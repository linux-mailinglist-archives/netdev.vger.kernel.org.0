Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 84328F24E
	for <lists+netdev@lfdr.de>; Tue, 30 Apr 2019 10:56:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726700AbfD3I4I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Apr 2019 04:56:08 -0400
Received: from mailgw02.mediatek.com ([1.203.163.81]:24483 "EHLO
        mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725790AbfD3I4I (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Apr 2019 04:56:08 -0400
X-UUID: 660ccab875084f589928a94b3a8c365e-20190430
X-UUID: 660ccab875084f589928a94b3a8c365e-20190430
Received: from mtkcas35.mediatek.inc [(172.27.4.253)] by mailgw02.mediatek.com
        (envelope-from <biao.huang@mediatek.com>)
        (mailgw01.mediatek.com ESMTP with TLS)
        with ESMTP id 562232972; Tue, 30 Apr 2019 16:56:02 +0800
Received: from MTKCAS32.mediatek.inc (172.27.4.184) by MTKMBS31N1.mediatek.inc
 (172.27.4.69) with Microsoft SMTP Server (TLS) id 15.0.1395.4; Tue, 30 Apr
 2019 16:56:01 +0800
Received: from [10.17.3.153] (172.27.4.253) by MTKCAS32.mediatek.inc
 (172.27.4.170) with Microsoft SMTP Server id 15.0.1395.4 via Frontend
 Transport; Tue, 30 Apr 2019 16:56:00 +0800
Message-ID: <1556614560.24897.31.camel@mhfsdcap03>
Subject: RE: [PATCH 1/4] net: stmmac: update rx tail pointer register to fix
 rx dma hang issue.
From:   biao huang <biao.huang@mediatek.com>
To:     Jose Abreu <Jose.Abreu@synopsys.com>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-stm32@st-md-mailman.stormreply.com" 
        <linux-stm32@st-md-mailman.stormreply.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mediatek@lists.infradead.org" 
        <linux-mediatek@lists.infradead.org>,
        "yt.shen@mediatek.com" <yt.shen@mediatek.com>,
        "jianguo.zhang@mediatek.com" <jianguo.zhang@mediatek.com>
Date:   Tue, 30 Apr 2019 16:56:00 +0800
In-Reply-To: <78EB27739596EE489E55E81C33FEC33A0B46DDF0@DE02WEMBXB.internal.synopsys.com>
References: <1556518556-32464-1-git-send-email-biao.huang@mediatek.com>
         <1556518556-32464-2-git-send-email-biao.huang@mediatek.com>
         <78EB27739596EE489E55E81C33FEC33A0B46DDF0@DE02WEMBXB.internal.synopsys.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
X-MTK:  N
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 2019-04-29 at 08:51 +0000, Jose Abreu wrote:
> From: Biao Huang <biao.huang@mediatek.com>
> Date: Mon, Apr 29, 2019 at 07:15:53
> 
> > Currently we will not update the receive descriptor tail pointer in
> > stmmac_rx_refill. Rx dma will think no available descriptors and stop
> > once received packets exceed DMA_RX_SIZE, so that the rx only test will fail.
> > 
> > Update the receive tail pointer in stmmac_rx_refill to add more descriptors
> > to the rx channel, so packets can be received continually
> > 
> > Signed-off-by: Biao Huang <biao.huang@mediatek.com>
> > ---
> >  drivers/net/ethernet/stmicro/stmmac/stmmac_main.c |    3 +++
> >  1 file changed, 3 insertions(+)
> > 
> > diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
> > index 97c5e1a..818ad88 100644
> > --- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
> > +++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
> > @@ -3336,6 +3336,9 @@ static inline void stmmac_rx_refill(struct stmmac_priv *priv, u32 queue)
> >  		entry = STMMAC_GET_ENTRY(entry, DMA_RX_SIZE);
> >  	}
> >  	rx_q->dirty_rx = entry;
> > +	stmmac_set_rx_tail_ptr(priv, priv->ioaddr,
> > +			       rx_q->dma_rx_phy + (entry * sizeof(struct dma_desc)),
> 
> I think you can just use the "rx_q->rx_tail_addr" here. It'll always 
> trigger a poll demand for the channel.
Yes, will use rx_q->rx_tail_addr here.
> 
> Thanks,
> Jose Miguel Abreu


