Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A4BBA607F4
	for <lists+netdev@lfdr.de>; Fri,  5 Jul 2019 16:35:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726824AbfGEOfd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Jul 2019 10:35:33 -0400
Received: from www62.your-server.de ([213.133.104.62]:54100 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725837AbfGEOfd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Jul 2019 10:35:33 -0400
Received: from [78.46.172.2] (helo=sslproxy05.your-server.de)
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1hjPJC-0004tf-T1; Fri, 05 Jul 2019 16:35:30 +0200
Received: from [2a02:1205:5069:fce0:c5f9:cd68:79d4:446d] (helo=linux.home)
        by sslproxy05.your-server.de with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89)
        (envelope-from <daniel@iogearbox.net>)
        id 1hjPJC-00031e-MN; Fri, 05 Jul 2019 16:35:30 +0200
Subject: Re: [PATCH bpf-next v3] libbpf: add xsk_ring_prod__nb_free() function
To:     Eelco Chaudron <echaudro@redhat.com>, netdev@vger.kernel.org
Cc:     ast@kernel.org, kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        andrii.nakryiko@gmail.com, magnus.karlsson@gmail.com
References: <ea49f66f73aedcdade979605dab6b2474e2dc4cb.1562145300.git.echaudro@redhat.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <c86151f8-9a16-d2e4-a888-d0836ff3c10a@iogearbox.net>
Date:   Fri, 5 Jul 2019 16:35:29 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.3.0
MIME-Version: 1.0
In-Reply-To: <ea49f66f73aedcdade979605dab6b2474e2dc4cb.1562145300.git.echaudro@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.100.3/25501/Fri Jul  5 10:01:52 2019)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 07/03/2019 02:52 PM, Eelco Chaudron wrote:
> When an AF_XDP application received X packets, it does not mean X
> frames can be stuffed into the producer ring. To make it easier for
> AF_XDP applications this API allows them to check how many frames can
> be added into the ring.
> 
> Signed-off-by: Eelco Chaudron <echaudro@redhat.com>

The commit log as it is along with the code is a bit too confusing for
readers. After all you only do a rename below. It would need to additionally
state that the rename is as per libbpf convention (xyz__ prefix) in order to
denote that this API is exposed to be used by applications.

Given you are doing this for xsk_prod_nb_free(), should we do the same for
xsk_cons_nb_avail() as well? Extending XDP sample app would be reasonable
addition as well in this context.

> ---
> 
> v2 -> v3
>  - Removed cache by pass option
> 
> v1 -> v2
>  - Renamed xsk_ring_prod__free() to xsk_ring_prod__nb_free()
>  - Add caching so it will only touch global state when needed
> 
>  tools/lib/bpf/xsk.h | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/tools/lib/bpf/xsk.h b/tools/lib/bpf/xsk.h
> index 82ea71a0f3ec..3411556e04d9 100644
> --- a/tools/lib/bpf/xsk.h
> +++ b/tools/lib/bpf/xsk.h
> @@ -76,7 +76,7 @@ xsk_ring_cons__rx_desc(const struct xsk_ring_cons *rx, __u32 idx)
>  	return &descs[idx & rx->mask];
>  }
>  
> -static inline __u32 xsk_prod_nb_free(struct xsk_ring_prod *r, __u32 nb)
> +static inline __u32 xsk_prod__nb_free(struct xsk_ring_prod *r, __u32 nb)
>  {
>  	__u32 free_entries = r->cached_cons - r->cached_prod;
>  
> @@ -110,7 +110,7 @@ static inline __u32 xsk_cons_nb_avail(struct xsk_ring_cons *r, __u32 nb)
>  static inline size_t xsk_ring_prod__reserve(struct xsk_ring_prod *prod,
>  					    size_t nb, __u32 *idx)
>  {
> -	if (xsk_prod_nb_free(prod, nb) < nb)
> +	if (xsk_prod__nb_free(prod, nb) < nb)
>  		return 0;
>  
>  	*idx = prod->cached_prod;
> 

