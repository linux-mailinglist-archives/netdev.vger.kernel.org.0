Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 80F5651C48E
	for <lists+netdev@lfdr.de>; Thu,  5 May 2022 18:05:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242905AbiEEQJB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 May 2022 12:09:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378685AbiEEQIh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 May 2022 12:08:37 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F216F5C648
        for <netdev@vger.kernel.org>; Thu,  5 May 2022 09:04:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=VqKIX59XvWcLWxiDke+7WNsv5OCBPbLCau+e8XlNbYk=; b=TVTFixaDfwDfgOKXYDlpRDCDJ+
        Bq5aw057T8aZ9pBF8WLS6FvWgHQ5a8d5ZzlFasysA4pUkL8tUCkenIpacnNmT2ynk0pIHoAvDMeg6
        /k6W3P0MFKhv92Gxa8VVphV2TIhEebfySWyr1Yz6/OBlYm8EHM5UWbyKBL18ESBQFb6k=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1nmdy8-001Npx-B1; Thu, 05 May 2022 18:04:44 +0200
Date:   Thu, 5 May 2022 18:04:44 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Cc:     Arnd Bergmann <arnd@arndb.de>,
        Alexander Lobakin <alexandr.lobakin@intel.com>,
        Network Development <netdev@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Russell King <linux@armlinux.org.uk>,
        Felix Fietkau <nbd@nbd.name>,
        "openwrt-devel@lists.openwrt.org" <openwrt-devel@lists.openwrt.org>,
        Florian Fainelli <f.fainelli@gmail.com>
Subject: Re: Optimizing kernel compilation / alignments for network
 performance
Message-ID: <YnP1nOqXI4EO1DLU@lunn.ch>
References: <84f25f73-1fab-fe43-70eb-45d25b614b4c@gmail.com>
 <20220427125658.3127816-1-alexandr.lobakin@intel.com>
 <066fc320-dc04-11a4-476e-b0d11f3b17e6@gmail.com>
 <CAK8P3a2tA8vkB-G-sQdvoiB8Pj08LRn_Vhf7qT-YdBJQwaGhaA@mail.gmail.com>
 <eec5e665-0c89-a914-006f-4fce3f296699@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <eec5e665-0c89-a914-006f-4fce3f296699@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> you'll see that most used functions are:
> v7_dma_inv_range
> __irqentry_text_end
> l2c210_inv_range
> v7_dma_clean_range
> bcma_host_soc_read32
> __netif_receive_skb_core
> arch_cpu_idle
> l2c210_clean_range
> fib_table_lookup

There is a lot of cache management functions here. Might sound odd,
but have you tried disabling SMP? These cache functions need to
operate across all CPUs, and the communication between CPUs can slow
them down. If there is only one CPU, these cache functions get simpler
and faster.

It just depends on your workload. If you have 1 CPU loaded to 100% and
the other 3 idle, you might see an improvement. If you actually need
more than one CPU, it will probably be worse.

I've also found that some Ethernet drivers invalidate or flush too
much. If you are sending a 64 byte TCP ACK, all you need to flush is
64 bytes, not the full 1500 MTU. If you receive a TCP ACK, and then
recycle the buffer, all you need to invalidate is the size of the ACK,
so long as you can guarantee nothing has touched the memory above it.
But you need to be careful when implementing tricks like this, or you
can get subtle corruption bugs when you get it wrong.

    Andrew
