Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E4751D8951
	for <lists+netdev@lfdr.de>; Mon, 18 May 2020 22:37:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727944AbgERUf0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 May 2020 16:35:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:57322 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726367AbgERUf0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 18 May 2020 16:35:26 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CA71720643;
        Mon, 18 May 2020 20:35:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589834125;
        bh=EebWMw2/BKiwkL0PdmpH4pmdEuuBamIWeyLtE/PbjDM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=0NV+O35TlHkZPw5ugdanjgmtCGbOX0t0hFYRBxjBtzDNjth/O3q+acWeLbthxRWNw
         SNKAZd0DdRSjYTHrZ0PZRjHHhDLSPqY0xusmfSDo0mYGrDhJRMT7+40ZzFowp5D85t
         Jh8T14s82+k6v/rjkjLSG3OwrgsvmAEAHZrw7WH8=
Date:   Mon, 18 May 2020 13:35:21 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     Luis Chamberlain <mcgrof@kernel.org>,
        Steve deRosier <derosier@gmail.com>,
        Ben Greear <greearb@candelatech.com>, jeyu@kernel.org,
        akpm@linux-foundation.org, arnd@arndb.de, rostedt@goodmis.org,
        mingo@redhat.com, aquini@redhat.com, cai@lca.pw, dyoung@redhat.com,
        bhe@redhat.com, peterz@infradead.org, tglx@linutronix.de,
        gpiccoli@canonical.com, pmladek@suse.com,
        Takashi Iwai <tiwai@suse.de>, schlad@suse.de,
        andriy.shevchenko@linux.intel.com, keescook@chromium.org,
        daniel.vetter@ffwll.ch, will@kernel.org,
        mchehab+samsung@kernel.org, Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Network Development <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        ath10k@lists.infradead.org
Subject: Re: [PATCH v2 12/15] ath10k: use new module_firmware_crashed()
Message-ID: <20200518133521.6052042e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <8d7a3bed242ac9d3ec55a4c97e008081230f1f6d.camel@sipsolutions.net>
References: <20200515212846.1347-1-mcgrof@kernel.org>
        <20200515212846.1347-13-mcgrof@kernel.org>
        <2b74a35c726e451b2fab2b5d0d301e80d1f4cdc7.camel@sipsolutions.net>
        <20200518165154.GH11244@42.do-not-panic.com>
        <4ad0668d-2de9-11d7-c3a1-ad2aedd0c02d@candelatech.com>
        <20200518170934.GJ11244@42.do-not-panic.com>
        <abf22ef3-93cb-61a4-0af2-43feac6d7930@candelatech.com>
        <20200518171801.GL11244@42.do-not-panic.com>
        <CALLGbR+ht2V3m5f-aUbdwEMOvbsX8ebmzdWgX4jyWTbpHrXZ0Q@mail.gmail.com>
        <20200518190930.GO11244@42.do-not-panic.com>
        <e3d978c8fa6a4075f12e843548d41e2c8ab537d1.camel@sipsolutions.net>
        <20200518132828.553159d9@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <8d7a3bed242ac9d3ec55a4c97e008081230f1f6d.camel@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 18 May 2020 22:29:53 +0200 Johannes Berg wrote:
> On Mon, 2020-05-18 at 13:28 -0700, Jakub Kicinski wrote:
> > On Mon, 18 May 2020 21:25:09 +0200 Johannes Berg wrote:  
> > > It's pretty clear, but even then, first of all I doubt this is the case
> > > for many of the places that you've sprinkled the annotation on, and
> > > secondly it actually hides useful information.
> > > 
> > > Regardless of the support issue, I think this hiding of information is
> > > also problematic.
> > > 
> > > I really think we'd all be better off if you just made a sysfs file (I
> > > mistyped debugfs in some other email, sorry, apparently you didn't see
> > > the correction in time) that listed which device(s) crashed and how many
> > > times. That would actually be useful. Because honestly, if a random
> > > device crashed for some random reason, that's pretty much a non-event.
> > > If it keeps happening, then we might even want to know about it.  
> > 
> > Johannes - have you seen devlink health? I think we should just use
> > that interface, since it supports all the things you're requesting,
> > rather than duplicate it in sysfs.  
> 
> I haven't, and I'm glad to hear that's there, sounds good!
> 
> I suspect that Luis wants something more generic though, that isn't just
> applicable to netdevices, unless devlink grew some kind of non-netdev
> stuff while I wasn't looking? :)

It's intended to be a generic netlink channel for configuring devices.

All the firmware-related interfaces have no dependencies on netdevs,
in fact that's one of the reasons we moved to devlink - we don't want
to hold rtnl lock just for talking to device firmware.
