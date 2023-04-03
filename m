Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DAC986D4584
	for <lists+netdev@lfdr.de>; Mon,  3 Apr 2023 15:22:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229603AbjDCNWI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Apr 2023 09:22:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229473AbjDCNWG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Apr 2023 09:22:06 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C326AB44E
        for <netdev@vger.kernel.org>; Mon,  3 Apr 2023 06:22:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=Qp99Y5L6gi8Fe+lh52JUdZX5o1lcsIuZMntIrefzP1Y=; b=e4eAQFRt94DwPcxZ426OEG/blM
        fGF6kGnFYGXsgt6epcXQWAQW82nZO6VQDU053UgVYTNW4Cusm86ZmRidAEiyxQbPtkA+Y09MDlh0V
        NYa1zVLAqqFYKSbGGtY7iY8YydliVVosvebVHWcG+pdYF+u1QfXD6jL5GY3rWNSYsxkg=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1pjK8J-009HjN-Hj; Mon, 03 Apr 2023 15:22:03 +0200
Date:   Mon, 3 Apr 2023 15:22:03 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Jiawen Wu <jiawenwu@trustnetic.com>
Cc:     netdev@vger.kernel.org, linux@armlinux.org.uk,
        mengyuanlou@net-swift.com
Subject: Re: [PATCH net-next 6/6] net: txgbe: Support phylink MAC layer
Message-ID: <ca3c82a9-4160-422a-a618-04ab04a19015@lunn.ch>
References: <20230403064528.343866-1-jiawenwu@trustnetic.com>
 <20230403064528.343866-7-jiawenwu@trustnetic.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230403064528.343866-7-jiawenwu@trustnetic.com>
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> @@ -215,23 +216,15 @@ static void txgbe_up_complete(struct wx *wx)
>  	smp_mb__before_atomic();
>  	wx_napi_enable_all(wx);
>  
> +	phylink_start(txgbe->phylink);
> +

>  static void txgbe_down(struct wx *wx)
>  {
> +	struct txgbe *txgbe = (struct txgbe *)wx->priv;
> +
>  	txgbe_disable_device(wx);
>  	txgbe_reset(wx);
> +	if (txgbe->phylink)
> +		phylink_stop(txgbe->phylink);

You uncoditionally phylink_start(). Does this need to be conditional?

> +static void txgbe_mac_config(struct phylink_config *config, unsigned int mode,
> +			     const struct phylink_link_state *state)
> +{
> +}

That is very likely to be wrong. Lets see what Russell says.

     Andrew
