Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 74E8B21ABF7
	for <lists+netdev@lfdr.de>; Fri, 10 Jul 2020 02:26:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726768AbgGJA0D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jul 2020 20:26:03 -0400
Received: from mx3.wp.pl ([212.77.101.10]:26518 "EHLO mx3.wp.pl"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726268AbgGJA0C (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 9 Jul 2020 20:26:02 -0400
X-Greylist: delayed 399 seconds by postgrey-1.27 at vger.kernel.org; Thu, 09 Jul 2020 20:26:01 EDT
Received: (wp-smtpd smtp.wp.pl 26509 invoked from network); 10 Jul 2020 02:19:19 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=wp.pl; s=1024a;
          t=1594340360; bh=M5kJMGGyLbRJI0K3J9+lfwIuZIDjk6vnZpUUDKpqNdg=;
          h=From:To:Cc:Subject;
          b=lBHZUaW8hRxMnekHsOKxmJc01IfrWBXBPdMzcvu+sIsA3HXuPfz2VmsPtYcafPIoY
           UT3IKaf6n6XQan1Xj9PfuihWJ0uECY+yzwNHTGccdoXhD0Smvh5W3fQBjtpXhYu7MK
           Br9T2FxKBpQduNqdW+mYtZeKeWuMrH/x7pvBuegI=
Received: from unknown (HELO kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com) (kubakici@wp.pl@[163.114.132.1])
          (envelope-sender <kubakici@wp.pl>)
          by smtp.wp.pl (WP-SMTPD) with ECDHE-RSA-AES256-GCM-SHA384 encrypted SMTP
          for <jacob.e.keller@intel.com>; 10 Jul 2020 02:19:19 +0200
Date:   Thu, 9 Jul 2020 17:19:13 -0700
From:   Jakub Kicinski <kubakici@wp.pl>
To:     Jacob Keller <jacob.e.keller@intel.com>
Cc:     netdev@vger.kernel.org, Jiri Pirko <jiri@resnulli.us>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tom Herbert <tom@herbertland.com>
Subject: Re: [RFC PATCH net-next 6/6] ice: implement devlink parameters to
 control flash update
Message-ID: <20200709171913.5b779cc7@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200709212652.2785924-7-jacob.e.keller@intel.com>
References: <20200709212652.2785924-1-jacob.e.keller@intel.com>
        <20200709212652.2785924-7-jacob.e.keller@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-WP-MailID: c3d5630feb57bfa7f6eee5e1d8f71ca8
X-WP-AV: skaner antywirusowy Poczty Wirtualnej Polski
X-WP-SPAM: NO 0000004 [URcl]                               
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu,  9 Jul 2020 14:26:52 -0700 Jacob Keller wrote:
> The flash update for the ice hardware currently supports a single fixed
> configuration:
> 
> * Firmware is always asked to preserve all changeable fields
> * The driver never allows downgrades
> * The driver will not allow canceling a previous update that never
>   completed (for example because an EMP reset never occurred)
> * The driver does not attempt to trigger an EMP reset immediately.
> 
> This default mode of operation is reasonable. However, it is often
> useful to allow system administrators more control over the update
> process. To enable this, implement devlink parameters that allow the
> system administrator to specify the desired behaviors:
> 
> * 'reset_after_flash_update'
>   If enabled, the driver will request that the firmware immediately
>   trigger an EMP reset when completing the device update. This will
>   result in the device switching active banks immediately and
>   re-initializing with the new firmware.

This should probably be handled through a reset API like what
Vasundhara is already working on.

> * 'allow_downgrade_on_flash_update'
>   If enabled, the driver will attempt to update device flash even when
>   firmware indicates that such an update would be a downgrade.
> * 'ignore_pending_flash_update'
>   If enabled, the device driver will cancel a previous pending update.
>   A pending update is one where the steps to write the update to the NVM
>   bank has finished, but the device never reset, as the system had not
>   yet been rebooted.

These can be implemented in user space based on the values of running
and stored versions from devlink info.

> * 'flash_update_preservation_level'
>   The value determines the preservation mode to request from firmware,
>   among the following 4 choices:
>   * PRESERVE_ALL (0)
>     Preserve all settings and fields in the NVM configuration
>   * PRESERVE_LIMITED (1)
>     Preserve only a limited set of fields, including the VPD, PCI serial
>     ID, MAC address, etc. This results in permanent settings being
>     reset, including changes to the port configuration, such as the
>     number of physical functions created.
>   * PRESERVE_FACTORY_SETTINGS (2)
>     Reset all configuration fields to the factory default settings
>     stored within the NVM.
>   * PRESERVE_NONE (3)
>     Do not perform any preservation.

Could this also be handled in a separate reset API? It seems useful to
be able to reset to factory defaults at any time, not just FW upgrade..
