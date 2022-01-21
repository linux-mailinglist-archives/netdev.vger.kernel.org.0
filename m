Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB46A49587A
	for <lists+netdev@lfdr.de>; Fri, 21 Jan 2022 04:11:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232434AbiAUDLS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Jan 2022 22:11:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232195AbiAUDLR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Jan 2022 22:11:17 -0500
Received: from mail-pf1-x435.google.com (mail-pf1-x435.google.com [IPv6:2607:f8b0:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CA69C061574;
        Thu, 20 Jan 2022 19:11:17 -0800 (PST)
Received: by mail-pf1-x435.google.com with SMTP id x37so3676019pfh.8;
        Thu, 20 Jan 2022 19:11:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=QMt8CBaVoOGqhQNb8h5x35eHZtIPLuhA30PSqH5cdwo=;
        b=hyQYLuGbXdl/ufPwPHJsFvQZ/B+sJCyCsF5KrKlmmnmRwVo0Epi0tKI2KQJd+UV8tg
         tGzNuEAogjUhT3+Cb16coVs9v7IgbnP+DSu24D8WqvoBYQNttb1iIxip3z4gGxWyTC89
         Kc3dpyJVRWd/9g6q6+Ugk5vMIVNI7M2QLB59ZT7jM/uNO1nOSnBIEsOAM7AKwGKEDnMy
         xKPOC/etJKIHFBwXjyaQFC2GsgrwsNN/w8ITBP7cOOQY4Ur7pVqrIqldgymeUTOguQVT
         OOYnAz+YX7IFn2LbAQqQCF1TnPLiJBQvHHPlMa7P8sSVOapncYpBWy43vVhNBZRMKEyE
         mAJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=QMt8CBaVoOGqhQNb8h5x35eHZtIPLuhA30PSqH5cdwo=;
        b=sEt+2Ogeuk1/b6xKdCX4W8t3oJJ4FMbQaFXUvbENut+IWyktQT8rLRN6TFc59zE9dY
         noxctzCSeqFNJZuJyL8Y5UC/yPfig5FPebRxEws5D3k0AKtotV6mDrZvFaLpx8jxkXJL
         TPMrRC9gApAYI6EkOavoBcsK71b3BndUOyMUsqACvPGKGKpSKHnmWNdaFE07ltU0RsRf
         Hs7B1hd0VgCRpDgW2hI0iwRbRZMN0JnYlewYIcjjgaa87gDH+39c2Ei9eddNe/l1TCaR
         Br7594I7NA0iA0MX7QQHmfyO1WaITbFu4oJ9yMLyzt6/z+MM6XJr9tOMYfuF7cwXFnxn
         1wKw==
X-Gm-Message-State: AOAM532g3oVUNmij6FTXSz2PYHD+MiQzuYOccCaWCr/3MSw7HwV6alOw
        Pbcm3RcrtEpkDa8PMfYAh0g8gTaqeG07axI6jLJ57OgC
X-Google-Smtp-Source: ABdhPJwcy+HPI3QbK9JHRMaNoOHpkjuVFn6sl71ADoHcjsCWyiRnhNJp5+Y5D/CjqTplthkBzd6CXA==
X-Received: by 2002:a63:ad0a:: with SMTP id g10mr1455405pgf.493.1642734675584;
        Thu, 20 Jan 2022 19:11:15 -0800 (PST)
Received: from localhost.localdomain ([106.11.30.62])
        by smtp.gmail.com with ESMTPSA id h29sm4420668pfr.156.2022.01.20.19.11.12
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 20 Jan 2022 19:11:15 -0800 (PST)
From:   ycaibb <ycaibb@gmail.com>
To:     edumazet@google.com, davem@davemloft.net, yoshfuji@linux-ipv6.org,
        dsahern@kernel.org, kuba@kernel.org, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com, john.fastabend@gmail.com,
        kpsingh@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        bpf@vger.kernel.org, ycaibb@gmail.com
Subject: [PATCH] ipv4: fix lock leaks
Date:   Fri, 21 Jan 2022 11:11:08 +0800
Message-Id: <20220121031108.4813-1-ycaibb@gmail.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ryan Cai <ycaibb@gmail.com>

In methods listening_get_first and listening_get_first in tcp_ipv4.c, there are lock leaks when seq_sk_match returns true.

Signed-off-by: Ryan Cai <ycaibb@gmail.com>
---
 net/ipv4/tcp_ipv4.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
index 13d868c43284..714107766035 100644
--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -2329,6 +2329,7 @@ static void *listening_get_first(struct seq_file *seq)
 		inet_lhash2_for_each_icsk(icsk, &ilb2->head) {
 			sk = (struct sock *)icsk;
 			if (seq_sk_match(seq, sk))
+				spin_unlock(&ilb2->lock);
 				return sk;
 		}
 		spin_unlock(&ilb2->lock);
@@ -2407,6 +2408,7 @@ static void *established_get_first(struct seq_file *seq)
 		spin_lock_bh(lock);
 		sk_nulls_for_each(sk, node, &tcp_hashinfo.ehash[st->bucket].chain) {
 			if (seq_sk_match(seq, sk))
+				spin_unlock_bh(lock);
 				return sk;
 		}
 		spin_unlock_bh(lock);
-- 
2.33.0

