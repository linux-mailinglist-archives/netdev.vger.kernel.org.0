Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 24E3F5649E
	for <lists+netdev@lfdr.de>; Wed, 26 Jun 2019 10:30:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726339AbfFZIaJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jun 2019 04:30:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:44694 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726042AbfFZIaJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 26 Jun 2019 04:30:09 -0400
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 0D9C6307F5FF;
        Wed, 26 Jun 2019 08:30:09 +0000 (UTC)
Received: from [10.36.116.254] (ovpn-116-254.ams2.redhat.com [10.36.116.254])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 583215D9D3;
        Wed, 26 Jun 2019 08:30:06 +0000 (UTC)
From:   "Eelco Chaudron" <echaudro@redhat.com>
To:     netdev@vger.kernel.org
Cc:     ast@kernel.org, daniel@iogearbox.net, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com, andrii.nakryiko@gmail.com,
        magnus.karlsson@gmail.com
Subject: Re: [PATCH net-next v2] libbpf: add xsk_ring_prod__nb_free() function
Date:   Wed, 26 Jun 2019 10:30:04 +0200
Message-ID: <2CFDAE18-4B3F-4E18-8C4B-185341E6A57C@redhat.com>
In-Reply-To: <d4692ea57ba7a3fe33549fc6222fb8aea5a4225e.1561537432.git.echaudro@redhat.com>
References: <d4692ea57ba7a3fe33549fc6222fb8aea5a4225e.1561537432.git.echaudro@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; format=flowed
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.41]); Wed, 26 Jun 2019 08:30:09 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Please ignore, this was supposed to be bpf-next not net-next :(

On 26 Jun 2019, at 10:27, Eelco Chaudron wrote:

> When an AF_XDP application received X packets, it does not mean X
> frames can be stuffed into the producer ring. To make it easier for
> AF_XDP applications this API allows them to check how many frames can
> be added into the ring.
>
> Signed-off-by: Eelco Chaudron <echaudro@redhat.com>
> ---
>
> v1 -> v2
>  - Renamed xsk_ring_prod__free() to xsk_ring_prod__nb_free()
>  - Add caching so it will only touch global state when needed
>
>  tools/lib/bpf/xsk.h | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
>
> diff --git a/tools/lib/bpf/xsk.h b/tools/lib/bpf/xsk.h
> index 82ea71a0f3ec..6acb81102346 100644
> --- a/tools/lib/bpf/xsk.h
> +++ b/tools/lib/bpf/xsk.h
> @@ -76,11 +76,11 @@ xsk_ring_cons__rx_desc(const struct xsk_ring_cons 
> *rx, __u32 idx)
>  	return &descs[idx & rx->mask];
>  }
>
> -static inline __u32 xsk_prod_nb_free(struct xsk_ring_prod *r, __u32 
> nb)
> +static inline __u32 xsk_prod__nb_free(struct xsk_ring_prod *r, __u32 
> nb)
>  {
>  	__u32 free_entries = r->cached_cons - r->cached_prod;
>
> -	if (free_entries >= nb)
> +	if (free_entries >= nb && nb != 0)
>  		return free_entries;
>
>  	/* Refresh the local tail pointer.
> @@ -110,7 +110,7 @@ static inline __u32 xsk_cons_nb_avail(struct 
> xsk_ring_cons *r, __u32 nb)
>  static inline size_t xsk_ring_prod__reserve(struct xsk_ring_prod 
> *prod,
>  					    size_t nb, __u32 *idx)
>  {
> -	if (xsk_prod_nb_free(prod, nb) < nb)
> +	if (xsk_prod__nb_free(prod, nb) < nb)
>  		return 0;
>
>  	*idx = prod->cached_prod;
> -- 
> 2.20.1
