Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 640092AD011
	for <lists+netdev@lfdr.de>; Tue, 10 Nov 2020 07:55:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731231AbgKJGzb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Nov 2020 01:55:31 -0500
Received: from mo4-p00-ob.smtp.rzone.de ([81.169.146.161]:15720 "EHLO
        mo4-p00-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726006AbgKJGza (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Nov 2020 01:55:30 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1604991328;
        s=strato-dkim-0002; d=hartkopp.net;
        h=In-Reply-To:Date:Message-ID:From:References:Cc:To:Subject:
        X-RZG-CLASS-ID:X-RZG-AUTH:From:Subject:Sender;
        bh=fODdxiI4WFWfv1hKxe+IgXill0r+Vu9XP6z2aFm3Yc0=;
        b=XM9853NdgHWxbVP8rwXmSziFm80X+cqLu3ORmdjeLkGVFSHvZitT+dQNwSxi0NGlHs
        jwiC51D5ebyfxqZWz70sGPqQgJobqqTyGsdvoHEFKXSScfDNdsAD3YgUNImR9ajRqF/g
        FAvAS61avbM9b2k7wve3qJCp/4IcxN9TurLreGNAXtJtb+cVdMQOmbVQw+IqGXl+bx0A
        UQpwE4aj9VCyNV8dC0ck05Of71XTIINOskcESeHI8EevzsXaab7vPiSNb5xEXMEbUamK
        MAXcvPd3RLlqp8vVBiE1JCdCX5Y1SVWyXNxBkJdB/Aomk2iq8Sh1N2/5O9KwhluWVUhl
        wxiQ==
X-RZG-AUTH: ":P2MHfkW8eP4Mre39l357AZT/I7AY/7nT2yrDxb8mjG14FZxedJy6qgO1o3PMaViOoLMGX8h6kE2n"
X-RZG-CLASS-ID: mo00
Received: from [192.168.50.177]
        by smtp.strato.de (RZmta 47.3.3 DYNA|AUTH)
        with ESMTPSA id V0298cwAA6tP9O1
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
        Tue, 10 Nov 2020 07:55:25 +0100 (CET)
Subject: Re: [PATCH v5 8/8] can-dev: add len8_dlc support for various CAN USB
 adapters
To:     Marc Kleine-Budde <mkl@pengutronix.de>, linux-can@vger.kernel.org,
        mailhol.vincent@wanadoo.fr
Cc:     netdev@vger.kernel.org
References: <20201109153657.17897-1-socketcan@hartkopp.net>
 <20201109153657.17897-9-socketcan@hartkopp.net>
 <c9b7ec89-0892-89fa-1f8d-af9c973e4544@pengutronix.de>
From:   Oliver Hartkopp <socketcan@hartkopp.net>
Message-ID: <68005955-4bf3-cdef-f85d-a841eb336921@hartkopp.net>
Date:   Tue, 10 Nov 2020 07:55:17 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <c9b7ec89-0892-89fa-1f8d-af9c973e4544@pengutronix.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 09.11.20 21:12, Marc Kleine-Budde wrote:
> On 11/9/20 4:36 PM, Oliver Hartkopp wrote:
>> Support the Classical CAN raw DLC functionality to send and receive DLC
>> values from 9 .. 15 on various Classical CAN capable USB network drivers:
>>
>> - gs_usb
>> - pcan_usb
>> - pcan_usb_fd
>> - usb_8dev
>>
>> Tested-by: Oliver Hartkopp <socketcan@hartkopp.net>
>> Signed-off-by: Oliver Hartkopp <socketcan@hartkopp.net>
>> ---
>>   drivers/net/can/usb/gs_usb.c               |  8 ++++++--
>>   drivers/net/can/usb/peak_usb/pcan_usb.c    |  8 ++++++--
>>   drivers/net/can/usb/peak_usb/pcan_usb_fd.c | 17 ++++++++++++-----
>>   drivers/net/can/usb/usb_8dev.c             |  9 ++++++---
>>   4 files changed, 30 insertions(+), 12 deletions(-)
>>
>> diff --git a/drivers/net/can/usb/gs_usb.c b/drivers/net/can/usb/gs_usb.c
>> index 940589667a7f..cc0c30a33335 100644
>> --- a/drivers/net/can/usb/gs_usb.c
>> +++ b/drivers/net/can/usb/gs_usb.c
>> @@ -330,10 +330,13 @@ static void gs_usb_receive_bulk_callback(struct urb *urb)
>>   			return;
>>   
>>   		cf->can_id = hf->can_id;
>>   
>>   		cf->len = can_cc_dlc2len(hf->len);
>> +		cf->len8_dlc = can_get_len8_dlc(dev->can.ctrlmode, cf->len,
>> +						hf->len);
> 
> What about introducing a function that sets len and len8_dlc at the same time:
> 
> void can_frame_set_length(const struct can_priv *can, struct can_frame *cfd, u8
> dlc);

Good idea.

I would suggest something like

u8 can_get_cc_len(const u32 ctrlmode, struct can_frame *cf, u8 dlc)

that still returns the 'len' element, so that we can replace 
can_cc_dlc2len() with can_get_cc_len() for CAN drivers that add support 
for len8_dlc.

The assignment cf->len = can_get_cc_len() fits better into the code 
which assigns cf->can_id too.

And I would stay on 'u32 ctrlmode' as ctrlmode is the parameter which is 
namely needed here. A pointer to can_priv can mean anything.

> 
> And maybe a function that takes a canfd_frame, so that we don't need to cast....

No. The len8_dlc element is from struct can_frame. When people use the 
struct canfd_frame in their driver this might have some benefits for them.
But when it comes to access the len8_dlc element this has to be casted IMO.

But with the suggested can_get_cc_len() function a needed cast could be 
put into the parameter list without adding extra code somewhere else in 
the driver.

(..)


>> @@ -1033,11 +1040,11 @@ static const struct can_bittiming_const pcan_usb_fd_data_const = {
>>   
>>   const struct peak_usb_adapter pcan_usb_fd = {
>>   	.name = "PCAN-USB FD",
>>   	.device_id = PCAN_USBFD_PRODUCT_ID,
>>   	.ctrl_count = PCAN_USBFD_CHANNEL_COUNT,
>> -	.ctrlmode_supported = CAN_CTRLMODE_FD |
>> +	.ctrlmode_supported = CAN_CTRLMODE_FD | CAN_CTRLMODE_CC_LEN8_DLC |
>>   			CAN_CTRLMODE_3_SAMPLES | CAN_CTRLMODE_LISTENONLY,
> 
> Please add the new CTRLMODE at the end, so that the list ist sorted. I don't
> mind if the diff is a bit larger.
> 

I had to decide between "make the patch looking good" and "make the 
result looking good" ;-)

But I'm fine with "make the patch looking good" too. Will change that in v6.

Best regards,
Oliver
