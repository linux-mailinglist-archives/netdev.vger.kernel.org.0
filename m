Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8B16363B999
	for <lists+netdev@lfdr.de>; Tue, 29 Nov 2022 06:56:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235538AbiK2F4e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Nov 2022 00:56:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235160AbiK2F4a (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Nov 2022 00:56:30 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 585194A07A
        for <netdev@vger.kernel.org>; Mon, 28 Nov 2022 21:56:29 -0800 (PST)
Received: from ptx.hi.pengutronix.de ([2001:67c:670:100:1d::c0])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1oztbM-00012a-AM; Tue, 29 Nov 2022 06:56:16 +0100
Received: from ore by ptx.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1oztbL-00050c-GO; Tue, 29 Nov 2022 06:56:15 +0100
Date:   Tue, 29 Nov 2022 06:56:15 +0100
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     Arun.Ramadoss@microchip.com
Cc:     olteanv@gmail.com, UNGLinuxDriver@microchip.com,
        vivien.didelot@gmail.com, andrew@lunn.ch, f.fainelli@gmail.com,
        kuba@kernel.org, edumazet@google.com, pabeni@redhat.com,
        Woojung.Huh@microchip.com, davem@davemloft.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel@pengutronix.de
Subject: Re: [PATCH v1 21/26] net: dsa: microchip: ksz8_r_sta_mac_table(): do
 not use error code for empty entries
Message-ID: <20221129055615.GB25526@pengutronix.de>
References: <20221128115958.4049431-1-o.rempel@pengutronix.de>
 <20221128115958.4049431-22-o.rempel@pengutronix.de>
 <90add896bd48f5ba80385df4d8a4e27c91f97e7d.camel@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <90add896bd48f5ba80385df4d8a4e27c91f97e7d.camel@microchip.com>
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

On Tue, Nov 29, 2022 at 05:25:55AM +0000, Arun.Ramadoss@microchip.com wrote:
> On Mon, 2022-11-28 at 12:59 +0100, Oleksij Rempel wrote:
> > EXTERNAL EMAIL: Do not click links or open attachments unless you
> > know the content is safe
> > 
> > This is a preparation for the next patch, to make use of read/write
> > errors.
> > 
> > Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
> > ---
> >  drivers/net/dsa/microchip/ksz8795.c | 94 +++++++++++++++++--------
> > ----
> >  1 file changed, 54 insertions(+), 40 deletions(-)
> > 
> > diff --git a/drivers/net/dsa/microchip/ksz8795.c
> > b/drivers/net/dsa/microchip/ksz8795.c
> > index 1c08103c9f50..b7487be91f67 100644
> > --- a/drivers/net/dsa/microchip/ksz8795.c
> > +++ b/drivers/net/dsa/microchip/ksz8795.c
> > @@ -457,7 +457,7 @@ static int ksz8_r_dyn_mac_table(struct ksz_device
> > *dev, u16 addr, u8 *mac_addr,
> >  }
> > 
> >  static int ksz8_r_sta_mac_table(struct ksz_device *dev, u16 addr,
> > -                               struct alu_struct *alu)
> > +                               struct alu_struct *alu, bool *valid)
> >  {
> >         u32 data_hi, data_lo;
> >         const u8 *shifts;
> > @@ -470,28 +470,32 @@ static int ksz8_r_sta_mac_table(struct
> > ksz_device *dev, u16 addr,
> >         ksz8_r_table(dev, TABLE_STATIC_MAC, addr, &data);
> >         data_hi = data >> 32;
> >         data_lo = (u32)data;
> > -       if (data_hi & (masks[STATIC_MAC_TABLE_VALID] |
> > -                       masks[STATIC_MAC_TABLE_OVERRIDE])) {
> > -               alu->mac[5] = (u8)data_lo;
> > -               alu->mac[4] = (u8)(data_lo >> 8);
> > -               alu->mac[3] = (u8)(data_lo >> 16);
> > -               alu->mac[2] = (u8)(data_lo >> 24);
> > -               alu->mac[1] = (u8)data_hi;
> > -               alu->mac[0] = (u8)(data_hi >> 8);
> > -               alu->port_forward =
> > -                       (data_hi & masks[STATIC_MAC_TABLE_FWD_PORTS])
> > >>
> > -                               shifts[STATIC_MAC_FWD_PORTS];
> > -               alu->is_override =
> > -                       (data_hi & masks[STATIC_MAC_TABLE_OVERRIDE])
> > ? 1 : 0;
> > -               data_hi >>= 1;
> > -               alu->is_static = true;
> > -               alu->is_use_fid =
> > -                       (data_hi & masks[STATIC_MAC_TABLE_USE_FID]) ?
> > 1 : 0;
> > -               alu->fid = (data_hi & masks[STATIC_MAC_TABLE_FID]) >>
> > -                               shifts[STATIC_MAC_FID];
> > +
> > +       if (!(data_hi & (masks[STATIC_MAC_TABLE_VALID] |
> > +                        masks[STATIC_MAC_TABLE_OVERRIDE]))) {
> > +               *valid = false;
> >                 return 0;
> >         }
> > -       return -ENXIO;
> > +
> > +       alu->mac[5] = (u8)data_lo;
> > +       alu->mac[4] = (u8)(data_lo >> 8);
> > +       alu->mac[3] = (u8)(data_lo >> 16);
> > +       alu->mac[2] = (u8)(data_lo >> 24);
> > +       alu->mac[1] = (u8)data_hi;
> > +       alu->mac[0] = (u8)(data_hi >> 8);
> 
> u64_to_ether_addr macro can be used to store address into array.

This should not be done in this patch.

> > +       alu->port_forward =
> > +               (data_hi & masks[STATIC_MAC_TABLE_FWD_PORTS]) >>
> > +                       shifts[STATIC_MAC_FWD_PORTS];
> 
> 
> 
> > +       alu->is_override = (data_hi &
> > masks[STATIC_MAC_TABLE_OVERRIDE]) ? 1 : 0;
> > +       data_hi >>= 1;
> > +       alu->is_static = true;
> > +       alu->is_use_fid = (data_hi & masks[STATIC_MAC_TABLE_USE_FID])
> > ? 1 : 0;
> > +       alu->fid = (data_hi & masks[STATIC_MAC_TABLE_FID]) >>
> > +               shifts[STATIC_MAC_FID];
> 
> Instead of masks and shifts, you consider using
> FIELD_GET(STATIC_MAC_TABLE_FID, data_hi);

I would love to do this, but in this case, complete driver should be
splittet in to KSZ88X3 and KSZ879X portions. FIELD_GET can't work with
dynamic masks and shifts.

I would say, it is not for this patch set.

> > +
> > +       *valid = true;
> > +
> > +       return 0;
> >  }
> > 
> >  void ksz8_w_sta_mac_table(struct ksz_device *dev, u16 addr,
> > @@ -969,12 +973,13 @@ int ksz8_fdb_dump(struct ksz_device *dev, int
> > port,
> > 
> >         for (i = 0; i  < dev->info->num_statics; i++) {
> >                 struct alu_struct alu;
> > +               bool valid;
> > 
> > -               ret = ksz8_r_sta_mac_table(dev, i, &alu);
> > -               if (ret == -ENXIO)
> > -                       continue;
> > +               ret = ksz8_r_sta_mac_table(dev, i, &alu, &valid);
> >                 if (ret)
> >                         return ret;
> > +               if (!valid)
> > +                       continue;
> > 
> >                 if (!(alu.port_forward & BIT(port)))
> >                         continue;
> > @@ -1010,20 +1015,25 @@ static int ksz8_add_sta_mac(struct ksz_device
> > *dev, int port,
> >                             const unsigned char *addr, u16 vid)
> >  {
> >         struct alu_struct alu;
> > -       int index;
> > +       int index, ret;
> >         int empty = 0;
> > 
> >         alu.port_forward = 0;
> >         for (index = 0; index < dev->info->num_statics; index++) {
> > -               if (!ksz8_r_sta_mac_table(dev, index, &alu)) {
> > -                       /* Found one already in static MAC table. */
> > -                       if (!memcmp(alu.mac, addr, ETH_ALEN) &&
> > -                           alu.fid == vid)
> > -                               break;
> > -               /* Remember the first empty entry. */
> > -               } else if (!empty) {
> > -                       empty = index + 1;
> > +               bool valid;
> > +
> > +               ret = ksz8_r_sta_mac_table(dev, index, &alu, &valid);
> > +               if (ret)
> > +                       return ret;
> > +               if (!valid) {
> > +                       /* Remember the first empty entry. */
> > +                       if (!empty)
> > +                               empty = index + 1;
> > +                       continue;
> >                 }
> > +
> > +               if (!memcmp(alu.mac, addr, ETH_ALEN) && alu.fid ==
> > vid)
> > +                       break;
> >         }
> > 
> >         /* no available entry */
> > @@ -1053,15 +1063,19 @@ static int ksz8_del_sta_mac(struct ksz_device
> > *dev, int port,
> >                             const unsigned char *addr, u16 vid)
> >  {
> >         struct alu_struct alu;
> > -       int index;
> > +       int index, ret;
> 
> Variable declaration in separate line.

Is it a new coding style requirement? I can't find it here:
https://www.kernel.org/doc/html/v6.0/process/coding-style.html

> > 
> >         for (index = 0; index < dev->info->num_statics; index++) {
> > -               if (!ksz8_r_sta_mac_table(dev, index, &alu)) {
> > -                       /* Found one already in static MAC table. */
> > -                       if (!memcmp(alu.mac, addr, ETH_ALEN) &&
> > -                           alu.fid == vid)
> > -                               break;
> > -               }
> > +               bool valid;
> > +
> > +               ret = ksz8_r_sta_mac_table(dev, index, &alu, &valid);
> > +               if (ret)
> > +                       return ret;
> > +               if (!valid)
> > +                       continue;
> > +
> > +               if (!memcmp(alu.mac, addr, ETH_ALEN) && alu.fid ==
> > vid)
> > +                       break;
> >         }
> > 
> >         /* no available entry */
> > --
> > 2.30.2
> > 

-- 
Pengutronix e.K.                           |                             |
Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
