Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 177741249AD
	for <lists+netdev@lfdr.de>; Wed, 18 Dec 2019 15:30:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727177AbfLROai (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Dec 2019 09:30:38 -0500
Received: from mail.nic.cz ([217.31.204.67]:40014 "EHLO mail.nic.cz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726921AbfLROai (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 18 Dec 2019 09:30:38 -0500
Received: from dellmb (unknown [IPv6:2001:1488:fffe:6:cac7:3539:7f1f:463])
        by mail.nic.cz (Postfix) with ESMTPSA id 47DCA140C5E;
        Wed, 18 Dec 2019 15:30:36 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=nic.cz; s=default;
        t=1576679436; bh=/4XTANkS0DO5ZAUDahbZEwYIwxtL9P+DqneGVnMyMFc=;
        h=Date:From:To;
        b=sTBntk4zo5pHlqnjN5HQetrqGva7dyEo8DCqNnwYohzsma1cw13oDXVNJEWLUZ3AC
         B82FJconcBVLwgzIvRvMsn9hmHbRWtncUZU4eTHhqgXUZIJm8c/vzXTRwlm2WsVnmV
         uJcVROzUZqGfPlXhbF5PtmQTX6i8YMY7uGAO0ZHo=
Date:   Wed, 18 Dec 2019 15:30:35 +0100
From:   Marek =?ISO-8859-1?Q?Beh=FAn?= <marek.behun@nic.cz>
To:     Baruch Siach <baruch@tkos.co.il>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        netdev@vger.kernel.org,
        Denis Odintsov <d.odintsov@traviangames.com>,
        Hubert Feurstein <h.feurstein@gmail.com>
Subject: Re: [BUG] mv88e6xxx: tx regression in v5.3
Message-ID: <20191218153035.11c3486d@dellmb>
In-Reply-To: <8736dlucai.fsf@tarshish>
References: <20191211131111.GK16369@lunn.ch>
        <87fthqu6y6.fsf@tarshish>
        <20191211174938.GB30053@lunn.ch>
        <20191212085045.nqhfldkbebqzzamv@sapphire.tkos.co.il>
        <20191212131448.GA9959@lunn.ch>
        <20191212150810.zx6o26jnk5croh4r@sapphire.tkos.co.il>
        <20191212151355.GE30053@lunn.ch>
        <20191212152355.iiepmi4cjriddeon@sapphire.tkos.co.il>
        <20191212193611.63111051@nic.cz>
        <20191212190640.6vki2pjfacdnxihh@sapphire.tkos.co.il>
        <20191212193129.GF30053@lunn.ch>
        <20191212204141.16a406cd@nic.cz>
        <8736dlucai.fsf@tarshish>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Virus-Scanned: clamav-milter 0.101.4 at mail
X-Virus-Status: Clean
X-Spam-Status: No, score=-1.0 required=5.0 tests=ALL_TRUSTED,SHORTCIRCUIT
        shortcircuit=ham autolearn=disabled version=3.4.2
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on mail.nic.cz
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Baruch,

On Sun, 15 Dec 2019 12:13:25 +0200
Baruch Siach <baruch@tkos.co.il> wrote:

> Thanks. That is enough to fix the phylink issue triggered by commit
> 7fb5a711545 ("net: dsa: mv88e6xxx: drop adjust_link to enabled
> phylink").
> 
> The Clearfog GT-8K DT has also this on the cpu side:
> 
> &cp1_eth2 {
>         status = "okay";
>         phy-mode = "2500base-x";
>         phys = <&cp1_comphy5 2>;
>         fixed-link {
>                 speed = <2500>;
>                 full-duplex;
>         };
> };
> 
> Should I drop fixed-link here as well?

I would think yes. phy-mode = 2500base-x should already force 2500mbps,
the fixed-link should be irrelevant. Whether this is truly the case I
do not know, but on Turris Mox I do not use fixed-link with these.

> 
> The call to mv88e6341_port_set_cmode() introduced in commit
> 7a3007d22e8 ("net: dsa: mv88e6xxx: fully support SERDES on Topaz
> family") still breaks port 5 (cpu) configuration. When called, its
> mode parameter is set to PHY_INTERFACE_MODE_2500BASEX (19).
> 
> Any idea?

I shall look into this. On Turris Mox this works, so I will have to do
some experiments.

> Thanks,
> baruch
> 
> --
>      http://baruch.siach.name/blog/                  ~. .~   Tk Open
> Systems
> =}------------------------------------------------ooO--U--Ooo------------{=
>    - baruch@tkos.co.il - tel: +972.52.368.4656, http://www.tkos.co.il
> -

