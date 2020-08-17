Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 98567247170
	for <lists+netdev@lfdr.de>; Mon, 17 Aug 2020 20:27:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390660AbgHQS1W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Aug 2020 14:27:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390877AbgHQS1M (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Aug 2020 14:27:12 -0400
Received: from mail-qt1-x844.google.com (mail-qt1-x844.google.com [IPv6:2607:f8b0:4864:20::844])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85B24C061342
        for <netdev@vger.kernel.org>; Mon, 17 Aug 2020 11:27:11 -0700 (PDT)
Received: by mail-qt1-x844.google.com with SMTP id f19so8681372qtp.2
        for <netdev@vger.kernel.org>; Mon, 17 Aug 2020 11:27:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=SPj1nltbf6/Ps0xiynwocXQ5gYrarpHlmjj1YMa+P0o=;
        b=IgNn/Rbf30NJPMwEmqpuuCwSC9Iob6QtDWEcexi5imI77jT05S6RMIY8IMsAeYfCw9
         uNkVT/0elwN2UabnHcNlvpEfmo9IUFrCVyUsZF8vtSp5vwhpoqSYEd650bNecqNbHCmg
         CGxvQALpR6VoO51ioY48lKLp+luZ3rESg0O1S7k//PSbvzkqTnWOp2xPWZCG3JW2vkm9
         5MX4ol7J8fTexS3jT3uHA4wvL6uNGBHek3/+xPm8hx4sESGtEQ5Mwxh/puDyDUhc2ZZU
         RDgnHj/2wpP38w7bt7bduUuBdihRBmAQVtpDrkgLAHZ3CPhvXRdgRYB1A5OcwfAcCv7T
         953w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=SPj1nltbf6/Ps0xiynwocXQ5gYrarpHlmjj1YMa+P0o=;
        b=N3MhCkhu2mqk0h0hoVYpJaMW4N3p4mpQG7FHqcpk+8vmrPIZXj/fodal6Cu4TqOg/9
         QSW+NcHZnPFlwZWuBu0XS5ptCKU+Ka9L9/gQCbJ/7ZqADTvsTswLaTrOIQgD97gMexmK
         JJlFruXavnwX2V3K3o0cDupACX4ezem6PmIguB0Rai276OaF70SJo05NS3h/GcoTNcc0
         vP5s8jr2/Qb8Yl+dtgHcyTRtIkfb2CrUOPdTH37roWdvpJfolGebhLjFW3J73Ese2M2m
         PQ1QBKdtICbqfmICjc4qXs2rP3B10cGhSQt1eTrBOon3zu1Jb6QNHatsOahDeu7Z/k6M
         mRGg==
X-Gm-Message-State: AOAM5301NR0VTG67qgj1ikveJG2ouCrzoSaQdudAPBiAYMPloYBRHLYK
        JmxuJ1Eh0EWG61MjRTtjTPqJgw==
X-Google-Smtp-Source: ABdhPJz1XCO87Xd17vzKVssV2ViWlDKoCCrxFTO+2fvGORjOMGdO8729lDAIeCSkX4+8no/PWVWTvQ==
X-Received: by 2002:aed:2f87:: with SMTP id m7mr14492866qtd.56.1597688830593;
        Mon, 17 Aug 2020 11:27:10 -0700 (PDT)
Received: from ?IPv6:2620:10d:c0a8:11c9::1102? ([2620:10d:c091:480::1:a613])
        by smtp.gmail.com with ESMTPSA id 20sm21114346qtp.53.2020.08.17.11.27.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 17 Aug 2020 11:27:09 -0700 (PDT)
Subject: Re: [PATCH bpf] bpf: use get_file_rcu() instead of get_file() for
 task_file iterator
To:     Yonghong Song <yhs@fb.com>, bpf@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, kernel-team@fb.com
References: <20200817174214.252601-1-yhs@fb.com>
From:   Josef Bacik <josef@toxicpanda.com>
Message-ID: <b1254561-4530-f2d8-bd10-98cb426a727d@toxicpanda.com>
Date:   Mon, 17 Aug 2020 14:27:08 -0400
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <20200817174214.252601-1-yhs@fb.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/17/20 1:42 PM, Yonghong Song wrote:
> With latest `bpftool prog` command, we observed the following kernel
> panic.
>      BUG: kernel NULL pointer dereference, address: 0000000000000000
>      #PF: supervisor instruction fetch in kernel mode
>      #PF: error_code(0x0010) - not-present page
>      PGD dfe894067 P4D dfe894067 PUD deb663067 PMD 0
>      Oops: 0010 [#1] SMP
>      CPU: 9 PID: 6023 ...
>      RIP: 0010:0x0
>      Code: Bad RIP value.
>      RSP: 0000:ffffc900002b8f18 EFLAGS: 00010286
>      RAX: ffff8883a405f400 RBX: ffff888e46a6bf00 RCX: 000000008020000c
>      RDX: 0000000000000000 RSI: 0000000000000001 RDI: ffff8883a405f400
>      RBP: ffff888e46a6bf50 R08: 0000000000000000 R09: ffffffff81129600
>      R10: ffff8883a405f300 R11: 0000160000000000 R12: 0000000000002710
>      R13: 000000e9494b690c R14: 0000000000000202 R15: 0000000000000009
>      FS:  00007fd9187fe700(0000) GS:ffff888e46a40000(0000) knlGS:0000000000000000
>      CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>      CR2: ffffffffffffffd6 CR3: 0000000de5d33002 CR4: 0000000000360ee0
>      DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
>      DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
>      Call Trace:
>       <IRQ>
>       rcu_core+0x1a4/0x440
>       __do_softirq+0xd3/0x2c8
>       irq_exit+0x9d/0xa0
>       smp_apic_timer_interrupt+0x68/0x120
>       apic_timer_interrupt+0xf/0x20
>       </IRQ>
>      RIP: 0033:0x47ce80
>      Code: Bad RIP value.
>      RSP: 002b:00007fd9187fba40 EFLAGS: 00000206 ORIG_RAX: ffffffffffffff13
>      RAX: 0000000000000002 RBX: 00007fd931789160 RCX: 000000000000010c
>      RDX: 00007fd9308cdfb4 RSI: 00007fd9308cdfb4 RDI: 00007ffedd1ea0a8
>      RBP: 00007fd9187fbab0 R08: 000000000000000e R09: 000000000000002a
>      R10: 0000000000480210 R11: 00007fd9187fc570 R12: 00007fd9316cc400
>      R13: 0000000000000118 R14: 00007fd9308cdfb4 R15: 00007fd9317a9380
> 
> After further analysis, the bug is triggered by
> Commit eaaacd23910f ("bpf: Add task and task/file iterator targets")
> which introduced task_file bpf iterator, which traverses all open file
> descriptors for all tasks in the current namespace.
> The latest `bpftool prog` calls a task_file bpf program to traverse
> all files in the system in order to associate processes with progs/maps, etc.
> When traversing files for a given task, rcu read_lock is taken to
> access all files in a file_struct. But it used get_file() to grab
> a file, which is not right. It is possible file->f_count is 0 and
> get_file() will unconditionally increase it.
> Later put_file() may cause all kind of issues with the above
> as one of sympotoms.
> 
> The failure can be reproduced with the following steps in a few seconds:
>      $ cat t.c
>      #include <stdio.h>
>      #include <sys/types.h>
>      #include <sys/stat.h>
>      #include <fcntl.h>
>      #include <unistd.h>
> 
>      #define N 10000
>      int fd[N];
>      int main() {
>        int i;
> 
>        for (i = 0; i < N; i++) {
>          fd[i] = open("./note.txt", 'r');
>          if (fd[i] < 0) {
>             fprintf(stderr, "failed\n");
>             return -1;
>          }
>        }
>        for (i = 0; i < N; i++)
>          close(fd[i]);
> 
>        return 0;
>      }
>      $ gcc -O2 t.c
>      $ cat run.sh
>      #/bin/bash
>      for i in {1..100}
>      do
>        while true; do ./a.out; done &
>      done
>      $ ./run.sh
>      $ while true; do bpftool prog >& /dev/null; done
> 
> This patch used get_file_rcu() which only grabs a file if the
> file->f_count is not zero. This is to ensure the file pointer
> is always valid. The above reproducer did not fail for more
> than 30 minutes.
> 
> Fixes: eaaacd23910f ("bpf: Add task and task/file iterator targets")
> Suggested-by: Josef Bacik <josef@toxicpanda.com>
> Signed-off-by: Yonghong Song <yhs@fb.com>
> ---

Reviewed-by: Josef Bacik <josef@toxicpanda.com>

Also verified that the problem no longer happens in production.  Thanks,

Josef
