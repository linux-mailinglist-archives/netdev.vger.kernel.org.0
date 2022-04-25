Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A1D9350E6E6
	for <lists+netdev@lfdr.de>; Mon, 25 Apr 2022 19:21:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243274AbiDYRXb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Apr 2022 13:23:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242858AbiDYRX3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Apr 2022 13:23:29 -0400
Received: from bmailout3.hostsharing.net (bmailout3.hostsharing.net [IPv6:2a01:4f8:150:2161:1:b009:f23e:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD373340EA;
        Mon, 25 Apr 2022 10:20:19 -0700 (PDT)
Received: from h08.hostsharing.net (h08.hostsharing.net [83.223.95.28])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256
         client-signature RSA-PSS (4096 bits) client-digest SHA256)
        (Client CN "*.hostsharing.net", Issuer "RapidSSL TLS DV RSA Mixed SHA256 2020 CA-1" (verified OK))
        by bmailout3.hostsharing.net (Postfix) with ESMTPS id F284E1032EE24;
        Mon, 25 Apr 2022 19:20:14 +0200 (CEST)
Received: by h08.hostsharing.net (Postfix, from userid 100393)
        id CB7C711767B; Mon, 25 Apr 2022 19:20:14 +0200 (CEST)
Date:   Mon, 25 Apr 2022 19:20:14 +0200
From:   Lukas Wunner <lukas@wunner.de>
To:     Jann Horn <jannh@google.com>
Cc:     Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Oliver Neukum <oneukum@suse.com>,
        "David S. Miller" <davem@davemloft.net>,
        Oleksij Rempel <o.rempel@pengutronix.de>,
        netdev <netdev@vger.kernel.org>,
        USB list <linux-usb@vger.kernel.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Jacky Chou <jackychou@asix.com.tw>, Willy Tarreau <w@1wt.eu>,
        Lino Sanfilippo <LinoSanfilippo@gmx.de>,
        Philipp Rosenberger <p.rosenberger@kunbus.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH] net: linkwatch: ignore events for unregistered netdevs
Message-ID: <20220425172014.GA24181@wunner.de>
References: <18b3541e5372bc9b9fc733d422f4e698c089077c.1650177997.git.lukas@wunner.de>
 <9325d344e8a6b1a4720022697792a84e545fef62.camel@redhat.com>
 <20220423160723.GA20330@wunner.de>
 <20220425074146.1fa27d5f@kernel.org>
 <CAG48ez3ibQjhs9Qxb0AAKE4-UZiZ5UdXG1JWcPWHAWBoO-1fVw@mail.gmail.com>
 <20220425080057.0fc4ef66@kernel.org>
 <CANn89iLwvqUJHBNifLESJyBQ85qjK42sK85Fs=QV4M7HqUXmxQ@mail.gmail.com>
 <CAG48ez0nw7coDXYozaUOTThWLkHWZuKVUpMosY2hgVSSfeM4Pw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAG48ez0nw7coDXYozaUOTThWLkHWZuKVUpMosY2hgVSSfeM4Pw@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 25, 2022 at 05:18:51PM +0200, Jann Horn wrote:
> Well, it's not quite a refcount. It's a count that can be incremented
> and decremented but can't be read while the device is alive, and then
> at some point it turns into a count that can be read and decremented
> but can't be incremented

Pardon me for being dense, but most other subsystems use the refcounting
built into struct device (or rather, its kobject) and tear it down
when the refcount reaches zero (e.g. pci_release_dev(), spidev_release()).

What's the rationale for struct net_device rolling its own refcounting?
Historic artifact?

I think a lot of these issues would solve themselves if that was done away
with and replaced with the generic kobject refcounting.  It's a pity that
the tracking infrastructure is now netdev-specific and other subsystems
cannot benefit from it.

Thanks,

Lukas
