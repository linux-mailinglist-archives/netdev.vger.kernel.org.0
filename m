Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 20CE92845D6
	for <lists+netdev@lfdr.de>; Tue,  6 Oct 2020 08:12:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727082AbgJFGMa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Oct 2020 02:12:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726022AbgJFGMa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Oct 2020 02:12:30 -0400
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7205FC0613A7
        for <netdev@vger.kernel.org>; Mon,  5 Oct 2020 23:12:30 -0700 (PDT)
Received: by mail-pf1-x443.google.com with SMTP id b26so5064007pff.3
        for <netdev@vger.kernel.org>; Mon, 05 Oct 2020 23:12:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=p0nOeFTTvxchhLDUOUtR4smjW/MrDN1RrdOcfJ9Vqqo=;
        b=lNTDA9o6leiZAV8Sn3Jl4K9rflqqzYaO2W//DuaVB+x0c+nmDe4hK6ZmHNxKs6cCXF
         hxAGCJ5qWPYZE6ntem4M4YIEjnfj8i+1GfVYhD3yCqZyFZHj2iZgEMU9gNK3tUZ1h22D
         0k+XjtQIMxCyD0p3kONYrES2NtPV/WBzmDJxszPiB0/nctGxbQhMsylJ+igLqn5XwLZK
         /ZU6D6NG8oDjtNCcuHOyXinWARRCUYzaxjVON4KAsx+X8ubnLVK5cMkjj8+pP/hJvzGU
         fng/QMk4WXZMO2iMrePmir4PLcAPyl4pw5z9xgHaOv4K2DilMeK+AxIp6ahTUt7joYJK
         RRcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=p0nOeFTTvxchhLDUOUtR4smjW/MrDN1RrdOcfJ9Vqqo=;
        b=sTffn3iWJlD5C1o46MbCpiU8TCOWhSqds3TG7EjwhG5FX+xPnBaGkRwvvVKJ+tYjJU
         zExSMzkJ5awfVVmyZX98r1JiKu/PzupeTmz7H23LkuM+ApaXv75TwhH8PkvulQzUdXeD
         IbtbDwlQPjxiKU5MwHvCiAcFNEqh/K/DIoYu0j4rt8/YGBvNZEquaSnX+O1cwA+NtjrI
         QnKf9vp3qUkWU2C/zgRjaOny4XcmM5p0vIJHSNWbDEfMlaFKxgyL+uyz3zi/M8SbkqJg
         ynBitcv2fcqSnRyPdebll1oVRnHkEJS8w/PG+/w3F0QYARfpVooKpJ08OpXhtw8lwlhc
         sfCg==
X-Gm-Message-State: AOAM531wDKDQW6ZvzF1NkiTM8G7hUrKsR2pL3E8XM9at4aYHqJkLyYfH
        DbWkLIv2N1m55gxI4gyyR3A=
X-Google-Smtp-Source: ABdhPJwTwsRzysboUCzDYQZBJecflXTAmTgMQIpnaHk6oRyeP758cZWfXnnLSSxVzFz3/dq2hlfh2Q==
X-Received: by 2002:a62:7b4a:0:b029:152:4310:a909 with SMTP id w71-20020a627b4a0000b02901524310a909mr2847735pfc.37.1601964750027;
        Mon, 05 Oct 2020 23:12:30 -0700 (PDT)
Received: from localhost.localdomain ([49.207.203.202])
        by smtp.gmail.com with ESMTPSA id c12sm2046410pfj.164.2020.10.05.23.12.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Oct 2020 23:12:29 -0700 (PDT)
From:   Allen Pais <allen.lkml@gmail.com>
To:     davem@davemloft.net
Cc:     m.grzeschik@pengutronix.de, kuba@kernel.org, paulus@samba.org,
        oliver@neukum.org, woojung.huh@microchip.com,
        UNGLinuxDriver@microchip.com, petkan@nucleusys.com,
        netdev@vger.kernel.org, Allen Pais <apais@linux.microsoft.com>,
        Romain Perier <romain.perier@gmail.com>
Subject: [next-next v3 04/10] net: ppp: convert tasklets to use new tasklet_setup() API
Date:   Tue,  6 Oct 2020 11:41:53 +0530
Message-Id: <20201006061159.292340-5-allen.lkml@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201006061159.292340-1-allen.lkml@gmail.com>
References: <20201006061159.292340-1-allen.lkml@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
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
index 29a0917a8..2b66cf301 100644
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
index 0f338752c..86ee5149f 100644
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

