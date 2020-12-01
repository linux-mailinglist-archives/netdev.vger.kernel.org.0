Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B437B2C98B8
	for <lists+netdev@lfdr.de>; Tue,  1 Dec 2020 08:57:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726598AbgLAH4X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Dec 2020 02:56:23 -0500
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:11720 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726178AbgLAH4W (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Dec 2020 02:56:22 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5fc5f6fe0001>; Mon, 30 Nov 2020 23:55:42 -0800
Received: from reg-r-vrt-018-180.nvidia.com (10.124.1.5) by
 HQMAIL107.nvidia.com (172.20.187.13) with Microsoft SMTP Server (TLS) id
 15.0.1473.3; Tue, 1 Dec 2020 07:55:40 +0000
References: <20201127151205.23492-1-vladbu@nvidia.com> <20201130185222.6b24ed42@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
User-agent: mu4e 1.4.12; emacs 26.2.90
From:   Vlad Buslov <vladbu@nvidia.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <jhs@mojatatu.com>, <xiyou.wangcong@gmail.com>, <jiri@resnulli.us>
Subject: Re: [PATCH net-next] net: sched: remove redundant 'rtnl_held' argument
In-Reply-To: <20201130185222.6b24ed42@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
Date:   Tue, 1 Dec 2020 09:55:37 +0200
Message-ID: <ygnh4kl6klja.fsf@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL101.nvidia.com (172.20.187.10) To
 HQMAIL107.nvidia.com (172.20.187.13)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1606809342; bh=jKcGEjQYO+hVXe9L5WJkPJWfu2RWLCOoz7w3HH12x3Q=;
        h=References:User-agent:From:To:CC:Subject:In-Reply-To:Date:
         Message-ID:MIME-Version:Content-Type:X-Originating-IP:
         X-ClientProxiedBy;
        b=fWIqhmvJjzq6VJfRybnLzBUYmq9VJ8EFNBsxw/vZKGRY1EcRZfodUlSetWOm43n8I
         h0AzCiRrY+DECSYP9StO4MORmFjUjf/FrJaPQxOk3JnfXkEOSfWZCZY4oKbzdCq3B3
         f0v3vk9OFIE4J0XMkvvPdXdHOna3swt7WLWey3lM+Qea0LBvjtRf+smZy1n/5xrDxF
         I3iLgSyYmL9FfCCz5HtGQ82UdgSsufgKHq8jXs5oH6uIErMle3DokHvX8y5TTSYxIa
         r4jMsPBFwCZu8B9FEQ39BoAz9SuXjZq2724I8NXzk0hAEVgzf4BHs0jmxW2h/bnJ3c
         SlNa+MKoqBcIA==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue 01 Dec 2020 at 04:52, Jakub Kicinski <kuba@kernel.org> wrote:
> On Fri, 27 Nov 2020 17:12:05 +0200 Vlad Buslov wrote:
>> @@ -2262,7 +2260,7 @@ static int tc_del_tfilter(struct sk_buff *skb, struct nlmsghdr *n,
>>  
>>  	if (prio == 0) {
>>  		tfilter_notify_chain(net, skb, block, q, parent, n,
>> -				     chain, RTM_DELTFILTER, rtnl_held);
>> +				     chain, RTM_DELTFILTER);
>>  		tcf_chain_flush(chain, rtnl_held);
>>  		err = 0;
>>  		goto errout;
>
> Hum. This looks off.

Hi Jakub,

Prio==0 means user requests to flush whole chain. In such case rtnl lock
is obtained earlier in tc_del_tfilter():

	/* Take rtnl mutex if flushing whole chain, block is shared (no qdisc
	 * found), qdisc is not unlocked, classifier type is not specified,
	 * classifier is not unlocked.
	 */
	if (!prio ||
	    (q && !(q->ops->cl_ops->flags & QDISC_CLASS_OPS_DOIT_UNLOCKED)) ||
	    !tcf_proto_is_unlocked(name)) {
		rtnl_held = true;
		rtnl_lock();
	}

