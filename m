Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 81B224607DA
	for <lists+netdev@lfdr.de>; Sun, 28 Nov 2021 18:10:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231855AbhK1RNx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 28 Nov 2021 12:13:53 -0500
Received: from marcansoft.com ([212.63.210.85]:36086 "EHLO mail.marcansoft.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234143AbhK1RLw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 28 Nov 2021 12:11:52 -0500
Received: from [127.0.0.1] (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: marcan@marcan.st)
        by mail.marcansoft.com (Postfix) with ESMTPSA id 988D242684;
        Sun, 28 Nov 2021 17:08:30 +0000 (UTC)
To:     Andrew Lunn <andrew@lunn.ch>, Tianhao Chai <cth451@gmail.com>
Cc:     Igor Russkikh <irusskikh@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Sven Peter <sven@svenpeter.dev>,
        Alyssa Rosenzweig <alyssa@rosenzweig.io>
References: <20211128023733.GA466664@cth-desktop-dorm.mad.wi.cth451.me>
 <YaOvShya4kP4SRk7@lunn.ch>
From:   Hector Martin <marcan@marcan.st>
Subject: Re: [PATCH] ethernet: aquantia: Try MAC address from device tree
Message-ID: <37679b8b-7a81-5605-23af-e442f9e91816@marcan.st>
Date:   Mon, 29 Nov 2021 02:08:28 +0900
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <YaOvShya4kP4SRk7@lunn.ch>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: es-ES
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 29/11/2021 01.33, Andrew Lunn wrote:
> On Sat, Nov 27, 2021 at 08:37:33PM -0600, Tianhao Chai wrote:
>> Apple M1 Mac minis (2020) with 10GE NICs do not have MAC address in the
>> card, but instead need to obtain MAC addresses from the device tree. In
>> this case the hardware will report an invalid MAC.
>>
>> Currently atlantic driver does not query the DT for MAC address and will
>> randomly assign a MAC if the NIC doesn't have a permanent MAC burnt in.
>> This patch causes the driver to perfer a valid MAC address from OF (if
>> present) over HW self-reported MAC and only fall back to a random MAC
>> address when neither of them is valid.
> 
> This is a change in behaviour, and could cause regressions. It would
> be better to keep with the current flow. Call
> aq_fw_ops->get_mac_permanent() first. If that does not give a valid
> MAC address, then try DT, and lastly use a random MAC address.

On DT platforms, it is expected that the device tree MAC will override 
whatever the device thinks is its MAC address. See tg3, igb, igc, r8169, 
for examples where eth_platform_get_mac_address takes precedence over 
everything else.

I would not expect any other existing platform to have a MAC assigned to 
the device in this way using these cards; if any platforms do, chances 
are they intended it for it to be used and this patch will fix a current 
bug. If some platforms out there really have bogus MACs assigned in this 
way, that's a firmware bug, and we'd have to find out and add explicit, 
targeted workaround code. Are you aware of any such platforms? :)

-- 
Hector Martin (marcan@marcan.st)
Public Key: https://mrcn.st/pub
