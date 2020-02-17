Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EA7C3160D51
	for <lists+netdev@lfdr.de>; Mon, 17 Feb 2020 09:31:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728254AbgBQIbt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Feb 2020 03:31:49 -0500
Received: from esa6.microchip.iphmx.com ([216.71.154.253]:56578 "EHLO
        esa6.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726397AbgBQIbs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Feb 2020 03:31:48 -0500
Received-SPF: Pass (esa6.microchip.iphmx.com: domain of
  Horatiu.Vultur@microchip.com designates 198.175.253.82 as
  permitted sender) identity=mailfrom;
  client-ip=198.175.253.82; receiver=esa6.microchip.iphmx.com;
  envelope-from="Horatiu.Vultur@microchip.com";
  x-sender="Horatiu.Vultur@microchip.com";
  x-conformance=spf_only; x-record-type="v=spf1";
  x-record-text="v=spf1 mx a:ushub1.microchip.com
  a:smtpout.microchip.com -exists:%{i}.spf.microchip.iphmx.com
  include:servers.mcsv.net include:mktomail.com
  include:spf.protection.outlook.com ~all"
Received-SPF: None (esa6.microchip.iphmx.com: no sender
  authenticity information available from domain of
  postmaster@email.microchip.com) identity=helo;
  client-ip=198.175.253.82; receiver=esa6.microchip.iphmx.com;
  envelope-from="Horatiu.Vultur@microchip.com";
  x-sender="postmaster@email.microchip.com";
  x-conformance=spf_only
Authentication-Results: esa6.microchip.iphmx.com; spf=Pass smtp.mailfrom=Horatiu.Vultur@microchip.com; spf=None smtp.helo=postmaster@email.microchip.com; dmarc=pass (p=none dis=none) d=microchip.com
IronPort-SDR: 2IEOfYiygsyNczvgLQg4UC8nf2ELD/vFq9bPoHK3s71gaHlYEHmAtObwaDFy096PMRgrVNptZQ
 dq2MQ0t9J6c2LbbUdhysV/aO5kKdL+6pB7Zx24OFoXS+5q2T1d7mSOuip+ttzRw7rb+1rokO+7
 k5zK1CREqu9U67YEJq+kNyM1GD2Uy20OBLf+90ePOnRrSVa2iiOQnpRU2y4ATGqDIqJXddAUz6
 fVqVWrYIyj6YNhlTpLj/+weXvQnVtWUk0iJendCXIfytR2gUnvghAGAfKFTvpIvXMJb5AsixBI
 fGM=
X-IronPort-AV: E=Sophos;i="5.70,451,1574146800"; 
   d="scan'208";a="2607181"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 17 Feb 2020 01:31:48 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Mon, 17 Feb 2020 01:31:47 -0700
Received: from soft-dev3.microsemi.net (10.10.115.15) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server id
 15.1.1713.5 via Frontend Transport; Mon, 17 Feb 2020 01:31:46 -0700
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     <alexandre.belloni@bootlin.com>, <UNGLinuxDriver@microchip.com>,
        <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: [PATCH] net: mscc: fix in frame extraction
Date:   Mon, 17 Feb 2020 09:31:33 +0100
Message-ID: <20200217083133.20828-1-horatiu.vultur@microchip.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Each extracted frame on Ocelot has an IFH. The frame and IFH are extracted
by reading chuncks of 4 bytes from a register.

In case the IFH and frames were read corretly it would try to read the next
frame. In case there are no more frames in the queue, it checks if there
were any previous errors and in that case clear the queue. But this check
will always succeed also when there are no errors. Because when extracting
the IFH the error is checked against 4(number of bytes read) and then the
error is set only if the extraction of the frame failed. So in a happy case
where there are no errors the err variable is still 4. So it could be
a case where after the check that there are no more frames in the queue, a
frame will arrive in the queue but because the error is not reseted, it
would try to flush the queue. So the frame will be lost.

The fix consist in resetting the error after reading the IFH.

Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
---
 drivers/net/ethernet/mscc/ocelot_board.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/net/ethernet/mscc/ocelot_board.c b/drivers/net/ethernet/mscc/ocelot_board.c
index b38820849faa..1135a18019c7 100644
--- a/drivers/net/ethernet/mscc/ocelot_board.c
+++ b/drivers/net/ethernet/mscc/ocelot_board.c
@@ -114,6 +114,14 @@ static irqreturn_t ocelot_xtr_irq_handler(int irq, void *arg)
 		if (err != 4)
 			break;
 
+		/* At this point the IFH was read correctly, so it is safe to
+		 * presume that there is no error. The err needs to be reset
+		 * otherwise a frame could come in CPU queue between the while
+		 * condition and the check for error later on. And in that case
+		 * the new frame is just removed and not processed.
+		 */
+		err = 0;
+
 		ocelot_parse_ifh(ifh, &info);
 
 		ocelot_port = ocelot->ports[info.port];
-- 
2.17.1

