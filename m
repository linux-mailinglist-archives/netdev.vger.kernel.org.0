Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4112D624FA5
	for <lists+netdev@lfdr.de>; Fri, 11 Nov 2022 02:35:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231586AbiKKBfz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Nov 2022 20:35:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232700AbiKKBfx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Nov 2022 20:35:53 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BE9758027;
        Thu, 10 Nov 2022 17:35:52 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A4A99B823D8;
        Fri, 11 Nov 2022 01:35:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A7CCC433B5;
        Fri, 11 Nov 2022 01:35:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668130549;
        bh=6L/0mnPwwA9ecxdinj4fNf+bVxwfnZgIcrejeymF+6Q=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=mOFq1wowsoLEcWZC+F1ia/3+QTyiVs8OkTcnfjYOh7Ilk2oZ+imMpTF5HvMoUl+AD
         osBDH+SjxH6eFzRu1tyLW5GOJglUvnQ7ag/O2YV/ZgxnvKvamtGe4qzfEVZ6gORnBL
         8mUas3CgyJ+ybbfZu+l4y+XSlB6hEjcLP2+uoSiD998oPXjd/68tzuFTpOMnK/j/Z8
         jLfxfuXAmOHz53RyF9ubw6XvciJJ4VfZDYShraX1pg/sg0G8sRdHx8KIFBDEiOGj4v
         v16+cQZ1YPzQoSvrc4NVPnJ3OBQizSOzALYuLjbdIOl1aHjovU3zekr6gifSNbb/h7
         Ahca24rTnvPEA==
Date:   Thu, 10 Nov 2022 17:35:48 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Stefan Roesch <shr@devkernel.io>
Cc:     kernel-team@fb.com, axboe@kernel.dk, olivier@trillion01.com,
        netdev@vger.kernel.org, io-uring@vger.kernel.org
Subject: Re: [RFC PATCH v2 1/2] io_uring: add napi busy polling support
Message-ID: <20221110173548.3d978dea@kernel.org>
In-Reply-To: <qvqweduae55u.fsf@dev0134.prn3.facebook.com>
References: <20221107175240.2725952-1-shr@devkernel.io>
        <20221107175240.2725952-2-shr@devkernel.io>
        <20221108165659.59d6f6b1@kernel.org>
        <qvqweduae55u.fsf@dev0134.prn3.facebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 10 Nov 2022 15:36:34 -0800 Stefan Roesch wrote:
> Jakub Kicinski <kuba@kernel.org> writes:
> > On Mon,  7 Nov 2022 09:52:39 -0800 Stefan Roesch wrote:  
> >> This adds the napi busy polling support in io_uring.c. It adds a new
> >> napi_list to the io_ring_ctx structure. This list contains the list of
> >> napi_id's that are currently enabled for busy polling. The list is
> >> synchronized by the new napi_lock spin lock. The current default napi
> >> busy polling time is stored in napi_busy_poll_to. If napi busy polling
> >> is not enabled, the value is 0.
> >>
> >> The busy poll timeout is also stored as part of the io_wait_queue. This
> >> is necessary as for sq polling the poll interval needs to be adjusted
> >> and the napi callback allows only to pass in one value.
> >>
> >> Testing has shown that the round-trip times are reduced to 38us from
> >> 55us by enabling napi busy polling with a busy poll timeout of 100us.  
> >
> > What's the test, exactly? What's the network latency? Did you busy poll
> > on both ends?
> 
> The test programs are part of the liburing patches. They consist of a
> client and server program. The client sends a request, which has a timestamp
> in its payload and the server replies with the same payload. The client
> calculates the roundtrip time and stores it to calcualte the results.
> 
> The client is running on host1 and the server is running on host 2. The
> measured times below are roundtrip times. These are average times over
> 10 runs each.
> 
> If no napi busy polling wait is used                 : 55us
> If napi with client busy polling is used             : 44us
> If napi busy polling is used on the client and server: 38us
> 
> If you think the numbers are not that useful, I can remove them from the
> commit message.

The latency numbers are a sum of a few components so you'd need to break
them down a little further. At least for me. I'd anticipate we'll have
networking delay, IRQ/completion coalescing in the NIC, and then SW
processing time. 

I was suspecting you were only busy polling on one end, because the
38us is very close to the default IRQ coalescing "we" have (33us).

Simplest way to provide a clear number would be to test with IRQ coal
set to 0/1, and back-to-back machines (or within a rack).
If that's what you did then just add the info to the msg and the
numbers are good :)

> >> +	list_for_each_entry_safe(ne, n, napi_list, list) {
> >> +		napi_busy_loop(ne->napi_id, NULL, NULL, true, BUSY_POLL_BUDGET);  
> >
> > You can't opt the user into prefer busy poll without the user asking
> > for it. Default to false and add an explicit knob like patch 2.
> >  
> 
> The above code is from the function io_napi_blocking_busy_loop().
> However this function is only called when a busy poll timeout has been
> configured.
> 
> #ifdef CONFIG_NET_RX_BUSY_POLL
>          if (iowq.busy_poll_to)
>                  io_napi_blocking_busy_loop(&local_napi_list, &iowq);
> 
> However we don't have that check for sqpoll, so we should add a check
> for the napi busy poll timeout in __io_sq_thread.
> 
> Do we really need a knob to store if napi busy polling is enabled or is
> sufficent to store a napi busy poll timeout value?

I was asking about *prefer* busy poll, IOW SO_PREFER_BUSY_POLL.
So I'm talking about argument 4 being set to true. 
This feature requires system configuration to arm timers to the correct
values within the netdev code. Normal epoll path always passes false
there, IIRC. We can add the support in iouring but we need an opt-in.
