Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 40ED12161A0
	for <lists+netdev@lfdr.de>; Tue,  7 Jul 2020 00:33:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727098AbgGFWdX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jul 2020 18:33:23 -0400
Received: from mga17.intel.com ([192.55.52.151]:51171 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726681AbgGFWdX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 6 Jul 2020 18:33:23 -0400
IronPort-SDR: ED6k71xbTz0tJ2NTUnlXEbYk51lKA7HnfVHArZobUZEP0fBM7AWwznDPZKDZW0Z6Ot01/Ak071
 WIDSQ7xfdcxA==
X-IronPort-AV: E=McAfee;i="6000,8403,9674"; a="127597285"
X-IronPort-AV: E=Sophos;i="5.75,321,1589266800"; 
   d="scan'208";a="127597285"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jul 2020 15:33:22 -0700
IronPort-SDR: twogQtfDC7AX5Kb3BD40ataoXLmSbntyt9rV7dpTVQse1IryPSOpLS4jpEsuYTAkBjgMTefek3
 9hkCMTePuX/g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,321,1589266800"; 
   d="scan'208";a="283186355"
Received: from samudral-mobl.amr.corp.intel.com (HELO [10.209.94.16]) ([10.209.94.16])
  by orsmga006.jf.intel.com with ESMTP; 06 Jul 2020 15:33:22 -0700
Subject: Re: [PATCH v2] fs/epoll: Enable non-blocking busypoll when epoll
 timeout is 0
To:     Alexander Duyck <alexander.duyck@gmail.com>
Cc:     linux-fsdevel@vger.kernel.org, Netdev <netdev@vger.kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        David Miller <davem@davemloft.net>
References: <1593027056-43779-1-git-send-email-sridhar.samudrala@intel.com>
 <CAKgT0UdD2cyikv8WgCoZSsHsxsbLm0-KZ9SxatbgEfgbb3z-FQ@mail.gmail.com>
From:   "Samudrala, Sridhar" <sridhar.samudrala@intel.com>
Message-ID: <e0a75c17-cc87-641d-50b3-0375be844a4b@intel.com>
Date:   Mon, 6 Jul 2020 15:33:21 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <CAKgT0UdD2cyikv8WgCoZSsHsxsbLm0-KZ9SxatbgEfgbb3z-FQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/6/2020 1:36 PM, Alexander Duyck wrote:
> On Wed, Jun 24, 2020 at 4:03 PM Sridhar Samudrala
> <sridhar.samudrala@intel.com> wrote:
>>
>> This patch triggers non-blocking busy poll when busy_poll is enabled,
>> epoll is called with a timeout of 0 and is associated with a napi_id.
>> This enables an app thread to go through napi poll routine once by
>> calling epoll with a 0 timeout.
>>
>> poll/select with a 0 timeout behave in a similar manner.
>>
>> Signed-off-by: Sridhar Samudrala <sridhar.samudrala@intel.com>
>>
>> v2:
>> Added net_busy_loop_on() check (Eric)
>>
>> ---
>>   fs/eventpoll.c | 13 +++++++++++++
>>   1 file changed, 13 insertions(+)
>>
>> diff --git a/fs/eventpoll.c b/fs/eventpoll.c
>> index 12eebcdea9c8..c33cc98d3848 100644
>> --- a/fs/eventpoll.c
>> +++ b/fs/eventpoll.c
>> @@ -1847,6 +1847,19 @@ static int ep_poll(struct eventpoll *ep, struct epoll_event __user *events,
>>                  eavail = ep_events_available(ep);
>>                  write_unlock_irq(&ep->lock);
>>
>> +               /*
>> +                * Trigger non-blocking busy poll if timeout is 0 and there are
>> +                * no events available. Passing timed_out(1) to ep_busy_loop
>> +                * will make sure that busy polling is triggered only once.
>> +                */
>> +               if (!eavail && net_busy_loop_on()) {
>> +                       ep_busy_loop(ep, timed_out);
>> +                       write_lock_irq(&ep->lock);
>> +                       eavail = ep_events_available(ep);
>> +                       write_unlock_irq(&ep->lock);
>> +               }
>> +
>>                  goto send_events;
>>          }
> 
> Doesn't this create a scenario where the NAPI ID will not be
> disassociated if the polling fails?
> 
> It seems like in order to keep parity with existing busy poll code you
> should need to check for !eavail after you release the lock and if
> that is true you should be calling ep_reset_busy_poll_napi_id so that
> you disassociate the NAPI ID from the eventpoll.

We are not going to sleep in this code path. I think napi id needs to be 
reset only if we are going to sleep and a wakeup is expected to set the 
nap_id again.
