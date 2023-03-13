Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B11F46B6F1F
	for <lists+netdev@lfdr.de>; Mon, 13 Mar 2023 06:36:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229494AbjCMFgV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Mar 2023 01:36:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229437AbjCMFgT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Mar 2023 01:36:19 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 593C03BDA5
        for <netdev@vger.kernel.org>; Sun, 12 Mar 2023 22:36:18 -0700 (PDT)
Received: from ptx.hi.pengutronix.de ([2001:67c:670:100:1d::c0])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1pbaqv-0002kl-Pu; Mon, 13 Mar 2023 06:36:09 +0100
Received: from ore by ptx.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1pbaqt-0002nD-HR; Mon, 13 Mar 2023 06:36:07 +0100
Date:   Mon, 13 Mar 2023 06:36:07 +0100
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     Arun.Ramadoss@microchip.com
Cc:     olteanv@gmail.com, andrew@lunn.ch, f.fainelli@gmail.com,
        kuba@kernel.org, edumazet@google.com, pabeni@redhat.com,
        Woojung.Huh@microchip.com, davem@davemloft.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel@pengutronix.de, UNGLinuxDriver@microchip.com
Subject: Re: [PATCH net-next v3 2/2] net: dsa: microchip: add ETS Qdisc
 support for KSZ9477 series
Message-ID: <20230313053607.GD29822@pengutronix.de>
References: <20230310090809.220764-1-o.rempel@pengutronix.de>
 <20230310090809.220764-3-o.rempel@pengutronix.de>
 <1b07b82f8692f5eb5134f78dad4cbcb3110224b2.camel@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1b07b82f8692f5eb5134f78dad4cbcb3110224b2.camel@microchip.com>
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

On Mon, Mar 13, 2023 at 03:34:16AM +0000, Arun.Ramadoss@microchip.com wrote:
> Hi Oleksij,
> On Fri, 2023-03-10 at 10:08 +0100, Oleksij Rempel wrote:
> > EXTERNAL EMAIL: Do not click links or open attachments unless you
> > know the content is safe
> > 
> > Add ETS Qdisc support for KSZ9477 of switches. Current implementation
> > is
> > limited to strict priority mode.
> > 
> > Tested on KSZ8563R with following configuration:
> > tc qdisc replace dev lan2 root handle 1: ets strict 4 \
> >   priomap 3 3 2 2 1 1 0 0
> > ip link add link lan2 name v1 type vlan id 1 \
> >   egress-qos-map 0:0 1:1 2:2 3:3 4:4 5:5 6:6 7:7
> > 
> > and patched iperf3 version:
> > https://github.com/esnet/iperf/pull/1476
> > iperf3 -c 172.17.0.1 -b100M  -l1472 -t100 -u -R --sock-prio 2
> > 
> > Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
> > ---
> >  drivers/net/dsa/microchip/ksz_common.c | 218
> > +++++++++++++++++++++++++
> >  drivers/net/dsa/microchip/ksz_common.h |  12 ++
> >  2 files changed, 230 insertions(+)
> > 
> > diff --git a/drivers/net/dsa/microchip/ksz_common.c
> > b/drivers/net/dsa/microchip/ksz_common.c
> > index ae05fe0b0a81..54d75ec22ef0 100644
> > --- a/drivers/net/dsa/microchip/ksz_common.c
> > +++ b/drivers/net/dsa/microchip/ksz_common.c
> > @@ -1087,6 +1087,7 @@ const struct ksz_chip_data ksz_switch_chips[] =
> > {
> >                 .port_nirqs = 3,
> >                 .num_tx_queues = 4,
> >                 .tc_cbs_supported = true,
> > +               .tc_ets_supported = true,
> 
> Whether the switch which are supporting cbs will also support ets or
> not. If CBS and ETS are related, then is it possible to use single flag
> controlling both the feature. I could infer that switch which has
> tc_cbs_supported  true, also has tc_ets_supported also true.
> 
> If both are different, patch looks good to me.

Both are different. For example on ksz8 switches it is possible to
implement tc-etc but not tc-cbs.

Regatds,
Oleksij
-- 
Pengutronix e.K.                           |                             |
Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
