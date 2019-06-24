Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E41254FF2A
	for <lists+netdev@lfdr.de>; Mon, 24 Jun 2019 04:15:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726934AbfFXCPx convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Sun, 23 Jun 2019 22:15:53 -0400
Received: from f0-dek.dektech.com.au ([210.10.221.142]:48373 "EHLO
        mail.dektech.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726334AbfFXCPx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 23 Jun 2019 22:15:53 -0400
Received: from localhost (localhost [127.0.0.1])
        by mail.dektech.com.au (Postfix) with ESMTP id 3E6CA45871;
        Mon, 24 Jun 2019 12:15:46 +1000 (AEST)
X-Virus-Scanned: amavisd-new at dektech.com.au
Received: from mail.dektech.com.au ([127.0.0.1])
        by localhost (mail2.dektech.com.au [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id nOF48eCrZNho; Mon, 24 Jun 2019 12:15:46 +1000 (AEST)
Received: from mail.dektech.com.au (localhost [127.0.0.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.dektech.com.au (Postfix) with ESMTPS id 0761F45873;
        Mon, 24 Jun 2019 12:15:45 +1000 (AEST)
Received: from VNLAP298VNPC (unknown [14.161.14.188])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.dektech.com.au (Postfix) with ESMTPSA id 3738645871;
        Mon, 24 Jun 2019 12:15:44 +1000 (AEST)
From:   "Hoang Le" <hoang.h.le@dektech.com.au>
To:     "'David Ahern'" <dsahern@gmail.com>, <jon.maloy@ericsson.com>,
        <maloy@donjonn.com>, <ying.xue@windriver.com>,
        <netdev@vger.kernel.org>, <tipc-discussion@lists.sourceforge.net>
References: <20190613080719.22081-1-hoang.h.le@dektech.com.au> <d4bef444-f009-5415-f27d-8cfde945ddab@gmail.com>
In-Reply-To: <d4bef444-f009-5415-f27d-8cfde945ddab@gmail.com>
Subject: RE: [iproute2-next v5] tipc: support interface name when activating UDP bearer
Date:   Mon, 24 Jun 2019 09:15:48 +0700
Message-ID: <00d101d52a32$bf483710$3dd8a530$@dektech.com.au>
MIME-Version: 1.0
Content-Type: text/plain;
        charset="utf-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Microsoft Outlook 16.0
Thread-Index: AQNM7RQ84gezk4aPz9SQzQv6igwFoQICW/2Zo6p2INA=
Content-Language: en-us
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thanks David. I will update code change as your comments.

For the item:
> +	/* remove from cache */
> +	ll_drop_by_index(ifr.ifr_ifindex);

why the call to ll_drop_by_index? doing so means that ifindex is looked
up again.

[Hoang]
> +	ifr.ifr_ifindex = ll_name_to_index(ifr.ifr_name);
This function stored an entry ll_cache in hash map table. We have to call this function to prevent memory leaked. 

Regards,
Hoang
-----Original Message-----
From: David Ahern <dsahern@gmail.com> 
Sent: Saturday, June 22, 2019 5:50 AM
To: Hoang Le <hoang.h.le@dektech.com.au>; dsahern@gmail.com; jon.maloy@ericsson.com; maloy@donjonn.com; ying.xue@windriver.com; netdev@vger.kernel.org; tipc-discussion@lists.sourceforge.net
Subject: Re: [iproute2-next v5] tipc: support interface name when activating UDP bearer

On 6/13/19 2:07 AM, Hoang Le wrote:
> @@ -119,6 +121,74 @@ static int generate_multicast(short af, char *buf, int bufsize)
>  	return 0;
>  }
>  
> +static struct ifreq ifr = {};

you don't need to initialize globals, but you could pass a a struct as
the arg to the filter here which is both the addr buffer and the ifindex
of interest.

> +static int nl_dump_addr_filter(struct nlmsghdr *nlh, void *arg)
> +{
> +	struct ifaddrmsg *ifa = NLMSG_DATA(nlh);
> +	char *r_addr = (char *)arg;
> +	int len = nlh->nlmsg_len;
> +	struct rtattr *addr_attr;
> +
> +	if (ifr.ifr_ifindex != ifa->ifa_index)
> +		return 0;
> +
> +	if (strlen(r_addr) > 0)
> +		return 1;
> +
> +	addr_attr = parse_rtattr_one(IFA_ADDRESS, IFA_RTA(ifa),
> +				     len - NLMSG_LENGTH(sizeof(*ifa)));
> +	if (!addr_attr)
> +		return 0;
> +
> +	if (ifa->ifa_family == AF_INET) {
> +		struct sockaddr_in ip4addr;
> +		memcpy(&ip4addr.sin_addr, RTA_DATA(addr_attr),
> +		       sizeof(struct in_addr));
> +		if (inet_ntop(AF_INET, &ip4addr.sin_addr, r_addr,
> +			      INET_ADDRSTRLEN) == NULL)
> +			return 0;
> +	} else if (ifa->ifa_family == AF_INET6) {
> +		struct sockaddr_in6 ip6addr;
> +		memcpy(&ip6addr.sin6_addr, RTA_DATA(addr_attr),
> +		       sizeof(struct in6_addr));
> +		if (inet_ntop(AF_INET6, &ip6addr.sin6_addr, r_addr,
> +			      INET6_ADDRSTRLEN) == NULL)
> +			return 0;
> +	}
> +	return 1;
> +}
> +
> +static int cmd_bearer_validate_and_get_addr(const char *name, char *r_addr)
> +{
> +	struct rtnl_handle rth ={ .fd = -1 };

space between '={'

> +
> +	memset(&ifr, 0, sizeof(ifr));
> +	if (!name || !r_addr || get_ifname(ifr.ifr_name, name))
> +		return 0;
> +
> +	ifr.ifr_ifindex = ll_name_to_index(ifr.ifr_name);
> +	if (!ifr.ifr_ifindex)
> +		return 0;
> +
> +	/* remove from cache */
> +	ll_drop_by_index(ifr.ifr_ifindex);

why the call to ll_drop_by_index? doing so means that ifindex is looked
up again.

> +
> +	if (rtnl_open(&rth, 0) < 0)
> +		return 0;
> +
> +	if (rtnl_addrdump_req(&rth, AF_UNSPEC, 0) < 0) {

If you pass a filter here to set ifa_index, this command on newer
kernels will be much more efficient. See ipaddr_dump_filter.


> +		rtnl_close(&rth);
> +		return 0;
> +	}
> +
> +	if (rtnl_dump_filter(&rth, nl_dump_addr_filter, r_addr) < 0) {
> +		rtnl_close(&rth);
> +		return 0;
> +	}
> +	rtnl_close(&rth);
> +	return 1;
> +}

it would better to have 1 exit with the rtnl_close and return rc based
on above.

