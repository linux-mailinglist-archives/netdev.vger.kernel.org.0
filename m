Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A38B626116C
	for <lists+netdev@lfdr.de>; Tue,  8 Sep 2020 14:34:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730012AbgIHMeS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Sep 2020 08:34:18 -0400
Received: from mga07.intel.com ([134.134.136.100]:59728 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730133AbgIHLvf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 8 Sep 2020 07:51:35 -0400
IronPort-SDR: qbU9wQojQO1rbr2U3kpA7KaU3FMvXkOsP3uQ8oD7rp+rllTLTh5eyeqJ7PB67jCpdiXhknGvMf
 eFETr2KdPK/Q==
X-IronPort-AV: E=McAfee;i="6000,8403,9737"; a="222323316"
X-IronPort-AV: E=Sophos;i="5.76,405,1592895600"; 
   d="scan'208";a="222323316"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Sep 2020 04:49:58 -0700
IronPort-SDR: 5FSVB/y7Pehr2OXRnNhTk4Mc2Rdqw20SWp9xRaQbrEmJvk2smAgX5KzK/d83KrIwbtDWO4+s+f
 6nT+2pVAblKQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.76,405,1592895600"; 
   d="scan'208";a="284487161"
Received: from pgierasi-mobl.ger.corp.intel.com (HELO btopel-mobl.ger.intel.com) ([10.252.39.2])
  by fmsmga007.fm.intel.com with ESMTP; 08 Sep 2020 04:49:55 -0700
Subject: Re: [PATCH bpf-next 4/4] ixgbe, xsk: use XSK_NAPI_WEIGHT as NAPI poll
 budget
To:     Eric Dumazet <eric.dumazet@gmail.com>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>,
        ast@kernel.org, daniel@iogearbox.net, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Cc:     magnus.karlsson@intel.com, kuba@kernel.org,
        intel-wired-lan@lists.osuosl.org
References: <20200907150217.30888-1-bjorn.topel@gmail.com>
 <20200907150217.30888-5-bjorn.topel@gmail.com>
 <6bbf1793-d2be-b724-eec4-65546d4cbc9c@gmail.com>
From:   =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>
Message-ID: <c5dac6d2-e2aa-05a4-2606-7db0687dd12b@intel.com>
Date:   Tue, 8 Sep 2020 13:49:54 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <6bbf1793-d2be-b724-eec4-65546d4cbc9c@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020-09-08 11:45, Eric Dumazet wrote:
> 
> 
> On 9/7/20 5:02 PM, Björn Töpel wrote:
>> From: Björn Töpel <bjorn.topel@intel.com>
>>
>> Start using XSK_NAPI_WEIGHT as NAPI poll budget for the AF_XDP Rx
>> zero-copy path.
>>
>> Signed-off-by: Björn Töpel <bjorn.topel@intel.com>
>> ---
>>   drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c
>> index 3771857cf887..f32c1ba0d237 100644
>> --- a/drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c
>> +++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c
>> @@ -239,7 +239,7 @@ int ixgbe_clean_rx_irq_zc(struct ixgbe_q_vector *q_vector,
>>   	bool failure = false;
>>   	struct sk_buff *skb;
>>   
>> -	while (likely(total_rx_packets < budget)) {
>> +	while (likely(total_rx_packets < XSK_NAPI_WEIGHT)) {
>>   		union ixgbe_adv_rx_desc *rx_desc;
>>   		struct ixgbe_rx_buffer *bi;
>>   		unsigned int size
> 
> This is a violation of NAPI API. IXGBE is already diverging a bit from best practices.
>

Thanks for having a look, Eric! By diverging from best practices, do
you mean that multiple queues share one NAPI context, and the budget
is split over the queues (say, 4 queues, 64/4 per queue), or that Tx
simply ignores the budget? Or both?

> There are reasons we want to control the budget from callers,
> if you want bigger budget just increase it instead of using your own ?
> 
> I would rather use a generic patch.
>

Hmm, so a configurable NAPI budget for, say, the AF_XDP enabled
queues/NAPIs? Am I reading that correct? (Note that this is *only* for
the AF_XDP enabled queues.)

I'll try to rework this to something more palatable.


Thanks,
Björn


> diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
> index 7bd4fcdd0738a718d8b0f7134523cd87e4dcdb7b..33bcbdb6fef488983438c6584e3cbb0a44febb1a 100644
> --- a/include/linux/netdevice.h
> +++ b/include/linux/netdevice.h
> @@ -2311,11 +2311,14 @@ static inline void *netdev_priv(const struct net_device *dev)
>    */
>   #define SET_NETDEV_DEVTYPE(net, devtype)       ((net)->dev.type = (devtype))
>   
> -/* Default NAPI poll() weight
> - * Device drivers are strongly advised to not use bigger value
> - */
> +/* Default NAPI poll() weight. Highly recommended. */
>   #define NAPI_POLL_WEIGHT 64
>   
> +/* Device drivers are strongly advised to not use bigger value,
> + * as this might cause latencies in stress conditions.
> + */
> +#define NAPI_POLL_WEIGHT_MAX 256
> +
>   /**
>    *     netif_napi_add - initialize a NAPI context
>    *     @dev:  network device
> diff --git a/net/core/dev.c b/net/core/dev.c
> index 4086d335978c1bf62bd3965bd2ea96a4ac06b13d..496713fb6075bd8e5e22725e7c817172858e1dd7 100644
> --- a/net/core/dev.c
> +++ b/net/core/dev.c
> @@ -6608,7 +6608,7 @@ void netif_napi_add(struct net_device *dev, struct napi_struct *napi,
>          INIT_LIST_HEAD(&napi->rx_list);
>          napi->rx_count = 0;
>          napi->poll = poll;
> -       if (weight > NAPI_POLL_WEIGHT)
> +       if (weight > NAPI_POLL_WEIGHT_MAX)
>                  netdev_err_once(dev, "%s() called with weight %d\n", __func__,
>                                  weight);
>          napi->weight = weight;
> 
