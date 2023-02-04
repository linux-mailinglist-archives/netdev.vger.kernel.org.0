Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7BCFB68AB93
	for <lists+netdev@lfdr.de>; Sat,  4 Feb 2023 18:14:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232745AbjBDROP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 Feb 2023 12:14:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232331AbjBDROO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 Feb 2023 12:14:14 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 444136594;
        Sat,  4 Feb 2023 09:13:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=yfwLdUV5OBNPu08HpkznU3dMK/3+zRMaw+qY8WlDfR4=; b=boU3IvUz5Lb9rtkdkCwc23U36U
        wDWsJEhJMCBxMf+siIQtrhN35p2pW7RHluKNeuaCeMP89luYV1RgZLiqCEA3gMssBzOIkCXgEt93x
        uHUAaqSVBDJ7f1Qdz/DfhLdGbofjeT5rKHUjj3Wct4VlJHmmLvPJX+ogcIvYFksrxDtI=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1pOM6g-0046AO-MB; Sat, 04 Feb 2023 18:13:42 +0100
Date:   Sat, 4 Feb 2023 18:13:42 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Daniel Golle <daniel@makrotopia.org>
Cc:     Vladimir Oltean <olteanv@gmail.com>, netdev@vger.kernel.org,
        linux-mediatek@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Russell King <linux@armlinux.org.uk>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        John Crispin <john@phrozen.org>, Felix Fietkau <nbd@nbd.name>,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jianhui Zhao <zhaojh329@gmail.com>,
        =?iso-8859-1?Q?Bj=F8rn?= Mork <bjorn@mork.no>
Subject: Re: [PATCH 9/9] net: dsa: mt7530: use external PCS driver
Message-ID: <Y96SRu4BFxNmaLjt@lunn.ch>
References: <cover.1675407169.git.daniel@makrotopia.org>
 <cover.1675407169.git.daniel@makrotopia.org>
 <677a5e37aab97a4f992d35c41329733c5f3082fb.1675407169.git.daniel@makrotopia.org>
 <677a5e37aab97a4f992d35c41329733c5f3082fb.1675407169.git.daniel@makrotopia.org>
 <20230203221915.tvg4rrjv5cnkshuf@skbuf>
 <Y95zaIJbCj3QIdqC@makrotopia.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y95zaIJbCj3QIdqC@makrotopia.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> The SerDes PCS units are only available for port 5 and 6. The code
> should make sure that the corresponding interface modes are only used
> on these two ports, so a BUG_ON(!mt753x_is_mac_port(port)) would also
> do the trick, I guess. However, as dsa_port_phylink_mac_select_pcs may
> also return ERR_PTR(-EOPNOTSUPP), returning ERR_PTR(-EINVAL) felt like
> the right thing to do in that case.
> Are you suggesting to use BUG_ON() instead or rather return
> ERR_PTR(-EOPNOTSUPP)?

BUG_ON() is considered to mean something which you cannot recover from
has happened, and going further will only cause more file system
corruption, memory corruption, etc. WARN_ON() is better, since it
gives the user a chance to perform a controlled shutdown, so
potentially not loosing files etc.

But even a WARN_ON() seems a bit extreme. If -EINVAL is sufficient to
cause either the whole device, or the port to fail to probe, that
should be enough to get the DT developers attention. Then either a
dev_err() or a dev_dbg() to help narrow down which check failed.

	  Andrew
