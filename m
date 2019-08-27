Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EC0459E447
	for <lists+netdev@lfdr.de>; Tue, 27 Aug 2019 11:32:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729897AbfH0Jba (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Aug 2019 05:31:30 -0400
Received: from esa3.microchip.iphmx.com ([68.232.153.233]:11957 "EHLO
        esa3.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729852AbfH0Jb3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Aug 2019 05:31:29 -0400
Received-SPF: Pass (esa3.microchip.iphmx.com: domain of
  Razvan.Stefanescu@microchip.com designates 198.175.253.82 as
  permitted sender) identity=mailfrom;
  client-ip=198.175.253.82; receiver=esa3.microchip.iphmx.com;
  envelope-from="Razvan.Stefanescu@microchip.com";
  x-sender="Razvan.Stefanescu@microchip.com";
  x-conformance=spf_only; x-record-type="v=spf1";
  x-record-text="v=spf1 mx a:ushub1.microchip.com
  a:smtpout.microchip.com a:mx1.microchip.iphmx.com
  a:mx2.microchip.iphmx.com include:servers.mcsv.net
  include:mktomail.com include:spf.protection.outlook.com ~all"
Received-SPF: None (esa3.microchip.iphmx.com: no sender
  authenticity information available from domain of
  postmaster@email.microchip.com) identity=helo;
  client-ip=198.175.253.82; receiver=esa3.microchip.iphmx.com;
  envelope-from="Razvan.Stefanescu@microchip.com";
  x-sender="postmaster@email.microchip.com";
  x-conformance=spf_only
Authentication-Results: esa3.microchip.iphmx.com; dkim=none (message not signed) header.i=none; spf=Pass smtp.mailfrom=Razvan.Stefanescu@microchip.com; spf=None smtp.helo=postmaster@email.microchip.com; dmarc=pass (p=none dis=none) d=microchip.com
IronPort-SDR: IoZAp5hx2bx5mAEHwX5AeKcwVJJ2UJ80Kf706x25uffIrOfPzEeGDZ0q8aSOU897343Q0IEYmY
 RTWQR6DUvQYLKvYDasGM6uPA7zP0wNtQyOWZiZ4JGWWVQwegLqsLYw/5V8V2Phha+STbPMbTgY
 L+aY+YmV8aTRC4ApxS3k/zzDsAaXKONjxmRoR7qRYe1+6/8cgWGILhy/Fe9OeUPsKrcNkvqsLC
 o/hivPk8hejORfh6TV7LUZFkH2x2oymY52UxlhsoEi4Ni8Tt/CmgHv3IFjriiKBeAM/sRVDH3V
 Jm4=
X-IronPort-AV: E=Sophos;i="5.64,436,1559545200"; 
   d="scan'208";a="46731633"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 27 Aug 2019 02:31:28 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Tue, 27 Aug 2019 02:31:27 -0700
Received: from rob-ult-m50855.microchip.com (10.10.85.251) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server id
 15.1.1713.5 via Frontend Transport; Tue, 27 Aug 2019 02:31:26 -0700
From:   Razvan Stefanescu <razvan.stefanescu@microchip.com>
To:     Woojung Huh <woojung.huh@microchip.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S . Miller" <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        "Razvan Stefanescu" <razvan.stefanescu@microchip.com>
Subject: [PATCH 3/4] net: dsa: microchip: fix interrupt mask
Date:   Tue, 27 Aug 2019 12:31:09 +0300
Message-ID: <20190827093110.14957-4-razvan.stefanescu@microchip.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190827093110.14957-1-razvan.stefanescu@microchip.com>
References: <20190827093110.14957-1-razvan.stefanescu@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Global Interrupt Mask Register comprises of Lookup Engine (LUE) Interrupt
Mask (bit 31) and GPIO Pin Output Trigger and Timestamp Unit Interrupt
Mask (bit 29).

This corrects LUE bit.

Signed-off-by: Razvan Stefanescu <razvan.stefanescu@microchip.com>
---
 drivers/net/dsa/microchip/ksz9477_reg.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/dsa/microchip/ksz9477_reg.h b/drivers/net/dsa/microchip/ksz9477_reg.h
index 2938e892b631..f3949d7b9bbd 100644
--- a/drivers/net/dsa/microchip/ksz9477_reg.h
+++ b/drivers/net/dsa/microchip/ksz9477_reg.h
@@ -76,7 +76,7 @@
 #define TRIG_TS_INT			BIT(30)
 #define APB_TIMEOUT_INT			BIT(29)
 
-#define SWITCH_INT_MASK			(TRIG_TS_INT | APB_TIMEOUT_INT)
+#define SWITCH_INT_MASK			(LUE_INT | TRIG_TS_INT)
 
 #define REG_SW_PORT_INT_STATUS__4	0x0018
 #define REG_SW_PORT_INT_MASK__4		0x001C
-- 
2.20.1

