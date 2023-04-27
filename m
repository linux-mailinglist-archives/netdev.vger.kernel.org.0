Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 95BD56F06C4
	for <lists+netdev@lfdr.de>; Thu, 27 Apr 2023 15:40:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243520AbjD0NkH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Apr 2023 09:40:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243215AbjD0NkG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Apr 2023 09:40:06 -0400
Received: from smtp.smtpout.orange.fr (smtp-25.smtpout.orange.fr [80.12.242.25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97AC1E75
        for <netdev@vger.kernel.org>; Thu, 27 Apr 2023 06:40:04 -0700 (PDT)
Received: from pop-os.home ([86.243.2.178])
        by smtp.orange.fr with ESMTPA
        id s1qrpS4bWFuuVs1qrpeFzo; Thu, 27 Apr 2023 15:40:02 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=wanadoo.fr;
        s=t20230301; t=1682602802;
        bh=xNHjnfO6hqQ3RjIXVzoEC16ztSod8ZRX8nPzacvbSXU=;
        h=From:To:Cc:Subject:Date;
        b=T6R7lunp4aeEdC38rs8pLq+riXSql4dd2rfJn1OPA6zKIP0oGQAEzcJ9RsRw4MKZI
         JutbsjTMy3/kgcUq3FQ8RbpZhKYeq+teYscvXqMe2A/FvkbmBiLxrKnkVE3oRWOhkT
         ndCnZXXV6MrOyiSvpGPhP/kfF5FvwA8mI1RCoLDKmlTBT/Es7o+ztiRZs2DLVpdH+i
         VPW5qZZc+OyAa8zc7pbzEn1zr4qArAGS9wnGxmOa5JhBUCyBEAwSi/w7FFXUkVV4CP
         ZdGQMo7WxI2gXtnqF9l2GrnvFp4UzKRI/vSjYOLihqhEYlmsfNIpjprkCYMrY/w0F+
         e77wdyihPG4nQ==
X-ME-Helo: pop-os.home
X-ME-Auth: Y2hyaXN0b3BoZS5qYWlsbGV0QHdhbmFkb28uZnI=
X-ME-Date: Thu, 27 Apr 2023 15:40:02 +0200
X-ME-IP: 86.243.2.178
From:   Christophe JAILLET <christophe.jaillet@wanadoo.fr>
To:     Karsten Keil <isdn@linux-pingi.de>
Cc:     linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        netdev@vger.kernel.org
Subject: [PATCH] mISDN: Use list_count_nodes()
Date:   Thu, 27 Apr 2023 15:39:48 +0200
Message-Id: <886a6fe86cfc3d787a2e3a5062ce8bd92323ed66.1682602766.git.christophe.jaillet@wanadoo.fr>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

count_list_member() really looks the same as list_count_nodes(), so use the
latter instead of hand writing it.

The first one return an int and the other a size_t, but that should be
fine. It is really unlikely that we get so many parties in a conference.

Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
---
Un-tested
---
 drivers/isdn/mISDN/dsp_cmx.c | 15 ++-------------
 1 file changed, 2 insertions(+), 13 deletions(-)

diff --git a/drivers/isdn/mISDN/dsp_cmx.c b/drivers/isdn/mISDN/dsp_cmx.c
index 6d2088fbaf69..357b87592eb4 100644
--- a/drivers/isdn/mISDN/dsp_cmx.c
+++ b/drivers/isdn/mISDN/dsp_cmx.c
@@ -141,17 +141,6 @@
 /*#define CMX_DELAY_DEBUG * gives rx-buffer delay overview */
 /*#define CMX_TX_DEBUG * massive read/write on tx-buffer with content */
 
-static inline int
-count_list_member(struct list_head *head)
-{
-	int			cnt = 0;
-	struct list_head	*m;
-
-	list_for_each(m, head)
-		cnt++;
-	return cnt;
-}
-
 /*
  * debug cmx memory structure
  */
@@ -1672,7 +1661,7 @@ dsp_cmx_send(void *arg)
 		mustmix = 0;
 		members = 0;
 		if (conf) {
-			members = count_list_member(&conf->mlist);
+			members = list_count_nodes(&conf->mlist);
 #ifdef CMX_CONF_DEBUG
 			if (conf->software && members > 1)
 #else
@@ -1695,7 +1684,7 @@ dsp_cmx_send(void *arg)
 	/* loop all members that require conference mixing */
 	list_for_each_entry(conf, &conf_ilist, list) {
 		/* count members and check hardware */
-		members = count_list_member(&conf->mlist);
+		members = list_count_nodes(&conf->mlist);
 #ifdef CMX_CONF_DEBUG
 		if (conf->software && members > 1) {
 #else
-- 
2.34.1

