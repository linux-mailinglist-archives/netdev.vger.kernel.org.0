Return-Path: <netdev+bounces-5846-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 405DD713229
	for <lists+netdev@lfdr.de>; Sat, 27 May 2023 05:33:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id ECC43281801
	for <lists+netdev@lfdr.de>; Sat, 27 May 2023 03:33:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DB877389;
	Sat, 27 May 2023 03:33:04 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D5581362
	for <netdev@vger.kernel.org>; Sat, 27 May 2023 03:33:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52EB4C433EF;
	Sat, 27 May 2023 03:33:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1685158382;
	bh=DGEzYFvM9I1jgRnttxVyh/KeRe2U384oxJ/d8jHZtCI=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=iqjgNKWNqSPVeRNib5CjowXpCzUWMr23gGGCSY9joEu+hqDdVpMBhwkHLye9OLIqj
	 nC6Li0zkCXuKgBPq0aaH22oIf14A0Tiw8J2bYa+v4N/YVqrR1H9pfT89s29X4TMylk
	 2m9K8zkrIkHlO4Ag7wbzBTzvwBhGPJtQEqaxTCh70sRmBWr84l0Un1omqcCVd86Apm
	 w3fLZOvU1rh2V8NFSNNTAXoL8JFhPe5mOfwhYO0pS2HD/kNcptagdCRvQ4d+1H/POg
	 dn2ikCwxn5QgxOhVOppWvUKrn12x9nApe3NtYLPgOtYzkrtdtUo2S2vxOwN49Jk517
	 QvFuGOoGt7b0g==
Date: Fri, 26 May 2023 20:33:01 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Pedro Tammela <pctammela@mojatatu.com>
Cc: netdev@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
 pabeni@redhat.com, kuniyu@amazon.com, dh.herrmann@gmail.com,
 jhs@mojatatu.com
Subject: Re: [PATCH net] net/netlink: fix NETLINK_LIST_MEMBERSHIPS group
 array length check
Message-ID: <20230526203301.6933b4b3@kernel.org>
In-Reply-To: <20230525144609.503744-1-pctammela@mojatatu.com>
References: <20230525144609.503744-1-pctammela@mojatatu.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Thu, 25 May 2023 11:46:09 -0300 Pedro Tammela wrote:
> For the socket option 'NETLINK_LIST_MEMBERSHIPS' the length is defined
> as the number of u32 required to represent the whole bitset.

I don't think it is, it's a getsockopt() len is in bytes.

> User space then usually queries the required size and issues a subsequent
> getsockopt call with the correct parameters[1].
> 
> The current code has an unit mismatch between 'len' and 'pos', where
> 'len' is the number of u32 in the passed array while 'pos' is the
> number of bytes iterated in the groups bitset.
> For netlink groups greater than 32, which from a quick glance
> is a rare occasion, the mismatch causes the misreport of groups e.g.
> if a rtnl socket is a member of group 34, it's reported as not a member
> (all 0s).

IDK... I haven't tried to repro but looking at the code the more
suspicious line of code is this one:

		if (put_user(ALIGN(nlk->ngroups / 8, sizeof(u32)), optlen))

It's going to round down bytes, and I don't think it's intending to.
It should be DIV_ROUND_UP(, 8) then ALIGN(, 4) right?
-- 
pw-bot: cr

