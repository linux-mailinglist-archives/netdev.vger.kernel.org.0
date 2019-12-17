Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 555281235F3
	for <lists+netdev@lfdr.de>; Tue, 17 Dec 2019 20:50:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728118AbfLQTug (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Dec 2019 14:50:36 -0500
Received: from www62.your-server.de ([213.133.104.62]:53910 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727162AbfLQTug (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Dec 2019 14:50:36 -0500
Received: from sslproxy05.your-server.de ([78.46.172.2])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1ihIrY-0004Aj-Fd; Tue, 17 Dec 2019 20:50:32 +0100
Received: from [178.197.249.31] (helo=pc-9.home)
        by sslproxy05.your-server.de with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89)
        (envelope-from <daniel@iogearbox.net>)
        id 1ihIrY-000SO2-5N; Tue, 17 Dec 2019 20:50:32 +0100
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
 <7bf339cf-c746-a780-3117-3348fb5997f1@iogearbox.net>
 <CAEf4BzYAWknN1HGHd0vREtQLHU-z3iTLJWBteRK6q7zkhySBBg@mail.gmail.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <e569134e-68a9-9c69-e894-b21640334bb0@iogearbox.net>
Date:   Tue, 17 Dec 2019 20:50:31 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <CAEf4BzYAWknN1HGHd0vREtQLHU-z3iTLJWBteRK6q7zkhySBBg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.101.4/25666/Tue Dec 17 10:54:52 2019)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/17/19 8:03 PM, Andrii Nakryiko wrote:
> On Tue, Dec 17, 2019 at 6:42 AM Daniel Borkmann <daniel@iogearbox.net> wrote:
>> On 12/16/19 8:29 PM, Andrii Nakryiko wrote:
>>> On Mon, Dec 16, 2019 at 3:17 AM Daniel Borkmann <daniel@iogearbox.net> wrote:
>>>> On Fri, Dec 13, 2019 at 05:47:08PM -0800, Andrii Nakryiko wrote:
[...]
>>> So for application-specific stuff, there isn't really a need to use
>>> externs to do that. Furthermore, I think allowing using externs as
>>> just another way to specify application-specific configuration is
>>> going to create a problem, potentially, as we'll have higher
>>> probability of collisions with kernel-provided extersn (variables
>>> and/or functions), or even externs provided by other
>>> dynamically/statically linked BPF programs (once we have dynamic and
>>> static linking, of course).
>>
>> Yes, that makes more sense, but then we are already potentially colliding
>> with current CONFIG_* variables once we handle dynamically / statically
>> linked BPF programs. Perhaps that's my confusion in the first place. Would
>> have been good if 166750bc1dd2 had a discussion on that as part of the
>> commit message.
>>
>> So, naive question, what's the rationale of not using .rodata variables
>> for CONFIG_* case and how do we handle these .extern collisions in future?
>> Should these vars rather have had some sort of annotation or be moved into
>> special ".extern.config" section or the like where we explicitly know that
>> these are handled differently so they don't collide with future ".extern"
>> content once we have linked BPF programs?
> 
> Yes, name collision is a possibility, which means users should
> restrain from using LINUX_KERNEL_VERSION and CONFIG_XXX names for
> their variables. But if that is ever actually the problem, the way to
> resolve this collision/ambiguity would be to put externs in a separate
> sections. It's possible to annotate extern variable with custom
> section.
> 
> But I guess putting Kconfig-provided externs into ".extern.kconfig"
> might be a good idea, actually. That will make it possible to have
> writable externs in the future.

Yep, and as mentioned it will make it more clear that these get special
loader treatment as opposed to regular externs we need to deal with in
future. A '.extern.kconfig' section sounds good to me and the BPF helper
header could provide a __kconfig annotation for that as well.
