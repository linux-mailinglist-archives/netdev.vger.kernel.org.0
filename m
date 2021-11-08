Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E07ED447D28
	for <lists+netdev@lfdr.de>; Mon,  8 Nov 2021 10:57:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238515AbhKHKAg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Nov 2021 05:00:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238510AbhKHKAf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Nov 2021 05:00:35 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA0F9C061570;
        Mon,  8 Nov 2021 01:57:51 -0800 (PST)
Message-ID: <b884b0c1-fc60-a7ac-a788-894e206b34a9@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1636365468;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=YoadjRf4FiKN1veUX9KomPwUfwXQtLyR4qj+Cau8Djk=;
        b=nrb11SEi8Se/oItTd/rpSkxJ+62DZgegCyr6Ja/iI8ah8h4J4QNYXvoy0VAD40x+l4Mn9M
        tS/1V59qrnKWYyw22jPcKM4WDuk07h56qgUhbn3lgQzvSmO9kXDpJ2q78Fo3ZUSdYOOXny
        a6GwQgkYAmul5bDEH0BNLV+3Ivft6ic9jxfUDvzvkS0Z6dvdmFSo5KldVRO1hRLLm2EfzH
        3XwphGFmZgKD/nDyN4kB5A5oQnu4nqo0B+18gI5pGTsThvkrDZoUtp2rQnv/jg4xcjfWj5
        RGySgKO6uZVvzxeGexfgvo7TWCbLxw8L7FWfD+xfQqoGu//KxSDbxYetAHbjFw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1636365468;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=YoadjRf4FiKN1veUX9KomPwUfwXQtLyR4qj+Cau8Djk=;
        b=wfmDv6HDkEMfNOl8q/qCVj3p0Pfrnm6KcIzpeY55EaA7VXo5I8a4fqyva211L+a4RLk3T+
        Dv9Ves3coE+XwOAA==
Date:   Mon, 8 Nov 2021 10:57:48 +0100
MIME-Version: 1.0
Subject: Re: [PATCH 6/7] net: dsa: b53: Add logic for TX timestamping
Content-Language: de-DE
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     Richard Cochran <richardcochran@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        John Stultz <john.stultz@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Stephen Boyd <sboyd@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>
References: <20211104133204.19757-1-martin.kaistra@linutronix.de>
 <20211104133204.19757-7-martin.kaistra@linutronix.de>
 <4f4e28f9-8d1e-f2e9-aa0c-37b2c4cd8e8a@gmail.com>
From:   Martin Kaistra <martin.kaistra@linutronix.de>
In-Reply-To: <4f4e28f9-8d1e-f2e9-aa0c-37b2c4cd8e8a@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Am 06.11.21 um 03:50 schrieb Florian Fainelli:
> 
> 
> On 11/4/2021 6:32 AM, Martin Kaistra wrote:
>> In order to get the switch to generate a timestamp for a transmitted
>> packet, we need to set the TS bit in the BRCM tag. The switch will then
>> create a status frame, which gets send back to the cpu.
>> In b53_port_txtstamp() we put the skb into a waiting position.
>>
>> When a status frame is received, we extract the timestamp and put the 
>> time
>> according to our timecounter into the waiting skb. When
>> TX_TSTAMP_TIMEOUT is reached and we have no means to correctly get back
>> a full timestamp, we cancel the process.
>>
>> As the status frame doesn't contain a reference to the original packet,
>> only one packet with timestamp request can be sent at a time.
>>
>> Signed-off-by: Martin Kaistra <martin.kaistra@linutronix.de>
>> ---
> 
> [snip]
> 
>> +static long b53_hwtstamp_work(struct ptp_clock_info *ptp)
>> +{
>> +    struct b53_device *dev =
>> +        container_of(ptp, struct b53_device, ptp_clock_info);
>> +    struct dsa_switch *ds = dev->ds;
>> +    int i;
>> +
>> +    for (i = 0; i < ds->num_ports; i++) {
>> +        struct b53_port_hwtstamp *ps;
>> +
>> +        if (!dsa_is_user_port(ds, i))
>> +            continue;
> 
> Can you also check on !dsa_port_is_unused()?
After the currently implemented check, dp->type should be 
DSA_PORT_TYPE_USER, so it can't be DSA_PORT_TYPE_UNUSED, right?


Thanks,
Martin
