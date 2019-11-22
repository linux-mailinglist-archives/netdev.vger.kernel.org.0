Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 82B07107B93
	for <lists+netdev@lfdr.de>; Sat, 23 Nov 2019 00:47:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726735AbfKVXrh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Nov 2019 18:47:37 -0500
Received: from www62.your-server.de ([213.133.104.62]:50532 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726666AbfKVXrh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Nov 2019 18:47:37 -0500
Received: from sslproxy01.your-server.de ([88.198.220.130])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1iYIe6-0005Kj-7N; Sat, 23 Nov 2019 00:47:26 +0100
Received: from [178.197.248.30] (helo=pc-9.home)
        by sslproxy01.your-server.de with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89)
        (envelope-from <daniel@iogearbox.net>)
        id 1iYIe5-0005qc-Rg; Sat, 23 Nov 2019 00:47:25 +0100
Subject: Re: [PATCH bpf-next] selftests/bpf: Add BPF trampoline performance
 test
To:     Alexei Starovoitov <ast@kernel.org>, davem@davemloft.net
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org, kernel-team@fb.com
References: <20191122011515.255371-1-ast@kernel.org>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <cbbd5f73-f20f-42fc-8b21-8d6f97d52cf9@iogearbox.net>
Date:   Sat, 23 Nov 2019 00:47:25 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20191122011515.255371-1-ast@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.101.4/25641/Fri Nov 22 11:06:48 2019)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/22/19 2:15 AM, Alexei Starovoitov wrote:
> Add a test that benchmarks different ways of attaching BPF program to a kernel function.
> Here are the results for 2.4Ghz x86 cpu on a kernel without mitigations:
> $ ./test_progs -n 49 -v|grep events
> task_rename base	2743K events per sec
> task_rename kprobe	2419K events per sec
> task_rename kretprobe	1876K events per sec
> task_rename raw_tp	2578K events per sec
> task_rename fentry	2710K events per sec
> task_rename fexit	2685K events per sec
> 
> On a kernel with retpoline:
> $ ./test_progs -n 49 -v|grep events
> task_rename base	2401K events per sec
> task_rename kprobe	1930K events per sec
> task_rename kretprobe	1485K events per sec
> task_rename raw_tp	2053K events per sec
> task_rename fentry	2351K events per sec
> task_rename fexit	2185K events per sec
> 
> All 5 approaches:
> - kprobe/kretprobe in __set_task_comm()
> - raw tracepoint in trace_task_rename()
> - fentry/fexit in __set_task_comm()
> are roughly equivalent.
> 
> __set_task_comm() by itself is quite fast, so any extra instructions add up.
> Until BPF trampoline was introduced the fastest mechanism was raw tracepoint.
> kprobe via ftrace was second best. kretprobe is slow due to trap. New
> fentry/fexit methods via BPF trampoline are clearly the fastest and the
> difference is more pronounced with retpoline on, since BPF trampoline doesn't
> use indirect jumps.
> 
> Signed-off-by: Alexei Starovoitov <ast@kernel.org>

Applied, thanks!
