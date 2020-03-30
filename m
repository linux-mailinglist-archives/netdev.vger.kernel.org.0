Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0EE7119793D
	for <lists+netdev@lfdr.de>; Mon, 30 Mar 2020 12:24:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729187AbgC3KYA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Mar 2020 06:24:00 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:12650 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729125AbgC3KYA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 30 Mar 2020 06:24:00 -0400
Received: from DGGEMS411-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id C4000249121698C47994;
        Mon, 30 Mar 2020 18:23:48 +0800 (CST)
Received: from localhost.localdomain.localdomain (10.175.113.25) by
 DGGEMS411-HUB.china.huawei.com (10.3.19.211) with Microsoft SMTP Server id
 14.3.487.0; Mon, 30 Mar 2020 18:23:46 +0800
From:   Mao Wenan <maowenan@huawei.com>
To:     <davem@davemloft.net>, <ast@kernel.org>, <daniel@iogearbox.net>,
        <kuba@kernel.org>, <hawk@kernel.org>, <john.fastabend@gmail.com>,
        <kafai@fb.com>, <songliubraving@fb.com>, <yhs@fb.com>,
        <andriin@fb.com>, <jwi@linux.ibm.com>,
        <toshiaki.makita1@gmail.com>, <jianglidong3@jd.com>,
        <edumazet@google.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <bpf@vger.kernel.org>, <kernel-janitors@vger.kernel.org>
Subject: [PATCH net] veth: xdp: use head instead of hard_start
Date:   Mon, 30 Mar 2020 18:26:31 +0800
Message-ID: <20200330102631.31286-1-maowenan@huawei.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.113.25]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

xdp.data_hard_start is mapped to the first
address of xdp_frame, but the pointer hard_start
is the offset(sizeof(struct xdp_frame)) of xdp_frame,
it should use head instead of hard_start to
set xdp.data_hard_start. Otherwise, if BPF program
calls helper_function such as bpf_xdp_adjust_head, it
will be confused for xdp_frame_end.

Signed-off-by: Mao Wenan <maowenan@huawei.com>
---
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

