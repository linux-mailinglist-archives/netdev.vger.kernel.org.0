Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 90B0451C82F
	for <lists+netdev@lfdr.de>; Thu,  5 May 2022 20:42:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1384470AbiEESnQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 May 2022 14:43:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1384705AbiEESmr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 May 2022 14:42:47 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F22B67D2A;
        Thu,  5 May 2022 11:32:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2356DB82E13;
        Thu,  5 May 2022 18:32:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DFE37C385A4;
        Thu,  5 May 2022 18:32:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651775529;
        bh=saevwTVtK1oIhp5X1KAe86QQJ9Jdw5Oayt67KKcTRqQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=f24ERZau8AWQ9b6FxKPAlCB3MpdjnpMvJP3G4vuzN0Yca5vWOSA24AABXIrqhDHEM
         WAJyJ730bE4GnGbzfvb0holCfr+J+k/Yu5MVHE/wBPc7RnLsNm0fxY23+NsTRNiImf
         V4DgIi9XFVVKxu0HLzb9756d+CdFM82ikrD2O1nBBSV39x26jHUxdhQOZuHbQrblGL
         M/2RNOdrOO49sgtYcWuteQCszW8Cj959zrF1IYMdh9BeI3Or8PRmYr/VEsQVdQP/1k
         ndnPRDkJp7EsF+GYSIdhuJ9VIvD7HAvwDBLvTJJuF2esJSEmonAZ+BK9HlW4wH2vlJ
         8HjKbKzQvkJhw==
Date:   Thu, 5 May 2022 11:32:07 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Thomas Gleixner <tglx@linutronix.de>, Marc Zyngier <maz@kernel.org>
Cc:     Lukas Wunner <lukas@wunner.de>,
        "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-usb@vger.kernel.org,
        Steve Glendinning <steve.glendinning@shawell.net>,
        UNGLinuxDriver@microchip.com, Oliver Neukum <oneukum@suse.com>,
        Andre Edich <andre.edich@microchip.com>,
        Oleksij Rempel <linux@rempel-privat.de>,
        Martyn Welch <martyn.welch@collabora.com>,
        Gabriel Hojda <ghojda@yo2urs.ro>,
        Christoph Fritz <chf.fritz@googlemail.com>,
        Lino Sanfilippo <LinoSanfilippo@gmx.de>,
        Philipp Rosenberger <p.rosenberger@kunbus.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Russell King <linux@armlinux.org.uk>,
        Ferry Toth <fntoth@gmail.com>
Subject: Re: [PATCH net-next v2 5/7] usbnet: smsc95xx: Forward PHY
 interrupts to PHY driver to avoid polling
Message-ID: <20220505113207.487861b2@kernel.org>
In-Reply-To: <c6b7f4e4a17913d2f2bc4fe722df0804c2d6fea7.1651574194.git.lukas@wunner.de>
References: <cover.1651574194.git.lukas@wunner.de>
        <c6b7f4e4a17913d2f2bc4fe722df0804c2d6fea7.1651574194.git.lukas@wunner.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 3 May 2022 15:15:05 +0200 Lukas Wunner wrote:
> @@ -608,11 +618,20 @@ static void smsc95xx_status(struct usbnet *dev, struct urb *urb)
>  	intdata = get_unaligned_le32(urb->transfer_buffer);
>  	netif_dbg(dev, link, dev->net, "intdata: 0x%08X\n", intdata);
>  
> +	/* USB interrupts are received in softirq (tasklet) context.
> +	 * Switch to hardirq context to make genirq code happy.
> +	 */
> +	local_irq_save(flags);
> +	__irq_enter_raw();
> +
>  	if (intdata & INT_ENP_PHY_INT_)
> -		;
> +		generic_handle_domain_irq(pdata->irqdomain, PHY_HWIRQ);
>  	else
>  		netdev_warn(dev->net, "unexpected interrupt, intdata=0x%08X\n",
>  			    intdata);
> +
> +	__irq_exit_raw();
> +	local_irq_restore(flags);

IRQ maintainers could you cast your eyes over this?

Full patch:

https://lore.kernel.org/all/c6b7f4e4a17913d2f2bc4fe722df0804c2d6fea7.1651574194.git.lukas@wunner.de/
