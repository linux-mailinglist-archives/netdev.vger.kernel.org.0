Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 819AC25DB64
	for <lists+netdev@lfdr.de>; Fri,  4 Sep 2020 16:22:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730787AbgIDOWX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Sep 2020 10:22:23 -0400
Received: from www62.your-server.de ([213.133.104.62]:60716 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730716AbgIDOWJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Sep 2020 10:22:09 -0400
Received: from sslproxy06.your-server.de ([78.46.172.3])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1kECbL-0008HQ-GH; Fri, 04 Sep 2020 16:22:03 +0200
Received: from [2001:1620:665:0:5795:5b0a:e5d5:5944] (helo=linux.fritz.box)
        by sslproxy06.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1kECbL-000WgX-8S; Fri, 04 Sep 2020 16:22:03 +0200
Subject: Re: [PATCHv10 bpf-next 2/5] xdp: add a new helper for dev map
 multicast support
To:     Hangbin Liu <liuhangbin@gmail.com>, bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org,
        =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>,
        Jiri Benc <jbenc@redhat.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Eelco Chaudron <echaudro@redhat.com>, ast@kernel.org,
        Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>
References: <20200826132002.2808380-1-liuhangbin@gmail.com>
 <20200903102701.3913258-1-liuhangbin@gmail.com>
 <20200903102701.3913258-3-liuhangbin@gmail.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <609c2fdf-09b7-b86e-26c0-ad386770ac33@iogearbox.net>
Date:   Fri, 4 Sep 2020 16:22:02 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20200903102701.3913258-3-liuhangbin@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.4/25919/Thu Sep  3 15:39:22 2020)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/3/20 12:26 PM, Hangbin Liu wrote:
[...]
> diff --git a/include/net/xdp.h b/include/net/xdp.h
> index 3814fb631d52..8453d477bb22 100644
> --- a/include/net/xdp.h
> +++ b/include/net/xdp.h
> @@ -132,6 +132,7 @@ void xdp_warn(const char *msg, const char *func, const int line);
>   #define XDP_WARN(msg) xdp_warn(msg, __func__, __LINE__)
>   
>   struct xdp_frame *xdp_convert_zc_to_xdp_frame(struct xdp_buff *xdp);
> +struct xdp_frame *xdpf_clone(struct xdp_frame *xdpf);
>   
>   static inline
>   void xdp_convert_frame_to_buff(struct xdp_frame *frame, struct xdp_buff *xdp)
> diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
> index 8dda13880957..e897c4a04061 100644
> --- a/include/uapi/linux/bpf.h
> +++ b/include/uapi/linux/bpf.h
> @@ -3576,6 +3576,27 @@ union bpf_attr {
>    * 		the data in *dst*. This is a wrapper of copy_from_user().
>    * 	Return
>    * 		0 on success, or a negative error in case of failure.
> + *
> + * long bpf_redirect_map_multi(struct bpf_map *map, struct bpf_map *ex_map, u64 flags)
> + * 	Description
> + * 		This is a multicast implementation for XDP redirect. It will
> + * 		redirect the packet to ALL the interfaces in *map*, but
> + * 		exclude the interfaces in *ex_map*.
> + *
> + * 		The frowarding *map* could be either BPF_MAP_TYPE_DEVMAP or

nit: typo

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
>    */
>   #define __BPF_FUNC_MAPPER(FN)		\
>   	FN(unspec),			\
> @@ -3727,6 +3748,7 @@ union bpf_attr {
>   	FN(inode_storage_delete),	\
>   	FN(d_path),			\
>   	FN(copy_from_user),		\
> +	FN(redirect_map_multi),		\
>   	/* */
>   
>   /* integer value in 'imm' field of BPF_CALL instruction selects which helper
> @@ -3898,6 +3920,11 @@ enum bpf_lwt_encap_mode {
>   	BPF_LWT_ENCAP_IP,
>   };
>   
> +/* BPF_FUNC_redirect_map_multi flags. */
> +enum {
> +	BPF_F_EXCLUDE_INGRESS		= (1ULL << 0),
> +};
> +
>   #define __bpf_md_ptr(type, name)	\
>   union {					\
>   	type name;			\
> diff --git a/kernel/bpf/devmap.c b/kernel/bpf/devmap.c
> index 2b5ca93c17de..04950e96282c 100644
> --- a/kernel/bpf/devmap.c
> +++ b/kernel/bpf/devmap.c
> @@ -511,6 +511,130 @@ int dev_map_enqueue(struct bpf_dtab_netdev *dst, struct xdp_buff *xdp,
>   	return __xdp_enqueue(dev, xdp, dev_rx);
>   }
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
> +	if (obj->dev->ifindex == exclude_ifindex)
> +		return true;
> +
> +	if (!map)
> +		return false;
> +
> +	return __dev_map_hash_lookup_elem(map, obj->dev->ifindex) != NULL;
> +}
> +
> +static struct bpf_dtab_netdev *devmap_get_next_obj(struct xdp_buff *xdp, struct bpf_map *map,
> +						   struct bpf_map *ex_map, u32 *key,
> +						   u32 *next_key, int ex_ifindex)
> +{
> +	struct bpf_dtab_netdev *obj;
> +	struct net_device *dev;
> +	u32 *tmp_key = key;
> +	int err;
> +
> +	err = devmap_get_next_key(map, tmp_key, next_key);
> +	if (err)
> +		return NULL;
> +
> +	for (;;) {
> +		switch (map->map_type) {
> +		case BPF_MAP_TYPE_DEVMAP:
> +			obj = __dev_map_lookup_elem(map, *next_key);
> +			break;
> +		case BPF_MAP_TYPE_DEVMAP_HASH:
> +			obj = __dev_map_hash_lookup_elem(map, *next_key);
> +			break;
> +		default:
> +			break;
> +		}
> +
> +		if (!obj || dev_in_exclude_map(obj, ex_map, ex_ifindex))
> +			goto find_next;
> +
> +		dev = obj->dev;
> +
> +		if (!dev->netdev_ops->ndo_xdp_xmit)
> +			goto find_next;
> +
> +		err = xdp_ok_fwd_dev(dev, xdp->data_end - xdp->data);
> +		if (unlikely(err))
> +			goto find_next;
> +
> +		return obj;
> +
> +find_next:
> +		tmp_key = next_key;
> +		err = devmap_get_next_key(map, tmp_key, next_key);

For all the devmap_get_next_key() or map->ops->map_get_next_key() (in dev_map_redirect_multi())
in the case of dev map hash, we could restart the hashtab traversal in case the key has been
updated/removed in the mean time, so we'd end up potentially looping due to traversal restarts
from first elem. Instead of for (;;) there should be an upper limit, so we don't perform this
forever, afaics.

> +		if (err)
> +			break;
> +	}
> +
> +	return NULL;
> +}
> +
