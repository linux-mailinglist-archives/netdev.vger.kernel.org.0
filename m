Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B933D49DF92
	for <lists+netdev@lfdr.de>; Thu, 27 Jan 2022 11:40:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239150AbiA0Kkz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jan 2022 05:40:55 -0500
Received: from mga17.intel.com ([192.55.52.151]:20498 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232916AbiA0Kky (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 27 Jan 2022 05:40:54 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1643280054; x=1674816054;
  h=date:from:to:cc:subject:in-reply-to:message-id:
   references:mime-version;
  bh=CwF4EuD+jK2sMYt/qd0W3G7JEKV2ORaBWovMhleYyHM=;
  b=JYkYRWcOdtIX2T/D+V1Nh0MkMtUKq9cscpjwxF1faVduIz5pjtfEb//m
   FMWT5AYi8L8jm9B38Hi8Cv2BT1yvnjc4qGXwLqUsFl779X1PDei3PCdtw
   oc4xXfPfcUgmxgxoJVrWZH4x2eznRAnUnvURhMSBnknT8jSYFf394q01h
   odPxsU6Dk22YTIex7GAIhaCNqlxaYS7WUG/MS7wDPoagwQrmcrd+GjDPU
   Ta7DIT6tCPT+k0GbuecroWfnBDsdRfjwnzgiVtIvUeDkuFE0R9/UKMCMG
   wsiXxfxCklbtpAuntRqiUyTZd4oU+/Vknhq7e4/bioKTnEPVGl0kN3162
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10239"; a="227486671"
X-IronPort-AV: E=Sophos;i="5.88,320,1635231600"; 
   d="scan'208";a="227486671"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jan 2022 02:40:54 -0800
X-IronPort-AV: E=Sophos;i="5.88,320,1635231600"; 
   d="scan'208";a="521179456"
Received: from shochwel-mobl.ger.corp.intel.com ([10.249.44.153])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jan 2022 02:40:48 -0800
Date:   Thu, 27 Jan 2022 12:40:42 +0200 (EET)
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
        sreehari.kancharla@intel.com
Subject: Re: [PATCH net-next v4 05/13] net: wwan: t7xx: Add control port
In-Reply-To: <20220114010627.21104-6-ricardo.martinez@linux.intel.com>
Message-ID: <7c1f1fe-fb19-fa95-10e3-776b81f5128@linux.intel.com>
References: <20220114010627.21104-1-ricardo.martinez@linux.intel.com> <20220114010627.21104-6-ricardo.martinez@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 13 Jan 2022, Ricardo Martinez wrote:

> From: Haijun Liu <haijun.liu@mediatek.com>
> 
> Control Port implements driver control messages such as modem-host
> handshaking, controls port enumeration, and handles exception messages.
> 
> The handshaking process between the driver and the modem happens during
> the init sequence. The process involves the exchange of a list of
> supported runtime features to make sure that modem and host are ready
> to provide proper feature lists including port enumeration. Further
> features can be enabled and controlled in this handshaking process.
> 
> Signed-off-by: Haijun Liu <haijun.liu@mediatek.com>
> Signed-off-by: Chandrashekar Devegowda <chandrashekar.devegowda@intel.com>
> Co-developed-by: Ricardo Martinez <ricardo.martinez@linux.intel.com>
> Signed-off-by: Ricardo Martinez <ricardo.martinez@linux.intel.com>
> ---

> +	/* Fill runtime feature */
> +	for (i = 0; i < FEATURE_COUNT; i++) {
> +		u8 md_feature_mask = FIELD_GET(FEATURE_MSK, md_feature->feature_set[i]);
> +
> +		memset(&rt_feature, 0, sizeof(rt_feature));
> +		rt_feature.feature_id = i;
> +
> +		switch (md_feature_mask) {
> +		case MTK_FEATURE_DOES_NOT_EXIST:
> +		case MTK_FEATURE_MUST_BE_SUPPORTED:
> +			rt_feature.support_info = md_feature->feature_set[i];
> +			break;
> +
> +		default:
> +			break;

Please remove empty default blocks from all patches.


> +		}
> +
> +		if (FIELD_GET(FEATURE_MSK, rt_feature.support_info) !=
> +		    MTK_FEATURE_MUST_BE_SUPPORTED) {
> +			memcpy(rt_data, &rt_feature, sizeof(rt_feature));
> +			rt_data += sizeof(rt_feature);
> +		}
> +
> +		packet_size += sizeof(struct mtk_runtime_feature);
> +	}

Is it intentional these two additions (rt_data and packet_size) are on
different sides of the if block?


> +static int port_ctl_init(struct t7xx_port *port)
> +{
> +	struct t7xx_port_static *port_static = port->port_static;
> +
> +	port->skb_handler = &control_msg_handler;
> +	port->thread = kthread_run(port_ctl_rx_thread, port, "%s", port_static->name);
> +	if (IS_ERR(port->thread)) {
> +		dev_err(port->dev, "Failed to start port control thread\n");
> +		return PTR_ERR(port->thread);
> +	}
> +
> +	port->rx_length_th = CTRL_QUEUE_MAXLEN;
> +	return 0;
> +}
> +
> +static void port_ctl_uninit(struct t7xx_port *port)
> +{
> +	unsigned long flags;
> +	struct sk_buff *skb;
> +
> +	if (port->thread)
> +		kthread_stop(port->thread);
> +
> +	spin_lock_irqsave(&port->rx_wq.lock, flags);
> +	while ((skb = __skb_dequeue(&port->rx_skb_list)) != NULL)
> +		dev_kfree_skb_any(skb);
> +
> +	spin_unlock_irqrestore(&port->rx_wq.lock, flags);
> +}

I wonder if the uninit should set rx_length_th to 0 to prevent
further accumulation of skbs?

> +	FSM_EVENT_AP_HS2_EXIT,

Never used anywhere.


-- 
 i.

