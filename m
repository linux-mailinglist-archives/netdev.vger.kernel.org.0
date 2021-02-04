Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8FBE730E9F9
	for <lists+netdev@lfdr.de>; Thu,  4 Feb 2021 03:09:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233024AbhBDCJP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Feb 2021 21:09:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:38582 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232556AbhBDCJP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 3 Feb 2021 21:09:15 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 16BD864DF6;
        Thu,  4 Feb 2021 02:08:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612404514;
        bh=+bq0U3MwJW8BHAYdyKvpckzyNEJrf1/aGTZQG9yR13Q=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=MutB6EPg+dI1l+hx31bVjDlitBAO9++4r5ORxqoSBe6cYI//M1c/IHZIGoyS+JjZd
         oPVvQuGtQNIzLPPFq7mNHy+no2hMcqLj7Ohdu74CaylG2eQPVBxk9zefU2zaGy1JSH
         0MI99pb+o4D6lr5r/sK8CDx5BS5G/leH16yNIyY/wViA58J8elzirVPdkf1Vega0rj
         ktulH/yogRTBlgmnDSHl+3E96VY/gA7taSjY+cEEVMmf7xgbnnn7j3knPyheOjl1YB
         ZKxVDuB8poadzpIDwZsNLq6QwzL5p90yvbwYIV5B4o6RUPdjU485rParc8rL7c/z/G
         TIFs5JqfaRy1Q==
Date:   Wed, 3 Feb 2021 18:08:33 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jacob Keller <jacob.e.keller@intel.com>
Cc:     Tony Nguyen <anthony.l.nguyen@intel.com>, davem@davemloft.net,
        netdev@vger.kernel.org, sassmann@redhat.com,
        Tony Brelinski <tonyx.brelinski@intel.com>
Subject: Re: [PATCH net-next 04/15] ice: add devlink parameters to read and
 write minimum security revision
Message-ID: <20210203180833.7188fbcf@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <c9bfca09-7fc1-08dc-750d-de604fb37e00@intel.com>
References: <20210129004332.3004826-1-anthony.l.nguyen@intel.com>
        <20210129004332.3004826-5-anthony.l.nguyen@intel.com>
        <20210203124112.67a1e1ee@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <c9bfca09-7fc1-08dc-750d-de604fb37e00@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 3 Feb 2021 17:34:24 -0800 Jacob Keller wrote:
> On 2/3/2021 12:41 PM, Jakub Kicinski wrote:
> > On Thu, 28 Jan 2021 16:43:21 -0800 Tony Nguyen wrote:  
> >> From: Jacob Keller <jacob.e.keller@intel.com>
> >>
> >> The ice NVM flash has a security revision field for the main NVM bank
> >> and the Option ROM bank. In addition to the revision within the module,
> >> the device also has a minimum security revision TLV area. This minimum
> >> security revision field indicates the minimum value that will be
> >> accepted for the associated security revision when loading the NVM bank.
> >>
> >> Add functions to read and update the minimum security revisions. Use
> >> these functions to implement devlink parameters, "fw.undi.minsrev" and
> >> "fw.mgmt.minsrev".
> >>
> >> These parameters are permanent (i.e. stored in flash), and are used to
> >> indicate the minimum security revision of the associated NVM bank. If
> >> the image in the bank has a lower security revision, then the flash
> >> loader will not continue loading that flash bank.
> >>
> >> The new parameters allow for opting in to update the minimum security
> >> revision to ensure that a flash image with a known security flaw cannot
> >> be loaded.
> >>
> >> Note that the minimum security revision cannot be reduced, only
> >> increased. The driver also refuses to allow an update if the currently
> >> active image revision is lower than the requested value. This is done to
> >> avoid potentially updating the value such that the device can no longer
> >> start.  
> >
> > Hi Jake, I had a couple of conversations with people from operations
> > and I'm struggling to find interest in writing this parameter.   
> >> It seems like the expectation is that the min sec revision will go up  
> > automatically after a new firmware with a higher number is flashed.
> 
> I believe the intention is that the update is not automatic, and
> requires the user to opt-in to enforcing the new minimum value. This is
> because once you update this value it is not possible to lower it
> without physical access to reflash the chip directly. It's intended as a
> mechanism to allow a system administrator to ensure that the board is
> unable to downgrade below a given minimum security revision.
> 
> > Do you have a user scenario where the manual bumping is needed?
> >   
> 
> In our case, we have tools which would use this interface and would
> perform the update upon request i.e. because the tool is configured to
> perform the update.
> 
> We don't want this field to be updated every time the board is flashed,
> as it is supposed to be an optional "opt-in", and not forced.
> 
> The flow is something like:
> 
> a) device is as firmware version with SREV of 1
> b) new firmware is flashed with SREV 2
> c) system administrator confirms that new firmware is working and that
> no issues have occurred
> d) system administrator then decides to enforce new srev by updating the
> minimum srev value.

Dunno, seems to me secure by default is a better approach. If admin 
is worried you can always ship an eval build which does not bump the
version. Or address the issues with the next release rather than roll
back.

> If there was an issue at step (c), we want to still be able to roll back
> to the old firmware. If the minimum srev is updated automatically, this
> would not be possible.
> 
> I've asked for further details from some of our firmware folks, and can
> try to provide further information. The key is that making it automatic
> is bad because it prevents rollback, so we want to ensure that it is
> only updated after the system administrator is ready to opt-in.
> 
> Ofcourse, it is plausible that most won't actually update this ever,
> because preventing the ability to use an old firmware might not be desired.

Well, if there is a point to secure boot w/ NICs people better prevent
replay attacks. Not every FW update is a security update, tho, so it's
not like "going to the old version" would never be possible.

> The goal with this series was to provide a mechanism to allow the
> update, because existing tools based on direct flash access have support
> for this, and we want to ensure that these tools can be ported to
> devlink without the direct flash access that we were (ab)using before.

I'm not completely opposed to this mechanism (although you may want 
to communicate the approach to your customers clearly, because many
may be surprised) - but let's be clear - the goal of devlink is to
create a replacement for vendor tooling, not be their underlying
mechanism.
