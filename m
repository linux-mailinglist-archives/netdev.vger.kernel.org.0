Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E822837C7DB
	for <lists+netdev@lfdr.de>; Wed, 12 May 2021 18:38:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236926AbhELQDA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 May 2021 12:03:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234814AbhELPwj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 May 2021 11:52:39 -0400
Received: from ssl.serverraum.org (ssl.serverraum.org [IPv6:2a01:4f8:151:8464::1:2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82DD3C06137A;
        Wed, 12 May 2021 08:27:33 -0700 (PDT)
Received: from ssl.serverraum.org (web.serverraum.org [172.16.0.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ssl.serverraum.org (Postfix) with ESMTPSA id C49182225B;
        Wed, 12 May 2021 17:27:28 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2016061301;
        t=1620833251;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=/lNbUY/raG/xRWA6P8fTkTsqWviUwUsi8XU1DoxL1/M=;
        b=Jj+17XP/xwM+dPAw2Pj80gHf1z5xq1Yr961HLmLV9nokufv2KA2Xpd6SMhT9omtPic4mQA
        Jl92FskDHiRqjhCkfmeaWkIu16InuTrErlTLck1Dty+8beZqahjpF4Md/9oCN2jMIJToce
        0vNrKOzBTgEOA/uSWAaC4s5LofDXAvk=
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Wed, 12 May 2021 17:27:28 +0200
From:   Michael Walle <michael@walle.cc>
To:     Rob Herring <robh@kernel.org>
Cc:     Andrew Lunn <andrew@lunn.ch>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Frank Rowand <frowand.list@gmail.com>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Ansuel Smith <ansuelsmth@gmail.com>
Subject: Re: [PATCH net-next 1/3] dt-bindings: net: add
 nvmem-mac-address-offset property
In-Reply-To: <fefde522146d18aa7f8fbb8fa698cb58@walle.cc>
References: <20210414152657.12097-1-michael@walle.cc>
 <20210414152657.12097-2-michael@walle.cc> <YHcNtdq+oIYcB08+@lunn.ch>
 <20210415215955.GA1937954@robh.at.kernel.org>
 <fefde522146d18aa7f8fbb8fa698cb58@walle.cc>
User-Agent: Roundcube Webmail/1.4.11
Message-ID: <362f1c6a8b0ec191b285ac6a604500da@walle.cc>
X-Sender: michael@walle.cc
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

[adding Srinivas Kandagatla and Ansuel Smith]

Am 2021-04-16 00:27, schrieb Michael Walle:
> Am 2021-04-15 23:59, schrieb Rob Herring:
>> On Wed, Apr 14, 2021 at 05:43:49PM +0200, Andrew Lunn wrote:
>>> On Wed, Apr 14, 2021 at 05:26:55PM +0200, Michael Walle wrote:
>>> > It is already possible to read the MAC address via a NVMEM provider. But
>>> > there are boards, esp. with many ports, which only have a base MAC
>>> > address stored. Thus we need to have a way to provide an offset per
>>> > network device.
>>> 
>>> We need to see what Rob thinks of this. There was recently a patchset
>>> to support swapping the byte order of the MAC address in a NVMEM. Rob
>>> said the NVMEM provider should have the property, not the MAC driver.
>>> This does seems more ethernet specific, so maybe it should be an
>>> Ethernet property?
>> 
>> There was also this one[1]. I'm not totally opposed, but don't want to
>> see a never ending addition of properties to try to describe any
>> possible transformation.
> 
> Agreed, that stuff like ASCII MAC address parsing should be done
> elsewhere. But IMHO adding an offset is a pretty common one (as also
> pointed out in [1]). And it also need to be a per ethernet device
> property.

I'm a bit up in the air on this, as I don't know how to proceed here.

To cite Rob from IRC:
   Not really up to me. All the people that care need to come up with
   something flexible enough for common/simple cases and that's not
   going to get extended with every new variation. What I don't want is
   a one-off that's then extended with another one-off.

I already pointed out that this property is per consumer as opposed
to something like endianess swap or parsing a given format. The latter
operates on the nvmem cell.

One random idea is to have a nvmem-cells-transformation (in the lack of
a better name) property for consumers, where you can have some kind of
simple operations like add:
   nvmem-cells-transformation = <NVMEM_ADD 1>
But is that something we really want to have? I'm not sure.

btw. given that there might be other means where a base mac address can
come from in the future, it might make sense to drop the "nvmem-"
prefix and just use "mac-address-offset" (or 
"base-mac-address-offset"?).

> [1] 
> https://patchwork.ozlabs.org/project/devicetree-bindings/patch/20200920095724.8251-4-ansuelsmth@gmail.com/

-michael
