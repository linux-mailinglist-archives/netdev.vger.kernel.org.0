Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6726451D813
	for <lists+netdev@lfdr.de>; Fri,  6 May 2022 14:43:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381087AbiEFMqs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 May 2022 08:46:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349759AbiEFMqr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 May 2022 08:46:47 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4E2BDF65
        for <netdev@vger.kernel.org>; Fri,  6 May 2022 05:43:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Transfer-Encoding:Content-Disposition:
        Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:From:
        Sender:Reply-To:Subject:Date:Message-ID:To:Cc:MIME-Version:Content-Type:
        Content-Transfer-Encoding:Content-ID:Content-Description:Content-Disposition:
        In-Reply-To:References; bh=8LhZtZ5ljXf7dhkfzgPu9NeYDgTqZZuEJIOuX2zNLBA=; b=Ty
        qF0uuI5fLVzD1xjkME9VmSXG9e6iKiiOyW72FdOoaQ4Sk/6ff7EUgpnXAkA169MuA2IkyrKqFZKzO
        hF3YwCBeHrwrgSSR5y/JS2BAMigqv6EWsv0Fl9cypHCrylMox4tk6ATb38H1Im4qPQH8Jw9fqDWPP
        8X95LxFoAlkK3hY=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1nmxIH-001WHI-J2; Fri, 06 May 2022 14:42:49 +0200
Date:   Fri, 6 May 2022 14:42:49 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Cc:     Felix Fietkau <nbd@nbd.name>, Arnd Bergmann <arnd@arndb.de>,
        Alexander Lobakin <alexandr.lobakin@intel.com>,
        Network Development <netdev@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Russell King <linux@armlinux.org.uk>,
        "openwrt-devel@lists.openwrt.org" <openwrt-devel@lists.openwrt.org>,
        Florian Fainelli <f.fainelli@gmail.com>
Subject: Re: Optimizing kernel compilation / alignments for network
 performance
Message-ID: <YnUXyQbLRn4BmJYr@lunn.ch>
References: <84f25f73-1fab-fe43-70eb-45d25b614b4c@gmail.com>
 <20220427125658.3127816-1-alexandr.lobakin@intel.com>
 <066fc320-dc04-11a4-476e-b0d11f3b17e6@gmail.com>
 <CAK8P3a2tA8vkB-G-sQdvoiB8Pj08LRn_Vhf7qT-YdBJQwaGhaA@mail.gmail.com>
 <eec5e665-0c89-a914-006f-4fce3f296699@gmail.com>
 <YnP1nOqXI4EO1DLU@lunn.ch>
 <2a338e8e-3288-859c-d2e8-26c5712d3d06@nbd.name>
 <04fa6560-e6f4-005f-cddb-7bc9b4859ba2@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <04fa6560-e6f4-005f-cddb-7bc9b4859ba2@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > I just took a quick look at the driver. It allocates and maps rx buffers that can cover a packet size of BGMAC_RX_MAX_FRAME_SIZE = 9724.
> > This seems rather excessive, especially since most people are going to use a MTU of 1500.
> > My proposal would be to add support for making rx buffer size dependent on MTU, reallocating the ring on MTU changes.
> > This should significantly reduce the time spent on flushing caches.
> 
> Oh, that's important too, it was changed by commit 8c7da63978f1 ("bgmac:
> configure MTU and add support for frames beyond 8192 byte size"):
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=8c7da63978f1672eb4037bbca6e7eac73f908f03
> 
> It lowered NAT speed with bgmac by 60% (362 Mbps → 140 Mbps).
> 
> I do all my testing with
> #define BGMAC_RX_MAX_FRAME_SIZE			1536

That helps show that cache operations are part of your bottleneck.

Taking a quick look at the driver. On the receive side:

                       /* Unmap buffer to make it accessible to the CPU */
                        dma_unmap_single(dma_dev, dma_addr,
                                         BGMAC_RX_BUF_SIZE, DMA_FROM_DEVICE);

Here is data is mapped read for the CPU to use it.

			/* Get info from the header */
                        len = le16_to_cpu(rx->len);
                        flags = le16_to_cpu(rx->flags);

                        /* Check for poison and drop or pass the packet */
                        if (len == 0xdead && flags == 0xbeef) {
                                netdev_err(bgmac->net_dev, "Found poisoned packet at slot %d, DMA issue!\n",
                                           ring->start);
                                put_page(virt_to_head_page(buf));
                                bgmac->net_dev->stats.rx_errors++;
                                break;
                        }

                        if (len > BGMAC_RX_ALLOC_SIZE) {
                                netdev_err(bgmac->net_dev, "Found oversized packet at slot %d, DMA issue!\n",
                                           ring->start);
                                put_page(virt_to_head_page(buf));
                                bgmac->net_dev->stats.rx_length_errors++;
                                bgmac->net_dev->stats.rx_errors++;
                                break;
                        }

                        /* Omit CRC. */
                        len -= ETH_FCS_LEN;

                        skb = build_skb(buf, BGMAC_RX_ALLOC_SIZE);
                        if (unlikely(!skb)) {
                                netdev_err(bgmac->net_dev, "build_skb failed\n");
                                put_page(virt_to_head_page(buf));
                                bgmac->net_dev->stats.rx_errors++;
                                break;
                        }
                        skb_put(skb, BGMAC_RX_FRAME_OFFSET +
                                BGMAC_RX_BUF_OFFSET + len);
                        skb_pull(skb, BGMAC_RX_FRAME_OFFSET +
                                 BGMAC_RX_BUF_OFFSET);

                        skb_checksum_none_assert(skb);
                        skb->protocol = eth_type_trans(skb, bgmac->net_dev);

and this is the first access of the actual data. You can make the
cache actually work for you, rather than against you, to adding a call to

	prefetch(buf);

just after the dma_unmap_single(). That will start getting the frame
header from DRAM into cache, so hopefully it is available by the time
eth_type_trans() is called and you don't have a cache miss.

	Andrew
