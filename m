Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 72F9341D731
	for <lists+netdev@lfdr.de>; Thu, 30 Sep 2021 12:06:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349761AbhI3KIf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Sep 2021 06:08:35 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:27949 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349750AbhI3KIe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Sep 2021 06:08:34 -0400
Received: from dggemv711-chm.china.huawei.com (unknown [172.30.72.54])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4HKph82dMHzbmt3;
        Thu, 30 Sep 2021 18:02:32 +0800 (CST)
Received: from dggpeml500025.china.huawei.com (7.185.36.35) by
 dggemv711-chm.china.huawei.com (10.1.198.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Thu, 30 Sep 2021 18:06:50 +0800
Received: from [10.174.176.117] (10.174.176.117) by
 dggpeml500025.china.huawei.com (7.185.36.35) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Thu, 30 Sep 2021 18:06:49 +0800
Subject: Re: [PATCH bpf-next v4 0/3] add support for writable bare tracepoint
To:     Alexei Starovoitov <ast@kernel.org>
CC:     Yonghong Song <yhs@fb.com>, Daniel Borkmann <daniel@iogearbox.net>,
        "Andrii Nakryiko" <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>
References: <20210930091355.2794601-1-houtao1@huawei.com>
 <20210930091355.2794601-5-houtao1@huawei.com>
From:   Hou Tao <houtao1@huawei.com>
Message-ID: <b6cf9124-f421-bfea-0cee-27307e7fbc07@huawei.com>
Date:   Thu, 30 Sep 2021 18:06:49 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20210930091355.2794601-5-houtao1@huawei.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [10.174.176.117]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 dggpeml500025.china.huawei.com (7.185.36.35)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Oops, I mistakenly send out the zero-patch again. Sorry for that.

On 9/30/2021 5:13 PM, Hou Tao wrote:
> Hi,
>
> The patchset series supports writable context for bare tracepoint.
>
> The main idea comes from patchset "writable contexts for bpf raw
> tracepoints" [1], but it only supports normal tracepoint with
> associated trace event under tracefs. Now we have one use case
> in which we will add bare tracepoint in VFS layer, and update
> file::f_mode for specific files. The reason using bare tracepoint
> is that it doesn't form a ABI and we can change it freely. So
> add support for it in BPF.
>
> Comments are always welcome.
>
> [1]: https://lore.kernel.org/lkml/20190426184951.21812-1-mmullins@fb.com
>
> Change log:
> v4:
>  * rebased on bpf-next
>  * patch 2 is updated to add support for writable raw tracepoint
>    attachment in attach_raw_tp().
>
> v3: https://www.spinics.net/lists/bpf/msg46824.html
>   * use raw_tp.w instead of raw_tp_writable as section
>     name of writable tp
>   * use ASSERT_XXX() instead of CHECK()
>   * define a common macro for "/sys/kernel/bpf_testmod"
>
> v2: https://www.spinics.net/lists/bpf/msg46356.html 
>   * rebase on bpf-next tree
>   * address comments from Yonghong Song
>   * rename bpf_testmode_test_writable_ctx::ret as early_ret to reflect
>     its purpose better.
>
> v1: https://www.spinics.net/lists/bpf/msg46221.html
>
> Hou Tao (3):
>   bpf: support writable context for bare tracepoint
>   libbpf: support detecting and attaching of writable tracepoint program
>   bpf/selftests: add test for writable bare tracepoint
>
>  include/trace/bpf_probe.h                     | 19 +++++++---
>  tools/lib/bpf/libbpf.c                        | 21 ++++++++---
>  .../bpf/bpf_testmod/bpf_testmod-events.h      | 15 ++++++++
>  .../selftests/bpf/bpf_testmod/bpf_testmod.c   | 10 ++++++
>  .../selftests/bpf/bpf_testmod/bpf_testmod.h   |  5 +++
>  .../selftests/bpf/prog_tests/module_attach.c  | 35 +++++++++++++++++++
>  .../selftests/bpf/progs/test_module_attach.c  | 14 ++++++++
>  tools/testing/selftests/bpf/test_progs.c      |  4 +--
>  tools/testing/selftests/bpf/test_progs.h      |  2 ++
>  9 files changed, 114 insertions(+), 11 deletions(-)
>

