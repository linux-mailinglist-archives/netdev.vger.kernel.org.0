Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CFE623BDB72
	for <lists+netdev@lfdr.de>; Tue,  6 Jul 2021 18:36:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230187AbhGFQel (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Jul 2021 12:34:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230129AbhGFQei (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Jul 2021 12:34:38 -0400
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94CDEC06175F;
        Tue,  6 Jul 2021 09:31:59 -0700 (PDT)
Received: by mail-pf1-x430.google.com with SMTP id q10so3762845pfj.12;
        Tue, 06 Jul 2021 09:31:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=87DPVRnOYK2PwLLhI2+qCBcidS77vkWMsF0VtVTxOuc=;
        b=DM4LQvZivFRrawA7QI05xB6Tib3mVYjGnHZHoqId0bTHt9Tvs4ISvNDb4px0JHIqFn
         sbTiO3LeRwReKAIvQ1lVpsG9KdkUESM1N6vHk8CXWYvzviwQkPE+q1xsvw0x7QX9VL8p
         sg7f/S0mxmfCndthQYmdzKvb4m8hn1fmwKfqSUnRuIiSu2ufXzuXL7Ro27TtDUL2vIe2
         kx/YWDGeAswViiE1MExq4ghyBi4Tj3pl/SmH5IdDRyKQtgJv0hHPG0EnsfYWv4p9kXmZ
         O3LoOKzzXN7yDUmfux9ZdHBQRHHCCphFrI8pBnwAbErafvV0KzSTx6rcxXRPFCOr+vn6
         1keQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=87DPVRnOYK2PwLLhI2+qCBcidS77vkWMsF0VtVTxOuc=;
        b=XTiKHWe/ZZ38Bxr2McbKOlVqIprWZA9XeYXzMz0WpY0gl82OqwalMSiE8WH4NAf1/R
         C8SzZbE61uG1Tvbq4oj99BCt2yPidAMUS24A/gAWcc3PxjnKnYWBmgpvlvlATiqmGGSM
         EKfw2ZwmPBc84LNe1Ad73c3b0KttdNoYFS87d1pLptEsjZc0hAMR181KgbUS1BHlCv+0
         lmRiK2DfYgnC9uPUTWjdTaIsukfTXv8yBVvGQXUms3UNiqmd7jwDVnYNDqyRzXzf7tIZ
         UgJxzwSbboy1NIP0WYiew52+lRdK/PIm4s09nXAo6ZilMnb0OZ+pF42QKt9LWrjgiP+T
         2TaA==
X-Gm-Message-State: AOAM531mrrhUtdnjq2q7OnnZcljgvtjiBBCNaltZ23auYI7CUKW5GX6P
        eavA2crU/EOXHYDJJDWo0Sk=
X-Google-Smtp-Source: ABdhPJxQJvAp6+F7sEgZcsWfRLI7194NY4C606/+mt39uOlPFBY3NrTTGUla2utMMyPr0jcF4WPJjg==
X-Received: by 2002:a63:5059:: with SMTP id q25mr11364969pgl.9.1625589119174;
        Tue, 06 Jul 2021 09:31:59 -0700 (PDT)
Received: from localhost.localdomain (51.sub-174-204-201.myvzw.com. [174.204.201.51])
        by smtp.gmail.com with ESMTPSA id b4sm14942570pji.52.2021.07.06.09.31.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Jul 2021 09:31:58 -0700 (PDT)
From:   John Fastabend <john.fastabend@gmail.com>
To:     ast@kernel.org, daniel@iogearbox.net, andriin@fb.com,
        xiyou.wangcong@gmail.com
Cc:     john.fastabend@gmail.com, bpf@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH bpf v3 2/2] bpf, sockmap: sk_prot needs inuse_idx set for proc stats
Date:   Tue,  6 Jul 2021 09:31:50 -0700
Message-Id: <20210706163150.112591-3-john.fastabend@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210706163150.112591-1-john.fastabend@gmail.com>
References: <20210706163150.112591-1-john.fastabend@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Proc socket stats use sk_prot->inuse_idx value to record inuse sock stats.
We currently do not set this correctly from sockmap side. The result is
reading sock stats '/proc/net/sockstat' gives incorrect values. The
socket counter is incremented correctly, but because we don't set the
counter correctly when we replace sk_prot we may omit the decrement.

Fixes: 604326b41a6fb ("bpf, sockmap: convert to generic sk_msg interface")
Signed-off-by: John Fastabend <john.fastabend@gmail.com>
---
 net/core/sock_map.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/net/core/sock_map.c b/net/core/sock_map.c
index 60decd6420ca..27bdf768aa8c 100644
--- a/net/core/sock_map.c
+++ b/net/core/sock_map.c
@@ -185,10 +185,19 @@ static void sock_map_unref(struct sock *sk, void *link_raw)
 
 static int sock_map_init_proto(struct sock *sk, struct sk_psock *psock)
 {
+	int err;
+#ifdef CONFIG_PROC_FS
+	int idx = sk->sk_prot->inuse_idx;
+#endif
 	if (!sk->sk_prot->psock_update_sk_prot)
 		return -EINVAL;
 	psock->psock_update_sk_prot = sk->sk_prot->psock_update_sk_prot;
-	return sk->sk_prot->psock_update_sk_prot(sk, psock, false);
+	err = sk->sk_prot->psock_update_sk_prot(sk, psock, false);
+#ifdef CONFIG_PROC_FS
+	if (!err)
+		sk->sk_prot->inuse_idx = idx;
+#endif
+	return err;
 }
 
 static struct sk_psock *sock_map_psock_get_checked(struct sock *sk)
-- 
2.25.1

