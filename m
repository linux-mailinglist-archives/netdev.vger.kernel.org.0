Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 944D8E7E28
	for <lists+netdev@lfdr.de>; Tue, 29 Oct 2019 02:45:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728321AbfJ2Bp2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Oct 2019 21:45:28 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:39444 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727379AbfJ2Bp2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 28 Oct 2019 21:45:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=RuYxUdc/W/7NxTob3mw2B6JKicPy2tWU1RDw/ewMbEk=; b=IqBNceA6l4TwMcDxPk9wTKqfk9
        fOtugh4OGcQD9r47U/By99/6jgJZowuU1NaxeNJ+cipYoSVNyjCQMC5AzsbysYiRfkiQ/YiOgOd6M
        7sBxMXUjbdrcj1ln951X5uAr7cdgQHx4dYJeTDn3wxQh9asGtZ7IDAF5dMg4kaRmH9rc=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.92.2)
        (envelope-from <andrew@lunn.ch>)
        id 1iPGZX-0001Fg-8n; Tue, 29 Oct 2019 02:45:23 +0100
Date:   Tue, 29 Oct 2019 02:45:23 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Ioana Ciornei <ioana.ciornei@nxp.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        laurentiu.tudor@nxp.com, f.fainelli@gmail.com,
        linux@armlinux.org.uk
Subject: Re: [PATCH net-next v3 2/5] bus: fsl-mc: add the fsl_mc_get_endpoint
 function
Message-ID: <20191029014523.GH15259@lunn.ch>
References: <1571998630-17108-1-git-send-email-ioana.ciornei@nxp.com>
 <1571998630-17108-3-git-send-email-ioana.ciornei@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1571998630-17108-3-git-send-email-ioana.ciornei@nxp.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +struct fsl_mc_device *fsl_mc_get_endpoint(struct fsl_mc_device *mc_dev)
> +{
> +	struct fsl_mc_device *mc_bus_dev, *endpoint;
> +	struct fsl_mc_obj_desc endpoint_desc = { 0 };
> +	struct dprc_endpoint endpoint1 = { 0 };
> +	struct dprc_endpoint endpoint2 = { 0 };
> +	int state, err;
> +
> +	mc_bus_dev = to_fsl_mc_device(mc_dev->dev.parent);
> +	strcpy(endpoint1.type, mc_dev->obj_desc.type);
> +	endpoint1.id = mc_dev->obj_desc.id;
> +
> +	err = dprc_get_connection(mc_bus_dev->mc_io, 0,
> +				  mc_bus_dev->mc_handle,
> +				  &endpoint1, &endpoint2,
> +				  &state);
> +
> +	if (err == -ENOTCONN || state == -1)
> +		return NULL;
> +
> +	if (err < 0) {
> +		dev_err(&mc_bus_dev->dev, "dprc_get_connection() = %d\n", err);
> +		return NULL;
> +	}

You could return these errors with ERR_PRT(err)

    Andrew
