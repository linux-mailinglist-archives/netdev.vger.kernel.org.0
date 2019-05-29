Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 31CCA2DF1D
	for <lists+netdev@lfdr.de>; Wed, 29 May 2019 16:03:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727578AbfE2ODj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 May 2019 10:03:39 -0400
Received: from www62.your-server.de ([213.133.104.62]:55664 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727106AbfE2ODj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 May 2019 10:03:39 -0400
Received: from [78.46.172.3] (helo=sslproxy06.your-server.de)
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1hVzB2-0004bn-RK; Wed, 29 May 2019 16:03:36 +0200
Received: from [2a02:120b:c3fc:feb0:dda7:bd28:a848:50e2] (helo=linux.home)
        by sslproxy06.your-server.de with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89)
        (envelope-from <daniel@iogearbox.net>)
        id 1hVzB2-000NQQ-L0; Wed, 29 May 2019 16:03:36 +0200
Subject: Re: [PATCH bpf-next] libbpf: prevent overwriting of log_level in
 bpf_object__load_progs()
To:     Quentin Monnet <quentin.monnet@netronome.com>,
        Alexei Starovoitov <ast@kernel.org>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        oss-drivers@netronome.com
References: <20190529092323.27477-1-quentin.monnet@netronome.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <1f3cfd61-f8af-f67e-aa2e-c0286df72820@iogearbox.net>
Date:   Wed, 29 May 2019 16:03:36 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.3.0
MIME-Version: 1.0
In-Reply-To: <20190529092323.27477-1-quentin.monnet@netronome.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.100.3/25464/Wed May 29 09:59:09 2019)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 05/29/2019 11:23 AM, Quentin Monnet wrote:
> There are two functions in libbpf that support passing a log_level
> parameter for the verifier for loading programs:
> bpf_object__load_xattr() and bpf_load_program_xattr(). Both accept an
> attribute object containing the log_level, and apply it to the programs
> to load.
> 
> It turns out that to effectively load the programs, the latter function
> eventually relies on the former. This was not taken into account when
> adding support for log_level in bpf_object__load_xattr(), and the
> log_level passed to bpf_load_program_xattr() later gets overwritten with
> a zero value, thus disabling verifier logs for the program in all cases:
> 
> bpf_load_program_xattr()             // prog.log_level = N;

I'm confused with your commit message. How can bpf_load_program_xattr()
make sense here, this is the one doing the bpf syscall. Do you mean to
say bpf_prog_load_xattr()? Because this one sets prog->log_level = attr->log_level
and calls bpf_object__load() which in turn does bpf_object__load_xattr()
with an attr that has attr->log_level of 0 such that bpf_object__load_progs()
then overrides it. Unless I'm not missing something, please fix up this
description properly and resubmit.

>  -> bpf_object__load()               // attr.log_level = 0;
>      -> bpf_object__load_xattr()     // <pass prog and attr>
>          -> bpf_object__load_progs() // prog.log_level = attr.log_level;
> 
> Fix this by OR-ing the log_level in bpf_object__load_progs(), instead of
> overwriting it.
> 
> Fixes: 60276f984998 ("libbpf: add bpf_object__load_xattr() API function to pass log_level")
> Reported-by: Alexei Starovoitov <ast@kernel.org>
> Signed-off-by: Quentin Monnet <quentin.monnet@netronome.com>
> ---
>  tools/lib/bpf/libbpf.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
> index ca4432f5b067..30cb08e2eb75 100644
> --- a/tools/lib/bpf/libbpf.c
> +++ b/tools/lib/bpf/libbpf.c
> @@ -2232,7 +2232,7 @@ bpf_object__load_progs(struct bpf_object *obj, int log_level)
>  	for (i = 0; i < obj->nr_programs; i++) {
>  		if (bpf_program__is_function_storage(&obj->programs[i], obj))
>  			continue;
> -		obj->programs[i].log_level = log_level;
> +		obj->programs[i].log_level |= log_level;
>  		err = bpf_program__load(&obj->programs[i],
>  					obj->license,
>  					obj->kern_version);
> 

