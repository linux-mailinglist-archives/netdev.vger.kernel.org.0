Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A1E24843DC
	for <lists+netdev@lfdr.de>; Tue,  4 Jan 2022 15:53:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232078AbiADOx3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jan 2022 09:53:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229504AbiADOx3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Jan 2022 09:53:29 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55AC4C061761;
        Tue,  4 Jan 2022 06:53:29 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E70CA612E7;
        Tue,  4 Jan 2022 14:53:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01D2AC36AED;
        Tue,  4 Jan 2022 14:53:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641308008;
        bh=0y3hkgpNcGJVZzPYwC7KrnbZbGGnlR7BZtECqLgn7uA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=M4FpgfBHDjWLkSAutnr6OJl0w+HHGWaCjjXRfPZZ0jxQj1VZ4IZ1JuYHJNJhHP/eB
         +FR8TvC3p8i9iYKYgi/f6AzbwqkBVAagzF8KQVcQuW1J98oGTgmkDEYOsd0qqAQ71K
         W66bRITleZOgOJJE/G7px0hXfU5K5V+KSLsH7qm09z2rcgKxURjNRS4FBqv2c/7PxE
         dvwXUkjinEfZD9298/wBDlA+SoTkLEfvY1fGF/hyqPgN5+OtY5z95DuulsU8QEbi14
         hcEB1nypWwm0EgPzVcaPSUkI095Pqht58e185upg4tjp603k45/5ga3tcygNVdsJfj
         i9Z4B4PouY5TQ==
Date:   Tue, 4 Jan 2022 06:53:26 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Henning Schild <henning.schild@siemens.com>,
        Aaron Ma <aaron.ma@canonical.com>
Cc:     <davem@davemloft.net>, <hayeswang@realtek.com>, <tiwai@suse.de>,
        <linux-usb@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] net: usb: r8152: Add MAC passthrough support for more
 Lenovo Docks
Message-ID: <20220104065326.2a73f674@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20220104123814.32bf179e@md1za8fc.ad001.siemens.net>
References: <20211116141917.31661-1-aaron.ma@canonical.com>
        <20220104123814.32bf179e@md1za8fc.ad001.siemens.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 4 Jan 2022 12:38:14 +0100 Henning Schild wrote:
> This patch is wrong and taking the MAC inheritance way too far. Now any
> USB Ethernet dongle connected to a Lenovo USB Hub will go into
> inheritance (which is meant for docks).
> 
> It means that such dongles plugged directly into the laptop will do
> that, or travel adaptors/hubs which are not "active docks".
> 
> I have USB-Ethernet dongles on two desks and both stopped working as
> expected because they took the main MAC, even with it being used at the
> same time. The inheritance should (if at all) only be done for clearly
> identified docks and only for one r8152 instance ... not all. Maybe
> even double checking if that main PHY is "plugged" and monitoring it to
> back off as soon as it is.
> 
> With this patch applied users can not use multiple ethernet devices
> anymore ... if some of them are r8152 and connected to "Lenovo" ...
> which is more than likely!
> 
> Reverting that patch solved my problem, but i later went to disabling
> that very questionable BIOS feature to disable things for good without
> having to patch my kernel.
> 
> I strongly suggest to revert that. And if not please drop the defines of
> 
> > -		case DEVICE_ID_THINKPAD_THUNDERBOLT3_DOCK_GEN2:
> > -		case DEVICE_ID_THINKPAD_USB_C_DOCK_GEN2:  
> 
> And instead of crapping out with "(unnamed net_device) (uninitialized):
> Invalid header when reading pass-thru MAC addr" when the BIOS feature
> is turned off, one might want to check
> DSDT/WMT1/ITEM/"MACAddressPassThrough" which is my best for asking the
> BIOS if the feature is wanted.

Thank you for the report!

Aaron, will you be able to fix this quickly? 5.16 is about to be
released.
