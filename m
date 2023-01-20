Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9BC8167617A
	for <lists+netdev@lfdr.de>; Sat, 21 Jan 2023 00:28:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229826AbjATX2B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Jan 2023 18:28:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229487AbjATX2A (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Jan 2023 18:28:00 -0500
Received: from mail.3ffe.de (0001.3ffe.de [159.69.201.130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 475C853FB1;
        Fri, 20 Jan 2023 15:27:59 -0800 (PST)
Received: from 3ffe.de (0001.3ffe.de [IPv6:2a01:4f8:c0c:9d57::1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.3ffe.de (Postfix) with ESMTPSA id A1E8B128F;
        Sat, 21 Jan 2023 00:27:57 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2022082101;
        t=1674257277;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=15naqOmKfHXhG56iuiMa9Jonm/FKerdElAQyJk+4o7E=;
        b=X04kko57AJnLGQ0aZxDV7+voq161LQxQ+FKMbLSsSEsg3rUOXdxXW0cJ5W0zfypOCIbutM
        quBbeiSnvzenoXQphqIZIb+Il9NgAZHZxTDKvneYpzVMwz/GiVBdPxeMA7nsxM+DOe5jLm
        RaTJ/w/qOWT8UmhlYdrTohSIm2JI4EaJodDEPmLhE+3zN6vLHmOBlsKg4rfypdjqb5u6De
        +UMF75eHqBUxy3LfZ8SthqWfLeHepCHZeTywxKMEfkpMDqidDshWqZnOStakLH3hB7snne
        k1DZiOWYtUxz+tY8rXsF2EGZry77F40TCbzkFU0IbnYWsEkDb5CGNcTpEW/NqQ==
MIME-Version: 1.0
Date:   Sat, 21 Jan 2023 00:27:57 +0100
From:   Michael Walle <michael@walle.cc>
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc:     Yisen Zhuang <yisen.zhuang@huawei.com>,
        Salil Mehta <salil.mehta@huawei.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Broadcom internal kernel review list 
        <bcm-kernel-feedback-list@broadcom.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        =?UTF-8?Q?Marek_Beh=C3=BAn?= <kabel@kernel.org>,
        Xu Liang <lxu@maxlinear.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 4/5] phy: net: introduce phy_promote_to_c45()
In-Reply-To: <Y8shrgmEoznYsol7@shell.armlinux.org.uk>
References: <20230120224011.796097-1-michael@walle.cc>
 <20230120224011.796097-5-michael@walle.cc>
 <Y8shrgmEoznYsol7@shell.armlinux.org.uk>
User-Agent: Roundcube Webmail/1.4.13
Message-ID: <de7f4c8b26fb0e9da7480548cf510906@walle.cc>
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

Am 2023-01-21 00:20, schrieb Russell King (Oracle):
> On Fri, Jan 20, 2023 at 11:40:10PM +0100, Michael Walle wrote:
>> If not explitly asked to be probed as a C45 PHY, on a bus which is
>> capable of doing both C22 and C45 transfers, C45 PHYs are first tried 
>> to
>> be probed as C22 PHYs. To be able to promote the PHY to be a C45 one,
>> the driver can call phy_promote_to_c45() in its probe function.
>> 
>> This was already done in the mxl-gpy driver by the following snippet:
>> 
>>    if (!phydev->has_c45) {
>>            ret = phy_get_c45_ids(phydev);
>>            if (ret < 0)
>>                    return ret;
>>    }
>> 
>> Move that code into the core by creating a new function
>> phy_promote_to_c45(). If a PHY is promoted, C45-over-C22 access is 
>> used,
>> regardless if the bus supports C45 or not. That is because there might
>> be C22 PHYs on the bus which gets confused by C45 accesses.
> 
> It is my understanding that C45 PHYs do not have to respond to C22
> accesses. So, wouldn't this lead to some C45 PHYs not being detected?

In that case, the PHY already has to be a C45 PHY, correct? Because
no access to c22 means, it can't be probed as a c22 phy; therefore,
it has the has_c45 set to true. Then phy_promote_to_c45() is a noop and
c45-over-c22 wont be set.

-michael
