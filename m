Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC5FB4A3F9D
	for <lists+netdev@lfdr.de>; Mon, 31 Jan 2022 10:59:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345545AbiAaJ7K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Jan 2022 04:59:10 -0500
Received: from esa.microchip.iphmx.com ([68.232.154.123]:39032 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240974AbiAaJ7G (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Jan 2022 04:59:06 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1643623146; x=1675159146;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=qS1GC/CazYtSayzRKGgsGj77mNORqaMQUiAVPaNI34o=;
  b=LHNg/hv+nxNiPLPWnyru42M52SyzAZ4r1bZigZTx3zAeS0Ij0a1sLdPc
   9vgHwmg4A9sKTOKQnupoeOL7UJoGO5EmNKgsIt+HjYPE7MbLNHjMeCP7i
   DA+yRYGCILbPu2FphwqkYWyYclDHmu8OzR0tJmUL9/YPu1mxtvutyH6sL
   XDKAM96EEZytElifX2qVkoPINlolb8Q3Jmtf/P6+HrmlJMtLj7+12ydp1
   0NfICSExtOWjUl8RsbP5WEMzzDavU8iwdIInyakPWN6Z/GpkoyYU0wFSl
   jWMruTeYSVU1H1jk35AvPnBlRXbznBUlI0i/LQHBmxgO4sRzP3KYYOYSg
   A==;
IronPort-SDR: y87pzpOEuryJ2hDaMLSndUXzoNKTPoXptC1M7EcqkQIkOjL9mzOa5QEgOScKM6OFUNyjTDUKTz
 OmHi4qwKmW4QVTR5H7rtWNq8eutqz9rdo7vEDXIPPc/eVS8nWlm2bTjUpEUYluGxpvJf33L28w
 QAPt3OQlI5qNHcE985MhNMlOUFWJOjWSOAu6Rw0lsB2XxdYg0v2ABLR+WNt4bAyfpR2D5Hwmiz
 nwuxpC3fbXdovN6vNMBErrt9ylCDSexqjsyoPrNmNtmVVgH/gyQjKDf2am6lc0h6nYwkwVuFQO
 q5OmgnWr3/cKQ/x4x1HAznQe
X-IronPort-AV: E=Sophos;i="5.88,330,1635231600"; 
   d="scan'208";a="84173548"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 31 Jan 2022 02:59:05 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Mon, 31 Jan 2022 02:59:04 -0700
Received: from soft-dev3-1.microsemi.net (10.10.115.15) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server id
 15.1.2375.17 via Frontend Transport; Mon, 31 Jan 2022 02:59:02 -0700
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     <netdev@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <robh+dt@kernel.org>,
        <UNGLinuxDriver@microchip.com>, <linux@armlinux.org.uk>,
        <richardcochran@gmail.com>, <f.fainelli@gmail.com>,
        <vivien.didelot@gmail.com>, <vladimir.oltean@nxp.com>,
        <andrew@lunn.ch>, Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: [PATCH net-next v2 0/7] net: lan966x: Add PTP Hardward Clock support
Date:   Mon, 31 Jan 2022 11:01:15 +0100
Message-ID: <20220131100122.423164-1-horatiu.vultur@microchip.com>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add support for PTP Hardware Clock (PHC) for lan966x. The switch supports
both PTP 1-step and 2-step modes.

v1->v2:
- fix commit messages
- reduce the scope of the lock ptp_lock inside the function
  lan966x_ptp_hwtstamp_set
- the rx timestamping is always enabled for all packages

Horatiu Vultur (7):
  dt-bindings: net: lan966x: Extend with the ptp interrupt
  net: lan966x: Add registers that are use for ptp functionality
  net: lan966x: Add support for ptp clocks
  net: lan966x: Implement SIOCSHWTSTAMP and SIOCGHWTSTAMP
  net: lan966x: Update extraction/injection for timestamping
  net: lan966x: Add support for ptp interrupts
  net: lan966x: Implement get_ts_info

 .../net/microchip,lan966x-switch.yaml         |   2 +
 .../net/ethernet/microchip/lan966x/Makefile   |   3 +-
 .../microchip/lan966x/lan966x_ethtool.c       |  34 +
 .../ethernet/microchip/lan966x/lan966x_main.c |  89 ++-
 .../ethernet/microchip/lan966x/lan966x_main.h |  51 ++
 .../ethernet/microchip/lan966x/lan966x_ptp.c  | 618 ++++++++++++++++++
 .../ethernet/microchip/lan966x/lan966x_regs.h | 103 +++
 7 files changed, 894 insertions(+), 6 deletions(-)
 create mode 100644 drivers/net/ethernet/microchip/lan966x/lan966x_ptp.c

-- 
2.33.0

