Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CC2427FAA3
	for <lists+netdev@lfdr.de>; Fri,  2 Aug 2019 15:34:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405503AbfHBNdt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Aug 2019 09:33:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:33712 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732368AbfHBNXJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 2 Aug 2019 09:23:09 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 683F1217D4;
        Fri,  2 Aug 2019 13:23:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564752188;
        bh=luGPwrsMzBhqsBsjmDOagWeS2+zn0+WUsPIMCrUf+ek=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IcDq8NHDwgNXWO2A4JXS5/mZGzyrBAZN0eOy4G87/fPxPKF8oxoVvZnXsFd+/tfk7
         3r1bY59tU23JiLeZkKsSLGgg7NRTMEPb9PYCB220EQ5LwlQrnHRhJeqY3W3ExZzPx1
         +weWoBhG8fe65bmLzIcclTnSXP74wbgNTrIM3bBk=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Florian Westphal <fw@strlen.de>,
        Jakub Jankowski <shasta@toxcorp.com>,
        Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Sasha Levin <sashal@kernel.org>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 04/42] netfilter: conntrack: always store window size un-scaled
Date:   Fri,  2 Aug 2019 09:22:24 -0400
Message-Id: <20190802132302.13537-4-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190802132302.13537-1-sashal@kernel.org>
References: <20190802132302.13537-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

[ Upstream commit 959b69ef57db00cb33e9c4777400ae7183ebddd3 ]

Jakub Jankowski reported following oddity:

After 3 way handshake completes, timeout of new connection is set to
max_retrans (300s) instead of established (5 days).

shortened excerpt from pcap provided:
25.070622 IP (flags [DF], proto TCP (6), length 52)
10.8.5.4.1025 > 10.8.1.2.80: Flags [S], seq 11, win 64240, [wscale 8]
26.070462 IP (flags [DF], proto TCP (6), length 48)
10.8.1.2.80 > 10.8.5.4.1025: Flags [S.], seq 82, ack 12, win 65535, [wscale 3]
27.070449 IP (flags [DF], proto TCP (6), length 40)
10.8.5.4.1025 > 10.8.1.2.80: Flags [.], ack 83, win 512, length 0

Turns out the last_win is of u16 type, but we store the scaled value:
512 << 8 (== 0x20000) becomes 0 window.

The Fixes tag is not correct, as the bug has existed forever, but
without that change all that this causes might cause is to mistake a
window update (to-nonzero-from-zero) for a retransmit.

Fixes: fbcd253d2448b8 ("netfilter: conntrack: lower timeout to RETRANS seconds if window is 0")
Reported-by: Jakub Jankowski <shasta@toxcorp.com>
Tested-by: Jakub Jankowski <shasta@toxcorp.com>
Signed-off-by: Florian Westphal <fw@strlen.de>
Acked-by: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_conntrack_proto_tcp.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/net/netfilter/nf_conntrack_proto_tcp.c b/net/netfilter/nf_conntrack_proto_tcp.c
index 842f3f86fb2e7..7011ab27c4371 100644
--- a/net/netfilter/nf_conntrack_proto_tcp.c
+++ b/net/netfilter/nf_conntrack_proto_tcp.c
@@ -480,6 +480,7 @@ static bool tcp_in_window(const struct nf_conn *ct,
 	struct ip_ct_tcp_state *receiver = &state->seen[!dir];
 	const struct nf_conntrack_tuple *tuple = &ct->tuplehash[dir].tuple;
 	__u32 seq, ack, sack, end, win, swin;
+	u16 win_raw;
 	s32 receiver_offset;
 	bool res, in_recv_win;
 
@@ -488,7 +489,8 @@ static bool tcp_in_window(const struct nf_conn *ct,
 	 */
 	seq = ntohl(tcph->seq);
 	ack = sack = ntohl(tcph->ack_seq);
-	win = ntohs(tcph->window);
+	win_raw = ntohs(tcph->window);
+	win = win_raw;
 	end = segment_seq_plus_len(seq, skb->len, dataoff, tcph);
 
 	if (receiver->flags & IP_CT_TCP_FLAG_SACK_PERM)
@@ -663,14 +665,14 @@ static bool tcp_in_window(const struct nf_conn *ct,
 			    && state->last_seq == seq
 			    && state->last_ack == ack
 			    && state->last_end == end
-			    && state->last_win == win)
+			    && state->last_win == win_raw)
 				state->retrans++;
 			else {
 				state->last_dir = dir;
 				state->last_seq = seq;
 				state->last_ack = ack;
 				state->last_end = end;
-				state->last_win = win;
+				state->last_win = win_raw;
 				state->retrans = 0;
 			}
 		}
-- 
2.20.1

