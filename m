Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 89C63215FA6
	for <lists+netdev@lfdr.de>; Mon,  6 Jul 2020 21:50:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726694AbgGFTuT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jul 2020 15:50:19 -0400
Received: from mga03.intel.com ([134.134.136.65]:10736 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725860AbgGFTuS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 6 Jul 2020 15:50:18 -0400
IronPort-SDR: UlDEFaIY3GXC6+sUE5l63N2iljwM81ot3OZEswJOREdzdeOlkwIsZnsy5dHBhWzKNhqGjzWlF+
 nBIloTSL31bw==
X-IronPort-AV: E=McAfee;i="6000,8403,9674"; a="147505977"
X-IronPort-AV: E=Sophos;i="5.75,321,1589266800"; 
   d="scan'208";a="147505977"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jul 2020 12:50:17 -0700
IronPort-SDR: +N5rseYLr1lDYqNiavH5byDprej7NlY1eO23n7foN6n5v6JsR7zGvoqK5DXeqg6nR286oKwEq2
 3Os5u94KVYlQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,321,1589266800"; 
   d="scan'208";a="483246170"
Received: from samudral-mobl.amr.corp.intel.com (HELO [10.255.228.177]) ([10.255.228.177])
  by fmsmga005.fm.intel.com with ESMTP; 06 Jul 2020 12:50:16 -0700
Subject: Re: [PATCH v2] fs/epoll: Enable non-blocking busypoll when epoll
 timeout is 0
From:   "Samudrala, Sridhar" <sridhar.samudrala@intel.com>
To:     linux-fsdevel@vger.kernel.org, netdev@vger.kernel.org,
        eric.dumazet@gmail.com, davem@davemloft.net,
        viro@zeniv.linux.org.uk
References: <1593027056-43779-1-git-send-email-sridhar.samudrala@intel.com>
Message-ID: <f7126487-71fc-ff8d-939a-d29316cda8e1@intel.com>
Date:   Mon, 6 Jul 2020 12:50:16 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <1593027056-43779-1-git-send-email-sridhar.samudrala@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Resending.

Dave, Eric,

Can we get this in via net-next as this is targeted for networking use 
case using epoll/busypoll.

Thanks
Sridhar

On 6/24/2020 12:30 PM, Sridhar Samudrala wrote:
> This patch triggers non-blocking busy poll when busy_poll is enabled,
> epoll is called with a timeout of 0 and is associated with a napi_id.
> This enables an app thread to go through napi poll routine once by
> calling epoll with a 0 timeout.
> 
> poll/select with a 0 timeout behave in a similar manner.
> 
> Signed-off-by: Sridhar Samudrala <sridhar.samudrala@intel.com>
> 
> v2:
> Added net_busy_loop_on() check (Eric)
> 
> ---
>   fs/eventpoll.c | 13 +++++++++++++
>   1 file changed, 13 insertions(+)
> 
> diff --git a/fs/eventpoll.c b/fs/eventpoll.c
> index 12eebcdea9c8..c33cc98d3848 100644
> --- a/fs/eventpoll.c
> +++ b/fs/eventpoll.c
> @@ -1847,6 +1847,19 @@ static int ep_poll(struct eventpoll *ep, struct epoll_event __user *events,
>   		eavail = ep_events_available(ep);
>   		write_unlock_irq(&ep->lock);
>   
> +		/*
> +		 * Trigger non-blocking busy poll if timeout is 0 and there are
> +		 * no events available. Passing timed_out(1) to ep_busy_loop
> +		 * will make sure that busy polling is triggered only once.
> +		 */
> +		if (!eavail && net_busy_loop_on()) {
> +			ep_busy_loop(ep, timed_out);
> +			write_lock_irq(&ep->lock);
> +			eavail = ep_events_available(ep);
> +			write_unlock_irq(&ep->lock);
> +		}
> +
>   		goto send_events;
>   	}
>   
> 
