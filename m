Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 65B1E198C05
	for <lists+netdev@lfdr.de>; Tue, 31 Mar 2020 08:04:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726488AbgCaGEM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Mar 2020 02:04:12 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:12660 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725809AbgCaGEM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 31 Mar 2020 02:04:12 -0400
Received: from DGGEMS413-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 128B67015BC6416B1C16;
        Tue, 31 Mar 2020 14:04:05 +0800 (CST)
Received: from localhost.localdomain.localdomain (10.175.113.25) by
 DGGEMS413-HUB.china.huawei.com (10.3.19.213) with Microsoft SMTP Server id
 14.3.487.0; Tue, 31 Mar 2020 14:04:01 +0800
From:   Mao Wenan <maowenan@huawei.com>
To:     <davem@davemloft.net>, <ast@kernel.org>, <daniel@iogearbox.net>,
        <kuba@kernel.org>, <hawk@kernel.org>, <john.fastabend@gmail.com>,
        <kafai@fb.com>, <songliubraving@fb.com>, <yhs@fb.com>,
        <andriin@fb.com>, <jwi@linux.ibm.com>,
        <toshiaki.makita1@gmail.com>, <jianglidong3@jd.com>,
        <edumazet@google.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <bpf@vger.kernel.org>, <kernel-janitors@vger.kernel.org>
Subject: [PATCH net v2] veth: xdp: use head instead of hard_start
Date:   Tue, 31 Mar 2020 14:06:41 +0800
Message-ID: <20200331060641.79999-1-maowenan@huawei.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <fb5ab568-9bc8-3145-a8db-3e975ccdf846@gmail.com>
References: <fb5ab568-9bc8-3145-a8db-3e975ccdf846@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.113.25]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

xdp.data_hard_start is equal to first address of
struct xdp_frame, which is mentioned in
convert_to_xdp_frame(). But the pointer hard_start
in veth_xdp_rcv_one() is 32 bytes offset of frame,
so it should use head instead of hard_start to
set xdp.data_hard_start. Otherwise, if BPF program
calls helper_function such as bpf_xdp_adjust_head, it
will be confused for xdp_frame_end.

Fixes: 9fc8d518d9d5 ("veth: Handle xdp_frames in xdp napi ring")
Signed-off-by: Mao Wenan <maowenan@huawei.com>
---
 v2: add fixes tag, as well as commit log.
 drivers/net/veth.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/veth.c b/drivers/net/veth.c
index d4cbb9e8c63f..5ea550884bf8 100644
--- a/drivers/net/veth.c
+++ b/drivers/net/veth.c
@@ -506,7 +506,7 @@ static struct sk_buff *veth_xdp_rcv_one(struct veth_rq *rq,
 		struct xdp_buff xdp;
 		u32 act;
 
-		xdp.data_hard_start = hard_start;
+		xdp.data_hard_start = head;
 		xdp.data = frame->data;
 		xdp.data_end = frame->data + frame->len;
 		xdp.data_meta = frame->data - frame->metasize;
-- 
2.20.1

