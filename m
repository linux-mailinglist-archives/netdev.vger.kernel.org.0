Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 17C8035A97
	for <lists+netdev@lfdr.de>; Wed,  5 Jun 2019 12:40:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727296AbfFEKkA convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 5 Jun 2019 06:40:00 -0400
Received: from mx1.redhat.com ([209.132.183.28]:39426 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727083AbfFEKkA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 5 Jun 2019 06:40:00 -0400
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 95C0830B96FC;
        Wed,  5 Jun 2019 10:39:51 +0000 (UTC)
Received: from carbon (ovpn-200-32.brq.redhat.com [10.40.200.32])
        by smtp.corp.redhat.com (Postfix) with ESMTP id CD26C19C65;
        Wed,  5 Jun 2019 10:39:42 +0000 (UTC)
Date:   Wed, 5 Jun 2019 12:39:41 +0200
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Toke =?UTF-8?B?SMO4aWxhbmQtSsO4cmdlbnNlbg==?= <toke@redhat.com>
Cc:     David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>, brouer@redhat.com,
        Jonathan Lemon <jonathan.lemon@gmail.com>
Subject: Re: [PATCH net-next 1/2] bpf_xdp_redirect_map: Add flag to return
 XDP_PASS on map lookup failure
Message-ID: <20190605123941.5b1d36ab@carbon>
In-Reply-To: <155966185069.9084.1926498690478259792.stgit@alrua-x1>
References: <155966185058.9084.14076895203527880808.stgit@alrua-x1>
        <155966185069.9084.1926498690478259792.stgit@alrua-x1>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.49]); Wed, 05 Jun 2019 10:39:59 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On Tue, 04 Jun 2019 17:24:10 +0200
Toke Høiland-Jørgensen <toke@redhat.com> wrote:

> The bpf_redirect_map() helper used by XDP programs doesn't return any
> indication of whether it can successfully redirect to the map index it was
> given. Instead, BPF programs have to track this themselves, leading to
> programs using duplicate maps to track which entries are populated in the
> devmap.
> 
> This adds a flag to the XDP version of the bpf_redirect_map() helper, which
> makes the helper do a lookup in the map when called, and return XDP_PASS if
> there is no value at the provided index. This enables two use cases:

To Jonathan Lemon, notice this approach of adding a flag to the helper
call, it actually also works for your use-case of XSK AF_XDP maps.

> - A BPF program can check the return code from the helper call and react if
>   it is XDP_PASS (by, for instance, redirecting out a different interface).
> 
> - Programs that just return the value of the bpf_redirect() call will
>   automatically fall back to the regular networking stack, simplifying
>   programs that (for instance) build a router with the fib_lookup() helper.
> 
> Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
> ---
>  include/uapi/linux/bpf.h |    8 ++++++++
>  net/core/filter.c        |   10 +++++++++-
>  2 files changed, 17 insertions(+), 1 deletion(-)
> 
> diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
> index 7c6aef253173..4c41482b7604 100644
> --- a/include/uapi/linux/bpf.h
> +++ b/include/uapi/linux/bpf.h
> @@ -3098,6 +3098,14 @@ enum xdp_action {
>  	XDP_REDIRECT,
>  };
>  
> +/* Flags for bpf_xdp_redirect_map helper */
> +
> +/* If set, the help will check if the entry exists in the map and return
> + * XDP_PASS if it doesn't.
> + */
> +#define XDP_REDIRECT_PASS_ON_INVALID BIT(0)
> +#define XDP_REDIRECT_ALL_FLAGS XDP_REDIRECT_PASS_ON_INVALID
> +
>  /* user accessible metadata for XDP packet hook
>   * new fields must be added to the end of this structure
>   */
> diff --git a/net/core/filter.c b/net/core/filter.c
> index 55bfc941d17a..dfab8478f66c 100644
> --- a/net/core/filter.c
> +++ b/net/core/filter.c
> @@ -3755,9 +3755,17 @@ BPF_CALL_3(bpf_xdp_redirect_map, struct bpf_map *, map, u32, ifindex,
>  {
>  	struct bpf_redirect_info *ri = this_cpu_ptr(&bpf_redirect_info);
>  
> -	if (unlikely(flags))
> +	if (unlikely(flags & ~XDP_REDIRECT_ALL_FLAGS))
>  		return XDP_ABORTED;
>  
> +	if (flags & XDP_REDIRECT_PASS_ON_INVALID) {
> +		struct net_device *fwd;

It is slightly misguiding that '*fwd' is a 'struct net_device', as the
__xdp_map_lookup_elem() call works for all the supported redirect-map
types.

People should realize that this patch is a general approach for all the
redirect-map types.

> +
> +		fwd = __xdp_map_lookup_elem(map, ifindex);
> +		if (unlikely(!fwd))
> +			return XDP_PASS;
> +	}
> +
>  	ri->ifindex = ifindex;
>  	ri->flags = flags;
>  	WRITE_ONCE(ri->map, map);


-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer
