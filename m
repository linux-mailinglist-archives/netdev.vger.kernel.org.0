Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 33D6028FB98
	for <lists+netdev@lfdr.de>; Fri, 16 Oct 2020 01:19:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387861AbgJOXT2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Oct 2020 19:19:28 -0400
Received: from fllv0016.ext.ti.com ([198.47.19.142]:44676 "EHLO
        fllv0016.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387694AbgJOXT2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Oct 2020 19:19:28 -0400
Received: from lelv0266.itg.ti.com ([10.180.67.225])
        by fllv0016.ext.ti.com (8.15.2/8.15.2) with ESMTP id 09FNJO8U079860;
        Thu, 15 Oct 2020 18:19:24 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1602803964;
        bh=oO+JEQwbOCBhrKYSnbru4rgOHlGjLU4dzzwQRA3ruGg=;
        h=From:To:CC:Subject:Date;
        b=h51Hq+vU0lU6Ew7LRLTi8/cWGS70yPiSQwL8A+WWgzbm3CTu2gFINJYQn/vRdbJ1K
         +3/HrnQDowa9RfWP5M4kD8tGADq29vXQ2YqC8W5fu4VNjAcukLejnED67rC5XNU57J
         7lYuvuO7DfB3tRj0uiptR8kkNXmmCO+n2hqq5ujk=
Received: from DLEE111.ent.ti.com (dlee111.ent.ti.com [157.170.170.22])
        by lelv0266.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 09FNJO8j114447
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 15 Oct 2020 18:19:24 -0500
Received: from DLEE104.ent.ti.com (157.170.170.34) by DLEE111.ent.ti.com
 (157.170.170.22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3; Thu, 15
 Oct 2020 18:19:23 -0500
Received: from lelv0326.itg.ti.com (10.180.67.84) by DLEE104.ent.ti.com
 (157.170.170.34) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3 via
 Frontend Transport; Thu, 15 Oct 2020 18:19:23 -0500
Received: from localhost (ileax41-snat.itg.ti.com [10.172.224.153])
        by lelv0326.itg.ti.com (8.15.2/8.15.2) with ESMTP id 09FNJMhw093075;
        Thu, 15 Oct 2020 18:19:23 -0500
From:   Grygorii Strashko <grygorii.strashko@ti.com>
To:     "David S. Miller" <davem@davemloft.net>, <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Vignesh Raghavendra <vigneshr@ti.com>
CC:     Sekhar Nori <nsekhar@ti.com>, <linux-kernel@vger.kernel.org>,
        <linux-omap@vger.kernel.org>,
        Murali Karicheri <m-karicheri2@ti.com>,
        Grygorii Strashko <grygorii.strashko@ti.com>
Subject: [PATCH net-next v2 0/9] net: ethernet: ti: am65-cpsw: add multi port support in mac-only mode
Date:   Fri, 16 Oct 2020 02:19:04 +0300
Message-ID: <20201015231913.30280-1-grygorii.strashko@ti.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi

This series adds multi-port support in mac-only mode (multi MAC mode) to TI
AM65x CPSW driver in preparation for enabling support for multi-port devices,
like Main CPSW0 on K3 J721E SoC or future CPSW3g on K3 AM64x SoC.

The multi MAC mode is implemented by configuring every enabled port in "mac-only"
mode (all ingress packets are sent only to the Host port and egress packets
directed to target Ext. Port) and creating separate net_device for
every enabled Ext. port.

This series does not affect on existing CPSW2g one Ext. Port devices and xmit
path changes are done only for multi-port devices by splitting xmit path for
one-port and multi-port devices. 

Patches 1-3: Preparation patches to improve K3 CPSW configuration depending on DT
Patches 4-5: Fix VLAN offload for multi MAC mode
Patch 6: Fixes CPTS context lose issue during PM runtime transition
Patch 7: Fixes TX csum offload for multi MAC mode
Patches 8-9: add multi-port support to TI AM65x CPSW

changes in v2:
- patch 8: xmit path split for one-port and multi-port devices to avoid
  performance losses 
- patch 9: fixed the case when Port 1 is disabled
- Patch 7: added fix for TX csum offload 

v1: https://lore.kernel.org/patchwork/cover/1315766/

Grygorii Strashko (9):
  net: ethernet: ti: am65-cpsw: move ale selection in pdata
  net: ethernet: ti: am65-cpsw: move free desc queue mode selection in
    pdata
  net: ethernet: ti: am65-cpsw: use cppi5_desc_is_tdcm()
  net: ethernet: ti: cpsw_ale: add cpsw_ale_vlan_del_modify()
  net: ethernet: ti: am65-cpsw: fix vlan offload for multi mac mode
  net: ethernet: ti: am65-cpsw: keep active if cpts enabled
  net: ethernet: ti: am65-cpsw: fix tx csum offload for multi mac mode
  net: ethernet: ti: am65-cpsw: prepare xmit/rx path for multi-port
    devices in mac-only mode
  net: ethernet: ti: am65-cpsw: add multi port support in mac-only mode

 drivers/net/ethernet/ti/am65-cpsw-nuss.c | 327 +++++++++++++++--------
 drivers/net/ethernet/ti/am65-cpsw-nuss.h |   5 +
 drivers/net/ethernet/ti/cpsw_ale.c       |  41 ++-
 drivers/net/ethernet/ti/cpsw_ale.h       |   1 +
 drivers/net/ethernet/ti/cpsw_switchdev.c |   2 +-
 5 files changed, 251 insertions(+), 125 deletions(-)

-- 
2.17.1

