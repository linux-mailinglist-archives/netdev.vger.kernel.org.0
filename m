Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 002F560D953
	for <lists+netdev@lfdr.de>; Wed, 26 Oct 2022 04:34:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232528AbiJZCeL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Oct 2022 22:34:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229904AbiJZCeI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Oct 2022 22:34:08 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02120C8215;
        Tue, 25 Oct 2022 19:34:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 90EAA61C5A;
        Wed, 26 Oct 2022 02:34:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92DF8C433D6;
        Wed, 26 Oct 2022 02:34:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666751646;
        bh=FDVpsBRsUXGYnqYQqEWHdd0PZaotpM7jFC1LM+4IOLw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=OAyyyXn5NukoB3j8toWNaJABBy/S/5TntYG/CvvG+RTJandosqs6BmGEumXVTe1Lx
         ptLZGC8qB92wzZ1EUNFIKbkcGsFIbnX5/KczRb0eQl5Dv6Vd0JYRJDMX62QXQRd+O2
         Gq7HEILgUrK1di4fi9R7fLqfHYa/TJzE92dTnpZ9N2vRkYuQl4g0BVREKPFCwV0QCJ
         GghWRkDVVC3+/Qll9HISgFCZiIwKxIScuBoq2mI8cOnS8Epa9hxUxxnEKRMSsnmaP4
         iEuYDeF/3s2lnlsY7ppvPrBejDcVn6oMsgdjjz6S6ZOMmxDISMkfk7+Z+f9hI38vTF
         0Rh3uPv0wcfTQ==
Date:   Tue, 25 Oct 2022 19:34:05 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Horatiu Vultur <horatiu.vultur@microchip.com>
Cc:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <davem@davemloft.net>, <edumazet@google.com>, <pabeni@redhat.com>,
        <UNGLinuxDriver@microchip.com>
Subject: Re: [PATCH net 3/3] net: lan966x: Fix FDMA when MTU is changed
Message-ID: <20221025193405.1c8f6e74@kernel.org>
In-Reply-To: <20221023184838.4128061-4-horatiu.vultur@microchip.com>
References: <20221023184838.4128061-1-horatiu.vultur@microchip.com>
        <20221023184838.4128061-4-horatiu.vultur@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 23 Oct 2022 20:48:38 +0200 Horatiu Vultur wrote:
> +		mtu = lan_rd(lan966x, DEV_MAC_MAXLEN_CFG(port->chip_port));

I'm slightly confused about the vlan situation, does this return the
vlan hdr length when enabled? or vlans are always communicated
out-of-band so don't need to count here?

Unrelated potential issue I spotted:

        skb = build_skb(page_address(page), PAGE_SIZE << rx->page_order);       
        if (unlikely(!skb))                                                     
                goto unmap_page;                                                
                                                                                
        dma_unmap_single(lan966x->dev, (dma_addr_t)db->dataptr,                 
                         FDMA_DCB_STATUS_BLOCKL(db->status),                    
                         DMA_FROM_DEVICE);  

Are you sure it's legal to unmap with a different length than you
mapped? Seems questionable - you can unmap & ask the unmap to skip
the sync, then sync manually only the part that you care about - if you
want to avoid full sync.

What made me pause here is that you build_skb() and then unmap which is
also odd because normally (if unmap was passed full len) unmap could
wipe what build_skb() initialized.
