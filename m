Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 148512C33B2
	for <lists+netdev@lfdr.de>; Tue, 24 Nov 2020 23:14:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388489AbgKXWLR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Nov 2020 17:11:17 -0500
Received: from www62.your-server.de ([213.133.104.62]:38508 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728523AbgKXWLQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Nov 2020 17:11:16 -0500
Received: from sslproxy01.your-server.de ([78.46.139.224])
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1khgWg-0008Hh-A8; Tue, 24 Nov 2020 23:11:06 +0100
Received: from [85.7.101.30] (helo=pc-9.home)
        by sslproxy01.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1khgWg-000Pkc-55; Tue, 24 Nov 2020 23:11:06 +0100
Subject: Re: [PATCH v3 1/1] xdp: remove the function xsk_map_inc
To:     Zhu Yanjun <yanjunz@nvidia.com>, magnus.karlsson@intel.com,
        bjorn.topel@intel.com, davem@davemloft.net, netdev@vger.kernel.org
Cc:     Zhu Yanjun <zyjzyj2000@gmail.com>
References: <1606143915-25335-1-git-send-email-yanjunz@nvidia.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <c3472d5f-54da-2e20-2c3c-3f6690de6f04@iogearbox.net>
Date:   Tue, 24 Nov 2020 23:11:05 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <1606143915-25335-1-git-send-email-yanjunz@nvidia.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.4/25998/Tue Nov 24 14:16:50 2020)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/23/20 4:05 PM, Zhu Yanjun wrote:
> From: Zhu Yanjun <zyjzyj2000@gmail.com>
> 
> The function xsk_map_inc is a simple wrapper of bpf_map_inc and
> always returns zero. As such, replacing this function with bpf_map_inc
> and removing the test code.
> 
> Signed-off-by: Zhu Yanjun <zyjzyj2000@gmail.com>
> ---
>   net/xdp/xsk.c    |  2 +-
>   net/xdp/xsk.h    |  1 -
>   net/xdp/xskmap.c | 13 +------------
>   3 files changed, 2 insertions(+), 14 deletions(-)
> 
> diff --git a/net/xdp/xsk.c b/net/xdp/xsk.c
> index cfbec3989a76..a3c1f07d77d8 100644
> --- a/net/xdp/xsk.c
> +++ b/net/xdp/xsk.c
> @@ -548,7 +548,7 @@ static struct xsk_map *xsk_get_map_list_entry(struct xdp_sock *xs,
>   	node = list_first_entry_or_null(&xs->map_list, struct xsk_map_node,
>   					node);
>   	if (node) {
> -		WARN_ON(xsk_map_inc(node->map));
> +		bpf_map_inc(&node->map->map);
>   		map = node->map;
>   		*map_entry = node->map_entry;
>   	}
> diff --git a/net/xdp/xsk.h b/net/xdp/xsk.h
> index b9e896cee5bb..0aad25c0e223 100644
> --- a/net/xdp/xsk.h
> +++ b/net/xdp/xsk.h
> @@ -41,7 +41,6 @@ static inline struct xdp_sock *xdp_sk(struct sock *sk)
>   
>   void xsk_map_try_sock_delete(struct xsk_map *map, struct xdp_sock *xs,
>   			     struct xdp_sock **map_entry);
> -int xsk_map_inc(struct xsk_map *map);
>   void xsk_map_put(struct xsk_map *map);
>   void xsk_clear_pool_at_qid(struct net_device *dev, u16 queue_id);
>   int xsk_reg_pool_at_qid(struct net_device *dev, struct xsk_buff_pool *pool,
> diff --git a/net/xdp/xskmap.c b/net/xdp/xskmap.c
> index 49da2b8ace8b..6b7e9a72b101 100644
> --- a/net/xdp/xskmap.c
> +++ b/net/xdp/xskmap.c
> @@ -11,12 +11,6 @@
>   
>   #include "xsk.h"
>   
> -int xsk_map_inc(struct xsk_map *map)
> -{
> -	bpf_map_inc(&map->map);
> -	return 0;
> -}
> -
>   void xsk_map_put(struct xsk_map *map)
>   {

So, the xsk_map_put() is defined as:

   void xsk_map_put(struct xsk_map *map)
   {
         bpf_map_put(&map->map);
   }

What is the reason to get rid of xsk_map_inc() but not xsk_map_put() wrapper?
Can't we just remove both while we're at it?

Thanks,
Daniel
