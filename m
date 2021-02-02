Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA70C30CBC6
	for <lists+netdev@lfdr.de>; Tue,  2 Feb 2021 20:36:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233297AbhBBTfF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Feb 2021 14:35:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239805AbhBBTex (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Feb 2021 14:34:53 -0500
Received: from mail-qk1-x74a.google.com (mail-qk1-x74a.google.com [IPv6:2607:f8b0:4864:20::74a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5EE49C06174A
        for <netdev@vger.kernel.org>; Tue,  2 Feb 2021 11:34:10 -0800 (PST)
Received: by mail-qk1-x74a.google.com with SMTP id m64so18323978qke.12
        for <netdev@vger.kernel.org>; Tue, 02 Feb 2021 11:34:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:message-id:mime-version:subject:from:to:cc;
        bh=7mjFDBlLOrroTL2nKpGO/1sBwkxR1/DzFWmT8k4ca/Y=;
        b=XZji5f4QZcJc3cciIxV/ZUFt8q7jQOeZ3dgN77mV4En1eXvNdun9Lyfa2A3eQpCqvV
         WL/iOwnSKik1JW4l2PEPR+yskCKOfARooFtvWOAU1CRfnV279Uv86+qrHQMGj9kkWz8k
         OCGoaMiA/XxM8snEQtRhc0RqlIgIkBA9jHrw59UA9dRAKmoW2BVR799V2H8iMU5yazr2
         WNrxJBccSz9HD/dm/SSAgQvGunJHQCpWBaoZOkHAdcdkmItuf15tgapNPvy1a9dNBR19
         XURcSGtrO5FqlOcKWDo2SnVZqELVe4rh9BnRLZIYNMcXZqge+WNuA0mDctHSS7+3wXGW
         75Vw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:message-id:mime-version:subject:from
         :to:cc;
        bh=7mjFDBlLOrroTL2nKpGO/1sBwkxR1/DzFWmT8k4ca/Y=;
        b=U/eRNju79dB8KFSEanyFPyjAglrBn9S/fj1IO95jrliCIsTBBsUK5Ns8NCVvHZxWCr
         gAJmkvctFaVr/VdXolCS67eiqvViKJpxBXDpbFYkbNXz9fSknrut0gDg9+mcoV0BHHgr
         CzjIsSkTqZB/sL4AjAzLFEao5YgSGXpY49AGKRk1owOym755pjoiuodXQnBDk3nmRDst
         Jlr6LobIJo3K13I5Qpa2OKCUQMOhsj5fA65eDYTHZN5kwrgYGiSlmi3DNqUuQw5q67dy
         nbS9ldClJ02vaHk3PgQuG2fKaDUKBmjaj321gNC+eX22mumdO1jhZXSRiE9u9riVNIaS
         aMKA==
X-Gm-Message-State: AOAM530ro9rB9Nj0IvmFloRAbVeRPt52OskYumPBs9z7PP1TjQ8KH0qk
        /fi+9/OruUjeNwC3N7EiUimYlKqA6JU=
X-Google-Smtp-Source: ABdhPJyStzGcJ1rYDikmQovo9rj/TamT+xJ23SIcDyr0EAfENN8pKceycOychwfR3Kuafu02XWw0mcSqkc4=
Sender: "weiwan via sendgmr" <weiwan@weiwan.svl.corp.google.com>
X-Received: from weiwan.svl.corp.google.com ([2620:15c:2c4:201:b40a:93c0:d2d6:71e3])
 (user=weiwan job=sendgmr) by 2002:ad4:4f41:: with SMTP id eu1mr21991208qvb.34.1612294449569;
 Tue, 02 Feb 2021 11:34:09 -0800 (PST)
Date:   Tue,  2 Feb 2021 11:34:08 -0800
Message-Id: <20210202193408.1171634-1-weiwan@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.30.0.365.g02bc693789-goog
Subject: [PATCH net-next] tcp: use a smaller percpu_counter batch size for sk_alloc
From:   Wei Wang <weiwan@google.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     Eric Dumazet <edumazet@google.com>,
        Soheil Hassas Yeganeh <soheil@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently, a percpu_counter with the default batch size (2*nr_cpus) is
used to record the total # of active sockets per protocol. This means
sk_sockets_allocated_read_positive() could be off by +/-2*(nr_cpus^2).
This under/over-estimation could lead to wrong memory suppression
conditions in __sk_raise_mem_allocated().
Fix this by using a more reasonable fixed batch size of 16.

See related commit cf86a086a180 ("net/dst: use a smaller percpu_counter
batch for dst entries accounting") that addresses a similar issue.

Signed-off-by: Wei Wang <weiwan@google.com>
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: Soheil Hassas Yeganeh <soheil@google.com>
---
 include/net/sock.h | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/include/net/sock.h b/include/net/sock.h
index 129d200bccb4..690e496a0e79 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -1350,14 +1350,18 @@ sk_memory_allocated_sub(struct sock *sk, int amt)
 	atomic_long_sub(amt, sk->sk_prot->memory_allocated);
 }
 
+#define SK_ALLOC_PERCPU_COUNTER_BATCH 16
+
 static inline void sk_sockets_allocated_dec(struct sock *sk)
 {
-	percpu_counter_dec(sk->sk_prot->sockets_allocated);
+	percpu_counter_add_batch(sk->sk_prot->sockets_allocated, -1,
+				 SK_ALLOC_PERCPU_COUNTER_BATCH);
 }
 
 static inline void sk_sockets_allocated_inc(struct sock *sk)
 {
-	percpu_counter_inc(sk->sk_prot->sockets_allocated);
+	percpu_counter_add_batch(sk->sk_prot->sockets_allocated, 1,
+				 SK_ALLOC_PERCPU_COUNTER_BATCH);
 }
 
 static inline u64
-- 
2.30.0.365.g02bc693789-goog

