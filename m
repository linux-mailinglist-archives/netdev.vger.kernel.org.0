Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4509E2F6397
	for <lists+netdev@lfdr.de>; Thu, 14 Jan 2021 16:02:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727480AbhANPAw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Jan 2021 10:00:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726565AbhANPAw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Jan 2021 10:00:52 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BEC63C061574
        for <netdev@vger.kernel.org>; Thu, 14 Jan 2021 06:59:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:
        Content-Transfer-Encoding:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Reply-To:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=NvL97tsH3xPtRBRPWdy1qmCILCqkx20olHUYvAYLS1g=; b=iJZa2fPpzQ/t+VdNHlvxpN+um
        WYGZCmnINtnYNnVcHHWofIaoCNVU6GtiqRK0nK0B+DU3UusPj6JvFUs18hMCo2ZEjrPoBn6Waanov
        o6xolYhJhejHuz+gHnx1yZpJXqP/i2DRDe2ZY68FBKBmcDKWKolyXaW5Ax+CBFVpiXMpzO1V+lAF6
        7BDMNY0a7MrXfj8eZHdEPx0vIxZ4fnvtHgFh1K8LGuHSK8cefB5JO4PCXN9o+mjLqB6sj2L3GKqyB
        tnRtsJ2J1Aal7gssbqUUIb2oVBe4fcGNBXep+dIbaJPjI0ErCyr+n42H4Xw9rkloOIUTUgPupSv59
        4P9ajGCfQ==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:47916)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1l046M-0002aX-FE; Thu, 14 Jan 2021 14:59:54 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1l046L-0008Qe-Hz; Thu, 14 Jan 2021 14:59:53 +0000
Date:   Thu, 14 Jan 2021 14:59:53 +0000
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Marek =?iso-8859-1?Q?Beh=FAn?= <kabel@kernel.org>
Cc:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Jakub Kicinski <kuba@kernel.org>, davem@davemloft.net,
        pali@kernel.org
Subject: Re: [PATCH net-next v5 1/5] net: sfp: add SFP_PASSWORD address
Message-ID: <20210114145953.GS1551@shell.armlinux.org.uk>
References: <20210114044331.5073-1-kabel@kernel.org>
 <20210114044331.5073-2-kabel@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210114044331.5073-2-kabel@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: Russell King - ARM Linux admin <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 14, 2021 at 05:43:27AM +0100, Marek Behún wrote:
> Add SFP_PASSWORD = 0x7b to the diagnostics enumerator. This address is
> described in SFF-8436 and SFF-8636.

However, as I mentioned previously, these are not relevant for SFPs,
but are for QSFPs, and QSFPs have a totally different layout.

The data structure for this enum is described by SFF-8472, and it lists

	Vendor Specific Locations [Address A2h, Bytes 120-126]

This is what the SFP_VSL definition covers.

SFF-8436 defines the layout for "QSFP+ 10 Gbs 4X PLUGGABLE TRANSCEIVER":

                            Table 17 - Lower Memory Map (A0h)
       Address       Description         Type         Passive Copper,     Optical
                                                      Active Copper,      Module                                                      Active Optical
       0             Identifier (1       Read-Only    R                   R
                     Byte)
       1-2           Status (2 Bytes)     Read-Only    See Table 18
       3-21          Interrupt Flags      Read-Only    See Tables 19-21
                     (19 Bytes)
...
       123-126       Password Entry       Read/Write   O                  O
                     Area (optional) 4
                     Bytes
       127           Page Select Byte     Read/Write   R                  R

So, SFF-8436 is not relevant - not only is it for a different address
but the whole format is different.

SFF-8636 is "Specification for Management Interface for Cabled
Environments" and defines:

                             2-Wire Serial Address 1010000x
                                     Lower Page 00h
                            0 Identifier
                        1- 2 Status
                        3- 21 Interrupt Flags
...
                      123-126 Password Entry Area (Optional)
                      127     Page Select Byte

So again, SFF-8636 is not relevant for the same reasons as SFF-8436.

We're left with SFF-8472, which mentions no password entry area, but
leaves the area from 120-127 open as "vendor specific", so I don't
think it is appropriate to start adding vendor specific definitions as
if they were generic to sfp.h

I would instead suggest defining this inside mdio-i2c.c as

#define ROLLERBALL_PASSWORD	(SFP_VSL + 3)

rather than trying to make this appear generic.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
