Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7DE8B4AA179
	for <lists+netdev@lfdr.de>; Fri,  4 Feb 2022 21:57:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238813AbiBDU5y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Feb 2022 15:57:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232318AbiBDU5w (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Feb 2022 15:57:52 -0500
Received: from mirix.in-vpn.de (mirix.in-vpn.de [IPv6:2001:67c:1407:a0::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE09AC061714;
        Fri,  4 Feb 2022 12:57:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mirix.org;
        s=43974b1a7d21b2cf; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:
        References:Cc:To:From:Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=4sEKZN7XRHzrBz/3nmumg6dygxdUwMPL/7KJ35y81FM=; b=hQnSfxwrB1thTrhI2d/95Z5sB+
        oioa9C+mUNvdq5aOrPkM9DGRTCrYXaW40eg3bEBn4Jz1pQisFukBkr+NHG8kjXYtqcGH62dVJCV8j
        CVkvi5WpKi3wqaVDDvsufKJEzMMBTJUbCczshxjOIV5gS7TK5k6BgpIveqlUpWs/iIS5gySsSsvEE
        xaF6JN8vG72+i9zfznlZzAs7VDVfZdPuitFoP+/8R+I+idC2hjq8Z3fEuBHH2sVm44m8xyyngBaqa
        Y9skUcBiZ6GSOru/AjeGQAmDRM368RJydzQ2HpE3AdeTe2tqW+kOMYXf7XSYbj83MLSld2ua5f/+8
        smedLBiw==;
Received: from [::1] (helo=localhost.localdomain)
        by mirix.in-vpn.de with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_128_GCM:128)
        (Exim)
        id 1nG5eJ-0007PX-R3; Fri, 04 Feb 2022 20:57:43 +0000
Message-ID: <be5e9de7-8a71-43a9-5c99-80e318fda42b@mirix.org>
Date:   Fri, 4 Feb 2022 21:57:41 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH] net: usb: pegasus: Request Ethernet FCS from hardware
Content-Language: en-US
From:   Matthias-Christian Ott <ott@mirix.org>
To:     petkan@nucleusys.com
Cc:     linux-usb@vger.kernel.org, netdev@vger.kernel.org
References: <20211226132502.7056-1-ott@mirix.org>
 <YciSJYMgyHtvyPc6@karbon.k.g>
 <6029432c-5f85-b727-ed90-dca1a52b3775@mirix.org>
 <Ycjov4ulEM3HqV/9@karbon.k.g>
 <c43f26e6-67bd-f403-2866-ee078632d9c9@mirix.org>
In-Reply-To: <c43f26e6-67bd-f403-2866-ee078632d9c9@mirix.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 26/12/2021 23:17, Matthias-Christian Ott wrote:
> On 26/12/2021 23:12, Petko Manolov wrote:
>> On 21-12-26 17:12:24, Matthias-Christian Ott wrote:
>>> On 26/12/2021 17:02, Petko Manolov wrote:
>>>> On 21-12-26 14:25:02, Matthias-Christian Ott wrote:
>>>>> Commit 1a8deec09d12 ("pegasus: fixes reported packet length") tried to
>>>>> configure the hardware to not include the FCS/CRC of Ethernet frames.
>>>>> Unfortunately, this does not work with the D-Link DSB-650TX (USB IDs
>>>>> 2001:4002 and 2001:400b): the transferred "packets" (in the terminology
>>>>> of the hardware) still contain 4 additional octets. For IP packets in
>>>>> Ethernet this is not a problem as IP packets contain their own lengths
>>>>> fields but other protocols also see Ethernet frames that include the FCS
>>>>> in the payload which might be a problem for some protocols.
>>>>>
>>>>> I was not able to open the D-Link DSB-650TX as the case is a very tight
>>>>> press fit and opening it would likely destroy it. However, according to
>>>>> the source code the earlier revision of the D-Link DSB-650TX (USB ID
>>>>> 2001:4002) is a Pegasus (possibly AN986) and not Pegasus II (AN8511)
>>>>> device. I also tried it with the later revision of the D-Link DSB-650TX
>>>>> (USB ID 2001:400b) which is a Pegasus II device according to the source
>>>>> code and had the same results. Therefore, I'm not sure whether the RXCS
>>>>> (rx_crc_sent) field of the EC0 (Ethernet control_0) register has any
>>>>> effect or in which revision of the hardware it is usable and has an
>>>>> effect. As a result, it seems best to me to revert commit
>>>>> 1a8deec09d12 ("pegasus: fixes reported packet length") and to set the
>>>>> RXCS (rx_crc_sent) field of the EC0 (Ethernet control_0) register so
>>>>> that the FCS/CRC is always included.
>>>>>
>>>>> Fixes: 1a8deec09d12 ("pegasus: fixes reported packet length")
>>>>> Signed-off-by: Matthias-Christian Ott <ott@mirix.org>
>>>>> ---
>>>>>   drivers/net/usb/pegasus.c | 15 ++++++++++++++-
>>>>>   1 file changed, 14 insertions(+), 1 deletion(-)
>>>>>
>>>>> diff --git a/drivers/net/usb/pegasus.c b/drivers/net/usb/pegasus.c
>>>>> index c4cd40b090fd..140d11ae6688 100644
>>>>> --- a/drivers/net/usb/pegasus.c
>>>>> +++ b/drivers/net/usb/pegasus.c
>>>>> @@ -422,7 +422,13 @@ static int enable_net_traffic(struct net_device *dev, struct usb_device *usb)
>>>>>   	ret = read_mii_word(pegasus, pegasus->phy, MII_LPA, &linkpart);
>>>>>   	if (ret < 0)
>>>>>   		goto fail;
>>>>> -	data[0] = 0xc8; /* TX & RX enable, append status, no CRC */
>>>>> +	/* At least two hardware revisions of the D-Link DSB-650TX (USB IDs
>>>>> +	 * 2001:4002 and 2001:400b) include the Ethernet FCS in the packets,
>>>>> +	 * even if RXCS is set to 0 in the EC0 register and the hardware is
>>>>> +	 * instructed to not include the Ethernet FCS in the packet.Therefore,
>>>>> +	 * it seems best to set RXCS to 1 and later ignore the Ethernet FCS.
>>>>> +	 */
>>>>> +	data[0] = 0xc9; /* TX & RX enable, append status, CRC */
>>>>>   	data[1] = 0;
>>>>>   	if (linkpart & (ADVERTISE_100FULL | ADVERTISE_10FULL))
>>>>>   		data[1] |= 0x20;	/* set full duplex */
>>>>> @@ -513,6 +519,13 @@ static void read_bulk_callback(struct urb *urb)
>>>>>   		pkt_len = buf[count - 3] << 8;
>>>>>   		pkt_len += buf[count - 4];
>>>>>   		pkt_len &= 0xfff;
>>>>> +		/* The FCS at the end of the packet is ignored. So subtract
>>>>> +		 * its length to ignore it.
>>>>> +		 */
>>>>> +		pkt_len -= ETH_FCS_LEN;
>>>>> +		/* Subtract the length of the received status at the end of the
>>>>> +		 * packet as it is not part of the Ethernet frame.
>>>>> +		 */
>>>>>   		pkt_len -= 4;
>>>>>   	}
>>>>
>>>> Nice catch.  However, changing these constants for all devices isn't such a
>>>> good idea.  I'd rather use vendor and device IDs to distinguish these two
>>>> cases in the above code.
>>>
>>> I don't think that it would hurt to include the FCS for all devices. I only
>>> have the datasheets for the ADM8511/X and the ADM8513 but it seems that all
>>> devices that are supported by the driver also include the RXCS field in EC0.
>>> This was also the previous behaviour before commit 1a8deec09d12 and seemed to
>>> have worked. It also only adds four octet that have to be transferred and it
>>> seems to avoid exceptions for different devices which seems to be a good idea,
>>> in particular, because it is not easy to acquire all of the supported devices
>>> as they are no longer sold or manufactured.
>>
>> The fix that commit 1a8deec09d12 introduces is real (the commit message makes
>> sense) and i don't feel confident to revert it so lightly.  I think i have all
>> relevant datasheets somewhere, along with a couple of old "pegasus I" devices,
>> which i could use for testing. Not at home right now, the aforementioned testing
>> will have to wait a couple of days.
>>
>>> That being said, if you are going to veto this change otherwise, I can of
>>> course just add the FCS back for the two USB IDs, even though it likely
>>> affects other devices as well.
>>
>> Like i said, i don't want to hurry up and revert something that looks like a
>> valid fix.  Especially after five years worth of kernel releases and no
>> complaints related to 1a8deec09d12.  This should mean two things: a) the driver
>> isn't used anymore, or b) this commit fixes a real problem.
>>
>> However, if it turn out that your fix is the right one, it goes in without fuss.
>> So lets see what it is...
> 
> I agree. It is not my intention to break something. Take your time to
> test it when you find the time and let me know of the results. We are
> not in a hurry. I have my private fork of the driver for the longterm
> kernel.

I imported a LinkSys EtherFast 10/100 USB Network Adapter with model 
number USB100TX, FCC ID MQ4UFF1KA and revision B1 from the USA. 
According to the FCC photos and the source code of the driver, it is a 
pegasus I device. It also includes the FCS.

I can provide Ethernet and USB captures in private correspondence if 
someone is interested.

Kind regards,
Matthias-Christian Ott
