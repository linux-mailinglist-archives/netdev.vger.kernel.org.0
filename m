Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D0CF7222C1F
	for <lists+netdev@lfdr.de>; Thu, 16 Jul 2020 21:46:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729592AbgGPTqH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jul 2020 15:46:07 -0400
Received: from www62.your-server.de ([213.133.104.62]:45016 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728788AbgGPTqD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Jul 2020 15:46:03 -0400
Received: from sslproxy02.your-server.de ([78.47.166.47])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1jw9pR-0004ec-AK; Thu, 16 Jul 2020 21:46:01 +0200
Received: from [178.196.57.75] (helo=pc-9.home)
        by sslproxy02.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1jw9pR-000Q9W-4z; Thu, 16 Jul 2020 21:46:01 +0200
Subject: Re: [PATCH bpf-next v3 3/4] bpf: export some cgroup storages
 allocation helpers for reusing
To:     Dmitry Yakunin <zeil@yandex-team.ru>, alexei.starovoitov@gmail.com,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     sdf@google.com
References: <20200715195132.4286-1-zeil@yandex-team.ru>
 <20200715195132.4286-4-zeil@yandex-team.ru>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <ab6460c2-1c01-3471-4368-1ddb19fa3695@iogearbox.net>
Date:   Thu, 16 Jul 2020 21:46:00 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20200715195132.4286-4-zeil@yandex-team.ru>
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
> This patch exports bpf_cgroup_storages_alloc and bpf_cgroup_storages_free
> helpers to the header file and reuses them in bpf_test_run.
> 
> v2:
>    - fix build without CONFIG_CGROUP_BPF (kernel test robot <lkp@intel.com>)
> 
> Signed-off-by: Dmitry Yakunin <zeil@yandex-team.ru>
> ---
>   include/linux/bpf-cgroup.h | 36 ++++++++++++++++++++++++++++++++++++
>   kernel/bpf/cgroup.c        | 25 -------------------------
>   net/bpf/test_run.c         | 16 ++++------------
>   3 files changed, 40 insertions(+), 37 deletions(-)
> 
> diff --git a/include/linux/bpf-cgroup.h b/include/linux/bpf-cgroup.h
> index 2c6f266..5c10fe6 100644
> --- a/include/linux/bpf-cgroup.h
> +++ b/include/linux/bpf-cgroup.h
> @@ -175,6 +175,33 @@ int bpf_percpu_cgroup_storage_copy(struct bpf_map *map, void *key, void *value);
>   int bpf_percpu_cgroup_storage_update(struct bpf_map *map, void *key,
>   				     void *value, u64 flags);
>   
> +static inline void bpf_cgroup_storages_free(struct bpf_cgroup_storage
> +					    *storage[MAX_BPF_CGROUP_STORAGE_TYPE])
> +{
> +	enum bpf_cgroup_storage_type stype;
> +
> +	for_each_cgroup_storage_type(stype)
> +		bpf_cgroup_storage_free(storage[stype]);
> +}
> +
> +static inline int bpf_cgroup_storages_alloc(struct bpf_cgroup_storage
> +					    *storage[MAX_BPF_CGROUP_STORAGE_TYPE],
> +					    struct bpf_prog *prog)
> +{
> +	enum bpf_cgroup_storage_type stype;
> +
> +	for_each_cgroup_storage_type(stype) {
> +		storage[stype] = bpf_cgroup_storage_alloc(prog, stype);
> +		if (IS_ERR(storage[stype])) {
> +			storage[stype] = NULL;
> +			bpf_cgroup_storages_free(storage);
> +			return -ENOMEM;
> +		}
> +	}
> +
> +	return 0;
> +}
> +
>   /* Wrappers for __cgroup_bpf_run_filter_skb() guarded by cgroup_bpf_enabled. */
>   #define BPF_CGROUP_RUN_PROG_INET_INGRESS(sk, skb)			      \
>   ({									      \
> @@ -398,6 +425,15 @@ static inline int bpf_percpu_cgroup_storage_update(struct bpf_map *map,
>   	return 0;
>   }
>   
> +static inline void bpf_cgroup_storages_free(
> +	struct bpf_cgroup_storage *storage[MAX_BPF_CGROUP_STORAGE_TYPE]) {}
> +
> +static inline int bpf_cgroup_storages_alloc(
> +	struct bpf_cgroup_storage *storage[MAX_BPF_CGROUP_STORAGE_TYPE],
> +	struct bpf_prog *prog) {
> +	return 0;
> +}
> +
>   #define cgroup_bpf_enabled (0)
>   #define BPF_CGROUP_RUN_SA_PROG_LOCK(sk, uaddr, type, t_ctx) ({ 0; })
>   #define BPF_CGROUP_PRE_CONNECT_ENABLED(sk) (0)
> diff --git a/kernel/bpf/cgroup.c b/kernel/bpf/cgroup.c
> index ac53102..e4c2792 100644
> --- a/kernel/bpf/cgroup.c
> +++ b/kernel/bpf/cgroup.c
> @@ -28,31 +28,6 @@ void cgroup_bpf_offline(struct cgroup *cgrp)
>   	percpu_ref_kill(&cgrp->bpf.refcnt);
>   }
>   
> -static void bpf_cgroup_storages_free(struct bpf_cgroup_storage *storages[])
> -{
> -	enum bpf_cgroup_storage_type stype;
> -
> -	for_each_cgroup_storage_type(stype)
> -		bpf_cgroup_storage_free(storages[stype]);
> -}
> -
> -static int bpf_cgroup_storages_alloc(struct bpf_cgroup_storage *storages[],
> -				     struct bpf_prog *prog)
> -{
> -	enum bpf_cgroup_storage_type stype;
> -
> -	for_each_cgroup_storage_type(stype) {
> -		storages[stype] = bpf_cgroup_storage_alloc(prog, stype);
> -		if (IS_ERR(storages[stype])) {
> -			storages[stype] = NULL;
> -			bpf_cgroup_storages_free(storages);
> -			return -ENOMEM;
> -		}
> -	}
> -
> -	return 0;
> -}
> -

nit: Can't we just export them from here instead of inlining? Given this is for
test_run.c anyway, I don't think it's worth the extra churn.

>   static void bpf_cgroup_storages_assign(struct bpf_cgroup_storage *dst[],
>   				       struct bpf_cgroup_storage *src[])
>   {
> diff --git a/net/bpf/test_run.c b/net/bpf/test_run.c
> index 0e92973..050390d 100644
> --- a/net/bpf/test_run.c
> +++ b/net/bpf/test_run.c
> @@ -19,20 +19,13 @@ static int bpf_test_run(struct bpf_prog *prog, void *ctx, u32 repeat,
>   			u32 *retval, u32 *time, bool xdp)
>   {
>   	struct bpf_cgroup_storage *storage[MAX_BPF_CGROUP_STORAGE_TYPE] = { NULL };
> -	enum bpf_cgroup_storage_type stype;
>   	u64 time_start, time_spent = 0;
>   	int ret = 0;
>   	u32 i;
>   
> -	for_each_cgroup_storage_type(stype) {
> -		storage[stype] = bpf_cgroup_storage_alloc(prog, stype);
> -		if (IS_ERR(storage[stype])) {
> -			storage[stype] = NULL;
> -			for_each_cgroup_storage_type(stype)
> -				bpf_cgroup_storage_free(storage[stype]);
> -			return -ENOMEM;
> -		}
> -	}
> +	ret = bpf_cgroup_storages_alloc(storage, prog);
> +	if (ret)
> +		return ret;
>   
>   	if (!repeat)
>   		repeat = 1;
> @@ -72,8 +65,7 @@ static int bpf_test_run(struct bpf_prog *prog, void *ctx, u32 repeat,
>   	do_div(time_spent, repeat);
>   	*time = time_spent > U32_MAX ? U32_MAX : (u32)time_spent;
>   
> -	for_each_cgroup_storage_type(stype)
> -		bpf_cgroup_storage_free(storage[stype]);
> +	bpf_cgroup_storages_free(storage);
>   
>   	return ret;
>   }
> 

