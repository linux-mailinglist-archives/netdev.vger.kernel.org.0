Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 301B668BF19
	for <lists+netdev@lfdr.de>; Mon,  6 Feb 2023 15:00:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229873AbjBFOAW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Feb 2023 09:00:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231139AbjBFN73 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Feb 2023 08:59:29 -0500
Received: from mail-wr1-f53.google.com (mail-wr1-f53.google.com [209.85.221.53])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03F3CD528;
        Mon,  6 Feb 2023 05:58:50 -0800 (PST)
Received: by mail-wr1-f53.google.com with SMTP id j25so6911149wrc.4;
        Mon, 06 Feb 2023 05:58:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=zpGZ0SKXKOge6HnxdkWMSdwz/l7mvDMZXx0r+zMmH6I=;
        b=ayBkd5SxKmxbth+Yy2we/29UalD+V2nIW98P3VjtfRSovsUSdEriYKfCyrLNnAIqKV
         5DxkIDIJxv++JZigdua25s2wxJtbbesDydxUYrDe1uNbBkDYn9Gc7xvcump0eMjLN/u5
         +z8ONnIXoAul+Cv2xxQJEpRETQloVFwFCD+AII+V58gxoGaRKx+bZvJrmqDxFDOw0A7C
         crV8afUth14o0Nn8boldTFgMdfQaMGXTqyhRJgomWTPXW/p6cyz8c6DNg64r2L/o3HCT
         pbhgRHUoyatlPBiNq1gmvGvoBbNDfWvE4x+gmctj8QNVVMkSStDB9yo8kXwBzPcwh9CR
         xLrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=zpGZ0SKXKOge6HnxdkWMSdwz/l7mvDMZXx0r+zMmH6I=;
        b=Zitm4HosRPxdGzLWrectphmFaaIN/t3aa9vyboM1Xsjnqy52CqHFT4BdzyZ6QR0sjg
         uovWsfScU8ziCH5AOrQ589IrorhnHIVwsvzkmyCxUCfkeV8BJZLJXvwlFWlSQiIXWEYi
         g64ogXLF0N7c/nfRmB1MKhHW1Zjp+9Tvh3E7R6PJjTb2i2/cuVZpgndwGSaux9vd44Sg
         oruPvnULHR6dwqwVRVL0RRXlWVZnoxR7eIc32XW1GAwGECZuBBBaFfqt5r3uLDFlzvJu
         M2Z3XabaPlRpreIuQuGLTg9139Ny8rHQnXnb3+AdFdVm1hA4Rd+Sn/yvl0aegFqqQByB
         CEkg==
X-Gm-Message-State: AO0yUKW8fm1PPx4vR090CfaHE+OAi7k9csbOakYquO8mozHOk5/GHE67
        ZfdR4aTU125XprD13PSXWouOC9JKAtY=
X-Google-Smtp-Source: AK7set/oAJw/wZouRHq2oiPHaQjLsZsQDOu0rNiek7XTsirfs/qg6NCpaXQfJdRm42EY8M07IIfbrA==
X-Received: by 2002:a05:6000:186a:b0:2c3:9851:e644 with SMTP id d10-20020a056000186a00b002c39851e644mr22129707wri.63.1675691929628;
        Mon, 06 Feb 2023 05:58:49 -0800 (PST)
Received: from localhost ([102.36.222.112])
        by smtp.gmail.com with ESMTPSA id a4-20020a5d5084000000b002c3db0eec5fsm7200088wrt.62.2023.02.06.05.58.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Feb 2023 05:58:49 -0800 (PST)
Date:   Mon, 6 Feb 2023 16:18:32 +0300
From:   Dan Carpenter <error27@gmail.com>
To:     Jamal Hadi Salim <jhs@mojatatu.com>,
        Kees Cook <keescook@chromium.org>
Cc:     Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Simon Horman <simon.horman@corigine.com>,
        netdev@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH net-next] net: sched: sch: Fix off by one in
 htb_activate_prios()
Message-ID: <Y+D+KN18FQI2DKLq@kili>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mailer: git-send-email haha only kidding
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The > needs be >= to prevent an out of bounds access.

Fixes: de5ca4c3852f ("net: sched: sch: Bounds check priority")
Signed-off-by: Dan Carpenter <error27@gmail.com>
---
 net/sched/sch_htb.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/sched/sch_htb.c b/net/sched/sch_htb.c
index cc28e41fb745..92f2975b6a82 100644
--- a/net/sched/sch_htb.c
+++ b/net/sched/sch_htb.c
@@ -433,7 +433,7 @@ static void htb_activate_prios(struct htb_sched *q, struct htb_class *cl)
 		while (m) {
 			unsigned int prio = ffz(~m);
 
-			if (WARN_ON_ONCE(prio > ARRAY_SIZE(p->inner.clprio)))
+			if (WARN_ON_ONCE(prio >= ARRAY_SIZE(p->inner.clprio)))
 				break;
 			m &= ~(1 << prio);
 
-- 
2.35.1

