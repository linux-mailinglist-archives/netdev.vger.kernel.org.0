Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3496934BCE9
	for <lists+netdev@lfdr.de>; Sun, 28 Mar 2021 17:25:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231370AbhC1PZS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 28 Mar 2021 11:25:18 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:51852 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231149AbhC1PYx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 28 Mar 2021 11:24:53 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1lQXHQ-00DTKW-JA; Sun, 28 Mar 2021 17:24:44 +0200
Date:   Sun, 28 Mar 2021 17:24:44 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Tobias Waldekranz <tobias@waldekranz.com>
Cc:     davem@davemloft.net, kuba@kernel.org, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, olteanv@gmail.com, netdev@vger.kernel.org,
        robh+dt@kernel.org, devicetree@vger.kernel.org
Subject: Re: [PATCH net-next 1/3] net: dsa: mv88e6xxx: Allow dynamic
 reconfiguration of tag protocol
Message-ID: <YGCfvDhRFcfESYKx@lunn.ch>
References: <20210326105648.2492411-1-tobias@waldekranz.com>
 <20210326105648.2492411-2-tobias@waldekranz.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210326105648.2492411-2-tobias@waldekranz.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 26, 2021 at 11:56:46AM +0100, Tobias Waldekranz wrote:
> All devices are capable of using regular DSA tags. Support for
> Ethertyped DSA tags sort into three categories:
> 
> 1. No support. Older chips fall into this category.
> 
> 2. Full support. Datasheet explicitly supports configuring the CPU
>    port to receive FORWARDs with a DSA tag.
> 
> 3. Undocumented support. Datasheet lists the configuration from
>    category 2 as "reserved for future use", but does empirically
>    behave like a category 2 device.

> +static int mv88e6xxx_change_tag_protocol(struct dsa_switch *ds, int port,
> +					 enum dsa_tag_protocol proto)
> +{
> +	struct mv88e6xxx_chip *chip = ds->priv;
> +	enum dsa_tag_protocol old_protocol;
> +	int err;
> +
> +	switch (proto) {
> +	case DSA_TAG_PROTO_EDSA:
> +		if (chip->info->tag_protocol != DSA_TAG_PROTO_EDSA)
> +			dev_warn(chip->dev, "Relying on undocumented EDSA tagging behavior\n");
> +
> +		break;
> +	case DSA_TAG_PROTO_DSA:
> +		break;
> +	default:
> +		return -EPROTONOSUPPORT;
> +	}

You are handling cases 2 and 3 here, but not 1. Which makes it a bit
of a foot cannon for older devices.

Now that we have chip->tag_protocol, maybe we should change
chip->info->tag_protocol to mean supported protocols?

BIT(0) DSA
BIT(1) EDSA
BIT(2) Undocumented EDSA

Andrew
