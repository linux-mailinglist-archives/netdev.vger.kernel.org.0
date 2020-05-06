Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB8A31C6673
	for <lists+netdev@lfdr.de>; Wed,  6 May 2020 05:51:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726470AbgEFDvL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 May 2020 23:51:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726267AbgEFDvL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 May 2020 23:51:11 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A2E4C061A0F
        for <netdev@vger.kernel.org>; Tue,  5 May 2020 20:51:10 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id s8so1214479ybj.9
        for <netdev@vger.kernel.org>; Tue, 05 May 2020 20:51:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=baMkoKKwc34KjgQYvnkxb1ZizrCHm6JCYUgxLUNPnSo=;
        b=ceq2C8V4DxZTZXVxvllX7cLDyEwSMPRMhBPiciSfL926qANa1wCY0XYSPnl9PAegpd
         8yhZMGfcKb+5oF9h+W+gvCV6JRhWn1vbQsQOpYBXJh48qtsxYEIGoRPCqFl52KYH3XZ3
         ZF2EwvG2Uc6108wkpVXPx38qU/9ihuKbyPHUmTx2gLYgq2WVUrtX2oqistADhnokIMDn
         uXJpJqwJW7STTwsoRPMwX/CXqmAun3mgFC49PmRJd17X0kBh1ebpl6AKCPPqxCRIQoOo
         QgY5rrc7r8xlsOt4k5X7C/Wk1arw1Dd6wsMb9re5T9I/Am9An5dV23ps7EMnXewWYivM
         qKLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=baMkoKKwc34KjgQYvnkxb1ZizrCHm6JCYUgxLUNPnSo=;
        b=SWI34c1pb5RRRXo1CnsLM72LutbuxTgCXdU1kZ7hf5fYbAYpnXvDK+ZdFDc0vsdntF
         QMTuFV2CclFQDmZGuPya7SUaO1y5KKzcAJwKHMgaZ0MkcqkZeAXjuzneoSA3lSAO1UUr
         3sah76KLrH4gvHhG+88M1aXjv8YYpqEzIdiydoJwA44v0NowkWnZeM92vSFpR4QoTY26
         PKDY0Tf8bTjNbf7oAq8tSYgufRSCYdeYmkZvzbWOn4+HvHQOscOTn78hmYeBqhHaAf5o
         meT0lLJyFBByntUuDb+5TyaxXUYmlRqMIyxE+p1UczR8oM2LIFEOdsY3XVcN/p44ZIb4
         fg9A==
X-Gm-Message-State: AGi0PuZsvZSD8YiWOp1fIxv7L8h9AJefeJvTFZn165QelECqw3QUGrIt
        87NOAZVG5GiHnjKycwKVR+0f7cOd40iJ+g==
X-Google-Smtp-Source: APiQypLllcMUrAcgiNMqvFmrdjMVkJ5stYHPuaGO6vocjF4EkrLAJdcHWVSfIRIy7zVH6gpDU2mIlDguKW3mVQ==
X-Received: by 2002:a5b:443:: with SMTP id s3mr10123223ybp.14.1588737069210;
 Tue, 05 May 2020 20:51:09 -0700 (PDT)
Date:   Tue,  5 May 2020 20:51:06 -0700
Message-Id: <20200506035106.187948-1-edumazet@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.26.2.526.g744177e7f7-goog
Subject: [PATCH net] selftests: net: tcp_mmap: clear whole tcp_zerocopy_receive
 struct
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Arjun Roy <arjunroy@google.com>,
        Soheil Hassas Yeganeh <soheil@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We added fields in tcp_zerocopy_receive structure,
so make sure to clear all fields to not pass garbage to the kernel.

We were lucky because recent additions added 'out' parameters,
still we need to clean our reference implementation, before folks
copy/paste it.

Fixes: c8856c051454 ("tcp-zerocopy: Return inq along with tcp receive zerocopy.")
Fixes: 33946518d493 ("tcp-zerocopy: Return sk_err (if set) along with tcp receive zerocopy.")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Arjun Roy <arjunroy@google.com>
Cc: Soheil Hassas Yeganeh <soheil@google.com>
---
 tools/testing/selftests/net/tcp_mmap.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/net/tcp_mmap.c b/tools/testing/selftests/net/tcp_mmap.c
index 35505b31e5cc092453ea7b72d9dba45bed2d6549..62171fd638c817dabe2d988f3cfae74522112584 100644
--- a/tools/testing/selftests/net/tcp_mmap.c
+++ b/tools/testing/selftests/net/tcp_mmap.c
@@ -165,9 +165,10 @@ void *child_thread(void *arg)
 			socklen_t zc_len = sizeof(zc);
 			int res;
 
+			memset(&zc, 0, sizeof(zc));
 			zc.address = (__u64)((unsigned long)addr);
 			zc.length = chunk_size;
-			zc.recv_skip_hint = 0;
+
 			res = getsockopt(fd, IPPROTO_TCP, TCP_ZEROCOPY_RECEIVE,
 					 &zc, &zc_len);
 			if (res == -1)
-- 
2.26.2.526.g744177e7f7-goog

