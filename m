Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8A1EE176C0E
	for <lists+netdev@lfdr.de>; Tue,  3 Mar 2020 03:54:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728848AbgCCCtY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Mar 2020 21:49:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:45618 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728782AbgCCCtX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 2 Mar 2020 21:49:23 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F2062246D5;
        Tue,  3 Mar 2020 02:49:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583203762;
        bh=OfJcAaeI/nrPc7oVnN+bhGLA3fcflJ33ohKgSQKGv7s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=v+ip1od6TI+ZfqEl0pnKQUrklWjmyhTQ0Y6NdmLNSpBIFAfEY83oCINZFffjT1GXp
         fBsde/30bdGaQ+HgMCuJ0jc5Su9/nTJoG2ziDpcmbD6MpMBc/ZZhkMfoUcONplFqt9
         N3Bmrwge1lXMdcCbgkHXoInNB5GI9WoUcgNCxt3E=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Horatiu Vultur <horatiu.vultur@microchip.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 24/32] net: mscc: fix in frame extraction
Date:   Mon,  2 Mar 2020 21:48:43 -0500
Message-Id: <20200303024851.10054-24-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200303024851.10054-1-sashal@kernel.org>
References: <20200303024851.10054-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Horatiu Vultur <horatiu.vultur@microchip.com>

[ Upstream commit a81541041ceb55bcec9a8bb8ad3482263f0a205a ]

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
Acked-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mscc/ocelot_board.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/net/ethernet/mscc/ocelot_board.c b/drivers/net/ethernet/mscc/ocelot_board.c
index 3cdf63e35b53b..4054cf9db8181 100644
--- a/drivers/net/ethernet/mscc/ocelot_board.c
+++ b/drivers/net/ethernet/mscc/ocelot_board.c
@@ -105,6 +105,14 @@ static irqreturn_t ocelot_xtr_irq_handler(int irq, void *arg)
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
 
 		dev = ocelot->ports[info.port]->dev;
-- 
2.20.1

