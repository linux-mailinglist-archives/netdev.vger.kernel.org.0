Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ECDFC5AFC45
	for <lists+netdev@lfdr.de>; Wed,  7 Sep 2022 08:18:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229677AbiIGGSA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Sep 2022 02:18:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229502AbiIGGR6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Sep 2022 02:17:58 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F51F9A979;
        Tue,  6 Sep 2022 23:17:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1662531475; x=1694067475;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=sq0si2PrDhOgtcIHs/t22Vqh4mT9XAr7UzcmO71dwEE=;
  b=1Bu4qU2IYr6UXLNugSjIjRAQAt8cs5JfLLzHIpd7fcvixK2+5bd6d2zM
   X48IhXuoQ8sxbysrZrm6sKHRJcIVjVtIjKDY8wrKBrjYKKyYmNrQjMjsN
   Rj+BTB3qTV3t6G2V6T8b27NJ63t7hQPHx/sNeov4V2tSMYL+CC42zpWhQ
   ILPdHP+x06X6D2LbllS8GeTRrd4DE6VSBxJ4ThqSUrjVtvhVVHpPZDw0w
   DzpJ6Vch9MykL/iscUQ4HUtFffaoRZkTGxqooW7IH2eEiCxgyZd1/cUQH
   1iJ+SzoIpt1u/r8LYKSIwxkMlfrEFgEAOr1nQje90Rq+z8bVWcTNaBuFd
   Q==;
X-IronPort-AV: E=Sophos;i="5.93,295,1654585200"; 
   d="scan'208";a="189742277"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 06 Sep 2022 23:17:53 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Tue, 6 Sep 2022 23:17:53 -0700
Received: from localhost (10.10.115.15) by chn-vm-ex02.mchp-main.com
 (10.10.85.144) with Microsoft SMTP Server id 15.1.2507.12 via Frontend
 Transport; Tue, 6 Sep 2022 23:17:50 -0700
Date:   Wed, 7 Sep 2022 11:47:49 +0530
From:   Raju Lakkaraju <Raju.Lakkaraju@microchip.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <davem@davemloft.net>,
        <linux-kernel@vger.kernel.org>, <bryan.whitehead@microchip.com>,
        <richardcochran@gmail.com>, <UNGLinuxDriver@microchip.com>,
        <Ian.Saturley@microchip.com>
Subject: Re: [PATCH net-next] net: lan743x: Fix the multi queue overflow issue
Message-ID: <20220907061749.GA14128@raju-project-pc>
References: <20220809083628.650493-1-Raju.Lakkaraju@microchip.com>
 <20220810223523.426b5e22@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <20220810223523.426b5e22@kernel.org>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jakub,

Thank you for review comments.
I accepted all your comments.
I will fix in V1 patch series and also change the subject line to 
"net: lan743x: Fix to use multiqueue start/stop APIs"

Thanks,
Raju
The 08/10/2022 22:35, Jakub Kicinski wrote:
> EXTERNAL EMAIL: Do not click links or open attachments unless you know the content is safe
> 
> On Tue, 9 Aug 2022 14:06:28 +0530 Raju Lakkaraju wrote:
> > Fix the Tx multi-queue overflow issue
> >
> > Tx ring size of 128 (for TCP) provides ability to handle way more data than
> > what Rx can (Rx buffers are constrained to one frame or even less during a
> > dynamic mtu size change)
> >
> > TX napi weight dependent of the ring size like it is now (ring size -1)
> > because there is an express warning in the kernel about not registering weight
> > values > NAPI_POLL_WEIGHT (currently 64)
> 
> I've read this message 3 times, I don't understand what you're saying.
> Could you please rewrite it and add necessary details?
> 
> > diff --git a/drivers/net/ethernet/microchip/lan743x_main.c b/drivers/net/ethernet/microchip/lan743x_main.c
> > index a9a1dea6d731..d7c14ee7e413 100644
> > --- a/drivers/net/ethernet/microchip/lan743x_main.c
> > +++ b/drivers/net/ethernet/microchip/lan743x_main.c
> > @@ -2064,8 +2064,10 @@ static void lan743x_tx_frame_end(struct lan743x_tx *tx,
> >  static netdev_tx_t lan743x_tx_xmit_frame(struct lan743x_tx *tx,
> >                                        struct sk_buff *skb)
> >  {
> > +     struct lan743x_adapter *adapter = tx->adapter;
> >       int required_number_of_descriptors = 0;
> >       unsigned int start_frame_length = 0;
> > +     netdev_tx_t retval = NETDEV_TX_OK;
> >       unsigned int frame_length = 0;
> >       unsigned int head_length = 0;
> >       unsigned long irq_flags = 0;
> > @@ -2083,9 +2085,13 @@ static netdev_tx_t lan743x_tx_xmit_frame(struct lan743x_tx *tx,
> >               if (required_number_of_descriptors > (tx->ring_size - 1)) {
> >                       dev_kfree_skb_irq(skb);
> >               } else {
> > -                     /* save to overflow buffer */
> > -                     tx->overflow_skb = skb;
> > -                     netif_stop_queue(tx->adapter->netdev);
> > +                     /* save how many descriptors we needed to restart the queue */
> > +                     tx->rqd_descriptors = required_number_of_descriptors;
> > +                     retval = NETDEV_TX_BUSY;
> > +                     if (is_pci11x1x_chip(adapter))
> > +                             netif_stop_subqueue(adapter->netdev, tx->channel_number);
> 
> Is tx->channel_number not 0 for devices other than pci11x1x ?
> netif_stop_queue() is just an alias for queue 0 IIRC so
> you can save all the ifs, most likely?
> 
Yes.
I will fix.

> > +                     else
> > +                             netif_stop_queue(adapter->netdev);
> >               }
> >               goto unlock;
> >       }
> > @@ -2093,7 +2099,7 @@ static netdev_tx_t lan743x_tx_xmit_frame(struct lan743x_tx *tx,
> >       /* space available, transmit skb  */
> >       if ((skb_shinfo(skb)->tx_flags & SKBTX_HW_TSTAMP) &&
> >           (tx->ts_flags & TX_TS_FLAG_TIMESTAMPING_ENABLED) &&
> > -         (lan743x_ptp_request_tx_timestamp(tx->adapter))) {
> > +         (lan743x_ptp_request_tx_timestamp(adapter))) {
> 
> If this is a fix you should hold off on refactoring like adding the
> local variable for adapter to make backports easier.
> 

Accepted.
I will fix.

> >               skb_shinfo(skb)->tx_flags |= SKBTX_IN_PROGRESS;
> >               do_timestamp = true;
> >               if (tx->ts_flags & TX_TS_FLAG_ONE_STEP_SYNC)
> 
> > @@ -1110,7 +1109,7 @@ struct lan743x_tx_buffer_info {
> >       unsigned int    buffer_length;
> >  };
> >
> > -#define LAN743X_TX_RING_SIZE    (50)
> > +#define LAN743X_TX_RING_SIZE    (128)
> 
> So the ring size is getting increased? I did not get that from the
> commit message at all :S

-- 
--------
Thanks,
Raju
