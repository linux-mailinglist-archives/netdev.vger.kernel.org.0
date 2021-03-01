Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE23332775D
	for <lists+netdev@lfdr.de>; Mon,  1 Mar 2021 07:07:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231670AbhCAGG6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Mar 2021 01:06:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231545AbhCAGGn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Mar 2021 01:06:43 -0500
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A34BC06174A;
        Sun, 28 Feb 2021 22:05:58 -0800 (PST)
Received: by mail-pf1-x42a.google.com with SMTP id i10so1593482pfk.4;
        Sun, 28 Feb 2021 22:05:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=jMWOZvS2/FrD2N+UR3nKIhFw7VUdZp63CYTyrcaoXAQ=;
        b=A1/Da6q7HcMaVcf0rFWlkJcK+ylFjr5FyiLab/uZz4/ActeAyTwuXRQgrSsvQO15LN
         vnYiNNW0NYahMP7mba4jHHo3OB0P8tUhKZA7rOKBOgDLkMsa7AJsxg34Hj4Pm1AzwlpJ
         ym9Q9d1WbfipieiLeh5i2ozEax0SsRv63PQHWnBxhK5gCWDpLHqqhcPdwzrsDYcf11N3
         u01g6Kj8R4ZqgXko9Kt/l0Vjszj+8PITtQWWKAOuNKWHXO84QVVEGZPZomQBw+t9StqL
         WBXN4/vHn7A/0TiRm2ZZGaG+zaFIxw+/FtVKJFZGMeiJKGR2x+t2TuvdCw28fuFWi9Pb
         7gIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=jMWOZvS2/FrD2N+UR3nKIhFw7VUdZp63CYTyrcaoXAQ=;
        b=qRn0BqmJUWfeTH1rdWGYJ116LQV/A1ghXnd/oqSMM8DspFOeXbsmmMq6xD3NUij1CO
         Evt5lM/Z07gHSxFWvHORaw35pDJGS7G/YBauN88NR6kbquNf1aBnqpABEXaastJGcKBp
         Sx0m2O6K4A5kQudIhHQidJZ9GMMj023+CE4K7XCen/8UnXvLJ42hW7wttqbaKDmbS2na
         1wsOSYe4mAfdTeuueEf7IeqOENHn93VnzINt8ueZwswQcQhh2us/ln9i3L9Q/dpKoIQL
         0sMzB+BmZTxhh3wHKAceR/6x5KU0s/MHEsWhQRq9yooPD7zRUw/2dN/pP+8NqTJM4xzz
         S+vA==
X-Gm-Message-State: AOAM530blUIW3Gz/NqYCHjDW+x+zODsghagL+o68j5Vd8Qd7GmQuzmMa
        FKxEd6rH7xs+5x8YjEJ5KXg=
X-Google-Smtp-Source: ABdhPJwvSGDWTbzt7ifBEWQXMedc4nMVANCMx9Nl+u7rPl/h6jNkdeeaAakkQkSM9JH7BApz551y/w==
X-Received: by 2002:a63:4343:: with SMTP id q64mr12240606pga.109.1614578757854;
        Sun, 28 Feb 2021 22:05:57 -0800 (PST)
Received: from localhost.localdomain ([122.10.161.207])
        by smtp.gmail.com with ESMTPSA id c8sm16426326pjv.18.2021.02.28.22.05.55
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 28 Feb 2021 22:05:57 -0800 (PST)
From:   Yejune Deng <yejune.deng@gmail.com>
To:     davem@davemloft.net, yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        kuba@kernel.org, eric.dumazet@gmail.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        yejune.deng@gmail.com
Subject: [PATCH] inetpeer: use div64_ul() and clamp_val() calculate inet_peer_threshold
Date:   Mon,  1 Mar 2021 14:05:48 +0800
Message-Id: <20210301060548.46289-1-yejune.deng@gmail.com>
X-Mailer: git-send-email 2.29.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In inet_initpeers(), struct inet_peer on IA32 uses 128 bytes in nowdays.
Get rid of the cascade and use div64_ul() and clamp_val() calculate that
will not need to be adjusted in the future as suggested by Eric Dumazet.

Suggested-by: Eric Dumazet <eric.dumazet@gmail.com>
Signed-off-by: Yejune Deng <yejune.deng@gmail.com>
---
 net/ipv4/inetpeer.c | 21 +++++++--------------
 1 file changed, 7 insertions(+), 14 deletions(-)

diff --git a/net/ipv4/inetpeer.c b/net/ipv4/inetpeer.c
index ff327a62c9ce..da21dfce24d7 100644
--- a/net/ipv4/inetpeer.c
+++ b/net/ipv4/inetpeer.c
@@ -65,7 +65,7 @@ EXPORT_SYMBOL_GPL(inet_peer_base_init);
 #define PEER_MAX_GC 32
 
 /* Exported for sysctl_net_ipv4.  */
-int inet_peer_threshold __read_mostly = 65536 + 128;	/* start to throw entries more
+int inet_peer_threshold __read_mostly;	/* start to throw entries more
 					 * aggressively at this stage */
 int inet_peer_minttl __read_mostly = 120 * HZ;	/* TTL under high load: 120 sec */
 int inet_peer_maxttl __read_mostly = 10 * 60 * HZ;	/* usual time to live: 10 min */
@@ -73,20 +73,13 @@ int inet_peer_maxttl __read_mostly = 10 * 60 * HZ;	/* usual time to live: 10 min
 /* Called from ip_output.c:ip_init  */
 void __init inet_initpeers(void)
 {
-	struct sysinfo si;
+	u64 nr_entries;
 
-	/* Use the straight interface to information about memory. */
-	si_meminfo(&si);
-	/* The values below were suggested by Alexey Kuznetsov
-	 * <kuznet@ms2.inr.ac.ru>.  I don't have any opinion about the values
-	 * myself.  --SAW
-	 */
-	if (si.totalram <= (32768*1024)/PAGE_SIZE)
-		inet_peer_threshold >>= 1; /* max pool size about 1MB on IA32 */
-	if (si.totalram <= (16384*1024)/PAGE_SIZE)
-		inet_peer_threshold >>= 1; /* about 512KB */
-	if (si.totalram <= (8192*1024)/PAGE_SIZE)
-		inet_peer_threshold >>= 2; /* about 128KB */
+	 /* 1% of physical memory */
+	nr_entries = div64_ul((u64)totalram_pages() << PAGE_SHIFT,
+			      100 * L1_CACHE_ALIGN(sizeof(struct inet_peer)));
+
+	inet_peer_threshold = clamp_val(nr_entries, 4096, 65536 + 128);
 
 	peer_cachep = kmem_cache_create("inet_peer_cache",
 			sizeof(struct inet_peer),
-- 
2.29.0

