Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B8050387557
	for <lists+netdev@lfdr.de>; Tue, 18 May 2021 11:41:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242524AbhERJnF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 May 2021 05:43:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240748AbhERJnE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 May 2021 05:43:04 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B4F4C061573
        for <netdev@vger.kernel.org>; Tue, 18 May 2021 02:41:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=wT0s4uUhHgQOK9ReyBbS9HPjXlWuGT/NPN/o67Cqkow=; b=jwde2OQbwdXG4yj6Yt8nwRU2R
        UFj6UhPcH53XbBtEbS3AYElE1m4KDOBWjFIeopSZzD56cMwhCNYM+a5HnjxzOQqNeq0A03fIRlGCS
        /18rNyUbNNTqD3dr2FNGLxtq1dXaJsCUyfzGbq7VqSjO++Mbwe2NQMf9F8bXppWb8XwTqEKX4tT5H
        Fh848EBLJRsNytz7yqbugkMA1Sw+vDRh3JxybeN47zlQzshAdjUzhIGOsYuV7AyOCs5WKv8z0VeeA
        i0m6rQ+zZK9cq999MvW8zCqi2K6G9zCdBVck5yOz1gMvP+6AjpVFZYksOGLz56qhKX4TQ6kAWPxHy
        3oBXg4bpw==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:44118)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1liwEJ-0003yT-8L; Tue, 18 May 2021 10:41:35 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1liwEI-0007mZ-7W; Tue, 18 May 2021 10:41:34 +0100
Date:   Tue, 18 May 2021 10:41:34 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Stefan Chulski <stefanc@marvell.com>
Cc:     Marcin Wojtas <mw@semihalf.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [EXT] mvpp2: incorrect max mtu?
Message-ID: <20210518094134.GQ12395@shell.armlinux.org.uk>
References: <20210514130018.GC12395@shell.armlinux.org.uk>
 <CO6PR18MB3873503C45634C7EBAE49AA4B02C9@CO6PR18MB3873.namprd18.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CO6PR18MB3873503C45634C7EBAE49AA4B02C9@CO6PR18MB3873.namprd18.prod.outlook.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 18, 2021 at 06:09:12AM +0000, Stefan Chulski wrote:
> Look like PPv2 tried scatter frame since it was larger than Jumbo buffer size and it drained buffer pool(Buffers never released).
> Received packet should be less than value set in MVPP2_POOL_BUF_SIZE_REG for long pool.

So this must mean that setting dev->max_mtu is incorrect.

From what I can see, the value programmed into that register would be
MVPP2_BM_JUMBO_PKT_SIZE which I believe is 9888. This is currently the
same value that dev->max_mtu is set to, but max_mtu is the data
payload size in the ethernet frame, which doesn't include the hardware
ethernet header.

So, should max_mtu be set to 14 bytes less? Or should it be set to
9856? Less 14 bytes? Or what?

It is really confusing that we have these definitions that state e.g.
that JUMBO_FRAME_SIZE is 10432 but the frame size comment says 9856.
It's not clear why it's different like that - why the additional 576
octets.

All of this could do with some explanation in the driver - would it be
possible to add some kind of documentation, or at least make the
definitions around packet and frame size more understandable please?

Thanks.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
