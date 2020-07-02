Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 28B6F2120EF
	for <lists+netdev@lfdr.de>; Thu,  2 Jul 2020 12:21:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728405AbgGBKUy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jul 2020 06:20:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728366AbgGBKUG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Jul 2020 06:20:06 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7304C08C5C1;
        Thu,  2 Jul 2020 03:20:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=tmoWyHWo+SN8Vhpar93hQFdhwp8xCobKG+G2PIUXDjc=; b=NtrLLqXRmr0TJmd7HuSZknX4g
        WCZf/hqqgMpcv+7YtGLPgsItukw63y5a/PL+A1uqBAaiw5DT5KBIVrI+p7mq21qXMq2+kmGwTSQ3f
        mIQUezBUgyN0OYoMwB9Rvpz2MNSL49J1zVqSqxstj74AgaMEo74n8XKGsf3VOXV7y337GG6QQRGEf
        PsDdjq1EXMTdG+obGMriXT8VxJDJntKBGoSv6JMUA3TX7n3BgWm8yRASdpCIfNCdciZHdiqRYP+HF
        XQJ0YEa+W5XaOKcnpLltr8RszRzKvnbUnaHA9A/focJOEj1rKSlCGpzewhuq/OTgMNmec0oAFhOdJ
        ohN/aWChw==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:34342)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1jqwK1-0002hK-7z; Thu, 02 Jul 2020 11:20:01 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1jqwJy-0001hZ-Ts; Thu, 02 Jul 2020 11:19:58 +0100
Date:   Thu, 2 Jul 2020 11:19:58 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Codrin Ciubotariu <codrin.ciubotariu@microchip.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        woojung.huh@microchip.com, UNGLinuxDriver@microchip.com,
        andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        davem@davemloft.net, kuba@kernel.org
Subject: Re: [PATCH net-next] net: dsa: microchip: split adjust_link() in
 phylink_mac_link_{up|down}()
Message-ID: <20200702101958.GN1551@shell.armlinux.org.uk>
References: <20200702095439.1355119-1-codrin.ciubotariu@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200702095439.1355119-1-codrin.ciubotariu@microchip.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 02, 2020 at 12:54:39PM +0300, Codrin Ciubotariu wrote:
> The DSA subsystem moved to phylink and adjust_link() became deprecated in
> the process. This patch removes adjust_link from the KSZ DSA switches and
> adds phylink_mac_link_up() and phylink_mac_link_down().
> 
> Signed-off-by: Codrin Ciubotariu <codrin.ciubotariu@microchip.com>

For the code _transformation_ that the patch does:

Reviewed-by: Russell King <rmk+kernel@armlinux.org.uk>

as it is equivalent.  However, for a deeper review of what is going
on here, I've a question:

$ grep live_ports *
ksz8795.c:         dev->live_ports = dev->host_mask;
ksz8795.c:                 dev->live_ports |= BIT(port);
ksz_common.h:      u16 live_ports;
ksz_common.c:              dev->live_ports &= ~(1 << port);
ksz_common.c:              dev->live_ports |= (1 << port) & dev->on_ports;
ksz_common.c:      dev->live_ports &= ~(1 << port);
ksz9477.c:         dev->live_ports = dev->host_mask;
ksz9477.c:                 dev->live_ports |= (1 << port);

These are the only references to dev->live_ports, so the purpose of
dev->live_ports seems unclear; it seems it is only updated but never
read.  Can it be removed, along with the locking in your new functions?

Thanks.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
