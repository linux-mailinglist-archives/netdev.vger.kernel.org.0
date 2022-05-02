Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 10EAA517673
	for <lists+netdev@lfdr.de>; Mon,  2 May 2022 20:21:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1386822AbiEBSYr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 May 2022 14:24:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238642AbiEBSYq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 May 2022 14:24:46 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A340A65A1
        for <netdev@vger.kernel.org>; Mon,  2 May 2022 11:21:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=erYGb63ZCu5CmvEC/xF+eVwLkOUEqtkM+RbcC2Zv7C0=; b=vxanIRSNkrfklf0jgUeLwwXbqg
        mRsS3xkreGRhiEd+c7S/hWODg9+2uqxlq5diN2C6UkiATFq+9F6aYox+JmxszLq8oBnl+dveFMMaD
        gmsS8IyS+3i549Mv0/nHO0oj6CYGyGNAptrLL6uTTJbi1hLLfMQRgINYNj8MczbttCMo=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1nlafW-000wBL-M4; Mon, 02 May 2022 20:21:10 +0200
Date:   Mon, 2 May 2022 20:21:10 +0200
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
Message-ID: <YnAhFse2h0vN1FCM@lunn.ch>
References: <20220422152612.GA510015@francesco-nb.int.toradex.com>
 <20220502170527.GA137942@francesco-nb.int.toradex.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220502170527.GA137942@francesco-nb.int.toradex.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Could it be that the issue is writing the MSCR in fec_restart(),
> `writel(fep->phy_speed, fep->hwp + FEC_MII_SPEED)`?
> 
> I do see the issue on link up/down event, when this function is actually
> called.
> 
> >From what I can understand from the previous history:
> 
>   1e6114f51f9d (net: fec: fix MDIO probing for some FEC hardware blocks, 2020-10-28) 
>   f166f890c8f0 (net: ethernet: fec: Replace interrupt driven MDIO with polled IO, 2020-05-02)
> 
> writing to this register could trigger a FEC_ENET_MII interrupt actually
> creating a race condition with fec_enet_mdio_read() that is called on
> link change also.

You should read the discussion from when this code was added.

Are you planning on adding:

       if (fep->quirks & FEC_QUIRK_CLEAR_SETUP_MII) {
                /* Clear MMFR to avoid to generate MII event by writing MSCR.
                 * MII event generation condition:
                 * - writing MSCR:
                 *      - mmfr[31:0]_not_zero & mscr[7:0]_is_zero &
                 *        mscr_reg_data_in[7:0] != 0
                 * - writing MMFR:
                 *      - mscr[7:0]_not_zero
                 */
                writel(0, fep->hwp + FEC_MII_DATA);
        }

To other locations which change FEC_MII_SPEED?

   Andrew
