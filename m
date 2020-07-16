Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D5956222C9E
	for <lists+netdev@lfdr.de>; Thu, 16 Jul 2020 22:19:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729603AbgGPUTE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jul 2020 16:19:04 -0400
Received: from www62.your-server.de ([213.133.104.62]:49886 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728788AbgGPUTD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Jul 2020 16:19:03 -0400
Received: from sslproxy02.your-server.de ([78.47.166.47])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1jwALM-0008Ac-K3; Thu, 16 Jul 2020 22:19:00 +0200
Received: from [178.196.57.75] (helo=pc-9.home)
        by sslproxy02.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1jwALM-000P4S-EH; Thu, 16 Jul 2020 22:19:00 +0200
Subject: Re: [PATCH bpf-next v3 4/4] bpf: try to use existing cgroup storage
 in bpf_prog_test_run_skb
To:     Dmitry Yakunin <zeil@yandex-team.ru>, alexei.starovoitov@gmail.com,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     sdf@google.com
References: <20200715195132.4286-1-zeil@yandex-team.ru>
 <20200715195132.4286-5-zeil@yandex-team.ru>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <0308c9ab-04aa-f367-14e9-8289f30e7fcf@iogearbox.net>
Date:   Thu, 16 Jul 2020 22:18:59 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20200715195132.4286-5-zeil@yandex-team.ru>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.3/25875/Thu Jul 16 16:46:30 2020)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/15/20 9:51 PM, Dmitry Yakunin wrote:
> Now we cannot check results in cgroup storage after running
> BPF_PROG_TEST_RUN command because it allocates dummy cgroup storage
> during test. This patch implements simple logic for searching already
> allocated cgroup storage through iterating effective programs of current
> cgroup and finding the first match. If match is not found fallback to
> temporary storage is happened.
> 
> v2:
>    - fix build without CONFIG_CGROUP_BPF (kernel test robot <lkp@intel.com>)
> 
> Signed-off-by: Dmitry Yakunin <zeil@yandex-team.ru>
> ---
>   net/bpf/test_run.c                                 | 64 +++++++++++++++++-
>   .../selftests/bpf/prog_tests/cgroup_skb_prog_run.c | 78 ++++++++++++++++++++++
>   2 files changed, 139 insertions(+), 3 deletions(-)
>   create mode 100644 tools/testing/selftests/bpf/prog_tests/cgroup_skb_prog_run.c
> 
> diff --git a/net/bpf/test_run.c b/net/bpf/test_run.c
> index 050390d..7382b22 100644
> --- a/net/bpf/test_run.c
> +++ b/net/bpf/test_run.c
> @@ -15,15 +15,67 @@
>   #define CREATE_TRACE_POINTS
>   #include <trace/events/bpf_test_run.h>
>   
> +#ifdef CONFIG_CGROUP_BPF
> +
> +static struct bpf_prog_array_item *bpf_prog_find_active(struct bpf_prog *prog,
> +							struct bpf_prog_array *effective)
> +{
> +	struct bpf_prog_array_item *item;
> +	struct bpf_prog_array *array;
> +	struct bpf_prog *p;
> +
> +	array = rcu_dereference(effective);
> +	if (!array)
> +		return NULL;
> +
> +	item = &array->items[0];
> +	while ((p = READ_ONCE(item->prog))) {
> +		if (p == prog)
> +			return item;
> +		item++;
> +	}
> +
> +	return NULL;
> +}
> +
> +static struct bpf_cgroup_storage **bpf_prog_find_active_storage(struct bpf_prog *prog)
> +{
> +	struct bpf_prog_array_item *item;
> +	struct cgroup *cgrp;
> +
> +	if (prog->type != BPF_PROG_TYPE_CGROUP_SKB)
> +		return NULL;
> +
> +	cgrp = task_dfl_cgroup(current);
> +
> +	item = bpf_prog_find_active(prog,
> +				    cgrp->bpf.effective[BPF_CGROUP_INET_INGRESS]);
> +	if (!item)
> +		item = bpf_prog_find_active(prog,
> +					    cgrp->bpf.effective[BPF_CGROUP_INET_EGRESS]);
> +
> +	return item ? item->cgroup_storage : NULL;
> +}
> +
> +#else
> +
> +static struct bpf_cgroup_storage **bpf_prog_find_active_storage(struct bpf_prog *prog)
> +{
> +	return NULL;
> +}
> +
> +#endif
> +
>   static int bpf_test_run(struct bpf_prog *prog, void *ctx, u32 repeat,
>   			u32 *retval, u32 *time, bool xdp)
>   {
> -	struct bpf_cgroup_storage *storage[MAX_BPF_CGROUP_STORAGE_TYPE] = { NULL };
> +	struct bpf_cgroup_storage *dummy_storage[MAX_BPF_CGROUP_STORAGE_TYPE] = { NULL };
> +	struct bpf_cgroup_storage **storage = dummy_storage;
>   	u64 time_start, time_spent = 0;
>   	int ret = 0;
>   	u32 i;
>   
> -	ret = bpf_cgroup_storages_alloc(storage, prog);
> +	ret = bpf_cgroup_storages_alloc(dummy_storage, prog);
>   	if (ret)
>   		return ret;
>   
> @@ -31,6 +83,9 @@ static int bpf_test_run(struct bpf_prog *prog, void *ctx, u32 repeat,
>   		repeat = 1;
>   
>   	rcu_read_lock();
> +	storage = bpf_prog_find_active_storage(prog);
> +	if (!storage)
> +		storage = dummy_storage;
>   	migrate_disable();
>   	time_start = ktime_get_ns();
>   	for (i = 0; i < repeat; i++) {
> @@ -54,6 +109,9 @@ static int bpf_test_run(struct bpf_prog *prog, void *ctx, u32 repeat,
>   			cond_resched();
>   
>   			rcu_read_lock();
> +			storage = bpf_prog_find_active_storage(prog);
> +			if (!storage)
> +				storage = dummy_storage;
>   			migrate_disable();
>   			time_start = ktime_get_ns();
>   		}
> @@ -65,7 +123,7 @@ static int bpf_test_run(struct bpf_prog *prog, void *ctx, u32 repeat,
>   	do_div(time_spent, repeat);
>   	*time = time_spent > U32_MAX ? U32_MAX : (u32)time_spent;
>   
> -	bpf_cgroup_storages_free(storage);
> +	bpf_cgroup_storages_free(dummy_storage);
>   
>   	return ret;
>   }
> diff --git a/tools/testing/selftests/bpf/prog_tests/cgroup_skb_prog_run.c b/tools/testing/selftests/bpf/prog_tests/cgroup_skb_prog_run.c
> new file mode 100644
> index 0000000..12ca881
> --- /dev/null
> +++ b/tools/testing/selftests/bpf/prog_tests/cgroup_skb_prog_run.c
> @@ -0,0 +1,78 @@
> +// SPDX-License-Identifier: GPL-2.0
> +
> +#include <test_progs.h>
> +
> +#include "cgroup_helpers.h"
> +#include "network_helpers.h"
> +
> +static char bpf_log_buf[BPF_LOG_BUF_SIZE];
> +
> +void test_cgroup_skb_prog_run(void)
> +{
> +	struct bpf_insn prog[] = {
> +		BPF_LD_MAP_FD(BPF_REG_1, 0), /* map fd */
> +		BPF_MOV64_IMM(BPF_REG_2, 0), /* flags, not used */
> +		BPF_RAW_INSN(BPF_JMP | BPF_CALL, 0, 0, 0, BPF_FUNC_get_local_storage),
> +		BPF_MOV64_IMM(BPF_REG_1, 1),
> +		BPF_RAW_INSN(BPF_STX | BPF_XADD | BPF_W, BPF_REG_0, BPF_REG_1, 0, 0),
> +
> +		BPF_MOV64_IMM(BPF_REG_0, 1), /* r0 = 1 */
> +		BPF_EXIT_INSN(),
> +	};
> +	size_t insns_cnt = sizeof(prog) / sizeof(struct bpf_insn);
> +	int storage_fd = -1, prog_fd = -1, cg_fd = -1;
> +	struct bpf_cgroup_storage_key key;
> +	__u32 duration, retval, size;
> +	char buf[128];
> +	__u64 value;
> +	int err;
> +
> +	storage_fd = bpf_create_map(BPF_MAP_TYPE_CGROUP_STORAGE,
> +				    sizeof(struct bpf_cgroup_storage_key),
> +				    8, 0, 0);
> +	if (CHECK(storage_fd < 0, "create_map", "%s\n", strerror(errno)))
> +		goto out;
> +
> +	prog[0].imm = storage_fd;
> +
> +	prog_fd = bpf_load_program(BPF_PROG_TYPE_CGROUP_SKB,
> +				   prog, insns_cnt, "GPL", 0,
> +				   bpf_log_buf, BPF_LOG_BUF_SIZE);
> +	if (CHECK(prog_fd < 0, "prog_load",
> +		  "verifier output:\n%s\n-------\n", bpf_log_buf))
> +		goto out;
> +
> +	if (CHECK_FAIL(setup_cgroup_environment()))
> +		goto out;
> +
> +	cg_fd = create_and_get_cgroup("/cg");
> +	if (CHECK_FAIL(cg_fd < 0))
> +		goto out;
> +
> +	if (CHECK_FAIL(join_cgroup("/cg")))
> +		goto out;
> +
> +	if (CHECK(bpf_prog_attach(prog_fd, cg_fd, BPF_CGROUP_INET_EGRESS, 0),
> +		  "prog_attach", "%s\n", strerror(errno)))
> +		goto out;
> +
> +	err = bpf_prog_test_run(prog_fd, NUM_ITER, &pkt_v4, sizeof(pkt_v4),
> +				buf, &size, &retval, &duration);

Hm, I think this approach is rather suboptimal, meaning, you need to load & even
actively attach the test program also to the cgroup aside from pushing this via
BPF prog test infra. So any other potential background traffic egressing from the
application will also go through the test program via BPF_CGROUP_INET_EGRESS.
Can't we instead extend the test infra to prepopulate and fetch the content from
the temp storage instead so this does not have any other side-effects?

> +	CHECK(err || retval != 1, "prog_test_run",
> +	      "err %d errno %d retval %d\n", err, errno, retval);
> +
> +	/* check that cgroup storage results are available after test run */
> +
> +	err = bpf_map_get_next_key(storage_fd, NULL, &key);
> +	CHECK(err, "map_get_next_key", "%s\n", strerror(errno));
> +
> +	err = bpf_map_lookup_elem(storage_fd, &key, &value);
> +	CHECK(err || value != NUM_ITER,
> +	      "map_lookup_elem",
> +	      "err %d errno %d cnt %lld(%d)\n", err, errno, value, NUM_ITER);
> +out:
> +	close(storage_fd);
> +	close(prog_fd);
> +	close(cg_fd);
> +	cleanup_cgroup_environment();
> +}
> 

