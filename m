Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8FF45522944
	for <lists+netdev@lfdr.de>; Wed, 11 May 2022 03:57:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240882AbiEKB4u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 May 2022 21:56:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240920AbiEKB4r (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 May 2022 21:56:47 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6EEFF49F9A
        for <netdev@vger.kernel.org>; Tue, 10 May 2022 18:56:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 503A461AF8
        for <netdev@vger.kernel.org>; Wed, 11 May 2022 01:56:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50815C385D8;
        Wed, 11 May 2022 01:56:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652234201;
        bh=7yZV36WtPFqHQDRDwAbUHLODykS/IAbdPxZZVMb3wUw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=JtH4rFtNzEeaTv0dS2jGXrbDK32vHluxxKB8qbbOQYmnE1+4yR6AEz46NbC5yW84V
         AjIsaTPDJ3K3umMgUtg64NiWxoxxBMyDA7zl2AiqtnHspGisdoRcCA9ev4ztjx9f4q
         iYsBYt1BSBqJPouAoHM/3lD7FYDRGjaRJmbHdK2ucnqpC8E8jeIgfFm1oMTQmMmHk5
         Wd6sJD0LjK8nD0iClN1DG8SYEWBH5ckwnyZctP57jO0V/21OADI8okOexHbjhLYhNg
         587n/xpTKH3aQiHBaRRuhXh5EdKjgjpeYirf/zfIIiLrHQ4aJtVMQkMlCDkl8oBRgD
         QUIPiSr9XxK4Q==
Date:   Tue, 10 May 2022 18:56:39 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Robert Hancock <robert.hancock@calian.com>
Cc:     netdev@vger.kernel.org, radhey.shyam.pandey@xilinx.com,
        davem@davemloft.net, edumazet@google.com, pabeni@redhat.com,
        michal.simek@xilinx.com, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH net-next v5] net: axienet: Use NAPI for TX completion
 path
Message-ID: <20220510185639.1c6d6c8a@kernel.org>
In-Reply-To: <20220509173039.263172-1-robert.hancock@calian.com>
References: <20220509173039.263172-1-robert.hancock@calian.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon,  9 May 2022 11:30:39 -0600 Robert Hancock wrote:
> This driver was using the TX IRQ handler to perform all TX completion
> tasks. Under heavy TX network load, this can cause significant irqs-off
> latencies (found to be in the hundreds of microseconds using ftrace).
> This can cause other issues, such as overrunning serial UART FIFOs when
> using high baud rates with limited UART FIFO sizes.
> 
> Switch to using a NAPI poll handler to perform the TX completion work
> to get this out of hard IRQ context and avoid the IRQ latency impact.
> A separate poll handler is used for TX and RX since they have separate
> IRQs on this controller, so that the completion work for each of them
> stays on the same CPU as the interrupt.
> 
> Testing on a Xilinx MPSoC ZU9EG platform using iperf3 from a Linux PC
> through a switch at 1G link speed showed no significant change in TX or
> RX throughput, with approximately 941 Mbps before and after. Hard IRQ
> time in the TX throughput test was significantly reduced from 12% to
> below 1% on the CPU handling TX interrupts, with total hard+soft IRQ CPU
> usage dropping from about 56% down to 48%.
> 
> Signed-off-by: Robert Hancock <robert.hancock@calian.com>
> ---
> 
> Changed since v4: Added locking to protect TX ring tail pointer against
> concurrent access by TX transmit and TX poll paths.

Hi, sorry for a late reply there's just too many patches to look at
lately.

The lock is slightly concerning, the driver follows the usual wake up 
scheme based on memory barriers. If we add the lock we should probably
take the barriers out.

We can also try to avoid the lock and drill into what the issue is.
At a quick look it seems like there is a barrier missing between setup
of the descriptors and kicking the transfer off:

diff --git a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
index d6fc3f7acdf0..9e244b73a0ca 100644
--- a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
+++ b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
@@ -878,10 +878,11 @@ axienet_start_xmit(struct sk_buff *skb, struct net_device *ndev)
 	cur_p->skb = skb;
 
 	tail_p = lp->tx_bd_p + sizeof(*lp->tx_bd_v) * lp->tx_bd_tail;
-	/* Start the transfer */
-	axienet_dma_out_addr(lp, XAXIDMA_TX_TDESC_OFFSET, tail_p);
 	if (++lp->tx_bd_tail >= lp->tx_bd_num)
 		lp->tx_bd_tail = 0;
+	wmb(); // possibly dma_wmb()
+	/* Start the transfer */
+	axienet_dma_out_addr(lp, XAXIDMA_TX_TDESC_OFFSET, tail_p);
 
 	/* Stop queue if next transmit may not have space */
 	if (axienet_check_tx_bd_space(lp, MAX_SKB_FRAGS + 1)) {
