Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C99EE2B3213
	for <lists+netdev@lfdr.de>; Sun, 15 Nov 2020 05:14:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726546AbgKOEKc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Nov 2020 23:10:32 -0500
Received: from mail.kernel.org ([198.145.29.99]:33638 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726177AbgKOEKZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 14 Nov 2020 23:10:25 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (c-67-180-217-166.hsd1.ca.comcast.net [67.180.217.166])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 252B0223EA;
        Sun, 15 Nov 2020 04:10:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605413424;
        bh=vGntya8YdNfvsf6A+gO/CXhKhnshIKURxO0WpvexcF8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=m2QsOzE8L80B3vAHbaa+rm+gKJ31fATvJylgO61PabQlKYp/lCW5GbDn4UbSGpc61
         fiqSwnUHsGuGuRf2pbd3zar68ixKm1I/JVzlQHnqnlUsNP1aor3LDGcZ6PStLju161
         +lIaCDt9KS9dlpMP+i4IwNZwb90VDWUmeWFB/pZM=
Date:   Sat, 14 Nov 2020 20:10:23 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jacob Keller <jacob.e.keller@intel.com>
Cc:     netdev@vger.kernel.org, Jiri Pirko <jiri@nvidia.com>,
        Michael Chan <michael.chan@broadcom.com>,
        Shannon Nelson <snelson@pensando.io>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Boris Pismenny <borisp@nvidia.com>,
        Bin Luo <luobin9@huawei.com>
Subject: Re: devlink userspace process appears stuck (was: Re: [net-next]
 devlink: move request_firmware out of driver)
Message-ID: <20201114201023.1b597c93@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <baf44b88-156f-7b34-5e8d-9fe3bc2e2c40@intel.com>
References: <20201113000142.3563690-1-jacob.e.keller@intel.com>
        <20201113131252.743c1226@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <01c79a25-3826-d0f3-8ea3-aa31e338dabe@intel.com>
        <6352e9d3-02af-721e-3a54-ef99a666be29@intel.com>
        <baf44b88-156f-7b34-5e8d-9fe3bc2e2c40@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 13 Nov 2020 14:51:36 -0800 Jacob Keller wrote:
> On 11/13/2020 2:32 PM, Jacob Keller wrote:
> > 
> > 
> > On 11/13/2020 1:34 PM, Jacob Keller wrote:  
> >> Well, at least with ice, the experience is pretty bad. I tried out with
> >> a garbage file name on one of my test systems. This was on a slightly
> >> older kernel without this patch applied, and the device had a pending
> >> update that had not yet been finalized with a reset:
> >>
> >> $ devlink dev flash pci/0000:af:00.0 file garbage_file_does_not_exist
> >> Canceling previous pending update
> >>
> >>
> >> The update looks like it got stuck, but actually it failed. Somehow the
> >> extack error over the socket didn't get handled by the application very
> >> well. Something buggy in the forked process probably.
> >>
> >> I do get this in the dmesg though:
> >>
> >> Nov 13 13:12:57 jekeller-stp-glorfindel kernel: ice 0000:af:00.0: Direct
> >> firmware load for garbage_file_does_not_exist failed with error -2
> >>  
> > 
> > I think I figured out what is going on here, but I'm not sure what the
> > best solution is.
> > 
> > in userspace devlink.c:3410, the condition for exiting the while loop
> > that monitors the flash update process is:
> > 
> > (!ctx.flash_done || (ctx.not_first && !ctx.received_end))
> >   
> 
> FWIW changing this to
> 
> (!ctx.flash_done && !ctx.received_end)
> 
> works for this problem, but I suspect that the original condition
> intended to try and catch the case where flash update has exited but we
> haven't yet processed all of the status messages?

Yeah... I've only looked at this for 5 minutes, but it seems that ice
should not send notifications outside of begin / end (in fact it could
be nice to add an appropriate WARN_ON() in notify())...

> I mean in some sense we could just wait for !ctx.flash_done only. Then
> we'd always loop until the initial request exits.
> 
> There's a slight issue with the netlink extack message not being
> displayed on its own line, but I think that just needs us to add a
> pr_out("\n") somewhere to fix it.
> 
> 
> > This condition means keep looping until flash is done *OR* we've
> > received a message but have not yet received the end.
> > 
> > In the ice driver implementation, we perform a check for a pending flash
> > update first, which could trigger a cancellation that causes us to send
> > back a "cancelling previous pending flash update" status message, which
> > was sent *before* the devlink_flash_update_begin_notify(). Then, after
> > this we request the firmware object, which fails, and results in an
> > error code being reported back..
> > 
> > However, we will never send either the begin or end notification at this
> > point. Thus, the devlink userspace application will never quit, and
> > won't display the extack message.
> > 
> > This occurs because we sent a status notify message before we actually
> > sent a "begin notify". I think the ordering was done because of trying
> > to avoid having a complicated cleanup logic.
> > 
> > In some sense, this is a bug in the ice driver.. but in another sense
> > this is the devlink application being too strict about the requirements
> > on ordering of these messages..
> > 
> > I guess one method if we really want to remain strict is moving the
> > "begin" and "end" notifications outside of the driver into core so that
> > it always sends a begin before calling the .flash_update handler, and
> > always sends an end before exiting.
> > 
> > I guess we could simply relax the restriction on "not first" so that
> > we'll always exit in the case where the forked process has quit on us,
> > even if we haven't received a proper flash end notification...
> > 
> > Thoughts?
> >   

