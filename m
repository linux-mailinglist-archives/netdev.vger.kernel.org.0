Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9694221BE68
	for <lists+netdev@lfdr.de>; Fri, 10 Jul 2020 22:25:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727820AbgGJUZa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jul 2020 16:25:30 -0400
Received: from mx4.wp.pl ([212.77.101.12]:39730 "EHLO mx4.wp.pl"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726828AbgGJUZ3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 10 Jul 2020 16:25:29 -0400
Received: (wp-smtpd smtp.wp.pl 11096 invoked from network); 10 Jul 2020 22:25:24 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=wp.pl; s=1024a;
          t=1594412724; bh=To+VloMcsEc9e2vbW9bPE28LAUJlsKWrcG6AYS89Ga4=;
          h=From:To:Cc:Subject;
          b=vYCJeg8EqbXIj1NBnteefSZJDJraPTrGxFW8RcP5A2yxZ0CAjiHMM5CsObHAslunV
           +E68efCBtgo4QPcmPWGTmG1u0muzRPuoaL78p4gTapxHWOIrMRDbARMsdsw61cGIk4
           GBvWr9sRfAsCKbh/pWplXxp6uX1ERZ1njkn5pbsY=
Received: from unknown (HELO kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com) (kubakici@wp.pl@[163.114.132.6])
          (envelope-sender <kubakici@wp.pl>)
          by smtp.wp.pl (WP-SMTPD) with ECDHE-RSA-AES256-GCM-SHA384 encrypted SMTP
          for <jacob.e.keller@intel.com>; 10 Jul 2020 22:25:24 +0200
Date:   Fri, 10 Jul 2020 13:25:16 -0700
From:   Jakub Kicinski <kubakici@wp.pl>
To:     Jacob Keller <jacob.e.keller@intel.com>
Cc:     netdev@vger.kernel.org, Jiri Pirko <jiri@resnulli.us>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tom Herbert <tom@herbertland.com>
Subject: Re: [RFC PATCH net-next 6/6] ice: implement devlink parameters to
 control flash update
Message-ID: <20200710132516.24994a33@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <ee8fc0a5-6cea-2689-372c-4e733cc06056@intel.com>
References: <20200709212652.2785924-1-jacob.e.keller@intel.com>
        <20200709212652.2785924-7-jacob.e.keller@intel.com>
        <20200709171913.5b779cc7@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <ee8fc0a5-6cea-2689-372c-4e733cc06056@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-WP-MailID: ac86915149baf49df119f44289e7b215
X-WP-AV: skaner antywirusowy Poczty Wirtualnej Polski
X-WP-SPAM: NO 0000004 [4Vdy]                               
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 10 Jul 2020 10:32:24 -0700 Jacob Keller wrote:
> On 7/9/2020 5:19 PM, Jakub Kicinski wrote:
> > On Thu,  9 Jul 2020 14:26:52 -0700 Jacob Keller wrote:  
> >> The flash update for the ice hardware currently supports a single fixed
> >> configuration:
> >>
> >> * Firmware is always asked to preserve all changeable fields
> >> * The driver never allows downgrades
> >> * The driver will not allow canceling a previous update that never
> >>   completed (for example because an EMP reset never occurred)
> >> * The driver does not attempt to trigger an EMP reset immediately.
> >>
> >> This default mode of operation is reasonable. However, it is often
> >> useful to allow system administrators more control over the update
> >> process. To enable this, implement devlink parameters that allow the
> >> system administrator to specify the desired behaviors:
> >>
> >> * 'reset_after_flash_update'
> >>   If enabled, the driver will request that the firmware immediately
> >>   trigger an EMP reset when completing the device update. This will
> >>   result in the device switching active banks immediately and
> >>   re-initializing with the new firmware.  
> > 
> > This should probably be handled through a reset API like what
> > Vasundhara is already working on.
> 
> Sure. I hadn't seen that work but I'll go take a look.
> 
> >> * 'allow_downgrade_on_flash_update'
> >>   If enabled, the driver will attempt to update device flash even when
> >>   firmware indicates that such an update would be a downgrade.  
> 
> There is also some trickiness here, because what this parameter does is
> cause the driver to ignore the firmware version check. I suppose we
> could just change the default behavior to ignoring that and assume user
> space will check itself?

Seems only appropriate to me.

I assume this is a safety check because downgrades are sometimes
impossible without factory reset (new FW version makes incompatible
changes to the NVM params or such)? FWIW that's a terrible user
experience, best avoided and handled as a exceptional circumstance
which it should be.

The defaults should be any FW version can be installed after any FW
version. Including downgrades, skipping versions etc.

> >> * 'ignore_pending_flash_update'
> >>   If enabled, the device driver will cancel a previous pending update.
> >>   A pending update is one where the steps to write the update to the NVM
> >>   bank has finished, but the device never reset, as the system had not
> >>   yet been rebooted.  
> > 
> > These can be implemented in user space based on the values of running
> > and stored versions from devlink info.  
> 
> So, there's some trickiness here. We actually have to perform some steps
> to cancel an update. Perhaps we should introduce a new option to request
> that a previous update be cancelled? If we don't tell the firmware to
> cancel the update, then future update requests will simply fail with
> some errors.

Can't it be canceled automatically when user requests a new image to
be flashed?

Perhaps best to think about it from the user perspective rather than
how the internal works. User wants a new FW, they flash it. Next boot -
the last flashed version should be activated.

If user wants to "cancel" and upgrade they will most likely flash the
previous version of the FW.

Is the pending update/ability to cancel thing also part of the DTMF
spec?

> >> * 'flash_update_preservation_level'
> >>   The value determines the preservation mode to request from firmware,
> >>   among the following 4 choices:
> >>   * PRESERVE_ALL (0)
> >>     Preserve all settings and fields in the NVM configuration
> >>   * PRESERVE_LIMITED (1)
> >>     Preserve only a limited set of fields, including the VPD, PCI serial
> >>     ID, MAC address, etc. This results in permanent settings being
> >>     reset, including changes to the port configuration, such as the
> >>     number of physical functions created.
> >>   * PRESERVE_FACTORY_SETTINGS (2)
> >>     Reset all configuration fields to the factory default settings
> >>     stored within the NVM.
> >>   * PRESERVE_NONE (3)
> >>     Do not perform any preservation.  
> > 
> > Could this also be handled in a separate reset API? It seems useful to
> > be able to reset to factory defaults at any time, not just FW upgrade..
>
> I'm not sure. At least the way it's described in the datasheet here is
> that this must be done during an update. I'll have to look into this
> further.
> 
> For the other 3 (I kept preserve none for completeness), these are
> referring to how much of the settings we preserve when updating to the
> new image, so I think they only apply at update time.

Not sure what the difference is between 2 and 3.

Not sure differentiating between 0 and 1 matters in practice. Clearly
users will not do 0 in the field, cause they don't have new IDs assigned
per product, and don't want to loose the IDs they put in their HW DB.

0 is only something a OEM can use, right? OEMs presumably generate the
image per device to flash the IDs, meaning difference between 0 and 1
seems to be equivalent to flashing a special OEM FW package vs flashing
a normal customer FW update...
