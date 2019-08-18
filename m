Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D31CA918CE
	for <lists+netdev@lfdr.de>; Sun, 18 Aug 2019 20:26:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726945AbfHRS0Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 18 Aug 2019 14:26:16 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:35058 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726005AbfHRS0Q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 18 Aug 2019 14:26:16 -0400
Received: by mail-wm1-f66.google.com with SMTP id l2so1100204wmg.0;
        Sun, 18 Aug 2019 11:26:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=ur3QGWAKmlqcvTKY0sjVTLZcBbPRFu8RJploRDnwy0w=;
        b=rbs88MZrejsH7+8YhPr5ZutOKhmcz9cYoIBKoE8w45QWR5nrrx3f0xyx07gfnzNCYu
         VvYhZDsEeL9pLlZW1a1SeJ2K+bhsd4jEL6lNxVKCaQYC5ysxLpQuciyFVZzPauKXmah9
         I2Z+RNXFqR9/FIoFCeQJ9bxy/BQOv7NmGJR3P6Kn5/mWuTwDihJJjBFJEMyZ9DCXi8hg
         r2nLmYiKUvF2OZQ9rfk3zsKNgjSzSEmLfJna7HTUv9uLhWisHQ+DshCsy2ATwKDYfs1v
         euyN5UAUPhha983Y7Cbuy5J2h/o3O6uSguvKqwddha2MUprqzOgFjMbyPZ+Z2uZFNjop
         vXkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=ur3QGWAKmlqcvTKY0sjVTLZcBbPRFu8RJploRDnwy0w=;
        b=jbABrcD/iH6b9gQlFc5HRCqCXHcyku069UGbVLTcKjyo3DnEUaCWDsA/wBpoFbGLQD
         8VHsOtKPQ7wsaXvHadC39ojz9bsF4YMxgrLLrspWxR8bhcE4sSygz3zkAE2zzUHea2ud
         yE3pmCAKrwfabxM7/Zg1aZ9y+YIpkXxUKGWcDnqJnjQL1epvVGgLaFI3chPszEhV4Uok
         fn+X+/DfMzibbkDcfp8mLolrqk7u+VosIp4rwe/PcZEWrZ0cM5SWQPBFuz8K5DlQJCQd
         EBC4/cbbtc2mhFsgRgclFVl0owb1ze3vzV5B6VBI5XQkLbEWU+3TE+13bEyyYeu97S8U
         /b7w==
X-Gm-Message-State: APjAAAWVBcqVVyxoRfTA/JqVEIzlQiqZMr76abjO8fYfU2Jdz8PTDuKp
        ZPiT1vQUUuTo3f0tZmXMWH8=
X-Google-Smtp-Source: APXvYqzLhtEsLSbHL9YU6BgKFpl+yhPSUTFYHC3C7rR7T7tPbCoYv9PK68LJVnqVENoKRHvvfxyI0Q==
X-Received: by 2002:a1c:4087:: with SMTP id n129mr16446303wma.3.1566152774070;
        Sun, 18 Aug 2019 11:26:14 -0700 (PDT)
Received: from localhost.localdomain ([188.25.91.80])
        by smtp.gmail.com with ESMTPSA id 39sm40831107wrc.45.2019.08.18.11.26.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 18 Aug 2019 11:26:13 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     broonie@kernel.org, h.feurstein@gmail.com, mlichvar@redhat.com,
        richardcochran@gmail.com, andrew@lunn.ch, f.fainelli@gmail.com
Cc:     linux-spi@vger.kernel.org, netdev@vger.kernel.org,
        Vladimir Oltean <olteanv@gmail.com>
Subject: [PATCH spi for-5.4 1/5] spi: Use an abbreviated pointer to ctlr->cur_msg in __spi_pump_messages
Date:   Sun, 18 Aug 2019 21:25:56 +0300
Message-Id: <20190818182600.3047-2-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190818182600.3047-1-olteanv@gmail.com>
References: <20190818182600.3047-1-olteanv@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This helps a bit with line fitting now (the list_first_entry call) as
well as during the next patch which needs to iterate through all
transfers of ctlr->cur_msg so it timestamps them.

Signed-off-by: Vladimir Oltean <olteanv@gmail.com>
---
 drivers/spi/spi.c | 23 ++++++++++++-----------
 1 file changed, 12 insertions(+), 11 deletions(-)

diff --git a/drivers/spi/spi.c b/drivers/spi/spi.c
index aef55acb5ccd..d96e04627982 100644
--- a/drivers/spi/spi.c
+++ b/drivers/spi/spi.c
@@ -1265,8 +1265,9 @@ EXPORT_SYMBOL_GPL(spi_finalize_current_transfer);
  */
 static void __spi_pump_messages(struct spi_controller *ctlr, bool in_kthread)
 {
-	unsigned long flags;
+	struct spi_message *mesg;
 	bool was_busy = false;
+	unsigned long flags;
 	int ret;
 
 	/* Lock queue */
@@ -1325,10 +1326,10 @@ static void __spi_pump_messages(struct spi_controller *ctlr, bool in_kthread)
 	}
 
 	/* Extract head of queue */
-	ctlr->cur_msg =
-		list_first_entry(&ctlr->queue, struct spi_message, queue);
+	mesg = list_first_entry(&ctlr->queue, struct spi_message, queue);
+	ctlr->cur_msg = mesg;
 
-	list_del_init(&ctlr->cur_msg->queue);
+	list_del_init(&mesg->queue);
 	if (ctlr->busy)
 		was_busy = true;
 	else
@@ -1361,7 +1362,7 @@ static void __spi_pump_messages(struct spi_controller *ctlr, bool in_kthread)
 			if (ctlr->auto_runtime_pm)
 				pm_runtime_put(ctlr->dev.parent);
 
-			ctlr->cur_msg->status = ret;
+			mesg->status = ret;
 			spi_finalize_current_message(ctlr);
 
 			mutex_unlock(&ctlr->io_mutex);
@@ -1369,28 +1370,28 @@ static void __spi_pump_messages(struct spi_controller *ctlr, bool in_kthread)
 		}
 	}
 
-	trace_spi_message_start(ctlr->cur_msg);
+	trace_spi_message_start(mesg);
 
 	if (ctlr->prepare_message) {
-		ret = ctlr->prepare_message(ctlr, ctlr->cur_msg);
+		ret = ctlr->prepare_message(ctlr, mesg);
 		if (ret) {
 			dev_err(&ctlr->dev, "failed to prepare message: %d\n",
 				ret);
-			ctlr->cur_msg->status = ret;
+			mesg->status = ret;
 			spi_finalize_current_message(ctlr);
 			goto out;
 		}
 		ctlr->cur_msg_prepared = true;
 	}
 
-	ret = spi_map_msg(ctlr, ctlr->cur_msg);
+	ret = spi_map_msg(ctlr, mesg);
 	if (ret) {
-		ctlr->cur_msg->status = ret;
+		mesg->status = ret;
 		spi_finalize_current_message(ctlr);
 		goto out;
 	}
 
-	ret = ctlr->transfer_one_message(ctlr, ctlr->cur_msg);
+	ret = ctlr->transfer_one_message(ctlr, mesg);
 	if (ret) {
 		dev_err(&ctlr->dev,
 			"failed to transfer one message from queue\n");
-- 
2.17.1

