Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EFF08475198
	for <lists+netdev@lfdr.de>; Wed, 15 Dec 2021 05:09:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232187AbhLOEJf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Dec 2021 23:09:35 -0500
Received: from pi.codeconstruct.com.au ([203.29.241.158]:35758 "EHLO
        codeconstruct.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229767AbhLOEJe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Dec 2021 23:09:34 -0500
Received: from pecola.lan (unknown [159.196.93.152])
        by mail.codeconstruct.com.au (Postfix) with ESMTPSA id 3710D20164;
        Wed, 15 Dec 2021 12:09:32 +0800 (AWST)
Message-ID: <7fae5b279352b9d3bdc524a45b50c0e57ebc7b15.camel@codeconstruct.com.au>
Subject: Re: [PATCH net-next] mctp: emit RTM_NEWADDR and RTM_DELADDR
From:   Jeremy Kerr <jk@codeconstruct.com.au>
To:     Matt Johnston <matt@codeconstruct.com.au>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Date:   Wed, 15 Dec 2021 12:09:31 +0800
In-Reply-To: <20211215022816.449508-1-matt@codeconstruct.com.au>
References: <20211215022816.449508-1-matt@codeconstruct.com.au>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.0-2 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Matt,

> Userspace can receive notification of MCTP address changes via
> RTNLGRP_MCTP_IFADDR rtnetlink multicast group.

Nice! A couple of minor things:

> +static void mctp_addr_notify(struct mctp_dev *mdev, mctp_eid_t eid, int msg_type,
> +                            struct sk_buff *req_skb, struct nlmsghdr *req_nlh)

Is it worthwhile keeping the portid argument here, rather than the
entire request skb? Might prevent some confusion with the notify skb.

(I'm OK if we settle on the req_skb approach too though, as it does save
a little repeated code in call sites)

> +{
> +       int rc;
> +       struct sk_buff *skb;
> +       struct net *net = dev_net(mdev->dev);
> +       u32 portid = NETLINK_CB(req_skb).portid;

Super minor, but: reverse Christmas tree here (and above)?

> +
> +       skb = nlmsg_new(mctp_addrinfo_size(), GFP_KERNEL);
> +       if (!skb) {
> +               rc = -ENOBUFS;
> +               goto out;
> +       }
> +
> +       rc = mctp_fill_addrinfo(skb, mdev, eid, msg_type,
> +                               portid, req_nlh->nlmsg_seq, 0);
> +       if (rc < 0)
> +               goto out;
> +
> +       rtnl_notify(skb, net, portid, RTNLGRP_MCTP_IFADDR, req_nlh,
> GFP_KERNEL);
> +out:
> +       if (rc < 0) {
> +               if (skb)
> +                       kfree_skb(skb);
> +               rtnl_set_sk_err(net, RTNLGRP_MCTP_IFADDR, rc);
> +       }

We don't need that `if (skb)` condition on the kfree_skb - Yang has
removed a bunch in 5cfe53cfeb1. We could also remove the rc check if we
use the goto-label only for errors. Maybe something like:

            rtnl_notify(skb, net, portid, RTNLGRP_MCTP_IFADDR, req_nlh, GFP_KERNEL);
            return;
    err:
            kfree_skb(skb);
            rtnl_set_sk_err(net, RTNLGRP_MCTP_IFADDR, rc);
    }

Cheers,


Jeremy
