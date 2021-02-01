Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E2CF30AC43
	for <lists+netdev@lfdr.de>; Mon,  1 Feb 2021 17:06:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230055AbhBAQFg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Feb 2021 11:05:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229570AbhBAQF1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Feb 2021 11:05:27 -0500
Received: from mail-wm1-x34a.google.com (mail-wm1-x34a.google.com [IPv6:2a00:1450:4864:20::34a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA8E8C06174A
        for <netdev@vger.kernel.org>; Mon,  1 Feb 2021 08:04:46 -0800 (PST)
Received: by mail-wm1-x34a.google.com with SMTP id k64so5019624wmb.6
        for <netdev@vger.kernel.org>; Mon, 01 Feb 2021 08:04:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:message-id:mime-version:subject:from:to:cc;
        bh=k0C1xWSejIoCUIkR3Xdpp2QfnBoYRRN5HyYkZB6dBTA=;
        b=NepNoYaSqyIEMzp6Df1/nXS4fC6aPClhYVE07/UQ8P/TA/6hzQq8i4FI1xSSiIMehd
         JBC4glTTbdqOCO/siFNbS2TTeBHRfWbLk2zqwrl88bzHvv2xfjxmFD5zNrDfFHnnmliK
         LyYwHowk9nqaJAWtjk0M7k5kGcTTCrvW6oN/+mG/pJHIISh7b/el2cPEP75uvJo2Bmyh
         IJf28vVsat0mk2unsmH4O/0QG2kWQWtgIAHMrkmmcNmMhKvj+XKzNS3aZSVDOBSUVAeQ
         NQMBdGPGBnbBnc9Vqzrbrrhq2PBnRwkJfvi34kcKwjrNey1eftKXLGNGt6re4wvO40mD
         Q4vQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:message-id:mime-version:subject:from
         :to:cc;
        bh=k0C1xWSejIoCUIkR3Xdpp2QfnBoYRRN5HyYkZB6dBTA=;
        b=Q43Qg9mwrgktEUii8sby/JGNJxh5NdwNsrGtrN619neNlpjPO/ubAgjgaX+LTv/f49
         SKUvAsMJIvJLYutAdClk5kKs3u1WzlbE/cYdGpjCq69s0rM7WyousDoiOM7OpsUGNyy4
         PCdJs2tbR8bo3EEoBUMcSrwpq1lztsvlXVwIeBFFQr6MMCbcD8T5rpxUQs+SAQOBPbFZ
         +Q4t9nsOAwv64rh7FLtjLgUNbI8P1koXo/cW3FNd7AwCVpflbWfsEunGxOrah9DPo81P
         wHZz9s6dvtWruOHLEgEI63Cua2gsL+Xb6WP7kkNJoTZ0N+S5y92zz2A3jsws3BI2BqKz
         O+PQ==
X-Gm-Message-State: AOAM531klAnmvv4DfzVqzNQ10gSgHjQFsmAJQqBXl/DHtEeJZn5erq+g
        P702oxlEfp26UnFhikBs/CFedV38Og==
X-Google-Smtp-Source: ABdhPJyfdxQAQE01yNUQDQX5ATRJfd8Q1f/BzqudRhIhMaukawQGypsRjYGiYl0suwLJ8tqxRRVJ6lOy8g==
Sender: "elver via sendgmr" <elver@elver.muc.corp.google.com>
X-Received: from elver.muc.corp.google.com ([2a00:79e0:15:13:f693:9fff:fef4:2449])
 (user=elver job=sendgmr) by 2002:a7b:c76e:: with SMTP id x14mr2587288wmk.17.1612195485394;
 Mon, 01 Feb 2021 08:04:45 -0800 (PST)
Date:   Mon,  1 Feb 2021 17:04:20 +0100
Message-Id: <20210201160420.2826895-1-elver@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.30.0.365.g02bc693789-goog
Subject: [PATCH net-next] net: fix up truesize of cloned skb in skb_prepare_for_shift()
From:   Marco Elver <elver@google.com>
To:     elver@google.com
Cc:     linux-kernel@vger.kernel.org, kasan-dev@googlegroups.com,
        davem@davemloft.net, kuba@kernel.org, jonathan.lemon@gmail.com,
        willemb@google.com, linmiaohe@huawei.com, gnault@redhat.com,
        dseok.yi@samsung.com, kyk.segfault@gmail.com,
        viro@zeniv.linux.org.uk, netdev@vger.kernel.org, glider@google.com,
        syzbot+7b99aafdcc2eedea6178@syzkaller.appspotmail.com,
        Eric Dumazet <edumazet@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Avoid the assumption that ksize(kmalloc(S)) == ksize(kmalloc(S)): when
cloning an skb, save and restore truesize after pskb_expand_head(). This
can occur if the allocator decides to service an allocation of the same
size differently (e.g. use a different size class, or pass the
allocation on to KFENCE).

Because truesize is used for bookkeeping (such as sk_wmem_queued), a
modified truesize of a cloned skb may result in corrupt bookkeeping and
relevant warnings (such as in sk_stream_kill_queues()).

Link: https://lkml.kernel.org/r/X9JR/J6dMMOy1obu@elver.google.com
Reported-by: syzbot+7b99aafdcc2eedea6178@syzkaller.appspotmail.com
Suggested-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: Marco Elver <elver@google.com>
---
 net/core/skbuff.c | 14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index 2af12f7e170c..3787093239f5 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -3289,7 +3289,19 @@ EXPORT_SYMBOL(skb_split);
  */
 static int skb_prepare_for_shift(struct sk_buff *skb)
 {
-	return skb_cloned(skb) && pskb_expand_head(skb, 0, 0, GFP_ATOMIC);
+	int ret = 0;
+
+	if (skb_cloned(skb)) {
+		/* Save and restore truesize: pskb_expand_head() may reallocate
+		 * memory where ksize(kmalloc(S)) != ksize(kmalloc(S)), but we
+		 * cannot change truesize at this point.
+		 */
+		unsigned int save_truesize = skb->truesize;
+
+		ret = pskb_expand_head(skb, 0, 0, GFP_ATOMIC);
+		skb->truesize = save_truesize;
+	}
+	return ret;
 }
 
 /**

base-commit: 14e8e0f6008865d823a8184a276702a6c3cbef3d
-- 
2.30.0.365.g02bc693789-goog

