Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BACAF100B2E
	for <lists+netdev@lfdr.de>; Mon, 18 Nov 2019 19:13:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726475AbfKRSN3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Nov 2019 13:13:29 -0500
Received: from mail-wm1-f65.google.com ([209.85.128.65]:40172 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726216AbfKRSN3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Nov 2019 13:13:29 -0500
Received: by mail-wm1-f65.google.com with SMTP id f3so304046wmc.5
        for <netdev@vger.kernel.org>; Mon, 18 Nov 2019 10:13:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=yb+nkwFA87pEn3fUl73Ovn85vhFh0SsK83wEfbg8jV4=;
        b=qr5IrY9I6Op1m+YWnI2qsNIJ1lBF/QF3me8HQO+WtQTeGZAKFmtfXlDa0g6oDMjokU
         X1Zm2K4TOcfLwXD/3to/5BWs31IdTAblwFfluPzc5i9Ajr5m798Xd4qnXcl+DhIyp4DR
         USp+B/35KmfVSk/mqcsrAGz3WbPezhLezmDDcU6XRECUOt+rutQOio0crxadnXEyV5ug
         +9ArjEtXYijJGctdi5pCY5PM1LTi4GgA5AZtwFd+gW9o35qn55Il8qw4v9iUgSvZZF0M
         HLODjWSuXFTMnWYaCL4lCifoMSqcwp3hxnvgAyOGund6ainNZlmd6XZtAH1B6puElwaG
         DXew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=yb+nkwFA87pEn3fUl73Ovn85vhFh0SsK83wEfbg8jV4=;
        b=PByBT1nPVms95woRNcHE/fUxjEOH6CTFINWFOQwJ0qi8WHksEqr5Din4FxWYcgGtXU
         GJzTA89EU+SudZIpFRDblOWiUTUs0P3lmZegL4WDHkqH4WNBYAWuhJY2dobVylNFWR8Q
         mtOiBY0jsT0K6F5f7nGIkrerlrJLaoVS8b3WyWdXBbbKv7eri4nx+yaXehBy+PMIk8WH
         YqKvAzTsF3+okAYl57Jp9w6r8M8iIN1VteJiO5Qe44WK4rIFzjYfs3HvirzwGiERnXvB
         y4aR8JtpmjSp3qaZJXqAn8S6P1xirqIg3J9hOZwVe2LVYpZt8/um1eWk4IF1T5ajJulr
         gmtg==
X-Gm-Message-State: APjAAAUP7anstl0Qagn6Lp6bgh+iS+Y+9XUTj/WhKiCEOtDiDS0JRfNf
        Op7sPQ5SCDeFVHlFdj6/a9I=
X-Google-Smtp-Source: APXvYqxovTFx8LObQbhoc/oOEyH0u47ZO4tMnwI7DnWqM1NFjpViPwLYuWGaeBNVmymY2wbXGn62Qw==
X-Received: by 2002:a7b:c7c7:: with SMTP id z7mr377246wmk.133.1574100807203;
        Mon, 18 Nov 2019 10:13:27 -0800 (PST)
Received: from localhost.localdomain ([86.121.29.241])
        by smtp.gmail.com with ESMTPSA id w7sm23341302wru.62.2019.11.18.10.13.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Nov 2019 10:13:26 -0800 (PST)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     davem@davemloft.net, linux@armlinux.org.uk,
        alexandre.belloni@bootlin.com
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        joergen.andreasen@microchip.com, allan.nielsen@microchip.com,
        horatiu.vultur@microchip.com, claudiu.manoil@nxp.com,
        alexandru.marginean@nxp.com, xiaoliang.yang_1@nxp.com,
        yangbo.lu@nxp.com, netdev@vger.kernel.org,
        Vladimir Oltean <olteanv@gmail.com>
Subject: [PATCH net-next 0/2] Convert Ocelot and Felix switches to PHYLINK
Date:   Mon, 18 Nov 2019 20:10:28 +0200
Message-Id: <20191118181030.23921-1-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series is needed on NXP LS1028A to support the CPU port which runs
at 2500Mbps fixed-link, a setting which PHYLIB can't hold in its swphy
design.

In DSA, PHYLINK comes "for free". I added the PHYLINK ops to the Ocelot
driver, integrated them to the VSC7514 ocelot_board module, then tested
them via the Felix front-end. The VSC7514 integration is only
compile-tested.

Vladimir Oltean (2):
  net: mscc: ocelot: treat SPEED_UNKNOWN as SPEED_10
  net: mscc: ocelot: convert to PHYLINK

 drivers/net/dsa/ocelot/felix.c           |  65 +++++++---
 drivers/net/ethernet/mscc/Kconfig        |   2 +-
 drivers/net/ethernet/mscc/ocelot.c       | 153 ++++++++++++-----------
 drivers/net/ethernet/mscc/ocelot.h       |  13 +-
 drivers/net/ethernet/mscc/ocelot_board.c | 151 +++++++++++++++++++---
 include/soc/mscc/ocelot.h                |  21 +++-
 6 files changed, 285 insertions(+), 120 deletions(-)

-- 

Horatiu, I am sorry for abusing your goodwill. Could you please test
this series and confirm it causes no regression on VSC7514?

2.17.1

