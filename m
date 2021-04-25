Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A95236A71C
	for <lists+netdev@lfdr.de>; Sun, 25 Apr 2021 14:22:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229707AbhDYMXQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 25 Apr 2021 08:23:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229688AbhDYMXP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 25 Apr 2021 08:23:15 -0400
Received: from mail-lf1-x12d.google.com (mail-lf1-x12d.google.com [IPv6:2a00:1450:4864:20::12d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15C9AC061574
        for <netdev@vger.kernel.org>; Sun, 25 Apr 2021 05:22:36 -0700 (PDT)
Received: by mail-lf1-x12d.google.com with SMTP id x19so53737637lfa.2
        for <netdev@vger.kernel.org>; Sun, 25 Apr 2021 05:22:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=flodin-me.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=vPOHxf1g/MJ8JGhCP7MMJDPjeMZAkcpKsVvEBqYfWjk=;
        b=iFtJ9bCza4lzGnszEQOsRboA3j+Ua9Bgu0sHz9U8DngqOhMD8dd9AccGxI1GDkUj/7
         H2g+Y/2TgUtNVo8ii8KU6McfCfYaC4YVY0eKjZrt5PeIPTqcXCjSauQ8puvc8/os2tFb
         e3IwqdjwDgiTORuwmhvznO2yuprMRrgyR1ZYR9AHlAWSVmzmdspPj0UfOzS3BO/W+eNU
         BDivMFYVnb7kgUHigUL8KISv4obzIzjQwO7VO3c6lAMGaamVVJ7lYcUxlfp2GaKB54YW
         8/n+7V8wD/spwCT7nkpHv+YMHa76Rykk5KykMrgIEU39sVjhRgSAzcuovJgIPpUfKCzk
         Q5Fw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=vPOHxf1g/MJ8JGhCP7MMJDPjeMZAkcpKsVvEBqYfWjk=;
        b=qvBd/ljQ6HtDULokkor+v2hno5TaRIhyiFWVqtNS+BN5fww48ZeqBzu+8VZE0wAOgF
         1+av3qKLE7j2dEBusGl78waU4w5vjaza6MygQiM+qTAGKcJtpyafFzLfhdQYKDeHzOPw
         Rjd0ChAPyiouoikZtkSaNXi6AiNigJXZ2x4LTcAEuAna/iXUoECS5qu06YSATdCiV+mK
         m/bjKQILdv1mVmF3Aujj8HfnVNaYk2Ipf5EMt+z8cr2wzVS4vSow4+fxDo/dTWZ/C3fA
         nRVjQPHrPJOZUiBRc+JsUvYOmvjsyO4EtWnf/iLZoAOJfEUN8LHLmpW9rsEtbPzGGbSh
         Z4nQ==
X-Gm-Message-State: AOAM532aNG2ylhw9jpk0qmFMBFPKP3+IhCt0kVS+iJ4TZYd/bMYQrlPb
        9XQpi3rouejwUOzbOlehcFHOcQ==
X-Google-Smtp-Source: ABdhPJzEIDKSoaNUeuA03A9UaNPbLJkgL1sPiKkMqCEZ8b3Zaa5qL84gJrS/tV33AfTsosz8jDFT0A==
X-Received: by 2002:a05:6512:159:: with SMTP id m25mr9504020lfo.73.1619353354561;
        Sun, 25 Apr 2021 05:22:34 -0700 (PDT)
Received: from trillian.bjorktomta.lan (h-158-174-77-132.NA.cust.bahnhof.se. [158.174.77.132])
        by smtp.gmail.com with ESMTPSA id p22sm1091528lfo.179.2021.04.25.05.22.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 25 Apr 2021 05:22:34 -0700 (PDT)
From:   Erik Flodin <erik@flodin.me>
Cc:     Erik Flodin <erik@flodin.me>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-can@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH v3] can: proc: fix rcvlist_* header alignment on 64-bit system
Date:   Sun, 25 Apr 2021 14:22:12 +0200
Message-Id: <20210425122222.223839-1-erik@flodin.me>
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
 net/can/proc.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/net/can/proc.c b/net/can/proc.c
index 5ea8695f507e..35b6c7512785 100644
--- a/net/can/proc.c
+++ b/net/can/proc.c
@@ -205,8 +205,11 @@ static void can_print_recv_banner(struct seq_file *m)
 	 *                  can1.  00000000  00000000  00000000
 	 *                 .......          0  tp20
 	 */
-	seq_puts(m, "  device   can_id   can_mask  function"
-			"  userdata   matches  ident\n");
+#ifdef CONFIG_64BIT
+	seq_puts(m, "  device   can_id   can_mask      function          userdata       matches  ident\n");
+#else
+	seq_puts(m, "  device   can_id   can_mask  function  userdata   matches  ident\n");
+#endif
 }
 
 static int can_stats_proc_show(struct seq_file *m, void *v)
-- 
2.31.0

