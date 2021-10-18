Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 051CF431845
	for <lists+netdev@lfdr.de>; Mon, 18 Oct 2021 13:57:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230515AbhJRL7j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Oct 2021 07:59:39 -0400
Received: from pegase2.c-s.fr ([93.17.235.10]:46085 "EHLO pegase2.c-s.fr"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229519AbhJRL7j (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 18 Oct 2021 07:59:39 -0400
Received: from localhost (mailhub3.si.c-s.fr [172.26.127.67])
        by localhost (Postfix) with ESMTP id 4HXwNQ3pXVz9sSg;
        Mon, 18 Oct 2021 13:57:26 +0200 (CEST)
X-Virus-Scanned: amavisd-new at c-s.fr
Received: from pegase2.c-s.fr ([172.26.127.65])
        by localhost (pegase2.c-s.fr [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id RL3x8vznDKhL; Mon, 18 Oct 2021 13:57:26 +0200 (CEST)
Received: from messagerie.si.c-s.fr (messagerie.si.c-s.fr [192.168.25.192])
        by pegase2.c-s.fr (Postfix) with ESMTP id 4HXwNQ2lbsz9sSY;
        Mon, 18 Oct 2021 13:57:26 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
        by messagerie.si.c-s.fr (Postfix) with ESMTP id 466508B76C;
        Mon, 18 Oct 2021 13:57:26 +0200 (CEST)
X-Virus-Scanned: amavisd-new at c-s.fr
Received: from messagerie.si.c-s.fr ([127.0.0.1])
        by localhost (messagerie.si.c-s.fr [127.0.0.1]) (amavisd-new, port 10023)
        with ESMTP id MRjVM3w8MEjt; Mon, 18 Oct 2021 13:57:26 +0200 (CEST)
Received: from PO20335.IDSI0.si.c-s.fr (unknown [172.25.230.103])
        by messagerie.si.c-s.fr (Postfix) with ESMTP id 102D18B763;
        Mon, 18 Oct 2021 13:57:26 +0200 (CEST)
Subject: Re: [PATCH net-next] phy: micrel: ksz8041nl: do not use power down
 mode
To:     Francesco Dolcini <francesco.dolcini@toradex.com>,
        f.fainelli@gmail.com, Andrew Lunn <andrew@lunn.ch>,
        Sergei Shtylyov <sergei.shtylyov@gmail.com>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Stefan Agner <stefan@agner.ch>,
        Marcel Ziswiler <marcel.ziswiler@toradex.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20211018094256.70096-1-francesco.dolcini@toradex.com>
 <180289ac-4480-1e4c-d679-df4f0478ec65@csgroup.eu>
 <20211018101802.GA7669@francesco-nb.int.toradex.com>
 <a06104cf-d634-a25a-cf54-975689ad3e91@csgroup.eu>
 <20211018112735.GB7669@francesco-nb.int.toradex.com>
From:   Christophe Leroy <christophe.leroy@csgroup.eu>
Message-ID: <efb25ac0-a5f6-fc88-ce6d-f93a174c65f1@csgroup.eu>
Date:   Mon, 18 Oct 2021 13:57:25 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20211018112735.GB7669@francesco-nb.int.toradex.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: fr-FR
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

+Sergei Shtylyov

Adding Sergei Shtylyov in the discussion, as he submitted the patch for 
the support of KSZ8041RNLI.


Le 18/10/2021 à 13:27, Francesco Dolcini a écrit :
> On Mon, Oct 18, 2021 at 12:46:14PM +0200, Christophe Leroy wrote:
>>
>>
>> Le 18/10/2021 à 12:18, Francesco Dolcini a écrit :
>>> Hello Christophe,
>>>
>>> On Mon, Oct 18, 2021 at 11:53:03AM +0200, Christophe Leroy wrote:
>>>>
>>>>
>>>> Le 18/10/2021 à 11:42, Francesco Dolcini a écrit :
>>>>> From: Stefan Agner <stefan@agner.ch>
>>>>>
>>>>> Some Micrel KSZ8041NL PHY chips exhibit continous RX errors after using
>>>>> the power down mode bit (0.11). If the PHY is taken out of power down
>>>>> mode in a certain temperature range, the PHY enters a weird state which
>>>>> leads to continously reporting RX errors. In that state, the MAC is not
>>>>> able to receive or send any Ethernet frames and the activity LED is
>>>>> constantly blinking. Since Linux is using the suspend callback when the
>>>>> interface is taken down, ending up in that state can easily happen
>>>>> during a normal startup.
>>>>>
>>>>> Micrel confirmed the issue in errata DS80000700A [*], caused by abnormal
>>>>> clock recovery when using power down mode. Even the latest revision (A4,
>>>>> Revision ID 0x1513) seems to suffer that problem, and according to the
>>>>> errata is not going to be fixed.
>>>>>
>>>>> Remove the suspend/resume callback to avoid using the power down mode
>>>>> completely.
>>>>
>>>> As far as I can see in the ERRATA, KSZ8041 RNLI also has the bug.
>>>> Shoudn't you also remove the suspend/resume on that one (which follows in
>>>> ksphy_driver[])
>>>
>>> Yes, I could, however this patch is coming out of a real issue we had with
>>> KSZ8041NL with this specific phy id (and we have such a patch in our linux
>>> branch since years).
>>>
>>> On the other hand the entry for KSZ8041RNLI in the driver is somehow weird,
>>> since the phy id according to the original commit does not even exists on
>>> the datasheet. Would you be confident applying such errata for that phyid
>>> without having a way of testing it?
>>
>>
>> If your patch was to add the suspend/resume capability I would agree with
>> you, but here we are talking about removing it, so what risk are we taking ?
> yes, you are right.
> 
>> In addition, commit 4bd7b5127bd0 ("micrel: add support for KSZ8041RNLI")
>> clearly tells that the only thing it did was to copy KSZ8041NL entry, so for
>> me updating both entries would really make sense.
>>
>> It looks odd to me that you refer in your commit log to an ERRATA that tells
>> you that the bug also exists on the KSZ8041RNLI and you apply it only
>> partly.
> 
> I think I was not clear enough, the entry I changed should already cover
> KSZ8041RNLI, the phyid is supposed to be just the same according to the
> datasheet. This entry for KSZ8041RNLI seems really special with this
> un-documented phyid.
> But I'm just speculating, I do not have access to these hardware.
> 
> Said that if there are no concern from anybody else, to be on the safe/cautious
> side, I can just update also this entry.
> 
> Francesco
> 
