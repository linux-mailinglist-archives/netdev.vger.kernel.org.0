Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 061746E0568
	for <lists+netdev@lfdr.de>; Thu, 13 Apr 2023 05:44:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229596AbjDMDoW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Apr 2023 23:44:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229522AbjDMDoU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Apr 2023 23:44:20 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2146126B3;
        Wed, 12 Apr 2023 20:44:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B1749618A8;
        Thu, 13 Apr 2023 03:44:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF756C433EF;
        Thu, 13 Apr 2023 03:44:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681357456;
        bh=1PPvIHWJLWZaXeNwvxpCYgYBMdUgCOq4oAMZ+tDARSA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=YC81KQbSbeIOZfW6h1vmXukqtShmRR80MyHthILoel5t8xoWmf3bzgUZlv3/FMQRJ
         34vEK6xEQJgzScb7rjYU4HUEc1k0JVsWYmh4/musAxPl+s000Voke0qAST4xdBSowd
         y+V507Af9Cv6g2L5fBBlnuorLfsZskrlYZ5j0mqPpP/7Usat6krJeVv/rf+VI1/TvG
         sWWemgBGufShxUtWDHJ73MxJXSGc1s2sXirMEceQwA/THEOT6bISjfRvITgb46UXuz
         GFGjWg1IlFSosY2VqrZ77PCz3mJnfQidg9oK9rUXMo5RQ3jMS1zPe+6d0FNclebm9G
         vm3WqAiI4R78w==
Date:   Wed, 12 Apr 2023 20:44:14 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     "Radu Pirea (OSS)" <radu-nicolae.pirea@oss.nxp.com>
Cc:     andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk,
        davem@davemloft.net, edumazet@google.com, pabeni@redhat.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH net] net: phy: nxp-c45-tja11xx: fix the PTP interrupt
 enabling/disabling
Message-ID: <20230412204414.72e89e5b@kernel.org>
In-Reply-To: <20230410124856.287753-1-radu-nicolae.pirea@oss.nxp.com>
References: <20230410124856.287753-1-radu-nicolae.pirea@oss.nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 10 Apr 2023 15:48:56 +0300 Radu Pirea (OSS) wrote:
> -	if (phydev->interrupts == PHY_INTERRUPT_ENABLED)
> +	if (phydev->interrupts == PHY_INTERRUPT_ENABLED) {
> +		phy_set_bits_mmd(phydev, MDIO_MMD_VEND1, PTP_IRQS, PTP_IRQS);

Isn't the third argument supposed to be the address?
Am I missing something or this patch was no tested properly?

Also why ignore the return value?

>  		return phy_set_bits_mmd(phydev, MDIO_MMD_VEND1,
>  					VEND1_PHY_IRQ_EN, PHY_IRQ_LINK_EVENT);
> -	else
> +	} else {
> +		phy_clear_bits_mmd(phydev, MDIO_MMD_VEND1, PTP_IRQS, PTP_IRQS);
>  		return phy_clear_bits_mmd(phydev, MDIO_MMD_VEND1,
>  					  VEND1_PHY_IRQ_EN, PHY_IRQ_LINK_EVENT);
> +	}
