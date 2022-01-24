Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 135D5497C49
	for <lists+netdev@lfdr.de>; Mon, 24 Jan 2022 10:44:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231812AbiAXJng (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jan 2022 04:43:36 -0500
Received: from out30-57.freemail.mail.aliyun.com ([115.124.30.57]:47637 "EHLO
        out30-57.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229823AbiAXJnd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Jan 2022 04:43:33 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R121e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04407;MF=haoxu@linux.alibaba.com;NM=1;PH=DS;RN=10;SR=0;TI=SMTPD_---0V2iRAzl_1643017410;
Received: from hao-A29R.hz.ali.com(mailfrom:haoxu@linux.alibaba.com fp:SMTPD_---0V2iRAzl_1643017410)
          by smtp.aliyun-inc.com(127.0.0.1);
          Mon, 24 Jan 2022 17:43:31 +0800
From:   Hao Xu <haoxu@linux.alibaba.com>
To:     netdev@vger.kernel.org, io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Joseph Qi <joseph.qi@linux.alibaba.com>
Subject: [PATCH 2/3] net-zerocopy: remove static for tcp_zerocopy_receive()
Date:   Mon, 24 Jan 2022 17:43:19 +0800
Message-Id: <20220124094320.900713-3-haoxu@linux.alibaba.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220124094320.900713-1-haoxu@linux.alibaba.com>
References: <20220124094320.900713-1-haoxu@linux.alibaba.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Remove static for tcp_zerocopy_receive() since we are going to
reference it in io_uring.

Signed-off-by: Hao Xu <haoxu@linux.alibaba.com>
---
 include/net/tcp.h | 3 +++
 net/ipv4/tcp.c    | 6 +++---
 2 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/include/net/tcp.h b/include/net/tcp.h
index ba0e7957bdfb..f4108dea6a82 100644
--- a/include/net/tcp.h
+++ b/include/net/tcp.h
@@ -424,6 +424,9 @@ int zc_receive_check(struct tcp_zerocopy_receive *zc, int *lenp,
 int zc_receive_update(struct sock *sk, struct tcp_zerocopy_receive *zc, int len,
 		      char __user *optval, struct scm_timestamping_internal *tss,
 		      int err);
+int tcp_zerocopy_receive(struct sock *sk,
+			 struct tcp_zerocopy_receive *zc,
+			 struct scm_timestamping_internal *tss);
 #endif
 void tcp_parse_options(const struct net *net, const struct sk_buff *skb,
 		       struct tcp_options_received *opt_rx,
diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index d47e3ccf7cdb..b08a04f58b42 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -2066,9 +2066,9 @@ static void tcp_zc_finalize_rx_tstamp(struct sock *sk,
 }
 
 #define TCP_ZEROCOPY_PAGE_BATCH_SIZE 32
-static int tcp_zerocopy_receive(struct sock *sk,
-				struct tcp_zerocopy_receive *zc,
-				struct scm_timestamping_internal *tss)
+int tcp_zerocopy_receive(struct sock *sk,
+			 struct tcp_zerocopy_receive *zc,
+			 struct scm_timestamping_internal *tss)
 {
 	u32 length = 0, offset, vma_len, avail_len, copylen = 0;
 	unsigned long address = (unsigned long)zc->address;
-- 
2.25.1

