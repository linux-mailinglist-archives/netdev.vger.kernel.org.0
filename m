Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0A1ED519147
	for <lists+netdev@lfdr.de>; Wed,  4 May 2022 00:21:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233477AbiECWVo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 May 2022 18:21:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243569AbiECWVj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 May 2022 18:21:39 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57B0B3EAB7
        for <netdev@vger.kernel.org>; Tue,  3 May 2022 15:18:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=+bltWWdYvDYxpY37tvq/Wgixud5JyrNy+vOhXBFIays=; b=hpDYdB9PYkhRWGP/cU0k16kvL9
        e+KfR7/yUhnuXGNGd10VH93Ix+8VovDVpy66ZcMSQkHsIkswZVgLyxlxI3cfMseh7btfYqstLeun1
        KW3kqte3lFwPIz4MGSFzt0XjVT5eh0tZ5DyY8CVPF9/kjaVfNx89aBcvlKdSxOSIUxHo=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1nm0qF-0016w6-U7; Wed, 04 May 2022 00:17:59 +0200
Date:   Wed, 4 May 2022 00:17:59 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Francesco Dolcini <francesco.dolcini@toradex.com>
Cc:     netdev@vger.kernel.org, Andy Duan <fugang.duan@nxp.com>,
        Joakim Zhang <qiangqing.zhang@nxp.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Fabio Estevam <festevam@gmail.com>,
        Tim Harvey <tharvey@gateworks.com>,
        Chris Healy <cphealy@gmail.com>
Subject: Re: FEC MDIO read timeout on linkup
Message-ID: <YnGqF4/040/Y9RjS@lunn.ch>
References: <20220422152612.GA510015@francesco-nb.int.toradex.com>
 <20220502170527.GA137942@francesco-nb.int.toradex.com>
 <YnAh9Q1lwz6Wu9R8@lunn.ch>
 <20220502183443.GB400423@francesco-nb.int.toradex.com>
 <20220503161356.GA35226@francesco-nb.int.toradex.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220503161356.GA35226@francesco-nb.int.toradex.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> I'm wondering could this be related to
> fec_enet_adjust_link()->fec_restart() during a fec_enet_mdio_read()
> and one of the many register write in fec_restart() just creates the
> issue, maybe while resetting the FEC? Does this makes any sense?

phylib is 'single threaded', in that only one thing will be active at
once for a PHY. While fec_enet_adjust_link() is being called, there
will not be any read/writes occurring for that PHY.

However, each PHY in the system runs on its own. If you have multiple
PHYs sharing one MDIO bus, or an Ethernet switch on the bus, they can
be doing read/writes at the same time.

The mdio bus has a lock which prevents actual transactions on the bus
at the same time. Nothing in phylib means that lock is held when
fec_enet_adjust_link() is called, so another PHY could be making MDIO
transfers. If fec_enet_adjust_link() is going to do bad things with
the MDIO bus master, it needs to hold the MDIO lock while doing it.

    Andrew
