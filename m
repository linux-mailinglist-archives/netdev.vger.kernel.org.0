Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2BF3C3F1868
	for <lists+netdev@lfdr.de>; Thu, 19 Aug 2021 13:42:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238829AbhHSLnB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Aug 2021 07:43:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:32940 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238208AbhHSLnB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 19 Aug 2021 07:43:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 75BCA61051;
        Thu, 19 Aug 2021 11:42:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629373345;
        bh=3ESGGX79rMhnGcZfV5Ry+oGNnhm6MRLHvW3TMspM5YQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:From;
        b=ut8KSdULgn3p+M/Bco5J4bgKkhiUQXAS5GDNXzK4yQXTlm0KUPdhzgA8z56YYw3oM
         QF4fCpw0syrbBrFuPtZp3mntejrxdNeExeierW5o8WW3YQUOLRRucl0g7DdyXhHIFJ
         U+bT9/jEKBt9YQhQKcHpywECTYlKGGmWTnnm7bufSWp8Zh/osdvehka7DsIAwoCNQE
         OcPiLZpCLkiYgnuNRtFJi6dVmtoYsFYATcOawtf6yQD9aK2/TEeCf+ZKkY63iPLRjY
         Z/egnnPMQnKMR7TqK0l2K+CntvJ3r6Uw5DybYU7jV3ccg8knS9TYrSFwYujM+iNu+r
         4ztCznJ/eOCzQ==
Date:   Thu, 19 Aug 2021 06:42:23 -0500
From:   Bjorn Helgaas <helgaas@kernel.org>
To:     Kai-Heng Feng <kai.heng.feng@canonical.com>
Cc:     hkallweit1@gmail.com, nic_swsd@realtek.com, bhelgaas@google.com,
        davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v3 1/3] r8169: Implement dynamic ASPM mechanism
Message-ID: <20210819114223.GA3189268@bjorn-Precision-5520>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210819054542.608745-2-kai.heng.feng@canonical.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 19, 2021 at 01:45:40PM +0800, Kai-Heng Feng wrote:
> r8169 NICs on some platforms have abysmal speed when ASPM is enabled.
> Same issue can be observed with older vendor drivers.

On some platforms but not on others?  Maybe the PCIe topology is a
factor?  Do you have bug reports with data, e.g., "lspci -vv" output?

> The issue is however solved by the latest vendor driver. There's a new
> mechanism, which disables r8169's internal ASPM when the NIC traffic has
> more than 10 packets, and vice versa. 

Presumably there's a time interval related to the 10 packets?  For
example, do you want to disable ASPM if 10 packets are received (or
sent?) in a certain amount of time?

> The possible reason for this is
> likely because the buffer on the chip is too small for its ASPM exit
> latency.

Maybe this means the chip advertises incorrect exit latencies?  If so,
maybe a quirk could override that?

> Realtek confirmed that all their PCIe LAN NICs, r8106, r8168 and r8125
> use dynamic ASPM under Windows. So implement the same mechanism here to
> resolve the issue.

What exactly is "dynamic ASPM"?

I see Heiner's comment about this being intended only for a downstream
kernel.  But why?

> Signed-off-by: Kai-Heng Feng <kai.heng.feng@canonical.com>
> ---
> v3:
>  - Use msecs_to_jiffies() for delay time
>  - Use atomic_t instead of mutex for bh
>  - Mention the buffer size and ASPM exit latency in commit message
> 
> v2: 
>  - Use delayed_work instead of timer_list to avoid interrupt context
>  - Use mutex to serialize packet counter read/write
>  - Wording change
> 
>  drivers/net/ethernet/realtek/r8169_main.c | 44 ++++++++++++++++++++++-
>  1 file changed, 43 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
> index 7a69b468584a2..3359509c1c351 100644
> --- a/drivers/net/ethernet/realtek/r8169_main.c
> +++ b/drivers/net/ethernet/realtek/r8169_main.c
> @@ -624,6 +624,10 @@ struct rtl8169_private {
>  
>  	unsigned supports_gmii:1;
>  	unsigned aspm_manageable:1;
> +	unsigned rtl_aspm_enabled:1;
> +	struct delayed_work aspm_toggle;
> +	atomic_t aspm_packet_count;
> +
>  	dma_addr_t counters_phys_addr;
>  	struct rtl8169_counters *counters;
>  	struct rtl8169_tc_offsets tc_offset;
> @@ -2665,8 +2669,13 @@ static void rtl_pcie_state_l2l3_disable(struct rtl8169_private *tp)
>  
>  static void rtl_hw_aspm_clkreq_enable(struct rtl8169_private *tp, bool enable)
>  {
> +	if (!tp->aspm_manageable && enable)
> +		return;
> +
> +	tp->rtl_aspm_enabled = enable;
> +
>  	/* Don't enable ASPM in the chip if OS can't control ASPM */
> -	if (enable && tp->aspm_manageable) {
> +	if (enable) {
>  		RTL_W8(tp, Config5, RTL_R8(tp, Config5) | ASPM_en);
>  		RTL_W8(tp, Config2, RTL_R8(tp, Config2) | ClkReqEn);
>  	} else {
> @@ -4415,6 +4424,7 @@ static void rtl_tx(struct net_device *dev, struct rtl8169_private *tp,
>  
>  	dirty_tx = tp->dirty_tx;
>  
> +	atomic_add(tp->cur_tx - dirty_tx, &tp->aspm_packet_count);
>  	while (READ_ONCE(tp->cur_tx) != dirty_tx) {
>  		unsigned int entry = dirty_tx % NUM_TX_DESC;
>  		u32 status;
> @@ -4559,6 +4569,8 @@ static int rtl_rx(struct net_device *dev, struct rtl8169_private *tp, int budget
>  		rtl8169_mark_to_asic(desc);
>  	}
>  
> +	atomic_add(count, &tp->aspm_packet_count);
> +
>  	return count;
>  }
>  
> @@ -4666,8 +4678,32 @@ static int r8169_phy_connect(struct rtl8169_private *tp)
>  	return 0;
>  }
>  
> +#define ASPM_PACKET_THRESHOLD 10
> +#define ASPM_TOGGLE_INTERVAL 1000
> +
> +static void rtl8169_aspm_toggle(struct work_struct *work)
> +{
> +	struct rtl8169_private *tp = container_of(work, struct rtl8169_private,
> +						  aspm_toggle.work);
> +	int packet_count;
> +	bool enable;
> +
> +	packet_count = atomic_xchg(&tp->aspm_packet_count, 0);
> +	enable = packet_count <= ASPM_PACKET_THRESHOLD;
> +
> +	if (tp->rtl_aspm_enabled != enable) {
> +		rtl_unlock_config_regs(tp);
> +		rtl_hw_aspm_clkreq_enable(tp, enable);
> +		rtl_lock_config_regs(tp);
> +	}
> +
> +	schedule_delayed_work(&tp->aspm_toggle, msecs_to_jiffies(ASPM_TOGGLE_INTERVAL));
> +}
> +
>  static void rtl8169_down(struct rtl8169_private *tp)
>  {
> +	cancel_delayed_work_sync(&tp->aspm_toggle);
> +
>  	/* Clear all task flags */
>  	bitmap_zero(tp->wk.flags, RTL_FLAG_MAX);
>  
> @@ -4694,6 +4730,8 @@ static void rtl8169_up(struct rtl8169_private *tp)
>  	rtl_reset_work(tp);
>  
>  	phy_start(tp->phydev);
> +
> +	schedule_delayed_work(&tp->aspm_toggle, msecs_to_jiffies(ASPM_TOGGLE_INTERVAL));
>  }
>  
>  static int rtl8169_close(struct net_device *dev)
> @@ -5354,6 +5392,10 @@ static int rtl_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
>  
>  	INIT_WORK(&tp->wk.work, rtl_task);
>  
> +	INIT_DELAYED_WORK(&tp->aspm_toggle, rtl8169_aspm_toggle);
> +
> +	atomic_set(&tp->aspm_packet_count, 0);
> +
>  	rtl_init_mac_address(tp);
>  
>  	dev->ethtool_ops = &rtl8169_ethtool_ops;
> -- 
> 2.32.0
> 
