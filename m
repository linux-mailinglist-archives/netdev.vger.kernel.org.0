Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B71571C7620
	for <lists+netdev@lfdr.de>; Wed,  6 May 2020 18:21:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729829AbgEFQVU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 May 2020 12:21:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729251AbgEFQVT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 May 2020 12:21:19 -0400
Received: from mail-qv1-xf4a.google.com (mail-qv1-xf4a.google.com [IPv6:2607:f8b0:4864:20::f4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5AB6C061A0F
        for <netdev@vger.kernel.org>; Wed,  6 May 2020 09:21:18 -0700 (PDT)
Received: by mail-qv1-xf4a.google.com with SMTP id ck5so2745712qvb.18
        for <netdev@vger.kernel.org>; Wed, 06 May 2020 09:21:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=2u/1fFkR7OvVjVUi9syBUT1jm6aslRkxBVWUoNqHPGM=;
        b=XdPlgDkFszU3AS1+ZDtOBLcIV+Zkc6dxyWGMqN3/F/Bvv389Xrj0S6zSqrEgEtRaZk
         ILKU8xS4TNTwl/DcX8ti5UWMrCppqY38Y8txwarfTKseKSz5vZyKVen31xzAtiyeoX3/
         7RdDvnLGDv/NA8idNCc8NPLQWDKX/fsKtuQPHNNVn7nkt7BtMEwlUBV0IpMCjjvl9VQm
         K1qL2pv+cASE9rtxkNceTaZOUgqOURSoecYeiDmQw7zYWt9UgS0SgCKut0Dd1pnagds8
         WSrMFV9A5YhVXFYR1FV37xYS7+xIzc9+vvcZg3iIM5F6JCLKWO4qbHRzo8SSlRMAuoq/
         bSEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=2u/1fFkR7OvVjVUi9syBUT1jm6aslRkxBVWUoNqHPGM=;
        b=t/9N9Fl4j9yN/WQpw8a7YZRf2VXcYddyFOOFlBdeemg0EFRiB+bBX31Q3YxoHgSY35
         72+3r10je+NJrpCa13Iq2UXjaKEj4s5oG7zTHyLaF0wAqmHFiLqM0luGZ9W0sjQcTYeg
         MHhLdxofK3ttW1yFphZiU39PK2Mv+IOK1Od8zB7FFnqMjvzbMp9w76DsiXD+f/b5CPMB
         IxW1PaVnp0MU+bmaeMkeeMAVSCHCqIMOHUvw1uG5vuw4VUP0b2T+JL5dFJyF7TdGB29h
         lMo4E7M0Qr2ea3ztUOLVSJeRK9LhHJhvm/ROxbhDLR+TNJYWppFJWunvEmwNkxUyq7DD
         T4rA==
X-Gm-Message-State: AGi0PuZ5wF2zJbW3nUee/QLUHarTR94DhA2h/zfSSgcJWVFH8dNLFVcS
        j27kZ0H9IZ54MkstwGTgaTtDtewEzdp/uw==
X-Google-Smtp-Source: APiQypKjvJU5y+LNWrsavQu9bEFLJKgK5+ob6vKG/mfUcW5y9AKhkti9oIozg9xqdXWo9Yi8JVbNtAre0vU8Gw==
X-Received: by 2002:ad4:4dc8:: with SMTP id cw8mr9250195qvb.83.1588782077984;
 Wed, 06 May 2020 09:21:17 -0700 (PDT)
Date:   Wed,  6 May 2020 09:21:15 -0700
Message-Id: <20200506162115.172485-1-edumazet@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.26.2.526.g744177e7f7-goog
Subject: [PATCH net] selftests: net: tcp_mmap: fix SO_RCVLOWAT setting
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Soheil Hassas Yeganeh <soheil@google.com>,
        Arjun Roy <arjunroy@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Since chunk_size is no longer an integer, we can not
use it directly as an argument of setsockopt().

This patch should fix tcp_mmap for Big Endian kernels.

Fixes: 597b01edafac ("selftests: net: avoid ptl lock contention in tcp_mmap")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Soheil Hassas Yeganeh <soheil@google.com>
Cc: Arjun Roy <arjunroy@google.com>
---
 tools/testing/selftests/net/tcp_mmap.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/net/tcp_mmap.c b/tools/testing/selftests/net/tcp_mmap.c
index 62171fd638c817dabe2d988f3cfae74522112584..4555f88252bafd31d6c225590316f03b08d3b132 100644
--- a/tools/testing/selftests/net/tcp_mmap.c
+++ b/tools/testing/selftests/net/tcp_mmap.c
@@ -282,12 +282,14 @@ static void setup_sockaddr(int domain, const char *str_addr,
 static void do_accept(int fdlisten)
 {
 	pthread_attr_t attr;
+	int rcvlowat;
 
 	pthread_attr_init(&attr);
 	pthread_attr_setdetachstate(&attr, PTHREAD_CREATE_DETACHED);
 
+	rcvlowat = chunk_size;
 	if (setsockopt(fdlisten, SOL_SOCKET, SO_RCVLOWAT,
-		       &chunk_size, sizeof(chunk_size)) == -1) {
+		       &rcvlowat, sizeof(rcvlowat)) == -1) {
 		perror("setsockopt SO_RCVLOWAT");
 	}
 
-- 
2.26.2.526.g744177e7f7-goog

