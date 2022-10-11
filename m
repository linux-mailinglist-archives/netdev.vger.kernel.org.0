Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 77EDB5FAA55
	for <lists+netdev@lfdr.de>; Tue, 11 Oct 2022 03:51:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229484AbiJKBvq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Oct 2022 21:51:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229614AbiJKBvn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Oct 2022 21:51:43 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 008667A75B;
        Mon, 10 Oct 2022 18:51:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=Vcn6Emy3G7xg1a8DUuh3MW2BLhxYU6+5G9TxFvJ9h7A=; b=ewhcvp6ZoKnszAUdfECoXEFPLh
        na/To6yfAcjk1h9gccU3cn5tJzFqcL6j9sMOTkc686iCUirnyhvsjaB/PM4gt/qpKFydHZ5Vzo3n1
        RUPo5GAPrwSMZHXBlnsPS/9CDqXWzSpbcjrIru3ET1S7JsPCw9AEn/oWyZSDHeA5be04=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1oi4Qa-001g1Q-6M; Tue, 11 Oct 2022 03:51:28 +0200
Date:   Tue, 11 Oct 2022 03:51:28 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Furkan Kardame <f.kardame@manjaro.org>
Cc:     pgwipeout@gmail.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: phy: add support for Motorcomm yt8531C phy
Message-ID: <Y0TMIMPJbOETFQ3f@lunn.ch>
References: <20221009192405.97118-1-f.kardame@manjaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221009192405.97118-1-f.kardame@manjaro.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +#define YT8531_RGMII_CONFIG1	0xa003
> +
> +/* TX Gig-E Delay is bits 3:0, default 0x1
> + * TX Fast-E Delay is bits 7:4, default 0xf
> + * RX Delay is bits 13:10, default 0x0
> + * Delay = 150ps * N
> + * On = 2000ps, off = 50ps
> + */
> +#define YT8531_DELAY_GE_TX_EN	(0xd << 0)
> +#define YT8531_DELAY_GE_TX_DIS	(0x0 << 0)

The comments above and the value here don't correspond.  These seem to
be enable/disable, which is usually a single bit. Here you have 3 bits
set? And what about the default 0x1?

0xd is 13. 13*150 = 1950, which is about 2000ps?

So YT8531_DELAY_GE_TX_EN is not really enable, it is
YT8531_DELAY_GE_TX_1950_PS, and YT8531_DELAY_GE_TX_DIS should be
YT8531_DELAY_GE_TX_0_PS.

> +#define YT8531_DELAY_FE_TX_EN	(0xd << 4)
> +#define YT8531_DELAY_FE_TX_DIS	(0x0 << 4)

Default is 0xf?

> +#define YT8531_DELAY_RX_EN	(0xd << 10)
> +#define YT8531_DELAY_RX_DIS	(0x0 << 10)
> +#define YT8531_DELAY_MASK	(GENMASK(13, 10) | GENMASK(7, 0))

Please rework these.

> +	ret = __phy_write(phydev, YT8511_PAGE, YT8531_CLKCFG_125M);
> +	if (ret < 0)
> +		goto err_restore_page;

This if statement is pointless.

> +
> +err_restore_page:
> +	return phy_restore_page(phydev, oldpage, ret);
> +}
> +
