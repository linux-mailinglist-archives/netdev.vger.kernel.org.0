Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A0B266601EC
	for <lists+netdev@lfdr.de>; Fri,  6 Jan 2023 15:18:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234495AbjAFOSR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Jan 2023 09:18:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230511AbjAFOSM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Jan 2023 09:18:12 -0500
Received: from mail.3ffe.de (0001.3ffe.de [159.69.201.130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5856178EB4;
        Fri,  6 Jan 2023 06:18:10 -0800 (PST)
Received: from 3ffe.de (0001.3ffe.de [IPv6:2a01:4f8:c0c:9d57::1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.3ffe.de (Postfix) with ESMTPSA id A7C7A1243;
        Fri,  6 Jan 2023 15:18:08 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2022082101;
        t=1673014688;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=SCqKuwNoR7/QACRBOUGFoUBRNWdvKQ7cYeO0SJgXqyQ=;
        b=zgDf6/uwWyLTNCGGENU5abFukGQOtcDgjiDhT71is6KUnpKeeTKW/3taNGzTy/WI1xv8Jk
        5MEYo0ygibp6nd8Ycsr7tJhfUAKSPgGO6xWxeOBgP2/SXpf4regE/7EpW7xmtm+gOiLQqY
        PjiptDdsXdN34SeKIBx+gwYppajwnavfDUj2H3CUkTl4VArMQyRXguNERdFTIcyeIj4ldF
        4QVwG9RF+mF0NCy7GDXE1UkdtoTG3WvOPpXpxvL9y1HXLgOePlEgB8Rj47Emt1Hh0ppmwn
        i53/MDN+QC327qaOGtRzjEaohOdtTsQ3kC9vdzXkZNcxbdCtf7ofW010iup5Ew==
MIME-Version: 1.0
Date:   Fri, 06 Jan 2023 15:18:08 +0100
From:   Michael Walle <michael@walle.cc>
To:     Steen Hegelund <steen.hegelund@microchip.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, UNGLinuxDriver@microchip.com,
        Randy Dunlap <rdunlap@infradead.org>,
        Casper Andersson <casper.casan@gmail.com>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Wan Jiabing <wanjiabing@vivo.com>,
        Nathan Huckleberry <nhuck@google.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Daniel Machon <daniel.machon@microchip.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Dan Carpenter <error27@gmail.com>
Subject: Re: [PATCH net-next v2 0/8] Add support for two classes of VCAP rules
In-Reply-To: <dc4c4fbf0cb1892dbe45c0ee80d5fafbd5fc36ff.camel@microchip.com>
References: <20230106085317.1720282-1-steen.hegelund@microchip.com>
 <35a9ff9fa0980e1e8542d338c6bf1e0c@walle.cc>
 <b6b2db49dfdd2c3809c8b2c99077ca5110d84d97.camel@microchip.com>
 <40eea59265ce70a80ca61164608f4739@walle.cc>
 <dc4c4fbf0cb1892dbe45c0ee80d5fafbd5fc36ff.camel@microchip.com>
User-Agent: Roundcube Webmail/1.4.13
Message-ID: <01a84b0942f7af86d907ed39f5048b72@walle.cc>
X-Sender: michael@walle.cc
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Steen,

>> > > Wouldn't it make more sense, to fix the regression via net (and
>> > > a Fixes: tag) and then make that stuff work without tc? Maybe
>> > > the fix is just reverting the commits.
>> >
>> > I have discussed this again with Horatiu and I have the following
>> > suggestion of
>> > how to proceed:
>> >
>> > 1) Create a small LAN966x specific patch for net (see below for the two
>> > possible
>> >    variants).
>> >
>> > 2) Continue with a net-next V3 without any 'Fixes' tags on top of the
>> > patch in
>> >    (1) when it becomes available in net-next.
>> 
>> Sounds good.
>> 
>> [coming back to this after writing the response below, so see there
>> for more context]
>> When do the patches from net become available in net-next? Only after 
>> a
>> merge window? If so, depending on the solution for (1) you'd have two
>> "in-between" kernel versions (v6.2 and v6.3).
> 
> According to our own experience the changes in net are usually merged 
> into net-
> next the following Thursday: so not too much delay, before we can 
> continue.

TIL :)

>> > The LAN966x patch for net (with a Fixes tag) could contain either:
>> >
>> > a) No check on enabled lookup
>> >
>> >    Removal of the check for enabled lookups:
>> >
>> >    -  if (!ANA_VCAP_S2_CFG_ENA_GET(val))
>> >    -          return -ENOENT;
>> >
>> >    This will remove the error that you have seen, but  will still
>> > require a
>> >    matchall rule to enable the PTP rules.  This is compatible with the
>> > TC
>> >    framework.
>> >
>> > b) Always enable lookups
>> >
>> >    Enable the lookups at startup.
>> >    Remove the lookup enable check as above.
>> >
>> >    This will make the PTP rules (and any other rules) work even without
>> > the
>> >    matchall rule to enable them.  It its not ideal, but solves the
>> > problem that
>> >    you have been experiencing without the 'TC magic'
>> >
>> >    The V3 in net-next will provide the full solution.
>> >
>> > I expect that you might prefer the b) version.
>> 
>> I *assume* linuxptp would have worked in my case (no bridge interface)
>> before Horatiu patches. As mentioned before, I haven't really tested 
>> it.
>> Does that mean with a) the error is gone and linuxptp is working as
>> before? If so, I'm also fine with a).
> 
> Yes this is the result: So I also suggest to go for solution a).
> 
> This will still allow LinuxPTP to work (without the error that you have 
> seen),
> but the bridged interface PTP support must be enabled with a TC 
> matchall rule.
> 
>> 
>> Honestly, now that there is a good solution in future kernels, I
>> don't care toooo much about that one particular kernel. Other
>> users might disagree though ;)
>> 
>> I just want to point out that right now you have some kind of
>> in-between kernel with 6.2:
>> 
>>   <=6.1 linuxptp working (but not on bridged ports)
>>   6.2   linuxptp working only with tc magic
>>   6.3   linuxptp working
> 
> So with the LAN966x patch the second line would change to:
> 
> 6.2   linuxptp working. PTP on bridged interfaces: needs TC matchall 
> rule
> 
>> 
>> Therefore, I've raised the question if it's also viable to just
>> revert the former changes for 6.2. The you'd have a clean
>> transition.
>> 
>> -michael
> 
> TLDR Summary:
> 
> 1) LAN966x patch for net to ensure PTP is working without errors
> 2) A V3 net-next VCAP series with the improvements for 
> enabled/disable/permanent
> rules (both LAN966x and Sparx5)
> 
> I will move forward with this.

Sounds perfect, thanks!

-michael
