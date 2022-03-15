Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CB2C54D91DB
	for <lists+netdev@lfdr.de>; Tue, 15 Mar 2022 01:59:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344065AbiCOBBB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Mar 2022 21:01:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233143AbiCOBBA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Mar 2022 21:01:00 -0400
Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A65272AC69;
        Mon, 14 Mar 2022 17:59:45 -0700 (PDT)
X-UUID: b0f5c08aee674351a40c3cd27ab70739-20220315
X-UUID: b0f5c08aee674351a40c3cd27ab70739-20220315
Received: from mtkexhb02.mediatek.inc [(172.21.101.103)] by mailgw02.mediatek.com
        (envelope-from <biao.huang@mediatek.com>)
        (Generic MTA with TLSv1.2 ECDHE-RSA-AES256-SHA384 256/256)
        with ESMTP id 1162513404; Tue, 15 Mar 2022 08:59:38 +0800
Received: from mtkcas11.mediatek.inc (172.21.101.40) by
 mtkmbs10n1.mediatek.inc (172.21.101.34) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.2.792.15; Tue, 15 Mar 2022 08:59:36 +0800
Received: from mhfsdcap04 (10.17.3.154) by mtkcas11.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Tue, 15 Mar 2022 08:59:35 +0800
Message-ID: <b681a7e0abc76e196c6bc3afa14402af23bba454.camel@mediatek.com>
Subject: Re: [PATCH net-next v2 9/9] net: ethernet: mtk-star-emac: separate
 tx/rx handling with two NAPIs
From:   Biao Huang <biao.huang@mediatek.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     David Miller <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>,
        Bartosz Golaszewski <brgl@bgdev.pl>,
        Fabien Parent <fparent@baylibre.com>,
        Felix Fietkau <nbd@nbd.name>, John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        "Matthias Brugger" <matthias.bgg@gmail.com>,
        <netdev@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-mediatek@lists.infradead.org>,
        Yinghua Pan <ot_yinghua.pan@mediatek.com>,
        <srv_heupstream@mediatek.com>,
        Macpaul Lin <macpaul.lin@mediatek.com>
Date:   Tue, 15 Mar 2022 08:59:35 +0800
In-Reply-To: <20220314085705.32033308@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <20220127015857.9868-1-biao.huang@mediatek.com>
         <20220127015857.9868-10-biao.huang@mediatek.com>
         <20220127194338.01722b3c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
         <2bdb6c9b5ec90b6c606b7db8c13f8acb34910b36.camel@mediatek.com>
         <20220128074454.46d0ca29@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
         <2d0ab5290e63069f310987a4423ef2a46f02f1b3.camel@mediatek.com>
         <20220314085705.32033308@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-MTK:  N
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,RDNS_NONE,
        SPF_HELO_NONE,T_SCC_BODY_TEXT_LINE,T_SPF_TEMPERROR,UNPARSEABLE_RELAY
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Dear Jakub,
	Thanks for your comments~

On Mon, 2022-03-14 at 08:57 -0700, Jakub Kicinski wrote:
> On Mon, 14 Mar 2022 15:01:23 +0800 Biao Huang wrote:
> > > Drivers are expected to stop their queues at the end of xmit
> > > routine
> > > if
> > > the ring can't accommodate another frame. It's more efficient to
> > > stop
> > > the queues early than have to put skbs already dequeued from the
> > > qdisc
> > > layer back into the qdiscs.  
> > 
> > Yes, if descriptors ring is full, it's meaningful to stop the
> > queue 
> > at the end of xmit; 
> > But driver seems hard to know how many descriptors the next skb
> > will
> > request, e.g. 3 descriptors are available for next round send, but
> > the
> > next skb may need 4 descriptors, in this case, we still need judge
> > whether descriptors are enough for skb transmission, then decide
> > stop
> > the queue or not, at the beginning of xmit routine.
> > 
> > Maybe we should judge ring is full or not at the beginning and the
> > end
> > of xmit routine(seems a little redundancy).
> 
> Assume the worst case scenario. You set the default ring size to 512,
> skb can have at most MAX_SKB_FRAGS fragments (usually 17) so the max
> number of descriptors should not be very high, hard to pre-compute,
> or problematic compared to the total ring size.
Yes, we'll check the available descriptor number at the end of xmit
routine, and ensure it will larger than (MAX_SKB_FRAGS + 1) in next
send. (refer to stmmac_main.c)

Regards!

