Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E7AB2216CD
	for <lists+netdev@lfdr.de>; Wed, 15 Jul 2020 23:08:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726831AbgGOVHZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jul 2020 17:07:25 -0400
Received: from www62.your-server.de ([213.133.104.62]:51196 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725917AbgGOVHY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jul 2020 17:07:24 -0400
Received: from sslproxy02.your-server.de ([78.47.166.47])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1jvocY-0003ol-AP; Wed, 15 Jul 2020 23:07:18 +0200
Received: from [178.196.57.75] (helo=pc-9.home)
        by sslproxy02.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1jvocY-000Rp7-0q; Wed, 15 Jul 2020 23:07:18 +0200
Subject: Re: [Linux-kernel-mentees] [PATCH v3] bpf: Fix NULL pointer
 dereference in __btf_resolve_helper_id()
To:     Peilin Ye <yepeilin.cs@gmail.com>,
        Andrii Nakryiko <andriin@fb.com>,
        Alexei Starovoitov <ast@kernel.org>
Cc:     Martin KaFai Lau <kafai@fb.com>, Song Liu <songliubraving@fb.com>,
        Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        syzkaller-bugs@googlegroups.com,
        linux-kernel-mentees@lists.linuxfoundation.org,
        linux-kernel@vger.kernel.org, clang-built-linux@googlegroups.com
References: <CAADnVQ+jUPGJapkvKW=AfXESD6Vz2iuONvJm8eJm5Yd+u9mJ+w@mail.gmail.com>
 <20200714180904.277512-1-yepeilin.cs@gmail.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <3b97c5bf-9f07-0353-ea4d-f90574fbcdc0@iogearbox.net>
Date:   Wed, 15 Jul 2020 23:07:17 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20200714180904.277512-1-yepeilin.cs@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.3/25874/Wed Jul 15 16:18:08 2020)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/14/20 8:09 PM, Peilin Ye wrote:
> Prevent __btf_resolve_helper_id() from dereferencing `btf_vmlinux`
> as NULL. This patch fixes the following syzbot bug:
> 
>      https://syzkaller.appspot.com/bug?id=f823224ada908fa5c207902a5a62065e53ca0fcc
> 
> Reported-by: syzbot+ee09bda7017345f1fbe6@syzkaller.appspotmail.com
> Signed-off-by: Peilin Ye <yepeilin.cs@gmail.com>

Looks good, applied, thanks! As far as I can tell all the other occurrences are
gated behind btf_parse_vmlinux() where we also init struct_opts, etc.

So for bpf-next this would then end up looking like ...

int btf_resolve_helper_id(struct bpf_verifier_log *log,
                           const struct bpf_func_proto *fn, int arg)
{
         int id;

         if (fn->arg_type[arg] != ARG_PTR_TO_BTF_ID)
                 return -EINVAL;
         id = fn->btf_id[arg];
         if (!id || !btf_vmlinux || id > btf_vmlinux->nr_types)
                 return -EINVAL;
         return id;
}

> ---
> Sorry, I got the link wrong. Thank you for pointing that out.
> 
> Change in v3:
>      - Fix incorrect syzbot dashboard link.
> 
> Change in v2:
>      - Split NULL and IS_ERR cases.
> 
>   kernel/bpf/btf.c | 5 +++++
>   1 file changed, 5 insertions(+)
> 
> diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
> index 30721f2c2d10..092116a311f4 100644
> --- a/kernel/bpf/btf.c
> +++ b/kernel/bpf/btf.c
> @@ -4088,6 +4088,11 @@ static int __btf_resolve_helper_id(struct bpf_verifier_log *log, void *fn,
>   	const char *tname, *sym;
>   	u32 btf_id, i;
>   
> +	if (!btf_vmlinux) {
> +		bpf_log(log, "btf_vmlinux doesn't exist\n");
> +		return -EINVAL;
> +	}
> +
>   	if (IS_ERR(btf_vmlinux)) {
>   		bpf_log(log, "btf_vmlinux is malformed\n");
>   		return -EINVAL;
> 

