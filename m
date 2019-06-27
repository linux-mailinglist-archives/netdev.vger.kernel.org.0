Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4419958C6E
	for <lists+netdev@lfdr.de>; Thu, 27 Jun 2019 23:04:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726498AbfF0VEg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jun 2019 17:04:36 -0400
Received: from www62.your-server.de ([213.133.104.62]:60332 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726384AbfF0VEg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jun 2019 17:04:36 -0400
Received: from [78.46.172.3] (helo=sslproxy06.your-server.de)
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1hgbZI-0006Oq-8C; Thu, 27 Jun 2019 23:04:33 +0200
Received: from [178.193.45.231] (helo=linux.home)
        by sslproxy06.your-server.de with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89)
        (envelope-from <daniel@iogearbox.net>)
        id 1hgbZI-000Tfk-2T; Thu, 27 Jun 2019 23:04:32 +0200
Subject: Re: [PATCH v2 bpf-next 1/3] libbpf: add perf buffer API
To:     Andrii Nakryiko <andriin@fb.com>, andrii.nakryiko@gmail.com,
        ast@fb.com, bpf@vger.kernel.org, netdev@vger.kernel.org,
        kernel-team@fb.com
References: <20190626061235.602633-1-andriin@fb.com>
 <20190626061235.602633-2-andriin@fb.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <7de14b2b-a663-eed9-8f70-fb6bd5ea84d8@iogearbox.net>
Date:   Thu, 27 Jun 2019 23:04:31 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.3.0
MIME-Version: 1.0
In-Reply-To: <20190626061235.602633-2-andriin@fb.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.100.3/25493/Thu Jun 27 10:06:16 2019)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 06/26/2019 08:12 AM, Andrii Nakryiko wrote:
> BPF_MAP_TYPE_PERF_EVENT_ARRAY map is often used to send data from BPF program
> to user space for additional processing. libbpf already has very low-level API
> to read single CPU perf buffer, bpf_perf_event_read_simple(), but it's hard to
> use and requires a lot of code to set everything up. This patch adds
> perf_buffer abstraction on top of it, abstracting setting up and polling
> per-CPU logic into simple and convenient API, similar to what BCC provides.
> 
> perf_buffer__new() sets up per-CPU ring buffers and updates corresponding BPF
> map entries. It accepts two user-provided callbacks: one for handling raw
> samples and one for get notifications of lost samples due to buffer overflow.
> 
> perf_buffer__poll() is used to fetch ring buffer data across all CPUs,
> utilizing epoll instance.
> 
> perf_buffer__free() does corresponding clean up and unsets FDs from BPF map.
> 
> All APIs are not thread-safe. User should ensure proper locking/coordination if
> used in multi-threaded set up.
> 
> Signed-off-by: Andrii Nakryiko <andriin@fb.com>

Aside from current feedback, this series generally looks great! Two small things:

> diff --git a/tools/lib/bpf/libbpf.map b/tools/lib/bpf/libbpf.map
> index 2382fbda4cbb..10f48103110a 100644
> --- a/tools/lib/bpf/libbpf.map
> +++ b/tools/lib/bpf/libbpf.map
> @@ -170,13 +170,16 @@ LIBBPF_0.0.4 {
>  		btf_dump__dump_type;
>  		btf_dump__free;
>  		btf_dump__new;
> -		btf__parse_elf;
>  		bpf_object__load_xattr;
>  		bpf_program__attach_kprobe;
>  		bpf_program__attach_perf_event;
>  		bpf_program__attach_raw_tracepoint;
>  		bpf_program__attach_tracepoint;
>  		bpf_program__attach_uprobe;
> +		btf__parse_elf;
>  		libbpf_num_possible_cpus;
>  		libbpf_perf_event_disable_and_close;
> +		perf_buffer__free;
> +		perf_buffer__new;
> +		perf_buffer__poll;

We should prefix with libbpf_* given it's not strictly BPF-only and rather
helper function.

Also, we should convert bpftool (tools/bpf/bpftool/map_perf_ring.c) to make
use of these new helpers instead of open-coding there.

Thanks,
Daniel
