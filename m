Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 90D4046B2E5
	for <lists+netdev@lfdr.de>; Tue,  7 Dec 2021 07:28:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235189AbhLGGbb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Dec 2021 01:31:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234426AbhLGGbb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Dec 2021 01:31:31 -0500
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A49CC061746
        for <netdev@vger.kernel.org>; Mon,  6 Dec 2021 22:28:01 -0800 (PST)
Received: by mail-pl1-x633.google.com with SMTP id b13so8735919plg.2
        for <netdev@vger.kernel.org>; Mon, 06 Dec 2021 22:28:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=R5Y9u2OO66361g2mHGUqWuP377UIs3AjqyFA9deFMrw=;
        b=nVn2qF7PnzXvUNYzDChcoFN+3SQOcCoAffhmyMNEkjaRUXv8gY28i8R4clmuySDyUl
         A+ngsto77scLc1JwvRHGqeO9t/u5DhZhqRouCxorD1BuTS7Rs5BSuOmYNyxW2HzxRwj8
         BUvGoGP/ZW6v0HoKuamTuvg7+D/Rr5NOJ4vWs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=R5Y9u2OO66361g2mHGUqWuP377UIs3AjqyFA9deFMrw=;
        b=7F6iTo5QWsaNP+CXApcmHnsHjJ9VQZddYy+VCUrljpczybR1leM9m8+91FdOTuEh09
         yvf8j4RMOkk2Yf0mWAuceotLSVZY2si5cHNgKrL2VJrdRm0rcgPzueUa3nxpirYZnXff
         u/mG6ZINxEX0+QhuPda4++BaFA/+nfTgg30u9q6qS78U1jUQCZ654zwdd1j+dsgzT9vJ
         0KSq68MUKiWwuyUC487lVCRk9NFbjCnFbw5NJRsfwbJDW2h9mA+7e6y+XpLV4mRXK691
         73a1cxkfStY4/0V67ccSyQXBQnl1bZPpxxjn2fBH01obO7wY+P6u8kDWECsoPKVZXlFs
         U6+w==
X-Gm-Message-State: AOAM530wfMF1YBrmKdeYIi5RssW8vAltbiBHp/BzGOJQu3ScEPUCQscj
        YufHpooREdYL8tYSe3Phmc/jXA==
X-Google-Smtp-Source: ABdhPJyRS1qegf7dZ9aGTu7oy8A6JYIDT7SPYcjpU/uDiMHuVmRRYJ3W7WiayPqjZC08t/YW6cDuQQ==
X-Received: by 2002:a17:902:c412:b0:141:f710:2a94 with SMTP id k18-20020a170902c41200b00141f7102a94mr49535975plk.1.1638858480887;
        Mon, 06 Dec 2021 22:28:00 -0800 (PST)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id me7sm1606618pjb.9.2021.12.06.22.28.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Dec 2021 22:28:00 -0800 (PST)
From:   Kees Cook <keescook@chromium.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Kees Cook <keescook@chromium.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Marco Elver <elver@google.com>,
        Alexander Lobakin <alobakin@pm.me>,
        Paolo Abeni <pabeni@redhat.com>,
        Cong Wang <cong.wang@bytedance.com>,
        Talal Ahmad <talalahmad@google.com>,
        Kevin Hao <haokexin@gmail.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org
Subject: [PATCH] skbuff: Extract list pointers to silence compiler warnings
Date:   Mon,  6 Dec 2021 22:27:58 -0800
Message-Id: <20211207062758.2324338-1-keescook@chromium.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=3388; h=from:subject; bh=dXKs2BUKHTDgnZIaKltd8Y//V8LOLmO8lOlbliutHeQ=; b=owEBbQKS/ZANAwAKAYly9N/cbcAmAcsmYgBhrv7tXeCUMNqOZ1Dkxzdct9reZXr/lhU0kG2AEqgL akeXvW2JAjMEAAEKAB0WIQSlw/aPIp3WD3I+bhOJcvTf3G3AJgUCYa7+7QAKCRCJcvTf3G3AJirREA CnHZaI+OtJvVYYAO/Pka/AeD3zTJ88dEp7V+BJ9DggP7LB3qfCVxYdG7GG2/GWsqLmpJBjwQEcdJPV nJK4BDxoNMuJ11A+VM4OlqKFgqsf48SHBTKQ8ecH/C3P2duqVHgEHaSkp4c3onmB1f5jVlsf0lI5Z3 M9D2meaKBplsq647GUZX2tLZDLMkIoBLpjtxMpGcmBfuDFQvGlVHtH6x9tTCmjn4aTHvOQR6/aTsDb hM8hwjKFTf5oEP+ALhINHkHmNtgUbMM2PO+VuGQ3gPt0PraVGaksHmgxkFx8V/SBFCdPMrWFqZAZFO j57kKOTQeflgAXgsSKwYH5HmgGt7hxW7oNlQTvm/CaviXJQwi4XcDLDRQ2/vOrjpyxLJfg2tI3vmuH 9bINIyAKuQSysCitsSHXqnPzwsk99ueTVqC+BncNzdYcazKGvcPYz06g+tAD4aDTKNf519f2eETEaB K0GbGzagMQFAfx7ACix7XhPmwTD17Pcet/kaN9UjJKoF8AYA+Qez1u5v1Kn9T9GYWlQVYpE8Xo4QaJ bPZwBH2TvFDybdhjpctgXsBGDEcLEsZRhvb9eAOlE9/mlU1tjKPCpyYmN9eF74YkpgxqiS7hU9wHPZ gY1WI0Fy9pvbr2vI9Gl028pwSgdECom7WxR4EErkNZbe7VPSa70YTuurCWUQ==
X-Developer-Key: i=keescook@chromium.org; a=openpgp; fpr=A5C3F68F229DD60F723E6E138972F4DFDC6DC026
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Under both -Warray-bounds and the object_size sanitizer, the compiler is
upset about accessing prev/next of sk_buff when the object it thinks it
is coming from is sk_buff_head. The warning is a false positive due to
the compiler taking a conservative approach, opting to warn at casting
time rather than access time.

However, in support of enabling -Warray-bounds globally (which has
found many real bugs), arrange things for sk_buff so that the compiler
can unambiguously see that there is no intention to access anything
except prev/next.  Introduce and cast to a separate struct sk_buff_list,
which contains _only_ the first two fields, silencing the warnings:

In file included from ./include/net/net_namespace.h:39,
                 from ./include/linux/netdevice.h:37,
                 from net/core/netpoll.c:17:
net/core/netpoll.c: In function 'refill_skbs':
./include/linux/skbuff.h:2086:9: warning: array subscript 'struct sk_buff[0]' is partly outside array bounds of 'struct sk_buff_head[1]' [-Warray-bounds]
 2086 |         __skb_insert(newsk, next->prev, next, list);
      |         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
net/core/netpoll.c:49:28: note: while referencing 'skb_pool'
   49 | static struct sk_buff_head skb_pool;
      |                            ^~~~~~~~

This change results in no executable instruction differences.

Signed-off-by: Kees Cook <keescook@chromium.org>
---
 include/linux/skbuff.h | 18 ++++++++++--------
 1 file changed, 10 insertions(+), 8 deletions(-)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index eae4bd3237a4..ec71b45b62b0 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -292,9 +292,11 @@ struct tc_skb_ext {
 #endif
 
 struct sk_buff_head {
-	/* These two members must be first. */
-	struct sk_buff	*next;
-	struct sk_buff	*prev;
+	/* These two members must be first to match sk_buff. */
+	struct_group_tagged(sk_buff_list, list,
+		struct sk_buff	*next;
+		struct sk_buff	*prev;
+	);
 
 	__u32		qlen;
 	spinlock_t	lock;
@@ -730,7 +732,7 @@ typedef unsigned char *sk_buff_data_t;
 struct sk_buff {
 	union {
 		struct {
-			/* These two members must be first. */
+			/* These two members must be first to match sk_buff_head. */
 			struct sk_buff		*next;
 			struct sk_buff		*prev;
 
@@ -1976,8 +1978,8 @@ static inline void __skb_insert(struct sk_buff *newsk,
 	 */
 	WRITE_ONCE(newsk->next, next);
 	WRITE_ONCE(newsk->prev, prev);
-	WRITE_ONCE(next->prev, newsk);
-	WRITE_ONCE(prev->next, newsk);
+	WRITE_ONCE(((struct sk_buff_list *)next)->prev, newsk);
+	WRITE_ONCE(((struct sk_buff_list *)prev)->next, newsk);
 	WRITE_ONCE(list->qlen, list->qlen + 1);
 }
 
@@ -2073,7 +2075,7 @@ static inline void __skb_queue_after(struct sk_buff_head *list,
 				     struct sk_buff *prev,
 				     struct sk_buff *newsk)
 {
-	__skb_insert(newsk, prev, prev->next, list);
+	__skb_insert(newsk, prev, ((struct sk_buff_list *)prev)->next, list);
 }
 
 void skb_append(struct sk_buff *old, struct sk_buff *newsk,
@@ -2083,7 +2085,7 @@ static inline void __skb_queue_before(struct sk_buff_head *list,
 				      struct sk_buff *next,
 				      struct sk_buff *newsk)
 {
-	__skb_insert(newsk, next->prev, next, list);
+	__skb_insert(newsk, ((struct sk_buff_list *)next)->prev, next, list);
 }
 
 /**
-- 
2.30.2

