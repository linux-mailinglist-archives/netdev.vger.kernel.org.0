Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2515C32A333
	for <lists+netdev@lfdr.de>; Tue,  2 Mar 2021 16:02:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378019AbhCBIxl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Mar 2021 03:53:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:39646 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1835641AbhCBGIu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 2 Mar 2021 01:08:50 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A903A61494;
        Tue,  2 Mar 2021 06:08:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614665282;
        bh=rQNw/xi+4W1+7G9+UmpFyMt1lfZvXK5rsdJvgkGG7yM=;
        h=From:To:Cc:Subject:Date:From;
        b=hu+CIikzf5bfBlAx1cDQxTM2NxWUmdFTkBZS7rUOnjq6Prg8kVdZnUYhg0M9S9A4i
         gS0XrHYLbWNXDCqqRiivXA74k8gjlj+Ce1atRNVgd4VOacWvyQ9vD2A/fd9Lv8RM6M
         ETEIfcw/LcEsQ30PIohjKNaqXg7WH16i28bom99ZjebnzVnrOkhAIvZaAG6XvnX2UD
         GBJ+iXkzYu8X2d6oF11CgEbx5A3AgXzZRHCG2U1dWCu420BxZqnw8LqCTRNQrOE9zw
         sZx9cmDUcmtYUySAxe85SMQOawRscMlvHBjGCpkEvwH1eVMLq7Azsus/aDN/D02led
         2sU2a5UZZsIVQ==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, kernel-team@fb.com,
        Jakub Kicinski <kuba@kernel.org>, Neil Spring <ntspring@fb.com>
Subject: [PATCH net] net: tcp: don't allocate fast clones for fastopen SYN
Date:   Mon,  1 Mar 2021 22:07:53 -0800
Message-Id: <20210302060753.953931-1-kuba@kernel.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When receiver does not accept TCP Fast Open it will only ack
the SYN, and not the data. We detect this and immediately queue
the data for (re)transmission in tcp_rcv_fastopen_synack().

In DC networks with very low RTT and without RFS the SYN-ACK
may arrive before NIC driver reported Tx completion on
the original SYN. In which case skb_still_in_host_queue()
returns true and sender will need to wait for the retransmission
timer to fire milliseconds later.

Revert back to non-fast clone skbs, this way
skb_still_in_host_queue() won't prevent the recovery flow
from completing.

Suggested-by: Eric Dumazet <edumazet@google.com>
Fixes: 355a901e6cf1 ("tcp: make connect() mem charging friendly")
Signed-off-by: Neil Spring <ntspring@fb.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 net/ipv4/tcp_output.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
index fbf140a770d8..cd9461588539 100644
--- a/net/ipv4/tcp_output.c
+++ b/net/ipv4/tcp_output.c
@@ -3759,9 +3759,16 @@ static int tcp_send_syn_data(struct sock *sk, struct sk_buff *syn)
 	/* limit to order-0 allocations */
 	space = min_t(size_t, space, SKB_MAX_HEAD(MAX_TCP_HEADER));
 
-	syn_data = sk_stream_alloc_skb(sk, space, sk->sk_allocation, false);
+	syn_data = alloc_skb(MAX_TCP_HEADER + space, sk->sk_allocation);
 	if (!syn_data)
 		goto fallback;
+	if (!sk_wmem_schedule(sk, syn_data->truesize)) {
+		__kfree_skb(syn_data);
+		goto fallback;
+	}
+	skb_reserve(syn_data, MAX_TCP_HEADER);
+	INIT_LIST_HEAD(&syn_data->tcp_tsorted_anchor);
+
 	syn_data->ip_summed = CHECKSUM_PARTIAL;
 	memcpy(syn_data->cb, syn->cb, sizeof(syn->cb));
 	if (space) {
-- 
2.26.2

