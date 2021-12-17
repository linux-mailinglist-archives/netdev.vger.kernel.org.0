Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 635BC4794FE
	for <lists+netdev@lfdr.de>; Fri, 17 Dec 2021 20:43:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240710AbhLQTm6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Dec 2021 14:42:58 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:50134 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240707AbhLQTm5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Dec 2021 14:42:57 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 82CCFB827DC
        for <netdev@vger.kernel.org>; Fri, 17 Dec 2021 19:42:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E640C36AE5;
        Fri, 17 Dec 2021 19:42:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1639770175;
        bh=56UsdLInh0vCBZvuSEAmQh7gePcOJo4tTJTUX9W/cgo=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=MImHckGGN7J3jvVMVse/5OsNc7Afo25T+2UlkZxhvVN0A1POKW70pSqc7UbWBBi6P
         XN/nrGC23zbq6fX6MyJJZSpOHnz1N9s8LIpyG3zWSHe1MS5nkDaIDQl19q4INECJZt
         F2V508hFyjev+19ehmblMrWaYABn3HwOEwBR6DN1xvpWKS0XaCe3NyfWhTZVUzf4mq
         +E5YGPbzwyzOlM8E6MI+GdHRrhlSrQ9eyS7sOH5U6fhChyfYe606fp3gA72yQgKmA0
         TJmFzz2MD/v4ylh58359upcYt5bNPYN/hwX4VoD4BL26PqKsJ7qjtf+cmR1huZkyQj
         4ihsB8eY7chWA==
Date:   Fri, 17 Dec 2021 11:42:54 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Matt Johnston <matt@codeconstruct.com.au>
Cc:     Jeremy Kerr <jk@codeconstruct.com.au>, netdev@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH net-next v2] mctp: emit RTM_NEWADDR and RTM_DELADDR
Message-ID: <20211217114247.39b632c8@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20211215053250.703167-1-matt@codeconstruct.com.au>
References: <20211215053250.703167-1-matt@codeconstruct.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 15 Dec 2021 13:32:50 +0800 Matt Johnston wrote:
> Userspace can receive notification of MCTP address changes via
> RTNLGRP_MCTP_IFADDR rtnetlink multicast group.
> 
> Signed-off-by: Matt Johnston <matt@codeconstruct.com.au>
> ---
> 
> v2: Simplify error return path, fix local variable ordering
> 
> I've left req_skb as-is rather than passing portid, as noted 
> it keeps callers tidier.

Sorry for late review.

> -static int mctp_fill_addrinfo(struct sk_buff *skb, struct netlink_callback *cb,
> -			      struct mctp_dev *mdev, mctp_eid_t eid)
> +static int mctp_addrinfo_size(void)
> +{
> +	return NLMSG_ALIGN(sizeof(struct ifaddrmsg))
> +		+ nla_total_size(4) // IFA_LOCAL
> +		+ nla_total_size(4) // IFA_ADDRESS

why 4? The attributes are u8, no?

> +		;
> +}

> @@ -127,6 +141,30 @@ static int mctp_dump_addrinfo(struct sk_buff *skb, struct netlink_callback *cb)
>  	return skb->len;
>  }
>  
> +static void mctp_addr_notify(struct mctp_dev *mdev, mctp_eid_t eid, int msg_type,
> +			     struct sk_buff *req_skb, struct nlmsghdr *req_nlh)
> +{
> +	u32 portid = NETLINK_CB(req_skb).portid;
> +	struct net *net = dev_net(mdev->dev);
> +	struct sk_buff *skb;
> +	int rc = -ENOBUFS;
> +
> +	skb = nlmsg_new(mctp_addrinfo_size(), GFP_KERNEL);
> +	if (!skb)
> +		goto out;
> +
> +	rc = mctp_fill_addrinfo(skb, mdev, eid, msg_type,
> +				portid, req_nlh->nlmsg_seq, 0);
> +	if (rc < 0)

How about a customary WARN_ON_ONCE(rc == -EMSGSIZE) here?

> +		goto out;
> +
> +	rtnl_notify(skb, net, portid, RTNLGRP_MCTP_IFADDR, req_nlh, GFP_KERNEL);
> +	return;
> +out:
> +	kfree_skb(skb);
> +	rtnl_set_sk_err(net, RTNLGRP_MCTP_IFADDR, rc);
> +}

