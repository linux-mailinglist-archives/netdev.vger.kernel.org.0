Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D29A1284352
	for <lists+netdev@lfdr.de>; Tue,  6 Oct 2020 02:25:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726337AbgJFAYr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Oct 2020 20:24:47 -0400
Received: from mga14.intel.com ([192.55.52.115]:34643 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725846AbgJFAYr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 5 Oct 2020 20:24:47 -0400
IronPort-SDR: CVzQcgZ6BpnlaOQh6wOzb44jIWf5Fhf/9+c949fbTWT0Vt5+Hf/EYd2+z6qjeyj2Tyxq0DUEsh
 7U4ZPg+11fnA==
X-IronPort-AV: E=McAfee;i="6000,8403,9765"; a="163504455"
X-IronPort-AV: E=Sophos;i="5.77,341,1596524400"; 
   d="scan'208";a="163504455"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga103.fm.intel.com with ESMTP; 05 Oct 2020 17:24:46 -0700
IronPort-SDR: 00AjKOwUKxVMBmYrd3hsVd0p3m2TXdqTspLHzmsGGTBF5KJnxlnT1lqYp+hbVl7bx5jEDHFwbo
 pMCh7jgNDBPA==
X-IronPort-AV: E=Sophos;i="5.77,341,1596524400"; 
   d="scan'208";a="327164068"
Received: from jekeller-mobl1.amr.corp.intel.com (HELO [10.255.65.178]) ([10.255.65.178])
  by orsmga002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Oct 2020 15:14:14 -0700
Subject: Re: [PATCH net-next] net: always dump full packets with skb_dump
To:     Vladimir Oltean <vladimir.oltean@nxp.com>, netdev@vger.kernel.org,
        davem@davemloft.net, kuba@kernel.org
Cc:     willemdebruijn.kernel@gmail.com
References: <20201005144838.851988-1-vladimir.oltean@nxp.com>
From:   Jacob Keller <jacob.e.keller@intel.com>
Organization: Intel Corporation
Message-ID: <bcf0a19d-a8c9-a9a2-7bcf-a97205aa4d05@intel.com>
Date:   Mon, 5 Oct 2020 15:13:54 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.3.1
MIME-Version: 1.0
In-Reply-To: <20201005144838.851988-1-vladimir.oltean@nxp.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 10/5/2020 7:48 AM, Vladimir Oltean wrote:
> Currently skb_dump has a restriction to only dump full packet for the
> first 5 socket buffers, then only headers will be printed. Remove this
> arbitrary and confusing restriction, which is only documented vaguely
> ("up to") in the comments above the prototype.
> 

So, this limitation appeared very clearly in the original commit,
6413139dfc64 ("skbuff: increase verbosity when dumping skb data")..

Searching the netdev list, that patch links back to this one as the
original idea:

https://patchwork.ozlabs.org/project/netdev/patch/20181121021309.6595-2-xiyou.wangcong@gmail.com/

I can't find any further justification on that limit. I suppose the
primary reasoning being if you somehow call this function in a loop this
would avoid dumping the entire packet over and over?

Thanks,
Jake

> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> ---
>  net/core/skbuff.c | 6 +-----
>  1 file changed, 1 insertion(+), 5 deletions(-)
> 
> diff --git a/net/core/skbuff.c b/net/core/skbuff.c
> index e0774471f56d..720076a6e2b1 100644
> --- a/net/core/skbuff.c
> +++ b/net/core/skbuff.c
> @@ -712,11 +712,10 @@ EXPORT_SYMBOL(kfree_skb_list);
>   *
>   * Must only be called from net_ratelimit()-ed paths.
>   *
> - * Dumps up to can_dump_full whole packets if full_pkt, headers otherwise.
> + * Dumps whole packets if full_pkt, only headers otherwise.
>   */
>  void skb_dump(const char *level, const struct sk_buff *skb, bool full_pkt)
>  {
> -	static atomic_t can_dump_full = ATOMIC_INIT(5);
>  	struct skb_shared_info *sh = skb_shinfo(skb);
>  	struct net_device *dev = skb->dev;
>  	struct sock *sk = skb->sk;
> @@ -725,9 +724,6 @@ void skb_dump(const char *level, const struct sk_buff *skb, bool full_pkt)
>  	int headroom, tailroom;
>  	int i, len, seg_len;
>  
> -	if (full_pkt)
> -		full_pkt = atomic_dec_if_positive(&can_dump_full) >= 0;
> -
>  	if (full_pkt)
>  		len = skb->len;
>  	else
> 
