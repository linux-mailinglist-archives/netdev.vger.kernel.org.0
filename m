Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6732436EB8E
	for <lists+netdev@lfdr.de>; Thu, 29 Apr 2021 15:47:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237419AbhD2NsA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Apr 2021 09:48:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237832AbhD2Nr7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Apr 2021 09:47:59 -0400
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FEAAC061342
        for <netdev@vger.kernel.org>; Thu, 29 Apr 2021 06:47:12 -0700 (PDT)
Received: by mail-wr1-x42e.google.com with SMTP id t18so9438516wry.1
        for <netdev@vger.kernel.org>; Thu, 29 Apr 2021 06:47:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=QdgOqG3N8NoAcJADfF2z8B9NTKycDIqg1ia12c/fZYc=;
        b=UM68g7XYs5/gTZCOix9BtmchrVRoD1W+BgHLFEdn+Bf0VCGZSDISCR92YwvXcpfT9x
         aRdyyRGPlnrZHZU8RICPPOWu9nMGeVObKXmwTRBEVt6ad5J/Mu09rNUtb7MAYof+IJ9s
         QST+TLqItfgbywCFCeyTuWufaYLmfFgA4mq/A=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=QdgOqG3N8NoAcJADfF2z8B9NTKycDIqg1ia12c/fZYc=;
        b=b3xbESO3RQzmHOnJ132q1Rktj1L7htTZcU1ihn6E4kitxvqJOxS7Lu07yDh1E9sZva
         6OOABSNobkMIvqZ2b9yNmcl7QKu+bVuHEV5kf5PlerBTTyu/lGqwsSzQfi/D0p0gpDz1
         Mbn4T00o+BDuEHxrfM7hggyoUV93N1AafWmY+uy9YqR+N4s2rJx9XFCPX+Sg2+V3PD4k
         4h1z6x5irOAsvc3ng8oxQvM6vrRFv6kKpOriXzl3hQ8k7qKBvivFLRYKgq5qCVWI33E5
         nie6hxdPtMlfmPtnAxiHZwAzPpkBv/60VKUCz9ivH4LjsLg4Dec0HWI8piY8AzVFdMlr
         Rl1g==
X-Gm-Message-State: AOAM533i6bXk+AdrEVlmxq7S9gTgzbE9P3t+Zeow/0JsJPdhTVwyT+Ut
        kybOQpP7GMEnbsPLlUQ4aK+ZIg==
X-Google-Smtp-Source: ABdhPJzBNsKBTsNJidzrYzujh6W7/cmshdmEYtoyNxbD0YWX9LTkIAo6uG3NbjdcyeeRsISHpgeg8g==
X-Received: by 2002:a5d:59a9:: with SMTP id p9mr3796298wrr.289.1619704031046;
        Thu, 29 Apr 2021 06:47:11 -0700 (PDT)
Received: from localhost.localdomain (8.7.1.e.3.2.9.3.e.a.2.1.c.2.e.4.f.f.6.2.a.5.a.7.0.b.8.0.1.0.0.2.ip6.arpa. [2001:8b0:7a5a:26ff:4e2c:12ae:3923:e178])
        by smtp.gmail.com with ESMTPSA id x8sm5105592wru.70.2021.04.29.06.47.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Apr 2021 06:47:10 -0700 (PDT)
From:   Lorenz Bauer <lmb@cloudflare.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>
Cc:     kernel-team@cloudflare.com, Lorenz Bauer <lmb@cloudflare.com>,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH bpf-next 2/3] bpf: verifier: use copy_array for jmp_history
Date:   Thu, 29 Apr 2021 14:46:55 +0100
Message-Id: <20210429134656.122225-3-lmb@cloudflare.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210429134656.122225-1-lmb@cloudflare.com>
References: <20210429134656.122225-1-lmb@cloudflare.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Eliminate a couple needless kfree / kmalloc cycles by using
copy_array for jmp_history.

Signed-off-by: Lorenz Bauer <lmb@cloudflare.com>
---
 kernel/bpf/verifier.c | 13 +++++--------
 1 file changed, 5 insertions(+), 8 deletions(-)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 67d914b26a39..2b9623ac9288 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -926,16 +926,13 @@ static int copy_verifier_state(struct bpf_verifier_state *dst_state,
 			       const struct bpf_verifier_state *src)
 {
 	struct bpf_func_state *dst;
-	u32 jmp_sz = sizeof(struct bpf_idx_pair) * src->jmp_history_cnt;
 	int i, err;
 
-	if (dst_state->jmp_history_cnt < src->jmp_history_cnt) {
-		kfree(dst_state->jmp_history);
-		dst_state->jmp_history = kmalloc(jmp_sz, GFP_USER);
-		if (!dst_state->jmp_history)
-			return -ENOMEM;
-	}
-	memcpy(dst_state->jmp_history, src->jmp_history, jmp_sz);
+	dst_state->jmp_history = copy_array(dst_state->jmp_history, src->jmp_history,
+					    src->jmp_history_cnt, sizeof(struct bpf_idx_pair),
+					    GFP_USER);
+	if (!dst_state->jmp_history)
+		return -ENOMEM;
 	dst_state->jmp_history_cnt = src->jmp_history_cnt;
 
 	/* if dst has more stack frames then src frame, free them */
-- 
2.27.0

