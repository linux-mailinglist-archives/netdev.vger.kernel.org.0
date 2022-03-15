Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 150064D9630
	for <lists+netdev@lfdr.de>; Tue, 15 Mar 2022 09:30:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343504AbiCOIb0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Mar 2022 04:31:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345904AbiCOIbZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Mar 2022 04:31:25 -0400
Received: from ssl.serverraum.org (ssl.serverraum.org [IPv6:2a01:4f8:151:8464::1:2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C5E14BFF3;
        Tue, 15 Mar 2022 01:30:12 -0700 (PDT)
Received: from ssl.serverraum.org (web.serverraum.org [172.16.0.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ssl.serverraum.org (Postfix) with ESMTPSA id C23A42223B;
        Tue, 15 Mar 2022 09:30:07 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2016061301;
        t=1647333010;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=J2khPEDGMsyeyix64KvE8xhNW4l9QN0rDqfNKW671YQ=;
        b=VUpNFjQB+Spj/0Uh6oaBdG6DEY+tBhortJD7DwW4E7eIqbCs3UzIST7vWvu5IJsah81W7v
        H/pDYbUixfKw0sryoUcvxi5y3oysZNvkEo99HbPXKYllvp/QgwdI2OSoo4llYSbxTw2WZy
        p05+L1s639Gx6KOnG/xmKzvICVuP3C4=
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Tue, 15 Mar 2022 09:30:06 +0100
From:   Michael Walle <michael@walle.cc>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S . Miller" <davem@davemloft.net>
Subject: Re: [PATCH net-next] net: sfp: add 2500base-X quirk for Lantech SFP
 module
In-Reply-To: <20220314220746.561b1da8@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <20220312205014.4154907-1-michael@walle.cc>
 <20220314220746.561b1da8@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
User-Agent: Roundcube Webmail/1.4.13
Message-ID: <148dcec837bb06022866556f02950b81@walle.cc>
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

Am 2022-03-15 06:07, schrieb Jakub Kicinski:
> On Sat, 12 Mar 2022 21:50:14 +0100 Michael Walle wrote:
>> The Lantech 8330-262D-E module is 2500base-X capable, but it reports 
>> the
>> nominal bitrate as 2500MBd instead of 3125MBd. Add a quirk for the
>> module.
>> 
>> The following in an EEPROM dump of such a SFP with the serial number
>> redacted:
>> 
>> 00: 03 04 07 00 00 00 01 20 40 0c 05 01 19 00 00 00    ???...? 
>> @????...
>> 10: 1e 0f 00 00 4c 61 6e 74 65 63 68 20 20 20 20 20    ??..Lantech
>> 20: 20 20 20 20 00 00 00 00 38 33 33 30 2d 32 36 32        
>> ....8330-262
>> 30: 44 2d 45 20 20 20 20 20 56 31 2e 30 03 52 00 cb    D-E     
>> V1.0?R.?
>> 40: 00 1a 00 00 46 43 XX XX XX XX XX XX XX XX XX XX    
>> .?..FCXXXXXXXXXX
>> 50: 20 20 20 20 32 32 30 32 31 34 20 20 68 b0 01 98        220214  
>> h???
>> 60: 45 58 54 52 45 4d 45 4c 59 20 43 4f 4d 50 41 54    EXTREMELY 
>> COMPAT
>> 70: 49 42 4c 45 20 20 20 20 20 20 20 20 20 20 20 20    IBLE
> 
> Any idea what the "Extremely Compatible" is referring to? :-D

Haha, I smirked on that, too. Anything between 60 and 7f
is vendor specific. So.. good for a laugh?

>> Signed-off-by: Michael Walle <michael@walle.cc>
> 
> A quirk like this seems safe to apply to net and 5.17, still.
> Would you prefer that or net-next as marked?

Personally, I don't have any preference because the board
is just in the process of being upstreamed. Just pick one ;)
I'd say net-next because 5.17 development is almost at the
end.

-michael
