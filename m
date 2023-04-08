Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C9F546DBDE0
	for <lists+netdev@lfdr.de>; Sun,  9 Apr 2023 00:50:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229535AbjDHWuV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 8 Apr 2023 18:50:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229448AbjDHWuU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 8 Apr 2023 18:50:20 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4EDFE273C
        for <netdev@vger.kernel.org>; Sat,  8 Apr 2023 15:50:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=Bg9upNIFCdjXksTwdUM6h1NF8ob/1RBy7F43ZTS3Ilg=; b=RD7Kp0Xsi2PF4nFNWLo9R31gsv
        qGniBpOviMgkr0ty/5AGocgxMPiFNCmDrabR11PhB59nFeevsyYNutz2MENdVZIjMuxVBm1re/v/8
        xBNGnOwxq5OW8AkBf9vt97GcMwTsMEuh6AhHaZoXPO0m9hQUh/pch8tS7gEf32GDPn5s=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1plHNt-009ojy-MB; Sun, 09 Apr 2023 00:50:13 +0200
Date:   Sun, 9 Apr 2023 00:50:13 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Geoff Levand <geoff@infradead.org>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexander Lobakin <aleksander.lobakin@intel.com>
Subject: Re: [PATCH net-next v1 2/2] net/ps3_gelic_net: Use napi routines for
 RX SKB
Message-ID: <9514a013-87fd-4dd9-b266-48f8855ff9b9@lunn.ch>
References: <cover.1680992691.git.geoff@infradead.org>
 <645368abb0e4c0c6afa2ed7f0e4ab7f932f1a2ba.1680992691.git.geoff@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <645368abb0e4c0c6afa2ed7f0e4ab7f932f1a2ba.1680992691.git.geoff@infradead.org>
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Apr 08, 2023 at 10:33:31PM +0000, Geoff Levand wrote:
> Convert the PS3 Gelic network driver's RX SK buffers over to
> use the napi_alloc_frag_align and napi_build_skb routines, and
> then cleanup with the skb_free_frag routine.

Hi Geoff

You might want to take a look at the buffer pool code. The Freescale
FEC driver was converted to it:

commit 95698ff6177b5f1f13f251da60e7348413046ae4
Author: Shenwei Wang <shenwei.wang@nxp.com>
Date:   Fri Sep 30 15:44:27 2022 -0500

    net: fec: using page pool to manage RX buffers
    
    This patch optimizes the RX buffer management by using the page
    pool. The purpose for this change is to prepare for the following
    XDP support. The current driver uses one frame per page for easy
    management.

Although the intention was to make XDP easier to add, the change
increased the performance of the driver in none XDP modes.

	  Andrew
