Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A75264ED598
	for <lists+netdev@lfdr.de>; Thu, 31 Mar 2022 10:28:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232779AbiCaI3z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 31 Mar 2022 04:29:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232797AbiCaI3y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 31 Mar 2022 04:29:54 -0400
Received: from ssl.serverraum.org (ssl.serverraum.org [176.9.125.105])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B5DA1C9B6A;
        Thu, 31 Mar 2022 01:28:07 -0700 (PDT)
Received: from ssl.serverraum.org (web.serverraum.org [172.16.0.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ssl.serverraum.org (Postfix) with ESMTPSA id DC76222246;
        Thu, 31 Mar 2022 10:28:04 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2016061301;
        t=1648715285;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=xLBmDR105PDmmrWw4p/m3U41pcGdvFhEUw0TeW5bDNE=;
        b=W1xRlWIqee+MF+MuWb7M1g0mk/kRz4fGc0y59p8rQAEjNFvMXG24hkNHs9nd7/thGGp02q
        e7RPyvg19Ua1iSeEUneD7nDWwOvFOH4a3pDe5CTnCRxGiUkmvdQdlzkKoJGvomw2HrnpNY
        mdFwr11MrtNYI0MXUTJ8xXn0t8DOAxw=
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Thu, 31 Mar 2022 10:28:04 +0200
From:   Michael Walle <michael@walle.cc>
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "David S . Miller" <davem@davemloft.net>,
        Xu Liang <lxu@maxlinear.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC net-next 2/5] net: phy: support indirect c45 access in
 get_phy_c45_ids()
In-Reply-To: <YkSC7CJ4OEFH69yU@shell.armlinux.org.uk>
References: <20220323183419.2278676-1-michael@walle.cc>
 <20220323183419.2278676-3-michael@walle.cc> <Yjt3hHWt0mW6er8/@lunn.ch>
 <43227d27d938fad8a2441363d175106e@walle.cc>
 <YkSC7CJ4OEFH69yU@shell.armlinux.org.uk>
User-Agent: Roundcube Webmail/1.4.13
Message-ID: <ed65d0a2e49159a85fc47092d0df6bb6@walle.cc>
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

Am 2022-03-30 18:18, schrieb Russell King (Oracle):
> On Wed, Mar 23, 2022 at 11:14:11PM +0100, Michael Walle wrote:
>> I actually had that. But mmd_phy_indirect() doesn't check
>> the return code and neither does the __phy_write_mmd() it
>> actually deliberatly sets "ret = 0". So I wasn't sure. If you
>> are fine with a changed code flow in the error case, then sure.
>> I.e. mmd_phy_indirect() always (try to) do three accesses; with
>> error checks it might end after the first. If you are fine
>> with the error checks, should __phy_write_mmd() also check the
>> last mdiobus_write()?
> 
> The reason for that goes back to
> commit a59a4d1921664da63d801ba477950114c71c88c9
>     phy: add the EEE support and the way to access to the MMD 
> registers.
> 
> and to maintain compatibility with that; if we start checking for
> errors now, we might trigger a kernel regression sadly.

I see that this is the commit which introduced the mmd_phy_indirect()
function, but I don't see why there is no return code checking.
Unlike now, there is a check for the last read (the one who
reads MII_MMD_DATA). That read which might return garbage if any
write has failed before - or if the bus is completely dead,
return an error. Current code will just return 0.

In any case, I don't have a strong opinion here. I just don't
see how that function could be reused while adding error checks
and without making it ugly, so I've just duplicated it.

Maybe something like this:

static int __phy_mmd_indirect_common(struct mii_bus *bus, int prtad,
                                      int devad, int addr,
                                      bool check_rc)
{
         int ret;

         /* Write the desired MMD Devad */
         ret = __mdiobus_write(bus, phy_addr, MII_MMD_CTRL, devad);
         if (check_rc && ret)
                 return ret;

         /* Write the desired MMD register address */
         ret = __mdiobus_write(bus, phy_addr, MII_MMD_DATA, regnum);
         if (check_rc && ret)
                 return ret;

         /* Select the Function : DATA with no post increment */
         ret = __mdiobus_write(bus, phy_addr, MII_MMD_CTRL,
                               devad | MII_MMD_CTRL_NOINCR);
         if (check_rc && ret)
                 return ret;

         return 0;
}

int __phy_mmd_indirect(struct mii_bus *bus, int prtad,
                        int devad, int addr)
{
         return __phy_mmd_indirect_common(bus, prtad, devad,
                                          addr, true);
}

/* some function doc about deliberatly no error checking.. */
void __phy_mmd_indirect_legacy(struct mii_bus *bus, int prtad,
                                int devad, int addr)
{
         __phy_mmd_indirect_common(bus, prtad, devad,
                                   addr, false);
}

should the last two functions be static inline?

-michael
