Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 81928258240
	for <lists+netdev@lfdr.de>; Mon, 31 Aug 2020 22:07:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729884AbgHaUHo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Aug 2020 16:07:44 -0400
Received: from www62.your-server.de ([213.133.104.62]:39058 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726939AbgHaUHm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Aug 2020 16:07:42 -0400
Received: from sslproxy01.your-server.de ([78.46.139.224])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1kCq5R-0002uJ-9g; Mon, 31 Aug 2020 22:07:29 +0200
Received: from [178.196.57.75] (helo=pc-9.home)
        by sslproxy01.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1kCq5R-000KJE-33; Mon, 31 Aug 2020 22:07:29 +0200
Subject: Re: [PATCH v2 bpf-next] bpf: Fix build without BPF_SYSCALL, but with
 BPF_JIT.
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        davem@davemloft.net
Cc:     paulmck@kernel.org, netdev@vger.kernel.org, bpf@vger.kernel.org,
        kernel-team@fb.com
References: <20200831155155.62754-1-alexei.starovoitov@gmail.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <48c87341-7ad0-6aee-3a11-ba85598b0330@iogearbox.net>
Date:   Mon, 31 Aug 2020 22:07:28 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20200831155155.62754-1-alexei.starovoitov@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.4/25916/Mon Aug 31 15:26:49 2020)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/31/20 5:51 PM, Alexei Starovoitov wrote:
> From: Alexei Starovoitov <ast@kernel.org>
> 
> When CONFIG_BPF_SYSCALL is not set, but CONFIG_BPF_JIT=y
> the kernel build fails:
> In file included from ../kernel/bpf/trampoline.c:11:
> ../kernel/bpf/trampoline.c: In function ‘bpf_trampoline_update’:
> ../kernel/bpf/trampoline.c:220:39: error: ‘call_rcu_tasks_trace’ undeclared
> ../kernel/bpf/trampoline.c: In function ‘__bpf_prog_enter_sleepable’:
> ../kernel/bpf/trampoline.c:411:2: error: implicit declaration of function ‘rcu_read_lock_trace’
> ../kernel/bpf/trampoline.c: In function ‘__bpf_prog_exit_sleepable’:
> ../kernel/bpf/trampoline.c:416:2: error: implicit declaration of function ‘rcu_read_unlock_trace’
> 
> This is due to:
> obj-$(CONFIG_BPF_JIT) += trampoline.o
> obj-$(CONFIG_BPF_JIT) += dispatcher.o
> There is a number of functions that arch/x86/net/bpf_jit_comp.c is
> using from these two files, but none of them will be used when
> only cBPF is on (which is the case for BPF_SYSCALL=n BPF_JIT=y).
> 
> Add rcu_trace functions to rcupdate_trace.h. The JITed code won't execute them
> and BPF trampoline logic won't be used without BPF_SYSCALL.
> 
> Reported-by: kernel test robot <lkp@intel.com>
> Fixes: 1e6c62a88215 ("bpf: Introduce sleepable BPF programs")
> Acked-by: Paul E. McKenney <paulmck@kernel.org>
> Signed-off-by: Alexei Starovoitov <ast@kernel.org>

Applied, thanks!
