Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F1DD8482B80
	for <lists+netdev@lfdr.de>; Sun,  2 Jan 2022 15:16:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232862AbiABOQK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Jan 2022 09:16:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229760AbiABOQK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 Jan 2022 09:16:10 -0500
Received: from mirix.in-vpn.de (mirix.in-vpn.de [IPv6:2001:67c:1407:a0::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96383C061761;
        Sun,  2 Jan 2022 06:16:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mirix.org;
        s=43974b1a7d21b2cf; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:
        MIME-Version:Date:Message-ID:From:References:Cc:To:Subject:Sender:Reply-To:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=cGoCtpTkA60zMI0CaZaCImZORodnlAxnp76Po/MQWW8=; b=RHd9qkEz6oskgA2AwpuV1UtHVH
        nX83L45KGUtNTQFmZch+xDxZdz35DJvoizM1080950UgwjZOCgo72ISkt/q0h3zzBFhtgwshl3iFm
        cFDLVkL+H95WKLCz1crl4tQSsTsSzFCWZE8AZ9OmmCBz/4mTxNqKwMNKh0/7EHmfH3TUpB6NHZIiM
        wOFj9Z+yOZVFmviEc61zbpgJO6JB+efMkjqn96uMg2E3uYdsO9Sb+2mkBPwBKIrfz0+BKqhRMqpqk
        +FbB3pdvFFmqujbB9Uxvv7LbfmXX9Nj/9z+kGLPPUSP4tRm2v6Ut4LrmFr6aQP65wuOnCuLjc97ET
        gGNWFFbw==;
Received: from [::1] (helo=localhost.localdomain)
        by mirix.in-vpn.de with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_128_GCM:128)
        (Exim)
        id 1n41eX-0001vv-R8; Sun, 02 Jan 2022 14:16:05 +0000
Subject: Re: [PATCH net v2] net: usb: pegasus: Do not drop long Ethernet
 frames
To:     Petko Manolov <petkan@nucleusys.com>
Cc:     linux-usb@vger.kernel.org, netdev@vger.kernel.org
References: <20211226221208.2583-1-ott@mirix.org>
 <YcmfbX5o0XHn1Uhx@karbon.k.g>
From:   Matthias-Christian Ott <ott@mirix.org>
Message-ID: <87aa9378-ac72-7221-6bf1-ee4d6ed2009d@mirix.org>
Date:   Sun, 2 Jan 2022 15:16:04 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <YcmfbX5o0XHn1Uhx@karbon.k.g>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 27/12/2021 12:11, Petko Manolov wrote:
> On 21-12-26 23:12:08, Matthias-Christian Ott wrote:
>> The D-Link DSB-650TX (2001:4002) is unable to receive Ethernet frames that are
>> longer than 1518 octets, for example, Ethernet frames that contain 802.1Q VLAN
>> tags.
>>
>> The frames are sent to the pegasus driver via USB but the driver discards them
>> because they have the Long_pkt field set to 1 in the received status report.
>> The function read_bulk_callback of the pegasus driver treats such received
>> "packets" (in the terminology of the hardware) as errors but the field simply
>> does just indicate that the Ethernet frame (MAC destination to FCS) is longer
>> than 1518 octets.
>>
>> It seems that in the 1990s there was a distinction between "giant" (> 1518)
>> and "runt" (< 64) frames and the hardware includes flags to indicate this
>> distinction. It seems that the purpose of the distinction "giant" frames was
>> to not allow infinitely long frames due to transmission errors and to allow
>> hardware to have an upper limit of the frame size. However, the hardware
>> already has such limit with its 2048 octet receive buffer and, therefore,
>> Long_pkt is merely a convention and should not be treated as a receive error.
>>
>> Actually, the hardware is even able to receive Ethernet frames with 2048
>> octets which exceeds the claimed limit frame size limit of the driver of 1536
>> octets (PEGASUS_MTU).
> 
> 2048 is not mentioned anywhere in both, adm8511 and adm8515 documents.  In the
> latter I found 1638 as max packet length, but that's not the default.  The
> default is 1528 and i don't feel like changing it without further investigation.

I can't remember where I found the number. I adapted the original bug
report that I wrote months ago for the commit message. I'm assuming that
the number comes from the size of the SRAM transmit buffer/TX FIFO. I
also remember that I did some experiments with the MTU to find out what
the hardware supports. However, I don't remember the results of these
experiments. So treat the 2048 as an unverified and perhaps wrong claim.
I will remove it a subsequent version of the patch.

The ADM8515/X datasheet states that the 2 KiB SRAM TX FIFO can hold 4
Ethernet frames which equals a MTU of 512 Octets and that the 24 KiB
SRAM RX FIFO can hold 16 Ethernet frames which equals a MTU of 1536
Octets. This somewhat contradicts the 1638 Octets from the same
datasheet. So it seems best to me find it out with an experiment.

> Thus, i assume it is safe to change PEGASUS_MTU to 1528 for the moment.  VLAN
> frames have 4 additional bytes so we aren't breaking neither pegasus I nor
> pegasus II devices.

Yes, this also not the subject or intent of the commit. I will remove
the sentence from the paragraph in a subsequent version of the patch.

Kind regards,
Matthias-Christian Ott
