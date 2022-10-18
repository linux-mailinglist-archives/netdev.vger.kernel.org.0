Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3E61E6033E7
	for <lists+netdev@lfdr.de>; Tue, 18 Oct 2022 22:27:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229866AbiJRU1s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Oct 2022 16:27:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229604AbiJRU1r (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Oct 2022 16:27:47 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A4D47F13F;
        Tue, 18 Oct 2022 13:27:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 05B7D616EA;
        Tue, 18 Oct 2022 20:27:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A16D7C433D6;
        Tue, 18 Oct 2022 20:27:45 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="AfpjIH9c"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1666124863;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Z9dNg5RUH3ZUYvEP9bPk55wn/6KP5eKiCL7817xOPJo=;
        b=AfpjIH9cDCFgTUBq9oDwFF23ExG/kMnTNG/BdqNSodzUqas/Qs1Ff+i/Tkfdk3qCikxF2A
        Gf1m5C/q+h9bIvjQfT62a63b1Gd1YOBJqzdqAtD7sPIpvc6Ugpa1AJlT5JSGx84LUXVQ4o
        nTBiOSN2Eqnjn7VirEb05LDPLfwmF2E=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 3a8f4031 (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO);
        Tue, 18 Oct 2022 20:27:43 +0000 (UTC)
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Stanislaw Gruszka <stf_xl@wp.pl>,
        Helmut Schaa <helmut.schaa@googlemail.com>,
        Kalle Valo <kvalo@kernel.org>
Subject: [PATCH] wifi: rt2x00: use explicitly signed type for clamping
Date:   Tue, 18 Oct 2022 14:27:34 -0600
Message-Id: <20221018202734.140489-1-Jason@zx2c4.com>
In-Reply-To: <202210190108.ESC3pc3D-lkp@intel.com>
References: <202210190108.ESC3pc3D-lkp@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-6.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On some platforms, `char` is unsigned, which makes casting -7 to char
overflow, which in turn makes the clamping operation bogus. Instead,
deal with an explicit `s8` type, so that the comparison is always
signed, and return an s8 result from the function as well. Note that
this function's result is assigned to a `short`, which is always signed.

Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Stanislaw Gruszka <stf_xl@wp.pl>
Cc: Helmut Schaa <helmut.schaa@googlemail.com>
Cc: Kalle Valo <kvalo@kernel.org>
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
---
 drivers/net/wireless/ralink/rt2x00/rt2800lib.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/ralink/rt2x00/rt2800lib.c b/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
index cbbb1a4849cf..e233ef9892b3 100644
--- a/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
@@ -4035,23 +4035,23 @@ static void rt2800_iq_calibrate(struct rt2x00_dev *rt2x00dev, int channel)
 	rt2800_bbp_write(rt2x00dev, 159, cal != 0xff ? cal : 0);
 }
 
-static char rt2800_txpower_to_dev(struct rt2x00_dev *rt2x00dev,
+static s8 rt2800_txpower_to_dev(struct rt2x00_dev *rt2x00dev,
 				  unsigned int channel,
-				  char txpower)
+				  s8 txpower)
 {
 	if (rt2x00_rt(rt2x00dev, RT3593) ||
 	    rt2x00_rt(rt2x00dev, RT3883))
 		txpower = rt2x00_get_field8(txpower, EEPROM_TXPOWER_ALC);
 
 	if (channel <= 14)
-		return clamp_t(char, txpower, MIN_G_TXPOWER, MAX_G_TXPOWER);
+		return clamp_t(s8, txpower, MIN_G_TXPOWER, MAX_G_TXPOWER);
 
 	if (rt2x00_rt(rt2x00dev, RT3593) ||
 	    rt2x00_rt(rt2x00dev, RT3883))
-		return clamp_t(char, txpower, MIN_A_TXPOWER_3593,
+		return clamp_t(s8, txpower, MIN_A_TXPOWER_3593,
 			       MAX_A_TXPOWER_3593);
 	else
-		return clamp_t(char, txpower, MIN_A_TXPOWER, MAX_A_TXPOWER);
+		return clamp_t(s8, txpower, MIN_A_TXPOWER, MAX_A_TXPOWER);
 }
 
 static void rt3883_bbp_adjust(struct rt2x00_dev *rt2x00dev,
-- 
2.37.3

