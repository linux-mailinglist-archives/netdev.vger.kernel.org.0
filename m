Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5DF014BA0F5
	for <lists+netdev@lfdr.de>; Thu, 17 Feb 2022 14:22:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237724AbiBQNWW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Feb 2022 08:22:22 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:46546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230153AbiBQNWV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Feb 2022 08:22:21 -0500
Received: from out199-12.us.a.mail.aliyun.com (out199-12.us.a.mail.aliyun.com [47.90.199.12])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5BE5B11C24;
        Thu, 17 Feb 2022 05:22:05 -0800 (PST)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R171e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04426;MF=dust.li@linux.alibaba.com;NM=1;PH=DS;RN=8;SR=0;TI=SMTPD_---0V4kW.U-_1645104120;
Received: from localhost(mailfrom:dust.li@linux.alibaba.com fp:SMTPD_---0V4kW.U-_1645104120)
          by smtp.aliyun-inc.com(127.0.0.1);
          Thu, 17 Feb 2022 21:22:01 +0800
Date:   Thu, 17 Feb 2022 21:22:00 +0800
From:   "dust.li" <dust.li@linux.alibaba.com>
To:     Stefan Raspl <raspl@linux.ibm.com>,
        Karsten Graul <kgraul@linux.ibm.com>,
        Tony Lu <tonylu@linux.alibaba.com>
Cc:     kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-rdma@vger.kernel.org
Subject: Re: [PATCH] net/smc: Add autocork support
Message-ID: <20220217132200.GA5443@linux.alibaba.com>
Reply-To: dust.li@linux.alibaba.com
References: <20220216034903.20173-1-dust.li@linux.alibaba.com>
 <68e9534b-7ff5-5a65-9017-124dbae0c74b@linux.ibm.com>
 <20220216152721.GB39286@linux.alibaba.com>
 <454b5efd-e611-2dfb-e462-e7ceaee0da4d@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <454b5efd-e611-2dfb-e462-e7ceaee0da4d@linux.ibm.com>
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 17, 2022 at 10:37:28AM +0100, Stefan Raspl wrote:
>On 2/16/22 16:27, dust.li wrote:
>> On Wed, Feb 16, 2022 at 02:58:32PM +0100, Stefan Raspl wrote:
>> > On 2/16/22 04:49, Dust Li wrote:
>> > > diff --git a/net/smc/smc_tx.c b/net/smc/smc_tx.c
>> > > index 5df3940d4543..bc737ac79805 100644
>> > > --- a/net/smc/smc_tx.c
>> > > +++ b/net/smc/smc_tx.c
>> > > @@ -31,6 +31,7 @@
>> > >    #include "smc_tracepoint.h"
>> > >    #define SMC_TX_WORK_DELAY	0
>> > > +#define SMC_DEFAULT_AUTOCORK_SIZE	(64 * 1024)
>> > 
>> > Probably a matter of taste, but why not use hex here?
>> 
>> Yeah, I have no option on this, I will change it in the next version.
>> But I think it should have no real difference since the compiler
>> should do the calculation.
>
>Agreed - this is just to make it a tiny bit easier to digest.
>
>
>> > Are there any fixed plans to make SMC_DEFAULT_AUTOCORK dynamic...? 'cause
>> > otherwise we could simply eliminate this parameter, and use the define within
>> > smc_should_autocork() instead.
>> 
>> Yes! Actually I'd like it to be dynamic variable too...
>> 
>> I didn't do it because I also want to add a control switch for the autocork
>> feature just like TCP. In that case I need to add 2 variables here.
>> But I found adding dynamic variables using netlink would introduce a lot of
>> redundant code and may even bring ABI compatibility issues in the future, as
>> I mentioned here:
>> https://lore.kernel.org/netdev/20220216114618.GA39286@linux.alibaba.com/T/#mecfcd3f8c816d07dbe35e4748d17008331c89523
>> 
>> I'm not sure that's the right way to do it. In this case, I prefer using
>> sysctl which I think would be easier, but I would like to listen to your advice.
>
>Extending the Netlink interface should be possible without breaking the API -
>we'd be adding further variables, not modifying or removing existing ones.
>Conceptually, Netlink is the way to go for any userspace interaction with
>SMC, which includes anything config-related.


>Now we understand that cloud workloads are a bit different, and the desire to
>be able to modify the environment of a container while leaving the container
>image unmodified is understandable. But then again, enabling the base image
>would be the cloud way to address this. The question to us is: How do other
>parts of the kernel address this?

I'm not familiar with K8S, but from one of my colleague who has worked
in that area tells me for resources like CPU/MEM and configurations
like sysctl, can be set using K8S configuration:
https://kubernetes.io/docs/tasks/administer-cluster/sysctl-cluster/

I don't know. Maybe because most of the current kernel configurations
are configured through sysfs that for those container orchestration
systems have supported it ?

Thanks
