Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D2D33A73C0
	for <lists+netdev@lfdr.de>; Tue, 15 Jun 2021 04:24:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231835AbhFOC0H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Jun 2021 22:26:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231753AbhFOC0A (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Jun 2021 22:26:00 -0400
Received: from mail-io1-xd2c.google.com (mail-io1-xd2c.google.com [IPv6:2607:f8b0:4864:20::d2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26AEBC061574;
        Mon, 14 Jun 2021 19:23:56 -0700 (PDT)
Received: by mail-io1-xd2c.google.com with SMTP id h5so5068022iok.5;
        Mon, 14 Jun 2021 19:23:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Li7iIK9O8bheMw2lclanyfnMSKgSW79Xj968UPC+rYs=;
        b=fZki6ssOlB+VxyfcAnV58alC1PcfzefwADuEnz6mbAO92jBi8Kcx7hMrNR+qCzArt2
         L87xwldgoJqlFDoRElkm8PpClfMIoqVsJyfzfXXE8NPl7OSN5MNT28Zh3YFs8ldW1XWs
         5QPetvSCQvO+6mvoQbm0GbALj4ZigR4xCEnR5rh9N4B2fzeDbUItLZl+yGFy39Yx22md
         Dqz0yjzmbu3oFi8fotj4lP/xMFxDnAlgZQajKjDDsuoGSQtGHoyQnUTU+kLX0SxSlCyq
         XmNoPYLeNhmhnuRFIQBpbZJT7qfCoyZpo2MjIhdIrUzAoIuVM20RTeSI3nXtkSdxd4jU
         MRIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Li7iIK9O8bheMw2lclanyfnMSKgSW79Xj968UPC+rYs=;
        b=lZSwCdlOQOwvWBgbD3W7MHjK6CZkQuIOymoGZmJ/DHW6MsXCSLx2TVTqzhEkcj8L81
         uHBt7wJiQRniTXQV2DxIew52ieK2peH0L1Lm44fhpQo42r7xxVlmJS1kvk72sse6c7lY
         abPM/D33BzRVqefPoxIqxmThl2NmxrHnTrm5GW1jnqPzSFlqxISGI0BsTLn+KJS/42r2
         +UFXDkAJ45J3Itwsg2Kc45rM4BubXYccCZMwE0HrJINbEbwAk6mYg1V3RbVJI9sae39p
         zPt0fYaF36fHZco+zE/UkjSNh5rz07d1JPhXdCT1XO8bBlS8QKgz+P30eWoU755lZm74
         nxcw==
X-Gm-Message-State: AOAM533kHZZkGd+ca1S03m+n04xrD90924kDxZDwNM7KA4JxF5hieVKP
        ZHZOWwVVqh+p9FI5too3a0X2yGVr8F7tVw==
X-Google-Smtp-Source: ABdhPJyBDpKGYzy1QdSgYN1+LUQ2WQjOJBtCkZBYaLxqGUQo4yOcWw+TKPfPbOI2t/fKEN7Q6EmLkw==
X-Received: by 2002:a05:620a:29d4:: with SMTP id s20mr19323986qkp.287.1623723244147;
        Mon, 14 Jun 2021 19:14:04 -0700 (PDT)
Received: from unknown.attlocal.net ([2600:1700:65a0:ab60:e9a1:5f1d:df88:4f3c])
        by smtp.gmail.com with ESMTPSA id t15sm10774497qtr.35.2021.06.14.19.14.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Jun 2021 19:14:03 -0700 (PDT)
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     netdev@vger.kernel.org
Cc:     bpf@vger.kernel.org, Cong Wang <cong.wang@bytedance.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Lorenz Bauer <lmb@cloudflare.com>
Subject: [PATCH RESEND bpf v3 7/8] skmsg: pass source psock to sk_psock_skb_redirect()
Date:   Mon, 14 Jun 2021 19:13:41 -0700
Message-Id: <20210615021342.7416-8-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210615021342.7416-1-xiyou.wangcong@gmail.com>
References: <20210615021342.7416-1-xiyou.wangcong@gmail.com>
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

