Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 38B6E60E777
	for <lists+netdev@lfdr.de>; Wed, 26 Oct 2022 20:32:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234334AbiJZScP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Oct 2022 14:32:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234430AbiJZScE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Oct 2022 14:32:04 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 901898981E;
        Wed, 26 Oct 2022 11:30:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1666809047; x=1698345047;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=P1ms4vHmm30D+edws1J0E7ETBA/SgDrTVDF13xa5vSY=;
  b=ffmMpvJyc7PLbDALDYVXKzCXpJPrqbnK6ux6zu4KEnB76MEjPkNAR6QJ
   DdRM39J/lo5fAVF/nra+mxPURfCkM7opUZwDYWt4j1/WtEhuTgeUg2vrJ
   zsvjdrtk5e7reUpSPYwJc+KQq2sStY2nX+gspGOuxsmmDE7A+XR9WWBsG
   oyiXe+ssfwmY0HCn4ti9Ik2EcwwG6noAzzbbYDtNgmZ5raZT7CK3xMK9v
   HmBcCkGWLDOJh8Nux/o+ROx6PwbBDqc8JEBMeYrVq5tMp5IRUruNjzHRE
   Cdmz4ZPJ0pT9caBSuvls/gUH32YZRllzklqKK7GyUFaNMfuwrsIRgAXUs
   A==;
X-IronPort-AV: E=Sophos;i="5.95,215,1661842800"; 
   d="scan'208";a="197157707"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 26 Oct 2022 11:30:47 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Wed, 26 Oct 2022 11:30:47 -0700
Received: from localhost (10.10.115.15) by chn-vm-ex04.mchp-main.com
 (10.10.85.152) with Microsoft SMTP Server id 15.1.2507.12 via Frontend
 Transport; Wed, 26 Oct 2022 11:30:46 -0700
Date:   Wed, 26 Oct 2022 20:35:27 +0200
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <davem@davemloft.net>, <edumazet@google.com>, <pabeni@redhat.com>,
        <UNGLinuxDriver@microchip.com>
Subject: Re: [PATCH net 3/3] net: lan966x: Fix FDMA when MTU is changed
Message-ID: <20221026183527.z4zuihbk275gm4bi@soft-dev3-1>
References: <20221023184838.4128061-1-horatiu.vultur@microchip.com>
 <20221023184838.4128061-4-horatiu.vultur@microchip.com>
 <20221025193405.1c8f6e74@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <20221025193405.1c8f6e74@kernel.org>
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The 10/25/2022 19:34, Jakub Kicinski wrote:
> 
> On Sun, 23 Oct 2022 20:48:38 +0200 Horatiu Vultur wrote:
> > +             mtu = lan_rd(lan966x, DEV_MAC_MAXLEN_CFG(port->chip_port));
> 
> I'm slightly confused about the vlan situation, does this return the
> vlan hdr length when enabled?

No it doesn't.

> or vlans are always communicated out-of-band so don't need to count here?

Actually, the vlan hdr is actually in bound.
So there is a mistake in the code. The function lan966x_fdma_change_mtu
needs to take in consideration also the vlan header. It can have up to
two tags so it is needed twice.
Because if the vlan header is not taken in consideration, then there can
be a skb_panic when the frame is created in case there is no space
enough to put also the vlan header.

This can be reproduced with the following commands:
ip link set dev eth0 up
ip link set dev eth0 mtu 3794
ip link add name br0 type bridge vlan filtering
ip link set dev eth0 master br0
ip link set dev br0 up

Now send a frame with a the total size of 3816(contains ETH_HLEN + FCS +
VLAN_HELN).

> 
> Unrelated potential issue I spotted:
> 
>         skb = build_skb(page_address(page), PAGE_SIZE << rx->page_order);
>         if (unlikely(!skb))
>                 goto unmap_page;
> 
>         dma_unmap_single(lan966x->dev, (dma_addr_t)db->dataptr,
>                          FDMA_DCB_STATUS_BLOCKL(db->status),
>                          DMA_FROM_DEVICE);
> 
> Are you sure it's legal to unmap with a different length than you
> mapped? Seems questionable - you can unmap & ask the unmap to skip
> the sync, then sync manually only the part that you care about - if you
> want to avoid full sync.

That is really good observation. I have looked at some other drivers and
all of them actually unmap with the same length that they used when they
mapped the page.

But the order of the operations should be like this:

---
dma_sync_single_for_cpu(lan966x->dev, (dma_addr_t)db->dataptr,
			FDMA_DCB_STATUS_BLOCKL(db->status),
			DMA_FROM_DEVICE);
skb = build_skb(page_address(page), PAGE_SIZE << rx->page_order);
if (unlikely(!skb))
	goto unmap_page;

dma_unmap_single_attrs(lan966x->dev, (dma_addr_t)db->dataptr,
		       PAGE_SIZE << rx->page_order, DMA_FROM_DEVICE,
		       DMA_ATTR_SKIP_CPU_SYNC);
---

Because in this way, I get the data from HW, I build the skb with all
the initialization and then I unmapped without CPU sync because I have
already done that.

> 
> What made me pause here is that you build_skb() and then unmap which is
> also odd because normally (if unmap was passed full len) unmap could
> wipe what build_skb() initialized.

-- 
/Horatiu
