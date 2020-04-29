Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 283221BECAA
	for <lists+netdev@lfdr.de>; Thu, 30 Apr 2020 01:33:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727028AbgD2Xdu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Apr 2020 19:33:50 -0400
Received: from www62.your-server.de ([213.133.104.62]:33030 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726935AbgD2Xdt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Apr 2020 19:33:49 -0400
Received: from sslproxy05.your-server.de ([78.46.172.2])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1jTwD4-0000YI-UR; Thu, 30 Apr 2020 01:33:47 +0200
Received: from [178.195.186.98] (helo=pc-9.home)
        by sslproxy05.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1jTwD4-0003Te-LV; Thu, 30 Apr 2020 01:33:46 +0200
Subject: Re: [PATCH v8 bpf-next 1/3] bpf: sharing bpf runtime stats with
 BPF_ENABLE_STATS
To:     Song Liu <songliubraving@fb.com>, bpf@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     ast@kernel.org, kernel-team@fb.com
References: <20200429064543.634465-1-songliubraving@fb.com>
 <20200429064543.634465-2-songliubraving@fb.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <77523dab-bfd0-45d4-0d03-26a07bb6483e@iogearbox.net>
Date:   Thu, 30 Apr 2020 01:33:45 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20200429064543.634465-2-songliubraving@fb.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.2/25797/Wed Apr 29 14:06:14 2020)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/29/20 8:45 AM, Song Liu wrote:
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
> bpf command BPF_ENABLE_STATS. On success, this command enables stats and
> returns a valid fd. BPF_ENABLE_STATS takes argument "type". Currently,
> only one type, BPF_STATS_RUN_TIME, is supported. We can extend the
> command to support other types of stats in the future.
> 
> With BPF_ENABLE_STATS, user space tool would have the following flow:
> 
>    1. Get a fd with BPF_ENABLE_STATS, and make sure it is valid;
>    2. Check program run_time_ns;
>    3. Sleep for the monitoring period;
>    4. Check program run_time_ns again, calculate the difference;
>    5. Close the fd.
> 
> Signed-off-by: Song Liu <songliubraving@fb.com>
[...]
> diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
> index d23c04cbe14f..8691b2cc550d 100644
> --- a/kernel/bpf/syscall.c
> +++ b/kernel/bpf/syscall.c
> @@ -3872,6 +3872,60 @@ static int bpf_link_get_fd_by_id(const union bpf_attr *attr)
>   	return fd;
>   }
>   
> +DEFINE_MUTEX(bpf_stats_enabled_mutex);
> +
> +static int bpf_stats_release(struct inode *inode, struct file *file)
> +{
> +	mutex_lock(&bpf_stats_enabled_mutex);
> +	static_key_slow_dec(&bpf_stats_enabled_key.key);
> +	mutex_unlock(&bpf_stats_enabled_mutex);
> +	return 0;
> +}
> +
> +static const struct file_operations bpf_stats_fops = {
> +	.release = bpf_stats_release,
> +};
> +
> +static int bpf_enable_runtime_stats(void)
> +{
> +	int fd;
> +
> +	mutex_lock(&bpf_stats_enabled_mutex);
> +
> +	/* Set a very high limit to avoid overflow */
> +	if (static_key_count(&bpf_stats_enabled_key.key) > INT_MAX / 2) {
> +		mutex_unlock(&bpf_stats_enabled_mutex);
> +		return -EBUSY;
> +	}
> +
> +	fd = anon_inode_getfd("bpf-stats", &bpf_stats_fops, NULL, 0);

Missing O_CLOEXEC or intentional (if latter, I'd have expected a comment
here though)?

> +	if (fd >= 0)
> +		static_key_slow_inc(&bpf_stats_enabled_key.key);
> +
> +	mutex_unlock(&bpf_stats_enabled_mutex);
> +	return fd;
> +}
> +
> +#define BPF_ENABLE_STATS_LAST_FIELD enable_stats.type
> +
[...]
> diff --git a/kernel/sysctl.c b/kernel/sysctl.c
> index e961286d0e14..af08ef0690cb 100644
> --- a/kernel/sysctl.c
> +++ b/kernel/sysctl.c
> @@ -201,6 +201,40 @@ static int max_extfrag_threshold = 1000;
>   
>   #endif /* CONFIG_SYSCTL */
>   
> +#ifdef CONFIG_BPF_SYSCALL
> +static int bpf_stats_handler(struct ctl_table *table, int write,
> +			     void __user *buffer, size_t *lenp,
> +			     loff_t *ppos)
> +{
> +	struct static_key *key = (struct static_key *)table->data;
> +	static int saved_val;
> +	int val, ret;
> +	struct ctl_table tmp = {
> +		.data   = &val,
> +		.maxlen = sizeof(val),
> +		.mode   = table->mode,
> +		.extra1 = SYSCTL_ZERO,
> +		.extra2 = SYSCTL_ONE,
> +	};
> +
> +	if (write && !capable(CAP_SYS_ADMIN))
> +		return -EPERM;
> +
> +	mutex_lock(&bpf_stats_enabled_mutex);
> +	val = saved_val;
> +	ret = proc_dointvec_minmax(&tmp, write, buffer, lenp, ppos);
> +	if (write && !ret && val != saved_val) {
> +		if (val)
> +			static_key_slow_inc(key);
> +		else
> +			static_key_slow_dec(key);
> +		saved_val = val;
> +	}
> +	mutex_unlock(&bpf_stats_enabled_mutex);
> +	return ret;
> +}

nit: I wonder if most of the logic could have been shared with
proc_do_static_key() here and only the mutex passed as an arg to
the common helper?

> +#endif
> +
>   /*
>    * /proc/sys support
>    */
> @@ -2549,7 +2583,7 @@ static struct ctl_table kern_table[] = {
>   		.data		= &bpf_stats_enabled_key.key,
>   		.maxlen		= sizeof(bpf_stats_enabled_key),
>   		.mode		= 0644,
