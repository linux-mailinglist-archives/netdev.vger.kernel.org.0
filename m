Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7B6F96888A3
	for <lists+netdev@lfdr.de>; Thu,  2 Feb 2023 21:58:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233060AbjBBU6W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Feb 2023 15:58:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232658AbjBBU6V (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Feb 2023 15:58:21 -0500
Received: from smtp.smtpout.orange.fr (smtp-28.smtpout.orange.fr [80.12.242.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 239B71F5DD
        for <netdev@vger.kernel.org>; Thu,  2 Feb 2023 12:58:18 -0800 (PST)
Received: from pop-os.home ([86.243.2.178])
        by smtp.orange.fr with ESMTPA
        id NgespaMSp7c7GNgetpCoUX; Thu, 02 Feb 2023 21:58:16 +0100
X-ME-Helo: pop-os.home
X-ME-Auth: Y2hyaXN0b3BoZS5qYWlsbGV0QHdhbmFkb28uZnI=
X-ME-Date: Thu, 02 Feb 2023 21:58:16 +0100
X-ME-IP: 86.243.2.178
From:   Christophe JAILLET <christophe.jaillet@wanadoo.fr>
To:     Loic Poulain <loic.poulain@linaro.org>,
        Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        wcn36xx@lists.infradead.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH net-next] wifi: wcn36xx: Slightly optimize PREPARE_HAL_BUF()
Date:   Thu,  2 Feb 2023 21:58:10 +0100
Message-Id: <7d8ab7fee45222cdbaf80c507525f2d3941587c1.1675371372.git.christophe.jaillet@wanadoo.fr>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In most (likely all) cases, INIT_HAL_MSG() is called before
PREPARE_HAL_BUF().
In such cases calling memset() is useless because:
   msg_body.header.len = sizeof(msg_body)

So, instead of writing twice the memory, we just have a sanity check to
make sure that some potential trailing memory is zeroed.
It even gives the opportunity to see that by itself and optimize it away.

Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
---
 drivers/net/wireless/ath/wcn36xx/smd.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/wcn36xx/smd.c b/drivers/net/wireless/ath/wcn36xx/smd.c
index 566f0b9c1584..17e1919d1cd8 100644
--- a/drivers/net/wireless/ath/wcn36xx/smd.c
+++ b/drivers/net/wireless/ath/wcn36xx/smd.c
@@ -475,8 +475,8 @@ static int wcn36xx_smd_send_and_wait(struct wcn36xx *wcn, size_t len)
 
 #define PREPARE_HAL_BUF(send_buf, msg_body) \
 	do {							\
-		memset(send_buf, 0, msg_body.header.len);	\
-		memcpy(send_buf, &msg_body, sizeof(msg_body));	\
+		memcpy_and_pad(send_buf, msg_body.header.len,	\
+			       &msg_body, sizeof(msg_body), 0);	\
 	} while (0)						\
 
 #define PREPARE_HAL_PTT_MSG_BUF(send_buf, p_msg_body) \
-- 
2.34.1

