Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8058D51BED5
	for <lists+netdev@lfdr.de>; Thu,  5 May 2022 14:06:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359540AbiEEMJW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 May 2022 08:09:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359765AbiEEMJS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 May 2022 08:09:18 -0400
Received: from mail.marcansoft.com (marcansoft.com [IPv6:2a01:298:fe:f::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE96D1A066;
        Thu,  5 May 2022 05:05:36 -0700 (PDT)
Received: from [127.0.0.1] (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: marcan@marcan.st)
        by mail.marcansoft.com (Postfix) with ESMTPSA id 44F9E41F5D;
        Thu,  5 May 2022 12:05:32 +0000 (UTC)
Message-ID: <1e04603d-5fb2-9c39-4c68-7bcb7428f667@marcan.st>
Date:   Thu, 5 May 2022 21:05:29 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Content-Language: es-ES
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Jacky Chou <jackychou@asix.com.tw>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20220502110644.167179-1-marcan@marcan.st>
 <20220504193047.1e4b97b7@kernel.org>
From:   Hector Martin <marcan@marcan.st>
Subject: Re: [PATCH v2] net: usb: ax88179_178a: Bind only to vendor-specific
 interface
In-Reply-To: <20220504193047.1e4b97b7@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 05/05/2022 11.30, Jakub Kicinski wrote:
> On Mon,  2 May 2022 20:06:44 +0900 Hector Martin wrote:
>> The Anker PowerExpand USB-C to Gigabit Ethernet adapter uses this
>> chipset, but exposes CDC Ethernet configurations as well as the
>> vendor specific one. 
> 
> And we have reasons to believe all dongle vendors may have a similar
> problem?

Given this is a vendor-specific driver it seems correct to have it only
bind to vendor-specific interfaces. That shouldn't break anything as
long as nobody is implementing this interface with the wrong protocol
IDs (which seems like quite a weird thing to do and fairly unlikely).

FWIW, the one I have has the generic VID/PID, not a custom vendor one.
If you prefer I can change just that one or both of the generic ones.

>> diff --git a/drivers/net/usb/ax88179_178a.c b/drivers/net/usb/ax88179_178a.c
>> index e2fa56b92685..7c7c2f31d9f1 100644
>> --- a/drivers/net/usb/ax88179_178a.c
>> +++ b/drivers/net/usb/ax88179_178a.c
>> @@ -1914,55 +1914,55 @@ static const struct driver_info at_umc2000sp_info = {
>>  static const struct usb_device_id products[] = {
>>  {
>>  	/* ASIX AX88179 10/100/1000 */
>> -	USB_DEVICE(0x0b95, 0x1790),
>> +	USB_DEVICE_AND_INTERFACE_INFO(0x0b95, 0x1790, 0xff, 0xff, 0),
>>  	.driver_info = (unsigned long)&ax88179_info,
>>  }, 
> 
> Should we use USB_CLASS_VENDOR_SPEC and USB_SUBCLASS_VENDOR_SPEC ?
> Maybe define a local macro wrapper for USB_DEVICE_AND.. which will
> fill those in to avoid long lines?

Sure, I'll do that!

-- 
Hector Martin (marcan@marcan.st)
Public Key: https://mrcn.st/pub
