Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2CFA01E156B
	for <lists+netdev@lfdr.de>; Mon, 25 May 2020 22:57:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390905AbgEYU5t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 May 2020 16:57:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:42682 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390750AbgEYU5t (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 25 May 2020 16:57:49 -0400
Received: from kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net (c-67-180-217-166.hsd1.ca.comcast.net [67.180.217.166])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9B8262065F;
        Mon, 25 May 2020 20:57:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590440268;
        bh=lR7NOEwZSW7Lg+I18yIGiKJF3iGfsiCFNOxqNlZ1mDc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=swt24vm+6Bdjwmpc/k3E1NGlCiAfDgyqBkQ3G8Ce/iyqkrFCZLuItGHYd7e+lhuit
         2p/8FdJfvjSP6yy44RRgmPkzZ0fXJ6Hm3oE4qCNX4na//sgiBAFsr9XmKyyD1l5QJB
         5v9UiseaC98juTrEUehmaFTAJxgDK718S2RLobhk=
Date:   Mon, 25 May 2020 13:57:46 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     Luis Chamberlain <mcgrof@kernel.org>, derosier@gmail.com,
        greearb@candelatech.com, jeyu@kernel.org,
        akpm@linux-foundation.org, arnd@arndb.de, rostedt@goodmis.org,
        mingo@redhat.com, aquini@redhat.com, cai@lca.pw, dyoung@redhat.com,
        bhe@redhat.com, peterz@infradead.org, tglx@linutronix.de,
        gpiccoli@canonical.com, pmladek@suse.com, tiwai@suse.de,
        schlad@suse.de, andriy.shevchenko@linux.intel.com,
        keescook@chromium.org, daniel.vetter@ffwll.ch, will@kernel.org,
        mchehab+samsung@kernel.org, kvalo@codeaurora.org,
        davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        ath10k@lists.infradead.org, jiri@resnulli.us,
        briannorris@chromium.org
Subject: Re: [RFC 1/2] devlink: add simple fw crash helpers
Message-ID: <20200525135746.45e764de@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <2e5199edb433c217c7974ef7408ff8c7253145b6.camel@sipsolutions.net>
References: <20200519010530.GS11244@42.do-not-panic.com>
        <20200519211531.3702593-1-kuba@kernel.org>
        <20200522052046.GY11244@42.do-not-panic.com>
        <20200522101738.1495f4cc@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <2e5199edb433c217c7974ef7408ff8c7253145b6.camel@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 22 May 2020 22:46:07 +0200 Johannes Berg wrote:
> > The irony is you have a problem with a networking device and all the
> > devices your initial set touched are networking. Two of the drivers 
> > you touched either have or will soon have devlink health reporters
> > implemented.  
> 
> Like I said above, do you think it'd be feasible to make a devcoredump
> out of devlink health reports? And can the report be in a way that we
> control the file format, or are there limits? I guess I should read the
> code to find out, but I figure you probably just know. But feel free to
> tell me to read it :)
> 
> The reason I'm asking is that it's starting to sound like we really
> ought to be implementing devlink, but we've got a bunch of
> infrastructure that uses the devcoredump, and it'll take time
> (significantly so) to change all that...

In devlink world pure FW core dumps are exposed by devlink regions.
An API allowing reading device memory, registers, etc., but also 
creating dumps of memory regions when things go wrong. It should be
a fairly straightforward migration.

Devlink health is more targeted, the dump is supposed to contain only
relevant information, selected and formatted by the driver. When device
misbehaves driver reads the relevant registers and FW state and creates
a formatted state dump. I believe each element of the dump must fit
into a netlink message (but there may be multiple elements, see
devlink_fmsg_prepare_skb()).

We should be able to convert dl-regions dumps and dl-health dumps into
devcoredumps, but since health reporters are supposed to be more
targeted there's usually multiple of them per device.

Conversely devcoredumps can be trivially exposed as dl-region dumps,
but I believe dl-health would require driver changes to format the
information appropriately.
