Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3CEA5404885
	for <lists+netdev@lfdr.de>; Thu,  9 Sep 2021 12:34:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233895AbhIIKfY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Sep 2021 06:35:24 -0400
Received: from prt-mail.chinatelecom.cn ([42.123.76.222]:43974 "EHLO
        chinatelecom.cn" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S233370AbhIIKfX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Sep 2021 06:35:23 -0400
X-Greylist: delayed 486 seconds by postgrey-1.27 at vger.kernel.org; Thu, 09 Sep 2021 06:35:23 EDT
HMM_SOURCE_IP: 172.18.0.48:41630.160014780
HMM_ATTACHE_NUM: 0000
HMM_SOURCE_TYPE: SMTP
Received: from clientip-110.86.5.93 (unknown [172.18.0.48])
        by chinatelecom.cn (HERMES) with SMTP id 871AA2800B1;
        Thu,  9 Sep 2021 18:25:58 +0800 (CST)
X-189-SAVE-TO-SEND: +zhenggy@chinatelecom.cn
Received: from  ([172.18.0.48])
        by app0024 with ESMTP id 5f5d8444eccf47bdbd712f35d3141f90 for netdev@vger.kernel.org;
        Thu, 09 Sep 2021 18:26:02 CST
X-Transaction-ID: 5f5d8444eccf47bdbd712f35d3141f90
X-Real-From: zhenggy@chinatelecom.cn
X-Receive-IP: 172.18.0.48
Sender: zhenggy@chinatelecom.cn
From:   zhenggy <zhenggy@chinatelecom.cn>
To:     netdev@vger.kernel.org
Cc:     edumazet@google.com, davem@davemloft.net, yoshfuji@linux-ipv6.org,
        dsahern@kernel.org, kuba@kernel.org,
        zhenggy <zhenggy@chinatelecom.cn>
Subject: [PATCH] net: fix tp->undo_retrans accounting in tcp_sacktag_one()
Date:   Sun, 29 Aug 2021 07:59:33 -0400
Message-Id: <1630238373-12912-1-git-send-email-zhenggy@chinatelecom.cn>
X-Mailer: git-send-email 1.8.3.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit a71d77e6be1e ("tcp: fix segment accounting when DSACK range covers
multiple segments") fix some DSACK accounting for multiple segments.
In tcp_sacktag_one(), we should also use the actual DSACK rang(pcount)
for tp->undo_retrans accounting.

Signed-off-by: zhenggy <zhenggy@chinatelecom.cn>
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

