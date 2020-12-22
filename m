Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 470632E0D3F
	for <lists+netdev@lfdr.de>; Tue, 22 Dec 2020 17:23:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727994AbgLVQWP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Dec 2020 11:22:15 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:34104 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727971AbgLVQWO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Dec 2020 11:22:14 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1608654047;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=bR7DMforv/x803CXjk8CPDAvmy4AcK9csPPLqvNBD5Y=;
        b=bezvkqr47V4OCxvIjtCAwrh9l/1KlaiFec+PL6Kyw/AFnXupngIMaulDoUdqgCd73Gs5Nz
        KsKLEPPunpmi18Idn/Rpkfr9Ll7yYy5PmXNE9BNV4MWuX048mCPO2NlptgcYAKzBVj8lzv
        ZiSasMAWpFDfYtlxmX8/DwoU6R2RUIA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-56-3gUBQg3DMlG7Wtb8Uv_L7A-1; Tue, 22 Dec 2020 11:20:46 -0500
X-MC-Unique: 3gUBQg3DMlG7Wtb8Uv_L7A-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0AE7A8145E1;
        Tue, 22 Dec 2020 16:20:44 +0000 (UTC)
Received: from firesoul.localdomain (unknown [10.40.208.19])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A87635D6A8;
        Tue, 22 Dec 2020 16:20:40 +0000 (UTC)
Received: from [192.168.42.3] (localhost [IPv6:::1])
        by firesoul.localdomain (Postfix) with ESMTP id B1DF232138458;
        Tue, 22 Dec 2020 17:20:39 +0100 (CET)
Subject: [PATCH bpf-next V10 2/7] bpf: fix bpf_fib_lookup helper MTU check for
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
Date:   Tue, 22 Dec 2020 17:20:39 +0100
Message-ID: <160865403966.3593456.3671822369709302636.stgit@firesoul>
In-Reply-To: <160865400291.3593456.17026136957003358677.stgit@firesoul>
References: <160865400291.3593456.17026136957003358677.stgit@firesoul>
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
by adjusting fib_params 'tot_len' with the packet length plus the expected
encap size. (Just like the bpf_check_mtu helper supports). He discovered
that for SKB ctx the param->tot_len was not used, instead skb->len was used
(via MTU check in is_skb_forwardable() that checks against netdev MTU).

Fix this by using fib_params 'tot_len' for MTU check. If not provided (e.g.
zero) then keep existing TC behaviour intact. Notice that 'tot_len' for MTU
check is done like XDP code-path, which checks against FIB-dst MTU.

V10:
- Use same method as XDP for 'tot_len' MTU check

Fixes: 4c79579b44b1 ("bpf: Change bpf_fib_lookup to return lookup status")
Reported-by: Carlo Carraro <colrack@gmail.com>
Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
---
 net/core/filter.c |   13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/net/core/filter.c b/net/core/filter.c
index f8f198252ff2..c1e460193bae 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -5548,6 +5548,7 @@ BPF_CALL_4(bpf_skb_fib_lookup, struct sk_buff *, skb,
 {
 	struct net *net = dev_net(skb->dev);
 	int rc = -EAFNOSUPPORT;
+	bool check_mtu = false;
 
 	if (plen < sizeof(*params))
 		return -EINVAL;
@@ -5555,22 +5556,28 @@ BPF_CALL_4(bpf_skb_fib_lookup, struct sk_buff *, skb,
 	if (flags & ~(BPF_FIB_LOOKUP_DIRECT | BPF_FIB_LOOKUP_OUTPUT))
 		return -EINVAL;
 
+	if (params->tot_len)
+		check_mtu = true;
+
 	switch (params->family) {
 #if IS_ENABLED(CONFIG_INET)
 	case AF_INET:
-		rc = bpf_ipv4_fib_lookup(net, params, flags, false);
+		rc = bpf_ipv4_fib_lookup(net, params, flags, check_mtu);
 		break;
 #endif
 #if IS_ENABLED(CONFIG_IPV6)
 	case AF_INET6:
-		rc = bpf_ipv6_fib_lookup(net, params, flags, false);
+		rc = bpf_ipv6_fib_lookup(net, params, flags, check_mtu);
 		break;
 #endif
 	}
 
-	if (!rc) {
+	if (rc == BPF_FIB_LKUP_RET_SUCCESS && !check_mtu) {
 		struct net_device *dev;
 
+		/* When tot_len isn't provided by user,
+		 * check skb against net_device MTU
+		 */
 		dev = dev_get_by_index_rcu(net, params->ifindex);
 		if (!is_skb_forwardable(dev, skb))
 			rc = BPF_FIB_LKUP_RET_FRAG_NEEDED;


