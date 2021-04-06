Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A4C3D354BCA
	for <lists+netdev@lfdr.de>; Tue,  6 Apr 2021 06:48:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243608AbhDFEsF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Apr 2021 00:48:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243600AbhDFEsE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Apr 2021 00:48:04 -0400
Received: from mail-ua1-x92b.google.com (mail-ua1-x92b.google.com [IPv6:2607:f8b0:4864:20::92b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4348C06174A
        for <netdev@vger.kernel.org>; Mon,  5 Apr 2021 21:47:56 -0700 (PDT)
Received: by mail-ua1-x92b.google.com with SMTP id r8so4238444ual.9
        for <netdev@vger.kernel.org>; Mon, 05 Apr 2021 21:47:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ClOiyYZKz95OIO54J0VorNj6tqXyN9Hb3E0W6gOaVhI=;
        b=U887KtV1EvddId/O9RvxsuXKBXhf3+i8S1FqCjXp++g2o5QFeWRsDP4LeG+FA3gLvo
         JZMNPUByMXQOcDRZ8ovj2XIARL8SMTJRPDzgA2Gln9kXXVSjOwYEJnO7cmOqjor/mZAA
         3VlAN/Hlf5RZyxvNF+Wf499nC8BOfMp8t2+H4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ClOiyYZKz95OIO54J0VorNj6tqXyN9Hb3E0W6gOaVhI=;
        b=r8O4n+5EaqstlbHJ6umSKumAdbJCJ0sNHPmPsr4rvmnmqpJHgyXWXiX8U67oCqv81B
         WgXA4DuU6nCk54DUTLQPZxlyyYZP8S2Z+liw+Zoy1DZ2GPDaEe/aW2zk05w8C6Em66FT
         JFPXezpu/2hna2e00m+hH5q93GL34cZXStseYr1wps4J/p/gO1YUM23EAlDERH1VXVaX
         yraBoQR9lN36QxOniR9FWEWyk/4+oocT9WzRf14qb0sL/LiKmoTSbLwlekvUqneSIHA/
         eILXSaTR8VM+DZMIlsegcu3pSKbHMSo64s0HBT3+jeKgPBDxZ0czCKED/WG/567Rm2rL
         tw3Q==
X-Gm-Message-State: AOAM532ABMDhbWyynHMLYnxNTkxHAORQbdCgIKePmtfktphqikWrBQeX
        EFhmTQdNUHLdVR0Ip6rxsfY3UNJU0D4yNWgZkjIPPA==
X-Google-Smtp-Source: ABdhPJyB+i4AGUkCIU/V7q7e8lqa2S6L4kkRMUZ8IjPMo2GRduKRnjSxHUNwc3Tt2Z7FX4YgOyALK+2psTUEu0lbo0E=
X-Received: by 2002:ab0:3c8f:: with SMTP id a15mr16303813uax.66.1617684475522;
 Mon, 05 Apr 2021 21:47:55 -0700 (PDT)
MIME-Version: 1.0
References: <20210405231344.1403025-1-grundler@chromium.org> <YGumuzcPl+9l5ZHV@lunn.ch>
In-Reply-To: <YGumuzcPl+9l5ZHV@lunn.ch>
From:   Grant Grundler <grundler@chromium.org>
Date:   Tue, 6 Apr 2021 04:47:43 +0000
Message-ID: <CANEJEGsYQm9EhqVLA4oedP2fuKrP=3bOUDV9=7owfdZzX7SpUA@mail.gmail.com>
Subject: Re: [PATCH net-next v4 0/4] usbnet: speed reporting for devices
 without MDIO
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Grant Grundler <grundler@chromium.org>,
        Oliver Neukum <oneukum@suse.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Roland Dreier <roland@kernel.org>,
        nic_swsd <nic_swsd@realtek.com>, netdev <netdev@vger.kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 6, 2021 at 12:09 AM Andrew Lunn <andrew@lunn.ch> wrote:
>
> On Mon, Apr 05, 2021 at 04:13:40PM -0700, Grant Grundler wrote:
> > This series introduces support for USB network devices that report
> > speed as a part of their protocol, not emulating an MII to be accessed
> > over MDIO.
> >
> > v2: rebased on recent upstream changes
> > v3: incorporated hints on naming and comments
> > v4: fix misplaced hunks; reword some commit messages;
> >     add same change for cdc_ether
> > v4-repost: added "net-next" to subject and Andrew Lunn's Reviewed-by
> >
> > I'm reposting Oliver Neukum's <oneukum@suse.com> patch series with
> > fix ups for "misplaced hunks" (landed in the wrong patches).
> > Please fixup the "author" if "git am" fails to attribute the
> > patches 1-3 (of 4) to Oliver.
> >
> > I've tested v4 series with "5.12-rc3+" kernel on Intel NUC6i5SYB
> > and + Sabrent NT-S25G. Google Pixelbook Go (chromeos-4.4 kernel)
> > + Alpha Network AUE2500C were connected directly to the NT-S25G
> > to get 2.5Gbps link rate:
> > # ethtool enx002427880815
> > Settings for enx002427880815:
> >         Supported ports: [  ]
> >         Supported link modes:   Not reported
> >         Supported pause frame use: No
> >         Supports auto-negotiation: No
> >         Supported FEC modes: Not reported
> >         Advertised link modes:  Not reported
> >         Advertised pause frame use: No
> >         Advertised auto-negotiation: No
> >         Advertised FEC modes: Not reported
> >         Speed: 2500Mb/s
> >         Duplex: Half
> >         Auto-negotiation: off
> >         Port: Twisted Pair
> >         PHYAD: 0
> >         Transceiver: internal
> >         MDI-X: Unknown
> >         Current message level: 0x00000007 (7)
> >                                drv probe link
> >         Link detected: yes
> >
> >
> > "Duplex" is a lie since we get no information about it.
>
> You can ask the PHY. At least those using mii or phylib.  If you are
> using mii, then mii_ethtool_get_link_ksettings() should set it
> correctly. If you are using phylib, phy_ethtool_get_link_ksettings()
> will correctly set it. If you are not using either of these, you are
> on your own.
>
> Speed: 2500Mb/s and Duplex: Half is very unlikely. You really only
> ever see 10 Half and occasionally 100 Half. Anything above that will
> be full duplex.
>
> It is probably best to admit the truth and use DUPLEX_UNKNOWN.

Agreed. I didn't notice this "lie" until I was writing the commit
message and wasn't sure off-hand how to fix it. Decided a follow on
patch could fix it up once this series lands.

You are right that DUPLEX_UNKNOWN is the safest (and usually correct) default.
Additionally, if RX and TX speed are equal, I am willing to assume
this is DUPLEX_FULL.
I can propose something like this in a patch:

grundler <1637>git diff
diff --git a/drivers/net/usb/usbnet.c b/drivers/net/usb/usbnet.c
index 86eb1d107433..a7ad9a0fb6ae 100644
--- a/drivers/net/usb/usbnet.c
+++ b/drivers/net/usb/usbnet.c
@@ -978,6 +978,11 @@ int usbnet_get_link_ksettings_internal(struct
net_device *net,
        else
                cmd->base.speed = SPEED_UNKNOWN;

+       if (dev->rx_speed == dev->tx_speed)
+               cmd->base.duplex = DUPLEX_FULL;
+       else
+               cmd->base.duplex =DUPLEX_UNKNOWN;
+
        return 0;
 }
 EXPORT_SYMBOL_GPL(usbnet_get_link_ksettings_internal);

Probably should check that link speed is > 100Mbps to be more certain
about this assumption (based on your comments above).

I can send this out later once this series lands or you are welcome to
post this with additional checks if you like.

The messy case is when RX != TX speed and I didn't want to delay
landing the current series to figure out DUPLEX.

> > I expect "Auto-Negotiation" is always true for cdc_ncm and
> > cdc_ether devices and perhaps someone knows offhand how
> > to have ethtool report "true" instead.
>
> ethtool_link_ksettings contains three bitmaps:
>
> supported: The capabilities of this device.
> advertising: What this device is telling the link peer it can do.
> lp_advertising: What the link peer is telling us it can do.
>
> So to get Supports auto-negotiation to be true you need to set bit
> ETHTOOL_LINK_MODE_Autoneg_BIT in supported.
> For Advertised auto-negotiation: you need to set the same bit in
> advertising.
>
> Auto-negotiation: off is i think from base.autoneg.

Thanks for explaining! :)  I understand the three bitmaps. I just
hadn't taken the time to figure out how to access/set those from
link_ksettings API.

If we want to assume autoneg is always on (regardless of which type of
media cdc_ncm/cdc_ether are talking to), we could set both supported
and advertising to AUTO and lp_advertising to UNKNOWN. But I would
prefer to add more checks to prove this is correct (vs making "well
intentioned" assumptions).

cheers,
grant
