Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F0C02B8077
	for <lists+netdev@lfdr.de>; Wed, 18 Nov 2020 16:30:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727316AbgKRP3r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Nov 2020 10:29:47 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:53782 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725832AbgKRP3q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Nov 2020 10:29:46 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1605713386;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=4jFpeGAhh6Fb5jG1FvpIjRZn9YY2hHww4xO7ltwcqts=;
        b=Vj9Z2FKcJuSZzx4vbLGr1Ypqmor1W9wNRrm2IAdnPITpZE/XnkAYDahmZWya6z1/P6JctR
        zAZCV51kGyJVr9ONx0rS3VMg4Z3QpIVY8/k0Oc2M6kRQHehIdY3+TsZSMgJBZgP+AldtGx
        foaOVooCGCCMRbNnzibb7wrDkB1EVpM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-373-K1bTl2RQNyWCwRo6Oynxyg-1; Wed, 18 Nov 2020 10:29:44 -0500
X-MC-Unique: K1bTl2RQNyWCwRo6Oynxyg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E806410866A7;
        Wed, 18 Nov 2020 15:29:41 +0000 (UTC)
Received: from firesoul.localdomain (unknown [10.40.208.7])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7F5BD60C05;
        Wed, 18 Nov 2020 15:29:36 +0000 (UTC)
Received: from [192.168.42.3] (localhost [IPv6:::1])
        by firesoul.localdomain (Postfix) with ESMTP id 6A7FA32138456;
        Wed, 18 Nov 2020 16:29:35 +0100 (CET)
Subject: [PATCH bpf-next V6 2/7] bpf: fix bpf_fib_lookup helper MTU check for
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
Date:   Wed, 18 Nov 2020 16:29:35 +0100
Message-ID: <160571337537.2801246.15228178384451037535.stgit@firesoul>
In-Reply-To: <160571331409.2801246.11527010115263068327.stgit@firesoul>
References: <160571331409.2801246.11527010115263068327.stgit@firesoul>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
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
 net/core/filter.c |   12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/net/core/filter.c b/net/core/filter.c
index 1ee97fdeea64..ae1fe8e6069a 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -5567,10 +5567,20 @@ BPF_CALL_4(bpf_skb_fib_lookup, struct sk_buff *, skb,
 
 	if (!rc) {
 		struct net_device *dev;
+		u32 mtu;
 
 		dev = dev_get_by_index_rcu(net, params->ifindex);
-		if (!is_skb_forwardable(dev, skb))
+		mtu = dev->mtu;
+
+		/* Using tot_len for L3 MTU check if provided by user. Notice at
+		 * this TC cls_bpf level skb->len contains L2 size, but
+		 * is_skb_forwardable takes that into account.
+		 */
+		if (params->tot_len > mtu) {
 			rc = BPF_FIB_LKUP_RET_FRAG_NEEDED;
+		} else if (!is_skb_forwardable(dev, skb)) {
+			rc = BPF_FIB_LKUP_RET_FRAG_NEEDED;
+		}
 	}
 
 	return rc;


