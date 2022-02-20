Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A70BE4BCD06
	for <lists+netdev@lfdr.de>; Sun, 20 Feb 2022 08:18:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241196AbiBTGh1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 20 Feb 2022 01:37:27 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:36956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232742AbiBTGh0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 20 Feb 2022 01:37:26 -0500
Received: from smtp.smtpout.orange.fr (smtp06.smtpout.orange.fr [80.12.242.128])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB59C41606
        for <netdev@vger.kernel.org>; Sat, 19 Feb 2022 22:37:04 -0800 (PST)
Received: from pop-os.home ([90.126.236.122])
        by smtp.orange.fr with ESMTPA
        id Lfq8nvjhNuCn2Lfq9nuQtp; Sun, 20 Feb 2022 07:37:02 +0100
X-ME-Helo: pop-os.home
X-ME-Auth: YWZlNiIxYWMyZDliZWIzOTcwYTEyYzlhMmU3ZiQ1M2U2MzfzZDfyZTMxZTBkMTYyNDBjNDJlZmQ3ZQ==
X-ME-Date: Sun, 20 Feb 2022 07:37:02 +0100
X-ME-IP: 90.126.236.122
From:   Christophe JAILLET <christophe.jaillet@wanadoo.fr>
To:     Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>,
        Sean Tranchetti <stranche@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        netdev@vger.kernel.org
Subject: [PATCH] net: qualcomm: rmnet: Use skb_put_zero() to simplify code
Date:   Sun, 20 Feb 2022 07:36:59 +0100
Message-Id: <8abfe32db956f335d65638dfafdd3577ab6baf0e.1645338968.git.christophe.jaillet@wanadoo.fr>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use skb_put_zero() instead of hand-writing it. This saves a few lines of
code and is more readable.

Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
---
 drivers/net/ethernet/qualcomm/rmnet/rmnet_map_data.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/qualcomm/rmnet/rmnet_map_data.c b/drivers/net/ethernet/qualcomm/rmnet/rmnet_map_data.c
index 3676976c875b..ba194698cc14 100644
--- a/drivers/net/ethernet/qualcomm/rmnet/rmnet_map_data.c
+++ b/drivers/net/ethernet/qualcomm/rmnet/rmnet_map_data.c
@@ -298,7 +298,6 @@ struct rmnet_map_header *rmnet_map_add_map_header(struct sk_buff *skb,
 {
 	struct rmnet_map_header *map_header;
 	u32 padding, map_datalen;
-	u8 *padbytes;
 
 	map_datalen = skb->len - hdrlen;
 	map_header = (struct rmnet_map_header *)
@@ -323,8 +322,7 @@ struct rmnet_map_header *rmnet_map_add_map_header(struct sk_buff *skb,
 	if (skb_tailroom(skb) < padding)
 		return NULL;
 
-	padbytes = (u8 *)skb_put(skb, padding);
-	memset(padbytes, 0, padding);
+	skb_put_zero(skb, padding);
 
 done:
 	map_header->pkt_len = htons(map_datalen + padding);
-- 
2.32.0

