Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 841D5246116
	for <lists+netdev@lfdr.de>; Mon, 17 Aug 2020 10:48:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728563AbgHQIsa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Aug 2020 04:48:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728110AbgHQIqw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Aug 2020 04:46:52 -0400
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DED92C061388;
        Mon, 17 Aug 2020 01:46:50 -0700 (PDT)
Received: by mail-pj1-x1043.google.com with SMTP id t6so7371004pjr.0;
        Mon, 17 Aug 2020 01:46:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=qv4GC02qge+8WBoWhKMhI0GaJq0fE5w5WlMXDX1eMMA=;
        b=NaUOnn94Oxlt73OY55Dyc1+uEkT/dBQ/+L2CTBGAgVWzTpBdn47zH8qmEudLhmna7X
         dcwGXsw4paLNVVFrB2ds6Wr0uhNGOP1tdXXuNJkTLur0K+UT6VUI8uInpXogdfY5paXa
         o9WVwSA5OnVBnn4uRhZmcJAaqtuI++RO/RIR3sEyu1ZIfrV0EyY7prBUAAUtbLqROhwp
         a5hDiZHHvPN1aXuvbBPUuLA0XjZia/j27ogqc48d6213fwIVhEej4jg6W/uCnt15nvp8
         8/Fvken5fNMQQ87nWTvrB50ynVIHC68tzXCu5GlpoOpMVaGrpVqetRpCQTaBjyFP86eG
         Uolw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=qv4GC02qge+8WBoWhKMhI0GaJq0fE5w5WlMXDX1eMMA=;
        b=hneO4eX1BJGV1o7KtOVX208rrkrYIhqHLF57Z5gb98uGml606hinRZEqpY6N1JcXfT
         9y1TneA+1fK6vT7PQFICyZ8Qk6kqATcHEKH6bFDRsiQPeRXNMfvTIMckYDJ4VvJGuON7
         +pAZx4HBRuvq5VP4ukAEMZzt3Vg5sMq5SgCE+V4/g7Li3uJVSTf5w/wA3n+mYII84eFH
         Rs/HQe5hE2X87BiOvEdwAY1T5pMPYZEMUZSNf1xr+28afk3v8lL/wcUPVUxvseaas88N
         PHhwZHvULAyVeaTZM+tA+NCZG8QxO0oa7grlM7CPRajcksW49CiiMsXK4YXG3AVX8vCn
         XZ9Q==
X-Gm-Message-State: AOAM531f2DHLUfvoXG6J6ZWy/tpElc4RmW90UUrxTEDMNEaqPkTonl1s
        n96EZ2KLweUfs6lwUcFI9tU=
X-Google-Smtp-Source: ABdhPJxe68nIhAqCAGWEtJuWFCHemuIjuNfWIKlLNXf06tV5CCXtH88GTgrO4d7VOTnvNGRe1uWjcg==
X-Received: by 2002:a17:90a:c781:: with SMTP id gn1mr11460864pjb.151.1597654010425;
        Mon, 17 Aug 2020 01:46:50 -0700 (PDT)
Received: from localhost.localdomain ([49.207.202.98])
        by smtp.gmail.com with ESMTPSA id ml18sm16418443pjb.43.2020.08.17.01.46.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Aug 2020 01:46:49 -0700 (PDT)
From:   Allen Pais <allen.cryptic@gmail.com>
To:     m.grzeschik@pengutronix.de, davem@davemloft.net, paulus@samba.org,
        oliver@neukum.org, woojung.huh@microchip.com, petkan@nucleusys.com
Cc:     keescook@chromium.org, netdev@vger.kernel.org,
        linux-ppp@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org, Allen Pais <allen.lkml@gmail.com>,
        Romain Perier <romain.perier@gmail.com>
Subject: [PATCH 2/9] net: ppp: convert tasklets to use new tasklet_setup() API
Date:   Mon, 17 Aug 2020 14:16:07 +0530
Message-Id: <20200817084614.24263-6-allen.cryptic@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200817084614.24263-1-allen.cryptic@gmail.com>
References: <20200817084614.24263-1-allen.cryptic@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Allen Pais <allen.lkml@gmail.com>

In preparation for unconditionally passing the
struct tasklet_struct pointer to all tasklet
callbacks, switch to using the new tasklet_setup()
and from_tasklet() to pass the tasklet pointer explicitly.

Signed-off-by: Romain Perier <romain.perier@gmail.com>
Signed-off-by: Allen Pais <allen.lkml@gmail.com>
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
2.17.1

