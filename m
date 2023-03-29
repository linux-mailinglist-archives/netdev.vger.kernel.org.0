Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 443D06CCFAF
	for <lists+netdev@lfdr.de>; Wed, 29 Mar 2023 03:57:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229617AbjC2B5Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Mar 2023 21:57:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229484AbjC2B5X (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Mar 2023 21:57:23 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4064BE;
        Tue, 28 Mar 2023 18:57:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 63F0D61A09;
        Wed, 29 Mar 2023 01:57:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08E95C433EF;
        Wed, 29 Mar 2023 01:57:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680055041;
        bh=Ht1onyfcmzOw2qKX1pJ8D5vEoEK4zHwhkFnjwVJVLG0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=dTjfxYX88Y0GCwguIOU1z+LJD7YjITgEt48phbqGQKQ0v7xyRPUlWTGG8ljYZGMPx
         0/x+CHkbC2HY8yFmHVsbqndOTDL9ByGVqxLl5kIcAIJ07W8qkrfxenDnG02z9jXb+u
         wV2AVnB88zfjoRmbnN5IAOwoihywT6e3CPTesZchHWA/NGIKggHkutdwnfwqI7HSgN
         JjCcMNvpZTTGEdKJGCSu8gvk3QFYEeiQ78wiStgkfqmlgF1jolj31mAn7D0CJHwZ3k
         IxIrVltQ/5gkNK2cmhSvvF/EiHa8lg5j29FiLgRu3cDDK86Hm39L/zdsGXriOLWaRF
         OBtsV1EKoVnsQ==
Date:   Tue, 28 Mar 2023 18:57:20 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     linux@armlinux.org.uk
Cc:     Michael Sit Wei Hong <michael.wei.hong.sit@intel.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Ong Boon Leong <boon.leong.ong@intel.com>,
        netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Looi Hong Aun <hong.aun.looi@intel.com>,
        Voon Weifeng <weifeng.voon@intel.com>,
        Lai Peter Jun Ann <peter.jun.ann.lai@intel.com>
Subject: Re: [PATCH net v3 1/3] net: phylink: add phylink_expects_phy()
 method
Message-ID: <20230328185720.6239e4a7@kernel.org>
In-Reply-To: <20230324081656.2969663-2-michael.wei.hong.sit@intel.com>
References: <20230324081656.2969663-1-michael.wei.hong.sit@intel.com>
        <20230324081656.2969663-2-michael.wei.hong.sit@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 24 Mar 2023 16:16:54 +0800 Michael Sit Wei Hong wrote:
> Provide phylink_expects_phy() to allow MAC drivers to check if it
> is expecting a PHY to attach to. Since fixed-linked setups do not
> need to attach to a PHY.
> 
> Provides a boolean value as to if the MAC should expect a PHY.
> returns true if a PHY is expected.
> 
> Signed-off-by: Michael Sit Wei Hong <michael.wei.hong.sit@intel.com>

Russell, looks good?

> diff --git a/drivers/net/phy/phylink.c b/drivers/net/phy/phylink.c
> index 1a2f074685fa..5c2bd1370993 100644
> --- a/drivers/net/phy/phylink.c
> +++ b/drivers/net/phy/phylink.c
> @@ -1586,6 +1586,19 @@ void phylink_destroy(struct phylink *pl)
>  }
>  EXPORT_SYMBOL_GPL(phylink_destroy);
>  
> +/**
> + * phylink_expects_phy() - Determine if phylink expects a phy to be attached
> + * @pl: a pointer to a &struct phylink returned from phylink_create()
> + *
> + * Fixed-link mode does not need a PHY, returns a boolean value to check if
> + * phylink will be expecting a PHY to attach.
> + */
> +bool phylink_expects_phy(struct phylink *pl)
> +{
> +	return pl->cfg_link_an_mode != MLO_AN_FIXED;
> +}
> +EXPORT_SYMBOL_GPL(phylink_expects_phy);
> +
>  static void phylink_phy_change(struct phy_device *phydev, bool up)
>  {
>  	struct phylink *pl = phydev->phylink;
> diff --git a/include/linux/phylink.h b/include/linux/phylink.h
> index c492c26202b5..637698ed5cb6 100644
> --- a/include/linux/phylink.h
> +++ b/include/linux/phylink.h
> @@ -574,6 +574,7 @@ struct phylink *phylink_create(struct phylink_config *, struct fwnode_handle *,
>  			       phy_interface_t iface,
>  			       const struct phylink_mac_ops *mac_ops);
>  void phylink_destroy(struct phylink *);
> +bool phylink_expects_phy(struct phylink *pl);
>  
>  int phylink_connect_phy(struct phylink *, struct phy_device *);
>  int phylink_of_phy_connect(struct phylink *, struct device_node *, u32 flags);

