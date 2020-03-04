Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D361A1790C4
	for <lists+netdev@lfdr.de>; Wed,  4 Mar 2020 14:02:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729307AbgCDNCy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Mar 2020 08:02:54 -0500
Received: from ssl.serverraum.org ([176.9.125.105]:37011 "EHLO
        ssl.serverraum.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729175AbgCDNCy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Mar 2020 08:02:54 -0500
Received: from ssl.serverraum.org (web.serverraum.org [172.16.0.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ssl.serverraum.org (Postfix) with ESMTPSA id 61E3D23059;
        Wed,  4 Mar 2020 14:02:47 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2016061301;
        t=1583326971;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=aFxZcCm568v6by3tfUeSQbeoR0eQO0FZk1P28xwCl4c=;
        b=L/rOEPBMW2w1DomjbFuB2bS924aOvyCcfd3qxrMqw65k+40SP+uo8W7QsMXZax7ClPjCN1
        Kgv5AjbMKRfisjn9N6nLHFVZ+bu2rWMt0F0pqF01Jy7LjJupYJkc6jEnOguGa0uqjdJWZq
        0MAMzrQN/kU8vLw8sCSE7QlaAI55VzI=
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Wed, 04 Mar 2020 14:02:47 +0100
From:   Michael Walle <michael@walle.cc>
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Russell King - ARM Linux <linux@armlinux.org.uk>,
        David Miller <davem@davemloft.net>, netdev@vger.kernel.org
Subject: Re: [PATCH net] net: phy: avoid clearing PHY interrupts twice in irq
 handler
In-Reply-To: <c2928823-da08-0321-6917-1481aab79e09@gmail.com>
References: <2f468a46-e966-761c-8466-51601d8f11a3@gmail.com>
 <a0b161ebd332c9ea26bb62ccf73d1862@walle.cc>
 <a33c33d6-621a-4139-0e81-eb0d0fd0e095@gmail.com>
 <c2928823-da08-0321-6917-1481aab79e09@gmail.com>
Message-ID: <fbf0a7739f5c8442c1d2b0aa9aba086d@walle.cc>
X-Sender: michael@walle.cc
User-Agent: Roundcube Webmail/1.3.10
X-Spamd-Bar: +
X-Spam-Level: *
X-Rspamd-Server: web
X-Spam-Status: No, score=1.40
X-Spam-Score: 1.40
X-Rspamd-Queue-Id: 61E3D23059
X-Spamd-Result: default: False [1.40 / 15.00];
         FROM_HAS_DN(0.00)[];
         TO_DN_SOME(0.00)[];
         FREEMAIL_ENVRCPT(0.00)[gmail.com];
         TO_MATCH_ENVRCPT_ALL(0.00)[];
         TAGGED_RCPT(0.00)[];
         MIME_GOOD(-0.10)[text/plain];
         RCPT_COUNT_FIVE(0.00)[6];
         DKIM_SIGNED(0.00)[];
         NEURAL_HAM(-0.00)[-0.288];
         FREEMAIL_TO(0.00)[gmail.com];
         RCVD_COUNT_ZERO(0.00)[0];
         FROM_EQ_ENVFROM(0.00)[];
         MIME_TRACE(0.00)[0:+];
         FREEMAIL_CC(0.00)[lunn.ch,gmail.com,armlinux.org.uk,davemloft.net,vger.kernel.org];
         MID_RHS_MATCH_FROM(0.00)[];
         SUSPICIOUS_RECIPS(1.50)[]
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Am 2020-03-04 13:13, schrieb Heiner Kallweit:
> On 02.03.2020 00:20, Heiner Kallweit wrote:
>> On 01.03.2020 23:52, Michael Walle wrote:
>>> Am 2020-03-01 21:36, schrieb Heiner Kallweit:
>>>> On all PHY drivers that implement did_interrupt() reading the 
>>>> interrupt
>>>> status bits clears them. This means we may loose an interrupt that
>>>> is triggered between calling did_interrupt() and 
>>>> phy_clear_interrupt().
>>>> As part of the fix make it a requirement that did_interrupt() clears
>>>> the interrupt.
>>> 
>>> Looks good. But how would you use did_interrupt() and 
>>> handle_interrupt()
>>> together? I guess you can't. At least not if handle_interrupt() has
>>> to read the pending bits again. So you'd have to handle custom
>>> interrupts in did_interrupt(). Any idea how to solve that?
>>> 
>>> [I know, this is only about fixing the lost interrupts.]
>>> 
>> Right, this one is meant for stable to fix the issue with the 
>> potentially
>> lost interrupts. Based on it I will submit a patch for net-next that
>> tackles the issue that did_interrupt() has to read (and therefore 
>> clear)
>> irq status bits and therefore makes them unusable for 
>> handle_interrupt().
>> The basic idea is that did_interrupt() is called only if 
>> handle_interrupt()
>> isn't implemented. handle_interrupt() has to include the did_interrupt
>> functionality. It can read the irq status once and store it in a 
>> variable
>> for later use.
>> 
> In case you wait for this patch to base further own work on it:
> I'm waiting for next merge of net into net-next, because my patch will
> apply cleanly only after that. This merge should happen in the next 
> days.

Ok, thanks for the information. I have enough other things to do ;)

-michael
