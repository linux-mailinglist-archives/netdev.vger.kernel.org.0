Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 32EB663F3C9
	for <lists+netdev@lfdr.de>; Thu,  1 Dec 2022 16:27:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231669AbiLAP1a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Dec 2022 10:27:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229728AbiLAP13 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Dec 2022 10:27:29 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97EF0AA8D4
        for <netdev@vger.kernel.org>; Thu,  1 Dec 2022 07:27:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=Z33fB9eVMIGnHJP5xJtWq1jOKHbK7KgN6sxZpd9y5gg=; b=ANkTQAbizNxrxw9UxudaFU8Bbb
        JK5put+rCq9OOHGhH9zw9YXfT9edk7K+f4yN2+DHhLfXj9EjMRArvxidtV4OHjqmNp0z5CV/dd1LQ
        6z8a64V6Q5IWE+izDhdl/iNIbJQn7KLP5al4kw8tFq/1isagEC8rQ43YWBhc8m16s8j0=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1p0lT3-0044aM-SI; Thu, 01 Dec 2022 16:27:17 +0100
Date:   Thu, 1 Dec 2022 16:27:17 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Zeng Heng <zengheng4@huawei.com>,
        Yang Yingliang <yangyingliang@huawei.com>
Cc:     f.fainelli@gmail.com, pabeni@redhat.com, kuba@kernel.org,
        linux@armlinux.org.uk, davem@davemloft.net, edumazet@google.com,
        hkallweit1@gmail.com, netdev@vger.kernel.org, liwei391@huawei.com
Subject: Re: [PATCH] net: mdio: fix unbalanced fwnode reference count in
 mdio_device_release()
Message-ID: <Y4jH1Z8UdA/h+WlE@lunn.ch>
References: <20221201092202.3394119-1-zengheng4@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221201092202.3394119-1-zengheng4@huawei.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 01, 2022 at 05:22:02PM +0800, Zeng Heng wrote:
> There is warning report about of_node refcount leak
> while probing mdio device:
> 
> OF: ERROR: memory leak, expected refcount 1 instead of 2,
> of_node_get()/of_node_put() unbalanced - destroy cset entry:
> attach overlay node /spi/soc@0/mdio@710700c0/ethernet@4
> 
> In of_mdiobus_register_device(), we increase fwnode refcount
> by fwnode_handle_get() before associating the of_node with
> mdio device, but it has never been decreased after that.
> Since that, in mdio_device_release(), it needs to call
> fwnode_handle_put() in addition instead of calling kfree()
> directly.
> 
> After above, just calling mdio_device_free() in the error handle
> path of of_mdiobus_register_device() is enough to keep the
> refcount balanced.

How does this interact with:

https://lore.kernel.org/netdev/20221201033838.1938765-1-yangyingliang@huawei.com/T/

	Andrew
