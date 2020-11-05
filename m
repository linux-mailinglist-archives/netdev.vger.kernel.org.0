Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 81AC92A73F0
	for <lists+netdev@lfdr.de>; Thu,  5 Nov 2020 01:45:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732576AbgKEApU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Nov 2020 19:45:20 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:36162 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729024AbgKEApU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 4 Nov 2020 19:45:20 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kaTOu-005J54-SD; Thu, 05 Nov 2020 01:45:16 +0100
Date:   Thu, 5 Nov 2020 01:45:16 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Ioana Ciornei <ciorneiioana@gmail.com>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: Re: [RFC 5/9] staging: dpaa2-switch: handle Rx path on control
 interface
Message-ID: <20201105004516.GG933237@lunn.ch>
References: <20201104165720.2566399-1-ciorneiioana@gmail.com>
 <20201104165720.2566399-6-ciorneiioana@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201104165720.2566399-6-ciorneiioana@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +/* Manage all NAPI instances for the control interface.
> + *
> + * We only have one RX queue and one Tx Conf queue for all
> + * switch ports. Therefore, we only need to enable the NAPI instance once, the
> + * first time one of the switch ports runs .dev_open().
> + */
> +
> +static void dpaa2_switch_enable_ctrl_if_napi(struct ethsw_core *ethsw)
> +{
> +	int i;
> +
> +	/* a new interface is using the NAPI instance */
> +	ethsw->napi_users++;
> +
> +	/* if there is already a user of the instance, return */
> +	if (ethsw->napi_users > 1)
> +		return;

Does there need to be any locking here? Or does it rely on RTNL?
Maybe a comment would be nice, or a check that RTNL is actually held.

> +
> +	if (!dpaa2_switch_has_ctrl_if(ethsw))
> +		return;
> +
> +	for (i = 0; i < DPAA2_SWITCH_RX_NUM_FQS; i++)
> +		napi_enable(&ethsw->fq[i].napi);
> +}

> +static void dpaa2_switch_rx(struct dpaa2_switch_fq *fq,
> +			    const struct dpaa2_fd *fd)
> +{
> +	struct ethsw_core *ethsw = fq->ethsw;
> +	struct ethsw_port_priv *port_priv;
> +	struct net_device *netdev;
> +	struct vlan_ethhdr *hdr;
> +	struct sk_buff *skb;
> +	u16 vlan_tci, vid;
> +	int if_id = -1;
> +	int err;
> +
> +	/* prefetch the frame descriptor */
> +	prefetch(fd);

Does this actually do any good, given that the next call:

> +
> +	/* get switch ingress interface ID */
> +	if_id = upper_32_bits(dpaa2_fd_get_flc(fd)) & 0x0000FFFF;

is accessing the frame descriptor? The idea of prefetch is to let it
bring it into the cache while you are busy doing something else,
hopefully with something which is already cache hot.

	  Andrew
