Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E3D336410EC
	for <lists+netdev@lfdr.de>; Fri,  2 Dec 2022 23:53:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234610AbiLBWxR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Dec 2022 17:53:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234309AbiLBWxK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Dec 2022 17:53:10 -0500
Received: from mail.3ffe.de (0001.3ffe.de [IPv6:2a01:4f8:c0c:9d57::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F16C1FF9D;
        Fri,  2 Dec 2022 14:53:08 -0800 (PST)
Received: from 3ffe.de (0001.3ffe.de [IPv6:2a01:4f8:c0c:9d57::1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.3ffe.de (Postfix) with ESMTPSA id 7EB7188;
        Fri,  2 Dec 2022 23:53:06 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2022082101;
        t=1670021586;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=sOvF3d2GeraoJaADoPidDcKYhaVUwKw06v7ceSUJOZw=;
        b=Q1zRAEHltwG3Yuxt80w9U6U4WfkGJje5u6SuFvidCzTJU+jiMFUbhWr5o+mmgWXp485M5B
        5oRnCz8J+enFNM1O5gPB8fuYZmsr69cOvD/JHfzcq21FccZuhWPLXEW3drps4VwyT9h1i2
        Xz1BFCYfjRavg3EjxhLXUHGcbIbYYtCX22CT5bU8MZbZdcfo4WWm+Lo2yBdCDeMefbalRR
        L+yN4FnJLqjF/ZvnepRfKx58bKSGLC6UmJi8JrlCQCmwiRLoFEF++1zxwJB3fbvWnB0M2y
        /Oq9vM+6kw9R5/pBcaeLIAiiD0zd9ND6Q5+rVj6QC0duqBZi47H8S0hJBLVFdw==
MIME-Version: 1.0
Date:   Fri, 02 Dec 2022 23:53:06 +0100
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
Subject: Re: [PATCH net-next v1 1/4] net: phy: mxl-gpy: add MDINT workaround
In-Reply-To: <Y4pCiOHgNCPLyZzA@lunn.ch>
References: <20221202151204.3318592-1-michael@walle.cc>
 <20221202151204.3318592-2-michael@walle.cc> <Y4pCiOHgNCPLyZzA@lunn.ch>
User-Agent: Roundcube Webmail/1.4.13
Message-ID: <e3d899872d7a8639dfc91b6c8bab8ffb@walle.cc>
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

Am 2022-12-02 19:23, schrieb Andrew Lunn:
> On Fri, Dec 02, 2022 at 04:12:01PM +0100, Michael Walle wrote:
>> At least the GPY215B and GPY215C has a bug where it is still driving 
>> the
>> interrupt line (MDINT) even after the interrupt status register is 
>> read
>> and its bits are cleared. This will cause an interrupt storm.
>> 
>> Although the MDINT is multiplexed with a GPIO pin and theoretically we
>> could switch the pinmux to GPIO input mode, this isn't possible 
>> because
>> the access to this register will stall exactly as long as the 
>> interrupt
>> line is asserted. We exploit this very fact and just read a random
>> internal register in our interrupt handler. This way, it will be 
>> delayed
>> until the external interrupt line is released and an interrupt storm 
>> is
>> avoided.
>> 
>> The internal register access via the mailbox was deduced by looking at
>> the downstream PHY API because the datasheet doesn't mention any of
>> this.
>> 
>> Signed-off-by: Michael Walle <michael@walle.cc>
>> ---
>>  drivers/net/phy/mxl-gpy.c | 83 
>> +++++++++++++++++++++++++++++++++++++++
>>  1 file changed, 83 insertions(+)
>> 
>> diff --git a/drivers/net/phy/mxl-gpy.c b/drivers/net/phy/mxl-gpy.c
>> index 0ff7ef076072..20e610dda891 100644
>> --- a/drivers/net/phy/mxl-gpy.c
>> +++ b/drivers/net/phy/mxl-gpy.c
>> @@ -9,6 +9,7 @@
>>  #include <linux/module.h>
>>  #include <linux/bitfield.h>
>>  #include <linux/hwmon.h>
>> +#include <linux/mutex.h>
>>  #include <linux/phy.h>
>>  #include <linux/polynomial.h>
>>  #include <linux/netdevice.h>
>> @@ -81,6 +82,14 @@
>>  #define VSPEC1_TEMP_STA	0x0E
>>  #define VSPEC1_TEMP_STA_DATA	GENMASK(9, 0)
>> 
>> +/* Mailbox */
>> +#define VSPEC1_MBOX_DATA	0x5
>> +#define VSPEC1_MBOX_ADDRLO	0x6
>> +#define VSPEC1_MBOX_CMD		0x7
>> +#define VSPEC1_MBOX_CMD_ADDRHI	GENMASK(7, 0)
>> +#define VSPEC1_MBOX_CMD_RD	(0 << 8)
>> +#define VSPEC1_MBOX_CMD_READY	BIT(15)
>> +
>>  /* WoL */
>>  #define VPSPEC2_WOL_CTL		0x0E06
>>  #define VPSPEC2_WOL_AD01	0x0E08
>> @@ -88,7 +97,15 @@
>>  #define VPSPEC2_WOL_AD45	0x0E0A
>>  #define WOL_EN			BIT(0)
>> 
>> +/* Internal registers, access via mbox */
>> +#define REG_GPIO0_OUT		0xd3ce00
>> +
>>  struct gpy_priv {
>> +	struct phy_device *phydev;
>> +
>> +	/* serialize mailbox acesses */
>> +	struct mutex mbox_lock;
>> +
> 
>>  static int gpy_probe(struct phy_device *phydev)
>>  {
>>  	struct device *dev = &phydev->mdio.dev;
>> @@ -228,7 +286,9 @@ static int gpy_probe(struct phy_device *phydev)
>>  	priv = devm_kzalloc(dev, sizeof(*priv), GFP_KERNEL);
>>  	if (!priv)
>>  		return -ENOMEM;
>> +	priv->phydev = phydev;
> 
> I don't think you use this anywhere. Maybe in one of the following
> patches?

Arg. Yes, it's an leftover from when I was using a workqueue to
reenable the interrupts again.

Any opinion whether this patch should be net or net-next?

-michael
