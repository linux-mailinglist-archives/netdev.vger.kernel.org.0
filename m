Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0EC4127DC76
	for <lists+netdev@lfdr.de>; Wed, 30 Sep 2020 01:07:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728963AbgI2XHH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Sep 2020 19:07:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728113AbgI2XHG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Sep 2020 19:07:06 -0400
Received: from mail-pf1-x435.google.com (mail-pf1-x435.google.com [IPv6:2607:f8b0:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE002C0613D0
        for <netdev@vger.kernel.org>; Tue, 29 Sep 2020 16:07:06 -0700 (PDT)
Received: by mail-pf1-x435.google.com with SMTP id f18so6279562pfa.10
        for <netdev@vger.kernel.org>; Tue, 29 Sep 2020 16:07:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=T56W4rlwKM3h0w7+QjGBQRIaXGTOjqoGepwvZvifopA=;
        b=u7ctPNw/bCJlHLZao4KrUwd8YSTNwu0ScSWSkn38YGsAWZv9zrDlzkmqrUrwD5aLem
         /w0yuGo+dbSRL1jimX9qU98ulfFvQ3MsEB1I1SUz3NFIS6T8xwWTKPBZL8MqMhx4+j7h
         XOXdJNg0vgO/7B0eq6AL4pBli99xvTVSeVcCfN1sBsU2KCSlQBq1qpQX93SDqNFk8Riz
         UMysDx5VYIkhLrI4K10saFmbuZ93NW3LS7O2/s/36I97FP0z7gpZghd1APyIc3fO2Hfm
         YREFwEWNc570IMUD4jhkE36VZ5py8gvbC0AK+KcPo34NQiNUV3BFr8tB5tehXj2wvMoU
         1G7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=T56W4rlwKM3h0w7+QjGBQRIaXGTOjqoGepwvZvifopA=;
        b=q2YxTcjIaTGr37nVW7hkWg+VXqmhttcxkpYxml3Wg5B+eVtVI0kUCflxtLf0gnb/yR
         VJR33TEFgRLOaOk+tF8KW5ndH9GtSwDLLHV1PMftVjBT8mZZeBNW+TNBhCiUScQjiysx
         BSnZC+rfi2YAVy+q3ERZIUOuhGg5UilZpGEZyeOhq79h05NHTJk4lq1k1fXcpzOwp3bB
         F2wmIGwddHPqps2pDumeVz+mIZEX8D9gwAS60TMOtSzchRumUspLO7RJtSARuWAZmVFz
         c5KEgL9AViG+985AKAfc6+gNzhglF3hrjMVbz7YwnGUnEoydU/FIrIOga3FusP4bfrnr
         mSHw==
X-Gm-Message-State: AOAM5306X0nThhP7O5DE6cH3asKtU4z14gj1JGlC0DvmnVYYh1VJYE/Y
        VYwHRE65jrPRoPccmLjrSMwAvA==
X-Google-Smtp-Source: ABdhPJzpobBeVD0QizR5JNx2IEww3/DSsVZ79uzkw55sMm1JxKZo1kgF0e0ARRsarK31gnzhNU0N1A==
X-Received: by 2002:a63:df02:: with SMTP id u2mr4908192pgg.270.1601420826006;
        Tue, 29 Sep 2020 16:07:06 -0700 (PDT)
Received: from Shannons-MacBook-Pro.local (static-50-53-47-17.bvtn.or.frontiernet.net. [50.53.47.17])
        by smtp.gmail.com with ESMTPSA id 134sm5798661pgf.55.2020.09.29.16.07.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 29 Sep 2020 16:07:05 -0700 (PDT)
Subject: Re: [patch V2 11/36] net: ionic: Replace in_interrupt() usage.
To:     Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Paul McKenney <paulmck@kernel.org>,
        Matthew Wilcox <willy@infradead.org>,
        Christian Benvenuti <benve@cisco.com>,
        Govindarajulu Varadarajan <_govind@gmx.com>,
        Dave Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Jonathan Corbet <corbet@lwn.net>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        linux-doc@vger.kernel.org,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Luc Van Oostenryck <luc.vanoostenryck@gmail.com>,
        Jay Cliburn <jcliburn@gmail.com>,
        Chris Snook <chris.snook@gmail.com>,
        Vishal Kulkarni <vishal@chelsio.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        intel-wired-lan@lists.osuosl.org,
        Pensando Drivers <drivers@pensando.io>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Solarflare linux maintainers <linux-net-drivers@solarflare.com>,
        Edward Cree <ecree@solarflare.com>,
        Martin Habets <mhabets@solarflare.com>,
        Jon Mason <jdmason@kudzu.us>, Daniel Drake <dsd@gentoo.org>,
        Ulrich Kunitz <kune@deine-taler.de>,
        Kalle Valo <kvalo@codeaurora.org>,
        linux-wireless@vger.kernel.org, linux-usb@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Arend van Spriel <arend.vanspriel@broadcom.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Chi-Hsien Lin <chi-hsien.lin@cypress.com>,
        Wright Feng <wright.feng@cypress.com>,
        brcm80211-dev-list.pdl@broadcom.com,
        brcm80211-dev-list@cypress.com,
        Stanislav Yakovlev <stas.yakovlev@gmail.com>,
        Stanislaw Gruszka <stf_xl@wp.pl>,
        Johannes Berg <johannes.berg@intel.com>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Intel Linux Wireless <linuxwifi@intel.com>,
        Jouni Malinen <j@w1.fi>,
        Amitkumar Karwar <amitkarwar@gmail.com>,
        Ganapathi Bhat <ganapathi.bhat@nxp.com>,
        Xinming Hu <huxinming820@gmail.com>,
        libertas-dev@lists.infradead.org,
        Pascal Terjan <pterjan@google.com>,
        Ping-Ke Shih <pkshih@realtek.com>
References: <20200929202509.673358734@linutronix.de>
 <20200929203500.579810110@linutronix.de>
From:   Shannon Nelson <snelson@pensando.io>
Message-ID: <04ec3648-9735-b901-6492-606468d47158@pensando.io>
Date:   Tue, 29 Sep 2020 16:06:59 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <20200929203500.579810110@linutronix.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/29/20 1:25 PM, Thomas Gleixner wrote:
> From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
>
> The in_interrupt() usage in this driver tries to figure out which context
> may sleep and which context may not sleep. in_interrupt() is not really
> suitable as it misses both preemption disabled and interrupt disabled
> invocations from task context.
>
> Conditionals like that in driver code are frowned upon in general because
> invocations of functions from invalid contexts might not be detected
> as the conditional papers over it.
>
> ionic_lif_addr() and _ionoc_lif_rx_mode() can be called from:
>
>   1) ->ndo_set_rx_mode() which is under netif_addr_lock_bh()) so it must not
>      sleep.
>
>   2) Init and setup functions which are in fully preemptible task context.
>
> ionic_link_status_check_request() has two call paths:
>
>   1) NAPI which obviously cannot sleep
>
>   2) Setup which is again fully preemptible task context
>
> Add arguments which convey the execution context to the affected functions
> and let the callers provide the context instead of letting the functions
> deduce it.
>
> Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> ---
> V2: Treat _ionoc_lif_rx_mode() correclty (Shannon)

Is it fair to poke at the comments?
s/ionoc/ionic/
s/correclty/correctly/

> ---
>   drivers/net/ethernet/pensando/ionic/ionic_dev.c |    2
>   drivers/net/ethernet/pensando/ionic/ionic_lif.c |   64 ++++++++++++++++--------
>   drivers/net/ethernet/pensando/ionic/ionic_lif.h |    2
>   3 files changed, 47 insertions(+), 21 deletions(-)
>
> --- a/drivers/net/ethernet/pensando/ionic/ionic_dev.c
> +++ b/drivers/net/ethernet/pensando/ionic/ionic_dev.c
> @@ -22,7 +22,7 @@ static void ionic_watchdog_cb(struct tim
>   	hb = ionic_heartbeat_check(ionic);
>   
>   	if (hb >= 0 && ionic->lif)
> -		ionic_link_status_check_request(ionic->lif);
> +		ionic_link_status_check_request(ionic->lif, false);
>   }
>   
>   void ionic_init_devinfo(struct ionic *ionic)
> --- a/drivers/net/ethernet/pensando/ionic/ionic_lif.c
> +++ b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
> @@ -151,7 +151,7 @@ static void ionic_link_status_check(stru
>   	clear_bit(IONIC_LIF_F_LINK_CHECK_REQUESTED, lif->state);
>   }
>   
> -void ionic_link_status_check_request(struct ionic_lif *lif)
> +void ionic_link_status_check_request(struct ionic_lif *lif, bool can_sleep)
>   {
>   	struct ionic_deferred_work *work;
>   
> @@ -159,7 +159,7 @@ void ionic_link_status_check_request(str
>   	if (test_and_set_bit(IONIC_LIF_F_LINK_CHECK_REQUESTED, lif->state))
>   		return;
>   
> -	if (in_interrupt()) {
> +	if (!can_sleep) {
>   		work = kzalloc(sizeof(*work), GFP_ATOMIC);
>   		if (!work)
>   			return;
> @@ -798,7 +798,7 @@ static bool ionic_notifyq_service(struct
>   
>   	switch (le16_to_cpu(comp->event.ecode)) {
>   	case IONIC_EVENT_LINK_CHANGE:
> -		ionic_link_status_check_request(lif);
> +		ionic_link_status_check_request(lif, false);
>   		break;
>   	case IONIC_EVENT_RESET:
>   		work = kzalloc(sizeof(*work), GFP_ATOMIC);
> @@ -981,7 +981,8 @@ static int ionic_lif_addr_del(struct ion
>   	return 0;
>   }
>   
> -static int ionic_lif_addr(struct ionic_lif *lif, const u8 *addr, bool add)
> +static int ionic_lif_addr(struct ionic_lif *lif, const u8 *addr, bool add,
> +			  bool can_sleep)
>   {
>   	struct ionic *ionic = lif->ionic;
>   	struct ionic_deferred_work *work;
> @@ -1010,7 +1011,7 @@ static int ionic_lif_addr(struct ionic_l
>   			lif->nucast--;
>   	}
>   
> -	if (in_interrupt()) {
> +	if (!can_sleep) {
>   		work = kzalloc(sizeof(*work), GFP_ATOMIC);
>   		if (!work) {
>   			netdev_err(lif->netdev, "%s OOM\n", __func__);
> @@ -1036,12 +1037,22 @@ static int ionic_lif_addr(struct ionic_l
>   
>   static int ionic_addr_add(struct net_device *netdev, const u8 *addr)
>   {
> -	return ionic_lif_addr(netdev_priv(netdev), addr, true);
> +	return ionic_lif_addr(netdev_priv(netdev), addr, true, true);
> +}
> +
> +static int ionic_ndo_addr_add(struct net_device *netdev, const u8 *addr)
> +{
> +	return ionic_lif_addr(netdev_priv(netdev), addr, true, false);
>   }
>   
>   static int ionic_addr_del(struct net_device *netdev, const u8 *addr)
>   {
> -	return ionic_lif_addr(netdev_priv(netdev), addr, false);
> +	return ionic_lif_addr(netdev_priv(netdev), addr, false, true);
> +}
> +
> +static int ionic_ndo_addr_del(struct net_device *netdev, const u8 *addr)
> +{
> +	return ionic_lif_addr(netdev_priv(netdev), addr, false, false);
>   }

These changes are reasonable, tho' I'm not fond of parameter lists of 
"true" and "false" with no context.  I'd prefer to have some constants like
#define can_sleep true
so the code can be a little more readable.

Yes, I know we have this problem already in the call to 
ionic_lif_addr(), which I'm annoyed with but haven't addressed yet.

So, if you want to deal with this now, fine, otherwise I'll take care of 
them both later.

Meanwhile,

Acked-by: Shannon Nelson <snelson@pensando.io>




>   
>   static void ionic_lif_rx_mode(struct ionic_lif *lif, unsigned int rx_mode)
> @@ -1081,11 +1092,12 @@ static void ionic_lif_rx_mode(struct ion
>   		lif->rx_mode = rx_mode;
>   }
>   
> -static void _ionic_lif_rx_mode(struct ionic_lif *lif, unsigned int rx_mode)
> +static void _ionic_lif_rx_mode(struct ionic_lif *lif, unsigned int rx_mode,
> +			       bool from_ndo)
>   {
>   	struct ionic_deferred_work *work;
>   
> -	if (in_interrupt()) {
> +	if (from_ndo) {
>   		work = kzalloc(sizeof(*work), GFP_ATOMIC);
>   		if (!work) {
>   			netdev_err(lif->netdev, "%s OOM\n", __func__);
> @@ -1100,7 +1112,16 @@ static void _ionic_lif_rx_mode(struct io
>   	}
>   }
>   
> -static void ionic_set_rx_mode(struct net_device *netdev)
> +static void ionic_dev_uc_sync(struct net_device *netdev, bool from_ndo)
> +{
> +	if (from_ndo)
> +		__dev_uc_sync(netdev, ionic_ndo_addr_add, ionic_ndo_addr_del);
> +	else
> +		__dev_uc_sync(netdev, ionic_addr_add, ionic_addr_del);
> +
> +}
> +
> +static void ionic_set_rx_mode(struct net_device *netdev, bool from_ndo)
>   {
>   	struct ionic_lif *lif = netdev_priv(netdev);
>   	struct ionic_identity *ident;
> @@ -1122,7 +1143,7 @@ static void ionic_set_rx_mode(struct net
>   	 *       we remove our overflow flag and check the netdev flags
>   	 *       to see if we can disable NIC PROMISC
>   	 */
> -	__dev_uc_sync(netdev, ionic_addr_add, ionic_addr_del);
> +	ionic_dev_uc_sync(netdev, from_ndo);
>   	nfilters = le32_to_cpu(ident->lif.eth.max_ucast_filters);
>   	if (netdev_uc_count(netdev) + 1 > nfilters) {
>   		rx_mode |= IONIC_RX_MODE_F_PROMISC;
> @@ -1134,7 +1155,7 @@ static void ionic_set_rx_mode(struct net
>   	}
>   
>   	/* same for multicast */
> -	__dev_mc_sync(netdev, ionic_addr_add, ionic_addr_del);
> +	ionic_dev_uc_sync(netdev, from_ndo);
>   	nfilters = le32_to_cpu(ident->lif.eth.max_mcast_filters);
>   	if (netdev_mc_count(netdev) > nfilters) {
>   		rx_mode |= IONIC_RX_MODE_F_ALLMULTI;
> @@ -1146,7 +1167,12 @@ static void ionic_set_rx_mode(struct net
>   	}
>   
>   	if (lif->rx_mode != rx_mode)
> -		_ionic_lif_rx_mode(lif, rx_mode);
> +		_ionic_lif_rx_mode(lif, rx_mode, from_ndo);
> +}
> +
> +static void ionic_ndo_set_rx_mode(struct net_device *netdev)
> +{
> +	ionic_set_rx_mode(netdev, true);
>   }
>   
>   static __le64 ionic_netdev_features_to_nic(netdev_features_t features)
> @@ -1391,7 +1417,7 @@ static int ionic_start_queues_reconfig(s
>   	 */
>   	err = ionic_txrx_init(lif);
>   	mutex_unlock(&lif->queue_lock);
> -	ionic_link_status_check_request(lif);
> +	ionic_link_status_check_request(lif, true);
>   	netif_device_attach(lif->netdev);
>   
>   	return err;
> @@ -1720,7 +1746,7 @@ static int ionic_txrx_init(struct ionic_
>   	if (lif->netdev->features & NETIF_F_RXHASH)
>   		ionic_lif_rss_init(lif);
>   
> -	ionic_set_rx_mode(lif->netdev);
> +	ionic_set_rx_mode(lif->netdev, false);
>   
>   	return 0;
>   
> @@ -2093,7 +2119,7 @@ static const struct net_device_ops ionic
>   	.ndo_stop               = ionic_stop,
>   	.ndo_start_xmit		= ionic_start_xmit,
>   	.ndo_get_stats64	= ionic_get_stats64,
> -	.ndo_set_rx_mode	= ionic_set_rx_mode,
> +	.ndo_set_rx_mode	= ionic_ndo_set_rx_mode,
>   	.ndo_set_features	= ionic_set_features,
>   	.ndo_set_mac_address	= ionic_set_mac_address,
>   	.ndo_validate_addr	= eth_validate_addr,
> @@ -2521,7 +2547,7 @@ static void ionic_lif_handle_fw_up(struc
>   	}
>   
>   	clear_bit(IONIC_LIF_F_FW_RESET, lif->state);
> -	ionic_link_status_check_request(lif);
> +	ionic_link_status_check_request(lif, true);
>   	netif_device_attach(lif->netdev);
>   	dev_info(ionic->dev, "FW Up: LIFs restarted\n");
>   
> @@ -2713,7 +2739,7 @@ static int ionic_station_set(struct ioni
>   		 */
>   		if (!ether_addr_equal(ctx.comp.lif_getattr.mac,
>   				      netdev->dev_addr))
> -			ionic_lif_addr(lif, netdev->dev_addr, true);
> +			ionic_lif_addr(lif, netdev->dev_addr, true, true);
>   	} else {
>   		/* Update the netdev mac with the device's mac */
>   		memcpy(addr.sa_data, ctx.comp.lif_getattr.mac, netdev->addr_len);
> @@ -2730,7 +2756,7 @@ static int ionic_station_set(struct ioni
>   
>   	netdev_dbg(lif->netdev, "adding station MAC addr %pM\n",
>   		   netdev->dev_addr);
> -	ionic_lif_addr(lif, netdev->dev_addr, true);
> +	ionic_lif_addr(lif, netdev->dev_addr, true, true);
>   
>   	return 0;
>   }
> --- a/drivers/net/ethernet/pensando/ionic/ionic_lif.h
> +++ b/drivers/net/ethernet/pensando/ionic/ionic_lif.h
> @@ -245,7 +245,7 @@ static inline u32 ionic_coal_usec_to_hw(
>   
>   typedef void (*ionic_reset_cb)(struct ionic_lif *lif, void *arg);
>   
> -void ionic_link_status_check_request(struct ionic_lif *lif);
> +void ionic_link_status_check_request(struct ionic_lif *lif, bool can_sleep);
>   void ionic_get_stats64(struct net_device *netdev,
>   		       struct rtnl_link_stats64 *ns);
>   void ionic_lif_deferred_enqueue(struct ionic_deferred *def,
>

