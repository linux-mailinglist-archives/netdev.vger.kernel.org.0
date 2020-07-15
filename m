Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F2A622185A
	for <lists+netdev@lfdr.de>; Thu, 16 Jul 2020 01:23:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726796AbgGOXXl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jul 2020 19:23:41 -0400
Received: from mx3.wp.pl ([212.77.101.9]:24120 "EHLO mx3.wp.pl"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726770AbgGOXXl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 15 Jul 2020 19:23:41 -0400
Received: (wp-smtpd smtp.wp.pl 13799 invoked from network); 16 Jul 2020 01:23:36 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=wp.pl; s=1024a;
          t=1594855417; bh=YtH/VdR7t7kwVuF8aaCf+Spu+qpanY02ftNa+wo7Rh8=;
          h=From:To:Cc:Subject;
          b=weedJY8jU6AzyBCsybi7gfpUx7X6/Yi/PSHiu/pmRFvVXx+Pgpef5D/8GhaoaXbX/
           oKPkUp3IVgVpzNxeuRDNqolWfxV2hVnW+Xrltti7knX6u/nVDB5UQ+Gx5yy7XjdVdm
           KBe/hKi5eIjCHS0IH8CA3N8kJ5/wzgvpEiC1e7Uo=
Received: from unknown (HELO kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com) (kubakici@wp.pl@[163.114.132.4])
          (envelope-sender <kubakici@wp.pl>)
          by smtp.wp.pl (WP-SMTPD) with ECDHE-RSA-AES256-GCM-SHA384 encrypted SMTP
          for <jacob.e.keller@intel.com>; 16 Jul 2020 01:23:36 +0200
Date:   Wed, 15 Jul 2020 16:23:29 -0700
From:   Jakub Kicinski <kubakici@wp.pl>
To:     Jacob Keller <jacob.e.keller@intel.com>
Cc:     netdev@vger.kernel.org, Jiri Pirko <jiri@resnulli.us>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tom Herbert <tom@herbertland.com>
Subject: Re: [RFC PATCH net-next 6/6] ice: implement devlink parameters to
 control flash update
Message-ID: <20200715162329.4224fa6f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <4c6a39f4-5ff2-b889-086a-f7c99990bd4c@intel.com>
References: <20200709212652.2785924-1-jacob.e.keller@intel.com>
        <20200709212652.2785924-7-jacob.e.keller@intel.com>
        <20200709171913.5b779cc7@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <ee8fc0a5-6cea-2689-372c-4e733cc06056@intel.com>
        <20200710132516.24994a33@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <0a12dbf7-58be-b0ad-53d7-61748b081b38@intel.com>
        <4c6a39f4-5ff2-b889-086a-f7c99990bd4c@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-WP-MailID: d01ee6eba21ff9d6accd39e5eb6acca7
X-WP-AV: skaner antywirusowy Poczty Wirtualnej Polski
X-WP-SPAM: NO 0000004 [kTcS]                               
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 15 Jul 2020 14:41:04 -0700 Jacob Keller wrote:
> To summarize this discussion, the next spin will have the following changes:
> 
> 1) remove all parameters except for the preservation_level. Both
> ignore_pending_flash_update and allow_downgrade_on_flash_update will be
> removed and change the default behavior to the most accepting case:
> updates will always be tried even if firmware says its a downgrade, and
> we will always cancel a pending update. We will now expect user space
> tools to be aware of this and handle the equivalent options themselves
> if they desire.
> 
> 2) reset_after_flash_update will be removed, and we will replace it with
> a new interface, perhaps like the devlink reset command suggested in
> another thread.
> 
> 3) preservation_level will remain, but I have updated the documentation
> slightly.

Okay, then. But let's make it a parameter to the flash update operation
(extend the uAPI), rather than a devlink param, shall we?

> Unfortunately it looks like FACTORY_SETTINGS option is not directly
> available without doing an update. It may work with a sort of "update to
> the same version" but I'm not sure if or how we could implement that
> silently in the driver. There's no other way to ask firmware to perform
> factory reset though. Otherwise I would remove this and make it part of
> a new command.

If the settings are restored from within the device and not the flashed
image - it sounds like it's a matter of a FW change to add this
functionality. Right? Maybe it's not immediately necessary if we go
with the new option to flashing.

> I'd also like to clarify the reasoning behind all of the options. The
> preservation is referring to "what to keep in the existing NVM", so
> "PRESERVE_ALL" is the one where the most fields and data are kept by the
> firmware when updating. In this mode, we do not change any settings,
> device-specific fields, or other configuration. This is the default.
> With "PRESERVE_LIMITED" the limited subset of device-specific fields are
> preserved, but all of the settings and configuration are overwritten.
> With PRESERVE_NONE, we simply write what is in the image.

IMO we need to come up with names for the reset levels which
correspond to what's being reset more directly. Ones which will
actually be meaningful without a 4-email-exchange with the developer :) 

It makes immediate sense to me to reset any subset of { settings,
identifying information }. But I don't see how reset to factory
defaults fits into this. Is it controlling the source of the defaults?
I.e. reset to factory defaults vs reset to FW build defaults?

> The intent behind this parameter is to enable our existing tools to
> learn the devlink tool while being able to maintain existing behavior.
> For other operating systems, these tools support the preservation level,
> so without this parameter, we would not be able to support it. The
> expectation is that most of the time PRESERVE_ALL is the correct mode.
> However, the other options do have some usefulness, either when
> debugging or to recover from bad situations such as if the firmware
> preservation doesn't behave properly as expected.
> 
> I hope this information further clarifies our goals and why I believe
> the parameter is valuable.

