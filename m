Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 991C626D095
	for <lists+netdev@lfdr.de>; Thu, 17 Sep 2020 03:28:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726115AbgIQB2K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Sep 2020 21:28:10 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:46878 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725858AbgIQB2G (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 16 Sep 2020 21:28:06 -0400
X-Greylist: delayed 989 seconds by postgrey-1.27 at vger.kernel.org; Wed, 16 Sep 2020 21:28:05 EDT
Received: from DGGEMS402-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 02BD1B9DAD897B943D82;
        Thu, 17 Sep 2020 09:11:35 +0800 (CST)
Received: from huawei.com (10.175.127.227) by DGGEMS402-HUB.china.huawei.com
 (10.3.19.202) with Microsoft SMTP Server id 14.3.487.0; Thu, 17 Sep 2020
 09:11:27 +0800
From:   Ye Bin <yebin10@huawei.com>
To:     <mathew.j.martineau@linux.intel.com>,
        <matthieu.baerts@tessares.net>, <pabeni@redhat.com>,
        <mptcp@lists.01.org>, <netdev@vger.kernel.org>
CC:     Ye Bin <yebin10@huawei.com>, Hulk Robot <hulkci@huawei.com>
Subject: [PATCH v3] mptcp: Fix unsigned 'max_seq' compared with zero in mptcp_data_queue_ofo
Date:   Thu, 17 Sep 2020 09:12:33 +0800
Message-ID: <20200917011233.2948595-1-yebin10@huawei.com>
X-Mailer: git-send-email 2.25.4
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.127.227]
X-CFilter-Loop: Reflected
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
index ef0dd2f23482..386cd4e60250 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -157,11 +157,12 @@ static void mptcp_data_queue_ofo(struct mptcp_sock *msk, struct sk_buff *skb)
 	struct rb_node **p, *parent;
 	u64 seq, end_seq, max_seq;
 	struct sk_buff *skb1;
+	int space;
 
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

