Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B7BD258374
	for <lists+netdev@lfdr.de>; Mon, 31 Aug 2020 23:25:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728956AbgHaVZf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Aug 2020 17:25:35 -0400
Received: from www62.your-server.de ([213.133.104.62]:48980 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728352AbgHaVZf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Aug 2020 17:25:35 -0400
Received: from sslproxy02.your-server.de ([78.47.166.47])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1kCrIq-0001ul-7c; Mon, 31 Aug 2020 23:25:24 +0200
Received: from [178.196.57.75] (helo=pc-9.home)
        by sslproxy02.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1kCrIq-0007yz-2B; Mon, 31 Aug 2020 23:25:24 +0200
Subject: Re: [PATCH bpf-next] bpf: Remove bpf_lsm_file_mprotect from sleepable
 list.
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        davem@davemloft.net
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org, kernel-team@fb.com
References: <20200831201651.82447-1-alexei.starovoitov@gmail.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <c6df42da-6185-3958-0528-55a43d0a9444@iogearbox.net>
Date:   Mon, 31 Aug 2020 23:25:23 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20200831201651.82447-1-alexei.starovoitov@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.4/25916/Mon Aug 31 15:26:49 2020)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/31/20 10:16 PM, Alexei Starovoitov wrote:
> From: Alexei Starovoitov <ast@kernel.org>
> 
> Technically the bpf programs can sleep while attached to bpf_lsm_file_mprotect,
> but such programs need to access user memory. So they're in might_fault()
> category. Which means they cannot be called from file_mprotect lsm hook that
> takes write lock on mm->mmap_lock.
> Adjust the test accordingly.
> 
> Also add might_fault() to __bpf_prog_enter_sleepable() to catch such deadlocks early.
> 
> Reported-by: Yonghong Song <yhs@fb.com>
> Fixes: 1e6c62a88215 ("bpf: Introduce sleepable BPF programs")
> Fixes: e68a144547fc ("selftests/bpf: Add sleepable tests")
> Signed-off-by: Alexei Starovoitov <ast@kernel.org>
> ---
>   kernel/bpf/trampoline.c                 |  1 +
>   kernel/bpf/verifier.c                   |  1 -
>   tools/testing/selftests/bpf/progs/lsm.c | 34 ++++++++++++-------------
>   3 files changed, 18 insertions(+), 18 deletions(-)
> 
> diff --git a/kernel/bpf/trampoline.c b/kernel/bpf/trampoline.c
> index c2b76545153c..7dd523a7e32d 100644
> --- a/kernel/bpf/trampoline.c
> +++ b/kernel/bpf/trampoline.c
> @@ -409,6 +409,7 @@ void notrace __bpf_prog_exit(struct bpf_prog *prog, u64 start)
>   void notrace __bpf_prog_enter_sleepable(void)
>   {
>   	rcu_read_lock_trace();
> +	might_fault();

Makes sense, was wondering about a __might_sleep() but that will cover it internally
too. Applied, thanks!

>   }
>   
>   void notrace __bpf_prog_exit_sleepable(void)
