Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B2087610645
	for <lists+netdev@lfdr.de>; Fri, 28 Oct 2022 01:15:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235547AbiJ0XPg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Oct 2022 19:15:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234705AbiJ0XPf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Oct 2022 19:15:35 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2B9C578A9
        for <netdev@vger.kernel.org>; Thu, 27 Oct 2022 16:15:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=5EZlcchJAy25hzFY5raR2BbWbOpbRCxyc+hZqLOPp2g=; b=0YQrv0eebEPzAIS7bxE2xv0YV4
        s5aLVYXRBySzpSZkUlbLQZ+JAMxPpQDV6Twe2Oapq7iA8WOqXs6bmIf72F4N7JPgG3Ipp/+lm//pd
        UJ651TE+pb0z9zAkSen8TNUWkyg4MEBUMx0nyXouZZB3ApdiHpJpIt9wn33OBfka+PKI=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1ooC5C-000lBX-HR; Fri, 28 Oct 2022 01:14:42 +0200
Date:   Fri, 28 Oct 2022 01:14:42 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     David Thompson <davthompson@nvidia.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org, cai.huoqing@linux.dev,
        brgl@bgdev.pl, limings@nvidia.com, Asmaa Mnebhi <asmaa@nvidia.com>
Subject: Re: [PATCH net-next v1 2/4] mlxbf_gige: support 10M/100M/1G speeds
 on BlueField-3
Message-ID: <Y1sQ4tdhYzvNwrZJ@lunn.ch>
References: <20221027220013.24276-1-davthompson@nvidia.com>
 <20221027220013.24276-3-davthompson@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221027220013.24276-3-davthompson@nvidia.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +static void mlxbf_gige_bf3_adjust_link(struct net_device *netdev)
> +{
> +	struct mlxbf_gige *priv = netdev_priv(netdev);
> +	struct phy_device *phydev = netdev->phydev;
> +	unsigned long flags;
> +	u8 sgmii_mode;
> +	u16 ipg_size;
> +	u32 val;
> +
> +	spin_lock_irqsave(&priv->lock, flags);

What are you protecting with this spinlock?

phylib holds the phy mutex while it calls the adjust_link method, so
calls to it are serialised.

      Andrew
