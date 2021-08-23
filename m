Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 87C173F4DC8
	for <lists+netdev@lfdr.de>; Mon, 23 Aug 2021 17:54:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231608AbhHWPzH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Aug 2021 11:55:07 -0400
Received: from www62.your-server.de ([213.133.104.62]:35630 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230314AbhHWPzG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Aug 2021 11:55:06 -0400
Received: from sslproxy02.your-server.de ([78.47.166.47])
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1mICH7-0007Np-Gb; Mon, 23 Aug 2021 17:54:13 +0200
Received: from [85.5.47.65] (helo=linux.home)
        by sslproxy02.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1mICH6-000KwX-Tj; Mon, 23 Aug 2021 17:54:13 +0200
Subject: Re: [PATCH linux-next] tools: fix warning comparing pointer to 0
To:     CGEL <cgel.zte@gmail.com>, Shuah Khan <shuah@kernel.org>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Andrei Matei <andreimatei1@gmail.com>,
        linux-kselftest@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org,
        jing yangyang <jing.yangyang@zte.com.cn>,
        Zeal Robot <zealci@zte.com.cn>
References: <20210820033057.13063-1-jing.yangyang@zte.com.cn>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <491f06b5-3680-012a-f1d0-9831aa18e56a@iogearbox.net>
Date:   Mon, 23 Aug 2021 17:54:07 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20210820033057.13063-1-jing.yangyang@zte.com.cn>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.2/26272/Mon Aug 23 10:21:13 2021)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/20/21 5:30 AM, CGEL wrote:
> From: jing yangyang <jing.yangyang@zte.com.cn>
> 
> Fix the following coccicheck warning:
> ./tools/testing/selftests/bpf/progs/profiler.inc.h:364:18-22:WARNING
> comparing pointer to 0
> ./tools/testing/selftests/bpf/progs/profiler.inc.h:537:23-27:WARNING
> comparing pointer to 0
> ./tools/testing/selftests/bpf/progs/profiler.inc.h:544:21-25:WARNING
> comparing pointer to 0
> ./tools/testing/selftests/bpf/progs/profiler.inc.h:770:13-17:WARNING
> comparing pointer to 0
> 
> Reported-by: Zeal Robot <zealci@zte.com.cn>
> Signed-off-by: jing yangyang <jing.yangyang@zte.com.cn>

Please properly explain in the commit message what this 'fixes' exactly and
why it is needed.

> ---
>   tools/testing/selftests/bpf/progs/profiler.inc.h | 8 ++++----
>   1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/tools/testing/selftests/bpf/progs/profiler.inc.h b/tools/testing/selftests/bpf/progs/profiler.inc.h
> index 4896fdf..5c0bdab 100644
> --- a/tools/testing/selftests/bpf/progs/profiler.inc.h
> +++ b/tools/testing/selftests/bpf/progs/profiler.inc.h
> @@ -361,7 +361,7 @@ static INLINE void* populate_var_metadata(struct var_metadata_t* metadata,
>   	int zero = 0;
>   	struct var_kill_data_t* kill_data = bpf_map_lookup_elem(&data_heap, &zero);
>   
> -	if (kill_data == NULL)
> +	if (!kill_dat)

And please don't send broken stuff like this.

>   		return NULL;
>   	struct task_struct* task = (struct task_struct*)bpf_get_current_task();
>   
> @@ -534,14 +534,14 @@ static INLINE bool is_dentry_allowed_for_filemod(struct dentry* file_dentry,
>   	*device_id = dev_id;
>   	bool* allowed_device = bpf_map_lookup_elem(&allowed_devices, &dev_id);
>   
> -	if (allowed_device == NULL)
> +	if (!allowed_device)
>   		return false;
>   
>   	u64 ino = BPF_CORE_READ(file_dentry, d_inode, i_ino);
>   	*file_ino = ino;
>   	bool* allowed_file = bpf_map_lookup_elem(&allowed_file_inodes, &ino);
>   
> -	if (allowed_file == NULL)
> +	if (!allowed_fil)

... same. You did not bother to compile test even.

>   		if (!is_ancestor_in_allowed_inodes(BPF_CORE_READ(file_dentry, d_parent)))
>   			return false;
>   	return true;
> @@ -689,7 +689,7 @@ int raw_tracepoint__sched_process_exec(struct bpf_raw_tracepoint_args* ctx)
>   	u64 inode = BPF_CORE_READ(bprm, file, f_inode, i_ino);
>   
>   	bool* should_filter_binprm = bpf_map_lookup_elem(&disallowed_exec_inodes, &inode);
> -	if (should_filter_binprm != NULL)
> +	if (should_filter_binprm)
>   		goto out;
>   
>   	int zero = 0;
> 

