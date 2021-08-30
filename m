Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 19E363FB012
	for <lists+netdev@lfdr.de>; Mon, 30 Aug 2021 05:47:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229980AbhH3DsY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 29 Aug 2021 23:48:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229548AbhH3DsX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 29 Aug 2021 23:48:23 -0400
Received: from mail-pf1-x435.google.com (mail-pf1-x435.google.com [IPv6:2607:f8b0:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93347C061575;
        Sun, 29 Aug 2021 20:47:30 -0700 (PDT)
Received: by mail-pf1-x435.google.com with SMTP id 18so11093879pfh.9;
        Sun, 29 Aug 2021 20:47:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=fiESui1KRzGljhyjmIcy4FRTOq44ThwYFlFuxizW2lc=;
        b=ljmrAOXKa2kEgYUcQsJnc64P7BcrrX9vyVgCH4j2yW6MHpWB2EmxUX03teNrQwLWu0
         RHmjcOChoMsNZi4F6/Jfq6cqC4Vd/pomMVtwkXQfvluhHjFCw/3uITT1WjMKDifQHGFF
         scQwdRslG/rJa2HuRNnk2CL4BFRxmeSrLbH9LQPYK+EGIJjOLhow+i7tOqRTMZnX67ur
         dEYkSetfO4cIkRrGlzsHGtZ+ariCCNOtAlz2GfFhWFKe69LEC8MHNYAUs3YB0WwxMntc
         DohNaR5BZqLjM9/om46MYgb3QzOsbiI8+pVlaCUPKfUtuSGLQV+xe8EP29zxa4IS5/La
         OraA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=fiESui1KRzGljhyjmIcy4FRTOq44ThwYFlFuxizW2lc=;
        b=giZccUkIGnV2uOpB64Af966Bb7o8+WrCYKSF9qX726AMUYl8Yl9QVDgP3TKlsXXR9b
         4GEyTlWvjc/O8fETXarGyp4KTCEn+/1dm3KV9ynGpRjgwWEWPTLeaZrHzrmRt1ews/4o
         RSiOmcQsTaCrgP/pBzhHSnsapxS45jaC7RZ4/DKeeNullIMPCjxne8qMK8rDri5d81Fd
         1HKShcxOxDU+jJSATDenZCfNC7v6oOvvDH/t93mWQi8T6OhuxkHBNXT9lLI4R3HdgFfv
         Ceo652sRSoAJifMmYiGFg0UPxHzL1guIHdpFUFGmge1/wTT/VLK8YeYhO7jK4sFwTnj/
         Nt0w==
X-Gm-Message-State: AOAM533Id5QTYG2ZkU1s05IFnFeRRSLNPv3SIJpTqmKrew9c4xwgNyeX
        IwIR0XvbbhV+43lcwDvOIg4=
X-Google-Smtp-Source: ABdhPJytAlDClDlFr40DlFnq54mEApl+e7N/GrajSnAU+2YbeEyWlbeZyBuld+pS21yFqOvNleTzrg==
X-Received: by 2002:aa7:9e4d:0:b0:3f8:6326:a038 with SMTP id z13-20020aa79e4d000000b003f86326a038mr11280871pfq.73.1630295250030;
        Sun, 29 Aug 2021 20:47:30 -0700 (PDT)
Received: from localhost.localdomain ([162.14.21.36])
        by smtp.gmail.com with ESMTPSA id x16sm15153114pgc.49.2021.08.29.20.47.28
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 29 Aug 2021 20:47:29 -0700 (PDT)
From:   tcs.kernel@gmail.com
X-Google-Original-From: tcs_kernel@tencent.com
To:     vinicius.gomes@intel.com, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, jiri@resnulli.us, davem@davemloft.net,
        kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Haimin Zhang <tcs_kernel@tencent.com>
Subject: [PATCH V2] fix array-index-out-of-bounds in taprio_change
Date:   Mon, 30 Aug 2021 11:47:01 +0800
Message-Id: <1630295221-9859-1-git-send-email-tcs_kernel@tencent.com>
X-Mailer: git-send-email 1.8.3.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Haimin Zhang <tcs_kernel@tencent.com>

syzbot report an array-index-out-of-bounds in taprio_change
index 16 is out of range for type '__u16 [16]'
that's because mqprio->num_tc is lager than TC_MAX_QUEUE,so we check
the return value of netdev_set_num_tc.

Reported-by: syzbot+2b3e5fb6c7ef285a94f6@syzkaller.appspotmail.com
Signed-off-by: Haimin Zhang <tcs_kernel@tencent.com>
---
 net/sched/sch_taprio.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/sched/sch_taprio.c b/net/sched/sch_taprio.c
index 9c79374..1ab2fc9 100644
--- a/net/sched/sch_taprio.c
+++ b/net/sched/sch_taprio.c
@@ -1513,7 +1513,9 @@ static int taprio_change(struct Qdisc *sch, struct nlattr *opt,
 	taprio_set_picos_per_byte(dev, q);
 
 	if (mqprio) {
-		netdev_set_num_tc(dev, mqprio->num_tc);
+		err = netdev_set_num_tc(dev, mqprio->num_tc);
+		if (err)
+			goto free_sched;
 		for (i = 0; i < mqprio->num_tc; i++)
 			netdev_set_tc_queue(dev, i,
 					    mqprio->count[i],
-- 
1.8.3.1

