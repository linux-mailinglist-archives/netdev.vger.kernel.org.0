Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D03548490C
	for <lists+netdev@lfdr.de>; Tue,  4 Jan 2022 21:00:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232095AbiADUAc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jan 2022 15:00:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229962AbiADUAb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Jan 2022 15:00:31 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D8A2C061761;
        Tue,  4 Jan 2022 12:00:31 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 330C86159D;
        Tue,  4 Jan 2022 20:00:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 272F8C36AEB;
        Tue,  4 Jan 2022 20:00:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641326429;
        bh=sQBg8Y7qecsMNIktMN2imf4TjCv8rYLDyWd3vuZtTxE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=QlF7Z3pV7qgO1ENoOkiP5b1vxTg+E++D8xbTtbWdRiMEnvjv/AdPzMAmCsqfoxjw/
         1qyBn/+vH7kMNjkn3oxskahyN8iG6X+uTqnjdvU2y2g/aYH/urAygMV58yz6WiMnwd
         Ac+mDyW32y2hvjWhKk/AR3T/UUzn7zqXjtlO2cz1mpJbKDto595jR0nuthP1B3yahG
         SRQwaC8moqMP47Nd5ETkctcUOjcIzleVmoHj/CsG9RwNlALoDPsWKMF5AEJ5cLTY+q
         2TMronwNzzdPTXr7gnar8jkURFzuVlInyPxj3EsXUeaokxVZ+BKY9+c1yBAy2VGYPZ
         A8+Wcr/1La5uA==
Date:   Tue, 4 Jan 2022 12:00:27 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Henning Schild <henning.schild@siemens.com>
Cc:     Aaron Ma <aaron.ma@canonical.com>, <davem@davemloft.net>,
        <hayeswang@realtek.com>, <tiwai@suse.de>,
        <linux-usb@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] net: usb: r8152: Add MAC passthrough support for more
 Lenovo Docks
Message-ID: <20220104120027.611f8830@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20220104193455.6b8a21fc@md1za8fc.ad001.siemens.net>
References: <20211116141917.31661-1-aaron.ma@canonical.com>
        <20220104123814.32bf179e@md1za8fc.ad001.siemens.net>
        <20220104065326.2a73f674@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
        <20220104180715.7ecb0980@md1za8fc.ad001.siemens.net>
        <601815fe-a10e-fe48-254c-ed2ef1accffc@canonical.com>
        <20220104193455.6b8a21fc@md1za8fc.ad001.siemens.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 4 Jan 2022 19:34:55 +0100 Henning Schild wrote:
> Am Wed, 5 Jan 2022 01:40:42 +0800
> schrieb Aaron Ma <aaron.ma@canonical.com>:
> > Yes, it's expected to be a mess if multiple r8152 are attached to
> > Lenovo USB-C/TBT docks. The issue had been discussed for several
> > times in LKML. Either lose this feature or add potential risk for
> > multiple r8152.
> > 
> > The idea is to make the Dock work which only ship with one r8152.
> > It's really hard to say r8152 is from dock or another plugin one.
> > 
> > If revert this patch, then most users with the original shipped dock
> > may lose this feature. That's the problem this patch try to fix.  
> 
> I understand that. But i would say people can not expect such a crap
> feature on Linux, or we really need very good reasoning to cause MAC
> collisions with the real PHY and on top claim ETOOMANY of the dongles.
> 
> The other vendors seem to check bits of the "golden" dongle. At least
> that is how i understand BD/AD/BND_MASK
> 
> How about making it a module param and default to off, and dev_warn if
> BIOS has it turned on. That sounds like a reasonable compromise and
> whoever turns it on twice probably really wants it. (note that BIOS
> defaults to on ... so that was never intended by users, and corporate
> users might not be allowed/able to turn that off)
> 
> MACs change ... all the time, people should use radius x509. The
> request is probably coming from corporate users, and they are all on a
> zero trust journey and will eventually stop relying on MACs anyways.
> 
> And if ubuntu wants to cater by default, there can always be an udev
> rule or setting that module param to "on".

Let's split the problem into the clear regression caused by the patch
and support of the feature on newer docks. I think we should fix the
regression ASAP (the patch has also been backported to 5.15, so it's
going to get more and more widely deployed). Then we can worry about
the MAC addr copy on newer docks and the feature in a wider context.
Is there really nothing in the usb info of the r8152 instance to
indicate that it's part of the dock? Does the device have EEPROM which
could contain useful info, maybe?

> > For now I suggest to disable it in BIOS if you got multiple r8152.
> > 
> > Let me try to make some changes to limit this feature in one r8152.  
> 
> Which one? ;) And how to deal with the real NIC once you picked one?
> Looking forward, please Cc me.

