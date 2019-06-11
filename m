Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 771483D4D5
	for <lists+netdev@lfdr.de>; Tue, 11 Jun 2019 20:00:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406736AbfFKSAg convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 11 Jun 2019 14:00:36 -0400
Received: from mx1.redhat.com ([209.132.183.28]:39688 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2406628AbfFKSAg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 11 Jun 2019 14:00:36 -0400
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 94E903082E68;
        Tue, 11 Jun 2019 18:00:30 +0000 (UTC)
Received: from carbon (ovpn-200-32.brq.redhat.com [10.40.200.32])
        by smtp.corp.redhat.com (Postfix) with ESMTP id EA5131001B0F;
        Tue, 11 Jun 2019 18:00:22 +0000 (UTC)
Date:   Tue, 11 Jun 2019 20:00:21 +0200
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Toke =?UTF-8?B?SMO4aWxhbmQtSsO4cmdlbnNlbg==?= <toke@redhat.com>
Cc:     netdev@vger.kernel.org, Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        David Miller <davem@davemloft.net>,
        Jonathan Lemon <jonathan.lemon@gmail.com>, brouer@redhat.com
Subject: Re: [PATCH bpf-next v3 2/3] bpf_xdp_redirect_map: Perform map
 lookup in eBPF helper
Message-ID: <20190611200021.473138bc@carbon>
In-Reply-To: <156026784011.26748.7290735899755011809.stgit@alrua-x1>
References: <156026783994.26748.2899804283816365487.stgit@alrua-x1>
        <156026784011.26748.7290735899755011809.stgit@alrua-x1>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.46]); Tue, 11 Jun 2019 18:00:35 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 11 Jun 2019 17:44:00 +0200
Toke Høiland-Jørgensen <toke@redhat.com> wrote:

> From: Toke Høiland-Jørgensen <toke@redhat.com>
> 
> The bpf_redirect_map() helper used by XDP programs doesn't return any
> indication of whether it can successfully redirect to the map index it was
> given. Instead, BPF programs have to track this themselves, leading to
> programs using duplicate maps to track which entries are populated in the
> devmap.
> 
> This patch fixes this by moving the map lookup into the bpf_redirect_map()
> helper, which makes it possible to return failure to the eBPF program. The
> lower bits of the flags argument is used as the return code, which means
> that existing users who pass a '0' flag argument will get XDP_ABORTED.
> 
> With this, a BPF program can check the return code from the helper call and
> react by, for instance, substituting a different redirect. This works for
> any type of map used for redirect.
> 
> Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
> ---
>  include/linux/filter.h   |    1 +
>  include/uapi/linux/bpf.h |    8 ++++++++
>  net/core/filter.c        |   26 ++++++++++++--------------
>  3 files changed, 21 insertions(+), 14 deletions(-)
> 
> diff --git a/include/linux/filter.h b/include/linux/filter.h
> index 43b45d6db36d..f31ae8b9035a 100644
> --- a/include/linux/filter.h
> +++ b/include/linux/filter.h
> @@ -580,6 +580,7 @@ struct bpf_skb_data_end {
>  struct bpf_redirect_info {
>  	u32 ifindex;
>  	u32 flags;
> +	void *item;
>  	struct bpf_map *map;
>  	struct bpf_map *map_to_flush;
>  	u32 kern_flags;
> diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
> index 7c6aef253173..9931cf02de19 100644
> --- a/include/uapi/linux/bpf.h
> +++ b/include/uapi/linux/bpf.h
> @@ -3098,6 +3098,14 @@ enum xdp_action {
>  	XDP_REDIRECT,
>  };
>  
> +/* Flags for bpf_xdp_redirect_map helper */
> +
> +/* The lower flag bits will be the return code of bpf_xdp_redirect_map() helper
> + * if the map lookup fails.
> + */
> +#define XDP_REDIRECT_INVALID_MASK (XDP_ABORTED | XDP_DROP | XDP_PASS | XDP_TX)
> +#define XDP_REDIRECT_ALL_FLAGS XDP_REDIRECT_INVALID_MASK
> +

Slightly confused about the naming of the define, see later.

>  /* user accessible metadata for XDP packet hook
>   * new fields must be added to the end of this structure
>   */
> diff --git a/net/core/filter.c b/net/core/filter.c
> index 7a996887c500..dd43be497480 100644
> --- a/net/core/filter.c
> +++ b/net/core/filter.c
> @@ -3608,17 +3608,13 @@ static int xdp_do_redirect_map(struct net_device *dev, struct xdp_buff *xdp,
>  			       struct bpf_redirect_info *ri)
>  {
>  	u32 index = ri->ifindex;
> -	void *fwd = NULL;
> +	void *fwd = ri->item;
>  	int err;
>  
>  	ri->ifindex = 0;
> +	ri->item = NULL;
>  	WRITE_ONCE(ri->map, NULL);
>  
> -	fwd = __xdp_map_lookup_elem(map, index);
> -	if (unlikely(!fwd)) {
> -		err = -EINVAL;
> -		goto err;
> -	}
>  	if (ri->map_to_flush && unlikely(ri->map_to_flush != map))
>  		xdp_do_flush_map();
>  
> @@ -3655,18 +3651,13 @@ static int xdp_do_generic_redirect_map(struct net_device *dev,
>  {
>  	struct bpf_redirect_info *ri = this_cpu_ptr(&bpf_redirect_info);
>  	u32 index = ri->ifindex;
> -	void *fwd = NULL;
> +	void *fwd = ri->item;
>  	int err = 0;
>  
>  	ri->ifindex = 0;
> +	ri->item = NULL;
>  	WRITE_ONCE(ri->map, NULL);
>  
> -	fwd = __xdp_map_lookup_elem(map, index);
> -	if (unlikely(!fwd)) {
> -		err = -EINVAL;
> -		goto err;
> -	}
> -
>  	if (map->map_type == BPF_MAP_TYPE_DEVMAP) {
>  		struct bpf_dtab_netdev *dst = fwd;
>  
> @@ -3735,6 +3726,7 @@ BPF_CALL_2(bpf_xdp_redirect, u32, ifindex, u64, flags)
>  
>  	ri->ifindex = ifindex;
>  	ri->flags = flags;
> +	ri->item = NULL;
>  	WRITE_ONCE(ri->map, NULL);
>  
>  	return XDP_REDIRECT;
> @@ -3753,9 +3745,15 @@ BPF_CALL_3(bpf_xdp_redirect_map, struct bpf_map *, map, u32, ifindex,
>  {
>  	struct bpf_redirect_info *ri = this_cpu_ptr(&bpf_redirect_info);
>  
> -	if (unlikely(flags))
> +	if (unlikely(flags & ~XDP_REDIRECT_ALL_FLAGS))
>  		return XDP_ABORTED;
>  
> +	ri->item = __xdp_map_lookup_elem(map, ifindex);
> +	if (unlikely(!ri->item)) {
> +		WRITE_ONCE(ri->map, NULL);
> +		return (flags & XDP_REDIRECT_INVALID_MASK);

Maybe I'm reading it wrong, but shouldn't the mask be called the "valid" mask?

> +	}
> +
>  	ri->ifindex = ifindex;
>  	ri->flags = flags;
>  	WRITE_ONCE(ri->map, map);
> 



-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer
