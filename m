Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5FF1CB6A7F
	for <lists+netdev@lfdr.de>; Wed, 18 Sep 2019 20:27:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388046AbfIRS1T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Sep 2019 14:27:19 -0400
Received: from mail-qt1-f195.google.com ([209.85.160.195]:41115 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387444AbfIRS1T (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Sep 2019 14:27:19 -0400
Received: by mail-qt1-f195.google.com with SMTP id x4so903961qtq.8
        for <netdev@vger.kernel.org>; Wed, 18 Sep 2019 11:27:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=selectel-ru.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to;
        bh=g/LHKyTZ2+yBp+jNWR7RT+3jLJCug/8YGoHsrPXwaHU=;
        b=kupqvlWzvV+Q/uErcsU4GapSvi5hmqNbgfTSRYLK8JpMCDupAMa0iLusVnpNspfQdX
         Uaj7KUe6TVLW6A9wGOMCTQc7D2dG8Ya5SCrzX8D+YgQmNo0vChjnLIMmncqfhIcaqun9
         Mdm1DfOyGogMIOdA9ibX8J4Mk8z6E6Ow7s58LTJP3DLyliF95ONs8kvAfeYtQloFW9eO
         BnYgvWorok3fLKzaIPQXDcjXLcoaxAfnkD/Rb5K1+xjnMFMxiFplupvqN/I+fu3OKawA
         PAFs3Rn6AeLW6uDmqq1WsKa94GErP7ueyg7FIWfx5H1uhwazh9Gsz+1hGSI/TZjIii7Z
         o79w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to;
        bh=g/LHKyTZ2+yBp+jNWR7RT+3jLJCug/8YGoHsrPXwaHU=;
        b=pL/cbBTA+0t1jdCz7c+h/EMOK5QJLpY89xd+iSKG9KRdEJNpMHkML60VHjNmFEsd4K
         XwpbUa+L26tMQpeHdGKVuIZ5VgWwncaciedYPjP+V7pRV16zVYol+if58EOSP9wB0ozc
         TKOGxf1kTW1RS9IfsCqM1+XSEBMf6yXXcMaDMX1jKBeuDnaEWLiK7luwQ9gvK/sfO0I+
         UguRw/SVq7CnHACVA5BIHuo+TdCACKT5j5vBvLGiWxGV24i5qCELeIKSZDCCWGl9cV1E
         fFk4QlhNyNiILltP3zo21I/PR845wchjCMk2DwLed1GXo+xf6bLRE3iJaAz+wsMt+eSZ
         DxvQ==
X-Gm-Message-State: APjAAAUdv8j5Nz3f+1DQ75Z3bHuSEUgo1yutPIco1MzoEkoPpph46kBG
        +xyym9us2zrd+IO8t55q76ApnuCYjZlkIemGGmD/pg==
X-Google-Smtp-Source: APXvYqwOtYJBioxBrns7JSxTjg4i1EzJFkTm/p54CqtTMsKEQ0Du1Q/DdJeQ9Otxjm+YEr2ZbtJCaGNtc6vxeIb8S2o=
X-Received: by 2002:ac8:6d03:: with SMTP id o3mr5278234qtt.97.1568831236896;
 Wed, 18 Sep 2019 11:27:16 -0700 (PDT)
MIME-Version: 1.0
References: <20190918130545.GA11133@yandex.ru> <31893.1568817274@nyx> <CAJYOGF9KZdouvmTxQcTOQgsi-uBxbvW50K3ufW1=8neeW98QVA@mail.gmail.com>
In-Reply-To: <CAJYOGF9KZdouvmTxQcTOQgsi-uBxbvW50K3ufW1=8neeW98QVA@mail.gmail.com>
From:   =?UTF-8?B?0JDQu9C10LrRgdC10Lkg0JfQsNGF0LDRgNC+0LI=?= 
        <zaharov@selectel.ru>
Date:   Wed, 18 Sep 2019 21:27:05 +0300
Message-ID: <CAJYOGF8LDwbZXXeEioKAtx=0rq9eZBxFYuRfF3jdFCDUGnJ-Rg@mail.gmail.com>
Subject: Fwd: [PATCH] bonding/802.3ad: fix slave initialization states race
To:     jay.vosburgh@canonical.com, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> >Once a while, one of 802.3ad slaves fails to initialize and hangs in
> >BOND_LINK_FAIL state. Commit 334031219a84 ("bonding/802.3ad: fix slave
> >link initialization transition states") checks slave->last_link_up. But
> >link can still hang in weird state.
> >After physical link comes up it sends first two LACPDU messages and
> >doesn't work properly after that. It doesn't send or receive LACPDU.
> >Once it happens, the only message in dmesg is:
> >bond1: link status up again after 0 ms for interface eth2
>
>         I believe this message indicates that the slave entered
> BOND_LINK_FAIL state, but downdelay was not set.  The _FAIL state is
> really for managing the downdelay expiration, and a slave should not be
> in that state (outside of a brief transition entirely within
> bond_miimon_inspect) if downdelay is 0.
That's true, downdelay was set to 0, we only use updelay 500.
Does it mean, that the bonding driver shouldn't set slave to FAIL
state in this case?

>
> >This behavior can be reproduced (not every time):
> >1. Set slave link down
> >2. Wait for 1-3 seconds
> >3. Set slave link up
> >
> >The fix is to check slave->link before setting it to BOND_LINK_FAIL or
> >BOND_LINK_DOWN state. If got invalid Speed/Dupex values and link is in
> >BOND_LINK_UP state, mark it as BOND_LINK_FAIL; otherwise mark it as
> >BOND_LINK_DOWN.
> >
> >Fixes: 334031219a84 ("bonding/802.3ad: fix slave link initialization
> >transition states")
> >Signed-off-by: Aleksei Zakharov <zakharov.a.g@yandex.ru>
> >---
> > drivers/net/bonding/bond_main.c | 2 +-
> > 1 file changed, 1 insertion(+), 1 deletion(-)
> >
> >diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
> >index 931d9d935686..a28776d8f33f 100644
> >--- a/drivers/net/bonding/bond_main.c
> >+++ b/drivers/net/bonding/bond_main.c
> >@@ -3135,7 +3135,7 @@ static int bond_slave_netdev_event(unsigned long event,
> >                */
> >               if (bond_update_speed_duplex(slave) &&
> >                   BOND_MODE(bond) == BOND_MODE_8023AD) {
> >-                      if (slave->last_link_up)
> >+                      if (slave->link == BOND_LINK_UP)
> >                               slave->link = BOND_LINK_FAIL;
> >                       else
> >                               slave->link = BOND_LINK_DOWN;
>
>         Is the core problem here that slaves are reporting link up, but
> returning invalid values for speed and/or duplex?  If so, what network
> device are you testing with that is exhibiting this behavior?
That's true, because link becomes FAIL right in this block of code.
We use Mellanox ConnectX-3 Pro nic.

>
>         If I'm not mistaken, there have been several iterations of
> hackery on this block of code to work around this same problem, and each
> time there's some corner case that still doesn't work.
As i can see, commit 4d2c0cda0744 ("bonding: speed/duplex update at
NETDEV_UP event")
introduced BOND_LINK_DOWN state if update speed/duplex failed.

Commit ea53abfab960 ("bonding/802.3ad: fix link_failure_count tracking")
changed DOWN state to FAIL.

Commit 334031219a84 ("bonding/802.3ad: fix slave link initialization
transition states")
implemented different new state for different current states, but it
was based on slave->last_link_up.
In our case slave->last_link_up !=0 when this code runs. But, slave is
not in UP state at the moment. It becomes
FAIL and hangs in this state.
So, it looks like checking if slave is in UP mode is more appropriate
here. At least it works in our case.

There was one more commit 12185dfe4436 ("bonding: Force slave speed
check after link state recovery for 802.3ad")
but it doesn't help in our case.

>
>         As Davem asked last time around, is the real problem that device
> drivers report carrier up but supply invalid speed and duplex state?
Probably, but I'm not quite sure right now. We didn't face this issue
before 4d2c0cda0744 and ea53abfab960
commits.

>
>         -J
>
> ---
>         -Jay Vosburgh, jay.vosburgh@canonical.com



--
Best Regards,
Aleksei Zakharov
System administrator
