Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 605B32BAE22
	for <lists+netdev@lfdr.de>; Fri, 20 Nov 2020 16:22:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729158AbgKTPNc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Nov 2020 10:13:32 -0500
Received: from www62.your-server.de ([213.133.104.62]:46736 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729157AbgKTPNb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Nov 2020 10:13:31 -0500
Received: from sslproxy05.your-server.de ([78.46.172.2])
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1kg86F-0007x2-FN; Fri, 20 Nov 2020 16:13:23 +0100
Received: from [85.7.101.30] (helo=pc-9.home)
        by sslproxy05.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1kg86F-0002nd-5k; Fri, 20 Nov 2020 16:13:23 +0100
Subject: Re: [PATCH] bpf: Check the return value of dev_get_by_index_rcu()
To:     xiakaixu1987@gmail.com, ast@kernel.org, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com, andrii@kernel.org,
        john.fastabend@gmail.com, kpsingh@chromium.org
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org, Kaixu Xia <kaixuxia@tencent.com>,
        dsahern@gmail.com
References: <1605769468-2078-1-git-send-email-kaixuxia@tencent.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <65d8f988-5b41-24c2-8501-7cbbddb1238e@iogearbox.net>
Date:   Fri, 20 Nov 2020 16:13:22 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <1605769468-2078-1-git-send-email-kaixuxia@tencent.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.4/25994/Fri Nov 20 14:09:26 2020)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

[ +David ]

On 11/19/20 8:04 AM, xiakaixu1987@gmail.com wrote:
> From: Kaixu Xia <kaixuxia@tencent.com>
> 
> The return value of dev_get_by_index_rcu() can be NULL, so here it
> is need to check the return value and return error code if it is NULL.
> 
> Signed-off-by: Kaixu Xia <kaixuxia@tencent.com>
> ---
>   net/core/filter.c | 2 ++
>   1 file changed, 2 insertions(+)
> 
> diff --git a/net/core/filter.c b/net/core/filter.c
> index 2ca5eecebacf..1263fe07170a 100644
> --- a/net/core/filter.c
> +++ b/net/core/filter.c
> @@ -5573,6 +5573,8 @@ BPF_CALL_4(bpf_skb_fib_lookup, struct sk_buff *, skb,
>   		struct net_device *dev;
>   
>   		dev = dev_get_by_index_rcu(net, params->ifindex);
> +		if (unlikely(!dev))
> +			return -EINVAL;
>   		if (!is_skb_forwardable(dev, skb))
>   			rc = BPF_FIB_LKUP_RET_FRAG_NEEDED;

The above logic is quite ugly anyway given we fetched the dev pointer already earlier
in bpf_ipv{4,6}_fib_lookup() and now need to redo it again ... so yeah there could be
a tiny race in here. We wanted do bring this logic closer to what XDP does anyway,
something like below, for example. David, thoughts? Thx

Subject: [PATCH] diff mtu check

Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
---
  net/core/filter.c | 22 +++++-----------------
  1 file changed, 5 insertions(+), 17 deletions(-)

diff --git a/net/core/filter.c b/net/core/filter.c
index 2ca5eecebacf..3bab0a97fa38 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -5547,9 +5547,6 @@ static const struct bpf_func_proto bpf_xdp_fib_lookup_proto = {
  BPF_CALL_4(bpf_skb_fib_lookup, struct sk_buff *, skb,
  	   struct bpf_fib_lookup *, params, int, plen, u32, flags)
  {
-	struct net *net = dev_net(skb->dev);
-	int rc = -EAFNOSUPPORT;
-
  	if (plen < sizeof(*params))
  		return -EINVAL;

@@ -5559,25 +5556,16 @@ BPF_CALL_4(bpf_skb_fib_lookup, struct sk_buff *, skb,
  	switch (params->family) {
  #if IS_ENABLED(CONFIG_INET)
  	case AF_INET:
-		rc = bpf_ipv4_fib_lookup(net, params, flags, false);
-		break;
+		return bpf_ipv4_fib_lookup(dev_net(skb->dev), params, flags,
+					   !skb_is_gso(skb));
  #endif
  #if IS_ENABLED(CONFIG_IPV6)
  	case AF_INET6:
-		rc = bpf_ipv6_fib_lookup(net, params, flags, false);
-		break;
+		return bpf_ipv6_fib_lookup(dev_net(skb->dev), params, flags,
+					   !skb_is_gso(skb));
  #endif
  	}
-
-	if (!rc) {
-		struct net_device *dev;
-
-		dev = dev_get_by_index_rcu(net, params->ifindex);
-		if (!is_skb_forwardable(dev, skb))
-			rc = BPF_FIB_LKUP_RET_FRAG_NEEDED;
-	}
-
-	return rc;
+	return -EAFNOSUPPORT;
  }

  static const struct bpf_func_proto bpf_skb_fib_lookup_proto = {
-- 
2.21.0

