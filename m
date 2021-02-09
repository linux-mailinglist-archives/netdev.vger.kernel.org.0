Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E3504314DBC
	for <lists+netdev@lfdr.de>; Tue,  9 Feb 2021 12:04:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232276AbhBILAD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Feb 2021 06:00:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232103AbhBIK5a (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Feb 2021 05:57:30 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F27EC061794;
        Tue,  9 Feb 2021 02:56:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=qgjO/6O6/GHv5ONViL/FqI7BSwMcToNyR5mKAZxLc1o=; b=ekteLdyeIn9VGB/6gjGX30LkE
        +v2HdWGWFMllCW2pOoCzuoYT1R27oUhe53z7JtRXQyUtYfxYa6CJVWMt82KhFGyfdDq1MvqsFbfZj
        JGeGW6XO6oxQH+JM1eZBqcGcrcGBYeuKWMOFN59kFM3VkPvaywD5+DZMKRNdeIbvBQuEaMg7I0rqC
        5JqybgKTHQ75PFp+Q2mTSimNC3NcjIPnUFDhPsBJyIiivKxyCCsKY8wCHI+Wv8DIQU6PpV1HO8dRA
        phyEfTaJK2UXC1nOHC51wZhkcbDCeIcFROx3qGeF96hZl1kzYb+kO3qarhnrfYMu1T0BzczIZK+bP
        HzkPABXTA==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:41154)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1l9QhL-0003JT-Go; Tue, 09 Feb 2021 10:56:47 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1l9QhK-0003zb-Ca; Tue, 09 Feb 2021 10:56:46 +0000
Date:   Tue, 9 Feb 2021 10:56:46 +0000
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Serge Semin <Sergey.Semin@baikalelectronics.ru>,
        Jose Abreu <Jose.Abreu@synopsys.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Joao Pinto <Joao.Pinto@synopsys.com>,
        linux-kernel@vger.kernel.org,
        Alexandre Torgue <alexandre.torgue@st.com>,
        netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        Serge Semin <fancer.lancer@gmail.com>,
        Alexey Malahov <Alexey.Malahov@baikalelectronics.ru>,
        Jose Abreu <joabreu@synopsys.com>,
        Pavel Parkhomenko <Pavel.Parkhomenko@baikalelectronics.ru>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Vyacheslav Mitrofanov 
        <Vyacheslav.Mitrofanov@baikalelectronics.ru>,
        "David S. Miller" <davem@davemloft.net>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 01/20] net: phy: realtek: Fix events detection failure in
 LPI mode
Message-ID: <20210209105646.GP1463@shell.armlinux.org.uk>
References: <20210208140341.9271-1-Sergey.Semin@baikalelectronics.ru>
 <20210208140341.9271-2-Sergey.Semin@baikalelectronics.ru>
 <8300d9ca-b877-860f-a975-731d6d3a93a5@gmail.com>
 <20210209101528.3lf47ouaedfgq74n@mobilestation>
 <a652c69b-94d3-9dc6-c529-1ebc0ed407ac@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a652c69b-94d3-9dc6-c529-1ebc0ed407ac@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: Russell King - ARM Linux admin <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 09, 2021 at 11:37:29AM +0100, Heiner Kallweit wrote:
> Right, adding something like a genphy_{read,write}_mmd() doesn't make
> too much sense for now. What I meant is just exporting mmd_phy_indirect().
> Then you don't have to open-code the first three steps of a mmd read/write.
> And it requires no additional code in phylib.

... but at the cost that the compiler can no longer inline that code,
as I mentioned in my previous reply. (However, the cost of the accesses
will be higher.) On the plus side, less I-cache footprint, and smaller
kernel code.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
