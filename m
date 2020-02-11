Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 14BF6159B51
	for <lists+netdev@lfdr.de>; Tue, 11 Feb 2020 22:41:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728126AbgBKVl5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Feb 2020 16:41:57 -0500
Received: from mo4-p02-ob.smtp.rzone.de ([85.215.255.80]:29479 "EHLO
        mo4-p02-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728014AbgBKVly (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Feb 2020 16:41:54 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1581457309;
        s=strato-dkim-0002; d=goldelico.com;
        h=References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
        X-RZG-CLASS-ID:X-RZG-AUTH:From:Subject:Sender;
        bh=TdyjL7fnovA7v90cI49fyycJRI+MxjJc1+DrsqTzedE=;
        b=oUp/bIW39rInx7cXXy+sj1W/5gOp1Xq/12yM9Q7Lbf34tNsASdymmF7KCzHywfEGeM
        oRvbegRP6v8E61nGt1mxPjEq3cDU42jUVqgwQWAN3dBvEaIggGmOVFCWdqVb+QfwGg/X
        H7b6ZCbOiMTaTnavWzyvfe7bElHApQt/NK59tk1W3c7z3sZQcZ6BVGaVP7Z2AzPv8mVm
        hn3JUIMpeHTSSUz7yzW1lamE/ob3NmEAXmZ9noDqmzFYAWUTQR8/VMBrKRgYlDuNhtcR
        dj9xy/Q8oxyEckplx5GqKYfr+xMaQnrPN2wZs05s+xNF3gx5Ahs/7Qjr+I15v0bDmh6P
        AswA==
X-RZG-AUTH: ":JGIXVUS7cutRB/49FwqZ7WcJeFKiMhflhwDubTJ9o1OAA2UNf2M0P2mp10IM"
X-RZG-CLASS-ID: mo00
Received: from iMac.fritz.box
        by smtp.strato.de (RZmta 46.1.12 DYNA|AUTH)
        with ESMTPSA id U06217w1BLfX0EH
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
        Tue, 11 Feb 2020 22:41:33 +0100 (CET)
From:   "H. Nikolaus Schaller" <hns@goldelico.com>
To:     Paul Cercueil <paul@crapouillou.net>,
        Paul Boddie <paul@boddie.org.uk>,
        Alex Smith <alex.smith@imgtec.com>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Ralf Baechle <ralf@linux-mips.org>,
        Paul Burton <paulburton@kernel.org>,
        James Hogan <jhogan@kernel.org>,
        David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>,
        "David S. Miller" <davem@davemloft.net>,
        Linus Walleij <linus.walleij@linaro.org>,
        "H. Nikolaus Schaller" <hns@goldelico.com>,
        Andi Kleen <ak@linux.intel.com>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        =?UTF-8?q?Petr=20=C5=A0tetiar?= <ynezz@true.cz>,
        Richard Fontana <rfontana@redhat.com>,
        Allison Randal <allison@lohutok.net>,
        Stephen Boyd <swboyd@chromium.org>
Cc:     devicetree@vger.kernel.org, linux-mips@vger.kernel.org,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linux-i2c@vger.kernel.org, netdev@vger.kernel.org,
        linux-gpio@vger.kernel.org, letux-kernel@openphoenux.org,
        kernel@pyra-handheld.com
Subject: [PATCH 01/14] i2c: jz4780: suppress txabrt reports for i2cdetect
Date:   Tue, 11 Feb 2020 22:41:18 +0100
Message-Id: <7facef52af9cff6ebe26ff321a7fd4f1ac640f74.1581457290.git.hns@goldelico.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <cover.1581457290.git.hns@goldelico.com>
References: <cover.1581457290.git.hns@goldelico.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This suppresses "simple" error reasons

	ABRT_7B_ADDR_NOACK
	ABRT_10ADDR1_NOACK
	ABRT_10ADDR2_NOACK

from flooding the console log when running i2cdetect on
addresses without a responding slave.

Additionally, reading the JZ4780_I2C_TAR in this situation
seems to harm the controller state.

Signed-off-by: H. Nikolaus Schaller <hns@goldelico.com>
---
 drivers/i2c/busses/i2c-jz4780.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/i2c/busses/i2c-jz4780.c b/drivers/i2c/busses/i2c-jz4780.c
index 16a67a64284a..55b7518435f1 100644
--- a/drivers/i2c/busses/i2c-jz4780.c
+++ b/drivers/i2c/busses/i2c-jz4780.c
@@ -578,6 +578,9 @@ static void jz4780_i2c_txabrt(struct jz4780_i2c *i2c, int src)
 {
 	int i;
 
+	if (!(src & ~7))
+		return;
+
 	dev_err(&i2c->adap.dev, "txabrt: 0x%08x\n", src);
 	dev_err(&i2c->adap.dev, "device addr=%x\n",
 		jz4780_i2c_readw(i2c, JZ4780_I2C_TAR));
-- 
2.23.0

