Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7813D6BFACC
	for <lists+netdev@lfdr.de>; Sat, 18 Mar 2023 15:24:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229933AbjCROYi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Mar 2023 10:24:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229809AbjCROYe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 18 Mar 2023 10:24:34 -0400
Received: from mailout-taastrup.gigahost.dk (mailout-taastrup.gigahost.dk [46.183.139.199])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CD2235246;
        Sat, 18 Mar 2023 07:24:29 -0700 (PDT)
Received: from mailout.gigahost.dk (mailout.gigahost.dk [89.186.169.112])
        by mailout-taastrup.gigahost.dk (Postfix) with ESMTP id B7F2918838A8;
        Sat, 18 Mar 2023 14:12:42 +0000 (UTC)
Received: from smtp.gigahost.dk (smtp.gigahost.dk [89.186.169.109])
        by mailout.gigahost.dk (Postfix) with ESMTP id 9E47E25002BC;
        Sat, 18 Mar 2023 14:12:42 +0000 (UTC)
Received: by smtp.gigahost.dk (Postfix, from userid 1000)
        id 929E49B403E4; Sat, 18 Mar 2023 14:12:42 +0000 (UTC)
X-Screener-Id: 413d8c6ce5bf6eab4824d0abaab02863e8e3f662
Received: from fujitsu.vestervang (2-104-116-184-cable.dk.customer.tdc.net [2.104.116.184])
        by smtp.gigahost.dk (Postfix) with ESMTPSA id D42DE91201E3;
        Sat, 18 Mar 2023 14:12:41 +0000 (UTC)
From:   "Hans J. Schultz" <netdev@kapio-technology.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org,
        "Hans J. Schultz" <netdev@kapio-technology.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vladimir Oltean <olteanv@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Woojung Huh <woojung.huh@microchip.com>,
        UNGLinuxDriver@microchip.com (maintainer:MICROCHIP KSZ SERIES ETHERNET
        SWITCH DRIVER), Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        =?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <clement.leger@bootlin.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ivan Vecera <ivecera@redhat.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Shuah Khan <shuah@kernel.org>,
        Christian Marangi <ansuelsmth@gmail.com>,
        Ido Schimmel <idosch@nvidia.com>,
        linux-kernel@vger.kernel.org (open list),
        linux-arm-kernel@lists.infradead.org (moderated list:ARM/Mediatek SoC
        support),
        linux-mediatek@lists.infradead.org (moderated list:ARM/Mediatek SoC
        support),
        linux-renesas-soc@vger.kernel.org (open list:RENESAS RZ/N1 A5PSW SWITCH
        DRIVER),
        bridge@lists.linux-foundation.org (moderated list:ETHERNET BRIDGE),
        linux-kselftest@vger.kernel.org (open list:KERNEL SELFTEST FRAMEWORK)
Subject: [PATCH v2 net-next 0/6] ATU and FDB synchronization on locked ports
Date:   Sat, 18 Mar 2023 15:10:04 +0100
Message-Id: <20230318141010.513424-1-netdev@kapio-technology.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Organization: Westermo Network Technologies AB
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch set makes it possible to have synchronized dynamic ATU and FDB
entries on locked ports. As locked ports are not able to automatically
learn, they depend on userspace added entries, where userspace can add
static or dynamic entries. The lifetime of static entries are completely
dependent on userspace intervention, and thus not of interest here. We
are only concerned with dynamic entries, which can be added with a
command like:

bridge fdb replace ADDR dev <DEV> master dynamic

We choose only to support this feature on locked ports, as it involves
utilizing the CPU to handle ATU related switchcore events (typically
interrupts) and thus can result in significant performance loss if
exposed to heavy traffic.

On locked ports it is important for userspace to know when an authorized
station has become silent, hence not breaking the communication of a
station that has been authorized based on the MAC-Authentication Bypass
(MAB) scheme. Thus if the station keeps being active after authorization,
it will continue to have an open port as long as it is active. Only after
a silent period will it have to be reauthorized. As the ageing process in
the ATU is dependent on incoming traffic to the switchcore port, it is
necessary for the ATU to signal that an entry has aged out, so that the
FDB can be updated at the correct time.

This patch set includes a solution for the Marvell mv88e6xxx driver, where
for this driver we use the Hold-At-One feature so that an age-out
violation interrupt occurs when a station has been silent for the
system-set age time. The age out violation interrupt allows the switchcore
driver to remove both the ATU and the FDB entry at the same time.

It is up to the maintainers of other switchcore drivers to implement the
feature for their specific driver.

LOG:
	V2:	Ensure the port is locked when using the feature as we
		must ensure that learning is enabled at all times for
		the interrupts to occur. This was missed in the previous
		version.

		Instead of ignoring unsupported flags, ensure that
		drivers are only called when supporting the feature.
		As 'dynamic' flag is legacy, all drivers support it at
		least by their previous handling.

Hans J. Schultz (6):
  net: bridge: add dynamic flag to switchdev notifier
  net: dsa: propagate flags down towards drivers
  drivers: net: dsa: add fdb entry flags incoming to switchcore drivers
  net: bridge: ensure FDB offloaded flag is handled as needed
  net: dsa: mv88e6xxx: implementation of dynamic ATU entries
  selftests: forwarding: add dynamic FDB test

 drivers/net/dsa/b53/b53_common.c              |  4 +-
 drivers/net/dsa/b53/b53_priv.h                |  4 +-
 drivers/net/dsa/hirschmann/hellcreek.c        |  4 +-
 drivers/net/dsa/lan9303-core.c                |  4 +-
 drivers/net/dsa/lantiq_gswip.c                |  4 +-
 drivers/net/dsa/microchip/ksz_common.c        |  6 +-
 drivers/net/dsa/mt7530.c                      |  4 +-
 drivers/net/dsa/mv88e6xxx/chip.c              | 20 ++++--
 drivers/net/dsa/mv88e6xxx/chip.h              |  9 ++-
 drivers/net/dsa/mv88e6xxx/global1_atu.c       | 21 +++++++
 drivers/net/dsa/mv88e6xxx/port.c              |  6 +-
 drivers/net/dsa/mv88e6xxx/switchdev.c         | 61 +++++++++++++++++++
 drivers/net/dsa/mv88e6xxx/switchdev.h         |  5 ++
 drivers/net/dsa/mv88e6xxx/trace.h             |  5 ++
 drivers/net/dsa/ocelot/felix.c                |  4 +-
 drivers/net/dsa/qca/qca8k-common.c            |  4 +-
 drivers/net/dsa/qca/qca8k.h                   |  4 +-
 drivers/net/dsa/rzn1_a5psw.c                  |  4 +-
 drivers/net/dsa/sja1105/sja1105_main.c        | 11 ++--
 include/net/dsa.h                             |  9 ++-
 include/net/switchdev.h                       |  1 +
 net/bridge/br_fdb.c                           |  5 +-
 net/bridge/br_switchdev.c                     |  1 +
 net/dsa/dsa.c                                 |  6 ++
 net/dsa/port.c                                | 28 +++++----
 net/dsa/port.h                                |  8 +--
 net/dsa/slave.c                               | 20 ++++--
 net/dsa/switch.c                              | 26 +++++---
 net/dsa/switch.h                              |  1 +
 .../net/forwarding/bridge_locked_port.sh      | 36 +++++++++++
 30 files changed, 258 insertions(+), 67 deletions(-)

-- 
2.34.1

