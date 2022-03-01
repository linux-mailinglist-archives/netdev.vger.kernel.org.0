Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E1CF94C8C3E
	for <lists+netdev@lfdr.de>; Tue,  1 Mar 2022 14:05:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233631AbiCANG0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Mar 2022 08:06:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230075AbiCANGZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Mar 2022 08:06:25 -0500
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 837C29ADBB;
        Tue,  1 Mar 2022 05:05:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1646139944; x=1677675944;
  h=date:from:to:cc:subject:in-reply-to:message-id:
   references:mime-version;
  bh=lcheyrkmjEM5QVMr/2UZtUl4ygVPPmK1bRpuRJVFTjw=;
  b=lIX0TxAq5GTZPmyShhoA/IfVJInbQIYq8I098Oy7rN37Nv1mbV616X8b
   UGxACeqanXDKwSgDrvIN/iPz0gFseMcqPdwfgQDHeoC0N37UuUin9zt4d
   C8hBgv56eP7Zk5AbmoFFFzFcAZj/U3xyU+5yiY7E1ZppDoY3AnMn2H4qd
   JIlt/L7vClCe6LA2Jo6cGRMgwr7owpToAJmuaaKrjJB+lfGypFM81dihD
   UVBl99RBGzO7yHIzVpMharCW3oMsvbQa3Gwp1Io9TrEqCnO6cl0Er2P5/
   I/A9DZSCagINj4e4oRcvkuI5IYGrGMTimfjuivlDX31lWaHSHmwh1uCjD
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10272"; a="236634492"
X-IronPort-AV: E=Sophos;i="5.90,146,1643702400"; 
   d="scan'208";a="236634492"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Mar 2022 05:05:44 -0800
X-IronPort-AV: E=Sophos;i="5.90,146,1643702400"; 
   d="scan'208";a="550702108"
Received: from fsforza-mobl1.ger.corp.intel.com ([10.252.44.248])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Mar 2022 05:05:37 -0800
Date:   Tue, 1 Mar 2022 15:05:31 +0200 (EET)
From:   =?ISO-8859-15?Q?Ilpo_J=E4rvinen?= <ilpo.jarvinen@linux.intel.com>
To:     Ricardo Martinez <ricardo.martinez@linux.intel.com>
cc:     Netdev <netdev@vger.kernel.org>, linux-wireless@vger.kernel.org,
        kuba@kernel.org, davem@davemloft.net, johannes@sipsolutions.net,
        ryazanov.s.a@gmail.com, loic.poulain@linaro.org,
        m.chetan.kumar@intel.com, chandrashekar.devegowda@intel.com,
        linuxwwan@intel.com, chiranjeevi.rapolu@linux.intel.com,
        haijun.liu@mediatek.com, amir.hanania@intel.com,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        dinesh.sharma@intel.com, eliot.lee@intel.com,
        moises.veleta@intel.com, pierre-louis.bossart@intel.com,
        muralidharan.sethuraman@intel.com, Soumya.Prakash.Mishra@intel.com,
        sreehari.kancharla@intel.com, madhusmita.sahu@intel.com
Subject: Re: [PATCH net-next v5 08/13] net: wwan: t7xx: Add data path
 interface
In-Reply-To: <20220223223326.28021-9-ricardo.martinez@linux.intel.com>
Message-ID: <52ad3b79-afd-7174-9eaf-86e2d364fcc6@linux.intel.com>
References: <20220223223326.28021-1-ricardo.martinez@linux.intel.com> <20220223223326.28021-9-ricardo.martinez@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 23 Feb 2022, Ricardo Martinez wrote:

> From: Haijun Liu <haijun.liu@mediatek.com>
> 
> Data Path Modem AP Interface (DPMAIF) HIF layer provides methods
> for initialization, ISR, control and event handling of TX/RX flows.
> 
> DPMAIF TX
> Exposes the `dmpaif_tx_send_skb` function which can be used by the
> network device to transmit packets.
> The uplink data management uses a Descriptor Ring Buffer (DRB).
> First DRB entry is a message type that will be followed by 1 or more
> normal DRB entries. Message type DRB will hold the skb information
> and each normal DRB entry holds a pointer to the skb payload.
> 
> DPMAIF RX
> The downlink buffer management uses Buffer Address Table (BAT) and
> Packet Information Table (PIT) rings.
> The BAT ring holds the address of skb data buffer for the HW to use,
> while the PIT contains metadata about a whole network packet including
> a reference to the BAT entry holding the data buffer address.
> The driver reads the PIT and BAT entries written by the modem, when
> reaching a threshold, the driver will reload the PIT and BAT rings.
> 
> Signed-off-by: Haijun Liu <haijun.liu@mediatek.com>
> Signed-off-by: Chandrashekar Devegowda <chandrashekar.devegowda@intel.com>
> Co-developed-by: Ricardo Martinez <ricardo.martinez@linux.intel.com>
> Signed-off-by: Ricardo Martinez <ricardo.martinez@linux.intel.com>
> 
> >From a WWAN framework perspective:
> Reviewed-by: Loic Poulain <loic.poulain@linaro.org>
> ---

> +static int t7xx_dpmaif_update_bat_wr_idx(struct dpmaif_ctrl *dpmaif_ctrl,
> +					 const unsigned char q_num, const unsigned int bat_cnt)
> +{
> +	struct dpmaif_rx_queue *rxq = &dpmaif_ctrl->rxq[q_num];
> +	unsigned short old_rl_idx, new_wr_idx, old_wr_idx;

unsigned int. I thought you listed a change for these idx local
variables but there were still many unsigned shorts. Please check
the whole change.

> +static int t7xx_dpmaif_rx_data_collect(struct dpmaif_ctrl *dpmaif_ctrl,
> +				       const unsigned char q_num, const unsigned int budget)
> +{
> +	struct dpmaif_rx_queue *rxq = &dpmaif_ctrl->rxq[q_num];
> +	unsigned long time_limit;
> +	unsigned int cnt;
> +
> +	time_limit = jiffies + msecs_to_jiffies(DPMAIF_WQ_TIME_LIMIT_MS);
> +
> +	while ((cnt = t7xx_dpmaifq_poll_pit(rxq))) {
> +		unsigned int rd_cnt;
> +		int real_cnt;
> +
> +		rd_cnt = min_t(unsigned int, cnt, budget);

This can be min(cnt, budget); because they're now both unsigned ints.
min_t is only needed if the args are of different type.

> +		t7xx_dpmaif_ul_update_hw_drb_cnt(&dpmaif_ctrl->hw_info, txq->index,
> +						 drb_send_cnt * DPMAIF_UL_DRB_SIZE_WORD);

This is the only callsite for t7xx_dpmaif_ul_update_hw_drb_cnt
that returns int (in 07). Change it to void?

> +		/* Wait for active Tx to be doneg */

doneg -> done.


-- 
 i.

