Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F20FC679849
	for <lists+netdev@lfdr.de>; Tue, 24 Jan 2023 13:45:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233971AbjAXMpm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Jan 2023 07:45:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233970AbjAXMpk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Jan 2023 07:45:40 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 005BD3EC64
        for <netdev@vger.kernel.org>; Tue, 24 Jan 2023 04:45:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:
        Content-Transfer-Encoding:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Reply-To:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=JFHuAI21WyhJ+jtU+P9s5gzqFmqgPhi74NYiczogY6Y=; b=lvO9zbGoXt31TJQ2f9Io+N/AQu
        KifFue1zJUl16J/VLU1upKhVtB/LdBlkj2j33WrdtEFyEt6IARqGwHX+iWSxnucG1x826SQ5ZUtw2
        9UPJgIJcdfn53TcKmEAKbn9hqBYHvTSSOJcbms5DUKjyOwc+MWTyGVeM7u7tIYPUs21Kyas+i5cNT
        unmB7KqSGX1YvJcC1WheQqSiShVSUj+1cqcOQ3OrbIlcpSewtefAgmsnpnB37pSL1PFqjkZDurxe9
        /t8OC2yrtfbelmYizdeyHTvaI/jyjD93U1+EHo6oXKqff0FMeGccndHmZn/Ibb0vhtykRFwnFyEBK
        JRqyHq3w==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:36280)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1pKIg2-0006jJ-Bz; Tue, 24 Jan 2023 12:45:26 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1pKIfx-0005IK-4J; Tue, 24 Jan 2023 12:45:21 +0000
Date:   Tue, 24 Jan 2023 12:45:21 +0000
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Paolo Abeni <pabeni@redhat.com>
Cc:     =?iso-8859-1?Q?Bj=F8rn?= Mork <bjorn@mork.no>,
        netdev@vger.kernel.org, Felix Fietkau <nbd@nbd.name>,
        John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Daniel Golle <daniel@makrotopia.org>,
        Alexander Couzens <lynxis@fe80.eu>
Subject: Re: [PATCH v3 net 1/3] net: mediatek: sgmii: ensure the SGMII PHY is
 powered down on configuration
Message-ID: <Y8/S4eAK338MG53B@shell.armlinux.org.uk>
References: <20230122212153.295387-1-bjorn@mork.no>
 <20230122212153.295387-2-bjorn@mork.no>
 <a9e7d8f528828c0c7cd0966a4f3023027425011b.camel@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <a9e7d8f528828c0c7cd0966a4f3023027425011b.camel@redhat.com>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 24, 2023 at 01:19:15PM +0100, Paolo Abeni wrote:
> On Sun, 2023-01-22 at 22:21 +0100, Bjørn Mork wrote:
> > From: Alexander Couzens <lynxis@fe80.eu>
> > 
> > The code expect the PHY to be in power down which is only true after reset.
> > Allow changes of the SGMII parameters more than once.
> > 
> > Only power down when reconfiguring to avoid bouncing the link when there's
> > no reason to - based on code from Russell King.
> > 
> > There are cases when the SGMII_PHYA_PWD register contains 0x9 which
> > prevents SGMII from working. The SGMII still shows link but no traffic
> > can flow. Writing 0x0 to the PHYA_PWD register fix the issue. 0x0 was
> > taken from a good working state of the SGMII interface.
> 
> This looks like a legitimate fix for -net, but we need a suitable Fixes
> tag pointing to the culprit commit.
> 
> Please repost including such tag. While at that you could also consider
> including Simon's suggestion.
> 
> The following 2 patches looks like new features/refactor that would be
> more suitable for net-next, and included here due to the code
> dependency.

I'm not sure why you think that, especially for patch 2.

Patch 2 corrects the sense of the duplex bit - the code originally
set this for full duplex, but in actual fact, the bit needs to be set
for half duplex. I can't see how one could regard that as a feature
or a refactor.

I'm also not sure how you could regard patch 3 as a refactor. It
could be argued that it is a new feature, but it is actually a bug
fix for the patch converting the driver to phylink_pcs which
omitted setting this, making the pcs_get_state() method rather
useless.

So I regard all three patches as fixes, not features or refactoring.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
