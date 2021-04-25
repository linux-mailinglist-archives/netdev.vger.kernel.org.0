Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF67B36A5E1
	for <lists+netdev@lfdr.de>; Sun, 25 Apr 2021 10:50:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229668AbhDYIuv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 25 Apr 2021 04:50:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229485AbhDYIut (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 25 Apr 2021 04:50:49 -0400
Received: from mail-lf1-x12c.google.com (mail-lf1-x12c.google.com [IPv6:2a00:1450:4864:20::12c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92856C061574
        for <netdev@vger.kernel.org>; Sun, 25 Apr 2021 01:50:05 -0700 (PDT)
Received: by mail-lf1-x12c.google.com with SMTP id y4so43507878lfl.10
        for <netdev@vger.kernel.org>; Sun, 25 Apr 2021 01:50:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=flodin-me.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ujKca+JTuVhPoMhmMDjrRFgqpHT2xUS8hTPaqNfVQbk=;
        b=d9lhczl3w/teld+CtLE7/6A5JlbDCkCfk35gVoI7EajXVuTY9M9jyd2lTBIPZHkLbv
         IvA9i31Z413j20D3Jx2itwQPZrgutd0kZDnr4bzDDpVCTSSYLTBYawvEYvfQYWkAkZzs
         rauUXGTJIZJAo6aroQtOXlquxa9OuFC22D4OngmZFYQuvLhXE4yfWBukIa04+XFfiJYL
         IyX/d/g7hSFoDN7P9KTve0LD/cyfr3t9IUyZ66GB2UZb4c0kTc4kbbjOidnTfHiPz3Zp
         5nhyYe5b7HQCFqvM2pSwHzRfEFJ0f9ZwmUimzqI92qwR5OtIzbBJ/DbNeW5QRlLigKLH
         u3Sw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ujKca+JTuVhPoMhmMDjrRFgqpHT2xUS8hTPaqNfVQbk=;
        b=GqH3I/VJaKdR/2FQLVxMWkijPOy+F4JMHnb50yGELqI/SEuu6FTkYpH+49xeeWYHqr
         aJbhk/6ABBkr0cO3VaYyfkjtaik86SGWKisclNwe0S5OId9w//w51p7tpJcOwG8+FjQf
         l5odrbyuoVDq9Djxbn+6Hu18ZzgFcyyDg1SuyFNaooY55skNbNghZRa8lNPz3/eiHXp7
         O15etj3MgiMkx2N8qj/Y0hoGxr/DhSK+uN8n/mtxfWiKFFg3VkIPeOKf/TlKo13YHIsR
         41GSFfxYS7ja5JUBY5bg5vBYXHVnqi4zfNts/JeIYPiyygJ15wk9Tlg0p6aNgR63+nUD
         L2nA==
X-Gm-Message-State: AOAM530aCqnyuMfmHgtEaQpuZGGndsvsfFAcxdGlgmv8BDtE6SQ+k//8
        z0dmJb8bcicN72GRdZ6voW1mcsBPJpu0jQ==
X-Google-Smtp-Source: ABdhPJyEFgEO40LQBZLQ1wGubsfRoX6hwUac66FyEFgBjq8gcw+EZPfv3dZH+MrDG77B+53EFo5f7w==
X-Received: by 2002:a05:6512:2287:: with SMTP id f7mr8966561lfu.143.1619340604023;
        Sun, 25 Apr 2021 01:50:04 -0700 (PDT)
Received: from trillian.bjorktomta.lan (h-158-174-77-132.NA.cust.bahnhof.se. [158.174.77.132])
        by smtp.gmail.com with ESMTPSA id u6sm1048433lfr.164.2021.04.25.01.50.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 25 Apr 2021 01:50:03 -0700 (PDT)
From:   Erik Flodin <erik@flodin.me>
Cc:     Erik Flodin <erik@flodin.me>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-can@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH] can: fix proc/can/net/rcvlist_* header alignment on 64-bit system
Date:   Sun, 25 Apr 2021 10:49:29 +0200
Message-Id: <20210425084950.171529-1-erik@flodin.me>
X-Mailer: git-send-email 2.31.0
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
 net/can/proc.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/net/can/proc.c b/net/can/proc.c
index 5ea8695f507e..97901e56c429 100644
--- a/net/can/proc.c
+++ b/net/can/proc.c
@@ -205,8 +205,11 @@ static void can_print_recv_banner(struct seq_file *m)
 	 *                  can1.  00000000  00000000  00000000
 	 *                 .......          0  tp20
 	 */
-	seq_puts(m, "  device   can_id   can_mask  function"
-			"  userdata   matches  ident\n");
+	const char *pad = sizeof(void *) == 8 ? "    " : "";
+
+	seq_printf(m, "  device   can_id   can_mask  %sfunction%s"
+		   "  %suserdata%s   matches  ident\n",
+		   pad, pad, pad, pad);
 }
 
 static int can_stats_proc_show(struct seq_file *m, void *v)
-- 
2.31.0

