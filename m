Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7D89265FF1D
	for <lists+netdev@lfdr.de>; Fri,  6 Jan 2023 11:47:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229775AbjAFKrD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Jan 2023 05:47:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229547AbjAFKrB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Jan 2023 05:47:01 -0500
Received: from mail.3ffe.de (0001.3ffe.de [159.69.201.130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B75F6C2BF;
        Fri,  6 Jan 2023 02:46:59 -0800 (PST)
Received: from 3ffe.de (0001.3ffe.de [IPv6:2a01:4f8:c0c:9d57::1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.3ffe.de (Postfix) with ESMTPSA id A1AA7125C;
        Fri,  6 Jan 2023 11:46:57 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2022082101;
        t=1673002017;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=2sAgKVw2R59p7zF72zbcRbRDTSb5XaO8aLxzjSwbQ5E=;
        b=kkMunGl6kfvzkLRQNl9fJNG4bpD3Yh9+Iw8tcAc/PJDpBVjwJqJlttqS4LB/6a9UDOzHg1
        PHxXpkM19VIzqhEFfnT8L0N9fajkdc3sG0O74CHcjJy/EWnT8ZWzGKN6niptWxs3byMIul
        y2eEjxNT35nM0Bwi3euwG40JL+p5H+79wLccWExtbIUiKkvbbCPsoabJGP/er3Qiu4Va6O
        +HR9NOaGatdCuTbjTJp2bjgM6/p6ranApKmYmQwx/o2Ow2nwsvgl5wibraJaP9OSfxIe5W
        He28n858M2gbBw8ZMyVleNeTHzsuc+S5fqa5evTqQkAqvXi4k5VKHQ4+hxK1dg==
MIME-Version: 1.0
Date:   Fri, 06 Jan 2023 11:46:57 +0100
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
In-Reply-To: <b6b2db49dfdd2c3809c8b2c99077ca5110d84d97.camel@microchip.com>
References: <20230106085317.1720282-1-steen.hegelund@microchip.com>
 <35a9ff9fa0980e1e8542d338c6bf1e0c@walle.cc>
 <b6b2db49dfdd2c3809c8b2c99077ca5110d84d97.camel@microchip.com>
User-Agent: Roundcube Webmail/1.4.13
Message-ID: <40eea59265ce70a80ca61164608f4739@walle.cc>
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

Hi,

>> Wouldn't it make more sense, to fix the regression via net (and
>> a Fixes: tag) and then make that stuff work without tc? Maybe
>> the fix is just reverting the commits.
> 
> I have discussed this again with Horatiu and I have the following 
> suggestion of
> how to proceed:
> 
> 1) Create a small LAN966x specific patch for net (see below for the two 
> possible
>    variants).
> 
> 2) Continue with a net-next V3 without any 'Fixes' tags on top of the 
> patch in
>    (1) when it becomes available in net-next.

Sounds good.

[coming back to this after writing the response below, so see there
for more context]
When do the patches from net become available in net-next? Only after a
merge window? If so, depending on the solution for (1) you'd have two
"in-between" kernel versions (v6.2 and v6.3).

> The LAN966x patch for net (with a Fixes tag) could contain either:
> 
> a) No check on enabled lookup
> 
>    Removal of the check for enabled lookups:
> 
>    -	if (!ANA_VCAP_S2_CFG_ENA_GET(val))
>    -		return -ENOENT;
> 
>    This will remove the error that you have seen, but  will still 
> require a
>    matchall rule to enable the PTP rules.  This is compatible with the 
> TC
>    framework.
> 
> b) Always enable lookups
> 
>    Enable the lookups at startup.
>    Remove the lookup enable check as above.
> 
>    This will make the PTP rules (and any other rules) work even without 
> the
>    matchall rule to enable them.  It its not ideal, but solves the 
> problem that
>    you have been experiencing without the 'TC magic'
> 
>    The V3 in net-next will provide the full solution.
> 
> I expect that you might prefer the b) version.

I *assume* linuxptp would have worked in my case (no bridge interface)
before Horatiu patches. As mentioned before, I haven't really tested it.
Does that mean with a) the error is gone and linuxptp is working as
before? If so, I'm also fine with a).

Honestly, now that there is a good solution in future kernels, I
don't care toooo much about that one particular kernel. Other
users might disagree though ;)

I just want to point out that right now you have some kind of
in-between kernel with 6.2:

  <=6.1 linuxptp working (but not on bridged ports)
  6.2   linuxptp working only with tc magic
  6.3   linuxptp working

Therefore, I've raised the question if it's also viable to just
revert the former changes for 6.2. The you'd have a clean
transition.

-michael
