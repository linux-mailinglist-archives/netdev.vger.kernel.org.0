Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D38E14CEBEC
	for <lists+netdev@lfdr.de>; Sun,  6 Mar 2022 15:27:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233621AbiCFO2G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 6 Mar 2022 09:28:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229463AbiCFO2F (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 6 Mar 2022 09:28:05 -0500
Received: from out30-132.freemail.mail.aliyun.com (out30-132.freemail.mail.aliyun.com [115.124.30.132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F4C94EF6A;
        Sun,  6 Mar 2022 06:27:12 -0800 (PST)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R161e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04426;MF=dust.li@linux.alibaba.com;NM=1;PH=DS;RN=7;SR=0;TI=SMTPD_---0V6MKPYm_1646576828;
Received: from localhost(mailfrom:dust.li@linux.alibaba.com fp:SMTPD_---0V6MKPYm_1646576828)
          by smtp.aliyun-inc.com(127.0.0.1);
          Sun, 06 Mar 2022 22:27:09 +0800
Date:   Sun, 6 Mar 2022 22:27:08 +0800
From:   "dust.li" <dust.li@linux.alibaba.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Karsten Graul <kgraul@linux.ibm.com>,
        Tony Lu <tonylu@linux.alibaba.com>, davem@davemloft.net,
        netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        linux-rdma@vger.kernel.org
Subject: Re: [PATCH net-next v2] net/smc: fix compile warning for smc_sysctl
Message-ID: <20220306142708.GD35207@linux.alibaba.com>
Reply-To: dust.li@linux.alibaba.com
References: <20220303084006.54313-1-dust.li@linux.alibaba.com>
 <20220304213151.04ecbe8f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220304213151.04ecbe8f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
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

On Fri, Mar 04, 2022 at 09:31:51PM -0800, Jakub Kicinski wrote:
>On Thu,  3 Mar 2022 16:40:06 +0800 Dust Li wrote:
>> kernel test robot reports multiple warning for smc_sysctl:
>> 
>>   In file included from net/smc/smc_sysctl.c:17:
>> >> net/smc/smc_sysctl.h:23:5: warning: no previous prototype \  
>> 	for function 'smc_sysctl_init' [-Wmissing-prototypes]
>>   int smc_sysctl_init(void)
>>        ^
>> and
>>   >> WARNING: modpost: vmlinux.o(.text+0x12ced2d): Section mismatch \  
>>   in reference from the function smc_sysctl_exit() to the variable
>>   .init.data:smc_sysctl_ops
>>   The function smc_sysctl_exit() references
>>   the variable __initdata smc_sysctl_ops.
>>   This is often because smc_sysctl_exit lacks a __initdata
>>   annotation or the annotation of smc_sysctl_ops is wrong.
>> 
>> and
>>   net/smc/smc_sysctl.c: In function 'smc_sysctl_init_net':
>>   net/smc/smc_sysctl.c:47:17: error: 'struct netns_smc' has no member named 'smc_hdr'
>>      47 |         net->smc.smc_hdr = register_net_sysctl(net, "net/smc", table);
>> 
>> Since we don't need global sysctl initialization. To make things
>> clean and simple, remove the global pernet_operations and
>> smc_sysctl_{init|exit}. Call smc_sysctl_net_{init|exit} directly
>> from smc_net_{init|exit}.
>> 
>> Also initialized sysctl_autocorking_size if CONFIG_SYSCTL it not
>> set, this makes sure SMC autocorking is enabled by default if
>> CONFIG_SYSCTL is not set.
>
>I think that makes sense, one nit below.
>
>> -static __net_init int smc_sysctl_init_net(struct net *net)
>> +int smc_sysctl_net_init(struct net *net)
>>  {
>>  	struct ctl_table *table;
>>  
>> @@ -59,22 +59,7 @@ static __net_init int smc_sysctl_init_net(struct net *net)
>>  	return -ENOMEM;
>>  }
>>  
>> -static __net_exit void smc_sysctl_exit_net(struct net *net)
>> +void smc_sysctl_net_exit(struct net *net)
>>  {
>>  	unregister_net_sysctl_table(net->smc.smc_hdr);
>>  }
>
>> +int smc_sysctl_net_init(struct net *net);
>> +void smc_sysctl_net_exit(struct net *net);
>
>I believe these functions can become / remain __net_init and __net_exit,
>since all the callers are also marked as such.

Agree, I will add this in the next version.


>
>>  #else
>>  
>> -int smc_sysctl_init(void)
>> +static inline int smc_sysctl_net_init(struct net *net)
>>  {
>> +	net->smc.sysctl_autocorking_size = SMC_AUTOCORKING_DEFAULT_SIZE;
>>  	return 0;
>>  }
>>  
>> -void smc_sysctl_exit(void) { }
>> +static inline void smc_sysctl_net_exit(struct net *net) { }
>
>Doesn't matter for static inlines.

OK

Thanks for you advice

>
>>  #endif /* CONFIG_SYSCTL */
>>  
