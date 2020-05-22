Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2ED471DE651
	for <lists+netdev@lfdr.de>; Fri, 22 May 2020 14:09:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730025AbgEVMIz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 May 2020 08:08:55 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:60819 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1730010AbgEVMIy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 May 2020 08:08:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1590149332;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=u/HlAcXKy6POHIGIcLRkxndzZPc/CF+My2FFUK06Fks=;
        b=e9kuM+5HSm/KhhOl5An971C/OVWf379T+/FI5XYMzcBqiwgGfwxRRxKuj5/N6V+DChIAwD
        MCdTK+Gs99beKANJBtDcqDma0kFI6lMHcrquDjBPslWAzwff5fAf0fZ5yyZ3WON0Fo5lC2
        GTiFJorb+j/oSHIvImbinBraYl2AdaQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-165-Aep6l-uhO124_mFr6GBV8Q-1; Fri, 22 May 2020 08:08:50 -0400
X-MC-Unique: Aep6l-uhO124_mFr6GBV8Q-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8842C8018A2;
        Fri, 22 May 2020 12:08:48 +0000 (UTC)
Received: from carbon (unknown [10.40.208.9])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 62ABE19167;
        Fri, 22 May 2020 12:08:07 +0000 (UTC)
Date:   Fri, 22 May 2020 14:08:05 +0200
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     David Ahern <dsahern@kernel.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        toke@redhat.com, daniel@iogearbox.net, john.fastabend@gmail.com,
        ast@kernel.org, kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        andriin@fb.com, dsahern@gmail.com, brouer@redhat.com,
        Lorenzo Bianconi <lorenzo@kernel.org>
Subject: Re: [PATCH RFC bpf-next 1/4] bpf: Handle 8-byte values in DEVMAP
 and DEVMAP_HASH
Message-ID: <20200522140805.045b8823@carbon>
In-Reply-To: <20200522010526.14649-2-dsahern@kernel.org>
References: <20200522010526.14649-1-dsahern@kernel.org>
        <20200522010526.14649-2-dsahern@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 21 May 2020 19:05:23 -0600
David Ahern <dsahern@kernel.org> wrote:

> Add support to DEVMAP and DEVMAP_HASH to support 8-byte values as a
> <device index, program id> pair. To do this, a new struct is needed in
> bpf_dtab_netdev to hold the values to return on lookup.

I would like to see us leverage BTF instead of checking on the size
attr->value_size. E.g do the sanity check based on BTF.
Given I don't know the exact details on how this should be done, I will
look into it... I already promised Lorenzo, as we have already
discussed this on IRC.

So, you can Lorenzo can go ahead with this approach, and test the
use-case. And I'll try to figure out if-and-how we can leverage BTF
here.  Input from BTF experts will be much appreciated.


> Signed-off-by: David Ahern <dsahern@kernel.org>
> ---
>  kernel/bpf/devmap.c | 53 ++++++++++++++++++++++++++++++++++-----------
>  1 file changed, 40 insertions(+), 13 deletions(-)
> 
> diff --git a/kernel/bpf/devmap.c b/kernel/bpf/devmap.c
> index a51d9fb7a359..2c01ce434306 100644
> --- a/kernel/bpf/devmap.c
> +++ b/kernel/bpf/devmap.c
> @@ -60,12 +60,19 @@ struct xdp_dev_bulk_queue {
>  	unsigned int count;
>  };
>  
> +/* devmap value can be dev index or dev index + prog id */
> +struct dev_map_ext_val {
> +	u32 ifindex;	/* must be first for compat with 4-byte values */
> +	u32 prog_id;
> +};
> +
>  struct bpf_dtab_netdev {
>  	struct net_device *dev; /* must be first member, due to tracepoint */
>  	struct hlist_node index_hlist;
>  	struct bpf_dtab *dtab;
>  	struct rcu_head rcu;
>  	unsigned int idx;
> +	struct dev_map_ext_val val;
>  };
>  
>  struct bpf_dtab {
> @@ -108,9 +115,13 @@ static int dev_map_init_map(struct bpf_dtab *dtab, union bpf_attr *attr)
>  	u64 cost = 0;
>  	int err;
>  
> -	/* check sanity of attributes */
> +	/* check sanity of attributes. 2 value sizes supported:
> +	 * 4 bytes: ifindex
> +	 * 8 bytes: ifindex + prog id
> +	 */
>  	if (attr->max_entries == 0 || attr->key_size != 4 ||
> -	    attr->value_size != 4 || attr->map_flags & ~DEV_CREATE_FLAG_MASK)
> +	    (attr->value_size != 4 && attr->value_size != 8) ||
> +	    attr->map_flags & ~DEV_CREATE_FLAG_MASK)
>  		return -EINVAL;
>  
>  	/* Lookup returns a pointer straight to dev->ifindex, so make sure the
[...]

>  static int __dev_map_update_elem(struct net *net, struct bpf_map *map,
> @@ -568,8 +579,16 @@ static int __dev_map_update_elem(struct net *net, struct bpf_map *map,
>  {
>  	struct bpf_dtab *dtab = container_of(map, struct bpf_dtab, map);
>  	struct bpf_dtab_netdev *dev, *old_dev;
> -	u32 ifindex = *(u32 *)value;
>  	u32 i = *(u32 *)key;
> +	u32 ifindex;
> +
> +	if (map->value_size == 4) {
> +		ifindex = *(u32 *)value;
> +	} else {
> +		struct dev_map_ext_val *val = value;
> +
> +		ifindex = val->ifindex;
> +	}
>  
>  	if (unlikely(map_flags > BPF_EXIST))
>  		return -EINVAL;
> @@ -609,10 +628,18 @@ static int __dev_map_hash_update_elem(struct net *net, struct bpf_map *map,
>  {
>  	struct bpf_dtab *dtab = container_of(map, struct bpf_dtab, map);
>  	struct bpf_dtab_netdev *dev, *old_dev;
> -	u32 ifindex = *(u32 *)value;
>  	u32 idx = *(u32 *)key;
>  	unsigned long flags;
>  	int err = -EEXIST;
> +	u32 ifindex;
> +
> +	if (map->value_size == 4) {
> +		ifindex = *(u32 *)value;
> +	} else {
> +		struct dev_map_ext_val *val = value;
> +
> +		ifindex = val->ifindex;
> +	}
>  
>  	if (unlikely(map_flags > BPF_EXIST || !ifindex))
>  		return -EINVAL;



-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

