Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 314F31E4FE5
	for <lists+netdev@lfdr.de>; Wed, 27 May 2020 23:16:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727843AbgE0VQN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 May 2020 17:16:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:34792 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726114AbgE0VQL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 27 May 2020 17:16:11 -0400
Received: from kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 61F9F207E8;
        Wed, 27 May 2020 21:16:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590614170;
        bh=hj12UP+St/N+cGyjJ9/+G6O0wyWZ+UZ309oo957+nWM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=KeFsZabwtepCN9guVzi55vEjOo82s5izBik6jL1AMXbd+fCIQDqGRPZ/ia2KQ/tFi
         1/+XZwq8uMKkGudxXszwp4vHQoovmDVKCt3kuSjDYLl0CRcFP/D1LRY51yPmDY8+Ad
         t+rQ6uJ862EQ/+iPkKnugbiGfYyIeiDyN7HvasRo=
Date:   Wed, 27 May 2020 14:16:08 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Michael Chan <michael.chan@broadcom.com>
Cc:     Vasundhara Volam <vasundhara-v.volam@broadcom.com>,
        Jiri Pirko <jiri@resnulli.us>,
        David Miller <davem@davemloft.net>,
        Netdev <netdev@vger.kernel.org>, Jiri Pirko <jiri@mellanox.com>
Subject: Re: [PATCH v2 net-next 1/4] devlink: Add new "allow_fw_live_reset"
 generic device parameter.
Message-ID: <20200527141608.3c96f618@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <CACKFLi=+Q4CkOvaxQQm5Ya8+Ft=jNMwCAuK+=5SMxAfNGGriBw@mail.gmail.com>
References: <1590214105-10430-1-git-send-email-vasundhara-v.volam@broadcom.com>
        <1590214105-10430-2-git-send-email-vasundhara-v.volam@broadcom.com>
        <20200524045335.GA22938@nanopsycho>
        <CAACQVJpbXSnf0Gc5HehFc6KzKjZU7dV5tY9cwR72pBhweVRkFw@mail.gmail.com>
        <20200525172602.GA14161@nanopsycho>
        <CAACQVJpRrOSn2eLzS1z9rmATrmzA2aNG-9pcbn-1E+sQJ5ET_g@mail.gmail.com>
        <20200526044727.GB14161@nanopsycho>
        <CAACQVJp8SfmP=R=YywDWC8njhA=ntEcs5o_KjBoHafPkHaj-iA@mail.gmail.com>
        <20200526134032.GD14161@nanopsycho>
        <CAACQVJrwFB4oHjTAw4DK28grxGGP15x52+NskjDtOYQdOUMbOg@mail.gmail.com>
        <CAACQVJqTc9s2KwUCEvGLfG3fh7kKj3-KmpeRgZMWM76S-474+w@mail.gmail.com>
        <20200527131401.2e269ab8@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
        <CACKFLi=+Q4CkOvaxQQm5Ya8+Ft=jNMwCAuK+=5SMxAfNGGriBw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 27 May 2020 13:57:11 -0700 Michael Chan wrote:
> On Wed, May 27, 2020 at 1:14 PM Jakub Kicinski <kuba@kernel.org> wrote:
> > On Wed, 27 May 2020 09:07:09 +0530 Vasundhara Volam wrote:  
> > > Here is a sample sequence of commands to do a "live reset" to get some
> > > clear idea.
> > > Note that I am providing the examples based on the current patchset.
> > >
> > > 1. FW live reset is disabled in the device/adapter. Here adapter has 2
> > > physical ports.
> > >
> > > $ devlink dev
> > > pci/0000:3b:00.0
> > > pci/0000:3b:00.1
> > > pci/0000:af:00.0
> > > $ devlink dev param show pci/0000:3b:00.0 name allow_fw_live_reset
> > > pci/0000:3b:00.0:
> > >   name allow_fw_live_reset type generic
> > >     values:
> > >       cmode runtime value false
> > >       cmode permanent value false
> > > $ devlink dev param show pci/0000:3b:00.1 name allow_fw_live_reset
> > > pci/0000:3b:00.1:
> > >   name allow_fw_live_reset type generic
> > >     values:
> > >       cmode runtime value false
> > >       cmode permanent value false  
> >
> > What's the permanent value? What if after reboot the driver is too old
> > to change this, is the reset still allowed?  
> 
> The permanent value should be the NVRAM value.  If the NVRAM value is
> false, the feature is always and unconditionally disabled.  If the
> permanent value is true, the feature will only be available when all
> loaded drivers indicate support for it and set the runtime value to
> true.  If an old driver is loaded afterwards, it wouldn't indicate
> support for this feature and it wouldn't set the runtime value to
> true.  So the feature will not be available until the old driver is
> unloaded or upgraded.

Setting this permanent value to false makes the FW's life easier?
Otherwise why not always have it enabled and just depend on hosts 
not opting in?

> > > 2. If a user issues "ethtool --reset p1p1 all", the device cannot
> > > perform "live reset" as capability is not enabled.
> > >
> > > User needs to do a driver reload, for firmware to undergo reset.  
> >
> > Why does driver reload have anything to do with resetting a potentially
> > MH device?  
> 
> I think she meant that all drivers have to be unloaded before the
> reset would take place in case it's a MH device since live reset is
> not supported.  If it's a single function device, unloading this
> driver is sufficient.

I see.

> > > $ ethtool --reset p1p1 all  
> >
> > Reset probably needs to be done via devlink. In any case you need a new
> > reset level for resetting MH devices and smartnics, because the current
> > reset mask covers port local, and host local cases, not any form of MH.  
> 
> RIght.  This reset could be just a single function reset in this example.

Well, for the single host scenario the parameter dance is not at all
needed, since there is only one domain of control. If user can issue a
reset they can as well change the value of the param or even reload the
driver. The runtime parameter only makes sense in MH/SmartNIC scenario,
so IMHO the param and devlink reset are strongly dependent.

> > > ETHTOOL_RESET 0xffffffff
> > > Components reset:     0xff0000
> > > Components not reset: 0xff00ffff
> > > $ dmesg
> > > [  198.745822] bnxt_en 0000:3b:00.0 p1p1: Firmware reset request successful.
> > > [  198.745836] bnxt_en 0000:3b:00.0 p1p1: Reload driver to complete reset  
> >
> > You said the reset was not performed, yet there is no information to
> > that effect in the log?!  
> 
> The firmware has been requested to reset, but the reset hasn't taken
> place yet because live reset cannot be done.  We can make the logs
> more clear.

Thanks

> > > 3. Now enable the capability in the device and reboot for device to
> > > enable the capability. Firmware does not get reset just by setting the
> > > param to true.
> > >
> > > $ devlink dev param set pci/0000:3b:00.1 name allow_fw_live_reset
> > > value true cmode permanent
> > >
> > > 4. After reboot, values of param.  
> >
> > Is the reboot required here?
> 
> In general, our new NVRAM permanent parameters will take effect after
> reset (or reboot).
>
> > > $ devlink dev param show pci/0000:3b:00.1 name allow_fw_live_reset
> > > pci/0000:3b:00.1:
> > >   name allow_fw_live_reset type generic
> > >     values:
> > >       cmode runtime value true  
> >
> > Why is runtime value true now?
> >  
> 
> If the permanent (NVRAM) parameter is true, all loaded new drivers
> will indicate support for this feature and set the runtime value to
> true by default.  The runtime value would not be true if any loaded
> driver is too old or has set the runtime value to false.

Okay, the parameter has a bit of a dual role as it controls whether the
feature is available (false -> true transition requiring a reset/reboot)
and the default setting of the runtime parameter. Let's document that
more clearly.
