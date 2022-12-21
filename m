Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6BDE4652D6B
	for <lists+netdev@lfdr.de>; Wed, 21 Dec 2022 08:47:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229696AbiLUHrh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Dec 2022 02:47:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229491AbiLUHrg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Dec 2022 02:47:36 -0500
Received: from forwardcorp1c.mail.yandex.net (forwardcorp1c.mail.yandex.net [178.154.239.200])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D10EF1EED2;
        Tue, 20 Dec 2022 23:47:33 -0800 (PST)
Received: from iva4-f06c35e68a0a.qloud-c.yandex.net (iva4-f06c35e68a0a.qloud-c.yandex.net [IPv6:2a02:6b8:c0c:152e:0:640:f06c:35e6])
        by forwardcorp1c.mail.yandex.net (Yandex) with ESMTP id D0CC75E5D0;
        Wed, 21 Dec 2022 10:47:31 +0300 (MSK)
Received: from [IPV6:2a02:6b8:b081:b58c::1:35] (unknown [2a02:6b8:b081:b58c::1:35])
        by iva4-f06c35e68a0a.qloud-c.yandex.net (smtpcorp/Yandex) with ESMTPSA id Tlgj130RteA1-NdWMV3Rd;
        Wed, 21 Dec 2022 10:47:30 +0300
X-Yandex-Fwd: 1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex-team.ru; s=default;
        t=1671608850; bh=Pbj46S3mGcjIEXtE6IsAPkk6Dz022LhylgCd4vfAgG4=;
        h=From:In-Reply-To:Cc:Date:References:To:Subject:Message-ID;
        b=jyQQ58CB5rRfjeiWTVpU3J5mkhgkUZK/y4VNRzhaLmDiZoA7MZk6COIjewr5dDKtg
         EL7LYG7GnyNvoS6u5UqmtmNqljWkRdlShqZY6Q7KrXEvKi5w/4s/PUwy2MGe9sUqI3
         yYWCGSjqGMsKAjx9umSl8x8cEFrGtVBW5KYiFAAQ=
Authentication-Results: iva4-f06c35e68a0a.qloud-c.yandex.net; dkim=pass header.i=@yandex-team.ru
Message-ID: <8c49acd6-7195-caaf-425c-b9ed9290423d@yandex-team.ru>
Date:   Wed, 21 Dec 2022 10:47:29 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH v1] qlcnic: prevent ->dcb use-after-free on
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
References: <20221220125649.1637829-1-d-tatianin@yandex-team.ru>
 <Y6G5eWWucdaJXmQu@localhost.localdomain>
From:   Daniil Tatianin <d-tatianin@yandex-team.ru>
In-Reply-To: <Y6G5eWWucdaJXmQu@localhost.localdomain>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/20/22 4:32 PM, Michal Swiatkowski wrote:
> On Tue, Dec 20, 2022 at 03:56:49PM +0300, Daniil Tatianin wrote:
>> adapter->dcb would get silently freed inside qlcnic_dcb_enable() in
>> case qlcnic_dcb_attach() would return an error, which always happens
>> under OOM conditions. This would lead to use-after-free because both
>> of the existing callers invoke qlcnic_dcb_get_info() on the obtained
>> pointer, which is potentially freed at that point.
>>
>> Propagate errors from qlcnic_dcb_enable(), and instead free the dcb
>> pointer at callsite.
>>
>> Found by Linux Verification Center (linuxtesting.org) with the SVACE
>> static analysis tool.
>>
>> Signed-off-by: Daniil Tatianin <d-tatianin@yandex-team.ru>
> 
> Please add Fix tag and net as target (net-next is close till the end of
> this year)
>
Sorry, I'll include a fixes tag.
Could you please explain what I would have to do to add net as target?
>> ---
>>   drivers/net/ethernet/qlogic/qlcnic/qlcnic_83xx_init.c | 9 ++++++++-
>>   drivers/net/ethernet/qlogic/qlcnic/qlcnic_dcb.h       | 5 ++---
>>   drivers/net/ethernet/qlogic/qlcnic/qlcnic_main.c      | 9 ++++++++-
>>   3 files changed, 18 insertions(+), 5 deletions(-)
>>
>> diff --git a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_83xx_init.c b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_83xx_init.c
>> index dbb800769cb6..465f149d94d4 100644
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
>> +		qlcnic_clear_dcb_ops(adapter->dcb);
>> +		adapter->dcb = NULL;
>> +		goto disable_mbx_intr;
>> +	}
> 
> Maybe I miss sth but it looks like there can be memory leak.
> For example if error in attach happen after allocating of dcb->cfg.
> Isn't it better to call qlcnic_dcb_free instead of qlcnic_clear_dcb_ops?
I think you're right, if attach fails midway then we might leak cfg or 
something else.
I'll use qlcnic_dcb_free() instead and completely remove 
qlcnic_clear_dcb_ops() as it
seems to be unused and relies on dcb being in a very specific state.
>> +
>>   	qlcnic_83xx_initialize_nic(adapter, 1);
>>   	qlcnic_dcb_get_info(adapter->dcb);
>>   
>> diff --git a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_dcb.h b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_dcb.h
>> index 7519773eaca6..e1460f9c38bf 100644
>> --- a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_dcb.h
>> +++ b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_dcb.h
>> @@ -112,9 +112,8 @@ static inline void qlcnic_dcb_init_dcbnl_ops(struct qlcnic_dcb *dcb)
>>   		dcb->ops->init_dcbnl_ops(dcb);
>>   }
>>   
>> -static inline void qlcnic_dcb_enable(struct qlcnic_dcb *dcb)
>> +static inline int qlcnic_dcb_enable(struct qlcnic_dcb *dcb)
>>   {
>> -	if (dcb && qlcnic_dcb_attach(dcb))
>> -		qlcnic_clear_dcb_ops(dcb);
>> +	return dcb ? qlcnic_dcb_attach(dcb) : 0;
>>   }
>>   #endif
>> diff --git a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_main.c b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_main.c
>> index 28476b982bab..36ba15fc9776 100644
>> --- a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_main.c
>> +++ b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_main.c
>> @@ -2599,7 +2599,14 @@ qlcnic_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
>>   			 "Device does not support MSI interrupts\n");
>>   
>>   	if (qlcnic_82xx_check(adapter)) {
>> -		qlcnic_dcb_enable(adapter->dcb);
>> +		err = qlcnic_dcb_enable(adapter->dcb);
>> +		if (err) {
>> +			qlcnic_clear_dcb_ops(adapter->dcb);
>> +			adapter->dcb = NULL;
>> +			dev_err(&pdev->dev, "Failed to enable DCB\n");
>> +			goto err_out_free_hw;
>> +		}
>> +
>>   		qlcnic_dcb_get_info(adapter->dcb);
>>   		err = qlcnic_setup_intr(adapter);
>>   
>> -- 
>> 2.25.1
>>
