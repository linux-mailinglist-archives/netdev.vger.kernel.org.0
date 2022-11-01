Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B310A614827
	for <lists+netdev@lfdr.de>; Tue,  1 Nov 2022 12:03:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230090AbiKALDu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Nov 2022 07:03:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230080AbiKALDr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Nov 2022 07:03:47 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9FC711A053;
        Tue,  1 Nov 2022 04:03:34 -0700 (PDT)
Received: from dggpemm500022.china.huawei.com (unknown [172.30.72.55])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4N1nDy5qmvzHvXt;
        Tue,  1 Nov 2022 19:03:14 +0800 (CST)
Received: from dggpemm500013.china.huawei.com (7.185.36.172) by
 dggpemm500022.china.huawei.com (7.185.36.162) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Tue, 1 Nov 2022 19:03:06 +0800
Received: from [10.67.108.67] (10.67.108.67) by dggpemm500013.china.huawei.com
 (7.185.36.172) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Tue, 1 Nov
 2022 19:03:06 +0800
Message-ID: <be794dca-f3ad-8fe4-98f2-2b17ea8ad72b@huawei.com>
Date:   Tue, 1 Nov 2022 19:03:06 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.0
Subject: Re: [PATCH] netfilter: nf_nat: Fix possible memory leak in
 nf_nat_init()
Content-Language: en-US
To:     <linux-kernel@vger.kernel.org>, <netfilter-devel@vger.kernel.org>,
        <coreteam@netfilter.org>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>
CC:     <pablo@netfilter.org>, <kadlec@netfilter.org>, <fw@strlen.de>,
        <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <john.fastabend@gmail.com>,
        <lorenzo@kernel.org>, <ast@kernel.org>
References: <20221101093430.126571-1-chenzhongjin@huawei.com>
From:   Chen Zhongjin <chenzhongjin@huawei.com>
In-Reply-To: <20221101093430.126571-1-chenzhongjin@huawei.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.67.108.67]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 dggpemm500013.china.huawei.com (7.185.36.172)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2022/11/1 17:34, Chen Zhongjin wrote:
> In nf_nat_init(), register_nf_nat_bpf() can fail and return directly
> without any error handling.
> Then nf_nat_bysource will leak and registering of &nat_net_ops won't
> be reverted. This leaves wild ops in subsystem linkedlist and when
> another module tries to call register_pernet_operations() it triggers
> page fault:
>
>   BUG: unable to handle page fault for address: fffffbfff81b964c
>   RIP: 0010:register_pernet_operations+0x1b9/0x5f0
>   Call Trace:
>   <TASK>
>    register_pernet_subsys+0x29/0x40
>    ebtables_init+0x58/0x1000 [ebtables]
>    ...
>
> Fixes: 820dc0523e05 ("net: netfilter: move bpf_ct_set_nat_info kfunc in nf_nat_bpf.c")
> Signed-off-by: Chen Zhongjin <chenzhongjin@huawei.com>
> ---
>   net/netfilter/nf_nat_core.c | 7 ++++++-
>   1 file changed, 6 insertions(+), 1 deletion(-)
>
> diff --git a/net/netfilter/nf_nat_core.c b/net/netfilter/nf_nat_core.c
> index 18319a6e6806..b24b4dfc1ca4 100644
> --- a/net/netfilter/nf_nat_core.c
> +++ b/net/netfilter/nf_nat_core.c
> @@ -1152,7 +1152,12 @@ static int __init nf_nat_init(void)
>   	WARN_ON(nf_nat_hook != NULL);
>   	RCU_INIT_POINTER(nf_nat_hook, &nat_hook);
>   
> -	return register_nf_nat_bpf();
> +	ret = register_nf_nat_bpf();
> +	if (ret < 0) {
> +		kvfree(nf_nat_bysource);
> +		unregister_pernet_subsys(&nat_net_ops);
> +	}
> +	return ret;
>   }

I noticed that follow_master_nat should also be unregistered.

Going to send v2, discard this one.


Best,

Chen

>   
>   static void __exit nf_nat_cleanup(void)
