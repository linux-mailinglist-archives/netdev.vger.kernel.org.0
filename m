Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1764119D75D
	for <lists+netdev@lfdr.de>; Fri,  3 Apr 2020 15:14:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403880AbgDCNOw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Apr 2020 09:14:52 -0400
Received: from esa5.microchip.iphmx.com ([216.71.150.166]:48431 "EHLO
        esa5.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728044AbgDCNOw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Apr 2020 09:14:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1585919692; x=1617455692;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=BUl5OPIQBO+nrNeP6bJCMTo0vE/9FRdmAQik2DEkayw=;
  b=tgrMngR6pzQ01atnhAhDbj2i4riCmFcYYgbD0WHg4X4xGjXD/f67xVd2
   y31GyQz1DvkiXdNIpjhby3dH8fX3J+645Gi6L9ka+3N8KnAry4dNObs80
   nPoGQpnxR9iy7BpP54Qyepq85E90X2OPNvZtw5t8w/d/fXVgh7sTDBFuu
   ZCaB0v1kJ3e94XPBsJOpF/+fBoAqDXARTJ+HlmRH3g7JbjyAxfOxgS1UQ
   6oGtbW1alvTPIcVeAgDo38wkl5QdCZuAOIMAbE/Ag9jfGA8xLPOOot/3c
   axIOQZsQgKjuHHYnnVja6VAO//gz0oSBE5wJUK+a/Y4MRQmi5dkqyWm1q
   w==;
IronPort-SDR: fp0Uozpef3CLf5W/bXxKymuxuwx9c5MwNPOiYwlw4FwV7l/pQYDdYtz2c1FkGVuZH29Qdr724A
 KwrNpZf6559mPj1sCF6FMbQDMhpMKlZuncxJCV91W29mvubFpUgfZx5MjtQKK/NOxtbsla/VFy
 GqpFGw0M7ba3HrcZMMwacQLwWqBD6CSyE7uzq/b0jpCBLP9bJF/aVc4iXu7WtfFIKFTu/x20R5
 GJB23TMVkacy5a3TR5yQQTN4Qz5xAezhNm6Zk97cbKIp3JS+fYuY3t2owlleqs2/MAOOaUZPOk
 YbA=
X-IronPort-AV: E=Sophos;i="5.72,339,1580799600"; 
   d="scan'208";a="71345554"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 03 Apr 2020 06:14:51 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Fri, 3 Apr 2020 06:14:50 -0700
Received: from mchp-main.com (10.10.115.15) by chn-vm-ex02.mchp-main.com
 (10.10.85.144) with Microsoft SMTP Server id 15.1.1713.5 via Frontend
 Transport; Fri, 3 Apr 2020 06:14:47 -0700
From:   <nicolas.ferre@microchip.com>
To:     <linux-arm-kernel@lists.infradead.org>, <netdev@vger.kernel.org>,
        "Claudiu Beznea" <claudiu.beznea@microchip.com>,
        <harini.katakam@xilinx.com>
CC:     <linux-kernel@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        <rafalo@cadence.com>, <sergio.prado@e-labworks.com>,
        <antoine.tenart@bootlin.com>, <f.fainelli@gmail.com>,
        <linux@armlinux.org.uk>, <andrew@lunn.ch>,
        <michal.simek@xilinx.com>,
        Nicolas Ferre <nicolas.ferre@microchip.com>
Subject: [RFC PATCH 0/3] net: macb: Wake-on-Lan magic packet fixes
Date:   Fri, 3 Apr 2020 15:14:41 +0200
Message-ID: <cover.1585917191.git.nicolas.ferre@microchip.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Nicolas Ferre <nicolas.ferre@microchip.com>

Hi,
Here are some of my early patches in order to fix WoL magic-packet on the
current macb driver.
Addition of this feature to GEM types of IPs is yet to come. I would like to
have your feedback on these little patches first so that I can continue
investigating the addition of GEM WoL magic-packet.

Harini, I know that you have patches for GEM in order to integrate WoL ARP
mode [1]. I'll try to integrate some of your work but would need that this feature
is better integrated in current code. For instance, the choice of "magic
packet" or "ARP" should be done by ethtool options and DT properties. For
matching with mainline users, MACB and GEM code must co-exist.
The use of dumb buffers for RX seems also fairly platform specific and we would
need to think more about it.

[1]:
https://github.com/Xilinx/linux-xlnx/commit/e9648006e8d9132db2594e50e700af362b3c9226#diff-41909d180431659ccc1229aa30fd4e5a
https://github.com/Xilinx/linux-xlnx/commit/60a21c686f7e4e50489ae04b9bb1980b145e52ef

Nicolas Ferre (3):
  net: macb: fix wakeup test in runtime suspend/resume routines
  net: macb: mark device wake capable when "magic-packet" property
    present
  net: macb: fix macb_get/set_wol() when moving to phylink

 drivers/net/ethernet/cadence/macb_main.c | 24 +++++++++++++-----------
 1 file changed, 13 insertions(+), 11 deletions(-)

-- 
2.20.1

