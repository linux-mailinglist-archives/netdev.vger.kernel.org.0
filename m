Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 651F464E674
	for <lists+netdev@lfdr.de>; Fri, 16 Dec 2022 04:44:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230051AbiLPDoc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Dec 2022 22:44:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230064AbiLPDo0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Dec 2022 22:44:26 -0500
Received: from codeconstruct.com.au (pi.codeconstruct.com.au [203.29.241.158])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AEF0D419AE
        for <netdev@vger.kernel.org>; Thu, 15 Dec 2022 19:44:23 -0800 (PST)
Received: by codeconstruct.com.au (Postfix, from userid 10000)
        id B616B20034; Fri, 16 Dec 2022 11:44:17 +0800 (AWST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=codeconstruct.com.au; s=2022a; t=1671162257;
        bh=5dSBjjr915OV+8y5VX2hV8fJmsnCcJAr0f9HMbNcpgw=;
        h=From:To:Cc:Subject:Date;
        b=HnBZZUyiRxswKAYPMVf+7wBsxwHP8T8OdakGhs/A0jbM6DNw7b4U6Uf5XRfpmmXYz
         i3/hCkbUyODDwL1vsPMH5w4Cux0TrfkrqGodTf8wtLz8kff4VU8w1fLzkTJzf7r4RB
         7xYaazrRKqVqVNLZUt5EbdK0nwpnAJvXR/HJ7DSMZI3ZTHVdxhHHgBk5aZzMy3foDe
         i40U1+U+8S3NO36SlA1dfKDLO8jeUPBt5SAPzHGqD6cRLfielPkX5YKkZpNgFtZPAj
         Z0NZc2aRONSV2f7BKhTGf8j2v6ML9IKJU3Oa+ciN1uqiwgX0DQ/YSUnae2p8KWpPWU
         B3gGc9oWbJwgA==
From:   Jeremy Kerr <jk@codeconstruct.com.au>
To:     netdev@vger.kernel.org
Cc:     Matt Johnston <matt@codeconstruct.com.au>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Harsh Tyagi <harshtya@google.com>
Subject: [PATCH net] mctp: serial: Fix starting value for frame check sequence
Date:   Fri, 16 Dec 2022 11:44:09 +0800
Message-Id: <20221216034409.27174-1-jk@codeconstruct.com.au>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RFC1662 defines the start state for the crc16 FCS to be 0xffff, but
we're currently starting at zero.

This change uses the correct start state. We're only early in the
adoption for the serial binding, so there aren't yet any other users to
interface to.

Fixes: a0c2ccd9b5ad ("mctp: Add MCTP-over-serial transport binding")

Reported-by: Harsh Tyagi <harshtya@google.com>
Tested-by: Harsh Tyagi <harshtya@google.com>
Signed-off-by: Jeremy Kerr <jk@codeconstruct.com.au>
---
 drivers/net/mctp/mctp-serial.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/mctp/mctp-serial.c b/drivers/net/mctp/mctp-serial.c
index 7cd103fd34ef..9f9eaf896047 100644
--- a/drivers/net/mctp/mctp-serial.c
+++ b/drivers/net/mctp/mctp-serial.c
@@ -35,6 +35,8 @@
 #define BYTE_FRAME		0x7e
 #define BYTE_ESC		0x7d
 
+#define FCS_INIT		0xffff
+
 static DEFINE_IDA(mctp_serial_ida);
 
 enum mctp_serial_state {
@@ -123,7 +125,7 @@ static void mctp_serial_tx_work(struct work_struct *work)
 		buf[2] = dev->txlen;
 
 		if (!dev->txpos)
-			dev->txfcs = crc_ccitt(0, buf + 1, 2);
+			dev->txfcs = crc_ccitt(FCS_INIT, buf + 1, 2);
 
 		txlen = write_chunk(dev, buf + dev->txpos, 3 - dev->txpos);
 		if (txlen <= 0) {
@@ -303,7 +305,7 @@ static void mctp_serial_push_header(struct mctp_serial *dev, unsigned char c)
 	case 1:
 		if (c == MCTP_SERIAL_VERSION) {
 			dev->rxpos++;
-			dev->rxfcs = crc_ccitt_byte(0, c);
+			dev->rxfcs = crc_ccitt_byte(FCS_INIT, c);
 		} else {
 			dev->rxstate = STATE_ERR;
 		}
-- 
2.35.1

