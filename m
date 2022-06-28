Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AF90E55D43C
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 15:13:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245132AbiF1Fot (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jun 2022 01:44:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245128AbiF1For (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jun 2022 01:44:47 -0400
Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08B8C1CFEA;
        Mon, 27 Jun 2022 22:44:38 -0700 (PDT)
X-UUID: 2f6f6cecdcca40c5a588f0ae662acb32-20220628
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.7,REQID:472ae498-e919-464c-98ec-16bcb49ca63d,OB:0,LO
        B:0,IP:0,URL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,RULE:Release_Ham,ACTI
        ON:release,TS:0
X-CID-META: VersionHash:87442a2,CLOUDID:afcdf485-57f0-47ca-ba27-fe8c57fbf305,C
        OID:IGNORED,Recheck:0,SF:nil,TC:nil,Content:0,EDM:-3,IP:nil,URL:0,File:nil
        ,QS:nil,BEC:nil,COL:0
X-UUID: 2f6f6cecdcca40c5a588f0ae662acb32-20220628
Received: from mtkexhb01.mediatek.inc [(172.21.101.102)] by mailgw01.mediatek.com
        (envelope-from <biao.huang@mediatek.com>)
        (Generic MTA with TLSv1.2 ECDHE-RSA-AES256-SHA384 256/256)
        with ESMTP id 100667279; Tue, 28 Jun 2022 13:44:34 +0800
Received: from mtkcas11.mediatek.inc (172.21.101.40) by
 mtkmbs11n1.mediatek.inc (172.21.101.185) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.2.792.3;
 Tue, 28 Jun 2022 13:44:32 +0800
Received: from mhfsdcap04 (10.17.3.154) by mtkcas11.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Tue, 28 Jun 2022 13:44:31 +0800
Message-ID: <3f42845aafce14dcd96a83690fe296eb9eb6b50d.camel@mediatek.com>
Subject: Re: [PATCH net-next v3 09/10] net: ethernet: mtk-star-emac:
 separate tx/rx handling with two NAPIs
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
Date:   Tue, 28 Jun 2022 13:44:31 +0800
In-Reply-To: <20220623213431.23528544@kernel.org>
References: <20220622090545.23612-1-biao.huang@mediatek.com>
         <20220622090545.23612-10-biao.huang@mediatek.com>
         <20220623213431.23528544@kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-MTK:  N
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,T_SCC_BODY_TEXT_LINE,
        T_SPF_HELO_TEMPERROR,T_SPF_TEMPERROR,UNPARSEABLE_RELAY autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Dear Jakub,
	Thanks for your comments~

On Thu, 2022-06-23 at 21:34 -0700, Jakub Kicinski wrote:
> On Wed, 22 Jun 2022 17:05:44 +0800 Biao Huang wrote:
> > +	if (rx || tx) {
> > +		spin_lock_irqsave(&priv->lock, flags);
> > +		/* mask Rx and TX Complete interrupt */
> > +		mtk_star_disable_dma_irq(priv, rx, tx);
> > +		spin_unlock_irqrestore(&priv->lock, flags);
> 
> You do _irqsave / _irqrestore here
We should invoke spin_lock, no need save/store irq here.
> 
> > +		if (rx)
> > +			__napi_schedule_irqoff(&priv->rx_napi);
> > +		if (tx)
> > +			__napi_schedule_irqoff(&priv->tx_napi);
> 
> Yet assume _irqoff here.
> 
> So can this be run from non-IRQ context or not?
seems __napi_schedule is more proper for our case, we'll modify it in
next send.
> 
> > -	if (mtk_star_ring_full(ring))
> > +	if (unlikely(mtk_star_tx_ring_avail(ring) < MAX_SKB_FRAGS + 1))
> >  		netif_stop_queue(ndev);
> 
> Please look around other drivers (like ixgbe) and copy the way they
> handle safe stopping of the queues. You need to add some barriers and
> re-check after disabling.
Yes, we look drivers from other vendors, and will do similar thing in
next send.
> 
> > -	spin_unlock_bh(&priv->lock);
> > -
> >  	mtk_star_dma_resume_tx(priv);
> >  
> >  	return NETDEV_TX_OK;
> 
> 
> > +	while ((entry != head) && (count < MTK_STAR_RING_NUM_DESCS -
> > 1)) {
> >  
> 
> Parenthesis unnecessary, so is the empty line after the while ().
Yes, the empty line will be removed in next send.
> 
> >  		ret = mtk_star_tx_complete_one(priv);
> >  		if (ret < 0)
> >  			break;
> > +
> > +		count++;
> > +		pkts_compl++;
> > +		bytes_compl += ret;
> > +		entry = ring->tail;
> >  	}
> >  
> > +	__netif_tx_lock_bh(netdev_get_tx_queue(priv->ndev, 0));
> >  	netdev_completed_queue(ndev, pkts_compl, bytes_compl);
> > +	__netif_tx_unlock_bh(netdev_get_tx_queue(priv->ndev, 0));
> 
> what are you taking this lock for?
In this version, we encounter some issue related to
__QUEUE_STATE_STACK_OFF, 
and if we add __netif_tx_lock_bh here, it disappears.

When recieve your comments, we survey netdev_completed_queue handles in
drivers from other vendors, we beleive the __QUEUE_STATE_STACK_OFF
issue may caused by unproper usage of __napi_schedule_irqoff in
previous lines, and we'll remove __netif_tx_lock_bh, and have another
try.

If our local stress test pass, corresponding modification will be added
in next send.
> 
> > -	if (wake && netif_queue_stopped(ndev))
> > +	if (unlikely(netif_queue_stopped(ndev)) &&
> > +	    (mtk_star_tx_ring_avail(ring) > MTK_STAR_TX_THRESH))
> >  		netif_wake_queue(ndev);
> >  
> > -	spin_unlock(&priv->lock);
> > +	if (napi_complete(napi)) {
> > +		spin_lock_irqsave(&priv->lock, flags);
> > +		mtk_star_enable_dma_irq(priv, false, true);
> > +		spin_unlock_irqrestore(&priv->lock, flags);
> > +	}
> > +
> > +	return 0;
> >  }
> > @@ -1475,6 +1514,7 @@ static int mtk_star_set_timing(struct
> > mtk_star_priv *priv)
> >  
> >  	return regmap_write(priv->regs, MTK_STAR_REG_TEST0, delay_val);
> >  }
> > +
> >  static int mtk_star_probe(struct platform_device *pdev)
> >  {
> >  	struct device_node *of_node;
> 
> spurious whitespace change
Yes, will fix it in next send.

Best Regards!
Biao

