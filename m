Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 29AB763BA18
	for <lists+netdev@lfdr.de>; Tue, 29 Nov 2022 08:02:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229770AbiK2HCn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Nov 2022 02:02:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229449AbiK2HCl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Nov 2022 02:02:41 -0500
Received: from mxhk.zte.com.cn (mxhk.zte.com.cn [63.216.63.35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B450711812;
        Mon, 28 Nov 2022 23:02:37 -0800 (PST)
Received: from mse-fl2.zte.com.cn (unknown [10.5.228.133])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mxhk.zte.com.cn (FangMail) with ESMTPS id 4NLtZL6Kz8z4xVnd;
        Tue, 29 Nov 2022 15:02:34 +0800 (CST)
Received: from szxlzmapp02.zte.com.cn ([10.5.231.79])
        by mse-fl2.zte.com.cn with SMTP id 2AT71vsp049656;
        Tue, 29 Nov 2022 15:02:26 +0800 (+08)
        (envelope-from yang.yang29@zte.com.cn)
Received: from mapi (szxlzmapp02[null])
        by mapi (Zmail) with MAPI id mid14;
        Tue, 29 Nov 2022 15:02:28 +0800 (CST)
Date:   Tue, 29 Nov 2022 15:02:28 +0800 (CST)
X-Zmail-TransId: 2b046385ae847e71f525
X-Mailer: Zmail v1.0
Message-ID: <202211291502286285262@zte.com.cn>
Mime-Version: 1.0
From:   <yang.yang29@zte.com.cn>
To:     <peppe.cavallaro@st.com>
Cc:     <alexandre.torgue@foss.st.com>, <joabreu@synopsys.com>,
        <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <mcoquelin.stm32@gmail.com>,
        <netdev@vger.kernel.org>,
        <linux-stm32@st-md-mailman.stormreply.com>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <xu.panda@zte.com.cn>,
        <yang.yang29@zte.com.cn>
Subject: =?UTF-8?B?W1BBVENIIGxpbnV4LW5leHQgdjJdIG5ldDogc3RtbWFjOiB1c2Ugc3lzZnNfc3RyZXEoKSBpbnN0ZWFkIG9mIHN0cm5jbXAoKQ==?=
Content-Type: text/plain;
        charset="UTF-8"
X-MAIL: mse-fl2.zte.com.cn 2AT71vsp049656
X-Fangmail-Gw-Spam-Type: 0
X-FangMail-Miltered: at cgslv5.04-192.168.250.138.novalocal with ID 6385AE8A.000 by FangMail milter!
X-FangMail-Envelope: 1669705354/4NLtZL6Kz8z4xVnd/6385AE8A.000/10.5.228.133/[10.5.228.133]/mse-fl2.zte.com.cn/<yang.yang29@zte.com.cn>
X-Fangmail-Anti-Spam-Filtered: true
X-Fangmail-MID-QID: 6385AE8A.000/4NLtZL6Kz8z4xVnd
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,UNPARSEABLE_RELAY autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Xu Panda <xu.panda@zte.com.cn>

Replace the open-code with sysfs_streq().

---
change for v2
 - fix the mistake of redundant parameter.
---
Signed-off-by: Xu Panda <xu.panda@zte.com.cn>
Signed-off-by: Yang Yang <yang.yang29@zte.com>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index 0a9d13d7976f..5ec9f64dadd0 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -7562,31 +7562,31 @@ static int __init stmmac_cmdline_opt(char *str)
 	if (!str || !*str)
 		return 1;
 	while ((opt = strsep(&str, ",")) != NULL) {
-		if (!strncmp(opt, "debug:", 6)) {
+		if (sysfs_streq(opt, "debug:")) {
 			if (kstrtoint(opt + 6, 0, &debug))
 				goto err;
-		} else if (!strncmp(opt, "phyaddr:", 8)) {
+		} else if (sysfs_streq(opt, "phyaddr:")) {
 			if (kstrtoint(opt + 8, 0, &phyaddr))
 				goto err;
-		} else if (!strncmp(opt, "buf_sz:", 7)) {
+		} else if (sysfs_streq(opt, "buf_sz:")) {
 			if (kstrtoint(opt + 7, 0, &buf_sz))
 				goto err;
-		} else if (!strncmp(opt, "tc:", 3)) {
+		} else if (sysfs_streq(opt, "tc:")) {
 			if (kstrtoint(opt + 3, 0, &tc))
 				goto err;
-		} else if (!strncmp(opt, "watchdog:", 9)) {
+		} else if (sysfs_streq(opt, "watchdog:")) {
 			if (kstrtoint(opt + 9, 0, &watchdog))
 				goto err;
-		} else if (!strncmp(opt, "flow_ctrl:", 10)) {
+		} else if (sysfs_streq(opt, "flow_ctrl:")) {
 			if (kstrtoint(opt + 10, 0, &flow_ctrl))
 				goto err;
-		} else if (!strncmp(opt, "pause:", 6)) {
+		} else if (sysfs_streq(opt, "pause:")) {
 			if (kstrtoint(opt + 6, 0, &pause))
 				goto err;
-		} else if (!strncmp(opt, "eee_timer:", 10)) {
+		} else if (sysfs_streq(opt, "eee_timer:")) {
 			if (kstrtoint(opt + 10, 0, &eee_timer))
 				goto err;
-		} else if (!strncmp(opt, "chain_mode:", 11)) {
+		} else if (sysfs_streq(opt, "chain_mode:")) {
 			if (kstrtoint(opt + 11, 0, &chain_mode))
 				goto err;
 		}
-- 
2.15.2
