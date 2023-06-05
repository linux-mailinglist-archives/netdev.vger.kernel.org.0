Return-Path: <netdev+bounces-8163-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id CE6E3722F09
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 20:58:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8973E280F83
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 18:58:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D326F23C99;
	Mon,  5 Jun 2023 18:58:52 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97B5E20EA
	for <netdev@vger.kernel.org>; Mon,  5 Jun 2023 18:58:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0265C433EF;
	Mon,  5 Jun 2023 18:58:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1685991531;
	bh=q9IlhMk0z/b8+lV8XafUj/P9x8dLcJwjnb2AaJeesJs=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=cMGFCKZ8Zv8dgepvbm62uwlkj/B6CnQw7P2FQMQs050yFitzQhCBPtCJJnq4hxDyX
	 wLQDn19x39tDr2y7KBO4QTKR5mcrGMwB0bcLDJOI7fTgbWWzLHVAY9yXpPxoIsyu2y
	 A/A/O0uVrLkQBxo+A7woElplrypoBRgUyBC2LdwDXOfv0DDSzCIK6JzTWO+HDXTGRn
	 KLYt/tyc3gOeYZ65tLNTmSSfeUHjsRRVqvoEdxO6mUXrkva6ds+9QfpgaXtxjzFsUV
	 Pv84UPjIXg1EIz3YNCVXbwCqWKoM4QrxnlyTGcBZOrVZQmWOinEnrbsOSumZW+MoJi
	 DK/p3Y2OSpTgQ==
Date: Mon, 5 Jun 2023 11:58:49 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Gal Pressman <gal@nvidia.com>, espeer@gmail.com
Cc: David Ahern <dsahern@gmail.com>, netdev <netdev@vger.kernel.org>, Andrew
 Gospodarek <andrew.gospodarek@broadcom.com>, Michael Chan
 <michael.chan@broadcom.com>, Stephen Hemminger
 <stephen@networkplumber.org>, Michal Kubecek <mkubecek@suse.cz>
Subject: Re: [PATCH net-next 1/4] netlink: truncate overlength attribute
 list in nla_nest_end()
Message-ID: <20230605115849.0368b8a7@kernel.org>
In-Reply-To: <cdbd5105-973a-2fa0-279b-0d81a1a637b9@nvidia.com>
References: <20210123045321.2797360-1-edwin.peer@broadcom.com>
	<20210123045321.2797360-2-edwin.peer@broadcom.com>
	<1dc163b0-d4b0-8f6c-d047-7eae6dc918c4@gmail.com>
	<CAKOOJTwKK5AgTf+g5LS4MMwR_HwbdFS6U7SFH0jZe8FuJMgNgA@mail.gmail.com>
	<CAKOOJTzwdSdwBF=H-h5qJzXaFDiMoX=vjrMi_vKfZoLrkt4=Lg@mail.gmail.com>
	<62a12b2c-c94e-8d89-0e75-f01dc6abbe92@gmail.com>
	<CAKOOJTwBcRJah=tngJH3EaHCCXb6T_ptAV+GMvqX_sZONeKe9w@mail.gmail.com>
	<cdbd5105-973a-2fa0-279b-0d81a1a637b9@nvidia.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

[Updating Edwin's email.]

On Mon, 5 Jun 2023 10:28:06 +0300 Gal Pressman wrote:
> On 26/01/2021 19:51, Edwin Peer wrote:
> > On Mon, Jan 25, 2021 at 8:56 PM David Ahern <dsahern@gmail.com> wrote:
> >   
> >> I'm not a fan of the skb trim idea. I think it would be better to figure
> >> out how to stop adding to the skb when an attr length is going to exceed
> >> 64kB. Not failing hard with an error (ip link sh needs to succeed), but
> >> truncating the specific attribute of a message with a flag so userspace
> >> knows it is short.  
> > 
> > Absent the ability to do something useful in terms of actually
> > avoiding the overflow [1], I'm abandoning this approach entirely. I
> > have a different idea that I will propose in due course.
> > 
> > [1] https://marc.info/?l=linux-netdev&m=161163943811663
> > 
> > Regards,
> > Edwin Peer  
> 
> Hello Edwin,
> 
> I'm also interested in getting this issue resolved, have you had any
> progress since this series? Are you still working on it?


