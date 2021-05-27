Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0512C39242C
	for <lists+netdev@lfdr.de>; Thu, 27 May 2021 03:12:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234471AbhE0BOA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 May 2021 21:14:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234199AbhE0BNs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 May 2021 21:13:48 -0400
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC7B4C061574;
        Wed, 26 May 2021 18:12:14 -0700 (PDT)
Received: by mail-pl1-x62b.google.com with SMTP id z4so1501273plg.8;
        Wed, 26 May 2021 18:12:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Z52yKO5K3X5Hvoq0tYlNwZhMPzpoNySZf4mcZZAiaZU=;
        b=VkFGoGW+HNF3xnbCEfTSW1Xd+FuFp1LMRKFl2bSmH/y27SpETu0bgcJcZS9D90nmeR
         XUILyDZ8aTeqqLbZ2+BnlwRGdIzRfrPGwVNuU+unKU6Vb4OgU0pOY/PPOjSDpIsl73zh
         kAGjsnDsoYoL1YaGbQyt35gwtHpNITAK20NQZSf24e3aCPsgmTbb/N3fUPXPE5jO3yj5
         kxU48ei9hVybuaQuUME2GxGCWeZ3YdTiCV7xIIXeS6v6iJdxcv5lmTwtqbgYU7KpRsHt
         7794GuVII3vf3spjbig1olF63SWWZmgkAYBe37iDC1MClF/Bn6jKQkbq+XqK7OO7ubJJ
         e0kA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Z52yKO5K3X5Hvoq0tYlNwZhMPzpoNySZf4mcZZAiaZU=;
        b=H3WE288Y0nJTDT7Wr7Oh0ua74qNdSdlLRu5ozTjXOq0vD+mRSAXlyvjSTH8kRXj2CE
         2sRCr5LMYW8gbuU/oCbCVpPHldNiSXdypYjXyOH1tT9PjFZMhUPIb/BONxx7gQ04lcVw
         ZK5xCowTwQTgUXnTozV8D5ERpQLF7ZFRe7bxm5fu8YpXf8XBYv/or8BLbjjz6yA6IQ/W
         l4a0KkwAQlltkEIiRrV/y+I36CU3Wsi9W0NExGyedZcDvXynSAIgTT6dD30dxrwoi500
         l4kjd0B/p8UAHpjWzzwsC8uN8teLL872eB9mPjm1Snu/Z59e7TaDWGKB0WW1NRgy2F65
         wQGQ==
X-Gm-Message-State: AOAM531eUze2/mINMk71dy99SPvkdVQquO1Ap0JOFP7LdiDVBD48yXio
        pRQKIn4ERd2QRJR+ST3AGe4iLqTa8l1ZXA==
X-Google-Smtp-Source: ABdhPJx+klGNHlnCzqAuMGh7VsXng1IH5JKxWiy3YY7bqkxdF9NO7zQWg+ishuwE1ywfVaxa02W8pg==
X-Received: by 2002:a17:90a:9511:: with SMTP id t17mr1027743pjo.108.1622077934323;
        Wed, 26 May 2021 18:12:14 -0700 (PDT)
Received: from unknown.attlocal.net ([2600:1700:65a0:ab60:991:63cd:5e03:9e3a])
        by smtp.gmail.com with ESMTPSA id n21sm360282pfu.99.2021.05.26.18.12.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 May 2021 18:12:14 -0700 (PDT)
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     netdev@vger.kernel.org
Cc:     bpf@vger.kernel.org, Cong Wang <cong.wang@bytedance.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Lorenz Bauer <lmb@cloudflare.com>
Subject: [Patch bpf v3 5/8] skmsg: fix a memory leak in sk_psock_verdict_apply()
Date:   Wed, 26 May 2021 18:11:52 -0700
Message-Id: <20210527011155.10097-6-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210527011155.10097-1-xiyou.wangcong@gmail.com>
References: <20210527011155.10097-1-xiyou.wangcong@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Cong Wang <cong.wang@bytedance.com>

If the dest psock does not set SK_PSOCK_TX_ENABLED,
the skb can't be queued anywhere so must be dropped.

This one is found during code review.

Fixes: 799aa7f98d53 ("skmsg: Avoid lock_sock() in sk_psock_backlog()")
Cc: John Fastabend <john.fastabend@gmail.com>
Cc: Daniel Borkmann <daniel@iogearbox.net>
Cc: Jakub Sitnicki <jakub@cloudflare.com>
Cc: Lorenz Bauer <lmb@cloudflare.com>
Signed-off-by: Cong Wang <cong.wang@bytedance.com>
---
 net/core/skmsg.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/net/core/skmsg.c b/net/core/skmsg.c
index 4334720e2a04..5464477e2d3d 100644
--- a/net/core/skmsg.c
+++ b/net/core/skmsg.c
@@ -924,8 +924,13 @@ static void sk_psock_verdict_apply(struct sk_psock *psock,
 			if (sk_psock_test_state(psock, SK_PSOCK_TX_ENABLED)) {
 				skb_queue_tail(&psock->ingress_skb, skb);
 				schedule_work(&psock->work);
+				err = 0;
 			}
 			spin_unlock_bh(&psock->ingress_lock);
+			if (err < 0) {
+				skb_bpf_redirect_clear(skb);
+				goto out_free;
+			}
 		}
 		break;
 	case __SK_REDIRECT:
-- 
2.25.1

