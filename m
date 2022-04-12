Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 269F54FDE75
	for <lists+netdev@lfdr.de>; Tue, 12 Apr 2022 13:54:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243337AbiDLLuT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Apr 2022 07:50:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353297AbiDLLsS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Apr 2022 07:48:18 -0400
Received: from lelv0142.ext.ti.com (lelv0142.ext.ti.com [198.47.23.249])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95CE26470;
        Tue, 12 Apr 2022 03:29:40 -0700 (PDT)
Received: from lelv0266.itg.ti.com ([10.180.67.225])
        by lelv0142.ext.ti.com (8.15.2/8.15.2) with ESMTP id 23CATU3R108146;
        Tue, 12 Apr 2022 05:29:30 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1649759370;
        bh=/7lqYkAwQmUFQdHVFYJTkp/5R0S+NP/aieRzswDefbM=;
        h=From:To:CC:Subject:Date;
        b=oxZBwHNp087am8E4KnOB1rBnHnNE+Gc+v9cqRqgyPP8s+K0eRQXm/EEH+u35HmLPM
         ZrQkj2jsEkukhdvo+cjV5grSZazlCpORXUvYceJc6semxzuz6kp14h+/Mst0Tb9Qw1
         gMAbjPEtzoxlP4SmJs+w1HmSaMAFyEz7c28OlmpM=
Received: from DFLE113.ent.ti.com (dfle113.ent.ti.com [10.64.6.34])
        by lelv0266.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 23CATU0x035399
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 12 Apr 2022 05:29:30 -0500
Received: from DFLE112.ent.ti.com (10.64.6.33) by DFLE113.ent.ti.com
 (10.64.6.34) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2308.14; Tue, 12
 Apr 2022 05:29:29 -0500
Received: from fllv0039.itg.ti.com (10.64.41.19) by DFLE112.ent.ti.com
 (10.64.6.33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2308.14 via
 Frontend Transport; Tue, 12 Apr 2022 05:29:29 -0500
Received: from localhost (ileax41-snat.itg.ti.com [10.172.224.153])
        by fllv0039.itg.ti.com (8.15.2/8.15.2) with ESMTP id 23CATSBB006765;
        Tue, 12 Apr 2022 05:29:29 -0500
From:   Grygorii Strashko <grygorii.strashko@ti.com>
To:     "David S. Miller" <davem@davemloft.net>, <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>
CC:     <linux-kernel@vger.kernel.org>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        <linux-omap@vger.kernel.org>, Tony Lindgren <tony@atomide.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Grygorii Strashko <grygorii.strashko@ti.com>
Subject: [PATCH net-next v3 0/3] net: ethernet: ti: enable bc/mc storm prevention support
Date:   Tue, 12 Apr 2022 13:29:26 +0300
Message-ID: <20220412102929.30719-1-grygorii.strashko@ti.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
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
on dst_mac/mask:
 - ff:ff:ff:ff:ff:ff/ff:ff:ff:ff:ff:ff has to be used for BC packets rate
limiting (exact match)
 - 01:00:00:00:00:00/01:00:00:00:00:00 fixed value has to be used for MC
packets rate limiting

The CPSW supports MC/BC packets rate limiting in packets/sec and affects
all ingress MC/BC packets and serves as BC/MC storm prevention feature.

Examples:
- BC rate limit to 1000pps:
  tc qdisc add dev eth0 clsact
  tc filter add dev eth0 ingress flower skip_sw dst_mac ff:ff:ff:ff:ff:ff \
  action police pkts_rate 1000 pkts_burst 1 drop

- MC rate limit to 20000pps:
  tc qdisc add dev eth0 clsact
  tc filter add dev eth0 ingress flower skip_sw dst_mac 01:00:00:00:00:00/01:00:00:00:00:00 \
  action police rate pkts_rate 20000 pkts_burst 1 drop

  pkts_burst - not used.

The solution inspired patch from Vladimir Oltean [1].

Changes in v3:
  - comments applied
  - policer validation added

Changes in v2:
 - switch to packet-per-second policing introduced by
   commit 2ffe0395288a ("net/sched: act_police: add support for packet-per-second policing") [2]

v2: https://patchwork.kernel.org/project/netdevbpf/cover/20211101170122.19160-1-grygorii.strashko@ti.com/
v1: https://patchwork.kernel.org/project/netdevbpf/cover/20201114035654.32658-1-grygorii.strashko@ti.com/

[1] https://lore.kernel.org/patchwork/patch/1217254/
[2] https://patchwork.kernel.org/project/netdevbpf/cover/20210312140831.23346-1-simon.horman@netronome.com/

Grygorii Strashko (3):
  drivers: net: cpsw: ale: add broadcast/multicast rate limit support
  net: ethernet: ti: am65-cpsw: enable bc/mc storm prevention support
  net: ethernet: ti: cpsw_new: enable bc/mc storm prevention support

 drivers/net/ethernet/ti/am65-cpsw-qos.c | 180 +++++++++++++++++++++
 drivers/net/ethernet/ti/am65-cpsw-qos.h |   8 +
 drivers/net/ethernet/ti/cpsw_ale.c      |  66 ++++++++
 drivers/net/ethernet/ti/cpsw_ale.h      |   2 +
 drivers/net/ethernet/ti/cpsw_new.c      |   4 +-
 drivers/net/ethernet/ti/cpsw_priv.c     | 205 ++++++++++++++++++++++++
 drivers/net/ethernet/ti/cpsw_priv.h     |   8 +
 7 files changed, 472 insertions(+), 1 deletion(-)

-- 
2.17.1

