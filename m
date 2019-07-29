Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3661A792A0
	for <lists+netdev@lfdr.de>; Mon, 29 Jul 2019 19:52:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727562AbfG2RwR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jul 2019 13:52:17 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:36684 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726631AbfG2RwR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Jul 2019 13:52:17 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id AB62A14017DA8;
        Mon, 29 Jul 2019 10:52:16 -0700 (PDT)
Date:   Mon, 29 Jul 2019 10:52:16 -0700 (PDT)
Message-Id: <20190729.105216.2073541569967891866.davem@davemloft.net>
To:     jiri@resnulli.us
Cc:     netdev@vger.kernel.org, jakub.kicinski@netronome.com,
        sthemmin@microsoft.com, dsahern@gmail.com, mlxsw@mellanox.com
Subject: Re: [patch net-next 1/3] net: devlink: allow to change namespaces
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190727094459.26345-2-jiri@resnulli.us>
References: <20190727094459.26345-1-jiri@resnulli.us>
        <20190727094459.26345-2-jiri@resnulli.us>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 29 Jul 2019 10:52:16 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@resnulli.us>
Date: Sat, 27 Jul 2019 11:44:57 +0200

> +	if ((netns_pid_attr && (netns_fd_attr || netns_id_attr)) ||
> +	    (netns_fd_attr && (netns_pid_attr || netns_id_attr)) ||
> +	    (netns_id_attr && (netns_pid_attr || netns_fd_attr))) {
> +		NL_SET_ERR_MSG(info->extack, "multiple netns identifying attributes specified");
> +		return ERR_PTR(-EINVAL);
> +	}

How about:

	if (!!a + !!b + !!c > 1) {
	...

> +
> +	if (netns_pid_attr) {
> +		net = get_net_ns_by_pid(nla_get_u32(netns_pid_attr));
> +	} else if (netns_fd_attr) {
> +		net = get_net_ns_by_fd(nla_get_u32(netns_fd_attr));
> +	} else if (netns_id_attr) {
> +		net = get_net_ns_by_id(sock_net(skb->sk),
> +				       nla_get_u32(netns_id_attr));
> +		if (!net)
> +			net = ERR_PTR(-EINVAL);
> +	}
> +	if (IS_ERR(net)) {

I think this is going to be one of those cases where a compiler won't be able
to prove that 'net' is guaranteed to be initialized at this spot.  Please
rearrange this code somehow so that is unlikely to happen.

Thanks.
