Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C36B7222EE0
	for <lists+netdev@lfdr.de>; Fri, 17 Jul 2020 01:18:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726794AbgGPXSr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jul 2020 19:18:47 -0400
Received: from mx4.wp.pl ([212.77.101.12]:58632 "EHLO mx4.wp.pl"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726189AbgGPXSr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Jul 2020 19:18:47 -0400
Received: (wp-smtpd smtp.wp.pl 15203 invoked from network); 17 Jul 2020 00:18:41 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=wp.pl; s=1024a;
          t=1594937922; bh=sFizejYWzFB+KZZgmMEck1i24WnVHDhLA/a0hj/Zht0=;
          h=From:To:Cc:Subject;
          b=C2ixhtibdkWf2A26zuiIMUrzlinC7q080GEwTbFWYuBakPCnU0GUd+1gl5T4B6iYv
           kLkCLzn7D1XPoeymkI4kV92f00cCqvYXgu3JE8UNwk/R7KXGYbylxAHsaBp3ADhK49
           QONZgoJaGPBlrBWWcoxCtIx3yiGGRR3YitJawBJk=
Received: from unknown (HELO kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com) (kubakici@wp.pl@[163.114.132.6])
          (envelope-sender <kubakici@wp.pl>)
          by smtp.wp.pl (WP-SMTPD) with ECDHE-RSA-AES256-GCM-SHA384 encrypted SMTP
          for <jacob.e.keller@intel.com>; 17 Jul 2020 00:18:41 +0200
Date:   Thu, 16 Jul 2020 15:18:33 -0700
From:   Jakub Kicinski <kubakici@wp.pl>
To:     Jacob Keller <jacob.e.keller@intel.com>,
        Tom Herbert <tom@herbertland.com>
Cc:     netdev@vger.kernel.org, Jiri Pirko <jiri@resnulli.us>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>
Subject: Re: [RFC PATCH net-next 6/6] ice: implement devlink parameters to
 control flash update
Message-ID: <20200716151833.3b21d277@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <2ce3eb56-69e3-91fe-96a2-e5e538846e9f@intel.com>
References: <20200709212652.2785924-1-jacob.e.keller@intel.com>
        <20200709212652.2785924-7-jacob.e.keller@intel.com>
        <20200709171913.5b779cc7@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <ee8fc0a5-6cea-2689-372c-4e733cc06056@intel.com>
        <20200710132516.24994a33@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <0a12dbf7-58be-b0ad-53d7-61748b081b38@intel.com>
        <4c6a39f4-5ff2-b889-086a-f7c99990bd4c@intel.com>
        <20200715162329.4224fa6f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <d8f88c91-57fa-9ca4-1838-5f63b6613c59@intel.com>
        <58840317-e818-af52-352a-19008b89bee7@intel.com>
        <20200716144208.4e602320@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <2ce3eb56-69e3-91fe-96a2-e5e538846e9f@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-WP-MailID: cb8333fca536673b61ecaf3513108baa
X-WP-AV: skaner antywirusowy Poczty Wirtualnej Polski
X-WP-SPAM: NO 0000004 [kaeS]                               
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 16 Jul 2020 14:52:15 -0700 Jacob Keller wrote:
> On 7/16/2020 2:42 PM, Jakub Kicinski wrote:
> > On Thu, 16 Jul 2020 14:29:40 -0700 Jacob Keller wrote:  
> >> On 7/15/2020 5:21 PM, Jacob Keller wrote:  
> >>> Ok, that seems reasonable. Ofcourse we'll need to find something generic
> >>> enough that it can be re-used and isn't driver specific.  
> >>
> >> Hi Jakub,
> >>
> >> I think I have something that will be more clear and will be sending a
> >> new RFC with the change this afternoon:
> >>
> >> an extension to the DEVLINK_CMD_FLASH_UPDATE with a new parameter,
> >> "overwrite" with these values:
> >>
> >> a) "nothing" (or maybe, "firmware-only" or "binary-only"?, need a way to
> >> clarify difference between settings/vital data and firmware program
> >> binary) will request that we do not overwrite any settings or fields.
> >> This is equivalent to the "PRESERVE_ALL" I had in the original proposal,
> >> where we will maintain all settings and all vital data, but update the
> >> firmware binary.
> >>
> >> b) "settings" will request that the firmware overwrite all the settings
> >> fields with the contents from the new image. However, vital data such as
> >> the PCI Serial ID, VPD section, MAC Addresses, and similar "static" data
> >> will be kept (not overwritten). This is the same as the
> >> "PRESERVE_LIMITED" option I had in the original proposal
> >>
> >> c) "all" or "everything" will request that firmware overwrite all
> >> contents of the image. This means all settings and all vital data will
> >> be overwritten by the contents in the new image.  
> > 
> > Sorry but I'm still not 100% sure of what the use for this option is
> > beyond an OEM. Is it possible to reset the VPD, board serial, MAC
> > address etc. while flashing a FW image downloaded from a support site?
> > Would that mean that if I flash a rack with one FW image all NICs will
> > start reporting the same serial numbers and use the same MACs?
> 
> I think the intent here is for OEMs which would generate/customize the
> images, though I've also been told it may be useful to get a card out of
> some situation where firmware preservation was broken.. (No, I don't
> really have more details on what specifically the situation might be).
> Obviously in most update cases I don't think we expect this to be used.

What I'm getting at is that this seems to inherently require a special
FW image which will carry unique IDs, custom-selected for a particular
board. So I was hoping we can infer the setting from the image being
flashed. But perhaps that's risky.

Let's make sure the description of the option captures the fact that
this is mostly useful in manufacturing and otherwise very rarely needed.

> >> d) if we need it, a "default" that would be the current behavior of
> >> doing whatever the driver default is? (since it's not clear to me what
> >> other implementations do but perhaps they all behavior as either
> >> "nothing" or "all"?  
> > 
> > As a user I'd expect "nothing" to be the default. Same as your OS
> > update does not wipe out your settings. I think it's also better 
> > if the default is decided by Linux, not the drivers.
> 
> Right, but I wasn't sure what other drivers/devices implement today and
> didn't want  to end up in a "well we don't behave that way so you just
> changed our behavior"..? Hmm. If they all behave this way today then
> it's fine to make "nothing" the default and modify all implementations
> to reject other options.

Understood. Let's make things clear in the submission and CC
maintainers of all drivers which implement devlink flashing today.
Let them complain. If we're too cautious we'll never arrive on sane
defaults.

> >> I think I agree that "factory" settings doesn't really belong here, and
> >> I will try to push for finding an alternative way to allow access to
> >> that behavior. If we wanted it we could use "from_factory" to request
> >> that we overwrite the settings and  vital data "from" the factory
> >> portion, but I think that is pushing the boundary here a bit...
> >>
> >> I am aiming to have a new patch up with this proposal  
> > 
> > Probably best if we understand the use case more clearly, too. Since
> > you have this implemented in your tooling what are the scenarios where
> > factory is expected to be preferred over FW default?
> 
> I'll see if I can gather any further information on both this and the
> overwrite-all mode.
> 
> My understanding so far is that it is intended as a way to restore the
> device settings/config to what was written in the factory. I agree from
> Linux perspective having this be a separate command (without requiring
> an update) would make the most sense, but that isn't how it was
> implemented today.
> 
> The factory settings are stored in a separate section of flash so they
> aren't modified by normal update flows. I am not sure if there is a
> procedure for updating them or if it truly is write-once.

