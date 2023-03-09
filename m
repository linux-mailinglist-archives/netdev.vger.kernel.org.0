Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 548556B292E
	for <lists+netdev@lfdr.de>; Thu,  9 Mar 2023 16:56:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230365AbjCIP4Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Mar 2023 10:56:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229976AbjCIP4U (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Mar 2023 10:56:20 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2CDEBE825E
        for <netdev@vger.kernel.org>; Thu,  9 Mar 2023 07:56:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:Content-Type:MIME-Version:
        Message-ID:Subject:Cc:To:From:Date:Reply-To:Content-Transfer-Encoding:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=z9GquP129NQj/ctO0X6qgRKAXW660qD4AAuqTvtd4s4=; b=PCMdTdTmPTtG5ChXYXDhDVdQhP
        y7DH3i93ZkskpBvTo9MnjKmHhDfoKj1Lg2kQS4tcX/afEGLbREzUgCIG3CAc0slf4zmbyOfPwnvRb
        RXdHthHGUrCqom0Op4JqRXEvnvVOZf3ZhoNdVs5JfP4ED3rbJKAQAslXYcb3Mfm4FU4gRdWCOuIVq
        tgVviTC2D1C1CfjS2bKm+5lZDnwNrdUuC3IBfJGMzs7IlybCKhDx/V8rUZ3/3nnRWq/Cc9z6bXBJB
        svUD62LDeAa1zxKqcxMCkIUNy40Xd/nCKVx3kJVGgKb6WeVwrw4DM2Z6yOXFaxfI1LCcn5GR6Ld2A
        5WOWDrJw==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:54602)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1paIcp-0004yv-G1; Thu, 09 Mar 2023 15:56:15 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1paIco-0003mo-2e; Thu, 09 Mar 2023 15:56:14 +0000
Date:   Thu, 9 Mar 2023 15:56:14 +0000
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH net-next 0/2] Rework SFP A2 access conditionals
Message-ID: <ZAoBnqGBnIZzLwpV@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

This series reworks the SFP A2 (diagnostics and control) access so we
don't end up testing a variable number of conditions in several places.

This also resolves a minor issue where we may have a module indicating
that it is not SFF8472 compliant, doesn't implement A2, but fails to
set the enhanced option byte to zero, leading to accesses to the A2
page that fail.

The first patch adds a new flag "have_a2" which indicates whether we
should be accessing the A2 page, and uses this for hwmon. The
conditions are kept the same.

The second patch extends the check for soft-state polling and control
by using this "have_a2" flag (which effectively augments the check to
include some level of SFF8472 compliance.)

 drivers/net/phy/sfp.c | 48 +++++++++++++++++++++++++++++-------------------
 1 file changed, 29 insertions(+), 19 deletions(-)

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
