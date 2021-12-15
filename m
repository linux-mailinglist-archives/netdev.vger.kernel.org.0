Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 26ECE4763C9
	for <lists+netdev@lfdr.de>; Wed, 15 Dec 2021 21:55:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230099AbhLOUx4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Dec 2021 15:53:56 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:56738 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229668AbhLOUx4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Dec 2021 15:53:56 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AC60C61A11
        for <netdev@vger.kernel.org>; Wed, 15 Dec 2021 20:53:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3E2EC36AE2;
        Wed, 15 Dec 2021 20:53:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1639601635;
        bh=HPIJThYj6uVAjfV2lOT7lYiKCOBXS4GCGIi3gohtIvs=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=DmYc/SZQXH1Z43GhugrKxPj2tZtzek4Kpk1qWYYUB/RF1Lq30lHIhJorZ0XBRu5jN
         7oHh88wPVmETp7082qY+O0lJxGcfgKL2D0FmVxiU+LPUomsoi4aZfdc/yR8eW/md34
         QmjynNZRh9DcsdwnikI9CIxA6U8TnUOnX6lkNY2aDNVNOh2EXsbIhz3ua/vsCYZYVo
         jQxwwWXdvEH5Nvfn7dd8QmiGKQlXG0LGPbuuJLT8KnqUShCiD41frFKWhx2MpwWG+R
         NfO3R9vD+MnwaMx6yCbVoMj5kBO5gD2he/6s7KJw8ZiCEswufSJjPaMyUTRDzms2d/
         aNQ7a3cg9f+qg==
Date:   Wed, 15 Dec 2021 21:53:50 +0100
From:   Marek =?UTF-8?B?QmVow7pu?= <kabel@kernel.org>
To:     Holger Brunck <holger.brunck@hitachienergy.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>
Subject: Re: [v3 2/2] dsa: mv88e6xxx: make serdes SGMII/Fiber output
 amplitude configurable
Message-ID: <20211215215350.7a8b353a@thinkpad>
In-Reply-To: <AM0PR0602MB366630C33E7F36499BCD1C40F7769@AM0PR0602MB3666.eurprd06.prod.outlook.com>
References: <20211207190730.3076-1-holger.brunck@hitachienergy.com>
        <20211207190730.3076-2-holger.brunck@hitachienergy.com>
        <20211207202733.56a0cf15@thinkpad>
        <AM6PR0602MB3671CC1FE1D6685FE2A503A6F76F9@AM6PR0602MB3671.eurprd06.prod.outlook.com>
        <20211208162852.4d7361af@thinkpad>
        <AM6PR0602MB36717361A85C1B0CA8FE94D0F76F9@AM6PR0602MB3671.eurprd06.prod.outlook.com>
        <20211208171720.6a297011@thinkpad>
        <YbDkldWhZNDRkZDO@lunn.ch>
        <20211208181623.6cf39e15@thinkpad>
        <AM0PR0602MB366630C33E7F36499BCD1C40F7769@AM0PR0602MB3666.eurprd06.prod.outlook.com>
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 15 Dec 2021 10:27:02 +0000
Holger Brunck <holger.brunck@hitachienergy.com> wrote:

> Hi Marek,
> 
> > > This gets interesting when PCIe and USB needs to use this property,
> > > what names are used, and if it is possible to combine two different
> > > lists?  
> >
> > I don't think it is possible, I tried that once and couldn't get it to work.
> >
> > I am going to try write the proposal. But unfortunately PHY binding is not
> > converted to YAML yet :(
> >  
> 
> I saw you recent patches to convert this. Thanks!
> 
> This make my serdes.yaml obsolete then, correct? Should I then only re-post
> my driver code, once your patches are accepted?

Yes, please let's do it this way. It may take some time for Rob to
review this, though, and he may require some changes.

Also I was thinking whether it wouldn't be better to put the property
into a separate SerDes PHY node, i.e.

  switch {
    compatible = "marvell,mv88e6085";
    ...

    ports {
      port@6 {
        reg = <0x6>;
        phy-handle = <&switch_serdes_phy>;
      };

      ...
    };

    mdio {
      switch_serdes_phy: ethernet-phy@f {
        reg = <0xf>;
        tx-amplitude-microvolt = <1234567>;
      };

      ...
    };
  };
