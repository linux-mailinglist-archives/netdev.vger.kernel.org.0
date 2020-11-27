Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 37BE62C6B47
	for <lists+netdev@lfdr.de>; Fri, 27 Nov 2020 19:07:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732583AbgK0SGk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Nov 2020 13:06:40 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:20621 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1732532AbgK0SGj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Nov 2020 13:06:39 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1606500398;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=KVMZThUI3oPsd1omprnYCWaZp4TXk/i/DP0zyqt9kfw=;
        b=LqK24Q72EveWjpe29Dz+eDFxiOrhHRR2l+fCBu75c5DJXsWZ8b6k3PMEy0x+KyvEWfC52H
        WI5jHl8DJX+dSnZsboL2TQdp3/KfNqXjYz5KwNaEYA89FfT8ZsXGHDKFvsaELN7SBinMVL
        pOICH8pPYGK2QOQDW8tUtxTWBtNN55A=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-362-iu7C9nY1M26umjXKw6ILLQ-1; Fri, 27 Nov 2020 13:06:34 -0500
X-MC-Unique: iu7C9nY1M26umjXKw6ILLQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 73A4B80ED8A;
        Fri, 27 Nov 2020 18:06:32 +0000 (UTC)
Received: from firesoul.localdomain (unknown [10.40.208.7])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C22B45D6D5;
        Fri, 27 Nov 2020 18:06:28 +0000 (UTC)
Received: from [192.168.42.3] (localhost [IPv6:::1])
        by firesoul.localdomain (Postfix) with ESMTP id B616F32138453;
        Fri, 27 Nov 2020 19:06:27 +0100 (CET)
Subject: [PATCH bpf-next V8 2/8] bpf: fix bpf_fib_lookup helper MTU check for
 SKB ctx
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     bpf@vger.kernel.org
Cc:     Jesper Dangaard Brouer <brouer@redhat.com>, netdev@vger.kernel.org,
        Daniel Borkmann <borkmann@iogearbox.net>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        maze@google.com, lmb@cloudflare.com, shaun@tigera.io,
        Lorenzo Bianconi <lorenzo@kernel.org>, marek@cloudflare.com,
        John Fastabend <john.fastabend@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>, eyal.birger@gmail.com,
        colrack@gmail.com
Date:   Fri, 27 Nov 2020 19:06:27 +0100
Message-ID: <160650038768.2890576.58199438471570295.stgit@firesoul>
In-Reply-To: <160650034591.2890576.1092952641487480652.stgit@firesoul>
References: <160650034591.2890576.1092952641487480652.stgit@firesoul>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

BPF end-user on Cilium slack-channel (Carlo Carraro) wants to use
bpf_fib_lookup for doing MTU-check, but *prior* to extending packet size,
by adjusting fib_params 'tot_len' with the packet length plus the
expected encap size. (Just like the bpf_check_mtu helper supports). He
discovered that for SKB ctx the param->tot_len was not used, instead
skb->len was used (via MTU check in is_skb_forwardable()).

Fix this by using fib_params 'tot_len' for MTU check.  If not provided
(e.g. zero) then keep existing behaviour intact.

Fixes: 4c79579b44b1 ("bpf: Change bpf_fib_lookup to return lookup status")
Reported-by: Carlo Carraro <colrack@gmail.com>
Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
---
 net/core/filter.c |   14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/net/core/filter.c b/net/core/filter.c
index 1ee97fdeea64..84d77c425fbe 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -5565,11 +5565,21 @@ BPF_CALL_4(bpf_skb_fib_lookup, struct sk_buff *, skb,
 #endif
 	}
 
-	if (!rc) {
+	if (rc == BPF_FIB_LKUP_RET_SUCCESS) {
 		struct net_device *dev;
+		u32 mtu;
 
 		dev = dev_get_by_index_rcu(net, params->ifindex);
-		if (!is_skb_forwardable(dev, skb))
+		mtu = READ_ONCE(dev->mtu);
+
+		/* Using tot_len for (L3) MTU check if provided by user */
+		if (params->tot_len && params->tot_len > mtu)
+			rc = BPF_FIB_LKUP_RET_FRAG_NEEDED;
+
+		/* Notice at this TC cls_bpf level skb->len contains L2 size,
+		 * but is_skb_forwardable takes that into account
+		 */
+		if (params->tot_len == 0 && !is_skb_forwardable(dev, skb))
 			rc = BPF_FIB_LKUP_RET_FRAG_NEEDED;
 	}
 


