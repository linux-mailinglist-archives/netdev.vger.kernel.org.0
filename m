Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED38F361EF8
	for <lists+netdev@lfdr.de>; Fri, 16 Apr 2021 13:43:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242940AbhDPLn3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Apr 2021 07:43:29 -0400
Received: from fllv0015.ext.ti.com ([198.47.19.141]:49018 "EHLO
        fllv0015.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239752AbhDPLn0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Apr 2021 07:43:26 -0400
Received: from lelv0266.itg.ti.com ([10.180.67.225])
        by fllv0015.ext.ti.com (8.15.2/8.15.2) with ESMTP id 13GBgobh110280;
        Fri, 16 Apr 2021 06:42:50 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1618573370;
        bh=ZVAgQtDnk7KKbKuoslQnNhFeEDKu1buoX1TrtK9eU6o=;
        h=From:To:CC:Subject:Date;
        b=AOjPqfFvB59pmSNP7nB8AS4byi8T0WE88vm+TIFdng3kw7yW8j/NE1x2hCrDmDHrT
         tXNbKYqKz9xhkqhaotBziHmQOtl9DgY0xRfcupoLgIH94CR1iUETaAGNlcBH7KTdbO
         ZSNUJjs0vNswbvhtt/mw44nHcpFHwQIh4ymTFs1k=
Received: from DLEE113.ent.ti.com (dlee113.ent.ti.com [157.170.170.24])
        by lelv0266.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 13GBgon3094454
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 16 Apr 2021 06:42:50 -0500
Received: from DLEE114.ent.ti.com (157.170.170.25) by DLEE113.ent.ti.com
 (157.170.170.24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2176.2; Fri, 16
 Apr 2021 06:42:50 -0500
Received: from lelv0326.itg.ti.com (10.180.67.84) by DLEE114.ent.ti.com
 (157.170.170.25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2176.2 via
 Frontend Transport; Fri, 16 Apr 2021 06:42:50 -0500
Received: from gsaswath-HP-ProBook-640-G5.dal.design.ti.com (ileax41-snat.itg.ti.com [10.172.224.153])
        by lelv0326.itg.ti.com (8.15.2/8.15.2) with ESMTP id 13GBgj3C039401;
        Fri, 16 Apr 2021 06:42:46 -0500
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
Subject: [PATCH v3 0/2] MCAN: Add support for implementing transceiver as a phy
Date:   Fri, 16 Apr 2021 17:12:43 +0530
Message-ID: <20210416114245.24829-1-a-govindraju@ti.com>
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

changes since v2:
- changed dev_err to dev_err_probe in patch 2
- used mcan_class instead of priv to assign max bit rate
- Picked up  Rob Herring's acked-by for patch 1

changes since v1:
- Used the API devm_phy_get_optional() instead of 
  devm_of_phy_get_optional_by_index()

[1] - https://www.ti.com/lit/ds/symlink/tcan1042h.pdf
[2] - https://www.ti.com/lit/ds/symlink/tcan1043-q1.pdf
[3] - https://lore.kernel.org/patchwork/project/lkml/list/?series=495511
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

