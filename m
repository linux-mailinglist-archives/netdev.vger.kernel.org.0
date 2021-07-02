Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 195C53BA31A
	for <lists+netdev@lfdr.de>; Fri,  2 Jul 2021 18:10:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229685AbhGBQMu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Jul 2021 12:12:50 -0400
Received: from www62.your-server.de ([213.133.104.62]:41262 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229455AbhGBQMu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Jul 2021 12:12:50 -0400
Received: from sslproxy05.your-server.de ([78.46.172.2])
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1lzLk6-000CJ0-HA; Fri, 02 Jul 2021 18:10:14 +0200
Received: from [85.5.47.65] (helo=linux-3.home)
        by sslproxy05.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1lzLk6-000SHb-Av; Fri, 02 Jul 2021 18:10:14 +0200
Subject: Re: [PATCH bpf-next] libbpf: ignore .eh_frame sections when parsing
 elf files
To:     =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>,
        Andrii Nakryiko <andrii@kernel.org>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org
References: <20210629110923.580029-1-toke@redhat.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <ac14ef3c-ccd5-5f74-dda5-1d9366883813@iogearbox.net>
Date:   Fri, 2 Jul 2021 18:10:13 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20210629110923.580029-1-toke@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.2/26219/Fri Jul  2 13:06:52 2021)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/29/21 1:09 PM, Toke Høiland-Jørgensen wrote:
> The .eh_frame and .rel.eh_frame sections will be present in BPF object
> files when compiled using a multi-stage compile pipe like in samples/bpf.
> This produces errors when loading such a file with libbpf. While the errors
> are technically harmless, they look odd and confuse users. So add .eh_frame
> sections to is_sec_name_dwarf() so they will also be ignored by libbpf
> processing. This gets rid of output like this from samples/bpf:
> 
> libbpf: elf: skipping unrecognized data section(32) .eh_frame
> libbpf: elf: skipping relo section(33) .rel.eh_frame for section(32) .eh_frame
> 
> Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>

For the samples/bpf case, could we instead just add a -fno-asynchronous-unwind-tables
to clang as cflags to avoid .eh_frame generation in the first place?

> ---
>   tools/lib/bpf/libbpf.c | 3 ++-
>   1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
> index 1e04ce724240..676af6be5961 100644
> --- a/tools/lib/bpf/libbpf.c
> +++ b/tools/lib/bpf/libbpf.c
> @@ -2906,7 +2906,8 @@ static Elf_Data *elf_sec_data(const struct bpf_object *obj, Elf_Scn *scn)
>   static bool is_sec_name_dwarf(const char *name)
>   {
>   	/* approximation, but the actual list is too long */
> -	return strncmp(name, ".debug_", sizeof(".debug_") - 1) == 0;
> +	return (strncmp(name, ".debug_", sizeof(".debug_") - 1) == 0 ||
> +		strncmp(name, ".eh_frame", sizeof(".eh_frame") - 1) == 0);
>   }
>   
>   static bool ignore_elf_section(GElf_Shdr *hdr, const char *name)
> 

Thanks,
Daniel
