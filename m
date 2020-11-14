Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 181E92B2B2B
	for <lists+netdev@lfdr.de>; Sat, 14 Nov 2020 04:57:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726451AbgKND5J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Nov 2020 22:57:09 -0500
Received: from fllv0016.ext.ti.com ([198.47.19.142]:60856 "EHLO
        fllv0016.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725981AbgKND5J (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Nov 2020 22:57:09 -0500
Received: from lelv0266.itg.ti.com ([10.180.67.225])
        by fllv0016.ext.ti.com (8.15.2/8.15.2) with ESMTP id 0AE3v3lM082107;
        Fri, 13 Nov 2020 21:57:03 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1605326223;
        bh=RQnAC+ZkevKf4QoHaxeqePnrgbvyAt6LyHW3yRnles8=;
        h=From:To:CC:Subject:Date;
        b=vHkEPOMnzRCybhJ2Fj6htxpxzBYBsDIw7nsx8cG8rqPg8/Nj6GRjTVqNV6Q0eJdR/
         xQhoSt7abehypY0y/2+QJ3lauP+hNWH1faiK3Tj2omMLqBK05IP/eLYOa7mQ33YbOJ
         CV1MVYyjul5nB5IzCKloXMXXXYIVrZFP0OilGmEQ=
Received: from DLEE112.ent.ti.com (dlee112.ent.ti.com [157.170.170.23])
        by lelv0266.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 0AE3v2wv127189
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 13 Nov 2020 21:57:03 -0600
Received: from DLEE103.ent.ti.com (157.170.170.33) by DLEE112.ent.ti.com
 (157.170.170.23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3; Fri, 13
 Nov 2020 21:57:02 -0600
Received: from fllv0039.itg.ti.com (10.64.41.19) by DLEE103.ent.ti.com
 (157.170.170.33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3 via
 Frontend Transport; Fri, 13 Nov 2020 21:57:02 -0600
Received: from localhost (ileax41-snat.itg.ti.com [10.172.224.153])
        by fllv0039.itg.ti.com (8.15.2/8.15.2) with ESMTP id 0AE3v1ts005268;
        Fri, 13 Nov 2020 21:57:02 -0600
From:   Grygorii Strashko <grygorii.strashko@ti.com>
To:     "David S. Miller" <davem@davemloft.net>, <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Vignesh Raghavendra <vigneshr@ti.com>
CC:     Sekhar Nori <nsekhar@ti.com>, <linux-kernel@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, Tony Lindgren <tony@atomide.com>,
        Grygorii Strashko <grygorii.strashko@ti.com>
Subject: [PATCH net-next 0/3] net: ethernet: ti: cpsw: enable broadcast/multicast rate limit support
Date:   Sat, 14 Nov 2020 05:56:51 +0200
Message-ID: <20201114035654.32658-1-grygorii.strashko@ti.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi

This series first adds supports for the ALE feature to rate limit number ingress
broadcast(BC)/multicast(MC) packets per/sec which main purpose is BC/MC storm
prevention.

And then enables corresponding support for ingress broadcast(BC)/multicast(MC)
rate limiting for TI CPSW switchdev and AM65x/J221E CPSW_NUSS drivers by
implementing HW offload for simple tc-flower policer with matches on dst_mac:
 - ff:ff:ff:ff:ff:ff has to be used for BC rate limiting
 - 01:00:00:00:00:00 fixed value has to be used for MC rate limiting

Hence tc policer defines rate limit in terms of bits per second, but the
ALE supports limiting in terms of packets per second - the rate limit
bits/sec is converted to number of packets per second assuming minimum
Ethernet packet size ETH_ZLEN=60 bytes.

The solution inspired patch from Vladimir Oltean [1].

Examples:
- BC rate limit to 1000pps:
  tc qdisc add dev eth0 clsact
  tc filter add dev eth0 ingress flower skip_sw dst_mac ff:ff:ff:ff:ff:ff \
  action police rate 480kbit burst 64k

  rate 480kbit - 1000pps * 60 bytes * 8, burst - not used.

- MC rate limit to 20000pps:
  tc qdisc add dev eth0 clsact
  tc filter add dev eth0 ingress flower skip_sw dst_mac 01:00:00:00:00:00 \
  action police rate 9600kbit burst 64k

  rate 9600kbit - 20000pps * 60 bytes * 8, burst - not used.

- show: tc filter show dev eth0 ingress
filter protocol all pref 49151 flower chain 0
filter protocol all pref 49151 flower chain 0 handle 0x1
  dst_mac ff:ff:ff:ff:ff:ff
  skip_sw
  in_hw in_hw_count 1
        action order 1:  police 0x2 rate 480Kbit burst 64Kb mtu 2Kb action reclassify overhead 0b
        ref 1 bind 1

filter protocol all pref 49152 flower chain 0
filter protocol all pref 49152 flower chain 0 handle 0x1
  dst_mac 01:00:00:00:00:00
  skip_sw
  in_hw in_hw_count 1
        action order 1:  police 0x1 rate 9600Kbit burst 64Kb mtu 2Kb action reclassify overhead 0b
        ref 1 bind

Testing MC with iperf:
- client
  -- setup tc-flower as per above
  route add -host 239.255.1.3 eth0
  iperf -s -B 239.255.1.3 -u -f m &
  cat /sys/class/net/eth0/statistics/rx_packets

- server
  route add -host 239.255.1.3 eth0
  iperf -c 239.255.1.3 -u -f m -i 5 -t 30 -l1472  -b121760000 -t1 //~10000pps

[1] https://lore.kernel.org/patchwork/patch/1217254/

Grygorii Strashko (3):
  drivers: net: cpsw: ale: add broadcast/multicast rate limit support
  net: ethernet: ti: cpsw_new: enable broadcast/multicast rate limit
    support
  net: ethernet: ti: am65-cpsw: enable broadcast/multicast rate limit
    support

 drivers/net/ethernet/ti/am65-cpsw-qos.c | 148 ++++++++++++++++++++
 drivers/net/ethernet/ti/am65-cpsw-qos.h |   8 ++
 drivers/net/ethernet/ti/cpsw_ale.c      |  66 +++++++++
 drivers/net/ethernet/ti/cpsw_ale.h      |   2 +
 drivers/net/ethernet/ti/cpsw_new.c      |   4 +-
 drivers/net/ethernet/ti/cpsw_priv.c     | 171 ++++++++++++++++++++++++
 drivers/net/ethernet/ti/cpsw_priv.h     |   8 ++
 7 files changed, 406 insertions(+), 1 deletion(-)

-- 
2.17.1

