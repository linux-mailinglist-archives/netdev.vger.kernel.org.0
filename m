Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 63C40A97CA
	for <lists+netdev@lfdr.de>; Thu,  5 Sep 2019 03:08:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729366AbfIEBH7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Sep 2019 21:07:59 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:35910 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727789AbfIEBH7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Sep 2019 21:07:59 -0400
Received: by mail-wm1-f67.google.com with SMTP id p13so761829wmh.1;
        Wed, 04 Sep 2019 18:07:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=LHXsVk3IyN3um5OPhmjw4ruCbmDcuCM+w6HNkI9Ksdo=;
        b=B1PhAvGixPRVjsiW1mGbMpcULZkAy+2e9WSwPKWY7vgYXk2j5kWCGJySwSybr396/E
         HQkT6H8gxu2KBAaNsaXs8X+jUkaX3n3Cpa0Ff7zynceGc51MiEiNLJY4UHH+RDXQeiAD
         GCGPyBeS/22oecHZ+IZE3QqGYtMMEt0rjTyFpuyU4d8Rf9fq7alfzCv4+in6g3t5vx//
         V+3osQJOgwBGFoYshk6CzlTV6iMXepgUAJRONDQZpudxDaKE9eLQ8wF6o0OyfrZCE7TJ
         x4T5GDyU6KlJGX6hZmfDSgkwlDKUh6qKhaC9A7SkOgrGbS/xsybdubXCWXtMBTmefPuO
         QGHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=LHXsVk3IyN3um5OPhmjw4ruCbmDcuCM+w6HNkI9Ksdo=;
        b=Gy3xLzXnGHmzcSJ032Q0zRjfVNcDIcTS2wnGAmLR/pBnrSbL9bbQfHewnIhXR3SJUF
         SuQcOEURmVVdWfoqJxhh+E7OKVXqszUbW85I65qMmk5zGze46XEcwFuCt7MXRszL+zyh
         JxhI/TOW+KLgvnV3VRgMqq1tJJ60tLbZnNtSRJPuADyOerBX8B9KzJlOO/G8E2IIozKk
         9QQsJlHArxKQRqs4sns4qwKTYYPESCn7Z0XIQL6y3aDPTR+MtJgS5o0lHckapfq9a2fM
         Aa/fd11Q+JHSe+WX1GVxs09zGaww9JtC5xMP/YuQ6g0fXPbdQQH1FC9HULsWEnUn6oWe
         ml9A==
X-Gm-Message-State: APjAAAXeG3BKP4/YTwPYvSgXusgS7imbBk+AdXsxYh8/nicoSd6GrwnX
        VN8lK3ZE+Es243QV4pPufNGX7sDU
X-Google-Smtp-Source: APXvYqyS2M3xosAjzb47lbscbO5zq6besjeiN1oZqkGZbRhQOEPJxOzscZfZYb7sxBS+hpkONl3gpA==
X-Received: by 2002:a7b:c4d6:: with SMTP id g22mr681007wmk.21.1567645676931;
        Wed, 04 Sep 2019 18:07:56 -0700 (PDT)
Received: from localhost.localdomain ([86.126.25.232])
        by smtp.gmail.com with ESMTPSA id b15sm670125wmb.28.2019.09.04.18.07.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Sep 2019 18:07:56 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     broonie@kernel.org, h.feurstein@gmail.com, mlichvar@redhat.com,
        richardcochran@gmail.com, andrew@lunn.ch, f.fainelli@gmail.com
Cc:     linux-spi@vger.kernel.org, netdev@vger.kernel.org,
        Vladimir Oltean <olteanv@gmail.com>
Subject: [PATCH v2 1/4] spi: Use an abbreviated pointer to ctlr->cur_msg in __spi_pump_messages
Date:   Thu,  5 Sep 2019 04:01:11 +0300
Message-Id: <20190905010114.26718-2-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190905010114.26718-1-olteanv@gmail.com>
References: <20190905010114.26718-1-olteanv@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This helps a bit with line fitting now (the list_first_entry call) as
well as during the next patch which needs to iterate through all
transfers of ctlr->cur_msg so it timestamps them.

Signed-off-by: Vladimir Oltean <olteanv@gmail.com>
---
Changes in v2:
- Renamed mesg to msg.

 drivers/spi/spi.c | 23 ++++++++++++-----------
 1 file changed, 12 insertions(+), 11 deletions(-)

diff --git a/drivers/spi/spi.c b/drivers/spi/spi.c
index 75ac046cae52..9ce86f761763 100644
--- a/drivers/spi/spi.c
+++ b/drivers/spi/spi.c
@@ -1265,8 +1265,9 @@ EXPORT_SYMBOL_GPL(spi_finalize_current_transfer);
  */
 static void __spi_pump_messages(struct spi_controller *ctlr, bool in_kthread)
 {
-	unsigned long flags;
+	struct spi_message *msg;
 	bool was_busy = false;
+	unsigned long flags;
 	int ret;
 
 	/* Lock queue */
@@ -1325,10 +1326,10 @@ static void __spi_pump_messages(struct spi_controller *ctlr, bool in_kthread)
 	}
 
 	/* Extract head of queue */
-	ctlr->cur_msg =
-		list_first_entry(&ctlr->queue, struct spi_message, queue);
+	msg = list_first_entry(&ctlr->queue, struct spi_message, queue);
+	ctlr->cur_msg = msg;
 
-	list_del_init(&ctlr->cur_msg->queue);
+	list_del_init(&msg->queue);
 	if (ctlr->busy)
 		was_busy = true;
 	else
@@ -1361,7 +1362,7 @@ static void __spi_pump_messages(struct spi_controller *ctlr, bool in_kthread)
 			if (ctlr->auto_runtime_pm)
 				pm_runtime_put(ctlr->dev.parent);
 
-			ctlr->cur_msg->status = ret;
+			msg->status = ret;
 			spi_finalize_current_message(ctlr);
 
 			mutex_unlock(&ctlr->io_mutex);
@@ -1369,28 +1370,28 @@ static void __spi_pump_messages(struct spi_controller *ctlr, bool in_kthread)
 		}
 	}
 
-	trace_spi_message_start(ctlr->cur_msg);
+	trace_spi_message_start(msg);
 
 	if (ctlr->prepare_message) {
-		ret = ctlr->prepare_message(ctlr, ctlr->cur_msg);
+		ret = ctlr->prepare_message(ctlr, msg);
 		if (ret) {
 			dev_err(&ctlr->dev, "failed to prepare message: %d\n",
 				ret);
-			ctlr->cur_msg->status = ret;
+			msg->status = ret;
 			spi_finalize_current_message(ctlr);
 			goto out;
 		}
 		ctlr->cur_msg_prepared = true;
 	}
 
-	ret = spi_map_msg(ctlr, ctlr->cur_msg);
+	ret = spi_map_msg(ctlr, msg);
 	if (ret) {
-		ctlr->cur_msg->status = ret;
+		msg->status = ret;
 		spi_finalize_current_message(ctlr);
 		goto out;
 	}
 
-	ret = ctlr->transfer_one_message(ctlr, ctlr->cur_msg);
+	ret = ctlr->transfer_one_message(ctlr, msg);
 	if (ret) {
 		dev_err(&ctlr->dev,
 			"failed to transfer one message from queue\n");
-- 
2.17.1

