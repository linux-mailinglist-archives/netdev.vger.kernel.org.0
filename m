Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9052A56C665
	for <lists+netdev@lfdr.de>; Sat,  9 Jul 2022 05:29:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229513AbiGID35 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Jul 2022 23:29:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229453AbiGID34 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Jul 2022 23:29:56 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 665AC68708
        for <netdev@vger.kernel.org>; Fri,  8 Jul 2022 20:29:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 21ACAB82A1D
        for <netdev@vger.kernel.org>; Sat,  9 Jul 2022 03:29:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9AFEFC341C0;
        Sat,  9 Jul 2022 03:29:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657337392;
        bh=81I0mrm4c4wFdVLwTX16BCuUn0sQG0aGEU8IGc0gR3s=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ISTefVyIYIb2X+ZtN3klor+e7N1zO+tQQn4mWOR5WjRLSw1yMZbhgoRXgehXqtY91
         7jfJmJMtzOZZnUizHXLlU9lqYnbMl5CthtYzkY3RVhuFp3lF1ttFH7rRpFpdCFr+yY
         EWIgEi0KCHQNMd16NjRMV1a/i5QybughBrg6xeX3jIflYWAC9XHoFr00LxKUDLDdtA
         ZokAirXKLwTM4QWbPX0O9cJWuRJ2liWT3J/zhSKjNn7tjMT/rOFuawrtzrIHo1B8C1
         pub3E+ebMfPtk3ePh42G0Bdy87mHLbFd6KUF0nIUkOx2JXaUMaIA+M37CrsukRhetZ
         nqAIHycmIKdRA==
Date:   Fri, 8 Jul 2022 20:29:51 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     David Lamparter <equinox@diac24.net>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        David Ahern <dsahern@kernel.org>
Subject: Re: [PATCH net-next v5] net: ip6mr: add RTM_GETROUTE netlink op
Message-ID: <20220708202951.46d3454a@kernel.org>
In-Reply-To: <20220707093336.214658-1-equinox@diac24.net>
References: <20220707093336.214658-1-equinox@diac24.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Few more nit picks, sorry..

On Thu,  7 Jul 2022 11:33:36 +0200 David Lamparter wrote:
> +static int ip6mr_rtm_getroute(struct sk_buff *in_skb, struct nlmsghdr *nlh,
> +			      struct netlink_ext_ack *extack)
> +{
> +	struct net *net = sock_net(in_skb->sk);
> +	struct in6_addr src = {}, grp = {};
> +	struct nlattr *tb[RTA_MAX + 1];
> +	struct sk_buff *skb = NULL;

Should be unnecessary if the code is right, let the compiler warn us
about uninitialized variables.

> +	struct mfc6_cache *cache;
> +	struct mr_table *mrt;
> +	u32 tableid;
> +	int err;
> +
> +	err = ip6mr_rtm_valid_getroute_req(in_skb, nlh, tb, extack);
> +	if (err < 0)
> +		goto errout;

Can we:

		return err;

? I don't know where the preference for jumping to the return statement
came from, old compilers? someone's "gut feeling"?

> +	if (tb[RTA_SRC])
> +		src = nla_get_in6_addr(tb[RTA_SRC]);
> +	if (tb[RTA_DST])
> +		grp = nla_get_in6_addr(tb[RTA_DST]);
> +	tableid = tb[RTA_TABLE] ? nla_get_u32(tb[RTA_TABLE]) : 0;
> +
> +	mrt = ip6mr_get_table(net, tableid ? tableid : RT_TABLE_DEFAULT);

	tableid ? : RT_TABLE_DEFAULT

or

	tableid ?: RT_TABLE_DEFAULT

the abbreviated version of the ternary operator is used quite commonly
in the kernel.

> +	if (!mrt) {
> +		NL_SET_ERR_MSG_MOD(extack, "MR table does not exist");
> +		err = -ENOENT;
> +		goto errout_free;

Ditto, just return, if not goto errout; there's nothing to free.

> +	}
> +
> +	/* entries are added/deleted only under RTNL */
> +	rcu_read_lock();
> +	cache = ip6mr_cache_find(mrt, &src, &grp);
> +	rcu_read_unlock();
> +	if (!cache) {
> +		NL_SET_ERR_MSG_MOD(extack, "MR cache entry not found");
> +		err = -ENOENT;
> +		goto errout_free;
> +	}
> +
> +	skb = nlmsg_new(mr6_msgsize(false, mrt->maxvif), GFP_KERNEL);
> +	if (!skb) {
> +		err = -ENOBUFS;
> +		goto errout_free;
> +	}
> +
> +	err = ip6mr_fill_mroute(mrt, skb, NETLINK_CB(in_skb).portid,
> +				nlh->nlmsg_seq, cache, RTM_NEWROUTE, 0);
> +	if (err < 0)
> +		goto errout_free;

now this is the only case which actually needs to free the skb

> +
> +	err = rtnl_unicast(skb, net, NETLINK_CB(in_skb).portid);
> +
> +errout:
> +	return err;

when the label is gone you can:

	return rtnl_unicast(...

directly.

> +
> +errout_free:
> +	kfree_skb(skb);
> +	goto errout;

and no need to do the funky backwards jump here either, IMO

> +}
