Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 414ED6CFB25
	for <lists+netdev@lfdr.de>; Thu, 30 Mar 2023 08:02:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230023AbjC3GCH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Mar 2023 02:02:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230011AbjC3GCA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Mar 2023 02:02:00 -0400
X-Greylist: delayed 48770 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 29 Mar 2023 23:01:43 PDT
Received: from forwardcorp1a.mail.yandex.net (forwardcorp1a.mail.yandex.net [178.154.239.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A308565BA;
        Wed, 29 Mar 2023 23:01:42 -0700 (PDT)
Received: from mail-nwsmtp-smtp-corp-main-62.vla.yp-c.yandex.net (mail-nwsmtp-smtp-corp-main-62.vla.yp-c.yandex.net [IPv6:2a02:6b8:c0d:3786:0:640:7c97:0])
        by forwardcorp1a.mail.yandex.net (Yandex) with ESMTP id 975765FEED;
        Thu, 30 Mar 2023 09:01:37 +0300 (MSK)
Received: from [IPV6:2a02:6b8:b081:b502::1:25] (unknown [2a02:6b8:b081:b502::1:25])
        by mail-nwsmtp-smtp-corp-main-62.vla.yp-c.yandex.net (smtpcorp/Yandex) with ESMTPSA id Z1CoQ70OrW20-2kVAMQRA;
        Thu, 30 Mar 2023 09:01:36 +0300
X-Yandex-Fwd: 1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex-team.ru; s=default;
        t=1680156097; bh=WxZblk8zP/PpvV733dqP5OGbqFyUaHE6g96KWu2H4Nc=;
        h=From:In-Reply-To:Cc:Date:References:To:Subject:Message-ID;
        b=giPk5XoEoiMdCaRmRcd6Kwxxt0xxtX2pS+QpLy7JBX8rz3ip0UgZsktieGwFrd5Hx
         bYtb7hpPsVHmzPCj647UhLQVwyMxIWnl1ZNoAcSkHdo7BQwJu/gCv+950kZIYoLLVR
         kKoFlUOoC0IXi1z6pzBLvCoPnolZ3njcCxGpDNfE=
Authentication-Results: mail-nwsmtp-smtp-corp-main-62.vla.yp-c.yandex.net; dkim=pass header.i=@yandex-team.ru
Message-ID: <bd780d59-4e3d-34bc-a2e4-aece5c851028@yandex-team.ru>
Date:   Thu, 30 Mar 2023 09:01:35 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: Re: [PATCH] net: netxen: report error on version offset reading
To:     Leon Romanovsky <leon@kernel.org>
Cc:     GR-Linux-NIC-Dev@marvell.com, manishc@marvell.com,
        rahulv@marvell.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com
References: <20230329162629.96590-1-den-plotnikov@yandex-team.ru>
 <20230329185907.GE831478@unreal>
Content-Language: en-US
From:   Denis Plotnikov <den-plotnikov@yandex-team.ru>
In-Reply-To: <20230329185907.GE831478@unreal>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 29.03.2023 21:59, Leon Romanovsky wrote:
> On Wed, Mar 29, 2023 at 07:26:29PM +0300, Denis Plotnikov wrote:
>> A static analyzer complains for non-checking the function returning value.
>> Although, the code looks like not expecting any problems with version
>> reading on netxen_p3_has_mn call, it seems the error still may happen.
>> So, at least, add error reporting to ease problems investigation.
>>
>> Signed-off-by: Denis Plotnikov <den-plotnikov@yandex-team.ru>
>> ---
>>   drivers/net/ethernet/qlogic/netxen/netxen_nic_init.c | 9 +++++++--
>>   1 file changed, 7 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/net/ethernet/qlogic/netxen/netxen_nic_init.c b/drivers/net/ethernet/qlogic/netxen/netxen_nic_init.c
>> index 35ec9aab3dc7b..92962dbb73ad0 100644
>> --- a/drivers/net/ethernet/qlogic/netxen/netxen_nic_init.c
>> +++ b/drivers/net/ethernet/qlogic/netxen/netxen_nic_init.c
>> @@ -1192,8 +1192,13 @@ netxen_p3_has_mn(struct netxen_adapter *adapter)
>>   	if (NX_IS_REVISION_P2(adapter->ahw.revision_id))
>>   		return 1;
>>   
>> -	netxen_rom_fast_read(adapter,
>> -			NX_FW_VERSION_OFFSET, (int *)&flashed_ver);
>> +	if (netxen_rom_fast_read(adapter,
>> +			NX_FW_VERSION_OFFSET, (int *)&flashed_ver)) {
> 1. Mo callers of netxen_rom_fast_read() print debug messages, so this
> shouldn't too.
> 2. netxen_p3_has_mn() can't fail and by returning 0, you will cause to
> unpredictable behaviour in netxen_validate_firmware().
>
> Thanks

Well, ok. Then patch isn't needed.

Thanks for reviewing!


Denis

>
>> +		printk(KERN_ERR "%s: ERROR on flashed version reading",
>> +				netxen_nic_driver_name);
>> +		return 0;
>> +	}
>> +
>>   	flashed_ver = NETXEN_DECODE_VERSION(flashed_ver);
>>   
>>   	if (flashed_ver >= NETXEN_VERSION_CODE(4, 0, 220)) {
>> -- 
>> 2.25.1
>>
