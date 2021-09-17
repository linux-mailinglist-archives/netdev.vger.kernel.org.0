Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1762B40F8D4
	for <lists+netdev@lfdr.de>; Fri, 17 Sep 2021 15:09:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239453AbhIQNKX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Sep 2021 09:10:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:51794 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231996AbhIQNKX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 17 Sep 2021 09:10:23 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CF7FC60E97;
        Fri, 17 Sep 2021 13:09:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631884141;
        bh=/xu1KXyF3d+KS93wiyT/7EeJ5neZn8B1hG3LwsUukJE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=qOHMIcsAhy6hozf24cI2W1xZWyBp3sjSnzSLWnwVqPF9V/FAwtIStCc4NaWQdIL1g
         AJsSpkGxtQtGwsrZ0vNRvXeARdvlU8h48aQdpMujSxqkauadgRMGFfbzdSZQDpcsou
         CkbMl3Afkv7/cNkYf+AcEzj9kroeCBt2cIMEmLCU4laoYpi7NfdL/fKlT18A50GvUB
         DxJbC8Nox1K/uyP7EjHCgMOwZz9HIjaZtEj7TDeV46qBZZLstTbbaIOZV3NrlQGWBx
         7A0361oPKdDDDs2Gu5uC54njORbYiSukZMSS2M9bFulvic1BiQt7isbrYc0wdu5wwV
         wcpp/dAZ7VG3w==
Date:   Fri, 17 Sep 2021 06:08:59 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Cong Wang <xiyou.wangcong@gmail.com>
Cc:     David Miller <davem@davemloft.net>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Eric Dumazet <edumazet@google.com>,
        Matthew Massey <matthewmassey@fb.com>,
        Dave Taht <dave.taht@gmail.com>
Subject: Re: [PATCH net-next 1/3] net: sched: update default qdisc
 visibility after Tx queue cnt changes
Message-ID: <20210917060859.637dd9c0@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <CAM_iQpW553fnxXxC+BLkhzsGixoufNrjzRTrhFKo_gsE9xPwbQ@mail.gmail.com>
References: <20210913225332.662291-1-kuba@kernel.org>
        <20210913225332.662291-2-kuba@kernel.org>
        <CAM_iQpVec_FY-71n3VUUgo8YCcn00+QzBBck9h1RGNaFzXX_ig@mail.gmail.com>
        <20210915123642.218f7f11@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <CAM_iQpW553fnxXxC+BLkhzsGixoufNrjzRTrhFKo_gsE9xPwbQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 16 Sep 2021 22:46:42 -0700 Cong Wang wrote:
> On Wed, Sep 15, 2021 at 12:36 PM Jakub Kicinski <kuba@kernel.org> wrote:
> > On Wed, 15 Sep 2021 09:31:08 -0700 Cong Wang wrote:  
> > > Don't we need to flip the device with dev_deactivate()+dev_activate()?
> > > It looks like the only thing this function resets is qdisc itself, and only
> > > partially.  
> >
> > We're only making the qdiscs visible, there should be
> > no datapath-visible change.  
> 
> Isn't every qdisc under mq visible to datapath?
> 
> Packets can be pending in qdisc's, and qdisc's can be scheduled
> in TX softirq, so essentially we need to flip the device like other

By visible I mean tc qdisc dump shows them. I'm adding/removing 
the qdiscs to netdev->qdisc_hash. That's only used by control 
paths to dump or find qdiscs by handle.

> > > This is nearly identical to mqprio_change_real_num_tx(), can we reuse
> > > it?  
> >
> > Indeed, I was a little unsure where best to place the helper.
> > Since mq is always built if mqprio is my instinct would be to
> > export mq_change_real_num_tx and use it in mqprio. But I didn't
> > see any existing exports (mq_attach(), mq_queue_get() are also
> > identical and are not shared) so I just copy&pasted the logic.  
> 
> What about net/sched/sch_generic.c?
> 
> > LMK if (a) that's fine; (b) I should share the new code;
> > (c) I should post a patch to share all the code that's identical;...  
> 
> I think you can put the code in net/sched/sch_generic.c and export
> it for mqprio (mq is built-in so can just call it).

Will do, thanks!
