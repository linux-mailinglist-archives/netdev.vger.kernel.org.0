Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 436325EDFA7
	for <lists+netdev@lfdr.de>; Wed, 28 Sep 2022 17:06:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234645AbiI1PGb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Sep 2022 11:06:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234618AbiI1PGZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Sep 2022 11:06:25 -0400
Received: from mailout-taastrup.gigahost.dk (mailout-taastrup.gigahost.dk [46.183.139.199])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4CF0240A6;
        Wed, 28 Sep 2022 08:06:19 -0700 (PDT)
Received: from mailout.gigahost.dk (mailout.gigahost.dk [89.186.169.112])
        by mailout-taastrup.gigahost.dk (Postfix) with ESMTP id 0B8FC1884BC7;
        Wed, 28 Sep 2022 15:06:17 +0000 (UTC)
Received: from smtp.gigahost.dk (smtp.gigahost.dk [89.186.169.109])
        by mailout.gigahost.dk (Postfix) with ESMTP id ED49F2500370;
        Wed, 28 Sep 2022 15:06:16 +0000 (UTC)
Received: by smtp.gigahost.dk (Postfix, from userid 1000)
        id E483B9EC0009; Wed, 28 Sep 2022 15:06:16 +0000 (UTC)
X-Screener-Id: 413d8c6ce5bf6eab4824d0abaab02863e8e3f662
Received: from fujitsu.vestervang (2-104-116-184-cable.dk.customer.tdc.net [2.104.116.184])
        by smtp.gigahost.dk (Postfix) with ESMTPSA id 11F749120FED;
        Wed, 28 Sep 2022 15:06:16 +0000 (UTC)
From:   Hans Schultz <netdev@kapio-technology.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org,
        "Hans J. Schultz" <netdev@kapio-technology.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Woojung Huh <woojung.huh@microchip.com>,
        UNGLinuxDriver@microchip.com, Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ivan Vecera <ivecera@redhat.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Shuah Khan <shuah@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        Christian Marangi <ansuelsmth@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Yuwei Wang <wangyuweihx@gmail.com>,
        Petr Machata <petrm@nvidia.com>,
        Ido Schimmel <idosch@nvidia.com>,
        Florent Fourcot <florent.fourcot@wifirst.fr>,
        Hans Schultz <schultz.hans@gmail.com>,
        Joachim Wiberg <troglobit@gmail.com>,
        Amit Cohen <amcohen@nvidia.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org,
        bridge@lists.linux-foundation.org, linux-kselftest@vger.kernel.org
Subject: [PATCH v6 net-next 0/9] Extend locked port feature with FDB locked flag (MAC-Auth/MAB)
Date:   Wed, 28 Sep 2022 17:02:47 +0200
Message-Id: <20220928150256.115248-1-netdev@kapio-technology.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: "Hans J. Schultz" <netdev@kapio-technology.com>

This patch set extends the locked port feature for devices
that are behind a locked port, but do not have the ability to
authorize themselves as a supplicant using IEEE 802.1X.
Such devices can be printers, meters or anything related to
fixed installations. Instead of 802.1X authorization, devices
can get access based on their MAC addresses being whitelisted.

For an authorization daemon to detect that a device is trying
to get access through a locked port, the bridge will add the
MAC address of the device to the FDB with a locked flag to it.
Thus the authorization daemon can catch the FDB add event and
check if the MAC address is in the whitelist and if so replace
the FDB entry without the locked flag enabled, and thus open
the port for the device.

This feature is known as MAC-Auth or MAC Authentication Bypass
(MAB) in Cisco terminology, where the full MAB concept involves
additional Cisco infrastructure for authorization. There is no
real authentication process, as the MAC address of the device
is the only input the authorization daemon, in the general
case, has to base the decision if to unlock the port or not.

With this patch set, an implementation of the offloaded case is
supplied for the mv88e6xxx driver. When a packet ingresses on
a locked port, an ATU miss violation event will occur. When
handling such ATU miss violation interrupts, the MAC address of
the device is added to the FDB with a zero destination port
vector (DPV) and the MAC address is communicated through the
switchdev layer to the bridge, so that a FDB entry with the
locked flag enabled can be added.

Log:
        v3:     Added timers and lists in the driver (mv88e6xxx)
                to keep track of and remove locked entries.

        v4:     Leave out enforcing a limit to the number of
                locked entries in the bridge.
                Removed the timers in the driver and use the
                worker only. Add locked FDB flag to all drivers
                using port_fdb_add() from the dsa api and let
                all drivers ignore entries with this flag set.
                Change how to get the ageing timeout of locked
                entries. See global1_atu.c and switchdev.c.
                Use struct mv88e6xxx_port for locked entries
                variables instead of struct dsa_port.

        v5:    	Added 'mab' flag to enable MAB/MacAuth feature,
        	in a similar way to the locked feature flag.

        	In these implementations for the mv88e6xxx, the
        	switchport must be configured with learning on.

        	To tell userspace about the behavior of the
        	locked entries in the driver, a 'blackhole'
        	FDB flag has been added, which locked FDB
        	entries coming from the driver gets. Also the
        	'sticky' flag comes with those locked entries,
        	as the drivers locked entries cannot roam.

        	Fixed issues with taking mutex locks, and added
        	a function to read the fid, that supports all
        	versions of the chipset family.

        v6:     Added blackhole FDB flag instead of using sticky
		flag, as the blackhole flag corresponds to the
		behaviour of the zero-DPV locked entries in the
		driver.

		Userspace can add blackhole FDB entries with:
		# bridge fdb add MAC dev br0 blackhole

		Added FDB flags towards driver in DSA layer as u16.

Hans J. Schultz (9):
  net: bridge: add locked entry fdb flag to extend locked port feature
  net: bridge: add blackhole fdb entry flag
  net: switchdev: add support for offloading of the FDB locked flag
  net: switchdev: support offloading of the FDB blackhole flag
  drivers: net: dsa: add fdb entry flags to drivers
  net: dsa: mv88e6xxx: allow reading FID when handling ATU violations
  net: dsa: mv88e6xxx: mac-auth/MAB implementation
  net: dsa: mv88e6xxx: add blackhole ATU entries
  selftests: forwarding: add test of MAC-Auth Bypass to locked port
    tests

 drivers/net/dsa/b53/b53_common.c              |  12 +-
 drivers/net/dsa/b53/b53_priv.h                |   4 +-
 drivers/net/dsa/hirschmann/hellcreek.c        |  12 +-
 drivers/net/dsa/lan9303-core.c                |  12 +-
 drivers/net/dsa/lantiq_gswip.c                |  12 +-
 drivers/net/dsa/microchip/ksz9477.c           |   8 +-
 drivers/net/dsa/microchip/ksz9477.h           |   8 +-
 drivers/net/dsa/microchip/ksz_common.c        |  14 +-
 drivers/net/dsa/mt7530.c                      |  12 +-
 drivers/net/dsa/mv88e6xxx/Makefile            |   1 +
 drivers/net/dsa/mv88e6xxx/chip.c              | 158 +++++++++-
 drivers/net/dsa/mv88e6xxx/chip.h              |  19 ++
 drivers/net/dsa/mv88e6xxx/global1.h           |   1 +
 drivers/net/dsa/mv88e6xxx/global1_atu.c       |  72 ++++-
 drivers/net/dsa/mv88e6xxx/port.c              |  15 +-
 drivers/net/dsa/mv88e6xxx/port.h              |   6 +
 drivers/net/dsa/mv88e6xxx/switchdev.c         | 284 ++++++++++++++++++
 drivers/net/dsa/mv88e6xxx/switchdev.h         |  37 +++
 drivers/net/dsa/ocelot/felix.c                |  12 +-
 drivers/net/dsa/qca/qca8k-common.c            |  10 +-
 drivers/net/dsa/qca/qca8k.h                   |   4 +-
 drivers/net/dsa/sja1105/sja1105_main.c        |  14 +-
 include/linux/if_bridge.h                     |   1 +
 include/net/dsa.h                             |   7 +-
 include/net/switchdev.h                       |   2 +
 include/uapi/linux/if_link.h                  |   1 +
 include/uapi/linux/neighbour.h                |  11 +-
 net/bridge/br.c                               |   5 +-
 net/bridge/br_fdb.c                           |  77 ++++-
 net/bridge/br_input.c                         |  20 +-
 net/bridge/br_netlink.c                       |  12 +-
 net/bridge/br_private.h                       |   5 +-
 net/bridge/br_switchdev.c                     |   4 +-
 net/core/rtnetlink.c                          |   9 +
 net/dsa/dsa_priv.h                            |  10 +-
 net/dsa/port.c                                |  32 +-
 net/dsa/slave.c                               |  16 +-
 net/dsa/switch.c                              |  24 +-
 .../net/forwarding/bridge_blackhole_fdb.sh    | 102 +++++++
 .../net/forwarding/bridge_locked_port.sh      | 106 ++++++-
 .../net/forwarding/bridge_sticky_fdb.sh       |  21 +-
 tools/testing/selftests/net/forwarding/lib.sh |  18 ++
 42 files changed, 1093 insertions(+), 117 deletions(-)
 create mode 100644 drivers/net/dsa/mv88e6xxx/switchdev.c
 create mode 100644 drivers/net/dsa/mv88e6xxx/switchdev.h
 create mode 100755 tools/testing/selftests/net/forwarding/bridge_blackhole_fdb.sh

-- 
2.34.1

