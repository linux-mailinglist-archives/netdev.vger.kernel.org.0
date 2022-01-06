Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 55BBA48620A
	for <lists+netdev@lfdr.de>; Thu,  6 Jan 2022 10:23:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237360AbiAFJX3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jan 2022 04:23:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237327AbiAFJX2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Jan 2022 04:23:28 -0500
Received: from ssl.serverraum.org (ssl.serverraum.org [IPv6:2a01:4f8:151:8464::1:2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7CA97C061245;
        Thu,  6 Jan 2022 01:23:28 -0800 (PST)
Received: from ssl.serverraum.org (web.serverraum.org [172.16.0.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ssl.serverraum.org (Postfix) with ESMTPSA id C769122236;
        Thu,  6 Jan 2022 10:23:22 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2016061301;
        t=1641461005;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=H5FnMDn1LTfHXy/mkIpjundiwjDbx0D7XiU772NlIxs=;
        b=r5YTQ6wZBG7ALB9aK9XdT2tKxJ+4T18RQ9V2jQzs5uOPyyQWE16qyueLEiAXOsNbj6sSnI
        G/yDajHfKdAiAzDzmE6N5j1AEC1wv3Co5ZZPGi09BPopA40n6B56Jhl6purANqyKkwSbRq
        o11aEGcMQOQW8SUYGdP1DGE4dRhGohQ=
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 8bit
Date:   Thu, 06 Jan 2022 10:23:22 +0100
From:   Michael Walle <michael@walle.cc>
To:     zajec5@gmail.com
Cc:     andrew@lunn.ch, davem@davemloft.net, devicetree@vger.kernel.org,
        hkallweit1@gmail.com, kuba@kernel.org,
        linux-kernel@vger.kernel.org, linux@armlinux.org.uk,
        netdev@vger.kernel.org, rafal@milecki.pl, robh+dt@kernel.org,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Subject: Re: [PATCH] of: net: support NVMEM cells with MAC in text format
In-Reply-To: <20211229124047.1286965-1-michael@walle.cc>
References: <20211223122747.30448-1-zajec5@gmail.com>
 <20211229124047.1286965-1-michael@walle.cc>
User-Agent: Roundcube Webmail/1.4.12
Message-ID: <4ce6539e8b7f2486b4c63a45e464da50@walle.cc>
X-Sender: michael@walle.cc
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Am 2021-12-29 13:40, schrieb Michael Walle:
>> Some NVMEM devices have text based cells. In such cases MAC is stored 
>> in
>> a XX:XX:XX:XX:XX:XX format. Use mac_pton() to parse such data and
>> support those NVMEM cells. This is required to support e.g. a very
>> popular U-Boot and its environment variables.
>> 
>> Signed-off-by: Rafał Miłecki <rafal@milecki.pl>
>> ---
>> Please let me know if checking NVMEM cell length (6 B vs. 17 B) can be
>> considered a good enough solution. Alternatively we could use some DT
>> property to make it explicity, e.g. something like:
>> 
>> ethernet@18024000 {
>> 	compatible = "brcm,amac";
>> 	reg = <0x18024000 0x800>;
>> 
>> 	nvmem-cells = <&mac_addr>;
>> 	nvmem-cell-names = "mac-address";
>> 	nvmem-mac-format = "text";
>> };
> 
> Please note, that there is also this proposal, which had such a 
> conversion
> in mind:
> https://lore.kernel.org/linux-devicetree/20211228142549.1275412-1-michael@walle.cc/
> 
> With this patch, there are now two different places where a mac address
> format is converted. In of_get_mac_addr_nvmem() and in the imx otp 
> driver.
> And both have their shortcomings and aren't really flexible. Eg. this 
> one
> magically detects the format by comparing the length, but can't be used 
> for
> to swap bytes (because the length is also ETH_ALEN), which apparently 
> is a
> use case in the imx otp driver. And having the conversion in an nvmem
> provider device driver is still a bad thing IMHO.
> 
> I'd really like to see all these kind of transformations in one place.

Unfortunately, there were no replies yet. Can we revert this patch
until there was a discussion and before there are any users of it.
Esp. the latter is hard to track and then it might be impossible
to change them to a better solution.

Any optionions?

-michael
