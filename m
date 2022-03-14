Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0A2E84D88A0
	for <lists+netdev@lfdr.de>; Mon, 14 Mar 2022 16:57:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242615AbiCNP6U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Mar 2022 11:58:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234054AbiCNP6T (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Mar 2022 11:58:19 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2CC19403E5;
        Mon, 14 Mar 2022 08:57:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BA40C61307;
        Mon, 14 Mar 2022 15:57:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5AAA1C340E9;
        Mon, 14 Mar 2022 15:57:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647273427;
        bh=/rB6touVORwKOdNua1VLyFTBI38m6etM0LeyJRkf28I=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=lbnAbiB+xjtDfrTmBLaXAYV0gtMZi9Op4qc2ltgm1cEv8n6G4KIxXomoqHSWaULAO
         LjQIGlmHSernXc6PVtJmbUXfB7KeqA2jtNkS0fBMvDGPDNJZPKRvScjuqunoa5V0tx
         EBpQfls3GUeL8A4qVU/c7CtWOQOqudfnrrF3qM1zc7qHZ/IVRayFbKZNVkf623qzHX
         OmbIIALwcruJM1jt8LpHEdV/chD2JR9rinCrpDaNuK1XcLXOASi9kq5DssTAsvu0jr
         tT97BeNNgh7Rzrmc+PlBkUBQ2rSgc4iZQ8+ezp6HZMGJvb6iGa9rUSgn+zuUC1PPdW
         a90I4ankoPeSw==
Date:   Mon, 14 Mar 2022 08:57:05 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Biao Huang <biao.huang@mediatek.com>
Cc:     David Miller <davem@davemloft.net>,
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
Subject: Re: [PATCH net-next v2 9/9] net: ethernet: mtk-star-emac: separate
 tx/rx handling with two NAPIs
Message-ID: <20220314085705.32033308@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <2d0ab5290e63069f310987a4423ef2a46f02f1b3.camel@mediatek.com>
References: <20220127015857.9868-1-biao.huang@mediatek.com>
        <20220127015857.9868-10-biao.huang@mediatek.com>
        <20220127194338.01722b3c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <2bdb6c9b5ec90b6c606b7db8c13f8acb34910b36.camel@mediatek.com>
        <20220128074454.46d0ca29@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <2d0ab5290e63069f310987a4423ef2a46f02f1b3.camel@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 14 Mar 2022 15:01:23 +0800 Biao Huang wrote:
> > Drivers are expected to stop their queues at the end of xmit routine
> > if
> > the ring can't accommodate another frame. It's more efficient to stop
> > the queues early than have to put skbs already dequeued from the
> > qdisc
> > layer back into the qdiscs.  
> Yes, if descriptors ring is full, it's meaningful to stop the queue 
> at the end of xmit; 
> But driver seems hard to know how many descriptors the next skb will
> request, e.g. 3 descriptors are available for next round send, but the
> next skb may need 4 descriptors, in this case, we still need judge
> whether descriptors are enough for skb transmission, then decide stop
> the queue or not, at the beginning of xmit routine.
> 
> Maybe we should judge ring is full or not at the beginning and the end
> of xmit routine(seems a little redundancy).

Assume the worst case scenario. You set the default ring size to 512,
skb can have at most MAX_SKB_FRAGS fragments (usually 17) so the max
number of descriptors should not be very high, hard to pre-compute,
or problematic compared to the total ring size.
