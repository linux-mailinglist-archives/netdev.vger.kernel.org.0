Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6D0455B8DCD
	for <lists+netdev@lfdr.de>; Wed, 14 Sep 2022 19:05:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229541AbiINRFD convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 14 Sep 2022 13:05:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229614AbiINRE5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Sep 2022 13:04:57 -0400
Received: from us-smtp-delivery-44.mimecast.com (us-smtp-delivery-44.mimecast.com [207.211.30.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0EAAF1ADB6
        for <netdev@vger.kernel.org>; Wed, 14 Sep 2022 10:04:51 -0700 (PDT)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-425-7EX0NfirMN6FKTUBRhA4sQ-1; Wed, 14 Sep 2022 13:04:47 -0400
X-MC-Unique: 7EX0NfirMN6FKTUBRhA4sQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D1233858F13;
        Wed, 14 Sep 2022 17:04:46 +0000 (UTC)
Received: from hog.localdomain (unknown [10.40.195.234])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D138A1121314;
        Wed, 14 Sep 2022 17:04:45 +0000 (UTC)
From:   Sabrina Dubroca <sd@queasysnail.net>
To:     netdev@vger.kernel.org
Cc:     steffen.klassert@secunet.com, Sabrina Dubroca <sd@queasysnail.net>
Subject: [PATCH ipsec-next 4/7] xfrm: add extack support to xfrm_dev_state_add
Date:   Wed, 14 Sep 2022 19:04:03 +0200
Message-Id: <ef2e68804d3f5f7e5c0c072db83a75babde84ae2.1663103634.git.sd@queasysnail.net>
In-Reply-To: <cover.1663103634.git.sd@queasysnail.net>
References: <cover.1663103634.git.sd@queasysnail.net>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: queasysnail.net
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset=WINDOWS-1252; x-default=true
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Signed-off-by: Sabrina Dubroca <sd@queasysnail.net>
---
 include/net/xfrm.h     |  5 +++--
 net/xfrm/xfrm_device.c | 20 +++++++++++++++-----
 net/xfrm/xfrm_user.c   |  8 +++++---
 3 files changed, 23 insertions(+), 10 deletions(-)

diff --git a/include/net/xfrm.h b/include/net/xfrm.h
index 28b988577ed2..9c1cccf85f12 100644
--- a/include/net/xfrm.h
+++ b/include/net/xfrm.h
@@ -1886,7 +1886,8 @@ void xfrm_dev_resume(struct sk_buff *skb);
 void xfrm_dev_backlog(struct softnet_data *sd);
 struct sk_buff *validate_xmit_xfrm(struct sk_buff *skb, netdev_features_t features, bool *again);
 int xfrm_dev_state_add(struct net *net, struct xfrm_state *x,
-		       struct xfrm_user_offload *xuo);
+		       struct xfrm_user_offload *xuo,
+		       struct netlink_ext_ack *extack);
 bool xfrm_dev_offload_ok(struct sk_buff *skb, struct xfrm_state *x);
 
 static inline void xfrm_dev_state_advance_esn(struct xfrm_state *x)
@@ -1949,7 +1950,7 @@ static inline struct sk_buff *validate_xmit_xfrm(struct sk_buff *skb, netdev_fea
 	return skb;
 }
 
-static inline int xfrm_dev_state_add(struct net *net, struct xfrm_state *x, struct xfrm_user_offload *xuo)
+static inline int xfrm_dev_state_add(struct net *net, struct xfrm_state *x, struct xfrm_user_offload *xuo, struct netlink_ext_ack *extack)
 {
 	return 0;
 }
diff --git a/net/xfrm/xfrm_device.c b/net/xfrm/xfrm_device.c
index 637ca8838436..5f5aafd418af 100644
--- a/net/xfrm/xfrm_device.c
+++ b/net/xfrm/xfrm_device.c
@@ -207,7 +207,8 @@ struct sk_buff *validate_xmit_xfrm(struct sk_buff *skb, netdev_features_t featur
 EXPORT_SYMBOL_GPL(validate_xmit_xfrm);
 
 int xfrm_dev_state_add(struct net *net, struct xfrm_state *x,
-		       struct xfrm_user_offload *xuo)
+		       struct xfrm_user_offload *xuo,
+		       struct netlink_ext_ack *extack)
 {
 	int err;
 	struct dst_entry *dst;
@@ -216,15 +217,21 @@ int xfrm_dev_state_add(struct net *net, struct xfrm_state *x,
 	xfrm_address_t *saddr;
 	xfrm_address_t *daddr;
 
-	if (!x->type_offload)
+	if (!x->type_offload) {
+		NL_SET_ERR_MSG(extack, "Type doesn't support offload");
 		return -EINVAL;
+	}
 
 	/* We don't yet support UDP encapsulation and TFC padding. */
-	if (x->encap || x->tfcpad)
+	if (x->encap || x->tfcpad) {
+		NL_SET_ERR_MSG(extack, "Encapsulation and TFC padding can't be offloaded");
 		return -EINVAL;
+	}
 
-	if (xuo->flags & ~(XFRM_OFFLOAD_IPV6 | XFRM_OFFLOAD_INBOUND))
+	if (xuo->flags & ~(XFRM_OFFLOAD_IPV6 | XFRM_OFFLOAD_INBOUND)) {
+		NL_SET_ERR_MSG(extack, "Unrecognized flags in offload request");
 		return -EINVAL;
+	}
 
 	dev = dev_get_by_index(net, xuo->ifindex);
 	if (!dev) {
@@ -256,6 +263,7 @@ int xfrm_dev_state_add(struct net *net, struct xfrm_state *x,
 
 	if (x->props.flags & XFRM_STATE_ESN &&
 	    !dev->xfrmdev_ops->xdo_dev_state_advance_esn) {
+		NL_SET_ERR_MSG(extack, "Device doesn't support offload with ESN");
 		xso->dev = NULL;
 		dev_put(dev);
 		return -EINVAL;
@@ -277,8 +285,10 @@ int xfrm_dev_state_add(struct net *net, struct xfrm_state *x,
 		xso->real_dev = NULL;
 		netdev_put(dev, &xso->dev_tracker);
 
-		if (err != -EOPNOTSUPP)
+		if (err != -EOPNOTSUPP) {
+			NL_SET_ERR_MSG(extack, "Device failed to offload this state");
 			return err;
+		}
 	}
 
 	return 0;
diff --git a/net/xfrm/xfrm_user.c b/net/xfrm/xfrm_user.c
index 3c150e1f8a2a..c56b9442dffe 100644
--- a/net/xfrm/xfrm_user.c
+++ b/net/xfrm/xfrm_user.c
@@ -652,7 +652,8 @@ static void xfrm_smark_init(struct nlattr **attrs, struct xfrm_mark *m)
 static struct xfrm_state *xfrm_state_construct(struct net *net,
 					       struct xfrm_usersa_info *p,
 					       struct nlattr **attrs,
-					       int *errp)
+					       int *errp,
+					       struct netlink_ext_ack *extack)
 {
 	struct xfrm_state *x = xfrm_state_alloc(net);
 	int err = -ENOMEM;
@@ -735,7 +736,8 @@ static struct xfrm_state *xfrm_state_construct(struct net *net,
 	/* configure the hardware if offload is requested */
 	if (attrs[XFRMA_OFFLOAD_DEV]) {
 		err = xfrm_dev_state_add(net, x,
-					 nla_data(attrs[XFRMA_OFFLOAD_DEV]));
+					 nla_data(attrs[XFRMA_OFFLOAD_DEV]),
+					 extack);
 		if (err)
 			goto error;
 	}
@@ -763,7 +765,7 @@ static int xfrm_add_sa(struct sk_buff *skb, struct nlmsghdr *nlh,
 	if (err)
 		return err;
 
-	x = xfrm_state_construct(net, p, attrs, &err);
+	x = xfrm_state_construct(net, p, attrs, &err, extack);
 	if (!x)
 		return err;
 
-- 
2.37.3

