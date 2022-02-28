Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1C24F4C7038
	for <lists+netdev@lfdr.de>; Mon, 28 Feb 2022 16:00:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237430AbiB1PAp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Feb 2022 10:00:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234144AbiB1PAo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Feb 2022 10:00:44 -0500
Received: from www62.your-server.de (www62.your-server.de [213.133.104.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B33950B03;
        Mon, 28 Feb 2022 07:00:04 -0800 (PST)
Received: from sslproxy03.your-server.de ([88.198.220.132])
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1nOhVK-0006vm-0T; Mon, 28 Feb 2022 16:00:02 +0100
Received: from [85.1.206.226] (helo=linux.home)
        by sslproxy03.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1nOhVJ-0000iV-Kb; Mon, 28 Feb 2022 16:00:01 +0100
Subject: Re: [PATCH 1/1] libbpf: ensure F_DUPFD_CLOEXEC is defined
To:     James Hilliard <james.hilliard1@gmail.com>, bpf@vger.kernel.org
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20220227142551.2349805-1-james.hilliard1@gmail.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <6af1530a-a4bf-dccf-947d-78ce235a4414@iogearbox.net>
Date:   Mon, 28 Feb 2022 16:00:00 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20220227142551.2349805-1-james.hilliard1@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.5/26467/Mon Feb 28 10:24:05 2022)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi James,

On 2/27/22 3:25 PM, James Hilliard wrote:
> This definition seems to be missing from some older toolchains.
> 
> Note that the fcntl.h in libbpf_internal.h is not a kernel header
> but rather a toolchain libc header.
> 
> Fixes:
> libbpf_internal.h:521:18: error: 'F_DUPFD_CLOEXEC' undeclared (first use in this function); did you mean 'FD_CLOEXEC'?
>     fd = fcntl(fd, F_DUPFD_CLOEXEC, 3);
>                    ^~~~~~~~~~~~~~~
>                    FD_CLOEXEC
> 
> Signed-off-by: James Hilliard <james.hilliard1@gmail.com>

Do you have some more info on your env (e.g. libc)? Looks like F_DUPFD_CLOEXEC
was added back in 2.6.24 kernel. When did libc add it?

Should we instead just add an include for <linux/fcntl.h> to libbpf_internal.h
(given it defines F_DUPFD_CLOEXEC as well)?

> ---
>   tools/lib/bpf/libbpf_internal.h | 4 ++++
>   1 file changed, 4 insertions(+)
> 
> diff --git a/tools/lib/bpf/libbpf_internal.h b/tools/lib/bpf/libbpf_internal.h
> index 4fda8bdf0a0d..d2a86b5a457a 100644
> --- a/tools/lib/bpf/libbpf_internal.h
> +++ b/tools/lib/bpf/libbpf_internal.h
> @@ -31,6 +31,10 @@
>   #define EM_BPF 247
>   #endif
>   
> +#ifndef F_DUPFD_CLOEXEC
> +#define F_DUPFD_CLOEXEC 1030
> +#endif
> +
>   #ifndef R_BPF_64_64
>   #define R_BPF_64_64 1
>   #endif
> 

Thanks,
Daniel
