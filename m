Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5F833641158
	for <lists+netdev@lfdr.de>; Sat,  3 Dec 2022 00:09:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234555AbiLBXJO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Dec 2022 18:09:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232011AbiLBXJN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Dec 2022 18:09:13 -0500
Received: from mail.3ffe.de (0001.3ffe.de [159.69.201.130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75CF31182B;
        Fri,  2 Dec 2022 15:09:10 -0800 (PST)
Received: from 3ffe.de (0001.3ffe.de [IPv6:2a01:4f8:c0c:9d57::1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.3ffe.de (Postfix) with ESMTPSA id 2B96524E;
        Sat,  3 Dec 2022 00:09:08 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2022082101;
        t=1670022548;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=9NRV57aXTBgiKCSCgggXRv2Sdf97U/uCm/dme3mjklM=;
        b=fGcqBMd5asKZtdHRi/fYbtEU4DmqcYPap2wb/JsZDR2S/XBTRqDPM7WOYI0uYkLqvZQS+0
        hTOxk9vmtAvtyhI7uNQnPIjm5J8EKxEodmKMcBPfdHrpKauCeOixO8cOlXnAkUq9yVRlaT
        rmwn37JcTJIHDMR9tceyXiphEJdhPZWC2iPgeavqh5PaRph9qHBDmyYt6m4dkDxPWplBd9
        d2FUwn+4bLsOq4G+CCtd1toryjaO31FATxupFC8UBi7DpbzoxdeL05iCFS7WZj68npv7Jc
        Xd6Hrlm6vxbLgZNnoqeeja3Pos4SJyrBwr3ULo1d8eev6AU6809yeyPad1+PAQ==
MIME-Version: 1.0
Date:   Sat, 03 Dec 2022 00:09:07 +0100
From:   Michael Walle <michael@walle.cc>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Xu Liang <lxu@maxlinear.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: Re: [PATCH net-next v1 4/4] net: phy: mxl-gpy: disable interrupts on
 GPY215 by default
In-Reply-To: <Y4pHCQrDbXXmOT+A@lunn.ch>
References: <20221202151204.3318592-1-michael@walle.cc>
 <20221202151204.3318592-5-michael@walle.cc> <Y4pHCQrDbXXmOT+A@lunn.ch>
User-Agent: Roundcube Webmail/1.4.13
Message-ID: <69e0468cf192455fd2dc7fc93194a8ff@walle.cc>
X-Sender: michael@walle.cc
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Am 2022-12-02 19:42, schrieb Andrew Lunn:
> On Fri, Dec 02, 2022 at 04:12:04PM +0100, Michael Walle wrote:
>> The interrupts on the GPY215B and GPY215C are broken and the only 
>> viable
>> fix is to disable them altogether. There is still the possibilty to
>> opt-in via the device tree.
>> 
>> Signed-off-by: Michael Walle <michael@walle.cc>
>> ---
>>  drivers/net/phy/mxl-gpy.c | 5 +++++
>>  1 file changed, 5 insertions(+)
>> 
>> diff --git a/drivers/net/phy/mxl-gpy.c b/drivers/net/phy/mxl-gpy.c
>> index 20e610dda891..edb8cd8313b0 100644
>> --- a/drivers/net/phy/mxl-gpy.c
>> +++ b/drivers/net/phy/mxl-gpy.c
>> @@ -12,6 +12,7 @@
>>  #include <linux/mutex.h>
>>  #include <linux/phy.h>
>>  #include <linux/polynomial.h>
>> +#include <linux/property.h>
>>  #include <linux/netdevice.h>
>> 
>>  /* PHY ID */
>> @@ -290,6 +291,10 @@ static int gpy_probe(struct phy_device *phydev)
>>  	phydev->priv = priv;
>>  	mutex_init(&priv->mbox_lock);
>> 
>> +	if (gpy_has_broken_mdint(phydev) &&
>> +	    !device_property_present(dev, 
>> "maxlinear,use-broken-interrupts"))
>> +		phydev->irq = PHY_POLL;
>> +
> 
> I'm not sure of ordering here. It could be phydev->irq is set after
> probe. The IRQ is requested as part of phy_connect_direct(), which is
> much later.

I've did it that way, because phy_probe() also sets phydev->irq = 
PHY_POLL
in some cases and the phy driver .probe() is called right after it.

> I think a better place for this test is in gpy_config_intr(), return
> -EOPNOTSUPP. phy_enable_interrupts() failing should then cause
> phy_request_interrupt() to use polling.

Which will then print a warning, which might be misleading.
Or we disable the warning if -EOPNOTSUPP is returned?

-michael
