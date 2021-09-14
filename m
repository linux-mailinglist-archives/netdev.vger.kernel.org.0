Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A7EB40A2DF
	for <lists+netdev@lfdr.de>; Tue, 14 Sep 2021 03:51:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230340AbhINBw4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Sep 2021 21:52:56 -0400
Received: from prt-mail.chinatelecom.cn ([42.123.76.223]:38840 "EHLO
        chinatelecom.cn" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S229732AbhINBwz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Sep 2021 21:52:55 -0400
HMM_SOURCE_IP: 172.18.0.218:36198.1001769352
HMM_ATTACHE_NUM: 0000
HMM_SOURCE_TYPE: SMTP
Received: from clientip-110.87.95.153 (unknown [172.18.0.218])
        by chinatelecom.cn (HERMES) with SMTP id B008B280142;
        Tue, 14 Sep 2021 09:51:16 +0800 (CST)
X-189-SAVE-TO-SEND: +zhenggy@chinatelecom.cn
Received: from  ([172.18.0.218])
        by app0025 with ESMTP id 02d5a94c49a445c39fae088d54da1d24 for ncardwell@google.com;
        Tue, 14 Sep 2021 09:51:32 CST
X-Transaction-ID: 02d5a94c49a445c39fae088d54da1d24
X-Real-From: zhenggy@chinatelecom.cn
X-Receive-IP: 172.18.0.218
Sender: zhenggy@chinatelecom.cn
From:   zhenggy <zhenggy@chinatelecom.cn>
To:     ncardwell@google.com, netdev@vger.kernel.org
Cc:     edumazet@google.com, davem@davemloft.net, yoshfuji@linux-ipv6.org,
        dsahern@kernel.org, kuba@kernel.org, ycheng@google.com,
        qitiepeng@chinatelecom.cn, wujianguo@chinatelecom.cn,
        liyonglong@chinatelecom.cn, luchang1@chinatelecom.cn,
        zhenggy <zhenggy@chinatelecom.cn>
Subject: [PATCH v4] tcp: fix tp->undo_retrans accounting in tcp_sacktag_one()
Date:   Tue, 14 Sep 2021 09:51:15 +0800
Message-Id: <1631584275-3075-1-git-send-email-zhenggy@chinatelecom.cn>
X-Mailer: git-send-email 1.8.3.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit 10d3be569243 ("tcp-tso: do not split TSO packets at retransmit
time") may directly retrans a multiple segments TSO/GSO packet without
split, Since this commit, we can no longer assume that a retransmitted
packet is a single segment.

This patch fixes the tp->undo_retrans accounting in tcp_sacktag_one()
that use the actual segments(pcount) of the retransmitted packet.

Before that commit (10d3be569243), the assumption underlying the
tp->undo_retrans-- seems correct.

Fixes: 10d3be569243 ("tcp-tso: do not split TSO packets at retransmit time")
Signed-off-by: zhenggy <zhenggy@chinatelecom.cn>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Acked-by: Yuchung Cheng <ycheng@google.com>
Acked-by: Neal Cardwell <ncardwell@google.com>
---
 net/ipv4/tcp_input.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index 3f7bd7a..141e85e 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -1346,7 +1346,7 @@ static u8 tcp_sacktag_one(struct sock *sk,
 	if (dup_sack && (sacked & TCPCB_RETRANS)) {
 		if (tp->undo_marker && tp->undo_retrans > 0 &&
 		    after(end_seq, tp->undo_marker))
-			tp->undo_retrans--;
+			tp->undo_retrans = max_t(int, 0, tp->undo_retrans - pcount);
 		if ((sacked & TCPCB_SACKED_ACKED) &&
 		    before(start_seq, state->reord))
 				state->reord = start_seq;
-- 
1.8.3.1

