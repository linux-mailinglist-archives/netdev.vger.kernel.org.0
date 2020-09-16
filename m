Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3AB2B26CA28
	for <lists+netdev@lfdr.de>; Wed, 16 Sep 2020 21:49:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727497AbgIPTtn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Sep 2020 15:49:43 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:50954 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727364AbgIPTsM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 16 Sep 2020 15:48:12 -0400
Received: from DGGEMS410-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 4D6173F7A1ADCF89CE70;
        Wed, 16 Sep 2020 19:39:58 +0800 (CST)
Received: from huawei.com (10.175.127.227) by DGGEMS410-HUB.china.huawei.com
 (10.3.19.210) with Microsoft SMTP Server id 14.3.487.0; Wed, 16 Sep 2020
 19:39:48 +0800
From:   Ye Bin <yebin10@huawei.com>
To:     <mathew.j.martineau@linux.intel.com>,
        <matthieu.baerts@tessares.net>, <netdev@vger.kernel.org>,
        <mptcp@lists.01.org>
CC:     Ye Bin <yebin10@huawei.com>, Hulk Robot <hulkci@huawei.com>
Subject: [PATCH v2] mptcp: Fix unsigned 'max_seq' compared with zero in mptcp_data_queue_ofo
Date:   Wed, 16 Sep 2020 19:41:04 +0800
Message-ID: <20200916114104.1556846-1-yebin10@huawei.com>
X-Mailer: git-send-email 2.25.4
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.127.227]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fixes coccicheck warnig:
net/mptcp/protocol.c:164:11-18: WARNING: Unsigned expression compared with zero: max_seq > 0

Fixes: ab174ad8ef76 ("mptcp: move ooo skbs into msk out of order queue")
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Ye Bin <yebin10@huawei.com>
---
 net/mptcp/protocol.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index ef0dd2f23482..3b71f6202524 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -155,13 +155,14 @@ static void mptcp_data_queue_ofo(struct mptcp_sock *msk, struct sk_buff *skb)
 {
 	struct sock *sk = (struct sock *)msk;
 	struct rb_node **p, *parent;
+	int space;
 	u64 seq, end_seq, max_seq;
 	struct sk_buff *skb1;
 
 	seq = MPTCP_SKB_CB(skb)->map_seq;
 	end_seq = MPTCP_SKB_CB(skb)->end_seq;
-	max_seq = tcp_space(sk);
-	max_seq = max_seq > 0 ? max_seq + msk->ack_seq : msk->ack_seq;
+	space = tcp_space(sk);
+	max_seq = space > 0 ? space + msk->ack_seq : msk->ack_seq;
 
 	pr_debug("msk=%p seq=%llx limit=%llx empty=%d", msk, seq, max_seq,
 		 RB_EMPTY_ROOT(&msk->out_of_order_queue));
-- 
2.25.4

