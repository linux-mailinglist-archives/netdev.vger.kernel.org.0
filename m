Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8F0F9D1949
	for <lists+netdev@lfdr.de>; Wed,  9 Oct 2019 21:56:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731590AbfJIT4E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Oct 2019 15:56:04 -0400
Received: from mail-pg1-f201.google.com ([209.85.215.201]:36836 "EHLO
        mail-pg1-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730490AbfJIT4D (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Oct 2019 15:56:03 -0400
Received: by mail-pg1-f201.google.com with SMTP id h36so2457275pgb.3
        for <netdev@vger.kernel.org>; Wed, 09 Oct 2019 12:56:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=HY7z8JgUwCkZwIzYXPlScRPd3CyL4dT4HGyioRN4tBw=;
        b=Bm9Z+TT+I3J2lu1mte4p3EhD5fAd9IumLBsQaecVML0XzT4kuMzD0nCJZwGADDhv2f
         7PbvQPm+oSZw0PL0kgqKyvOOas6jcFrgEfKTxhdNobTQvsmZjrHaw0sWjcNGZVyk5oSA
         ClWhff43GI7AHBVEixfc1k/NNqwUqLn2iVJiQx1GISuO9bwYbIkZLDfo1vUBhWg/YF36
         QDjtmLyHh1NK7rtDCtGyFHqOCCUzXUe8yD61BzFVKRQnCIv/I7mQExt9+kwC3/dSmjAT
         zbhXkGndOT+mU1zmjlogBg+cHrxQJxq313VJ/1jRftR3ee3alJ45HwnP1HMfo8VUqdN4
         xFyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=HY7z8JgUwCkZwIzYXPlScRPd3CyL4dT4HGyioRN4tBw=;
        b=H1lR4i5vD8qPOZQ3qBFOOpmjuKXqCAJ4Olh4UzC9Egm4s3F0MD49socaA0hAb2eR9X
         0bw8n8/TPQ+oI7poEMQTkOsXFdTtx99nXJ2AeZ1KWKNndh3pfNOpNVYea6Zfu/O531xv
         +SdmHodE0CqUnwZUSEPyrUOdiz6VMbpdyk1xtybOJXs0r+cFSSCkiCBg8KTp8tBpgwSX
         pLtxvwdHGwRq2HZhoR9dmtaUGIFUcGyxhSYQPet2uIZRSKq7PB16MgggG78t/a1/T3BU
         K6aCF03bJw4jkHwa98l69jzrEuNdmYo5cAUO7Ydv0n+7qka4sIf76RBAnRbNewO3QHHu
         wM6Q==
X-Gm-Message-State: APjAAAVpYAbVtbkmeGemJK7oH69KZdK05FLbYMq++tVsTunCkQF6s+gI
        t2H7ukOMz9qRRuchwVFUshDvPjDxsovTHg==
X-Google-Smtp-Source: APXvYqw1/YnMufdVOBBRjUtBPdSZ3cygDjwmd2ACe8tFteHzWc3ZIbbI125bvoa5pbEhr4nww5A2KlqlKPBtEQ==
X-Received: by 2002:a63:4e09:: with SMTP id c9mr5934523pgb.98.1570650962330;
 Wed, 09 Oct 2019 12:56:02 -0700 (PDT)
Date:   Wed,  9 Oct 2019 12:55:53 -0700
Message-Id: <20191009195553.154443-1-edumazet@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.23.0.581.g78d2f28ef7-goog
Subject: [PATCH net] net: avoid possible false sharing in sk_leave_memory_pressure()
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

As mentioned in https://github.com/google/ktsan/wiki/READ_ONCE-and-WRITE_ONCE#it-may-improve-performance
a C compiler can legally transform :

if (memory_pressure && *memory_pressure)
        *memory_pressure = 0;

to :

if (memory_pressure)
        *memory_pressure = 0;

Fixes: 0604475119de ("tcp: add TCPMemoryPressuresChrono counter")
Fixes: 180d8cd942ce ("foundations of per-cgroup memory pressure controlling.")
Fixes: 3ab224be6d69 ("[NET] CORE: Introducing new memory accounting interface.")
Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 net/core/sock.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/core/sock.c b/net/core/sock.c
index fac2b4d80de5e54c77628073d7930bddf8a10cb3..50647a10fdb7f050e963e2734f0d3555fa4bd7aa 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -2334,8 +2334,8 @@ static void sk_leave_memory_pressure(struct sock *sk)
 	} else {
 		unsigned long *memory_pressure = sk->sk_prot->memory_pressure;
 
-		if (memory_pressure && *memory_pressure)
-			*memory_pressure = 0;
+		if (memory_pressure && READ_ONCE(*memory_pressure))
+			WRITE_ONCE(*memory_pressure, 0);
 	}
 }
 
-- 
2.23.0.581.g78d2f28ef7-goog

