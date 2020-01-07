Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 33266133523
	for <lists+netdev@lfdr.de>; Tue,  7 Jan 2020 22:44:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727188AbgAGVoq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jan 2020 16:44:46 -0500
Received: from www62.your-server.de ([213.133.104.62]:50098 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726594AbgAGVoq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jan 2020 16:44:46 -0500
Received: from sslproxy05.your-server.de ([78.46.172.2])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1ioweY-0001U0-SD; Tue, 07 Jan 2020 22:44:42 +0100
Received: from [178.197.249.51] (helo=pc-9.home)
        by sslproxy05.your-server.de with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89)
        (envelope-from <daniel@iogearbox.net>)
        id 1ioweY-000Ayn-I5; Tue, 07 Jan 2020 22:44:42 +0100
Subject: Re: [PATCH bpf-next v3 06/11] bpf: Introduce BPF_MAP_TYPE_STRUCT_OPS
To:     Martin Lau <kafai@fb.com>
Cc:     "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        David Miller <davem@davemloft.net>,
        Kernel Team <Kernel-team@fb.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <20191231062037.280596-1-kafai@fb.com>
 <20191231062050.281712-1-kafai@fb.com>
 <4d0aafe9-75c7-43fe-d9eb-62bb2053b53e@iogearbox.net>
 <20200107185533.d64lkoqggrdfehga@kafai-mbp>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <ee7a3631-bb47-3d58-7ad2-431b9af40589@iogearbox.net>
Date:   Tue, 7 Jan 2020 22:44:41 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20200107185533.d64lkoqggrdfehga@kafai-mbp>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.101.4/25687/Tue Jan  7 10:56:22 2020)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/7/20 7:55 PM, Martin Lau wrote:
> On Tue, Jan 07, 2020 at 05:00:37PM +0100, Daniel Borkmann wrote:
>> On 12/31/19 7:20 AM, Martin KaFai Lau wrote:
>> [...]
[...]
>>> +		err = arch_prepare_bpf_trampoline(image,
>>> +						  st_map->image + PAGE_SIZE,
>>> +						  &st_ops->func_models[i], 0,
>>> +						  &prog, 1, NULL, 0, NULL);
>>> +		if (err < 0)
>>> +			goto reset_unlock;
>>> +
>>> +		*(void **)(kdata + moff) = image;
>>> +		image += err;
>>> +
>>> +		/* put prog_id to udata */
>>> +		*(unsigned long *)(udata + moff) = prog->aux->id;
> udata (with all progs' id) will be returned during lookup_elem().
> 
>>> +	}
>>> +
>>> +	refcount_set(&kvalue->refcnt, 1);
>>> +	bpf_map_inc(map);
>>> +
>>> +	err = st_ops->reg(kdata);
>>> +	if (!err) {
>>> +		/* Pair with smp_load_acquire() during lookup */
>>> +		smp_store_release(&kvalue->state, BPF_STRUCT_OPS_STATE_INUSE);
>>
>> Is there a reason using READ_ONCE/WRITE_ONCE pair is not enough?
> The intention is to ensure lookup_elem() can see all the progs' id once
> the state is set to BPF_STRUCT_OPS_STATE_INUSE.
> 
> Is READ_ONCE/WRITE_ONCE enough to do this?

True, given the above udata store, makes sense as-is.

>>> +		goto unlock;
>>> +	}
>>> +
>>> +	/* Error during st_ops->reg() */
>>> +	bpf_map_put(map);
>>> +
>>> +reset_unlock:
>>> +	bpf_struct_ops_map_put_progs(st_map);
>>> +	memset(uvalue, 0, map->value_size);
>>> +	memset(kvalue, 0, map->value_size);
>>> +
>>> +unlock:
>>> +	spin_unlock(&st_map->lock);
>>> +	return err;
>>> +}
>> [...]
>>> +static struct bpf_map *bpf_struct_ops_map_alloc(union bpf_attr *attr)
>>> +{
>>> +	const struct bpf_struct_ops *st_ops;
>>> +	size_t map_total_size, st_map_size;
>>> +	struct bpf_struct_ops_map *st_map;
>>> +	const struct btf_type *t, *vt;
>>> +	struct bpf_map_memory mem;
>>> +	struct bpf_map *map;
>>> +	int err;
>>> +
>>> +	if (!capable(CAP_SYS_ADMIN))
>>> +		return ERR_PTR(-EPERM);
>>> +
>>> +	st_ops = bpf_struct_ops_find_value(attr->btf_vmlinux_value_type_id);
>>> +	if (!st_ops)
>>> +		return ERR_PTR(-ENOTSUPP);
>>> +
>>> +	vt = st_ops->value_type;
>>> +	if (attr->value_size != vt->size)
>>> +		return ERR_PTR(-EINVAL);
>>> +
>>> +	t = st_ops->type;
>>> +
>>> +	st_map_size = sizeof(*st_map) +
>>> +		/* kvalue stores the
>>> +		 * struct bpf_struct_ops_tcp_congestions_ops
>>> +		 */
>>> +		(vt->size - sizeof(struct bpf_struct_ops_value));
>>> +	map_total_size = st_map_size +
>>> +		/* uvalue */
>>> +		sizeof(vt->size) +
>>> +		/* struct bpf_progs **progs */
>>> +		 btf_type_vlen(t) * sizeof(struct bpf_prog *);
>>> +	err = bpf_map_charge_init(&mem, map_total_size);
>>> +	if (err < 0)
>>> +		return ERR_PTR(err);
>>> +
>>> +	st_map = bpf_map_area_alloc(st_map_size, NUMA_NO_NODE);
>>> +	if (!st_map) {
>>> +		bpf_map_charge_finish(&mem);
>>> +		return ERR_PTR(-ENOMEM);
>>> +	}
>>> +	st_map->st_ops = st_ops;
>>> +	map = &st_map->map;
>>> +
>>> +	st_map->uvalue = bpf_map_area_alloc(vt->size, NUMA_NO_NODE);
>>> +	st_map->progs =
>>> +		bpf_map_area_alloc(btf_type_vlen(t) * sizeof(struct bpf_prog *),
>>> +				   NUMA_NO_NODE);
>>> +	st_map->image = bpf_jit_alloc_exec(PAGE_SIZE);
>>> +	if (!st_map->uvalue || !st_map->progs || !st_map->image) {
>>> +		bpf_struct_ops_map_free(map);
>>> +		bpf_map_charge_finish(&mem);
>>> +		return ERR_PTR(-ENOMEM);
>>> +	}
>>> +
>>> +	spin_lock_init(&st_map->lock);
>>> +	set_vm_flush_reset_perms(st_map->image);
>>> +	set_memory_x((long)st_map->image, 1);
>>
>> Shouldn't this be using text poke as well once you write the image later on,
>> otherwise we create yet another instance of W+X memory ... :/
> Once image is written in update_elem(), it will never be changed.
> I can set it to ro after it is written.

And we could also move the set_memory_x() to that point once image is written and
marked read-only; mid term text poke interface to avoid all this.

Other than that nothing obvious stands out from reviewing patch 1-8, so no objections
from my side.

>>> +	bpf_map_init_from_attr(map, attr);
>>> +	bpf_map_charge_move(&map->memory, &mem);
>>> +
>>> +	return map;
>>> +}
>>> +
>>> +const struct bpf_map_ops bpf_struct_ops_map_ops = {
>>> +	.map_alloc_check = bpf_struct_ops_map_alloc_check,
>>> +	.map_alloc = bpf_struct_ops_map_alloc,
>>> +	.map_free = bpf_struct_ops_map_free,
>>> +	.map_get_next_key = bpf_struct_ops_map_get_next_key,
>>> +	.map_lookup_elem = bpf_struct_ops_map_lookup_elem,
>>> +	.map_delete_elem = bpf_struct_ops_map_delete_elem,
>>> +	.map_update_elem = bpf_struct_ops_map_update_elem,
>>> +	.map_seq_show_elem = bpf_struct_ops_map_seq_show_elem,
>>> +};
>> [...]

