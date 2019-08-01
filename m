Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 50FB57E1D5
	for <lists+netdev@lfdr.de>; Thu,  1 Aug 2019 20:00:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387991AbfHASAd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Aug 2019 14:00:33 -0400
Received: from mx1.redhat.com ([209.132.183.28]:51316 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731616AbfHASAd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 1 Aug 2019 14:00:33 -0400
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 11D573151289;
        Thu,  1 Aug 2019 18:00:33 +0000 (UTC)
Received: from firesoul.localdomain (ovpn-200-21.brq.redhat.com [10.40.200.21])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B0B4E60BEC;
        Thu,  1 Aug 2019 18:00:32 +0000 (UTC)
Received: from [10.10.10.1] (localhost [IPv6:::1])
        by firesoul.localdomain (Postfix) with ESMTP id DEECA31256FD1;
        Thu,  1 Aug 2019 20:00:31 +0200 (CEST)
Subject: [net v1 PATCH 4/4] net: fix bpf_xdp_adjust_head regression for
 generic-XDP
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>
Cc:     xdp-newbies@vger.kernel.org,
        Daniel Borkmann <borkmann@iogearbox.net>,
        brandon.cazander@multapplied.net,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>
Date:   Thu, 01 Aug 2019 20:00:31 +0200
Message-ID: <156468243184.27559.7002090473019021952.stgit@firesoul>
In-Reply-To: <156468229108.27559.2443904494495785131.stgit@firesoul>
References: <156468229108.27559.2443904494495785131.stgit@firesoul>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.49]); Thu, 01 Aug 2019 18:00:33 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When generic-XDP was moved to a later processing step by commit
458bf2f224f0 ("net: core: support XDP generic on stacked devices.")
a regression was introduced when using bpf_xdp_adjust_head.

The issue is that after this commit the skb->network_header is now
changed prior to calling generic XDP and not after. Thus, if the header
is changed by XDP (via bpf_xdp_adjust_head), then skb->network_header
also need to be updated again.  Fix by calling skb_reset_network_header().

Fixes: 458bf2f224f0 ("net: core: support XDP generic on stacked devices.")
Reported-by: Brandon Cazander <brandon.cazander@multapplied.net>
Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
---
 net/core/dev.c |   15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff --git a/net/core/dev.c b/net/core/dev.c
index fc676b2610e3..b5533795c3c1 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -4374,12 +4374,17 @@ static u32 netif_receive_generic_xdp(struct sk_buff *skb,
 
 	act = bpf_prog_run_xdp(xdp_prog, xdp);
 
+	/* check if bpf_xdp_adjust_head was used */
 	off = xdp->data - orig_data;
-	if (off > 0)
-		__skb_pull(skb, off);
-	else if (off < 0)
-		__skb_push(skb, -off);
-	skb->mac_header += off;
+	if (off) {
+		if (off > 0)
+			__skb_pull(skb, off);
+		else if (off < 0)
+			__skb_push(skb, -off);
+
+		skb->mac_header += off;
+		skb_reset_network_header(skb);
+	}
 
 	/* check if bpf_xdp_adjust_tail was used. it can only "shrink"
 	 * pckt.

