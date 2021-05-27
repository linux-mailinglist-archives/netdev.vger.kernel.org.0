Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E16339242F
	for <lists+netdev@lfdr.de>; Thu, 27 May 2021 03:12:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234394AbhE0BOD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 May 2021 21:14:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234224AbhE0BNt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 May 2021 21:13:49 -0400
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE404C0613CE;
        Wed, 26 May 2021 18:12:16 -0700 (PDT)
Received: by mail-pf1-x42d.google.com with SMTP id d16so2334194pfn.12;
        Wed, 26 May 2021 18:12:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Li7iIK9O8bheMw2lclanyfnMSKgSW79Xj968UPC+rYs=;
        b=oAv6YrOyfDhehpeMDNJBRNPuDyYiTxbS8w31OlUMDswhd2UDArd9zyYc8j4x/o3M+q
         OV41+Tk5nECjABjahnM0istnC3v2leDEO6kgFDjalZWM67JvsLPIrtw29ze7oGcSpNQN
         WwB0eQsE9gwdOqho31PT4It0tM43400NRnp54eJT8ysa+xKHl4DFhKaunIkGzAQCb7tw
         Nh4QkI2am1hhZSWtnmHGr6hIxMPSkYO16jjJ9nZl2Mz7KatTeOj+Zw3F32Z+sOTmhobI
         yezgqV03SVq2sm4HUg+kVoAtO7+ZLHy8nXqdZAFibFECJXatFvO9tXzZPBhPxrxsIUEL
         uqeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Li7iIK9O8bheMw2lclanyfnMSKgSW79Xj968UPC+rYs=;
        b=EMbE/B9GMCasVRJC9X8FWW7vol4dDOtLPIEH2CfogYe+sFmuoI1mjOfGO14nQtmF+h
         PrkdQimIfGDW0MRYgwp/GpdlGtB/DLVScV07TIB4pUoYZcLN0T7ocZA/RR+qvr4w14h3
         h3S/Wi/v+47kWSCGHWMZ0MIvHzKdzx7K4VbJE9USjjpsIFJY5KvP9YWG7iYFyTMGXoyO
         LpGOdm3ggjS+ISYhLBjMqBT8M2K8zn+AV2Lr6ojoEysw2QXy8pql3IofsWUC8McE0S2w
         tWiMbfoc8ggm2iyQ+oXEWJxLpGymsy4YMOMxtAf5yMmNHD53lx5afpEyd86QAW4i8I6S
         4bBg==
X-Gm-Message-State: AOAM5317UOkxTTFgZoDfcEt1MUqJL2JMPSHyLlczW0Vqci8TfYBDyLu2
        Vlhw7xZEuYSyopnQC9X1tRplKL47Fae/vA==
X-Google-Smtp-Source: ABdhPJwkCIEjVEJ3HsNYfV7PFNMZKZvvYe1Q/jdPCWZC3cdc4phNyqSFLff17WnK+SjgGBwMjfjOiA==
X-Received: by 2002:a05:6a00:d41:b029:2da:b8ea:df35 with SMTP id n1-20020a056a000d41b02902dab8eadf35mr1244104pfv.3.1622077936245;
        Wed, 26 May 2021 18:12:16 -0700 (PDT)
Received: from unknown.attlocal.net ([2600:1700:65a0:ab60:991:63cd:5e03:9e3a])
        by smtp.gmail.com with ESMTPSA id n21sm360282pfu.99.2021.05.26.18.12.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 May 2021 18:12:15 -0700 (PDT)
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     netdev@vger.kernel.org
Cc:     bpf@vger.kernel.org, Cong Wang <cong.wang@bytedance.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Lorenz Bauer <lmb@cloudflare.com>
Subject: [Patch bpf v3 7/8] skmsg: pass source psock to sk_psock_skb_redirect()
Date:   Wed, 26 May 2021 18:11:54 -0700
Message-Id: <20210527011155.10097-8-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210527011155.10097-1-xiyou.wangcong@gmail.com>
References: <20210527011155.10097-1-xiyou.wangcong@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Cong Wang <cong.wang@bytedance.com>

sk_psock_skb_redirect() only takes skb as a parameter, we
will need to know where this skb is from, so just pass
the source psock to this function as a new parameter.
This patch prepares for the next one.

Cc: John Fastabend <john.fastabend@gmail.com>
Cc: Daniel Borkmann <daniel@iogearbox.net>
Cc: Jakub Sitnicki <jakub@cloudflare.com>
Cc: Lorenz Bauer <lmb@cloudflare.com>
Signed-off-by: Cong Wang <cong.wang@bytedance.com>
---
 net/core/skmsg.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/net/core/skmsg.c b/net/core/skmsg.c
index e3d210811db4..3aa9065811ad 100644
--- a/net/core/skmsg.c
+++ b/net/core/skmsg.c
@@ -824,7 +824,7 @@ int sk_psock_msg_verdict(struct sock *sk, struct sk_psock *psock,
 }
 EXPORT_SYMBOL_GPL(sk_psock_msg_verdict);
 
-static int sk_psock_skb_redirect(struct sk_buff *skb)
+static int sk_psock_skb_redirect(struct sk_psock *from, struct sk_buff *skb)
 {
 	struct sk_psock *psock_other;
 	struct sock *sk_other;
@@ -861,11 +861,12 @@ static int sk_psock_skb_redirect(struct sk_buff *skb)
 	return 0;
 }
 
-static void sk_psock_tls_verdict_apply(struct sk_buff *skb, struct sock *sk, int verdict)
+static void sk_psock_tls_verdict_apply(struct sk_buff *skb,
+				       struct sk_psock *from, int verdict)
 {
 	switch (verdict) {
 	case __SK_REDIRECT:
-		sk_psock_skb_redirect(skb);
+		sk_psock_skb_redirect(from, skb);
 		break;
 	case __SK_PASS:
 	case __SK_DROP:
@@ -889,7 +890,7 @@ int sk_psock_tls_strp_read(struct sk_psock *psock, struct sk_buff *skb)
 		ret = sk_psock_map_verd(ret, skb_bpf_redirect_fetch(skb));
 		skb->sk = NULL;
 	}
-	sk_psock_tls_verdict_apply(skb, psock->sk, ret);
+	sk_psock_tls_verdict_apply(skb, psock, ret);
 	rcu_read_unlock();
 	return ret;
 }
@@ -936,7 +937,7 @@ static int sk_psock_verdict_apply(struct sk_psock *psock, struct sk_buff *skb,
 		}
 		break;
 	case __SK_REDIRECT:
-		err = sk_psock_skb_redirect(skb);
+		err = sk_psock_skb_redirect(psock, skb);
 		break;
 	case __SK_DROP:
 	default:
-- 
2.25.1

