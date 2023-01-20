Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6AFDE67545B
	for <lists+netdev@lfdr.de>; Fri, 20 Jan 2023 13:27:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229596AbjATM1a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Jan 2023 07:27:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229500AbjATM13 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Jan 2023 07:27:29 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4BD6BC757
        for <netdev@vger.kernel.org>; Fri, 20 Jan 2023 04:27:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:
        Content-Transfer-Encoding:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Reply-To:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=XjRbaRyZOqJMw9qrkPYGjpAZxyQu0XQZvW64et9i9iU=; b=vebhBcVu2QdAQsuEhQ3I3kKGYD
        DF3YdEIh5tBARCRSRuThICd11kx3NZknQk78kFTjonUNiu1HJf1lqpgdBofuXUH/3fAPcWQmbs1o2
        PKyjZz2YJyPePTUg41k9aSODs9eY4Ih2muHIJ/WMMvbsACzSkYAjY7QLavtpvVInQqtZduzdqGP7p
        lWuFwpqmjdXGVw3YTkhgpPK4j/EbqsKGnMSNAENxcXg5gW5pIaoS5q1hqWxK0PA/sL4e7m5Iq0eD6
        oc5ylM/zQepml4VPshuLCRU8MNNhUfEjDExCzuO2PX8j4zmQL8NoMNjXaaQJVJp7Abky9QA9zC8t0
        /d6WDUDg==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:36226)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1pIqUL-0006fl-UB; Fri, 20 Jan 2023 12:27:21 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1pIqUF-0001RX-57; Fri, 20 Jan 2023 12:27:15 +0000
Date:   Fri, 20 Jan 2023 12:27:15 +0000
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     =?iso-8859-1?Q?Bj=F8rn?= Mork <bjorn@mork.no>
Cc:     netdev@vger.kernel.org, Felix Fietkau <nbd@nbd.name>,
        John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Daniel Golle <daniel@makrotopia.org>,
        Alexander Couzens <lynxis@fe80.eu>
Subject: Re: [PATCH v2 net 1/3] net: mediatek: sgmii: ensure the SGMII PHY is
 powered down on configuration
Message-ID: <Y8qIoxpLj2uiRM1Q@shell.armlinux.org.uk>
References: <20230120104947.4048820-1-bjorn@mork.no>
 <20230120104947.4048820-2-bjorn@mork.no>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230120104947.4048820-2-bjorn@mork.no>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 20, 2023 at 11:49:45AM +0100, Bjørn Mork wrote:
> From: Alexander Couzens <lynxis@fe80.eu>
> 
> The code expect the PHY to be in power down which is only true after reset.
> Allow changes of the SGMII parameters more than once.
> 
> Only power down when reconfiguring to avoid bouncing the link when there's
> no reason to - based on code from Russell King.
> 
> There are cases when the SGMII_PHYA_PWD register contains 0x9 which
> prevents SGMII from working. The SGMII still shows link but no traffic
> can flow. Writing 0x0 to the PHYA_PWD register fix the issue. 0x0 was
> taken from a good working state of the SGMII interface.
> 
> Suggested-by: Russell King (Oracle) <linux@armlinux.org.uk>
> Signed-off-by: Alexander Couzens <lynxis@fe80.eu>
> [ bmork: rebased and squashed into one patch ]
> Signed-off-by: Bjørn Mork <bjorn@mork.no>

Reviewed-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>

Thanks!

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
