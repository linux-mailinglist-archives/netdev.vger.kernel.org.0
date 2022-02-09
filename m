Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5CA8B4AF1D4
	for <lists+netdev@lfdr.de>; Wed,  9 Feb 2022 13:36:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231526AbiBIMgh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Feb 2022 07:36:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229996AbiBIMgg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Feb 2022 07:36:36 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B2ADC0613CA
        for <netdev@vger.kernel.org>; Wed,  9 Feb 2022 04:36:39 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8C8FFB81ED4
        for <netdev@vger.kernel.org>; Wed,  9 Feb 2022 12:36:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13D91C340EE;
        Wed,  9 Feb 2022 12:36:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644410197;
        bh=7Jq8q7ZqC3/EGlSapy4ormfKALb0Jo7CwApDfTPRS4U=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=orLSi44QmWuN5o2Rg/trhlJiahxoSIXmcnTwn6AiozhNVjKnYbbhTN/1eeEY1C3iA
         o5R1pIUPcwban7PiH03acnVNDZo645LB6SjymIrbV7wfIHzE9dqfJqMbBuWpH4uzxW
         DxgdVDAcEt3Rw7m1ossTOXUDXyWAS9jc+Cbr7XVU83Mh+r1pMo+LbzAEmbrCN8ZDVK
         YJYLMGPadQTdyfycKJnw4Xqqbx6nXr/csOAqp7vtWI+DzP/m/I1hbqKQRvViupmcxB
         KVbV+HvFxvcR59Hyi+aQRl8Nrw8B7JPvIEkzV2Y4c5UCorSAFq+GH/wF3vOsm1o6v0
         zC7R6Bg7TmE3w==
Date:   Wed, 9 Feb 2022 13:36:31 +0100
From:   Marek =?UTF-8?B?QmVow7pu?= <kabel@kernel.org>
To:     Holger Brunck <holger.brunck@hitachienergy.com>
Cc:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [v5] dsa: mv88e6xxx: make serdes SGMII/Fiber tx amplitude
 configurable
Message-ID: <20220209133631.1954a69b@dellmb>
In-Reply-To: <20220209095427.30568-1-holger.brunck@hitachienergy.com>
References: <20220209095427.30568-1-holger.brunck@hitachienergy.com>
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed,  9 Feb 2022 10:54:27 +0100
Holger Brunck <holger.brunck@hitachienergy.com> wrote:

> @@ -3178,6 +3181,25 @@ static int mv88e6xxx_setup_port(struct mv88e6xxx_chip *chip, int port)
>  			return err;
>  	}
>  
> +	if (chip->info->ops->serdes_set_tx_p2p_amplitude) {
> +		dp = dsa_to_port(ds, port);
> +		if (dp)
> +			phy_handle = of_parse_phandle(dp->dn, "phy-handle", 0);
> +
> +		if (phy_handle && !of_property_read_u32(phy_handle,
> +							"tx-p2p-microvolt",
> +							&tx_amp)) {
> +			err = mv88e6352_serdes_set_tx_p2p_amplitude(chip, port,
> +								    tx_amp);

You should use
  err = chip->info->ops->serdes_set_tx_p2p_amplitude(...);
instead of
  err = mv88e6352_serdes_set_tx_p2p_amplitude(...);
since you are adding this operation to the operations structure and
since mv88e6xxx_setup_port() is a generic method.

Sorry, I overlooked this in v4 :-(

Marek
