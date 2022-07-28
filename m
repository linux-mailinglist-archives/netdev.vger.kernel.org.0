Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A59485846C5
	for <lists+netdev@lfdr.de>; Thu, 28 Jul 2022 22:06:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232118AbiG1T7j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jul 2022 15:59:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231301AbiG1T7i (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Jul 2022 15:59:38 -0400
X-Greylist: delayed 399 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 28 Jul 2022 12:59:35 PDT
Received: from mail.sf-mail.de (mail.sf-mail.de [IPv6:2a01:4f8:1c17:6fae:616d:6c69:616d:6c69])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16D5A6FA0E
        for <netdev@vger.kernel.org>; Thu, 28 Jul 2022 12:59:34 -0700 (PDT)
Received: (qmail 21331 invoked from network); 28 Jul 2022 19:52:15 -0000
Received: from mail.sf-mail.de ([2a01:4f8:1c17:6fae:616d:6c69:616d:6c69]:50732 HELO webmail.sf-mail.de) (auth=eike@sf-mail.de)
        by mail.sf-mail.de (Qsmtpd 0.38dev) with (TLS_AES_256_GCM_SHA384 encrypted) ESMTPSA
        for <seanga2@gmail.com>; Thu, 28 Jul 2022 21:52:15 +0200
MIME-Version: 1.0
Date:   Thu, 28 Jul 2022 21:52:15 +0200
From:   Rolf Eike Beer <eike-kernel@sf-tec.de>
To:     Sean Anderson <seanga2@gmail.com>
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH 4/x] sunhme: switch to devres
In-Reply-To: <7685c7df-83ed-a3a0-6e61-42bd48713dc9@gmail.com>
References: <4686583.GXAFRqVoOG@eto.sf-tec.de>
 <11922663.O9o76ZdvQC@eto.sf-tec.de>
 <00f00bdf-1a76-693f-5c8f-9b4ceaf76b91@gmail.com>
 <7685c7df-83ed-a3a0-6e61-42bd48713dc9@gmail.com>
Message-ID: <8005d74d1e4ff2bdd75f8fefe70561a0@sf-tec.de>
X-Sender: eike-kernel@sf-tec.de
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Am 2022-07-27 05:58, schrieb Sean Anderson:
> On 7/26/22 11:49 PM, Sean Anderson wrote:

>> This looks good, but doesn't apply cleanly. I rebased it as follows:

Looks like what my local rebase has also produced.

The sentence about the leak from the commitmessage can be dropped then,
as this leak has already been fixed.

>> diff --git a/drivers/net/ethernet/sun/sunhme.c 
>> b/drivers/net/ethernet/sun/sunhme.c
>> index eebe8c5f480c..e83774ffaa7a 100644
>> --- a/drivers/net/ethernet/sun/sunhme.c
>> +++ b/drivers/net/ethernet/sun/sunhme.c
>> @@ -2990,21 +2990,23 @@ static int happy_meal_pci_probe(struct pci_dev 
>> *pdev,
>>           qp->happy_meals[qfe_slot] = dev;
>>       }
>> 
>> -    hpreg_res = pci_resource_start(pdev, 0);
>> -    err = -ENODEV;
>>       if ((pci_resource_flags(pdev, 0) & IORESOURCE_IO) != 0) {
>>           printk(KERN_ERR "happymeal(PCI): Cannot find proper PCI 
>> device base address.\n");
>>           goto err_out_clear_quattro;
>>       }
>> -    if (pci_request_regions(pdev, DRV_NAME)) {
>> +
>> +    if (!devm_request_region(&pdev->dev, pci_resource_start(pdev, 0),
>> +                  pci_resource_len(pdev, 0),
>> +                  DRV_NAME)) {
> 
> Actually, it looks like you are failing to set err from these *m
> calls, like what
> you fixed in patch 3. Can you address this for v2?

It returns NULL on error, there is no error code I can set.

Regards,

Eike
