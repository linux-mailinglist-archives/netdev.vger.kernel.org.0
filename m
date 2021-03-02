Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A7B2632B3DA
	for <lists+netdev@lfdr.de>; Wed,  3 Mar 2021 05:23:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1840222AbhCCEHh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Mar 2021 23:07:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:42046 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2361127AbhCBXbQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 2 Mar 2021 18:31:16 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0B04F64F3A;
        Tue,  2 Mar 2021 23:30:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614727835;
        bh=eaqbGMdh02IVWXqfTzJMMG0eXfyji5TImxVinimTfZ8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=mNGVJGj74sulK1XpDtC+1PkfDz8pu+vd5dy/11440qyYXhOmgfChR3ePqAJ66/tFm
         whjv4sQsgIG6JcRttlCQV/iA0GGZCXaZlNGnN3YLuQK4l/L2mXxFz35Xav1425icea
         XTEP2yCPViD+lHhpxOKV4QhNpSI5eZkHuLbQGWgYyQqgCXwG/9xDgY/ZNO6XNzX/dL
         euOlDcj+MHjwH7K1sz448UerEeBKMQND73XvXHTysPTBgmqT1JhaL8LyOnDfOWMIM8
         uhb9TnP9VyQ9MX+03SHMZWRiczJF0yplPbGVe/KJnvDQRhda8PSQOTt0NmaUh487kp
         2p84s69/cvvow==
Date:   Tue, 2 Mar 2021 15:30:34 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Martin Schiller <ms@dev.tdt.de>
Cc:     Xie He <xie.he.0141@gmail.com>, Leon Romanovsky <leon@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Linux X25 <linux-x25@vger.kernel.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Krzysztof Halasa <khc@pm.waw.pl>,
        Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org
Subject: Re: [PATCH net-next RFC v4] net: hdlc_x25: Queue outgoing LAPB
 frames
Message-ID: <20210302153034.5f4e320b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <41b77b1c3cf1bb7a51b750faf23900ef@dev.tdt.de>
References: <20210216201813.60394-1-xie.he.0141@gmail.com>
        <YC4sB9OCl5mm3JAw@unreal>
        <CAJht_EN2ZO8r-dpou5M4kkg3o3J5mHvM7NdjS8nigRCGyih7mg@mail.gmail.com>
        <YC5DVTHHd6OOs459@unreal>
        <CAJht_EOhu+Wsv91yDS5dEt+YgSmGsBnkz=igeTLibenAgR=Tew@mail.gmail.com>
        <YC7GHgYfGmL2wVRR@unreal>
        <CAJht_EPZ7rVFd-XD6EQD2VJTDtmZZv0HuZvii+7=yhFgVz68VQ@mail.gmail.com>
        <CAJht_EPPMhB0JTtjWtMcGbRYNiZwJeMLWSC5hS6WhWuw5FgZtg@mail.gmail.com>
        <20210219103948.6644e61f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <CAJht_EOru3pW6AHN4QVjiaERpLSfg-0G0ZEaqU_hkhX1acv0HQ@mail.gmail.com>
        <906d8114f1965965749f1890680f2547@dev.tdt.de>
        <CAJht_EPBJhhdCBoon=WMuPBk-sxaeYOq3veOpAd2jq5kFqQHBg@mail.gmail.com>
        <e1750da4179aca52960703890e985af3@dev.tdt.de>
        <CAJht_ENP3Y98jgj1peGa3fGpQ-qPaF=1gtyYwMcawRFW_UCpeA@mail.gmail.com>
        <ff200b159ef358494a922a676cbef8a6@dev.tdt.de>
        <CAJht_EMG27YU+Jxtb2qeq1nXwu8uV8FXQPr62OcNHsE7DozD1g@mail.gmail.com>
        <41b77b1c3cf1bb7a51b750faf23900ef@dev.tdt.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 02 Mar 2021 08:04:20 +0100 Martin Schiller wrote:
> On 2021-03-01 09:56, Xie He wrote:
> > On Sun, Feb 28, 2021 at 10:56 PM Martin Schiller <ms@dev.tdt.de> wrote:  
> >> I mean the change from only one hdlc<x> interface to both hdlc<x> and
> >> hdlc<x>_x25.
> >> 
> >> I can't estimate how many users are out there and how their setup 
> >> looks
> >> like.  
> > 
> > I'm also thinking about solving this issue by adding new APIs to the
> > HDLC subsystem (hdlc_stop_queue / hdlc_wake_queue) for hardware
> > drivers to call instead of netif_stop_queue / netif_wake_queue. This
> > way we can preserve backward compatibility.
> > 
> > However I'm reluctant to change the code of all the hardware drivers
> > because I'm afraid of introducing bugs, etc. When I look at the code
> > of "wan/lmc/lmc_main.c", I feel I'm not able to make sure there are no
> > bugs (related to stop_queue / wake_queue) after my change (and even
> > before my change, actually). There are even serious style problems:
> > the majority of its lines are indented by spaces.
> > 
> > So I don't want to mess with all the hardware drivers. Hardware driver
> > developers (if they wish to properly support hdlc_x25) should do the
> > change themselves. This is not a problem for me, because I use my own
> > out-of-tree hardware driver. However if I add APIs with no user code
> > in the kernel, other developers may think these APIs are not
> > necessary.  
> 
> I don't think a change that affects the entire HDLC subsystem is
> justified, since the actual problem only affects the hdlc_x25 area.
> 
> The approach with the additional hdlc<x>_x25 is clean and purposeful and
> I personally could live with it.
> 
> I just don't see myself in the position to decide such a change at the
> moment.
> 
> @Jakub: What is your opinion on this.

Hard question to answer, existing users seem happy and Xie's driver
isn't upstream, so the justification for potentially breaking backward
compatibility isn't exactly "strong".

Can we cop out and add a knob somewhere to control spawning the extra
netdev? Let people who just want a newer kernel carry on without
distractions and those who want the extra layer can flip the switch?
