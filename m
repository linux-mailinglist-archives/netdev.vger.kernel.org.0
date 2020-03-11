Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C747418186F
	for <lists+netdev@lfdr.de>; Wed, 11 Mar 2020 13:46:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729354AbgCKMqs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Mar 2020 08:46:48 -0400
Received: from mail-ed1-f68.google.com ([209.85.208.68]:36956 "EHLO
        mail-ed1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729279AbgCKMqs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Mar 2020 08:46:48 -0400
Received: by mail-ed1-f68.google.com with SMTP id b23so2713761edx.4
        for <netdev@vger.kernel.org>; Wed, 11 Mar 2020 05:46:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=VRvosfgrT7qtZwn4vI1JG0A7hp4tCm3RZoUHP6ng3h4=;
        b=JUG5v9raeUDoXJnCZALV8f6q8M8bhM+vuwBbDUF4Gsy8xfskgh++TJ6frwGWe+OuEb
         MTFaCHduSU/csT8zZ4x+WaQjFLyAyv6edICQqwO04RUni1+pDk3n1ImWtY8W3+u+mYQx
         /U8nwXbDvhZBzwCcB70kqrU9WPSWupXyjDKGitJ4EGX1FKDk6ZstdqXpAspCogOVBNRI
         ScqSSq3rhwLnk6WNBfu4RscbuqbT1n/gTrY3Jyndw5vtMoPWUHAtpksi0CrmCzg5NQj+
         k/rorqIv7kTswWzraoqeF5fS5eTBC3+C/xqAaRxCjPUH2BHxbxSZttaptavqlP1Hx6Ru
         wjmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=VRvosfgrT7qtZwn4vI1JG0A7hp4tCm3RZoUHP6ng3h4=;
        b=kAh+d5cKmiSqiFUDWM7Jjqs6Wf3X71RwRupGo7NEEY48I1qo0FEIlyjV+oAs4QrFGs
         bkhbVzCmdesc/xjohCcJYaLxb1jNDtWSMMXxQZfxtnNAG9PW6wYzxmSBtjfupL5J8HhN
         a7MXCJItXqiXaMQHT/z3La55j8vYqyCXNx3FKbgrkmURkAjH2qwWrzkToqGj4C692yXa
         QLgg6kHJ2r7gq1Qxdz4jr49GQGfAswUUWpy4gSX72zacG8tcSPMEH1d9YfjvmguVJ4dB
         h6Ir5Q0nvZOpmB2B9uf1bCDsKZdV2kG6OI6zjgaFJv15igVMwATyXL1Qn6ZMEw1/2uAo
         Jt9w==
X-Gm-Message-State: ANhLgQ3DChUqMGY2tizOZ4OJqp2BKn9bN1P3TN4X7nUR+U7osqkp1VZ+
        PZa0Ub3ekGjplXZAY7W0urYpvUG2KO0OPSMsVbI=
X-Google-Smtp-Source: ADFU+vva6L4gj1E6xdt/CbY5EH9PoDo0fQFWdHu8OVFIhHsXyZzL6Les6dMa6RP5EhnUilj3+RJlZ42uLF7iIq8URWU=
X-Received: by 2002:a05:6402:c:: with SMTP id d12mr2673222edu.337.1583930804625;
 Wed, 11 Mar 2020 05:46:44 -0700 (PDT)
MIME-Version: 1.0
References: <20200311120643.GN25745@shell.armlinux.org.uk>
In-Reply-To: <20200311120643.GN25745@shell.armlinux.org.uk>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Wed, 11 Mar 2020 14:46:33 +0200
Message-ID: <CA+h21hoq2qkmxDFEb2QgLfrbC0PYRBHsca=0cDcGOr3txy9hsg@mail.gmail.com>
Subject: Re: [PATCH net-next 0/5] add phylink support for PCS
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Russell,

On Wed, 11 Mar 2020 at 14:09, Russell King - ARM Linux admin
<linux@armlinux.org.uk> wrote:
>
> Hi,
>
> This series adds support for IEEE 802.3 register set compliant PCS
> for phylink.  In order to do this, we:
>
> 1. convert the existing (unused) mii_lpa_to_ethtool_lpa_x() function
>    to a linkmode variant.
> 2. add a helper for clause 37 advertisements, supporting both the
>    1000baseX and defacto 2500baseX variants. Note that ethtool does
>    not support half duplex for either of these, and we make no effort
>    to do so.
> 3. add accessors for modifying a MDIO device register, and use them in
>    phylib, rather than duplicating the code from phylib.

Have you considered accessing the PCS as a phy_device structure, a la
drivers/net/dsa/ocelot/felix_vsc9959.c?

> 4. add support for decoding the advertisement from clause 22 compatible
>    register sets for clause 37 advertisements and SGMII advertisements.
> 5. add support for clause 45 register sets for 10GBASE-R PCS.
>
> These have been tested on the LX2160A Clearfog-CX platform.
>
>  drivers/net/phy/mdio_bus.c |  55 +++++++++++
>  drivers/net/phy/phy-core.c |  31 ------
>  drivers/net/phy/phylink.c  | 236 +++++++++++++++++++++++++++++++++++++++++++++
>  include/linux/mdio.h       |   4 +
>  include/linux/mii.h        |  57 +++++++----
>  include/linux/phy.h        |  19 ++++
>  include/linux/phylink.h    |   8 ++
>  include/uapi/linux/mii.h   |   5 +
>  8 files changed, 366 insertions(+), 49 deletions(-)
>
> --
> RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
> FTTC broadband for 0.8mile line in suburbia: sync at 10.2Mbps down 587kbps up

Regards,
-Vladimir
