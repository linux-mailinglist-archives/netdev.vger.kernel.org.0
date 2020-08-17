Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 342FA246138
	for <lists+netdev@lfdr.de>; Mon, 17 Aug 2020 10:52:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728176AbgHQIvr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Aug 2020 04:51:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727007AbgHQIvo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Aug 2020 04:51:44 -0400
Received: from mail-pl1-x644.google.com (mail-pl1-x644.google.com [IPv6:2607:f8b0:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FF99C061388;
        Mon, 17 Aug 2020 01:51:44 -0700 (PDT)
Received: by mail-pl1-x644.google.com with SMTP id k13so7149657plk.13;
        Mon, 17 Aug 2020 01:51:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=YHwU7mJDKeQtuf2nGZDv2FGeDLOAbojJ1CiHYqxaKsE=;
        b=NwDo0yrSQNwwGODAhpyAHCdlmpi//hZOjDK61tg57+GVESEZTVsizg6alKCHmNRTpO
         LO6xlZa58B2CqDtHsbZHOEXREjfqJlHHLi+/2rREVo7qGSvDqUElihhjH8ivo87c17nE
         vcsuiwSXrrxLuynrDkaA40TZFHWlzTIWrOdu701+PZsucTDXEf/H+URfhrJ0eJ9x8x1m
         X/8f36s7uoi3GGa8mONHWYC7NpxncIjCBg79/WYpHKA14v6dmaeUAYJgtJ1f6sxXOZul
         rPL339TSOCn6xiA9F1j8c6VjejT2qatpi4CdKjHwhgDzRE4DnyGq+DscTfCKl3GPtuKW
         42Vg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=YHwU7mJDKeQtuf2nGZDv2FGeDLOAbojJ1CiHYqxaKsE=;
        b=bkZLzXMOI4m4gehJhQVpOGdpPalBtDNuJkkplR1+6JpiRomyji3ZReA2z6mgpA7Frd
         eFB1fkw3jOlDpij1rRArTHjsXuHAxPepDiM+hlb9GwizrtH05h6y7cCWLHuhEbBAyGPg
         aw5OK2A6wHgqZpvsfiymRorsvSC/0AHl0PL1rDsfeG15kiJmYZaVLDKvjQxLWp4Rhae8
         779lZdxXTZQoqFxpaUGX/yjigTAi7dia5CWUvmYe8unSZAskB65C1N4GY3Pq60vbAvFw
         1+pgUKRIle0yk3dClVDj+TA8GKk0tEVrLecnF5cNTs9y80vVPjt3ILpJw6GNehUcduvt
         A6Fw==
X-Gm-Message-State: AOAM530ZuVbchzT+VwHcEirVceclv3Ahb1MY1wevU0MvX78y2Nd5JmVC
        onL07pyj16WivI7J8IWTK/g=
X-Google-Smtp-Source: ABdhPJwEdFp8CfcoePsDFPhRFMP6EJZ5h2o1f+OZt0pK3aPE3p2eGSCRrwPtC19qyJ7L7cLqbopEWA==
X-Received: by 2002:a17:902:6b05:: with SMTP id o5mr10389378plk.173.1597654303737;
        Mon, 17 Aug 2020 01:51:43 -0700 (PDT)
Received: from localhost.localdomain ([49.207.202.98])
        by smtp.gmail.com with ESMTPSA id b185sm18554863pfg.71.2020.08.17.01.51.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Aug 2020 01:51:43 -0700 (PDT)
From:   Allen Pais <allen.cryptic@gmail.com>
To:     gerrit@erg.abdn.ac.uk, davem@davemloft.net, kuba@kernel.org,
        edumazet@google.com, kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org,
        johannes@sipsolutions.net, alex.aring@gmail.com,
        stefan@datenfreihafen.org, santosh.shilimkar@oracle.com,
        jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us
Cc:     keescook@chromium.org, netdev@vger.kernel.org,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-wpan@vger.kernel.org, linux-rdma@vger.kernel.org,
        linux-s390@vger.kernel.org, Allen Pais <allen.lkml@gmail.com>,
        Romain Perier <romain.perier@gmail.com>
Subject: [PATCH 2/8] net: ipv4: convert tasklets to use new tasklet_setup() API
Date:   Mon, 17 Aug 2020 14:21:14 +0530
Message-Id: <20200817085120.24894-2-allen.cryptic@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200817085120.24894-1-allen.cryptic@gmail.com>
References: <20200817085120.24894-1-allen.cryptic@gmail.com>
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
 net/ipv4/tcp_output.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
index 85ff417bda7f..6afad9b407a1 100644
--- a/net/ipv4/tcp_output.c
+++ b/net/ipv4/tcp_output.c
@@ -883,9 +883,9 @@ static void tcp_tsq_handler(struct sock *sk)
  * transferring tsq->head because tcp_wfree() might
  * interrupt us (non NAPI drivers)
  */
-static void tcp_tasklet_func(unsigned long data)
+static void tcp_tasklet_func(struct tasklet_struct *t)
 {
-	struct tsq_tasklet *tsq = (struct tsq_tasklet *)data;
+	struct tsq_tasklet *tsq = from_tasklet(tsq,  t, tasklet);
 	LIST_HEAD(list);
 	unsigned long flags;
 	struct list_head *q, *n;
@@ -970,9 +970,7 @@ void __init tcp_tasklet_init(void)
 		struct tsq_tasklet *tsq = &per_cpu(tsq_tasklet, i);
 
 		INIT_LIST_HEAD(&tsq->head);
-		tasklet_init(&tsq->tasklet,
-			     tcp_tasklet_func,
-			     (unsigned long)tsq);
+		tasklet_setup(&tsq->tasklet, tcp_tasklet_func);
 	}
 }
 
-- 
2.17.1

