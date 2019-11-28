Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 60F1C10C448
	for <lists+netdev@lfdr.de>; Thu, 28 Nov 2019 08:19:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726754AbfK1HT0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Nov 2019 02:19:26 -0500
Received: from mail-qt1-f179.google.com ([209.85.160.179]:34199 "EHLO
        mail-qt1-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726492AbfK1HT0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Nov 2019 02:19:26 -0500
Received: by mail-qt1-f179.google.com with SMTP id i17so28176537qtq.1
        for <netdev@vger.kernel.org>; Wed, 27 Nov 2019 23:19:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=S/AgBpo0HkEQBVQxSHMCfCK4aBQDo0Cv2zHEA8KD3wY=;
        b=uI6IX+o4DQhbLKxKNTwL724QuSwJR3txkodI/lj5eRKK76X/ffgtmKZO4upbu5vx1I
         k95xzr6wM5SRwmEfLH92SRdbb2JPFHEWlFjYJvdOd1bjBYPxPvONd5kooZ+HujkZ0ikV
         DYpkW4eU573SwcIg0l5WOeYf2T37TBvT1VdyzyrORHcoAHZuizRjGsZ3+9T/dcsoInCB
         Neockf41m1h4fqoPLN1emJmmwA0YO80lZ5riCQs6OYWLVTZ/ssBTChziLswVQh6eNJvh
         hbMOEY+1kqFjp9uoMlkeINKoDGnNVWlCKc9N2i3epsXKCFDqitqP+lsHTx+DobkfBW+X
         KmPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=S/AgBpo0HkEQBVQxSHMCfCK4aBQDo0Cv2zHEA8KD3wY=;
        b=idD4AFZeXBTVlK8yXCRjYesXhIRagzgS/jZ0D7+CMLcAl8mKk1N6kt1mOtQEwZNYds
         fgHUxGxBdcr2Agy3et+kmOAksQe1O75RxXpmmFi64nkmYrzPNTteB5/3KodRq57RQTio
         KTZCcq1dKT8TecYbhjb9gCn1hrUO+i99ma6T20reylx0phuXs6FJOu3fminLFf3/+jIG
         wErf/NkdTXX672kIIHO54PyjFztChL0+chJK2agA30qAr4AElNwjY71pltmabwndFVLp
         vwcB3yFs4JcYfwf0R0Ivzp/VsgbIisRLikxVbAoU2o9jRxXJwjjSi+/+hRrid8Npn6ye
         YpWQ==
X-Gm-Message-State: APjAAAW9g3nwoFW+4vkq9IM0cjcS+2DQCZHACfGVUYXIlGWS0wQOGXJQ
        seDq09tIUZdj4Zuqzl7e3iZLWggYYuWHpZXvewD73mpM7z0=
X-Google-Smtp-Source: APXvYqzhKjWkz2Yr18icB2qHbn6THxoWVmCj12WTdtmpdoMYL3J/6vfUU30G2zaSEwFgXVeiJ1Fbwvf1eVkRtgaOkuA=
X-Received: by 2002:aed:212e:: with SMTP id 43mr6147592qtc.25.1574925565460;
 Wed, 27 Nov 2019 23:19:25 -0800 (PST)
MIME-Version: 1.0
From:   Sam Lewis <sam.vr.lewis@gmail.com>
Date:   Thu, 28 Nov 2019 18:19:14 +1100
Message-ID: <CA+ZLECteuEZJM_4gtbxiEAAKbKnJ_3UfGN4zg_m2EVxk_9=WiA@mail.gmail.com>
Subject: PROBLEM: smsc95xx loses config on link down/up
To:     steve.glendinning@shawell.net, UNGLinuxDriver@microchip.com
Cc:     netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I'm using a LAN9514 chip in my embedded Linux device and have noticed
that changing Ethernet configuration (with ethtool for example) does
not persist after putting the link up.

I have tested this on kernel versions 4.14.0 and 5.0.0-36. As far as I
can tell the driver hasn't had any related fixes since 5.0.0, so I
don't think the behavior has changed in more recent kernel versions.

To demonstrate, what I mean, if I:

1) Take the link down (with `ip link set eth0 down`)
2) Turn auto-negotiation off (with `ethtool -s eth0 autoneg off`)
3) Take the link up (with `ip link set eth0 up`)

Then auto-negotiation is turned back on after the Ethernet interface
is brought back up. This seems to be true for any of the ethtool
configuration settings, like speed and duplex as well.

This is frustrating for a few reasons:

- I can't set the Ethernet configuration before I put the link up
- I can't use systemd .link files for managing link properties as they
seem to set the properties of the link before it's up

I've hacked through the driver code (without really knowing what I'm
doing, just adding various print statements) and I think this happens
because setting a link up causes the `smsc95xx_reset` function to be
called which seems to clear all configuration through:

1) Doing a PHY reset (with `smsc95xx_write_reg(dev, PM_CTRL, PM_CTL_PHY_RST_)`)
2) Doing (another?) PHY reset (with `smsc95xx_mdio_write(dev->net,
dev->mii.phy_id, MII_BMCR, BMCR_RESET)`)

I tested this by looking at the configuration through calling
`mii_ethtool_gset` before and after those two resets. After the
resets, it appears the configuration is cleared.

I'm using the LAN9514 without an attached EEPROM, so understand that
any settings set will not persist through a power cycle, but it would
still be nice if they persisted through setting the interface down and
then up. This seems to be the behavior on other Ethernet devices that
I've tried (even ones without NV storage), so maybe this is a bug with
the LAN95xx driver implementation?

It's very possible that I'm doing something wrong though, I'm happy to
hear if there's some other way to achieve what I'm trying to do.

If this is a real bug I'd be happy to take a look into trying to fix
it. Would it be acceptable to restore any configuration read from a
`mii_ethtool_gset` after the `smsc95xx_reset` is run?
