Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 30ED42CAB3C
	for <lists+netdev@lfdr.de>; Tue,  1 Dec 2020 20:00:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731243AbgLATAQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Dec 2020 14:00:16 -0500
Received: from mail.kernel.org ([198.145.29.99]:44224 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727006AbgLATAQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 1 Dec 2020 14:00:16 -0500
Received: from kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com (c-67-180-217-166.hsd1.ca.comcast.net [67.180.217.166])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2AD3920643;
        Tue,  1 Dec 2020 18:59:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1606849175;
        bh=BtxyHBLXobh4EjqbIkPQzC0vVh8swzUv2fALa8vpju8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Q53A8RltsvlnS6QBdtNnfyWDgZ+x/JGvNhD3NPOnLOPHu7ErAtvSs2mOQa86Vd6b6
         fOowGpp/Exr/VofogE6hUqXogq0gAThSeBf6aMPdiF8g+eunvVLEpbbBA9jgEqyBFD
         eUlLeaKqK5WOW0MaFCdsoj/6cfWRh+IoBQfGuR2w=
Date:   Tue, 1 Dec 2020 10:59:33 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     George Cherian <gcherian@marvell.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Sunil Kovvuri Goutham <sgoutham@marvell.com>,
        Linu Cherian <lcherian@marvell.com>,
        "Geethasowjanya Akula" <gakula@marvell.com>,
        "masahiroy@kernel.org" <masahiroy@kernel.org>,
        "willemdebruijn.kernel@gmail.com" <willemdebruijn.kernel@gmail.com>,
        "saeed@kernel.org" <saeed@kernel.org>,
        "jiri@resnulli.us" <jiri@resnulli.us>
Subject: Re: [PATCHv5 net-next 2/3] octeontx2-af: Add devlink health
 reporters for NPA
Message-ID: <20201201105933.7b22d119@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
In-Reply-To: <BYAPR18MB2679F855ADD7176A1587ED37C5F40@BYAPR18MB2679.namprd18.prod.outlook.com>
References: <BYAPR18MB2679898E4AB4122CE2E566D6C5F40@BYAPR18MB2679.namprd18.prod.outlook.com>
        <BYAPR18MB26793451EC000695A56D3B00C5F40@BYAPR18MB2679.namprd18.prod.outlook.com>
        <BYAPR18MB2679F855ADD7176A1587ED37C5F40@BYAPR18MB2679.namprd18.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 1 Dec 2020 05:23:23 +0000 George Cherian wrote:
> > > > You seem to have missed the feedback Saeed and I gave you on v2.
> > > >
> > > > Did you test this with the errors actually triggering? Devlink
> > > > should store only  
> > > Yes, the same was tested using devlink health test interface by
> > > injecting errors.
> > > The dump gets generated automatically and the counters do get out of
> > > sync, in case of continuous error.
> > > That wouldn't be much of an issue as the user could manually trigger a
> > > dump clear and Re-dump the counters to get the exact status of the
> > > counters at any point of time.  
> > 
> > Now that recover op is added the devlink error counter and recover counter
> > will be proper. The internal counter for each event is needed just to
> > understand within a specific reporter, how many such events occurred.
> > 
> > Following is the log snippet of the devlink health test being done on hw_nix
> > reporter.
> > # for i in `seq 1 33` ; do  devlink health test pci/0002:01:00.0 reporter hw_nix;
> > done //Inject 33 errors (16  of NIX_AF_RVU and 17 of NIX_AF_RAS and
> > NIX_AF_GENERAL errors) # devlink health
> > pci/0002:01:00.0:
> >   reporter hw_npa
> >     state healthy error 0 recover 0 grace_period 0 auto_recover true
> > auto_dump true
> >   reporter hw_nix
> >     state healthy error 250 recover 250 last_dump_date 1970-01-01
> > last_dump_time 00:04:16 grace_period 0 auto_recover true auto_dump true  
> Oops, There was a log copy paste error above its not 250 (that was from a run, in which test was done
> for 250 error injections)  
> # devlink health
> pci/0002:01:00.0:
>   reporter hw_npa
>     state healthy error 0 recover 0 grace_period 0 auto_recover true auto_dump true
>   reporter hw_nix
>     state healthy error 33 recover 33

I thought it'd be better to just add each error as its own reporter
rather than combining them and abusing context for reporting detailed
stats.

This seems to be harder to get done than I thought. Maybe just go back
to the prints and we can move on.

> last_dump_date 1970-01-01 last_dump_time 00:02:16 grace_period 0 auto_recover true auto_dump true

Why the weird date? Is this something on your system?
