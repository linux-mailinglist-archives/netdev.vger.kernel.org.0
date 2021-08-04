Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 25CD43E09D4
	for <lists+netdev@lfdr.de>; Wed,  4 Aug 2021 23:05:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239948AbhHDVFl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Aug 2021 17:05:41 -0400
Received: from www62.your-server.de ([213.133.104.62]:35268 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237378AbhHDVFl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Aug 2021 17:05:41 -0400
Received: from sslproxy06.your-server.de ([78.46.172.3])
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1mBO4l-00080s-If; Wed, 04 Aug 2021 23:05:19 +0200
Received: from [85.5.47.65] (helo=linux.home)
        by sslproxy06.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1mBO4l-00027K-Ap; Wed, 04 Aug 2021 23:05:19 +0200
Subject: Re: [PATCH bpf-next 0/3] tools: ksnoop: tracing kernel function
 entry/return with argument/return value display
To:     Alan Maguire <alan.maguire@oracle.com>, ast@kernel.org,
        andrii@kernel.org
Cc:     kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org,
        quentin@isovalent.com, toke@redhat.com, bpf@vger.kernel.org,
        netdev@vger.kernel.org
References: <1628025796-29533-1-git-send-email-alan.maguire@oracle.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <9fab5327-b629-c6bf-454c-dffe181e1cb1@iogearbox.net>
Date:   Wed, 4 Aug 2021 23:05:18 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <1628025796-29533-1-git-send-email-alan.maguire@oracle.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.2/26253/Wed Aug  4 10:20:49 2021)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Alan,

On 8/3/21 11:23 PM, Alan Maguire wrote:
> Recent functionality added to libbpf [1] enables typed display of kernel
> data structures; here that functionality is exploited to provide a
> simple example of how a tracer can support deep argument/return value
> inspection.  The intent is to provide a demonstration of these features
> to help facilitate tracer adoption, while also providing a tool which
> can be useful for kernel debugging.

Thanks a lot for working on this tool, this looks _super useful_! Right now
under tools/bpf/ we have bpftool and resolve_btfids as the two main tools,
the latter used during kernel build, and the former evolving with the kernel
together with libbpf. The runqslower in there was originally thought of as
a single/small example tool to demo how to build stand-alone tracing tools
with all the modern practices, though the latter has also been added to [0]
(thus could be removed). I would rather love if you could add ksnoop for
inclusion into bcc's libbpf-based tracing tooling suite under [0] as well
which would be a better fit long term rather than kernel tree for the tool
to evolve. We don't intend to add a stand-alone tooling collection under the
tools/bpf/ long term since these can evolve better outside of kernel tree.

Thanks a lot,
Daniel

   [0] https://github.com/iovisor/bcc/tree/master/libbpf-tools

> Changes since RFC [2]:
> 
> - In the RFC version, kernel data structures were string-ified in
>    BPF program context vi bpf_snprintf_btf(); Alexei pointed out that
>    it would be better to dump memory to userspace and let the
>    interpretation happen there.  btf_dump__dump_type_data() in libbpf
>    now supports this (Alexei, patch 1)
> - Added the "stack mode" specification where we trace a specific set
>    of functions being called in order (though not necessarily directly).
>    This mode of tracing is useful when debugging issues with a specific
>    stack signature.
> 
> [1] https://lore.kernel.org/bpf/1626362126-27775-1-git-send-email-alan.maguire@oracle.com/
> [2] https://lore.kernel.org/bpf/1609773991-10509-1-git-send-email-alan.maguire@oracle.com/
> 
> Alan Maguire (3):
>    tools: ksnoop: kernel argument/return value tracing/display using BTF
>    tools: ksnoop: document ksnoop tracing of entry/return with value
>      display
>    tools: ksnoop: add .gitignore
> 
>   tools/bpf/Makefile                        |  20 +-
>   tools/bpf/ksnoop/.gitignore               |   1 +
>   tools/bpf/ksnoop/Documentation/Makefile   |  58 ++
>   tools/bpf/ksnoop/Documentation/ksnoop.rst | 173 ++++++
>   tools/bpf/ksnoop/Makefile                 | 107 ++++
>   tools/bpf/ksnoop/ksnoop.bpf.c             | 391 +++++++++++++
>   tools/bpf/ksnoop/ksnoop.c                 | 890 ++++++++++++++++++++++++++++++
>   tools/bpf/ksnoop/ksnoop.h                 | 103 ++++
>   8 files changed, 1738 insertions(+), 5 deletions(-)
>   create mode 100644 tools/bpf/ksnoop/.gitignore
>   create mode 100644 tools/bpf/ksnoop/Documentation/Makefile
>   create mode 100644 tools/bpf/ksnoop/Documentation/ksnoop.rst
>   create mode 100644 tools/bpf/ksnoop/Makefile
>   create mode 100644 tools/bpf/ksnoop/ksnoop.bpf.c
>   create mode 100644 tools/bpf/ksnoop/ksnoop.c
>   create mode 100644 tools/bpf/ksnoop/ksnoop.h
> 

