Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 90BB2FCAF8
	for <lists+netdev@lfdr.de>; Thu, 14 Nov 2019 17:43:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726599AbfKNQnc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Nov 2019 11:43:32 -0500
Received: from mail-pf1-f202.google.com ([209.85.210.202]:46356 "EHLO
        mail-pf1-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726505AbfKNQnc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Nov 2019 11:43:32 -0500
Received: by mail-pf1-f202.google.com with SMTP id 187so5031634pfu.13
        for <netdev@vger.kernel.org>; Thu, 14 Nov 2019 08:43:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=JaRFB/C2ZTmi8sgCv1s5/pBHRFdrc2V1blJOszkYU40=;
        b=BlB5gtT6M9x5Tglc30JGnog6DlrMMFMwZAYPPjYRyYflFx9lwOlLkw402S58oMqTei
         y7X4Fkv5XUOSgXMb4zSrL8LSMYHaGVqf9TbIpoaw7kkvdBeJ1mv3mWQVtoWE0JXE2lOr
         wILcFof8tMGJ1Rf5NxpKw0jWJG12Oy1oLeOJebNl4giQjedtb88KZfSid3NPfjUu63AG
         /yQtdKXv3Aj16N/v67Im3gqLXANju1INcOPSs7s/37tz1Hph1rlrOgpbxavBZineSovr
         r34taPRG4ZDjeOW1umWr3DUZoyXKxYPdWiRzIs3Uo8Kc7oy49Ug0jbifIkuPzY/THpRO
         Qahw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=JaRFB/C2ZTmi8sgCv1s5/pBHRFdrc2V1blJOszkYU40=;
        b=df9pDqHZTsQipkLaIkFkZsyfUhrRQmt4kU25lcLQl7lxdNWcqJsExqLivNL0sfuA4d
         GhWgLL+rTFj6UZYFcz2ilufSftrAHR5dC4aQgQBVytyeBMfa3PEl60Kc3J75im5vKIUh
         ffsB+2z8vrsEC1HG/s+/40laYsGs1yWGw8Jk7DwTqpiIW4J6768MR/AXM28t5dxEEdcx
         T5pd3lgFwrd8VJUQPTYAUl3e+e+oAoDMBj/KhYZ9ZyMuGOwqKNX1Lv6qK3l1+Nx7kI9R
         GSoBy8rDUqmJvqWwGgrgRHpf32Db/Zu2L7SUY+Jw+YsEU1qN9nhZvjfd2ZeXthYKX6VL
         eKQg==
X-Gm-Message-State: APjAAAUHwkV6jPH/PFMU5OQZZUnGG//aX/xLL/KZ1dU3DfUXQE6BrqL8
        ouNXyZYkjIHBEjoxhh2w5tuq9aNSyj5T5g==
X-Google-Smtp-Source: APXvYqxay2+FSHa5Fut6wJOFe7vGYkw8s0yqt7g0vIZkAM4kM+b1xKeuYqmqv+y+v/RIyAg65T1bDJ43FbzkFw==
X-Received: by 2002:a63:d703:: with SMTP id d3mr10890301pgg.102.1573749810899;
 Thu, 14 Nov 2019 08:43:30 -0800 (PST)
Date:   Thu, 14 Nov 2019 08:43:27 -0800
Message-Id: <20191114164327.171997-1-edumazet@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.24.0.432.g9d3f5f5b63-goog
Subject: [PATCH net-next] selftests: net: tcp_mmap should create detached threads
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

Since we do not plan using pthread_join() in the server do_accept()
loop, we better create detached threads, or risk increasing memory
footprint over time.

Fixes: 192dc405f308 ("selftests: net: add tcp_mmap program")
Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 tools/testing/selftests/net/tcp_mmap.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/net/tcp_mmap.c b/tools/testing/selftests/net/tcp_mmap.c
index 31ced79f4f25de89afe95a7214600b2eae42f057..0e73a30f0c2262e62a5ed1e2db6c7c8977bf44fa 100644
--- a/tools/testing/selftests/net/tcp_mmap.c
+++ b/tools/testing/selftests/net/tcp_mmap.c
@@ -270,6 +270,11 @@ static void setup_sockaddr(int domain, const char *str_addr,
 
 static void do_accept(int fdlisten)
 {
+	pthread_attr_t attr;
+
+	pthread_attr_init(&attr);
+	pthread_attr_setdetachstate(&attr, PTHREAD_CREATE_DETACHED);
+
 	if (setsockopt(fdlisten, SOL_SOCKET, SO_RCVLOWAT,
 		       &chunk_size, sizeof(chunk_size)) == -1) {
 		perror("setsockopt SO_RCVLOWAT");
@@ -288,7 +293,7 @@ static void do_accept(int fdlisten)
 			perror("accept");
 			continue;
 		}
-		res = pthread_create(&th, NULL, child_thread,
+		res = pthread_create(&th, &attr, child_thread,
 				     (void *)(unsigned long)fd);
 		if (res) {
 			errno = res;
-- 
2.24.0.432.g9d3f5f5b63-goog

