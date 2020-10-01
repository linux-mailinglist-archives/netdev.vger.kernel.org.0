Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B72B927FDBF
	for <lists+netdev@lfdr.de>; Thu,  1 Oct 2020 12:53:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731975AbgJAKxG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Oct 2020 06:53:06 -0400
Received: from fllv0016.ext.ti.com ([198.47.19.142]:33976 "EHLO
        fllv0016.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731131AbgJAKxF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Oct 2020 06:53:05 -0400
Received: from lelv0266.itg.ti.com ([10.180.67.225])
        by fllv0016.ext.ti.com (8.15.2/8.15.2) with ESMTP id 091Ar1WM097623;
        Thu, 1 Oct 2020 05:53:01 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1601549581;
        bh=siR2Dq0VwkakKM4NvZJ4Dd9LKdMWMVceMi7VtEmHcLI=;
        h=From:To:CC:Subject:Date;
        b=kOde88gdPCXuPtOyksZVL8RjA2BesqGAd4Jme61t0hEkkIINRRi+iskrUAFTrs0FC
         BWE31KyCLY5OYAZxiv75bcStKMhR54olDHP/+AlgrG2txCJVq8YV/atjEU9VcdNWs1
         OGXdUS2gvjWgfxf51mhbH9I16iDgenrH5VL1MlVk=
Received: from DFLE112.ent.ti.com (dfle112.ent.ti.com [10.64.6.33])
        by lelv0266.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 091Ar1AW129553
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 1 Oct 2020 05:53:01 -0500
Received: from DFLE115.ent.ti.com (10.64.6.36) by DFLE112.ent.ti.com
 (10.64.6.33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3; Thu, 1 Oct
 2020 05:53:01 -0500
Received: from lelv0327.itg.ti.com (10.180.67.183) by DFLE115.ent.ti.com
 (10.64.6.36) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3 via
 Frontend Transport; Thu, 1 Oct 2020 05:53:01 -0500
Received: from localhost (ileax41-snat.itg.ti.com [10.172.224.153])
        by lelv0327.itg.ti.com (8.15.2/8.15.2) with ESMTP id 091Ar0lK073206;
        Thu, 1 Oct 2020 05:53:01 -0500
From:   Grygorii Strashko <grygorii.strashko@ti.com>
To:     "David S. Miller" <davem@davemloft.net>, <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Vignesh Raghavendra <vigneshr@ti.com>
CC:     Sekhar Nori <nsekhar@ti.com>, <linux-kernel@vger.kernel.org>,
        <linux-omap@vger.kernel.org>,
        Murali Karicheri <m-karicheri2@ti.com>,
        Grygorii Strashko <grygorii.strashko@ti.com>
Subject: [PATCH net-next 0/8] net: ethernet: ti: am65-cpsw: add multi port support in mac-only mode
Date:   Thu, 1 Oct 2020 13:52:50 +0300
Message-ID: <20201001105258.2139-1-grygorii.strashko@ti.com>
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

Patches 1-3: Preparation patches to improve K3 CPSW configuration depending on DT
Patches 4-5: Fix VLAN offload for multi MAC mode
Patch 6: Fixes CPTS context lose issue during PM runtime transition
Patches 7-8: add multi-port support to TI AM65x CPSW

Grygorii Strashko (8):
  net: ethernet: ti: am65-cpsw: move ale selection in pdata
  net: ethernet: ti: am65-cpsw: move free desc queue mode selection in pdata
  net: ethernet: ti: am65-cpsw: use cppi5_desc_is_tdcm()
  net: ethernet: ti: cpsw_ale: add cpsw_ale_vlan_del_modify()
  net: ethernet: ti: am65-cpsw: fix vlan offload for multi mac mode
  net: ethernet: ti: am65-cpsw: keep active if cpts enabled
  net: ethernet: ti: am65-cpsw: prepare xmit/rx path for multi-port
    devices in mac-only mode
  net: ethernet: ti: am65-cpsw: add multi port support in mac-only mode

 drivers/net/ethernet/ti/am65-cpsw-nuss.c | 179 ++++++++++++++---------
 drivers/net/ethernet/ti/am65-cpsw-nuss.h |   4 +
 drivers/net/ethernet/ti/cpsw_ale.c       |  41 +++++-
 drivers/net/ethernet/ti/cpsw_ale.h       |   1 +
 drivers/net/ethernet/ti/cpsw_switchdev.c |   2 +-
 5 files changed, 153 insertions(+), 74 deletions(-)

-- 
2.17.1

