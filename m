Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 801AE4CEFE4
	for <lists+netdev@lfdr.de>; Mon,  7 Mar 2022 03:59:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234907AbiCGDAW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 6 Mar 2022 22:00:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234906AbiCGDAU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 6 Mar 2022 22:00:20 -0500
Received: from out30-133.freemail.mail.aliyun.com (out30-133.freemail.mail.aliyun.com [115.124.30.133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4E3EDFAF;
        Sun,  6 Mar 2022 18:59:25 -0800 (PST)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R771e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04423;MF=dust.li@linux.alibaba.com;NM=1;PH=DS;RN=8;SR=0;TI=SMTPD_---0V6OHzgx_1646621961;
Received: from localhost(mailfrom:dust.li@linux.alibaba.com fp:SMTPD_---0V6OHzgx_1646621961)
          by smtp.aliyun-inc.com(127.0.0.1);
          Mon, 07 Mar 2022 10:59:22 +0800
Date:   Mon, 7 Mar 2022 10:59:21 +0800
From:   "dust.li" <dust.li@linux.alibaba.com>
To:     Randy Dunlap <rdunlap@infradead.org>,
        Karsten Graul <kgraul@linux.ibm.com>,
        Tony Lu <tonylu@linux.alibaba.com>, davem@davemloft.net,
        kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        linux-rdma@vger.kernel.org
Subject: Re: [PATCH net-next v3] net/smc: fix compile warning for smc_sysctl
Message-ID: <20220307025921.GE35207@linux.alibaba.com>
Reply-To: dust.li@linux.alibaba.com
References: <20220307015424.59154-1-dust.li@linux.alibaba.com>
 <f0aec757-185b-8c78-8c39-dacb3520ce74@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f0aec757-185b-8c78-8c39-dacb3520ce74@infradead.org>
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

On Sun, Mar 06, 2022 at 06:36:35PM -0800, Randy Dunlap wrote:
>
>
>On 3/6/22 17:54, Dust Li wrote:
>> kernel test robot reports multiple warning for smc_sysctl:
>
>when SYSCTL is not enabled
>(AFAIK)

Right. CONFIG_SMC=m|y and CONFIG_SYSCTL is not enabled.

>
>>   In file included from net/smc/smc_sysctl.c:17:
>>>> net/smc/smc_sysctl.h:23:5: warning: no previous prototype \
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
>> set, this make sure SMC autocorking is enabled by default if
>> CONFIG_SYSCTL is not set.
>> 
>> Fixes: 462791bbfa35 ("net/smc: add sysctl interface for SMC")
>> Reported-by: kernel test robot <lkp@intel.com>
>> Signed-off-by: Dust Li <dust.li@linux.alibaba.com>
>> 
>> ---
>> v3: 1. add __net_{init|exit} annotation for smc_sysctl_net_{init|exit}
>>        sugguested by Jakub Kicinski
>>     2. Remove static inline for smc_sysctl_net_{init|exit} if
>>        CONFIG_SYSCTL not defined
>> v2: 1. Removes pernet_operations and smc_sysctl_{init|exit}
>>     2. Initialize sysctl_autocorking_size if CONFIG_SYSCTL not set
>> ---
>>  net/smc/Makefile     |  3 ++-
>>  net/smc/af_smc.c     | 15 ++++++---------
>>  net/smc/smc_sysctl.c | 19 ++-----------------
>>  net/smc/smc_sysctl.h |  9 +++++----
>>  4 files changed, 15 insertions(+), 31 deletions(-)
>
>Tested-by: Randy Dunlap <rdunlap@infradead.org> # build-tested

Thanks a lot for testing !

>
>thanks.
>
>-- 
>~Randy
