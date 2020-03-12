Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C9307183519
	for <lists+netdev@lfdr.de>; Thu, 12 Mar 2020 16:38:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727585AbgCLPiE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Mar 2020 11:38:04 -0400
Received: from www62.your-server.de ([213.133.104.62]:42810 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727196AbgCLPiD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Mar 2020 11:38:03 -0400
Received: from sslproxy06.your-server.de ([78.46.172.3])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1jCPuK-0007tp-88; Thu, 12 Mar 2020 16:38:00 +0100
Received: from [85.7.42.192] (helo=pc-9.home)
        by sslproxy06.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1jCPuJ-0000d6-W7; Thu, 12 Mar 2020 16:38:00 +0100
Subject: Re: [PATCH bpf] libbpf: add null pointer check in
 bpf_object__init_user_btf_maps()
To:     Quentin Monnet <quentin@isovalent.com>,
        Alexei Starovoitov <ast@kernel.org>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        Andrii Nakryiko <andriin@fb.com>,
        Michal Rostecki <mrostecki@opensuse.org>
References: <20200312140357.20174-1-quentin@isovalent.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <1fff03e7-e52b-edcc-d427-f912bf0a4af2@iogearbox.net>
Date:   Thu, 12 Mar 2020 16:37:59 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20200312140357.20174-1-quentin@isovalent.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.2/25749/Thu Mar 12 14:09:06 2020)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/12/20 3:03 PM, Quentin Monnet wrote:
> When compiling bpftool with clang 7, after the addition of its recent
> "bpftool prog profile" feature, Michal reported a segfault. This
> occurred while the build process was attempting to generate the
> skeleton needed for the profiling program, with the following command:
> 
>      ./_bpftool gen skeleton skeleton/profiler.bpf.o > profiler.skel.h
> 
> Tracing the error showed that bpf_object__init_user_btf_maps() does no
> verification on obj->btf before passing it to btf__get_nr_types(), where
> btf is dereferenced. Libbpf considers BTF information should be here
> because of the presence of a ".maps" section in the object file (hence
> the check on "obj->efile.btf_maps_shndx < 0" fails and we do not exit
> from the function early), but it was unable to load BTF info as there is
> no .BTF section.
> 
> Add a null pointer check and error out if the pointer is null. The final
> bpftool executable still fails to build, but at least we have a proper
> error and no more segfault.
> 
> Fixes: abd29c931459 ("libbpf: allow specifying map definitions using BTF")
> Cc: Andrii Nakryiko <andriin@fb.com>
> Reported-by: Michal Rostecki <mrostecki@opensuse.org>
> Signed-off-by: Quentin Monnet <quentin@isovalent.com>

Applied to bpf-next, thanks! Note ...

> ---
>   tools/lib/bpf/libbpf.c | 4 ++++
>   1 file changed, 4 insertions(+)
> 
> diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
> index 223be01dc466..19c0c40e8a80 100644
> --- a/tools/lib/bpf/libbpf.c
> +++ b/tools/lib/bpf/libbpf.c
> @@ -2140,6 +2140,10 @@ static int bpf_object__init_user_btf_maps(struct bpf_object *obj, bool strict,
>   		return -EINVAL;
>   	}
>   
> +	if (!obj->btf) {
> +		pr_warn("failed to retrieve BTF for map");

I've added a '\n' here, otherwise it looks like:

[...]
   LINK     _bpftool
   CLANG    skeleton/profiler.bpf.o
   GEN      profiler.skel.h
libbpf: failed to retrieve BTF for mapError: failed to open BPF object file: 0
Makefile:129: recipe for target 'profiler.skel.h' failed

Fixed version:

   LINK     _bpftool
   GEN      profiler.skel.h
libbpf: failed to retrieve BTF for map
Error: failed to open BPF object file: 0
Makefile:129: recipe for target 'profiler.skel.h' failed

Thanks,
Daniel
