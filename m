Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C89E2653F35
	for <lists+netdev@lfdr.de>; Thu, 22 Dec 2022 12:46:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235379AbiLVLql (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Dec 2022 06:46:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229548AbiLVLqj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Dec 2022 06:46:39 -0500
Received: from forwardcorp1c.mail.yandex.net (forwardcorp1c.mail.yandex.net [178.154.239.200])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15C32D41;
        Thu, 22 Dec 2022 03:46:36 -0800 (PST)
Received: from iva4-f06c35e68a0a.qloud-c.yandex.net (iva4-f06c35e68a0a.qloud-c.yandex.net [IPv6:2a02:6b8:c0c:152e:0:640:f06c:35e6])
        by forwardcorp1c.mail.yandex.net (Yandex) with ESMTP id 59C8B5E8FA;
        Thu, 22 Dec 2022 14:46:34 +0300 (MSK)
Received: from [IPV6:2a02:6b8:b081:b5b0::1:4] (unknown [2a02:6b8:b081:b5b0::1:4])
        by iva4-f06c35e68a0a.qloud-c.yandex.net (smtpcorp/Yandex) with ESMTPSA id WklqJ10RgiE1-4EonBEYl;
        Thu, 22 Dec 2022 14:46:33 +0300
X-Yandex-Fwd: 1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex-team.ru; s=default;
        t=1671709593; bh=v+YXuoAWt5kCRFjKyaUhO+Sfafoa/+MDXkI+ks4y4KI=;
        h=From:In-Reply-To:Cc:Date:References:To:Subject:Message-ID;
        b=onuwFFL1BiDfSJd++DXCzKHWi92XRUtCnxuHlrhKU5gXz1GYyOSqrZo41qZA1YOEN
         qvXj+ouKZ5U2tfczt3RfkdogkUzv9tgWV0A8uzIsTd4WVCLu0h13scl3FUW9ogqk4X
         uAz//pQGNmOEjX+DmjFwf3tGWyzBPeDFrmmkEENE=
Authentication-Results: iva4-f06c35e68a0a.qloud-c.yandex.net; dkim=pass header.i=@yandex-team.ru
Message-ID: <89723faa-b0c2-54c9-89bd-f1bf025636ab@yandex-team.ru>
Date:   Thu, 22 Dec 2022 14:46:32 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH net v2] qlcnic: prevent ->dcb use-after-free on
 qlcnic_dcb_enable() failure
Content-Language: en-US
To:     Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
Cc:     Shahed Shaikh <shshaikh@marvell.com>,
        Manish Chopra <manishc@marvell.com>,
        GR-Linux-NIC-Dev@marvell.com,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20221222074223.1746072-1-d-tatianin@yandex-team.ru>
 <Y6QqDLoqCXHG8KVl@localhost.localdomain>
From:   Daniil Tatianin <d-tatianin@yandex-team.ru>
In-Reply-To: <Y6QqDLoqCXHG8KVl@localhost.localdomain>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/22/22 12:57 PM, Michal Swiatkowski wrote:
> On Thu, Dec 22, 2022 at 10:42:23AM +0300, Daniil Tatianin wrote:
>> adapter->dcb would get silently freed inside qlcnic_dcb_enable() in
>> case qlcnic_dcb_attach() would return an error, which always happens
>> under OOM conditions. This would lead to use-after-free because both
>> of the existing callers invoke qlcnic_dcb_get_info() on the obtained
>> pointer, which is potentially freed at that point.
>>
>> Propagate errors from qlcnic_dcb_enable(), and instead free the dcb
>> pointer at callsite using qlcnic_dcb_free(). This also removes the now
>> unused qlcnic_clear_dcb_ops() helper, which was a simple wrapper around
>> kfree() also causing memory leaks for partially initialized dcb.
>>
>> Found by Linux Verification Center (linuxtesting.org) with the SVACE
>> static analysis tool.
>>
>> Fixes: 3c44bba1d270 ("qlcnic: Disable DCB operations from SR-IOV VFs")
>> Signed-off-by: Daniil Tatianin <d-tatianin@yandex-team.ru>
>> ---
>> Changes since v1:
>> - Add a fixes tag + net as a target
>> - Remove qlcnic_clear_dcb_ops entirely & use qlcnic_dcb_free instead
>> ---
>>   drivers/net/ethernet/qlogic/qlcnic/qlcnic_83xx_init.c |  9 ++++++++-
>>   drivers/net/ethernet/qlogic/qlcnic/qlcnic_dcb.h       | 10 ++--------
>>   drivers/net/ethernet/qlogic/qlcnic/qlcnic_main.c      |  9 ++++++++-
>>   3 files changed, 18 insertions(+), 10 deletions(-)
>>
>> diff --git a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_83xx_init.c b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_83xx_init.c
>> index dbb800769cb6..774f2c6875ec 100644
>> --- a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_83xx_init.c
>> +++ b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_83xx_init.c
>> @@ -2505,7 +2505,14 @@ int qlcnic_83xx_init(struct qlcnic_adapter *adapter)
>>   		goto disable_mbx_intr;
>>   
>>   	qlcnic_83xx_clear_function_resources(adapter);
>> -	qlcnic_dcb_enable(adapter->dcb);
>> +
>> +	err = qlcnic_dcb_enable(adapter->dcb);
>> +	if (err) {
>> +		qlcnic_dcb_free(adapter->dcb);
>> +		adapter->dcb = NULL;
> Small nit, I think qlcnic_dcb_free() already set adapter->dcb to NULL.
Oops, you're right. Thanks for spotting.
> Otherwise, thanks for changing:
> Reviewed-by: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
> 
> Thanks,
> Michal
> 
> [...]
>> -- 
>> 2.25.1
