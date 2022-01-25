Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 63F7C49B720
	for <lists+netdev@lfdr.de>; Tue, 25 Jan 2022 16:02:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358104AbiAYPB4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jan 2022 10:01:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1581257AbiAYO7N (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jan 2022 09:59:13 -0500
Received: from ssl.serverraum.org (ssl.serverraum.org [IPv6:2a01:4f8:151:8464::1:2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C32B7C06173B;
        Tue, 25 Jan 2022 06:59:11 -0800 (PST)
Received: from ssl.serverraum.org (web.serverraum.org [172.16.0.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ssl.serverraum.org (Postfix) with ESMTPSA id 583C222246;
        Tue, 25 Jan 2022 15:59:07 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2016061301;
        t=1643122748;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=sM8Q2KXy+Jfx3tOwipesCkOAKh8jg0scyT5GXZrZG50=;
        b=dr/FI8+r3AXWq6WCwokEUvanPYljOb5z/fA0yl0aK7v9LYN4nf+fcPyaUxATUtx7RR/GET
        3tpiqqEVzBVYXRJfCzJNFdUfdhjFOyVwmP+JOSHOvEy8fyLYz4O0hwLuI3/9mJjuzxV2Q+
        0HZug21gTPv5uo0nmXD8ng/4+Drmjmw=
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 8bit
Date:   Tue, 25 Jan 2022 15:59:07 +0100
From:   Michael Walle <michael@walle.cc>
To:     =?UTF-8?Q?Rafa=C5=82_Mi=C5=82ecki?= <zajec5@gmail.com>
Cc:     linux-mtd@lists.infradead.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        netdev@vger.kernel.org, Miquel Raynal <miquel.raynal@bootlin.com>,
        Richard Weinberger <richard@nod.at>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Rob Herring <robh+dt@kernel.org>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Shawn Guo <shawnguo@kernel.org>, Li Yang <leoyang.li@nxp.com>,
        Frank Rowand <frowand.list@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Ansuel Smith <ansuelsmth@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>
Subject: Re: [PATCH 6/8] nvmem: transformations: ethernet address offset
 support
In-Reply-To: <455f4360-34fe-7fee-66d5-fd945fe1e086@gmail.com>
References: <20211228142549.1275412-1-michael@walle.cc>
 <20211228142549.1275412-7-michael@walle.cc>
 <455f4360-34fe-7fee-66d5-fd945fe1e086@gmail.com>
User-Agent: Roundcube Webmail/1.4.12
Message-ID: <19d7206a42c7616d45733e44c9e52878@walle.cc>
X-Sender: michael@walle.cc
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

Am 2022-01-25 13:08, schrieb Rafał Miłecki:
> On 28.12.2021 15:25, Michael Walle wrote:
>> An nvmem cell might just contain a base MAC address. To generate a
>> address of a specific interface, add a transformation to add an offset
>> to this base address.
>> 
>> Add a generic implementation and the first user of it, namely the sl28
>> vpd storage.
>> 
>> Signed-off-by: Michael Walle <michael@walle.cc>
>> ---
>>   drivers/nvmem/transformations.c | 45 
>> +++++++++++++++++++++++++++++++++
>>   1 file changed, 45 insertions(+)
>> 
>> diff --git a/drivers/nvmem/transformations.c 
>> b/drivers/nvmem/transformations.c
>> index 61642a9feefb..15cd26da1f83 100644
>> --- a/drivers/nvmem/transformations.c
>> +++ b/drivers/nvmem/transformations.c
>> @@ -12,7 +12,52 @@ struct nvmem_transformations {
>>   	nvmem_cell_post_process_t pp;
>>   };
>>   +/**
>> + * nvmem_transform_mac_address_offset() - Add an offset to a mac 
>> address cell
>> + *
>> + * A simple transformation which treats the index argument as an 
>> offset and add
>> + * it to a mac address. This is useful, if the nvmem cell stores a 
>> base
>> + * ethernet address.
>> + *
>> + * @index: nvmem cell index
>> + * @data: nvmem data
>> + * @bytes: length of the data
>> + *
>> + * Return: 0 or negative error code on failure.
>> + */
>> +static int nvmem_transform_mac_address_offset(int index, unsigned int 
>> offset,
>> +					      void *data, size_t bytes)
>> +{
>> +	if (bytes != ETH_ALEN)
>> +		return -EINVAL;
>> +
>> +	if (index < 0)
>> +		return -EINVAL;
>> +
>> +	if (!is_valid_ether_addr(data))
>> +		return -EINVAL;
>> +
>> +	eth_addr_add(data, index);
>> +
>> +	return 0;
>> +}
>> +
>> +static int nvmem_kontron_sl28_vpd_pp(void *priv, const char *id, int 
>> index,
>> +				     unsigned int offset, void *data,
>> +				     size_t bytes)
>> +{
>> +	if (!id)
>> +		return 0;
>> +
>> +	if (!strcmp(id, "mac-address"))
>> +		return nvmem_transform_mac_address_offset(index, offset, data,
>> +							  bytes);
>> +
>> +	return 0;
>> +}
>> +
>>   static const struct nvmem_transformations nvmem_transformations[] = 
>> {
>> +	{ .compatible = "kontron,sl28-vpd", .pp = nvmem_kontron_sl28_vpd_pp 
>> },
>>   	{}
>>   };
> 
> I think it's a rather bad solution that won't scale well at all.
> 
> You'll end up with a lot of NVMEM device specific strings and code in a
> NVMEM core.

They must not be in the core, but they have to be somewhere. That is
because Rob isn't fond of describing the actual transformation in
the device tree but to have it a specific compatible [1]. Thus you have
to have these strings somewhere in the driver code.

> You'll have a lot of duplicated code (many device specific functions
> calling e.g. nvmem_transform_mac_address_offset()).

If there will be multiple formats using the same transformation for
different compatible strings, you could just use the same function
for all compatibles.

But we have to first agree on the device tree representation because
that is then fixed. The driver code can change over time.

> I think it also ignores fact that one NVMEM device can be reused in
> multiple platforms / device models using different (e.g. vendor / 
> device
> specific) cells.
> 
> 
> What if we have:
> 1. Foo company using "kontron,sl28-vpd" with NVMEM cells:
>    a. "mac-address"
>    b. "mac-address-2"
>    c. "mac-address-3"
> 2. Bar company using "kontron,sl28-vpd" with NVMEM cell:
>    a. "mac-address"
> 
> In the first case you don't want any transformation.

I can't follow you here. The "kontron,sl28-vpd" specifies one
particular format, namely, that there is a base address
rather than individual ones.

> If you consider using transformations for ASCII formats too then it
> causes another conflict issue. Consider two devices:
> 
> 1. Foo company device with BIN format of MAC
> 2. Bar company device with ASCII format of MAC
> 
> Both may use exactly the same binding:
> 
> partition@0 {
>         compatible = "nvmem-cells";
>         reg = <0x0 0x100000>;
>         label = "bootloader";
> 
>         #address-cells = <1>;
>         #size-cells = <1>;
> 
>         mac-address@100 {
>                 reg = <0x100 0x6>;
>         };
> };
> 
> how are you going to handle them with proposed implementation? You 
> can't
> support both if you share "nvmem-cells" compatible string.

No, you'd need two different compatible strings. Again, that all boils
down to what the device tree should describe and what not.

But if you have the u-boot environment as an nvmem provider, you already
know that the mac address is in ascii representation and you'd need
to transform it to the kernel representation.

> I think that what can solve those problems is assing "compatible" to
> NVMEM cells.
> 
> Let me think about details of that possible solution.

See [2].

-michael

[1] 
https://lore.kernel.org/linux-devicetree/YaZ5JNCFeKcdIfu8@robh.at.kernel.org/
[2] 
https://lore.kernel.org/linux-devicetree/CAL_JsqL55mZJ6jUyQACer2pKMNDV08-FgwBREsJVgitnuF18Cg@mail.gmail.com/
