Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C98E2C4B9C
	for <lists+netdev@lfdr.de>; Thu, 26 Nov 2020 00:26:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731501AbgKYXZt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Nov 2020 18:25:49 -0500
Received: from mail-out.m-online.net ([212.18.0.9]:42333 "EHLO
        mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730073AbgKYXZs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Nov 2020 18:25:48 -0500
Received: from frontend01.mail.m-online.net (unknown [192.168.8.182])
        by mail-out.m-online.net (Postfix) with ESMTP id 4ChH7Y5bCHz1qs0h;
        Thu, 26 Nov 2020 00:25:43 +0100 (CET)
Received: from localhost (dynscan1.mnet-online.de [192.168.6.70])
        by mail.m-online.net (Postfix) with ESMTP id 4ChH7W1c7Vz1vdfr;
        Thu, 26 Nov 2020 00:25:43 +0100 (CET)
X-Virus-Scanned: amavisd-new at mnet-online.de
Received: from mail.mnet-online.de ([192.168.8.182])
        by localhost (dynscan1.mail.m-online.net [192.168.6.70]) (amavisd-new, port 10024)
        with ESMTP id 7UTtCUP6cI3U; Thu, 26 Nov 2020 00:25:40 +0100 (CET)
X-Auth-Info: NXtzVqb2rHz/6wd9Y0nb/ZjeT3ip+hxOijmDOWKGRM0=
Received: from localhost.localdomain (89-64-5-98.dynamic.chello.pl [89.64.5.98])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.mnet-online.de (Postfix) with ESMTPSA;
        Thu, 26 Nov 2020 00:25:40 +0100 (CET)
From:   Lukasz Majewski <lukma@denx.de>
To:     Fugang Duan <fugang.duan@nxp.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        Fabio Estevam <festevam@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>
Cc:     NXP Linux Team <linux-imx@nxp.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Peng Fan <peng.fan@nxp.com>, stefan.agner@toradex.com,
        krzk@kernel.org, Shawn Guo <shawnguo@kernel.org>,
        Lukasz Majewski <lukma@denx.de>
Subject: [RFC 0/4] net: l2switch: Provide support for L2 switch on i.MX28 SoC
Date:   Thu, 26 Nov 2020 00:24:55 +0100
Message-Id: <20201125232459.378-1-lukma@denx.de>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is the first attempt to add support for L2 switch available on some NXP
devices - i.e. iMX287 or VF610. This patch set uses common FEC and DSA code.

This code provides _very_ basic switch functionality (packets are passed
between lan1 and lan2 ports and it is possible to send packets via eth0),
at its main purpose is to establish the way of reusing the FEC driver. When
this is done, one can add more advanced features to the switch (like vlan or
port separation).

I also do have a request for testing on e.g. VF610 if this driver works on
it too.
The L2 switch documentation is very scant on NXP's User Manual [0] and most
understanding of how it really works comes from old (2.6.35) NXP driver [1].
The aforementioned old driver [1] was monolitic and now this patch set tries
to mix FEC and DSA.

Open issues:
- I do have a hard time on understanding how to "disable" ENET-MAC{01} ports
in DSA (via port_disable callback in dsa_switch_ops).
When I disable L2 switch port1,2 or the ENET-MAC{01} in control register, I
cannot simply re-enable it with enabling this bit again. The old driver reset
(and setup again) the whole switch.

- The L2 switch is part of the SoC silicon, so we cannot follow the "normal" DSA
pattern with "attaching" it via mdio device. The switch reuses already well
defined ENET-MAC{01}. For that reason the MoreThanIP switch driver is
registered as platform device

- The question regarding power management - at least for my use case there
is no need for runtime power management. The L2 switch shall work always at
it connects other devices. 

- The FEC clock is also used for L2 switch management and configuration (as
the L2 switch is just in the same, large IP block). For now I just keep it
enabled so DSA code can use it. It looks a bit problematic to export 
fec_enet_clk_enable() to be reused on DSA code.

Links:
[0] - "i.MX28 Applications Processor Reference Manual, Rev. 2, 08/2013"
[1] - https://github.com/lmajewski/linux-imx28-l2switch/commit/e3c7a6eab73401e021aef0070e1935a0dba84fb5

Dependencies:
This patch set depends on one, which adds DTS for XEA board. However, it shall
be also possible to work on any board by adding L2 switch specific description.

https://marc.info/?l=devicetree&m=160632122703785&w=2
https://marc.info/?l=devicetree&m=160632122303783&w=2
https://marc.info/?l=devicetree&m=160632123203787&w=2

Those patches has been tested (applied) on 4.9.130-cip and v5.9 (vanila
mainline kernel)


Lukasz Majewski (4):
  net: fec: Move some defines to ./drivers/net/ethernet/freescale/fec.h
    header
  net: dsa: Provide DSA driver for NXP's More Than IP L2 switch
  net: imx: l2switch: Adjust fec_main.c to provide support for L2 switch
  ARM: dts: imx28: Add description for L2 switch on XEA board

 arch/arm/boot/dts/imx28-xea.dts           |  55 +++
 drivers/net/dsa/Kconfig                   |  11 +
 drivers/net/dsa/Makefile                  |   1 +
 drivers/net/dsa/mtip-l2switch.c           | 399 ++++++++++++++++++++++
 drivers/net/dsa/mtip-l2switch.h           | 239 +++++++++++++
 drivers/net/ethernet/freescale/fec.h      |  42 +++
 drivers/net/ethernet/freescale/fec_main.c | 148 ++++++--
 7 files changed, 874 insertions(+), 21 deletions(-)
 create mode 100644 drivers/net/dsa/mtip-l2switch.c
 create mode 100644 drivers/net/dsa/mtip-l2switch.h

-- 
2.20.1

