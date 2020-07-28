Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C6D50231378
	for <lists+netdev@lfdr.de>; Tue, 28 Jul 2020 22:07:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728361AbgG1UG5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jul 2020 16:06:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:43332 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728053AbgG1UG4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 28 Jul 2020 16:06:56 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A6A7820656;
        Tue, 28 Jul 2020 20:06:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595966816;
        bh=sYKqOmMNs+3IuJX+AIxjd9QENNEFZ6DotksaWOwUFJw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=X2yu3iDa12nwXWYvQqNcQCax4XbNVXFFzr803PPOWcQECw2MNU1xec48umfhQEc79
         r9UK7Ra6T1kkJGTufPFpnLnfoJkosrvgccL2z6taFM5+S9RvLVN0h5CI2RWkEbf8cN
         l+NFSvzdhCbp0SkpZg5epUKuY5D2kclSVl9tUmCU=
Date:   Tue, 28 Jul 2020 13:06:53 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jacob Keller <jacob.e.keller@intel.com>
Cc:     Jiri Pirko <jiri@resnulli.us>, Moshe Shemesh <moshe@mellanox.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Jiri Pirko <jiri@mellanox.com>,
        Vasundhara Volam <vasundhara-v.volam@broadcom.com>
Subject: Re: [PATCH net-next RFC 01/13] devlink: Add reload level option to
 devlink reload command
Message-ID: <20200728130653.7ce2f013@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <d6fbfedd-9022-ff67-23ed-418607beecc2@intel.com>
References: <1595847753-2234-1-git-send-email-moshe@mellanox.com>
        <1595847753-2234-2-git-send-email-moshe@mellanox.com>
        <20200727175802.04890dd3@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <20200728135808.GC2207@nanopsycho>
        <464add44-3ab1-21b8-3dba-a88202350bb9@intel.com>
        <20200728114458.762b5396@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <d6fbfedd-9022-ff67-23ed-418607beecc2@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 28 Jul 2020 12:18:30 -0700 Jacob Keller wrote:
> On 7/28/2020 11:44 AM, Jakub Kicinski wrote:
> > From user perspective what's important is what the reset achieves (and
> > perhaps how destructive it is). We can define the reset levels as:
> > 
> > $ devlink dev reload pci/0000:82:00.0 net-ns-respawn
> > $ devlink dev reload pci/0000:82:00.0 driver-param-init
> > $ devlink dev reload pci/0000:82:00.0 fw-activate
> > 
> > combining should be possible when user wants multiple things to happen:
> > 
> > $ devlink dev reload pci/0000:82:00.0 fw-activate driver-param-init
> 
> Where today "driver-param-init" is the default behavior. But didn't we
> just say that mlxsw also does the equivalent of fw-activate?

Actually the default should probably be the combination of
driver-param-init and net-ns-respawn.

My expectations would be that the driver must perform the lowest reset 
level possible that satisfies the requested functional change. 
IOW driver may do more, in fact it should be acceptable for the driver
to always for a full HW reset (unless --live or other constraint is
specified).

> > We can also add the "reset level" specifier - for the cases where
> > device is misbehaving:
> > 
> > $ devlink dev reload pci/0000:82:00.0 level [driver|fw|hardware]
> 
> I guess I don't quite see how level fits in? This is orthogonal to the
> other settings?

Yup, it is, it's already orthogonal to what reload does today, hence the
need for the "driver default" hack.

> > But I don't think that we can go from the current reload command
> > cleanly to just a level reset. The driver-specific default is a bad
> > smell which indicates we're changing semantics from what user wants 
> > to what the reset depth is. Our semantics with the patch as it stands
> > are in fact:
> >  - if you want to load new params or change netns, don't pass the level
> >    - the "driver default" workaround dictates the right reset level for
> >    param init;
> >  - if you want to activate new firmware - select the reset level you'd
> >    like from the reset level options.
> >   
> 
> I think I agree, having the "what gets reloaded" as a separate vector
> makes sense and avoids confusion. For example for ice hardware,
> "fw-activate" really does mean "Do an EMP reset" rather than just a
> "device reset" which could be interpreted differently. ice can do
> function level reset, or core device reset also. Neither of those two
> resets activates firmware.
> 
> Additionally the current function load process in ice doesn't support
> driver-init at all. That's something I'd like to see happen but is quite
> a significant refactor for how the driver loads. We need to refactor
> everything out so that devlink is created early on and factor out
> load/unload into handlers that can be called by the devlink reload. As I
> have primarily been focused on flash update I sort of left that for the
> future because it was a huge task to solve.

Cool! That was what I was concerned about, but I didn't know any
existing driver already has the problem. "FW reset" is not nearly
a clear enough operation. We'd end up with drivers differing and 
users having to refer to vendor documentation to find out which 
"reset level" maps to what.

I think the components in ethtool-reset try to address the same
problem, and they have the notion of per-port, and per-device.
In the modern world we lack the per-host notion, but that's still 
strictly clearer than the limited API proposed here.
