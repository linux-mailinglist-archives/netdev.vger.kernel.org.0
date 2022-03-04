Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8C2F24CDC5C
	for <lists+netdev@lfdr.de>; Fri,  4 Mar 2022 19:26:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241641AbiCDS0o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Mar 2022 13:26:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241015AbiCDS0o (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Mar 2022 13:26:44 -0500
Received: from mail.ispras.ru (mail.ispras.ru [83.149.199.84])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C19A61D3058;
        Fri,  4 Mar 2022 10:25:55 -0800 (PST)
Received: from hednb3.intra.ispras.ru (unknown [10.10.2.52])
        by mail.ispras.ru (Postfix) with ESMTPSA id 8A61940D4004;
        Fri,  4 Mar 2022 18:25:48 +0000 (UTC)
From:   Alexey Khoroshilov <khoroshilov@ispras.ru>
To:     Karsten Keil <isdn@linux-pingi.de>
Cc:     Alexey Khoroshilov <khoroshilov@ispras.ru>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, ldv-project@linuxtesting.org
Subject: [PATCH] mISDN: Fix memory leak in dsp_pipeline_build()
Date:   Fri,  4 Mar 2022 21:25:36 +0300
Message-Id: <1646418336-12115-1-git-send-email-khoroshilov@ispras.ru>
X-Mailer: git-send-email 2.7.4
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

dsp_pipeline_build() allocates dup pointer by kstrdup(cfg),
but then it updates dup variable by strsep(&dup, "|").
As a result when it calls kfree(dup), the dup variable contains NULL.

Found by Linux Driver Verification project (linuxtesting.org) with SVACE.

Signed-off-by: Alexey Khoroshilov <khoroshilov@ispras.ru>
Fixes: 960366cf8dbb ("Add mISDN DSP")
---
 drivers/isdn/mISDN/dsp_pipeline.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/isdn/mISDN/dsp_pipeline.c b/drivers/isdn/mISDN/dsp_pipeline.c
index e11ca6bbc7f4..c3b2c99b5cd5 100644
--- a/drivers/isdn/mISDN/dsp_pipeline.c
+++ b/drivers/isdn/mISDN/dsp_pipeline.c
@@ -192,7 +192,7 @@ void dsp_pipeline_destroy(struct dsp_pipeline *pipeline)
 int dsp_pipeline_build(struct dsp_pipeline *pipeline, const char *cfg)
 {
 	int found = 0;
-	char *dup, *tok, *name, *args;
+	char *dup, *next, *tok, *name, *args;
 	struct dsp_element_entry *entry, *n;
 	struct dsp_pipeline_entry *pipeline_entry;
 	struct mISDN_dsp_element *elem;
@@ -203,10 +203,10 @@ int dsp_pipeline_build(struct dsp_pipeline *pipeline, const char *cfg)
 	if (!list_empty(&pipeline->list))
 		_dsp_pipeline_destroy(pipeline);
 
-	dup = kstrdup(cfg, GFP_ATOMIC);
+	dup = next = kstrdup(cfg, GFP_ATOMIC);
 	if (!dup)
 		return 0;
-	while ((tok = strsep(&dup, "|"))) {
+	while ((tok = strsep(&next, "|"))) {
 		if (!strlen(tok))
 			continue;
 		name = strsep(&tok, "(");
-- 
2.7.4

