Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D8A3F6E0AF7
	for <lists+netdev@lfdr.de>; Thu, 13 Apr 2023 12:01:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230161AbjDMKBk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Apr 2023 06:01:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229746AbjDMKBh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Apr 2023 06:01:37 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF0B77AA0;
        Thu, 13 Apr 2023 03:01:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1681380090; x=1712916090;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=uz4KE9ShWEG/KYQWIZ19a/8EmBDeITrEkJ7Sdq+pOqk=;
  b=IMljj3sR7wX4LDmmL/l3FBFBCnZQjyAZ/vSWQlM7ef7GZpLWmRCm7tzb
   uoJYn8vgLHZE5fyngqILz7EHlx038MfZoOasokwxs0uq5y4BcwvyzBUL4
   Tm3vjNQDoffStYfTxexwJfVGnfLXC8hTYpsxtSBgGcyi76j+BRnr5n/YV
   FAGi1WFPOym1yuXH3TLoge5OfLqH/Eerx5Oo+MBIhrqtWyZCahcCo9lHb
   E3SwEO1Wn+zZ0mRl9ZDaRlaE3/l7vbdGMgu4RlMI8VCp8FciHeZjSeiV/
   HmoP4OI94uZwaFlXuqEhNWFGxklRnOV9fVFH0/79x4vQMfHiotJEdeRtg
   Q==;
X-IronPort-AV: E=Sophos;i="5.98,341,1673938800"; 
   d="scan'208";a="220707414"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 13 Apr 2023 03:01:29 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Thu, 13 Apr 2023 03:01:29 -0700
Received: from localhost (10.10.115.15) by chn-vm-ex02.mchp-main.com
 (10.10.85.144) with Microsoft SMTP Server id 15.1.2507.21 via Frontend
 Transport; Thu, 13 Apr 2023 03:01:29 -0700
Date:   Thu, 13 Apr 2023 12:01:28 +0200
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     Zheng Wang <zyytlz.wz@163.com>
CC:     <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <hackerzheng666@gmail.com>,
        <1395428693sheep@gmail.com>, <alex000young@gmail.com>
Subject: Re: [PATCH net v2] net: ethernet: fix use after free bug in
 ns83820_remove_one due to race condition
Message-ID: <20230413100128.bcnqvdpu6hgilws4@soft-dev3-1>
References: <20230413071401.210599-1-zyytlz.wz@163.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <20230413071401.210599-1-zyytlz.wz@163.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The 04/13/2023 15:14, Zheng Wang wrote:

Hi Zheng,

> 
> In ns83820_init_one, dev->tq_refill was bound with queue_refill.
> 
> If irq happens, it will call ns83820_irq->ns83820_do_isr.
> Then it invokes tasklet_schedule(&dev->rx_tasklet) to start
> rx_action function. And rx_action will call ns83820_rx_kick
> and finally start queue_refill function.
> 
> If we remove the driver without finishing the work, there
> may be a race condition between ndev, which may cause UAF
> bug.
> 
> CPU0                  CPU1
> 
>                      |queue_refill
> ns83820_remove_one   |
> free_netdev                      |
> put_device                       |
> free ndev                        |
>                      |rx_refill
>                      |//use ndev

Will you not have the same issue if you remove the driver after you
schedule rx_tasklet? Because rx_action will use also ndev.

> 
> Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
> Signed-off-by: Zheng Wang <zyytlz.wz@163.com>
> ---
> v2:
> - cancel the work after unregister_netdev to make sure there
> is no more request suggested by Jakub Kicinski
> ---
>  drivers/net/ethernet/natsemi/ns83820.c | 5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/drivers/net/ethernet/natsemi/ns83820.c b/drivers/net/ethernet/natsemi/ns83820.c
> index 998586872599..2e84b9fcd8e9 100644
> --- a/drivers/net/ethernet/natsemi/ns83820.c
> +++ b/drivers/net/ethernet/natsemi/ns83820.c
> @@ -2208,8 +2208,13 @@ static void ns83820_remove_one(struct pci_dev *pci_dev)
> 
>         ns83820_disable_interrupts(dev); /* paranoia */
> 
> +       netif_carrier_off(ndev);
> +       netif_tx_disable(ndev);
> +
>         unregister_netdev(ndev);
>         free_irq(dev->pci_dev->irq, ndev);
> +       cancel_work_sync(&dev->tq_refill);
> +
>         iounmap(dev->base);
>         dma_free_coherent(&dev->pci_dev->dev, 4 * DESC_SIZE * NR_TX_DESC,
>                           dev->tx_descs, dev->tx_phy_descs);
> --
> 2.25.1
> 

-- 
/Horatiu
