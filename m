Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A8FD011F75E
	for <lists+netdev@lfdr.de>; Sun, 15 Dec 2019 12:10:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726145AbfLOLKW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 15 Dec 2019 06:10:22 -0500
Received: from guitar.tcltek.co.il ([192.115.133.116]:36487 "EHLO
        mx.tkos.co.il" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726089AbfLOLKW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 15 Dec 2019 06:10:22 -0500
Received: from tarshish (unknown [10.0.8.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx.tkos.co.il (Postfix) with ESMTPS id 29014440808;
        Sun, 15 Dec 2019 13:10:20 +0200 (IST)
References: <20191211131111.GK16369@lunn.ch> <87fthqu6y6.fsf@tarshish> <20191211174938.GB30053@lunn.ch> <20191212085045.nqhfldkbebqzzamv@sapphire.tkos.co.il> <20191212131448.GA9959@lunn.ch> <20191212150810.zx6o26jnk5croh4r@sapphire.tkos.co.il> <20191212151355.GE30053@lunn.ch> <20191212152355.iiepmi4cjriddeon@sapphire.tkos.co.il> <20191212193611.63111051@nic.cz> <20191212190640.6vki2pjfacdnxihh@sapphire.tkos.co.il> <20191212193129.GF30053@lunn.ch> <20191212204141.16a406cd@nic.cz> <8736dlucai.fsf@tarshish>
User-agent: mu4e 1.2.0; emacs 26.1
From:   Baruch Siach <baruch@tkos.co.il>
To:     Marek Behun <marek.behun@nic.cz>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        netdev@vger.kernel.org,
        Denis Odintsov <d.odintsov@traviangames.com>,
        Hubert Feurstein <h.feurstein@gmail.com>
Subject: Re: [BUG] mv88e6xxx: tx regression in v5.3
In-reply-to: <8736dlucai.fsf@tarshish>
Date:   Sun, 15 Dec 2019 13:10:19 +0200
Message-ID: <871rt5u9no.fsf@tarshish>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Marek,

On Sun, Dec 15 2019, Baruch Siach wrote:
> The call to mv88e6341_port_set_cmode() introduced in commit 7a3007d22e8
> ("net: dsa: mv88e6xxx: fully support SERDES on Topaz family") still
> breaks port 5 (cpu) configuration. When called, its mode parameter is
> set to PHY_INTERFACE_MODE_2500BASEX (19).
>
> Any idea?

I dug a little further here. It turns out that
mv88e6xxx_port_set_cmode() does not do any register write, because it
exits early here with cmode == 0xb:

        /* cmode doesn't change, nothing to do for us */
        if (cmode == chip->ports[port].cmode)
                return 0;

mv88e6341_port_set_cmode_writable() breaks the port configuration with
its call to mv88e6xxx_port_hidden_write(). Before this call
mv88e6352_port_get_cmode() sets cmode to 0xb. After this call cmode is
6. This breaks the assumption that the equality test above relies on.

This fixes cpu port configuration for me:

diff --git a/drivers/net/dsa/mv88e6xxx/port.c b/drivers/net/dsa/mv88e6xxx/port.c
index 7fe256c5739d..a6c320978bcf 100644
--- a/drivers/net/dsa/mv88e6xxx/port.c
+++ b/drivers/net/dsa/mv88e6xxx/port.c
@@ -427,10 +427,6 @@ static int mv88e6xxx_port_set_cmode(struct mv88e6xxx_chip *chip, int port,
 		cmode = 0;
 	}
 
-	/* cmode doesn't change, nothing to do for us */
-	if (cmode == chip->ports[port].cmode)
-		return 0;
-
 	lane = mv88e6xxx_serdes_get_lane(chip, port);
 	if (lane) {
 		if (chip->ports[port].serdes_irq) {

Does that make sense?

Thanks,
baruch

--
     http://baruch.siach.name/blog/                  ~. .~   Tk Open Systems
=}------------------------------------------------ooO--U--Ooo------------{=
   - baruch@tkos.co.il - tel: +972.52.368.4656, http://www.tkos.co.il -
