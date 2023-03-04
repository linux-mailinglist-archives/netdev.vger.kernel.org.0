Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A633B6AAB3B
	for <lists+netdev@lfdr.de>; Sat,  4 Mar 2023 17:49:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229562AbjCDQtM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 Mar 2023 11:49:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229455AbjCDQtL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 Mar 2023 11:49:11 -0500
Received: from mail.ispras.ru (mail.ispras.ru [83.149.199.84])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 787181A676;
        Sat,  4 Mar 2023 08:49:10 -0800 (PST)
Received: from fpc.. (unknown [46.242.14.200])
        by mail.ispras.ru (Postfix) with ESMTPSA id B9C9244C1023;
        Sat,  4 Mar 2023 16:49:08 +0000 (UTC)
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.ispras.ru B9C9244C1023
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ispras.ru;
        s=default; t=1677948548;
        bh=vA0uddaAF4XkgrzjTMknhDOe+mBtUEC4F4gPVaK/S0k=;
        h=From:To:Cc:Subject:Date:From;
        b=gv57uY8XyHCNo2SNdxOBtVjHHinjaG8id0LpuoJRefFLuKBHZxZ5V+KMUqHqOpaE/
         WKTtB6v/1LYnxpg02YirFjw8uQd5dj+C77e0ztCX9yDUNwVoyWaHzeQBN4Dj8be5qv
         klwglD/CjpjonTWWs1TQB6u43XGUofPGnr/AQb5g=
From:   Fedor Pchelkin <pchelkin@ispras.ru>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Fedor Pchelkin <pchelkin@ispras.ru>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Alexey Khoroshilov <khoroshilov@ispras.ru>,
        lvc-project@linuxtesting.org
Subject: [PATCH] nfc: change order inside nfc_se_io error path
Date:   Sat,  4 Mar 2023 19:48:44 +0300
Message-Id: <20230304164844.133931-1-pchelkin@ispras.ru>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

cb_context should be freed on error paths in nfc_se_io as stated by commit
25ff6f8a5a3b ("nfc: fix memory leak of se_io context in nfc_genl_se_io").

Make the error path in nfc_se_io unwind everything in reverse order, i.e.
free the cb_context after unlocking the device.

No functional changes intended - only adjusting to good coding practice.

Suggested-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Signed-off-by: Fedor Pchelkin <pchelkin@ispras.ru>
---
 net/nfc/netlink.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/nfc/netlink.c b/net/nfc/netlink.c
index 348bf561bc9f..b9264e730fd9 100644
--- a/net/nfc/netlink.c
+++ b/net/nfc/netlink.c
@@ -1446,8 +1446,8 @@ static int nfc_se_io(struct nfc_dev *dev, u32 se_idx,
 	return rc;
 
 error:
-	kfree(cb_context);
 	device_unlock(&dev->dev);
+	kfree(cb_context);
 	return rc;
 }
 
-- 
2.34.1

