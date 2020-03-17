Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 366A5188E05
	for <lists+netdev@lfdr.de>; Tue, 17 Mar 2020 20:30:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726623AbgCQTaf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Mar 2020 15:30:35 -0400
Received: from www62.your-server.de ([213.133.104.62]:37880 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726476AbgCQTaf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Mar 2020 15:30:35 -0400
Received: from sslproxy03.your-server.de ([88.198.220.132])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1jEHv6-0005Gw-7l; Tue, 17 Mar 2020 20:30:32 +0100
Received: from [85.7.42.192] (helo=pc-9.home)
        by sslproxy03.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1jEHv5-000HzY-S0; Tue, 17 Mar 2020 20:30:31 +0100
Subject: Re: [PATCH v2 bpf-next] bpf: sharing bpf runtime stats with
 /dev/bpf_stats
To:     Song Liu <songliubraving@fb.com>, linux-fsdevel@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     kernel-team@fb.com, ast@kernel.org, mcgrof@kernel.org,
        keescook@chromium.org, yzaikin@google.com
References: <20200316203329.2747779-1-songliubraving@fb.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <eb31bed3-3be4-501e-4340-bd558b31ead2@iogearbox.net>
Date:   Tue, 17 Mar 2020 20:30:31 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20200316203329.2747779-1-songliubraving@fb.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.2/25754/Tue Mar 17 14:09:15 2020)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/16/20 9:33 PM, Song Liu wrote:
> Currently, sysctl kernel.bpf_stats_enabled controls BPF runtime stats.
> Typical userspace tools use kernel.bpf_stats_enabled as follows:
> 
>    1. Enable kernel.bpf_stats_enabled;
>    2. Check program run_time_ns;
>    3. Sleep for the monitoring period;
>    4. Check program run_time_ns again, calculate the difference;
>    5. Disable kernel.bpf_stats_enabled.
> 
> The problem with this approach is that only one userspace tool can toggle
> this sysctl. If multiple tools toggle the sysctl at the same time, the
> measurement may be inaccurate.
> 
> To fix this problem while keep backward compatibility, introduce a new
> bpf command BPF_ENABLE_RUNTIME_STATS. On success, this command enables
> run_time_ns stats and returns a valid fd.
> 
> With BPF_ENABLE_RUNTIME_STATS, user space tool would have the following
> flow:
> 
>    1. Get a fd with BPF_ENABLE_RUNTIME_STATS, and make sure it is valid;
>    2. Check program run_time_ns;
>    3. Sleep for the monitoring period;
>    4. Check program run_time_ns again, calculate the difference;
>    5. Close the fd.
> 
> Signed-off-by: Song Liu <songliubraving@fb.com>

Hmm, I see no relation to /dev/bpf_stats anymore, yet the subject still talks
about it?

Also, should this have bpftool integration now that we have `bpftool prog profile`
support? Would be nice to then fetch the related stats via bpf_prog_info, so users
can consume this in an easy way.

> Changes RFC => v2:
> 1. Add a new bpf command instead of /dev/bpf_stats;
> 2. Remove the jump_label patch, which is no longer needed;
> 3. Add a static variable to save previous value of the sysctl.
> ---
>   include/linux/bpf.h            |  1 +
>   include/uapi/linux/bpf.h       |  1 +
>   kernel/bpf/syscall.c           | 43 ++++++++++++++++++++++++++++++++++
>   kernel/sysctl.c                | 36 +++++++++++++++++++++++++++-
>   tools/include/uapi/linux/bpf.h |  1 +
>   5 files changed, 81 insertions(+), 1 deletion(-)
> 
> diff --git a/include/linux/bpf.h b/include/linux/bpf.h
> index 4fd91b7c95ea..d542349771df 100644
> --- a/include/linux/bpf.h
> +++ b/include/linux/bpf.h
> @@ -970,6 +970,7 @@ _out:							\
>   
>   #ifdef CONFIG_BPF_SYSCALL
>   DECLARE_PER_CPU(int, bpf_prog_active);
> +extern struct mutex bpf_stats_enabled_mutex;
>   
>   /*
>    * Block execution of BPF programs attached to instrumentation (perf,
> diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
> index 40b2d9476268..8285ff37210c 100644
> --- a/include/uapi/linux/bpf.h
> +++ b/include/uapi/linux/bpf.h
> @@ -111,6 +111,7 @@ enum bpf_cmd {
>   	BPF_MAP_LOOKUP_AND_DELETE_BATCH,
>   	BPF_MAP_UPDATE_BATCH,
>   	BPF_MAP_DELETE_BATCH,
> +	BPF_ENABLE_RUNTIME_STATS,
>   };
>   
>   enum bpf_map_type {
> diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
> index b2f73ecacced..823dc9de7953 100644
> --- a/kernel/bpf/syscall.c
> +++ b/kernel/bpf/syscall.c
> @@ -24,6 +24,9 @@
>   #include <linux/ctype.h>
>   #include <linux/nospec.h>
>   #include <linux/audit.h>
> +#include <linux/miscdevice.h>

Is this still needed?

> +#include <linux/fs.h>
> +#include <linux/jump_label.h>
>   #include <uapi/linux/btf.h>
>   
>   #define IS_FD_ARRAY(map) ((map)->map_type == BPF_MAP_TYPE_PERF_EVENT_ARRAY || \
> @@ -3550,6 +3553,43 @@ static int bpf_map_do_batch(const union bpf_attr *attr,
>   	return err;
>   }
>   

Thanks,
Daniel
