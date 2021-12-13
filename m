Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA024472AD0
	for <lists+netdev@lfdr.de>; Mon, 13 Dec 2021 12:03:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232578AbhLMLD1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Dec 2021 06:03:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232342AbhLMLD1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Dec 2021 06:03:27 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7836C06173F;
        Mon, 13 Dec 2021 03:03:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=TAxkZYTLGQdMl8InjvEC8WjPoh21RqQVBS9pBjUFe48=; b=ycFjoDTBAlTagIUP/oMHJM4ATO
        Ob7GLoxAAD5gc8lE7Kq9Zob+RkI8OojC+d8/0o/QQBdj32gifcPpTiukGTx7GMsyLDf3oy48JrE2z
        +AAx2xaxqQFPV2sslZvyV4PUjQOt6KSftcm0SdTyOBC3n8ES93tb/DF61a3boHsodh5udCqqjxNPs
        zDZP+wj5UYa3Q5SuSo5h0NrXNklVmWy9pnUTclsMD5oXlUUNei42qYS3IETbJXxWRka2WrofUN92D
        H+qvpcAuuYbS3uZg4Iff6tJSzKJZ9zZn7zdN3YLb5zPjqIfpF94OFzbM/1arWG2KvGpFaxmoJKrwS
        HpOdo4JQ==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:56258)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1mwj6x-0003UV-0p; Mon, 13 Dec 2021 11:03:15 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1mwj6u-0002WP-Aj; Mon, 13 Dec 2021 11:03:12 +0000
Date:   Mon, 13 Dec 2021 11:03:12 +0000
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Qing Wang <wangqing@vivo.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: phy: add missing of_node_put before return
Message-ID: <YbcocBZBAJaZ0Rf6@shell.armlinux.org.uk>
References: <1639388689-64038-1-git-send-email-wangqing@vivo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1639388689-64038-1-git-send-email-wangqing@vivo.com>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 13, 2021 at 01:44:49AM -0800, Qing Wang wrote:
> From: Wang Qing <wangqing@vivo.com>
> 
> Fix following coccicheck warning:
> WARNING: Function "for_each_available_child_of_node" 
> should have of_node_put() before return.
> 
> Early exits from for_each_available_child_of_node should decrement the
> node reference counter.

Most *definitely* NAK. Coccicheck is most definitely wrong on this one,
and we will probably need some way to tell people not to believe
coccicheck on this.

In this path, the DT node is assigned to a struct device. This _must_
be reference counted. device_set_node() does not increment the
reference count, nor does of_fwnode_handle(). The reference count
here is passed from this code over to the struct device.

Adding an of_node_put() will break this.

This must _never_ be "fixed" no matter how much coccicheck complains,
as fixing the warning _will_ introduce a refcounting bug.

I'll send a patch adding a comment to this effect.

Thanks.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
