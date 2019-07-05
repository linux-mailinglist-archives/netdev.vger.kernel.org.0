Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 43BB460CAD
	for <lists+netdev@lfdr.de>; Fri,  5 Jul 2019 22:46:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728115AbfGEUq0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Jul 2019 16:46:26 -0400
Received: from www62.your-server.de ([213.133.104.62]:36474 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726411AbfGEUqZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Jul 2019 16:46:25 -0400
Received: from [78.46.172.2] (helo=sslproxy05.your-server.de)
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1hjV66-0006ep-Db; Fri, 05 Jul 2019 22:46:22 +0200
Received: from [178.193.45.231] (helo=linux.home)
        by sslproxy05.your-server.de with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89)
        (envelope-from <daniel@iogearbox.net>)
        id 1hjV66-000BtR-7X; Fri, 05 Jul 2019 22:46:22 +0200
Subject: Re: [PATCH v5 bpf-next 4/9] libbpf: add kprobe/uprobe attach API
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Kernel Team <kernel-team@fb.com>, Yonghong Song <yhs@fb.com>
References: <20190701235903.660141-1-andriin@fb.com>
 <20190701235903.660141-5-andriin@fb.com>
 <5e494d84-5db9-3d57-ccb3-c619cbae7833@iogearbox.net>
 <CAEf4BzaHM5432VS-1wDxKJXr7U-9zkM+A_XsU+1p77YCd8VRgg@mail.gmail.com>
 <CAEf4BzaUeLDgwzBc0EbXnzahe8wxf9CNVFa_isgRp8rwJ0OSjQ@mail.gmail.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <a24b3328-2d4a-17f2-3aa3-756af7432e6b@iogearbox.net>
Date:   Fri, 5 Jul 2019 22:46:21 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.3.0
MIME-Version: 1.0
In-Reply-To: <CAEf4BzaUeLDgwzBc0EbXnzahe8wxf9CNVFa_isgRp8rwJ0OSjQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.100.3/25501/Fri Jul  5 10:01:52 2019)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 07/04/2019 02:57 AM, Andrii Nakryiko wrote:
> On Wed, Jul 3, 2019 at 9:47 AM Andrii Nakryiko
> <andrii.nakryiko@gmail.com> wrote:
[...]
>>   [1] https://lore.kernel.org/bpf/20190621045555.4152743-4-andriin@fb.com/T/#m6cfc141e7b57970bc948134bf671a46972b95134
>>
>>> with bpf_link with destructor looks good to me, but my feedback from back then was
>>> that all the kprobe/uprobe/tracepoint/raw_tracepoint should be split API-wise, so
>>> you'll end up with something like the below, that is, 1) a set of functions that
>>> only /create/ the bpf_link handle /once/, and 2) a helper that allows /attaching/
>>> progs to one or multiple bpf_links. The set of APIs would look like:
>>>
>>> struct bpf_link *bpf_link__create_kprobe(bool retprobe, const char *func_name);
>>> struct bpf_link *bpf_link__create_uprobe(bool retprobe, pid_t pid,
>>>                                          const char *binary_path,
>>>                                          size_t func_offset);
>>> int bpf_program__attach_to_link(struct bpf_link *link, struct bpf_program *prog);
>>> int bpf_link__destroy(struct bpf_link *link);
>>>
>>> This seems much more natural to me. Right now you sort of do both in one single API.
>>
>> It felt that way for me as well, until I implemented it and used it in
>> selftests. And then it felt unnecessarily verbose without giving any
>> benefit. I still have a local patchset with that change, I can post it
>> as RFC, if you don't trust my judgement. Please let me know.
>>
>>> Detangling the bpf_program__attach_{uprobe,kprobe}() would also avoid that you have
>>> to redo all the perf_event_open_probe() work over and over in order to get the pfd
> 
> So re-reading this again, I wonder if you meant that with separate
> bpf_link (or rather bpf_hook in that case) creation and attachment
> operations, one would be able to create single bpf_hook for same
> kprobe and then attach multiple BPF programs to that single pfd
> representing that specific probe.
> 
> If that's how I should have read it, I agree that it probably would be
> possible for some types of hooks, but not for every type of hook. But
> furthermore, how often in practice same application attaches many
> different BPF programs to the same hook? And it's also hard to imagine
> that hook creation (i.e., creating such FD for BPF hook), would ever
> be a bottleneck.
> 
> So I still think it's not a strong reason to go with API that's harder
> to use for typical use cases just because of hypothetical benefits in
> some extreme cases.

Was thinking along that lines, yes, as we run over an array of BPF progs,
but I just double checked the kernel code again and the relationship of
a BPF prog to perf_event is really just 1:1, just that the backing tp_event
(trace_event_call) contains the shared array. Given that, all makes sense
and there is no point in splitting. Therefore, applied, thanks!
