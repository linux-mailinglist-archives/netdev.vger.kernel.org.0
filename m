Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 672A6654B6E
	for <lists+netdev@lfdr.de>; Fri, 23 Dec 2022 03:59:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235973AbiLWC7E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Dec 2022 21:59:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235854AbiLWC7D (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Dec 2022 21:59:03 -0500
Received: from mxhk.zte.com.cn (mxhk.zte.com.cn [63.216.63.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E6E817413;
        Thu, 22 Dec 2022 18:59:02 -0800 (PST)
Received: from mse-fl2.zte.com.cn (unknown [10.5.228.133])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mxhk.zte.com.cn (FangMail) with ESMTPS id 4NdX2D6Mxrz8R040;
        Fri, 23 Dec 2022 10:59:00 +0800 (CST)
Received: from szxlzmapp03.zte.com.cn ([10.5.231.207])
        by mse-fl2.zte.com.cn with SMTP id 2BN2wlg0065747;
        Fri, 23 Dec 2022 10:58:54 +0800 (+08)
        (envelope-from yang.yang29@zte.com.cn)
Received: from mapi (szxlzmapp02[null])
        by mapi (Zmail) with MAPI id mid14;
        Fri, 23 Dec 2022 10:58:55 +0800 (CST)
Date:   Fri, 23 Dec 2022 10:58:55 +0800 (CST)
X-Zmail-TransId: 2b0463a5196fffffffff833ba8ff
X-Mailer: Zmail v1.0
Message-ID: <202212231058555242869@zte.com.cn>
Mime-Version: 1.0
From:   <yang.yang29@zte.com.cn>
To:     <kvalo@kernel.org>
Cc:     <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <xu.panda@zte.com.cn>,
        <yang.yang29@zte.com.cn>
Subject: =?UTF-8?B?W1BBVENIIG5ldC1uZXh0XSB3bDEyNTE6IHVzZSBzdHJzY3B5KCkgdG8gaW5zdGVhZCBvZiBzdHJuY3B5KCk=?=
Content-Type: text/plain;
        charset="UTF-8"
X-MAIL: mse-fl2.zte.com.cn 2BN2wlg0065747
X-Fangmail-Gw-Spam-Type: 0
X-FangMail-Miltered: at cgslv5.04-192.168.250.137.novalocal with ID 63A51974.001 by FangMail milter!
X-FangMail-Envelope: 1671764340/4NdX2D6Mxrz8R040/63A51974.001/10.5.228.133/[10.5.228.133]/mse-fl2.zte.com.cn/<yang.yang29@zte.com.cn>
X-Fangmail-Anti-Spam-Filtered: true
X-Fangmail-MID-QID: 63A51974.001/4NdX2D6Mxrz8R040
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Xu Panda <xu.panda@zte.com.cn>

The implementation of strscpy() is more robust and safer.
That's now the recommended way to copy NUL-terminated strings.

Signed-off-by: Xu Panda <xu.panda@zte.com.cn>
Signed-off-by: Yang Yang <yang.yang29@zte.com>
---
 drivers/net/wireless/ti/wl1251/acx.c | 9 +--------
 1 file changed, 1 insertion(+), 8 deletions(-)

diff --git a/drivers/net/wireless/ti/wl1251/acx.c b/drivers/net/wireless/ti/wl1251/acx.c
index f78fc3880423..613ddab068c3 100644
--- a/drivers/net/wireless/ti/wl1251/acx.c
+++ b/drivers/net/wireless/ti/wl1251/acx.c
@@ -150,14 +150,7 @@ int wl1251_acx_fw_version(struct wl1251 *wl, char *buf, size_t len)
 	}

 	/* be careful with the buffer sizes */
-	strncpy(buf, rev->fw_version, min(len, sizeof(rev->fw_version)));
-
-	/*
-	 * if the firmware version string is exactly
-	 * sizeof(rev->fw_version) long or fw_len is less than
-	 * sizeof(rev->fw_version) it won't be null terminated
-	 */
-	buf[min(len, sizeof(rev->fw_version)) - 1] = '\0';
+	strscpy(buf, rev->fw_version, len);

 out:
 	kfree(rev);
-- 
2.15.2
