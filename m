Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E3031D67FC
	for <lists+netdev@lfdr.de>; Sun, 17 May 2020 14:47:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727929AbgEQMrM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 17 May 2020 08:47:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727893AbgEQMrM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 17 May 2020 08:47:12 -0400
Received: from mail-qt1-x842.google.com (mail-qt1-x842.google.com [IPv6:2607:f8b0:4864:20::842])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DDA8C061A0C
        for <netdev@vger.kernel.org>; Sun, 17 May 2020 05:47:12 -0700 (PDT)
Received: by mail-qt1-x842.google.com with SMTP id i68so5914087qtb.5
        for <netdev@vger.kernel.org>; Sun, 17 May 2020 05:47:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id;
        bh=Es4PmaqKKw+YBEoaBuJgLMXxZnpVGaR4UYiE0LTbTr4=;
        b=C7gLQjpKGXl8qRIj0bpMNVU0o6DjIf0NZmBWFPzCGMIak6Uc8+unIc4rR7FLi3ju3E
         eW5HRFfBJ8Z1swe9QsaXC0VueJkyfBD4xUBEmRxAXbUws7p3Nz9Mc0Zi5I2/8jB1g6ic
         4S0d8QRA9Mjxw7RQmYZGvjfbSBObdskHowxHn7TE07zw9Awn1AgfnkfUp6RLCqbjoByp
         uAhXYnvo/RJyct0Pek9fGlNawu4ksQ0KdsqcAJR+lW6JMoCLuBhEk6cMY+lX2wmoCKJs
         mxVb/j0CyvOD6oPdBl/hsrDFXX82ikWtniJkyPx3x1C+Me2xK//ao3XWIIQ4agIT1yof
         Urog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=Es4PmaqKKw+YBEoaBuJgLMXxZnpVGaR4UYiE0LTbTr4=;
        b=M4tgqjploWjJcZe66AX47IhaUwVh5DTSITiSToDTYamS80H+RR5zdsH9WgVRYdhKn1
         HRodYewwxBW3FOqzGu7rBnS/bFm/D2rEYUz6wuZ0jVgga3I9UdajEFQrWITT7fh3Dfya
         RGa3SDQv6bm0Q73Q7ydMREFokYJMtbwRuAWC/Ik8cfC2lZiscg3R4gNQg74oV4uToy5W
         Nnt6DJzoeYWezOCG52m+ZL92fjUhvspVRYyX5aDq81cRfNhTRrxjbpN8lHyk3TNUF0Py
         BumHgc6ZQ08dPn6wDEScri6ufZg7KuGHjyY5AOuVAf/EsWGfngV1zkUlwRUPtNb9OO7J
         v7Sg==
X-Gm-Message-State: AOAM532oCRj9IrEj2wDdQnVerMi8ika14oXgr2heGLHWNpvleBxEqMF/
        wbZfSNMKuXVm2fskYYicngJorg==
X-Google-Smtp-Source: ABdhPJwoOqvCLEF+42UXwQf4Ly4UYaGRZ5I47EKk1onNzhjYwP8GPssB0nJr76N5mEP9AS1+A+VyZw==
X-Received: by 2002:ac8:518e:: with SMTP id c14mr11890510qtn.183.1589719630952;
        Sun, 17 May 2020 05:47:10 -0700 (PDT)
Received: from mojatatu.com ([74.127.203.199])
        by smtp.gmail.com with ESMTPSA id o31sm6836641qto.64.2020.05.17.05.46.57
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 17 May 2020 05:47:10 -0700 (PDT)
From:   Roman Mashak <mrv@mojatatu.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, kernel@mojatatu.com, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, jiri@resnulli.us,
        Roman Mashak <mrv@mojatatu.com>
Subject: [PATCH net 1/1] net sched: fix reporting the first-time use timestamp
Date:   Sun, 17 May 2020 08:46:31 -0400
Message-Id: <1589719591-32491-1-git-send-email-mrv@mojatatu.com>
X-Mailer: git-send-email 2.7.4
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When a new action is installed, firstuse field of 'tcf_t' is explicitly set
to 0. Value of zero means "new action, not yet used"; as a packet hits the
action, 'firstuse' is stamped with the current jiffies value.

tcf_tm_dump() should return 0 for firstuse if action has not yet been hit.

Fixes: 48d8ee1694dd ("net sched actions: aggregate dumping of actions timeinfo")
Cc: Jamal Hadi Salim <jhs@mojatatu.com>
Signed-off-by: Roman Mashak <mrv@mojatatu.com>
Acked-by: Jamal Hadi Salim <jhs@mojatatu.com>
---
 include/net/act_api.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/include/net/act_api.h b/include/net/act_api.h
index c24d7643548e..124bd139886c 100644
--- a/include/net/act_api.h
+++ b/include/net/act_api.h
@@ -75,7 +75,8 @@ static inline void tcf_tm_dump(struct tcf_t *dtm, const struct tcf_t *stm)
 {
 	dtm->install = jiffies_to_clock_t(jiffies - stm->install);
 	dtm->lastuse = jiffies_to_clock_t(jiffies - stm->lastuse);
-	dtm->firstuse = jiffies_to_clock_t(jiffies - stm->firstuse);
+	dtm->firstuse = stm->firstuse ?
+		jiffies_to_clock_t(jiffies - stm->firstuse) : 0;
 	dtm->expires = jiffies_to_clock_t(stm->expires);
 }
 
-- 
2.7.4

