Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 035D01924BF
	for <lists+netdev@lfdr.de>; Wed, 25 Mar 2020 10:54:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727578AbgCYJy2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Mar 2020 05:54:28 -0400
Received: from www62.your-server.de ([213.133.104.62]:36544 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726225AbgCYJyZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Mar 2020 05:54:25 -0400
Received: from sslproxy05.your-server.de ([78.46.172.2])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1jH2jq-0000bX-Uw; Wed, 25 Mar 2020 10:54:18 +0100
Received: from [85.7.42.192] (helo=pc-9.home)
        by sslproxy05.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1jH2jq-000Erx-L4; Wed, 25 Mar 2020 10:54:18 +0100
Subject: Re: [PATCH bpf-next] libbpf: don't allocate 16M for log buffer by
 default
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Stanislav Fomichev <sdf@fomichev.me>
Cc:     Stanislav Fomichev <sdf@google.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>
References: <20200324233120.66314-1-sdf@google.com>
 <CAEf4BzbFOjSDw9YvsoZGtzWVbZykg62atNAgzt19audTXmvprw@mail.gmail.com>
 <20200324235938.GA2805006@mini-arch.hsd1.ca.comcast.net>
 <CAEf4BzbF+QmKAmkhrNMn2EEo0nPMmyb0T=BwLvDm+KFE1ZrhrA@mail.gmail.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <e4ea4eef-c889-b007-31ea-27c8d57e7115@iogearbox.net>
Date:   Wed, 25 Mar 2020 10:54:18 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <CAEf4BzbF+QmKAmkhrNMn2EEo0nPMmyb0T=BwLvDm+KFE1ZrhrA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.2/25761/Tue Mar 24 15:55:35 2020)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/25/20 1:08 AM, Andrii Nakryiko wrote:
> On Tue, Mar 24, 2020 at 4:59 PM Stanislav Fomichev <sdf@fomichev.me> wrote:
>> On 03/24, Andrii Nakryiko wrote:
>>> On Tue, Mar 24, 2020 at 4:31 PM Stanislav Fomichev <sdf@google.com> wrote:
>>>>
>>>> For each prog/btf load we allocate and free 16 megs of verifier buffer.
>>>> On production systems it doesn't really make sense because the
>>>> programs/btf have gone through extensive testing and (mostly) guaranteed
>>>> to successfully load.
>>>>
>>>> Let's switch to a much smaller buffer by default (128 bytes, sys_bpf
>>>> doesn't accept smaller log buffer) and resize it if the kernel returns
>>>> ENOSPC. On the first ENOSPC error we resize the buffer to BPF_LOG_BUF_SIZE
>>>> and then, on each subsequent ENOSPC, we keep doubling the buffer.
>>>>
>>>> Signed-off-by: Stanislav Fomichev <sdf@google.com>
>>>> ---
>>>>   tools/lib/bpf/btf.c             | 10 +++++++++-
>>>>   tools/lib/bpf/libbpf.c          | 10 ++++++++--
>>>>   tools/lib/bpf/libbpf_internal.h |  2 ++
>>>>   3 files changed, 19 insertions(+), 3 deletions(-)
>>>>
>>>> diff --git a/tools/lib/bpf/btf.c b/tools/lib/bpf/btf.c
>>>> index 3d1c25fc97ae..53c7efc3b347 100644
>>>> --- a/tools/lib/bpf/btf.c
>>>> +++ b/tools/lib/bpf/btf.c
>>>> @@ -657,13 +657,14 @@ int btf__finalize_data(struct bpf_object *obj, struct btf *btf)
>>>>
>>>>   int btf__load(struct btf *btf)
>>>>   {
>>>> -       __u32 log_buf_size = BPF_LOG_BUF_SIZE;
>>>> +       __u32 log_buf_size = BPF_MIN_LOG_BUF_SIZE;
>>>>          char *log_buf = NULL;
>>>>          int err = 0;
>>>>
>>>>          if (btf->fd >= 0)
>>>>                  return -EEXIST;
>>>>
>>>> +retry_load:
>>>>          log_buf = malloc(log_buf_size);
>>>>          if (!log_buf)
>>>>                  return -ENOMEM;
>>>
>>> I'd argue that on first try we shouldn't allocate log_buf at all, then
>>> start allocating it using reasonable starting size (see below).
>> Agreed, makes sense.

The iproute2 BPF loader does the first try without any log buffer, and then
successively increases the size on failure [0].

libbpf should also assume the success case in the very first run, and only
then redo the load attempt with log buffer to avoid the overhead.

   [0] https://git.kernel.org/pub/scm/network/iproute2/iproute2.git/tree/lib/bpf.c

>>>> @@ -673,6 +674,13 @@ int btf__load(struct btf *btf)
>>>>          btf->fd = bpf_load_btf(btf->data, btf->data_size,
>>>>                                 log_buf, log_buf_size, false);
>>>>          if (btf->fd < 0) {
>>>> +               if (errno == ENOSPC) {
>>>> +                       log_buf_size = max((__u32)BPF_LOG_BUF_SIZE,
>>>> +                                          log_buf_size << 1);
>>>> +                       free(log_buf);
>>>> +                       goto retry_load;
>>>> +               }
>>>> +
>>>>                  err = -errno;
>>>>                  pr_warn("Error loading BTF: %s(%d)\n", strerror(errno), errno);
>>>>                  if (*log_buf)
[...]
>>>> diff --git a/tools/lib/bpf/libbpf_internal.h b/tools/lib/bpf/libbpf_internal.h
>>>> index 8c3afbd97747..2720f3366798 100644
>>>> --- a/tools/lib/bpf/libbpf_internal.h
>>>> +++ b/tools/lib/bpf/libbpf_internal.h
>>>> @@ -23,6 +23,8 @@
>>>>   #define BTF_PARAM_ENC(name, type) (name), (type)
>>>>   #define BTF_VAR_SECINFO_ENC(type, offset, size) (type), (offset), (size)
>>>>
>>>> +#define BPF_MIN_LOG_BUF_SIZE 128
>>>
>>> This seems way too low, if there is some error it almost certainly
>>> will be too short, probably for few iterations, just causing waste.
>>> Let's make it something a bit more reasonable, like 32KB or something?
>> In this case, maybe start with the existing 16M BPF_LOG_BUF_SIZE?
>> My goal here is optimize for the successful case. If there is an error the
>> size shouldn't matter that much.
> 
> Not feeling strongly. But we already will have a retry loop, so not
> too hard to do it in steps. Then also errors do happen in production
> as well, and it would be good to not eat too much memory
> unnecessarily.

Yeah, 128 is way too low. Either we should just malloc the max possible size
right away, or make it a two-step approach where we first try with half the
size and only if that fails we retry with the max size. Given programs can be
very complex this will otherwise just prolong the time unnecessarily for the
failure verdict and unnecessarily puts load on the verifier.

Thanks,
Daniel
