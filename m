Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 578D025636E
	for <lists+netdev@lfdr.de>; Sat, 29 Aug 2020 01:21:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726880AbgH1XVA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Aug 2020 19:21:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726720AbgH1XUy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Aug 2020 19:20:54 -0400
Received: from ipv6.s19.hekko.net.pl (ipv6.s19.hekko.net.pl [IPv6:2a02:1778:113::19])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45B13C061264
        for <netdev@vger.kernel.org>; Fri, 28 Aug 2020 16:20:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=arf.net.pl;
         s=x; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:MIME-Version:Date:
        Message-ID:Cc:To:From:References:Subject:Sender:Reply-To:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=Na3Gzaxwk6FMEjfOn/TGF+MX+8mRYcyh2fWWcqmyx/E=; b=tF9n4O6gvtp/uZ74ruv/Z4Bb1J
        V9J9QEsr2FKpz6yx7isCKBsEDx/TURI/jXwSKxIc7vHDDREas8qhP0EQPw8Xo2PWQ8O86nboq3h1f
        oxMjwic21cAaS/kEU+iISDLAWBcLt867PJ2QbdGx0aKPl0Y4TN7xDFTHuqOU6LOT6LeEBeymdq+yK
        gbPLNM1mvR6t+QRIdnjPURYAsIdGWOuzK18LYqThUOYx2ROwqoiwY0JDmsQTpEKJLV2VFf7Lw6ZtK
        ge9JBrw0s1E1gdXdjlBI9F4eDZ++EwvrHgRY0oU6nGbeLC2Y3cE7sV9SZIPv3w6nnhFkQaquUq5Vj
        3rQupybA==;
Received: from [185.135.2.46] (helo=[172.20.10.2])
        by s19.hekko.net.pl with esmtpsa (TLSv1.2:ECDHE-RSA-AES128-GCM-SHA256:128)
        (Exim 4.92.3)
        (envelope-from <adam.rudzinski@arf.net.pl>)
        id 1kBml5-00FYnw-TW; Sat, 29 Aug 2020 00:22:08 +0200
Subject: proposed modification of drivers/of/of_mdio.c and
 include/linux/of_mdio.h
References: <46a9839e-830c-69a9-08c5-08cfae213a2b@gmail.com>
From:   =?UTF-8?Q?Adam_Rudzi=c5=84ski?= <adam.rudzinski@arf.net.pl>
To:     netdev@vger.kernel.org
Cc:     robh+dt@kernel.org, frowand.list@gmail.com, f.fainelli@gmail.com,
        andrew@lunn.ch
X-Forwarded-Message-Id: <46a9839e-830c-69a9-08c5-08cfae213a2b@gmail.com>
Message-ID: <743ba788-6794-4eba-4fed-b2c019273b35@arf.net.pl>
Date:   Sat, 29 Aug 2020 00:21:59 +0200
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <46a9839e-830c-69a9-08c5-08cfae213a2b@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: pl
X-Authenticated-Id: ar@arf.net.pl
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

I have found that a device with two Ethernet interfaces may have a 
problem with bringing up both interfaces on fresh boot (after power-on). 
According to my investigation, the problem is caused by probing PHYs on 
shared MDIO bus while one PHY still has no clock provided.

The possible workarounds are: reset or relying on u-boot for 
initialization of the clocks. However, they are unacceptable or dangerous.

In my opinion with the current kernel the Ethernet driver has no way of 
doing the thing right, because of_mdio.c allows only "full service" of 
new MDIO bus. I have implemented such modification for my designed 
device (where I encountered the problem), and now it works fine.

The proposed modification essentially comes down to making a part of 
of_mdiobus_register a separate public function (with prototype in the 
header file of_mdio.h). This new function only registers child nodes of 
mdio node from device tree. This enables the ethernet driver to add new 
PHYs to already registered MDIO bus. This is necessary to utilize a 
shared MDIO bus.

Please, let me know how I could or should send my proposed modification. 
My code is derived from kernel 4.19.35 taken from SomLabs' repository. 
Should I clone/fork a specific repo or make a branch in a repo, 
implement the changes there and create a pull-request? Should I send a 
patch versus some specific branch or commit? Or, should I just paste the 
relevant parts of code in a next email (or add as an attachment to an 
email)?

Best regards,
Adam
---------------------
Adam Rudziński
A.R.f.
http://arf.net.pl
