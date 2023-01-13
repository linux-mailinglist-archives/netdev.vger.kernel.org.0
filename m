Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 52F8566881B
	for <lists+netdev@lfdr.de>; Fri, 13 Jan 2023 01:09:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229976AbjAMAJK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Jan 2023 19:09:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232708AbjAMAJH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Jan 2023 19:09:07 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90F7C40848
        for <netdev@vger.kernel.org>; Thu, 12 Jan 2023 16:09:05 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id D44C1CE1EF3
        for <netdev@vger.kernel.org>; Fri, 13 Jan 2023 00:09:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4E76C433EF;
        Fri, 13 Jan 2023 00:09:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673568542;
        bh=aIlW1HbwoeeRgiUHNLsa+JPHrvzQVzl90//RJ6b0tRs=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=AsgcGCMfd+mfOVI8cFvHCsqehZWPinSVpD9a//Z3GU8Tn2S1wxXenNif6dzhaV/T8
         hoaXtUa/u3kuFQmWdYQx1EBZAmDXf3TDIZWkVhpFVlIfh8s/I3/fypTyLxrjAmjEVb
         iFDuaa61IWI1CLQrS62r146wsEXRcBiuNR/IfG2sjuFI5cjHtpBDyS9zCwjKBDJPkO
         DHcO8EFkWRh+CUzoeMZiURgtiYMixW5jwYnA/8iRb4UScRWNa9Vf8nn+//7vBPviXk
         XeLSZGKp1FEdnLgmyX2GS8xeBoHo+h/0sdYHhuc+zohj77eLJEOqhacIOnyN1xeW11
         hFMQ373O5NjDQ==
Date:   Thu, 12 Jan 2023 16:09:00 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jeremy Harris <jeharris@redhat.com>
Cc:     netdev@vger.kernel.org
Subject: Re: [RFC PATCH net-next 0/7] NIC driver Rx ring ECN
Message-ID: <20230112160900.5fdb5b20@kernel.org>
In-Reply-To: <2ff79a56-bf32-731b-a6ab-94654b8a3b31@redhat.com>
References: <20230111143427.1127174-1-jgh@redhat.com>
        <20230111104618.74022e83@kernel.org>
        <2ff79a56-bf32-731b-a6ab-94654b8a3b31@redhat.com>
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

On Thu, 12 Jan 2023 14:06:50 +0000 Jeremy Harris wrote:
> On 11/01/2023 18:46, Jakub Kicinski wrote:
> > Do you have any reason to believe that it actually helps anything?  
> 
> I've not measured actual drop-rates, no.
> 
> > NAPI with typical budget of 64 is easily exhausted (you just need
> > two TSO frames arriving at once with 1500 MTU).  
> 
> I see typical systems with 300, not 64

Say more? I thought you were going by NAPI budget which should be 64
in bnx2x.

> - but it's a valid point.
> It's not the right measurement to try to control.
> Perhaps I should work harder to locate the ring size within
> the bnx2 and bnx2x drivers.

Perhaps the older devices give you some extra information here.
Normally on the Rx path you don't know how long the queue is,
you just check whether the next descriptor has been filled or not.
"Looking ahead" may be costly because you're accessing the same 
memory as the device.

> If I managed that (it being already the case for the xgene example)
> would your opinions change?

It may be cool if we can retrofit some second-order signal into 
the time-based machinery. The problem is that we don't actually 
have any time-based machinery upstream, yet :(
And designing interfaces for a decade-old HW seems shortsighted.

> > Host level congestion is better detected using time / latency signals.
> > Timestamp the packet at the NIC and compare the Rx time to current time
> > when processing by the driver.
> > 
> > Google search "Google Swift congestion control".  
> 
> Nice, but
> - requires we wait for timestamping-NICs

Grep for HWTSTAMP_FILTER_ALL, there's HW out there.

> - does not address Rx drops due to Rx ring-buffer overflow

It's a stronger signal than "continuous run of packets".
You can have a standing queue of 2 packets, and keep processing 
for ever. There's no congestion, or overload. You'd see that 
timestamps are recent.

I experimented last year with implementing CoDel on the input queues,
worked pretty well (scroll down ~half way):

https://developers.facebook.com/blog/post/2022/04/25/investigating-tcp-self-throttling-triggered-overload/
