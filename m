Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 37EAE4007CD
	for <lists+netdev@lfdr.de>; Sat,  4 Sep 2021 00:14:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350063AbhICWP1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Sep 2021 18:15:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:44638 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229875AbhICWP1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 3 Sep 2021 18:15:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 70F1A60FE6;
        Fri,  3 Sep 2021 22:14:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1630707266;
        bh=lBOxEqozVrXDx8qSm7r9PVWjHadA6v/qo4NipJh4Wfw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ZkwY0Txc4bB8DPrKI5Yt9W5MyYcbly+PgzjuTpS9rQC5STI1BhDxZ47Xs9+oDjLOy
         d0CsF5mxN3Mtsj7H2vsxRQCcaTP7BEtPqxIQC4s8oeybLLXqrJhIJLG6pKRKdnyrxm
         BgAc+EAYVSi6vhIr82e+3KAJjxqLlP7jnO4u2ZH24sc3OD5nSLQlYnvoR8QiOUX4CV
         5eXrCzqps82r51PoA6ONHaoHQ0k7cY4SeZ9ffq09NcO/HSKBTsEsW8fpRA73jaUz8w
         H9wvXcsGH+ovQ7Kt+mhZjHPR8pyYxUtZPtXGZiEff7GmErl95XVErL8HMsfQUrBjmj
         WTA+PoQ+pwncQ==
Date:   Fri, 3 Sep 2021 15:14:25 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Maciej Machnikowski <maciej.machnikowski@intel.com>
Cc:     netdev@vger.kernel.org, intel-wired-lan@lists.osuosl.org,
        richardcochran@gmail.com, abyagowi@fb.com,
        anthony.l.nguyen@intel.com, davem@davemloft.net,
        linux-kselftest@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Michal Kubecek <mkubecek@suse.cz>
Subject: Re: [PATCH net-next 1/2] rtnetlink: Add new RTM_GETEECSTATE message
 to get SyncE status
Message-ID: <20210903151425.0bea0ce7@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210903151436.529478-2-maciej.machnikowski@intel.com>
References: <20210903151436.529478-1-maciej.machnikowski@intel.com>
        <20210903151436.529478-2-maciej.machnikowski@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri,  3 Sep 2021 17:14:35 +0200 Maciej Machnikowski wrote:
> This patch series introduces basic interface for reading the Ethernet
> Equipment Clock (EEC) state on a SyncE capable device. This state gives
> information about the state of EEC. This interface is required to
> implement Synchronization Status Messaging on upper layers.
> 
> Initial implementation returns SyncE EEC state and flags attributes.
> The only flag currently implemented is the EEC_SRC_PORT. When it's set
> the EEC is synchronized to the recovered clock recovered from the
> current port.
> 
> SyncE EEC state read needs to be implemented as a ndo_get_eec_state
> function.
> 
> Signed-off-by: Maciej Machnikowski <maciej.machnikowski@intel.com>

Since we're talking SyncE-only now my intuition would be to put this 
op in ethtool. Was there a reason ethtool was not chosen? If not what
do others think / if yes can the reason be included in the commit
message?


> +/* SyncE section */
> +
> +enum if_eec_state {
> +	IF_EEC_STATE_INVALID = 0,
> +	IF_EEC_STATE_FREERUN,
> +	IF_EEC_STATE_LOCKACQ,
> +	IF_EEC_STATE_LOCKREC,
> +	IF_EEC_STATE_LOCKED,
> +	IF_EEC_STATE_HOLDOVER,
> +	IF_EEC_STATE_OPEN_LOOP,
> +	__IF_EEC_STATE_MAX,
> +};
> +
> +#define IF_EEC_STATE_MAX	(__IF_EEC_STATE_MAX - 1)

You don't need MAC for an output-only enum, MAX define in netlink is
usually for attributes to know how to size attribute arrays.

> +#define EEC_SRC_PORT		(1 << 0) /* recovered clock from the port is
> +					  * currently the source for the EEC
> +					  */

Why include it then? Just leave the value out and if the attr is not
present user space should assume the source is port.

> +struct if_eec_state_msg {
> +	__u32 ifindex;
> +};
> +
> +enum {
> +	IFLA_EEC_UNSPEC,
> +	IFLA_EEC_STATE,
> +	IFLA_EEC_FLAGS,

With "SRC_PORT" gone there's no reason for flags at this point.

> +	__IFLA_EEC_MAX,
> +};
> +
> +#define IFLA_EEC_MAX (__IFLA_EEC_MAX - 1)

> +static int rtnl_fill_eec_state(struct sk_buff *skb, struct net_device *dev,
> +			       u32 portid, u32 seq, struct netlink_callback *cb,
> +			       int flags, struct netlink_ext_ack *extack)
> +{
> +	const struct net_device_ops *ops = dev->netdev_ops;
> +	struct if_eec_state_msg *state_msg;
> +	enum if_eec_state state;
> +	struct nlmsghdr *nlh;
> +	u32 eec_flags;
> +	int err;
> +
> +	ASSERT_RTNL();
> +
> +	if (!ops->ndo_get_eec_state)
> +		return -EOPNOTSUPP;
> +
> +	err = ops->ndo_get_eec_state(dev, &state, &eec_flags, extack);
> +	if (err)
> +		return err;
> +
> +	nlh = nlmsg_put(skb, portid, seq, RTM_GETEECSTATE, sizeof(*state_msg),
> +			flags);
> +	if (!nlh)
> +		return -EMSGSIZE;
> +
> +	state_msg = nlmsg_data(nlh);
> +	state_msg->ifindex = dev->ifindex;
> +
> +	if (nla_put(skb, IFLA_EEC_STATE, sizeof(state), &state) ||

This should be a u32.

> +	    nla_put_u32(skb, IFLA_EEC_FLAGS, eec_flags))
> +		return -EMSGSIZE;
> +
> +	nlmsg_end(skb, nlh);
> +	return 0;
> +}
> +
> +static int rtnl_eec_state_get(struct sk_buff *skb, struct nlmsghdr *nlh,
> +			      struct netlink_ext_ack *extack)
> +{
> +	struct net *net = sock_net(skb->sk);
> +	struct if_eec_state_msg *state;
> +	struct net_device *dev;
> +	struct sk_buff *nskb;
> +	int err;
> +
> +	state = nlmsg_data(nlh);
> +	if (state->ifindex > 0)
> +		dev = __dev_get_by_index(net, state->ifindex);
> +	else
> +		return -EINVAL;
> +
> +	if (!dev)
> +		return -ENODEV;

I think I pointed this out already, this is more natural without the
else branch:

if (ifindex <= 0)
	return -EINVAL;

dev = ...
if (!dev)
	return -ENOENT;

or don't check the ifindex at all and let dev_get_by.. fail.


Thanks for pushing this API forward!
