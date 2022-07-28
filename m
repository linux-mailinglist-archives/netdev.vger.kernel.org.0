Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 42DEA583F9B
	for <lists+netdev@lfdr.de>; Thu, 28 Jul 2022 15:08:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238755AbiG1NIG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jul 2022 09:08:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238518AbiG1NIE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Jul 2022 09:08:04 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CE0525E86;
        Thu, 28 Jul 2022 06:07:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=e2aRA4oShO3rcHQwn3d4gkYplDcEMSwuuAnIV3K8o2Q=; b=6Ub0R7uZ5U5TkIk5V1ocXPS0HH
        3gWNd7c02bhaCyypM1OIgyxaEN85a3Kj9nSfSOaKtH0pZyQUm1UUTeTUMG8w+y8qYx9LXuInvTopi
        Y7tbBC0tDMBD5Tj0WJgFPEJzI/B/6nKXOZB2kN8v8mQAeHT2sVT+O+t/5wL6tqsEHAHc=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1oH3F1-00Bo2q-Ey; Thu, 28 Jul 2022 15:07:51 +0200
Date:   Thu, 28 Jul 2022 15:07:51 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Antonio Quartulli <antonio@openvpn.net>
Cc:     netdev@vger.kernel.org, David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org
Subject: Re: [RFC 1/1] net: introduce OpenVPN Data Channel Offload (ovpn-dco)
Message-ID: <YuKKJxSFOgOL836y@lunn.ch>
References: <20220719014704.21346-1-antonio@openvpn.net>
 <20220719014704.21346-2-antonio@openvpn.net>
 <YtbNBUZ0Kz7pgmWK@lunn.ch>
 <c490b87c-085b-baca-b7e4-c67a3ee2c25e@openvpn.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c490b87c-085b-baca-b7e4-c67a3ee2c25e@openvpn.net>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 28, 2022 at 09:41:11AM +0200, Antonio Quartulli wrote:
> Hi,
> 
> On 19/07/2022 17:25, Andrew Lunn wrote:
> > > +static void ovpn_get_drvinfo(struct net_device *dev,
> > > +			     struct ethtool_drvinfo *info)
> > > +{
> > > +	strscpy(info->driver, DRV_NAME, sizeof(info->driver));
> > > +	strscpy(info->version, DRV_VERSION, sizeof(info->version));
> > > +	strscpy(info->bus_info, "ovpn", sizeof(info->bus_info));
> > 
> > version is generally considered useless information if it comes from
> > the driver. You have no idea if this is version 42 in net-next, or
> > some backported version in an enterprise kernel with lots of out of
> > tree patches. The driver is not standalone, it runs inside the
> > kernel. So in order to understand a bug report, you need to know what
> > kernel it is. If you don't fill in version, the core will with the
> > kernel version, which is much more useful.
> 
> True.
> 
> However, I guess I will still fill MODULE_VERSION() with a custom string.
> This may also be useful when building the module out-of-tree.

You could, but out of tree is even worse. You have even less idea what
environment the driver is running in, so the version is even less
meaningful. You need to ask be bug reported for even more information.

Also, using a mainline driver out of tree is not easy. The code will
make use of the latest APIs, and internal APIs are not stable, making
it hard to use in older kernels. So you end up with out of tree
wrapper code for whatever version of out of tree Linux you decide to
support. Take a look at

https://github.com/open-mesh-mirror/batman-adv

for an example of this.

    Andrew
