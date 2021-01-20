Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 17B092FCF06
	for <lists+netdev@lfdr.de>; Wed, 20 Jan 2021 12:21:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389176AbhATLQv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Jan 2021 06:16:51 -0500
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:6565 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730336AbhATKqd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Jan 2021 05:46:33 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B600809d80000>; Wed, 20 Jan 2021 02:45:44 -0800
Received: from yaviefel (172.20.145.6) by HQMAIL107.nvidia.com (172.20.187.13)
 with Microsoft SMTP Server (TLS) id 15.0.1473.3; Wed, 20 Jan 2021 10:45:41
 +0000
References: <cover.1610978306.git.petrm@nvidia.org>
 <ec93d227609126c98805e52ba3821b71f8bb338d.1610978306.git.petrm@nvidia.org>
 <20210119125504.0b306d97@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <74bb53b9-1bda-ba42-ceeb-9e85c8c2ea27@gmail.com>
User-agent: mu4e 1.4.10; emacs 27.1
From:   Petr Machata <petrm@nvidia.com>
To:     David Ahern <dsahern@gmail.com>
CC:     Jakub Kicinski <kuba@kernel.org>, Petr Machata <petrm@nvidia.com>,
        <netdev@vger.kernel.org>, David Ahern <dsahern@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Ido Schimmel <idosch@nvidia.com>
Subject: Re: [PATCH net-next 1/3] nexthop: Use a dedicated policy for
 nh_valid_get_del_req()
In-Reply-To: <74bb53b9-1bda-ba42-ceeb-9e85c8c2ea27@gmail.com>
Message-ID: <87mtx36g4u.fsf@nvidia.com>
Date:   Wed, 20 Jan 2021 11:45:37 +0100
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.20.145.6]
X-ClientProxiedBy: HQMAIL111.nvidia.com (172.20.187.18) To
 HQMAIL107.nvidia.com (172.20.187.13)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1611139544; bh=Sg2R5NGdFCPK9kNZUCOwjBe12okch2NyjSF2tO2ZXNA=;
        h=References:User-agent:From:To:CC:Subject:In-Reply-To:Message-ID:
         Date:MIME-Version:Content-Type:X-Originating-IP:X-ClientProxiedBy;
        b=L0cydR3ruLlKhFniYmgQAsEvvdhfS1kNkcNEczeGsqyMwE115nAHyI0mC1hc+XoYC
         sl29ohCSzNHq3yDvyy8kNRWpEgB7cSWAY0AoAUZodsX5kD3TfSw1HP60dkJXKRgjGS
         e5qBP53LCV76JaP088lsItJBBY5HTm+bB7IigMLwzIC1GLkRaxrGeIpKC/0Faqfl3y
         qbtdJcCvHPpxkR6iVLArxEz3atJ/NeijxgoJtYd/Fxhu3wcQSE/Gn4sGJxtTxxJtMV
         QTxfUdL2ZuGd2XkmhrQcRy8HKtRIDaALaUB7CdEP3zLkIkVrqxl4JRQVYY017uglKV
         fZ+TUUpNzrNmw==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


David Ahern <dsahern@gmail.com> writes:

> On 1/19/21 1:55 PM, Jakub Kicinski wrote:
>>> diff --git a/net/ipv4/nexthop.c b/net/ipv4/nexthop.c
>>> index e53e43aef785..d5d88f7c5c11 100644
>>> --- a/net/ipv4/nexthop.c
>>> +++ b/net/ipv4/nexthop.c
>>> @@ -36,6 +36,10 @@ static const struct nla_policy rtm_nh_policy[NHA_MAX + 1] = {
>>>  	[NHA_FDB]		= { .type = NLA_FLAG },
>>>  };
>>>  
>>> +static const struct nla_policy rtm_nh_policy_get[NHA_MAX + 1] = {
>> 
>> This is an unnecessary waste of memory if you ask me.
>> 
>> NHA_ID is 1, so we're creating an array of 10 extra NULL elements.
>> 
>> Can you leave the size to the compiler and use ARRAY_SIZE() below?
>
> interesting suggestion in general for netlink attributes.
>
>> 
>>> +	[NHA_ID]		= { .type = NLA_U32 },
>>> +};
>>> +
>>>  static bool nexthop_notifiers_is_empty(struct net *net)
>>>  {
>>>  	return !net->nexthop.notifier_chain.head;
>>> @@ -1843,27 +1847,14 @@ static int nh_valid_get_del_req(struct nlmsghdr *nlh, u32 *id,
>>>  {
>>>  	struct nhmsg *nhm = nlmsg_data(nlh);
>>>  	struct nlattr *tb[NHA_MAX + 1];
>
> This tb array too could be sized to just the highest indexed expected -
> NHA_ID in this case.
>
>>> -	int err, i;
>>> +	int err;
>>>  
>>> -	err = nlmsg_parse(nlh, sizeof(*nhm), tb, NHA_MAX, rtm_nh_policy,
>>> +	err = nlmsg_parse(nlh, sizeof(*nhm), tb, NHA_MAX, rtm_nh_policy_get,
>>>  			  extack);

OK, I'll send a v2 that uses ARRAY_SIZE instead of hard-coding the max
and size.
