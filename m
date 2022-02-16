Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B1B164B86FF
	for <lists+netdev@lfdr.de>; Wed, 16 Feb 2022 12:46:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232254AbiBPLqg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Feb 2022 06:46:36 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:38798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232250AbiBPLqf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Feb 2022 06:46:35 -0500
Received: from out30-132.freemail.mail.aliyun.com (out30-132.freemail.mail.aliyun.com [115.124.30.132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C81A27FC1;
        Wed, 16 Feb 2022 03:46:22 -0800 (PST)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R621e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04400;MF=dust.li@linux.alibaba.com;NM=1;PH=DS;RN=9;SR=0;TI=SMTPD_---0V4cycIW_1645011978;
Received: from localhost(mailfrom:dust.li@linux.alibaba.com fp:SMTPD_---0V4cycIW_1645011978)
          by smtp.aliyun-inc.com(127.0.0.1);
          Wed, 16 Feb 2022 19:46:19 +0800
Date:   Wed, 16 Feb 2022 19:46:18 +0800
From:   "dust.li" <dust.li@linux.alibaba.com>
To:     Karsten Graul <kgraul@linux.ibm.com>,
        Tony Lu <tonylu@linux.alibaba.com>,
        Stefan Raspl <raspl@linux.ibm.com>
Cc:     "D. Wythe" <alibuda@linux.alibaba.com>, kuba@kernel.org,
        davem@davemloft.net, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-rdma@vger.kernel.org
Subject: Re: [PATCH net-next v2] net/smc: Reduce overflow of smc clcsock
 listen queue
Message-ID: <20220216114618.GA39286@linux.alibaba.com>
Reply-To: dust.li@linux.alibaba.com
References: <1641301961-59331-1-git-send-email-alibuda@linux.alibaba.com>
 <8a60dabb-1799-316c-80b5-14c920fe98ab@linux.ibm.com>
 <20220105044049.GA107642@e02h04389.eu6sqa>
 <20220105085748.GD31579@linux.alibaba.com>
 <b98aefce-e425-9501-aacc-8e5a4a12953e@linux.ibm.com>
 <20220105150612.GA75522@e02h04389.eu6sqa>
 <d35569df-e0e0-5ea7-9aeb-7ffaeef04b14@linux.ibm.com>
 <YdaUuOq+SkhYTWU8@TonyMac-Alibaba>
 <5a5ba1b6-93d7-5c1e-aab2-23a52727fbd1@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5a5ba1b6-93d7-5c1e-aab2-23a52727fbd1@linux.ibm.com>
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 13, 2022 at 09:07:51AM +0100, Karsten Graul wrote:

>>> One comment to sysctl: our current approach is to add new switches to the existing 
>>> netlink interface which can be used with the smc-tools package (or own implementations of course). 
>>> Is this prereq problematic in your environment? 
>>> We tried to avoid more sysctls and the netlink interface keeps use more flexible.
>> 
>> I agree with you about using netlink is more flexible. There are
>> something different in our environment to use netlink to control the
>> behaves of smc.
>> 
>> Compared with netlink, sysctl is:
>> - easy to use on clusters. Applications who want to use smc, don't need
>>   to deploy additional tools or developing another netlink logic,
>>   especially for thousands of machines or containers. With smc forward,
>>   we should make sure the package or logic is compatible with current
>>   kernel, but sysctl's API compatible is easy to discover.
>> 
>> - config template and default maintain. We are using /etc/sysctl.conf to
>>   make sure the systeml configures update to date, such as pre-tuned smc
>>   config parameters. So that we can change this default values on boot,
>>   and generate lots of machines base on this machine template. Userspace
>>   netlink tools doesn't suit for it, for example ip related config, we
>>   need additional NetworkManager or netctl to do this.
>> 
>> - TCP-like sysctl entries. TCP provides lots of sysctl to configure
>>   itself, somethings it is hard to use and understand. However, it is
>>   accepted by most of users and system. Maybe we could use sysctl for
>>   the item that frequently and easy to change, netlink for the complex
>>   item.
>> 
>> We are gold to contribute to smc-tools. Use netlink and sysctl both
>> time, I think, is a more suitable choice.
>
>Lets decide that when you have a specific control that you want to implement. 
>I want to have a very good to introduce another interface into the SMC module,
>making the code more complex and all of that. The decision for the netlink interface 
>was also done because we have the impression that this is the NEW way to go, and
>since we had no interface before we started with the most modern way to implement it.
>
>TCP et al have a history with sysfs, so thats why it is still there. 
>But I might be wrong on that...

Sorry to bother on this topic again...

When implementing SMC autocork, I'd like to add a switch to enable or
disable SMC autocork just like what TCP does. But I encounter some
problem which I think might be relevant to this topic.

My requirements for the switch is like this:
1. Can be set dynamically by an userspace tool
2. Need to be namespacified so different containers can have their own
value
3. Should be able to be configured to some default values using a
configuration file so every time a container started, those values can
be set properly.


I notice we have a patch recently("net/smc: Add global configure for
handshake limitation by netlink") which did something similar. And I
tried the same way but found it might not be very elegant:
1. I need to copy most of the code(enable/disable/dump) for autocork
   which is quite redundant. Maybe we should add some common wrappers ?
2. I need to add a new enumeration, and what if years later, we found
   this function is no longer need ? Deleting this may cause ABI
   compatibility issues
3. Finally, How can we implement requirement #3 ? It is really needed
   in the K8S container environment.

Any suggestions or comments are really welcomed.

Thanks!
