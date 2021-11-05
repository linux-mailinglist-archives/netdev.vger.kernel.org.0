Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 53B984463D6
	for <lists+netdev@lfdr.de>; Fri,  5 Nov 2021 14:08:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232143AbhKENK4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Nov 2021 09:10:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229529AbhKENKz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Nov 2021 09:10:55 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6ACB4C061714;
        Fri,  5 Nov 2021 06:08:16 -0700 (PDT)
Message-ID: <c7137797-cd62-7006-572b-003e8bff89e5@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1636117694;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=UeC3aybvyY+u3viJ2ldalln4q7M15Xgy6n9ybUL7U0A=;
        b=rVZmMZmc8IOKl400/JOAMPcgLx31JlDGn2WSNH0FkPqnh0lAfnfEVGofYsz4S1FVUvKvlx
        Dw6AEXVktrHxNDdmxuHRccLqaina/ZijUhdZ17QeQoayuCUJVp2jT9QDLGSyxiwbxSnBVj
        EcZ6nT4ws7bW/mFMlXrzl8k9PA6BTCXl3EBku+jQv2v5DHEZj/y2jWnTcZpa9mQpT78Z9O
        27V3DDLB+3/+1k6eURbgPR8oli4b4R1jwbQbtWftM9QVQymqXIwxC9xfOieWBKKaENdyvQ
        54UazyuRvylBUr8IxX4qP7bjMJY3SpPRxsatTV6V6rgdeHd1lsyV6t8HUyv6VA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1636117694;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=UeC3aybvyY+u3viJ2ldalln4q7M15Xgy6n9ybUL7U0A=;
        b=0KX+nvgzoB2m92FYAdiIHoCq4Bl2YiO0Xr4nZ3Mn0XyHAustqtZOdmbDNrjWqGqo/RaHO/
        z+BQkvlRRsovEsCg==
Date:   Fri, 5 Nov 2021 14:08:13 +0100
MIME-Version: 1.0
Subject: Re: [PATCH 0/7] Add PTP support for BCM53128 switch
Content-Language: de-DE
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        John Stultz <john.stultz@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Stephen Boyd <sboyd@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
References: <20211104133204.19757-1-martin.kaistra@linutronix.de>
 <20211104102933.3c6f5b12@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Martin Kaistra <martin.kaistra@linutronix.de>
In-Reply-To: <20211104102933.3c6f5b12@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Am 04.11.21 um 18:29 schrieb Jakub Kicinski:
> On Thu,  4 Nov 2021 14:31:54 +0100 Martin Kaistra wrote:
>> this series adds PTP support to the b53 DSA driver for the BCM53128
>> switch using the BroadSync HD feature.
>>
>> As there seems to be only one filter (either by Ethertype or DA) for
>> timestamping incoming packets, only L2 is supported.
>>
>> To be able to use the timecounter infrastructure with a counter that
>> wraps around at a non-power of two point, patch 2 adds support for such
>> a custom point. Alternatively I could fix up the delta every time a
>> wrap-around occurs in the driver itself, but this way it can also be
>> useful for other hardware.
> 
> Please make sure that the code builds as a module and that each patch
> compiles cleanly with W=1 C=1 flags set - build the entire tree first
> with W=1 C=1 cause there will be extra warning noise, then apply your
> patches one by one and recompile, there should be no warnings since b53
> itself builds cleanly.
> 

Sorry, I will fix that.

Thanks,
Martin
