Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6815BDD69
	for <lists+netdev@lfdr.de>; Mon, 29 Apr 2019 10:09:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727608AbfD2IJ0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Apr 2019 04:09:26 -0400
Received: from mailgw02.mediatek.com ([1.203.163.81]:27987 "EHLO
        mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727471AbfD2IJ0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Apr 2019 04:09:26 -0400
X-UUID: 1a18ea539a324a15a23e18423d763b8a-20190429
X-UUID: 1a18ea539a324a15a23e18423d763b8a-20190429
Received: from mtkcas36.mediatek.inc [(172.27.4.253)] by mailgw02.mediatek.com
        (envelope-from <biao.huang@mediatek.com>)
        (mailgw01.mediatek.com ESMTP with TLS)
        with ESMTP id 801430977; Mon, 29 Apr 2019 16:09:16 +0800
Received: from MTKCAS36.mediatek.inc (172.27.4.186) by MTKMBS31DR.mediatek.inc
 (172.27.6.102) with Microsoft SMTP Server (TLS) id 15.0.1395.4; Mon, 29 Apr
 2019 16:09:14 +0800
Received: from [10.17.3.153] (172.27.4.253) by MTKCAS36.mediatek.inc
 (172.27.4.170) with Microsoft SMTP Server id 15.0.1395.4 via Frontend
 Transport; Mon, 29 Apr 2019 16:09:13 +0800
Message-ID: <1556525353.24897.30.camel@mhfsdcap03>
Subject: Re: [PATCH 2/6] net: stmmac: fix csr_clk can't be zero issue
From:   biao huang <biao.huang@mediatek.com>
To:     Alexandre Torgue <alexandre.torgue@st.com>
CC:     Jose Abreu <joabreu@synopsys.com>, <davem@davemloft.net>,
        "Giuseppe Cavallaro" <peppe.cavallaro@st.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        <netdev@vger.kernel.org>,
        <linux-stm32@st-md-mailman.stormreply.com>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>,
        <linux-mediatek@lists.infradead.org>, <yt.shen@mediatek.com>,
        <jianguo.zhang@mediatek.com>
Date:   Mon, 29 Apr 2019 16:09:13 +0800
In-Reply-To: <24f4b268-aa7f-e1f7-59fc-2bc163eb8277@st.com>
References: <1556433009-25759-1-git-send-email-biao.huang@mediatek.com>
         <1556433009-25759-3-git-send-email-biao.huang@mediatek.com>
         <24f4b268-aa7f-e1f7-59fc-2bc163eb8277@st.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
X-MTK:  N
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Mon, 2019-04-29 at 09:18 +0200, Alexandre Torgue wrote:
> Hi
> 
> On 4/28/19 8:30 AM, Biao Huang wrote:
> > The specific clk_csr value can be zero, and
> > stmmac_clk is necessary for MDC clock which can be set dynamically.
> > So, change the condition from plat->clk_csr to plat->stmmac_clk to
> > fix clk_csr can't be zero issue.
> > 
> > Signed-off-by: Biao Huang <biao.huang@mediatek.com>
> > ---
> >   drivers/net/ethernet/stmicro/stmmac/stmmac_main.c |    2 +-
> >   1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
> > index 818ad88..9e89b94 100644
> > --- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
> > +++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
> > @@ -4376,7 +4376,7 @@ int stmmac_dvr_probe(struct device *device,
> >   	 * set the MDC clock dynamically according to the csr actual
> >   	 * clock input.
> >   	 */
> > -	if (!priv->plat->clk_csr)
> > +	if (priv->plat->stmmac_clk)
> >   		stmmac_clk_csr_set(priv);
> >   	else
> >   		priv->clk_csr = priv->plat->clk_csr;
> > 
> 
> So, as soon as stmmac_clk will be declared, it is no longer possible to 
> fix a CSR through the device tree ?

let's focus on the condition:
1. clk_csr may be zero, it should not be the condition. or the clk_csr =
0 will jump to the wrong block.
2. Since stmmac_clk_csr_set will get_clk_rate from stmmac_clk,
the plat->stmmac_clk is a more proper condition.

In some case, it's impossible to get the clk rate of stmmac_clk,
so it's better to remain the clk_csr flow.



