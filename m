Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CEA33360F44
	for <lists+netdev@lfdr.de>; Thu, 15 Apr 2021 17:46:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233772AbhDOPrQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Apr 2021 11:47:16 -0400
Received: from fllv0016.ext.ti.com ([198.47.19.142]:34742 "EHLO
        fllv0016.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233094AbhDOPrP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Apr 2021 11:47:15 -0400
Received: from lelv0266.itg.ti.com ([10.180.67.225])
        by fllv0016.ext.ti.com (8.15.2/8.15.2) with ESMTP id 13FFkf6H028131;
        Thu, 15 Apr 2021 10:46:41 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1618501601;
        bh=UYS0mmXwXHvdy44MSdxL2VsFFDNIsAIevhRgyfcwE28=;
        h=From:To:CC:Subject:Date;
        b=NBpPA97qt18VfRpo250ryA95pGVl3G03wxlb1a0CVu1GFZ2fkkW9XyRVuuaYNaqut
         YJq6nI9yH7zwr4us0+ausfz0PH49GJ9c4USl7RnsNVesq1ikLRkzv+mL+p/Zg4rLsD
         QbbhHu5QBlM+LqbQO0Z8mYyX70tke99id5zWIEg0=
Received: from DFLE114.ent.ti.com (dfle114.ent.ti.com [10.64.6.35])
        by lelv0266.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 13FFkf75059424
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 15 Apr 2021 10:46:41 -0500
Received: from DFLE108.ent.ti.com (10.64.6.29) by DFLE114.ent.ti.com
 (10.64.6.35) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2176.2; Thu, 15
 Apr 2021 10:46:40 -0500
Received: from lelv0327.itg.ti.com (10.180.67.183) by DFLE108.ent.ti.com
 (10.64.6.29) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2176.2 via
 Frontend Transport; Thu, 15 Apr 2021 10:46:40 -0500
Received: from gsaswath-HP-ProBook-640-G5.dal.design.ti.com (ileax41-snat.itg.ti.com [10.172.224.153])
        by lelv0327.itg.ti.com (8.15.2/8.15.2) with ESMTP id 13FFkZh9028376;
        Thu, 15 Apr 2021 10:46:36 -0500
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
        Faiz Abbas <faiz_abbas@ti.com>,
        Aswath Govindraju <a-govindraju@ti.com>
Subject: [PATCH v2 0/2] MCAN: Add support for implementing transceiver as a phy
Date:   Thu, 15 Apr 2021 21:16:33 +0530
Message-ID: <20210415154635.30094-1-a-govindraju@ti.com>
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

This patch series is dependent on [4].

Changes since v1:
- Used the API devm_phy_get_optional() instead of 
  devm_of_phy_get_optional_by_index()

[1] - https://www.ti.com/lit/ds/symlink/tcan1042h.pdf
[2] - https://www.ti.com/lit/ds/symlink/tcan1043-q1.pdf
[3] - https://lore.kernel.org/patchwork/project/lkml/list/?series=495365
[4] - https://lore.kernel.org/patchwork/patch/1413286/

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

