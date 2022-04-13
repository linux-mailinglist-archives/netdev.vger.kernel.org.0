Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 851F94FF902
	for <lists+netdev@lfdr.de>; Wed, 13 Apr 2022 16:33:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236136AbiDMOfj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Apr 2022 10:35:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233994AbiDMOfi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Apr 2022 10:35:38 -0400
Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BEF7556C00;
        Wed, 13 Apr 2022 07:33:16 -0700 (PDT)
Received: from dggpeml500025.china.huawei.com (unknown [172.30.72.57])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4KdlMW1PQDzCqwJ;
        Wed, 13 Apr 2022 22:28:55 +0800 (CST)
Received: from [10.174.176.117] (10.174.176.117) by
 dggpeml500025.china.huawei.com (7.185.36.35) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Wed, 13 Apr 2022 22:33:12 +0800
Subject: Re: [PATCH] bpf/benchs: fix error check return value of
 bpf_program__attach()
To:     <cgel.zte@gmail.com>, <shuah@kernel.org>, <ast@kernel.org>,
        <daniel@iogearbox.net>
CC:     <andrii@kernel.org>, <kafai@fb.com>, <songliubraving@fb.com>,
        <yhs@fb.com>, <john.fastabend@gmail.com>, <kpsingh@kernel.org>,
        <joannekoong@fb.com>, <lv.ruyi@zte.com.cn>, <toke@redhat.com>,
        <linux-kselftest@vger.kernel.org>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Zeal Robot <zealci@zte.com.cn>
References: <20220413093123.2538001-1-lv.ruyi@zte.com.cn>
From:   Hou Tao <houtao1@huawei.com>
Message-ID: <3dab1e4b-2317-4730-f699-627583ff759d@huawei.com>
Date:   Wed, 13 Apr 2022 22:33:12 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20220413093123.2538001-1-lv.ruyi@zte.com.cn>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Originating-IP: [10.174.176.117]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 dggpeml500025.china.huawei.com (7.185.36.35)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-5.5 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On 4/13/2022 5:31 PM, cgel.zte@gmail.com wrote:
> From: Lv Ruyi <lv.ruyi@zte.com.cn>
>
> bpf_program__attach() returns error ptr when it fails, so we should use
> IS_ERR() to check it in error handling path. The patch fix all the same
> problems in the bpf/benchs/*.
The fix is unnecessary. Because libbpf has been setup as  LIBBPF_STRICT_ALL mode
in setup_libbpf() of bench.c, so when bpf_program__attach() fails, it will
return NULL instead of ERR_PTR(err).

>
> Reported-by: Zeal Robot <zealci@zte.com.cn>
> Signed-off-by: Lv Ruyi <lv.ruyi@zte.com.cn>
> ---
>  .../selftests/bpf/benchs/bench_bloom_filter_map.c      | 10 +++++-----
>  tools/testing/selftests/bpf/benchs/bench_bpf_loop.c    |  2 +-
>  tools/testing/selftests/bpf/benchs/bench_rename.c      |  2 +-
>  tools/testing/selftests/bpf/benchs/bench_ringbufs.c    |  6 +++---
>  tools/testing/selftests/bpf/benchs/bench_strncmp.c     |  2 +-
>  tools/testing/selftests/bpf/benchs/bench_trigger.c     |  2 +-
>  6 files changed, 12 insertions(+), 12 deletions(-)
>
> diff --git a/tools/testing/selftests/bpf/benchs/bench_bloom_filter_map.c b/tools/testing/selftests/bpf/benchs/bench_bloom_filter_map.c
> index 5bcb8a8cdeb2..fd1be1042516 100644
> --- a/tools/testing/selftests/bpf/benchs/bench_bloom_filter_map.c
> +++ b/tools/testing/selftests/bpf/benchs/bench_bloom_filter_map.c
> @@ -309,7 +309,7 @@ static void bloom_lookup_setup(void)
>  	populate_maps();
>  
>  	link = bpf_program__attach(ctx.skel->progs.bloom_lookup);
> -	if (!link) {
> +	if (IS_ERR(link)) {
>  		fprintf(stderr, "failed to attach program!\n");
>  		exit(1);
>  	}
> @@ -326,7 +326,7 @@ static void bloom_update_setup(void)
>  	populate_maps();
>  
>  	link = bpf_program__attach(ctx.skel->progs.bloom_update);
> -	if (!link) {
> +	if (IS_ERR(link)) {
>  		fprintf(stderr, "failed to attach program!\n");
>  		exit(1);
>  	}
> @@ -345,7 +345,7 @@ static void false_positive_setup(void)
>  	populate_maps();
>  
>  	link = bpf_program__attach(ctx.skel->progs.bloom_hashmap_lookup);
> -	if (!link) {
> +	if (IS_ERR(link)) {
>  		fprintf(stderr, "failed to attach program!\n");
>  		exit(1);
>  	}
> @@ -363,7 +363,7 @@ static void hashmap_with_bloom_setup(void)
>  	populate_maps();
>  
>  	link = bpf_program__attach(ctx.skel->progs.bloom_hashmap_lookup);
> -	if (!link) {
> +	if (IS_ERR(link)) {
>  		fprintf(stderr, "failed to attach program!\n");
>  		exit(1);
>  	}
> @@ -380,7 +380,7 @@ static void hashmap_no_bloom_setup(void)
>  	populate_maps();
>  
>  	link = bpf_program__attach(ctx.skel->progs.bloom_hashmap_lookup);
> -	if (!link) {
> +	if (IS_ERR(link)) {
>  		fprintf(stderr, "failed to attach program!\n");
>  		exit(1);
>  	}
> diff --git a/tools/testing/selftests/bpf/benchs/bench_bpf_loop.c b/tools/testing/selftests/bpf/benchs/bench_bpf_loop.c
> index d0a6572bfab6..8dbdc28d26c8 100644
> --- a/tools/testing/selftests/bpf/benchs/bench_bpf_loop.c
> +++ b/tools/testing/selftests/bpf/benchs/bench_bpf_loop.c
> @@ -85,7 +85,7 @@ static void setup(void)
>  	}
>  
>  	link = bpf_program__attach(ctx.skel->progs.benchmark);
> -	if (!link) {
> +	if (IS_ERR(link)) {
>  		fprintf(stderr, "failed to attach program!\n");
>  		exit(1);
>  	}
> diff --git a/tools/testing/selftests/bpf/benchs/bench_rename.c b/tools/testing/selftests/bpf/benchs/bench_rename.c
> index 3c203b6d6a6e..66d63b92a28a 100644
> --- a/tools/testing/selftests/bpf/benchs/bench_rename.c
> +++ b/tools/testing/selftests/bpf/benchs/bench_rename.c
> @@ -65,7 +65,7 @@ static void attach_bpf(struct bpf_program *prog)
>  	struct bpf_link *link;
>  
>  	link = bpf_program__attach(prog);
> -	if (!link) {
> +	if (IS_ERR(link)) {
>  		fprintf(stderr, "failed to attach program!\n");
>  		exit(1);
>  	}
> diff --git a/tools/testing/selftests/bpf/benchs/bench_ringbufs.c b/tools/testing/selftests/bpf/benchs/bench_ringbufs.c
> index c2554f9695ff..fff24ca82dc0 100644
> --- a/tools/testing/selftests/bpf/benchs/bench_ringbufs.c
> +++ b/tools/testing/selftests/bpf/benchs/bench_ringbufs.c
> @@ -181,7 +181,7 @@ static void ringbuf_libbpf_setup(void)
>  	}
>  
>  	link = bpf_program__attach(ctx->skel->progs.bench_ringbuf);
> -	if (!link) {
> +	if (IS_ERR(link)) {
>  		fprintf(stderr, "failed to attach program!\n");
>  		exit(1);
>  	}
> @@ -271,7 +271,7 @@ static void ringbuf_custom_setup(void)
>  	}
>  
>  	link = bpf_program__attach(ctx->skel->progs.bench_ringbuf);
> -	if (!link) {
> +	if (IS_ERR(link)) {
>  		fprintf(stderr, "failed to attach program\n");
>  		exit(1);
>  	}
> @@ -426,7 +426,7 @@ static void perfbuf_libbpf_setup(void)
>  	}
>  
>  	link = bpf_program__attach(ctx->skel->progs.bench_perfbuf);
> -	if (!link) {
> +	if (IS_ERR(link)) {
>  		fprintf(stderr, "failed to attach program\n");
>  		exit(1);
>  	}
> diff --git a/tools/testing/selftests/bpf/benchs/bench_strncmp.c b/tools/testing/selftests/bpf/benchs/bench_strncmp.c
> index 494b591c0289..dcb9ce5ffcb0 100644
> --- a/tools/testing/selftests/bpf/benchs/bench_strncmp.c
> +++ b/tools/testing/selftests/bpf/benchs/bench_strncmp.c
> @@ -103,7 +103,7 @@ static void strncmp_attach_prog(struct bpf_program *prog)
>  	struct bpf_link *link;
>  
>  	link = bpf_program__attach(prog);
> -	if (!link) {
> +	if (IS_ERR(link)) {
>  		fprintf(stderr, "failed to attach program!\n");
>  		exit(1);
>  	}
> diff --git a/tools/testing/selftests/bpf/benchs/bench_trigger.c b/tools/testing/selftests/bpf/benchs/bench_trigger.c
> index 0c481de2833d..bda930a8153c 100644
> --- a/tools/testing/selftests/bpf/benchs/bench_trigger.c
> +++ b/tools/testing/selftests/bpf/benchs/bench_trigger.c
> @@ -61,7 +61,7 @@ static void attach_bpf(struct bpf_program *prog)
>  	struct bpf_link *link;
>  
>  	link = bpf_program__attach(prog);
> -	if (!link) {
> +	if (IS_ERR(link)) {
>  		fprintf(stderr, "failed to attach program!\n");
>  		exit(1);
>  	}

