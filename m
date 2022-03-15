Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0205C4D9597
	for <lists+netdev@lfdr.de>; Tue, 15 Mar 2022 08:49:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345633AbiCOHuU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Mar 2022 03:50:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345578AbiCOHuT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Mar 2022 03:50:19 -0400
Received: from smtpbg153.qq.com (smtpbg153.qq.com [13.245.218.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B92B12AD0
        for <netdev@vger.kernel.org>; Tue, 15 Mar 2022 00:49:06 -0700 (PDT)
X-QQ-mid: bizesmtp66t1647330538t2e5fnkr
Received: from localhost.localdomain ( [58.240.82.166])
        by bizesmtp.qq.com (ESMTP) with 
        id ; Tue, 15 Mar 2022 15:48:52 +0800 (CST)
X-QQ-SSF: 01400000002000D0H000B00A0000000
X-QQ-FEAT: 2/V7nd32TUNNL9VZeRdmamHW/40ftL9nCkS+SA2Cjt/VReeEKtayf5eld+pEV
        S4ppc/UoEjWTLGfmglppM+tlrceAEQKUT8GYjsIS12xW8iba2jYmD1uiIvf192fiOtMtPEC
        YmvtbesERPpeWv/c+7il+ErWeI48CQ29Id0af1WL2j9uc8X4IS1SNQ4eQW+LGYHNqnEdBIA
        w04yePwuzg+XufdJPMJS7dni4c7k8ALBFJDuUZN8k8+PZvjhjbXtDvoQn6aWeSwpWL8KBVn
        Tz8S5IFOUZo8TDYAA08sE/IXH+t65ZqrvyXWTf22Q4k8Es8qEE61J1HI+7HD7hOVez3lPJu
        jryYjzT43Ney0ju5jnA02tpZErfIx0ha3o6OKCP
X-QQ-GoodBg: 2
From:   Meng Tang <tangmeng@uniontech.com>
To:     t.sailer@alumni.ethz.ch, davem@davemloft.net, kuba@kernel.org
Cc:     linux-hams@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Meng Tang <tangmeng@uniontech.com>
Subject: [PATCH] hamradio: Fix wrong assignment of 'bbc->cfg.loopback'
Date:   Tue, 15 Mar 2022 15:48:51 +0800
Message-Id: <20220315074851.6456-1-tangmeng@uniontech.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: bizesmtp:uniontech.com:qybgforeign:qybgforeign1
X-QQ-Bgrelay: 1
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In file hamradio/baycom_epp.c, the baycom_setmode interface, there
is a problem with improper use of strstr.

Suppose that when modestr="noloopback", both conditions which are
'strstr(modestr,"noloopback")' and 'strstr(modestr,"loopback")'
will be true(not NULL), this lead the bc->cfg.loopback variable
will be first assigned to 0, and then reassigned to 1.

This will cause 'bc->cfg.loopback = 0' will never take effect. That
obviously violates the logic of the code, so adjust the order of
their execution to solve the problem.

Signed-off-by: Meng Tang <tangmeng@uniontech.com>
---
 drivers/net/hamradio/baycom_epp.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/hamradio/baycom_epp.c b/drivers/net/hamradio/baycom_epp.c
index a03d0b474641..36e6de42ae77 100644
--- a/drivers/net/hamradio/baycom_epp.c
+++ b/drivers/net/hamradio/baycom_epp.c
@@ -982,10 +982,10 @@ static int baycom_setmode(struct baycom_state *bc, const char *modestr)
 		bc->cfg.extmodem = 0;
 	if (strstr(modestr,"extmodem"))
 		bc->cfg.extmodem = 1;
-	if (strstr(modestr,"noloopback"))
-		bc->cfg.loopback = 0;
 	if (strstr(modestr,"loopback"))
 		bc->cfg.loopback = 1;
+	if (strstr(modestr, "noloopback"))
+		bc->cfg.loopback = 0;
 	if ((cp = strstr(modestr,"fclk="))) {
 		bc->cfg.fclk = simple_strtoul(cp+5, NULL, 0);
 		if (bc->cfg.fclk < 1000000)
-- 
2.20.1



