Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E727B6C7F16
	for <lists+netdev@lfdr.de>; Fri, 24 Mar 2023 14:49:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231562AbjCXNtW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Mar 2023 09:49:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231215AbjCXNtU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Mar 2023 09:49:20 -0400
Received: from fudo.makrotopia.org (fudo.makrotopia.org [IPv6:2a07:2ec0:3002::71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F16481515C
        for <netdev@vger.kernel.org>; Fri, 24 Mar 2023 06:49:14 -0700 (PDT)
Received: from local
        by fudo.makrotopia.org with esmtpsa (TLS1.3:TLS_AES_256_GCM_SHA384:256)
         (Exim 4.96)
        (envelope-from <daniel@makrotopia.org>)
        id 1pfhmm-0006Oz-2c;
        Fri, 24 Mar 2023 14:48:52 +0100
Date:   Fri, 24 Mar 2023 13:47:10 +0000
From:   Daniel Golle <daniel@makrotopia.org>
To:     Felix Fietkau <nbd@nbd.name>
Cc:     Frank Wunderlich <frank-w@public-files.de>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        John Crispin <john@phrozen.org>,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>, netdev@vger.kernel.org,
        linux-mediatek@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: Aw: Re: [BUG] MTK SoC Ethernet throughput TX only ~620Mbit/s
 since 6.2-rc1
Message-ID: <ZB2p3kMLF2cWd8f/@makrotopia.org>
References: <trinity-92c3826f-c2c8-40af-8339-bc6d0d3ffea4-1678213958520@3c-app-gmx-bs16>
 <4a229d53-f058-115a-afc6-dd544a0dedf2@nbd.name>
 <ZBBs/xE0+ULtJNIJ@makrotopia.org>
 <trinity-b2506855-d27f-4e5c-bd20-d3768fa7505d-1679077409691@3c-app-gmx-bap25>
 <trinity-e199fc72-77d9-47f3-acb6-e11fbf66360b-1679144877213@3c-app-gmx-bs63>
 <4462a0c2-f7ea-c81c-e12f-ec629113fc40@nbd.name>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4462a0c2-f7ea-c81c-e12f-ec629113fc40@nbd.name>
X-Spam-Status: No, score=0.0 required=5.0 tests=SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Felix,
Hi Frank,

On Fri, Mar 24, 2023 at 12:52:09PM +0100, Felix Fietkau wrote:
> On 18.03.23 14:07, Frank Wunderlich wrote:
> > on BPI-R2 the eth0/gmac0 (tested with wan-port) is affected. here i have in TX-Direction only 620Mbit.
> > 
> > I have no idea yet why there the gmac0 is affected and on r3 only gmac1.
> > 
> > But it looks differently...on r3 the gmac1 is nearly completely broken.

If it looks "completely broken" as in you see only kilobits or even
complete starvation of RX, then you probably miss this fix:
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=193250ace270fecd586dd2d0dfbd9cbd2ade977f

> Please try this patch and let me know if it resolves the regression:
> 
> ---
> --- a/drivers/net/ethernet/mediatek/mtk_eth_soc.c
> +++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
> @@ -718,8 +718,6 @@ static void mtk_mac_link_up(struct phyli
>  		break;
>  	}
> -	mtk_set_queue_speed(mac->hw, mac->id, speed);
> -
>  	/* Configure duplex */
>  	if (duplex == DUPLEX_FULL)
>  		mcr |= MAC_MCR_FORCE_DPX;
> 
> 

I was about to suggest exactly this fix, and yes, it resolves the issue
and now I see full 1 Gbit/s speed on both, switch ports (even while 100M
connection is also used) and eth1 (via 1000Base-T SFP module).

Thank you for taking care of this!

