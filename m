Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 179796DC7DB
	for <lists+netdev@lfdr.de>; Mon, 10 Apr 2023 16:31:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229788AbjDJObJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Apr 2023 10:31:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229720AbjDJObI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Apr 2023 10:31:08 -0400
Received: from out30-101.freemail.mail.aliyun.com (out30-101.freemail.mail.aliyun.com [115.124.30.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1DDC155A1;
        Mon, 10 Apr 2023 07:31:03 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R121e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018046056;MF=guwen@linux.alibaba.com;NM=1;PH=DS;RN=12;SR=0;TI=SMTPD_---0VfoSjxI_1681137058;
Received: from 30.221.131.183(mailfrom:guwen@linux.alibaba.com fp:SMTPD_---0VfoSjxI_1681137058)
          by smtp.aliyun-inc.com;
          Mon, 10 Apr 2023 22:30:59 +0800
Message-ID: <340abce3-9a54-8dea-9212-a0a1b60b7375@linux.alibaba.com>
Date:   Mon, 10 Apr 2023 22:30:57 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.8.0
Subject: Re: [RFC PATCH net-next v4 0/9] net/smc: Introduce SMC-D-based OS
 internal communication acceleration
To:     Niklas Schnelle <schnelle@linux.ibm.com>,
        Alexandra Winter <wintera@linux.ibm.com>, kgraul@linux.ibm.com,
        wenjia@linux.ibm.com, jaka@linux.ibm.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com
Cc:     linux-s390@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <1679887699-54797-1-git-send-email-guwen@linux.alibaba.com>
 <6156aaad710bc7350cbae6cb821289c8a37f44bb.camel@linux.ibm.com>
 <33ab688e-88c9-d950-be66-f0f79774ff6c@linux.ibm.com>
 <5a678df91455e29f296de25ef4aee25cae0e23d6.camel@linux.ibm.com>
From:   Wen Gu <guwen@linux.alibaba.com>
In-Reply-To: <5a678df91455e29f296de25ef4aee25cae0e23d6.camel@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-11.2 required=5.0 tests=ENV_AND_HDR_SPF_MATCH,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS,UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2023/4/6 22:27, Niklas Schnelle wrote:

> On Thu, 2023-04-06 at 13:14 +0200, Alexandra Winter wrote:
>>
>> On 05.04.23 19:04, Niklas Schnelle wrote:
>>> One more question though, what about the SEID why does that have to be
>>> fixed and at least partially match what ISM devices use? I think I'm
>>> missing some SMC protocol/design detail here. I'm guessing this would
>>> require a protocol change?
>>>
>>> Thanks,
>>> Niklas
>>
>> Niklas,
>> in the initial SMC CLC handshake the client and server exchange the SEID (one per peer system)
>> and up to 8 proposals for SMC-D interfaces.
>> Wen's current proposal assumes that smc-d loopback can be one of these 8 proposed interfaces,
>> iiuc. So on s390 the proposal can contain ISM devices and a smc-d loopback device at the same time.
>> If one of the peers is e.g. an older Linux version, it will just ignore the loopback-device
>> in the list (Don't find a match for CHID 0xFFFF) and use an ISM interface for SMC-D if possible.
>> Therefor it is important that the SEID is used in the same way as it is today in the handshake.
>>
>> If we decide for some reason (virtio-ism open issues?) that a protocol change/extension is
>> required/wanted, then it is a new game and we can come up with new identifiers, but we may
>> lose compatibility to backlevel systems.
>>
>> Alexandra
> 
> Ok that makes sense to me. I was looking at the code in patch 4 of this
> series and there it looks to me like SMC-D loopback as implemented
> would always use the newly added SMCD_DEFAULT_V2_SEID might have
> misread it though. From your description I think that would be wrong,
> if a SEID is defined as on s390 it should use that SEID in the CLC for
> all SMC variants. Similarly on other architectures it should use the
> same SEID for SMC-D as for SMC-R, right? Also with partially match I
> was actually wrong the SMCD_DEFAULT_V2_SEID.seid_string starts with
> "IBM-DEF-ISMSEID…" while on s390's existing ISM we use "IBM-SYSZ-
> ISMSEID…" so if SMC-D loopback correctly uses the shared SEID on s390
> we can already only get GID.DMB collisions only on the same mainframe.
> 
> Thanks,
> Niklas

SMC stack uses a global variable smc_ism_v2_system_eid to indicate
the only one SEID of system. Because all ISMv2 devices return the same
SEID, SEID of the first registered ISMv2 device will be assigned to
smc_ism_v2_system_eid.

Now we have extension SMC-D devices, loopback or virtio-ism device,
and this may need a little change.

My original idea was that

- Extension SMC-D devices always return SMCD_DEFAULT_V2_SEID as SEID.
- If there is only extension device in the system, smc_ism_v2_system_eid
   will record SMCD_DEFAULT_V2_SEID returned by SMC-D extension device.
- If extension devices coexist with ISM devices on s390, smc_ism_v2_system_eid
   will record SEID of ISM devices.

But inspired by your comments, I find the original idea has some problems
in situation that one side has only extension devices but the other side
has both extension and ISM devices. Although they can communicate through
the extension devices(virtio-ism), SMC-D connection is unavailable due to
the different SEIDs.

So as you suggested, the extension devices (loopback or virtio-ism) should
use the same way as ISM device to get the shared SEID on s390 arch.

And on arch other than s390, extension SMC-D device can use a fixed SEID like
SMCD_DEFAULT_V2_SEID here if we do not require SMC-D communication between
different architectures.

Thanks,
Wen Gu
