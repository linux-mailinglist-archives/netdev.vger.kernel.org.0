Return-Path: <netdev+bounces-5562-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2770971225D
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 10:37:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4DE902816C4
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 08:37:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6D6A05254;
	Fri, 26 May 2023 08:37:55 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AE17524B
	for <netdev@vger.kernel.org>; Fri, 26 May 2023 08:37:55 +0000 (UTC)
Received: from mail.avm.de (mail.avm.de [212.42.244.120])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 853DC9B
	for <netdev@vger.kernel.org>; Fri, 26 May 2023 01:37:52 -0700 (PDT)
Received: from mail-auth.avm.de (unknown [IPv6:2001:bf0:244:244::71])
	by mail.avm.de (Postfix) with ESMTPS;
	Fri, 26 May 2023 10:37:48 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=avm.de; s=mail;
	t=1685090268; bh=iLDsmBp/bnLMgnE8s+73OnYsWcOM7tHgbqVUqIPl8tE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=OP1h0iU6vRBkryaGDGTd4+RPn0lqwQWSqtlZ2ar7imwFlnwxVjsfwAs3WL25BFsk0
	 T+flCCAn92GlUDtDDH0fojjj/DXtz4QMeOVB+y8VHavcPxT+V4ai/zgmKTh+68RdeG
	 wcHAYUyq0WUiFHqLVfiAxCW0coRqVYqNfuykpJ/o=
Received: from localhost (unknown [172.17.88.63])
	by mail-auth.avm.de (Postfix) with ESMTPSA id 2EB7C80A44;
	Fri, 26 May 2023 10:37:50 +0200 (CEST)
Date: Fri, 26 May 2023 10:37:50 +0200
From: Johannes Nixdorf <jnixdorf-oss@avm.de>
To: Nikolay Aleksandrov <razor@blackwall.org>
Cc: Vladimir Oltean <vladimir.oltean@nxp.com>, Andrew Lunn <andrew@lunn.ch>,
	Florian Fainelli <f.fainelli@gmail.com>,
	Oleksij Rempel <linux@rempel-privat.de>, netdev@vger.kernel.org,
	bridge@lists.linux-foundation.org,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Roopa Prabhu <roopa@nvidia.com>, Ido Schimmel <idosch@nvidia.com>
Subject: Re: [PATCH net-next 1/2] bridge: Add a limit on FDB entries
Message-ID: <ZHBv3l9wnbeJzyO2@u-jnixdorf.ads.avm.de>
References: <ZGNEk3F8mcT7nNdB@u-jnixdorf.ads.avm.de>
 <f899f032-b726-7b6d-953d-c7f3f98744ca@blackwall.org>
 <20230516102141.w75yh6pdo53ufjur@skbuf>
 <ce3835d9-c093-cfcb-3687-3a375236cb8f@blackwall.org>
 <20230516104428.i5ou4ogx7gt2x6gq@skbuf>
 <c05b5623-c096-162f-3a2d-db19ca760098@blackwall.org>
 <20230516105509.xaalfs77vrlr663u@skbuf>
 <6a688292-a7a0-20c9-03b9-cad11a61144f@blackwall.org>
 <20230516111005.ni3jygnnxgygoenh@skbuf>
 <b12a817f-de9f-6d25-f189-67e5e7ef49a4@blackwall.org>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b12a817f-de9f-6d25-f189-67e5e7ef49a4@blackwall.org>
X-purgate-ID: 149429::1685090268-42F8D128-28E51B1A/0/0
X-purgate-type: clean
X-purgate-size: 4387
X-purgate-Ad: Categorized by eleven eXpurgate (R) http://www.eleven.de
X-purgate: This mail is considered clean (visit http://www.eleven.de for further information)
X-purgate: clean
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Tue, May 16, 2023 at 02:18:15PM +0300, Nikolay Aleksandrov wrote:
> On 16/05/2023 14:10, Vladimir Oltean wrote:
> > On Tue, May 16, 2023 at 02:04:30PM +0300, Nikolay Aleksandrov wrote:
> >> That was one of the questions actually. More that I'm thinking about this, the more
> >> I want to break it apart by type because we discussed being able to specify a flag
> >> mask for the limit (all, dynamic, dynamic+static etc). If we embed these stats into a
> >> bridge fdb count attribute, it can be easily extended later if anything new comes along.
> >> If switchdev doesn't support some of these global limit configs, we can pass the option
> >> and it can deny setting it later. I think this should be more than enough as a first step.
> > 
> > Ok, and by "type" you actually mean the impossibly hard to understand
> > neighbor discovery states used by the bridge UAPI? Like having
> 
> Yes, that is what I mean. It's not that hard, we can limit it to a few combinations
> that are well understood and defined.
> 
> > (overlapping) limits per NUD_REACHABLE, NUD_NOARP etc flags set in
> > ndm->ndm_state? Or how should the UAPI look like?
> 
> Hmm, perhaps for the time being and for keeping it simpler it'd be best if the type initially is just about
> dynamic entries and the count reflects only those. We can add an abstraction later if we want "per-type"/mask limits.
> Adding such abstraction should be pretty-straight forward if we keep in mind the flags that can change only
> under lock, otherwise proper counting would have to be revisited.

Now that I implemented most of v2, except that I kept the netlink API
roughly the same as v1, I noticed that we probably need to discuss the UAPI
design more, or else we'd be stuck with the new netlink attributes that
do not fit the later abstraction design.

I see several options from what was discussed here and what seems to be
the easiest to implement for me:

 1. Everything is a separate netlink attribute:

 My current draft of v2 adds 2 netlink attributes -
 IFLA_BR_FDB_MAX_LEARNED_ENTRIES and IFLA_BR_FDB_CUR_LEARNED_ENTRIES.
 More generally this would be two u32 netlink attributes for each limit
 (_MAX_ (RW) and _CUR_ (RO)), which can be differentiated by their name.

 1.a Each limit is a separate netlink attribute, _CUR_ and _MAX_ are
     grouped together as a nested message:

 Like 1., but add only one netlink attribute for each limit
 (e.g. IFLA_BR_FDB_LIMIT_LEARNED), containing a nested message with the
 _CUR_ and _MAX_ attributes.

 1.b The same as 1.a, but have one nested message
     (e.g. IFLA_BR_FDB_LIMITS):

 The message would contain attributes of the form
 IFLA_BR_FDB_LIMITS_${NAME}_CUR, IFLA_BR_FDB_LIMITS_${NAME}_MAX, initially
 only for NAME=LEARNED.

 2. Add a new dynamically sized list of attributes + flag mask:

 Permitt the netlink caller to pass a dynamically sized array
 (NL_ATTR_TYPE_NESTED_ARRAY?) of pairs of a flag (and state) mask
 combination and the limit to enforce for them. We'd be rejecting
 everything but NTF_USE + NUD_NOARP for the first implementation.

 Problems:
  - Those are the impossibly hard to understand neighbour discovery
    states. (as in the quoted mail) Having now looked closer at them
    and the bridge internal flags they translate to, I also would prefer
    a different approach.
  - For the general approach of not just rejecting all but one
    flag combination accounting is more difficult.
    For the one limit in v1, and the v2 draft, we can just start counting
    when creating the bridge, and the accounting is up to date when the
    user sets a limit.
    For the general approach later we'd probably not want to include
    separate counters for each combination in the bridge struct. Instead
    we'd dynamically allocate our counter when the user sets a limit,
    so for each newly set limit we'd then need to lock the fdb table and
    count the current fdb entries matching the limit first.

 2.a Invent new names for the supported limits without exposing their flag
     (and state) masks:

 Conceptually this is equivalent to putting the names in the netlink
 attribute namespace as in 1., so I'd prefer to go with one of them
 instead.

Do you have a preference for an approach from the list, or do you see
different options I did not include?

