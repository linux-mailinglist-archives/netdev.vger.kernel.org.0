Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 71AED44AC56
	for <lists+netdev@lfdr.de>; Tue,  9 Nov 2021 12:13:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243696AbhKILPt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Nov 2021 06:15:49 -0500
Received: from Galois.linutronix.de ([193.142.43.55]:35482 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243520AbhKILPt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Nov 2021 06:15:49 -0500
Message-ID: <eb5836a7-fe08-7764-596b-f3941128f89c@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1636456382;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=zVR7Mogf6s4EwqQxKfIE82QSXL5TJMC/vQqFb693/O4=;
        b=qGuoJ+5pmCdeQh02LYXsR7oCVd8SAKCypNkp5nhK8jdRAHWbADV8Xm1afg7o9Z7p+o9Ay/
        NkGFrAOlN+4pP7rGC6G3iVhJ/UAEUJTGQP+VxpQ2WLvE+GxbJSOfk54Mq1piSqOAUb/GTu
        CavsQDsf/0kRRGykIPZC51lrEoXStF5ah54UhfaPgwSDfOzgg55BW1z45IqzbNGfugP56L
        mAiHIbfeoDJR31h8posD8vfcaHG4a1YanntVKW0Mo9CdG79OWFgxBFCw2WJwHSibLv8tX3
        S6R+URdXKPsyR9bsR63U3gqwnmYvMrIkrJeMHxFk6FU2YqhBVycqtejp1HxBAw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1636456382;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=zVR7Mogf6s4EwqQxKfIE82QSXL5TJMC/vQqFb693/O4=;
        b=voG/2TOPVzcQCUcZkDtkWSgD8DLM/QcpUs5o5WShQizun9r2Tp7VpUlamDkscgZZq2hEY4
        mERSfMT/RENvm5Aw==
Date:   Tue, 9 Nov 2021 12:13:01 +0100
MIME-Version: 1.0
Subject: Re: [PATCH v2 0/7] Add PTP support for BCM53128 switch
Content-Language: de-DE
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Richard Cochran <richardcochran@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        John Stultz <john.stultz@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Stephen Boyd <sboyd@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
References: <20211109095013.27829-1-martin.kaistra@linutronix.de>
 <20211109103936.2wjvvwhihhfqjfot@skbuf>
From:   Martin Kaistra <martin.kaistra@linutronix.de>
In-Reply-To: <20211109103936.2wjvvwhihhfqjfot@skbuf>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



Am 09.11.21 um 11:39 schrieb Vladimir Oltean:
> On Tue, Nov 09, 2021 at 10:50:02AM +0100, Martin Kaistra wrote:
>> Ideally, for the B53=m case, I would have liked to include the PTP
>> support in the b53_module itself, however I couldn't find a way to do
>> that without renaming either the common source file or the module, which
>> I didn't want to do.
>>
>> Instead, b53_ptp will be allowed as a loadable module, but only if
>> b53_common is also a module, otherwise it will be built-in.
> 
> Does this not work?
> 
> obj-$(CONFIG_B53)		+= b53_common.o
> 
> ifdef CONFIG_B53_PTP
> b53_common-objs += b53_ptp.o
> endif
> 
> (haven't tried though)
> 

I get:

arm-linux-gnueabihf-ld  -EL    -r -o drivers/net/dsa/b53/b53_common.o 
drivers/net/dsa/b53/b53_ptp.o



and



ERROR: modpost: "b53_switch_register" [drivers/net/dsa/b53/b53_mdio.ko] 
undefined!

ERROR: modpost: "b53_switch_alloc" [drivers/net/dsa/b53/b53_mdio.ko] 
undefined!

ERROR: modpost: "b53_switch_register" [drivers/net/dsa/b53/b53_spi.ko] 
undefined!

ERROR: modpost: "b53_switch_alloc" [drivers/net/dsa/b53/b53_spi.ko] 
undefined!

It seems to me, that b53_common.c does not get included at all.
