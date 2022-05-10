Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C6129522748
	for <lists+netdev@lfdr.de>; Wed, 11 May 2022 00:56:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237823AbiEJW42 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 May 2022 18:56:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232608AbiEJW4C (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 May 2022 18:56:02 -0400
Received: from mout-p-102.mailbox.org (mout-p-102.mailbox.org [IPv6:2001:67c:2050:0:465::102])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D21CF26DB
        for <netdev@vger.kernel.org>; Tue, 10 May 2022 15:55:56 -0700 (PDT)
Received: from smtp1.mailbox.org (smtp1.mailbox.org [10.196.197.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mout-p-102.mailbox.org (Postfix) with ESMTPS id 4KyYKw0cFkz9sn6;
        Wed, 11 May 2022 00:55:48 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=hauke-m.de; s=MBO0001;
        t=1652223348;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=rhc4bzwrGdn1PJetTP6kS+vmyu5h4GpyQTn67BB/eDk=;
        b=juy4X+KV6+Ga4MjJq+CX2Z5BsGHWqyeviF0cC6lbU/F74MjSIVQoS4xG5hQ50NwArAAOUS
        /QDOijd+/u8ZhdGwcbgYCEO/62QxxohgynCCXoJTKphs7uLM0EMMNHyy+1z6A9oG3r2vBA
        svACFkVDkZeDiuj8HKGnTXh9sfKRG+PJB5wvjVrH/uDSiAzFu4ijUdQG759NspaCu0/V86
        HCYTw4D1WRZqAgdYQ6xV/6o6Tr6sVTk3m0kaGdrBBViQYS3Nvb3+fkzF1/unGltdee53so
        jowph1V/67hMcvlTO/o1tehsi3DVLvPSq/B48v1ywdvAOhHPYw5i+XP2haN/pw==
Message-ID: <c27e2a8b-900a-4bf0-2327-7f0f400bea31@hauke-m.de>
Date:   Wed, 11 May 2022 00:55:43 +0200
MIME-Version: 1.0
Content-Language: en-US
To:     Luiz Angelo Daros de Luca <luizluca@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        =?UTF-8?Q?Alvin_=c5=a0ipraga?= <alsi@bang-olufsen.dk>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "open list:NETWORKING DRIVERS" <netdev@vger.kernel.org>,
        =?UTF-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>
References: <20220508224848.2384723-1-hauke@hauke-m.de>
 <CAJq09z7+bDpMShTxuOvURmp272d-FVDNaDpx1_-qjuOZOOrS3g@mail.gmail.com>
From:   Hauke Mehrtens <hauke@hauke-m.de>
Subject: Re: [PATCH 0/4] net: dsa: realtek: rtl8365mb: Add SGMII and HSGMII
 support
In-Reply-To: <CAJq09z7+bDpMShTxuOvURmp272d-FVDNaDpx1_-qjuOZOOrS3g@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/9/22 08:28, Luiz Angelo Daros de Luca wrote:
>> This was tested on a Buffalo WSR-2533DHP2. This is a board using a
>> Mediatek MT7622 SoC and its 2.5G Ethernet MAC connected over a 2.5G
>> HSGMII link to a RTL8367S switch providing 5 1G ports.
>> This is the only board I have using this switch.
>>
>> With the DSA_TAG_PROTO_RTL8_4 tag format the TCP checksum for all TCP
>> send packets is wrong. It is set to 0x83c6. The mac driver probably
>> should do some TCP checksum offload, but it does not work.
> 
> 0x83c6 might be yout tcp pseudo ip header sum.

Yes this is the default checksum. I see the same checksum when listening 
on my laptop for packets it sends out and where the NIC does checksum 
offloading.

>> When I used the DSA_TAG_PROTO_RTL8_4T tag format the send packets are
>> ok, but it looks like the system does TCP Large receive offload, but
>> does not update the TCP checksum correctly. I see that multiple received
>> TCP packets are combined into one (using tcpdump on switch port on
>> device). The switch tag is also correctly removed. tcpdump complains
>> that the checksum is wrong, it was updated somewhere, but it is wrong.
>>
>> Does anyone know what could be wrong here and how to fix this?
> 
> The good news, it is a known problem:
> 
> https://patchwork.kernel.org/project/netdevbpf/patch/20220411230305.28951-1-luizluca@gmail.com/
> (there are some interesting discussions)
> https://patchwork.kernel.org/project/netdevbpf/patch/20220416052737.25509-1-luizluca@gmail.com/
> (merged)

Thanks for the links.

> The bad news, there is no way to enable checksum offload with
> mediatek+realtek. You'll need to disable almost any type of offload.
> For any tag before the IP header, if your driver/HW does not support a
> way to set where the IP header starts and the offload HW does not
> understand the tag protocol, the offload HW will keep the pseudo ip
> header sum. And for tags after the payload, the offload HW will blend
> the tag with the payload, generating bad checksums when the switch
> removes the tag.
> 
> You can do that from userland, using ethtool on the master port before
> the bridge is up, or patching the driver. You can try this patch
> (written for MT7620 but it is easy to adapt it to upstream
> mtk_eth_soc.c).
> https://github.com/luizluca/openwrt/commit/d799bd363f902bf3b9c595972a1b9280a0b61dca
> . I never submitted that upstream because I don't have the HW to test
> it (Arinç tested a modified version in an MT7621) and I didn't
> investigate how much those extra ifs in ndo_features_check will cost
> in performance when the driver does support the tag (using a mediatek
> switch).

Thanks for the tip to remove the checksum offloading before adding the 
device to the bridge, I was already wondering why it did not work when I 
deactivated the checksum offloading later.

Thanks for the link. I also have one device with a MT7531 switch, but it 
is sued in production. I will check this in the next days.


> And the DSA_TAG_PROTO_RTL8_4T already paid off. It was added exactly
> as a way to test checksum errors. Probably no offload will work for
> tags that are after the payload if the offload HW does not already
> know that tag (e.g. same vendors). DSA_TAG_PROTO_RTL8_4T works because
> it calculates the checksum in software before the tag is added.
> However, during my tests, I never tested TCP Large receive offload.

I accidentally tested TCP Large receive offload. ;-) The driver has a 
special DMA flag for to tell the MAC that there is a Mediatek tag in the 
packet.

>> This uses the rtl8367s-sgmii.bin firmware file. I extracted it from a
>> GPL driver source code with a GPL notice on top. I do not have the
>> source code of this firmware. You can download it here:
>> https://hauke-m.de/files/rtl8367/rtl8367s-sgmii.bin
>> Here are some information about the source:
>> https://hauke-m.de/files/rtl8367/rtl8367s-sgmii.txt
>>
>> This file does not look like intentional GPL. It would be nice if
>> Realtek could send this file or a similar version to the linux-firmware
>> repository under a license which allows redistribution. I do not have
>> any contact at Realtek, if someone has a contact there it would be nice
>> if we can help me on this topic.
>>
>> Hauke Mehrtens (4):
>>    net: dsa: realtek: rtl8365mb: Fix interface type mask
>>    net: dsa: realtek: rtl8365mb: Get chip option
>>    net: dsa: realtek: rtl8365mb: Add setting MTU
>>    net: dsa: realtek: rtl8365mb: Add SGMII and HSGMII support
>>
>>   drivers/net/dsa/realtek/rtl8365mb.c | 444 ++++++++++++++++++++++++++--
>>   1 file changed, 413 insertions(+), 31 deletions(-)

Hauke

