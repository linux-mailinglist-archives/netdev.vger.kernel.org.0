Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E1AA47F831
	for <lists+netdev@lfdr.de>; Sun, 26 Dec 2021 17:12:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230502AbhLZQMa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Dec 2021 11:12:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230492AbhLZQM3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 Dec 2021 11:12:29 -0500
Received: from mirix.in-vpn.de (mirix.in-vpn.de [IPv6:2001:67c:1407:a0::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A9CFC06173E;
        Sun, 26 Dec 2021 08:12:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mirix.org;
        s=43974b1a7d21b2cf; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:
        MIME-Version:Date:Message-ID:From:References:Cc:To:Subject:Sender:Reply-To:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=IF6GGe2YqZugPITip6uWvWbc+h2zbiaXgcgjSR/tfgY=; b=UQPLS9VcyHV+zRffdFeiBnspDO
        LtQy6UI+mMnm6JDKlnlLiRXyPZZket0WY7Y1wYti0b4VhPTGuBUpaRiKPNA9W3RY0H8tiRMfT0Jtq
        snqar1aoaMLdJytldiF49CAqxxlB2EhfFtLUaVqMC2vQaZ1a70PSI7SEVfkHntIw0NQGk65y0kCWI
        fZWHCPm+INVXEwCDJSf3IKxhrkQujZTcmPUDqccpUjleekczSgtFD5APhyIDOAdM6NzUPo8Zcg+Gw
        kU4Pp9S9v1oWmuONTZDWpztIMEZVfTRL2TP7UV4DvkkqXA0m4hwQAkZnW6hTNn+cjAzYkEDJ010TU
        M4qbHFBg==;
Received: from [::1] (helo=localhost.localdomain)
        by mirix.in-vpn.de with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_128_GCM:128)
        (Exim)
        id 1n1W8I-0005wG-DS; Sun, 26 Dec 2021 16:12:26 +0000
Subject: Re: [PATCH] net: usb: pegasus: Request Ethernet FCS from hardware
To:     Petko Manolov <petkan@nucleusys.com>
Cc:     linux-usb@vger.kernel.org, netdev@vger.kernel.org
References: <20211226132502.7056-1-ott@mirix.org>
 <YciSJYMgyHtvyPc6@karbon.k.g>
From:   Matthias-Christian Ott <ott@mirix.org>
Message-ID: <6029432c-5f85-b727-ed90-dca1a52b3775@mirix.org>
Date:   Sun, 26 Dec 2021 17:12:24 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <YciSJYMgyHtvyPc6@karbon.k.g>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 26/12/2021 17:02, Petko Manolov wrote:
> On 21-12-26 14:25:02, Matthias-Christian Ott wrote:
>> Commit 1a8deec09d12 ("pegasus: fixes reported packet length") tried to
>> configure the hardware to not include the FCS/CRC of Ethernet frames.
>> Unfortunately, this does not work with the D-Link DSB-650TX (USB IDs
>> 2001:4002 and 2001:400b): the transferred "packets" (in the terminology
>> of the hardware) still contain 4 additional octets. For IP packets in
>> Ethernet this is not a problem as IP packets contain their own lengths
>> fields but other protocols also see Ethernet frames that include the FCS
>> in the payload which might be a problem for some protocols.
>>
>> I was not able to open the D-Link DSB-650TX as the case is a very tight
>> press fit and opening it would likely destroy it. However, according to
>> the source code the earlier revision of the D-Link DSB-650TX (USB ID
>> 2001:4002) is a Pegasus (possibly AN986) and not Pegasus II (AN8511)
>> device. I also tried it with the later revision of the D-Link DSB-650TX
>> (USB ID 2001:400b) which is a Pegasus II device according to the source
>> code and had the same results. Therefore, I'm not sure whether the RXCS
>> (rx_crc_sent) field of the EC0 (Ethernet control_0) register has any
>> effect or in which revision of the hardware it is usable and has an
>> effect. As a result, it seems best to me to revert commit
>> 1a8deec09d12 ("pegasus: fixes reported packet length") and to set the
>> RXCS (rx_crc_sent) field of the EC0 (Ethernet control_0) register so
>> that the FCS/CRC is always included.
>>
>> Fixes: 1a8deec09d12 ("pegasus: fixes reported packet length")
>> Signed-off-by: Matthias-Christian Ott <ott@mirix.org>
>> ---
>>  drivers/net/usb/pegasus.c | 15 ++++++++++++++-
>>  1 file changed, 14 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/net/usb/pegasus.c b/drivers/net/usb/pegasus.c
>> index c4cd40b090fd..140d11ae6688 100644
>> --- a/drivers/net/usb/pegasus.c
>> +++ b/drivers/net/usb/pegasus.c
>> @@ -422,7 +422,13 @@ static int enable_net_traffic(struct net_device *dev, struct usb_device *usb)
>>  	ret = read_mii_word(pegasus, pegasus->phy, MII_LPA, &linkpart);
>>  	if (ret < 0)
>>  		goto fail;
>> -	data[0] = 0xc8; /* TX & RX enable, append status, no CRC */
>> +	/* At least two hardware revisions of the D-Link DSB-650TX (USB IDs
>> +	 * 2001:4002 and 2001:400b) include the Ethernet FCS in the packets,
>> +	 * even if RXCS is set to 0 in the EC0 register and the hardware is
>> +	 * instructed to not include the Ethernet FCS in the packet.Therefore,
>> +	 * it seems best to set RXCS to 1 and later ignore the Ethernet FCS.
>> +	 */
>> +	data[0] = 0xc9; /* TX & RX enable, append status, CRC */
>>  	data[1] = 0;
>>  	if (linkpart & (ADVERTISE_100FULL | ADVERTISE_10FULL))
>>  		data[1] |= 0x20;	/* set full duplex */
>> @@ -513,6 +519,13 @@ static void read_bulk_callback(struct urb *urb)
>>  		pkt_len = buf[count - 3] << 8;
>>  		pkt_len += buf[count - 4];
>>  		pkt_len &= 0xfff;
>> +		/* The FCS at the end of the packet is ignored. So subtract
>> +		 * its length to ignore it.
>> +		 */
>> +		pkt_len -= ETH_FCS_LEN;
>> +		/* Subtract the length of the received status at the end of the
>> +		 * packet as it is not part of the Ethernet frame.
>> +		 */
>>  		pkt_len -= 4;
>>  	}
> 
> Nice catch.  However, changing these constants for all devices isn't such a good
> idea.  I'd rather use vendor and device IDs to distinguish these two cases in
> the above code.

I don't think that it would hurt to include the FCS for all devices. I
only have the datasheets for the ADM8511/X and the ADM8513 but it seems
that all devices that are supported by the driver also include the RXCS
field in EC0. This was also the previous behaviour before commit
1a8deec09d12 and seemed to have worked. It also only adds four octet
that have to be transferred and it seems to avoid exceptions for
different devices which seems to be a good idea, in particular, because
it is not easy to acquire all of the supported devices as they are no
longer sold or manufactured.

That being said, if you are going to veto this change otherwise, I can
of course just add the FCS back for the two USB IDs, even though it
likely affects other devices as well.

Kind regards,
Matthias-Christian Ott
