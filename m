Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0E82CDD3F
	for <lists+netdev@lfdr.de>; Mon, 29 Apr 2019 09:55:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727610AbfD2HzU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Apr 2019 03:55:20 -0400
Received: from smtp-out.xnet.cz ([178.217.244.18]:47746 "EHLO smtp-out.xnet.cz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727409AbfD2HzT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 29 Apr 2019 03:55:19 -0400
Received: from meh.true.cz (meh.true.cz [108.61.167.218])
        (Authenticated sender: petr@true.cz)
        by smtp-out.xnet.cz (Postfix) with ESMTPSA id 170E057D9;
        Mon, 29 Apr 2019 09:55:16 +0200 (CEST)
Received: from localhost (meh.true.cz [local])
        by meh.true.cz (OpenSMTPD) with ESMTPA id efaae547;
        Mon, 29 Apr 2019 09:55:14 +0200 (CEST)
Date:   Mon, 29 Apr 2019 09:55:14 +0200
From:   Petr =?utf-8?Q?=C5=A0tetiar?= <ynezz@true.cz>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Rob Herring <robh+dt@kernel.org>,
        Frank Rowand <frowand.list@gmail.com>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Maxime Ripard <maxime.ripard@bootlin.com>,
        Alban Bedel <albeu@free.fr>
Subject: Re: [PATCH v2 3/4] net: macb: Drop nvmem_get_mac_address usage
Message-ID: <20190429075514.GB346@meh.true.cz>
Reply-To: Petr =?utf-8?Q?=C5=A0tetiar?= <ynezz@true.cz>
References: <1556456002-13430-1-git-send-email-ynezz@true.cz>
 <1556456002-13430-4-git-send-email-ynezz@true.cz>
 <20190428165637.GJ23059@lunn.ch>
 <20190428210814.GA346@meh.true.cz>
 <20190428213640.GB10772@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190428213640.GB10772@lunn.ch>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Andrew Lunn <andrew@lunn.ch> [2019-04-28 23:36:40]:

Hi Andrew,

> > so if I understand this correctly, it probably means, that this approach with
> > modified of_get_mac_address is dead end as current of_get_mac_address users
> > don't expect and handle possible -EPROBE_DEFER error, so I would need to
> > change all the current users, which is nonsense.
> 
> I would not say it is dead, it just needs a bit more work.

ok, that's good news, I've probably just misunderstood your concern about the
random MAC address in case when platform/nvmem subsystem returns -EPROBE_DEFER.

> The current users should always be checking for a NULL pointer.  You
> just need to change that to !IS_ERR(). You can then return
> ERR_PTR(-PROBE_DEFER) from the NVMEM operation.

I'm more then happy to address this in v3, but I'm still curious, what is it
going to change in the current state of the tree. 

My understanding of -PROBE_DEFER is, that it needs to be propagated back from
the driver's probe callback/hook to the upper device/driver subsystem in order
to be moved to the list of pending drivers and considered for probe later
again. This is not going to happen in any of the current drivers, thus it will
probably still always result in random MAC address in case of -EPROBE_DEFER
error from the nvmem subsystem.

-- ynezz
