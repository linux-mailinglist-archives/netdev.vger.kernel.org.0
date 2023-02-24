Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 094B06A16C1
	for <lists+netdev@lfdr.de>; Fri, 24 Feb 2023 07:50:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229634AbjBXGue (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Feb 2023 01:50:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229562AbjBXGud (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Feb 2023 01:50:33 -0500
X-Greylist: delayed 1476 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 23 Feb 2023 22:50:31 PST
Received: from mxout70.expurgate.net (mxout70.expurgate.net [194.37.255.70])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C183B28209
        for <netdev@vger.kernel.org>; Thu, 23 Feb 2023 22:50:31 -0800 (PST)
Received: from [127.0.0.1] (helo=localhost)
        by relay.expurgate.net with smtp (Exim 4.92)
        (envelope-from <prvs=9433889ceb=ms@dev.tdt.de>)
        id 1pVRWj-0003CB-S2; Fri, 24 Feb 2023 07:25:53 +0100
Received: from [195.243.126.94] (helo=securemail.tdt.de)
        by relay.expurgate.net with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ms@dev.tdt.de>)
        id 1pVRWj-000OKh-A8; Fri, 24 Feb 2023 07:25:53 +0100
Received: from securemail.tdt.de (localhost [127.0.0.1])
        by securemail.tdt.de (Postfix) with ESMTP id E2A9C240049;
        Fri, 24 Feb 2023 07:25:52 +0100 (CET)
Received: from mail.dev.tdt.de (unknown [10.2.4.42])
        by securemail.tdt.de (Postfix) with ESMTP id 93EFC240040;
        Fri, 24 Feb 2023 07:25:52 +0100 (CET)
Received: from mail.dev.tdt.de (localhost [IPv6:::1])
        by mail.dev.tdt.de (Postfix) with ESMTP id 0E02420430;
        Fri, 24 Feb 2023 07:25:52 +0100 (CET)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Fri, 24 Feb 2023 07:25:51 +0100
From:   Martin Schiller <ms@dev.tdt.de>
To:     Michael Walle <michael@walle.cc>
Cc:     tharvey@gateworks.com, andrew@lunn.ch, davem@davemloft.net,
        f.fainelli@gmail.com, hauke@hauke-m.de, hkallweit1@gmail.com,
        kuba@kernel.org, linux-kernel@vger.kernel.org,
        linux@armlinux.org.uk, martin.blumenstingl@googlemail.com,
        netdev@vger.kernel.org
Subject: Re: [PATCH net-next v6] net: phy: intel-xway: Add RGMII internal
 delay configuration
Organization: TDT AG
In-Reply-To: <20230222160425.4040683-1-michael@walle.cc>
References: <CAJ+vNU3_8Gk8Mj_uCudMz0=MdN3B9T9pUOvYtP7H_B0fnTfZmg@mail.gmail.com>
 <20230222160425.4040683-1-michael@walle.cc>
Message-ID: <8aa26f417c99761cdf1b6b7082fdec14@dev.tdt.de>
X-Sender: ms@dev.tdt.de
User-Agent: Roundcube Webmail/1.3.17
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        SPF_HELO_PASS,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
X-purgate: clean
X-purgate-type: clean
X-purgate-ID: 151534::1677219953-6BFEA99C-261FF377/0/0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2023-02-22 17:04, Michael Walle wrote:
> Hi Tim, Hi Martin,
> 
>> I've got some boards with the GPY111 phy on them and I'm finding that
>> modifying XWAY_MDIO_MIICTRL to change the skew has no effect unless I
>> do a soft reset (BCMR_RESET) first. I don't see anything in the
>> datasheet which specifies this to be the case so I'm interested it
>> what you have found. Are you sure adjusting the skews like this
>> without a soft (or hard pin based) reset actually works?
> 
> I do have the same PHY and I'm puzzled with the delay settings. Do
> you have an EEPROM attached to the PHY? According to my datasheet,
> that seems to make a difference. Apparently, only if there is an
> EEPROM, you can change the value (the value is then also written to
> the EEPROM according the datasheet).
> If you don't have one, the values will get overwritten by the
> external strappings on a soft reset. Therefore, it seems they cannot
> be set. (FWIW there is also a sticky bit, but that doesn't seem to
> help in this case).
> 
> -michael

Yes, you are right. The datasheet says: "In no-EEPROM mode, writing to
this register has no impact on operation of the device".

But changing this settings without an EEPROM indeed has an impact.

We don't use an EEPROM and without tuning this values some boards are
unable to communicate on the ethernet port(s).

I varied these values during operation in the uboot and was able to test
the limits very nicely.

I wouldn't have introduced this feature if it hasn't got any impact.

Regards,
Martin
