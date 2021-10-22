Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 20C0E43776A
	for <lists+netdev@lfdr.de>; Fri, 22 Oct 2021 14:51:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230519AbhJVMxq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Oct 2021 08:53:46 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:52374 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229842AbhJVMxp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 22 Oct 2021 08:53:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=qA1QSREbL+LNXCMCLcrPj0ob8I+E19DdMPB2HSLLjeI=; b=uR/3Xr6BHdhrXof2BhEmPlZ4kU
        qiYlmBcxjydDc85MFhH0FX/AgyO6tXR2l3X7IkbjEgvruXydtIm5vRCBmPS367GP0xErwSBAeS6mx
        nD6v6Sgi6XAqbrce+LmOWSR/lojZn8Nu/i60tSCj7hpjEMyj3G/ohT/4UPb+QZbTUIOg=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mdu10-00BNtA-VH; Fri, 22 Oct 2021 14:51:18 +0200
Date:   Fri, 22 Oct 2021 14:51:18 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Volodymyr Mytnyk <volodymyr.mytnyk@plvision.eu>
Cc:     kuba@kernel.org, mickeyr@marvell.com, serhiy.pshyk@plvision.eu,
        taras.chornyi@plvision.eu, Volodymyr Mytnyk <vmytnyk@marvell.com>,
        Vadym Kochan <vkochan@marvell.com>,
        Yevhen Orlov <yevhen.orlov@plvision.eu>,
        Taras Chornyi <tchornyi@marvell.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v3] net: marvell: prestera: add firmware v4.0
 support
Message-ID: <YXKzxvyZwsFmRaMf@lunn.ch>
References: <1634722349-23693-1-git-send-email-volodymyr.mytnyk@plvision.eu>
 <YXKuOSDraUsaN75U@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YXKuOSDraUsaN75U@lunn.ch>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 22, 2021 at 02:27:37PM +0200, Andrew Lunn wrote:
> On Wed, Oct 20, 2021 at 12:32:28PM +0300, Volodymyr Mytnyk wrote:
> > From: Volodymyr Mytnyk <vmytnyk@marvell.com>
> > 
> > Add firmware (FW) version 4.0 support for Marvell Prestera
> > driver.
> > 
> > Major changes have been made to new v4.0 FW ABI to add support
> > of new features, introduce the stability of the FW ABI and ensure
> > better forward compatibility for the future driver vesrions.
> > 
> > Current v4.0 FW feature set support does not expect any changes
> > to ABI, as it was defined and tested through long period of time.
> > The ABI may be extended in case of new features, but it will not
> > break the backward compatibility.
> > 
> > ABI major changes done in v4.0:
> > - L1 ABI, where MAC and PHY API configuration are split.
> > - ACL has been split to low-level TCAM and Counters ABI
> >   to provide more HW ACL capabilities for future driver
> >   versions.
> > 
> > To support backward support, the addition compatibility layer is
> > required in the driver which will have two different codebase under
> > "if FW-VER elif FW-VER else" conditions that will be removed
> > in the future anyway, So, the idea was to break backward support
> > and focus on more stable FW instead of supporting old version
> > with very minimal and limited set of features/capabilities.
>  
> > +/* TODO: add another parameters here: modes, etc... */
> > +struct prestera_port_phy_config {
> > +	bool admin;
> > +	u32 mode;
> > +	u8 mdix;
> > +};
> 
> > @@ -242,10 +246,44 @@ union prestera_msg_port_param {
> >  	u8  duplex;
> >  	u8  fec;
> >  	u8  fc;
> > -	struct prestera_msg_port_mdix_param mdix;
> > -	struct prestera_msg_port_autoneg_param autoneg;
> > +
> > +	union {
> > +		struct {
> > +			/* TODO: merge it with "mode" */
> 
> > +		struct {
> > +			/* TODO: merge it with "mode" */
> > +			u8 admin:1;
> > +			u8 adv_enable;
> > +			u64 modes;
> > +			/* TODO: merge it with modes */
> > +			u32 mode;
> > +			u8 mdix;
> > +		} phy;

Please can you also make use of __le64, __le32, __le16 in messages
to/from the firmware, so sparse etc can help you catch were you are
missing htonl(), htons() etc.

    Andrew
