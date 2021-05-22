Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 44CD338D72C
	for <lists+netdev@lfdr.de>; Sat, 22 May 2021 21:14:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231422AbhEVTQA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 22 May 2021 15:16:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231377AbhEVTPz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 22 May 2021 15:15:55 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4CF6C061574;
        Sat, 22 May 2021 12:14:30 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id t11so12674955pjm.0;
        Sat, 22 May 2021 12:14:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=lX//LiYCi9V25eCHy4xTyI2ugZeYUnZTGWUsgm/854w=;
        b=YtKsDUBlMiq8Xu8M6BOGp2WSgVJrRDJGEjagsEAR2G1OHHUE2imDtY9gMzlNCRcV+Z
         7X8f7pnq04BfpIjdSEGD01K5uvcRW5NBgr3mJcRVORWKrpWaJc3qQdy0UroIPHB1TRCH
         94mdH5hPnkA3cpjExUouL4749Tu3+jVpqNskRE1eBHAvTEad3yD8ZwBUhOm1zGZG1FTi
         dUh7spWTbjXiiwhCusKvj0bM85BxiMtfpPQeDj0NY3FA7OUrraxZvWkLRrmXP1nqIP4l
         fgqwsyPvyjQsux2gpEU6ReWF7nRq2vc2FCNlDSGH0+e4vmYenC/cMp39Kqg/NznZoHI3
         50sQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=lX//LiYCi9V25eCHy4xTyI2ugZeYUnZTGWUsgm/854w=;
        b=byCo5yAQNsNCB9HM+Av/vziBZACTRVeC9jMHZgc41Th8G/IVM9vNnG3IEErNRa2yF2
         ybBZgqvoiC3/tGLyrHGWRGtLeFfPwu/SLQ1pUI6c7qLgrBWhziFMY2w6Ja9JnGo+RSQu
         +/QABiwmAldzrlLPzAiYwawoAf5stPAZtBqqm6JPpiRjAgzSbrYc752Oj4IQINhk1hIe
         s8A9U9/YgoqOjtPaIuYMMnYWS6MQbk9AnHd9fhvQARrKoUFT9N4fDmRGC3mxsD8GpYOx
         oDDlNF7z1NhQ6rCUwRt17qkF36FNszEtgXv0aynuafE64/ke6GvQryMPh150BNB+zyzM
         XsOw==
X-Gm-Message-State: AOAM530VOoSRMf78eaTXknAE1XFVjlMfPe1ZB81V3at3VKWU7VG2DL3O
        nkwNzc0hKYKObb0YexTvXJG+o9asELKF6g==
X-Google-Smtp-Source: ABdhPJwpv+3abu5TxI4O3VoXl9HK1yDkHp2NsdLBZMhTa8Ig7sgXK2JHGHdXbJaE7KGBeFQXx3nrgg==
X-Received: by 2002:a17:90b:1185:: with SMTP id gk5mr16468559pjb.168.1621710870161;
        Sat, 22 May 2021 12:14:30 -0700 (PDT)
Received: from unknown.attlocal.net ([2600:1700:65a0:ab60:14cd:343f:4e27:51d7])
        by smtp.gmail.com with ESMTPSA id 5sm6677531pfe.32.2021.05.22.12.14.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 22 May 2021 12:14:29 -0700 (PDT)
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     netdev@vger.kernel.org
Cc:     bpf@vger.kernel.org, Cong Wang <cong.wang@bytedance.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Lorenz Bauer <lmb@cloudflare.com>
Subject: [Patch bpf v2 4/7] skmsg: fix a memory leak in sk_psock_verdict_apply()
Date:   Sat, 22 May 2021 12:14:08 -0700
Message-Id: <20210522191411.21446-5-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210522191411.21446-1-xiyou.wangcong@gmail.com>
References: <20210522191411.21446-1-xiyou.wangcong@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Cong Wang <cong.wang@bytedance.com>

If the dest psock does not set SK_PSOCK_TX_ENABLED,
then the skb can't be queued anywhere so hould be
dropped.

This one is found during code review.

Fixes: 799aa7f98d53 ("skmsg: Avoid lock_sock() in sk_psock_backlog()")
Cc: John Fastabend <john.fastabend@gmail.com>
Cc: Daniel Borkmann <daniel@iogearbox.net>
Cc: Jakub Sitnicki <jakub@cloudflare.com>
Cc: Lorenz Bauer <lmb@cloudflare.com>
Signed-off-by: Cong Wang <cong.wang@bytedance.com>
---
 net/core/skmsg.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/core/skmsg.c b/net/core/skmsg.c
index f9a81b314e4c..de68a3cd33f1 100644
--- a/net/core/skmsg.c
+++ b/net/core/skmsg.c
@@ -922,8 +922,11 @@ static void sk_psock_verdict_apply(struct sk_psock *psock,
 			if (sk_psock_test_state(psock, SK_PSOCK_TX_ENABLED)) {
 				skb_queue_tail(&psock->ingress_skb, skb);
 				schedule_work(&psock->work);
+				err = 0;
 			}
 			spin_unlock_bh(&psock->ingress_lock);
+			if (err < 0)
+				goto out_free;
 		}
 		break;
 	case __SK_REDIRECT:
-- 
2.25.1

