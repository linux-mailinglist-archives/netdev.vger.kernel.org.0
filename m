Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B498343FDDD
	for <lists+netdev@lfdr.de>; Fri, 29 Oct 2021 16:09:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230495AbhJ2OLm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Oct 2021 10:11:42 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:14880 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229692AbhJ2OLl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Oct 2021 10:11:41 -0400
Received: from dggemv711-chm.china.huawei.com (unknown [172.30.72.55])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4HgknF4Jz5z90G1;
        Fri, 29 Oct 2021 22:09:05 +0800 (CST)
Received: from dggema772-chm.china.huawei.com (10.1.198.214) by
 dggemv711-chm.china.huawei.com (10.1.198.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2308.15; Fri, 29 Oct 2021 22:09:10 +0800
Received: from huawei.com (10.175.101.6) by dggema772-chm.china.huawei.com
 (10.1.198.214) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2308.15; Fri, 29
 Oct 2021 22:09:09 +0800
From:   Liu Jian <liujian56@huawei.com>
To:     <john.fastabend@gmail.com>, <daniel@iogearbox.net>,
        <jakub@cloudflare.com>, <lmb@cloudflare.com>,
        <davem@davemloft.net>, <kuba@kernel.org>, <ast@kernel.org>,
        <andrii@kernel.org>, <kafai@fb.com>, <songliubraving@fb.com>,
        <yhs@fb.com>, <kpsingh@kernel.org>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>, <xiyou.wangcong@gmail.com>,
        <alexei.starovoitov@gmail.com>
CC:     <liujian56@huawei.com>
Subject: [PATHC bpf v6 2/3] selftests, bpf: Fix test_txmsg_ingress_parser error
Date:   Fri, 29 Oct 2021 22:12:15 +0800
Message-ID: <20211029141216.211899-2-liujian56@huawei.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20211029141216.211899-1-liujian56@huawei.com>
References: <20211029141216.211899-1-liujian56@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.101.6]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 dggema772-chm.china.huawei.com (10.1.198.214)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

After "skmsg: lose offset info in sk_psock_skb_ingress", the test case
with ktls failed. This because ktls parser(tls_read_size) return value
is 285 not 256.

the case like this:
	tls_sk1 --> redir_sk --> tls_sk2
tls_sk1 sent out 512 bytes data, after tls related processing redir_sk
recved 570 btyes data, and redirect 512 (skb_use_parser) bytes data to
tls_sk2; but tls_sk2 needs 285 * 2 bytes data, receive timeout occurred.

Signed-off-by: Liu Jian <liujian56@huawei.com>
Acked-by: John Fastabend <john.fastabend@gmail.com>
---
 tools/testing/selftests/bpf/test_sockmap.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/tools/testing/selftests/bpf/test_sockmap.c b/tools/testing/selftests/bpf/test_sockmap.c
index eefd445b96fc..06924917ad77 100644
--- a/tools/testing/selftests/bpf/test_sockmap.c
+++ b/tools/testing/selftests/bpf/test_sockmap.c
@@ -1680,6 +1680,8 @@ static void test_txmsg_ingress_parser(int cgrp, struct sockmap_options *opt)
 {
 	txmsg_pass = 1;
 	skb_use_parser = 512;
+	if (ktls == 1)
+		skb_use_parser = 570;
 	opt->iov_length = 256;
 	opt->iov_count = 1;
 	opt->rate = 2;
-- 
2.17.1

