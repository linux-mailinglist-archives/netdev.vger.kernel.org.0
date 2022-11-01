Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1DB0B614F0B
	for <lists+netdev@lfdr.de>; Tue,  1 Nov 2022 17:18:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229959AbiKAQSi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Nov 2022 12:18:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229517AbiKAQSh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Nov 2022 12:18:37 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6E8A1C431;
        Tue,  1 Nov 2022 09:18:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6C29961552;
        Tue,  1 Nov 2022 16:18:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66E12C433D6;
        Tue,  1 Nov 2022 16:18:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667319515;
        bh=KsBcs3Cavhj5NIz9q9Vas0Zz1VAOpCisZtpZCSq795E=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Q+m9fimfwnIKvRYFH9xgaQyJV8RlDERSQHmOYpF6SdtSoi9aDp2PmE7xqszhl/B4e
         LNcAqvwbRTtvfbQes5VBFRcCdl1MUHybcBPCcgGC0e7vtDSlTMHAw3RJTeT76e7vDT
         onMQyTBkcxW376M5ccaEzFGC53RS9GDiyyv/MHjUNVOZ6YcYZZwPY3NyV21/0xGkQ4
         XaNZvbbp2292f44EXALGk/nq16Xl0IyH6FVbmKgOi/tb1j2a43HleMi+WTSW81VwAV
         tnPGDS3w+3IfXHT8GxqNg4larts/91i1b5crdvjKhqhAYCJi1uS5w9aoedrLNCkzrH
         /QyJqeu3nTwmA==
Date:   Tue, 1 Nov 2022 09:18:34 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, pabeni@redhat.com,
        edumazet@google.com, tariqt@nvidia.com, moshe@nvidia.com,
        saeedm@nvidia.com, linux-rdma@vger.kernel.org
Subject: Re: [patch net-next v3 13/13] net: expose devlink port over
 rtnetlink
Message-ID: <20221101091834.4dbdcbc1@kernel.org>
In-Reply-To: <20221031124248.484405-14-jiri@resnulli.us>
References: <20221031124248.484405-1-jiri@resnulli.us>
        <20221031124248.484405-14-jiri@resnulli.us>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-8.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 31 Oct 2022 13:42:48 +0100 Jiri Pirko wrote:
> From: Jiri Pirko <jiri@nvidia.com>
> 
> Expose devlink port handle related to netdev over rtnetlink. Introduce a
> new nested IFLA attribute to carry the info. Call into devlink code to
> fill-up the nest with existing devlink attributes that are used over
> devlink netlink.

> +int devlink_nl_port_handle_fill(struct sk_buff *msg, struct devlink_port *devlink_port)
> +{
> +	if (devlink_nl_put_handle(msg, devlink_port->devlink))
> +		return -EMSGSIZE;
> +	if (nla_put_u32(msg, DEVLINK_ATTR_PORT_INDEX, devlink_port->index))
> +		return -EMSGSIZE;
> +	return 0;
> +}
> +EXPORT_SYMBOL_GPL(devlink_nl_port_handle_fill);
> +
> +size_t devlink_nl_port_handle_size(struct devlink_port *devlink_port)
> +{
> +	struct devlink *devlink = devlink_port->devlink;
> +
> +	return nla_total_size(strlen(devlink->dev->bus->name) + 1) /* DEVLINK_ATTR_BUS_NAME */
> +	     + nla_total_size(strlen(dev_name(devlink->dev)) + 1) /* DEVLINK_ATTR_DEV_NAME */
> +	     + nla_total_size(4); /* DEVLINK_ATTR_PORT_INDEX */
> +}
> +EXPORT_SYMBOL_GPL(devlink_nl_port_handle_size);

Why the exports? devlink is a boolean now IIRC.

> +static int rtnl_fill_devlink_port(struct sk_buff *skb,
> +				  const struct net_device *dev)
> +{
> +	struct nlattr *devlink_port_nest;
> +	int ret;
> +
> +	devlink_port_nest = nla_nest_start(skb, IFLA_DEVLINK_PORT);
> +	if (!devlink_port_nest)
> +		return -EMSGSIZE;
> +
> +	if (dev->devlink_port) {

Why produce the empty nest if port is not set?

> +		ret = devlink_nl_port_handle_fill(skb, dev->devlink_port);
> +		if (ret < 0)
> +			goto nest_cancel;
> +	}
> +
> +	nla_nest_end(skb, devlink_port_nest);
> +	return 0;
> +
> +nest_cancel:
> +	nla_nest_cancel(skb, devlink_port_nest);
> +	return ret;
> +}
