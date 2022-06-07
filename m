Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5702253339C
	for <lists+netdev@lfdr.de>; Wed, 25 May 2022 00:42:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242453AbiEXWmn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 May 2022 18:42:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239127AbiEXWml (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 May 2022 18:42:41 -0400
X-Greylist: delayed 203 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 24 May 2022 15:42:38 PDT
Received: from h3.fbrelay.privateemail.com (h3.fbrelay.privateemail.com [131.153.2.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25B97546AE;
        Tue, 24 May 2022 15:42:38 -0700 (PDT)
Received: from MTA-15-4.privateemail.com (MTA-15-1.privateemail.com [198.54.118.208])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by h3.fbrelay.privateemail.com (Postfix) with ESMTPS id 72E0318007EA;
        Tue, 24 May 2022 18:39:14 -0400 (EDT)
Received: from mta-15.privateemail.com (localhost [127.0.0.1])
        by mta-15.privateemail.com (Postfix) with ESMTP id 336CB18001A5;
        Tue, 24 May 2022 18:39:13 -0400 (EDT)
Received: from warhead.local (unknown [10.20.151.140])
        by mta-15.privateemail.com (Postfix) with ESMTPA id 3763F1800182;
        Tue, 24 May 2022 18:39:04 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=mebeim.net; s=default;
        t=1653431953; bh=TnKjhqksMncdEY2RXthuQsk5fek7maCh5+VoEJsnvcw=;
        h=From:To:Cc:Subject:Date:From;
        b=YtCpZeQuQNis7kL6O4IrA5AbMMpTqbBrPNgw5Wqq+c144yGtVQJ3tR8CTdy1Mq6/J
         9hXuIEGDuv5hQizNGDsLqu+FtBUoc1sMtz5VG1+HgahgjEJ0399B3BaH+36Y/nuTzq
         VGeQqlbjikU9G1WLtXN39e+fEuaFL7Qowm3ZHXT7WTdimBPM3ytJ7eEFdTxkALkqT8
         FCA9yoUApBm3nA7560/tDilmx1QGFPGqi7bRnse2gRmBA/90ziwazJduLQZcypOzRV
         oK8pkj/LybWdY4L1ZWWwqBJHdcfBcdWG02XVjzmqsxLmU/zNexvpQWT4titTE5WvTd
         /7Mcf3y38MfbQ==
From:   Marco Bonelli <marco@mebeim.net>
To:     netdev@vger.kernel.org
Cc:     Marco Bonelli <marco@mebeim.net>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org
Subject: [PATCH] ethtool: Fix and optimize ethtool_convert_link_mode_to_legacy_u32()
Date:   Wed, 25 May 2022 00:38:19 +0200
Message-Id: <20220524223818.259303-1-marco@mebeim.net>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix the implementation of ethtool_convert_link_mode_to_legacy_u32(), which
is supposed to return false if src has bits higher than 31 set. The current
implementation uses the complement of bitmap_fill(ext, 32) to test high
bits of src, which is wrong as bitmap_fill() fills _with long granularity_,
and sizeof(long) can be > 4. No users of this function currently check the
return value, so the bug was dormant.

Also remove the check for __ETHTOOL_LINK_MODE_MASK_NBITS > 32, as the enum
ethtool_link_mode_bit_indices contains far beyond 32 values. Using
find_next_bit() to test the src bitmask works regardless of this anyway.

Signed-off-by: Marco Bonelli <marco@mebeim.net>
---
 net/ethtool/ioctl.c | 17 ++---------------
 1 file changed, 2 insertions(+), 15 deletions(-)

diff --git a/net/ethtool/ioctl.c b/net/ethtool/ioctl.c
index 326e14ee05db..7fb3f3fd6f3c 100644
--- a/net/ethtool/ioctl.c
+++ b/net/ethtool/ioctl.c
@@ -369,22 +369,9 @@ EXPORT_SYMBOL(ethtool_convert_legacy_u32_to_link_mode);
 bool ethtool_convert_link_mode_to_legacy_u32(u32 *legacy_u32,
 					     const unsigned long *src)
 {
-	bool retval = true;
-
-	/* TODO: following test will soon always be true */
-	if (__ETHTOOL_LINK_MODE_MASK_NBITS > 32) {
-		__ETHTOOL_DECLARE_LINK_MODE_MASK(ext);
-
-		linkmode_zero(ext);
-		bitmap_fill(ext, 32);
-		bitmap_complement(ext, ext, __ETHTOOL_LINK_MODE_MASK_NBITS);
-		if (linkmode_intersects(ext, src)) {
-			/* src mask goes beyond bit 31 */
-			retval = false;
-		}
-	}
 	*legacy_u32 = src[0];
-	return retval;
+	return find_next_bit(src, __ETHTOOL_LINK_MODE_MASK_NBITS, 32) ==
+		__ETHTOOL_LINK_MODE_MASK_NBITS;
 }
 EXPORT_SYMBOL(ethtool_convert_link_mode_to_legacy_u32);
 
-- 
2.30.2

