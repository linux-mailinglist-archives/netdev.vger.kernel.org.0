Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 107DC34BD13
	for <lists+netdev@lfdr.de>; Sun, 28 Mar 2021 17:53:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229499AbhC1Pws (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 28 Mar 2021 11:52:48 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:51872 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229593AbhC1Pwr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 28 Mar 2021 11:52:47 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1lQXiV-00DTZ9-6o; Sun, 28 Mar 2021 17:52:43 +0200
Date:   Sun, 28 Mar 2021 17:52:43 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Tobias Waldekranz <tobias@waldekranz.com>
Cc:     davem@davemloft.net, kuba@kernel.org, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, olteanv@gmail.com, netdev@vger.kernel.org,
        robh+dt@kernel.org, devicetree@vger.kernel.org
Subject: Re: [PATCH net-next 2/3] net: dsa: Allow default tag protocol to be
 overridden from DT
Message-ID: <YGCmS2rcypegGmYa@lunn.ch>
References: <20210326105648.2492411-1-tobias@waldekranz.com>
 <20210326105648.2492411-3-tobias@waldekranz.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210326105648.2492411-3-tobias@waldekranz.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +static int dsa_switch_setup_tag_protocol(struct dsa_switch *ds)
> +{
> +	const struct dsa_device_ops *tag_ops = ds->dst->tag_ops;
> +	struct dsa_switch_tree *dst = ds->dst;
> +	int port, err;
> +
> +	if (tag_ops->proto == dst->default_proto)
> +		return 0;
> +
> +	if (!ds->ops->change_tag_protocol) {
> +		dev_err(ds->dev, "Tag protocol cannot be modified\n");
> +		return -EINVAL;
> +	}
> +
> +	for (port = 0; port < ds->num_ports; port++) {
> +		if (!(dsa_is_dsa_port(ds, port) || dsa_is_cpu_port(ds, port)))
> +			continue;

dsa_is_dsa_port() is interesting. Do we care about the tagging
protocol on DSA ports? We never see that traffic?

> +
> +		err = ds->ops->change_tag_protocol(ds, port, tag_ops->proto);
> +		if (err) {
> +			dev_err(ds->dev, "Tag protocol \"%s\" is not supported\n",
> +				tag_ops->name);
> +			return err;
> +		}
> +	}
> +
> +	return 0;
> +}
> +

> -static int dsa_port_parse_cpu(struct dsa_port *dp, struct net_device *master)
> +static int dsa_port_parse_cpu(struct dsa_port *dp, struct net_device *master,
> +			      const char *user_protocol)
>  {
>  	struct dsa_switch *ds = dp->ds;
>  	struct dsa_switch_tree *dst = ds->dst;
> -	enum dsa_tag_protocol tag_protocol;
> +	const struct dsa_device_ops *tag_ops;
> +	enum dsa_tag_protocol default_proto;
> +
> +	/* Find out which protocol the switch would prefer. */
> +	default_proto = dsa_get_tag_protocol(dp, master);
> +	if (dst->default_proto) {
> +		if (dst->default_proto != default_proto) {
> +			dev_err(ds->dev,
> +				"A DSA switch tree can have only one tagging protovol\n");
> +			return -EINVAL;
> +		}
> +	} else {
> +		dst->default_proto = default_proto;
> +	}
> +
> +	/* See if the user wants to override that preference. */
> +	if (user_protocol && ds->ops->change_tag_protocol) {
> +		tag_ops = dsa_find_tagger_by_name(user_protocol);
> +	} else {
> +		if (user_protocol)
> +			dev_warn(ds->dev,
> +				 "Tag protocol cannot be modified, using default\n");

I would probably error out here. I don't think it is a good idea to
ignore what DT says. We also potentially have forward compatibility
problems. Somebody cut/pastes a DT fragment including an invalid
override. But the driver does not support it, so it just gives this
warning and keeps going. Sometime in the future, change support is
added, it then becomes a real error, and the driver stops probing.

       Andrew
