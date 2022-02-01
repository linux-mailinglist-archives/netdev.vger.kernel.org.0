Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B87144A58CD
	for <lists+netdev@lfdr.de>; Tue,  1 Feb 2022 09:52:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235773AbiBAIw0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Feb 2022 03:52:26 -0500
Received: from www62.your-server.de ([213.133.104.62]:60382 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231912AbiBAIwZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Feb 2022 03:52:25 -0500
Received: from sslproxy06.your-server.de ([78.46.172.3])
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1nEote-0003N7-C3; Tue, 01 Feb 2022 09:52:18 +0100
Received: from [85.1.206.226] (helo=linux.home)
        by sslproxy06.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1nEote-00059S-1o; Tue, 01 Feb 2022 09:52:18 +0100
Subject: Re: [PATCH v3 bpf-next 0/4] libbpf: name-based u[ret]probe attach
To:     Alan Maguire <alan.maguire@oracle.com>, andrii@kernel.org,
        ast@kernel.org
Cc:     kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org, jolsa@kernel.org,
        sunyucong@gmail.com, netdev@vger.kernel.org, bpf@vger.kernel.org
References: <1643645554-28723-1-git-send-email-alan.maguire@oracle.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <a74d3ab8-152a-b81b-54f3-9a46d6ba682d@iogearbox.net>
Date:   Tue, 1 Feb 2022 09:52:17 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <1643645554-28723-1-git-send-email-alan.maguire@oracle.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.5/26439/Mon Jan 31 10:24:40 2022)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Alan,

On 1/31/22 5:12 PM, Alan Maguire wrote:
> This patch series is a refinement of the RFC patchset [1], focusing
> on support for attach by name for uprobes and uretprobes. v3
> because there was an earlier RFC [2].
> 
> Currently attach for such probes is done by determining the offset
> manually, so the aim is to try and mimic the simplicity of kprobe
> attach, making use of uprobe opts to specify a name string.
> Patch 1 adds the "func_name" option to allow uprobe attach by
> name; the mechanics are described there.
> 
> Having name-based support allows us to support auto-attach for
> uprobes; patch 2 adds auto-attach support while attempting
> to handle backwards-compatibility issues that arise.  The format
> supported is
> 
> u[ret]probe//path/2/binary:[raw_offset|function[+offset]]
> 
> For example, to attach to libc malloc:
> 
> SEC("uprobe//usr/lib64/libc.so.6:malloc")
> 
> Patch 3 introduces a helper function to trace_helpers, allowing
> us to retrieve the path to a library by reading /proc/self/maps.
> 
> Finally patch 4 add tests to the attach_probe selftests covering
> attach by name, auto-attach and auto-attach failure.

Looks like the selftest in the series fails the BPF CI (test_progs & test_progs-no_alu32):

https://github.com/kernel-patches/bpf/runs/5012260907?check_suite_focus=true

   [...]
   test_attach_probe:PASS:uprobe_offset 0 nsec
   test_attach_probe:PASS:ref_ctr_offset 0 nsec
   test_attach_probe:PASS:skel_open 0 nsec
   test_attach_probe:PASS:check_bss 0 nsec
   test_attach_probe:PASS:attach_kprobe 0 nsec
   test_attach_probe:PASS:attach_kretprobe 0 nsec
   test_attach_probe:PASS:uprobe_ref_ctr_before 0 nsec
   test_attach_probe:PASS:attach_uprobe 0 nsec
   test_attach_probe:PASS:uprobe_ref_ctr_after 0 nsec
   test_attach_probe:PASS:attach_uretprobe 0 nsec
   test_attach_probe:PASS:auto-attach should fail for old-style name 0 nsec
   test_attach_probe:PASS:attach_uprobe_byname 0 nsec
   test_attach_probe:PASS:attach_uretprobe_byname 0 nsec
   test_attach_probe:PASS:get path to libc 0 nsec
   test_attach_probe:PASS:find libc path in /proc/self/maps 0 nsec
   libbpf: failed to open 7f55b225c000-7f55b2282000 r--p 00000000 fe:00 3381                       /usr/lib/libc-2.32.so: No such file or directory
   test_attach_probe:FAIL:attach_uprobe_byname2 unexpected error: -2
   test_attach_probe:PASS:uprobe_ref_ctr_cleanup 0 nsec
   #4 attach_probe:FAIL
   [...]

Thanks,
Daniel
