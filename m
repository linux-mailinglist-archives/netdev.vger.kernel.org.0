Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DEF9D1D9DC8
	for <lists+netdev@lfdr.de>; Tue, 19 May 2020 19:21:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729445AbgESRV0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 May 2020 13:21:26 -0400
Received: from www62.your-server.de ([213.133.104.62]:51704 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729238AbgESRVZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 May 2020 13:21:25 -0400
Received: from sslproxy01.your-server.de ([78.46.139.224])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1jb5ve-0003cr-PZ; Tue, 19 May 2020 19:21:22 +0200
Received: from [178.196.57.75] (helo=pc-9.home)
        by sslproxy01.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1jb5ve-000D5F-GM; Tue, 19 May 2020 19:21:22 +0200
Subject: Re: [PATCH bpf-next v2 0/5] samples: bpf: refactor kprobe tracing
 progs with libbpf
To:     "Daniel T. Lee" <danieltimlee@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Yonghong Song <yhs@fb.com>
References: <20200516040608.1377876-1-danieltimlee@gmail.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <a2814e19-3a0a-bfc8-a025-62e4bb7302a7@iogearbox.net>
Date:   Tue, 19 May 2020 19:21:21 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20200516040608.1377876-1-danieltimlee@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.2/25817/Tue May 19 14:16:16 2020)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/16/20 6:06 AM, Daniel T. Lee wrote:
> Currently, the kprobe BPF program attachment method for bpf_load is
> pretty outdated. The implementation of bpf_load "directly" controls and
> manages(create, delete) the kprobe events of DEBUGFS. On the other hand,
> using using the libbpf automatically manages the kprobe event.
> (under bpf_link interface)
> 
> This patchset refactors kprobe tracing programs with using libbpf API
> for loading bpf program instead of previous bpf_load implementation.
> 
> ---
> Changes in V2:
>   - refactor pointer error check with libbpf_get_error
>   - on bpf object open failure, return instead jump to cleanup
>   - add macro for adding architecture prefix to system calls (sys_*)
> 
> Daniel T. Lee (5):
>    samples: bpf: refactor pointer error check with libbpf
>    samples: bpf: refactor kprobe tracing user progs with libbpf
>    samples: bpf: refactor tail call user progs with libbpf
>    samples: bpf: add tracex7 test file to .gitignore
>    samples: bpf: refactor kprobe, tail call kern progs map definition
> 
>   samples/bpf/.gitignore              |  1 +
>   samples/bpf/Makefile                | 16 +++----
>   samples/bpf/sampleip_kern.c         | 12 +++---
>   samples/bpf/sampleip_user.c         |  7 +--
>   samples/bpf/sockex3_kern.c          | 36 ++++++++--------
>   samples/bpf/sockex3_user.c          | 64 +++++++++++++++++++---------
>   samples/bpf/trace_common.h          | 13 ++++++
>   samples/bpf/trace_event_kern.c      | 24 +++++------
>   samples/bpf/trace_event_user.c      |  9 ++--
>   samples/bpf/tracex1_user.c          | 37 +++++++++++++---
>   samples/bpf/tracex2_kern.c          | 27 ++++++------
>   samples/bpf/tracex2_user.c          | 51 ++++++++++++++++++----
>   samples/bpf/tracex3_kern.c          | 24 +++++------
>   samples/bpf/tracex3_user.c          | 61 +++++++++++++++++++-------
>   samples/bpf/tracex4_kern.c          | 12 +++---
>   samples/bpf/tracex4_user.c          | 51 +++++++++++++++++-----
>   samples/bpf/tracex5_kern.c          | 14 +++---
>   samples/bpf/tracex5_user.c          | 66 +++++++++++++++++++++++++----
>   samples/bpf/tracex6_kern.c          | 38 +++++++++--------
>   samples/bpf/tracex6_user.c          | 49 ++++++++++++++++++---
>   samples/bpf/tracex7_user.c          | 39 +++++++++++++----
>   samples/bpf/xdp_redirect_cpu_user.c |  5 +--
>   22 files changed, 455 insertions(+), 201 deletions(-)
>   create mode 100644 samples/bpf/trace_common.h
> 

Applied, thanks!
