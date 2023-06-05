Return-Path: <netdev+bounces-7848-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 8AB9A721C96
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 05:35:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 45DC52810F1
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 03:35:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3F24A17D9;
	Mon,  5 Jun 2023 03:35:24 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 217D3649;
	Mon,  5 Jun 2023 03:35:23 +0000 (UTC)
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6F89A4;
	Sun,  4 Jun 2023 20:35:21 -0700 (PDT)
Received: from dggpeml500010.china.huawei.com (unknown [172.30.72.53])
	by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4QZK4636wlzTkjG;
	Mon,  5 Jun 2023 11:35:02 +0800 (CST)
Received: from huawei.com (10.175.101.6) by dggpeml500010.china.huawei.com
 (7.185.36.155) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.23; Mon, 5 Jun
 2023 11:35:18 +0800
From: Xin Liu <liuxin350@huawei.com>
To: <daniel@iogearbox.net>
CC: <andrii@kernel.org>, <ast@kernel.org>, <bpf@vger.kernel.org>,
	<davem@davemloft.net>, <edumazet@google.com>, <hsinweih@uci.edu>,
	<jakub@cloudflare.com>, <john.fastabend@gmail.com>, <kuba@kernel.org>,
	<linux-kernel@vger.kernel.org>, <liuxin350@huawei.com>,
	<netdev@vger.kernel.org>, <pabeni@redhat.com>,
	<syzbot+49f6cef45247ff249498@syzkaller.appspotmail.com>,
	<syzkaller-bugs@googlegroups.com>, <yanan@huawei.com>,
	<wuchangye@huawei.com>, <xiesongyang@huawei.com>, <kongweibin2@huawei.com>,
	<zhangmingyi5@huawei.com>
Subject: [PATCH] libbpf:fix use empty function pointers in ringbuf_poll
Date: Mon, 5 Jun 2023 11:34:49 +0800
Message-ID: <20230605033449.239123-1-liuxin350@huawei.com>
X-Mailer: git-send-email 2.33.0
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.175.101.6]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 dggpeml500010.china.huawei.com (7.185.36.155)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

From: zhangmingyi <zhangmingyi5@huawei.com>

The sample_cb of the ring_buffer__new interface can transfer NULL. However,
the system does not check whether sample_cb is NULL during 
ring_buffer__poll, null pointer is used.

Signed-off-by: zhangmingyi <zhangmingyi5@huawei.com>
---
 tools/lib/bpf/ringbuf.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/lib/bpf/ringbuf.c b/tools/lib/bpf/ringbuf.c
index 02199364db13..3661338a1d2e 100644
--- a/tools/lib/bpf/ringbuf.c
+++ b/tools/lib/bpf/ringbuf.c
@@ -248,7 +248,7 @@ static int64_t ringbuf_process_ring(struct ring *r)
 			got_new_data = true;
 			cons_pos += roundup_len(len);
 
-			if ((len & BPF_RINGBUF_DISCARD_BIT) == 0) {
+			if (r->sample_cb && ((len & BPF_RINGBUF_DISCARD_BIT) == 0)) {
 				sample = (void *)len_ptr + BPF_RINGBUF_HDR_SZ;
 				err = r->sample_cb(r->ctx, sample, len);
 				if (err < 0) {
-- 
2.33.0


