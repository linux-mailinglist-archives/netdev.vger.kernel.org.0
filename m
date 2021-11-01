Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9834B441573
	for <lists+netdev@lfdr.de>; Mon,  1 Nov 2021 09:40:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231751AbhKAImZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Nov 2021 04:42:25 -0400
Received: from mail.netfilter.org ([217.70.188.207]:57796 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231728AbhKAImW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Nov 2021 04:42:22 -0400
Received: from localhost.localdomain (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id 6046C63F47;
        Mon,  1 Nov 2021 09:37:55 +0100 (CET)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net-next 2/5] netfilter: conntrack: set on IPS_ASSURED if flows enters internal stream state
Date:   Mon,  1 Nov 2021 09:39:37 +0100
Message-Id: <20211101083940.51007-3-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211101083940.51007-1-pablo@netfilter.org>
References: <20211101083940.51007-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The internal stream state sets the timeout to 120 seconds 2 seconds
after the creation of the flow, attach this internal stream state to the
IPS_ASSURED flag for consistent event reporting.

Before this patch:

      [NEW] udp      17 30 src=10.246.11.13 dst=216.239.35.0 sport=37282 dport=123 [UNREPLIED] src=216.239.35.0 dst=10.246.11.13 sport=123 dport=37282
   [UPDATE] udp      17 30 src=10.246.11.13 dst=216.239.35.0 sport=37282 dport=123 src=216.239.35.0 dst=10.246.11.13 sport=123 dport=37282
   [UPDATE] udp      17 30 src=10.246.11.13 dst=216.239.35.0 sport=37282 dport=123 src=216.239.35.0 dst=10.246.11.13 sport=123 dport=37282 [ASSURED]
  [DESTROY] udp      17 src=10.246.11.13 dst=216.239.35.0 sport=37282 dport=123 src=216.239.35.0 dst=10.246.11.13 sport=123 dport=37282 [ASSURED]

Note IPS_ASSURED for the flow not yet in the internal stream state.

after this update:

      [NEW] udp      17 30 src=10.246.11.13 dst=216.239.35.0 sport=37282 dport=123 [UNREPLIED] src=216.239.35.0 dst=10.246.11.13 sport=123 dport=37282
   [UPDATE] udp      17 30 src=10.246.11.13 dst=216.239.35.0 sport=37282 dport=123 src=216.239.35.0 dst=10.246.11.13 sport=123 dport=37282
   [UPDATE] udp      17 120 src=10.246.11.13 dst=216.239.35.0 sport=37282 dport=123 src=216.239.35.0 dst=10.246.11.13 sport=123 dport=37282 [ASSURED]
  [DESTROY] udp      17 src=10.246.11.13 dst=216.239.35.0 sport=37282 dport=123 src=216.239.35.0 dst=10.246.11.13 sport=123 dport=37282 [ASSURED]

Before this patch, short-lived UDP flows never entered IPS_ASSURED, so
they were already candidate flow to be deleted by early_drop under
stress.

Before this patch, IPS_ASSURED is set on regardless the internal stream
state, attach this internal stream state to IPS_ASSURED.

packet #1 (original direction) enters NEW state
packet #2 (reply direction) enters ESTABLISHED state, sets on IPS_SEEN_REPLY
paclet #3 (any direction) sets on IPS_ASSURED (if 2 seconds since the
          creation has passed by).

Reported-by: Maciej Żenczykowski <zenczykowski@gmail.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_conntrack_proto_udp.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nf_conntrack_proto_udp.c b/net/netfilter/nf_conntrack_proto_udp.c
index f8e3c0d2602f..3b516cffc779 100644
--- a/net/netfilter/nf_conntrack_proto_udp.c
+++ b/net/netfilter/nf_conntrack_proto_udp.c
@@ -104,10 +104,13 @@ int nf_conntrack_udp_packet(struct nf_conn *ct,
 	 */
 	if (test_bit(IPS_SEEN_REPLY_BIT, &ct->status)) {
 		unsigned long extra = timeouts[UDP_CT_UNREPLIED];
+		bool stream = false;
 
 		/* Still active after two seconds? Extend timeout. */
-		if (time_after(jiffies, ct->proto.udp.stream_ts))
+		if (time_after(jiffies, ct->proto.udp.stream_ts)) {
 			extra = timeouts[UDP_CT_REPLIED];
+			stream = true;
+		}
 
 		nf_ct_refresh_acct(ct, ctinfo, skb, extra);
 
@@ -116,7 +119,7 @@ int nf_conntrack_udp_packet(struct nf_conn *ct,
 			return NF_ACCEPT;
 
 		/* Also, more likely to be important, and not a probe */
-		if (!test_and_set_bit(IPS_ASSURED_BIT, &ct->status))
+		if (stream && !test_and_set_bit(IPS_ASSURED_BIT, &ct->status))
 			nf_conntrack_event_cache(IPCT_ASSURED, ct);
 	} else {
 		nf_ct_refresh_acct(ct, ctinfo, skb, timeouts[UDP_CT_UNREPLIED]);
-- 
2.30.2

