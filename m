Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6C7B3665028
	for <lists+netdev@lfdr.de>; Wed, 11 Jan 2023 01:00:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235251AbjAKAAJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Jan 2023 19:00:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235398AbjAKAAF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Jan 2023 19:00:05 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B32555663;
        Tue, 10 Jan 2023 16:00:01 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E3830B81A1F;
        Tue, 10 Jan 2023 23:59:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6CF2C433EF;
        Tue, 10 Jan 2023 23:59:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673395198;
        bh=duw0LjoikfQ0dZpYavFL/CIJ3PpYay+YHMc35jB+yLo=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Aen/XKrrrdot2L0nFNnJCVlRWaJjhMlTHgIfEE1bbtMoW43S39iE0JCLaLqLKmF9u
         TLPWIaHzAUVbS8wujgQKuIow1cMsFjMEnclzMKQkkKbLm6uz/qt/iwB7Mo/9mLiHc/
         LPb/51M2Rbsg4mIiNQrGuaoHuSnn0vSrdUv14oCJ9+BjCHxfqwDrfxYACZ3PZSl4Rd
         lyMxy1YIBwAD8tylGlaE5Mt/zmnXxeSsr/vlMdCJSOKP5Bng0knu45jVXImBZM7hbo
         akZkuRcIljdPYnQR8lCJXw9KW447AB0/JgPZKvLxjyPVTg7IXF1MLR0Eb1WuvkTW+2
         5x4iV4a7gUB8w==
Date:   Tue, 10 Jan 2023 15:59:56 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Paolo Abeni <pabeni@redhat.com>
Cc:     Michael Walle <michael@walle.cc>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jose Abreu <Jose.Abreu@synopsys.com>,
        Sergey Shtylyov <s.shtylyov@omp.ru>,
        Wei Fang <wei.fang@nxp.com>,
        Shenwei Wang <shenwei.wang@nxp.com>,
        Clark Wang <xiaoning.wang@nxp.com>,
        NXP Linux Team <linux-imx@nxp.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, Andrew Lunn <andrew@lunn.ch>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: Re: [PATCH net-next v3 01/11] net: mdio: Add dedicated C45 API to
 MDIO bus drivers
Message-ID: <20230110155956.06941ea8@kernel.org>
In-Reply-To: <161fdffccb78fca2f16f1f5c78390420f60817b3.camel@redhat.com>
References: <20221227-v6-2-rc1-c45-seperation-v3-0-ade1deb438da@walle.cc>
        <20221227-v6-2-rc1-c45-seperation-v3-1-ade1deb438da@walle.cc>
        <5bd7ee34ead313785951defbf3069b64d4338a45.camel@redhat.com>
        <161fdffccb78fca2f16f1f5c78390420f60817b3.camel@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 10 Jan 2023 13:49:28 +0100 Paolo Abeni wrote:
> On Tue, 2023-01-10 at 12:16 +0100, Paolo Abeni wrote:
> > On Mon, 2023-01-09 at 16:30 +0100, Michael Walle wrote:  
> > > diff --git a/include/linux/phy.h b/include/linux/phy.h
> > > index 6378c997ded5..65844f0a7fb3 100644
> > > --- a/include/linux/phy.h
> > > +++ b/include/linux/phy.h
> > > @@ -364,6 +364,11 @@ struct mii_bus {
> > >  	int (*read)(struct mii_bus *bus, int addr, int regnum);
> > >  	/** @write: Perform a write transfer on the bus */
> > >  	int (*write)(struct mii_bus *bus, int addr, int regnum, u16 val);
> > > +	/** @read: Perform a C45 read transfer on the bus */  
> > 
> > Minor nit: s/@read/@read_c45/ 
> >   
> > > +	int (*read_c45)(struct mii_bus *bus, int addr, int devnum, int regnum);
> > > +	/** @write: Perform a C45 write transfer on the bus */  
> > 
> > Mutatis mutandis, same thing here.  
> 
> Otherwise the series LGTM. I think it would be preferable avoiding
> reposting a largish series like this for such a minor change. I think
> the series can be merged as-is and the above can be addressed with a
> follow-up patch.

Hmmm if we're doing special treatment I guess can as well fix this 
when applying. Save people who report warnings potential work.
