Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B7C33A476E
	for <lists+netdev@lfdr.de>; Fri, 11 Jun 2021 19:05:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231312AbhFKRHs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Jun 2021 13:07:48 -0400
Received: from fllv0016.ext.ti.com ([198.47.19.142]:40392 "EHLO
        fllv0016.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229633AbhFKRHs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Jun 2021 13:07:48 -0400
Received: from fllv0034.itg.ti.com ([10.64.40.246])
        by fllv0016.ext.ti.com (8.15.2/8.15.2) with ESMTP id 15BH5gD6044939;
        Fri, 11 Jun 2021 12:05:42 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1623431142;
        bh=l99g2k9vyL7sWPEL1tJV5egVhHg7xB19/k7tlJBHCis=;
        h=Subject:To:CC:References:From:Date:In-Reply-To;
        b=nF/qVd3Mj/m9MRbNFgfFN9tKi0ajkH8wJwVu1jPxzTEyJggL/qZlEE9e8N7giuRJB
         RWKd0Urwl3U9A2suvzRZCDzcOVykd3lkpvSq6x4RCr6dAwm+GI17lTnUfDy2KD8W3S
         IJ6S0OLC/Gxipz1hGR2TMi4O0EVX7wGeL1j1ANfE=
Received: from DLEE104.ent.ti.com (dlee104.ent.ti.com [157.170.170.34])
        by fllv0034.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 15BH5gg7018538
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 11 Jun 2021 12:05:42 -0500
Received: from DLEE114.ent.ti.com (157.170.170.25) by DLEE104.ent.ti.com
 (157.170.170.34) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2176.2; Fri, 11
 Jun 2021 12:05:42 -0500
Received: from fllv0039.itg.ti.com (10.64.41.19) by DLEE114.ent.ti.com
 (157.170.170.25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2176.2 via
 Frontend Transport; Fri, 11 Jun 2021 12:05:42 -0500
Received: from [10.247.25.23] (ileax41-snat.itg.ti.com [10.172.224.153])
        by fllv0039.itg.ti.com (8.15.2/8.15.2) with ESMTP id 15BH5fpX073943;
        Fri, 11 Jun 2021 12:05:42 -0500
Subject: Re: [PATCH v2] net: phy: dp83867: perform soft reset and retain
 established link
To:     Johannes Pointner <h4nn35.work@gmail.com>,
        Geet Modi <geet.modi@ti.com>, Andrew Lunn <andrew@lunn.ch>
CC:     <netdev@vger.kernel.org>, "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        <linux-kernel@vger.kernel.org>
References: <3494dcf6-14ca-be2b-dbf8-dda2e208b70b@ti.com>
 <20210610004342.4493-1-praneeth@ti.com> <YMGP/aim6CD270Yo@lunn.ch>
 <CAHvQdo0YAmAo_1m7LgLS200a7fNz-vYJkwR74AxckQm-iu0tuA@mail.gmail.com>
From:   "Bajjuri, Praneeth" <praneeth@ti.com>
Message-ID: <e4f3a1c2-069e-b58a-eadf-b5505fb42e02@ti.com>
Date:   Fri, 11 Jun 2021 12:05:41 -0500
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <CAHvQdo0YAmAo_1m7LgLS200a7fNz-vYJkwR74AxckQm-iu0tuA@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hannes,

On 6/10/2021 12:53 AM, Johannes Pointner wrote:
> Hello,
> 
> On Thu, Jun 10, 2021 at 6:10 AM Andrew Lunn <andrew@lunn.ch> wrote:
>>
>> On Wed, Jun 09, 2021 at 07:43:42PM -0500, praneeth@ti.com wrote:
>>> From: Praneeth Bajjuri <praneeth@ti.com>
>>>
>>> Current logic is performing hard reset and causing the programmed
>>> registers to be wiped out.
>>>
>>> as per datasheet: https://www.ti.com/lit/ds/symlink/dp83867cr.pdf
>>> 8.6.26 Control Register (CTRL)
>>>
>>> do SW_RESTART to perform a reset not including the registers,
>>> If performed when link is already present,
>>> it will drop the link and trigger re-auto negotiation.
>>>
>>> Signed-off-by: Praneeth Bajjuri <praneeth@ti.com>
>>> Signed-off-by: Geet Modi <geet.modi@ti.com>
>>
>> Reviewed-by: Andrew Lunn <andrew@lunn.ch>
>>
>>      Andrew
> 
> I reported a few days ago an issue with the DP83822 which I think is
> caused by a similar change.
> https://lore.kernel.org/netdev/CAHvQdo2yzJC89K74c_CZFjPydDQ5i22w36XPR5tKVv_W8a2vcg@mail.gmail.com/
> In my case I can't get an link after this change, reverting it fixes
> the problem for me.

Are you saying that instead of reset if sw_restart is done as per this 
patch, there is no issue?

> 
> Hannes
> 
