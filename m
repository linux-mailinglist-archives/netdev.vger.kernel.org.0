Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 232F640B677
	for <lists+netdev@lfdr.de>; Tue, 14 Sep 2021 20:03:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230012AbhINSEg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Sep 2021 14:04:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:48400 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229526AbhINSEe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 14 Sep 2021 14:04:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 07E106109E;
        Tue, 14 Sep 2021 18:03:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631642597;
        bh=nzELtPlyvwLTBG+56RGpEyyw/l4ak9OiKvwJpkVJ98I=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=FHjaegV9OkeFI/33PEiI0G7k2qcUuFz4qvHUr5KbHmtCzrO01r1IknojfvszPPYxj
         3iz5dok9m0xhiejnNlbHZOCEJLKbG33+MbYosi6tmFc/LJwzEuQd58rNha1XaUaiPF
         EOGCLS0sblsbYr/FQXcY9FTADMv7pBWzgIbyc7Lo0q8ZChomCgMYYi4D3xYnVwIdME
         tvPwnbZL9syM51BkpHahNMXPXtpBKfQAM8jO9OFbv8SyO6ZNY+Ui2RPOMe2u/abqRl
         0p9gEOK5issHqMH3XCXbRUDpMH04EU+w30Yl8VgWMaUWkvLAeYyoS/RTSYAvMXUY9L
         28QXdYzEFU6ow==
Date:   Tue, 14 Sep 2021 11:03:15 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     willemb@google.com, netdev@vger.kernel.org
Subject: Re: [RFC net] net: stream: don't purge sk_error_queue without
 holding its lock
Message-ID: <20210914110315.32ebccce@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <8ce5b709-17bb-ea01-48b4-b80447fb5d3f@gmail.com>
References: <20210913223850.660578-1-kuba@kernel.org>
        <3b5549a2-cb0e-0dc1-3cb3-00d15a74873b@gmail.com>
        <20210914071836.46813650@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <c945d4ee-591c-7c38-8322-3fb9db0f104f@gmail.com>
        <20210914095621.5fa08637@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <8ce5b709-17bb-ea01-48b4-b80447fb5d3f@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 14 Sep 2021 10:55:49 -0700 Eric Dumazet wrote:
> On 9/14/21 9:56 AM, Jakub Kicinski wrote:
> > Right, but then inet_sock_destruct() also purges the err queue, again.
> > I was afraid of regressions but we could just remove the purging 
> > from sk_stream_kill_queues(), and target net-next?
> >   
> 
> Yes, this would be the safest thing.

Alright, let me do more testing and post a removal to net-next.

> >> If you think there is a bug, it must be fixed in another way.
> >>
> >> IMO, preventing err packets from a prior session being queued after a tcp_disconnect()
> >> is rather hard. We should not even try (packets could be stuck for hours in a qdisc)  
> > 
> > Indeed, we could rearrange the SOCK_DEAD check in sock_queue_err_skb()
> > to skip queuing and put it under the err queue lock (provided we make
> > sk_stream_kill_queues() take that lock as well). But seems like an
> > overkill. I'd lean towards the existing patch or removing the purge from
> > sk_stream_kill_queues(). LMK what you prefer, this is not urgent.
> 
> The issue would really about the tcp_disconnect() case, 
> followed by a reuse of the socket to establish another session.
> 
> In order to prevent polluting sk_error_queue with notifications
> triggered by old packets (from prior flow), this would require
> to record the socket cookie in skb, or something like that :/

Ah, I see what you meant! I'll make a note of the disconnect case 
in the commit message. I just care that we don't corrupt the queue
on close.
