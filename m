Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F12AC1E4F00
	for <lists+netdev@lfdr.de>; Wed, 27 May 2020 22:14:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728149AbgE0UOF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 May 2020 16:14:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:45120 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726887AbgE0UOE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 27 May 2020 16:14:04 -0400
Received: from kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BB9CB2073B;
        Wed, 27 May 2020 20:14:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590610444;
        bh=xDqL+7wCx+Yw6YyP2dedBJCsLJSoJR2OYd8fxMjAi8I=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=oJ3f/7ME3fBb2y4vFWcD7txKvfYkxEg9Ho2LjZgMqqUUYC4krH5vefQNUgVTvVEze
         pdiBJ4cqLxh+eUlSeJoWpzaoSiYbuipOWZ8jjAYAcLOf+9Fdh28ptaQfTFQJUYXwn2
         xb4DNrIAbgfh4rV3QzfgB6QkUG84cYsMdK6tvjc4=
Date:   Wed, 27 May 2020 13:14:01 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Vasundhara Volam <vasundhara-v.volam@broadcom.com>
Cc:     Jiri Pirko <jiri@resnulli.us>, David Miller <davem@davemloft.net>,
        Netdev <netdev@vger.kernel.org>, Jiri Pirko <jiri@mellanox.com>,
        Michael Chan <michael.chan@broadcom.com>
Subject: Re: [PATCH v2 net-next 1/4] devlink: Add new "allow_fw_live_reset"
 generic device parameter.
Message-ID: <20200527131401.2e269ab8@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <CAACQVJqTc9s2KwUCEvGLfG3fh7kKj3-KmpeRgZMWM76S-474+w@mail.gmail.com>
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
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 27 May 2020 09:07:09 +0530 Vasundhara Volam wrote:
> Here is a sample sequence of commands to do a "live reset" to get some
> clear idea.
> Note that I am providing the examples based on the current patchset.
> 
> 1. FW live reset is disabled in the device/adapter. Here adapter has 2
> physical ports.
> 
> $ devlink dev
> pci/0000:3b:00.0
> pci/0000:3b:00.1
> pci/0000:af:00.0
> $ devlink dev param show pci/0000:3b:00.0 name allow_fw_live_reset
> pci/0000:3b:00.0:
>   name allow_fw_live_reset type generic
>     values:
>       cmode runtime value false
>       cmode permanent value false
> $ devlink dev param show pci/0000:3b:00.1 name allow_fw_live_reset
> pci/0000:3b:00.1:
>   name allow_fw_live_reset type generic
>     values:
>       cmode runtime value false
>       cmode permanent value false

What's the permanent value? What if after reboot the driver is too old
to change this, is the reset still allowed?

> 2. If a user issues "ethtool --reset p1p1 all", the device cannot
> perform "live reset" as capability is not enabled.
>
> User needs to do a driver reload, for firmware to undergo reset.

Why does driver reload have anything to do with resetting a potentially
MH device?

> $ ethtool --reset p1p1 all

Reset probably needs to be done via devlink. In any case you need a new
reset level for resetting MH devices and smartnics, because the current
reset mask covers port local, and host local cases, not any form of MH.

> ETHTOOL_RESET 0xffffffff
> Components reset:     0xff0000
> Components not reset: 0xff00ffff
> $ dmesg
> [  198.745822] bnxt_en 0000:3b:00.0 p1p1: Firmware reset request successful.
> [  198.745836] bnxt_en 0000:3b:00.0 p1p1: Reload driver to complete reset

You said the reset was not performed, yet there is no information to
that effect in the log?!

> 3. Now enable the capability in the device and reboot for device to
> enable the capability. Firmware does not get reset just by setting the
> param to true.
> 
> $ devlink dev param set pci/0000:3b:00.1 name allow_fw_live_reset
> value true cmode permanent
> 
> 4. After reboot, values of param.

Is the reboot required here?

> $ devlink dev param show pci/0000:3b:00.1 name allow_fw_live_reset
> pci/0000:3b:00.1:
>   name allow_fw_live_reset type generic
>     values:
>       cmode runtime value true

Why is runtime value true now?

>       cmode permanent value true
> $ devlink dev param show pci/0000:3b:00.0 name allow_fw_live_reset
> pci/0000:3b:00.0:
>   name allow_fw_live_reset type generic
>     values:
>       cmode runtime value true
>       cmode permanent value true
> 
> 5. Now issue the "ethtool --reset p1p1 all" and device will undergo
> the "live reset". Reloading the driver is not required.
> 
> $ ethtool --reset p1p1 all
> ETHTOOL_RESET 0xffffffff
> Components reset:     0xff0000
> Components not reset: 0xff00ffff
> $ dmesg
> [  117.432013] bnxt_en 0000:3b:00.0 p1p1: Firmware non-fatal reset
> event received, max wait time 4200 msec
> [  117.432015] bnxt_en 0000:3b:00.0 p1p1: Firmware reset request successful.
> [  117.432032] bnxt_en 0000:3b:00.1 p1p2: Firmware non-fatal reset
> event received, max wait time 4200 msec
> $ devlink health show pci/0000:3b:00.0 reporter fw_reset
> pci/0000:3b:00.0:
>   reporter fw_reset
>     state healthy error 1 recover 1 grace_period 0 auto_recover true
> 
> 6. If one of the host/PF turns off runtime param to false, "ethtool
> --reset p1p1 all" behaves similar to step 2, until it turns it back
> on.
> 
> $ devlink dev param set pci/0000:3b:00.1 name allow_fw_live_reset
> value false cmode runtime
> $ ethtool --reset p1p1 all
> ETHTOOL_RESET 0xffffffff
> Components reset:     0xff0000
> Components not reset: 0xff00ffff
> $ dmesg
> [  327.610814] bnxt_en 0000:3b:00.0 p1p1: Firmware reset request successful.
> [  327.610828] bnxt_en 0000:3b:00.0 p1p1: Reload driver to complete reset

