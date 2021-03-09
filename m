Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C12AE3331C3
	for <lists+netdev@lfdr.de>; Tue,  9 Mar 2021 23:53:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231924AbhCIWwp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Mar 2021 17:52:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:60480 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232114AbhCIWwL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 9 Mar 2021 17:52:11 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 91B1764FBC;
        Tue,  9 Mar 2021 22:52:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615330331;
        bh=kPsU0PHqMtzXMCdg9NjKkHEAiWjL+gtt1xdNZUj9SJA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=KZBnb8HScgiwmoiV84QtxcMXb/qWSHVv731O63xfJbYgswwc8ldv/BQwZLL6tD621
         zWU1wtxrP121/qJUjFz/rUQf6fiAvgjNMiMl/66ZH/RBawjN+wxLkXsG4hNyrZMsAD
         nNG3XgPZWb653csv31tLo1En+G8njlow0+RAzDuYLY4q0aqdhW5ihYionxVkvUJ2TW
         mOO8IKq+VGPQU/eRY6JTW7J5ekaZDz+DQla7UdPt07+QJWsL8c3V4h38JqL4JgwA1Q
         Gt/ygJDO04aeAg0GZjGfvH7pEclC7MGVT1T9GJks5jwvzAbK15phTtE1PUHDOmSfnW
         uMf9Qgc4eqb0w==
Date:   Tue, 9 Mar 2021 14:52:09 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Eran Ben Elisha <eranbe@nvidia.com>
Cc:     <netdev@vger.kernel.org>, <jiri@resnulli.us>, <saeedm@nvidia.com>,
        <andrew.gospodarek@broadcom.com>, <jacob.e.keller@intel.com>,
        <guglielmo.morandin@broadcom.com>, <eugenem@fb.com>,
        <eranbe@mellanox.com>
Subject: Re: [RFC] devlink: health: add remediation type
Message-ID: <20210309145209.0e05608d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <bca3440c-9279-58a6-377f-6a4fdcccdf1f@nvidia.com>
References: <20210306024220.251721-1-kuba@kernel.org>
        <3d7e75bb-311d-ccd3-6852-cae5c32c9a8e@nvidia.com>
        <20210308091600.5f686fcd@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <20210308095950.3cede742@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <bca3440c-9279-58a6-377f-6a4fdcccdf1f@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 9 Mar 2021 16:06:49 +0200 Eran Ben Elisha wrote:
> On 3/8/2021 7:59 PM, Jakub Kicinski wrote:
> >> Hm, export and extend devlink_health_reporter_state? I like that idea.  
> > 
> > Trying to type it up it looks less pretty than expected.
> > 
> > Let's looks at some examples.
> > 
> > A queue reporter, say "rx", resets the queue dropping all outstanding
> > buffers. As previously mentioned when the normal remediation fails user
> > is expected to power cycle the machine or maybe swap the card. The
> > device itself does not have a crystal ball.  
> 
> Not sure, reopen the queue, or reinit the driver might also be good in 
> case of issue in the SW/HW queue context for example. But I agree that 
> RX reporter can't tell from its perspective what further escalation is 
> needed in case its local defined operations failed.

Right, the point being if normal remediation fails collect a full
system dump and do the big hammer remediation (power cycle or reinit 
if user wants to try that).

> > A management FW reporter "fw", has a auto recovery of FW reset
> > (REMEDY_RESET). On failure -> power cycle.
> > 
> > An "io" reporter (PCI link had to be trained down) can only return
> > a hardware failure (we should probably have a HW failure other than
> > BAD_PART for this).
> > 
> > Flash reporters - the device will know if the flash had a bad block
> > or the entire part is bad, so probably can have 2 reporters for this.
> > 
> > Most of the reporters would only report one "action" that can be
> > performed to fix them. The cartesian product of ->recovery types vs
> > manual recovery does not seem necessary. And drivers would get bloated
> > with additional boilerplate of returning ERROR_NEED_POWER_CYCLE for
> > _all_ cases with ->recovery. Because what else would the fix be if
> > software-initiated reset didn't work?
> 
> OK, I see your point.
> 
> If I got you right, this is the conclusions so far:
> 1. Each reporter with recover callback will have to supply a remedy 
> definition.
> 2. We shouldn't have POWER_CYCLE, REIMAGE and BAD_PART as a remedy, 
> because these are not valid reporter recover flows in any case.
> 3. If a reporter will fail to recover, its status shall remain as error, 
> and it is out of the reporter's scope to advise the administrator on 
> further actions.

I was actually intending to go back to the original proposal, mostly 
as is (plus he KICK).

Indeed the intent is that if local remediation fails or is unavailable
and reporter is in failed state - power cycle or other manual
intervention is needed. So we can drop the POWER_CYCLE remedy and leave
it implicit.

But how are you suggesting we handle BAD_PART and REIMAGE? Still
extending the health status or a separate mechanism than dl-health?
