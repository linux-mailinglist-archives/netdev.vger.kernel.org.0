Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9B2C969FDCF
	for <lists+netdev@lfdr.de>; Wed, 22 Feb 2023 22:41:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232841AbjBVVk7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Feb 2023 16:40:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232814AbjBVVk5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Feb 2023 16:40:57 -0500
Received: from out-3.mta0.migadu.com (out-3.mta0.migadu.com [91.218.175.3])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04B1832CC6
        for <netdev@vger.kernel.org>; Wed, 22 Feb 2023 13:40:51 -0800 (PST)
Message-ID: <76e226e6-f3bf-f740-c86c-6ee214aff07d@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1677102049;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ULSs5D2Kb3ePBoYyjTCmDgoF746uH4nFtS2uoFRmdJM=;
        b=dtuBJPLUPhHuttZ5PmCFdedcgpdhA19HESXTQmw4vG0574AW6ft5RVdXQ6hHNcUinXc+ws
        YeeeXBoGF4h51a+KizxNwBaqeYJmQTr1WIAXyyr/fMo+MKrOhRwxO9QqqIQcFDCSy3wj01
        WQyPlDEQfVtXLNyczLof23Dmal/4MwQ=
Date:   Wed, 22 Feb 2023 13:40:43 -0800
MIME-Version: 1.0
Subject: Re: [PATCH bpf-next v2 1/2] net/smc: Introduce BPF injection
 capability for SMC
Content-Language: en-US
To:     "D. Wythe" <alibuda@linux.alibaba.com>
Cc:     kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-rdma@vger.kernel.org,
        bpf@vger.kernel.org, kgraul@linux.ibm.com, wenjia@linux.ibm.com,
        jaka@linux.ibm.com, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org
References: <1676981919-64884-1-git-send-email-alibuda@linux.alibaba.com>
 <1676981919-64884-2-git-send-email-alibuda@linux.alibaba.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Martin KaFai Lau <martin.lau@linux.dev>
In-Reply-To: <1676981919-64884-2-git-send-email-alibuda@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/21/23 4:18 AM, D. Wythe wrote:
> From: "D. Wythe" <alibuda@linux.alibaba.com>
> 
> This PATCH attempts to introduce BPF injection capability for SMC.
> As we all know that the SMC protocol is not suitable for all scenarios,
> especially for short-lived. However, for most applications, they cannot
> guarantee that there are no such scenarios at all. Therefore, apps
> may need some specific strategies to decide shall we need to use SMC
> or not, for example, apps can limit the scope of the SMC to a specific
> IP address or port.
> 
> Based on the consideration of transparent replacement, we hope that apps
> can remain transparent even if they need to formulate some specific
> strategies for SMC using. That is, do not need to recompile their code.
> 
> On the other hand, we need to ensure the scalability of strategies
> implementation. Although it is simple to use socket options or sysctl,
> it will bring more complexity to subsequent expansion.
> 
> Fortunately, BPF can solve these concerns very well, users can write
> thire own strategies in eBPF to choose whether to use SMC or not.
> And it's quite easy for them to modify their strategies in the future.
> 
> This PATCH implement injection capability for SMC via struct_ops.
> In that way, we can add new injection scenarios in the future.

I have never used smc. I can only comment at its high level usage and details on 
the bpf side.

> 
> Signed-off-by: D. Wythe <alibuda@linux.alibaba.com>
> ---
>   include/linux/btf_ids.h           |  15 +++
>   include/net/smc.h                 | 254 ++++++++++++++++++++++++++++++++++++++
>   kernel/bpf/bpf_struct_ops_types.h |   4 +
>   net/Makefile                      |   5 +
>   net/smc/af_smc.c                  |  10 +-
>   net/smc/bpf_smc_struct_ops.c      | 146 ++++++++++++++++++++++
>   net/smc/smc.h                     | 220 ---------------------------------
>   7 files changed, 433 insertions(+), 221 deletions(-)
>   create mode 100644 net/smc/bpf_smc_struct_ops.c
> 
> diff --git a/include/linux/btf_ids.h b/include/linux/btf_ids.h
> index 3a4f7cd..25eab1e 100644
> --- a/include/linux/btf_ids.h
> +++ b/include/linux/btf_ids.h
> @@ -264,6 +264,21 @@ enum {
>   MAX_BTF_TRACING_TYPE,
>   };
>   
> +#if IS_ENABLED(CONFIG_SMC)
> +#define BTF_SMC_TYPE_xxx		\
> +	BTF_SMC_TYPE(BTF_SMC_TYPE_SOCK, smc_sock)		\
> +	BTF_SMC_TYPE(BTF_SMC_TYPE_CONNECTION, smc_connection)	\
> +	BTF_SMC_TYPE(BTF_SMC_TYPE_HOST_CURSOR, smc_host_cursor)
> +
> +enum {
> +#define BTF_SMC_TYPE(name, type) name,
> +BTF_SMC_TYPE_xxx
> +#undef BTF_SMC_TYPE
> +MAX_BTF_SMC_TYPE,
> +};
> +extern u32 btf_smc_ids[];

Do all these need to be in btf_ids.h?

> +#endif
> +
>   extern u32 btf_tracing_ids[];
>   extern u32 bpf_cgroup_btf_id[];
>   extern u32 bpf_local_storage_map_btf_id[];
> diff --git a/include/net/smc.h b/include/net/smc.h
> index 597cb93..912c269 100644
> --- a/include/net/smc.h
> +++ b/include/net/smc.h

It is not obvious to me why the header moving is needed (from net/smc/smc.h to 
include/net/smc.h ?). This can use some comment in the commit message and please 
break it out to another patch.

[ ... ]

> --- a/net/Makefile
> +++ b/net/Makefile
> @@ -52,6 +52,11 @@ obj-$(CONFIG_TIPC)		+= tipc/
>   obj-$(CONFIG_NETLABEL)		+= netlabel/
>   obj-$(CONFIG_IUCV)		+= iucv/
>   obj-$(CONFIG_SMC)		+= smc/
> +ifneq ($(CONFIG_SMC),)
> +ifeq ($(CONFIG_BPF_SYSCALL),y)
> +obj-y				+= smc/bpf_smc_struct_ops.o

This will ensure bpf_smc_struct_ops.c compiled as builtin even when smc is 
compiled as module?

> diff --git a/net/smc/bpf_smc_struct_ops.c b/net/smc/bpf_smc_struct_ops.c
> new file mode 100644
> index 0000000..a5989b6
> --- /dev/null
> +++ b/net/smc/bpf_smc_struct_ops.c
> @@ -0,0 +1,146 @@
> +// SPDX-License-Identifier: GPL-2.0
> +
> +#include <linux/kernel.h>
> +#include <linux/bpf_verifier.h>
> +#include <linux/btf_ids.h>
> +#include <linux/bpf.h>
> +#include <linux/btf.h>
> +#include <net/sock.h>
> +#include <net/smc.h>
> +
> +extern struct bpf_struct_ops smc_sock_negotiator_ops;
> +
> +DEFINE_RWLOCK(smc_sock_negotiator_ops_rwlock);
> +struct smc_sock_negotiator_ops *negotiator;

Is it sure one global negotiator (policy) will work for all smc_sock? or each sk 
should have its own negotiator and the negotiator is selected by setsockopt.

> +
> +/* convert sk to smc_sock */
> +static inline struct smc_sock *smc_sk(const struct sock *sk)
> +{
> +	return (struct smc_sock *)sk;
> +}
> +
> +/* register ops */
> +static inline void smc_reg_passive_sk_ops(struct smc_sock_negotiator_ops *ops)
> +{
> +	write_lock_bh(&smc_sock_negotiator_ops_rwlock);
> +	negotiator = ops;

What happens to the existing negotiator?

> +	write_unlock_bh(&smc_sock_negotiator_ops_rwlock);
> +}
> +
> +/* unregister ops */
> +static inline void smc_unreg_passive_sk_ops(struct smc_sock_negotiator_ops *ops)
> +{
> +	write_lock_bh(&smc_sock_negotiator_ops_rwlock);
> +	if (negotiator == ops)
> +		negotiator = NULL;
> +	write_unlock_bh(&smc_sock_negotiator_ops_rwlock);
> +}
> +
> +int smc_sock_should_select_smc(const struct smc_sock *smc)
> +{
> +	int ret = SK_PASS;
> +
> +	read_lock_bh(&smc_sock_negotiator_ops_rwlock);
> +	if (negotiator && negotiator->negotiate)
> +		ret = negotiator->negotiate((struct smc_sock *)smc);
> +	read_unlock_bh(&smc_sock_negotiator_ops_rwlock);
> +	return ret;
> +}
> +EXPORT_SYMBOL_GPL(smc_sock_should_select_smc);
> +
> +void smc_sock_perform_collecting_info(const struct smc_sock *smc, int timing)
> +{
> +	read_lock_bh(&smc_sock_negotiator_ops_rwlock);
> +	if (negotiator && negotiator->collect_info)
> +		negotiator->collect_info((struct smc_sock *)smc, timing);
> +	read_unlock_bh(&smc_sock_negotiator_ops_rwlock);
> +}
> +EXPORT_SYMBOL_GPL(smc_sock_perform_collecting_info);
> +
> +/* define global smc ID for smc_struct_ops */
> +BTF_ID_LIST_GLOBAL(btf_smc_ids, MAX_BTF_SMC_TYPE)

How is btf_smc_ids used?

> +#define BTF_SMC_TYPE(name, type) BTF_ID(struct, type)
> +BTF_SMC_TYPE_xxx
> +#undef BTF_SMC_TYPE
> +


