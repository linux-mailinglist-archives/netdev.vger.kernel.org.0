Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 94808F908C
	for <lists+netdev@lfdr.de>; Tue, 12 Nov 2019 14:23:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727187AbfKLNXS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Nov 2019 08:23:18 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:35702 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726188AbfKLNXS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 12 Nov 2019 08:23:18 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=EkOskIfrlI4bkz4+Vg1LatDiIG96BWRzkY/ggrPRwOw=; b=b2yL+wmOhtnmgb4EeBedjT/nTY
        dPTwwgAouo89wqS7BDa7kJivRsY2wymHv4kx2QZI1rhAViFN87AtxZtoEdbjuxu74AP6nL7+H27d0
        X0bJBgY/ZK9EtgAS/6z1qRwqwQs+kZvhc1KOZWMyHb2NFvtKOthiVfEaTA2s+v3mDt/0=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.92.2)
        (envelope-from <andrew@lunn.ch>)
        id 1iUW8V-0001S0-8d; Tue, 12 Nov 2019 14:23:11 +0100
Date:   Tue, 12 Nov 2019 14:23:11 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     David Miller <davem@redhat.com>
Cc:     olof@lixom.net, f.fainelli@gmail.com, hkallweit1@gmail.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: mdio-octeon: Fix pointer/integer casts
Message-ID: <20191112132311.GA5090@lunn.ch>
References: <20191111004211.96425-1-olof@lixom.net>
 <20191111.214658.1031500406952713920.davem@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191111.214658.1031500406952713920.davem@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 11, 2019 at 09:46:58PM -0800, David Miller wrote:
> From: Olof Johansson <olof@lixom.net>
> Date: Sun, 10 Nov 2019 16:42:11 -0800
> 
> > -static inline void oct_mdio_writeq(u64 val, u64 addr)
> > +static inline void oct_mdio_writeq(u64 val, void __iomem *addr)
> >  {
> > -	cvmx_write_csr(addr, val);
> > +	cvmx_write_csr((u64)addr, val);
> >  }
> 
> I hate stuff like this, I think you really need to fix this from the bottom
> up or similar.  MMIO and such addresses are __iomem pointers, period.

Yes, i agree, but did not want to push the work to Olof. The point of
COMPILE_TEST is to find issues like this, code which should be
architecture independent, but is not. The cast just papers over the
cracks.

At a minimum, could we fix the stub cvmx_write_csr() used for
everything !MIPS. That should hopefully fix everything !MIPS, but
cause MIPS to start issuing warning. The MIPS folks can then cleanup
their code, which is really what is broken here.

      Andrew
