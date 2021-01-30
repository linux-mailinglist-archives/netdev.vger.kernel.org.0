Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE6D53097E2
	for <lists+netdev@lfdr.de>; Sat, 30 Jan 2021 20:17:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231923AbhA3TRC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 30 Jan 2021 14:17:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:37566 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232204AbhA3TRA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 30 Jan 2021 14:17:00 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7B41F64E15;
        Sat, 30 Jan 2021 19:16:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612034179;
        bh=yNI/zbRVAZi7i5zFsn4fJE94geSUHpso7ntTBnGczLY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=iqFwsa34f4ivyrjHaQKp5Ux+uq79sDlfi5DnKKMtE4Dez3lFsjVobMXk1s1IXHqtf
         ys72eYfgOTm0XIH251AMP8yEETFP2ueRgeLH/NScZllsrFIneGgwAY/+hT7hmRgwe0
         +IZWjBHYoatfk4woFA3r6ZUaLmjMhVUpK2/YB1S6Wv75vgoK1+RN/FPfd88lCCjI9t
         Ffre2qv1RAbe3AERs+qADlP7yCFeA1EA2i/iPBrYipJ/22PnxAInWPppqhb4Z9+3Nd
         X7C/ndsIvD0SnbLb8ZvplSl7rlD/bqql5mxlz4UG49hrpJKSEoef4NtGCnaF6mGMGT
         PADC2t17CweAQ==
Date:   Sat, 30 Jan 2021 11:16:18 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Xie He <xie.he.0141@gmail.com>
Cc:     Martin Schiller <ms@dev.tdt.de>,
        "David S. Miller" <davem@davemloft.net>,
        Linux X25 <linux-x25@vger.kernel.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Krzysztof Halasa <khc@pm.waw.pl>
Subject: Re: [PATCH net] net: hdlc_x25: Use qdisc to queue outgoing LAPB
 frames
Message-ID: <20210130111618.335b6945@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <CAJht_EPMtn5E-Y312vPQfH2AwDAi+j1OP4zzpg+AUKf46XE1Yw@mail.gmail.com>
References: <20210127090747.364951-1-xie.he.0141@gmail.com>
        <20210128114659.2d81a85f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <CAJht_EOSB-m--Ombr6wLMFq4mPy8UTpsBri2CPsaRTU-aks7Uw@mail.gmail.com>
        <3f67b285671aaa4b7903733455a730e1@dev.tdt.de>
        <20210129173650.7c0b7cda@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <CAJht_EPMtn5E-Y312vPQfH2AwDAi+j1OP4zzpg+AUKf46XE1Yw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 30 Jan 2021 06:29:20 -0800 Xie He wrote:
> On Fri, Jan 29, 2021 at 5:36 PM Jakub Kicinski <kuba@kernel.org> wrote:
> > I'm still struggling to wrap my head around this.
> >
> > Did you test your code with lockdep enabled? Which Qdisc are you using?
> > You're queuing the frames back to the interface they came from - won't
> > that cause locking issues?  
> 
> Hmm... Thanks for bringing this to my attention. I indeed find issues
> when the "noqueue" qdisc is used.
> 
> When using a qdisc other than "noqueue", when sending an skb:
> "__dev_queue_xmit" will call "__dev_xmit_skb";
> "__dev_xmit_skb" will call "qdisc_run_begin" to mark the beginning of
> a qdisc run, and if the qdisc is already running, "qdisc_run_begin"
> will fail, then "__dev_xmit_skb" will just enqueue this skb without
> starting qdisc. There is no problem.
> 
> When using "noqueue" as the qdisc, when sending an skb:
> "__dev_queue_xmit" will try to send this skb directly. Before it does
> that, it will first check "txq->xmit_lock_owner" and will find that
> the current cpu already owns the xmit lock, it will then print a
> warning message "Dead loop on virtual device ..." and drop the skb.
> 
> A solution can be queuing the outgoing L2 frames in this driver first,
> and then using a tasklet to send them to the qdisc TX queue.
> 
> Thanks! I'll make changes to fix this.

Sounds like too much afford for a sub-optimal workaround.
The qdisc semantics are borken in the proposed scheme (double 
counting packets) - both in term of statistics and if user decides 
to add a policer, filter etc.

Another worry is that something may just inject a packet with
skb->protocol == ETH_P_HDLC but unexpected structure (IDK if 
that's a real concern).

It may be better to teach LAPB to stop / start the internal queue. 
The lower level drivers just needs to call LAPB instead of making 
the start/wake calls directly to the stack, and LAPB can call the 
stack. Would that not work?
