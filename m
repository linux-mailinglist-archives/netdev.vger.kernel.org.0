Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A48B220050
	for <lists+netdev@lfdr.de>; Tue, 14 Jul 2020 23:52:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728135AbgGNVw1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jul 2020 17:52:27 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:48120 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727983AbgGNVw1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jul 2020 17:52:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1594763543;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=k+fJy0z5kEmIHfoXEa76pGbILtJA4lF4lPbG0nrsZ3I=;
        b=ImhibABHmP/isX9tFZqJYyNnfvTDlsxNi3TiL+yTNDhX5PTarHdzGj0jotuKzXSloNnikG
        xwAlRuxhp98OJ/huPaeyLozyagnN0391yDc4VC9IV3dkefKFqSSTGPNOuqZRv1S5nSRoDH
        FxHxCwAwlJIFhlaI1k7CPonO2FGQx8Y=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-457-BOQBTUXoPCGMi6CjTWYMbQ-1; Tue, 14 Jul 2020 17:52:18 -0400
X-MC-Unique: BOQBTUXoPCGMi6CjTWYMbQ-1
Received: by mail-wm1-f69.google.com with SMTP id o13so62390wmh.9
        for <netdev@vger.kernel.org>; Tue, 14 Jul 2020 14:52:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=k+fJy0z5kEmIHfoXEa76pGbILtJA4lF4lPbG0nrsZ3I=;
        b=j1usiZYqp1b706usY2lL9hDJapzDxjQNUHZgjrkBrcTcAKxjEiRUs1U8Qx8HMjsZWX
         6wfkdFD34vFkwpHPhBmXLGCxVaqk4mobyJgoNgIWMMiC4mr2r/WNvbYctRqq4gMy6hT6
         ILZdWXy13C7eXO+Y3yws210XFDCR6l1EGqHH/LW04C8pLPbp7SECA53ALAT8keIc+ptA
         NiSu5vlashoJaKbQioW9EhK1SFNw1XbahXdOZy87a/5OhKXAle1JKi8YdCTWW88/FnsG
         sz4mSphuedsZvIBKXU1xgclFWo/JwptcYVNZpV8XYCeb41jr/2/I5AtYuQMQNnyrRHM1
         w9rg==
X-Gm-Message-State: AOAM531IsfdeTZ3tQ8tRVOWryrQ5dlWPSXFJpRXyaqau2P8UDauQx06d
        eO1JxeYFkesLFtlfrNfTeyAI7HOrdUYHmzGZA/MPOsrJGMA4JLe53gkfUIMoMo16f0rzpZthi8d
        FWiernATH6T94efb5
X-Received: by 2002:adf:e88b:: with SMTP id d11mr7709919wrm.378.1594763537157;
        Tue, 14 Jul 2020 14:52:17 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyWx2n+zEqAqx7YRwx0FAUCUcyFc1Y+If2BVbHKrwlkB7gA0taC5kOxNZWmx6YuYtSgoM1vRQ==
X-Received: by 2002:adf:e88b:: with SMTP id d11mr7709897wrm.378.1594763536804;
        Tue, 14 Jul 2020 14:52:16 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id e23sm178400wme.35.2020.07.14.14.52.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Jul 2020 14:52:15 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 023661804F0; Tue, 14 Jul 2020 23:52:14 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Hangbin Liu <liuhangbin@gmail.com>, bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, Jiri Benc <jbenc@redhat.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Eelco Chaudron <echaudro@redhat.com>, ast@kernel.org,
        Daniel Borkmann <daniel@iogearbox.net>,
        Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        Hangbin Liu <liuhangbin@gmail.com>
Subject: Re: [PATCHv7 bpf-next 1/3] xdp: add a new helper for dev map multicast support
In-Reply-To: <20200714063257.1694964-2-liuhangbin@gmail.com>
References: <20200709013008.3900892-1-liuhangbin@gmail.com> <20200714063257.1694964-1-liuhangbin@gmail.com> <20200714063257.1694964-2-liuhangbin@gmail.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Tue, 14 Jul 2020 23:52:14 +0200
Message-ID: <87imepg3xt.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hangbin Liu <liuhangbin@gmail.com> writes:

> This patch is for xdp multicast support. which has been discussed
> before[0], The goal is to be able to implement an OVS-like data plane in XDP,
> i.e., a software switch that can forward XDP frames to multiple ports.
>
> To achieve this, an application needs to specify a group of interfaces
> to forward a packet to. It is also common to want to exclude one or more
> physical interfaces from the forwarding operation - e.g., to forward a
> packet to all interfaces in the multicast group except the interface it
> arrived on. While this could be done simply by adding more groups, this
> quickly leads to a combinatorial explosion in the number of groups an
> application has to maintain.
>
> To avoid the combinatorial explosion, we propose to include the ability
> to specify an "exclude group" as part of the forwarding operation. This
> needs to be a group (instead of just a single port index), because there
> may have multi interfaces you want to exclude.
>
> Thus, the logical forwarding operation becomes a "set difference"
> operation, i.e. "forward to all ports in group A that are not also in
> group B". This series implements such an operation using device maps to
> represent the groups. This means that the XDP program specifies two
> device maps, one containing the list of netdevs to redirect to, and the
> other containing the exclude list.
>
> To achieve this, I re-implement a new helper bpf_redirect_map_multi()
> to accept two maps, the forwarding map and exclude map. The forwarding
> map could be DEVMAP or DEVMAP_HASH, but the exclude map *must* be
> DEVMAP_HASH to get better performace. If user don't want to use exclude
> map and just want simply stop redirecting back to ingress device, they
> can use flag BPF_F_EXCLUDE_INGRESS.
>
> As both bpf_xdp_redirect_map() and this new helpers are using struct
> bpf_redirect_info, I add a new ex_map and set tgt_value to NULL in the
> new helper to make a difference with bpf_xdp_redirect_map().
>
> Also I keep the the general data path in net/core/filter.c, the native data
> path in kernel/bpf/devmap.c so we can use direct calls to get better
> performace.
>
> [0] https://xdp-project.net/#Handling-multicast
>
> Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
>
> ---
> v7: Fix helper flag check
>     Limit the *ex_map* to use DEVMAP_HASH only and update function
>     dev_in_exclude_map() to get better performance.
>
> v6: converted helper return types from int to long
>
> v5:
> a) Check devmap_get_next_key() return value.
> b) Pass through flags to __bpf_tx_xdp_map() instead of bool value.
> c) In function dev_map_enqueue_multi(), consume xdpf for the last
>    obj instead of the first on.
> d) Update helper description and code comments to explain that we
>    use NULL target value to distinguish multicast and unicast
>    forwarding.
> e) Update memory model, memory id and frame_sz in xdpf_clone().
>
> v4: Fix bpf_xdp_redirect_map_multi_proto arg2_type typo
>
> v3: Based on Toke's suggestion, do the following update
> a) Update bpf_redirect_map_multi() description in bpf.h.
> b) Fix exclude_ifindex checking order in dev_in_exclude_map().
> c) Fix one more xdpf clone in dev_map_enqueue_multi().
> d) Go find next one in dev_map_enqueue_multi() if the interface is not
>    able to forward instead of abort the whole loop.
> e) Remove READ_ONCE/WRITE_ONCE for ex_map.
>
> v2: Add new syscall bpf_xdp_redirect_map_multi() which could accept
> include/exclude maps directly.
>
> ---
>  include/linux/bpf.h            |  20 +++++
>  include/linux/filter.h         |   1 +
>  include/net/xdp.h              |   1 +
>  include/uapi/linux/bpf.h       |  26 ++++++
>  kernel/bpf/devmap.c            | 140 +++++++++++++++++++++++++++++++++
>  kernel/bpf/verifier.c          |   6 ++
>  net/core/filter.c              | 111 ++++++++++++++++++++++++--
>  net/core/xdp.c                 |  29 +++++++
>  tools/include/uapi/linux/bpf.h |  26 ++++++
>  9 files changed, 355 insertions(+), 5 deletions(-)
>
> diff --git a/include/linux/bpf.h b/include/linux/bpf.h
> index 0cd7f6884c5c..b48d587b8b3b 100644
> --- a/include/linux/bpf.h
> +++ b/include/linux/bpf.h
> @@ -1264,6 +1264,11 @@ int dev_xdp_enqueue(struct net_device *dev, struct xdp_buff *xdp,
>  		    struct net_device *dev_rx);
>  int dev_map_enqueue(struct bpf_dtab_netdev *dst, struct xdp_buff *xdp,
>  		    struct net_device *dev_rx);
> +bool dev_in_exclude_map(struct bpf_dtab_netdev *obj, struct bpf_map *map,
> +			int exclude_ifindex);
> +int dev_map_enqueue_multi(struct xdp_buff *xdp, struct net_device *dev_rx,
> +			  struct bpf_map *map, struct bpf_map *ex_map,
> +			  u32 flags);
>  int dev_map_generic_redirect(struct bpf_dtab_netdev *dst, struct sk_buff *skb,
>  			     struct bpf_prog *xdp_prog);
>  bool dev_map_can_have_prog(struct bpf_map *map);
> @@ -1406,6 +1411,21 @@ int dev_map_enqueue(struct bpf_dtab_netdev *dst, struct xdp_buff *xdp,
>  	return 0;
>  }
>  
> +static inline
> +bool dev_in_exclude_map(struct bpf_dtab_netdev *obj, struct bpf_map *map,
> +			int exclude_ifindex)
> +{
> +	return false;
> +}
> +
> +static inline
> +int dev_map_enqueue_multi(struct xdp_buff *xdp, struct net_device *dev_rx,
> +			  struct bpf_map *map, struct bpf_map *ex_map,
> +			  u32 flags)
> +{
> +	return 0;
> +}
> +
>  struct sk_buff;
>  
>  static inline int dev_map_generic_redirect(struct bpf_dtab_netdev *dst,
> diff --git a/include/linux/filter.h b/include/linux/filter.h
> index 259377723603..cf5b5b1d9ae5 100644
> --- a/include/linux/filter.h
> +++ b/include/linux/filter.h
> @@ -612,6 +612,7 @@ struct bpf_redirect_info {
>  	u32 tgt_index;
>  	void *tgt_value;
>  	struct bpf_map *map;
> +	struct bpf_map *ex_map;
>  	u32 kern_flags;
>  };
>  
> diff --git a/include/net/xdp.h b/include/net/xdp.h
> index 609f819ed08b..deb6c104e698 100644
> --- a/include/net/xdp.h
> +++ b/include/net/xdp.h
> @@ -110,6 +110,7 @@ void xdp_warn(const char *msg, const char *func, const int line);
>  #define XDP_WARN(msg) xdp_warn(msg, __func__, __LINE__)
>  
>  struct xdp_frame *xdp_convert_zc_to_xdp_frame(struct xdp_buff *xdp);
> +struct xdp_frame *xdpf_clone(struct xdp_frame *xdpf);
>  
>  static inline
>  void xdp_convert_frame_to_buff(struct xdp_frame *frame, struct xdp_buff *xdp)
> diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
> index 548a749aebb3..ce0fb7c8bd5e 100644
> --- a/include/uapi/linux/bpf.h
> +++ b/include/uapi/linux/bpf.h
> @@ -3319,6 +3319,26 @@ union bpf_attr {
>   *		A non-negative value equal to or less than *size* on success,
>   *		or a negative error in case of failure.
>   *
> + * long bpf_redirect_map_multi(struct bpf_map *map, struct bpf_map *ex_map, u64 flags)
> + * 	Description
> + * 		This is a multicast implementation for XDP redirect. It will
> + * 		redirect the packet to ALL the interfaces in *map*, but
> + * 		exclude the interfaces in *ex_map*.
> + *
> + * 		The frowarding *map* could be either BPF_MAP_TYPE_DEVMAP or
> + * 		BPF_MAP_TYPE_DEVMAP_HASH. But the *ex_map* must be
> + * 		BPF_MAP_TYPE_DEVMAP_HASH to get better performance.
> + *
> + * 		Currently the *flags* only supports *BPF_F_EXCLUDE_INGRESS*,
> + * 		which additionally excludes the current ingress device.
> + *
> + * 		See also bpf_redirect_map() as a unicast implementation,
> + * 		which supports redirecting packet to a specific ifindex
> + * 		in the map. As both helpers use struct bpf_redirect_info
> + * 		to store the redirect info, we will use a a NULL tgt_value
> + * 		to distinguish multicast and unicast redirecting.
> + * 	Return
> + * 		**XDP_REDIRECT** on success, or **XDP_ABORTED** on error.
>   */
>  #define __BPF_FUNC_MAPPER(FN)		\
>  	FN(unspec),			\
> @@ -3463,6 +3483,7 @@ union bpf_attr {
>  	FN(skc_to_tcp_request_sock),	\
>  	FN(skc_to_udp6_sock),		\
>  	FN(get_task_stack),		\
> +	FN(redirect_map_multi),		\
>  	/* */
>  
>  /* integer value in 'imm' field of BPF_CALL instruction selects which helper
> @@ -3624,6 +3645,11 @@ enum bpf_lwt_encap_mode {
>  	BPF_LWT_ENCAP_IP,
>  };
>  
> +/* BPF_FUNC_redirect_map_multi flags. */
> +enum {
> +	BPF_F_EXCLUDE_INGRESS		= (1ULL << 0),
> +};
> +
>  #define __bpf_md_ptr(type, name)	\
>  union {					\
>  	type name;			\
> diff --git a/kernel/bpf/devmap.c b/kernel/bpf/devmap.c
> index 10abb06065bb..bef81f869728 100644
> --- a/kernel/bpf/devmap.c
> +++ b/kernel/bpf/devmap.c
> @@ -512,6 +512,146 @@ int dev_map_enqueue(struct bpf_dtab_netdev *dst, struct xdp_buff *xdp,
>  	return __xdp_enqueue(dev, xdp, dev_rx);
>  }
>  
> +/* Use direct call in fast path instead of map->ops->map_get_next_key() */
> +static int devmap_get_next_key(struct bpf_map *map, void *key, void *next_key)
> +{
> +
> +	switch (map->map_type) {
> +	case BPF_MAP_TYPE_DEVMAP:
> +		return dev_map_get_next_key(map, key, next_key);
> +	case BPF_MAP_TYPE_DEVMAP_HASH:
> +		return dev_map_hash_get_next_key(map, key, next_key);
> +	default:
> +		break;
> +	}
> +
> +	return -ENOENT;
> +}
> +
> +bool dev_in_exclude_map(struct bpf_dtab_netdev *obj, struct bpf_map *map,
> +			int exclude_ifindex)
> +{
> +	struct bpf_dtab *dtab = container_of(map, struct bpf_dtab, map);
> +	struct bpf_dtab_netdev *dev;
> +	struct hlist_head *head;
> +	int i = 0;
> +
> +	if (obj->dev->ifindex == exclude_ifindex)
> +		return true;
> +
> +	if (!map || map->map_type != BPF_MAP_TYPE_DEVMAP_HASH)
> +		return false;

The map type should probably be checked earlier and the whole operation
aborted if it is wrong...

> +
> +	for (; i < dtab->n_buckets; i++) {
> +		head = dev_map_index_hash(dtab, i);
> +
> +		dev = hlist_entry_safe(rcu_dereference_raw(hlist_first_rcu(head)),
> +					    struct bpf_dtab_netdev,
> +					    index_hlist);
> +
> +		if (dev && dev->idx == exclude_ifindex)
> +			return true;
> +	}

This looks broken; why are you iterating through the buckets? Shouldn't
this just be something like:

return __dev_map_hash_lookup_elem(map, obj->dev->ifindex) != NULL;

-Toke

