Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 97AE842A36D
	for <lists+netdev@lfdr.de>; Tue, 12 Oct 2021 13:38:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236270AbhJLLkD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Oct 2021 07:40:03 -0400
Received: from m15111.mail.126.com ([220.181.15.111]:51703 "EHLO
        m15111.mail.126.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236177AbhJLLkA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Oct 2021 07:40:00 -0400
X-Greylist: delayed 1841 seconds by postgrey-1.27 at vger.kernel.org; Tue, 12 Oct 2021 07:40:00 EDT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=126.com;
        s=s110527; h=From:Subject:Date:Message-Id; bh=sHHaDOnhNcxuYRU/Gc
        8plYu8LofSoJnRYwgUX7P/g3w=; b=kAMS/H7LA5Bacjx46zis0G+w9yJpjxL/Or
        dUGDhZntcZxJ2ox/D5HI+ZYHpKh+aTnzC/2N9jz+m7yAmH1t0BMIHiRlHBYhOjO2
        PLHpJtxYIozcv9Uk2vU2oXI4kBqQQXBWinu5VOwQDFqOVZ/wedoJLydaq27iBmqd
        esTJwJbRc=
Received: from localhost.localdomain (unknown [221.221.165.193])
        by smtp1 (Coremail) with SMTP id C8mowAB3EKxWbGVhG9KUBA--.10361S4;
        Tue, 12 Oct 2021 19:07:04 +0800 (CST)
From:   zhang kai <zhangkaiheb@126.com>
To:     davem@davemloft.net
Cc:     yoshfuji@linux-ipv6.org, dsahern@kernel.org, kuba@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        zhang kai <zhangkaiheb@126.com>
Subject: [PATCH] ipv4: only allow increasing fib_info_hash_size
Date:   Tue, 12 Oct 2021 19:06:58 +0800
Message-Id: <20211012110658.10166-1-zhangkaiheb@126.com>
X-Mailer: git-send-email 2.17.1
X-CM-TRANSID: C8mowAB3EKxWbGVhG9KUBA--.10361S4
X-Coremail-Antispam: 1Uf129KBjvJXoW7uFyDXw18KFWrZFW8XF1fWFg_yoW8Xrykpr
        yakw1ktFWDJFyxKr17X3WkGwnxJw18CF18GrZ2vrs5trnxGryUXayqkrWI9FWUAFZ7ZF48
        KFZ7KryfJFn8W3DanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07j8cTQUUUUU=
X-Originating-IP: [221.221.165.193]
X-CM-SenderInfo: x2kd0wxndlxvbe6rjloofrz/1tbi1xgq-l53XQooxgAAsL
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

and when failed to allocate memory, check fib_info_hash_size.

Signed-off-by: zhang kai <zhangkaiheb@126.com>
---
 net/ipv4/fib_semantics.c | 25 ++++++++++++++-----------
 1 file changed, 14 insertions(+), 11 deletions(-)

diff --git a/net/ipv4/fib_semantics.c b/net/ipv4/fib_semantics.c
index a632b66bc..7547708a9 100644
--- a/net/ipv4/fib_semantics.c
+++ b/net/ipv4/fib_semantics.c
@@ -1403,17 +1403,20 @@ struct fib_info *fib_create_info(struct fib_config *cfg,
 
 		if (!new_size)
 			new_size = 16;
-		bytes = new_size * sizeof(struct hlist_head *);
-		new_info_hash = fib_info_hash_alloc(bytes);
-		new_laddrhash = fib_info_hash_alloc(bytes);
-		if (!new_info_hash || !new_laddrhash) {
-			fib_info_hash_free(new_info_hash, bytes);
-			fib_info_hash_free(new_laddrhash, bytes);
-		} else
-			fib_info_hash_move(new_info_hash, new_laddrhash, new_size);
-
-		if (!fib_info_hash_size)
-			goto failure;
+
+		if (new_size > fib_info_hash_size) {
+			bytes = new_size * sizeof(struct hlist_head *);
+			new_info_hash = fib_info_hash_alloc(bytes);
+			new_laddrhash = fib_info_hash_alloc(bytes);
+			if (!new_info_hash || !new_laddrhash) {
+				fib_info_hash_free(new_info_hash, bytes);
+				fib_info_hash_free(new_laddrhash, bytes);
+
+				if (!fib_info_hash_size)
+					goto failure;
+			} else
+				fib_info_hash_move(new_info_hash, new_laddrhash, new_size);
+		}
 	}
 
 	fi = kzalloc(struct_size(fi, fib_nh, nhs), GFP_KERNEL);
-- 
2.17.1

