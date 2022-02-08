Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 65AAE4ADDEA
	for <lists+netdev@lfdr.de>; Tue,  8 Feb 2022 17:05:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352041AbiBHQEj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Feb 2022 11:04:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1382687AbiBHQEi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Feb 2022 11:04:38 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1DF92C061578
        for <netdev@vger.kernel.org>; Tue,  8 Feb 2022 08:04:38 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B91EA61675
        for <netdev@vger.kernel.org>; Tue,  8 Feb 2022 16:04:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1347DC004E1;
        Tue,  8 Feb 2022 16:04:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644336277;
        bh=LTagtQyNrUO/mBER41G5+mY5pUfzxhO2HOwtIBCqqRc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ZDT2FpNih4QZnn6bJxbh88QgMWTX709MB5Z53YHsaeh65DgudKgf3//ns2fbcNQQE
         MKH8nD8td5WQ7x4DoDLRsI44DC0SABeo/4jrpov4OLRaeds5gMHJPVx/FXXmhfYalc
         zdWmTFuDZQLJQKppCWDBAaHJ1xRanp836p0yw3tejLEdnQofM8KhSkTq+4BZ2rzWSV
         aMcer/byqZcj4vDFOSxW9eIXKDJdYE1c9R/efqbK1BpBnMbDRGC/iUgexYyGymok9h
         nj00zKEcubPdhUmh20gQhx3hcw4SZgrheP+fU6FocTDkOqKtnQ/+fbshYk/Ofb8CdD
         cVF3HfxIDvRHg==
Date:   Tue, 8 Feb 2022 17:04:32 +0100
From:   Marek =?UTF-8?B?QmVow7pu?= <kabel@kernel.org>
To:     Holger Brunck <holger.brunck@hitachienergy.com>
Cc:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [v4] dsa: mv88e6xxx: make serdes SGMII/Fiber tx amplitude
 configurable
Message-ID: <20220208170432.6578540b@thinkpad>
In-Reply-To: <20220208094455.28870-1-holger.brunck@hitachienergy.com>
References: <20220208094455.28870-1-holger.brunck@hitachienergy.com>
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

On Tue,  8 Feb 2022 10:44:55 +0100
Holger Brunck <holger.brunck@hitachienergy.com> wrote:

> @@ -3011,6 +3014,22 @@ static int mv88e6xxx_setup_port(struct mv88e6xxx_chip *chip, int port)
>  			return err;
>  	}
>  
> +	if (chip->info->ops->serdes_set_tx_p2p_amplitude) {
> +		dp = dsa_to_port(ds, port);
> +		if (dp)
> +			phy_handle =  of_parse_phandle(dp->dn, "phy-handle", 0);

two spaces after '=' operator, only one needed

> +		if (phy_handle &&
> +		    !of_property_read_u32(phy_handle,
> +					  "tx-p2p-microvolt",
> +					  &tx_amp)) {
> +			err = mv88e6352_serdes_set_tx_p2p_amplitude(chip, port,
> +								    tx_amp);
> +			if (err)
> +				return err;
> +		}

you need to decrease reference of the phy_handle you just got with
of_parse_phandle:

  if (phy_handle)
    of_node_put(phy_handle);

> +	}
> +

> +struct mv88e6352_serdes_p2p_to_val {
> +	int mv;
> +	u16 regval;
> +};
> +
> +static struct mv88e6352_serdes_p2p_to_val mv88e6352_serdes_p2p_to_val[] = {
> +	/* Mapping of configurable mikrovolt values to the register value */
> +	{ 14000, 0},
> +	{ 112000, 1},
> +	{ 210000, 2},
> +	{ 308000, 3},
> +	{ 406000, 4},
> +	{ 504000, 5},
> +	{ 602000, 6},
> +	{ 700000, 7},

add spaces before ending '}'


Marek
