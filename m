Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 85EB550EB3F
	for <lists+netdev@lfdr.de>; Mon, 25 Apr 2022 23:18:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245735AbiDYVVc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Apr 2022 17:21:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236884AbiDYVVa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Apr 2022 17:21:30 -0400
X-Greylist: delayed 14287 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 25 Apr 2022 14:18:24 PDT
Received: from bmailout3.hostsharing.net (bmailout3.hostsharing.net [176.9.242.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6807EBC850;
        Mon, 25 Apr 2022 14:18:23 -0700 (PDT)
Received: from h08.hostsharing.net (h08.hostsharing.net [IPv6:2a01:37:1000::53df:5f1c:0])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256
         client-signature RSA-PSS (4096 bits) client-digest SHA256)
        (Client CN "*.hostsharing.net", Issuer "RapidSSL TLS DV RSA Mixed SHA256 2020 CA-1" (verified OK))
        by bmailout3.hostsharing.net (Postfix) with ESMTPS id 5DB6110301073;
        Mon, 25 Apr 2022 23:18:22 +0200 (CEST)
Received: by h08.hostsharing.net (Postfix, from userid 100393)
        id 3D8AD117691; Mon, 25 Apr 2022 23:18:22 +0200 (CEST)
Date:   Mon, 25 Apr 2022 23:18:22 +0200
From:   Lukas Wunner <lukas@wunner.de>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Paolo Abeni <pabeni@redhat.com>, Oliver Neukum <oneukum@suse.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jann Horn <jannh@google.com>,
        Oleksij Rempel <o.rempel@pengutronix.de>,
        Eric Dumazet <edumazet@google.com>, netdev@vger.kernel.org,
        linux-usb@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Jacky Chou <jackychou@asix.com.tw>, Willy Tarreau <w@1wt.eu>,
        Lino Sanfilippo <LinoSanfilippo@gmx.de>,
        Philipp Rosenberger <p.rosenberger@kunbus.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH] net: linkwatch: ignore events for unregistered netdevs
Message-ID: <20220425211822.GA22629@wunner.de>
References: <18b3541e5372bc9b9fc733d422f4e698c089077c.1650177997.git.lukas@wunner.de>
 <9325d344e8a6b1a4720022697792a84e545fef62.camel@redhat.com>
 <20220423160723.GA20330@wunner.de>
 <20220425074146.1fa27d5f@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220425074146.1fa27d5f@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 25, 2022 at 07:41:46AM -0700, Jakub Kicinski wrote:
> On Sat, 23 Apr 2022 18:07:23 +0200 Lukas Wunner wrote:
> > > Looking at the original report it looks like the issue could be
> > > resolved with a more usb-specific change: e.g. it looks like
> > > usbnet_defer_kevent() is not acquiring a dev reference as it should.
> > > 
> > > Have you considered that path?  
> > 
> > First of all, the diffstat of the patch shows this is an opportunity
> > to reduce LoC as well as simplify and speed up device teardown.
> > 
> > Second, the approach you're proposing won't work if a driver calls
> > netif_carrier_on/off() after unregister_netdev().
> > 
> > It seems prudent to prevent such a misbehavior in *any* driver,
> > not just usbnet.  usbnet may not be the only one doing it wrong.
> > Jann pointed out that there are more syzbot reports related
> > to a UAF in linkwatch:
> > 
> > https://lore.kernel.org/netdev/?q=__linkwatch_run_queue+syzbot
> > 
> > Third, I think an API which schedules work, invisibly to the driver,
> > is dangerous and misguided.  If it is illegal to call
> > netif_carrier_on/off() for an unregistered but not yet freed netdev,
> > catch that in core networking code and don't expect drivers to respect
> > a rule which isn't even documented.
> 
> Doesn't mean we should make it legal. We can add a warning to catch
> abuses.

That would be inconsequent, considering that netif_carrier_on/off()
do not warn for a reg_state of NETREG_UNINITIALIZED.

Thanks,

Lukas
