Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9E8C86AE3EC
	for <lists+netdev@lfdr.de>; Tue,  7 Mar 2023 16:07:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229813AbjCGPHW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Mar 2023 10:07:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229577AbjCGPHB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Mar 2023 10:07:01 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4EBF6911F6;
        Tue,  7 Mar 2023 07:00:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=Pej/R2eiauVJxEiGN1MisFQpptx8WKIt172xVqffJMM=; b=og/4LJa2feM9MOGbDE8JLsOVO4
        /anOKsdL1LSH4kJodJn4fJizhGpyjikcXwhzpXMDBVPXoCh254+DfEPTIvsQ0f9WvqsxqIZXFWICF
        BmRS6pxd2irlt9y3XrMfjNs3iz7LMIb7Iu2pwDAgsR5g38+RroLZ3gbU68wESHCdhZL1hG1WCAsur
        iC67thkxs1phqW93qePVb85y0YiPF+/j0BBoNlDjjwePyPHp5fz50R8SqCBhFDNh/hY/AbTbCGs/B
        7M11X5jeF2VbC/yCjuitpD7Q6MZ0CH6FPoiYPYpcfQIrj1dnHD0THcfzQWZ0AEPH8SfcK4Trx9oIj
        H4kVpnNA==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:34842)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1pZYno-0000aj-Rs; Tue, 07 Mar 2023 15:00:32 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1pZYnm-0001cI-GO; Tue, 07 Mar 2023 15:00:30 +0000
Date:   Tue, 7 Mar 2023 15:00:30 +0000
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Vladimir Oltean <olteanv@gmail.com>,
        Michael Walle <michael@walle.cc>, sean.anderson@seco.com,
        davem@davemloft.net, edumazet@google.com, f.fainelli@gmail.com,
        hkallweit1@gmail.com, kuba@kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        pabeni@redhat.com, tobias@waldekranz.com
Subject: Re: [PATCH net-next] net: mdio: Add netlink interface
Message-ID: <ZAdRjo3wXmVigPAC@shell.armlinux.org.uk>
References: <20230306204517.1953122-1-sean.anderson@seco.com>
 <20230307112307.777207-1-michael@walle.cc>
 <684c859a-02e2-4652-9a40-9607410f95e6@lunn.ch>
 <20230307140535.32ldprkyblpmicjg@skbuf>
 <7013dea3-a026-4a0c-81e0-7ebe6f708e39@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7013dea3-a026-4a0c-81e0-7ebe6f708e39@lunn.ch>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 07, 2023 at 03:33:20PM +0100, Andrew Lunn wrote:
> > - Atomic (why only atomic?) (read) access to paged registers
> 
> I would say 'atomic' is wrong, you cannot access paged registers at
> all.
> 
> > are we ok with the implications?
> 
> I am. Anybody doing this level of debugging should be able to
> recompile the kernel to enable write support. It does limit debugging
> in field, where maybe you cannot recompile the kernel, but to me, that
> is a reasonable trade off.

However, it should be pointed out that disabling write support means
that one can not even read paged registers through this interface.

That leads me to question the whole point of this, because as far as I
can see, the only thing this interface would offer with writes disabled
is the ability to read several non-paged registers consectively while
holding the mdio bus lock. Apart from that, with writes disabled, it
appears to offer nothing over the existing MII ioctls.

With writes enabled, then yes, it offers a slightly better interface
to be able to perform multiple accesses while holding the bus lock.

In that regard, is there any point to having the configuration option
to control whether writes are supported, or is it just better to have
an option to enable/disable the whole interface, and taint the kernel
on *any* use of this interface?

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
