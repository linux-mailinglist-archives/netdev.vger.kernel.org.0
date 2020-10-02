Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB9A22811C9
	for <lists+netdev@lfdr.de>; Fri,  2 Oct 2020 13:56:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387936AbgJBL4j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Oct 2020 07:56:39 -0400
Received: from mga02.intel.com ([134.134.136.20]:49200 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726090AbgJBL4i (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 2 Oct 2020 07:56:38 -0400
IronPort-SDR: f4MhOr0IJj27enTpHxqZT0m66cy11mZP9+zmpC22jmROy7JXUuQanxIV7kgQQ1MFr7T488PfA9
 DlgTFw3JWGTw==
X-IronPort-AV: E=McAfee;i="6000,8403,9761"; a="150605520"
X-IronPort-AV: E=Sophos;i="5.77,327,1596524400"; 
   d="scan'208";a="150605520"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Oct 2020 04:56:34 -0700
IronPort-SDR: KMIushWI+tKTPMsZSbXkeqOW/8LRd4C5WXZk+9caixuIBRvEkonRuxCUoPBpBcu529NqxBPgGC
 6rN6LGmMIz2g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.77,327,1596524400"; 
   d="scan'208";a="352354403"
Received: from ranger.igk.intel.com ([10.102.21.164])
  by orsmga007.jf.intel.com with ESMTP; 02 Oct 2020 04:56:30 -0700
Date:   Fri, 2 Oct 2020 13:49:36 +0200
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     Hangbin Liu <liuhangbin@gmail.com>
Cc:     bpf@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>, netdev@vger.kernel.org,
        Toke =?iso-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@redhat.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>
Subject: Re: [PATCH libbpf] libbpf: check if pin_path was set even map fd
 exist
Message-ID: <20201002114936.GA20275@ranger.igk.intel.com>
References: <20201002075750.1978298-1-liuhangbin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201002075750.1978298-1-liuhangbin@gmail.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 02, 2020 at 03:57:50PM +0800, Hangbin Liu wrote:
> Say a user reuse map fd after creating a map manually and set the
> pin_path, then load the object via libbpf.
> 
> In libbpf bpf_object__create_maps(), bpf_object__reuse_map() will
> return 0 if there is no pinned map in map->pin_path. Then after
> checking if map fd exist, we should also check if pin_path was set
> and do bpf_map__pin() instead of continue the loop.
> 
> Fix it by creating map if fd not exist and continue checking pin_path
> after that.
> 
> Suggested-by: Andrii Nakryiko <andrii.nakryiko@gmail.com>
> Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
> ---
>  tools/lib/bpf/libbpf.c | 75 +++++++++++++++++++++---------------------
>  1 file changed, 37 insertions(+), 38 deletions(-)
> 
> diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
> index e493d6048143..d4149585a76c 100644
> --- a/tools/lib/bpf/libbpf.c
> +++ b/tools/lib/bpf/libbpf.c
> @@ -3861,50 +3861,49 @@ bpf_object__create_maps(struct bpf_object *obj)
>  			}
>  		}
>  
> -		if (map->fd >= 0) {
> -			pr_debug("map '%s': skipping creation (preset fd=%d)\n",
> -				 map->name, map->fd);
> -			continue;
> -		}
> -
> -		err = bpf_object__create_map(obj, map);
> -		if (err)
> -			goto err_out;
> -
> -		pr_debug("map '%s': created successfully, fd=%d\n", map->name,
> -			 map->fd);
> -
> -		if (bpf_map__is_internal(map)) {
> -			err = bpf_object__populate_internal_map(obj, map);
> -			if (err < 0) {
> -				zclose(map->fd);
> +		if (map->fd < 0) {
> +			err = bpf_object__create_map(obj, map);
> +			if (err)
>  				goto err_out;
> -			}
> -		}
> -
> -		if (map->init_slots_sz) {
> -			for (j = 0; j < map->init_slots_sz; j++) {
> -				const struct bpf_map *targ_map;
> -				int fd;
>  
> -				if (!map->init_slots[j])
> -					continue;
> +			pr_debug("map '%s': created successfully, fd=%d\n", map->name,
> +				 map->fd);
>  
> -				targ_map = map->init_slots[j];
> -				fd = bpf_map__fd(targ_map);
> -				err = bpf_map_update_elem(map->fd, &j, &fd, 0);
> -				if (err) {
> -					err = -errno;
> -					pr_warn("map '%s': failed to initialize slot [%d] to map '%s' fd=%d: %d\n",
> -						map->name, j, targ_map->name,
> -						fd, err);
> +			if (bpf_map__is_internal(map)) {
> +				err = bpf_object__populate_internal_map(obj, map);
> +				if (err < 0) {
> +					zclose(map->fd);
>  					goto err_out;
>  				}
> -				pr_debug("map '%s': slot [%d] set to map '%s' fd=%d\n",
> -					 map->name, j, targ_map->name, fd);
>  			}
> -			zfree(&map->init_slots);
> -			map->init_slots_sz = 0;
> +
> +			if (map->init_slots_sz) {

Couldn't we flatten the code by inverting the logic here and using goto?

	if (!map->init_slot_sz) {
		pr_debug("map '%s': skipping creation (preset fd=%d)\n",
			 map->name, map->fd);
		goto map_pin;
	}

	(...)
map_pin:
	if (map->pin_path && !map->pinned) {

If I'm reading this right.

> +				for (j = 0; j < map->init_slots_sz; j++) {
> +					const struct bpf_map *targ_map;
> +					int fd;
> +
> +					if (!map->init_slots[j])
> +						continue;
> +
> +					targ_map = map->init_slots[j];
> +					fd = bpf_map__fd(targ_map);
> +					err = bpf_map_update_elem(map->fd, &j, &fd, 0);
> +					if (err) {
> +						err = -errno;
> +						pr_warn("map '%s': failed to initialize slot [%d] to map '%s' fd=%d: %d\n",
> +							map->name, j, targ_map->name,
> +							fd, err);
> +						goto err_out;
> +					}
> +					pr_debug("map '%s': slot [%d] set to map '%s' fd=%d\n",
> +						map->name, j, targ_map->name, fd);
> +				}
> +				zfree(&map->init_slots);
> +				map->init_slots_sz = 0;
> +			}
> +		} else {
> +			pr_debug("map '%s': skipping creation (preset fd=%d)\n",
> +				 map->name, map->fd);
>  		}
>  
>  		if (map->pin_path && !map->pinned) {
> -- 
> 2.25.4
> 
