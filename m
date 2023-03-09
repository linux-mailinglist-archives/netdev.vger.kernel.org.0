Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 93F576B253A
	for <lists+netdev@lfdr.de>; Thu,  9 Mar 2023 14:26:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230039AbjCIN0c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Mar 2023 08:26:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229751AbjCIN0a (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Mar 2023 08:26:30 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0CBFE8CE6;
        Thu,  9 Mar 2023 05:26:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=mAH+gJH5iSXK8yJctunoTdsLme9UYm2uCsVvhWaxJF0=; b=zVWdXmuDJsTULwUOTmAeXoD9C2
        rPezpW7Lb2gwGjgipExhG0bE+I4ufKetCKDFSLPGvOmLbNxt6Kg03fO/G1oiCTYOzMljtqZBC1FAG
        ij+LxXPjeBVfZ9m9VcZ2ywwGyvKhz4gi4EHBdBfZcKeNnp9io96sMA1EytIse0eext2OPX8SxiLUw
        X+Lf5j0D6yf1m1aFnq4NJmK9QXeJ6W85nNbMDdlkGEuTQ/G0izfp4gOJ3MNm3XNHyl+ZVCSmZBgs2
        4UZ4mHvu+eVlHpX4Q/jSRgWWuvP4Gpn/e7Ybqlckrca/Q/sW7JH7idbVMFKx/bVxc8H8NHzKq+pM5
        ShPvTdCw==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:37662)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1paGHm-0004dw-Cs; Thu, 09 Mar 2023 13:26:22 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1paGHk-0003gu-Ea; Thu, 09 Mar 2023 13:26:20 +0000
Date:   Thu, 9 Mar 2023 13:26:20 +0000
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Lukasz Majewski <lukma@denx.de>
Cc:     Andrew Lunn <andrew@lunn.ch>, Vladimir Oltean <olteanv@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/7] dsa: marvell: Add helper function to validate the
 max_frame_size variable
Message-ID: <ZAnefI4vCZSIPkEK@shell.armlinux.org.uk>
References: <20230309125421.3900962-1-lukma@denx.de>
 <20230309125421.3900962-6-lukma@denx.de>
 <ZAndSR4L1QvOFta6@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZAndSR4L1QvOFta6@shell.armlinux.org.uk>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 09, 2023 at 01:21:13PM +0000, Russell King (Oracle) wrote:
> On Thu, Mar 09, 2023 at 01:54:19PM +0100, Lukasz Majewski wrote:
> > This commit shall be regarded as a transition one, as this function helps
> > to validate the correctness of max_frame_size variable added to
> > mv88e6xxx_info structure.
> > 
> > It is necessary to avoid regressions as manual assessment of this value
> > turned out to be error prone.
> > 
> > Signed-off-by: Lukasz Majewski <lukma@denx.de>
> > Suggested-by: Russell King (Oracle) <linux@armlinux.org.uk>
> 
> Shouldn't this be patch 2 - immediately after populating the
> .max_frame_size members, and before adding any additional devices?

Moreover, shouldn't the patch order be:

1, 5, 6 (fixing the entry that needs it), 7 (which then gets the
max frame size support in place), 4 (so that .set_max_frame_size for
6250 is in place), 2, 3

?

In other words, get the new infrastructure you need in place first
(that being the new .max_frame_size and the .set_max_frame_size
function) before then adding the new support.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
