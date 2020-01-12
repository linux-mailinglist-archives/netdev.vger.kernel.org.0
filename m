Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CA6001386DA
	for <lists+netdev@lfdr.de>; Sun, 12 Jan 2020 15:54:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733042AbgALOyi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 12 Jan 2020 09:54:38 -0500
Received: from mga09.intel.com ([134.134.136.24]:47156 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733021AbgALOyh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 12 Jan 2020 09:54:37 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga102.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 12 Jan 2020 06:54:37 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,425,1571727600"; 
   d="scan'208";a="224668477"
Received: from ranger.igk.intel.com ([10.102.21.164])
  by orsmga003.jf.intel.com with ESMTP; 12 Jan 2020 06:54:34 -0800
Date:   Sun, 12 Jan 2020 08:47:22 +0100
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     John Fastabend <john.fastabend@gmail.com>
Cc:     bjorn.topel@gmail.com, bpf@vger.kernel.org, toke@redhat.com,
        toshiaki.makita1@gmail.com, netdev@vger.kernel.org, ast@kernel.org,
        daniel@iogearbox.net
Subject: Re: [bpf-next PATCH v2 1/2] bpf: xdp, update devmap comments to
 reflect napi/rcu usage
Message-ID: <20200112074722.GA24420@ranger.igk.intel.com>
References: <157879606461.8200.2816751890292483534.stgit@john-Precision-5820-Tower>
 <157879664156.8200.4955971883120344808.stgit@john-Precision-5820-Tower>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <157879664156.8200.4955971883120344808.stgit@john-Precision-5820-Tower>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jan 11, 2020 at 06:37:21PM -0800, John Fastabend wrote:

Small nits for typos, can be ignored.

> Now that we rely on synchronize_rcu and call_rcu waiting to
> exit perempt-disable regions (NAPI) lets update the comments

s/perempt/preempt

> to reflect this.
> 
> Fixes: 0536b85239b84 ("xdp: Simplify devmap cleanup")
> Acked-by: Björn Töpel <bjorn.topel@intel.com>
> Acked-by: Song Liu <songliubraving@fb.com>
> Signed-off-by: John Fastabend <john.fastabend@gmail.com>
> ---
>  kernel/bpf/devmap.c |   21 +++++++++++----------
>  1 file changed, 11 insertions(+), 10 deletions(-)
> 
> diff --git a/kernel/bpf/devmap.c b/kernel/bpf/devmap.c
> index da9c832..f0bf525 100644
> --- a/kernel/bpf/devmap.c
> +++ b/kernel/bpf/devmap.c
> @@ -193,10 +193,12 @@ static void dev_map_free(struct bpf_map *map)
>  
>  	/* At this point bpf_prog->aux->refcnt == 0 and this map->refcnt == 0,
>  	 * so the programs (can be more than one that used this map) were
> -	 * disconnected from events. Wait for outstanding critical sections in
> -	 * these programs to complete. The rcu critical section only guarantees
> -	 * no further reads against netdev_map. It does __not__ ensure pending
> -	 * flush operations (if any) are complete.
> +	 * disconnected from events. The following synchronize_rcu() guarantees
> +	 * both rcu read critical sections complete and waits for
> +	 * preempt-disable regions (NAPI being the relavent context here) so we

s/relavent/relevant

> +	 * are certain there will be no further reads against the netdev_map and
> +	 * all flush operations are complete. Flush operations can only be done
> +	 * from NAPI context for this reason.
>  	 */
>  
>  	spin_lock(&dev_map_lock);
> @@ -498,12 +500,11 @@ static int dev_map_delete_elem(struct bpf_map *map, void *key)
>  		return -EINVAL;
>  
>  	/* Use call_rcu() here to ensure any rcu critical sections have
> -	 * completed, but this does not guarantee a flush has happened
> -	 * yet. Because driver side rcu_read_lock/unlock only protects the
> -	 * running XDP program. However, for pending flush operations the
> -	 * dev and ctx are stored in another per cpu map. And additionally,
> -	 * the driver tear down ensures all soft irqs are complete before
> -	 * removing the net device in the case of dev_put equals zero.
> +	 * completed as well as any flush operations because call_rcu
> +	 * will wait for preempt-disable region to complete, NAPI in this
> +	 * context.  And additionally, the driver tear down ensures all
> +	 * soft irqs are complete before removing the net device in the
> +	 * case of dev_put equals zero.
>  	 */
>  	old_dev = xchg(&dtab->netdev_map[k], NULL);
>  	if (old_dev)
> 
