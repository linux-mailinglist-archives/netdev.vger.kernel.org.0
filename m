Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 43E556F3F68
	for <lists+netdev@lfdr.de>; Tue,  2 May 2023 10:44:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233894AbjEBIod (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 May 2023 04:44:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233761AbjEBIoa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 May 2023 04:44:30 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79E7D4C19
        for <netdev@vger.kernel.org>; Tue,  2 May 2023 01:44:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=fT4aRaj709FwTgCK59qkl0CvUDkbgbsNVg56AO1O4bY=; b=ccmdMpPXAoFG8W0Jg4Vbimsu9k
        yGtOuRIvJL5WtvntOljP90kkLVn1YFRNyVy9xHTHZPDd++j5Hqx/h9MX8Oxpo7ytwRXHy+tSbtAYn
        fFgBxtJaGKSIJ+zPfycLb5e4aLVEjjzvuVHQeml91xxaxE8OUQ7jNzpb9dPcBaY1AmShQz1BnjHOO
        4PYZZziUAI7PIPUlEd35ohad9j4pY32wIurQ0ZQOh+7umiy9EFBy428uEdkAnCw029SzhVWjW+Ali
        mli99PpnvYKine0atASW0jizbk1q7tbG6zFBclSu8vJgrs+r09+l24QHyDyt4z5HX1nm47mkvm3yJ
        YFgV24Ow==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:42676)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1ptlcX-00020N-2Z; Tue, 02 May 2023 09:44:25 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1ptlcV-0000Yl-C1; Tue, 02 May 2023 09:44:23 +0100
Date:   Tue, 2 May 2023 09:44:23 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Shmuel Hazan <shmuel.h@siklu.com>,
        "mw@semihalf.com" <mw@semihalf.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>
Subject: Re: [RFC PATCH] net: mvpp2: tai: add refcount for ptp worker
Message-ID: <ZFDNZ42DmdzrJAdp@shell.armlinux.org.uk>
References: <6806f01c8a6281a15495f5ead08c8b4403b1a581.camel@siklu.com>
 <69b2616d-dfeb-4e06-8f9b-60ced06cca00@lunn.ch>
 <43513e82fcdf84ce363abe31d6998b4f40aaa49f.camel@siklu.com>
 <fb41eeca-6a75-44cb-9b95-4f8b7ed052f2@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fb41eeca-6a75-44cb-9b95-4f8b7ed052f2@lunn.ch>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Apr 16, 2023 at 05:40:12PM +0200, Andrew Lunn wrote:
> On Sun, Apr 16, 2023 at 03:25:55PM +0000, Shmuel Hazan wrote:
> > On Sun, 2023-04-16 at 16:52 +0200, Andrew Lunn wrote:
> > > 
> > > > diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2_tai.c
> > > > b/drivers/net/ethernet/marvell/mvpp2/mvpp2_tai.c
> > > > index 95862aff49f1..1b57573dd866 100644
> > > > --- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_tai.c
> > > > +++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_tai.c
> > > > @@ -61,6 +61,7 @@ struct mvpp2_tai {
> > > >       u64 period;             // nanosecond period in 32.32 fixed
> > > > point
> > > >       /* This timestamp is updated every two seconds */
> > > >       struct timespec64 stamp;
> > > > +     u16 poll_worker_refcount;
> > > 
> > > What lock is protecting this? It would be nice to comment in the
> > > commit message why it is safe to use a simple u16.
> > 
> > Hi Andrew, 
> > 
> > thanks for your response. In theory, the only code path
> > to these functions (mvpp22_tai_start and mvpp22_tai_stop)
> > is ioctl (mvpp2_ioctl -> mvpp2_set_ts_config) which should lock
> > rtnl. However, 
> > It would probably be a good idea to also lock mvpp2_tai->lock too.
> 
> I cannot comment on what locks should be used, i don't know the code.
> 
> Which is why as a reviewer, i just want some indication you have
> thought about locking, and you think it is safe, given that there are
> not obvious locks in the code.

... and probably is a good idea to place a comment in the code stating
what the locking for it is.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 80Mbps down 10Mbps up. Decent connectivity at last!
