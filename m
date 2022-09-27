Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E47225EC887
	for <lists+netdev@lfdr.de>; Tue, 27 Sep 2022 17:49:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229687AbiI0Ptn convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 27 Sep 2022 11:49:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229838AbiI0Psv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Sep 2022 11:48:51 -0400
Received: from us-smtp-delivery-44.mimecast.com (us-smtp-delivery-44.mimecast.com [205.139.111.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 781FF1CB1C
        for <netdev@vger.kernel.org>; Tue, 27 Sep 2022 08:46:44 -0700 (PDT)
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-264-QkyZZLDtOb2udAMuJk11kA-1; Tue, 27 Sep 2022 11:46:12 -0400
X-MC-Unique: QkyZZLDtOb2udAMuJk11kA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id DBA693C14858;
        Tue, 27 Sep 2022 15:46:11 +0000 (UTC)
Received: from hog.localdomain (unknown [10.39.195.84])
        by smtp.corp.redhat.com (Postfix) with ESMTP id EC69D2166B26;
        Tue, 27 Sep 2022 15:46:10 +0000 (UTC)
From:   Sabrina Dubroca <sd@queasysnail.net>
To:     netdev@vger.kernel.org
Cc:     steffen.klassert@secunet.com, Sabrina Dubroca <sd@queasysnail.net>
Subject: [PATCH ipsec-next 4/6] xfrm: tunnel: add extack to ipip_init_state, xfrm6_tunnel_init_state
Date:   Tue, 27 Sep 2022 17:45:32 +0200
Message-Id: <ea0bbbd2fe9586c3f0f2efc265b19a9939a1ab16.1664287440.git.sd@queasysnail.net>
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

Signed-off-by: Sabrina Dubroca <sd@queasysnail.net>
---
 net/ipv4/xfrm4_tunnel.c | 8 ++++++--
 net/ipv6/xfrm6_tunnel.c | 8 ++++++--
 2 files changed, 12 insertions(+), 4 deletions(-)

diff --git a/net/ipv4/xfrm4_tunnel.c b/net/ipv4/xfrm4_tunnel.c
index 08826e0d7962..8489fa106583 100644
--- a/net/ipv4/xfrm4_tunnel.c
+++ b/net/ipv4/xfrm4_tunnel.c
@@ -24,11 +24,15 @@ static int ipip_xfrm_rcv(struct xfrm_state *x, struct sk_buff *skb)
 
 static int ipip_init_state(struct xfrm_state *x, struct netlink_ext_ack *extack)
 {
-	if (x->props.mode != XFRM_MODE_TUNNEL)
+	if (x->props.mode != XFRM_MODE_TUNNEL) {
+		NL_SET_ERR_MSG(extack, "IPv4 tunnel can only be used with tunnel mode");
 		return -EINVAL;
+	}
 
-	if (x->encap)
+	if (x->encap) {
+		NL_SET_ERR_MSG(extack, "IPv4 tunnel is not compatible with encapsulation");
 		return -EINVAL;
+	}
 
 	x->props.header_len = sizeof(struct iphdr);
 
diff --git a/net/ipv6/xfrm6_tunnel.c b/net/ipv6/xfrm6_tunnel.c
index dda44b0671ac..1323f2f6928e 100644
--- a/net/ipv6/xfrm6_tunnel.c
+++ b/net/ipv6/xfrm6_tunnel.c
@@ -272,11 +272,15 @@ static int xfrm6_tunnel_err(struct sk_buff *skb, struct inet6_skb_parm *opt,
 
 static int xfrm6_tunnel_init_state(struct xfrm_state *x, struct netlink_ext_ack *extack)
 {
-	if (x->props.mode != XFRM_MODE_TUNNEL)
+	if (x->props.mode != XFRM_MODE_TUNNEL) {
+		NL_SET_ERR_MSG(extack, "IPv6 tunnel can only be used with tunnel mode");
 		return -EINVAL;
+	}
 
-	if (x->encap)
+	if (x->encap) {
+		NL_SET_ERR_MSG(extack, "IPv6 tunnel is not compatible with encapsulation");
 		return -EINVAL;
+	}
 
 	x->props.header_len = sizeof(struct ipv6hdr);
 
-- 
2.37.3

