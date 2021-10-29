Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 46D0643FB1C
	for <lists+netdev@lfdr.de>; Fri, 29 Oct 2021 12:55:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231815AbhJ2K6E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Oct 2021 06:58:04 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:30879 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231749AbhJ2K6D (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Oct 2021 06:58:03 -0400
Received: from dggemv711-chm.china.huawei.com (unknown [172.30.72.57])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4HgfNW49jBzbmhX;
        Fri, 29 Oct 2021 18:50:51 +0800 (CST)
Received: from dggpeml500025.china.huawei.com (7.185.36.35) by
 dggemv711-chm.china.huawei.com (10.1.198.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.15; Fri, 29 Oct 2021 18:55:32 +0800
Received: from [10.174.176.117] (10.174.176.117) by
 dggpeml500025.china.huawei.com (7.185.36.35) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.15; Fri, 29 Oct 2021 18:55:31 +0800
Subject: Re: [PATCH bpf-next v4 0/4] introduce dummy BPF STRUCT_OPS
To:     Alexei Starovoitov <ast@kernel.org>
CC:     Martin KaFai Lau <kafai@fb.com>, Yonghong Song <yhs@fb.com>,
        "Daniel Borkmann" <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>
References: <20211025064025.2567443-1-houtao1@huawei.com>
From:   Hou Tao <houtao1@huawei.com>
Message-ID: <d89d987d-18e1-cd2a-0f29-efd2ff0449bb@huawei.com>
Date:   Fri, 29 Oct 2021 18:55:31 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20211025064025.2567443-1-houtao1@huawei.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [10.174.176.117]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 dggpeml500025.china.huawei.com (7.185.36.35)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Alexei,

Could you please consider the patch set for 5.16 ? The whole patch set has
already been Acked by Martin.

Thanks.

On 10/25/2021 2:40 PM, Hou Tao wrote:
> Hi,
>
> Currently the test of BPF STRUCT_OPS depends on the specific bpf
> implementation (e.g, tcp_congestion_ops), but it can not cover all
> basic functionalities (e.g, return value handling), so introduce
> a dummy BPF STRUCT_OPS for test purpose.
>
> Instead of loading a userspace-implemeted bpf_dummy_ops map into
> kernel and calling the specific function by writing to sysfs provided
> by bpf_testmode.ko, only loading bpf_dummy_ops related prog into
> kernel and calling these prog by bpf_prog_test_run(). The latter
> is more flexible and has no dependency on extra kernel module.
>
> Now the return value handling is supported by test_1(...) ops,
> and passing multiple arguments is supported by test_2(...) ops.
> If more is needed, test_x(...) ops can be added afterwards.
>
> Comments are always welcome.
> Regards,
> Hou
>
> Change Log:
> v4:
>  * add Acked-by tags in patch 1~4
>  * patch 2: remove unncessary comments and update commit message
>             accordingly
>  * patch 4: remove unnecessary nr checking in dummy_ops_init_args()
>
> v3: https://www.spinics.net/lists/bpf/msg48303.html
>  * rebase on bpf-next
>  * address comments for Martin, mainly include: merge patch 3 &
>    patch 4 in v2, fix names of btf ctx access check helpers,
>    handle CONFIG_NET, fix leak in dummy_ops_init_args(), and
>    simplify bpf_dummy_init()
>  * patch 4: use a loop to check args in test_dummy_multiple_args()
>
> v2: https://www.spinics.net/lists/bpf/msg47948.html
>  * rebase on bpf-next
>  * add test_2(...) ops to test the passing of multiple arguments
>  * a new patch (patch #2) is added to factor out ctx access helpers
>  * address comments from Martin & Andrii
>
> v1: https://www.spinics.net/lists/bpf/msg46787.html
>
> RFC: https://www.spinics.net/lists/bpf/msg46117.html
>
>
> Hou Tao (4):
>   bpf: factor out a helper to prepare trampoline for struct_ops prog
>   bpf: factor out helpers for ctx access checking
>   bpf: add dummy BPF STRUCT_OPS for test purpose
>   selftests/bpf: add test cases for struct_ops prog
>
>  include/linux/bpf.h                           |  43 ++++
>  kernel/bpf/bpf_struct_ops.c                   |  32 ++-
>  kernel/bpf/bpf_struct_ops_types.h             |   3 +
>  kernel/trace/bpf_trace.c                      |  16 +-
>  net/bpf/Makefile                              |   3 +
>  net/bpf/bpf_dummy_struct_ops.c                | 200 ++++++++++++++++++
>  net/ipv4/bpf_tcp_ca.c                         |   9 +-
>  .../selftests/bpf/prog_tests/dummy_st_ops.c   | 115 ++++++++++
>  .../selftests/bpf/progs/dummy_st_ops.c        |  50 +++++
>  9 files changed, 439 insertions(+), 32 deletions(-)
>  create mode 100644 net/bpf/bpf_dummy_struct_ops.c
>  create mode 100644 tools/testing/selftests/bpf/prog_tests/dummy_st_ops.c
>  create mode 100644 tools/testing/selftests/bpf/progs/dummy_st_ops.c
>

