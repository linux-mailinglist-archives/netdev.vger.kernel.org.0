Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7987F6B957C
	for <lists+netdev@lfdr.de>; Tue, 14 Mar 2023 14:07:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232190AbjCNNHO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Mar 2023 09:07:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232000AbjCNNGz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Mar 2023 09:06:55 -0400
Received: from fudo.makrotopia.org (fudo.makrotopia.org [IPv6:2a07:2ec0:3002::71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90F0364267
        for <netdev@vger.kernel.org>; Tue, 14 Mar 2023 06:03:40 -0700 (PDT)
Received: from local
        by fudo.makrotopia.org with esmtpsa (TLS1.3:TLS_AES_256_GCM_SHA384:256)
         (Exim 4.96)
        (envelope-from <daniel@makrotopia.org>)
        id 1pc44R-0002yc-00;
        Tue, 14 Mar 2023 13:48:03 +0100
Date:   Tue, 14 Mar 2023 12:47:59 +0000
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
Subject: Re: [BUG] MTK SoC Ethernet throughput TX only ~620Mbit/s since
 6.2-rc1
Message-ID: <ZBBs/xE0+ULtJNIJ@makrotopia.org>
References: <trinity-92c3826f-c2c8-40af-8339-bc6d0d3ffea4-1678213958520@3c-app-gmx-bs16>
 <4a229d53-f058-115a-afc6-dd544a0dedf2@nbd.name>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4a229d53-f058-115a-afc6-dd544a0dedf2@nbd.name>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Felix,

On Tue, Mar 14, 2023 at 11:30:53AM +0100, Felix Fietkau wrote:
> On 07.03.23 19:32, Frank Wunderlich wrote:
> > Hi,
> > 
> > i've noticed that beginning on 6.2-rc1 the throughput on my Bananapi-R2 and Bananapi-R3 goes from 940Mbit/s down do 620Mbit/s since 6.2-rc1.
> > Only TX (from SBC PoV) is affected, RX is still 940Mbit/s.
> > 
> > i bisected this to this commit:
> > 
> > f63959c7eec3151c30a2ee0d351827b62e742dcb ("net: ethernet: mtk_eth_soc: implement multi-queue support for per-port queues")
> > 
> > Daniel reported me that this is known so far and they need assistance from MTK and i should report it officially.
> > 
> > As far as i understand it the commit should fix problems with clients using non-GBE speeds (10/100 Mbit/s) on the Gbit-capable dsa
> > interfaces (mt753x connected) behind the mac, but now the Gigabit speed is no more reached.
> > I see no CRC/dropped packets, retransmitts or similar.
> > 
> > after reverting the commit above i get 940Mbit like in rx direction, but this will introduce the problems mentioned above so this not a complete fix.
> I don't have a BPI-R2, but I tested on BPI-R3 and can't reproduce this
> issue. Do you see it on all ports, or only on specific ones?

I also can't reproduce this if unsing any of the gigE ports wired via
MT7531 on the R3. However, I can reproduce the issue if using a 1 GBit/s
SFP module in slot SFP1 of the R3 (connected directly to GMAC2/eth1).

Users have reported this also to be a problem also on MT7622 on devices
directly connecting a PHY (and not using MT7531).

In all cases, reverting the commit above fixes the issue.


Cheers


Daniel
