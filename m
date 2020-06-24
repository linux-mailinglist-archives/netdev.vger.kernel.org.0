Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E029D207938
	for <lists+netdev@lfdr.de>; Wed, 24 Jun 2020 18:32:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405172AbgFXQc0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jun 2020 12:32:26 -0400
Received: from mga14.intel.com ([192.55.52.115]:4058 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2405107AbgFXQcY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 24 Jun 2020 12:32:24 -0400
IronPort-SDR: rZl7Xy7j8kFlLW4NGVVvAzZvnjKDzVHzumQiPKAxDvDMRJU9ktWZKNzqoIFOSXM82tL+d159A5
 Z9lO2KFf3gpw==
X-IronPort-AV: E=McAfee;i="6000,8403,9662"; a="143635359"
X-IronPort-AV: E=Sophos;i="5.75,276,1589266800"; 
   d="scan'208";a="143635359"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jun 2020 09:32:22 -0700
IronPort-SDR: s00+NRtZ0NPWmDjhtzqHJY8HqtYbM1o4ulSR0bl9+Q8Ul1Jt+woSwlAfZIqqLOzN0wf3E15ALa
 p2rK/8fbGvEg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,276,1589266800"; 
   d="scan'208";a="263681386"
Received: from vsave-mobl.amr.corp.intel.com (HELO [10.251.3.18]) ([10.251.3.18])
  by fmsmga007.fm.intel.com with ESMTP; 24 Jun 2020 09:32:22 -0700
Subject: Re: [PATCH] fs/epoll: Enable non-blocking busypoll with epoll timeout
 of 0
From:   "Samudrala, Sridhar" <sridhar.samudrala@intel.com>
To:     viro@zeniv.linux.org.uk, linux-fsdevel@vger.kernel.org,
        netdev@vger.kernel.org,
        "davem@davemloft.net" <davem@davemloft.net>, eric.dumazet@gmail.com
References: <1592590409-35439-1-git-send-email-sridhar.samudrala@intel.com>
Message-ID: <de6bf72d-d4fd-9a62-c082-c82179d1f4fe@intel.com>
Date:   Wed, 24 Jun 2020 09:32:22 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <1592590409-35439-1-git-send-email-sridhar.samudrala@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Adding Dave, Eric for review and see if we can get this in via net-next
as this is mainly useful for networking workloads doing busypoll.

Thanks
Sridhar

On 6/19/2020 11:13 AM, Sridhar Samudrala wrote:
> This patch triggers non-blocking busy poll when busy_poll is enabled and
> epoll is called with a timeout of 0 and is associated with a napi_id.
> This enables an app thread to go through napi poll routine once by calling
> epoll with a 0 timeout.
> 
> poll/select with a 0 timeout behave in a similar manner.
> 
> Signed-off-by: Sridhar Samudrala <sridhar.samudrala@intel.com>
> ---
>   fs/eventpoll.c | 13 +++++++++++++
>   1 file changed, 13 insertions(+)
> 
> diff --git a/fs/eventpoll.c b/fs/eventpoll.c
> index 12eebcdea9c8..5f55078d6381 100644
> --- a/fs/eventpoll.c
> +++ b/fs/eventpoll.c
> @@ -1847,6 +1847,19 @@ static int ep_poll(struct eventpoll *ep, struct epoll_event __user *events,
>   		eavail = ep_events_available(ep);
>   		write_unlock_irq(&ep->lock);
>   
> +		/*
> +		 * Trigger non-blocking busy poll if timeout is 0 and there are
> +		 * no events available. Passing timed_out(1) to ep_busy_loop
> +		 * will make sure that busy polling is triggered only once and
> +		 * only if sysctl.net.core.busy_poll is set to non-zero value.
> +		 */
> +		if (!eavail) {
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
