Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 139B42DF0BD
	for <lists+netdev@lfdr.de>; Sat, 19 Dec 2020 18:47:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727109AbgLSRrg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 19 Dec 2020 12:47:36 -0500
Received: from smtp-fw-9101.amazon.com ([207.171.184.25]:30620 "EHLO
        smtp-fw-9101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725944AbgLSRrg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 19 Dec 2020 12:47:36 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1608400056; x=1639936056;
  h=references:from:to:cc:subject:in-reply-to:date:
   message-id:mime-version;
  bh=F7IdQ8uO633RpYfrqVxuaxBymtGiyiFpbnJzX3JKznU=;
  b=Ga9+16TqPHBUQzdAfDz4JfbEUMrEXqB8TeDCcKxefp8L0u47xW9yWtQp
   8plwczOlNF4MRRCCf8NnSVaObv290pM79aU7LLekfB2A3UHkWLIbzluSS
   tumXl6mAK5n2EXzxV3ezW3I9aeEGlEioVYcmU+XEP6uXgvbmDMAPVgCwk
   4=;
X-IronPort-AV: E=Sophos;i="5.78,433,1599523200"; 
   d="scan'208";a="97458502"
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO email-inbound-relay-1a-807d4a99.us-east-1.amazon.com) ([10.47.23.38])
  by smtp-border-fw-out-9101.sea19.amazon.com with ESMTP; 19 Dec 2020 17:46:48 +0000
Received: from EX13D28EUC001.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan2.iad.amazon.com [10.40.163.34])
        by email-inbound-relay-1a-807d4a99.us-east-1.amazon.com (Postfix) with ESMTPS id 1C467A1F4B;
        Sat, 19 Dec 2020 17:46:43 +0000 (UTC)
Received: from u68c7b5b1d2d758.ant.amazon.com.amazon.com (10.43.160.90) by
 EX13D28EUC001.ant.amazon.com (10.43.164.4) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Sat, 19 Dec 2020 17:46:36 +0000
References: <cover.1607349924.git.lorenzo@kernel.org>
 <a12bf957bf99fa86d229f383f615f11ee7153340.1607349924.git.lorenzo@kernel.org>
User-agent: mu4e 1.4.12; emacs 27.1
From:   Shay Agroskin <shayagr@amazon.com>
To:     Lorenzo Bianconi <lorenzo@kernel.org>
CC:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>,
        <davem@davemloft.net>, <kuba@kernel.org>, <ast@kernel.org>,
        <daniel@iogearbox.net>, <sameehj@amazon.com>,
        <john.fastabend@gmail.com>, <dsahern@kernel.org>,
        <brouer@redhat.com>, <echaudro@redhat.com>,
        <lorenzo.bianconi@redhat.com>, <jasowang@redhat.com>
Subject: Re: [PATCH v5 bpf-next 11/14] bpf: cpumap: introduce xdp multi-buff
 support
In-Reply-To: <a12bf957bf99fa86d229f383f615f11ee7153340.1607349924.git.lorenzo@kernel.org>
Date:   Sat, 19 Dec 2020 19:46:15 +0200
Message-ID: <pj41zleejlpu3c.fsf@u68c7b5b1d2d758.ant.amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; format=flowed
X-Originating-IP: [10.43.160.90]
X-ClientProxiedBy: EX13D19UWA004.ant.amazon.com (10.43.160.102) To
 EX13D28EUC001.ant.amazon.com (10.43.164.4)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Lorenzo Bianconi <lorenzo@kernel.org> writes:

> Introduce __xdp_build_skb_from_frame and 
> xdp_build_skb_from_frame
> utility routines to build the skb from xdp_frame.
> Add xdp multi-buff support to cpumap
>
> Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> ---
>  include/net/xdp.h   |  5 ++++
>  kernel/bpf/cpumap.c | 45 +---------------------------
>  net/core/xdp.c      | 73 
>  +++++++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 79 insertions(+), 44 deletions(-)
>
[...]
> diff --git a/net/core/xdp.c b/net/core/xdp.c
> index 6c8e743ad03a..55f3e9c69427 100644
> --- a/net/core/xdp.c
> +++ b/net/core/xdp.c
> @@ -597,3 +597,76 @@ void xdp_warn(const char *msg, const char 
> *func, const int line)
>  	WARN(1, "XDP_WARN: %s(line:%d): %s\n", func, line, msg);
>  };
>  EXPORT_SYMBOL_GPL(xdp_warn);
> +
> +struct sk_buff *__xdp_build_skb_from_frame(struct xdp_frame 
> *xdpf,
> +					   struct sk_buff *skb,
> +					   struct net_device *dev)
> +{
> +	unsigned int headroom = sizeof(*xdpf) + xdpf->headroom;
> +	void *hard_start = xdpf->data - headroom;
> +	skb_frag_t frag_list[MAX_SKB_FRAGS];
> +	struct xdp_shared_info *xdp_sinfo;
> +	int i, num_frags = 0;
> +
> +	xdp_sinfo = xdp_get_shared_info_from_frame(xdpf);
> +	if (unlikely(xdpf->mb)) {
> +		num_frags = xdp_sinfo->nr_frags;
> +		memcpy(frag_list, xdp_sinfo->frags,
> +		       sizeof(skb_frag_t) * num_frags);
> +	}

nit, can you please move the xdp_sinfo assignment inside this 'if' 
? This would help to emphasize that regarding xdp_frame tailroom 
as xdp_shared_info struct (rather than skb_shared_info) is correct 
only when the mb bit is set

thanks,
Shay

> +
> +	skb = build_skb_around(skb, hard_start, xdpf->frame_sz);
> +	if (unlikely(!skb))
> +		return NULL;
[...]
