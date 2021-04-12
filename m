Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8027B35C7BC
	for <lists+netdev@lfdr.de>; Mon, 12 Apr 2021 15:34:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241739AbhDLNeh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Apr 2021 09:34:37 -0400
Received: from uho.ysoft.cz ([81.19.3.130]:19283 "EHLO uho.ysoft.cz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237558AbhDLNeg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 12 Apr 2021 09:34:36 -0400
X-Greylist: delayed 351 seconds by postgrey-1.27 at vger.kernel.org; Mon, 12 Apr 2021 09:34:36 EDT
Received: from [10.0.29.110] (unknown [10.0.29.110])
        by uho.ysoft.cz (Postfix) with ESMTP id 44B4FA0356;
        Mon, 12 Apr 2021 15:28:26 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ysoft.com;
        s=20160406-ysoft-com; t=1618234106;
        bh=tNFYVCOzsw3e0L6/HjFz+j7iKuvqDyVJK7oGso10V2o=;
        h=From:Subject:To:Cc:Date:From;
        b=LeVUR3miOgby8+mcvlKOSz9hTCecO4sd5i3eNsHy+MKE2IOOqShkpCR6H8TtSUoeQ
         VfP/em2yvbx+nmynzki8VsqYpfVw0DQWxQUTSy1v52YeP9h+gMNyClLTWk5l5hb7eX
         skxq0OmEmbEy2F+OGYyxGQ7B4xEFPkSEI2L91+jc=
From:   =?UTF-8?B?TWljaGFsIFZva8OhxI0=?= <michal.vokac@ysoft.com>
Subject: Broken imx6 to QCA8334 connection since PHYLIB to PHYLINK conversion
To:     Jonathan McDowell <noodles@earth.li>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        David Miller <davem@davemloft.net>, netdev@vger.kernel.org
Message-ID: <b7f5842a-c7b7-6439-ae68-51e1690d2507@ysoft.com>
Date:   Mon, 12 Apr 2021 15:28:26 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi folks,

I am working on kernel upgrade on our imx6dl-yapp4 platform and just realized
that since v5.9 networking is broken. Git bisect brought me to commit
b3591c2a3661 ("net: dsa: qca8k: Switch to PHYLINK instead of PHYLIB")

Kernel v5.8 NFS boot without the offending commit:

qca8k 2188000.ethernet-1:0a: Using legacy PHYLIB callbacks. Please migrate to PHYLINK!
qca8k 2188000.ethernet-1:0a: nonfatal error -95 setting MTU on port 2
qca8k 2188000.ethernet-1:0a eth2 (uninitialized): PHY [2188000.ethernet-1:01] driver [Generic PHY] (irq=POLL)
qca8k 2188000.ethernet-1:0a: nonfatal error -95 setting MTU on port 3
qca8k 2188000.ethernet-1:0a eth1 (uninitialized): PHY [2188000.ethernet-1:02] driver [Generic PHY] (irq=POLL)
eth0: mtu greater than device maximum
fec 2188000.ethernet eth0: error -22 setting MTU to include DSA overhead
DSA: tree 0 setup
Generic PHY fixed-0:00: attached PHY driver [Generic PHY] (mii_bus:phy_addr=fixed-0:00, irq=POLL)
fec 2188000.ethernet eth0: Link is Up - 1Gbps/Full - flow control off
qca8k 2188000.ethernet-1:0a eth2: configuring for phy/ link mode
qca8k 2188000.ethernet-1:0a eth2: Link is Up - 1Gbps/Full - flow control rx/tx
IPv6: ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
IPv6: ADDRCONF(NETDEV_CHANGE): eth2: link becomes ready
Sending DHCP requests ., OK

Kernel v5.9 and newer with that commit:

qca8k 2188000.ethernet-1:0a: configuring for fixed/rgmii-id link mode
qca8k 2188000.ethernet-1:0a eth2 (uninitialized): PHY [2188000.ethernet-1:01] driver [Generic PHY] (irq=POLL)
qca8k 2188000.ethernet-1:0a eth1 (uninitialized): PHY [2188000.ethernet-1:02] driver [Generic PHY] (irq=POLL)
DSA: tree 0 setup
qca8k 2188000.ethernet-1:0a: Link is Up - 1Gbps/Full - flow control off
fec 2188000.ethernet eth0: Unable to connect to phy
IP-Config: Failed to open eth0
IP-Config: Failed to open eth2
IP-Config: Device `eth2' not found

Manual attempt to bring the interface up:

# ifconfig eth0 up
fec 2188000.ethernet eth0: Unable to connect to phy
ifconfig: SIOCSIFFLAGS: No such device

I have no clue what could be wrong. Maybe this change revealed that our DT
configuration [1] is not correct? Or after this change the driver does not
handle the rgmii-id configuration properly? Or something else..

Any ideas how to further debug the problem?

Thank you in advance,
Michal

[1] https://elixir.bootlin.com/linux/v5.12-rc7/source/arch/arm/boot/dts/imx6dl-yapp4-common.dtsi#L101
