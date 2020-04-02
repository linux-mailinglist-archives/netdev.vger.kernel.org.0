Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 29EB519CCD8
	for <lists+netdev@lfdr.de>; Fri,  3 Apr 2020 00:27:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389725AbgDBW1B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Apr 2020 18:27:01 -0400
Received: from mail-qk1-f196.google.com ([209.85.222.196]:45316 "EHLO
        mail-qk1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388218AbgDBW1B (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Apr 2020 18:27:01 -0400
Received: by mail-qk1-f196.google.com with SMTP id o18so3201261qko.12
        for <netdev@vger.kernel.org>; Thu, 02 Apr 2020 15:27:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=4PcIhlqyUaz+aZ9wdLpZKJLgagQhkffRm37/i5Dl3Pc=;
        b=HEovbhqHZhU/Vmrezhb6OVePWbBOmAWCLQBBM0KOHFVuB/5Xglst47uZKpvNM7zzyK
         CCJVzO/B37eX6EmWsL8EM/inOLlT1IxCgk4YZKJsIAJVCXgjg1LSBDamkn/lJb3cFQ3N
         fn/lmzi/0A3xkFonG8lc/p7AW3P1OQfr6J/TKWtMe36XMIPsvZMen0V2ozs/dLHbQEAl
         9ZA4ZGjyks0KSDX7uxR+OA1MlHdqtWlyUM4aZZbfNGQxotDK/qHmYbJ1sZQU2h/0Wr2+
         47ZvAgzgrgJOmUWV4XhQlOMFt05beu7WZErlrcb0/zq72YYOJrRIOcDF152mRd/RAVCk
         eqdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=4PcIhlqyUaz+aZ9wdLpZKJLgagQhkffRm37/i5Dl3Pc=;
        b=QirtV3BWmCp9tdZ2iZF+EbJw9RSF2EFrZk7lW91J/MT8u0u1yCtqsHP2scBqkp+huH
         KZkmzvPPfYBwKF993EQgDq25ncX7NsKel73p8bpC5fyAiaqKiUuYHkvI7pJpujXCuLX6
         tEC/F1HomcvVkK5aPXNXkTd+UP9V5GNnc2mrc7Z+QU57qbb9fpp8XdNyiO0Z+wk97KYW
         a0BttC7PKGe6XbWmcIb10DDbuRiMnap7ippJ01DhlZS1D0ZHTYNu2O4Ust1kPLJRzFJg
         U6DlJPfkEgUnSBhx6hoSAAnTE8j3XxZSaUOnHa7Npw2yjCU6DkRYbEaUic8a4cILcoa7
         f/qg==
X-Gm-Message-State: AGi0PuYCv2eu24+7nNL/5tOk/lGgc0LYJUuO0yxbq++tDHZOaFXeoRkd
        B58eT2rg5NfEo1Wk35Lqc3E=
X-Google-Smtp-Source: APiQypJxyRqMRcnWkNZnhmTsQIniJuYIFIbwqv1/8jGVet6a8/ekVeP5DVwzOe9DlLiNdj41RcBCwA==
X-Received: by 2002:a37:a93:: with SMTP id 141mr5916110qkk.244.1585866420162;
        Thu, 02 Apr 2020 15:27:00 -0700 (PDT)
Received: from localhost.localdomain ([2001:1284:f016:e706:e019:95fc:6441:c82])
        by smtp.gmail.com with ESMTPSA id p191sm4473629qke.6.2020.04.02.15.26.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Apr 2020 15:26:58 -0700 (PDT)
Received: by localhost.localdomain (Postfix, from userid 1000)
        id 5BDB2C0E8C; Thu,  2 Apr 2020 19:26:56 -0300 (-03)
From:   Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>, marcelo.leitner@gmail.com
Subject: [PATCH net] net: sched: reduce amount of log messages in act_mirred
Date:   Thu,  2 Apr 2020 19:26:12 -0300
Message-Id: <a59f92670c72db738d91b639ecc72ef8daf69300.1585866258.git.marcelo.leitner@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

OVS bridge is usually left down. When using OVS offload, then, it is
quite common to trigger this message. Some cards, for example, can't
offload broadcasts because they can't output to more than 2 ports.
Due to this, act_mirred will try to output to the OVS bridge itself,
which is often down, and floods the log. (yes, the ratelimit is not
enough)

As act_mirred is already incrementing the overlimit counter for each
drop, there is no need to keep flooding the logs here. Lets log it once,
warn the sysadmin, and let the counters do the rest.

Signed-off-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
---
 net/sched/act_mirred.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/sched/act_mirred.c b/net/sched/act_mirred.c
index 83dd82fc9f40ce800b99eae5c0b279dce5b2c1c9..bd1e2c98aaaefc689e52840b9be53ef9de4dd86d 100644
--- a/net/sched/act_mirred.c
+++ b/net/sched/act_mirred.c
@@ -245,8 +245,8 @@ static int tcf_mirred_act(struct sk_buff *skb, const struct tc_action *a,
 	}
 
 	if (unlikely(!(dev->flags & IFF_UP))) {
-		net_notice_ratelimited("tc mirred to Houston: device %s is down\n",
-				       dev->name);
+		pr_notice_once("tc mirred: device %s is down\n",
+			       dev->name);
 		goto out;
 	}
 
-- 
2.25.1

