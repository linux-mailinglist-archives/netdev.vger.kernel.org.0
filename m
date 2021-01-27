Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B38C30674D
	for <lists+netdev@lfdr.de>; Wed, 27 Jan 2021 23:56:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231998AbhA0Wz6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jan 2021 17:55:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:38970 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231825AbhA0WzT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 27 Jan 2021 17:55:19 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 179EA64DD9;
        Wed, 27 Jan 2021 22:54:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611788078;
        bh=RFMVTbPsJbSB9O0MyrO+zDcpU34HRr63zx+ty6mxMAU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=frLYgKOc19UXPnETTmyUbXtCKwYN9rDS2rTHbdYgq1FQ311cOmgk20xncKOFqQywN
         pEtvDEtQt61mkS3YipJ7Dtv+kHKjbh/g1gl4D1GrQVi4+TtEDwCrToth83nGwSGVAT
         eMZPQJxQeJFSF0/n4B/2C3uUF/7AT6Xk1UY63jEZF9FdnQjc0WNIls9W99Ye6/+TYp
         cPT1rc3rC9C22AW6D5r46L+u7CKqeOPpaEAYeYaZTKIirV3kPGwP6gcDBOpXm2MDSE
         Z1w3Uto8DKBi/tCvyL2X4PaUPfASgCOfVckSqwCPl0Zr3huPKVuWeem+lHLMXCyjrT
         jBx9QbuJBfazQ==
Date:   Wed, 27 Jan 2021 14:54:37 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Mike Looijmans <mike.looijmans@topic.nl>
Cc:     Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>, netdev@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: mdiobus: Prevent spike on MDIO bus reset signal
Message-ID: <20210127145437.1f5227b5@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <c640eb02-fe31-d460-521b-c7e5b85f016f@topic.nl>
References: <20210126073337.20393-1-mike.looijmans@topic.nl>
        <YBAVwFlLsfVEHd+E@lunn.ch>
        <20210126134937.GI1551@shell.armlinux.org.uk>
        <1b153bce-a66a-45ee-a5c6-963ea6fb1c82.949ef384-8293-46b8-903f-40a477c056ae.b4d05392-d8bb-4828-9ac6-5a63736d3625@emailsignatures365.codetwo.com>
        <1b153bce-a66a-45ee-a5c6-963ea6fb1c82.0d2bd5fa-15cc-4b27-b94e-83614f9e5b38.23e4b566-2e4d-4160-a40f-4bf79ef86f8a@emailsignatures365.codetwo.com>
        <c640eb02-fe31-d460-521b-c7e5b85f016f@topic.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 27 Jan 2021 08:08:29 +0100 Mike Looijmans wrote:
> > Andrew, I don't get what you're saying.
> >
> > Here is what happens depending on the pre-existing state of the
> > reset signal:
> >
> > Reset (previously asserted):   ~~~|_|~~~~|_______
> > Reset (previously deasserted): _____|~~~~|_______
> >                                    ^ ^    ^
> >                                    A B    C
> >
> > At point A, the low going transition is because the reset line is
> > requested using GPIOD_OUT_LOW. If the line is successfully requested,
> > the first thing we do is set it high _without_ any delay. This is
> > point B. So, a glitch occurs between A and B.
> >
> > We then fsleep() and finally set the GPIO low at point C.
> >
> > Requesting the line using GPIOD_OUT_HIGH eliminates the A and B
> > transitions. Instead we get:
> >
> > Reset (previously asserted)  : ~~~~~~~~~~|______
> > Reset (previously deasserted): ____|~~~~~|______
> >                                     ^     ^
> >                                     A     C
> >
> > Where A and C are the points described above in the code. Point B
> > has been eliminated.
> >
> > Therefore, to me the patch looks entirely reasonable and correct.
> >  
> Thanks, excellent explanation.
> 
> As a bit of background, we were using a Marvell PHY where the datasheet 
> states that thou shallt not release the reset within 50 ms of power-up. 
> A pull-down on the active-low reset was thus added. Looking at the reset 
> signal with a scope revealed a short spike, visible only because it was 
> being controlled by an I2C GPIO expander. So it's indeed point "B" that 
> we wanted to eliminate.

This is all useful information - can we roll more of it into the commit
message? I'd think that calling out the part and the 50ms value could
make things more "concrete" for a reader down the line?
