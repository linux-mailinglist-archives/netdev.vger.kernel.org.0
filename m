Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8883C394A34
	for <lists+netdev@lfdr.de>; Sat, 29 May 2021 06:11:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229636AbhE2EMl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 29 May 2021 00:12:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:40704 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229620AbhE2EMh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 29 May 2021 00:12:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C2010613DD;
        Sat, 29 May 2021 04:11:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622261462;
        bh=lQF3+h/YchI0Tvlu6FIhjdyBBAl4V/K5NaGngICaNeY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ThMl5gvaeOamZvWhz1/0kWtSATmcdn+2jZrjk3red7q/53PG0jDUbrbJDmYHcNYhb
         24Sq+xhMNvmVWqPJ5/pdK6lcuidMBFhhiJ7nwHw8YVEbvcYFSqBWup1tCrz+GkQ2jy
         LkfgKNNB+QzF46D186tX9dsWoJXZhGyK7XYPx4KFdA2vE3OlGtXvndRGtuij0fyRWU
         jMBf7a12/0uE63I4H/n2cHreE9K6nnhx4rpnMREMq5td7piK4q2CMkvp0Cwll1RGg7
         ARWHacTK8AHd5anV+C2UdflsjPpBkTnRin7ynWDQXZYNHdypLPmoWuTdgmMa5vcEiD
         +T0mWtl6kZwnw==
Date:   Fri, 28 May 2021 21:11:00 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Michael Chan <michael.chan@broadcom.com>
Cc:     David Miller <davem@davemloft.net>,
        Netdev <netdev@vger.kernel.org>,
        Andrew Gospodarek <gospo@broadcom.com>,
        richardcochran@gmail.com, Pavan Chebbi <pavan.chebbi@broadcom.com>,
        Edwin Peer <edwin.peer@broadcom.com>
Subject: Re: [PATCH net-next 5/7] bnxt_en: Get the RX packet timestamp.
Message-ID: <20210528211100.70cd916f@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <CACKFLi=0fq26Su6wBwEG-8bhPuEU0JB7O=mUtZ=01KLKOyYxsg@mail.gmail.com>
References: <1622249601-7106-1-git-send-email-michael.chan@broadcom.com>
        <1622249601-7106-6-git-send-email-michael.chan@broadcom.com>
        <20210528183908.3c84bff4@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
        <CACKFLi=0fq26Su6wBwEG-8bhPuEU0JB7O=mUtZ=01KLKOyYxsg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 28 May 2021 19:31:30 -0700 Michael Chan wrote:
> On Fri, May 28, 2021 at 6:39 PM Jakub Kicinski <kuba@kernel.org> wrote:
> > On Fri, 28 May 2021 20:53:19 -0400 Michael Chan wrote:  
> > > +     struct bnxt_ptp_cfg *ptp = bp->ptp_cfg;
> > > +     u64 time;
> > > +
> > > +     if (!ptp)
> > > +             return -ENODEV;
> > > +
> > > +     time = READ_ONCE(ptp->old_time);  
> >
> > READ_ONCE() on a u64? That's not gonna prevent tearing the read on 32
> > bit architectures, right?  
> 
> Right, we should add a conditional lock for 32-bit architectures.

Or only store the top 32 bit of the full counter. I don't think you 
need the bottom 16.

> > > +     *ts = (time & BNXT_HI_TIMER_MASK) | pkt_ts;
> > > +     if (pkt_ts < (time & BNXT_LO_TIMER_MASK))
> > > +             *ts += BNXT_LO_TIMER_MASK + 1;  
> >
> > The stamp is from the MAC, I hope, or otherwise packet which could have
> > been sitting on the ring for some approximation of eternity. You can
> > easily see a packet stamp older than the value stashed in ptp->old_time
> > if you run soon after the refresh.  
> 
> The hardware returns the low 32-bit timestamp of the packet.
> ptp->old_time contains the full 48-bit of the time counter that we
> sample periodically.  We're getting the upper 16-bit from
> ptp->old_time to form the complete timestamp for the packet.
> ptp->old_time is between 1 and 2 sampling periods before the current
> time.  The sampling period should be 1 second.
> 
> Yeah, if the RX packet is older than 1 to 2 seconds, the upper part
> can potentially be wrong if it has wrapped around.

Ah, you're comparing to the previous sample, I see.
