Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 410EC29DC44
	for <lists+netdev@lfdr.de>; Thu, 29 Oct 2020 01:23:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727434AbgJ2AXX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Oct 2020 20:23:23 -0400
Received: from fllv0016.ext.ti.com ([198.47.19.142]:55198 "EHLO
        fllv0016.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388505AbgJ1Who (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Oct 2020 18:37:44 -0400
Received: from fllv0035.itg.ti.com ([10.64.41.0])
        by fllv0016.ext.ti.com (8.15.2/8.15.2) with ESMTP id 09SJWSrQ001891;
        Wed, 28 Oct 2020 14:32:28 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1603913548;
        bh=dql6zUttDWwckfnGqpXVkB3hy8f3bWyvhuFEqK3X54c=;
        h=Subject:To:CC:References:From:Date:In-Reply-To;
        b=kUJ/t3DXu6WJKkicGCA80pUu2p0wncptqP0LDy+Vgw9YqOwV1XZtJ645m3dRacGPa
         7LR40XusRRPDoh/53uB6ickFwYQ7Wlz+RgnUmZbxHhHXblBnzk3EbbXmqS+orc1lDP
         gz0xFPX6qmfsmFBzlP80gdCsbDeHB343VvLi5214=
Received: from DFLE112.ent.ti.com (dfle112.ent.ti.com [10.64.6.33])
        by fllv0035.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 09SJWSVf040598
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 28 Oct 2020 14:32:28 -0500
Received: from DFLE110.ent.ti.com (10.64.6.31) by DFLE112.ent.ti.com
 (10.64.6.33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3; Wed, 28
 Oct 2020 14:32:28 -0500
Received: from lelv0327.itg.ti.com (10.180.67.183) by DFLE110.ent.ti.com
 (10.64.6.31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3 via
 Frontend Transport; Wed, 28 Oct 2020 14:32:28 -0500
Received: from [10.250.100.73] (ileax41-snat.itg.ti.com [10.172.224.153])
        by lelv0327.itg.ti.com (8.15.2/8.15.2) with ESMTP id 09SJWOuT056574;
        Wed, 28 Oct 2020 14:32:25 -0500
Subject: Re: [PATCH] RFC: net: phy: of phys probe/reset issue
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>
CC:     "David S. Miller" <davem@davemloft.net>, <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Sekhar Nori <nsekhar@ti.com>, <linux-kernel@vger.kernel.org>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Roger Quadros <rogerq@ti.com>,
        Russell King <linux@armlinux.org.uk>,
        Rob Herring <robh+dt@kernel.org>
References: <20201023174750.21356-1-grygorii.strashko@ti.com>
 <450d262e-242c-77f1-9f06-e25943cc595c@gmail.com>
 <20201023201046.GB752111@lunn.ch>
From:   Grygorii Strashko <grygorii.strashko@ti.com>
Message-ID: <87f264f7-da24-61db-2339-59a88d88e533@ti.com>
Date:   Wed, 28 Oct 2020 21:32:32 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20201023201046.GB752111@lunn.ch>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

hi Andrew,

On 23/10/2020 23:10, Andrew Lunn wrote:
>> Yes there is: have your Ethernet PHY compatible string be of the form
>> "ethernetAAAA.BBBB" and then there is no need for such hacking.
>> of_get_phy_id() will parse that compatible and that will trigger
>> of_mdiobus_register_phy() to take the phy_device_create() path.
> 
> Yep. That does seem like the cleanest way to do this. Let the PHY
> driver deal with the resources it needs.

Thanks you for your comments.

huh. I gave it try and some thinking. it works as W/A, but what does it mean in the long term?

Neither Linux documentation, neither DT bindings suggest such solution in any way
(and there is *Zero* users of ""ethernet-phy-id%4x.%4x" in the current LKML).
And the main reason for this RFC is really bad customer experience while migrating to the new kernels, as
mdio reset does not support multi-phys and phy resets are not working.

Following your comments, my understanding for the long term (to avoid user's confusions) is:
"for OF case the usage of 'ethernet-phy-id%4x.%4x' compatibly is became mandatory for PHYs
to avoid PHY resets dependencies from board design and bootloader".

Which in turn means - update all reference boards by adding ""ethernet-phy-id%4x.%4x" and add
new DT board files for boards which are differ by only PHY version.

:(

-- 
Best regards,
grygorii
