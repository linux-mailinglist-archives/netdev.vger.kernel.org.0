Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9B542593AC5
	for <lists+netdev@lfdr.de>; Mon, 15 Aug 2022 22:33:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343815AbiHOTmz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Aug 2022 15:42:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343538AbiHOTjd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Aug 2022 15:39:33 -0400
Received: from www62.your-server.de (www62.your-server.de [213.133.104.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38906402CF;
        Mon, 15 Aug 2022 11:47:03 -0700 (PDT)
Received: from sslproxy03.your-server.de ([88.198.220.132])
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1oNf73-000FWY-0a; Mon, 15 Aug 2022 20:46:57 +0200
Received: from [85.1.206.226] (helo=linux-4.home)
        by sslproxy03.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1oNf72-000MQi-PA; Mon, 15 Aug 2022 20:46:56 +0200
Subject: Re: [PATCH bpf-next] selftests/bpf: fix attach point for non-x86
 arches in test_progs/lsm
To:     Artem Savkov <asavkov@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>, bpf@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org,
        =?UTF-8?Q?Daniel_M=c3=bcller?= <deso@posteo.net>
References: <20220815122422.687116-1-asavkov@redhat.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <376f20c5-4b1c-efec-4dde-43d91b3d4308@iogearbox.net>
Date:   Mon, 15 Aug 2022 20:46:56 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20220815122422.687116-1-asavkov@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.6/26628/Mon Aug 15 09:51:41 2022)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/15/22 2:24 PM, Artem Savkov wrote:
> Use SYS_PREFIX macro from bpf_misc.h instead of hard-coded '__x64_'
> prefix for sys_setdomainname attach point in lsm test.
> 
> Signed-off-by: Artem Savkov <asavkov@redhat.com>
> ---
>   tools/testing/selftests/bpf/progs/lsm.c | 3 ++-
>   1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/tools/testing/selftests/bpf/progs/lsm.c b/tools/testing/selftests/bpf/progs/lsm.c
> index 33694ef8acfa..d8d8af623bc2 100644
> --- a/tools/testing/selftests/bpf/progs/lsm.c
> +++ b/tools/testing/selftests/bpf/progs/lsm.c
> @@ -4,6 +4,7 @@
>    * Copyright 2020 Google LLC.
>    */
>   
> +#include "bpf_misc.h"
>   #include "vmlinux.h"
>   #include <bpf/bpf_helpers.h>
>   #include <bpf/bpf_tracing.h>
> @@ -160,7 +161,7 @@ int BPF_PROG(test_task_free, struct task_struct *task)
>   
>   int copy_test = 0;
>   
> -SEC("fentry.s/__x64_sys_setdomainname")
> +SEC("fentry.s/" SYS_PREFIX "sys_setdomainname")
>   int BPF_PROG(test_sys_setdomainname, struct pt_regs *regs)
>   {
>   	void *ptr = (void *)PT_REGS_PARM1(regs);
> 

Good catch! Could you also update the comment in tools/testing/selftests/bpf/DENYLIST.s390x +46 :

[...]
test_lsm                                 # failed to find kernel BTF type ID of '__x64_sys_setdomainname': -3          (?)
[...]

It should likely say sth like `attach fentry unexpected error: -524 (trampoline)`.

Thanks,
Daniel
