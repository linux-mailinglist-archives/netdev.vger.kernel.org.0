Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3195968166C
	for <lists+netdev@lfdr.de>; Mon, 30 Jan 2023 17:31:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237520AbjA3QbC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Jan 2023 11:31:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237589AbjA3Qat (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Jan 2023 11:30:49 -0500
Received: from out199-12.us.a.mail.aliyun.com (out199-12.us.a.mail.aliyun.com [47.90.199.12])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D9DF360BF;
        Mon, 30 Jan 2023 08:30:47 -0800 (PST)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R391e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018046056;MF=guwen@linux.alibaba.com;NM=1;PH=DS;RN=11;SR=0;TI=SMTPD_---0VaTPF9e_1675096241;
Received: from 30.120.173.137(mailfrom:guwen@linux.alibaba.com fp:SMTPD_---0VaTPF9e_1675096241)
          by smtp.aliyun-inc.com;
          Tue, 31 Jan 2023 00:30:42 +0800
Message-ID: <3232f433-5025-b435-2fb5-f4435fd9465b@linux.alibaba.com>
Date:   Tue, 31 Jan 2023 00:30:41 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.6.1
Subject: Re: [RFC PATCH net-next v2 1/5] net/smc: introduce SMC-D loopback
 device
To:     Alexandra Winter <wintera@linux.ibm.com>, kgraul@linux.ibm.com,
        wenjia@linux.ibm.com, jaka@linux.ibm.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com
Cc:     linux-s390@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <1671506505-104676-1-git-send-email-guwen@linux.alibaba.com>
 <1671506505-104676-2-git-send-email-guwen@linux.alibaba.com>
 <2ff23fc7-c393-46b8-e358-31a39ed2c56b@linux.ibm.com>
From:   Wen Gu <guwen@linux.alibaba.com>
In-Reply-To: <2ff23fc7-c393-46b8-e358-31a39ed2c56b@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-10.0 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,
        UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2023/1/20 00:25, Alexandra Winter wrote:
> 
> 
> On 20.12.22 04:21, Wen Gu wrote:
>> This patch introduces a kind of loopback device for SMC-D, thus
>> enabling the SMC communication between two local sockets in one
>> kernel.
>>
>> The loopback device supports basic capabilities defined by SMC-D,
>> including registering DMB, unregistering DMB and moving data.
>>
>> Considering that there is no ism device on other servers expect
>> IBM z13,
> 
> Please use the wording 'on other architectures except s390'.
> That is how IBM Z is referred to in the Linux kernel.
> 

Thanks, will use words consistent with this.

> 
>> the loopback device can be used as a dummy device to
>> test SMC-D logic for the broad community.
>>
>> Signed-off-by: Wen Gu <guwen@linux.alibaba.com>
>> ---
> 
> Hello Wen Gu,
> 
> as the general design discussions are ongoing, I didn't
> do a thorough review. But here are some general remarks
> that you may want to consider for future versions.
> I would propose to add a module parameter (default off) to enable
> SMC-D loopback.
> 

OK, will add a module parameter in the future version.

>>   include/net/smc.h      |   1 +
>>   net/smc/Makefile       |   2 +-
>>   net/smc/af_smc.c       |  12 ++-
>>   net/smc/smc_cdc.c      |   6 ++
>>   net/smc/smc_cdc.h      |   1 +
>>   net/smc/smc_loopback.c | 282 +++++++++++++++++++++++++++++++++++++++++++++++++
>>   net/smc/smc_loopback.h |  59 +++++++++++
>>   7 files changed, 361 insertions(+), 2 deletions(-)
>>   create mode 100644 net/smc/smc_loopback.c
>>   create mode 100644 net/smc/smc_loopback.h
>>
> 
> I am not convinced that this warrants a separate file.

IMHO, the dummy device used by smcd loopback is corresponding to ISM device.
So I put the dummy device implementation in smc_loopback.c alone, imitating
drivers/s390/net/ism_drv.c. I think it maybe clearer to do so.

> 
> [...]
>>
>> +}
>> +
>> +static int lo_add_vlan_id(struct smcd_dev *smcd, u64 vlan_id)
>> +{
>> +	return 0;
>> +}
>> +
>> +static int lo_del_vlan_id(struct smcd_dev *smcd, u64 vlan_id)
>> +{
>> +	return 0;
>> +}
>> +
>> +static int lo_set_vlan_required(struct smcd_dev *smcd)
>> +{
>> +	return 0;
>> +}
>> +
>> +static int lo_reset_vlan_required(struct smcd_dev *smcd)
>> +{
>> +	return 0;
>> +}
> 
> The VLAN functions are only required for SMC-Dv1
> Seems you want to provide v1 support for loopback?
> May be nice for testing v1 VLAN support.
> But then you need proper VLAN support.
> 
Based on the current discussion, I tend to only provide v2 support for loopback
since v2 is the general trend. So I will fix this in the future version.

> [...]
>> +
>> +static u8 *lo_get_system_eid(void)
>> +{
>> +	return &LO_SYSTEM_EID.seid_string[0];
>> +}
> SEID is for the whole system not per device.
> We probably need to register a different function
> for each architecture.
> 

Yes, I agree.


>> +
>> +static u16 lo_get_chid(struct smcd_dev *smcd)
>> +{
>> +	return 0;
>> +}
>> +
> 
> Shouldn't this return 0xFFFF in your current concept?
> 
> 

Yes, this should return 0xFFFF.
I supplemented a patch as attachment in this earlier reply:
https://lore.kernel.org/netdev/b25f56de-7913-2a56-950f-dfe0defd6936@linux.alibaba.com/
and have amended this.
