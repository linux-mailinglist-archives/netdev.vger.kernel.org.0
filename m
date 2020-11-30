Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 901792C8ABD
	for <lists+netdev@lfdr.de>; Mon, 30 Nov 2020 18:21:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729216AbgK3RV2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Nov 2020 12:21:28 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:57844 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728162AbgK3RV1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 30 Nov 2020 12:21:27 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kjmqo-009XnF-OI; Mon, 30 Nov 2020 18:20:34 +0100
Date:   Mon, 30 Nov 2020 18:20:34 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Vignesh Raghavendra <vigneshr@ti.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Jonathan Corbet <corbet@lwn.net>, Jiri Pirko <jiri@nvidia.com>,
        netdev@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Linux ARM Mailing List <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 3/4] net: ti: am65-cpsw-nuss: Add switchdev support
Message-ID: <20201130172034.GF2073444@lunn.ch>
References: <20201130082046.16292-1-vigneshr@ti.com>
 <20201130082046.16292-4-vigneshr@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201130082046.16292-4-vigneshr@ti.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +static int am65_cpsw_port_stp_state_set(struct am65_cpsw_port *port,
> +					struct switchdev_trans *trans, u8 state)
> +{
> +	struct am65_cpsw_common *cpsw = port->common;
> +	u8 cpsw_state;
> +	int ret = 0;
> +
> +	if (switchdev_trans_ph_prepare(trans))
> +		return 0;
> +
> +	switch (state) {
> +	case BR_STATE_FORWARDING:
> +		cpsw_state = ALE_PORT_STATE_FORWARD;
> +		break;
> +	case BR_STATE_LEARNING:
> +		cpsw_state = ALE_PORT_STATE_LEARN;
> +		break;
> +	case BR_STATE_DISABLED:
> +		cpsw_state = ALE_PORT_STATE_DISABLE;
> +		break;
> +	case BR_STATE_LISTENING:
> +	case BR_STATE_BLOCKING:
> +		cpsw_state = ALE_PORT_STATE_BLOCK;
> +		break;
> +	default:
> +		return -EOPNOTSUPP;
> +	}

Strictly speaking, the:

> +	if (switchdev_trans_ph_prepare(trans))
> +		return 0;

should be here. In the prepare phase, you are suppose to validate you
can do the requested action, and return an error is not. In second
phase, actually carrying out the action, you then never return an
error.

But in this case, you are handling all the bridge states, so it should
not matter.

    Andrew
