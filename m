Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 33E0F139412
	for <lists+netdev@lfdr.de>; Mon, 13 Jan 2020 15:58:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728755AbgAMO6G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jan 2020 09:58:06 -0500
Received: from relay2-d.mail.gandi.net ([217.70.183.194]:59795 "EHLO
        relay2-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726567AbgAMO6F (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jan 2020 09:58:05 -0500
X-Originating-IP: 90.76.211.102
Received: from localhost (lfbn-tou-1-1151-102.w90-76.abo.wanadoo.fr [90.76.211.102])
        (Authenticated sender: antoine.tenart@bootlin.com)
        by relay2-d.mail.gandi.net (Postfix) with ESMTPSA id BFC4640007;
        Mon, 13 Jan 2020 14:57:58 +0000 (UTC)
Date:   Mon, 13 Jan 2020 15:57:58 +0100
From:   Antoine Tenart <antoine.tenart@bootlin.com>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     Antoine Tenart <antoine.tenart@bootlin.com>, davem@davemloft.net,
        sd@queasysnail.net, andrew@lunn.ch, f.fainelli@gmail.com,
        hkallweit1@gmail.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, thomas.petazzoni@bootlin.com,
        alexandre.belloni@bootlin.com, allan.nielsen@microchip.com,
        camelia.groza@nxp.com, Simon.Edelhaus@aquantia.com,
        Igor.Russkikh@aquantia.com, jakub.kicinski@netronome.com
Subject: Re: [PATCH net-next v5 05/15] net: macsec: hardware offloading
 infrastructure
Message-ID: <20200113145758.GB3078@kwain>
References: <20200110162010.338611-1-antoine.tenart@bootlin.com>
 <20200110162010.338611-6-antoine.tenart@bootlin.com>
 <20200113143452.GA2131@nanopsycho>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200113143452.GA2131@nanopsycho>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Jiri,

On Mon, Jan 13, 2020 at 03:34:52PM +0100, Jiri Pirko wrote:
> Fri, Jan 10, 2020 at 05:20:00PM CET, antoine.tenart@bootlin.com wrote:
> 
> Couple nitpicks I randomly spotted:
> 
> [...]
> 
> 
> >+static bool macsec_is_offloaded(struct macsec_dev *macsec)
> >+{
> >+	if (macsec->offload == MACSEC_OFFLOAD_PHY)
> >+		return true;
> >+
> >+	return false;
> 
> Just:
> 	return macsec->offload == MACSEC_OFFLOAD_PHY;

This construction is because I split the phy offloading support from the
MAC one, and this check becomes more complex when the MAC offloading
support is applied. I could check it's not MACSEC_OFFLOAD_OFF, but I
think it's nice having the default set to false when reading the code.

> >+/* Checks if underlying layers implement MACsec offloading functions. */
> >+static bool macsec_check_offload(enum macsec_offload offload,
> >+				 struct macsec_dev *macsec)
> >+{
> >+	if (!macsec || !macsec->real_dev)
> >+		return false;
> >+
> >+	if (offload == MACSEC_OFFLOAD_PHY)
> 
> You have a helper for this already - macsec_is_offloaded(). No need for
> "offload" arg then.

Same here, except the _PHY case is different from the _MAC one. So the
check needs to be specific to _PHY.

> >+		return macsec->real_dev->phydev &&
> >+		       macsec->real_dev->phydev->macsec_ops;
> >+
> >+	return false;
> >+}
> >+
> >+static const struct macsec_ops *__macsec_get_ops(enum macsec_offload offload,
> >+						 struct macsec_dev *macsec,
> >+						 struct macsec_context *ctx)
> >+{
> >+	if (ctx) {
> >+		memset(ctx, 0, sizeof(*ctx));
> >+		ctx->offload = offload;
> >+
> >+		if (offload == MACSEC_OFFLOAD_PHY)
> 
> Same here.

Same here.

Thanks,
Antoine

-- 
Antoine Ténart, Bootlin
Embedded Linux and Kernel engineering
https://bootlin.com
