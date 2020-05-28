Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E6C711E641B
	for <lists+netdev@lfdr.de>; Thu, 28 May 2020 16:38:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728489AbgE1Oio (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 May 2020 10:38:44 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:34590 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725768AbgE1Oim (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 28 May 2020 10:38:42 -0400
Received: from DGGEMS409-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 236C15584F194234AC35;
        Thu, 28 May 2020 22:38:35 +0800 (CST)
Received: from localhost (10.166.215.154) by DGGEMS409-HUB.china.huawei.com
 (10.3.19.209) with Microsoft SMTP Server id 14.3.487.0; Thu, 28 May 2020
 22:38:27 +0800
From:   YueHaibing <yuehaibing@huawei.com>
To:     <jmaloy@redhat.com>, <ying.xue@windriver.com>,
        <davem@davemloft.net>, <kuba@kernel.org>,
        <tuong.t.lien@dektech.com.au>
CC:     <netdev@vger.kernel.org>, <tipc-discussion@lists.sourceforge.net>,
        <linux-kernel@vger.kernel.org>, YueHaibing <yuehaibing@huawei.com>
Subject: [PATCH net-next] tipc: Fix NULL pointer dereference in __tipc_sendstream()
Date:   Thu, 28 May 2020 22:34:07 +0800
Message-ID: <20200528143407.56196-1-yuehaibing@huawei.com>
X-Mailer: git-send-email 2.10.2.windows.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.166.215.154]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

tipc_sendstream() may send zero length packet, then tipc_msg_append()
do not alloc skb, skb_peek_tail() will get NULL, msg_set_ack_required
will trigger NULL pointer dereference.

Reported-by: syzbot+8eac6d030e7807c21d32@syzkaller.appspotmail.com
Fixes: 0a3e060f340d ("tipc: add test for Nagle algorithm effectiveness")
Signed-off-by: YueHaibing <yuehaibing@huawei.com>
---
 net/tipc/socket.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/net/tipc/socket.c b/net/tipc/socket.c
index d6b67d07d22e..2943561399f1 100644
--- a/net/tipc/socket.c
+++ b/net/tipc/socket.c
@@ -1588,8 +1588,12 @@ static int __tipc_sendstream(struct socket *sock, struct msghdr *m, size_t dlen)
 				tsk->pkt_cnt += skb_queue_len(txq);
 			} else {
 				skb = skb_peek_tail(txq);
-				msg_set_ack_required(buf_msg(skb));
-				tsk->expect_ack = true;
+				if (skb) {
+					msg_set_ack_required(buf_msg(skb));
+					tsk->expect_ack = true;
+				} else {
+					tsk->expect_ack = false;
+				}
 				tsk->msg_acc = 0;
 				tsk->pkt_cnt = 0;
 			}
-- 
2.17.1


