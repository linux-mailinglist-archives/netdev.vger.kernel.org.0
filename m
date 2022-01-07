Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 766D848754F
	for <lists+netdev@lfdr.de>; Fri,  7 Jan 2022 11:15:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346594AbiAGKPA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Jan 2022 05:15:00 -0500
Received: from www62.your-server.de ([213.133.104.62]:40170 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236825AbiAGKO7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Jan 2022 05:14:59 -0500
Received: from sslproxy02.your-server.de ([78.47.166.47])
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1n5mGq-000BB7-92; Fri, 07 Jan 2022 11:14:52 +0100
Received: from [85.1.206.226] (helo=linux.home)
        by sslproxy02.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1n5mGp-000Fdg-UZ; Fri, 07 Jan 2022 11:14:51 +0100
Subject: Re: [PATCH] bpf: allow setting mount device for bpffs
To:     Yafang Shao <laoar.shao@gmail.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>, Martin Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        john fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, netdev <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, David Howells <dhowells@redhat.com>,
        Al Viro <viro@zeniv.linux.org.uk>, christian.brauner@ubuntu.com
References: <20211226165649.7178-1-laoar.shao@gmail.com>
 <616eab60-0f56-7309-4f0f-c0f96719b688@iogearbox.net>
 <CALOAHbBi4HYUd+AD+F8DrCUPrh8-E3HJC=RPMTw3dNLKHAHczg@mail.gmail.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <e3598aba-490f-95a9-f92d-52cf83175d42@iogearbox.net>
Date:   Fri, 7 Jan 2022 11:14:51 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <CALOAHbBi4HYUd+AD+F8DrCUPrh8-E3HJC=RPMTw3dNLKHAHczg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.3/26415/Fri Jan  7 10:26:59 2022)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/7/22 6:48 AM, Yafang Shao wrote:
> On Wed, Jan 5, 2022 at 9:24 PM Daniel Borkmann <daniel@iogearbox.net> wrote:
>> On 12/26/21 5:56 PM, Yafang Shao wrote:
>>> We noticed our tc ebpf tools can't start after we upgrade our in-house
>>> kernel version from 4.19 to 5.10. That is because of the behaviour change
>>> in bpffs caused by commit
>>> d2935de7e4fd ("vfs: Convert bpf to use the new mount API").
>>>
>>> In our tc ebpf tools, we do strict environment check. If the enrioment is
>>> not match, we won't allow to start the ebpf progs. One of the check is
>>> whether bpffs is properly mounted. The mount information of bpffs in
>>> kernel-4.19 and kernel-5.10 are as follows,
>>>
>>> - kenrel 4.19
>>> $ mount -t bpf bpffs /sys/fs/bpf
>>> $ mount -t bpf
>>> bpffs on /sys/fs/bpf type bpf (rw,relatime)
>>>
>>> - kernel 5.10
>>> $ mount -t bpf bpffs /sys/fs/bpf
>>> $ mount -t bpf
>>> none on /sys/fs/bpf type bpf (rw,relatime)
>>>
>>> The device name in kernel-5.10 is displayed as none instead of bpffs,
>>> then our environment check fails. Currently we modify the tools to adopt to
>>> the kernel behaviour change, but I think we'd better change the kernel code
>>> to keep the behavior consistent.
>>>
>>> After this change, the mount information will be displayed the same with
>>> the behavior in kernel-4.19, for example,
>>>
>>> $ mount -t bpf bpffs /sys/fs/bpf
>>> $ mount -t bpf
>>> bpffs on /sys/fs/bpf type bpf (rw,relatime)
>>>
>>> Fixes: d2935de7e4fd ("vfs: Convert bpf to use the new mount API")
>>> Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
>>> Cc: David Howells <dhowells@redhat.com>
>>> ---
>>>    kernel/bpf/inode.c | 18 ++++++++++++++++--
>>>    1 file changed, 16 insertions(+), 2 deletions(-)
>>>
>>> diff --git a/kernel/bpf/inode.c b/kernel/bpf/inode.c
>>> index 80da1db47c68..5a8b729afa91 100644
>>> --- a/kernel/bpf/inode.c
>>> +++ b/kernel/bpf/inode.c
>>> @@ -648,12 +648,26 @@ static int bpf_parse_param(struct fs_context *fc, struct fs_parameter *param)
>>>        int opt;
>>>
>>>        opt = fs_parse(fc, bpf_fs_parameters, param, &result);
>>> -     if (opt < 0)
>>> +     if (opt < 0) {
>>>                /* We might like to report bad mount options here, but
>>>                 * traditionally we've ignored all mount options, so we'd
>>>                 * better continue to ignore non-existing options for bpf.
>>>                 */
>>> -             return opt == -ENOPARAM ? 0 : opt;
>>> +             if (opt == -ENOPARAM) {
>>> +                     if (strcmp(param->key, "source") == 0) {
>>> +                             if (param->type != fs_value_is_string)
>>> +                                     return 0;
>>> +                             if (fc->source)
>>> +                                     return 0;
>>> +                             fc->source = param->string;
>>> +                             param->string = NULL;
>>> +                     }
>>> +
>>> +                     return 0;
>>> +             }
>>> +
>>> +             return opt;
>>> +     }
>>
>> I don't think we need to open code this? Couldn't we just do something like:
>>
>>           [...]
>>
>>           opt = fs_parse(fc, bpf_fs_parameters, param, &result);
>>           if (opt == -ENOPARAM) {
>>                   opt = vfs_parse_fs_param_source(fc, param);
>>                   if (opt != -ENOPARAM)
>>                           return opt;
>>                   return 0;
>>           }
>>           if (opt < 0)
>>                   return opt;
>>
>>           [...]
>>
>> See also 0858d7da8a09 ("ramfs: fix mount source show for ramfs") where they
>> had a similar issue.
> 
> Thanks for the suggestion. I will update it.

Sounds good, thanks!

> nit:  vfs_parse_fs_param_source() is introduced in commit d1d488d81370
> ("fs: add vfs_parse_fs_param_source() helper"), so the updated one
> can't be directly backported to 5.10.

Right, so for stable trees that don't have this commit, you could use your
patch here if needed. But for upstream, lets not open code it given we have
the helper for it.

Thanks,
Daniel
