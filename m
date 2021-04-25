Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F2F4536A659
	for <lists+netdev@lfdr.de>; Sun, 25 Apr 2021 11:53:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229916AbhDYJxq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 25 Apr 2021 05:53:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229551AbhDYJxq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 25 Apr 2021 05:53:46 -0400
Received: from mail-lf1-x12d.google.com (mail-lf1-x12d.google.com [IPv6:2a00:1450:4864:20::12d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A330C061756
        for <netdev@vger.kernel.org>; Sun, 25 Apr 2021 02:53:06 -0700 (PDT)
Received: by mail-lf1-x12d.google.com with SMTP id 124so2790685lff.5
        for <netdev@vger.kernel.org>; Sun, 25 Apr 2021 02:53:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=flodin-me.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=dLiKSbWhlGZSUV+iRQ1/IADQ4m+lyxFqf/acvVJO7Ow=;
        b=R9xZj8rrHG3dgWOtGjP0GhSUVHHdkJGQC80qj4PQBNkNnEPfWQU396pFvqbd7/Q6MU
         Yuo4526G209AQorct9gyp5PzvWsrM6YsLE2BltIQVF0NGKfw/n4/sy3n71uN0sZpTC4R
         QoQ/T49fj8/hl4ssiNNHxxNz2t2qRoXqJTGC2/w9fvkUpRb7iOVCJKqveQNFEaG7FCma
         77/1PHb0ECjbgD9FGj0+fP80IJwgW88PKe0QFp3RJQCpuOne7UnqcQuL6T111G1eWqUo
         xS6Zx6p6LmB+HoFuy5OBZhotDvfaHKX6WF3ua0wDN65uHc/nK+LYdvcLmbcqfqAACwF/
         Df4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=dLiKSbWhlGZSUV+iRQ1/IADQ4m+lyxFqf/acvVJO7Ow=;
        b=fWgY6KPcX0Yl8BZxXQj2vfB3pS2O+vp0Usd+790FldqSKaNYwbKa+5VqSTfe4J5y/+
         7nsIkekc/NLDbP6HSp/Z2rdsCkiKMOfZsY4jZLvygcOg3my6vkbTa+vOmo7mzesgelf9
         VtONX29mvIMw0hG+EnzHaolZlz/IS93n4vjbMvXeH2Uzh47gGln+fF093SI5HcagzEy1
         bwBz351fxx2r8xvJHM64txyw1pYdFqND1UF/MFgJJJWuLLCE9BKdJN/ukVG/KJMnrV4z
         UDXnJ+03aBLRdh8qF4GWwl6Y/+37Id3mASsn6mut372dYvGIceOcSmAHaHKm0lxLuowh
         oehw==
X-Gm-Message-State: AOAM533wumhErYHnxeatjZVqwPHOfCP4lHH9dLJS1D9nxRIbE/6GhW5/
        EyQuF8+Isnw5Rm37lDIiKy7TYg==
X-Google-Smtp-Source: ABdhPJwvWNz+OiL2ITuFiBhiru4qjxH3CNpJAkdK+pQ7UamPwP0KA4gyTF+N/wi4hLOq1EdauD4Qrw==
X-Received: by 2002:a05:6512:14a:: with SMTP id m10mr9270442lfo.74.1619344384761;
        Sun, 25 Apr 2021 02:53:04 -0700 (PDT)
Received: from trillian.bjorktomta.lan (h-158-174-77-132.NA.cust.bahnhof.se. [158.174.77.132])
        by smtp.gmail.com with ESMTPSA id x41sm1055669lfa.236.2021.04.25.02.53.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 25 Apr 2021 02:53:04 -0700 (PDT)
From:   Erik Flodin <erik@flodin.me>
Cc:     Erik Flodin <erik@flodin.me>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-can@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH] can: proc: fix rcvlist_* header alignment on 64-bit system
Date:   Sun, 25 Apr 2021 11:52:36 +0200
Message-Id: <20210425095249.177588-1-erik@flodin.me>
X-Mailer: git-send-email 2.31.0
In-Reply-To: <20210425090751.2jqj4yqx5ztyqhvg@pengutronix.de>
References: <20210425090751.2jqj4yqx5ztyqhvg@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Before this fix, the function and userdata columns weren't aligned:
  device   can_id   can_mask  function  userdata   matches  ident
   vcan0  92345678  9fffffff  0000000000000000  0000000000000000         0  raw
   vcan0     123    00000123  0000000000000000  0000000000000000         0  raw

After the fix they are:
  device   can_id   can_mask      function          userdata       matches  ident
   vcan0  92345678  9fffffff  0000000000000000  0000000000000000         0  raw
   vcan0     123    00000123  0000000000000000  0000000000000000         0  raw

Signed-off-by: Erik Flodin <erik@flodin.me>
---
 net/can/proc.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/net/can/proc.c b/net/can/proc.c
index 5ea8695f507e..9c341ccd097c 100644
--- a/net/can/proc.c
+++ b/net/can/proc.c
@@ -201,12 +201,14 @@ static void can_print_rcvlist(struct seq_file *m, struct hlist_head *rx_list,
 
 static void can_print_recv_banner(struct seq_file *m)
 {
+	const char *pad = sizeof(void *) == 8 ? "    " : "";
+
 	/*
 	 *                  can1.  00000000  00000000  00000000
 	 *                 .......          0  tp20
 	 */
-	seq_puts(m, "  device   can_id   can_mask  function"
-			"  userdata   matches  ident\n");
+	seq_printf(m, "  device   can_id   can_mask  %sfunction%s  %suserdata%s   matches  ident\n",
+		   pad, pad, pad, pad);
 }
 
 static int can_stats_proc_show(struct seq_file *m, void *v)
-- 
2.31.0

