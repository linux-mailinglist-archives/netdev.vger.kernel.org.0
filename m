Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 736434E32E3
	for <lists+netdev@lfdr.de>; Mon, 21 Mar 2022 23:48:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229729AbiCUWr4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Mar 2022 18:47:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229835AbiCUWrf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Mar 2022 18:47:35 -0400
Received: from ssl.serverraum.org (ssl.serverraum.org [IPv6:2a01:4f8:151:8464::1:2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E67843A35D7;
        Mon, 21 Mar 2022 15:27:35 -0700 (PDT)
Received: from ssl.serverraum.org (web.serverraum.org [172.16.0.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ssl.serverraum.org (Postfix) with ESMTPSA id 81CD722175;
        Mon, 21 Mar 2022 22:41:56 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2016061301;
        t=1647898916;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=H8b7+3L8jyoijK3U5LHdUPt3et03RXlG9z84o4vPklU=;
        b=o/s/oQAP6fhf078SLdCjf35BeBa/MVgWK2EQ5ACRLZmmB8sjXAdT3mItde5d4yhj+YoGJW
        3SLTBJsX0ffwSsf8G6o0IqCEkV2zYwBf0JTd4YWhUQpjzGtOJcFLRbz7kGeP13ltxceJGS
        NnJZuKXpaSB3iQSAX/Coq1cQjYYnYPE=
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Mon, 21 Mar 2022 22:41:56 +0100
From:   Michael Walle <michael@walle.cc>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: Clause 45 and Clause 22 PHYs on one MDIO bus
In-Reply-To: <YjjhxbZgKHykJ+35@lunn.ch>
References: <240354b0a54b37e8b5764773711b8aa3@walle.cc>
 <cdb3d3f6ad35d4e26fd8abb23b2e96a3@walle.cc> <YjjhxbZgKHykJ+35@lunn.ch>
User-Agent: Roundcube Webmail/1.4.13
Message-ID: <4d728d267e45fe591c933c86cdfff333@walle.cc>
X-Sender: michael@walle.cc
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Am 2022-03-21 21:36, schrieb Andrew Lunn:
>> Actually, it looks like mdiobus_c45_read() is really c45 only and only
>> used for PHYs which just support c45 and not c45-over-c22 (?). I was
>> mistaken by the heavy use of the function in phy_device.c. All the
>> methods in phy-c45.c use phy_*_mmd() functions. Thus it might only be
>> the mxl-gpy doing something fishy in its probe function.
> 
> Yes, there is something odd here. You should search back on the
> mailing list.
> 
> If i remember correctly, it is something like it responds to both c22
> and c45. If it is found via c22, phylib does not set phydev->is_c45,
> and everything ends up going indirect. So the probe additionally tries
> to find it via c45? Or something like that.

Yeah, found it: https://lore.kernel.org/netdev/YLaG9cdn6ewdffjV@lunn.ch/

But that means that if the controller is not c45 capable, it will always
fail to probe, no?

I've added the "if (regnum & MII_ADDR_C45) return -EOPNOTSUPP" to the
mdio driver and the gpy phy will then fail to probe - as expected.

Should it check for -EOPNOTSUPP and just ignore that error and continue
probing? Or make it a no-op if probe_capabilities say it has no c45
access so it would take advantage of a quirk flag (derived from dt)?

>> Nevertheless, I'd still need the opt-out of any c45 access. Otherwise,
>> if someone will ever implement c45 support for the mdio-mscc-mdio
>> driver, I'll run in the erratic behavior.
> 
> Yah, i need to think about that. Are you purely in the DT world, or is
> ACPI also an option?

Just DT world.

> Maybe extend of_mdiobus_register() to look for a DT property to limit
> what values probe_capabilities can take?

I'll have to give it a try. First I was thinking that we wouldn't need
it because a broken PHY driver could just set a quirk 
"broken_c45_access"
or similar. But that would mean it has to be probed before any c45 PHY.
Dunno if that will be true for the future. And it sounds rather fragile.
So yes, a dt property might be a better option.

-michael
