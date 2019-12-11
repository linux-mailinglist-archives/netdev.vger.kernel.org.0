Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7176411A84C
	for <lists+netdev@lfdr.de>; Wed, 11 Dec 2019 10:55:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728265AbfLKJzv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Dec 2019 04:55:51 -0500
Received: from guitar.tcltek.co.il ([192.115.133.116]:36144 "EHLO
        mx.tkos.co.il" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727493AbfLKJzv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 11 Dec 2019 04:55:51 -0500
X-Greylist: delayed 411 seconds by postgrey-1.27 at vger.kernel.org; Wed, 11 Dec 2019 04:55:51 EST
Received: from tarshish (unknown [10.0.8.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx.tkos.co.il (Postfix) with ESMTPS id C6D9F440044;
        Wed, 11 Dec 2019 11:48:57 +0200 (IST)
User-agent: mu4e 1.2.0; emacs 26.1
From:   Baruch Siach <baruch@tkos.co.il>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>
Cc:     netdev@vger.kernel.org,
        Denis Odintsov <d.odintsov@traviangames.com>
Subject: [BUG] mv88e6xxx: tx regression in v5.3
Date:   Wed, 11 Dec 2019 11:48:57 +0200
Message-ID: <87tv67tcom.fsf@tarshish>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Andrew, Vivien,

Since kernel v5.3 (tested v5.3.15), the 88E6141 switch on SolidRun
Clearfog GT-8K stopped transmitting packets on switch connected
ports. Kernel v5.2 works fine (tested v5.2.21).

Here are the relevant kernel v5.3 log lines:

[    2.867424] mv88e6085 f412a200.mdio-mii:04: switch 0x3400 detected: Marvell 88E6141, revision 0
[    2.927445] libphy: mdio: probed
[    3.578496] mv88e6085 f412a200.mdio-mii:04 lan2 (uninitialized): PHY [!cp1!config-space@f4000000!mdio@12a200!switch0@4!mdio:11] driver [Marvell 88E6390]
[    3.595674] mv88e6085 f412a200.mdio-mii:04 lan1 (uninitialized): PHY [!cp1!config-space@f4000000!mdio@12a200!switch0@4!mdio:12] driver [Marvell 88E6390]
[    3.612797] mv88e6085 f412a200.mdio-mii:04 lan4 (uninitialized): PHY [!cp1!config-space@f4000000!mdio@12a200!switch0@4!mdio:13] driver [Marvell 88E6390]
[    3.629910] mv88e6085 f412a200.mdio-mii:04 lan3 (uninitialized): PHY [!cp1!config-space@f4000000!mdio@12a200!switch0@4!mdio:14] driver [Marvell 88E6390]
[    3.646049] mv88e6085 f412a200.mdio-mii:04: configuring for phy/ link mode
[    3.654451] DSA: tree 0 setup
...
[   10.784521] mvpp2 f4000000.ethernet eth2: configuring for fixed/2500base-x link mode
[   10.792401] mvpp2 f4000000.ethernet eth2: Link is Up - 2.5Gbps/Full - flow control off
[   19.817981] mv88e6085 f412a200.mdio-mii:04 lan1: configuring for phy/ link mode
[   19.827083] 8021q: adding VLAN 0 to HW filter on device lan1
[   21.577276] mv88e6085 f412a200.mdio-mii:04 lan1: Link is Up - 100Mbps/Full - flow control rx/tx
[   21.586030] IPv6: ADDRCONF(NETDEV_CHANGE): lan1: link becomes ready

The Tx count on the lan1 interface increments, but the ARP packets don't
show on the network.

Do you have any idea?

Thanks,
baruch

--
     http://baruch.siach.name/blog/                  ~. .~   Tk Open Systems
=}------------------------------------------------ooO--U--Ooo------------{=
   - baruch@tkos.co.il - tel: +972.52.368.4656, http://www.tkos.co.il -
