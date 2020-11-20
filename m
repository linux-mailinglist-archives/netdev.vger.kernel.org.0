Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3005A2BB842
	for <lists+netdev@lfdr.de>; Fri, 20 Nov 2020 22:23:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728792AbgKTVWs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Nov 2020 16:22:48 -0500
Received: from mx2.suse.de ([195.135.220.15]:55394 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728398AbgKTVWs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 20 Nov 2020 16:22:48 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 646D9ACE0;
        Fri, 20 Nov 2020 21:22:44 +0000 (UTC)
Received: by lion.mk-sys.cz (Postfix, from userid 1000)
        id E071D603F9; Fri, 20 Nov 2020 22:22:43 +0100 (CET)
Date:   Fri, 20 Nov 2020 22:22:43 +0100
From:   Michal Kubecek <mkubecek@suse.cz>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     tanhuazhong <tanhuazhong@huawei.com>, davem@davemloft.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linuxarm@huawei.com, kuba@kernel.org
Subject: Re: [RFC net-next 1/2] ethtool: add support for controling the type
 of adaptive coalescing
Message-ID: <20201120212243.n7vnwo3ldzisr4hl@lion.mk-sys.cz>
References: <1605758050-21061-1-git-send-email-tanhuazhong@huawei.com>
 <1605758050-21061-2-git-send-email-tanhuazhong@huawei.com>
 <20201119041557.GR1804098@lunn.ch>
 <e43890d1-5596-3439-f4a7-d704c069a035@huawei.com>
 <20201119220203.fv2uluoeekyoyxrv@lion.mk-sys.cz>
 <8e9ba4c4-3ef4-f8bc-ab2f-92d695f62f12@huawei.com>
 <20201120072322.slrpgqydcupm63ep@lion.mk-sys.cz>
 <20201120133938.GG1804098@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201120133938.GG1804098@lunn.ch>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 20, 2020 at 02:39:38PM +0100, Andrew Lunn wrote:
> On Fri, Nov 20, 2020 at 08:23:22AM +0100, Michal Kubecek wrote:
> > On Fri, Nov 20, 2020 at 10:59:59AM +0800, tanhuazhong wrote:
> > > On 2020/11/20 6:02, Michal Kubecek wrote:
> > > > 
> > > > We could use a similar approach as struct ethtool_link_ksettings, e.g.
> > > > 
> > > > 	struct kernel_ethtool_coalesce {
> > > > 		struct ethtool_coalesce base;
> > > > 		/* new members which are not part of UAPI */
> > > > 	}
> > > > 
> > > > get_coalesce() and set_coalesce() would get pointer to struct
> > > > kernel_ethtool_coalesce and ioctl code would be modified to only touch
> > > > the base (legacy?) part.
> > > >  > While already changing the ops arguments, we could also add extack
> > > > pointer, either as a separate argument or as struct member (I slightly
> > > > prefer the former).
> > > 
> > > If changing the ops arguments, each driver who implement
> > > set_coalesce/get_coalesce of ethtool_ops need to be updated. Is it
> > > acceptable adding two new ops to get/set ext_coalesce info (like
> > > ecc31c60240b ("ethtool: Add link extended state") does)? Maybe i can send V2
> > > in this way, and then could you help to see which one is more suitable?
> > 
> > If it were just this one case, adding an extra op would be perfectly
> > fine. But from long term point of view, we should expect extending also
> > other existing ethtool requests and going this way for all of them would
> > essentially double the number of callbacks in struct ethtool_ops.
> 
> coccinella might be useful here.

I played with spatch a bit and it with the spatch and patch below, I got
only three build failures (with allmodconfig) that would need to be
addressed manually - these drivers call the set_coalesce() callback on
device initialization.

I also tried to make the structure argument const in ->set_coalesce()
but that was more tricky as adjusting other functions that the structure
is passed to required either running the spatch three times or repeating
the same two rules three times in the spatch (or perhaps there is
a cleaner way but I'm missing relevant knowledge of coccinelle). Then
there was one more problem in i40e driver which modifies the structure
before passing it on to its helpers. It could be worked around but I'm
not sure if constifying the argument is worth these extra complications.

Michal


semantic patch:
------------------------------------------------------------------------
@getc@
 identifier fn;
 identifier ops;
@@
 struct ethtool_ops ops = {
 ...
 ,.get_coalesce = fn,
 ...
 };
 

@@
identifier getc.fn;
identifier dev, data;
@@
-int fn(struct net_device *dev, struct ethtool_coalesce *data)
+int fn(struct net_device *dev, struct netlink_ext_ack *extack, struct kernel_ethtool_coalesce *data)
 {
+struct ethtool_coalesce *coal_base = &data->base;
 <...
-data
+coal_base
 ...>
 }


@setc@
 identifier fn;
 identifier ops;
@@
 struct ethtool_ops ops = {
 ...
 ,.set_coalesce = fn,
 ...
 };
 

@@
identifier setc.fn;
identifier dev, data;
@@
-int fn(struct net_device *dev, struct ethtool_coalesce *data)
+int fn(struct net_device *dev, struct netlink_ext_ack *extack, struct kernel_ethtool_coalesce *data)
 {
+struct ethtool_coalesce *coal_base = &data->base;
 <...
-data
+coal_base
 ...>
 }
------------------------------------------------------------------------

maual part:
------------------------------------------------------------------------
diff --git a/include/linux/ethtool.h b/include/linux/ethtool.h
index 6408b446051f..01d049d36120 100644
--- a/include/linux/ethtool.h
+++ b/include/linux/ethtool.h
@@ -15,6 +15,7 @@
 
 #include <linux/bitmap.h>
 #include <linux/compat.h>
+#include <linux/netlink.h>
 #include <uapi/linux/ethtool.h>
 
 #ifdef CONFIG_COMPAT
@@ -176,6 +177,10 @@ extern int
 __ethtool_get_link_ksettings(struct net_device *dev,
 			     struct ethtool_link_ksettings *link_ksettings);
 
+struct kernel_ethtool_coalesce {
+	struct ethtool_coalesce	base;
+};
+
 /**
  * ethtool_intersect_link_masks - Given two link masks, AND them together
  * @dst: first mask and where result is stored
@@ -436,8 +441,12 @@ struct ethtool_ops {
 			      struct ethtool_eeprom *, u8 *);
 	int	(*set_eeprom)(struct net_device *,
 			      struct ethtool_eeprom *, u8 *);
-	int	(*get_coalesce)(struct net_device *, struct ethtool_coalesce *);
-	int	(*set_coalesce)(struct net_device *, struct ethtool_coalesce *);
+	int	(*get_coalesce)(struct net_device *,
+				struct netlink_ext_ack *extack,
+				struct kernel_ethtool_coalesce *);
+	int	(*set_coalesce)(struct net_device *,
+				struct netlink_ext_ack *extack,
+				struct kernel_ethtool_coalesce *);
 	void	(*get_ringparam)(struct net_device *,
 				 struct ethtool_ringparam *);
 	int	(*set_ringparam)(struct net_device *,
diff --git a/net/ethtool/coalesce.c b/net/ethtool/coalesce.c
index 1d6bc132aa4d..6f64dad0202e 100644
--- a/net/ethtool/coalesce.c
+++ b/net/ethtool/coalesce.c
@@ -9,7 +9,7 @@ struct coalesce_req_info {
 
 struct coalesce_reply_data {
 	struct ethnl_reply_data		base;
-	struct ethtool_coalesce		coalesce;
+	struct kernel_ethtool_coalesce	coalesce;
 	u32				supported_params;
 };
 
@@ -61,6 +61,7 @@ static int coalesce_prepare_data(const struct ethnl_req_info *req_base,
 				 struct genl_info *info)
 {
 	struct coalesce_reply_data *data = COALESCE_REPDATA(reply_base);
+	struct netlink_ext_ack *extack = info ? info->extack : NULL;
 	struct net_device *dev = reply_base->dev;
 	int ret;
 
@@ -70,7 +71,7 @@ static int coalesce_prepare_data(const struct ethnl_req_info *req_base,
 	ret = ethnl_ops_begin(dev);
 	if (ret < 0)
 		return ret;
-	ret = dev->ethtool_ops->get_coalesce(dev, &data->coalesce);
+	ret = dev->ethtool_ops->get_coalesce(dev, extack, &data->coalesce);
 	ethnl_ops_complete(dev);
 
 	return ret;
@@ -124,53 +125,53 @@ static int coalesce_fill_reply(struct sk_buff *skb,
 			       const struct ethnl_reply_data *reply_base)
 {
 	const struct coalesce_reply_data *data = COALESCE_REPDATA(reply_base);
-	const struct ethtool_coalesce *coal = &data->coalesce;
+	const struct ethtool_coalesce *cbase = &data->coalesce.base;
 	u32 supported = data->supported_params;
 
 	if (coalesce_put_u32(skb, ETHTOOL_A_COALESCE_RX_USECS,
-			     coal->rx_coalesce_usecs, supported) ||
+			     cbase->rx_coalesce_usecs, supported) ||
 	    coalesce_put_u32(skb, ETHTOOL_A_COALESCE_RX_MAX_FRAMES,
-			     coal->rx_max_coalesced_frames, supported) ||
+			     cbase->rx_max_coalesced_frames, supported) ||
 	    coalesce_put_u32(skb, ETHTOOL_A_COALESCE_RX_USECS_IRQ,
-			     coal->rx_coalesce_usecs_irq, supported) ||
+			     cbase->rx_coalesce_usecs_irq, supported) ||
 	    coalesce_put_u32(skb, ETHTOOL_A_COALESCE_RX_MAX_FRAMES_IRQ,
-			     coal->rx_max_coalesced_frames_irq, supported) ||
+			     cbase->rx_max_coalesced_frames_irq, supported) ||
 	    coalesce_put_u32(skb, ETHTOOL_A_COALESCE_TX_USECS,
-			     coal->tx_coalesce_usecs, supported) ||
+			     cbase->tx_coalesce_usecs, supported) ||
 	    coalesce_put_u32(skb, ETHTOOL_A_COALESCE_TX_MAX_FRAMES,
-			     coal->tx_max_coalesced_frames, supported) ||
+			     cbase->tx_max_coalesced_frames, supported) ||
 	    coalesce_put_u32(skb, ETHTOOL_A_COALESCE_TX_USECS_IRQ,
-			     coal->tx_coalesce_usecs_irq, supported) ||
+			     cbase->tx_coalesce_usecs_irq, supported) ||
 	    coalesce_put_u32(skb, ETHTOOL_A_COALESCE_TX_MAX_FRAMES_IRQ,
-			     coal->tx_max_coalesced_frames_irq, supported) ||
+			     cbase->tx_max_coalesced_frames_irq, supported) ||
 	    coalesce_put_u32(skb, ETHTOOL_A_COALESCE_STATS_BLOCK_USECS,
-			     coal->stats_block_coalesce_usecs, supported) ||
+			     cbase->stats_block_coalesce_usecs, supported) ||
 	    coalesce_put_bool(skb, ETHTOOL_A_COALESCE_USE_ADAPTIVE_RX,
-			      coal->use_adaptive_rx_coalesce, supported) ||
+			      cbase->use_adaptive_rx_coalesce, supported) ||
 	    coalesce_put_bool(skb, ETHTOOL_A_COALESCE_USE_ADAPTIVE_TX,
-			      coal->use_adaptive_tx_coalesce, supported) ||
+			      cbase->use_adaptive_tx_coalesce, supported) ||
 	    coalesce_put_u32(skb, ETHTOOL_A_COALESCE_PKT_RATE_LOW,
-			     coal->pkt_rate_low, supported) ||
+			     cbase->pkt_rate_low, supported) ||
 	    coalesce_put_u32(skb, ETHTOOL_A_COALESCE_RX_USECS_LOW,
-			     coal->rx_coalesce_usecs_low, supported) ||
+			     cbase->rx_coalesce_usecs_low, supported) ||
 	    coalesce_put_u32(skb, ETHTOOL_A_COALESCE_RX_MAX_FRAMES_LOW,
-			     coal->rx_max_coalesced_frames_low, supported) ||
+			     cbase->rx_max_coalesced_frames_low, supported) ||
 	    coalesce_put_u32(skb, ETHTOOL_A_COALESCE_TX_USECS_LOW,
-			     coal->tx_coalesce_usecs_low, supported) ||
+			     cbase->tx_coalesce_usecs_low, supported) ||
 	    coalesce_put_u32(skb, ETHTOOL_A_COALESCE_TX_MAX_FRAMES_LOW,
-			     coal->tx_max_coalesced_frames_low, supported) ||
+			     cbase->tx_max_coalesced_frames_low, supported) ||
 	    coalesce_put_u32(skb, ETHTOOL_A_COALESCE_PKT_RATE_HIGH,
-			     coal->pkt_rate_high, supported) ||
+			     cbase->pkt_rate_high, supported) ||
 	    coalesce_put_u32(skb, ETHTOOL_A_COALESCE_RX_USECS_HIGH,
-			     coal->rx_coalesce_usecs_high, supported) ||
+			     cbase->rx_coalesce_usecs_high, supported) ||
 	    coalesce_put_u32(skb, ETHTOOL_A_COALESCE_RX_MAX_FRAMES_HIGH,
-			     coal->rx_max_coalesced_frames_high, supported) ||
+			     cbase->rx_max_coalesced_frames_high, supported) ||
 	    coalesce_put_u32(skb, ETHTOOL_A_COALESCE_TX_USECS_HIGH,
-			     coal->tx_coalesce_usecs_high, supported) ||
+			     cbase->tx_coalesce_usecs_high, supported) ||
 	    coalesce_put_u32(skb, ETHTOOL_A_COALESCE_TX_MAX_FRAMES_HIGH,
-			     coal->tx_max_coalesced_frames_high, supported) ||
+			     cbase->tx_max_coalesced_frames_high, supported) ||
 	    coalesce_put_u32(skb, ETHTOOL_A_COALESCE_RATE_SAMPLE_INTERVAL,
-			     coal->rate_sample_interval, supported))
+			     cbase->rate_sample_interval, supported))
 		return -EMSGSIZE;
 
 	return 0;
@@ -219,7 +220,8 @@ const struct nla_policy ethnl_coalesce_set_policy[] = {
 
 int ethnl_set_coalesce(struct sk_buff *skb, struct genl_info *info)
 {
-	struct ethtool_coalesce coalesce = {};
+	struct kernel_ethtool_coalesce coalesce = {};
+	struct ethtool_coalesce *coal_base = &coalesce.base;
 	struct ethnl_req_info req_info = {};
 	struct nlattr **tb = info->attrs;
 	const struct ethtool_ops *ops;
@@ -255,59 +257,59 @@ int ethnl_set_coalesce(struct sk_buff *skb, struct genl_info *info)
 	ret = ethnl_ops_begin(dev);
 	if (ret < 0)
 		goto out_rtnl;
-	ret = ops->get_coalesce(dev, &coalesce);
+	ret = ops->get_coalesce(dev, info->extack, &coalesce);
 	if (ret < 0)
 		goto out_ops;
 
-	ethnl_update_u32(&coalesce.rx_coalesce_usecs,
+	ethnl_update_u32(&coal_base->rx_coalesce_usecs,
 			 tb[ETHTOOL_A_COALESCE_RX_USECS], &mod);
-	ethnl_update_u32(&coalesce.rx_max_coalesced_frames,
+	ethnl_update_u32(&coal_base->rx_max_coalesced_frames,
 			 tb[ETHTOOL_A_COALESCE_RX_MAX_FRAMES], &mod);
-	ethnl_update_u32(&coalesce.rx_coalesce_usecs_irq,
+	ethnl_update_u32(&coal_base->rx_coalesce_usecs_irq,
 			 tb[ETHTOOL_A_COALESCE_RX_USECS_IRQ], &mod);
-	ethnl_update_u32(&coalesce.rx_max_coalesced_frames_irq,
+	ethnl_update_u32(&coal_base->rx_max_coalesced_frames_irq,
 			 tb[ETHTOOL_A_COALESCE_RX_MAX_FRAMES_IRQ], &mod);
-	ethnl_update_u32(&coalesce.tx_coalesce_usecs,
+	ethnl_update_u32(&coal_base->tx_coalesce_usecs,
 			 tb[ETHTOOL_A_COALESCE_TX_USECS], &mod);
-	ethnl_update_u32(&coalesce.tx_max_coalesced_frames,
+	ethnl_update_u32(&coal_base->tx_max_coalesced_frames,
 			 tb[ETHTOOL_A_COALESCE_TX_MAX_FRAMES], &mod);
-	ethnl_update_u32(&coalesce.tx_coalesce_usecs_irq,
+	ethnl_update_u32(&coal_base->tx_coalesce_usecs_irq,
 			 tb[ETHTOOL_A_COALESCE_TX_USECS_IRQ], &mod);
-	ethnl_update_u32(&coalesce.tx_max_coalesced_frames_irq,
+	ethnl_update_u32(&coal_base->tx_max_coalesced_frames_irq,
 			 tb[ETHTOOL_A_COALESCE_TX_MAX_FRAMES_IRQ], &mod);
-	ethnl_update_u32(&coalesce.stats_block_coalesce_usecs,
+	ethnl_update_u32(&coal_base->stats_block_coalesce_usecs,
 			 tb[ETHTOOL_A_COALESCE_STATS_BLOCK_USECS], &mod);
-	ethnl_update_bool32(&coalesce.use_adaptive_rx_coalesce,
+	ethnl_update_bool32(&coal_base->use_adaptive_rx_coalesce,
 			    tb[ETHTOOL_A_COALESCE_USE_ADAPTIVE_RX], &mod);
-	ethnl_update_bool32(&coalesce.use_adaptive_tx_coalesce,
+	ethnl_update_bool32(&coal_base->use_adaptive_tx_coalesce,
 			    tb[ETHTOOL_A_COALESCE_USE_ADAPTIVE_TX], &mod);
-	ethnl_update_u32(&coalesce.pkt_rate_low,
+	ethnl_update_u32(&coal_base->pkt_rate_low,
 			 tb[ETHTOOL_A_COALESCE_PKT_RATE_LOW], &mod);
-	ethnl_update_u32(&coalesce.rx_coalesce_usecs_low,
+	ethnl_update_u32(&coal_base->rx_coalesce_usecs_low,
 			 tb[ETHTOOL_A_COALESCE_RX_USECS_LOW], &mod);
-	ethnl_update_u32(&coalesce.rx_max_coalesced_frames_low,
+	ethnl_update_u32(&coal_base->rx_max_coalesced_frames_low,
 			 tb[ETHTOOL_A_COALESCE_RX_MAX_FRAMES_LOW], &mod);
-	ethnl_update_u32(&coalesce.tx_coalesce_usecs_low,
+	ethnl_update_u32(&coal_base->tx_coalesce_usecs_low,
 			 tb[ETHTOOL_A_COALESCE_TX_USECS_LOW], &mod);
-	ethnl_update_u32(&coalesce.tx_max_coalesced_frames_low,
+	ethnl_update_u32(&coal_base->tx_max_coalesced_frames_low,
 			 tb[ETHTOOL_A_COALESCE_TX_MAX_FRAMES_LOW], &mod);
-	ethnl_update_u32(&coalesce.pkt_rate_high,
+	ethnl_update_u32(&coal_base->pkt_rate_high,
 			 tb[ETHTOOL_A_COALESCE_PKT_RATE_HIGH], &mod);
-	ethnl_update_u32(&coalesce.rx_coalesce_usecs_high,
+	ethnl_update_u32(&coal_base->rx_coalesce_usecs_high,
 			 tb[ETHTOOL_A_COALESCE_RX_USECS_HIGH], &mod);
-	ethnl_update_u32(&coalesce.rx_max_coalesced_frames_high,
+	ethnl_update_u32(&coal_base->rx_max_coalesced_frames_high,
 			 tb[ETHTOOL_A_COALESCE_RX_MAX_FRAMES_HIGH], &mod);
-	ethnl_update_u32(&coalesce.tx_coalesce_usecs_high,
+	ethnl_update_u32(&coal_base->tx_coalesce_usecs_high,
 			 tb[ETHTOOL_A_COALESCE_TX_USECS_HIGH], &mod);
-	ethnl_update_u32(&coalesce.tx_max_coalesced_frames_high,
+	ethnl_update_u32(&coal_base->tx_max_coalesced_frames_high,
 			 tb[ETHTOOL_A_COALESCE_TX_MAX_FRAMES_HIGH], &mod);
-	ethnl_update_u32(&coalesce.rate_sample_interval,
+	ethnl_update_u32(&coal_base->rate_sample_interval,
 			 tb[ETHTOOL_A_COALESCE_RATE_SAMPLE_INTERVAL], &mod);
 	ret = 0;
 	if (!mod)
 		goto out_ops;
 
-	ret = dev->ethtool_ops->set_coalesce(dev, &coalesce);
+	ret = dev->ethtool_ops->set_coalesce(dev, info->extack, &coalesce);
 	if (ret < 0)
 		goto out_ops;
 	ethtool_notify(dev, ETHTOOL_MSG_COALESCE_NTF, NULL);
diff --git a/net/ethtool/ioctl.c b/net/ethtool/ioctl.c
index 771688e1b0da..cb378fd8fcae 100644
--- a/net/ethtool/ioctl.c
+++ b/net/ethtool/ioctl.c
@@ -1513,71 +1513,74 @@ static int ethtool_set_eeprom(struct net_device *dev, void __user *useraddr)
 static noinline_for_stack int ethtool_get_coalesce(struct net_device *dev,
 						   void __user *useraddr)
 {
-	struct ethtool_coalesce coalesce = { .cmd = ETHTOOL_GCOALESCE };
+	struct kernel_ethtool_coalesce coalesce = {
+		.base = { .cmd = ETHTOOL_GCOALESCE }
+	};
 	int ret;
 
 	if (!dev->ethtool_ops->get_coalesce)
 		return -EOPNOTSUPP;
 
-	ret = dev->ethtool_ops->get_coalesce(dev, &coalesce);
+	ret = dev->ethtool_ops->get_coalesce(dev, NULL, &coalesce);
 	if (ret)
 		return ret;
 
-	if (copy_to_user(useraddr, &coalesce, sizeof(coalesce)))
+	if (copy_to_user(useraddr, &coalesce.base, sizeof(coalesce.base)))
 		return -EFAULT;
 	return 0;
 }
 
 static bool
 ethtool_set_coalesce_supported(struct net_device *dev,
-			       struct ethtool_coalesce *coalesce)
+			       struct kernel_ethtool_coalesce *coalesce)
 {
 	u32 supported_params = dev->ethtool_ops->supported_coalesce_params;
+	const struct ethtool_coalesce *coal_base = &coalesce->base;
 	u32 nonzero_params = 0;
 
-	if (coalesce->rx_coalesce_usecs)
+	if (coal_base->rx_coalesce_usecs)
 		nonzero_params |= ETHTOOL_COALESCE_RX_USECS;
-	if (coalesce->rx_max_coalesced_frames)
+	if (coal_base->rx_max_coalesced_frames)
 		nonzero_params |= ETHTOOL_COALESCE_RX_MAX_FRAMES;
-	if (coalesce->rx_coalesce_usecs_irq)
+	if (coal_base->rx_coalesce_usecs_irq)
 		nonzero_params |= ETHTOOL_COALESCE_RX_USECS_IRQ;
-	if (coalesce->rx_max_coalesced_frames_irq)
+	if (coal_base->rx_max_coalesced_frames_irq)
 		nonzero_params |= ETHTOOL_COALESCE_RX_MAX_FRAMES_IRQ;
-	if (coalesce->tx_coalesce_usecs)
+	if (coal_base->tx_coalesce_usecs)
 		nonzero_params |= ETHTOOL_COALESCE_TX_USECS;
-	if (coalesce->tx_max_coalesced_frames)
+	if (coal_base->tx_max_coalesced_frames)
 		nonzero_params |= ETHTOOL_COALESCE_TX_MAX_FRAMES;
-	if (coalesce->tx_coalesce_usecs_irq)
+	if (coal_base->tx_coalesce_usecs_irq)
 		nonzero_params |= ETHTOOL_COALESCE_TX_USECS_IRQ;
-	if (coalesce->tx_max_coalesced_frames_irq)
+	if (coal_base->tx_max_coalesced_frames_irq)
 		nonzero_params |= ETHTOOL_COALESCE_TX_MAX_FRAMES_IRQ;
-	if (coalesce->stats_block_coalesce_usecs)
+	if (coal_base->stats_block_coalesce_usecs)
 		nonzero_params |= ETHTOOL_COALESCE_STATS_BLOCK_USECS;
-	if (coalesce->use_adaptive_rx_coalesce)
+	if (coal_base->use_adaptive_rx_coalesce)
 		nonzero_params |= ETHTOOL_COALESCE_USE_ADAPTIVE_RX;
-	if (coalesce->use_adaptive_tx_coalesce)
+	if (coal_base->use_adaptive_tx_coalesce)
 		nonzero_params |= ETHTOOL_COALESCE_USE_ADAPTIVE_TX;
-	if (coalesce->pkt_rate_low)
+	if (coal_base->pkt_rate_low)
 		nonzero_params |= ETHTOOL_COALESCE_PKT_RATE_LOW;
-	if (coalesce->rx_coalesce_usecs_low)
+	if (coal_base->rx_coalesce_usecs_low)
 		nonzero_params |= ETHTOOL_COALESCE_RX_USECS_LOW;
-	if (coalesce->rx_max_coalesced_frames_low)
+	if (coal_base->rx_max_coalesced_frames_low)
 		nonzero_params |= ETHTOOL_COALESCE_RX_MAX_FRAMES_LOW;
-	if (coalesce->tx_coalesce_usecs_low)
+	if (coal_base->tx_coalesce_usecs_low)
 		nonzero_params |= ETHTOOL_COALESCE_TX_USECS_LOW;
-	if (coalesce->tx_max_coalesced_frames_low)
+	if (coal_base->tx_max_coalesced_frames_low)
 		nonzero_params |= ETHTOOL_COALESCE_TX_MAX_FRAMES_LOW;
-	if (coalesce->pkt_rate_high)
+	if (coal_base->pkt_rate_high)
 		nonzero_params |= ETHTOOL_COALESCE_PKT_RATE_HIGH;
-	if (coalesce->rx_coalesce_usecs_high)
+	if (coal_base->rx_coalesce_usecs_high)
 		nonzero_params |= ETHTOOL_COALESCE_RX_USECS_HIGH;
-	if (coalesce->rx_max_coalesced_frames_high)
+	if (coal_base->rx_max_coalesced_frames_high)
 		nonzero_params |= ETHTOOL_COALESCE_RX_MAX_FRAMES_HIGH;
-	if (coalesce->tx_coalesce_usecs_high)
+	if (coal_base->tx_coalesce_usecs_high)
 		nonzero_params |= ETHTOOL_COALESCE_TX_USECS_HIGH;
-	if (coalesce->tx_max_coalesced_frames_high)
+	if (coal_base->tx_max_coalesced_frames_high)
 		nonzero_params |= ETHTOOL_COALESCE_TX_MAX_FRAMES_HIGH;
-	if (coalesce->rate_sample_interval)
+	if (coal_base->rate_sample_interval)
 		nonzero_params |= ETHTOOL_COALESCE_RATE_SAMPLE_INTERVAL;
 
 	return (supported_params & nonzero_params) == nonzero_params;
@@ -1586,19 +1589,22 @@ ethtool_set_coalesce_supported(struct net_device *dev,
 static noinline_for_stack int ethtool_set_coalesce(struct net_device *dev,
 						   void __user *useraddr)
 {
-	struct ethtool_coalesce coalesce;
+	struct kernel_ethtool_coalesce coalesce = {};
 	int ret;
 
-	if (!dev->ethtool_ops->set_coalesce)
+	if (!dev->ethtool_ops->get_coalesce || !dev->ethtool_ops->set_coalesce)
 		return -EOPNOTSUPP;
 
-	if (copy_from_user(&coalesce, useraddr, sizeof(coalesce)))
+	ret = dev->ethtool_ops->get_coalesce(dev, NULL, &coalesce);
+	if (ret)
+		return ret;
+	if (copy_from_user(&coalesce.base, useraddr, sizeof(coalesce.base)))
 		return -EFAULT;
 
 	if (!ethtool_set_coalesce_supported(dev, &coalesce))
 		return -EOPNOTSUPP;
 
-	ret = dev->ethtool_ops->set_coalesce(dev, &coalesce);
+	ret = dev->ethtool_ops->set_coalesce(dev, NULL, &coalesce);
 	if (!ret)
 		ethtool_notify(dev, ETHTOOL_MSG_COALESCE_NTF, NULL);
 	return ret;
@@ -2362,6 +2368,7 @@ ethtool_set_per_queue_coalesce(struct net_device *dev,
 	int i, ret = 0;
 	int n_queue;
 	struct ethtool_coalesce *backup = NULL, *tmp = NULL;
+	struct kernel_ethtool_coalesce coalesce = {};
 	DECLARE_BITMAP(queue_mask, MAX_NUM_QUEUE);
 
 	if ((!dev->ethtool_ops->set_per_queue_coalesce) ||
@@ -2377,15 +2384,14 @@ ethtool_set_per_queue_coalesce(struct net_device *dev,
 		return -ENOMEM;
 
 	for_each_set_bit(bit, queue_mask, MAX_NUM_QUEUE) {
-		struct ethtool_coalesce coalesce;
-
 		ret = dev->ethtool_ops->get_per_queue_coalesce(dev, bit, tmp);
 		if (ret != 0)
 			goto roll_back;
 
 		tmp++;
 
-		if (copy_from_user(&coalesce, useraddr, sizeof(coalesce))) {
+		if (copy_from_user(&coalesce.base, useraddr,
+				   sizeof(coalesce.base))) {
 			ret = -EFAULT;
 			goto roll_back;
 		}
@@ -2395,7 +2401,8 @@ ethtool_set_per_queue_coalesce(struct net_device *dev,
 			goto roll_back;
 		}
 
-		ret = dev->ethtool_ops->set_per_queue_coalesce(dev, bit, &coalesce);
+		ret = dev->ethtool_ops->set_per_queue_coalesce(dev, bit,
+							       &coalesce.base);
 		if (ret != 0)
 			goto roll_back;
 
------------------------------------------------------------------------
