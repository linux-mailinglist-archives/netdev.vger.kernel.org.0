Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 72446360E0B
	for <lists+netdev@lfdr.de>; Thu, 15 Apr 2021 17:10:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234887AbhDOPIs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Apr 2021 11:08:48 -0400
Received: from fllv0015.ext.ti.com ([198.47.19.141]:39960 "EHLO
        fllv0015.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234191AbhDOPHJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Apr 2021 11:07:09 -0400
Received: from lelv0265.itg.ti.com ([10.180.67.224])
        by fllv0015.ext.ti.com (8.15.2/8.15.2) with ESMTP id 13FF6YCX105243;
        Thu, 15 Apr 2021 10:06:34 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1618499194;
        bh=TddhIByRHAUrc3d1UoVU5WLxRPZpc3YiP4ZJ9S8Yb/Y=;
        h=From:To:CC:Subject:Date;
        b=kJ1VUrHtST2QiXzK076lqZsCv7stGm2GSfvtrtZjeD+LoExJW5mKQh6JOitfn99KY
         NyZNVNMYCvSGWNBXYXpj5W7B/sSLSOrVmGXYVNsRIxBr2GfT/YA/3fZohK6fWq6CxQ
         ImTJSLvAXwl2tavaj/D64ZDQtiLRKK19xAx56E1I=
Received: from DFLE112.ent.ti.com (dfle112.ent.ti.com [10.64.6.33])
        by lelv0265.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 13FF6YeI018218
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 15 Apr 2021 10:06:34 -0500
Received: from DFLE104.ent.ti.com (10.64.6.25) by DFLE112.ent.ti.com
 (10.64.6.33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2176.2; Thu, 15
 Apr 2021 10:06:34 -0500
Received: from fllv0039.itg.ti.com (10.64.41.19) by DFLE104.ent.ti.com
 (10.64.6.25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2176.2 via
 Frontend Transport; Thu, 15 Apr 2021 10:06:34 -0500
Received: from gsaswath-HP-ProBook-640-G5.dal.design.ti.com (ileax41-snat.itg.ti.com [10.172.224.153])
        by fllv0039.itg.ti.com (8.15.2/8.15.2) with ESMTP id 13FF6TGH129989;
        Thu, 15 Apr 2021 10:06:30 -0500
From:   Aswath Govindraju <a-govindraju@ti.com>
CC:     <linux-kernel@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-can@vger.kernel.org>, <netdev@vger.kernel.org>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Rob Herring <robh+dt@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Chandrasekar Ramakrishnan <rcsekar@samsung.com>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Lokesh Vutla <lokeshvutla@ti.com>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Aswath Govindraju <a-govindraju@ti.com>
Subject: [PATCH 0/2] MCAN: Add support for implementing transceiver as a phy
Date:   Thu, 15 Apr 2021 20:36:27 +0530
Message-ID: <20210415150629.5417-1-a-govindraju@ti.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The following series of patches add support for implementing the
transceiver as a phy of m_can_platform driver.

TCAN1042 has a standby signal that needs to be pulled high for
sending/receiving messages[1]. TCAN1043 has a enable signal along with
standby signal that needs to be pulled up for sending/receiving
messages[2], and other combinations of the two lines can be used to put the
transceiver in different states to reduce power consumption. On boards
like the AM654-idk and J721e-evm these signals are controlled using gpios.

These gpios are set in phy driver, and the transceiver can be put in
different states using phy API. The phy driver is added in the series [3].

[1] - https://www.ti.com/lit/ds/symlink/tcan1042h.pdf
[2] - https://www.ti.com/lit/ds/symlink/tcan1043-q1.pdf
[3] - https://lore.kernel.org/patchwork/project/lkml/list/?series=495365

Faiz Abbas (2):
  dt-bindings: net: can: Document transceiver implementation as phy
  can: m_can: Add support for transceiver as phy

 .../devicetree/bindings/net/can/bosch,m_can.yaml    |  3 +++
 drivers/net/can/m_can/m_can.c                       | 10 ++++++++++
 drivers/net/can/m_can/m_can.h                       |  2 ++
 drivers/net/can/m_can/m_can_platform.c              | 13 +++++++++++++
 4 files changed, 28 insertions(+)

-- 
2.17.1

