Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E0A136753F
	for <lists+netdev@lfdr.de>; Thu, 22 Apr 2021 00:42:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343580AbhDUWmR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Apr 2021 18:42:17 -0400
Received: from www62.your-server.de ([213.133.104.62]:42730 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229706AbhDUWmQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Apr 2021 18:42:16 -0400
Received: from sslproxy01.your-server.de ([78.46.139.224])
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1lZLXP-000Cs0-2c; Thu, 22 Apr 2021 00:41:39 +0200
Received: from [85.7.101.30] (helo=linux.home)
        by sslproxy01.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1lZLXO-0001R9-Oa; Thu, 22 Apr 2021 00:41:38 +0200
Subject: Re: [PATCH bpf-next v3 3/3] libbpf: add selftests for TC-BPF API
To:     =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Networking <netdev@vger.kernel.org>
References: <20210420193740.124285-1-memxor@gmail.com>
 <20210420193740.124285-4-memxor@gmail.com>
 <CAEf4BzbQjWkVM-dy+ebSKzgO89_W9vMGz_ZYicXCfp5XD_d_1g@mail.gmail.com>
 <20210421195643.tduqyyfr5xubxfgn@apollo> <87o8e7gypg.fsf@toke.dk>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <67563477-49b4-a475-7002-a27f30c1d3e4@iogearbox.net>
Date:   Thu, 22 Apr 2021 00:41:38 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <87o8e7gypg.fsf@toke.dk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.4/26147/Wed Apr 21 13:06:05 2021)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/21/21 10:38 PM, Toke Høiland-Jørgensen wrote:
> Kumar Kartikeya Dwivedi <memxor@gmail.com> writes:
> 
>> On Wed, Apr 21, 2021 at 11:54:18PM IST, Andrii Nakryiko wrote:
>>> On Tue, Apr 20, 2021 at 12:37 PM Kumar Kartikeya Dwivedi
>>> <memxor@gmail.com> wrote:
>>>>
>>>> This adds some basic tests for the low level bpf_tc_* API.
>>>>
>>>> Reviewed-by: Toke Høiland-Jørgensen <toke@redhat.com>
>>>> Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
>>>> ---
>>>>   .../selftests/bpf/prog_tests/test_tc_bpf.c    | 169 ++++++++++++++++++
>>>>   .../selftests/bpf/progs/test_tc_bpf_kern.c    |  12 ++
>>>>   2 files changed, 181 insertions(+)
>>>>   create mode 100644 tools/testing/selftests/bpf/prog_tests/test_tc_bpf.c
>>>
>>> we normally don't call prog_test's files with "test_" prefix, it can
>>> be just tc_bpf.c (or just tc.c)
>>>
>>
>> Ok, will rename.
>>
>>>>   create mode 100644 tools/testing/selftests/bpf/progs/test_tc_bpf_kern.c
>>>
>>> we also don't typically call BPF source code files with _kern suffix,
>>> just test_tc_bpf.c would be more in line with most common case
>>>
>>
>> Will rename.
>>
>>>>
>>>> diff --git a/tools/testing/selftests/bpf/prog_tests/test_tc_bpf.c b/tools/testing/selftests/bpf/prog_tests/test_tc_bpf.c
>>>> new file mode 100644
>>>> index 000000000000..563a3944553c
>>>> --- /dev/null
>>>> +++ b/tools/testing/selftests/bpf/prog_tests/test_tc_bpf.c
>>>> @@ -0,0 +1,169 @@
>>>> +// SPDX-License-Identifier: GPL-2.0
>>>> +
>>>> +#include <linux/bpf.h>
>>>> +#include <linux/err.h>
>>>> +#include <linux/limits.h>
>>>> +#include <bpf/libbpf.h>
>>>> +#include <errno.h>
>>>> +#include <stdio.h>
>>>> +#include <stdlib.h>
>>>> +#include <test_progs.h>
>>>> +#include <linux/if_ether.h>
>>>> +
>>>> +#define LO_IFINDEX 1
>>>> +
>>>> +static int test_tc_internal(int fd, __u32 parent_id)
>>>> +{
>>>> +       DECLARE_LIBBPF_OPTS(bpf_tc_opts, opts, .handle = 1, .priority = 10,
>>>> +                           .class_id = TC_H_MAKE(1UL << 16, 1));
>>>> +       struct bpf_tc_attach_id id = {};
>>>> +       struct bpf_tc_info info = {};
>>>> +       int ret;
>>>> +
>>>> +       ret = bpf_tc_attach(fd, LO_IFINDEX, parent_id, &opts, &id);
>>>> +       if (!ASSERT_EQ(ret, 0, "bpf_tc_attach"))
>>>> +               return ret;
>>>> +
>>>> +       ret = bpf_tc_get_info(LO_IFINDEX, parent_id, &id, &info);
>>>> +       if (!ASSERT_EQ(ret, 0, "bpf_tc_get_info"))
>>>> +               goto end;
>>>> +
>>>> +       if (!ASSERT_EQ(info.id.handle, id.handle, "handle mismatch") ||
>>>> +           !ASSERT_EQ(info.id.priority, id.priority, "priority mismatch") ||
>>>> +           !ASSERT_EQ(info.id.handle, 1, "handle incorrect") ||
>>>> +           !ASSERT_EQ(info.chain_index, 0, "chain_index incorrect") ||
>>>> +           !ASSERT_EQ(info.id.priority, 10, "priority incorrect") ||
>>>> +           !ASSERT_EQ(info.class_id, TC_H_MAKE(1UL << 16, 1),
>>>> +                      "class_id incorrect") ||
>>>> +           !ASSERT_EQ(info.protocol, ETH_P_ALL, "protocol incorrect"))
>>>> +               goto end;
>>>> +
>>>> +       opts.replace = true;
>>>> +       ret = bpf_tc_attach(fd, LO_IFINDEX, parent_id, &opts, &id);
>>>> +       if (!ASSERT_EQ(ret, 0, "bpf_tc_attach in replace mode"))
>>>> +               return ret;
>>>> +
>>>> +       /* Demonstrate changing attributes */
>>>> +       opts.class_id = TC_H_MAKE(1UL << 16, 2);
>>>> +
>>>> +       ret = bpf_tc_attach(fd, LO_IFINDEX, parent_id, &opts, &id);
>>>> +       if (!ASSERT_EQ(ret, 0, "bpf_tc attach in replace mode"))
>>>> +               goto end;
>>>> +
>>>> +       ret = bpf_tc_get_info(LO_IFINDEX, parent_id, &id, &info);
>>>> +       if (!ASSERT_EQ(ret, 0, "bpf_tc_get_info"))
>>>> +               goto end;
>>>> +
>>>> +       if (!ASSERT_EQ(info.class_id, TC_H_MAKE(1UL << 16, 2),
>>>> +                      "class_id incorrect after replace"))
>>>> +               goto end;
>>>> +       if (!ASSERT_EQ(info.bpf_flags & TCA_BPF_FLAG_ACT_DIRECT, 1,
>>>> +                      "direct action mode not set"))
>>>> +               goto end;
>>>> +
>>>> +end:
>>>> +       ret = bpf_tc_detach(LO_IFINDEX, parent_id, &id);
>>>> +       ASSERT_EQ(ret, 0, "detach failed");
>>>> +       return ret;
>>>> +}
>>>> +
>>>> +int test_tc_info(int fd)
>>>> +{
>>>> +       DECLARE_LIBBPF_OPTS(bpf_tc_opts, opts, .handle = 1, .priority = 10,
>>>> +                           .class_id = TC_H_MAKE(1UL << 16, 1));
>>>> +       struct bpf_tc_attach_id id = {}, old;
>>>> +       struct bpf_tc_info info = {};
>>>> +       int ret;
>>>> +
>>>> +       ret = bpf_tc_attach(fd, LO_IFINDEX, BPF_TC_CLSACT_INGRESS, &opts, &id);
>>>> +       if (!ASSERT_EQ(ret, 0, "bpf_tc_attach"))
>>>> +               return ret;
>>>> +       old = id;
>>>> +
>>>> +       ret = bpf_tc_get_info(LO_IFINDEX, BPF_TC_CLSACT_INGRESS, &id, &info);
>>>> +       if (!ASSERT_EQ(ret, 0, "bpf_tc_get_info"))
>>>> +               goto end_old;
>>>> +
>>>> +       if (!ASSERT_EQ(info.id.handle, id.handle, "handle mismatch") ||
>>>> +           !ASSERT_EQ(info.id.priority, id.priority, "priority mismatch") ||
>>>> +           !ASSERT_EQ(info.id.handle, 1, "handle incorrect") ||
>>>> +           !ASSERT_EQ(info.chain_index, 0, "chain_index incorrect") ||
>>>> +           !ASSERT_EQ(info.id.priority, 10, "priority incorrect") ||
>>>> +           !ASSERT_EQ(info.class_id, TC_H_MAKE(1UL << 16, 1),
>>>> +                      "class_id incorrect") ||
>>>> +           !ASSERT_EQ(info.protocol, ETH_P_ALL, "protocol incorrect"))
>>>> +               goto end_old;
>>>> +
>>>> +       /* choose a priority */
>>>> +       opts.priority = 0;
>>>> +       ret = bpf_tc_attach(fd, LO_IFINDEX, BPF_TC_CLSACT_INGRESS, &opts, &id);
>>>> +       if (!ASSERT_EQ(ret, 0, "bpf_tc_attach"))
>>>> +               goto end_old;
>>>> +
>>>> +       ret = bpf_tc_get_info(LO_IFINDEX, BPF_TC_CLSACT_INGRESS, &id, &info);
>>>> +       if (!ASSERT_EQ(ret, 0, "bpf_tc_get_info"))
>>>> +               goto end;
>>>> +
>>>> +       if (!ASSERT_NEQ(id.priority, old.priority, "filter priority mismatch"))
>>>> +               goto end;
>>>> +       if (!ASSERT_EQ(info.id.priority, id.priority, "priority mismatch"))
>>>> +               goto end;
>>>> +
>>>> +end:
>>>> +       ret = bpf_tc_detach(LO_IFINDEX, BPF_TC_CLSACT_INGRESS, &id);
>>>> +       ASSERT_EQ(ret, 0, "detach failed");
>>>> +end_old:
>>>> +       ret = bpf_tc_detach(LO_IFINDEX, BPF_TC_CLSACT_INGRESS, &old);
>>>> +       ASSERT_EQ(ret, 0, "detach failed");
>>>> +       return ret;
>>>> +}
>>>> +
>>>> +void test_test_tc_bpf(void)
>>>
>>> test_test_ tautology, drop one test?
>>>
>>
>> Ok.
>>
>>>> +{
>>>> +       const char *file = "./test_tc_bpf_kern.o";
>>>
>>> please use BPF skeleton instead, see lots of other selftests doing
>>> that already. You won't even need find_program_by_{name,title}, among
>>> other things.
>>>
>>
>> Sounds good, will change.
>>
>>>> +       struct bpf_program *clsp;
>>>> +       struct bpf_object *obj;
>>>> +       int cls_fd, ret;
>>>> +
>>>> +       obj = bpf_object__open(file);
>>>> +       if (!ASSERT_OK_PTR(obj, "bpf_object__open"))
>>>> +               return;
>>>> +
>>>> +       clsp = bpf_object__find_program_by_title(obj, "classifier");
>>>> +       if (!ASSERT_OK_PTR(clsp, "bpf_object__find_program_by_title"))
>>>> +               goto end;
>>>> +
>>>> +       ret = bpf_object__load(obj);
>>>> +       if (!ASSERT_EQ(ret, 0, "bpf_object__load"))
>>>> +               goto end;
>>>> +
>>>> +       cls_fd = bpf_program__fd(clsp);
>>>> +
>>>> +       system("tc qdisc del dev lo clsact");
>>>
>>> can this fail? also why is this necessary? it's still not possible to
>>
>> This is just removing any existing clsact qdisc since it will be setup by the
>> attach call, which is again removed later (where we do check if it fails, if it
>> does clsact qdisc was not setup, and something was wrong in that it returned 0
>> when the attach point was one of the clsact hooks).
>>
>> We don't care about failure initially, since if it isn't present we'd just move
>> on to running the test.
>>
>>> do anything with only libbpf APIs?
>>
>> I don't think so, I can do the qdisc teardown using netlink in the selftest,
>> but that would mean duplicating a lot of code. I think expecting tc to be
>> present on the system is a reasonable assumption for this test.
> 
> So this stems from the fact that bpf_tc_detach() doesn't clean up the
> clsact qdisc that is added by bpf_tc_attach(). I think we should fix
> this.

I was wondering whether it would make sense to add a bpf_tc_ctx_init() and
bpf_tc_ctx_destroy() API which would auto-create the sch_clsact qdisc, plus
provide a 'handle' for bpf_tc_attach() and bpf_tc_detach(), and for the other
one, it would delete the qdisc. Otoh, if an empty sch_clsact obj is sitting
around while not being great (given minor effect on fast-path), it also doesn't
harm /overly/ much. Maybe a /poor/ analogy could be that if you open a v6 socket,
it pulls in the ipv6 module, but also doesn't remove it when you close() it.
Anyway, but for the test itself, given you can define prio etc, I don't think
it would even need the system() call?

Thanks,
Daniel
