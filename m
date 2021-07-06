Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F3EE3BD923
	for <lists+netdev@lfdr.de>; Tue,  6 Jul 2021 16:55:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232295AbhGFO6I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Jul 2021 10:58:08 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:6429 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231460AbhGFO6B (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Jul 2021 10:58:01 -0400
Received: from dggeme756-chm.china.huawei.com (unknown [172.30.72.57])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4GK3vQ6Qspz76rF;
        Tue,  6 Jul 2021 21:54:26 +0800 (CST)
Received: from [10.174.178.171] (10.174.178.171) by
 dggeme756-chm.china.huawei.com (10.3.19.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Tue, 6 Jul 2021 21:57:53 +0800
Subject: Re: [PATCH v4 bpf-next 1/9] bpf: Introduce bpf timers.
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        <davem@davemloft.net>
CC:     <daniel@iogearbox.net>, <andrii@kernel.org>,
        <netdev@vger.kernel.org>, <bpf@vger.kernel.org>,
        <kernel-team@fb.com>
References: <20210701192044.78034-1-alexei.starovoitov@gmail.com>
 <20210701192044.78034-2-alexei.starovoitov@gmail.com>
From:   "luwei (O)" <luwei32@huawei.com>
Message-ID: <bcdccd37-6372-859f-824e-c96250361904@huawei.com>
Date:   Tue, 6 Jul 2021 21:57:52 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210701192044.78034-2-alexei.starovoitov@gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.178.171]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 dggeme756-chm.china.huawei.com (10.3.19.102)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


在 2021/7/2 3:20 AM, Alexei Starovoitov 写道:
> From: Alexei Starovoitov <ast@kernel.org>
>
> Introduce 'struct bpf_timer { __u64 :64; __u64 :64; };' that can be embedded
> in hash/array/lru maps as a regular field and helpers to operate on it:
>
> // Initialize the timer.
> // First 4 bits of 'flags' specify clockid.
> // Only CLOCK_MONOTONIC, CLOCK_REALTIME, CLOCK_BOOTTIME are allowed.
> long bpf_timer_init(struct bpf_timer *timer, struct bpf_map *map, int flags);
>
> // Configure the timer to call 'callback_fn' static function.
> long bpf_timer_set_callback(struct bpf_timer *timer, void *callback_fn);
>
> // Arm the timer to expire 'nsec' nanoseconds from the current time.
> long bpf_timer_start(struct bpf_timer *timer, u64 nsec, u64 flags);
>
> // Cancel the timer and wait for callback_fn to finish if it was running.
> long bpf_timer_cancel(struct bpf_timer *timer);
>
[...]
> +static enum hrtimer_restart bpf_timer_cb(struct hrtimer *hrtimer)
> +{
> +	struct bpf_hrtimer *t = container_of(hrtimer, struct bpf_hrtimer, timer);
> +	struct bpf_map *map = t->map;
> +	void *value = t->value;
> +	struct bpf_timer_kern *timer = value + map->timer_off;
> +	struct bpf_prog *prog;
> +	void *callback_fn;
> +	void *key;
> +	u32 idx;
> +	int ret;
> +
> +	/* The triple underscore bpf_spin_lock is a direct call
> +	 * to BPF_CALL_1(bpf_spin_lock) which does irqsave.
> +	 */
> +	____bpf_spin_lock(&timer->lock);
> +	/* callback_fn and prog need to match. They're updated together
> +	 * and have to be read under lock.
> +	 */
> +	prog = t->prog;
> +	callback_fn = t->callback_fn;
> +
> +	/* wrap bpf subprog invocation with prog->refcnt++ and -- to make
> +	 * sure that refcnt doesn't become zero when subprog is executing.
> +	 * Do it under lock to make sure that bpf_timer_start doesn't drop
> +	 * prev prog refcnt to zero before timer_cb has a chance to bump it.
> +	 */
> +	bpf_prog_inc(prog);
> +	____bpf_spin_unlock(&timer->lock);
> +
> +	/* bpf_timer_cb() runs in hrtimer_run_softirq. It doesn't migrate and
> +	 * cannot be preempted by another bpf_timer_cb() on the same cpu.
> +	 * Remember the timer this callback is servicing to prevent
> +	 * deadlock if callback_fn() calls bpf_timer_cancel() on the same timer.
> +	 */
> +	this_cpu_write(hrtimer_running, t);
> +	if (map->map_type == BPF_MAP_TYPE_ARRAY) {
> +		struct bpf_array *array = container_of(map, struct bpf_array, map);
> +
> +		/* compute the key */
> +		idx = ((char *)value - array->value) / array->elem_size;
> +		key = &idx;
> +	} else { /* hash or lru */
> +		key = value - round_up(map->key_size, 8);
> +	}
> +
> +	ret = BPF_CAST_CALL(callback_fn)((u64)(long)map,
> +					 (u64)(long)key,
> +					 (u64)(long)value, 0, 0);
> +	WARN_ON(ret != 0); /* Next patch moves this check into the verifier */
> +	bpf_prog_put(prog);
> +
> +	this_cpu_write(hrtimer_running, NULL);
> +	return HRTIMER_NORESTART;
> +}
> +
Your patch is awesome, and I tried your example and it works, my 
call_back() is called after a certained time.  But  I am confued that 
the bpf_timer_cb() function only returns HRTIMER_NORESTART,

how to trigger a periodic task, that means I want to call my call_back() 
periodically, not just for one time ?

[...]

-- 
Best Regards,
Lu Wei

