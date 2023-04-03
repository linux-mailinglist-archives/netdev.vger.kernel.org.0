Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 88F466D42C0
	for <lists+netdev@lfdr.de>; Mon,  3 Apr 2023 12:59:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231862AbjDCK66 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Apr 2023 06:58:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231783AbjDCK65 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Apr 2023 06:58:57 -0400
Received: from forwardcorp1c.mail.yandex.net (forwardcorp1c.mail.yandex.net [178.154.239.200])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84582EB7C;
        Mon,  3 Apr 2023 03:58:55 -0700 (PDT)
Received: from mail-nwsmtp-smtp-corp-main-34.sas.yp-c.yandex.net (mail-nwsmtp-smtp-corp-main-34.sas.yp-c.yandex.net [IPv6:2a02:6b8:c08:19a8:0:640:4e87:0])
        by forwardcorp1c.mail.yandex.net (Yandex) with ESMTP id 768F25F228;
        Mon,  3 Apr 2023 13:58:53 +0300 (MSK)
Received: from [IPV6:2a02:6b8:b081:8014::1:2c] (unknown [2a02:6b8:b081:8014::1:2c])
        by mail-nwsmtp-smtp-corp-main-34.sas.yp-c.yandex.net (smtpcorp/Yandex) with ESMTPSA id owKZdU0OeKo0-8INAhgp8;
        Mon, 03 Apr 2023 13:58:52 +0300
X-Yandex-Fwd: 1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex-team.ru; s=default;
        t=1680519532; bh=ORNE5FRmOKWFTYbSD7tRSFvdZisp89jLtfgvi4gNMlA=;
        h=From:In-Reply-To:Cc:Date:References:To:Subject:Message-ID;
        b=ikkLSowgdNYie4Ye9MMbdUrX+Qk2htQyDuBLP3nyEy52MlYPmkVaatS/kz5YWTemX
         V91/E5cLfFiOJFPJIVnEc3EaGx5uwJbyqCAw535kA9eVYd3i9AtwOzkO0oBh+1pLCt
         3HcCqlyNYkyzlgvhbKEj2QzohXbmXMJjDg8Vaysw=
Authentication-Results: mail-nwsmtp-smtp-corp-main-34.sas.yp-c.yandex.net; dkim=pass header.i=@yandex-team.ru
Message-ID: <b4852db1-61bd-410e-e89d-05d89cf14063@yandex-team.ru>
Date:   Mon, 3 Apr 2023 13:58:49 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: Re: [PATCH] qlcnic: check pci_reset_function result
Content-Language: en-US
To:     Simon Horman <simon.horman@corigine.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        shshaikh@marvell.com, manishc@marvell.com,
        GR-Linux-NIC-Dev@marvell.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com
References: <20230331080605.42961-1-den-plotnikov@yandex-team.ru>
 <ZCcd1c0jhKxk+FD+@corigine.com>
From:   Denis Plotnikov <den-plotnikov@yandex-team.ru>
In-Reply-To: <ZCcd1c0jhKxk+FD+@corigine.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.5 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 31.03.2023 20:52, Simon Horman wrote:
> On Fri, Mar 31, 2023 at 11:06:05AM +0300, Denis Plotnikov wrote:
>> Static code analyzer complains to unchecked return value.
>> It seems that pci_reset_function return something meaningful
>> only if "reset_methods" is set.
>> Even if reset_methods isn't used check the return value to avoid
>> possible bugs leading to undefined behavior in the future.
>>
>> Signed-off-by: Denis Plotnikov <den-plotnikov@yandex-team.ru>
> nit: The tree this patch is targeted at should be designated, probably
>       net-next, so the '[PATCH net-next]' in the subject.
>
>> ---
>>   drivers/net/ethernet/qlogic/qlcnic/qlcnic_ctx.c | 4 +++-
>>   1 file changed, 3 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_ctx.c b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_ctx.c
>> index 87f76bac2e463..39ecfc1a1dbd0 100644
>> --- a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_ctx.c
>> +++ b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_ctx.c
>> @@ -628,7 +628,9 @@ int qlcnic_fw_create_ctx(struct qlcnic_adapter *dev)
>>   	int i, err, ring;
>>   
>>   	if (dev->flags & QLCNIC_NEED_FLR) {
>> -		pci_reset_function(dev->pdev);
>> +		err = pci_reset_function(dev->pdev);
>> +		if (err && err != -ENOTTY)
> Are you sure about the -ENOTTY part?
>
> It seems odd to me that an FLR would be required but reset is not supported.
No, I'm not sure. My logic is: if the reset method isn't set than 
pci_reset_function() returns -ENOTTY so treat that result as ok. 
pci_reset_function may return something different than -ENOTTY only if 
pci_reset_fn_methods[m].reset_fn is set.
>> +			return err;
>>   		dev->flags &= ~QLCNIC_NEED_FLR;
>>   	}
>>   
>> -- 
>> 2.25.1
>>
