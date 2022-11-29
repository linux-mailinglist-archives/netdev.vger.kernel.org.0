Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F2B9C63BC12
	for <lists+netdev@lfdr.de>; Tue, 29 Nov 2022 09:51:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231404AbiK2IvQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Nov 2022 03:51:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231438AbiK2Iu5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Nov 2022 03:50:57 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B275E58BDD
        for <netdev@vger.kernel.org>; Tue, 29 Nov 2022 00:50:30 -0800 (PST)
Received: from ptx.hi.pengutronix.de ([2001:67c:670:100:1d::c0])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1ozwJe-0004ws-8S; Tue, 29 Nov 2022 09:50:10 +0100
Received: from ore by ptx.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1ozwJd-0006Ac-4v; Tue, 29 Nov 2022 09:50:09 +0100
Date:   Tue, 29 Nov 2022 09:50:09 +0100
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     Arun.Ramadoss@microchip.com
Cc:     olteanv@gmail.com, UNGLinuxDriver@microchip.com,
        vivien.didelot@gmail.com, andrew@lunn.ch, f.fainelli@gmail.com,
        kuba@kernel.org, edumazet@google.com, pabeni@redhat.com,
        Woojung.Huh@microchip.com, davem@davemloft.net,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        kernel@pengutronix.de
Subject: Re: [PATCH v1 10/26] net: dsa: microchip: ksz8: refactor
 ksz8_fdb_dump()
Message-ID: <20221129085009.GC25526@pengutronix.de>
References: <20221128115958.4049431-1-o.rempel@pengutronix.de>
 <20221128115958.4049431-11-o.rempel@pengutronix.de>
 <aa1e91a9df8548559f0e6cde19dc1e90619d8a1e.camel@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <aa1e91a9df8548559f0e6cde19dc1e90619d8a1e.camel@microchip.com>
X-Sent-From: Pengutronix Hildesheim
X-URL:  http://www.pengutronix.de/
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
User-Agent: Mutt/1.10.1 (2018-07-13)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c0
X-SA-Exim-Mail-From: ore@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 29, 2022 at 08:29:47AM +0000, Arun.Ramadoss@microchip.com wrote:
> Hi Oleksij,
> 
> On Mon, 2022-11-28 at 12:59 +0100, Oleksij Rempel wrote:
> > EXTERNAL EMAIL: Do not click links or open attachments unless you
> > know the content is safe
> > 
> > After fixing different bugs we can refactor this function:
> > - be paranoid - read only max possibly amount of entries supported by
> >   the HW.
> > - pass error values returned by regmap
> > 
> > Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
> > ---
> >  drivers/net/dsa/microchip/ksz8795.c     | 41 ++++++++++++++---------
> > --
> >  drivers/net/dsa/microchip/ksz8795_reg.h |  1 +
> >  2 files changed, 24 insertions(+), 18 deletions(-)
> > 
> > diff --git a/drivers/net/dsa/microchip/ksz8795.c
> > b/drivers/net/dsa/microchip/ksz8795.c
> > index 736cf4e54333..308b46bb2ce5 100644
> > --- a/drivers/net/dsa/microchip/ksz8795.c
> > +++ b/drivers/net/dsa/microchip/ksz8795.c
> > @@ -949,26 +949,31 @@ void ksz8_flush_dyn_mac_table(struct ksz_device
> > *dev, int port)
> >  int ksz8_fdb_dump(struct ksz_device *dev, int port,
> >                   dsa_fdb_dump_cb_t *cb, void *data)
> >  {
> > -       int ret = 0;
> > -       u16 i = 0;
> > -       u16 entries = 0;
> > -       u8 src_port;
> > -       u8 mac[ETH_ALEN];
> > +       u16 i, entries = 0;
> > +       int ret;
> > 
> > -       do {
> > -               ret = ksz8_r_dyn_mac_table(dev, i, mac, &src_port,
> > -                                          &entries);
> > -               if (!ret && port == src_port) {
> > -                       ret = cb(mac, 0, false, data);
> > -                       if (ret)
> > -                               break;
> > -               }
> > -               i++;
> > -       } while (i < entries);
> > -       if (i >= entries)
> > -               ret = 0;
> > +       for (i = 0; i < KSZ8_DYN_MAC_ENTRIES; i++) {
> > +               u8 mac[ETH_ALEN];
> > +               u8 src_port;
> 
> Any specific reason for declaring variable within for loop instead of
> outside.

No. It is personal preference to declare variables within the scope where
variable is used.

-- 
Pengutronix e.K.                           |                             |
Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
