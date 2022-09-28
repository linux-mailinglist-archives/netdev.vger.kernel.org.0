Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D78195ED24A
	for <lists+netdev@lfdr.de>; Wed, 28 Sep 2022 02:55:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231218AbiI1Azz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Sep 2022 20:55:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229838AbiI1Azx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Sep 2022 20:55:53 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3EA0AB6002;
        Tue, 27 Sep 2022 17:55:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3B2F061CD5;
        Wed, 28 Sep 2022 00:55:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C74ABC433D6;
        Wed, 28 Sep 2022 00:55:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664326550;
        bh=zhby2WkIY+2vrCBlQlJB7Z8ZYK63F+z7AimfqPfjWLE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=to5ua9epoOC+ymk9knNoNS4MY4yEPYove5Pzd3K3o8PT9BbZdfp7LLQrRlRiKPlJH
         ux4BX346zXOZi9V3bXwDlfvvyFcjim3ns5uMp5TX8ZNIxLOKHDmtPoHxEgt0ztNJao
         lE8PfKVJqpu6UbVx2ZvFMX/8feDO37p5Yvt9i2Gv8ZZqmPZbcYtjKOhWLI3d1/NQ1y
         cGCdGj24TqhSarzL2E3Ypy7ogZmk+zZdxUDInYzeQrXjlGrUc0/AkqgdjYq2vWb9tq
         2Nj+Ky5nRFnaqysA/ZmTCyT0CBLMWa9r6muHcyd/mlGIUvRO9EKO+EkSTVLSQyARvj
         TTmuG2NePkuOA==
Date:   Tue, 27 Sep 2022 17:55:48 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Russell King <linux@armlinux.org.uk>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Jonathan Corbet <corbet@lwn.net>, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        David Jander <david@protonic.nl>,
        Luka Perkov <luka.perkov@sartura.hr>,
        Robert Marko <robert.marko@sartura.hr>
Subject: Re: [PATCH net-next v7 4/7] net: mdiobus: search for PSE nodes by
 parsing PHY nodes.
Message-ID: <20220927175548.331d9bae@kernel.org>
In-Reply-To: <20220926112500.990705-5-o.rempel@pengutronix.de>
References: <20220926112500.990705-1-o.rempel@pengutronix.de>
        <20220926112500.990705-5-o.rempel@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 26 Sep 2022 13:24:57 +0200 Oleksij Rempel wrote:
> +static struct pse_control *
> +fwnode_find_pse_control(struct fwnode_handle *fwnode)
> +{
> +	struct pse_control *psec;
> +	struct device_node *np;
> +
> +	np = to_of_node(fwnode);
> +	if (!np)
> +		return NULL;
> +
> +	psec = of_pse_control_get(np);

This will fail with ENOTSUPP if PSE is not built. Won't that make all
fwnode_mdiobus_register_phy() calls fail?

static inline struct pse_control *of_pse_control_get(struct device_node *node)
{
	return ERR_PTR(-ENOTSUPP);
}

Actually let me take a closer look at patch 2 :S

> +	if (PTR_ERR(psec) == -ENOENT)
> +		return NULL;
> +
> +	return psec;
> +}

