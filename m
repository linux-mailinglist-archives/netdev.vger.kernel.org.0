Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C428B5A69B8
	for <lists+netdev@lfdr.de>; Tue, 30 Aug 2022 19:22:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231363AbiH3RWV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Aug 2022 13:22:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231164AbiH3RVm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Aug 2022 13:21:42 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A6A8DDB63;
        Tue, 30 Aug 2022 10:20:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8953EB81D0C;
        Tue, 30 Aug 2022 17:20:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3264C43150;
        Tue, 30 Aug 2022 17:20:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661880023;
        bh=I5qbucz9hEvTK5aZplOe8XJDRDj5Cv0jBV9i3aOvbeo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Hsbkq94mxzlF1kLR/iTHL7BLWchmQ8bicn6kwHWHf6tGu5SzAw8CBmXR44fVkw8wn
         AR0fpgvFVSCVvM3XiuMXgrw2HXfNSJfblp38p7kEe9FVxzrEwwy5zHSbj4pjezciuQ
         87ZYIimcwG0yJWXQycuezMLcxIWCOrK3vezltlQkpBxU636y+EmQt6ZJn7XITeX+WM
         TTyDybSn1gUp3v509uhd4dV/ydxrTZzxMVvaFSO6Oj29QCDlLGOvEdCxHp1O6Owzpj
         aS1mh9vFYncWRrtFHCEmzbPgiwJrqHQZswoaQmIskBaaloxTw7VYWcqhFc1KQ+zw9W
         zs/pV3s4iXwzg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Florian Westphal <fw@strlen.de>, Sasha Levin <sashal@kernel.org>,
        pablo@netfilter.org, kadlec@netfilter.org, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.19 21/33] netfilter: conntrack: work around exceeded receive window
Date:   Tue, 30 Aug 2022 13:18:12 -0400
Message-Id: <20220830171825.580603-21-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220830171825.580603-1-sashal@kernel.org>
References: <20220830171825.580603-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

[ Upstream commit cf97769c761abfeac8931b35fe0e1a8d5fabc9d8 ]

When a TCP sends more bytes than allowed by the receive window, all future
packets can be marked as invalid.
This can clog up the conntrack table because of 5-day default timeout.

Sequence of packets:
 01 initiator > responder: [S], seq 171, win 5840, options [mss 1330,sackOK,TS val 63 ecr 0,nop,wscale 1]
 02 responder > initiator: [S.], seq 33211, ack 172, win 65535, options [mss 1460,sackOK,TS val 010 ecr 63,nop,wscale 8]
 03 initiator > responder: [.], ack 33212, win 2920, options [nop,nop,TS val 068 ecr 010], length 0
 04 initiator > responder: [P.], seq 172:240, ack 33212, win 2920, options [nop,nop,TS val 279 ecr 010], length 68

Window is 5840 starting from 33212 -> 39052.

 05 responder > initiator: [.], ack 240, win 256, options [nop,nop,TS val 872 ecr 279], length 0
 06 responder > initiator: [.], seq 33212:34530, ack 240, win 256, options [nop,nop,TS val 892 ecr 279], length 1318

This is fine, conntrack will flag the connection as having outstanding
data (UNACKED), which lowers the conntrack timeout to 300s.

 07 responder > initiator: [.], seq 34530:35848, ack 240, win 256, options [nop,nop,TS val 892 ecr 279], length 1318
 08 responder > initiator: [.], seq 35848:37166, ack 240, win 256, options [nop,nop,TS val 892 ecr 279], length 1318
 09 responder > initiator: [.], seq 37166:38484, ack 240, win 256, options [nop,nop,TS val 892 ecr 279], length 1318
 10 responder > initiator: [.], seq 38484:39802, ack 240, win 256, options [nop,nop,TS val 892 ecr 279], length 1318

Packet 10 is already sending more than permitted, but conntrack doesn't
validate this (only seq is tested vs. maxend, not 'seq+len').

38484 is acceptable, but only up to 39052, so this packet should
not have been sent (or only 568 bytes, not 1318).

At this point, connection is still in '300s' mode.

Next packet however will get flagged:
 11 responder > initiator: [P.], seq 39802:40128, ack 240, win 256, options [nop,nop,TS val 892 ecr 279], length 326

nf_ct_proto_6: SEQ is over the upper bound (over the window of the receiver) .. LEN=378 .. SEQ=39802 ACK=240 ACK PSH ..

Now, a couple of replies/acks comes in:

 12 initiator > responder: [.], ack 34530, win 4368,
[.. irrelevant acks removed ]
 16 initiator > responder: [.], ack 39802, win 8712, options [nop,nop,TS val 296201291 ecr 2982371892], length 0

This ack is significant -- this acks the last packet send by the
responder that conntrack considered valid.

This means that ack == td_end.  This will withdraw the
'unacked data' flag, the connection moves back to the 5-day timeout
of established conntracks.

 17 initiator > responder: ack 40128, win 10030, ...

This packet is also flagged as invalid.

Because conntrack only updates state based on packets that are
considered valid, packet 11 'did not exist' and that gets us:

nf_ct_proto_6: ACK is over upper bound 39803 (ACKed data not seen yet) .. SEQ=240 ACK=40128 WINDOW=10030 RES=0x00 ACK URG

Because this received and processed by the endpoints, the conntrack entry
remains in a bad state, no packets will ever be considered valid again:

 30 responder > initiator: [F.], seq 40432, ack 2045, win 391, ..
 31 initiator > responder: [.], ack 40433, win 11348, ..
 32 initiator > responder: [F.], seq 2045, ack 40433, win 11348 ..

... all trigger 'ACK is over bound' test and we end up with
non-early-evictable 5-day default timeout.

NB: This patch triggers a bunch of checkpatch warnings because of silly
indent.  I will resend the cleanup series linked below to reduce the
indent level once this change has propagated to net-next.

I could route the cleanup via nf but that causes extra backport work for
stable maintainers.

Link: https://lore.kernel.org/netfilter-devel/20220720175228.17880-1-fw@strlen.de/T/#mb1d7147d36294573cc4f81d00f9f8dadfdd06cd8
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_conntrack_proto_tcp.c | 31 ++++++++++++++++++++++++++
 1 file changed, 31 insertions(+)

diff --git a/net/netfilter/nf_conntrack_proto_tcp.c b/net/netfilter/nf_conntrack_proto_tcp.c
index a63b51dceaf2c..a634c72b1ffcf 100644
--- a/net/netfilter/nf_conntrack_proto_tcp.c
+++ b/net/netfilter/nf_conntrack_proto_tcp.c
@@ -655,6 +655,37 @@ static bool tcp_in_window(struct nf_conn *ct,
 		    tn->tcp_be_liberal)
 			res = true;
 		if (!res) {
+			bool seq_ok = before(seq, sender->td_maxend + 1);
+
+			if (!seq_ok) {
+				u32 overshot = end - sender->td_maxend + 1;
+				bool ack_ok;
+
+				ack_ok = after(sack, receiver->td_end - MAXACKWINDOW(sender) - 1);
+
+				if (in_recv_win &&
+				    ack_ok &&
+				    overshot <= receiver->td_maxwin &&
+				    before(sack, receiver->td_end + 1)) {
+					/* Work around TCPs that send more bytes than allowed by
+					 * the receive window.
+					 *
+					 * If the (marked as invalid) packet is allowed to pass by
+					 * the ruleset and the peer acks this data, then its possible
+					 * all future packets will trigger 'ACK is over upper bound' check.
+					 *
+					 * Thus if only the sequence check fails then do update td_end so
+					 * possible ACK for this data can update internal state.
+					 */
+					sender->td_end = end;
+					sender->flags |= IP_CT_TCP_FLAG_DATA_UNACKNOWLEDGED;
+
+					nf_ct_l4proto_log_invalid(skb, ct, hook_state,
+								  "%u bytes more than expected", overshot);
+					return res;
+				}
+			}
+
 			nf_ct_l4proto_log_invalid(skb, ct, hook_state,
 			"%s",
 			before(seq, sender->td_maxend + 1) ?
-- 
2.35.1

