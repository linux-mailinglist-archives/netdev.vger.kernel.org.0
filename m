Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B6EB863DC09
	for <lists+netdev@lfdr.de>; Wed, 30 Nov 2022 18:33:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230019AbiK3Rdm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Nov 2022 12:33:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229986AbiK3Rdf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Nov 2022 12:33:35 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B61C27B1E;
        Wed, 30 Nov 2022 09:33:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=eWTp50vj1owXok9ZS3DmZfJ3/9+ZtfspBzxtU2pkiRI=; b=B1cSd1GkIITcC8/xA5aVHlM8+p
        1Rr1lANb/HDuYBAg8j9goKrN6bfsVoXW0be+Iu7cFOfiezpqDvY3JQu9C5Ej8FhOiPF64Od/rxQ6J
        pK27iZVpfVj3TM9Mar4tb38myxDjdItKcft9cKeB+SaeqpB0BioD28IQe5+oamHmxLJBiJkpaS65m
        UlkUCjpAciVEx+2rUbBRg5kbZcHP+chAA1JlV/W0rS0f3vJ0bIcA9JRnD+3v3diksD0BPu6R2BQBe
        TWRbzP/SG3zBhnJKVhPfrIesmWPo8IDvl9rzUBG6NpJj07Qbx8UXLg3oXU/qaSviFDHHP+FxC+X8b
        rmga18dQ==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:35504)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1p0QxT-0001zy-W9; Wed, 30 Nov 2022 17:33:20 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1p0QxP-0002fg-9t; Wed, 30 Nov 2022 17:33:15 +0000
Date:   Wed, 30 Nov 2022 17:33:15 +0000
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Frank <Frank.Sae@motor-comm.com>, Peter Geis <pgwipeout@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, yinghong.zhang@motor-comm.com,
        fei.zhang@motor-comm.com, hua.sun@motor-comm.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] net: phy: Add driver for Motorcomm yt8531
 gigabit ethernet phy
Message-ID: <Y4eT25bT7T8W6UXW@shell.armlinux.org.uk>
References: <20221130094928.14557-1-Frank.Sae@motor-comm.com>
 <Y4copjAzKpGSeunB@shell.armlinux.org.uk>
 <Y4eOkiaRywaUJa9n@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y4eOkiaRywaUJa9n@lunn.ch>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Andrew,

On Wed, Nov 30, 2022 at 06:10:42PM +0100, Andrew Lunn wrote:
> This is not the first time Russell has pointed out your locking is
> wrong.
> 
> How about adding a check in functions which should be called with the
> lock taken really do have the lock taken?

They already do:

        lockdep_assert_held_once(&bus->mdio_lock);

but I guess people just aren't testing their code with lockdep enabled.

The only other thing I can think of trying is to use mutex_trylock():

	if (WARN_ON_ONCE(mutex_trylock(&bus->mdio_lock)))
		mutex_unlock(&bus->mdio_lock);

scattered throughout.

However, if the author does have lockdep enabled but ignores the
warnings, that isn't going to help.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
