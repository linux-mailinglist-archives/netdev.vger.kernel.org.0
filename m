Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7997234DBE
	for <lists+netdev@lfdr.de>; Tue,  4 Jun 2019 18:36:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728036AbfFDQgO convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 4 Jun 2019 12:36:14 -0400
Received: from mx1.redhat.com ([209.132.183.28]:55456 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727831AbfFDQgO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 4 Jun 2019 12:36:14 -0400
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 85A213087932;
        Tue,  4 Jun 2019 16:36:11 +0000 (UTC)
Received: from carbon (ovpn-200-32.brq.redhat.com [10.40.200.32])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A0CD960566;
        Tue,  4 Jun 2019 16:36:01 +0000 (UTC)
Date:   Tue, 4 Jun 2019 18:35:59 +0200
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Toke =?UTF-8?B?SMO4aWxhbmQtSsO4cmdlbnNlbg==?= <toke@redhat.com>
Cc:     David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>, brouer@redhat.com,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Jiri Olsa <jolsa@redhat.com>
Subject: Re: [PATCH net-next 2/2] devmap: Allow map lookups from eBPF
Message-ID: <20190604183559.10db09d2@carbon>
In-Reply-To: <155966185078.9084.7775851923786129736.stgit@alrua-x1>
References: <155966185058.9084.14076895203527880808.stgit@alrua-x1>
        <155966185078.9084.7775851923786129736.stgit@alrua-x1>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.45]); Tue, 04 Jun 2019 16:36:13 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 04 Jun 2019 17:24:10 +0200
Toke Høiland-Jørgensen <toke@redhat.com> wrote:

> We don't currently allow lookups into a devmap from eBPF, because the map
> lookup returns a pointer directly to the dev->ifindex, which shouldn't be
> modifiable from eBPF.
> 
> However, being able to do lookups in devmaps is useful to know (e.g.)
> whether forwarding to a specific interface is enabled. Currently, programs
> work around this by keeping a shadow map of another type which indicates
> whether a map index is valid.
> 
> To allow lookups, simply copy the ifindex into a scratch variable and
> return a pointer to this. If an eBPF program does modify it, this doesn't
> matter since it will be overridden on the next lookup anyway. While this
> does add a write to every lookup, the overhead of this is negligible
> because the cache line is hot when both the write and the subsequent
> read happens.

When we choose the return value, here the ifindex, then this basically
becomes UABI, right?

Can we somehow use BTF to help us to make this extensible?

As Toke mention in the cover letter, we really want to know if the
chosen egress have actually enabled/allocated resources for XDP
transmitting, but as we currently don't have in-kernel way to query
thus (thus, we cannot expose such info).


> Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
> ---
>  kernel/bpf/devmap.c   |    8 +++++++-
>  kernel/bpf/verifier.c |    7 ++-----
>  2 files changed, 9 insertions(+), 6 deletions(-)
> 
> diff --git a/kernel/bpf/devmap.c b/kernel/bpf/devmap.c
> index 5ae7cce5ef16..830650300ea4 100644
> --- a/kernel/bpf/devmap.c
> +++ b/kernel/bpf/devmap.c
> @@ -65,6 +65,7 @@ struct xdp_bulk_queue {
>  struct bpf_dtab_netdev {
>  	struct net_device *dev; /* must be first member, due to tracepoint */
>  	struct bpf_dtab *dtab;
> +	int ifindex_scratch;
>  	unsigned int bit;
>  	struct xdp_bulk_queue __percpu *bulkq;
>  	struct rcu_head rcu;
> @@ -375,7 +376,12 @@ static void *dev_map_lookup_elem(struct bpf_map *map, void *key)
>  	struct bpf_dtab_netdev *obj = __dev_map_lookup_elem(map, *(u32 *)key);
>  	struct net_device *dev = obj ? obj->dev : NULL;
>  
> -	return dev ? &dev->ifindex : NULL;
> +	if (dev) {
> +		obj->ifindex_scratch = dev->ifindex;
> +		return &obj->ifindex_scratch;
> +	}
> +
> +	return NULL;
>  }
>  
>  static void dev_map_flush_old(struct bpf_dtab_netdev *dev)
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
