Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2C6016D505B
	for <lists+netdev@lfdr.de>; Mon,  3 Apr 2023 20:30:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233141AbjDCSaU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Apr 2023 14:30:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233038AbjDCSaT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Apr 2023 14:30:19 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9EF7A2D40
        for <netdev@vger.kernel.org>; Mon,  3 Apr 2023 11:30:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:Content-Type:MIME-Version:
        Message-ID:Subject:Cc:To:From:Date:Reply-To:Content-Transfer-Encoding:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=DY9bvv25MhNkG4m2LoFk1qeB2PUv3643fp9Bi8G8e/M=; b=gsi2i/jiLPdTfLRtCdCbiTUhUP
        VjcUQeoYaL+RWKEa+aYhgXjDK5jeCpnRUP4HaCIr9vewasnvsnBc4GeDYdviMlPAi9EVomuIwSXsH
        qPP8UfZ3NxznzfontqKq7+WRPUu7x5yTNgb92M1KWKdeXNCS9t91qL8EmzJSU8s0voROYjjvnbIyX
        P9YEIMyZHzSvkZsGg54bc6PsGXw1EjvjV6V80bnH91TU1OLt0IXRIDFNe6HuKFcWPDEppdxDw/yf8
        QOLZL37HZsifjlq8ZyLt+HCpsL85VBRN//CXpJd/DjAsTTNZ9yGEP0NU6dfkdyRYdxoQduOu9XuiQ
        wrHfL0JQ==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:39136)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1pjOwL-00037I-Pb; Mon, 03 Apr 2023 19:30:01 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1pjOwJ-0004TQ-UG; Mon, 03 Apr 2023 19:29:59 +0100
Date:   Mon, 3 Apr 2023 19:29:59 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Marek =?iso-8859-1?Q?Beh=FAn?= <kabel@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Paolo Abeni <pabeni@redhat.com>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>
Subject: [PATCH RFC net-next 0/6] net: mvneta: reduce size of TSO header
 allocation
Message-ID: <ZCsbJ4nG+So/n9qY@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

With reference to
https://forum.turris.cz/t/random-kernel-exceptions-on-hbl-tos-7-0/18865/

It appears that mvneta attempts an order-6 allocation for the TSO
header memory. While this succeeds early on in the system's life time,
trying order-6 allocations later can result in failure due to memory
fragmentation.

Firstly, the reason it's so large is that we take the number of
transmit descriptors, and allocate a TSO header buffer for each, and
each TSO header is 256 bytes. The driver uses a simple mechanism to
determine the address - it uses the transmit descriptor index as an
index into the TSO header memory.

	(The first obvious question is: do there need to be this
	many? Won't each TSO header always have at least one bit
	of data to go with it? In other words, wouldn't the maximum
	number of TSO headers that a ring could accept be the number
	of ring entries divided by 2?)

There is no real need for this memory to be an order-6 allocation,
since nothing in hardware requires this buffer to be contiguous.

Therefore, this series splits this order-6 allocation up into 32
order-1 allocations (8k pages on 4k page platforms), each giving
32 TSO headers per page.

In order to do this, these patches:

1) fix a horrible transmit path error-cleanup bug - the existing
   code unmaps from the first descriptor that was allocated at
   interface bringup, not the first descriptor that the packet
   is using, resulting in the wrong descriptors being unmapped.

2) since xdp support was added, we now have buf->type which indicates
   what this transmit buffer contains. Use this to mark TSO header
   buffers.

3) get rid of IS_TSO_HEADER(), instead using buf->type to determine
   whether this transmit buffer needs to be DMA-unmapped.

4) move tso_build_hdr() into mvneta_tso_put_hdr() to keep all the
   TSO header building code together.

5) split the TSO header allocation into chunks of order-1 pages.

 drivers/net/ethernet/marvell/mvneta.c | 166 +++++++++++++++++++++++-----------
 1 file changed, 115 insertions(+), 51 deletions(-)

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 80Mbps down 10Mbps up. Decent connectivity at last!
