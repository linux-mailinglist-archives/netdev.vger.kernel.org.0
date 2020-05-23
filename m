Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A0DD1DFAC1
	for <lists+netdev@lfdr.de>; Sat, 23 May 2020 21:47:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387569AbgEWTqy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 23 May 2020 15:46:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728319AbgEWTqx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 23 May 2020 15:46:53 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8CCCC061A0E
        for <netdev@vger.kernel.org>; Sat, 23 May 2020 12:46:53 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id k15so13117815ybt.4
        for <netdev@vger.kernel.org>; Sat, 23 May 2020 12:46:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=JXod+WgEG2IOUs0660x5oo3FBnYojupsb8lKMJDCr5s=;
        b=MWXFktYss4z80epHVGlGyzlgu5kFWHyqdf/XSD2FRgUOHsygCpRmrwaGEkU44xfyW0
         /G0udFNIU/C8WkuHovvW7GAnf5BPY76r1SlyM13q6YZWptCURBDcXh/5+b/zecOopZvY
         N64YhT3syaFV8xYJHXlzucWoTmxGVTaXpDJNCE4qxy7y6vem5ZyVRN2YX6oq1WquB2vZ
         OQZJ7YRLZWFTIgRX7BSk+TowJrO6Km21Ng1zclbeSfOdjJsba0vloGYPkaiXNy9k1Cu6
         LLkyjaPl4tOu1O1goz2SSAHryhbRE9wTCOoNrxbBX4t9MdahtUCoyS2YhVRIUqB2S5jY
         cgxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=JXod+WgEG2IOUs0660x5oo3FBnYojupsb8lKMJDCr5s=;
        b=fhDg99JEwAFXS37eot4TDdXb7y8kEv85KQMEBGPKYbl4t9cGnTnQo4Q0aKIQSVsxyk
         0kNH6f3ZNWqQglbGx8MDF7X5Ghr18OhV/AOZ01JoQyWKsfTYQyuWuim5QsRipmBL3zov
         xS425FeOjZpZT6k6DowP3+K4vPEdKolH+bPgdM76i8JDzwe/okzueoG/mUbnZ7ICAwpg
         z6uIVU3KdBm9I9nNv0SvqeAnj6SwJZkZzd+abskueDh6P8xlWpzC7NwYR0Nz4QxQnQ+u
         Xs4wU0EfFin1zEJseKQD7vFTzPeZz1prwkRYoLkoB2TuyrM/nvbb5Brp5aWErcQUq/fS
         qqgg==
X-Gm-Message-State: AOAM531HsA64L2RYXV11lFp0JYSXuykBeIurVD3xl6XAMDzchy3xmDoG
        Kttw1FjHL3BlmpK3sRkI3meWGoLqYCUlpw==
X-Google-Smtp-Source: ABdhPJxA7s9p8yPTVFkJDn6BVzteWFOMftrccmvlz9jhWzcgH8ncigOFvzDjFjRiOgkT8eNhDentHt+pzoshqA==
X-Received: by 2002:a25:7713:: with SMTP id s19mr18430841ybc.307.1590263212898;
 Sat, 23 May 2020 12:46:52 -0700 (PDT)
Date:   Sat, 23 May 2020 12:46:49 -0700
Message-Id: <20200523194649.217950-1-edumazet@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.27.0.rc0.183.gde8f92d652-goog
Subject: [PATCH net-next] bnx2x: allow bnx2x_bsc_read() to schedule
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Ariel Elior <aelior@marvell.com>,
        Sudarsana Kalluru <skalluru@marvell.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

bnx2x_warpcore_read_sfp_module_eeprom() can call bnx2x_bsc_read()
three times before giving up.

This causes latency blips of at least 31 ms (58 ms being reported
by our teams)

Convert the long lasting loops of udelay() to usleep_range() ones,
and breaks the loops on precise time tracking.

Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Ariel Elior <aelior@marvell.com>
Cc: Sudarsana Kalluru <skalluru@marvell.com>
---
 .../net/ethernet/broadcom/bnx2x/bnx2x_link.c  | 26 +++++++++++--------
 1 file changed, 15 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_link.c b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_link.c
index 517caedc0a87a2b1adc3269442f1cbc420490d39..1426c691c7c4a416f4f8227ccb0e2d5dbd039107 100644
--- a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_link.c
+++ b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_link.c
@@ -3085,6 +3085,7 @@ static int bnx2x_bsc_read(struct link_params *params,
 			  u8 xfer_cnt,
 			  u32 *data_array)
 {
+	u64 t0, delta;
 	u32 val, i;
 	int rc = 0;
 
@@ -3114,17 +3115,18 @@ static int bnx2x_bsc_read(struct link_params *params,
 	REG_WR(bp, MCP_REG_MCPR_IMC_COMMAND, val);
 
 	/* Poll for completion */
-	i = 0;
+	t0 = ktime_get_ns();
 	val = REG_RD(bp, MCP_REG_MCPR_IMC_COMMAND);
 	while (((val >> MCPR_IMC_COMMAND_IMC_STATUS_BITSHIFT) & 0x3) != 1) {
-		udelay(10);
-		val = REG_RD(bp, MCP_REG_MCPR_IMC_COMMAND);
-		if (i++ > 1000) {
-			DP(NETIF_MSG_LINK, "wr 0 byte timed out after %d try\n",
-								i);
+		delta = ktime_get_ns() - t0;
+		if (delta > 10 * NSEC_PER_MSEC) {
+			DP(NETIF_MSG_LINK, "wr 0 byte timed out after %Lu ns\n",
+					   delta);
 			rc = -EFAULT;
 			break;
 		}
+		usleep_range(10, 20);
+		val = REG_RD(bp, MCP_REG_MCPR_IMC_COMMAND);
 	}
 	if (rc == -EFAULT)
 		return rc;
@@ -3138,16 +3140,18 @@ static int bnx2x_bsc_read(struct link_params *params,
 	REG_WR(bp, MCP_REG_MCPR_IMC_COMMAND, val);
 
 	/* Poll for completion */
-	i = 0;
+	t0 = ktime_get_ns();
 	val = REG_RD(bp, MCP_REG_MCPR_IMC_COMMAND);
 	while (((val >> MCPR_IMC_COMMAND_IMC_STATUS_BITSHIFT) & 0x3) != 1) {
-		udelay(10);
-		val = REG_RD(bp, MCP_REG_MCPR_IMC_COMMAND);
-		if (i++ > 1000) {
-			DP(NETIF_MSG_LINK, "rd op timed out after %d try\n", i);
+		delta = ktime_get_ns() - t0;
+		if (delta > 10 * NSEC_PER_MSEC) {
+			DP(NETIF_MSG_LINK, "rd op timed out after %Lu ns\n",
+					   delta);
 			rc = -EFAULT;
 			break;
 		}
+		usleep_range(10, 20);
+		val = REG_RD(bp, MCP_REG_MCPR_IMC_COMMAND);
 	}
 	if (rc == -EFAULT)
 		return rc;
-- 
2.27.0.rc0.183.gde8f92d652-goog

