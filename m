Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 87654ED7B0
	for <lists+netdev@lfdr.de>; Mon,  4 Nov 2019 03:24:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728783AbfKDCYV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 3 Nov 2019 21:24:21 -0500
Received: from mail-pf1-f201.google.com ([209.85.210.201]:33580 "EHLO
        mail-pf1-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728227AbfKDCYU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 3 Nov 2019 21:24:20 -0500
Received: by mail-pf1-f201.google.com with SMTP id s24so1772696pfd.0
        for <netdev@vger.kernel.org>; Sun, 03 Nov 2019 18:24:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=Q05kqVL/Ty7FnijlUDh0epzqdzqIKW0VGuQAGOJS4Nw=;
        b=ICW8MRAM4RCKZPJawciXLmo9jpT+H/6sBUI/bnKL51zhyVa6EYokUI2PIFGV334Iuk
         Qpj0p+ysgOhl4MwfkSR70OcZpzQaG4ZshWzVbYy3iH1HQ433LXrokQB6Z/CB1V+5KKm4
         ucQjpDhHe+siFi2ZtDOHOcNenQQxQXqMgqi0BxQaZAcnrQEjDDkrTqkQDKzGQexdT2gq
         xO9f5qS0kk/w5dPqSYY+5lzzOm52EAGwtvo+CfdKv9nl72OrtjzfFjk4EUn3djA3AnHL
         gcG/WwoMb/+7B3fz+bY1mGbeUTFjkWKxAUgv5kLelxa6Fbof2rOyFdOQOiNKDGoYmKUW
         tTNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=Q05kqVL/Ty7FnijlUDh0epzqdzqIKW0VGuQAGOJS4Nw=;
        b=NYDbmS82nH4tpamZyuxuqBVmT9rW1HQuqUW+Vspfpb5Gd5VxLA9vy+mk0G0r5EsHUm
         i+eA2abwKLSUktT+yA2GrNNOTE5kVtAe809Y8EhBfoqGV+MZOrWUThmKnG2BLPBAXVRK
         1DoOxF9qu7pmOqWImewzGwkIXnfUuz5pjC5dvWvyZ3yfTxpIL48xYIA8PAHY2DtttWA+
         G3IJOum0vpSeIw8Zi8Z6x+LgmprYiMLKEiX+z27IyDDnor6EBwwq+Kyjb5pIcEtf/+cP
         wHCKBzTEejdeFhLRfby1cGPId10hntagMajwp689YP00pEjS2e0tZVhbPmGX0h5AGsNH
         qOXw==
X-Gm-Message-State: APjAAAXLq9siUW/aoq0gN9OxhqOZgoxzWZiJ8W4XHWk6y6B/kMUMGU9d
        M6+NDFmLWkX1gQ0XlqtU+5GVHkA5Sage0Q==
X-Google-Smtp-Source: APXvYqxDIltpyezfq38egfcrpxYw7f3HiKjy17Ma75+Rw/gESCMpw2ctsrKg/V5EhsVfcvRemd6NNofpr5VlFQ==
X-Received: by 2002:a63:5960:: with SMTP id j32mr27480313pgm.281.1572834259791;
 Sun, 03 Nov 2019 18:24:19 -0800 (PST)
Date:   Sun,  3 Nov 2019 18:24:16 -0800
Message-Id: <20191104022416.100184-1-edumazet@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.24.0.rc1.363.gb1bccd3e3d-goog
Subject: [PATCH net-next] ipv6: use jhash2() in rt6_exception_hash()
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Faster jhash2() can be used instead of jhash(), since
IPv6 addresses have the needed alignment requirement.

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 net/ipv6/route.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/ipv6/route.c b/net/ipv6/route.c
index a63ff85fe14198fc23a5cbc7abcd107df5df00c8..c7a2022e64eb9de9e4300f0311dbff66281ec0a8 100644
--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -1475,11 +1475,11 @@ static u32 rt6_exception_hash(const struct in6_addr *dst,
 	u32 val;
 
 	net_get_random_once(&seed, sizeof(seed));
-	val = jhash(dst, sizeof(*dst), seed);
+	val = jhash2((const u32 *)dst, sizeof(*dst)/sizeof(u32), seed);
 
 #ifdef CONFIG_IPV6_SUBTREES
 	if (src)
-		val = jhash(src, sizeof(*src), val);
+		val = jhash2((const u32 *)src, sizeof(*src)/sizeof(u32), val);
 #endif
 	return hash_32(val, FIB6_EXCEPTION_BUCKET_SIZE_SHIFT);
 }
-- 
2.24.0.rc1.363.gb1bccd3e3d-goog

