Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9BB91F2484
	for <lists+netdev@lfdr.de>; Thu,  7 Nov 2019 02:48:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727924AbfKGBsC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Nov 2019 20:48:02 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:53072 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727328AbfKGBsC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 6 Nov 2019 20:48:02 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=BUzkMa1+y5vciB/bw0SvwlN9GdgY2uJTeX7cn2TFYO8=; b=pHCeKgZqeFSSFuAUjCg9cRqXVr
        N6thNkW9MTj6X093Lklqnln6hkSHySnjpD2499VfbzKKiB3PpdvA52n7DXlNePhoCrrgdEdQk6+ES
        3iU5GumsjNW8IZQLrQC+107bfr1Z5fQEIorSWuYvDSZajPJHq77TZdmoKdHOTgXvIYZ4=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.92.2)
        (envelope-from <andrew@lunn.ch>)
        id 1iSWty-0002h3-Jo; Thu, 07 Nov 2019 02:47:58 +0100
Date:   Thu, 7 Nov 2019 02:47:58 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Ioana Ciornei <ioana.ciornei@nxp.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: Re: [PATCH net-next] dpaa2-eth: add ethtool MAC counters
Message-ID: <20191107014758.GA8978@lunn.ch>
References: <1573087748-31303-1-git-send-email-ioana.ciornei@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1573087748-31303-1-git-send-email-ioana.ciornei@nxp.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 07, 2019 at 02:49:08AM +0200, Ioana Ciornei wrote:
> +void dpaa2_mac_get_ethtool_stats(struct dpaa2_mac *mac, u64 *data)
> +{
> +	struct fsl_mc_device *dpmac_dev = mac->mc_dev;
> +	int i, err;
> +	u64 value;
> +
> +	for (i = 0; i < DPAA2_MAC_NUM_STATS; i++) {
> +		err = dpmac_get_counter(mac->mc_io, 0, dpmac_dev->mc_handle,
> +					i, &value);
> +		if (err) {
> +			netdev_err(mac->net_dev,
> +				   "dpmac_get_counter error %d\n", err);
> +			return;

Hi Ioana

I've seen quite a few drivers set *data to U64_MAX when there is an
error. A value like that should stand out. The kernel message might
not be seen.

> +/**
> + * dpmac_get_counter() - Read a specific DPMAC counter
> + * @mc_io:	Pointer to opaque I/O object
> + * @cmd_flags:	Command flags; one or more of 'MC_CMD_FLAG_'
> + * @token:	Token of DPMAC object
> + * @id:		The requested counter ID
> + * @value:	Returned counter value
> + *
> + * Return:	The requested counter; '0' otherwise.
> + */
> +int dpmac_get_counter(struct fsl_mc_io *mc_io, u32 cmd_flags, u16 token,
> +		      enum dpmac_counter_id id, u64 *value)
> +{
> +	struct dpmac_cmd_get_counter *dpmac_cmd;
> +	struct dpmac_rsp_get_counter *dpmac_rsp;
> +	struct fsl_mc_command cmd = { 0 };
> +	int err = 0;
> +
> +	cmd.header = mc_encode_cmd_header(DPMAC_CMDID_GET_COUNTER,
> +					  cmd_flags,
> +					  token);
> +	dpmac_cmd = (struct dpmac_cmd_get_counter *)cmd.params;
> +	dpmac_cmd->id = id;
> +
> +	err = mc_send_command(mc_io, &cmd);
> +	if (err)
> +		return err;
> +
> +	dpmac_rsp = (struct dpmac_rsp_get_counter *)cmd.params;
> +	*value = le64_to_cpu(dpmac_rsp->counter);
> +
> +	return 0;
> +}

How expensive is getting a single value? Is there a way to just get
them all in a single command? The ethtool API always returns them all,
so maybe you can optimise the firmware API to do the same?

   Andrew
