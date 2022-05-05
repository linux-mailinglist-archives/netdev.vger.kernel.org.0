Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4DC6851C1F5
	for <lists+netdev@lfdr.de>; Thu,  5 May 2022 16:10:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380415AbiEEONK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 May 2022 10:13:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347604AbiEEONH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 May 2022 10:13:07 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D513F5A0B4;
        Thu,  5 May 2022 07:09:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=6Lmbk4iO3bAEj7owhMXQsEqPqr87gMH5In94FkOVBfw=; b=Aoqc9T79xRfKYVs3id4satwXyq
        zthalTtBJQEWrhGGjEiZ8LID9PItEJ8UPFI23dYGREnp3kQPPQXWx4ETJs0RgVlduyzoFsiwc4qcZ
        Dxt0BWtweS8zIeRBXEg0wRIywxyO7O+OvPIQ+bn5qfr+KxPsC0U00cUesUHbVIXlKQLk=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1nmcAE-001N3s-Tm; Thu, 05 May 2022 16:09:06 +0200
Date:   Thu, 5 May 2022 16:09:06 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Jiabing Wan <jiabing.wan@foxmail.com>
Cc:     Jiabing Wan <wanjiabing@vivo.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: phy: micrel: Remove unnecessary comparison in
 lan8814_handle_interrupt
Message-ID: <YnPagtJIZSt8oPJu@lunn.ch>
References: <20220505030217.1651422-1-wanjiabing@vivo.com>
 <YnO/VGKVHfFJG7/7@lunn.ch>
 <2ec61428-d9af-7712-b008-cf6b7e445aaa@vivo.com>
 <YnPHdzegs33G4JJ8@lunn.ch>
 <tencent_3A7D58D1E919ED045A0C40D4CE489320080A@qq.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <tencent_3A7D58D1E919ED045A0C40D4CE489320080A@qq.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> I write the coccicheck and find these reports:

Nice!

> For directly call __phy_read():
> 
> ./drivers/net/phy/micrel.c:1969:59-60: WARNING: __phy_read() assigned to an
> unsigned int 'data'

This one we know about.

> ./drivers/net/phy/mscc/mscc_macsec.c:49:50-51: WARNING: __phy_read()
> assigned to an unsigned int 'val'
> ./drivers/net/phy/mscc/mscc_macsec.c:52:51-52: WARNING: __phy_read()
> assigned to an unsigned int 'val_l'
> ./drivers/net/phy/mscc/mscc_macsec.c:53:51-52: WARNING: __phy_read()
> assigned to an unsigned int 'val_h'
> ./drivers/net/phy/mscc/mscc_macsec.c:89:50-51: WARNING: __phy_read()
> assigned to an unsigned int 'val'

These are all in the same function. Looking at the first check, it has
been decided that if something goes wrong, return 0. Not the best
solution, but better than returning something random. So the do/while
loop can goto failed: val_l and val_h are a bit more messy, but a
check would be nice, return 0 on error.

Actually returning an error code is not going to be easy. The rest of
the code assumes vsc8584_macsec_phy_read() never fails :-(

> ./drivers/net/phy/mscc/mscc_main.c:1511:50-51: WARNING: __phy_read()
> assigned to an unsigned int 'addr'
> ./drivers/net/phy/mscc/mscc_main.c:1514:47-48: WARNING: __phy_read()
> assigned to an unsigned int 'val'

More code which assumes a read can never fail. vsc8514_probe() calls
this, so it should be reasonable easy to catch the error, return it,
and make the probe fail.

> ./drivers/net/phy/mscc/mscc_main.c:366:54-55: WARNING: __phy_read() assigned
> to an unsigned int 'reg_val'
> ./drivers/net/phy/mscc/mscc_main.c:370:55-56: WARNING: __phy_read() assigned
> to an unsigned int 'pwd [ 0 ]'
> ./drivers/net/phy/mscc/mscc_main.c:371:53-54: WARNING: __phy_read() assigned
> to an unsigned int 'pwd [ 1 ]'
> ./drivers/net/phy/mscc/mscc_main.c:372:55-56: WARNING: __phy_read() assigned
> to an unsigned int 'pwd [ 2 ]'
> ./drivers/net/phy/mscc/mscc_main.c:317:54-55: WARNING: __phy_read() assigned
> to an unsigned int 'reg_val'

Another void function which assumes it cannot fail. Error checks would
be nice, don't return random data in the wol structure.

Thanks
	Andrew
