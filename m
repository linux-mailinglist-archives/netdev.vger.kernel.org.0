Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED12E30C653
	for <lists+netdev@lfdr.de>; Tue,  2 Feb 2021 17:46:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236799AbhBBQo3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Feb 2021 11:44:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:33620 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236745AbhBBQmW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 2 Feb 2021 11:42:22 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B1FBB64F64;
        Tue,  2 Feb 2021 16:41:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612284102;
        bh=L71Awcg/HF6WOIMSygGKnyNZDF81guEDZR3Xldfh3NA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=t/lvXoPoVfVH2sMKx9lhcgnIVnDuG8zHsBYJnBELL8MsYb3fYw8jDBY5avGdq6/bF
         iXVk+/LgiRNoAPxO8rOn1PqxfISapICLFR1AdqPH+vW1oQ7Jz0mHy1HYKNUrXfwbLe
         sg/2IxwDzoABo+UlXJu4qcCcIsjC8UVEp3RZip06hSasUCrRG8Xy8CTIgyt2CN17TC
         8xE82v0SkQ0O6vEchROia2UtCKHFyLXf9zLCIqpdvXv62LsfWFD/ShiszEZlJZs5ah
         cn/cNa/RyBM7GJqTSWHWEWrDWeDDGcz0G5vvfn3UqGECINpa3XLEbe23y+CH9/u5fF
         jkTlhB2+8MW9g==
Date:   Tue, 2 Feb 2021 08:41:40 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Xie He <xie.he.0141@gmail.com>
Cc:     Julian Wiedmann <jwi@linux.ibm.com>,
        "David S. Miller" <davem@davemloft.net>,
        Linux X25 <linux-x25@vger.kernel.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Martin Schiller <ms@dev.tdt.de>
Subject: Re: [PATCH net] net: lapb: Copy the skb before sending a packet
Message-ID: <20210202084140.642a9cc1@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <CAJht_ENcz1A+C8=tJ_wP8kQby4OuyWirJC+c+-ngg5D54dpHNg@mail.gmail.com>
References: <20210201055706.415842-1-xie.he.0141@gmail.com>
        <4d1988d9-6439-ae37-697c-d2b970450498@linux.ibm.com>
        <CAJht_EOw4d9h7LqOsXpucADV5=gAGws-fKj5q7BdH2+h0Yv9Vg@mail.gmail.com>
        <20210201204224.4872ce23@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <CAJht_ENcz1A+C8=tJ_wP8kQby4OuyWirJC+c+-ngg5D54dpHNg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 1 Feb 2021 22:25:17 -0800 Xie He wrote:
> On Mon, Feb 1, 2021 at 8:42 PM Jakub Kicinski <kuba@kernel.org> wrote:
> >
> > On Mon, 1 Feb 2021 08:14:31 -0800 Xie He wrote:  
> > > On Mon, Feb 1, 2021 at 6:10 AM Julian Wiedmann <jwi@linux.ibm.com> wrote:  
>  [...]  
> > >
> > > Calling "skb_cow_head" before we call "skb_clone" would indeed solve
> > > the problem of writes to our clones affecting clones in other parts of
> > > the system. But since we are still writing to the skb after
> > > "skb_clone", it'd still be better to replace "skb_clone" with
> > > "skb_copy" to avoid interference between our own clones.  
> >
> > Why call skb_cow_head() before skb_clone()? skb_cow_head should be
> > called before the data in skb head is modified. I'm assuming you're only
> > modifying "front" of the frame, right? skb_cow_head() should do nicely
> > in that case.  
> 
> The modification happens after skb_clone. If we call skb_cow_head
> after skb_clone (before the modification), then skb_cow_head would
> always see that the skb is a clone and would always copy it. Therefore
> skb_clone + skb_cow_head is equivalent to skb_copy.

You're right. I thought cow_head is a little more clever.
