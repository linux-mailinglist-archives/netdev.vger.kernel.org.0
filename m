Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A014135A01D
	for <lists+netdev@lfdr.de>; Fri,  9 Apr 2021 15:41:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233700AbhDINln (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Apr 2021 09:41:43 -0400
Received: from fllv0015.ext.ti.com ([198.47.19.141]:58096 "EHLO
        fllv0015.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231402AbhDINlk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Apr 2021 09:41:40 -0400
Received: from lelv0266.itg.ti.com ([10.180.67.225])
        by fllv0015.ext.ti.com (8.15.2/8.15.2) with ESMTP id 139Df4ZH113099;
        Fri, 9 Apr 2021 08:41:04 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1617975664;
        bh=+hrfoKJ5dxbZo5OQLdyaXN4aZTv5QQgu1FvsD/VAlxs=;
        h=From:To:CC:Subject:Date;
        b=XU0/teXZMOTlXq58jED0E/yqtBw6uSrLZCuHTs85bfy2EmkecWtlzjziD4ScbPgx6
         RedcJSsXSH+LzdGuXfxDoHcfEg8+wnZ1SxoD7qm0Dch13kmRCyI+9bWVG/WYI8exK5
         LEFynr5PFjBoFcG5dhfxxrY9fEuzemgKrEt3862E=
Received: from DFLE109.ent.ti.com (dfle109.ent.ti.com [10.64.6.30])
        by lelv0266.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 139Df4Qw074014
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 9 Apr 2021 08:41:04 -0500
Received: from DFLE107.ent.ti.com (10.64.6.28) by DFLE109.ent.ti.com
 (10.64.6.30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2176.2; Fri, 9 Apr
 2021 08:41:04 -0500
Received: from lelv0326.itg.ti.com (10.180.67.84) by DFLE107.ent.ti.com
 (10.64.6.28) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2176.2 via
 Frontend Transport; Fri, 9 Apr 2021 08:41:04 -0500
Received: from gsaswath-HP-ProBook-640-G5.dal.design.ti.com (ileax41-snat.itg.ti.com [10.172.224.153])
        by lelv0326.itg.ti.com (8.15.2/8.15.2) with ESMTP id 139DewmZ029277;
        Fri, 9 Apr 2021 08:40:59 -0500
From:   Aswath Govindraju <a-govindraju@ti.com>
CC:     Vignesh Raghavendra <vigneshr@ti.com>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Lokesh Vutla <lokeshvutla@ti.com>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Aswath Govindraju <a-govindraju@ti.com>,
        Chandrasekar Ramakrishnan <rcsekar@samsung.com>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Vinod Koul <vkoul@kernel.org>,
        Sriram Dash <sriram.dash@samsung.com>,
        <linux-can@vger.kernel.org>, <netdev@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-phy@lists.infradead.org>
Subject: [PATCH 0/4] CAN TRANSCEIVER: Add support for CAN transceivers
Date:   Fri, 9 Apr 2021 19:10:50 +0530
Message-ID: <20210409134056.18740-1-a-govindraju@ti.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The following series of patches add support for CAN transceivers.

TCAN1042 has a standby signal that needs to be pulled high for
sending/receiving messages[1]. TCAN1043 has a enable signal along with
standby signal that needs to be pulled up for sending/receiving
messages[2], and other combinations of the two lines can be used to put the
transceiver in different states to reduce power consumption. On boards
like the AM654-idk and J721e-evm these signals are controlled using gpios.

Patch 1 models the transceiver as a phy device tree node with properties
for max bit rate supported, gpio properties for indicating gpio pin numbers
to which standby and enable signals are connected.

Patch 2 adds a generic driver to support CAN transceivers.

Patches 3 & 4 add support for implementing the transceiver as a phy of
m_can_platform driver.

Aswath Govindraju (2):
  dt-bindings: phy: Add binding for TI TCAN104x CAN transceivers
  phy: phy-can-transceiver: Add support for generic CAN transceiver
    driver

Faiz Abbas (2):
  dt-bindings: net: can: Document transceiver implementation as phy
  can: m_can_platform: Add support for transceiver as phy

 .../bindings/net/can/bosch,m_can.yaml         |   6 +
 .../bindings/phy/ti,tcan104x-can.yaml         |  56 +++++++
 drivers/net/can/m_can/m_can_platform.c        |  25 ++++
 drivers/phy/Kconfig                           |   9 ++
 drivers/phy/Makefile                          |   1 +
 drivers/phy/phy-can-transceiver.c             | 140 ++++++++++++++++++
 6 files changed, 237 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/phy/ti,tcan104x-can.yaml
 create mode 100644 drivers/phy/phy-can-transceiver.c

-- 
2.17.1

