Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6C67E6CF003
	for <lists+netdev@lfdr.de>; Wed, 29 Mar 2023 18:58:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229629AbjC2Q6D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Mar 2023 12:58:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229495AbjC2Q6C (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Mar 2023 12:58:02 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9F3012E;
        Wed, 29 Mar 2023 09:58:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=R8xyMlTF2/FzYyTh03m+l1LnTI8sQSiRhFH5N5HuEpA=; b=ijkBTfVvZXrv6nBzfJPXW8aNUp
        qaivtLM5iW3QischbZkM2AG74yZB/cOKYygm6wv43rNgRkbbUjZQiXr5VoDVkX3cG/OjNq2XqEwaf
        a/8u2HlEoMobRswu8VKdSnVQFTMbn20ZojCrcQMh9aQZmfbd2fZJYuEDuDpDJ31Tua+c=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1phZ7S-008mlq-78; Wed, 29 Mar 2023 18:57:54 +0200
Date:   Wed, 29 Mar 2023 18:57:54 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Daniel Golle <daniel@makrotopia.org>
Cc:     netdev@vger.kernel.org, linux-mediatek@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Sam Shih <Sam.Shih@mediatek.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        John Crispin <john@phrozen.org>, Felix Fietkau <nbd@nbd.name>
Subject: Re: [RFC PATCH net-next v3 14/15] net: dsa: mt7530: introduce driver
 for MT7988 built-in switch
Message-ID: <8fe9c1b6-a533-4ad9-8a23-4f16547476ed@lunn.ch>
References: <cover.1680105013.git.daniel@makrotopia.org>
 <371f0586e257d098993847e71d0c916a03c04191.1680105013.git.daniel@makrotopia.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <371f0586e257d098993847e71d0c916a03c04191.1680105013.git.daniel@makrotopia.org>
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> @@ -18,6 +18,7 @@ enum mt753x_id {
>  	ID_MT7530 = 0,
>  	ID_MT7621 = 1,
>  	ID_MT7531 = 2,
> +	ID_MT7988 = 3,
>  };
>  
>  #define	NUM_TRGMII_CTRL			5
> @@ -54,11 +55,11 @@ enum mt753x_id {
>  #define  MT7531_MIRROR_PORT_SET(x)	(((x) & MIRROR_MASK) << 16)
>  #define  MT7531_CPU_PMAP_MASK		GENMASK(7, 0)
>  
> -#define MT753X_MIRROR_REG(id)		(((id) == ID_MT7531) ? \
> +#define MT753X_MIRROR_REG(id)		((((id) == ID_MT7531) || ((id) == ID_MT7988)) ?	\
>  					 MT7531_CFC : MT7530_MFC)
> -#define MT753X_MIRROR_EN(id)		(((id) == ID_MT7531) ? \
> +#define MT753X_MIRROR_EN(id)		((((id) == ID_MT7531) || ((id) == ID_MT7988)) ?	\
>  					 MT7531_MIRROR_EN : MIRROR_EN)
> -#define MT753X_MIRROR_MASK(id)		(((id) == ID_MT7531) ? \
> +#define MT753X_MIRROR_MASK(id)		((((id) == ID_MT7531) || ((id) == ID_MT7988)) ?	\
>  					 MT7531_MIRROR_MASK : MIRROR_MASK)

Are there more devices coming soon? I'm just wondering if these should
change into static inline functions with a switch statement? The
current code is not going to scale too much more.

	Andrew
