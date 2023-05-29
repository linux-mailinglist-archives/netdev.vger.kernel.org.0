Return-Path: <netdev+bounces-5997-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AF490714507
	for <lists+netdev@lfdr.de>; Mon, 29 May 2023 08:40:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4E7E71C20971
	for <lists+netdev@lfdr.de>; Mon, 29 May 2023 06:40:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CF276800;
	Mon, 29 May 2023 06:40:41 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93EF636D
	for <netdev@vger.kernel.org>; Mon, 29 May 2023 06:40:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8810C433D2;
	Mon, 29 May 2023 06:40:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1685342440;
	bh=sENKKAgj+Q9jb/nxedR3OVjZEPKu9Q44UYTy1W674H4=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=eOEWeP+wUCkcqkmzOZRq/55v3pwd6sOv+SFidRS7ruVNWSpFXWnXshyVFvE+86pst
	 hTv4vw368oaqdKecVa9j82up9FWh9G58ypoljiqnBOuv1w81J9gNIQP653WOWIQeOc
	 Jnrqql7nqg2L1wh8Qh3m8EQP+rLFjQR9J2/AazdtiNER+vFTOhj6aDKonVv7jSHXVG
	 Owv96rpn8ZvkOPkTfCHCoW5qWWN6q7/RswLUv8OW35JHVhA793c/i6sqwZTe+3bfiq
	 a1n3+aAzMHxa6tfrtFNv7fFzPD9SexZB2X2chmUkTmrWdQxn75hlWTmMsKeP1WLFiu
	 HGmVi2mssVUsw==
Date: Sun, 28 May 2023 23:40:38 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Pedro Tammela <pctammela@mojatatu.com>
Cc: netdev@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
 pabeni@redhat.com, kuniyu@amazon.com, dh.herrmann@gmail.com,
 jhs@mojatatu.com
Subject: Re: [PATCH net] net/netlink: fix NETLINK_LIST_MEMBERSHIPS group
 array length check
Message-ID: <20230528234038.1d6de5cb@kernel.org>
In-Reply-To: <1be298c3-ce57-548e-e0af-937971fe58e9@mojatatu.com>
References: <20230525144609.503744-1-pctammela@mojatatu.com>
	<20230526203301.6933b4b3@kernel.org>
	<1be298c3-ce57-548e-e0af-937971fe58e9@mojatatu.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Sat, 27 May 2023 12:01:25 -0300 Pedro Tammela wrote:
> On 27/05/2023 00:33, Jakub Kicinski wrote:
> > On Thu, 25 May 2023 11:46:09 -0300 Pedro Tammela wrote:  
> >> For the socket option 'NETLINK_LIST_MEMBERSHIPS' the length is defined
> >> as the number of u32 required to represent the whole bitset.  
> > 
> > I don't think it is, it's a getsockopt() len is in bytes.  
> 
> Unfortunately the man page seems to be ambiguous (Emphasis added):
> 	
>         NETLINK_LIST_MEMBERSHIPS (since Linux 4.2)
>                Retrieve all groups a socket is a member of.  optval is a
>                pointer to __u32 and *optlen is the size of the array*.  The
>                array is filled with the full membership set of the
>                socket, and the required array size is returned in optlen.
> 
> Size of the array in bytes? in __u32?

Indeed ambiguous, in C "size of array" could as well refer to sizeof()
or ARRAY_SIZE()..

> SystemD seems to be expecting the size in __u32 chunks:
> https://github.com/systemd/systemd/blob/9c9b9b89151c3e29f3665e306733957ee3979853/src/libsystemd/sd-netlink/netlink-socket.c#L37
> 
> But then looking into the getsockopt manpage we see (Ubuntu 23.04):
> 
>         int getsockopt(int sockfd, int level, int optname,
>                        void optval[restrict *.optlen],
>                        socklen_t *restrict optlen);
> 
> 
> So it seems like getsockopt() asks for optlen to be, in this case, __u32 
> chunks?

Why so?

> WDYT?
> 
> >   
> >> User space then usually queries the required size and issues a subsequent
> >> getsockopt call with the correct parameters[1].
> >>
> >> The current code has an unit mismatch between 'len' and 'pos', where
> >> 'len' is the number of u32 in the passed array while 'pos' is the
> >> number of bytes iterated in the groups bitset.
> >> For netlink groups greater than 32, which from a quick glance
> >> is a rare occasion, the mismatch causes the misreport of groups e.g.
> >> if a rtnl socket is a member of group 34, it's reported as not a member
> >> (all 0s).  
> > 
> > IDK... I haven't tried to repro but looking at the code the more
> > suspicious line of code is this one:
> > 
> > 		if (put_user(ALIGN(nlk->ngroups / 8, sizeof(u32)), optlen))
> > 
> > It's going to round down bytes, and I don't think it's intending to.
> > It should be DIV_ROUND_UP(, 8) then ALIGN(, 4) right?  
> 
> That indeed looks suspicious.
> Your suggestions looks correct for optlen reported as bytes.
> For optlen reported in __u32 chunks seems like BITS_TO_U32(nlk->ngroups) 
> would be sufficient.

I don't know of any other case where socklen_t would refer to something
else than bytes, I'm leaning towards addressing the truncation (and if
systemd thinks the value is in u32s potentially also fixing system, not
that over-allocating will hurt its correctness).

