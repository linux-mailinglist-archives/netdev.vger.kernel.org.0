Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9460B679C39
	for <lists+netdev@lfdr.de>; Tue, 24 Jan 2023 15:42:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234459AbjAXOma (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Jan 2023 09:42:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233621AbjAXOm2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Jan 2023 09:42:28 -0500
Received: from mail.3ffe.de (0001.3ffe.de [IPv6:2a01:4f8:c0c:9d57::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B3FD4A239;
        Tue, 24 Jan 2023 06:42:01 -0800 (PST)
Received: from 3ffe.de (0001.3ffe.de [IPv6:2a01:4f8:c0c:9d57::1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.3ffe.de (Postfix) with ESMTPSA id CF79238;
        Tue, 24 Jan 2023 15:41:56 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2022082101;
        t=1674571316;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=9yw77V4shCHNv/4/RPjmgehtlFoZNBUhxM9+dg++5ks=;
        b=fAmhEVGugApXBkM0Lo9pKHUI/2DzBsUePMcd2De47QXNppMsai2IBvsoDb08Y7+QoilFqC
        8oEX8xIQQpKQTleidlzQGTAiqPm/jyqGT1pXiK59LMD2TwLAFhXvgUZJok2zsYkkI2446e
        dNJVBE7ISfjc/dm64pe5AlCdDZ02QabQ6Az4zhllVcHMdy2YL3LDwkvrWCIVqn7gpCZy1p
        P6x5cNOs5bU71r9LpLHUCbDZO9iAjSKnnMgMhdoj+jIvNz9+NLqNRD8Nl/60wnWYuHey4c
        ZIDpr1LLfXiwvt9Q3t0IbVb2fNN72a3hD8GzwdN1Y4aGsOG5TLKFfjb8UrUHTQ==
MIME-Version: 1.0
Date:   Tue, 24 Jan 2023 15:41:56 +0100
From:   Michael Walle <michael@walle.cc>
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Yisen Zhuang <yisen.zhuang@huawei.com>,
        Salil Mehta <salil.mehta@huawei.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Broadcom internal kernel review list 
        <bcm-kernel-feedback-list@broadcom.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        =?UTF-8?Q?Marek_Beh=C3=BAn?= <kabel@kernel.org>,
        Xu Liang <lxu@maxlinear.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 0/5] net: phy: C45-over-C22 access
In-Reply-To: <Y87WR/T395hKmgKm@shell.armlinux.org.uk>
References: <20230120224011.796097-1-michael@walle.cc>
 <Y87L5r8uzINALLw4@lunn.ch> <Y87WR/T395hKmgKm@shell.armlinux.org.uk>
User-Agent: Roundcube Webmail/1.4.13
Message-ID: <dcea8c36e626dc31ee1ddd8c867eb999@walle.cc>
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

>> The problem is in the middle.  get_phy_c45_devs_in_pkg() uses
>> mdiobus_c45_read(). Does mdiobus_c45_read() mean perform a C45 bus
>> transaction, or access the C45 address space? I would say it means
>> perform a C45 bus transaction. It does not take a phydev, so we are
>> below the concept of PHYs, and so C45 over C22 does not exist at this
>> level.
> 
> C45-over-C22 is a PHY thing, it isn't generic. We shouldn't go poking
> at the PHY C45-over-C22 registers unless we know for certain that the
> C22 device we are accessing is a PHY, otherwise we could be writing
> into e.g. a switch register or something else.
> 
> So, the mdiobus_* API should be the raw bus API. If we want C45 bus
> cycles then mdiobus_c45_*() is the API that gives us that, vs C22 bus
> cycles through the non-C45 API.
> 
> C45-over-C22 being a PHY thing is something that should be handled by
> phylib, and currently is. The phylib accessors there will use C45 or
> C45-over-C22 as appropriate.

I think the crux is get_phy_device(). It is used for two different
cases:
  (1) to scan the mdio bus
  (2) to add a c45 phy, i.e. in the DT/fwnode case

For (1) we must not use indirect access. And for (2) we know for
a fact that it must be a PHY and thus we can (and have to) fall back
to c45-over-c22.

Btw. for the DT case, it seems we need yet another property
to indicate broken MDIO busses.

-michael
