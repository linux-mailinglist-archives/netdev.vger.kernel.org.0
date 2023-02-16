Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 55341699540
	for <lists+netdev@lfdr.de>; Thu, 16 Feb 2023 14:11:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229608AbjBPNL0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Feb 2023 08:11:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229492AbjBPNLZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Feb 2023 08:11:25 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1A58518D4
        for <netdev@vger.kernel.org>; Thu, 16 Feb 2023 05:11:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=+4EWSgT4Z8/ZJGdeDRda32sS4QtBWz4i27hJmMQD5Ws=; b=wo+RJkWyOTBMU4bc/+S3dA8hg3
        tPKhfS+tt08SzbzjAQth2PDw912+qV7JqhEl4WzefibGKM0HY0QRtps4DX/vEO/J2wWvWqN+qMWoS
        jecc+/qEdAA2p7YrUc6RS9hrbJwFer4px6E9CCaR98iowwHXfr1L0VWbR9uiLfEj33gQ=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1pSe2h-005BHV-Q4; Thu, 16 Feb 2023 14:11:19 +0100
Date:   Thu, 16 Feb 2023 14:11:19 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Mengyuan Lou <mengyuanlou@net-swift.com>
Cc:     netdev@vger.kernel.org, jiawenwu@trustnetic.com
Subject: Re: [PATCH net-next] net: wangxun: Implement the ndo change mtu
 interface
Message-ID: <Y+4rd1q58XzLlCOy@lunn.ch>
References: <20230216084413.10089-1-mengyuanlou@net-swift.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230216084413.10089-1-mengyuanlou@net-swift.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +static int ngbe_change_mtu(struct net_device *netdev, int new_mtu)
> +{
> +	int max_frame = new_mtu + ETH_HLEN + ETH_FCS_LEN;
> +	struct wx *wx = netdev_priv(netdev);
> +
> +	if (max_frame > WX_MAX_JUMBO_FRAME_SIZE)
> +		return -EINVAL;

You set netdev->max_mtu. So was it possible to actually make this
happen?

> +
> +	netdev_info(netdev, "Changing MTU from %d to %d.\n",
> +		    netdev->mtu, new_mtu);

netdev_dbg().

> +static void txgbe_reinit_locked(struct wx *wx)
> +{
> +	/* prevent tx timeout */
> +	netif_trans_update(wx->netdev);
> +	txgbe_down(wx);
> +	wx_configure(wx);
> +	txgbe_up_complete(wx);
> +}

None of these can fail? None allocate memory, etc?

> +static int txgbe_change_mtu(struct net_device *netdev, int new_mtu)
> +{
> +	int max_frame = new_mtu + ETH_HLEN + ETH_FCS_LEN;
> +	struct wx *wx = netdev_priv(netdev);
> +
> +	if (max_frame > WX_MAX_JUMBO_FRAME_SIZE)
> +		return -EINVAL;
> +
> +	netdev_info(netdev, "Changing MTU from %d to %d.\n",
> +		    netdev->mtu, new_mtu);

Same two comments as above.

     Andrew
