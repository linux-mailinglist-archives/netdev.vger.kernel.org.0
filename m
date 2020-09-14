Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 25408268604
	for <lists+netdev@lfdr.de>; Mon, 14 Sep 2020 09:32:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726192AbgINHcr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Sep 2020 03:32:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726167AbgINHcF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Sep 2020 03:32:05 -0400
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C21CFC061788;
        Mon, 14 Sep 2020 00:32:03 -0700 (PDT)
Received: by mail-pj1-x1044.google.com with SMTP id jw11so4901168pjb.0;
        Mon, 14 Sep 2020 00:32:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=N2MifhL9FQLhmGJY8Ha5tzsG1ZTIi/JoaFltL1GAB/g=;
        b=bNZVNkiitG3u7y0bOklrEdOb6ubON1k6SoTt9JaoOKssxOv3cHn0eokzzGh8NDkDuw
         6niF0OcZF3ZvlMQ1X6uncNNocbrQ/8i0bJs7KAw3PJNSmrmrXmqVIoHgB6XDLy4XUaMr
         yJiGf2HPoCHTK7re1i0KTZMU2G2SwaCNWuwknKrj0TEy4P8BZa99sr2YUs+bPt+/tBcW
         JIMNQ+H0Wh5OkJyLYQorrI06J9gIcsNrtEOFcONSo21MVXacbDBRLlczW2LmS+RO4OJh
         INsp4puEbM19Uy6D2LrA6qkthcRLp9DvJOB5+7snx5LGUb6JlE0Xwq3uRlF68lfqxsQH
         qt8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=N2MifhL9FQLhmGJY8Ha5tzsG1ZTIi/JoaFltL1GAB/g=;
        b=H+jWEd1/Iy+lDvFdoQAonRByCtXLTyfgW24tThSIrCcaNlrGVx8ll3eNuA4e2uPPwh
         zDbZ4SUH/JyQ1H0QNDx75ZAtwqgY3LIr2YMk9ybXEhpcyPqqid3ItCg3zDB7xfspvnL/
         PEndbGsj3FG7c47GCUp3+GGpfCO13Imx2tvAtMcjR86viueVsoyvkcPQgNO5p2N1kjHT
         TOMe6VDKFMGlFvvT6qJy0QWEIf0x43QXw2L71ZI3ofHAUK+VmbG9GbOXlYAPoUYOrUBL
         qu7GCwlKoMaFoEOoe8JuLmla/0ad9PgSUSpk+u6EX/Vpd6LSu3HI5PD+5Yf9cTezSWyv
         Fz/Q==
X-Gm-Message-State: AOAM531Ct4gm30w0fgv9cLdG0w+VnYeneo3K35Ht02tAL2/W3zM0oyvj
        NAye06VKoYb3Hwq88TqnroVgFI3seZQeYw==
X-Google-Smtp-Source: ABdhPJyYLGQ6p8LPlVKOA0weL3Obfh9b11QIf/nkx1OtbY2VikehXbH3ygAc4QTfub06IT9unjxVxA==
X-Received: by 2002:a17:90b:f14:: with SMTP id br20mr12280711pjb.24.1600068723335;
        Mon, 14 Sep 2020 00:32:03 -0700 (PDT)
Received: from localhost.localdomain ([49.207.192.250])
        by smtp.gmail.com with ESMTPSA id o1sm9128626pfg.83.2020.09.14.00.31.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Sep 2020 00:32:02 -0700 (PDT)
From:   Allen Pais <allen.lkml@gmail.com>
To:     davem@davemloft.net
Cc:     m.grzeschik@pengutronix.de, kuba@kernel.org, paulus@samba.org,
        oliver@neukum.org, woojung.huh@microchip.com,
        UNGLinuxDriver@microchip.com, petkan@nucleusys.com,
        netdev@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-ppp@vger.kernel.org, Allen Pais <apais@linux.microsoft.com>,
        Romain Perier <romain.perier@gmail.com>
Subject: [RESEND net-next v2 05/12] net: ppp: convert tasklets to use new tasklet_setup() API
Date:   Mon, 14 Sep 2020 13:01:24 +0530
Message-Id: <20200914073131.803374-6-allen.lkml@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200914073131.803374-1-allen.lkml@gmail.com>
References: <20200914073131.803374-1-allen.lkml@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Allen Pais <apais@linux.microsoft.com>

In preparation for unconditionally passing the
struct tasklet_struct pointer to all tasklet
callbacks, switch to using the new tasklet_setup()
and from_tasklet() to pass the tasklet pointer explicitly.

Signed-off-by: Romain Perier <romain.perier@gmail.com>
Signed-off-by: Allen Pais <apais@linux.microsoft.com>
---
 drivers/net/ppp/ppp_async.c   | 8 ++++----
 drivers/net/ppp/ppp_synctty.c | 8 ++++----
 2 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ppp/ppp_async.c b/drivers/net/ppp/ppp_async.c
index 29a0917a81e6..2b66cf301b0e 100644
--- a/drivers/net/ppp/ppp_async.c
+++ b/drivers/net/ppp/ppp_async.c
@@ -101,7 +101,7 @@ static void ppp_async_input(struct asyncppp *ap, const unsigned char *buf,
 			    char *flags, int count);
 static int ppp_async_ioctl(struct ppp_channel *chan, unsigned int cmd,
 			   unsigned long arg);
-static void ppp_async_process(unsigned long arg);
+static void ppp_async_process(struct tasklet_struct *t);
 
 static void async_lcp_peek(struct asyncppp *ap, unsigned char *data,
 			   int len, int inbound);
@@ -179,7 +179,7 @@ ppp_asynctty_open(struct tty_struct *tty)
 	ap->lcp_fcs = -1;
 
 	skb_queue_head_init(&ap->rqueue);
-	tasklet_init(&ap->tsk, ppp_async_process, (unsigned long) ap);
+	tasklet_setup(&ap->tsk, ppp_async_process);
 
 	refcount_set(&ap->refcnt, 1);
 	init_completion(&ap->dead);
@@ -488,9 +488,9 @@ ppp_async_ioctl(struct ppp_channel *chan, unsigned int cmd, unsigned long arg)
  * to the ppp_generic code, and to tell the ppp_generic code
  * if we can accept more output now.
  */
-static void ppp_async_process(unsigned long arg)
+static void ppp_async_process(struct tasklet_struct *t)
 {
-	struct asyncppp *ap = (struct asyncppp *) arg;
+	struct asyncppp *ap = from_tasklet(ap, t, tsk);
 	struct sk_buff *skb;
 
 	/* process received packets */
diff --git a/drivers/net/ppp/ppp_synctty.c b/drivers/net/ppp/ppp_synctty.c
index 0f338752c38b..86ee5149f4f2 100644
--- a/drivers/net/ppp/ppp_synctty.c
+++ b/drivers/net/ppp/ppp_synctty.c
@@ -90,7 +90,7 @@ static struct sk_buff* ppp_sync_txmunge(struct syncppp *ap, struct sk_buff *);
 static int ppp_sync_send(struct ppp_channel *chan, struct sk_buff *skb);
 static int ppp_sync_ioctl(struct ppp_channel *chan, unsigned int cmd,
 			  unsigned long arg);
-static void ppp_sync_process(unsigned long arg);
+static void ppp_sync_process(struct tasklet_struct *t);
 static int ppp_sync_push(struct syncppp *ap);
 static void ppp_sync_flush_output(struct syncppp *ap);
 static void ppp_sync_input(struct syncppp *ap, const unsigned char *buf,
@@ -177,7 +177,7 @@ ppp_sync_open(struct tty_struct *tty)
 	ap->raccm = ~0U;
 
 	skb_queue_head_init(&ap->rqueue);
-	tasklet_init(&ap->tsk, ppp_sync_process, (unsigned long) ap);
+	tasklet_setup(&ap->tsk, ppp_sync_process);
 
 	refcount_set(&ap->refcnt, 1);
 	init_completion(&ap->dead_cmp);
@@ -480,9 +480,9 @@ ppp_sync_ioctl(struct ppp_channel *chan, unsigned int cmd, unsigned long arg)
  * to the ppp_generic code, and to tell the ppp_generic code
  * if we can accept more output now.
  */
-static void ppp_sync_process(unsigned long arg)
+static void ppp_sync_process(struct tasklet_struct *t)
 {
-	struct syncppp *ap = (struct syncppp *) arg;
+	struct syncppp *ap = from_tasklet(ap, t, tsk);
 	struct sk_buff *skb;
 
 	/* process received packets */
-- 
2.25.1

