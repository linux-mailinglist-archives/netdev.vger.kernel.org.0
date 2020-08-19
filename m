Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DABF62491CA
	for <lists+netdev@lfdr.de>; Wed, 19 Aug 2020 02:28:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726826AbgHSA2d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Aug 2020 20:28:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725554AbgHSA2d (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Aug 2020 20:28:33 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 019FAC061389
        for <netdev@vger.kernel.org>; Tue, 18 Aug 2020 17:28:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:Content-Type:
        MIME-Version:Date:Message-ID:Subject:Cc:From:To:Sender:Reply-To:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=KwdhtQts5HDAeq+f+K5Q6Pite/CTNR1iUA/0goTpEDU=; b=JmNnfZpVsyCjVVCdueIPL254Ns
        EOkYuKYjbVjBvkO6d418LbyXT+H5eYx2//OrlEM4qxVlTKTbq+ucxOVx89E89OcwqPdBn4gMF8QGr
        QRgnQFX4Fx1LDVogKxD2w3r0f5gQB8ebf3xvCd0IUbbwSZIbTke3L4fwSPpElZSyrJ6AdaxALAeQD
        PgxdB4QkdMXxEa+e3u7GXVhlXrFAUkg4IcMDp4sa2m4RpdQh5q+3GXZg9ghf2uvTF/QK4eE3wOZtO
        tybqScqdWqjDUaKHrJ3v8I9PPSMqEcJe8iXrC0pQZxHXav/nTxmY4sDx+3Zic3fH1jUwU994k6PQG
        3OwVONEg==;
Received: from [2601:1c0:6280:3f0::19c2]
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1k8Bxr-00040T-Lq; Wed, 19 Aug 2020 00:28:28 +0000
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
From:   Randy Dunlap <rdunlap@infradead.org>
Cc:     Michael Brown <mbrown@fensystems.co.uk>,
        Solarflare linux maintainers <linux-net-drivers@solarflare.com>,
        Edward Cree <ecree@solarflare.com>,
        Martin Habets <mhabets@solarflare.com>
Subject: ethernet/sfc/ warnings with 32-bit dma_addr_t
Message-ID: <f8f07f47-4ba9-4fd6-1d22-9559e150bc2e@infradead.org>
Date:   Tue, 18 Aug 2020 17:28:24 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

Does the drivers/net/ethernet/sfc/sfc driver require (expect)
dma_addr_t to be 64 bits (as opposed to 32 bits)?

I see that several #defines in ef100_regs.h are 64...

When used with DMA_BIT_MASK(64), does the value just need to be
truncated to 32 bits?  Will that work?


When I build this driver on i386 with 32-bit dma_addr_t, I see
the following build warnings:


  CC      drivers/net/ethernet/sfc/ef100.o
In file included from ../include/linux/skbuff.h:31:0,
                 from ../include/linux/if_ether.h:19,
                 from ../include/uapi/linux/ethtool.h:19,
                 from ../include/linux/ethtool.h:18,
                 from ../include/linux/netdevice.h:37,
                 from ../drivers/net/ethernet/sfc/net_driver.h:13,
                 from ../drivers/net/ethernet/sfc/ef100.c:12:
../drivers/net/ethernet/sfc/ef100.c: In function ‘ef100_pci_parse_continue_entry’:
../include/linux/dma-mapping.h:139:25: warning: large integer implicitly truncated to unsigned type [-Woverflow]
 #define DMA_BIT_MASK(n) (((n) == 64) ? ~0ULL : ((1ULL<<(n))-1))
                         ^
../drivers/net/ethernet/sfc/ef100.c:145:6: note: in expansion of macro ‘DMA_BIT_MASK’
      DMA_BIT_MASK(ESF_GZ_TX_SEND_ADDR_WIDTH),
      ^~~~~~~~~~~~
../include/linux/dma-mapping.h:139:25: warning: large integer implicitly truncated to unsigned type [-Woverflow]
 #define DMA_BIT_MASK(n) (((n) == 64) ? ~0ULL : ((1ULL<<(n))-1))
                         ^
../drivers/net/ethernet/sfc/ef100.c:163:6: note: in expansion of macro ‘DMA_BIT_MASK’
      DMA_BIT_MASK(ESF_GZ_TX_SEND_ADDR_WIDTH),
      ^~~~~~~~~~~~
../drivers/net/ethernet/sfc/ef100.c: In function ‘ef100_pci_parse_xilinx_cap’:
../include/linux/dma-mapping.h:139:25: warning: large integer implicitly truncated to unsigned type [-Woverflow]
 #define DMA_BIT_MASK(n) (((n) == 64) ? ~0ULL : ((1ULL<<(n))-1))
                         ^
../drivers/net/ethernet/sfc/ef100.c:337:5: note: in expansion of macro ‘DMA_BIT_MASK’
     DMA_BIT_MASK(ESF_GZ_TX_SEND_ADDR_WIDTH),
     ^~~~~~~~~~~~
../drivers/net/ethernet/sfc/ef100.c: In function ‘ef100_pci_probe’:
../include/linux/dma-mapping.h:139:25: warning: large integer implicitly truncated to unsigned type [-Woverflow]
 #define DMA_BIT_MASK(n) (((n) == 64) ? ~0ULL : ((1ULL<<(n))-1))
                         ^
../drivers/net/ethernet/sfc/ef100.c:498:5: note: in expansion of macro ‘DMA_BIT_MASK’
     DMA_BIT_MASK(ESF_GZ_TX_SEND_ADDR_WIDTH),
     ^~~~~~~~~~~~


thanks.
-- 
~Randy

