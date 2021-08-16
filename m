Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 02E6B3ED1F4
	for <lists+netdev@lfdr.de>; Mon, 16 Aug 2021 12:29:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235738AbhHPK3f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Aug 2021 06:29:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233954AbhHPK3c (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Aug 2021 06:29:32 -0400
Received: from mail-lj1-x229.google.com (mail-lj1-x229.google.com [IPv6:2a00:1450:4864:20::229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C10A6C061764
        for <netdev@vger.kernel.org>; Mon, 16 Aug 2021 03:29:00 -0700 (PDT)
Received: by mail-lj1-x229.google.com with SMTP id c12so13347899ljr.5
        for <netdev@vger.kernel.org>; Mon, 16 Aug 2021 03:29:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=hnn/XCO1KNrPSIWH/8V0Bw4tyoD6BS0iYBrTL9QxGow=;
        b=HVCzQKllFk76lGYWg8PqIdnISq0nWwRobL4RsK8zf2jreaxxKrLzRnq5JX0lod3H4t
         2odRj+YYWb0SnR3g473c5sBLXFFztJxqC4l029yvHyERKXHqrwghmPjUmQSMjDWgm+cA
         Fcowv/jgkCLsKJd6Pw32H06/WVpLhcKnW11a9A+aG7RFza17GFhmhTWdhxos7WcU+eb+
         ODs7O2yFZBUT0fWedLqkvFFAl/SKS+iHS1ujswYQefGDzWCd6r/kp3M9cykwkPnlk6fb
         kPOCBht1p0/QqhxvvP/xgjQfnVAqWk9KStEuIOkOcJG3kQdEkgyXood8QcyRJXxHbKpR
         mk6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=hnn/XCO1KNrPSIWH/8V0Bw4tyoD6BS0iYBrTL9QxGow=;
        b=UslHUuxFY4qPB8a/amx95F4KetvgAdOzJveSRuekBJXi7OG4S74sM/uBnagZJk+Zel
         JLyGz1HpCzT/32BapclI5ATKnH/0oxSeHeskui5vhbKYkck7TLbfouiVFgflei/mPvVY
         PAKTSHGMVOHpWC4T5KtszrqEJqaJonvdgcTGQ/Q7Z30i3VkeXvsaUhmSp3c3Ddl4e5Hk
         6q+BNByX1CfDF9rvpyuhRJY3nllKwRig4lhccf/Yf94FXrUq7cgXTKAZIS6S8FHYXyvL
         /BZ4wqlKQkgkrRwio+i3/QrBL1/M2qOwLtC3YAsbV2supnxeotY1vP7J1qZs+Ju50Cne
         oZCA==
X-Gm-Message-State: AOAM533u5XFEpDyI4HHGE3/LRkWuHJO++AerHR/+IW3ifVqd2yZfWZi+
        IJyDd5CP3z0Bh2DByM8NHHc4Plmngkz9wY4Eb26TSv5Juh0=
X-Google-Smtp-Source: ABdhPJwg5e2wRHxw2WBIBWXf7jT8zsR+QI8vBeoVeRHIFpyxLcRIs/h/aWfTgU3w7EQ48B60jrappBs0VqEx9TTGv0A=
X-Received: by 2002:a2e:a275:: with SMTP id k21mr8016651ljm.228.1629109739102;
 Mon, 16 Aug 2021 03:28:59 -0700 (PDT)
MIME-Version: 1.0
From:   Tom Yan <tom.ty89@gmail.com>
Date:   Mon, 16 Aug 2021 18:28:48 +0800
Message-ID: <CAGnHSE=0ZQK=e4kV3CgycM1xTE+woT607ZHRP_EZtngwVvVB-w@mail.gmail.com>
Subject: ip link set master recursively put devices into promiscuous mode?
To:     stephen@networkplumber.org, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

I've bumped into a weird / bad behavior of ip link when I use it to
enslave a passthru macvlan to a bridge:

# grep . /etc/systemd/network/*.net*
[NetDev]
Name=bridge1
Kind=bridge
# ip l add macvl0 link wlan0 type macvlan mode passthru
# date; ip l set macvl0 up
Mon Aug 16 05:31:02 PM HKT 2021
# date; ip l delete macvl0
Mon Aug 16 05:31:12 PM HKT 2021
# ip l add macvl0 link wlan0 type macvlan mode passthru
# date; ip l set macvl0 up
Mon Aug 16 05:31:35 PM HKT 2021
# date; ip l set macvl0 master bridge1
Mon Aug 16 05:31:42 PM HKT 2021
# date; ip l delete macvl0
Mon Aug 16 05:31:47 PM HKT 2021
# journalctl -k | grep promisc
Aug 16 17:31:02 ideapad kernel: device wlan0 entered promiscuous mode
Aug 16 17:31:12 ideapad kernel: device wlan0 left promiscuous mode
Aug 16 17:31:35 ideapad kernel: device wlan0 entered promiscuous mode
Aug 16 17:31:42 ideapad kernel: device macvl0 entered promiscuous mode
Aug 16 17:31:47 ideapad kernel: device macvl0 left promiscuous mode

The cause became clear when I use the nopromisc flag:

# ip l add macvl0 link wlan0 type macvlan mode passthru nopromisc
# date; ip l set macvl0 up
Mon Aug 16 05:35:27 PM HKT 2021
# date; ip l set macvl0 master bridge1
Mon Aug 16 05:35:36 PM HKT 2021
# date; ip l delete macvl0
Mon Aug 16 05:35:47 PM HKT 2021
# journalctl -k | grep promisc
Aug 16 17:35:36 ideapad kernel: device macvl0 entered promiscuous mode
Aug 16 17:35:36 ideapad kernel: device wlan0 entered promiscuous mode
Aug 16 17:35:47 ideapad kernel: device macvl0 left promiscuous mode

For some reason it causes the underlying device of the macvlan to also
enter promiscuous mode. In addition to the fact that the behavior
causes the underlying device *stay* in promiscuous mode (which shows
why it is *bad*), it does not seem to be a kernel-side problem either,
as when I use systemd-networkd to enslave the macvlan, it works as
expected / desired:

# grep . /etc/systemd/network/*.net*
/etc/systemd/network/bridge1.netdev:[NetDev]
/etc/systemd/network/bridge1.netdev:Name=bridge1
/etc/systemd/network/bridge1.netdev:Kind=bridge
/etc/systemd/network/macvl0.network:[Match]
/etc/systemd/network/macvl0.network:Name=macvl0
/etc/systemd/network/macvl0.network:[Network]
/etc/systemd/network/macvl0.network:Bridge=bridge1
# date; ip l add macvl0 link wlan0 type macvlan mode passthru
Mon Aug 16 05:21:50 PM HKT 2021
# date; ip l delete macvl0
Mon Aug 16 05:22:01 PM HKT 2021
# date; ip l add macvl0 link wlan0 type macvlan mode passthru nopromisc
Mon Aug 16 05:22:09 PM HKT 2021
# date; ip l delete macvl0
Mon Aug 16 05:22:15 PM HKT 2021
# journalctl -k | grep -i promisc
Aug 16 17:21:50 ideapad kernel: device macvl0 entered promiscuous mode
Aug 16 17:21:50 ideapad kernel: device wlan0 entered promiscuous mode
Aug 16 17:22:01 ideapad kernel: device wlan0 left promiscuous mode
Aug 16 17:22:01 ideapad kernel: device macvl0 left promiscuous mode
Aug 16 17:22:09 ideapad kernel: device macvl0 entered promiscuous mode
Aug 16 17:22:15 ideapad kernel: device macvl0 left promiscuous mode

Any ideas?

Regards,
Tom
