Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B8253BBBB2
	for <lists+netdev@lfdr.de>; Mon, 23 Sep 2019 20:38:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728050AbfIWSix (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Sep 2019 14:38:53 -0400
Received: from mail-qk1-f171.google.com ([209.85.222.171]:43245 "EHLO
        mail-qk1-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727376AbfIWSiw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Sep 2019 14:38:52 -0400
Received: by mail-qk1-f171.google.com with SMTP id h126so16497309qke.10
        for <netdev@vger.kernel.org>; Mon, 23 Sep 2019 11:38:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=L6WJ+UsK4vqXfuecb/2kN2nIfxVw16YFPagCpNf//Es=;
        b=M0qSpOTgSukYu35WvLbFUcqPi8TMOcKITdPIWzioLqnwbzscbDj6sLvucFPHzWUzf8
         M7yjcZyevmRzc8UsIZEKuWWk7Bkwylcx0fdMDHXTjzh3vl9y3f+ivNPhnIWJMe0vF1m5
         4a3jaZXgxgOAG4rM05ETalPFGsT2VRnUvKMzuL7FeeM5yTGVSwuqgYcoWrzovC/sdJsQ
         /6WPb3NS4TOF8l6Af8owzJ8T094K+RaqrWQi7cUYHOJBErXqhe2HkaNFVZ/rHFAKo+RI
         moxpTrB5ZzBqjqUI3Fo0KWv85AIOoHmHIFVuwKT91hnmGDQa3B/4GW7ODpoq97EMKrU4
         KRYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=L6WJ+UsK4vqXfuecb/2kN2nIfxVw16YFPagCpNf//Es=;
        b=INPZdexxdG6qDxrH+WZmsyYe4M1rj2W3QRiTwkMrTP/Zs3/sDikdTxWyyNa+qNTmzG
         MbTLbPL2Ax9oJbj5Ne8kti1rdLAijso+oYvlZK/k4Jm3vB5ZZaliRWPQUKClwDgx80sA
         rcCAQ3YO5B+ZvLSCyK4ClBAvHEYxf8oO47aHnbWtrAmro98tQvwo2JtGIhD8+6NvffeE
         /k3lHrwIQYQ+aklGw83iw83sA/KaDQ1MNqu2j0/5B8Hjv+d9xvPPdfM6bL92nRxlqLER
         Sq0/4OhkyKsTIPV9Dpa3TeM/U/wUEwNY/8RylU3ahrQkv+uaE9eqGHfrrF+NvJ9FWLIt
         kEQw==
X-Gm-Message-State: APjAAAWNBgS7VWK0MtO+sr6K9wAz0PxwTaggqxfal2BYNAOkxbDz3jDI
        MnNZICo5naopG/srIX4pp8Y35yd38Upq5JnQZzhFn2741eM=
X-Google-Smtp-Source: APXvYqy7PEFuRG03kqPTLAe5uumWLnKsP8YKFHz7tkyl1/dxQW+S5J8DuhbScXHqAPc9XLW3BekmRRKg5qjodKrfla8=
X-Received: by 2002:a37:ac01:: with SMTP id e1mr1422113qkm.140.1569263931463;
 Mon, 23 Sep 2019 11:38:51 -0700 (PDT)
MIME-Version: 1.0
From:   Zoran Stojsavljevic <zoran.stojsavljevic@gmail.com>
Date:   Mon, 23 Sep 2019 20:38:40 +0200
Message-ID: <CAGAf8LzeyrMSHCYMxn1FNtMQVyhhLYbJaczhe2AMj+7T_nBt7Q@mail.gmail.com>
Subject: DSA driver kernel extension for dsa mv88e6190 switch
To:     netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Community,

We have interesting problem to solve using our HW platform. And I hope
somebody has the similar example, and some patches, which need to be
applied to the kernel (directory .../drivers/net/dsa/) to make this
application to work.

We have the configuration problem with the Marvell 88E6190 switch.
What the our problem is... Is the switch is NOT configured with the
EEPROM (24C512), which does not exist on the board. It is put in
autoconfig by HW straps (NOCPU mode). Once the MDIO command, issued to
probe the switch and read the make of it, the switch jumps out of the
autoconfig mode. There are some commands issued from the DSA to
configure the switch (to apply to switch TXC and RXC RGMII delays -
RGMII-ID mode), but this is not enough to make it work properly.

Once the configuration is not properly applied (NOT configured via
EEPROM 24C512). We have problems when the Linux booting phase comes to
LIBPHY. Since switch should be transparent to the PHYs at that time,
but my best guess, it is not!

Once LIBPHY starts writing to the switch (since MDIO commands are not
reaching PHYs), switch blocks. Exists from auto config mode and
refuses to respond (my best guess). So no ping possible on the
MV88E61890 MACs and through after Linux boots.

If we physically cut the MDIO line and put the switch in autoconfig
mode, then switch stays in autoconfig mode (by HW straps), but then it
is impossible to do RGMII TxC and RxC clock skew, since i.MX6 has the
silicon bug which does NOT allow this skew to be applied to i.MX6 (1.5
ns skew MUST be applied to the both clocks). If this done from the
DSA, (having MDIO fully in effect), the switch goes out of autoconfig
and does not finish the proper config.

I have here three questions, I hope there are some educated suggestions?

[1] Does this, what I wrote here, sound resonable (Google has very
little on it)?

[2] Does this problem with MV88E6190 switch could be solved
introducing some MV88E6190 configuration via RGMII mode in U-Boot
(setting the switch in U-boot and letting kernel do what it does, at
the end everything works seamlessly)?

[3] Does anybody have pointer to some similar patches for the DSA
driver addendum (NO U-boot involved), how to properly deal with this
problem and fully configure the switch from Linux DSA driver (chip.c
as switch config, and port.c files)??

Any advice is appreciated!

Thank you in advance,
Zoran
_______
