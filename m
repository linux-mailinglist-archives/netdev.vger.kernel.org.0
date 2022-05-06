Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B17C551CF1C
	for <lists+netdev@lfdr.de>; Fri,  6 May 2022 04:52:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1388375AbiEFCzb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 May 2022 22:55:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1388365AbiEFCza (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 May 2022 22:55:30 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0AAA65E16D
        for <netdev@vger.kernel.org>; Thu,  5 May 2022 19:51:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AFF17B832C0
        for <netdev@vger.kernel.org>; Fri,  6 May 2022 02:51:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15E99C385B2;
        Fri,  6 May 2022 02:51:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651805505;
        bh=/oum6KmoWIC9t6xsWgbOdnEtnG7kQk6EPaQLgse+Y/0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dV38/aSZodSRp8VOhnFACIVdinRcv3mf70HC084rLMNVpVA/5syW+aivsL9WLr6N2
         FQPKqSmXB+nV2Xu5Ik0aD4KkkehiRZrnmNsEatDlJ3EPPhDLXcdMBdamMM2jPMbSqf
         ZHmnJF41QHc3xLucsEYgVxS1Zg42hjUDlDR4G5RdtTJZCU48FFwI2RokF8pR+y2iEb
         2JxjAalB30sf4rpU/QrOOrhzooS/m466UPJhOksCaJ/KRYLcsAalfQKbMUmtqbnS1j
         1Buyeqw/HKKr/VdQxxPz2nlhzg7ztTGdR2bFAiwRsxFMBzyVO+4OtRCQW46IJdipXM
         cTJI1znmhBlJQ==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        alexander.duyck@gmail.com, stephen@networkplumber.org,
        Jakub Kicinski <kuba@kernel.org>, petrm@nvidia.com
Subject: [PATCH net-next 2/4] net: don't allow user space to lift the device limits
Date:   Thu,  5 May 2022 19:51:32 -0700
Message-Id: <20220506025134.794537-3-kuba@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220506025134.794537-1-kuba@kernel.org>
References: <20220506025134.794537-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Up until commit 46e6b992c250 ("rtnetlink: allow GSO maximums to
be set on device creation") the gso_max_segs and gso_max_size
of a device were not controlled from user space.

The quoted commit added the ability to control them because of
the following setup:

 netns A  |  netns B
     veth<->veth   eth0

If eth0 has TSO limitations and user wants to efficiently forward
traffic between eth0 and the veths they should copy the TSO
limitations of eth0 onto the veths. This would happen automatically
for macvlans or ipvlan but veth users are not so lucky (given the
loose coupling).

Unfortunately the commit in question allowed users to also override
the limits on real HW devices.

It may be useful to control the max GSO size and someone may be using
that ability (not that I know of any user), so create a separate set
of knobs to reliably record the TSO limitations. Validate the user
requests.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
CC: petrm@nvidia.com
---
 include/linux/netdevice.h |  9 +++++++++
 net/core/dev.c            | 35 +++++++++++++++++++++++++++++++++++
 net/core/rtnetlink.c      |  4 ++--
 3 files changed, 46 insertions(+), 2 deletions(-)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 006bb5c0e413..e12f7de6d6ae 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -1917,8 +1917,10 @@ enum netdev_ml_priv_type {
  *	@rtnl_link_ops:	Rtnl_link_ops
  *
  *	@gso_max_size:	Maximum size of generic segmentation offload
+ *	@tso_max_size:	Device (as in HW) limit on the max TSO request size
  *	@gso_max_segs:	Maximum number of segments that can be passed to the
  *			NIC for GSO
+ *	@tso_max_segs:	Device (as in HW) limit on the max TSO segment count
  *
  *	@dcbnl_ops:	Data Center Bridging netlink ops
  *	@num_tc:	Number of traffic classes in the net device
@@ -2262,8 +2264,13 @@ struct net_device {
 	/* for setting kernel sock attribute on TCP connection setup */
 #define GSO_MAX_SIZE		65536
 	unsigned int		gso_max_size;
+#define TSO_LEGACY_MAX_SIZE	65536
+#define TSO_MAX_SIZE		UINT_MAX
+	unsigned int		tso_max_size;
 #define GSO_MAX_SEGS		65535
 	u16			gso_max_segs;
+#define TSO_MAX_SEGS		U16_MAX
+	u16			tso_max_segs;
 
 #ifdef CONFIG_DCB
 	const struct dcbnl_rtnl_ops *dcbnl_ops;
@@ -4895,6 +4902,8 @@ static inline void netif_set_gro_max_size(struct net_device *dev,
 	WRITE_ONCE(dev->gro_max_size, size);
 }
 
+void netif_set_tso_max_size(struct net_device *dev, unsigned int size);
+void netif_set_tso_max_segs(struct net_device *dev, unsigned int segs);
 void netif_inherit_tso_max(struct net_device *to,
 			   const struct net_device *from);
 
diff --git a/net/core/dev.c b/net/core/dev.c
index eef1d19b130f..6ae085b11373 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -2992,6 +2992,39 @@ int netif_set_real_num_queues(struct net_device *dev,
 }
 EXPORT_SYMBOL(netif_set_real_num_queues);
 
+/**
+ * netif_set_tso_max_size() - set the max size of TSO frames supported
+ * @dev:	netdev to update
+ * @size:	max skb->len of a TSO frame
+ *
+ * Set the limit on the size of TSO super-frames the device can handle.
+ * Unless explicitly set the stack will assume the value of %GSO_MAX_SIZE.
+ */
+void netif_set_tso_max_size(struct net_device *dev, unsigned int size)
+{
+	dev->tso_max_size = size;
+	if (size < READ_ONCE(dev->gso_max_size))
+		netif_set_gso_max_size(dev, size);
+}
+EXPORT_SYMBOL(netif_set_tso_max_size);
+
+/**
+ * netif_set_tso_max_segs() - set the max number of segs supported for TSO
+ * @dev:	netdev to update
+ * @segs:	max number of TCP segments
+ *
+ * Set the limit on the number of TCP segments the device can generate from
+ * a single TSO super-frame.
+ * Unless explicitly set the stack will assume the value of %GSO_MAX_SEGS.
+ */
+void netif_set_tso_max_segs(struct net_device *dev, unsigned int segs)
+{
+	dev->tso_max_segs = segs;
+	if (segs < READ_ONCE(dev->gso_max_segs))
+		netif_set_gso_max_segs(dev, segs);
+}
+EXPORT_SYMBOL(netif_set_tso_max_segs);
+
 /**
  * netif_inherit_tso_max() - copy all TSO limits from a lower device to an upper
  * @to:		netdev to update
@@ -10572,6 +10605,8 @@ struct net_device *alloc_netdev_mqs(int sizeof_priv, const char *name,
 	dev->gso_max_size = GSO_MAX_SIZE;
 	dev->gso_max_segs = GSO_MAX_SEGS;
 	dev->gro_max_size = GRO_MAX_SIZE;
+	dev->tso_max_size = TSO_LEGACY_MAX_SIZE;
+	dev->tso_max_segs = TSO_MAX_SEGS;
 	dev->upper_level = 1;
 	dev->lower_level = 1;
 #ifdef CONFIG_LOCKDEP
diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c
index eea5ed09e1bb..e6d4b9272995 100644
--- a/net/core/rtnetlink.c
+++ b/net/core/rtnetlink.c
@@ -2803,7 +2803,7 @@ static int do_setlink(const struct sk_buff *skb,
 	if (tb[IFLA_GSO_MAX_SIZE]) {
 		u32 max_size = nla_get_u32(tb[IFLA_GSO_MAX_SIZE]);
 
-		if (max_size > GSO_MAX_SIZE) {
+		if (max_size > GSO_MAX_SIZE || max_size > dev->tso_max_size) {
 			err = -EINVAL;
 			goto errout;
 		}
@@ -2817,7 +2817,7 @@ static int do_setlink(const struct sk_buff *skb,
 	if (tb[IFLA_GSO_MAX_SEGS]) {
 		u32 max_segs = nla_get_u32(tb[IFLA_GSO_MAX_SEGS]);
 
-		if (max_segs > GSO_MAX_SEGS) {
+		if (max_segs > GSO_MAX_SEGS || max_segs > dev->tso_max_segs) {
 			err = -EINVAL;
 			goto errout;
 		}
-- 
2.34.1

