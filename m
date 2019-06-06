Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 35B7737549
	for <lists+netdev@lfdr.de>; Thu,  6 Jun 2019 15:34:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727482AbfFFNeE convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 6 Jun 2019 09:34:04 -0400
Received: from mx1.redhat.com ([209.132.183.28]:39108 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726924AbfFFNeE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 6 Jun 2019 09:34:04 -0400
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id B63A3916C0;
        Thu,  6 Jun 2019 13:33:53 +0000 (UTC)
Received: from carbon (ovpn-200-32.brq.redhat.com [10.40.200.32])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 6484B619B9;
        Thu,  6 Jun 2019 13:33:46 +0000 (UTC)
Date:   Thu, 6 Jun 2019 15:33:44 +0200
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Toke =?UTF-8?B?SMO4aWxhbmQtSsO4cmdlbnNlbg==?= <toke@redhat.com>
Cc:     David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>, brouer@redhat.com
Subject: Re: [PATCH net-next v2 2/2] devmap: Allow map lookups from eBPF
Message-ID: <20190606153344.4871ffa2@carbon>
In-Reply-To: <155982745466.30088.16226777266948206538.stgit@alrua-x1>
References: <155982745450.30088.1132406322084580770.stgit@alrua-x1>
        <155982745466.30088.16226777266948206538.stgit@alrua-x1>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.29]); Thu, 06 Jun 2019 13:34:03 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 06 Jun 2019 15:24:14 +0200
Toke Høiland-Jørgensen <toke@redhat.com> wrote:

> From: Toke Høiland-Jørgensen <toke@redhat.com>
> 
> We don't currently allow lookups into a devmap from eBPF, because the map
> lookup returns a pointer directly to the dev->ifindex, which shouldn't be
> modifiable from eBPF.
> 
> However, being able to do lookups in devmaps is useful to know (e.g.)
> whether forwarding to a specific interface is enabled. Currently, programs
> work around this by keeping a shadow map of another type which indicates
> whether a map index is valid.
> 
> Since we now have a flag to make maps read-only from the eBPF side, we can
> simply lift the lookup restriction if we make sure this flag is always set.

Nice, I didn't know this was possible.  I like it! :-)

> Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
> ---
>  kernel/bpf/devmap.c   |    5 +++++
>  kernel/bpf/verifier.c |    7 ++-----
>  2 files changed, 7 insertions(+), 5 deletions(-)
> 
> diff --git a/kernel/bpf/devmap.c b/kernel/bpf/devmap.c
> index 5ae7cce5ef16..0e6875a462ef 100644
> --- a/kernel/bpf/devmap.c
> +++ b/kernel/bpf/devmap.c
> @@ -99,6 +99,11 @@ static struct bpf_map *dev_map_alloc(union bpf_attr *attr)
>  	    attr->value_size != 4 || attr->map_flags & ~DEV_CREATE_FLAG_MASK)
>  		return ERR_PTR(-EINVAL);
>  
> +	/* Lookup returns a pointer straight to dev->ifindex, so make sure the
> +	 * verifier prevents writes from the BPF side
> +	 */
> +	attr->map_flags |= BPF_F_RDONLY_PROG;
> +
>  	dtab = kzalloc(sizeof(*dtab), GFP_USER);
>  	if (!dtab)
>  		return ERR_PTR(-ENOMEM);
> diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
> index 5c2cb5bd84ce..7128a9821481 100644
> --- a/kernel/bpf/verifier.c
> +++ b/kernel/bpf/verifier.c
> @@ -2893,12 +2893,9 @@ static int check_map_func_compatibility(struct bpf_verifier_env *env,
>  		if (func_id != BPF_FUNC_get_local_storage)
>  			goto error;
>  		break;
> -	/* devmap returns a pointer to a live net_device ifindex that we cannot
> -	 * allow to be modified from bpf side. So do not allow lookup elements
> -	 * for now.
> -	 */
>  	case BPF_MAP_TYPE_DEVMAP:
> -		if (func_id != BPF_FUNC_redirect_map)
> +		if (func_id != BPF_FUNC_redirect_map &&
> +		    func_id != BPF_FUNC_map_lookup_elem)
>  			goto error;
>  		break;
>  	/* Restrict bpf side of cpumap and xskmap, open when use-cases
> 



-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer
