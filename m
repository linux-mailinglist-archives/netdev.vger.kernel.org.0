Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 52A75605ED1
	for <lists+netdev@lfdr.de>; Thu, 20 Oct 2022 13:28:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231308AbiJTL2Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Oct 2022 07:28:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231335AbiJTL2Y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Oct 2022 07:28:24 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04EBE11CB4F;
        Thu, 20 Oct 2022 04:28:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=Zykh0+WPGN9uC9knxmTn71hjuvUREHosM5NpuyOqmLE=; b=ak23Vnaqq9Qv1bB9sejzP8Afv0
        aztN6bxfGj6qgx77Dbjg5PaK/OHt2DBNZUngZb4x+hI6eZ+rc2xGHf89c72/a8+T1Fl9F/gRv8Ad7
        jmQgrsvd04lB84yTh+gJJVWYV2qvy7e8Ezb7yEnEpjlLlA+dylVxTYdUlXsdSiFo9HBpafxl5gzY4
        URaqvIw82Cd8h0k/frDSzbgabj6UnSJ7K/zX6bO1/UnMp3qRpsCwbp7LOqsBZ0NQerqp9I4CcYXHb
        G2CEZA/rX4R95t2mrppMqtPRT/UzPSj8OIz8aft+5TGx8O+Lyzk86gMmSr0Zek3EH/O6hl8oBUWUW
        1IHtFjxw==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:34820)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1olTij-0006wC-Q6; Thu, 20 Oct 2022 12:28:17 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1olTif-00037n-DO; Thu, 20 Oct 2022 12:28:13 +0100
Date:   Thu, 20 Oct 2022 12:28:13 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Alexandru Tachici <alexandru.tachici@analog.com>
Cc:     linux-kernel@vger.kernel.org, andrew@lunn.ch, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, lennart@lfdomain.com
Subject: Re: [net v2 1/1] net: ethernet: adi: adin1110: Fix notifiers
Message-ID: <Y1EwzRa3SNpA0++W@shell.armlinux.org.uk>
References: <20221020094804.13527-1-alexandru.tachici@analog.com>
 <20221020094804.13527-2-alexandru.tachici@analog.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221020094804.13527-2-alexandru.tachici@analog.com>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Thu, Oct 20, 2022 at 12:48:04PM +0300, Alexandru Tachici wrote:
> @@ -1688,7 +1684,31 @@ static struct spi_driver adin1110_driver = {
>  	.probe = adin1110_probe,
>  	.id_table = adin1110_spi_id,
>  };
> -module_spi_driver(adin1110_driver);
> +
> +static int __init adin1110_driver_init(void)
> +{
> +	int err;
> +
> +	err = spi_register_driver(&adin1110_driver);
> +	if (err)
> +		return err;

This is the point that devices can be bound and thus published to
userspace.

> +
> +	err = adin1110_setup_notifiers();
> +	if (err) {
> +		spi_unregister_driver(&adin1110_driver);
> +		return err;
> +	}

And you setup the notifier after, so there is a window when
notifications could be lost. Is this safe?

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
