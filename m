Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4937048172C
	for <lists+netdev@lfdr.de>; Wed, 29 Dec 2021 23:04:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229853AbhL2WE4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Dec 2021 17:04:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229575AbhL2WE4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Dec 2021 17:04:56 -0500
Received: from ssl.serverraum.org (ssl.serverraum.org [IPv6:2a01:4f8:151:8464::1:2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFAC5C061574;
        Wed, 29 Dec 2021 14:04:55 -0800 (PST)
Received: from ssl.serverraum.org (web.serverraum.org [172.16.0.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ssl.serverraum.org (Postfix) with ESMTPSA id D429422205;
        Wed, 29 Dec 2021 23:04:51 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2016061301;
        t=1640815492;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=LYOShGFxoVvCBZJANWhGET2Z8pVxxIxQelAYck+8IJQ=;
        b=hp3onYbMLbayQHCVAXMsE4+S7mkL9fFWlL2pR/By8GaPLYaFz83ffCgQxsZpQOVXvVjAqG
        7yyc/GJlLyHzmYMWnk2CPDDIlZCc41F6JtBy5SMDp2prm8lx8xQWkE0RJtZlpD/Xwd+zGw
        S9Z6ddLHMxsQ9+Kgufvct5TqkHLk1SM=
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 8bit
Date:   Wed, 29 Dec 2021 23:04:51 +0100
From:   Michael Walle <michael@walle.cc>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     zajec5@gmail.com, andrew@lunn.ch, davem@davemloft.net,
        devicetree@vger.kernel.org, hkallweit1@gmail.com,
        linux-kernel@vger.kernel.org, linux@armlinux.org.uk,
        netdev@vger.kernel.org, rafal@milecki.pl, robh+dt@kernel.org,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Subject: Re: [PATCH] of: net: support NVMEM cells with MAC in text format
In-Reply-To: <20211229101822.7a740aed@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
References: <20211223122747.30448-1-zajec5@gmail.com>
 <20211229124047.1286965-1-michael@walle.cc>
 <20211229101822.7a740aed@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
User-Agent: Roundcube Webmail/1.4.12
Message-ID: <4cbd5c7160b3c55205315f937eba94f6@walle.cc>
X-Sender: michael@walle.cc
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Am 2021-12-29 19:18, schrieb Jakub Kicinski:
> On Wed, 29 Dec 2021 13:40:47 +0100 Michael Walle wrote:
>> > Some NVMEM devices have text based cells. In such cases MAC is stored in
>> > a XX:XX:XX:XX:XX:XX format. Use mac_pton() to parse such data and
>> > support those NVMEM cells. This is required to support e.g. a very
>> > popular U-Boot and its environment variables.
>> >
>> > Signed-off-by: Rafał Miłecki <rafal@milecki.pl>
>> > ---
>> > Please let me know if checking NVMEM cell length (6 B vs. 17 B) can be
>> > considered a good enough solution. Alternatively we could use some DT
>> > property to make it explicity, e.g. something like:
>> >
>> > ethernet@18024000 {
>> > 	compatible = "brcm,amac";
>> > 	reg = <0x18024000 0x800>;
>> >
>> > 	nvmem-cells = <&mac_addr>;
>> > 	nvmem-cell-names = "mac-address";
>> > 	nvmem-mac-format = "text";
>> > };
>> 
>> Please note, that there is also this proposal, which had such a 
>> conversion
>> in mind:
>> https://lore.kernel.org/linux-devicetree/20211228142549.1275412-1-michael@walle.cc/
>> 
>> With this patch, there are now two different places where a mac 
>> address
>> format is converted. In of_get_mac_addr_nvmem() and in the imx otp 
>> driver.
>> And both have their shortcomings and aren't really flexible. Eg. this 
>> one
>> magically detects the format by comparing the length, but can't be 
>> used for
>> to swap bytes (because the length is also ETH_ALEN), which apparently 
>> is a
>> use case in the imx otp driver. And having the conversion in an nvmem
>> provider device driver is still a bad thing IMHO.
>> 
>> I'd really like to see all these kind of transformations in one place.
> 
> FWIW offsetting from a common base address is relatively common, that's
> why we have:
> 
> /**
>  * eth_hw_addr_gen - Generate and assign Ethernet address to a port
>  * @dev: pointer to port's net_device structure
>  * @base_addr: base Ethernet address
>  * @id: offset to add to the base address
>  *
>  * Generate a MAC address using a base address and an offset and assign 
> it
>  * to a net_device. Commonly used by switch drivers which need to 
> compute
>  * addresses for all their ports. addr_assign_type is not changed.
>  */
> static inline void eth_hw_addr_gen(struct net_device *dev, const u8 
> *base_addr,
> 				   unsigned int id)

I didn't know that. But it doesn't help me that much because it mostly
used for switches, but in my case, I also have up to four network
cards (enetc) on the SoC; besides a network switch (felix). But
only one source for the base mac address.

-michael
