Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CACA056A6E3
	for <lists+netdev@lfdr.de>; Thu,  7 Jul 2022 17:29:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235572AbiGGP3u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Jul 2022 11:29:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235982AbiGGP3t (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Jul 2022 11:29:49 -0400
Received: from mailout-taastrup.gigahost.dk (mailout-taastrup.gigahost.dk [46.183.139.199])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A73881902A;
        Thu,  7 Jul 2022 08:29:46 -0700 (PDT)
Received: from mailout.gigahost.dk (mailout.gigahost.dk [89.186.169.112])
        by mailout-taastrup.gigahost.dk (Postfix) with ESMTP id 31FD41886E58;
        Thu,  7 Jul 2022 15:29:44 +0000 (UTC)
Received: from smtp.gigahost.dk (smtp.gigahost.dk [89.186.169.109])
        by mailout.gigahost.dk (Postfix) with ESMTP id 0997825032B7;
        Thu,  7 Jul 2022 15:29:43 +0000 (UTC)
Received: by smtp.gigahost.dk (Postfix, from userid 1000)
        id DCF02A1E00B8; Thu,  7 Jul 2022 15:29:42 +0000 (UTC)
X-Screener-Id: 413d8c6ce5bf6eab4824d0abaab02863e8e3f662
Received: from wse-c0127.vestervang (unknown [208.127.141.28])
        by smtp.gigahost.dk (Postfix) with ESMTPSA id 770249120FED;
        Thu,  7 Jul 2022 15:29:41 +0000 (UTC)
From:   Hans Schultz <netdev@kapio-technology.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, Hans Schultz <netdev@kapio-technology.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, Jiri Pirko <jiri@resnulli.us>,
        Ivan Vecera <ivecera@redhat.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Shuah Khan <shuah@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Ido Schimmel <idosch@nvidia.com>, linux-kernel@vger.kernel.org,
        bridge@lists.linux-foundation.org, linux-kselftest@vger.kernel.org
Subject: [PATCH v4 net-next 0/6] Extend locked port feature with FDB locked flag (MAC-Auth/MAB)
Date:   Thu,  7 Jul 2022 17:29:24 +0200
Message-Id: <20220707152930.1789437-1-netdev@kapio-technology.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Organization: Westermo Network Technologies AB
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,FROM_FMBLA_NEWDOM,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

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
	v3:	Added timers and lists in the driver (mv88e6xxx)
		to keep track of and remove locked entries.

	v4:	Leave out enforcing a limit to the number of
		locked entries in the bridge.
		Removed the timers in the driver and use the
		worker only. Add locked FDB flag to all drivers
		using port_fdb_add() from the dsa api and let
		all drivers ignore entries with this flag set.
		Change how to get the ageing timeout of locked
		entries. See global1_atu.c and switchdev.c.
		Use struct mv88e6xxx_port for locked entries
		variables instead of struct dsa_port.

Hans Schultz (6):
  net: bridge: add locked entry fdb flag to extend locked port feature
  net: switchdev: add support for offloading of fdb locked flag
  drivers: net: dsa: add locked fdb entry flag to drivers
  net: dsa: mv88e6xxx: allow reading FID when handling ATU violations
  net: dsa: mv88e6xxx: mac-auth/MAB implementation
  selftests: forwarding: add test of MAC-Auth Bypass to locked port
    tests

 drivers/net/dsa/b53/b53_common.c              |   5 +
 drivers/net/dsa/b53/b53_priv.h                |   1 +
 drivers/net/dsa/hirschmann/hellcreek.c        |   5 +
 drivers/net/dsa/lan9303-core.c                |   5 +
 drivers/net/dsa/lantiq_gswip.c                |   5 +
 drivers/net/dsa/microchip/ksz9477.c           |   5 +
 drivers/net/dsa/mt7530.c                      |   5 +
 drivers/net/dsa/mv88e6xxx/Makefile            |   1 +
 drivers/net/dsa/mv88e6xxx/chip.c              |  54 +++-
 drivers/net/dsa/mv88e6xxx/chip.h              |  15 +
 drivers/net/dsa/mv88e6xxx/global1.h           |   1 +
 drivers/net/dsa/mv88e6xxx/global1_atu.c       |  32 +-
 drivers/net/dsa/mv88e6xxx/port.c              |  30 +-
 drivers/net/dsa/mv88e6xxx/port.h              |   2 +
 drivers/net/dsa/mv88e6xxx/switchdev.c         | 280 ++++++++++++++++++
 drivers/net/dsa/mv88e6xxx/switchdev.h         |  37 +++
 drivers/net/dsa/ocelot/felix.c                |   5 +
 drivers/net/dsa/qca8k.c                       |   5 +
 drivers/net/dsa/sja1105/sja1105_main.c        |   5 +
 include/net/dsa.h                             |   7 +
 include/net/switchdev.h                       |   1 +
 include/uapi/linux/neighbour.h                |   1 +
 net/bridge/br.c                               |   3 +-
 net/bridge/br_fdb.c                           |  19 +-
 net/bridge/br_input.c                         |  10 +-
 net/bridge/br_private.h                       |   5 +-
 net/bridge/br_switchdev.c                     |   1 +
 net/dsa/dsa_priv.h                            |   4 +-
 net/dsa/port.c                                |   7 +-
 net/dsa/slave.c                               |   4 +-
 net/dsa/switch.c                              |  10 +-
 .../net/forwarding/bridge_locked_port.sh      |  30 +-
 32 files changed, 566 insertions(+), 34 deletions(-)
 create mode 100644 drivers/net/dsa/mv88e6xxx/switchdev.c
 create mode 100644 drivers/net/dsa/mv88e6xxx/switchdev.h

-- 
2.30.2

