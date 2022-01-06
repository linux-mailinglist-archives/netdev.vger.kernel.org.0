Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4346F486199
	for <lists+netdev@lfdr.de>; Thu,  6 Jan 2022 09:45:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236972AbiAFIo5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jan 2022 03:44:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236971AbiAFIoz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Jan 2022 03:44:55 -0500
Received: from proxima.lasnet.de (proxima.lasnet.de [IPv6:2a01:4f8:121:31eb:3::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E089C061245;
        Thu,  6 Jan 2022 00:44:55 -0800 (PST)
Received: from [IPV6:2003:e9:d722:f53c:f580:a16d:51ed:dc62] (p200300e9d722f53cf580a16d51eddc62.dip0.t-ipconnect.de [IPv6:2003:e9:d722:f53c:f580:a16d:51ed:dc62])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: stefan@datenfreihafen.org)
        by proxima.lasnet.de (Postfix) with ESMTPSA id C8315C027C;
        Thu,  6 Jan 2022 09:44:51 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=datenfreihafen.org;
        s=2021; t=1641458692;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=dtAOofmNB1Y9PmgLPQC/2A+pt6Ehh+W5o51Vearo0Ag=;
        b=bR6ffJvzaWFaP2zfwXOpfTUNQUKrhopuxiSdawya1k4UJjzEZcJrnyhQo0K2FMNzEeWgOR
        gOwjezjDtaNT5Snz1oxM99gug/htxWtmkVZAUL6Gya1S6xqLKB9Gjg0oXvvVgij+0dCk5C
        05k0tpKws51knHkhYFywe3kUBstQBy/C547cgNOpyI8VFhCjzsLAeWnTPOG3wKypik93bU
        iNHZgnF0KnN2pjNqU1hZmYbYITyDf6fTAG/R2RpcNl5p0beaLyMA66IdjTu/mQeBRyM7l2
        0eri/NfYvsZe/32CyEzG0oqCcYk4Z7Ygc2slgmd1u++TRlebUhprio8Afy0XeA==
Message-ID: <57f0e761-db5a-86f6-ab27-c0943d3e7805@datenfreihafen.org>
Date:   Thu, 6 Jan 2022 09:44:50 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.0
Subject: Re: [net-next 12/18] net: mac802154: Handle scan requests
Content-Language: en-US
To:     Alexander Aring <alex.aring@gmail.com>,
        Miquel Raynal <miquel.raynal@bootlin.com>
Cc:     Nicolas Schodet <nico@ni.fr.eu.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>,
        linux-wpan - ML <linux-wpan@vger.kernel.org>,
        David Girault <david.girault@qorvo.com>,
        Romuald Despres <romuald.despres@qorvo.com>,
        Frederic Blain <frederic.blain@qorvo.com>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        kernel list <linux-kernel@vger.kernel.org>
References: <20211222155743.256280-1-miquel.raynal@bootlin.com>
 <20211222155743.256280-13-miquel.raynal@bootlin.com>
 <CAB_54W6AZ+LGTcFsQjNx7uq=+R5v_kdF0Xm5kwWQ8ONtfOrmAw@mail.gmail.com>
 <Ycx0mwQcFsmVqWVH@ni.fr.eu.org>
 <CAB_54W41ZEoXzoD2_wadfMTY8anv9D9e2T5wRckdXjs7jKTTCA@mail.gmail.com>
 <CAB_54W6gHE1S9Q+-SVbrnAWPxBxnvf54XVTCmddtj8g-bZzMRA@mail.gmail.com>
 <20220104191802.2323e44a@xps13>
 <CAB_54W5quZz8rVrbdx+cotTRZZpJ4ouRDZkxeW6S1L775Si=cw@mail.gmail.com>
 <20220105215551.1693eba4@xps13>
 <CAB_54W7zDXfybMZZo8QPwRCxX8-BbkQdznwEkLEWeW+E3k2dNg@mail.gmail.com>
From:   Stefan Schmidt <stefan@datenfreihafen.org>
In-Reply-To: <CAB_54W7zDXfybMZZo8QPwRCxX8-BbkQdznwEkLEWeW+E3k2dNg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello.

On 06.01.22 01:38, Alexander Aring wrote:
> Hi,
> 
> 
> On Wed, 5 Jan 2022 at 15:55, Miquel Raynal <miquel.raynal@bootlin.com> wrote:
> ...

>> Also, just for the record,
>> - should I keep copying the netdev list for v2?
> 
> yes, why not.

>> - should I monitor if net-next is open before sending or do you have
>>    your own set of rules?
>>
> 
> I need to admit, Stefan is the "Thanks, applied." hero here and he
> should answer this question.

No need to monitor if net-next is open for these patches (just don't add 
a net-next patch subject prefix as this would confuse Jakub and Dave. 
wpan-next would be more appropriate).

I am following this patchset and the review from Alex. I have not done a 
full in depth review myself yet, its on my list.

Basically keep working with Alex and use the wpan-next prefix and I will 
pick up the patches to my wpan-next tree and sent a pull to net-next 
when we are happy with it. Does that sound good to you?

regards
Stefan Schmidt
