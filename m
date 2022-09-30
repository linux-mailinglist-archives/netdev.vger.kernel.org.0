Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 71ED05F0590
	for <lists+netdev@lfdr.de>; Fri, 30 Sep 2022 09:15:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231158AbiI3HPr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Sep 2022 03:15:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231156AbiI3HPp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Sep 2022 03:15:45 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F299213746A;
        Fri, 30 Sep 2022 00:15:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1664522142; x=1696058142;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=nBnk2H1ZFAJdL54aE/crKqQH3+vyJO5hi81g9RggVEU=;
  b=M5BZuE/QpIIMZCYTu3wbbjoR3Tkfpl7VoKeTqrZ3cY2r4GhrWBfxnPvT
   Wt1Uv/1WRH+9q4Filmc8uiPnULgVm9eVRDWgB4KjnCCQ1a2ioKGgmH66T
   oWjRvYBFIOWD8jQF1L5gs/EgE50216xh6fB3C4mNMMEnmoxFXm81Vg0ph
   8xKLc2Y9bBncifOl8oRl6jZssFRyNo+RRnjDu8EBO7s+oHwOSx44bR/Il
   DFC0kMc3dfq/bHziFl+Ck2Itq6laXy57ZImpgZQvpO0A94h/3QFiG6dBf
   x7zas0nFrSp8A4Mc99Gy6Kbw92Fj9UknPA5n8lTrlcMXNTbZkF91m2621
   w==;
X-IronPort-AV: E=Sophos;i="5.93,357,1654585200"; 
   d="scan'208";a="182751300"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 30 Sep 2022 00:15:41 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Fri, 30 Sep 2022 00:15:39 -0700
Received: from localhost (10.10.115.15) by chn-vm-ex03.mchp-main.com
 (10.10.85.151) with Microsoft SMTP Server id 15.1.2507.12 via Frontend
 Transport; Fri, 30 Sep 2022 00:15:39 -0700
Date:   Fri, 30 Sep 2022 09:20:08 +0200
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     Nathan Huckleberry <nhuck@google.com>
CC:     Dan Carpenter <error27@gmail.com>, <llvm@lists.linux.dev>,
        <UNGLinuxDriver@microchip.com>,
        "David S. Miller" <davem@davemloft.net>,
        "Eric Dumazet" <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Tom Rix <trix@redhat.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] net: lan966x: Fix return type of lan966x_port_xmit
Message-ID: <20220930072008.jhu2wj7tqpa3nfud@soft-dev3-1.localhost>
References: <20220929182704.64438-1-nhuck@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <20220929182704.64438-1-nhuck@google.com>
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The 09/29/2022 11:27, Nathan Huckleberry wrote:

Hi Nathan,

> 
> The ndo_start_xmit field in net_device_ops is expected to be of type
> netdev_tx_t (*ndo_start_xmit)(struct sk_buff *skb, struct net_device *dev).
> 
> The mismatched return type breaks forward edge kCFI since the underlying
> function definition does not match the function hook definition.
> 
> The return type of lan966x_port_xmit should be changed from int to
> netdev_tx_t.
> 
> Reported-by: Dan Carpenter <error27@gmail.com>
> Link: https://github.com/ClangBuiltLinux/linux/issues/1703
> Cc: llvm@lists.linux.dev
> Signed-off-by: Nathan Huckleberry <nhuck@google.com>

It looks pretty good.
If we change the return type of lan966x_port_xmit, can we change also the
return type of the functions lan966x_fdma_xmit and
lan966x_port_ifh_xmit?
And then also make sure to return NETDEV_TX_BUSY in case
lan966x_ptp_txtstamp_request fails and not the error code?

I have a diff below:
---
diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_fdma.c b/drivers/net/ethernet/microchip/lan966x/lan966x_fdma.c
index 7e4061c854f0e..148920bb74e08 100644
--- a/drivers/net/ethernet/microchip/lan966x/lan966x_fdma.c
+++ b/drivers/net/ethernet/microchip/lan966x/lan966x_fdma.c
@@ -558,7 +558,8 @@ static int lan966x_fdma_get_next_dcb(struct lan966x_tx *tx)
        return -1;
 }

-int lan966x_fdma_xmit(struct sk_buff *skb, __be32 *ifh, struct net_device *dev)
+netdev_tx_t lan966x_fdma_xmit(struct sk_buff *skb, __be32 *ifh,
+                             struct net_device *dev)
 {
        struct lan966x_port *port = netdev_priv(dev);
        struct lan966x *lan966x = port->lan966x;
diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_main.c b/drivers/net/ethernet/microchip/lan966x/lan966x_main.c
index b98d37c76edbc..4b471a1562e29 100644
--- a/drivers/net/ethernet/microchip/lan966x/lan966x_main.c
+++ b/drivers/net/ethernet/microchip/lan966x/lan966x_main.c
@@ -219,9 +219,9 @@ static int lan966x_port_inj_ready(struct lan966x *lan966x, u8 grp)
                                         READL_SLEEP_US, READL_TIMEOUT_US);
 }

-static int lan966x_port_ifh_xmit(struct sk_buff *skb,
-                                __be32 *ifh,
-                                struct net_device *dev)
+static netdev_tx_t lan966x_port_ifh_xmit(struct sk_buff *skb,
+                                        __be32 *ifh,
+                                        struct net_device *dev)
 {
        struct lan966x_port *port = netdev_priv(dev);
        struct lan966x *lan966x = port->lan966x;
@@ -344,12 +344,12 @@ static void lan966x_ifh_set_timestamp(void *ifh, u64 timestamp)
                IFH_POS_TIMESTAMP, IFH_LEN * 4, PACK, 0);
 }

-static int lan966x_port_xmit(struct sk_buff *skb, struct net_device *dev)
+static netdev_tx_t lan966x_port_xmit(struct sk_buff *skb, struct net_device *dev)
 {
        struct lan966x_port *port = netdev_priv(dev);
        struct lan966x *lan966x = port->lan966x;
        __be32 ifh[IFH_LEN];
-       int err;
+       netdev_tx_t ret;

        memset(ifh, 0x0, sizeof(__be32) * IFH_LEN);

@@ -360,9 +360,8 @@ static int lan966x_port_xmit(struct sk_buff *skb, struct net_device *dev)
        lan966x_ifh_set_vid(ifh, skb_vlan_tag_get(skb));

        if (port->lan966x->ptp && skb_shinfo(skb)->tx_flags & SKBTX_HW_TSTAMP) {
-               err = lan966x_ptp_txtstamp_request(port, skb);
-               if (err)
-                       return err;
+               if (lan966x_ptp_txtstamp_request(port, skb))
+                       return NETDEV_TX_BUSY;

                lan966x_ifh_set_rew_op(ifh, LAN966X_SKB_CB(skb)->rew_op);
                lan966x_ifh_set_timestamp(ifh, LAN966X_SKB_CB(skb)->ts_id);
@@ -370,12 +369,12 @@ static int lan966x_port_xmit(struct sk_buff *skb, struct net_device *dev)

        spin_lock(&lan966x->tx_lock);
        if (port->lan966x->fdma)
-               err = lan966x_fdma_xmit(skb, ifh, dev);
+               ret = lan966x_fdma_xmit(skb, ifh, dev);
        else
-               err = lan966x_port_ifh_xmit(skb, ifh, dev);
+               ret = lan966x_port_ifh_xmit(skb, ifh, dev);
        spin_unlock(&lan966x->tx_lock);

-       return err;
+       return ret;
 }

 static int lan966x_port_change_mtu(struct net_device *dev, int new_mtu)
diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_main.h b/drivers/net/ethernet/microchip/lan966x/lan966x_main.h
index 9656071b8289e..d61a0fc4b33ab 100644
--- a/drivers/net/ethernet/microchip/lan966x/lan966x_main.h
+++ b/drivers/net/ethernet/microchip/lan966x/lan966x_main.h
@@ -434,7 +434,8 @@ irqreturn_t lan966x_ptp_ext_irq_handler(int irq, void *args);
 u32 lan966x_ptp_get_period_ps(void);
 int lan966x_ptp_gettime64(struct ptp_clock_info *ptp, struct timespec64 *ts);

-int lan966x_fdma_xmit(struct sk_buff *skb, __be32 *ifh, struct net_device *dev);
+netdev_tx_t lan966x_fdma_xmit(struct sk_buff *skb, __be32 *ifh,
+                             struct net_device *dev);
 int lan966x_fdma_change_mtu(struct lan966x *lan966x);
 void lan966x_fdma_netdev_init(struct lan966x *lan966x, struct net_device *dev);
 void lan966x_fdma_netdev_deinit(struct lan966x *lan966x, struct net_device *dev);
---

> ---
>  drivers/net/ethernet/microchip/lan966x/lan966x_main.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_main.c b/drivers/net/ethernet/microchip/lan966x/lan966x_main.c
> index b98d37c76edb..be2fd030cccb 100644
> --- a/drivers/net/ethernet/microchip/lan966x/lan966x_main.c
> +++ b/drivers/net/ethernet/microchip/lan966x/lan966x_main.c
> @@ -344,7 +344,8 @@ static void lan966x_ifh_set_timestamp(void *ifh, u64 timestamp)
>                 IFH_POS_TIMESTAMP, IFH_LEN * 4, PACK, 0);
>  }
> 
> -static int lan966x_port_xmit(struct sk_buff *skb, struct net_device *dev)
> +static netdev_tx_t lan966x_port_xmit(struct sk_buff *skb,
> +                                    struct net_device *dev)
>  {
>         struct lan966x_port *port = netdev_priv(dev);
>         struct lan966x *lan966x = port->lan966x;
> --
> 2.38.0.rc1.362.ged0d419d3c-goog
> 

-- 
/Horatiu
