Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 64A1852009A
	for <lists+netdev@lfdr.de>; Mon,  9 May 2022 17:03:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237898AbiEIPGe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 May 2022 11:06:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238031AbiEIPGT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 May 2022 11:06:19 -0400
Received: from www62.your-server.de (www62.your-server.de [213.133.104.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3648A6256;
        Mon,  9 May 2022 08:02:25 -0700 (PDT)
Received: from sslproxy03.your-server.de ([88.198.220.132])
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1no4tn-0002Zm-I0; Mon, 09 May 2022 17:02:11 +0200
Received: from [85.1.206.226] (helo=linux-2.home)
        by sslproxy03.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1no4tn-0003KZ-8p; Mon, 09 May 2022 17:02:11 +0200
Subject: Re: [PATCH bpf-next 2/3] net: sysctl: No need to check CAP_SYS_ADMIN
 for bpf_jit_*
To:     Tiezhu Yang <yangtiezhu@loongson.cn>, davem@davemloft.net,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <1652079475-16684-1-git-send-email-yangtiezhu@loongson.cn>
 <1652079475-16684-3-git-send-email-yangtiezhu@loongson.cn>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <9b5fadfb-7d43-7341-deeb-756885042a25@iogearbox.net>
Date:   Mon, 9 May 2022 17:02:10 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <1652079475-16684-3-git-send-email-yangtiezhu@loongson.cn>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.5/26536/Mon May  9 10:04:57 2022)
X-Spam-Status: No, score=-3.0 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/9/22 8:57 AM, Tiezhu Yang wrote:
> The mode of the following procnames are defined as 0644, 0600, 0600
> and 0600 respectively in net_core_table[], normal user can not write
> them, so no need to check CAP_SYS_ADMIN in the related proc_handler
> function, just remove the checks.
> 
> /proc/sys/net/core/bpf_jit_enable
> /proc/sys/net/core/bpf_jit_harden
> /proc/sys/net/core/bpf_jit_kallsyms
> /proc/sys/net/core/bpf_jit_limit
> 
> Signed-off-by: Tiezhu Yang <yangtiezhu@loongson.cn>

I don't think we can make this assumption - there are various other (non-BPF)
sysctl handlers in the tree doing similar check to prevent from userns' based
CAP_SYS_ADMIN.

> ---
>   net/core/sysctl_net_core.c | 9 ---------
>   1 file changed, 9 deletions(-)
> 
> diff --git a/net/core/sysctl_net_core.c b/net/core/sysctl_net_core.c
> index cf00dd7..059352b 100644
> --- a/net/core/sysctl_net_core.c
> +++ b/net/core/sysctl_net_core.c
> @@ -268,9 +268,6 @@ static int proc_dointvec_minmax_bpf_enable(struct ctl_table *table, int write,
>   	int ret, jit_enable = *(int *)table->data;
>   	struct ctl_table tmp = *table;
>   
> -	if (write && !capable(CAP_SYS_ADMIN))
> -		return -EPERM;
> -
>   	tmp.data = &jit_enable;
>   	ret = proc_dointvec_minmax(&tmp, write, buffer, lenp, ppos);
>   	if (write && !ret) {
> @@ -291,9 +288,6 @@ static int
>   proc_dointvec_minmax_bpf_restricted(struct ctl_table *table, int write,
>   				    void *buffer, size_t *lenp, loff_t *ppos)
>   {
> -	if (!capable(CAP_SYS_ADMIN))
> -		return -EPERM;
> -
>   	return proc_dointvec_minmax(table, write, buffer, lenp, ppos);
>   }
>   # endif /* CONFIG_HAVE_EBPF_JIT */
> @@ -302,9 +296,6 @@ static int
>   proc_dolongvec_minmax_bpf_restricted(struct ctl_table *table, int write,
>   				     void *buffer, size_t *lenp, loff_t *ppos)
>   {
> -	if (!capable(CAP_SYS_ADMIN))
> -		return -EPERM;
> -
>   	return proc_doulongvec_minmax(table, write, buffer, lenp, ppos);
>   }
>   #endif
> 

