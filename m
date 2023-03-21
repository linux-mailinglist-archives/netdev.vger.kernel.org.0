Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CDBCF6C2C0B
	for <lists+netdev@lfdr.de>; Tue, 21 Mar 2023 09:12:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231145AbjCUIMh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Mar 2023 04:12:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230502AbjCUIMY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Mar 2023 04:12:24 -0400
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD67E3A4F3
        for <netdev@vger.kernel.org>; Tue, 21 Mar 2023 01:12:11 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-541942bfdccso146720097b3.14
        for <netdev@vger.kernel.org>; Tue, 21 Mar 2023 01:12:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1679386329;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=939qGjHz1bGVs5oH99oCeysL5FUpJOexYpIoJoVgT20=;
        b=EEs74O7INa/kDcHbNe4Pb5teq4IGoSGm26aIG6Znw4CZAQMNdFe1abWyZuRPPjhKWk
         Z8aLAmodsq2ZbwvJ1zPeU1fmGVxuL6xjBVDAycrbFZ8IVH+8uVxpTyE1ynTsh7do//V4
         9CHTSEvkUSnBSsK8yjIHKO7VVkXTbngn9F+Jqob/GIpydXQhQI3RDapx/DMXbH2GEu+l
         yZqTHH6yIP4+lZU3sfnXNrEPFy/25GiEdt+gq7qEHA95jV+GLtrUesV2Lt/EI13Ac84W
         xdUl1EvFKTIBtDMfcVOkaNri1DNFykHaJWb3mjBFlF4RKQd1wIixBmDOxjc+YmOoop27
         B/Lw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679386329;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=939qGjHz1bGVs5oH99oCeysL5FUpJOexYpIoJoVgT20=;
        b=Cir9OFtUNFYALaQL9DtMP3npaviORPWFm6L3SEnt3vsAgaJPbOX2JzzBT8WCAItdIO
         ezSX2jQMVOZXUB+MfGJEZH7u1aY14r/v9l0qdYj2hEzK/cBJDn2LOA0445+4muoAQvfP
         xFw2lVngDk/9e4eLOVLthBxu7mzeTDBMInalJj7ycEkthkV9HIMgxd5xKXAh50m2llu7
         uPU8mGh7/rhs/SP26Up6J7QspAH6O44QgZ4OqzkrEXatFKb0lJYxjqXXnPaphu8En0wr
         FNm0CXEYLW8ydO33ZCgdWNjoxyNyd99aTUKUrBPbD1xCrqlBzdChX1DLbZYFweyLNcu/
         0sYg==
X-Gm-Message-State: AAQBX9ep9Bue0fUjz1z4zgEkSkYIK+ukmlYb9Uj1xATG19iI6FA+4x4v
        0LMliAaVcl9aHnBqzQyqs4akDrZxhF4sDYY=
X-Google-Smtp-Source: AKy350ZDrwtJmhLe1KZnlEa3wHtDGdJ0n4tdxp4fhnhITywPtatb3ppEznHNK9dpb2Ejfi8FPPU4bQUSZ5lxVb0=
X-Received: from lixiaoyan1.bej.corp.google.com ([2401:fa00:44:10:da00:4d2e:dae2:452f])
 (user=lixiaoyan job=sendgmr) by 2002:a81:ad50:0:b0:544:bce8:980f with SMTP id
 l16-20020a81ad50000000b00544bce8980fmr555615ywk.6.1679386329501; Tue, 21 Mar
 2023 01:12:09 -0700 (PDT)
Date:   Tue, 21 Mar 2023 16:12:01 +0800
Mime-Version: 1.0
X-Mailer: git-send-email 2.40.0.rc1.284.g88254d51c5-goog
Message-ID: <20230321081202.2370275-1-lixiaoyan@google.com>
Subject: [PATCH net-next 1/2] net-zerocopy: Reduce compound page head access
From:   Coco Li <lixiaoyan@google.com>
To:     "David S . Miller" <davem@davemloft.net>,
        David Ahern <dsahern@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Shuah Khan <shuah@kernel.org>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Shakeel Butt <shakeelb@google.com>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        Al Viro <viro@zeniv.linux.org.uk>
Cc:     netdev@vger.kernel.org, inux-kernel@vger.kernel.org,
        linux-kselftest@vger.kernel.org, Xiaoyan Li <lixiaoyan@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,HK_RANDOM_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Xiaoyan Li <lixiaoyan@google.com>

When compound pages are enabled, although the mm layer still
returns an array of page pointers, a subset (or all) of them
may have the same page head since a max 180kb skb can span 2
hugepages if it is on the boundary, be a mix of pages and 1 hugepage,
or fit completely in a hugepage. Instead of referencing page head
on all page pointers, use page length arithmetic to only call page
head when referencing a known different page head to avoid touching
a cold cacheline.

Tested:
See next patch with changes to tcp_mmap

Correntess:
On a pair of separate hosts as send with MSG_ZEROCOPY will
force a copy on tx if using loopback alone, check that the SHA
on the message sent is equivalent to checksum on the message received,
since the current program already checks for the length.

echo 1024 > /sys/kernel/mm/hugepages/hugepages-2048kB/nr_hugepages
./tcp_mmap -s -z
./tcp_mmap -H $DADDR -z

SHA256 is correct
received 2 MB (100 % mmap'ed) in 0.005914 s, 2.83686 Gbit
  cpu usage user:0.001984 sys:0.000963, 1473.5 usec per MB, 10 c-switches

Performance:
Run neper between adjacent hosts with the same config
tcp_stream -Z --skip-rx-copy -6 -T 20 -F 1000 --stime-use-proc --test-length=30

Before patch: stime_end=37.670000
After patch: stime_end=30.310000

Signed-off-by: Coco Li <lixiaoyan@google.com>
---
 net/core/datagram.c | 14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

diff --git a/net/core/datagram.c b/net/core/datagram.c
index e4ff2db40c98..5662dff3d381 100644
--- a/net/core/datagram.c
+++ b/net/core/datagram.c
@@ -622,12 +622,12 @@ int __zerocopy_sg_from_iter(struct msghdr *msg, struct sock *sk,
 	frag = skb_shinfo(skb)->nr_frags;
 
 	while (length && iov_iter_count(from)) {
+		struct page *head, *last_head = NULL;
 		struct page *pages[MAX_SKB_FRAGS];
-		struct page *last_head = NULL;
+		int refs, order, n = 0;
 		size_t start;
 		ssize_t copied;
 		unsigned long truesize;
-		int refs, n = 0;
 
 		if (frag == MAX_SKB_FRAGS)
 			return -EMSGSIZE;
@@ -650,9 +650,17 @@ int __zerocopy_sg_from_iter(struct msghdr *msg, struct sock *sk,
 		} else {
 			refcount_add(truesize, &skb->sk->sk_wmem_alloc);
 		}
+
+		head = compound_head(pages[n]);
+		order = compound_order(head);
+
 		for (refs = 0; copied != 0; start = 0) {
 			int size = min_t(int, copied, PAGE_SIZE - start);
-			struct page *head = compound_head(pages[n]);
+
+			if (pages[n] - head > (1UL << order) - 1) {
+				head = compound_head(pages[n]);
+				order = compound_order(head);
+			}
 
 			start += (pages[n] - head) << PAGE_SHIFT;
 			copied -= size;
-- 
2.40.0.rc1.284.g88254d51c5-goog

