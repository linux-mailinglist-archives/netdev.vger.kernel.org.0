Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E9D030B2CA
	for <lists+netdev@lfdr.de>; Mon,  1 Feb 2021 23:35:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229914AbhBAWev (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Feb 2021 17:34:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:59858 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229514AbhBAWep (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 1 Feb 2021 17:34:45 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E778364EAA;
        Mon,  1 Feb 2021 22:34:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612218845;
        bh=bW1WVD3TmGLw9DY1p8o6NG/X8hqb0cYKp2kw31xOmxs=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=dcZPhDWhKxtutFiLg+uIzzcFCrq04vrmz9qE7w7vKGClN5STq6Oh9nmfdL53dhQeN
         FbCaABqDOzZuFnhZnvUYI4xao4J+oOn+Z6lbrL7Fp8V/Ey4jNaYw1mwf/jcJDB4YJA
         gmgMwt89lzPsokD1h1lnTQfftZb0df8KrPm/1HDgEFlB0jxoRFBUFTmJH5Mo+XEVBF
         93IyNnABGnhmBHbcDq/dZzsmJFrqpMBq7WqLeRNTacR1m+A/xo3/tVCMAcSza1m3Q0
         AP5R927ZXxsKSyTCbXAr/ty0LHy0BuD9BU4ji2FQyGMYtF619judmJW3aL/abTTlUJ
         WHdYKHUn5C90g==
Date:   Mon, 1 Feb 2021 14:34:04 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jacob Keller <jacob.e.keller@intel.com>
Cc:     Tony Nguyen <anthony.l.nguyen@intel.com>, davem@davemloft.net,
        netdev@vger.kernel.org, sassmann@redhat.com,
        Tony Brelinski <tonyx.brelinski@intel.com>
Subject: Re: [PATCH net-next 10/15] ice: display some stored NVM versions
 via devlink info
Message-ID: <20210201143404.7e4a093b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <977ae41c-c547-bc44-9857-24c88c228412@intel.com>
References: <20210129004332.3004826-1-anthony.l.nguyen@intel.com>
        <20210129004332.3004826-11-anthony.l.nguyen@intel.com>
        <20210129223754.0376285e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <977ae41c-c547-bc44-9857-24c88c228412@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 1 Feb 2021 13:40:27 -0800 Jacob Keller wrote:
> On 1/29/2021 10:37 PM, Jakub Kicinski wrote:
> > On Thu, 28 Jan 2021 16:43:27 -0800 Tony Nguyen wrote:  
> >> When reporting the versions via devlink info, first read the device
> >> capabilities. If there is a pending flash update, use this new function
> >> to extract the inactive flash versions. Add the stored fields to the
> >> flash version map structure so that they will be displayed when
> >> available.  
> > 
> > Why only report them when there is an update pending?
> > 
> > The expectation was that you'd always report what you can and user 
> > can tell the update is pending by comparing the fields.
> 
> If there is no pending update, what is the expected behavior? We report
> the currently active image version as both stored and running?
> 
> In our case, the device has 2 copies of each of the 3 modules: NVM,
> Netlist, and UNDI/OptionROM.
> 
> For each module, the device has a bit that indicates whether it will
> boot from the first or second bank of the image. When we update,
> whichever bank is not active is erased, and then populated with the new
> image contents. The bit indicating which bank to load is flipped. Once
> the device is rebooted (EMP reset), then the new bank is loaded, and the
> firmware performs some onetime initialization.
> 
> So for us, in theory we have up to 2 versions within the device for each
> bank: the version in the currently active bank, and a version in the
> inactive bank. In the inactive case, it may or may not be valid
> depending on if that banks contents were ever a valid image. On a fresh
> card, this might be empty or filled with garbage.
> 
> Presumably we do not want to report that we have "stored" a version
> which is not going to be activated next time that we boot?
> 
> The documentation indicated that stored should be the version which
> *will* be activated.
> 
> If I just blindly always reported what was inactive, then the following
> scenarios exist:
> 
> # Brand new card:
> 
> running:
>   fw.bundle_id: Version
> stored
>   fw.bundle_id: <zero or garbage>
> 
> # Do an update:
> 
> running:
>   fw.bundle_id: Version
> stored
>   fw.bundle_id: NewVersion
> 
> # reset/reboot
> 
> running:
>   fw.bundle_id: NewVersion
> stored:
>   fw.bundle_id: Version
> 
> 
> I could get behind that if we do not have a pending update we report the
> stored value as the same as the running value (i.e. from the active
> bank), where as if we have a pending update that will be triggered we
> would report the inactive bank. I didn't see the value in that before
> because it seemed like "if you don't have a pending update, you don't
> have a stored value, so just report the active version in the running
> category")
> 
> It's also plausibly useful to report the stored but not pending value in
> some cases, but I really don't want to report zeros or garbage data on
> accident. This would almost certainly lead to confusing support
> conversations.

Very good points. Please see the documentation for example workflow:

https://www.kernel.org/doc/html/latest/networking/devlink/devlink-flash.html#firmware-version-management

The FW update agent should be able to rely on 'stored' for checking if
flash update is needed.

If the FW update is not pending just report the same values as running.
You should not report old version after 2 flashings (3rd output in your
example) - that'd confuse the flow - as you said - the stored versions
would not be what will get activated.
