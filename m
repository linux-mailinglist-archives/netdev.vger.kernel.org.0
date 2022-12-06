Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C09B2644D6B
	for <lists+netdev@lfdr.de>; Tue,  6 Dec 2022 21:43:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229612AbiLFUns (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Dec 2022 15:43:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229511AbiLFUnr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Dec 2022 15:43:47 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BE3443851;
        Tue,  6 Dec 2022 12:43:47 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 62FB9CE1ADE;
        Tue,  6 Dec 2022 20:43:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50695C433D6;
        Tue,  6 Dec 2022 20:43:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670359423;
        bh=nakWPfl/JPzwhzckIxUS+kQsv0RDMmrnqYA8gUFyCTU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=BuO9tr0vZz7M2wK6L/5GF4fw5fBLo6XuXDKMiR57OmTVRZBjcVnBZBvbSuEJyHHsB
         yGqilZlLOvnL+mutjQ+vcsHgY3nMHcYGjYAMJZkSERm1BhaAXos5cZkR01zcjYJyMg
         EvsWl02E/vMK6KYMP47pa/HxNNkX23SzewQZ1lS65voS6xP8XIZCUns+4i5XXhEqj8
         TKqXTwrtFLpU/YyDMAcY+tBtG8Cfvu0qXgsX6QjUjD/nkN4dijI0k2VisJVZNb9DuQ
         JXtaC97t0YjNy0mhNceK1zC6DhNvkTCgkGElSyAYXl4VFjdjOADHzUNY7RUYJdg8zJ
         ga7VKJM0FBLYQ==
Date:   Tue, 6 Dec 2022 12:43:42 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Justin Iurman <justin.iurman@uliege.be>
Cc:     Eric Dumazet <edumazet@google.com>, netdev@vger.kernel.org,
        davem@davemloft.net, yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        pabeni@redhat.com, stable@vger.kernel.org
Subject: Re: [RFC net] Fixes: b63c5478e9cb ("ipv6: ioam: Support for Queue
 depth data field")
Message-ID: <20221206124342.7f429399@kernel.org>
In-Reply-To: <d579c817-50c7-5bd5-4b28-f044daabf7f6@uliege.be>
References: <20221205153557.28549-1-justin.iurman@uliege.be>
        <CANn89iLjGnyh0GgW_5kkMQJBCi-KfgwyvZwT1ou2FMY4ZDcMXw@mail.gmail.com>
        <CANn89iK3hMpJQ1w4peg2g35W+Oi3t499C5rUv7rcwzYtxDGBuw@mail.gmail.com>
        <a8dcb88c-16be-058b-b890-5d479d22c8a8@uliege.be>
        <CANn89iKgeVFRAstW3QRwOdn8SV_EbHqcKYqmoWT6m5nGQwPWUg@mail.gmail.com>
        <d579c817-50c7-5bd5-4b28-f044daabf7f6@uliege.be>
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

On Mon, 5 Dec 2022 21:44:09 +0100 Justin Iurman wrote:
> > Please revert this patch.
> > 
> > Many people use FQ qdisc, where packets are waiting for their Earliest
> > Departure Time to be released.  
> 
> The IOAM queue depth is a very important value and is already used.

Can you say more about the use? What signal do you derive from it?
I do track qlen on Meta's servers but haven't found a strong use 
for it yet (I did for backlog drops but not the qlen itself).

> > Also, the draft says:
> > 
> > 5.4.2.7.  queue depth
> > 
> >     The "queue depth" field is a 4-octet unsigned integer field.  This
> >     field indicates the current length of the egress interface queue of
> >     the interface from where the packet is forwarded out.  The queue
> >     depth is expressed as the current amount of memory buffers used by
> >     the queue (a packet could consume one or more memory buffers,
> >     depending on its size).
> > 
> >      0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1
> >     +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
> >     |                       queue depth                             |
> >     +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
> > 
> > 
> > It is relatively clear that the egress interface is the aggregate
> > egress interface,
> > not a subset of the interface.  
> 
> Correct, even though the definition of an interface in RFC 9197 is quite 
> abstract (see the end of section 4.4.2.2: "[...] could represent a 
> physical interface, a virtual or logical interface, or even a queue").
> 
> > If you have 32 TX queues on a NIC, all of them being backlogged (line rate),
> > sensing the queue length of one of the queues would give a 97% error
> > on the measure.  
> 
> Why would it? Not sure I get your idea based on that example.

Because it measures the length of a single queue not the device.
