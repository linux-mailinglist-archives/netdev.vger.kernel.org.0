Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D4EA0247B0
	for <lists+netdev@lfdr.de>; Tue, 21 May 2019 07:54:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726252AbfEUFyc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 May 2019 01:54:32 -0400
Received: from mx1.redhat.com ([209.132.183.28]:36802 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725794AbfEUFyc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 21 May 2019 01:54:32 -0400
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 17A85C057E9F;
        Tue, 21 May 2019 05:54:32 +0000 (UTC)
Received: from [10.72.12.36] (ovpn-12-36.pek2.redhat.com [10.72.12.36])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 43FD51001F5B;
        Tue, 21 May 2019 05:54:27 +0000 (UTC)
Subject: Re: [PATCH v2 net 2/2] net: core: generic XDP support for stacked
 device
To:     Stephen Hemminger <stephen@networkplumber.org>,
        Jiri Pirko <jiri@resnulli.us>
Cc:     netdev@vger.kernel.org, davem@davemloft.net,
        xdp-newbies@vger.kernel.org, bpf@vger.kernel.org,
        Stephen Hemminger <sthemmin@microsoft.com>
References: <20190519031046.4049-1-sthemmin@microsoft.com>
 <20190519031046.4049-3-sthemmin@microsoft.com>
 <20190520091105.GA2142@nanopsycho> <20190520085340.4f44ac8b@hermes.lan>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <2abc3bd0-dccb-9885-b152-ef144ad12f29@redhat.com>
Date:   Tue, 21 May 2019 13:54:26 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190520085340.4f44ac8b@hermes.lan>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.32]); Tue, 21 May 2019 05:54:32 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2019/5/20 下午11:53, Stephen Hemminger wrote:
> On Mon, 20 May 2019 11:11:05 +0200
> Jiri Pirko <jiri@resnulli.us> wrote:
>
>> Sun, May 19, 2019 at 05:10:46AM CEST, stephen@networkplumber.org wrote:
>>> When a device is stacked like (team, bonding, failsafe or netvsc) the
>>> XDP generic program for the parent device is not called.  In these
>>> cases, the rx handler changes skb->dev to its own in the receive
>>> handler, and returns RX_HANDLER_ANOTHER.  Fix this by calling
>>> do_xdp_generic if necessary before starting another round.
>>>
>>> Review of all the places RX_HANDLER_ANOTHER is returned
>>> show that the current devices do correctly change skb->dev.
>>>
>>> There was an older patch that got abandoned that did the
>>> same thing, this is just a rewrite.
>>>
>>> Suggested-by: Jason Wang <jasowang@redhat.com>
>>> Fixes: d445516966dc ("net: xdp: support xdp generic on virtual devices")
>>> Signed-off-by: Stephen Hemminger <sthemmin@microsoft.com>
>>> Acked-by: Jason Wang <jasowang@redhat.com>
>>> ---
>> I'm always scarred of changes like this. The history tells us that this
>> codepaths are very fragile. It took us non-trivial efford to fix bonding
>> here, not to mention vlans (that was pain).
>>
>> The reason for troubles was often fact that different flows were treated
>> differently (vlan accel/non-accel).
> Yes, this is a sensitive path. Another alternative is to fix it
> inside each device (netvsc). That is what my earlier patch did and that
> is what is being done now (probably will make it into the RHEL on Azure
> drivers).
>   
>> This patch calls do_xdp_generic for master device in different point in
>> the receive patch comparing to lower device. Would it be possible to
>> unify this? E.g. by moving do_xdp_generice() call from
>> netif_rx_internal()/netif_receive_skb_internal() here,
>> to the beginning of __netif_receive_skb_core()?
>>
> That could work, but has the question about doing XDP farther down
> call stack (lower performance).
>
> There is also the case what if both paths support XDP in driver.
> This would be the ideal case, how would this work?
>
>

I think we have a clear request of allowing native XDP to work on 
stacked device. We're missing some generic building blocks (like XDP rx 
handler) here.

Thanks


