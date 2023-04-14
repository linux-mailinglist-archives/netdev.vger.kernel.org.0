Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB87C6E25C5
	for <lists+netdev@lfdr.de>; Fri, 14 Apr 2023 16:32:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230129AbjDNOcA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Apr 2023 10:32:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229647AbjDNOb6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Apr 2023 10:31:58 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36D2E196;
        Fri, 14 Apr 2023 07:31:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1681482711; x=1713018711;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=xPULitwJp6+DmysWFbEIuihcneSUosBP3Pul4LIysT8=;
  b=mQ73Ke7olemveOcUU5hIiMwEOYzCqPmh4uiAEAERJIvovsSLNYSTx4MJ
   JbLXIE/vGu/8Z5Bt/0SD0XfG6NHTGVF/1a1wNfrveiokjplBkRbidxzLP
   eT9LsDBETqa78eiyWO3Afz0WpD2n0vRZdzOgRRIO7wlytlyKR5TyNse5+
   NvnPcsLMcP6QZ8ihZzJ/vuYMJtFjex10+tSioV6GmLiQSJnqk2tcP3xMq
   wqFY7d3ftyS2014YQC4bpVvezst4yqh2pOAZ4bDEZJozQa4JPBfS9pvw4
   C5Bf76DNwI2vUuC0XbmcaNv8Ri0ZeBpfILsDpGnYtYg92F8nWgXrUSi+0
   w==;
X-IronPort-AV: E=Sophos;i="5.99,197,1677567600"; 
   d="scan'208";a="209115974"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 14 Apr 2023 07:31:50 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Fri, 14 Apr 2023 07:31:44 -0700
Received: from localhost (10.10.115.15) by chn-vm-ex03.mchp-main.com
 (10.10.85.151) with Microsoft SMTP Server id 15.1.2507.21 via Frontend
 Transport; Fri, 14 Apr 2023 07:31:44 -0700
Date:   Fri, 14 Apr 2023 16:31:44 +0200
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     Zheng Hacker <hackerzheng666@gmail.com>
CC:     Zheng Wang <zyytlz.wz@163.com>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <1395428693sheep@gmail.com>, <alex000young@gmail.com>
Subject: Re: [PATCH net v2] net: ethernet: fix use after free bug in
 ns83820_remove_one due to race condition
Message-ID: <20230414143144.2e5hf6iokcbcrf5a@soft-dev3-1>
References: <20230413071401.210599-1-zyytlz.wz@163.com>
 <20230413100128.bcnqvdpu6hgilws4@soft-dev3-1>
 <CAJedcCyLXuqMEWt6f+_HFEzAdgEcq5oQc-hRtt0k=rd_vrz6ew@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAJedcCyLXuqMEWt6f+_HFEzAdgEcq5oQc-hRtt0k=rd_vrz6ew@mail.gmail.com>
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,DKIM_INVALID,
        DKIM_SIGNED,RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        T_SCC_BODY_TEXT_LINE,T_SPF_TEMPERROR autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The 04/13/2023 18:49, Zheng Hacker wrote:

Hi Zheng,

> 
> Horatiu Vultur <horatiu.vultur@microchip.com> 于2023年4月13日周四 18:01写道：
> >
> > The 04/13/2023 15:14, Zheng Wang wrote:
> >
> > Hi Zheng,
> >
> > >
> > > In ns83820_init_one, dev->tq_refill was bound with queue_refill.
> > >
> > > If irq happens, it will call ns83820_irq->ns83820_do_isr.
> > > Then it invokes tasklet_schedule(&dev->rx_tasklet) to start
> > > rx_action function. And rx_action will call ns83820_rx_kick
> > > and finally start queue_refill function.
> > >
> > > If we remove the driver without finishing the work, there
> > > may be a race condition between ndev, which may cause UAF
> > > bug.
> > >
> > > CPU0                  CPU1
> > >
> > >                      |queue_refill
> > > ns83820_remove_one   |
> > > free_netdev                      |
> > > put_device                       |
> > > free ndev                        |
> > >                      |rx_refill
> > >                      |//use ndev
> >
> > Will you not have the same issue if you remove the driver after you
> > schedule rx_tasklet? Because rx_action will use also ndev.
> >
> 
> Hello Horatiu,
> 
> Thanks for your reply. In ns83820_remove_one, there is an invoking:
> 
> free_irq(dev->pci_dev->irq, ndev);
> 
> This will prevent the driver from handling more irq, But it couldn't prevent
> the rx_tasklet from being scheduled. So I think we should add the
> following code:
> 
> tasklet_kill(&dev->rx_tasklet);
> 
> after free_irq invoking. Is there anything wrong about my analysis?

I think you are right, I don't see a problem.

> 
> Thanks again for pointing the mistake out.
> 
> Best regards,
> Zheng
> 
> 
> > >
> > > Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
> > > Signed-off-by: Zheng Wang <zyytlz.wz@163.com>
> > > ---
> > > v2:
> > > - cancel the work after unregister_netdev to make sure there
> > > is no more request suggested by Jakub Kicinski
> > > ---
> > >  drivers/net/ethernet/natsemi/ns83820.c | 5 +++++
> > >  1 file changed, 5 insertions(+)
> > >
> > > diff --git a/drivers/net/ethernet/natsemi/ns83820.c b/drivers/net/ethernet/natsemi/ns83820.c
> > > index 998586872599..2e84b9fcd8e9 100644
> > > --- a/drivers/net/ethernet/natsemi/ns83820.c
> > > +++ b/drivers/net/ethernet/natsemi/ns83820.c
> > > @@ -2208,8 +2208,13 @@ static void ns83820_remove_one(struct pci_dev *pci_dev)
> > >
> > >         ns83820_disable_interrupts(dev); /* paranoia */
> > >
> > > +       netif_carrier_off(ndev);
> > > +       netif_tx_disable(ndev);
> > > +
> > >         unregister_netdev(ndev);
> > >         free_irq(dev->pci_dev->irq, ndev);
> > > +       cancel_work_sync(&dev->tq_refill);
> > > +
> > >         iounmap(dev->base);
> > >         dma_free_coherent(&dev->pci_dev->dev, 4 * DESC_SIZE * NR_TX_DESC,
> > >                           dev->tx_descs, dev->tx_phy_descs);
> > > --
> > > 2.25.1
> > >
> >
> > --
> > /Horatiu

-- 
/Horatiu
