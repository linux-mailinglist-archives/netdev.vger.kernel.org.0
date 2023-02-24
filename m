Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC1D56A17AE
	for <lists+netdev@lfdr.de>; Fri, 24 Feb 2023 09:04:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229668AbjBXIEy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Feb 2023 03:04:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229545AbjBXIEx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Feb 2023 03:04:53 -0500
Received: from mail.3ffe.de (0001.3ffe.de [IPv6:2a01:4f8:c0c:9d57::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0CCC28D2F;
        Fri, 24 Feb 2023 00:04:51 -0800 (PST)
Received: from 3ffe.de (0001.3ffe.de [IPv6:2a01:4f8:c0c:9d57::1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.3ffe.de (Postfix) with ESMTPSA id EDC0F61;
        Fri, 24 Feb 2023 09:04:49 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2022082101;
        t=1677225890;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=8hYTIIbNhdLYsQYh/XYIycPjz/USIz6gl+igSUCQP2Y=;
        b=BorI/xn6hRTyGYBqmeLOtYz69IP1ZRg2y01401Tyw4jzXtO+WCLUXnM5cHQoASvXPMbILC
        5pDAlz9y0YXM+qKGjfOtDQLSTaxGhp1TBC0RjET8rJ0mf1WwtFKIYAge0fOq9bXj305o6N
        h2JEZemB1FY0RHC/SX5GU0tp7nbnvdf4Ux4hr3p5KEn0zXemGSlQ8I6Up/4vD8FTCadkqh
        L6wb3vr+2BGJxCMXmDiukVTuep7AmDgUgMT50OzoCjeyTxNAJZUdlABmTnmNtEXCMPlOSJ
        dmoQ5d1daQwBBH2mqIfS06OZFsLW3YX8Y+LXZzkrLUuIIR/ix9ISD+dDL+laAw==
MIME-Version: 1.0
Date:   Fri, 24 Feb 2023 09:04:49 +0100
From:   Michael Walle <michael@walle.cc>
To:     Martin Schiller <ms@dev.tdt.de>
Cc:     tharvey@gateworks.com, andrew@lunn.ch, davem@davemloft.net,
        f.fainelli@gmail.com, hauke@hauke-m.de, hkallweit1@gmail.com,
        kuba@kernel.org, linux-kernel@vger.kernel.org,
        linux@armlinux.org.uk, martin.blumenstingl@googlemail.com,
        netdev@vger.kernel.org
Subject: Re: [PATCH net-next v6] net: phy: intel-xway: Add RGMII internal
 delay configuration
In-Reply-To: <8aa26f417c99761cdf1b6b7082fdec14@dev.tdt.de>
References: <CAJ+vNU3_8Gk8Mj_uCudMz0=MdN3B9T9pUOvYtP7H_B0fnTfZmg@mail.gmail.com>
 <20230222160425.4040683-1-michael@walle.cc>
 <8aa26f417c99761cdf1b6b7082fdec14@dev.tdt.de>
User-Agent: Roundcube Webmail/1.4.13
Message-ID: <df9a0b6e59d27d5898a9021915ca333a@walle.cc>
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

Hi Martin,

Am 2023-02-24 07:25, schrieb Martin Schiller:
> On 2023-02-22 17:04, Michael Walle wrote:
>> Hi Tim, Hi Martin,
>> 
>>> I've got some boards with the GPY111 phy on them and I'm finding that
>>> modifying XWAY_MDIO_MIICTRL to change the skew has no effect unless I
>>> do a soft reset (BCMR_RESET) first. I don't see anything in the
>>> datasheet which specifies this to be the case so I'm interested it
>>> what you have found. Are you sure adjusting the skews like this
>>> without a soft (or hard pin based) reset actually works?
>> 
>> I do have the same PHY and I'm puzzled with the delay settings. Do
>> you have an EEPROM attached to the PHY? According to my datasheet,
>> that seems to make a difference. Apparently, only if there is an
>> EEPROM, you can change the value (the value is then also written to
>> the EEPROM according the datasheet).
>> If you don't have one, the values will get overwritten by the
>> external strappings on a soft reset. Therefore, it seems they cannot
>> be set. (FWIW there is also a sticky bit, but that doesn't seem to
>> help in this case).
>> 
>> -michael
> 
> Yes, you are right. The datasheet says: "In no-EEPROM mode, writing to
> this register has no impact on operation of the device".
> 
> But changing this settings without an EEPROM indeed has an impact.
> 
> We don't use an EEPROM and without tuning this values some boards are
> unable to communicate on the ethernet port(s).

Thanks for confirming! Could you share your PHYID1/PHYID2 register and
firmware version (FWV, 0x1E) contents?

In our case, any changes in MIICTRL are lost after a soft reset.

> I varied these values during operation in the uboot and was able to 
> test
> the limits very nicely.

So I guess, the value you write into MIICTRL are retained on a soft 
reset.
I.e.

mii write <phyad> 0x17 0xffff
mii write <phyad> 0x00 0x8000
mii read <phyad> 0x17

will still return 0xffff?

> 
> I wouldn't have introduced this feature if it hasn't got any impact.

Sure, I'm just trying to figure out the differences ;)

Thanks,
Michael
