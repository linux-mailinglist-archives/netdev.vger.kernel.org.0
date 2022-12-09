Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D4D27647EA4
	for <lists+netdev@lfdr.de>; Fri,  9 Dec 2022 08:35:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229863AbiLIHfB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Dec 2022 02:35:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229550AbiLIHfA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Dec 2022 02:35:00 -0500
Received: from mxhk.zte.com.cn (mxhk.zte.com.cn [63.216.63.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51BBA195;
        Thu,  8 Dec 2022 23:34:59 -0800 (PST)
Received: from mse-fl1.zte.com.cn (unknown [10.5.228.132])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mxhk.zte.com.cn (FangMail) with ESMTPS id 4NT2q60Hj0z8R039;
        Fri,  9 Dec 2022 15:34:58 +0800 (CST)
Received: from szxlzmapp07.zte.com.cn ([10.5.230.251])
        by mse-fl1.zte.com.cn with SMTP id 2B97Yk6Y033797;
        Fri, 9 Dec 2022 15:34:46 +0800 (+08)
        (envelope-from yang.yang29@zte.com.cn)
Received: from mapi (szxlzmapp04[null])
        by mapi (Zmail) with MAPI id mid14;
        Fri, 9 Dec 2022 15:34:49 +0800 (CST)
Date:   Fri, 9 Dec 2022 15:34:49 +0800 (CST)
X-Zmail-TransId: 2b066392e519360cae99
X-Mailer: Zmail v1.0
Message-ID: <202212091534493764895@zte.com.cn>
Mime-Version: 1.0
From:   <yang.yang29@zte.com.cn>
To:     <dchickles@marvell.com>
Cc:     <sburla@marvell.com>, <fmanlunas@marvell.com>,
        <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <xu.panda@zte.com.cn>,
        <yang.yang29@zte.com.cn>
Subject: =?UTF-8?B?W1BBVENIIG5ldC1uZXh0IHYyXSBsaXF1aWRpbzogdXNlIHN0cnNjcHkoKSB0byBpbnN0ZWFkIG9mIHN0cm5jcHkoKQ==?=
Content-Type: text/plain;
        charset="UTF-8"
X-MAIL: mse-fl1.zte.com.cn 2B97Yk6Y033797
X-Fangmail-Gw-Spam-Type: 0
X-FangMail-Miltered: at cgslv5.04-192.168.250.137.novalocal with ID 6392E522.000 by FangMail milter!
X-FangMail-Envelope: 1670571298/4NT2q60Hj0z8R039/6392E522.000/10.5.228.132/[10.5.228.132]/mse-fl1.zte.com.cn/<yang.yang29@zte.com.cn>
X-Fangmail-Anti-Spam-Filtered: true
X-Fangmail-MID-QID: 6392E522.000/4NT2q60Hj0z8R039
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
That's now the recommended way to copy NUL terminated strings.

Signed-off-by: Xu Panda <xu.panda@zte.com.cn>
Signed-off-by: Yang Yang <yang.yang29@zte.com>
---
change for v2
 - change the subject, replace linux-next with net-next.
---
 drivers/net/ethernet/cavium/liquidio/octeon_console.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/cavium/liquidio/octeon_console.c b/drivers/net/ethernet/cavium/liquidio/octeon_console.c
index 28feabec8fbb..67c3570f875f 100644
--- a/drivers/net/ethernet/cavium/liquidio/octeon_console.c
+++ b/drivers/net/ethernet/cavium/liquidio/octeon_console.c
@@ -247,8 +247,7 @@ static const struct cvmx_bootmem_named_block_desc
 					struct cvmx_bootmem_named_block_desc,
 					size));

-		strncpy(desc->name, name, sizeof(desc->name));
-		desc->name[sizeof(desc->name) - 1] = 0;
+		strscpy(desc->name, name, sizeof(desc->name));
 		return &oct->bootmem_named_block_desc;
 	} else {
 		return NULL;
@@ -471,8 +470,8 @@ static void output_console_line(struct octeon_device *oct,
 	if (line != &console_buffer[bytes_read]) {
 		console_buffer[bytes_read] = '\0';
 		len = strlen(console->leftover);
-		strncpy(&console->leftover[len], line,
-			sizeof(console->leftover) - len);
+		strscpy(&console->leftover[len], line,
+			sizeof(console->leftover) - len + 1);
 	}
 }

-- 
2.15.2
