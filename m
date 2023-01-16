Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B46B266C405
	for <lists+netdev@lfdr.de>; Mon, 16 Jan 2023 16:35:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231553AbjAPPfR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Jan 2023 10:35:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230458AbjAPPem (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Jan 2023 10:34:42 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 098244EF9;
        Mon, 16 Jan 2023 07:32:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Transfer-Encoding:Content-Disposition:
        Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:From:
        Sender:Reply-To:Subject:Date:Message-ID:To:Cc:MIME-Version:Content-Type:
        Content-Transfer-Encoding:Content-ID:Content-Description:Content-Disposition:
        In-Reply-To:References; bh=QajF265tJ0WvkwuQz9gjguYri6Y5RnP6Kr8WpdzadyU=; b=o1
        Ao0LKkB6DMZq2hTu7weiDdpyHpNYITfKyZdvoTFXZfUrOO6GQSOhkvpJ5kP6RkdBhsxoE4BLlyGIS
        mI93lhuZ+e1U6pH7ldMxn8DIQWvPBd71xnCnF4yZeO8MHDxFArDaXpEmfVG/tekmKWOxn1xb6K+lj
        Q8ecZ/ibyw3Gboc=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1pHRTB-002F0G-7T; Mon, 16 Jan 2023 16:32:21 +0100
Date:   Mon, 16 Jan 2023 16:32:21 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Pierluigi Passaro <pierluigi.p@variscite.com>
Cc:     Pierluigi Passaro <pierluigi.passaro@gmail.com>,
        "wei.fang@nxp.com" <wei.fang@nxp.com>,
        "shenwei.wang@nxp.com" <shenwei.wang@nxp.com>,
        "xiaoning.wang@nxp.com" <xiaoning.wang@nxp.com>,
        "linux-imx@nxp.com" <linux-imx@nxp.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Eran Matityahu <eran.m@variscite.com>,
        Nate Drude <Nate.D@variscite.com>,
        Francesco Ferraro <francesco.f@variscite.com>
Subject: Re: [PATCH v2] net: fec: manage corner deferred probe condition
Message-ID: <Y8VuBbINetkFwQzY@lunn.ch>
References: <20230115213804.26650-1-pierluigi.p@variscite.com>
 <Y8R2kQMwgdgE6Qlp@lunn.ch>
 <CAJ=UCjXvcpV9gAfXv8An-pp=CK8J=sGE_adAoKeNFG1C-sMgJA@mail.gmail.com>
 <Y8STz5eOoSPfkMbU@lunn.ch>
 <AM6PR08MB43761CFA825A9B4A2E68D29EFFC19@AM6PR08MB4376.eurprd08.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AM6PR08MB43761CFA825A9B4A2E68D29EFFC19@AM6PR08MB4376.eurprd08.prod.outlook.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> This is the setup of the corner case:
> - FEC0 is the owner of MDIO bus, but its own PHY rely on a "delayed" GPIO
> - FEC1 rely on FEC0 for MDIO communications
> The sequence is something like this
> - FEC0 probe start, but being the reset GPIO "delayed" it return EPROBE_DEFERRED
> - FEC1 is successfully probed: being the MDIO bus still not owned, the driver assume
>   that the ownership must be assigned to the 1st one successfully probed, but no
>   MDIO node is actually present and no communication takes place.

So semantics of a phandle is that you expect what it points to, to
exists. So if phy-handle points to a PHY, when you follow that pointer
and find it missing, you should defer the probe. So this step should
not succeed.

> - FEC0 is successfully probed, but MDIO bus is now assigned to FEC1
>   and cannot  and no communication takes place

       Andrew
