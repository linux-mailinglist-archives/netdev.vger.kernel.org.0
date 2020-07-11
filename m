Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A88621C47D
	for <lists+netdev@lfdr.de>; Sat, 11 Jul 2020 15:50:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728290AbgGKNug (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Jul 2020 09:50:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727004AbgGKNuf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 11 Jul 2020 09:50:35 -0400
Received: from mail-vs1-xe42.google.com (mail-vs1-xe42.google.com [IPv6:2607:f8b0:4864:20::e42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74BB5C08C5DD
        for <netdev@vger.kernel.org>; Sat, 11 Jul 2020 06:50:35 -0700 (PDT)
Received: by mail-vs1-xe42.google.com with SMTP id d11so1951856vsq.3
        for <netdev@vger.kernel.org>; Sat, 11 Jul 2020 06:50:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=QHgNiPbSLqyDBYXkqFjOK6SwMGYpsYtwFTRtiFFI6a0=;
        b=OpYQEzpi1akxMN59fxn4VejlsuuWAmUI9J0fX3HDo5HqeH6K59L9hBUdR7aVGdZjX5
         MynJwUu2DKadxIsP9cMlOI954N19WZ/o0v8UxFfCSxe8KIEugEQfNvx2CNcgZl+kOTm6
         7jXF+KVrlK8ScaixChTDfAtigkANzXePZkYnoBwLkIUL0yZrEkMB7LgVw7VpqsNX+08k
         ySZebexcfps4spIvoZ8jpJLWO4sWWf8twzFG/v/k/kTe71ieB7pywpfavZIJzQXCxyFP
         +HD3PVV5xYyB+WZxRPFug+B75T7JzCBvKtnQdfeO0O/y+0nd8cn8HmKykAIL+AWzcZKo
         OjdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=QHgNiPbSLqyDBYXkqFjOK6SwMGYpsYtwFTRtiFFI6a0=;
        b=NJEsN6OOl+1Uo+Ghb/m91TbsQ1JCbmXxysyFb0jMNfIUP82i/icSbWFi2ZUzaql/bI
         bhvWPDvoV59/34lQcpyL7R9xO2IPc+QmxWiZ0fa5+rX/kMOH8WBljVoQqtvg3OP7P+3Y
         68TraHS4ImhFTIKiBxBPcI7uN0cwhS9qVULmrFe+JvV5qPxzLPYNch7Q8rFS4O+qd082
         7hkXNc4n6AIymluM9ETFoDpeGQKMGdEb1CdHmTBvcL4QrA0gmDFCSgrA+qWN2kfffNFR
         if9jiG2yYPqmd8mroSpZnZSKaU1UvIUWnELSHyaO5HDorwpAHS2HlrJGDA1+zhjRTRh/
         HiWQ==
X-Gm-Message-State: AOAM533jypW288daekP0LMz6kxrEzUhD4GxTpCJ5gQZ08vNYqLuxyJaA
        gg32hPr6jZ401LKq4XITZAJuN3X2QF1cJa+s3TN8aEzj
X-Google-Smtp-Source: ABdhPJxXiR2AsHJRXrzJVlDZ78P1mVi0qAhXzc6wJ4lT7v0IKppSrdb8CE4oUgqZ0uqnqllnF6DtPD/NKrjd6VadVuo=
X-Received: by 2002:a67:ce08:: with SMTP id s8mr43844387vsl.103.1594475432464;
 Sat, 11 Jul 2020 06:50:32 -0700 (PDT)
MIME-Version: 1.0
From:   Martin Rowe <martin.p.rowe@gmail.com>
Date:   Sat, 11 Jul 2020 13:50:21 +0000
Message-ID: <CAOAjy5T63wDzDowikwZXPTC5fCnPL1QbH9P1v+MMOfydegV30w@mail.gmail.com>
Subject: bug: net: dsa: mv88e6xxx: unable to tx or rx with Clearfog GT 8K
 (with git bisect)
To:     netdev@vger.kernel.org
Cc:     andrew@lunn.ch, davem@davemloft.net, vivien.didelot@gmail.com,
        linux@armlinux.org.uk
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

I hope this is the right forum.

I have been troubleshooting an issue with my Clearfog GT 8Ks where I
am unable to tx or rx on the switch interface, which uses the
mv88e6xxx driver. Based on git bisect, I believe it is related to
commit 34b5e6a33c1a8e466c3a73fd437f66fb16cb83ea from around the
5.7-rc2 era.

Symptoms:
The interface used to work, then it stopped and I didn't immediately
notice because of life. Now the network never comes fully up. dmesg
indicates no issues bringing the device up. Links are brought up and
down with cable connects and disconnects. Negotiation seems to be
working. But the interface rx counter never increases. While the tx
counters do increase, tcpdumps on the other end of the cables never
see any traffic. Basically, it doesn't look like any traffic is going
out or in.

What I have done:
Obvious one first: yes, I bring the parent eth2 before expecting any
of the lan[1-4] interfaces to work.
I know that the interface worked at some point around February when I
was doing some testing.
I have the same issue on all three of my Clearfog GT 8Ks.
Tried different cables.
I searched a lot of web pages.
I can change link modes and duplex using ethtool on a directly
connected device, and I see in dmesg that the Clearfogs detect the
change and reconfigure (example in dmesg output at the bottom).
I have directly connected the switched ports to other devices and
tcpdumped, as well as tried with a commercial switch in between; no
packets are ever received on either side.
I have tried static IP assignments and DHCP. While the interface can
be configured, no packets ever appear to leave the device. When static
IP is assigned, pinging the device doesn't result in anything being
received.
I have tried using the lan[1-4] ports in single port and bridged mode.
I have tried manually configuring the interfaces (i.e. ip commands)
and using systemd.
No firewall rules are active, everything is ACCEPT (iptables,
ebtables, nftables, etc.)
I have tried with and without a MAC address being set in u-boot.
I have tried different u-boot versions, although it wasn't otherwise
changed since the known good working state.
Then I git bisected the mainline kernel...

Commit 34b5e6a33c1a8e466c3a73fd437f66fb16cb83ea is the first "bad"
commit where the interface stops working. To double check I tried with
the latest I had from Linus' branch (HEAD at
bfe91da29bfad9941d5d703d45e29f0812a20724, I think it was around
5.8-rc2), reverted the one problem commit, and the interface worked
again.

I'm using the ARM port of Arch Linux, but I tested with the mainline
kernel that I compiled myself. I did borrow the Arch linux-aarch64
config, though.

I'm more than happy to test any patches, but my C is rudimentary at
best and there's nothing that jumps out at me as being obviously
"wrong" in the problem commit, so I am way out of my depth from here.
Please let me know what information you need from me to help work this
out.

Martin



# dmesg |grep mv88
[    8.635839] mv88e6085 f412a200.mdio-mii:04: switch 0x3400 detected:
Marvell 88E6141, revision 0
[    9.372614] mv88e6085 f412a200.mdio-mii:04: nonfatal error -95
setting MTU on port 1
[    9.382190] mv88e6085 f412a200.mdio-mii:04 lan2 (uninitialized):
PHY [!cp1!config-space@f4000000!mdio@12a200!switch0@4!mdio:11] driver
[Marvell 88E6390] (irq=72)
[    9.401218] mv88e6085 f412a200.mdio-mii:04: nonfatal error -95
setting MTU on port 2
[    9.410884] mv88e6085 f412a200.mdio-mii:04 lan1 (uninitialized):
PHY [!cp1!config-space@f4000000!mdio@12a200!switch0@4!mdio:12] driver
[Marvell 88E6390] (irq=73)
[    9.429732] mv88e6085 f412a200.mdio-mii:04: nonfatal error -95
setting MTU on port 3
[    9.438606] mv88e6085 f412a200.mdio-mii:04 lan4 (uninitialized):
PHY [!cp1!config-space@f4000000!mdio@12a200!switch0@4!mdio:13] driver
[Marvell 88E6390] (irq=74)
[    9.460614] mv88e6085 f412a200.mdio-mii:04: nonfatal error -95
setting MTU on port 4
[    9.469695] mv88e6085 f412a200.mdio-mii:04 lan3 (uninitialized):
PHY [!cp1!config-space@f4000000!mdio@12a200!switch0@4!mdio:14] driver
[Marvell 88E6390] (irq=75)
[    9.497221] mv88e6085 f412a200.mdio-mii:04: configuring for
inband/2500base-x link mode
[    9.719879] mv88e6085 f412a200.mdio-mii:04 lan2: configuring for
phy/ link mode
[    9.789470] mv88e6085 f412a200.mdio-mii:04 lan1: configuring for
phy/ link mode
[    9.803635] mv88e6085 f412a200.mdio-mii:04 lan4: configuring for
phy/ link mode
[    9.822532] mv88e6085 f412a200.mdio-mii:04 lan3: configuring for
phy/ link mode
[   12.827209] mv88e6085 f412a200.mdio-mii:04 lan4: Link is Up -
1Gbps/Full - flow control rx/tx
[   12.848385] mv88e6085 f412a200.mdio-mii:04 lan2: Link is Up -
1Gbps/Full - flow control rx/tx
[   12.933265] mv88e6085 f412a200.mdio-mii:04 lan3: Link is Up -
1Gbps/Full - flow control rx/tx
[ 1582.803879] mv88e6085 f412a200.mdio-mii:04 lan4: Link is Down
[ 1585.109257] mv88e6085 f412a200.mdio-mii:04 lan4: Link is Up -
10Mbps/Half - flow control off
[ 1600.842612] mv88e6085 f412a200.mdio-mii:04 lan4: Link is Down
[ 1603.807772] mv88e6085 f412a200.mdio-mii:04 lan4: Link is Up -
1Gbps/Full - flow control rx/tx

# ip a
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN
group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
       valid_lft forever preferred_lft forever
    inet6 ::1/128 scope host
       valid_lft forever preferred_lft forever
2: eth0: <BROADCAST,MULTICAST> mtu 1500 qdisc noop state DOWN group
default qlen 2048
    link/ether d0:63:b4:01:00:01 brd ff:ff:ff:ff:ff:ff
3: eth1: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc mq state UP
group default qlen 2048
    link/ether d0:63:b4:01:00:00 brd ff:ff:ff:ff:ff:ff
    inet 10.0.0.20/24 brd 10.0.0.255 scope global dynamic eth1
       valid_lft 1892sec preferred_lft 1892sec
    inet6 fe80::d263:b4ff:fe01:0/64 scope link
       valid_lft forever preferred_lft forever
4: eth2: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1508 qdisc mq state UP
group default qlen 2048
    link/ether d0:63:b4:01:00:02 brd ff:ff:ff:ff:ff:ff
    inet 169.254.181.234/16 brd 169.254.255.255 scope link eth2
       valid_lft forever preferred_lft forever
    inet6 fe80::d263:b4ff:fe01:2/64 scope link
       valid_lft forever preferred_lft forever
5: lan2@eth2: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue
state UP group default qlen 1000
    link/ether d0:63:b4:01:00:02 brd ff:ff:ff:ff:ff:ff
    inet6 fe80::d263:b4ff:fe01:2/64 scope link
       valid_lft forever preferred_lft forever
6: lan1@eth2: <NO-CARRIER,BROADCAST,MULTICAST,UP> mtu 1500 qdisc
noqueue state LOWERLAYERDOWN group default qlen 1000
    link/ether d0:63:b4:01:00:02 brd ff:ff:ff:ff:ff:ff
7: lan4@eth2: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue
state UP group default qlen 1000
    link/ether d0:63:b4:01:00:02 brd ff:ff:ff:ff:ff:ff
    inet6 fe80::d263:b4ff:fe01:2/64 scope link
       valid_lft forever preferred_lft forever
8: lan3@eth2: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue
state UP group default qlen 1000
    link/ether d0:63:b4:01:00:02 brd ff:ff:ff:ff:ff:ff
    inet6 fe80::d263:b4ff:fe01:2/64 scope link
       valid_lft forever preferred_lft forever
