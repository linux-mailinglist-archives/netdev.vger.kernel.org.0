Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD364441EEA
	for <lists+netdev@lfdr.de>; Mon,  1 Nov 2021 18:01:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231388AbhKARET (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Nov 2021 13:04:19 -0400
Received: from lelv0142.ext.ti.com ([198.47.23.249]:41480 "EHLO
        lelv0142.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229725AbhKARES (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Nov 2021 13:04:18 -0400
Received: from lelv0265.itg.ti.com ([10.180.67.224])
        by lelv0142.ext.ti.com (8.15.2/8.15.2) with ESMTP id 1A1H1ZJ5020781;
        Mon, 1 Nov 2021 12:01:35 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1635786095;
        bh=+BaagvGnP502Ks9mneotsbJCaIrZZZNppE+YaKPxILA=;
        h=From:To:CC:Subject:Date;
        b=RtbC9l3lgT4bH+oB/Eee33pVNVHbhQ6qCUqsVxHC2mfl8izoOFiQSScLSE1mITYhY
         hNUcyi2xovxLAQdThV2Bf34Qdtu20fdGK5T2o/V+zeswVQXFQzgJesgYbVjwtnovdD
         nvxHsQ5R6BxiHvjkN1QM5wEMScclqG6dmTrdBjWk=
Received: from DLEE102.ent.ti.com (dlee102.ent.ti.com [157.170.170.32])
        by lelv0265.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 1A1H1ZYl042749
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 1 Nov 2021 12:01:35 -0500
Received: from DLEE115.ent.ti.com (157.170.170.26) by DLEE102.ent.ti.com
 (157.170.170.32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2308.14; Mon, 1
 Nov 2021 12:01:35 -0500
Received: from lelv0327.itg.ti.com (10.180.67.183) by DLEE115.ent.ti.com
 (157.170.170.26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2308.14 via
 Frontend Transport; Mon, 1 Nov 2021 12:01:35 -0500
Received: from localhost (ileax41-snat.itg.ti.com [10.172.224.153])
        by lelv0327.itg.ti.com (8.15.2/8.15.2) with ESMTP id 1A1H1X4v052695;
        Mon, 1 Nov 2021 12:01:34 -0500
From:   Grygorii Strashko <grygorii.strashko@ti.com>
To:     "David S. Miller" <davem@davemloft.net>, <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>
CC:     <linux-kernel@vger.kernel.org>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        <linux-omap@vger.kernel.org>, Tony Lindgren <tony@atomide.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [PATCH net-next v2 0/3] net: ethernet: ti: cpsw: enable bc/mc storm prevention support
Date:   Mon, 1 Nov 2021 19:01:19 +0200
Message-ID: <20211101170122.19160-1-grygorii.strashko@ti.com>
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
packets rate limiting for TI CPSW switchdev and AM65x/J221E CPSW_NUSS drivers by
implementing HW offload for simple tc-flower with policer action with matches
on dst_mac:
 - ff:ff:ff:ff:ff:ff has to be used for BC packets rate limiting
 - 01:00:00:00:00:00 fixed value has to be used for MC packets rate limiting

Examples:
- BC rate limit to 1000pps:
  tc qdisc add dev eth0 clsact
  tc filter add dev eth0 ingress flower skip_sw dst_mac ff:ff:ff:ff:ff:ff \
  action police pkts_rate 1000 pkts_burst 1

- MC rate limit to 20000pps:
  tc qdisc add dev eth0 clsact
  tc filter add dev eth0 ingress flower skip_sw dst_mac 01:00:00:00:00:00 \
  action police pkts_rate 10000 pkts_burst 1

  pkts_burst - not used.

The solution inspired patch from Vladimir Oltean [1].

Changes in v2:
 - switch to packet-per-second policing introduced by
   commit 2ffe0395288a ("net/sched: act_police: add support for packet-per-second policing") [2]

v1: https://patchwork.kernel.org/project/netdevbpf/cover/20201114035654.32658-1-grygorii.strashko@ti.com/

[1] https://lore.kernel.org/patchwork/patch/1217254/
[2] https://patchwork.kernel.org/project/netdevbpf/cover/20210312140831.23346-1-simon.horman@netronome.com/

Grygorii Strashko (3):
  drivers: net: cpsw: ale: add broadcast/multicast rate limit support
  net: ethernet: ti: am65-cpsw: enable bc/mc storm prevention support
  net: ethernet: ti: cpsw_new: enable bc/mc storm prevention support

 drivers/net/ethernet/ti/am65-cpsw-qos.c | 145 ++++++++++++++++++++
 drivers/net/ethernet/ti/am65-cpsw-qos.h |   8 ++
 drivers/net/ethernet/ti/cpsw_ale.c      |  66 +++++++++
 drivers/net/ethernet/ti/cpsw_ale.h      |   2 +
 drivers/net/ethernet/ti/cpsw_new.c      |   4 +-
 drivers/net/ethernet/ti/cpsw_priv.c     | 170 ++++++++++++++++++++++++
 drivers/net/ethernet/ti/cpsw_priv.h     |   8 ++
 7 files changed, 402 insertions(+), 1 deletion(-)

-- 
2.17.1

