Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 128CC6A7480
	for <lists+netdev@lfdr.de>; Wed,  1 Mar 2023 20:49:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229606AbjCATtn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Mar 2023 14:49:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229546AbjCATtl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Mar 2023 14:49:41 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F39755BE;
        Wed,  1 Mar 2023 11:49:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1677700172; x=1709236172;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=7reiKjD1KnrY4wWSGx+aBYfAaGWBUZqD36fWwdHvUGk=;
  b=ED/+bG5aGg/myGfBdBmIN44SgamBP2erdVjiYHDyNYf3q1a2nPJe1ljv
   H0wsrDCJoDtrQYREzkStpe6IgPtFeNgSgFQhz5V/4M0JTwhDGMc09KYg9
   pnQ49VjzPVvdRsAXeWrkRwC2Ij+17Xs83U02DO71QmqDCoIlH7RglHRAP
   klhq92Kj5e9ZJXCAwWmiofPfcvZYox545C7KfccxmVYRB1tSYHk1Y3X+K
   x8Df0YvUjlvtMn3JBzSCajtzDy+uNr3cr7iR6KU+4Y46TakbX3G0G4WAj
   BTyZKEZ+5riuFA4un6YNtcjSB95P0Y48BRrUSZW0kW2vYUhOE3soKMuNP
   A==;
X-IronPort-AV: E=Sophos;i="5.98,225,1673938800"; 
   d="scan'208";a="202842359"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 01 Mar 2023 12:49:31 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Wed, 1 Mar 2023 12:49:31 -0700
Received: from localhost (10.10.115.15) by chn-vm-ex03.mchp-main.com
 (10.10.85.151) with Microsoft SMTP Server id 15.1.2507.16 via Frontend
 Transport; Wed, 1 Mar 2023 12:49:30 -0700
Date:   Wed, 1 Mar 2023 20:49:30 +0100
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     Vladimir Oltean <olteanv@gmail.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <UNGLinuxDriver@microchip.com>
Subject: Re: [PATCH net] net: lan966x: Fix port police support using
 tc-matchall
Message-ID: <20230301194930.44g55mljrw3qicsi@soft-dev3-1>
References: <20230228204742.2599151-1-horatiu.vultur@microchip.com>
 <20230301122711.2eqlbjplitrpktdj@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <20230301122711.2eqlbjplitrpktdj@skbuf>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The 03/01/2023 14:27, Vladimir Oltean wrote:

Hi Vladimir,

> 
> On Tue, Feb 28, 2023 at 09:47:42PM +0100, Horatiu Vultur wrote:
> > When the police was removed from the port, then it was trying to
> > remove the police from the police id and not from the actual
> > police index.
> > The police id represents the id of the police and police index
> > represents the position in HW where the police is situated.
> > The port police id can be any number while the port police index
> > is a number based on the port chip port.
> > Fix this by deleting the police from HW that is situated at the
> > police index and not police id.
> >
> > Fixes: 5390334b59a3 ("net: lan966x: Add port police support using tc-matchall")
> > Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
> > ---
> >  drivers/net/ethernet/microchip/lan966x/lan966x_police.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_police.c b/drivers/net/ethernet/microchip/lan966x/lan966x_police.c
> > index a9aec900d608d..7d66fe75cd3bf 100644
> > --- a/drivers/net/ethernet/microchip/lan966x/lan966x_police.c
> > +++ b/drivers/net/ethernet/microchip/lan966x/lan966x_police.c
> > @@ -194,7 +194,7 @@ int lan966x_police_port_del(struct lan966x_port *port,
> >               return -EINVAL;
> >       }
> >
> > -     err = lan966x_police_del(port, port->tc.police_id);
> > +     err = lan966x_police_del(port, POL_IDX_PORT + port->chip_port);
> >       if (err) {
> >               NL_SET_ERR_MSG_MOD(extack,
> >                                  "Failed to add policer to port");
> > --
> > 2.38.0
> >
> 
> Reviewed-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Thanks for the review.

> 
> but the extack message is also wrong; it says it failed to add the
> policer, when the operation that failed was a deletion.

Good catch, but this err path will never be hit as the function
lan966x_police_del always returns 0.

I am planning to send a patch when the net-next gets open to
actually change the return type of the function 'lan966x_police_del' and
then the extack message will be removed.


-- 
/Horatiu
