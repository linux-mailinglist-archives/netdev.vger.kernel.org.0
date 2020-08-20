Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DDBC724C444
	for <lists+netdev@lfdr.de>; Thu, 20 Aug 2020 19:12:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730465AbgHTRMc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Aug 2020 13:12:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730523AbgHTRL3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Aug 2020 13:11:29 -0400
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 485C1C061387
        for <netdev@vger.kernel.org>; Thu, 20 Aug 2020 10:11:28 -0700 (PDT)
Received: by mail-pf1-x449.google.com with SMTP id a73so1616835pfa.10
        for <netdev@vger.kernel.org>; Thu, 20 Aug 2020 10:11:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=VQfBKsvDWx+HzFQd4Qe36rkEa5O6q5wzeJ4kSs1eZGM=;
        b=hBOeh3XMAs16M16NFXVYBnfpzGtiCG/irlj0yVBHy4h9MFN74LPP94HEpnJSw46xs0
         0/DVKAxaD16HMEhNDTdEm359yPuFJB1suezF2kYC5aS2/xy4GfRcDQYtseeBn+2Zw1Mg
         vq4VUPrvxxchDoMh1vSIbQiyTwKRlqkboeFiXtCjL9srfZoenKQNtdd7czsPtl/nfQQK
         SZq1MBy6NGdlrqDnJ9toVSV/jXvikmDm+A7pLPNDkOgh2WTNhqABn70HN9+2qhy96Mik
         IxUqnsI/uzPuIdhN/1UK8MF5I7S2n06Kp8ipoiMWDyq15Ct0Ii/rIYCo/eeJLIildyil
         quXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=VQfBKsvDWx+HzFQd4Qe36rkEa5O6q5wzeJ4kSs1eZGM=;
        b=hW5434lXkLBMhmzy2Ue+tZKHrGqJkyyD66aKN8S2vbWjXP6Vos/6lIK7oy1EL10hLe
         40ikUP+ZkTwrv9XbaN64IYU51Ddnca2v9xTnMr7df0HtlN4PyyfSttFzhCFqlT7/FwFN
         WVzB6FgXn6Ik93sQAu5/m41WRoG5DQVbSbWyTXFSQlec2EdOE7JF9VjHyk77KxWJ9y9q
         VU/BJBt4CyrwJ65J6quonQF2q3lxNTxD510SDZHB5l+kofqq6mxRKrXu38G2ZqY24jwc
         0ezV87rEHQW0pqgCvY5AfkSAn7Tx89NiDPJnnvu/v88hWqI3U04oialya4gFzYcm3kvb
         zFVw==
X-Gm-Message-State: AOAM532ksxf7O4SJm7ezLahRDBif523FFcF5nvnE64QSponnt11IKjgR
        LVLJr8CIt9TKRxo8EFcj+zh0uQK1l3En0g==
X-Google-Smtp-Source: ABdhPJwVhZ0C0P+499YBfdv/2KLJ/qiOsRSUUoEGXVAObJ0RrJR1zp7NSauvUKr1j6egdWsfWxvg5kPcqiFjrA==
X-Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:7220:84ff:fe09:1424])
 (user=edumazet job=sendgmr) by 2002:a17:90b:194d:: with SMTP id
 nk13mr3062339pjb.220.1597943487612; Thu, 20 Aug 2020 10:11:27 -0700 (PDT)
Date:   Thu, 20 Aug 2020 10:11:17 -0700
In-Reply-To: <20200820171118.1822853-1-edumazet@google.com>
Message-Id: <20200820171118.1822853-3-edumazet@google.com>
Mime-Version: 1.0
References: <20200820171118.1822853-1-edumazet@google.com>
X-Mailer: git-send-email 2.28.0.297.g1956fa8f8d-goog
Subject: [PATCH net-next 2/3] selftests: net: tcp_mmap: Use huge pages in send path
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

There are significant gains using huge pages when
available, as shown in [1].

This patch adds mmap_large_buffer() and uses it
in client side (tx path of this reference tool)

Following patch will use the feature for server side.

[1] https://patchwork.ozlabs.org/project/netdev/patch/20200820154359.1806305-1-edumazet@google.com/

Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Arjun Roy <arjunroy@google.com>
Cc: Soheil Hassas Yeganeh <soheil@google.com>
---
 tools/testing/selftests/net/tcp_mmap.c | 29 +++++++++++++++++++++++---
 1 file changed, 26 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/net/tcp_mmap.c b/tools/testing/selftests/net/tcp_mmap.c
index 59ec0b59f7b76ff75685bd96901d8237e0665b2b..ca2618f3e7a12ab6863665f465dea2e8d469131b 100644
--- a/tools/testing/selftests/net/tcp_mmap.c
+++ b/tools/testing/selftests/net/tcp_mmap.c
@@ -123,6 +123,28 @@ void hash_zone(void *zone, unsigned int length)
 #define ALIGN_UP(x, align_to)	(((x) + ((align_to)-1)) & ~((align_to)-1))
 #define ALIGN_PTR_UP(p, ptr_align_to)	((typeof(p))ALIGN_UP((unsigned long)(p), ptr_align_to))
 
+
+static void *mmap_large_buffer(size_t need, size_t *allocated)
+{
+	void *buffer;
+	size_t sz;
+
+	/* Attempt to use huge pages if possible. */
+	sz = ALIGN_UP(need, map_align);
+	buffer = mmap(NULL, sz, PROT_READ | PROT_WRITE,
+		      MAP_PRIVATE | MAP_ANONYMOUS | MAP_HUGETLB, -1, 0);
+
+	if (buffer == (void *)-1) {
+		sz = need;
+		buffer = mmap(NULL, sz, PROT_READ | PROT_WRITE,
+			      MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
+		if (buffer != (void *)-1)
+			fprintf(stderr, "MAP_HUGETLB attempt failed, look at /sys/kernel/mm/hugepages for optimal performance\n");
+	}
+	*allocated = sz;
+	return buffer;
+}
+
 void *child_thread(void *arg)
 {
 	unsigned long total_mmap = 0, total = 0;
@@ -351,6 +373,7 @@ int main(int argc, char *argv[])
 	uint64_t total = 0;
 	char *host = NULL;
 	int fd, c, on = 1;
+	size_t buffer_sz;
 	char *buffer;
 	int sflg = 0;
 	int mss = 0;
@@ -441,8 +464,8 @@ int main(int argc, char *argv[])
 		}
 		do_accept(fdlisten);
 	}
-	buffer = mmap(NULL, chunk_size, PROT_READ | PROT_WRITE,
-			      MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
+
+	buffer = mmap_large_buffer(chunk_size, &buffer_sz);
 	if (buffer == (char *)-1) {
 		perror("mmap");
 		exit(1);
@@ -488,6 +511,6 @@ int main(int argc, char *argv[])
 		total += wr;
 	}
 	close(fd);
-	munmap(buffer, chunk_size);
+	munmap(buffer, buffer_sz);
 	return 0;
 }
-- 
2.28.0.297.g1956fa8f8d-goog

