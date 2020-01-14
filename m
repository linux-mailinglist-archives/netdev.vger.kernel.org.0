Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3997113AB80
	for <lists+netdev@lfdr.de>; Tue, 14 Jan 2020 14:55:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728871AbgANNzp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jan 2020 08:55:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:43568 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726453AbgANNzp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 14 Jan 2020 08:55:45 -0500
Received: from cakuba.hsd1.ca.comcast.net (c-73-93-4-247.hsd1.ca.comcast.net [73.93.4.247])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EA8522467A;
        Tue, 14 Jan 2020 13:55:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579010145;
        bh=1yUOzUoSxcZExOH/9FkbsG0uKOk9GKckSuGzrxAhpN4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Y/OHm3zVJP77IeFzNoTtCjaV4OMo99jbKwlrOUlnf74lwnac0v9y+KRU8MT/8n/1U
         v1vikP/x83NJ81KIqu9FjDc8BC5HTVi4vL06g1v+ntBL5f0MJEBv0uSh9lzruZIGrM
         jq/Yhgng2P3+H4sqZMZnw4xSFckrSrVxa7SudB0Q=
Date:   Tue, 14 Jan 2020 05:55:44 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
Cc:     netdev@vger.kernel.org, roopa@cumulusnetworks.com,
        davem@davemloft.net, bridge@lists.linux-foundation.org,
        "dsahern@gmail.com" <dsahern@gmail.com>
Subject: Re: [PATCH net-next 3/8] net: bridge: vlan: add rtm definitions and
 dump support
Message-ID: <20200114055544.77a7806f@cakuba.hsd1.ca.comcast.net>
In-Reply-To: <20200113155233.20771-4-nikolay@cumulusnetworks.com>
References: <20200113155233.20771-1-nikolay@cumulusnetworks.com>
        <20200113155233.20771-4-nikolay@cumulusnetworks.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 13 Jan 2020 17:52:28 +0200, Nikolay Aleksandrov wrote:
> +static int br_vlan_rtm_dump(struct sk_buff *skb, struct netlink_callback *cb)
> +{
> +	int idx = 0, err = 0, s_idx = cb->args[0];
> +	struct net *net = sock_net(skb->sk);
> +	struct br_vlan_msg *bvm;
> +	struct net_device *dev;
> +
> +	if (cb->nlh->nlmsg_len < nlmsg_msg_size(sizeof(*bvm))) {

I wonder if it'd be useful to make this a strict != check? At least
when strict validation is on? Perhaps we'll one day want to extend 
the request?

> +		NL_SET_ERR_MSG_MOD(cb->extack, "Invalid header for vlan dump request");
> +		return -EINVAL;
> +	}

