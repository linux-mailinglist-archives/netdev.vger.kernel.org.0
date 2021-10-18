Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3EBC4431663
	for <lists+netdev@lfdr.de>; Mon, 18 Oct 2021 12:46:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230376AbhJRKs2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Oct 2021 06:48:28 -0400
Received: from pegase2.c-s.fr ([93.17.235.10]:57413 "EHLO pegase2.c-s.fr"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229603AbhJRKs1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 18 Oct 2021 06:48:27 -0400
Received: from localhost (mailhub3.si.c-s.fr [172.26.127.67])
        by localhost (Postfix) with ESMTP id 4HXtpH2mnzz9sSY;
        Mon, 18 Oct 2021 12:46:15 +0200 (CEST)
X-Virus-Scanned: amavisd-new at c-s.fr
Received: from pegase2.c-s.fr ([172.26.127.65])
        by localhost (pegase2.c-s.fr [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id ANnJZly2ob87; Mon, 18 Oct 2021 12:46:15 +0200 (CEST)
Received: from messagerie.si.c-s.fr (messagerie.si.c-s.fr [192.168.25.192])
        by pegase2.c-s.fr (Postfix) with ESMTP id 4HXtpH1wwVz9sSD;
        Mon, 18 Oct 2021 12:46:15 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
        by messagerie.si.c-s.fr (Postfix) with ESMTP id 29DC68B76C;
        Mon, 18 Oct 2021 12:46:15 +0200 (CEST)
X-Virus-Scanned: amavisd-new at c-s.fr
Received: from messagerie.si.c-s.fr ([127.0.0.1])
        by localhost (messagerie.si.c-s.fr [127.0.0.1]) (amavisd-new, port 10023)
        with ESMTP id qhZjXg78Wf90; Mon, 18 Oct 2021 12:46:15 +0200 (CEST)
Received: from PO20335.IDSI0.si.c-s.fr (unknown [172.25.230.103])
        by messagerie.si.c-s.fr (Postfix) with ESMTP id EA6688B763;
        Mon, 18 Oct 2021 12:46:14 +0200 (CEST)
Subject: Re: [PATCH net-next] phy: micrel: ksz8041nl: do not use power down
 mode
To:     Francesco Dolcini <francesco.dolcini@toradex.com>
Cc:     f.fainelli@gmail.com, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Stefan Agner <stefan@agner.ch>,
        Marcel Ziswiler <marcel.ziswiler@toradex.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20211018094256.70096-1-francesco.dolcini@toradex.com>
 <180289ac-4480-1e4c-d679-df4f0478ec65@csgroup.eu>
 <20211018101802.GA7669@francesco-nb.int.toradex.com>
From:   Christophe Leroy <christophe.leroy@csgroup.eu>
Message-ID: <a06104cf-d634-a25a-cf54-975689ad3e91@csgroup.eu>
Date:   Mon, 18 Oct 2021 12:46:14 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20211018101802.GA7669@francesco-nb.int.toradex.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: fr-FR
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



Le 18/10/2021 à 12:18, Francesco Dolcini a écrit :
> Hello Christophe,
> 
> On Mon, Oct 18, 2021 at 11:53:03AM +0200, Christophe Leroy wrote:
>>
>>
>> Le 18/10/2021 à 11:42, Francesco Dolcini a écrit :
>>> From: Stefan Agner <stefan@agner.ch>
>>>
>>> Some Micrel KSZ8041NL PHY chips exhibit continous RX errors after using
>>> the power down mode bit (0.11). If the PHY is taken out of power down
>>> mode in a certain temperature range, the PHY enters a weird state which
>>> leads to continously reporting RX errors. In that state, the MAC is not
>>> able to receive or send any Ethernet frames and the activity LED is
>>> constantly blinking. Since Linux is using the suspend callback when the
>>> interface is taken down, ending up in that state can easily happen
>>> during a normal startup.
>>>
>>> Micrel confirmed the issue in errata DS80000700A [*], caused by abnormal
>>> clock recovery when using power down mode. Even the latest revision (A4,
>>> Revision ID 0x1513) seems to suffer that problem, and according to the
>>> errata is not going to be fixed.
>>>
>>> Remove the suspend/resume callback to avoid using the power down mode
>>> completely.
>>
>> As far as I can see in the ERRATA, KSZ8041 RNLI also has the bug.
>> Shoudn't you also remove the suspend/resume on that one (which follows in
>> ksphy_driver[])
> 
> Yes, I could, however this patch is coming out of a real issue we had with
> KSZ8041NL with this specific phy id (and we have such a patch in our linux
> branch since years).
> 
> On the other hand the entry for KSZ8041RNLI in the driver is somehow weird,
> since the phy id according to the original commit does not even exists on
> the datasheet. Would you be confident applying such errata for that phyid
> without having a way of testing it?


If your patch was to add the suspend/resume capability I would agree 
with you, but here we are talking about removing it, so what risk are we 
taking ?

In addition, commit 4bd7b5127bd0 ("micrel: add support for KSZ8041RNLI") 
clearly tells that the only thing it did was to copy KSZ8041NL entry, so 
for me updating both entries would really make sense.

It looks odd to me that you refer in your commit log to an ERRATA that 
tells you that the bug also exists on the KSZ8041RNLI and you apply it 
only partly.

Christophe
