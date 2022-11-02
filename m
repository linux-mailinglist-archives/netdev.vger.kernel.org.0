Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DD4D76156FB
	for <lists+netdev@lfdr.de>; Wed,  2 Nov 2022 02:27:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229933AbiKBB1G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Nov 2022 21:27:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229935AbiKBB1D (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Nov 2022 21:27:03 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9FE691FCE4;
        Tue,  1 Nov 2022 18:26:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=ByeRLxikMYM3ac/zYAwjbHrnz6wxVOIg1IVLvVaHMRU=; b=VXXWehq9WzJBIX74BuCCaQ/2c3
        qZ3Rzqevza6vojM2of3R/UGOD8gtT+DGPvDpHQ/BAPp754ld7gQqwkFYJj3UfGeA+uFDn0pF/b7Rk
        DnK9lNRCFD5SdpCxwkM1oxxf+YcLAWw5OBH+PzeuJYiz375yj2QHwVhWKV74VGn6TpKg=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1oq2WH-0019fw-Kb; Wed, 02 Nov 2022 02:26:17 +0100
Date:   Wed, 2 Nov 2022 02:26:17 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Daniel Golle <daniel@makrotopia.org>
Cc:     Felix Fietkau <nbd@nbd.name>, John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] net: ethernet: mediatek: ppe: add support for flow
 accounting
Message-ID: <Y2HHOSaYQGAhWL/E@lunn.ch>
References: <Y2G9ANkdaaENNnOd@makrotopia.org>
 <Y2G/CaPrTVsYeGWB@lunn.ch>
 <Y2HBzEdmiKK9IPFK@makrotopia.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y2HBzEdmiKK9IPFK@makrotopia.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 02, 2022 at 01:03:08AM +0000, Daniel Golle wrote:
> Hi Andrew,
> 
> On Wed, Nov 02, 2022 at 01:51:21AM +0100, Andrew Lunn wrote:
> > On Wed, Nov 02, 2022 at 12:42:40AM +0000, Daniel Golle wrote:
> > > The PPE units found in MT7622 and newer support packet and byte
> > > accounting of hw-offloaded flows. Add support for reading those
> > > counters as found in MediaTek's SDK[1].
> > > 
> > > [1]: https://git01.mediatek.com/plugins/gitiles/openwrt/feeds/mtk-openwrt-feeds/+/bc6a6a375c800dc2b80e1a325a2c732d1737df92
> > > Signed-off-by: Daniel Golle <daniel@makrotopia.org>
> > 
> > Sorry, but NACK.
> > 
> > You have not explained why doing this correctly via ethtool -S cannot
> > be done. debugfs is a vendor crap way of doing this.
> 
> The debugfs interface is pre-existing and **in addition** to the
> standard Linux interfaces which are also provided. It is true that
> the debugfs interface in this case doesn't provide much additional
> value apart from having the counter listed next to the hardware-
> specific hashtable keys. As the debugfs interface for now aims to
> be as complete as possible, naturally there is some redundance of
> things which can also be accessed using other (standard) interfaces.

debugfs is by definition unstable. It is not ABI. Anything using it is
expected to break in the near future when it changes its layout. It is
also totally option, you cannot expect it to be mounted.

I hope you don't have any user space code using it.

Maybe i should submit a patch which just for the fun of it rearranged
the order in debugfs and change the file name?

    Andrew
