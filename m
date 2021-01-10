Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 41B642F090D
	for <lists+netdev@lfdr.de>; Sun, 10 Jan 2021 19:33:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726559AbhAJScR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Jan 2021 13:32:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726263AbhAJScR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 10 Jan 2021 13:32:17 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B040C061786;
        Sun, 10 Jan 2021 10:31:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=4MrtpvUy4MSvMa9k/Wkk0LE7O9i3EdMj6jymHko/oc4=; b=Eu05WV+MUFwPEo6zgkPiRMhsZ
        nyHkOSp9O9UtL360XJCEXSXlRfaReo71RqjiComnF+9IM/WkPn7Ueyq371Fu7+11iiptbXkZ0EiPo
        jxteT/GMzpC4a/tFLqXvAOv1EJyAwo8pzsGY+WBFAEmMwgjmztEbJiwgVqe9lJTPz7sxWLRn1V9EI
        aPduoLnUzGKggh5bQYiTEhCyKCwGnq1Fzp0BfxMPzusOo5DjYYAQLhM9X97uTObnpldCWP2Jlj5fN
        J/mGIo9C4c/sHTXMVT+3kB3yBFIDd/SJ7rdpAqsM6k7FsDsMb+IpAjVknwwjVDpp2hEsGIiYlwffJ
        rRSetcNhg==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:46266)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1kyfV0-00066c-Hc; Sun, 10 Jan 2021 18:31:34 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1kyfUz-0004Qs-JF; Sun, 10 Jan 2021 18:31:33 +0000
Date:   Sun, 10 Jan 2021 18:31:33 +0000
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Stefan Chulski <stefanc@marvell.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "thomas.petazzoni@bootlin.com" <thomas.petazzoni@bootlin.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Nadav Haklai <nadavh@marvell.com>,
        Yan Markman <ymarkman@marvell.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "mw@semihalf.com" <mw@semihalf.com>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "atenart@kernel.org" <atenart@kernel.org>
Subject: Re: [EXT] Re: [PATCH RFC net-next  11/19] net: mvpp2: add flow
 control RXQ and BM pool config callbacks
Message-ID: <20210110183133.GM1551@shell.armlinux.org.uk>
References: <1610292623-15564-1-git-send-email-stefanc@marvell.com>
 <1610292623-15564-12-git-send-email-stefanc@marvell.com>
 <20210110180642.GH1551@shell.armlinux.org.uk>
 <CO6PR18MB387313CF1DB7B16D015043CCB0AC9@CO6PR18MB3873.namprd18.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CO6PR18MB387313CF1DB7B16D015043CCB0AC9@CO6PR18MB3873.namprd18.prod.outlook.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: Russell King - ARM Linux admin <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jan 10, 2021 at 06:24:30PM +0000, Stefan Chulski wrote:
> > >
> > > +/* Routine calculate single queue shares address space */ static int
> > > +mvpp22_calc_shared_addr_space(struct mvpp2_port *port) {
> > > +	/* If number of CPU's greater than number of threads, return last
> > > +	 * address space
> > > +	 */
> > > +	if (num_active_cpus() >= MVPP2_MAX_THREADS)
> > > +		return MVPP2_MAX_THREADS - 1;
> > > +
> > > +	return num_active_cpus();
> > 
> > Firstly - this can be written as:
> > 
> > 	return min(num_active_cpus(), MVPP2_MAX_THREADS - 1);
> 
> OK.
> 
> > Secondly - what if the number of active CPUs change, for example due to
> > hotplug activity. What if we boot with maxcpus=1 and then bring the other
> > CPUs online after networking has been started? The number of active CPUs is
> > dynamically managed via the scheduler as CPUs are brought online or offline.
> > 
> > > +/* Routine enable flow control for RXQs conditon */ void
> > > +mvpp2_rxq_enable_fc(struct mvpp2_port *port)
> > ...
> > > +/* Routine disable flow control for RXQs conditon */ void
> > > +mvpp2_rxq_disable_fc(struct mvpp2_port *port)
> > 
> > Nothing seems to call these in this patch, so on its own, it's not obvious how
> > these are being called, and therefore what remedy to suggest for
> > num_active_cpus().
> 
> I don't think that current driver support CPU hotplug, anyway I can
> remove  num_active_cpus and just use shared RX IRQ ID.

Sorry, but that is not really a decision the driver can make. It is
part of a kernel that _does_ support CPU hotplug, and the online
CPUs can be changed today.

It is likely that every distro out there builds the kernel with
CPU hotplug enabled.

If changing the online CPUs causes the driver to misbehave, that
is a(nother) bug with the driver.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
