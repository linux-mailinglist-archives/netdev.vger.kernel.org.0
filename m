Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7AD42132A9B
	for <lists+netdev@lfdr.de>; Tue,  7 Jan 2020 17:00:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728374AbgAGQAq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jan 2020 11:00:46 -0500
Received: from www62.your-server.de ([213.133.104.62]:52230 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728348AbgAGQAq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jan 2020 11:00:46 -0500
Received: from sslproxy02.your-server.de ([78.47.166.47])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1iorHa-0006u1-22; Tue, 07 Jan 2020 17:00:38 +0100
Received: from [2001:1620:665:0:5795:5b0a:e5d5:5944] (helo=linux.fritz.box)
        by sslproxy02.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1iorHZ-000VPD-PW; Tue, 07 Jan 2020 17:00:37 +0100
Subject: Re: [PATCH bpf-next v3 06/11] bpf: Introduce BPF_MAP_TYPE_STRUCT_OPS
To:     Martin KaFai Lau <kafai@fb.com>, bpf@vger.kernel.org
Cc:     Alexei Starovoitov <ast@kernel.org>,
        David Miller <davem@davemloft.net>, kernel-team@fb.com,
        netdev@vger.kernel.org
References: <20191231062037.280596-1-kafai@fb.com>
 <20191231062050.281712-1-kafai@fb.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <4d0aafe9-75c7-43fe-d9eb-62bb2053b53e@iogearbox.net>
Date:   Tue, 7 Jan 2020 17:00:37 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20191231062050.281712-1-kafai@fb.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.101.4/25687/Tue Jan  7 10:56:22 2020)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/31/19 7:20 AM, Martin KaFai Lau wrote:
[...]
> +static int bpf_struct_ops_map_update_elem(struct bpf_map *map, void *key,
> +					  void *value, u64 flags)
> +{
> +	struct bpf_struct_ops_map *st_map = (struct bpf_struct_ops_map *)map;
> +	const struct bpf_struct_ops *st_ops = st_map->st_ops;
> +	struct bpf_struct_ops_value *uvalue, *kvalue;
> +	const struct btf_member *member;
> +	const struct btf_type *t = st_ops->type;
> +	void *udata, *kdata;
> +	int prog_fd, err = 0;
> +	void *image;
> +	u32 i;
> +
> +	if (flags)
> +		return -EINVAL;
> +
> +	if (*(u32 *)key != 0)
> +		return -E2BIG;
> +
> +	err = check_zero_holes(st_ops->value_type, value);
> +	if (err)
> +		return err;
> +
> +	uvalue = (struct bpf_struct_ops_value *)value;
> +	err = check_zero_holes(t, uvalue->data);
> +	if (err)
> +		return err;
> +
> +	if (uvalue->state || refcount_read(&uvalue->refcnt))
> +		return -EINVAL;
> +
> +	uvalue = (struct bpf_struct_ops_value *)st_map->uvalue;
> +	kvalue = (struct bpf_struct_ops_value *)&st_map->kvalue;
> +
> +	spin_lock(&st_map->lock);
> +
> +	if (kvalue->state != BPF_STRUCT_OPS_STATE_INIT) {
> +		err = -EBUSY;
> +		goto unlock;
> +	}
> +
> +	memcpy(uvalue, value, map->value_size);
> +
> +	udata = &uvalue->data;
> +	kdata = &kvalue->data;
> +	image = st_map->image;
> +
> +	for_each_member(i, t, member) {
> +		const struct btf_type *mtype, *ptype;
> +		struct bpf_prog *prog;
> +		u32 moff;
> +
> +		moff = btf_member_bit_offset(t, member) / 8;
> +		ptype = btf_type_resolve_ptr(btf_vmlinux, member->type, NULL);
> +		if (ptype == module_type) {
> +			if (*(void **)(udata + moff))
> +				goto reset_unlock;
> +			*(void **)(kdata + moff) = BPF_MODULE_OWNER;
> +			continue;
> +		}
> +
> +		err = st_ops->init_member(t, member, kdata, udata);
> +		if (err < 0)
> +			goto reset_unlock;
> +
> +		/* The ->init_member() has handled this member */
> +		if (err > 0)
> +			continue;
> +
> +		/* If st_ops->init_member does not handle it,
> +		 * we will only handle func ptrs and zero-ed members
> +		 * here.  Reject everything else.
> +		 */
> +
> +		/* All non func ptr member must be 0 */
> +		if (!ptype || !btf_type_is_func_proto(ptype)) {
> +			u32 msize;
> +
> +			mtype = btf_type_by_id(btf_vmlinux, member->type);
> +			mtype = btf_resolve_size(btf_vmlinux, mtype, &msize,
> +						 NULL, NULL);
> +			if (IS_ERR(mtype)) {
> +				err = PTR_ERR(mtype);
> +				goto reset_unlock;
> +			}
> +
> +			if (memchr_inv(udata + moff, 0, msize)) {
> +				err = -EINVAL;
> +				goto reset_unlock;
> +			}
> +
> +			continue;
> +		}
> +
> +		prog_fd = (int)(*(unsigned long *)(udata + moff));
> +		/* Similar check as the attr->attach_prog_fd */
> +		if (!prog_fd)
> +			continue;
> +
> +		prog = bpf_prog_get(prog_fd);
> +		if (IS_ERR(prog)) {
> +			err = PTR_ERR(prog);
> +			goto reset_unlock;
> +		}
> +		st_map->progs[i] = prog;
> +
> +		if (prog->type != BPF_PROG_TYPE_STRUCT_OPS ||
> +		    prog->aux->attach_btf_id != st_ops->type_id ||
> +		    prog->expected_attach_type != i) {
> +			err = -EINVAL;
> +			goto reset_unlock;
> +		}
> +
> +		err = arch_prepare_bpf_trampoline(image,
> +						  st_map->image + PAGE_SIZE,
> +						  &st_ops->func_models[i], 0,
> +						  &prog, 1, NULL, 0, NULL);
> +		if (err < 0)
> +			goto reset_unlock;
> +
> +		*(void **)(kdata + moff) = image;
> +		image += err;
> +
> +		/* put prog_id to udata */
> +		*(unsigned long *)(udata + moff) = prog->aux->id;
> +	}
> +
> +	refcount_set(&kvalue->refcnt, 1);
> +	bpf_map_inc(map);
> +
> +	err = st_ops->reg(kdata);
> +	if (!err) {
> +		/* Pair with smp_load_acquire() during lookup */
> +		smp_store_release(&kvalue->state, BPF_STRUCT_OPS_STATE_INUSE);

Is there a reason using READ_ONCE/WRITE_ONCE pair is not enough?

> +		goto unlock;
> +	}
> +
> +	/* Error during st_ops->reg() */
> +	bpf_map_put(map);
> +
> +reset_unlock:
> +	bpf_struct_ops_map_put_progs(st_map);
> +	memset(uvalue, 0, map->value_size);
> +	memset(kvalue, 0, map->value_size);
> +
> +unlock:
> +	spin_unlock(&st_map->lock);
> +	return err;
> +}
[...]
> +static struct bpf_map *bpf_struct_ops_map_alloc(union bpf_attr *attr)
> +{
> +	const struct bpf_struct_ops *st_ops;
> +	size_t map_total_size, st_map_size;
> +	struct bpf_struct_ops_map *st_map;
> +	const struct btf_type *t, *vt;
> +	struct bpf_map_memory mem;
> +	struct bpf_map *map;
> +	int err;
> +
> +	if (!capable(CAP_SYS_ADMIN))
> +		return ERR_PTR(-EPERM);
> +
> +	st_ops = bpf_struct_ops_find_value(attr->btf_vmlinux_value_type_id);
> +	if (!st_ops)
> +		return ERR_PTR(-ENOTSUPP);
> +
> +	vt = st_ops->value_type;
> +	if (attr->value_size != vt->size)
> +		return ERR_PTR(-EINVAL);
> +
> +	t = st_ops->type;
> +
> +	st_map_size = sizeof(*st_map) +
> +		/* kvalue stores the
> +		 * struct bpf_struct_ops_tcp_congestions_ops
> +		 */
> +		(vt->size - sizeof(struct bpf_struct_ops_value));
> +	map_total_size = st_map_size +
> +		/* uvalue */
> +		sizeof(vt->size) +
> +		/* struct bpf_progs **progs */
> +		 btf_type_vlen(t) * sizeof(struct bpf_prog *);
> +	err = bpf_map_charge_init(&mem, map_total_size);
> +	if (err < 0)
> +		return ERR_PTR(err);
> +
> +	st_map = bpf_map_area_alloc(st_map_size, NUMA_NO_NODE);
> +	if (!st_map) {
> +		bpf_map_charge_finish(&mem);
> +		return ERR_PTR(-ENOMEM);
> +	}
> +	st_map->st_ops = st_ops;
> +	map = &st_map->map;
> +
> +	st_map->uvalue = bpf_map_area_alloc(vt->size, NUMA_NO_NODE);
> +	st_map->progs =
> +		bpf_map_area_alloc(btf_type_vlen(t) * sizeof(struct bpf_prog *),
> +				   NUMA_NO_NODE);
> +	st_map->image = bpf_jit_alloc_exec(PAGE_SIZE);
> +	if (!st_map->uvalue || !st_map->progs || !st_map->image) {
> +		bpf_struct_ops_map_free(map);
> +		bpf_map_charge_finish(&mem);
> +		return ERR_PTR(-ENOMEM);
> +	}
> +
> +	spin_lock_init(&st_map->lock);
> +	set_vm_flush_reset_perms(st_map->image);
> +	set_memory_x((long)st_map->image, 1);

Shouldn't this be using text poke as well once you write the image later on,
otherwise we create yet another instance of W+X memory ... :/

> +	bpf_map_init_from_attr(map, attr);
> +	bpf_map_charge_move(&map->memory, &mem);
> +
> +	return map;
> +}
> +
> +const struct bpf_map_ops bpf_struct_ops_map_ops = {
> +	.map_alloc_check = bpf_struct_ops_map_alloc_check,
> +	.map_alloc = bpf_struct_ops_map_alloc,
> +	.map_free = bpf_struct_ops_map_free,
> +	.map_get_next_key = bpf_struct_ops_map_get_next_key,
> +	.map_lookup_elem = bpf_struct_ops_map_lookup_elem,
> +	.map_delete_elem = bpf_struct_ops_map_delete_elem,
> +	.map_update_elem = bpf_struct_ops_map_update_elem,
> +	.map_seq_show_elem = bpf_struct_ops_map_seq_show_elem,
> +};
[...]
