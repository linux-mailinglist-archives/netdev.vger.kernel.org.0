Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9EE636E3986
	for <lists+netdev@lfdr.de>; Sun, 16 Apr 2023 16:52:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229732AbjDPOwd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 16 Apr 2023 10:52:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229672AbjDPOwc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 16 Apr 2023 10:52:32 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82B0E2114
        for <netdev@vger.kernel.org>; Sun, 16 Apr 2023 07:52:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=IvEtQhVlt1nEMAZGliKh0BaoqnF23+ji3BgpHqXink8=; b=kPNFdg881GrEYHvOP5z7uLFICb
        6oqN1ijDlCZU4m0A9B+YLe5auySxrxFGHBpgwzfyqyyIrwa4w5dIEOxYXd+vdDtLMXFZkFf58HO/l
        qGmlt0AODNhEOwpEw1p3zXVd2RRqYVWBfLhWehzyu32i8p4j0f96qj86xiXdB4nuCv20=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1po3ju-00AQqu-1J; Sun, 16 Apr 2023 16:52:26 +0200
Date:   Sun, 16 Apr 2023 16:52:26 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Shmuel Hazan <shmuel.h@siklu.com>
Cc:     "linux@armlinux.org.uk" <linux@armlinux.org.uk>,
        "mw@semihalf.com" <mw@semihalf.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>
Subject: Re: [RFC PATCH] net: mvpp2: tai: add refcount for ptp worker
Message-ID: <69b2616d-dfeb-4e06-8f9b-60ced06cca00@lunn.ch>
References: <6806f01c8a6281a15495f5ead08c8b4403b1a581.camel@siklu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6806f01c8a6281a15495f5ead08c8b4403b1a581.camel@siklu.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2_tai.c
> b/drivers/net/ethernet/marvell/mvpp2/mvpp2_tai.c
> index 95862aff49f1..1b57573dd866 100644
> --- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_tai.c
> +++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_tai.c
> @@ -61,6 +61,7 @@ struct mvpp2_tai {
>  	u64 period;		// nanosecond period in 32.32 fixed
> point
>  	/* This timestamp is updated every two seconds */
>  	struct timespec64 stamp;
> +	u16 poll_worker_refcount;

What lock is protecting this? It would be nice to comment in the
commit message why it is safe to use a simple u16.

       Andrew
