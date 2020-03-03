Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1DF87176B1A
	for <lists+netdev@lfdr.de>; Tue,  3 Mar 2020 03:48:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728412AbgCCCs0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Mar 2020 21:48:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:44144 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728397AbgCCCsY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 2 Mar 2020 21:48:24 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AC24F246D6;
        Tue,  3 Mar 2020 02:48:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583203703;
        bh=xqt4H5Ll6dhRS4CH7JG/NGQN2sDa4HiwBAcvJr7uI2k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YAPLcXOw99TrMRdv4OtfIGcew+r3tO+GVt3VbhUyf5zAZisrmUdnah7Mrl2wPAr0G
         Jz7ttAqTyD0C2ysezYAxEHBlfFb+L7HOfYB+6s2PnTqBES+Z2Cw9P0WP0rgB/q0Ceh
         TAv6NhM6SwayIdHnmt9abP8PkasX0Yx3yU4vuNSA=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Horatiu Vultur <horatiu.vultur@microchip.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 35/58] net: mscc: fix in frame extraction
Date:   Mon,  2 Mar 2020 21:47:17 -0500
Message-Id: <20200303024740.9511-35-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200303024740.9511-1-sashal@kernel.org>
References: <20200303024740.9511-1-sashal@kernel.org>
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
index aac115136720f..3371562325013 100644
--- a/drivers/net/ethernet/mscc/ocelot_board.c
+++ b/drivers/net/ethernet/mscc/ocelot_board.c
@@ -112,6 +112,14 @@ static irqreturn_t ocelot_xtr_irq_handler(int irq, void *arg)
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

