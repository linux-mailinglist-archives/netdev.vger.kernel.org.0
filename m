Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B79363BC385
	for <lists+netdev@lfdr.de>; Mon,  5 Jul 2021 22:58:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230078AbhGEVBd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Jul 2021 17:01:33 -0400
Received: from www62.your-server.de ([213.133.104.62]:32786 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229904AbhGEVBd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Jul 2021 17:01:33 -0400
Received: from sslproxy02.your-server.de ([78.47.166.47])
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1m0Vg5-00020R-MB; Mon, 05 Jul 2021 22:58:53 +0200
Received: from [85.5.47.65] (helo=linux-3.home)
        by sslproxy02.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1m0Vg5-000B9F-FH; Mon, 05 Jul 2021 22:58:53 +0200
Subject: Re: [PATCH] tools: bpftool: close va_list 'ap' by va_end()
To:     gushengxian <gushengxian507419@gmail.com>, ast@kernel.org,
        andrii@kernel.org
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org, gushengxian <gushengxian@yulong.com>
References: <20210701120026.709862-1-gushengxian507419@gmail.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <bc835003-6497-4c7c-731c-738c632acdda@iogearbox.net>
Date:   Mon, 5 Jul 2021 22:58:53 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20210701120026.709862-1-gushengxian507419@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.2/26222/Mon Jul  5 13:05:31 2021)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/1/21 2:00 PM, gushengxian wrote:
> From: gushengxian <gushengxian@yulong.com>
> 
> va_list 'ap' was opened but not closed by va_end(). It should be
> closed by va_end() before return.
> 
> Signed-off-by: gushengxian <gushengxian@yulong.com>

nit: 'From:' and 'SoB:' should be in standardized form, I presume in your case
this would be:

Gu Shengxian <gushengxian@yulong.com>

> ---
>   tools/bpf/bpftool/jit_disasm.c | 4 +++-
>   1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/tools/bpf/bpftool/jit_disasm.c b/tools/bpf/bpftool/jit_disasm.c
> index e7e7eee9f172..3c85fd1f00cb 100644
> --- a/tools/bpf/bpftool/jit_disasm.c
> +++ b/tools/bpf/bpftool/jit_disasm.c
> @@ -45,8 +45,10 @@ static int fprintf_json(void *out, const char *fmt, ...)
>   	char *s;
>   
>   	va_start(ap, fmt);
> -	if (vasprintf(&s, fmt, ap) < 0)
> +	if (vasprintf(&s, fmt, ap) < 0) {
> +		va_end(ap);
>   		return -1;
> +	}
>   	va_end(ap);

Small nit, please change into something like:

         va_list ap;
         char *s;
+       int err;

         va_start(ap, fmt);
-       if (vasprintf(&s, fmt, ap) < 0)
-               return -1;
+       err = vasprintf(&s, fmt, ap);
         va_end(ap);
+       if (err < 0)
+               return -1;

         if (!oper_count) {
                 int i;

Fwiw, man page says: "On some systems, va_end contains a closing '}' matching a '{' in
va_start, so that both macros must occur in the same function, and in a way that allows
this.".

Thanks,
Daniel
