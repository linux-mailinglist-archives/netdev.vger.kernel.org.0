Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 25F27348500
	for <lists+netdev@lfdr.de>; Thu, 25 Mar 2021 00:00:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233937AbhCXXA2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Mar 2021 19:00:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:58428 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233784AbhCXXAL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 24 Mar 2021 19:00:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 30ACF61A0E;
        Wed, 24 Mar 2021 23:00:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616626810;
        bh=d6scC4wzlllCYKmFI7BfA/+PTeW1QYPG6iubfOyrYQw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=h1JUzhsQSmZI99+ikd9D2E8GQ1ThCP6bJAdVohxemgBQ9rfAQD8C6c7Uxh8yBV2si
         i8E8jd+NA/0MZS690sy3jLjOAIUuEQe4T6b4xLKS+LFZFW8NSDxeNSh81sEyuOhfOW
         IlVNLu9XkoNeTM5tMhAkAKgDS/w68bTrTKkFcji+De83osSY9ZbEwW26tTWI4qq6DJ
         9fQzU8ZTvW+ZIY4X5zdkg+4IcuNRh+mkUEAnGCCiUdlLiut4b5J7PzQM0Pl44NeHiE
         NBaJR+YhBRntKFjgoYR+cwAvX8u0vyL5PoF3cegPml9K3b6bnWG2kVFvAHbOOnanay
         sSPLJ3KLeMz5A==
Date:   Thu, 25 Mar 2021 00:00:07 +0100
From:   Marek =?UTF-8?B?QmVow7pu?= <kabel@kernel.org>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        "David S . Miller" <davem@davemloft.net>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Rob Herring <robh@kernel.org>, devicetree@vger.kernel.org,
        pali@kernel.org
Subject: Re: [PATCH net-next 0/2] dt-bindings: define property describing
 supported ethernet PHY modes
Message-ID: <20210325000007.19a38bce@thinkpad>
In-Reply-To: <e4e088a4-1538-1e7d-241d-e43b69742811@gmail.com>
References: <20210324103556.11338-1-kabel@kernel.org>
        <e4e088a4-1538-1e7d-241d-e43b69742811@gmail.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 24 Mar 2021 14:19:28 -0700
Florian Fainelli <f.fainelli@gmail.com> wrote:

> > Another problem is that if lower modes are supported, we should
> > maybe use them in order to save power.  
> 
> That is an interesting proposal but if you want it to be truly valuable,
> does not that mean that an user ought to be able to switch between any
> of the supported PHY <=> MAC interfaces at runtime, and then within
> those interfaces to the speeds that yield the best power savings?

If the code determines that there are multiple working configurations,
it theoretically could allow the user to switch between them.

My idea was that this should be done by kernel, though.

But power saving is not the main problem I am trying to solve.
What I am trying to solve is that if a board does not support all modes
supported by the MAC and PHY, because they are not wired or something,
we need to know about that so that we can select the correct mode for
PHYs that change this mode at runtime.

> > 
> > But for this we need to know which phy-modes are supported on the
> > board.
> > 
> > This series adds documentation for a new ethernet PHY property,
> > called `supported-mac-connection-types`.  
> 
> That naming does not quite make sense to me, if we want to describe the
> MAC supported connection types, then those would naturally be within the
> Ethernet MAC Device Tree node, no? If we are describing what the PHY is
> capable, then we should be dropping "mac" from the property name not to
> create confusion.

I put "mac" there to indicate that this is the SerDes to the MAC (i.e.
host side in Marvell PHY). 88X3310 has another SerDes side (Fiber Side).
I guess I put "mac" there so that if in the future we wanted to specify
supported modes for the fiber side, we could add
`supported-fiber-connection-types`.

But otherwise it does not matter where this property is. Rob Herring
says that maybe we don't need a new property at all. We can reuse
phy-mode property of the MAC, and enumerate all supported modes there.

> 
> > 
> > When this property is present for a PHY node, only the phy-modes
> > listed in this property should be considered to be functional on
> > the board.  
> 
> Can you post the code that is going to utilize these properties so we
> have a clearer picture of how and what you need to solve?

I am still working on this, so the repo may change, but look at
https://git.kernel.org/pub/scm/linux/kernel/git/kabel/linux.git/log/?h=phy-supported-interfaces
at the last three patches.
