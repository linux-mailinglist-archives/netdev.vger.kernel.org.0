Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F1B46EA1DF
	for <lists+netdev@lfdr.de>; Wed, 30 Oct 2019 17:36:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726895AbfJ3QgZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Oct 2019 12:36:25 -0400
Received: from mail-pg1-f202.google.com ([209.85.215.202]:38620 "EHLO
        mail-pg1-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726425AbfJ3QgZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Oct 2019 12:36:25 -0400
Received: by mail-pg1-f202.google.com with SMTP id b24so1999097pgi.5
        for <netdev@vger.kernel.org>; Wed, 30 Oct 2019 09:36:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=laOls+liDf7YgEUPDBRX/JcUUIWy7rDyVNRejS8kQKk=;
        b=WcRhRuhvnyxzoEZD3RgASZ04lzpk/wVdtiBzj2iTnH3hvX57du7N+Ub0yhzluzitV2
         PVDlzDqlZ565LssPB1tu/4L6VWB4zGcZkvtozNOocRftY05riBGH5pfhevS2N5UP98Tc
         0zEioTzCCe030T7duYb1T1X7bwirmZiyxsbVK6gS3Tx01Y3pWkw6LzJW4BVdxKLYaOpL
         z3SqqLWHok8KrtRqLl2rs0ZNvwCAwyZ9WziqbM/+mZNldmCUO3OkRVcNdmWk/h81PX3z
         M8sitdhn/7zpRirBmkGb76npc0+nHIor09pVk89yPmH0+DzH8Ni8E82mS/T4LP5G1s0e
         EfHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=laOls+liDf7YgEUPDBRX/JcUUIWy7rDyVNRejS8kQKk=;
        b=a9h2IydNlY3sEG9dmvtOAxYidhm4HFfaSLcXxk0CPd0xy7Fq/KsjGlRfmd2is3Q7sw
         /nKC0mmIilC7d2lmd3Fu+L4VeuqjvqssLcW8NZOpcEbzaj0Cr2uS0USt8JbEeHA80JDq
         GZEWPHAG/eGaDRkEnmhdJcbQzgEuQIj6hpDtTpFwawLG7kgoY9kPmh/zJqofp8vtcL1O
         +VhUy2tex1CI5XU3nNB+sCm0tmBg2nhBuerP4xst1WxyQx7n76AkJeQbwK6ySkt9fByh
         PLA0RHSPtWFdALrwIjuI79EOT4o5N9/TIWnCG3JxeXvib3FUwwQ6FpdF03F6E4+6Xlyt
         BjuA==
X-Gm-Message-State: APjAAAXV051+kQAYIe9BJyILtGH86GH6F4Q7S43pyO9NXZiQaC7aG+RR
        HItIf9gkBgkpMIqXRmKLdtmF+u18XCgKpg==
X-Google-Smtp-Source: APXvYqwOGAi0V0w5vow2+DtvsMcxBsbFLC1waN/a4lE3MStgo+Dbu43Q+hAABCt+TaeSIryzpb4PDDKqJ7dn2w==
X-Received: by 2002:a63:3ecf:: with SMTP id l198mr363625pga.228.1572453384179;
 Wed, 30 Oct 2019 09:36:24 -0700 (PDT)
Date:   Wed, 30 Oct 2019 09:36:20 -0700
Message-Id: <20191030163620.140387-1-edumazet@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.24.0.rc0.303.g954a862665-goog
Subject: [PATCH net] net: increase SOMAXCONN to 4096
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Neal Cardwell <ncardwell@google.com>,
        Yuchung Cheng <ycheng@google.com>, Willy Tarreau <w@1wt.eu>,
        Yue Cao <ycao009@ucr.edu>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SOMAXCONN is /proc/sys/net/core/somaxconn default value.

It has been defined as 128 more than 20 years ago.

Since it caps the listen() backlog values, the very small value has
caused numerous problems over the years, and many people had
to raise it on their hosts after beeing hit by problems.

Google has been using 1024 for at least 15 years, and we increased
this to 4096 after TCP listener rework has been completed, more than
4 years ago. We got no complain of this change breaking any
legacy application.

Many applications indeed setup a TCP listener with listen(fd, -1);
meaning they let the system select the backlog.

Raising SOMAXCONN lowers chance of the port being unavailable under
even small SYNFLOOD attack, and reduces possibilities of side channel
vulnerabilities.

Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Willy Tarreau <w@1wt.eu>
Cc: Yue Cao <ycao009@ucr.edu>
---
 Documentation/networking/ip-sysctl.txt | 4 ++--
 include/linux/socket.h                 | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/Documentation/networking/ip-sysctl.txt b/Documentation/networking/ip-sysctl.txt
index 49e95f438ed7571a93bceffdc17846c35dd64fca..ffa5f8892a66ed3bfcd53903cc6badf28dfa0f50 100644
--- a/Documentation/networking/ip-sysctl.txt
+++ b/Documentation/networking/ip-sysctl.txt
@@ -207,8 +207,8 @@ TCP variables:
 
 somaxconn - INTEGER
 	Limit of socket listen() backlog, known in userspace as SOMAXCONN.
-	Defaults to 128.  See also tcp_max_syn_backlog for additional tuning
-	for TCP sockets.
+	Defaults to 4096. (Was 128 before linux-5.4)
+	See also tcp_max_syn_backlog for additional tuning for TCP sockets.
 
 tcp_abort_on_overflow - BOOLEAN
 	If listening service is too slow to accept new connections,
diff --git a/include/linux/socket.h b/include/linux/socket.h
index fc0bed59fc84ef8e6631d3c275853d52a46f84aa..4049d9755cf198bdda600a61485b36a888b9d879 100644
--- a/include/linux/socket.h
+++ b/include/linux/socket.h
@@ -263,7 +263,7 @@ struct ucred {
 #define PF_MAX		AF_MAX
 
 /* Maximum queue length specifiable by listen.  */
-#define SOMAXCONN	128
+#define SOMAXCONN	4096
 
 /* Flags we can use with send/ and recv.
    Added those for 1003.1g not all are supported yet
-- 
2.24.0.rc0.303.g954a862665-goog

