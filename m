Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F90530E861
	for <lists+netdev@lfdr.de>; Thu,  4 Feb 2021 01:17:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233417AbhBDAPl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Feb 2021 19:15:41 -0500
Received: from www62.your-server.de ([213.133.104.62]:60410 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231817AbhBDAPk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Feb 2021 19:15:40 -0500
Received: from sslproxy01.your-server.de ([78.46.139.224])
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1l7SIT-0008bJ-Bm; Thu, 04 Feb 2021 01:14:57 +0100
Received: from [85.7.101.30] (helo=pc-9.home)
        by sslproxy01.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1l7SIT-000EEW-3V; Thu, 04 Feb 2021 01:14:57 +0100
Subject: Re: [PATCH v3 bpf-next] net: veth: alloc skb in bulk for ndo_xdp_xmit
To:     Lorenzo Bianconi <lorenzo@kernel.org>, bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        ast@kernel.org, toshiaki.makita1@gmail.com,
        lorenzo.bianconi@redhat.com, brouer@redhat.com, toke@redhat.com
References: <a14a30d3c06fff24e13f836c733d80efc0bd6eb5.1611957532.git.lorenzo@kernel.org>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <e2ae0d97-376a-07db-94fb-14f1220acca5@iogearbox.net>
Date:   Thu, 4 Feb 2021 01:14:56 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <a14a30d3c06fff24e13f836c733d80efc0bd6eb5.1611957532.git.lorenzo@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.4/26069/Wed Feb  3 13:23:20 2021)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/29/21 11:04 PM, Lorenzo Bianconi wrote:
> Split ndo_xdp_xmit and ndo_start_xmit use cases in veth_xdp_rcv routine
> in order to alloc skbs in bulk for XDP_PASS verdict.
> Introduce xdp_alloc_skb_bulk utility routine to alloc skb bulk list.
> The proposed approach has been tested in the following scenario:
[...]
> diff --git a/net/core/xdp.c b/net/core/xdp.c
> index 0d2630a35c3e..05354976c1fc 100644
> --- a/net/core/xdp.c
> +++ b/net/core/xdp.c
> @@ -514,6 +514,17 @@ void xdp_warn(const char *msg, const char *func, const int line)
>   };
>   EXPORT_SYMBOL_GPL(xdp_warn);
>   
> +int xdp_alloc_skb_bulk(void **skbs, int n_skb, gfp_t gfp)
> +{
> +	n_skb = kmem_cache_alloc_bulk(skbuff_head_cache, gfp,
> +				      n_skb, skbs);

Applied, but one question I was wondering about when reading the kmem_cache_alloc_bulk()
code was whether it would be safer to simply test for kmem_cache_alloc_bulk() != n_skb
given it could potentially in future also alloc less objs than requested, but I presume
if such extension would get implemented then call-sites might need to indicate 'best
effort' somehow via flag instead (to handle < n_skb case). Either way all current callers
assume for != 0 that everything went well, so lgtm.

> +	if (unlikely(!n_skb))
> +		return -ENOMEM;
> +
> +	return 0;
> +}
> +EXPORT_SYMBOL_GPL(xdp_alloc_skb_bulk);
> +
>   struct sk_buff *__xdp_build_skb_from_frame(struct xdp_frame *xdpf,
>   					   struct sk_buff *skb,
>   					   struct net_device *dev)
> 

