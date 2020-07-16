Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B505222E1A
	for <lists+netdev@lfdr.de>; Thu, 16 Jul 2020 23:42:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726189AbgGPVmT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jul 2020 17:42:19 -0400
Received: from mx3.wp.pl ([212.77.101.9]:22753 "EHLO mx3.wp.pl"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726002AbgGPVmT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Jul 2020 17:42:19 -0400
Received: (wp-smtpd smtp.wp.pl 25735 invoked from network); 16 Jul 2020 23:42:15 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=wp.pl; s=1024a;
          t=1594935735; bh=lREl+mR8j/fmAa9cMi/EQg6a3B93xZKTLaXTrhEChOA=;
          h=From:To:Cc:Subject;
          b=yiLitJayDlXSZiGFVrCAmgeXRtusjTtxPRqMkDOKt8n3/3ST37thA/iQtUR85gTfr
           t52LG5LNhV2ThDSm6/FyN3KIAv7dqxX+AuRm2ZDO7XKX8VlkhZt86XCoLffges+r+3
           mhjUqTa54A82tlnIOJJs6hNFt+hAd7NsLKoxRqHE=
Received: from unknown (HELO kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com) (kubakici@wp.pl@[163.114.132.6])
          (envelope-sender <kubakici@wp.pl>)
          by smtp.wp.pl (WP-SMTPD) with ECDHE-RSA-AES256-GCM-SHA384 encrypted SMTP
          for <jacob.e.keller@intel.com>; 16 Jul 2020 23:42:15 +0200
Date:   Thu, 16 Jul 2020 14:42:08 -0700
From:   Jakub Kicinski <kubakici@wp.pl>
To:     Jacob Keller <jacob.e.keller@intel.com>
Cc:     netdev@vger.kernel.org, Jiri Pirko <jiri@resnulli.us>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tom Herbert <tom@herbertland.com>
Subject: Re: [RFC PATCH net-next 6/6] ice: implement devlink parameters to
 control flash update
Message-ID: <20200716144208.4e602320@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <58840317-e818-af52-352a-19008b89bee7@intel.com>
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
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-WP-MailID: 2ef46fabbc34132a88281f22736e370c
X-WP-AV: skaner antywirusowy Poczty Wirtualnej Polski
X-WP-SPAM: NO 0000004 [0bey]                               
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 16 Jul 2020 14:29:40 -0700 Jacob Keller wrote:
> On 7/15/2020 5:21 PM, Jacob Keller wrote:
> > Ok, that seems reasonable. Ofcourse we'll need to find something generic
> > enough that it can be re-used and isn't driver specific.
> 
> Hi Jakub,
> 
> I think I have something that will be more clear and will be sending a
> new RFC with the change this afternoon:
> 
> an extension to the DEVLINK_CMD_FLASH_UPDATE with a new parameter,
> "overwrite" with these values:
> 
> a) "nothing" (or maybe, "firmware-only" or "binary-only"?, need a way to
> clarify difference between settings/vital data and firmware program
> binary) will request that we do not overwrite any settings or fields.
> This is equivalent to the "PRESERVE_ALL" I had in the original proposal,
> where we will maintain all settings and all vital data, but update the
> firmware binary.
> 
> b) "settings" will request that the firmware overwrite all the settings
> fields with the contents from the new image. However, vital data such as
> the PCI Serial ID, VPD section, MAC Addresses, and similar "static" data
> will be kept (not overwritten). This is the same as the
> "PRESERVE_LIMITED" option I had in the original proposal
> 
> c) "all" or "everything" will request that firmware overwrite all
> contents of the image. This means all settings and all vital data will
> be overwritten by the contents in the new image.

Sorry but I'm still not 100% sure of what the use for this option is
beyond an OEM. Is it possible to reset the VPD, board serial, MAC
address etc. while flashing a FW image downloaded from a support site?
Would that mean that if I flash a rack with one FW image all NICs will
start reporting the same serial numbers and use the same MACs?

> d) if we need it, a "default" that would be the current behavior of
> doing whatever the driver default is? (since it's not clear to me what
> other implementations do but perhaps they all behavior as either
> "nothing" or "all"?

As a user I'd expect "nothing" to be the default. Same as your OS
update does not wipe out your settings. I think it's also better 
if the default is decided by Linux, not the drivers.

> I think I agree that "factory" settings doesn't really belong here, and
> I will try to push for finding an alternative way to allow access to
> that behavior. If we wanted it we could use "from_factory" to request
> that we overwrite the settings and  vital data "from" the factory
> portion, but I think that is pushing the boundary here a bit...
> 
> I am aiming to have a new patch up with this proposal

Probably best if we understand the use case more clearly, too. Since
you have this implemented in your tooling what are the scenarios where
factory is expected to be preferred over FW default?
