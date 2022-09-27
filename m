Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8497E5EC886
	for <lists+netdev@lfdr.de>; Tue, 27 Sep 2022 17:49:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232450AbiI0Pt3 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 27 Sep 2022 11:49:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232952AbiI0Psk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Sep 2022 11:48:40 -0400
Received: from us-smtp-delivery-44.mimecast.com (us-smtp-delivery-44.mimecast.com [207.211.30.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E22CD01E4
        for <netdev@vger.kernel.org>; Tue, 27 Sep 2022 08:46:20 -0700 (PDT)
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-645-I8MQx0xtNPCdNbwdTB4eUg-1; Tue, 27 Sep 2022 11:46:14 -0400
X-MC-Unique: I8MQx0xtNPCdNbwdTB4eUg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 50D632999B24;
        Tue, 27 Sep 2022 15:46:13 +0000 (UTC)
Received: from hog.localdomain (unknown [10.39.195.84])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 442612166B26;
        Tue, 27 Sep 2022 15:46:12 +0000 (UTC)
From:   Sabrina Dubroca <sd@queasysnail.net>
To:     netdev@vger.kernel.org
Cc:     steffen.klassert@secunet.com, Sabrina Dubroca <sd@queasysnail.net>
Subject: [PATCH ipsec-next 5/6] xfrm: ipcomp: add extack to ipcomp{4,6}_init_state
Date:   Tue, 27 Sep 2022 17:45:33 +0200
Message-Id: <6ff58e0af215169fdc654fe45e89b78eec2906a4.1664287440.git.sd@queasysnail.net>
In-Reply-To: <cover.1664287440.git.sd@queasysnail.net>
References: <cover.1664287440.git.sd@queasysnail.net>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: queasysnail.net
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset=WINDOWS-1252; x-default=true
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

And the shared helper ipcomp_init_state.

Signed-off-by: Sabrina Dubroca <sd@queasysnail.net>
---
 include/net/ipcomp.h   |  2 +-
 net/ipv4/ipcomp.c      |  7 +++++--
 net/ipv6/ipcomp6.c     |  7 +++++--
 net/xfrm/xfrm_ipcomp.c | 10 +++++++---
 4 files changed, 18 insertions(+), 8 deletions(-)

diff --git a/include/net/ipcomp.h b/include/net/ipcomp.h
index c31108295079..8660a2a6d1fc 100644
--- a/include/net/ipcomp.h
+++ b/include/net/ipcomp.h
@@ -22,7 +22,7 @@ struct xfrm_state;
 int ipcomp_input(struct xfrm_state *x, struct sk_buff *skb);
 int ipcomp_output(struct xfrm_state *x, struct sk_buff *skb);
 void ipcomp_destroy(struct xfrm_state *x);
-int ipcomp_init_state(struct xfrm_state *x);
+int ipcomp_init_state(struct xfrm_state *x, struct netlink_ext_ack *extack);
 
 static inline struct ip_comp_hdr *ip_comp_hdr(const struct sk_buff *skb)
 {
diff --git a/net/ipv4/ipcomp.c b/net/ipv4/ipcomp.c
index 230d1120874f..5a4fb2539b08 100644
--- a/net/ipv4/ipcomp.c
+++ b/net/ipv4/ipcomp.c
@@ -130,17 +130,20 @@ static int ipcomp4_init_state(struct xfrm_state *x,
 		x->props.header_len += sizeof(struct iphdr);
 		break;
 	default:
+		NL_SET_ERR_MSG(extack, "Unsupported XFRM mode for IPcomp");
 		goto out;
 	}
 
-	err = ipcomp_init_state(x);
+	err = ipcomp_init_state(x, extack);
 	if (err)
 		goto out;
 
 	if (x->props.mode == XFRM_MODE_TUNNEL) {
 		err = ipcomp_tunnel_attach(x);
-		if (err)
+		if (err) {
+			NL_SET_ERR_MSG(extack, "Kernel error: failed to initialize the associated state");
 			goto out;
+		}
 	}
 
 	err = 0;
diff --git a/net/ipv6/ipcomp6.c b/net/ipv6/ipcomp6.c
index 7e47009739e9..72d4858dec18 100644
--- a/net/ipv6/ipcomp6.c
+++ b/net/ipv6/ipcomp6.c
@@ -149,17 +149,20 @@ static int ipcomp6_init_state(struct xfrm_state *x,
 		x->props.header_len += sizeof(struct ipv6hdr);
 		break;
 	default:
+		NL_SET_ERR_MSG(extack, "Unsupported XFRM mode for IPcomp");
 		goto out;
 	}
 
-	err = ipcomp_init_state(x);
+	err = ipcomp_init_state(x, extack);
 	if (err)
 		goto out;
 
 	if (x->props.mode == XFRM_MODE_TUNNEL) {
 		err = ipcomp6_tunnel_attach(x);
-		if (err)
+		if (err) {
+			NL_SET_ERR_MSG(extack, "Kernel error: failed to initialize the associated state");
 			goto out;
+		}
 	}
 
 	err = 0;
diff --git a/net/xfrm/xfrm_ipcomp.c b/net/xfrm/xfrm_ipcomp.c
index cb40ff0ff28d..656045a87606 100644
--- a/net/xfrm/xfrm_ipcomp.c
+++ b/net/xfrm/xfrm_ipcomp.c
@@ -325,18 +325,22 @@ void ipcomp_destroy(struct xfrm_state *x)
 }
 EXPORT_SYMBOL_GPL(ipcomp_destroy);
 
-int ipcomp_init_state(struct xfrm_state *x)
+int ipcomp_init_state(struct xfrm_state *x, struct netlink_ext_ack *extack)
 {
 	int err;
 	struct ipcomp_data *ipcd;
 	struct xfrm_algo_desc *calg_desc;
 
 	err = -EINVAL;
-	if (!x->calg)
+	if (!x->calg) {
+		NL_SET_ERR_MSG(extack, "Missing required compression algorithm");
 		goto out;
+	}
 
-	if (x->encap)
+	if (x->encap) {
+		NL_SET_ERR_MSG(extack, "IPComp is not compatible with encapsulation");
 		goto out;
+	}
 
 	err = -ENOMEM;
 	ipcd = kzalloc(sizeof(*ipcd), GFP_KERNEL);
-- 
2.37.3

