Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A463E463B8E
	for <lists+netdev@lfdr.de>; Tue, 30 Nov 2021 17:19:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243181AbhK3QW1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Nov 2021 11:22:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243789AbhK3QWZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Nov 2021 11:22:25 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32CE2C061574
        for <netdev@vger.kernel.org>; Tue, 30 Nov 2021 08:19:06 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F14CFB81A5B
        for <netdev@vger.kernel.org>; Tue, 30 Nov 2021 16:19:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73E34C53FCD;
        Tue, 30 Nov 2021 16:19:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638289143;
        bh=w/xVcM1PWCHRyh+4ITK8ESet4RtKgSSuT9vBi2yG94E=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=pXsqzT8E6UGFTCkoXG+74UWJIiFkIl6nTycE0qtGYCF8E7hM2dbi4+aCKupq5cpwW
         oTtyviYnBsEKlYmcaYmUwGCOYvZEPwvUc3I0OYrvyjq9xnIy7uuGR7LSwtBWQT8qXQ
         j7KwERnIjTc/52uiAoz0oYJzKsrTccQoAcxSC13hrELracwVuB4PsBiDSXpOplHsP6
         oHmAbO1GM1OM6qkBiZMMpD0ZkHDv87U32BIPoqUOIhvPgK5OKlu0AnYQ1WEN7CiQBI
         fxpLptA8aXFSpb1JTwTy+UauX4GHw8IidP0AvL7SPO6O8BN1y1vuCK15tOgSAXfMyF
         CsBnRRbMJbCeQ==
Date:   Tue, 30 Nov 2021 17:18:59 +0100
From:   Marek =?UTF-8?B?QmVow7pu?= <kabel@kernel.org>
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Jakub Kicinski <kuba@kernel.org>, davem@davemloft.net
Subject: Re: [PATCH net 6/6] net: dsa: mv88e6xxx: Link in pcs_get_state() if
 AN is bypassed
Message-ID: <20211130171859.6deeb17d@thinkpad>
In-Reply-To: <YaZONv7fmRWK+qCb@shell.armlinux.org.uk>
References: <20211129195823.11766-1-kabel@kernel.org>
        <20211129195823.11766-7-kabel@kernel.org>
        <YaVeyWsGd06eRUqv@shell.armlinux.org.uk>
        <20211130011812.08baccdc@thinkpad>
        <20211130170911.6355db44@thinkpad>
        <YaZONv7fmRWK+qCb@shell.armlinux.org.uk>
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 30 Nov 2021 16:15:50 +0000
"Russell King (Oracle)" <linux@armlinux.org.uk> wrote:

> On Tue, Nov 30, 2021 at 05:09:11PM +0100, Marek Beh=C3=BAn wrote:
> > Seems that BMSR_ANEGCAPABLE is set even if AN is disabled in BMCR. =20
>=20
> Hmm, that behaviour goes against 22.2.4.2.10:
>=20
> A PHY shall return a value of zero in bit 1.5 if Auto-Negotiation is
> disabled by clearing bit 0.12. A PHY shall also return a value of zero
> in bit 1.5 if it lacks the ability to perform Auto-Negotiation.
>=20
> > I was under the impression that
> >   state->an_complete
> > should only be set to true if AN is enabled. =20
>=20
> Yes - however as you've stated, the PHY doesn't follow 802.3 behaviour
> so I guess we should make the emulation appear compliant by fixing it
> like this.

OK, I will use BMCR_ANENABLE and add a comment explaining that we can't
use BMSR_ANEGCAPABLE because the PHY violates standard. Would that be
okay?
