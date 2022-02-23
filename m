Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BC4794C10B1
	for <lists+netdev@lfdr.de>; Wed, 23 Feb 2022 11:48:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239688AbiBWKtI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Feb 2022 05:49:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237755AbiBWKtI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Feb 2022 05:49:08 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A55CE5A0B6;
        Wed, 23 Feb 2022 02:48:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=Qj1XjCtHH+cDK9A9LI4ULsQPbWkbS/mgt53QvA7mUjY=; b=O3yHXWRHKKvJHIc9XNK4HVNkZk
        Vep3ohqyAdr+HSvCH83pjgnjH+hCoQxhEw4Pl503hSL/E290dSN7P+iqufCxIQQMO5HbS/4045ckF
        JnpSCuXpIx3JjVsIl+kqEw0ygTDk1Bxj9AcQEt5iBY9FWj0YgHfGxq17yBWCcyMmBUPM=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1nMpBq-007mAW-RP; Wed, 23 Feb 2022 11:48:10 +0100
Date:   Wed, 23 Feb 2022 11:48:10 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Heyi Guo <guoheyi@linux.alibaba.com>
Cc:     linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Joel Stanley <joel@jms.id.au>,
        Guangbin Huang <huangguangbin2@huawei.com>,
        Hao Chen <chenhao288@hisilicon.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Dylan Hung <dylan_hung@aspeedtech.com>, netdev@vger.kernel.org
Subject: Re: [PATCH 3/3] drivers/net/ftgmac100: fix DHCP potential failure
 with systemd
Message-ID: <YhYQ6jGQv39rSsDU@lunn.ch>
References: <20220223031436.124858-1-guoheyi@linux.alibaba.com>
 <20220223031436.124858-4-guoheyi@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220223031436.124858-4-guoheyi@linux.alibaba.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> diff --git a/drivers/net/ethernet/faraday/ftgmac100.c b/drivers/net/ethernet/faraday/ftgmac100.c
> index c1deb6e5d26c5..d5356db7539a4 100644
> --- a/drivers/net/ethernet/faraday/ftgmac100.c
> +++ b/drivers/net/ethernet/faraday/ftgmac100.c
> @@ -1402,8 +1402,17 @@ static void ftgmac100_adjust_link(struct net_device *netdev)
>  	/* Disable all interrupts */
>  	iowrite32(0, priv->base + FTGMAC100_OFFSET_IER);
>  
> -	/* Reset the adapter asynchronously */
> -	schedule_work(&priv->reset_task);
> +	/* Release phy lock to allow ftgmac100_reset to aquire it, keeping lock
> +	 * order consistent to prevent dead lock.
> +	 */
> +	if (netdev->phydev)
> +		mutex_unlock(&netdev->phydev->lock);

No need to do this test. The fact that adjust_link is being called
indicates there must be a PHY.

    Andrew
