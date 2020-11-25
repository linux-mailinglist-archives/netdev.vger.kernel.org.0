Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED66E2C467B
	for <lists+netdev@lfdr.de>; Wed, 25 Nov 2020 18:09:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732658AbgKYRHl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Nov 2020 12:07:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730653AbgKYRHk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Nov 2020 12:07:40 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14065C0613D4;
        Wed, 25 Nov 2020 09:07:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:
        Content-Transfer-Encoding:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Reply-To:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=OMSN3bVHjMv7vKaV6DqN9uaT7htqeGYHppfGfEgyak4=; b=izvc4kvl+GJKxr/C9b6YCgPhV
        pxPKNfUO8V15Qjyg/0liNvzNU5/Bcjvxyi1WjyNakY8aUvr2jv6xQU3YCCfAQq2GeEQ6W2rY65k7C
        MNavth1EFSDaom2OjMlrEE069IKqKCbK/FzJ3odo5VKuSvNBLtP+vYpK595RET6YnB1KR7PKb/95N
        MAEvqYolGIn3JXYEt8JSkGdAoE+dWLapiyzZrr4US9xr3Lp3XH0in5oIYb9WvKDhtoxzpAFYHdWFa
        O802Mun5Lo+3R20ZX5ek/l0z9B90ZKLERMvsl5v+7oVVDQ5UltSUBnmJ2bkp8zZypV9RsOErIIjus
        6QzTKg5Jw==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:35984)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1khyGN-0000rp-9v; Wed, 25 Nov 2020 17:07:27 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1khyGA-00004x-D7; Wed, 25 Nov 2020 17:07:14 +0000
Date:   Wed, 25 Nov 2020 17:07:14 +0000
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Yonglong Liu <liuyonglong@huawei.com>
Cc:     Antonio Borneo <antonio.borneo@st.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Willy Liu <willy.liu@realtek.com>,
        linux-kernel@vger.kernel.org, Salil Mehta <salil.mehta@huawei.com>,
        linuxarm@huawei.com, linux-stm32@st-md-mailman.stormreply.com
Subject: Re: [PATCH v3 net-next] net: phy: realtek: read actual speed on
 rtl8211f to detect downshift
Message-ID: <20201125170714.GK1551@shell.armlinux.org.uk>
References: <20201124143848.874894-1-antonio.borneo@st.com>
 <20201124230756.887925-1-antonio.borneo@st.com>
 <d62710c3-7813-7506-f209-fcfa65931778@huawei.com>
 <f24476cc-39f0-ea5f-d6af-faad481e3235@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <f24476cc-39f0-ea5f-d6af-faad481e3235@huawei.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: Russell King - ARM Linux admin <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 26, 2020 at 12:57:37AM +0800, Yonglong Liu wrote:
> Hi, Antonio:
> 
>     Could you help to provide a downshift warning message when this happen?
> 
>     It's a little strange that the adv and the lpa support 1000M, but
> finally the link speed is 100M.

That is an identifying feature of downshift.

Downshift can happen at either end of the link, and since we must not
change the "Advertised link modes" since this is what userspace
configured, if a downshift occurs at the local end, then you will get
the ethtool output you provide, where the speed does not agree with
the reported advertisements.

You should already be getting a warning in the kernel log when this
happens; phy_check_downshift() which is part of the phylib core code
will check this every time the link comes up. You should already
have a message "Downshift occurred ..." in your kernel log. Please
check.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
