Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 04B09104603
	for <lists+netdev@lfdr.de>; Wed, 20 Nov 2019 22:46:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725956AbfKTVqs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Nov 2019 16:46:48 -0500
Received: from www62.your-server.de ([213.133.104.62]:53468 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725819AbfKTVqs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Nov 2019 16:46:48 -0500
Received: from sslproxy01.your-server.de ([88.198.220.130])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1iXXoD-0004qT-Je; Wed, 20 Nov 2019 22:46:45 +0100
Received: from [178.197.248.30] (helo=pc-9.home)
        by sslproxy01.your-server.de with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89)
        (envelope-from <daniel@iogearbox.net>)
        id 1iXXoD-0000wD-2Z; Wed, 20 Nov 2019 22:46:45 +0100
Subject: Re: [PATCH] bpf: emit audit messages upon successful prog load and
 unload
To:     Jiri Olsa <jolsa@kernel.org>, Alexei Starovoitov <ast@kernel.org>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        Andrii Nakryiko <andriin@fb.com>, Yonghong Song <yhs@fb.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Steve Grubb <sgrubb@redhat.com>,
        David Miller <davem@redhat.com>,
        Paul Moore <paul@paul-moore.com>,
        Eric Paris <eparis@redhat.com>, Jiri Benc <jbenc@redhat.com>
References: <20191120213816.8186-1-jolsa@kernel.org>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <8c928ec4-9e43-3e2a-7005-21f40fcca061@iogearbox.net>
Date:   Wed, 20 Nov 2019 22:46:43 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20191120213816.8186-1-jolsa@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.101.4/25639/Wed Nov 20 11:02:53 2019)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/20/19 10:38 PM, Jiri Olsa wrote:
> From: Daniel Borkmann <daniel@iogearbox.net>
> 
> Allow for audit messages to be emitted upon BPF program load and
> unload for having a timeline of events. The load itself is in
> syscall context, so additional info about the process initiating
> the BPF prog creation can be logged and later directly correlated
> to the unload event.
> 
> The only info really needed from BPF side is the globally unique
> prog ID where then audit user space tooling can query / dump all
> info needed about the specific BPF program right upon load event
> and enrich the record, thus these changes needed here can be kept
> small and non-intrusive to the core.
> 
> Raw example output:
> 
>    # auditctl -D
>    # auditctl -a always,exit -F arch=x86_64 -S bpf
>    # ausearch --start recent -m 1334
>    [...]
>    ----
>    time->Wed Nov 20 12:45:51 2019
>    type=PROCTITLE msg=audit(1574271951.590:8974): proctitle="./test_verifier"
>    type=SYSCALL msg=audit(1574271951.590:8974): arch=c000003e syscall=321 success=yes exit=14 a0=5 a1=7ffe2d923e80 a2=78 a3=0 items=0 ppid=742 pid=949 auid=0 uid=0 gid=0 euid=0 suid=0 fsuid=0 egid=0 sgid=0 fsgid=0 tty=pts0 ses=2 comm="test_verifier" exe="/root/bpf-next/tools/testing/selftests/bpf/test_verifier" subj=unconfined_u:unconfined_r:unconfined_t:s0-s0:c0.c1023 key=(null)
>    type=UNKNOWN[1334] msg=audit(1574271951.590:8974): auid=0 uid=0 gid=0 ses=2 subj=unconfined_u:unconfined_r:unconfined_t:s0-s0:c0.c1023 pid=949 comm="test_verifier" exe="/root/bpf-next/tools/testing/selftests/bpf/test_verifier" prog-id=3260 event=LOAD
>    ----
>    time->Wed Nov 20 12:45:51 2019
> type=UNKNOWN[1334] msg=audit(1574271951.590:8975): prog-id=3260 event=UNLOAD
>    ----
>    [...]
> 
> Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
> Signed-off-by: Jiri Olsa <jolsa@kernel.org>

LGTM, thanks for the rebase!
