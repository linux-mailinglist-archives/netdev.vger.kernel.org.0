Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9A4A54CB50B
	for <lists+netdev@lfdr.de>; Thu,  3 Mar 2022 03:40:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231776AbiCCCgO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Mar 2022 21:36:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231892AbiCCCgJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Mar 2022 21:36:09 -0500
Received: from out30-45.freemail.mail.aliyun.com (out30-45.freemail.mail.aliyun.com [115.124.30.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFD49124C1F;
        Wed,  2 Mar 2022 18:35:23 -0800 (PST)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R101e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e01424;MF=dust.li@linux.alibaba.com;NM=1;PH=DS;RN=9;SR=0;TI=SMTPD_---0V65YL3i_1646274920;
Received: from localhost(mailfrom:dust.li@linux.alibaba.com fp:SMTPD_---0V65YL3i_1646274920)
          by smtp.aliyun-inc.com(127.0.0.1);
          Thu, 03 Mar 2022 10:35:20 +0800
Date:   Thu, 3 Mar 2022 10:35:19 +0800
From:   "dust.li" <dust.li@linux.alibaba.com>
To:     Jakub Kicinski <kuba@kernel.org>, kernel test robot <lkp@intel.com>
Cc:     Karsten Graul <kgraul@linux.ibm.com>,
        Tony Lu <tonylu@linux.alibaba.com>, davem@davemloft.net,
        kbuild-all@lists.01.org, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-rdma@vger.kernel.org
Subject: Re: [PATCH net-next] net/smc: fix compile warning for smc_sysctl
Message-ID: <20220303023519.GA35207@linux.alibaba.com>
Reply-To: dust.li@linux.alibaba.com
References: <20220302034312.31168-1-dust.li@linux.alibaba.com>
 <202203022234.AMB3WcyJ-lkp@intel.com>
 <20220302114503.47d64a55@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220302114503.47d64a55@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 02, 2022 at 11:45:03AM -0800, Jakub Kicinski wrote:
>On Wed, 2 Mar 2022 23:02:23 +0800 kernel test robot wrote:
>>    In file included from net/smc/smc_sysctl.c:18:
>>    net/smc/smc_sysctl.h:23:19: note: previous definition of 'smc_sysctl_init' with type 'int(void)'
>>       23 | static inline int smc_sysctl_init(void)
>>          |                   ^~~~~~~~~~~~~~~
>> >> net/smc/smc_sysctl.c:78:1: warning: ignoring attribute 'noinline' because it conflicts with attribute 'gnu_inline' [-Wattributes]  
>>       78 | {
>>          | ^
>
>The __net_init / __net_exit attr has to go on the prototype as well.

Thanks a lot for pointing out !

>
>This doesn't look right, tho, why __net_* attrs?  You call those
>functions from the module init/exit. __net_ is for namespace code.

Yes, I made the mistake and mixes up smc_sysctl_{init|exit}() with
smc_sysctl_{init|exit}_net when doing the quick fix...

And my check script with neither allyesconfig/allnoconfig nor defconfig
reproduced this.
This happens when CONFIG_SMC=y|m and CONFIG_SYSCTL is not set.

I will send a v2.

Thanks.
