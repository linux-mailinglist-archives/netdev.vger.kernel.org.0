Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E3352A0F1D
	for <lists+netdev@lfdr.de>; Fri, 30 Oct 2020 21:07:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727379AbgJ3UHI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Oct 2020 16:07:08 -0400
Received: from fllv0015.ext.ti.com ([198.47.19.141]:33138 "EHLO
        fllv0015.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725975AbgJ3UHI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Oct 2020 16:07:08 -0400
Received: from lelv0266.itg.ti.com ([10.180.67.225])
        by fllv0015.ext.ti.com (8.15.2/8.15.2) with ESMTP id 09UK71rY108040;
        Fri, 30 Oct 2020 15:07:01 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1604088421;
        bh=rIc2Rlbdsgh8YepaFO9M3sefdA21E5gYn0Lu0N3mkqA=;
        h=From:To:CC:Subject:Date;
        b=J9zns5qNqPKUIoZlBpxlD65oINfytI+Li2MVOS6oHa4Wiof5gmcd1mPONzWH/rm86
         NA3+zqZKIuuVpEriPIx70dKOmzdrcfNjY0B6hIh2B1sujyKNaqo7hh4hCc37dlCSXr
         QV2KZJkls/GTzncDBfZmBBTFtyWL4/tOROTmBpOo=
Received: from DLEE111.ent.ti.com (dlee111.ent.ti.com [157.170.170.22])
        by lelv0266.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 09UK71Md035328
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 30 Oct 2020 15:07:01 -0500
Received: from DLEE106.ent.ti.com (157.170.170.36) by DLEE111.ent.ti.com
 (157.170.170.22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3; Fri, 30
 Oct 2020 15:07:01 -0500
Received: from lelv0326.itg.ti.com (10.180.67.84) by DLEE106.ent.ti.com
 (157.170.170.36) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3 via
 Frontend Transport; Fri, 30 Oct 2020 15:07:01 -0500
Received: from localhost (ileax41-snat.itg.ti.com [10.172.224.153])
        by lelv0326.itg.ti.com (8.15.2/8.15.2) with ESMTP id 09UK70sH100346;
        Fri, 30 Oct 2020 15:07:01 -0500
From:   Grygorii Strashko <grygorii.strashko@ti.com>
To:     "David S. Miller" <davem@davemloft.net>, <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Vignesh Raghavendra <vigneshr@ti.com>
CC:     Sekhar Nori <nsekhar@ti.com>, <linux-kernel@vger.kernel.org>,
        <linux-omap@vger.kernel.org>,
        "Reviewed-by : Jesse Brandeburg" <jesse.brandeburg@intel.com>,
        Grygorii Strashko <grygorii.strashko@ti.com>
Subject: [PATCH net-next v3 00/10] net: ethernet: ti: am65-cpsw: add multi port support in mac-only mode
Date:   Fri, 30 Oct 2020 22:06:57 +0200
Message-ID: <20201030200707.24294-1-grygorii.strashko@ti.com>
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
Patch 10: handle deferred probe with new dev_err_probe() API

changes in v3:
 - rebased
 - added Reviewed-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
 - added Patch 10 which is minor optimization

changes in v2:
- patch 8: xmit path split for one-port and multi-port devices to avoid
  performance losses 
- patch 9: fixed the case when Port 1 is disabled
- Patch 7: added fix for TX csum offload 

v2: https://lore.kernel.org/patchwork/cover/1321608/
v1: https://lore.kernel.org/patchwork/cover/1315766/

Grygorii Strashko (10):
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
  net: ethernet: ti: am65-cpsw: handle deferred probe with
    dev_err_probe()

 drivers/net/ethernet/ti/am65-cpsw-nuss.c | 355 ++++++++++++++---------
 drivers/net/ethernet/ti/am65-cpsw-nuss.h |   5 +
 drivers/net/ethernet/ti/cpsw_ale.c       |  41 ++-
 drivers/net/ethernet/ti/cpsw_ale.h       |   1 +
 drivers/net/ethernet/ti/cpsw_switchdev.c |   2 +-
 5 files changed, 261 insertions(+), 143 deletions(-)

-- 
2.17.1

