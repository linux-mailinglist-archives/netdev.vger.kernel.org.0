Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A1B0036A7B8
	for <lists+netdev@lfdr.de>; Sun, 25 Apr 2021 16:14:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230242AbhDYOP2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 25 Apr 2021 10:15:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229837AbhDYOP1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 25 Apr 2021 10:15:27 -0400
Received: from mail-lj1-x232.google.com (mail-lj1-x232.google.com [IPv6:2a00:1450:4864:20::232])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 554D7C061574
        for <netdev@vger.kernel.org>; Sun, 25 Apr 2021 07:14:47 -0700 (PDT)
Received: by mail-lj1-x232.google.com with SMTP id u25so22669600ljg.7
        for <netdev@vger.kernel.org>; Sun, 25 Apr 2021 07:14:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=flodin-me.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=+0mM/qMNc4B4VYwhLsNdsBejrnT5u5kkfqn8D/fEEm4=;
        b=JC2rTxg6hoQHZJKsmrEYUaKmG7SdMVTg8/wZVh+AgD7ntzXCOfRFkfrkYkM+Xi+mLG
         SOIwxkIREJRO9C0RWS5OF8GYhusweD0cnoLqA0chF60XXR48pgQMqeMpcCkJUFvM68Ay
         oZsfoheYX0w9/qXwgbIr5kYl3fpmiZMAfJb2UaEh9FithSWHlYWT7xQVF2ryR/ugAzDw
         wF/nPvw1JK3P9GZvUavetRS6z92GCuQ7OjFbuLW88hkCRpChPO7LSvaFZNQ7fCRsLFsb
         /9O7vN4OKilhNUTIp7iicH7wAP9xDIZFgN7eNRWT+ji5cPVRkGuzFGPshgJV08vyCXMT
         IQBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=+0mM/qMNc4B4VYwhLsNdsBejrnT5u5kkfqn8D/fEEm4=;
        b=ZBqL7VAxiNrsiTkp+JmU6SUVepxy6bGtoN2ioW/HPLnjIVj0ZZdGeWEPBiiyA03lNW
         oTehxrHrVic2cSSj9wTaD7SOt4GYic8PUN9lexUhoKNoPtBN+J2k4ZiYwbDpX0QTz2nT
         XTx5dRh2VsXH3eTb7TFB6n1qMIcwbun5GXRnYqaS1DUlKO3LlDGX3l6a/gjeaHwE4psM
         uR+qXv6FqXb9v1z4bBWJ4/hYvnTtd32VjerdraMKpbLeARmUwItJT/kPj6qUbFi5pjlV
         s8rFSxf6YvDuzQCVgYwdAko5J7Ab3wyCKikBY7QrK1DaiaV8hSJTpF8ldEBLskDxEeJ/
         xRhA==
X-Gm-Message-State: AOAM533Z+8TAmL8jh65yUgGewUYxFwdW1vFVM8ICpjjTyEcVxdjwfRNs
        RFloeFaH8hBTA5HN0+Zyw9j/ORDxGl39xYm0
X-Google-Smtp-Source: ABdhPJx2WuBZPzF4VftEf8Qg3Fy2IxTNbrRQ0BzNG12YPYlOgoCBzMcONkGlk7rVDY8tvC09q8CG8w==
X-Received: by 2002:a05:651c:88:: with SMTP id 8mr9612711ljq.268.1619360085736;
        Sun, 25 Apr 2021 07:14:45 -0700 (PDT)
Received: from trillian.bjorktomta.lan (h-158-174-77-132.NA.cust.bahnhof.se. [158.174.77.132])
        by smtp.gmail.com with ESMTPSA id s13sm1182655ljc.26.2021.04.25.07.14.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 25 Apr 2021 07:14:45 -0700 (PDT)
From:   Erik Flodin <erik@flodin.me>
Cc:     Erik Flodin <erik@flodin.me>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-can@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH] can: proc: fix rcvlist_* header alignment on 64-bit system
Date:   Sun, 25 Apr 2021 16:14:35 +0200
Message-Id: <20210425141440.229653-1-erik@flodin.me>
X-Mailer: git-send-email 2.31.0
In-Reply-To: <20210425095249.177588-1-erik@flodin.me>
References: <20210425095249.177588-1-erik@flodin.me>
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
index 5ea8695f507e..ba00619cc3c0 100644
--- a/net/can/proc.c
+++ b/net/can/proc.c
@@ -205,8 +205,10 @@ static void can_print_recv_banner(struct seq_file *m)
 	 *                  can1.  00000000  00000000  00000000
 	 *                 .......          0  tp20
 	 */
-	seq_puts(m, "  device   can_id   can_mask  function"
-			"  userdata   matches  ident\n");
+	if (IS_ENABLED(CONFIG_64BIT))
+		seq_puts(m, "  device   can_id   can_mask      function          userdata       matches  ident\n");
+	else
+		seq_puts(m, "  device   can_id   can_mask  function  userdata   matches  ident\n");
 }
 
 static int can_stats_proc_show(struct seq_file *m, void *v)
-- 
2.31.0

