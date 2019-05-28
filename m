Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 132C72C636
	for <lists+netdev@lfdr.de>; Tue, 28 May 2019 14:11:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727068AbfE1MLl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 May 2019 08:11:41 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:53298 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726620AbfE1MLl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 May 2019 08:11:41 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id C21AE60271; Tue, 28 May 2019 12:11:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1559045499;
        bh=2lQySrPSOTMzyxN6pFfdb+ev8cgoIVdkWaHsrsG9+pw=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=VZjh4BYAAVpZxfy0yQF0qtQoGet9/5UvUoYvfMpI3Vn5VllXfA8JwdO/lSM7EUw9P
         VIw0sVaS+HJrHbXxZFR24R1+vvtHk2dDMkFsC2dOs4O726+kdp9t2bP1gaYRMpu9zX
         7yaolr0o06xDn6rYBGTfdXB+hzhEQGQJqboI+ycM=
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        pdx-caf-mail.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.7 required=2.0 tests=ALL_TRUSTED,BAYES_00,
        DKIM_INVALID,DKIM_SIGNED,SPF_NONE autolearn=no autolearn_force=no
        version=3.4.0
Received: from purkki.adurom.net (purkki.adurom.net [80.68.90.206])
        (using TLSv1.2 with cipher DHE-RSA-AES128-SHA (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 472EB6070D;
        Tue, 28 May 2019 12:11:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1559045499;
        bh=2lQySrPSOTMzyxN6pFfdb+ev8cgoIVdkWaHsrsG9+pw=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=VZjh4BYAAVpZxfy0yQF0qtQoGet9/5UvUoYvfMpI3Vn5VllXfA8JwdO/lSM7EUw9P
         VIw0sVaS+HJrHbXxZFR24R1+vvtHk2dDMkFsC2dOs4O726+kdp9t2bP1gaYRMpu9zX
         7yaolr0o06xDn6rYBGTfdXB+hzhEQGQJqboI+ycM=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 472EB6070D
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Alan Stern <stern@rowland.harvard.edu>
Cc:     Christian Lamparter <chunkeey@gmail.com>,
        syzbot <syzbot+200d4bb11b23d929335f@syzkaller.appspotmail.com>,
        <davem@davemloft.net>, <andreyknvl@google.com>,
        <syzkaller-bugs@googlegroups.com>,
        Kernel development list <linux-kernel@vger.kernel.org>,
        USB list <linux-usb@vger.kernel.org>,
        <linux-wireless@vger.kernel.org>, <netdev@vger.kernel.org>
Subject: Re: [PATCH] network: wireless: p54u: Fix race between disconnect and firmware loading
References: <Pine.LNX.4.44L0.1905201042110.1498-100000@iolanthe.rowland.org>
Date:   Tue, 28 May 2019 15:11:34 +0300
In-Reply-To: <Pine.LNX.4.44L0.1905201042110.1498-100000@iolanthe.rowland.org>
        (Alan Stern's message of "Mon, 20 May 2019 10:44:21 -0400 (EDT)")
Message-ID: <8736kyvkw9.fsf@purkki.adurom.net>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Alan Stern <stern@rowland.harvard.edu> writes:

> The syzbot fuzzer found a bug in the p54 USB wireless driver.  The
> issue involves a race between disconnect and the firmware-loader
> callback routine, and it has several aspects.
>
> One big problem is that when the firmware can't be loaded, the
> callback routine tries to unbind the driver from the USB _device_ (by
> calling device_release_driver) instead of from the USB _interface_ to
> which it is actually bound (by calling usb_driver_release_interface).
>
> The race involves access to the private data structure.  The driver's
> disconnect handler waits for a completion that is signalled by the
> firmware-loader callback routine.  As soon as the completion is
> signalled, you have to assume that the private data structure may have
> been deallocated by the disconnect handler -- even if the firmware was
> loaded without errors.  However, the callback routine does access the
> private data several times after that point.
>
> Another problem is that, in order to ensure that the USB device
> structure hasn't been freed when the callback routine runs, the driver
> takes a reference to it.  This isn't good enough any more, because now
> that the callback routine calls usb_driver_release_interface, it has
> to ensure that the interface structure hasn't been freed.
>
> Finally, the driver takes an unnecessary reference to the USB device
> structure in the probe function and drops the reference in the
> disconnect handler.  This extra reference doesn't accomplish anything,
> because the USB core already guarantees that a device structure won't
> be deallocated while a driver is still bound to any of its interfaces.
>
> To fix these problems, this patch makes the following changes:
>
> 	Call usb_driver_release_interface() rather than
> 	device_release_driver().
>
> 	Don't signal the completion until after the important
> 	information has been copied out of the private data structure,
> 	and don't refer to the private data at all thereafter.
>
> 	Lock udev (the interface's parent) before unbinding the driver
> 	instead of locking udev->parent.
>
> 	During the firmware loading process, take a reference to the
> 	USB interface instead of the USB device.
>
> 	Don't take an unnecessary reference to the device during probe
> 	(and then don't drop it during disconnect).
>
> Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
> Reported-and-tested-by: syzbot+200d4bb11b23d929335f@syzkaller.appspotmail.com
> CC: <stable@vger.kernel.org>
>
> ---
>
>
> [as1899]
>
>
>  drivers/net/wireless/intersil/p54/p54usb.c |   43 ++++++++++++-----------------
>  1 file changed, 18 insertions(+), 25 deletions(-)

The correct prefix is "p54:", but I can fix that during commit.

> Index: usb-devel/drivers/net/wireless/intersil/p54/p54usb.c
> ===================================================================
> --- usb-devel.orig/drivers/net/wireless/intersil/p54/p54usb.c
> +++ usb-devel/drivers/net/wireless/intersil/p54/p54usb.c
> @@ -33,6 +33,8 @@ MODULE_ALIAS("prism54usb");
>  MODULE_FIRMWARE("isl3886usb");
>  MODULE_FIRMWARE("isl3887usb");
>  
> +static struct usb_driver p54u_driver;

How is it safe to use static variables from a wireless driver? For
example, what if there are two p54 usb devices on the host? How do we
avoid a race in that case?

-- 
Kalle Valo
