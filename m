Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 75C354E8BD2
	for <lists+netdev@lfdr.de>; Mon, 28 Mar 2022 03:59:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231680AbiC1CAr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 27 Mar 2022 22:00:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230063AbiC1CAo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 27 Mar 2022 22:00:44 -0400
Received: from out30-56.freemail.mail.aliyun.com (out30-56.freemail.mail.aliyun.com [115.124.30.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E29962C6
        for <netdev@vger.kernel.org>; Sun, 27 Mar 2022 18:59:03 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R141e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e01424;MF=tonylu@linux.alibaba.com;NM=1;PH=DS;RN=8;SR=0;TI=SMTPD_---0V8KLcU9_1648432739;
Received: from localhost(mailfrom:tonylu@linux.alibaba.com fp:SMTPD_---0V8KLcU9_1648432739)
          by smtp.aliyun-inc.com(127.0.0.1);
          Mon, 28 Mar 2022 09:59:00 +0800
Date:   Mon, 28 Mar 2022 09:58:58 +0800
From:   Tony Lu <tonylu@linux.alibaba.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        syzbot <syzkaller@googlegroups.com>,
        Dust Li <dust.li@linux.alibaba.com>
Subject: Re: [PATCH net] net/smc: fix a memory leak in smc_sysctl_net_exit()
Message-ID: <YkEWYutckbyQoa62@TonyMac-Alibaba>
Reply-To: Tony Lu <tonylu@linux.alibaba.com>
References: <20220325165021.570708-1-eric.dumazet@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220325165021.570708-1-eric.dumazet@gmail.com>
X-Spam-Status: No, score=-10.9 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H5,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 25, 2022 at 09:50:21AM -0700, Eric Dumazet wrote:
> From: Eric Dumazet <edumazet@google.com>
> 
> Recently added smc_sysctl_net_exit() forgot to free
> the memory allocated from smc_sysctl_net_init()
> for non initial network namespace.
> 
> Fixes: 462791bbfa35 ("net/smc: add sysctl interface for SMC")
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Reported-by: syzbot <syzkaller@googlegroups.com>
> Cc: Tony Lu <tonylu@linux.alibaba.com>
> Cc: Dust Li <dust.li@linux.alibaba.com>
> ---
>  net/smc/smc_sysctl.c | 5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/net/smc/smc_sysctl.c b/net/smc/smc_sysctl.c
> index bae19419e7553222d74c2ae178fd5a2b6116679b..cf3ab1334c009a1a0539b2c228c4503ae391d89b 100644
> --- a/net/smc/smc_sysctl.c
> +++ b/net/smc/smc_sysctl.c
> @@ -61,5 +61,10 @@ int __net_init smc_sysctl_net_init(struct net *net)
>  
>  void __net_exit smc_sysctl_net_exit(struct net *net)
>  {
> +	struct ctl_table *table;
> +
> +	table = net->smc.smc_hdr->ctl_table_arg;
>  	unregister_net_sysctl_table(net->smc.smc_hdr);
> +	if (!net_eq(net, &init_net))
> +		kfree(table);
>  }

Thanks a lot for fixing this issue, this is my fault.

Tony Lu
