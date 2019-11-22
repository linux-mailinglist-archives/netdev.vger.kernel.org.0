Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 20171105DA5
	for <lists+netdev@lfdr.de>; Fri, 22 Nov 2019 01:25:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726500AbfKVAZg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Nov 2019 19:25:36 -0500
Received: from www62.your-server.de ([213.133.104.62]:34764 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726038AbfKVAZg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Nov 2019 19:25:36 -0500
Received: from sslproxy01.your-server.de ([88.198.220.130])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1iXwlN-0007NS-8Q; Fri, 22 Nov 2019 01:25:29 +0100
Received: from [178.197.248.30] (helo=pc-9.home)
        by sslproxy01.your-server.de with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89)
        (envelope-from <daniel@iogearbox.net>)
        id 1iXwlM-0002Tj-LF; Fri, 22 Nov 2019 01:25:28 +0100
Subject: Re: [PATCH] bpf: emit audit messages upon successful prog load and
 unload
To:     Paul Moore <paul@paul-moore.com>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        linux-audit@redhat.com, Jiri Olsa <jolsa@kernel.org>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, Andrii Nakryiko <andriin@fb.com>,
        Yonghong Song <yhs@fb.com>, Martin KaFai Lau <kafai@fb.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Steve Grubb <sgrubb@redhat.com>,
        David Miller <davem@redhat.com>,
        Eric Paris <eparis@redhat.com>, Jiri Benc <jbenc@redhat.com>
References: <20191120213816.8186-1-jolsa@kernel.org>
 <8c928ec4-9e43-3e2a-7005-21f40fcca061@iogearbox.net>
 <CAADnVQKu-ZgFTaSMH=Q-jMOYYvE32TF2b2hq1=dmDV8wAf18pg@mail.gmail.com>
 <CAHC9VhQbQoXacbTCNJPGNzFOv30PwLeiWu4ROQFU46=saTeTNQ@mail.gmail.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <b8a79ac0-a7d3-8d7b-1e31-33f477b30503@iogearbox.net>
Date:   Fri, 22 Nov 2019 01:25:27 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <CAHC9VhQbQoXacbTCNJPGNzFOv30PwLeiWu4ROQFU46=saTeTNQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.101.4/25640/Thu Nov 21 11:08:44 2019)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/22/19 12:41 AM, Paul Moore wrote:
> On Wed, Nov 20, 2019 at 4:49 PM Alexei Starovoitov
> <alexei.starovoitov@gmail.com> wrote:
>> On Wed, Nov 20, 2019 at 1:46 PM Daniel Borkmann <daniel@iogearbox.net> wrote:
>>> On 11/20/19 10:38 PM, Jiri Olsa wrote:
>>>> From: Daniel Borkmann <daniel@iogearbox.net>
>>>>
>>>> Allow for audit messages to be emitted upon BPF program load and
>>>> unload for having a timeline of events. The load itself is in
>>>> syscall context, so additional info about the process initiating
>>>> the BPF prog creation can be logged and later directly correlated
>>>> to the unload event.
>>>>
>>>> The only info really needed from BPF side is the globally unique
>>>> prog ID where then audit user space tooling can query / dump all
>>>> info needed about the specific BPF program right upon load event
>>>> and enrich the record, thus these changes needed here can be kept
>>>> small and non-intrusive to the core.
>>>>
>>>> Raw example output:
>>>>
>>>>     # auditctl -D
>>>>     # auditctl -a always,exit -F arch=x86_64 -S bpf
>>>>     # ausearch --start recent -m 1334
>>>>     [...]
>>>>     ----
>>>>     time->Wed Nov 20 12:45:51 2019
>>>>     type=PROCTITLE msg=audit(1574271951.590:8974): proctitle="./test_verifier"
>>>>     type=SYSCALL msg=audit(1574271951.590:8974): arch=c000003e syscall=321 success=yes exit=14 a0=5 a1=7ffe2d923e80 a2=78 a3=0 items=0 ppid=742 pid=949 auid=0 uid=0 gid=0 euid=0 suid=0 fsuid=0 egid=0 sgid=0 fsgid=0 tty=pts0 ses=2 comm="test_verifier" exe="/root/bpf-next/tools/testing/selftests/bpf/test_verifier" subj=unconfined_u:unconfined_r:unconfined_t:s0-s0:c0.c1023 key=(null)
>>>>     type=UNKNOWN[1334] msg=audit(1574271951.590:8974): auid=0 uid=0 gid=0 ses=2 subj=unconfined_u:unconfined_r:unconfined_t:s0-s0:c0.c1023 pid=949 comm="test_verifier" exe="/root/bpf-next/tools/testing/selftests/bpf/test_verifier" prog-id=3260 event=LOAD
>>>>     ----
>>>>     time->Wed Nov 20 12:45:51 2019
>>>> type=UNKNOWN[1334] msg=audit(1574271951.590:8975): prog-id=3260 event=UNLOAD
>>>>     ----
>>>>     [...]
>>>>
>>>> Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
>>>> Signed-off-by: Jiri Olsa <jolsa@kernel.org>
>>>
>>> LGTM, thanks for the rebase!
>>
>> Applied to bpf-next. Thanks!
> 
> [NOTE: added linux-audit to the To/CC line]
> 
> Wait a minute, why was the linux-audit list not CC'd on this?  Why are
> you merging a patch into -next that adds to the uapi definition *and*
> creates a new audit record while we are at -rc8?
> 
> Aside from that I'm concerned that you are relying on audit userspace
> changes that might not be okay; I see the PR below, but I don't see
> any comment on it from Steve (it is his audit userspace).  I also
> don't see a corresponding test added to the audit-testsuite, which is
> a common requirement for new audit functionality (link below).  I'm
> also fairly certain we don't want this new BPF record to look like how
> you've coded it up in bpf_audit_prog(); duplicating the fields with
> audit_log_task() is wrong, you've either already got them via an
> associated record (which you get from passing non-NULL as the first
> parameter to audit_log_start()), or you don't because there is no
> associated syscall/task (which you get from passing NULL as the first
> parameter).  Please revert, un-merge, etc. this patch from bpf-next;
> it should not go into Linus' tree as written.

Fair enough, up to you guys. My impression was that this is mainly coming
from RHEL use case [0] and given that the original patch was back in Oct
2018 [1] that you've sorted it out by now RH internally and agreed to proceed
with this patch for BPF given the rebase + resend ... seems not then. :(

The audit-userspace PR below is sitting there since August this year but
its for the perf event based approach and my understanding from Plumbers
conf was that the internal discussion was that a native integration was
needed hence the proposed resend now.

Given the change is mostly trivial, are there any major objections for Jiri
to follow-up? Otherwise worst case probably easier to revert in net-next.

> Audit userspace PR:
> * https://github.com/linux-audit/audit-userspace/pull/104
> 
> Audit test suite:
> * https://github.com/linux-audit/audit-testsuite
> 
> Audit folks, here is a link to the thread in the archives:
> * https://lore.kernel.org/bpf/20191120213816.8186-1-jolsa@kernel.org/T/#u

Thanks,
Daniel

   [0] slide 11, https://linuxplumbersconf.org/event/4/contributions/460/attachments/244/426/xdp-distro-view.pdf
   [1] https://lore.kernel.org/netdev/20181004135038.2876-1-daniel@iogearbox.net/
