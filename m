Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AC16EDA2C
	for <lists+netdev@lfdr.de>; Mon, 29 Apr 2019 02:20:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726891AbfD2ASE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 28 Apr 2019 20:18:04 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:53379 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726223AbfD2ASE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 28 Apr 2019 20:18:04 -0400
Received: by mail-wm1-f67.google.com with SMTP id 26so11574950wmj.3;
        Sun, 28 Apr 2019 17:18:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=2T7noN4367tfx6VYmz3FpjmukFhrGIKbCovTkZB0ID4=;
        b=eugu2JGCRPnKoFSBtbEeEIgJQ2icGGZiuFiw50Fk03JveH2Dicp3Pg0R2rTbqVGmIM
         z9wwOAGcESX8joF3SditxnwwnBOuOEkPSU3kMGGXkouKKsTTposaRXIpESrLUJy/jBB8
         QaCuQYcTQMS3CpeQT/g8x2MWHDd/qReQ5VBPhwXmpw87zv03YFjF6BiaJZG20vbiS/y5
         9xmcoRi22yjWXY3QHjdarfc7Mk920qGIWOH5VRR67zU6RyZHp9mu4ZsATqOTf5JFLq5S
         qPlhyxkUXWMMWnrMfrZMy9Tia0wA7auxcPeaeWODIC6/k5upBOxb6Xk1NbYiz+E7ebk8
         gp5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=2T7noN4367tfx6VYmz3FpjmukFhrGIKbCovTkZB0ID4=;
        b=c7v+quDIQNOsT0tAGaP2+ww2i28S1CJ45lakjoc+8ErNc4aGTWhE2teeHdB2YMXFA9
         2I22rNrGlZ4K9t6szMDq/UvVFxBw/5pf+UouVkqLV9u9UxD55vbvO/1azzbeLp8R2vRT
         I/tRLsOUJTi5GuhUq7GkLwyVtQV06h3wh0XEHG4DqkyGgq5HL8yVumQwZbKpLkQKp9sb
         EaVBVoIQsgpgnGsSQV5vVKsbGBxcJFhJdRB02kshwYo7iKYxHcXOWe+dM2/9deeG5RgZ
         aE6V0i6IOfe5JudXU3Bsq5YwXP0zLqGgO5xLAYlWmqEifkyxHebHQiKLe4ZyXHHPV63R
         wvdg==
X-Gm-Message-State: APjAAAXQH4RlBqI4MBzD+CpMMnBTsMhDPSM+eXZXJhYumGdierbNpnsi
        8/KWmk29hzlZK7WmAvPm/DI5rhhG9Y4=
X-Google-Smtp-Source: APXvYqy4tsuedG1pgCpOnOhdzRAidYzNvvPgTX815ee4dKisRdew4lNi7PEGv/g5oL16qwThZdbT2g==
X-Received: by 2002:a1c:4c1a:: with SMTP id z26mr15794026wmf.73.1556497081854;
        Sun, 28 Apr 2019 17:18:01 -0700 (PDT)
Received: from localhost.localdomain (5-12-225-227.residential.rdsnet.ro. [5.12.225.227])
        by smtp.gmail.com with ESMTPSA id h16sm5098030wrb.31.2019.04.28.17.18.00
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 28 Apr 2019 17:18:01 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     f.fainelli@gmail.com, vivien.didelot@gmail.com, andrew@lunn.ch,
        davem@davemloft.net
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Vladimir Oltean <olteanv@gmail.com>
Subject: [PATCH v4 net-next 00/12] NXP SJA1105 DSA driver
Date:   Mon, 29 Apr 2019 03:16:54 +0300
Message-Id: <20190429001706.7449-1-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patchset adds a DSA driver for the SPI-controlled NXP SJA1105
switch.  Due to the hardware's unfriendliness, most of its state needs
to be shadowed in kernel memory by the driver. To support this and keep
a decent amount of cleanliness in the code, a new generic API for
converting between CPU-accessible ("unpacked") structures and
hardware-accessible ("packed") structures is proposed and used.

The driver is GPL-2.0 licensed. The source code files which are licensed
as BSD-3-Clause are hardware support files and derivative of the
userspace NXP sja1105-tool program, which is BSD-3-Clause licensed.

TODO items:
* Add support for traffic.
* Add full support for the P/Q/R/S series. The patches were mostly
  tested on a first-generation T device.
* Add timestamping support and PTP clock manipulation.
* Figure out how the tc-taprio hardware offload that was just proposed
  by Vinicius can be used to configure the switch's time-aware scheduler.
* Rework link state callbacks to use phylink once the SGMII port
  is supported.

Changes in v4:
1. Previous patchset was broken apart, and for the moment the driver is
   configuring the switch as unmanaged. Support for regular and management
   traffic, as well as for PTP timestamping, will be submitted once the
   basic driver is accepted. Some core DSA patches were also broken out
   of the series, and are a dependency for this series:
   https://patchwork.ozlabs.org/project/netdev/list/?series=105069
2. Addressed Jiri Pirko's feedback about too generic function and macro
   naming.
3. Re-introduced ETH_P_DSA_8021Q.

v3 patchset can be found at:
https://lkml.org/lkml/2019/4/12/978

Changes in v3:
1. Removed the patch for a dedicated Ethertype to use with 802.1Q DSA
   tagging
2. Changed the SJA1105 switch tagging protocol sysfs label from
   "sja1105" to "8021q" to denote to users such as tcpdump that the
   structure is more generic.
3. Respun previous patch "net: dsa: Allow drivers to modulate between
   presence and absence of tagging". Current equivalent patch is called
   "net: dsa: Allow drivers to filter packets they can decode source
   port from" and at least allows reception of management traffic during
   the time when switch tagging is not enabled.
4. Added DSA-level fixes for the bridge core not unsetting
   vlan_filtering when ports leave. The global VLAN filtering is treated
   as a special case. Made the mt7530 driver use this. This patch
   benefits the SJA1105 because otherwise traffic in standalone mode
   would no longer work after removing the ports from a vlan_filtering
   bridge, since the driver and the hardware would be in an inconsistent
   state.
5. Restructured the documentation as rst. This depends upon the recently
   submitted "[PATCH net-next] Documentation: net: dsa: transition to
   the rst format": https://patchwork.ozlabs.org/patch/1084658/.

v2 patchset can be found at:
https://www.spinics.net/lists/netdev/msg563454.html

Changes in v2:
1. Device ID is no longer auto-detected but enforced based on explicit DT
   compatible string. This helps with stricter checking of DT bindings.
2. Group all device-specific operations into a sja1105_info structure and
   avoid using the IS_ET() and IS_PQRS() macros at runtime as much as possible.
3. Added more verbiage to commit messages and documentation.
4. Treat the case where RGMII internal delays are requested through DT bindings
   and return error.
5. Miscellaneous cosmetic cleanup in sja1105_clocking.c
6. Not advertising link features that are not supported, such as pause frames
   and the half duplex modes.
7. Fixed a mistake in previous patchset where the switch tagging was not
   actually enabled (lost during a rebase). This brought up another uncaught
   issue where switching at runtime between tagging and no-tagging was not
   supported by DSA. Fixed up the mistake in "net: dsa: sja1105: Add support
   for traffic through standalone ports", and added the new patch "net: dsa:
   Allow drivers to modulate between presence and absence of tagging" to
   address the other issue.
8. Added a workaround for switch resets cutting a frame in the middle of
   transmission, which would throw off some link partners.
9. Changed the TPID from ETH_P_EDSA (0xDADA) to a newly introduced one:
   ETH_P_DSA_8021Q (0xDADB). Uncovered another mistake in the previous patchset
   with a missing ntohs(), which was not caught because 0xDADA is
   endian-agnostic.
10. Made NET_DSA_TAG_8021Q select VLAN_8021Q
11. Renamed __dsa_port_vlan_add to dsa_port_vid_add and not to
    dsa_port_vlan_add_trans, as suggested, because the corresponding _del function
    does not have a transactional phase and the naming is more uniform this way.

v1 patchset can be found at:
https://www.spinics.net/lists/netdev/msg561589.html

Changes from RFC:
1. Removed the packing code for the static configuration tables that were
   not currently used
2. Removed the code for unpacking a static configuration structure from
   a memory buffer (not used)
3. Completely removed the SGMII stubs, since the configuration is not
   complete anyway.
4. Moved some code from the SJA1105 introduction commit into the patch
   that used it.
5. Made the code for checking global VLAN filtering generic and made b53
   driver use it.
6. Made mt7530 driver use the new generic dp->vlan_filtering
7. Fixed check for stringset in .get_sset_count
8. Minor cleanup in sja1105_clocking.c
9. Fixed a confusing typo in DSA

RFC can be found at:
https://www.mail-archive.com/netdev@vger.kernel.org/msg291717.html

Vladimir Oltean (12):
  lib: Add support for generic packing operations
  net: dsa: Introduce driver for NXP SJA1105 5-port L2 switch
  net: dsa: sja1105: Add support for FDB and MDB management
  net: dsa: sja1105: Error out if RGMII delays are requested in DT
  ether: Add dedicated Ethertype for pseudo-802.1Q DSA tagging
  net: dsa: sja1105: Add support for VLAN operations
  net: dsa: sja1105: Add support for ethtool port counters
  net: dsa: sja1105: Add support for configuring address aging time
  net: dsa: sja1105: Prevent PHY jabbering during switch reset
  net: dsa: sja1105: Reject unsupported link modes for AN
  Documentation: net: dsa: Add details about NXP SJA1105 driver
  dt-bindings: net: dsa: Add documentation for NXP SJA1105 driver

 .../devicetree/bindings/net/dsa/sja1105.txt   |  157 ++
 Documentation/networking/dsa/index.rst        |    1 +
 Documentation/networking/dsa/sja1105.rst      |  167 ++
 Documentation/packing.txt                     |  150 ++
 MAINTAINERS                                   |   14 +
 drivers/net/dsa/Kconfig                       |    2 +
 drivers/net/dsa/Makefile                      |    1 +
 drivers/net/dsa/sja1105/Kconfig               |   15 +
 drivers/net/dsa/sja1105/Makefile              |   10 +
 drivers/net/dsa/sja1105/sja1105.h             |  154 ++
 drivers/net/dsa/sja1105/sja1105_clocking.c    |  602 +++++++
 .../net/dsa/sja1105/sja1105_dynamic_config.c  |  533 ++++++
 .../net/dsa/sja1105/sja1105_dynamic_config.h  |   43 +
 drivers/net/dsa/sja1105/sja1105_ethtool.c     |  418 +++++
 drivers/net/dsa/sja1105/sja1105_main.c        | 1459 +++++++++++++++++
 drivers/net/dsa/sja1105/sja1105_spi.c         |  591 +++++++
 .../net/dsa/sja1105/sja1105_static_config.c   |  988 +++++++++++
 .../net/dsa/sja1105/sja1105_static_config.h   |  254 +++
 include/linux/dsa/sja1105.h                   |   23 +
 include/linux/packing.h                       |   49 +
 include/uapi/linux/if_ether.h                 |    1 +
 lib/Makefile                                  |    2 +-
 lib/packing.c                                 |  211 +++
 23 files changed, 5844 insertions(+), 1 deletion(-)
 create mode 100644 Documentation/devicetree/bindings/net/dsa/sja1105.txt
 create mode 100644 Documentation/networking/dsa/sja1105.rst
 create mode 100644 Documentation/packing.txt
 create mode 100644 drivers/net/dsa/sja1105/Kconfig
 create mode 100644 drivers/net/dsa/sja1105/Makefile
 create mode 100644 drivers/net/dsa/sja1105/sja1105.h
 create mode 100644 drivers/net/dsa/sja1105/sja1105_clocking.c
 create mode 100644 drivers/net/dsa/sja1105/sja1105_dynamic_config.c
 create mode 100644 drivers/net/dsa/sja1105/sja1105_dynamic_config.h
 create mode 100644 drivers/net/dsa/sja1105/sja1105_ethtool.c
 create mode 100644 drivers/net/dsa/sja1105/sja1105_main.c
 create mode 100644 drivers/net/dsa/sja1105/sja1105_spi.c
 create mode 100644 drivers/net/dsa/sja1105/sja1105_static_config.c
 create mode 100644 drivers/net/dsa/sja1105/sja1105_static_config.h
 create mode 100644 include/linux/dsa/sja1105.h
 create mode 100644 include/linux/packing.h
 create mode 100644 lib/packing.c

-- 
2.17.1

