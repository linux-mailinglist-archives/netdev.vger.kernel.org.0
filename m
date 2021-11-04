Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D137444EE8
	for <lists+netdev@lfdr.de>; Thu,  4 Nov 2021 07:32:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230152AbhKDGfX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Nov 2021 02:35:23 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:30917 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230383AbhKDGfT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Nov 2021 02:35:19 -0400
Received: from dggemv711-chm.china.huawei.com (unknown [172.30.72.57])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4HlDGK5wx3zcZxj;
        Thu,  4 Nov 2021 14:27:53 +0800 (CST)
Received: from dggpeml500025.china.huawei.com (7.185.36.35) by
 dggemv711-chm.china.huawei.com (10.1.198.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.15; Thu, 4 Nov 2021 14:32:38 +0800
Received: from [10.174.176.117] (10.174.176.117) by
 dggpeml500025.china.huawei.com (7.185.36.35) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.15; Thu, 4 Nov 2021 14:32:38 +0800
Subject: Re: [RFC PATCH v3 2/3] bpf: Add selftests
To:     Joe Burton <jevburton.kernel@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, <linux-kernel@vger.kernel.org>,
        <netdev@vger.kernel.org>, <bpf@vger.kernel.org>
CC:     Petar Penkov <ppenkov@google.com>,
        Stanislav Fomichev <sdf@google.com>,
        Joe Burton <jevburton@google.com>
References: <20211102021432.2807760-1-jevburton.kernel@gmail.com>
 <20211102021432.2807760-3-jevburton.kernel@gmail.com>
From:   Hou Tao <houtao1@huawei.com>
Message-ID: <98178f0f-ff43-b996-f78b-778f74b44a6b@huawei.com>
Date:   Thu, 4 Nov 2021 14:32:37 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20211102021432.2807760-3-jevburton.kernel@gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [10.174.176.117]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 dggpeml500025.china.huawei.com (7.185.36.35)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On 11/2/2021 10:14 AM, Joe Burton wrote:
> From: Joe Burton <jevburton@google.com>
>
> Add selftests verifying that each supported map type is traced.
>
> Signed-off-by: Joe Burton <jevburton@google.com>
> ---
>  .../selftests/bpf/prog_tests/map_trace.c      | 166 ++++++++++++++++++
>  .../selftests/bpf/progs/bpf_map_trace.c       |  95 ++++++++++
>  .../bpf/progs/bpf_map_trace_common.h          |  12 ++
>  3 files changed, 273 insertions(+)
>  create mode 100644 tools/testing/selftests/bpf/prog_tests/map_trace.c
>  create mode 100644 tools/testing/selftests/bpf/progs/bpf_map_trace.c
>  create mode 100644 tools/testing/selftests/bpf/progs/bpf_map_trace_common.h
snip
> +	/*
> +	 * Invoke core BPF program.
> +	 */
> +	write_fd = open("/tmp/map_trace_test_file", O_CREAT | O_WRONLY);
> +	if (!ASSERT_GE(rc, 0, "open tmp file for writing"))
> +		goto out;
> +
> +	bytes_written = write(write_fd, &write_buf, sizeof(write_buf));
> +	if (!ASSERT_EQ(bytes_written, sizeof(write_buf), "write to tmp file"))
> +		return;
In fentry__x64_sys_write(), you just do trigger updates to maps, so for the
portability of the test
(e.g. run-able for arm64) and minimal dependency (e.g. don't depends on /tmp),
why do you
using nanosleep() and replacing fentry_x64_sys_write by
tp/syscalls/sys_enter_nanosleep instead.
Also it will be better if you can filter out other processes by pid.

Thanks,
Tao

