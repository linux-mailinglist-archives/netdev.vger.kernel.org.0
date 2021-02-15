Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A59331B83C
	for <lists+netdev@lfdr.de>; Mon, 15 Feb 2021 12:45:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229880AbhBOLo7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Feb 2021 06:44:59 -0500
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:11170 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229652AbhBOLok (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Feb 2021 06:44:40 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B602a5e7e0003>; Mon, 15 Feb 2021 03:43:58 -0800
Received: from yaviefel (172.20.145.6) by HQMAIL107.nvidia.com (172.20.187.13)
 with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 15 Feb 2021 11:43:55
 +0000
References: <cover.1612815057.git.petrm@nvidia.com>
 <893e22e2ad6413a98ca76134b332c8962fcd3b6a.1612815058.git.petrm@nvidia.com>
 <d3a64aea-d544-cd58-475c-57e89ea49be5@gmail.com>
 <20210213201758.GB401513@shredder.lan>
User-agent: mu4e 1.4.10; emacs 27.1
From:   Petr Machata <petrm@nvidia.com>
To:     Ido Schimmel <idosch@idosch.org>
CC:     David Ahern <dsahern@gmail.com>, Petr Machata <petrm@nvidia.com>,
        <netdev@vger.kernel.org>, David Ahern <dsahern@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Ido Schimmel <idosch@nvidia.com>
Subject: Re: [RFC PATCH 03/13] nexthop: Add netlink defines and enumerators
 for resilient NH groups
In-Reply-To: <20210213201758.GB401513@shredder.lan>
Date:   Mon, 15 Feb 2021 12:43:51 +0100
Message-ID: <875z2tbloo.fsf@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.20.145.6]
X-ClientProxiedBy: HQMAIL107.nvidia.com (172.20.187.13) To
 HQMAIL107.nvidia.com (172.20.187.13)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1613389438; bh=vKEldqNTlQmF6htD+V5gQ3gFczxJkajGNmDB3YupWf0=;
        h=References:User-agent:From:To:CC:Subject:In-Reply-To:Date:
         Message-ID:MIME-Version:Content-Type:X-Originating-IP:
         X-ClientProxiedBy;
        b=VRvJjQ1A/KbUGvaegnX5AFqp7wMjsUQ524fBLbM73A/bxlKsSPf9IoEmAnOS7PnYU
         8zE+zEq/plyVvP7tcSsqyHzkFHMm6h91SXsQIJpmjNpXB1BSSiYtU8Uh+CdQT2Ocie
         48qM4D3qqVDY0fkbQWLFBsZKJWeFOFKtLVDzZEo+dQYgOZPrcrL+KG3uP67R5eFjse
         c+S4EPHzh5U5DGmFT/1w7SaROP9gJdh4vcgUxF9Ii+0Vr7j51GOlEQDrsp4PEU+wcn
         PeAZIxF5kt2HDVW/0XcEaBfxz7GCJifPkF1VSvg/U8weqmdvA4zjprcM/IH2mOsNyO
         vdW0vzxzBizOQ==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Ido Schimmel <idosch@idosch.org> writes:

> On Sat, Feb 13, 2021 at 12:16:45PM -0700, David Ahern wrote:
>> On 2/8/21 1:42 PM, Petr Machata wrote:
>> > @@ -52,8 +53,50 @@ enum {
>> >  	NHA_FDB,	/* flag; nexthop belongs to a bridge fdb */
>> >  	/* if NHA_FDB is added, OIF, BLACKHOLE, ENCAP cannot be set */
>> >  
>> > +	/* nested; resilient nexthop group attributes */
>> > +	NHA_RES_GROUP,
>> > +	/* nested; nexthop bucket attributes */
>> > +	NHA_RES_BUCKET,
>> > +
>> >  	__NHA_MAX,
>> >  };
>> >  
>> >  #define NHA_MAX	(__NHA_MAX - 1)
>> > +
>> > +enum {
>> > +	NHA_RES_GROUP_UNSPEC,
>> > +	/* Pad attribute for 64-bit alignment. */
>> > +	NHA_RES_GROUP_PAD = NHA_RES_GROUP_UNSPEC,
>> > +
>> > +	/* u32; number of nexthop buckets in a resilient nexthop group */
>> > +	NHA_RES_GROUP_BUCKETS,
>> 
>> u32 is overkill; arguably u16 (64k) should be more than enough buckets
>> for any real use case.
>
> We wanted to make it future-proof, but I think we can live with 64k. At
> least in Spectrum the maximum is 4k. I don't know about other devices,
> but I guess it is not more than 64k.

OK, no problem. I was thinking of keeping the API as u32, and tracking
as u16 internally, but let's not add baggage at this stage already. Push
comes to shove there can be another u32 attribute mutexed with this one.
