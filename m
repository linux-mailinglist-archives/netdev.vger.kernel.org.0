Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 15A2418387D
	for <lists+netdev@lfdr.de>; Thu, 12 Mar 2020 19:21:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726676AbgCLSVO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Mar 2020 14:21:14 -0400
Received: from www62.your-server.de ([213.133.104.62]:44030 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726647AbgCLSVO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Mar 2020 14:21:14 -0400
Received: from sslproxy06.your-server.de ([78.46.172.3])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1jCSSF-0006GZ-A8; Thu, 12 Mar 2020 19:21:11 +0100
Received: from [85.7.42.192] (helo=pc-9.home)
        by sslproxy06.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1jCSSE-000JOa-UF; Thu, 12 Mar 2020 19:21:11 +0100
Subject: Re: [PATCH bpf] libbpf: add null pointer check in
 bpf_object__init_user_btf_maps()
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Quentin Monnet <quentin@isovalent.com>,
        Alexei Starovoitov <ast@kernel.org>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Andrii Nakryiko <andriin@fb.com>,
        Michal Rostecki <mrostecki@opensuse.org>
References: <20200312140357.20174-1-quentin@isovalent.com>
 <1fff03e7-e52b-edcc-d427-f912bf0a4af2@iogearbox.net>
 <CAEf4BzaQdv8s4cGp=ouitxczzWV1E1WeuxktDTp5JFkXXkRU=w@mail.gmail.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <4a17add0-6756-a60c-7c5b-9ffe45ff4060@iogearbox.net>
Date:   Thu, 12 Mar 2020 19:21:10 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <CAEf4BzaQdv8s4cGp=ouitxczzWV1E1WeuxktDTp5JFkXXkRU=w@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.2/25749/Thu Mar 12 14:09:06 2020)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/12/20 6:54 PM, Andrii Nakryiko wrote:
> On Thu, Mar 12, 2020 at 8:38 AM Daniel Borkmann <daniel@iogearbox.net> wrote:
>> On 3/12/20 3:03 PM, Quentin Monnet wrote:
>>> When compiling bpftool with clang 7, after the addition of its recent
>>> "bpftool prog profile" feature, Michal reported a segfault. This
>>> occurred while the build process was attempting to generate the
>>> skeleton needed for the profiling program, with the following command:
>>>
>>>       ./_bpftool gen skeleton skeleton/profiler.bpf.o > profiler.skel.h
>>>
>>> Tracing the error showed that bpf_object__init_user_btf_maps() does no
>>> verification on obj->btf before passing it to btf__get_nr_types(), where
>>> btf is dereferenced. Libbpf considers BTF information should be here
>>> because of the presence of a ".maps" section in the object file (hence
>>> the check on "obj->efile.btf_maps_shndx < 0" fails and we do not exit
>>> from the function early), but it was unable to load BTF info as there is
>>> no .BTF section.
>>>
>>> Add a null pointer check and error out if the pointer is null. The final
>>> bpftool executable still fails to build, but at least we have a proper
>>> error and no more segfault.
>>>
>>> Fixes: abd29c931459 ("libbpf: allow specifying map definitions using BTF")
>>> Cc: Andrii Nakryiko <andriin@fb.com>
>>> Reported-by: Michal Rostecki <mrostecki@opensuse.org>
>>> Signed-off-by: Quentin Monnet <quentin@isovalent.com>
>>
>> Applied to bpf-next, thanks! Note ...
> 
> I don't think this is the right fix. The problem was in my
> 5327644614a1 ("libbpf: Relax check whether BTF is mandatory") commit.
> I've removed "mandatory" status of BTF if .maps is present. But that's
> not right. We have the need for BTF at two levels: for libbpf itself
> and for kernel, those are overlapping, but not exactly the same. BTF
> is needed for libbpf when .maps, .struct_ops and externs are present.
> But kernel needs it only for when .struct_ops are present. Right now
> those checks are conflated together. Proper fix would be to separate
> them. Can we please undo this patch? I'll post a proper fix shortly.

Ok, please send a proper fix for 5327644614a1 then. Tossed off the tree.
