Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 74CAB517680
	for <lists+netdev@lfdr.de>; Mon,  2 May 2022 20:25:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1386857AbiEBS2Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 May 2022 14:28:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1386854AbiEBS2Y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 May 2022 14:28:24 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B71FC65C0
        for <netdev@vger.kernel.org>; Mon,  2 May 2022 11:24:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=7tGSiFBr/9K4/jKh47mhHErPc/vnY9sRdMy3yhrBXx8=; b=dJwGyu1QBn5d1CtA++07ajmgc8
        jwxwbmw5va1NFUZhIx1e8oxRbGnIime37qZISsSynO0vZqz91FmoS1nphVCXjTZQfGdzsnXUTRy6a
        aUCx4NOQVHIituwnJSACVFnyBknke5KG1ikUphq6c1cgpU/nYrj1Sg7+3tgGQZ2xpB1M=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1nlaj7-000wDt-TO; Mon, 02 May 2022 20:24:53 +0200
Date:   Mon, 2 May 2022 20:24:53 +0200
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
Message-ID: <YnAh9Q1lwz6Wu9R8@lunn.ch>
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

> writing to this register could trigger a FEC_ENET_MII interrupt actually
> creating a race condition with fec_enet_mdio_read() that is called on
> link change also.

Another point to consider:

static int fec_enet_mdio_wait(struct fec_enet_private *fep)
{
        uint ievent;
        int ret;

        ret = readl_poll_timeout_atomic(fep->hwp + FEC_IEVENT, ievent,
                                        ievent & FEC_ENET_MII, 2, 30000);

        if (!ret)
                writel(FEC_ENET_MII, fep->hwp + FEC_IEVENT);

        return ret;
}

An unexpected interrupt will make this exit too early, and the read
will get invalid data. An unexpected interrupt would not cause a
timeout here, which is what you are reporting.

	Andrew
