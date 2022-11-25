Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 01807639233
	for <lists+netdev@lfdr.de>; Sat, 26 Nov 2022 00:32:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229919AbiKYXcU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Nov 2022 18:32:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229868AbiKYXcT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Nov 2022 18:32:19 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB845554DF
        for <netdev@vger.kernel.org>; Fri, 25 Nov 2022 15:32:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=bvSRWUU5LbYB0Ch1xker8wTQ8ekBr9ogacOWUoMze5s=; b=sLQ3hYpkSy2IG4sZBlAKQa7P2X
        540NTgbG/3IT8Vxbu7qV6HfYKV3MyFVhweNyki9QreCZSPJySgGDgvwJB9lqEjRjh0vfD54FL0o02
        a68urK1fD5mn1epuRH9PZHSWn6sQdKCUplBIPZHpjEOpbDcMQLkhICY4aZPYEjAJapPQ=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1oyiB2-003TKn-VW; Sat, 26 Nov 2022 00:32:12 +0100
Date:   Sat, 26 Nov 2022 00:32:12 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Yang Yingliang <yangyingliang@huawei.com>
Cc:     netdev@vger.kernel.org, hkallweit1@gmail.com,
        linux@armlinux.org.uk, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, ioana.ciornei@nxp.com,
        calvin.johnson@oss.nxp.com, grant.likely@arm.com
Subject: Re: [PATCH net] net: mdiobus: fix unbalanced node reference count
Message-ID: <Y4FQfGKkNMzZQ7tA@lunn.ch>
References: <20221124150130.609420-1-yangyingliang@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221124150130.609420-1-yangyingliang@huawei.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 24, 2022 at 11:01:30PM +0800, Yang Yingliang wrote:
> I got the following report while doing device(mscc-miim) load test
> with CONFIG_OF_UNITTEST and CONFIG_OF_DYNAMIC enabled:
> 
>   OF: ERROR: memory leak, expected refcount 1 instead of 2,
>   of_node_get()/of_node_put() unbalanced - destroy cset entry:
>   attach overlay node /spi/soc@0/mdio@7107009c/ethernet-phy@0
> 
> If the 'fwnode' is not an acpi node, the refcount is get in
> fwnode_mdiobus_phy_device_register(), but it has never been
> put when the device is freed in the normal path. So call
> fwnode_handle_put() in phy_device_release() to avoid leak.
> 
> If it's an acpi node, it has never been get, but it's put
> in the error path, so call fwnode_handle_get() before
> phy_device_register() to keep get/put operation balanced.
> 
> Fixes: bc1bee3b87ee ("net: mdiobus: Introduce fwnode_mdiobus_register_phy()")
> Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
