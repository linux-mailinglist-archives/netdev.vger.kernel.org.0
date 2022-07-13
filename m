Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BBE86573018
	for <lists+netdev@lfdr.de>; Wed, 13 Jul 2022 10:08:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231803AbiGMIIR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jul 2022 04:08:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229968AbiGMIIP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Jul 2022 04:08:15 -0400
Received: from ssl.serverraum.org (ssl.serverraum.org [IPv6:2a01:4f8:151:8464::1:2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73555E9231;
        Wed, 13 Jul 2022 01:08:13 -0700 (PDT)
Received: from ssl.serverraum.org (web.serverraum.org [172.16.0.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ssl.serverraum.org (Postfix) with ESMTPSA id 5869A2222E;
        Wed, 13 Jul 2022 10:08:11 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2016061301;
        t=1657699691;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=tOKbUApMJaGcvjgSs3pJX5iTlIKWX+aHMMzJOeg1bfY=;
        b=hkdpoDCzOxjtQ5dNydOJ8PqTmgZZ/erDYimb3lDDKWDXe87jU6X6Mmt7eHzDjDSdp381ZM
        P9wLZWZ0JkBbUuVmKr97lIWzYxKyLg7bsc7TLR7QsgUg4K6sT/qFSCl1SjqcFOOFFkXiMq
        IEQ4UuxBzLEeNX/2ZdmifoitXCSYV5s=
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Wed, 13 Jul 2022 10:08:11 +0200
From:   Michael Walle <michael@walle.cc>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH] NFC: nxp-nci: fix deadlock during firmware update
In-Reply-To: <f837b69d-b212-3107-504b-b5d716ab6878@linaro.org>
References: <20220712152554.2909224-1-michael@walle.cc>
 <f837b69d-b212-3107-504b-b5d716ab6878@linaro.org>
User-Agent: Roundcube Webmail/1.4.13
Message-ID: <8b8415320c913cb5e8c078acfd0940d1@walle.cc>
X-Sender: michael@walle.cc
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Am 2022-07-13 08:57, schrieb Krzysztof Kozlowski:
> On 12/07/2022 17:25, Michael Walle wrote:
>> During firmware update, both nxp_nci_i2c_irq_thread_fn() and
>> nxp_nci_fw_work() will hold the info_lock mutex and one will wait
>> for the other via a completion:
>> 
>> nxp_nci_fw_work()
>>   mutex_lock(info_lock)
>>   nxp_nci_fw_send()
>>     wait_for_completion(cmd_completion)
>>   mutex_unlock(info_lock)
>> 
>> nxp_nci_i2c_irq_thread_fn()
>>   mutex_lock(info_lock)
>>     nxp_nci_fw_recv_frame()
>>       complete(cmd_completion)
>>   mutex_unlock(info_lock)
>> 
>> This will result in a -ETIMEDOUT error during firmware update (note
>> that the wait_for_completion() above is a variant with a timeout).
>> 
>> Drop the lock in nxp_nci_fw_work() and instead take it after the
>> work is done in nxp_nci_fw_work_complete() when the NFC controller 
>> mode
>> is switched and the info structure is updated.
>> 
>> Fixes: dece45855a8b ("NFC: nxp-nci: Add support for NXP NCI chips")
>> Signed-off-by: Michael Walle <michael@walle.cc>
>> ---
>>  drivers/nfc/nxp-nci/firmware.c | 5 ++---
>>  1 file changed, 2 insertions(+), 3 deletions(-)
>> 
>> diff --git a/drivers/nfc/nxp-nci/firmware.c 
>> b/drivers/nfc/nxp-nci/firmware.c
>> index 119bf305c642..6a4d4aa7239f 100644
>> --- a/drivers/nfc/nxp-nci/firmware.c
>> +++ b/drivers/nfc/nxp-nci/firmware.c
>> @@ -54,6 +54,7 @@ void nxp_nci_fw_work_complete(struct nxp_nci_info 
>> *info, int result)
>>  	struct nxp_nci_fw_info *fw_info = &info->fw_info;
>>  	int r;
>> 
>> +	mutex_lock(&info->info_lock);
>>  	if (info->phy_ops->set_mode) {
>>  		r = info->phy_ops->set_mode(info->phy_id, NXP_NCI_MODE_COLD);
>>  		if (r < 0 && result == 0)
>> @@ -66,6 +67,7 @@ void nxp_nci_fw_work_complete(struct nxp_nci_info 
>> *info, int result)
>>  		release_firmware(fw_info->fw);
>>  		fw_info->fw = NULL;
>>  	}
>> +	mutex_unlock(&info->info_lock);
>> 
>>  	nfc_fw_download_done(info->ndev->nfc_dev, fw_info->name, (u32) 
>> -result);
>>  }
>> @@ -172,8 +174,6 @@ void nxp_nci_fw_work(struct work_struct *work)
>>  	fw_info = container_of(work, struct nxp_nci_fw_info, work);
>>  	info = container_of(fw_info, struct nxp_nci_info, fw_info);
>> 
>> -	mutex_lock(&info->info_lock);
>> -
> 
> I am not sure this is correct. info_lock should protect members of info
> thus also info->fw_info. By removing the mutex the protection is gone.
> 
> Unless you are sure that fw_info cannot be modified concurrently?

Mh, you are right. fw_info could be modified by the irq thread and
in the worker thread (and the nfc core doesn't protect against
multiple fw_download() calls)

-michael
