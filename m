Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A0D0469C37A
	for <lists+netdev@lfdr.de>; Mon, 20 Feb 2023 01:14:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229658AbjBTAMG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Feb 2023 19:12:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229602AbjBTAMF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Feb 2023 19:12:05 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FD3AC159
        for <netdev@vger.kernel.org>; Sun, 19 Feb 2023 16:12:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Transfer-Encoding:Content-Disposition:
        Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:From:
        Sender:Reply-To:Subject:Date:Message-ID:To:Cc:MIME-Version:Content-Type:
        Content-Transfer-Encoding:Content-ID:Content-Description:Content-Disposition:
        In-Reply-To:References; bh=kRQSDr4fYzeFipfcoVk+0YTchNjho9jsJQS1BZ3IL2U=; b=up
        zf1DjD8Mmo2SSDtks/5lYkQsmdtdH+5LTUeAqqstyZbWpVwny60H53uipJLQKGdFUnuBrX3vppERP
        DfX0Nc8Ho37aiCAMNyNk604REv8EpMKZTuEVGJKluqAcsiz+2rog/U3+eGDqLa+x8A7MexzPfR8o4
        G8OHHYwX6B3UEDQ=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1pTtmZ-005Sru-1s; Mon, 20 Feb 2023 01:11:51 +0100
Date:   Mon, 20 Feb 2023 01:11:51 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Richard Weinberger <richard@nod.at>
Cc:     wei fang <wei.fang@nxp.com>,
        David Laight <David.Laight@aculab.com>,
        netdev <netdev@vger.kernel.org>,
        shenwei wang <shenwei.wang@nxp.com>,
        xiaoning wang <xiaoning.wang@nxp.com>,
        linux-imx <linux-imx@nxp.com>
Subject: Re: high latency with imx8mm compared to imx6q
Message-ID: <Y/K6xxqSIejCOuQk@lunn.ch>
References: <1422776754.146013.1676652774408.JavaMail.zimbra@nod.at>
 <b4fc00958e0249208b5aceecfa527161@AcuMS.aculab.com>
 <Y/AkI7DUYKbToEpj@lunn.ch>
 <DB9PR04MB81065CC7BD56EBDDC91C7ED288A69@DB9PR04MB8106.eurprd04.prod.outlook.com>
 <130183416.146934.1676713353800.JavaMail.zimbra@nod.at>
 <DB9PR04MB8106FE7B686569FB15C3281388A69@DB9PR04MB8106.eurprd04.prod.outlook.com>
 <2030061857.147332.1676721783879.JavaMail.zimbra@nod.at>
 <DB9PR04MB81068EF8919ED7488EE1E3D788A69@DB9PR04MB8106.eurprd04.prod.outlook.com>
 <2015643728.147543.1676726453615.JavaMail.zimbra@nod.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <2015643728.147543.1676726453615.JavaMail.zimbra@nod.at>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Feb 18, 2023 at 02:20:53PM +0100, Richard Weinberger wrote:
> ----- Ursprüngliche Mail -----
> > Von: "wei fang" <wei.fang@nxp.com>
> > If you use the ethtool cmd, the minimum can only be set to 1.
> > But you can set the coalescing registers directly on your console,
> > ENET_RXICn[ICEN] (addr: base + F0h offset + (4d × n) where n=0,1,2) and
> > ENET_TXICn[ICEN] (addr: base + 100h offset + (4d × n), where n=0d to 2d)
> > set the ICEN bit (bit 31) to 0:
> > 0 disable Interrupt coalescing.
> > 1 disable Interrupt coalescing.
> > or modify you fec driver, but remember, the interrupt coalescing feature
> > can only be disable by setting the ICEN bit to 0, do not set the tx/rx
> > usecs/frames
> > to 0.
> 
> Disabling interrupt coalescing seems to make things much better. :-)

Another thing to consider. The FEC in imx8 gained support for EEE. So
if your link is otherwise idle, it could be put into low power mode,
and takes a little time to wake up. Like most MAC drivers, EEE is
broken on the FEC, but it could still be active. You might want to put
a printk() in fec_enet_eee_mode_set() and see if it is active. I would
not trust ethtool.

    Andrew
