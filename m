Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 90F265223B
	for <lists+netdev@lfdr.de>; Tue, 25 Jun 2019 06:43:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726968AbfFYEnW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jun 2019 00:43:22 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:48118 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726421AbfFYEnV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jun 2019 00:43:21 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 6BB25608CE; Tue, 25 Jun 2019 04:43:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1561437800;
        bh=PzVp8KkogA+HpuLr/YP8oqFfRobqR8lFNoY9waydybM=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=gdxfop57atEjvmRF8gPOTqZFUYIpLMuvk3v7sa0hocaPU7Kiz1gYQuaZrWgvdX+Dj
         Z82ssd8e6DCvYle2B+GdHKCaTPcvcHO57m9WyJsdZBA6btr/pRDPQYBQI9hi+D06mu
         P3tgaB/Bs8jFMztruF+3HFd82d2D7PPmbLPutqHs=
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        pdx-caf-mail.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=2.0 tests=ALL_TRUSTED,BAYES_00,
        DKIM_INVALID,DKIM_SIGNED,MISSING_DATE,MISSING_MID,SPF_NONE autolearn=no
        autolearn_force=no version=3.4.0
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 2E23260709;
        Tue, 25 Jun 2019 04:43:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1561437799;
        bh=PzVp8KkogA+HpuLr/YP8oqFfRobqR8lFNoY9waydybM=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=PBPwg7IrJqMMukLWvzfIZX+whOYm0ZznKI/3wi9SCk5H3k6H/D+0I4GAZgV2o/bps
         SfaDPbUvmqd720DbwWT8+WtOldqLomy5tytCONSAs4sGw5dQ79adiUIPunmzEQt2IX
         elxmnUfr7YzxgldSiUhoq7DCqzjOoQLhaLjBuQSs=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 2E23260709
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] p54usb: Fix race between disconnect and firmware loading
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <Pine.LNX.4.44L0.1905201042110.1498-100000@iolanthe.rowland.org>
References: <Pine.LNX.4.44L0.1905201042110.1498-100000@iolanthe.rowland.org>
To:     Alan Stern <stern@rowland.harvard.edu>
Cc:     Christian Lamparter <chunkeey@gmail.com>,
        syzbot <syzbot+200d4bb11b23d929335f@syzkaller.appspotmail.com>,
        <davem@davemloft.net>, <andreyknvl@google.com>,
        <syzkaller-bugs@googlegroups.com>,
        Kernel development list <linux-kernel@vger.kernel.org>,
        USB list <linux-usb@vger.kernel.org>,
        <linux-wireless@vger.kernel.org>, <netdev@vger.kernel.org>
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20190625044320.6BB25608CE@smtp.codeaurora.org>
Date:   Tue, 25 Jun 2019 04:43:20 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Alan Stern <stern@rowland.harvard.edu> wrote:

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
> Acked-by: Christian Lamparter <chunkeey@gmail.com>

Patch applied to wireless-drivers-next.git, thanks.

6e41e2257f10 p54usb: Fix race between disconnect and firmware loading

-- 
https://patchwork.kernel.org/patch/10951527/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

