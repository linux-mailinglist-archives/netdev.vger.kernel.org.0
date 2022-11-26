Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4F62663976D
	for <lists+netdev@lfdr.de>; Sat, 26 Nov 2022 18:16:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229551AbiKZRQj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 26 Nov 2022 12:16:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229450AbiKZRQh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 26 Nov 2022 12:16:37 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26E301B795;
        Sat, 26 Nov 2022 09:16:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=5Hw31AgKId+3OPnZUDNl0zoIziLgXdVSUBBYyPkaxJA=; b=OCNEu2IqIwoJjsrj84rge722+P
        RCBQrmpgb9mdXI9VD8F20jmskv9EXiEWZ3OLgbZYVlvfihZ72zXFj7kP7fbl7nxFMxoE32dnB/PAz
        UZBIVukz0RCsu8ib0W6SZacXCPcG89vQXQnM/l9dZ/rJC19xnv7kYY4Uh20Emz0SSUPk=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1oyyn2-003WW5-Gn; Sat, 26 Nov 2022 18:16:32 +0100
Date:   Sat, 26 Nov 2022 18:16:32 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Vincent Mailhol <mailhol.vincent@wanadoo.fr>
Cc:     linux-can@vger.kernel.org, Marc Kleine-Budde <mkl@pengutronix.de>,
        linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        netdev@vger.kernel.org, linux-usb@vger.kernel.org,
        Saeed Mahameed <saeed@kernel.org>,
        Jiri Pirko <jiri@nvidia.com>,
        Lukas Magel <lukas.magel@posteo.net>
Subject: Re: [PATCH v4 3/6] can: etas_es58x: export product information
 through devlink_ops::info_get()
Message-ID: <Y4JJ8Dyz7urLz/IM@lunn.ch>
References: <20221104073659.414147-1-mailhol.vincent@wanadoo.fr>
 <20221126162211.93322-1-mailhol.vincent@wanadoo.fr>
 <20221126162211.93322-4-mailhol.vincent@wanadoo.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221126162211.93322-4-mailhol.vincent@wanadoo.fr>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +struct es58x_sw_version {
> +	u8 major;
> +	u8 minor;
> +	u8 revision;
> +};

> +static int es58x_devlink_info_get(struct devlink *devlink,
> +				  struct devlink_info_req *req,
> +				  struct netlink_ext_ack *extack)
> +{
> +	struct es58x_device *es58x_dev = devlink_priv(devlink);
> +	struct es58x_sw_version *fw_ver = &es58x_dev->firmware_version;
> +	struct es58x_sw_version *bl_ver = &es58x_dev->bootloader_version;
> +	struct es58x_hw_revision *hw_rev = &es58x_dev->hardware_revision;
> +	char buf[max(sizeof("xx.xx.xx"), sizeof("axxx/xxx"))];
> +	int ret = 0;
> +
> +	if (es58x_sw_version_is_set(fw_ver)) {
> +		snprintf(buf, sizeof(buf), "%02u.%02u.%02u",
> +			 fw_ver->major, fw_ver->minor, fw_ver->revision);

I see you have been very careful here, but i wonder if you might still
get some compiler/static code analyser warnings here. As far as i
remember %02u does not limit it to two characters. If the number is
bigger than 99, it will take three characters. And your types are u8,
so the compiler could consider these to be 3 characters each. So you
end up truncating. Which you look to of done correctly, but i wonder
if some over zealous checker will report it? Maybe consider
"xxx.xxx.xxx"?

Nice paranoid code by the way. I'm not the best at spotting potential
buffer overflows, but this code looks good. The only question i had
left was how well sscanf() deals with UTF-8.

     Andrew

