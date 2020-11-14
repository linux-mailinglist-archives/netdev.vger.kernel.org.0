Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C1B712B3162
	for <lists+netdev@lfdr.de>; Sun, 15 Nov 2020 00:29:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726198AbgKNX2V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Nov 2020 18:28:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:59494 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726125AbgKNX2V (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 14 Nov 2020 18:28:21 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (c-67-180-217-166.hsd1.ca.comcast.net [67.180.217.166])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2B72E24137;
        Sat, 14 Nov 2020 23:28:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605396500;
        bh=7Ai9UarSje4Uti3CevlWJkiUDgHFix9kQvv0wmu+fMo=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=yd30vLw/XOnZaleoH0kMV16JC4ykU0Zjwbqai037sUECS3MJdHgCrEOs9oU3fSLwU
         aILgJdgzv1rOsB41yc+0VbF3+DMtiqDCY0nHyeQ0VUjxfXVOaASYZNBzrVt8vob8do
         XbxdZ57lJHWd99FAdwE4V9BIedBre4rpld5GElmU=
Date:   Sat, 14 Nov 2020 15:28:19 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Sven Van Asbroeck <thesven73@gmail.com>
Cc:     Bryan Whitehead <bryan.whitehead@microchip.com>,
        David S Miller <davem@davemloft.net>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        Andrew Lunn <andrew@lunn.ch>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net v1] lan743x: prevent entire kernel HANG on open, for
 some platforms
Message-ID: <20201114152819.6b89d74a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201112204741.12375-1-TheSven73@gmail.com>
References: <20201112204741.12375-1-TheSven73@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 12 Nov 2020 15:47:41 -0500 Sven Van Asbroeck wrote:
> From: Sven Van Asbroeck <thesven73@gmail.com>
> 
> On arm imx6, when opening the chip's netdev, the whole Linux
> kernel intermittently hangs/freezes.
> 
> This is caused by a bug in the driver code which tests if pcie
> interrupts are working correctly, using the software interrupt:
> 
> 1. open: enable the software interrupt
> 2. open: tell the chip to assert the software interrupt
> 3. open: wait for flag
> 4. ISR: acknowledge s/w interrupt, set flag
> 5. open: notice flag, disable the s/w interrupt, continue
> 
> Unfortunately the ISR only acknowledges the s/w interrupt, but
> does not disable it. This will re-trigger the ISR in a tight
> loop.
> 
> On some (lucky) platforms, open proceeds to disable the s/w
> interrupt even while the ISR is 'spinning'. On arm imx6,
> the spinning ISR does not allow open to proceed, resulting
> in a hung Linux kernel.
> 
> Fix minimally by disabling the s/w interrupt in the ISR, which
> will prevent it from spinning. This won't break anything because
> the s/w interrupt is used as a one-shot interrupt.
> 
> Note that this is a minimal fix, overlooking many possible
> cleanups, e.g.:
> - lan743x_intr_software_isr() is completely redundant and reads
>   INT_STS twice for no apparent reason
> - disabling the s/w interrupt in lan743x_intr_test_isr() is now
>   redundant, but harmless
> - waiting on software_isr_flag can be converted from a sleeping
>   poll loop to wait_event_timeout()
> 
> Fixes: 23f0703c125b ("lan743x: Add main source files for new lan743x driver")
> Tested-by: Sven Van Asbroeck <thesven73@gmail.com> # arm imx6 lan7430
> Signed-off-by: Sven Van Asbroeck <thesven73@gmail.com>

Applied, thank you!
