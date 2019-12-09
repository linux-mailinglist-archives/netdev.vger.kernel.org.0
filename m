Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D903E117B5F
	for <lists+netdev@lfdr.de>; Tue, 10 Dec 2019 00:19:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727202AbfLIXT5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Dec 2019 18:19:57 -0500
Received: from www62.your-server.de ([213.133.104.62]:47252 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726592AbfLIXT5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Dec 2019 18:19:57 -0500
Received: from sslproxy02.your-server.de ([78.47.166.47])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1ieSJl-0007I5-PL; Tue, 10 Dec 2019 00:19:53 +0100
Received: from [178.197.249.52] (helo=pc-9.home)
        by sslproxy02.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1ieSJl-000NZ5-8y; Tue, 10 Dec 2019 00:19:53 +0100
Subject: Re: [PATCHv3] bpf: Emit audit messages upon successful prog load and
 unload
To:     Paul Moore <paul@paul-moore.com>
Cc:     Jiri Olsa <jolsa@kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-audit@redhat.com, Andrii Nakryiko <andriin@fb.com>,
        Yonghong Song <yhs@fb.com>, Martin KaFai Lau <kafai@fb.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Steve Grubb <sgrubb@redhat.com>,
        David Miller <davem@redhat.com>,
        Eric Paris <eparis@redhat.com>, Jiri Benc <jbenc@redhat.com>
References: <20191206214934.11319-1-jolsa@kernel.org>
 <20191209121537.GA14170@linux.fritz.box>
 <CAHC9VhQdOGTj1HT1cwvAdE1sRpzk5mC+oHQLHgJFa3vXEij+og@mail.gmail.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <d387184e-9c5f-d5b2-0acb-57b794235cbd@iogearbox.net>
Date:   Tue, 10 Dec 2019 00:19:51 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <CAHC9VhQdOGTj1HT1cwvAdE1sRpzk5mC+oHQLHgJFa3vXEij+og@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.101.4/25658/Mon Dec  9 10:47:26 2019)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/9/19 3:56 PM, Paul Moore wrote:
> On Mon, Dec 9, 2019 at 7:15 AM Daniel Borkmann <daniel@iogearbox.net> wrote:
>> On Fri, Dec 06, 2019 at 10:49:34PM +0100, Jiri Olsa wrote:
>>> From: Daniel Borkmann <daniel@iogearbox.net>
>>>
>>> Allow for audit messages to be emitted upon BPF program load and
>>> unload for having a timeline of events. The load itself is in
>>> syscall context, so additional info about the process initiating
>>> the BPF prog creation can be logged and later directly correlated
>>> to the unload event.
>>>
>>> The only info really needed from BPF side is the globally unique
>>> prog ID where then audit user space tooling can query / dump all
>>> info needed about the specific BPF program right upon load event
>>> and enrich the record, thus these changes needed here can be kept
>>> small and non-intrusive to the core.
>>>
>>> Raw example output:
>>>
>>>    # auditctl -D
>>>    # auditctl -a always,exit -F arch=x86_64 -S bpf
>>>    # ausearch --start recent -m 1334
>>>    ...
>>>    ----
>>>    time->Wed Nov 27 16:04:13 2019
>>>    type=PROCTITLE msg=audit(1574867053.120:84664): proctitle="./bpf"
>>>    type=SYSCALL msg=audit(1574867053.120:84664): arch=c000003e syscall=321   \
>>>      success=yes exit=3 a0=5 a1=7ffea484fbe0 a2=70 a3=0 items=0 ppid=7477    \
>>>      pid=12698 auid=1001 uid=1001 gid=1001 euid=1001 suid=1001 fsuid=1001    \
>>>      egid=1001 sgid=1001 fsgid=1001 tty=pts2 ses=4 comm="bpf"                \
>>>      exe="/home/jolsa/auditd/audit-testsuite/tests/bpf/bpf"                  \
>>>      subj=unconfined_u:unconfined_r:unconfined_t:s0-s0:c0.c1023 key=(null)
>>>    type=UNKNOWN[1334] msg=audit(1574867053.120:84664): prog-id=76 op=LOAD
>>>    ----
>>>    time->Wed Nov 27 16:04:13 2019
>>>    type=UNKNOWN[1334] msg=audit(1574867053.120:84665): prog-id=76 op=UNLOAD
>>>    ...
>>>
>>> Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
>>> Co-developed-by: Jiri Olsa <jolsa@kernel.org>
>>> Signed-off-by: Jiri Olsa <jolsa@kernel.org>
>>
>> Paul, Steve, given the merge window is closed by now, does this version look
>> okay to you for proceeding to merge into bpf-next?
> 
> Given the change to audit UAPI I was hoping to merge this via the
> audit/next tree, is that okay with you?

Hm, my main concern is that given all the main changes are in BPF core and
usually the BPF subsystem has plenty of changes per release coming in that we'd
end up generating unnecessary merge conflicts. Given the include/uapi/linux/audit.h
UAPI diff is a one-line change, my preference would be to merge via bpf-next with
your ACK or SOB added. Does that work for you as well as?

Thanks,
Daniel
