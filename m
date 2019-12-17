Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 48A31122F0D
	for <lists+netdev@lfdr.de>; Tue, 17 Dec 2019 15:43:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728856AbfLQOnD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Dec 2019 09:43:03 -0500
Received: from www62.your-server.de ([213.133.104.62]:42234 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728799AbfLQOnC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Dec 2019 09:43:02 -0500
Received: from sslproxy05.your-server.de ([78.46.172.2])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1ihE3u-0002EC-Vx; Tue, 17 Dec 2019 15:42:59 +0100
Received: from [178.197.249.31] (helo=pc-9.home)
        by sslproxy05.your-server.de with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89)
        (envelope-from <daniel@iogearbox.net>)
        id 1ihE3u-000Brc-JT; Tue, 17 Dec 2019 15:42:58 +0100
Subject: Re: [PATCH v4 bpf-next 2/4] libbpf: support libbpf-provided extern
 variables
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Kernel Team <kernel-team@fb.com>
References: <20191214014710.3449601-1-andriin@fb.com>
 <20191214014710.3449601-3-andriin@fb.com>
 <20191216111736.GA14887@linux.fritz.box>
 <CAEf4Bzbx+2Fot9NYzGJS-pUF5x5zvcfBnb7fcO_s9_gCQQVuLg@mail.gmail.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <7bf339cf-c746-a780-3117-3348fb5997f1@iogearbox.net>
Date:   Tue, 17 Dec 2019 15:42:57 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <CAEf4Bzbx+2Fot9NYzGJS-pUF5x5zvcfBnb7fcO_s9_gCQQVuLg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.101.4/25666/Tue Dec 17 10:54:52 2019)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/16/19 8:29 PM, Andrii Nakryiko wrote:
> On Mon, Dec 16, 2019 at 3:17 AM Daniel Borkmann <daniel@iogearbox.net> wrote:
>> On Fri, Dec 13, 2019 at 05:47:08PM -0800, Andrii Nakryiko wrote:
>>> Add support for extern variables, provided to BPF program by libbpf. Currently
>>> the following extern variables are supported:
>>>    - LINUX_KERNEL_VERSION; version of a kernel in which BPF program is
>>>      executing, follows KERNEL_VERSION() macro convention, can be 4- and 8-byte
>>>      long;
>>>    - CONFIG_xxx values; a set of values of actual kernel config. Tristate,
>>>      boolean, strings, and integer values are supported.
>>>
>> [...]
>>>
>>> All detected extern variables, are put into a separate .extern internal map.
>>> It, similarly to .rodata map, is marked as read-only from BPF program side, as
>>> well as is frozen on load. This allows BPF verifier to track extern values as
>>> constants and perform enhanced branch prediction and dead code elimination.
>>> This can be relied upon for doing kernel version/feature detection and using
>>> potentially unsupported field relocations or BPF helpers in a CO-RE-based BPF
>>> program, while still having a single version of BPF program running on old and
>>> new kernels. Selftests are validating this explicitly for unexisting BPF
>>> helper.
>>>
>>> Signed-off-by: Andrii Nakryiko <andriin@fb.com>
>> [...]
>>> +static int bpf_object__resolve_externs(struct bpf_object *obj,
>>> +                                    const char *config_path)
>>> +{
>>> +     bool need_config = false;
>>> +     struct extern_desc *ext;
>>> +     int err, i;
>>> +     void *data;
>>> +
>>> +     if (obj->nr_extern == 0)
>>> +             return 0;
>>> +
>>> +     data = obj->maps[obj->extern_map_idx].mmaped;
>>> +
>>> +     for (i = 0; i < obj->nr_extern; i++) {
>>> +             ext = &obj->externs[i];
>>> +
>>> +             if (strcmp(ext->name, "LINUX_KERNEL_VERSION") == 0) {
>>> +                     void *ext_val = data + ext->data_off;
>>> +                     __u32 kver = get_kernel_version();
>>> +
>>> +                     if (!kver) {
>>> +                             pr_warn("failed to get kernel version\n");
>>> +                             return -EINVAL;
>>> +                     }
>>> +                     err = set_ext_value_num(ext, ext_val, kver);
>>> +                     if (err)
>>> +                             return err;
>>> +                     pr_debug("extern %s=0x%x\n", ext->name, kver);
>>> +             } else if (strncmp(ext->name, "CONFIG_", 7) == 0) {
>>> +                     need_config = true;
>>> +             } else {
>>> +                     pr_warn("unrecognized extern '%s'\n", ext->name);
>>> +                     return -EINVAL;
>>> +             }
>>
>> I don't quite like that this is (mainly) tracing-only specific, and that
>> for everything else we just bail out - there is much more potential than
>> just completing above vars. But also, there is also no way to opt-out
>> for application developers of /this specific/ semi-magic auto-completion
>> of externs.
> 
> What makes you think it's tracing only? While non-tracing apps
> probably don't need to care about LINUX_KERNEL_VERSION, all of the
> CONFIG_ stuff is useful and usable for any type of application.

Ok, just curious, do you have a concrete example e.g. for tc/xdp networking
programs where you have a specific CONFIG_* extern that you're using in your
programs currently?

> As for opt-out, you can easily opt out by not using extern variables.
> 
>> bpf_object__resolve_externs() should be changed instead to invoke a
>> callback obj->resolve_externs(). Former can be passed by the application
>> developer to allow them to take care of extern resolution all by themself,
>> and if no callback has been passed, then we default to the one above
>> being set as obj->resolve_externs.
> 
> Can you elaborate on the use case you have in mind? The way I always
> imagined BPF applications provide custom read-only parameters to BPF
> side is through using .rodata variables. With skeleton it's super easy
> to initialize them before BPF program is loaded, and their values will
> be well-known by verifier and potentially optimized.

We do set the map with .extern contents as read-only memory as well in
libbpf as I understand it. So same dead code optimization from the
verifier as well in this case. It feels the line with passing external
config via .rodata variables vs .extern variables gets therefore a bit
blurry.

Are we saying that in libbpf convention is that .extern contents must
*only* ever be kernel-provided but cannot come from some other configuration
data such as env/daemon?

[...]
> So for application-specific stuff, there isn't really a need to use
> externs to do that. Furthermore, I think allowing using externs as
> just another way to specify application-specific configuration is
> going to create a problem, potentially, as we'll have higher
> probability of collisions with kernel-provided extersn (variables
> and/or functions), or even externs provided by other
> dynamically/statically linked BPF programs (once we have dynamic and
> static linking, of course).

Yes, that makes more sense, but then we are already potentially colliding
with current CONFIG_* variables once we handle dynamically / statically
linked BPF programs. Perhaps that's my confusion in the first place. Would
have been good if 166750bc1dd2 had a discussion on that as part of the
commit message.

So, naive question, what's the rationale of not using .rodata variables
for CONFIG_* case and how do we handle these .extern collisions in future?
Should these vars rather have had some sort of annotation or be moved into
special ".extern.config" section or the like where we explicitly know that
these are handled differently so they don't collide with future ".extern"
content once we have linked BPF programs?

> So if you still insist we need user to provide custom extern-parsing
> logic, can you please elaborate on the use case details?
> 
> BTW, from discussion w/ Alexei on another thread, I think I'm going to
> change kconfig_path option to just `kconfig`, which will specify
> additional config in Kconfig format. This could be used by
> applications to provide their own config, augmenting Kconfig with
> custom overrides.

Ok.

Thanks,
Daniel
