Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 85C0547F82C
	for <lists+netdev@lfdr.de>; Sun, 26 Dec 2021 17:01:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230484AbhLZQBa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Dec 2021 11:01:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229711AbhLZQBa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 Dec 2021 11:01:30 -0500
Received: from mirix.in-vpn.de (mirix.in-vpn.de [IPv6:2001:67c:1407:a0::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE61EC06173E;
        Sun, 26 Dec 2021 08:01:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mirix.org;
        s=43974b1a7d21b2cf; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:
        MIME-Version:Date:Message-ID:From:References:Cc:To:Subject:Sender:Reply-To:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=rg0k5zhAPFc7Pi9ts554EK56qLUcykuskxNyvxU80Bk=; b=eCQLWvKu49U6CKhi8hg4YJF5uv
        pP94Fd4Tjag5xKRYUMaGrRXCqg9JvkUfsmh+88pHlPmgV+k195BTQ1iN6pLCiYhL/mykfHGrQVXCj
        TafLCLA890WLVicjto6J38bTMIHj4g6y39CgClaiSQyWlUbFYeMjUp7yNsMt7s6ZdGJesAcls5I+I
        7Ix7y5Hoxe1dqLnrR/ZlXLtjM6CS0Yz2h+lZ4pf5iwpisX3zG+oTannpu9IU3sfXpp7QglC/9//2M
        Yq1XQUatXbrEMks13oZV4NSWZaeixbM+5Ev2hk5IxyoBzqlf3KQ9+rU4y/QUV73Lw+qjNnmiLJgad
        vTB5qrrg==;
Received: from [::1] (helo=localhost.localdomain)
        by mirix.in-vpn.de with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_128_GCM:128)
        (Exim)
        id 1n1Vxe-0005vb-Jl; Sun, 26 Dec 2021 16:01:26 +0000
Subject: Re: [PATCH] net: usb: pegasus: Do not drop long Ethernet frames
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Petko Manolov <petkan@nucleusys.com>, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org
References: <20211226132930.7220-1-ott@mirix.org> <YciMrJBDk6bA5+Nv@lunn.ch>
From:   Matthias-Christian Ott <ott@mirix.org>
Message-ID: <a87c4ea5-72ef-8dd3-de98-01f799d627ef@mirix.org>
Date:   Sun, 26 Dec 2021 17:01:24 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <YciMrJBDk6bA5+Nv@lunn.ch>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 26/12/2021 16:39, Andrew Lunn wrote:
> On Sun, Dec 26, 2021 at 02:29:30PM +0100, Matthias-Christian Ott wrote:
>> The D-Link DSB-650TX (2001:4002) is unable to receive Ethernet frames
>> that are longer than 1518 octets, for example, Ethernet frames that
>> contain 802.1Q VLAN tags.
>>
>> The frames are sent to the pegasus driver via USB but the driver
>> discards them because they have the Long_pkt field set to 1 in the
>> received status report. The function read_bulk_callback of the pegasus
>> driver treats such received "packets" (in the terminology of the
>> hardware) as errors but the field simply does just indicate that the
>> Ethernet frame (MAC destination to FCS) is longer than 1518 octets.
>>
>> It seems that in the 1990s there was a distinction between
>> "giant" (> 1518) and "runt" (< 64) frames and the hardware includes
>> flags to indicate this distinction. It seems that the purpose of the
>> distinction "giant" frames was to not allow infinitely long frames due
>> to transmission errors and to allow hardware to have an upper limit of
>> the frame size. However, the hardware already has such limit with its
>> 2048 octet receive buffer and, therefore, Long_pkt is merely a
>> convention and should not be treated as a receive error.
>>
>> Actually, the hardware is even able to receive Ethernet frames with 2048
>> octets which exceeds the claimed limit frame size limit of the driver of
>> 1536 octets (PEGASUS_MTU).
>>
>> Signed-off-by: Matthias-Christian Ott <ott@mirix.org>
>> ---
>>  drivers/net/usb/pegasus.c | 4 ++--
>>  1 file changed, 2 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/net/usb/pegasus.c b/drivers/net/usb/pegasus.c
>> index 140d11ae6688..2582daf23015 100644
>> --- a/drivers/net/usb/pegasus.c
>> +++ b/drivers/net/usb/pegasus.c
>> @@ -499,11 +499,11 @@ static void read_bulk_callback(struct urb *urb)
>>  		goto goon;
>>  
>>  	rx_status = buf[count - 2];
>> -	if (rx_status & 0x1e) {
>> +	if (rx_status & 0x1c) {
>>  		netif_dbg(pegasus, rx_err, net,
>>  			  "RX packet error %x\n", rx_status);
>>  		net->stats.rx_errors++;
>> -		if (rx_status & 0x06)	/* long or runt	*/
>> +		if (rx_status & 0x04)	/* runt	*/
> 
> I've nothing against this patch, but if you are working on the driver,
> it would be nice to replace these hex numbers with #defines using BIT,
> or FIELD. It will make the code more readable.

Replacing the constants with macros is on my list of things that I want
to do. In this case, I did not do it because I wanted to a have small
patch that gets easily accepted and allows me to figure out the current
process to submit patches after years of inactivity.

Kind regards,
Matthias-Christian Ott
