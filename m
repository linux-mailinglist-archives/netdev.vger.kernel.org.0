Return-Path: <netdev+bounces-41-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A094A6F4DCD
	for <lists+netdev@lfdr.de>; Wed,  3 May 2023 01:43:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7223B1C209D4
	for <lists+netdev@lfdr.de>; Tue,  2 May 2023 23:43:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BBE82BA2F;
	Tue,  2 May 2023 23:43:39 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46A329456
	for <netdev@vger.kernel.org>; Tue,  2 May 2023 23:43:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABB43C433D2;
	Tue,  2 May 2023 23:43:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1683071017;
	bh=c1Heg2nL6qir+Xqli9M7po1p59+s4gtSZRo6ATkH01Y=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=fnb53USrqfLn9RG1tGzSllVvXYIWTkb1f1N8b0vEZ3sugQna8xdYMH16caSRvFoES
	 V9oJT2JB5t5QwtG0HWVeErxb4hr9QgKg65xAUFRrZ4luSpY0q6isev8joDidge2i1b
	 vlUE40oNbTkVt/v6WgWxtiIe1jCNdFAwsgdKr5M80vAeLzklfBbxA5gK47YF1I5U1m
	 /2zrOMyK7/LjFbRr3HZSvw6Y0NJ7PFOOOVWVy9a3tQLke3hgWzsVNi9TbqCcBpHZJh
	 mvq87xVh9fQihZ4Mo8MXOhEI89AU49xUiQwsZtMQOkSVEzASK3zdAg07BVpawsm0Q5
	 VUzUd3X1Si6lw==
Date: Tue, 2 May 2023 16:43:36 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Shannon Nelson <shannon.nelson@amd.com>
Cc: <brett.creeley@amd.com>, <netdev@vger.kernel.org>, <drivers@pensando.io>
Subject: Re: [PATCH RFC net-next 0/2] pds_core: add switchdev and tc for
 vlan offload
Message-ID: <20230502164336.1e8974af@kernel.org>
In-Reply-To: <20230427164546.31296-1-shannon.nelson@amd.com>
References: <20230427164546.31296-1-shannon.nelson@amd.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Thu, 27 Apr 2023 09:45:44 -0700 Shannon Nelson wrote:
> This is an RFC for adding to the pds_core driver some very simple support
> for VF representors and a tc command for offloading VF port vlans.
> 
> The problem to solve is how to request that a NIC do the push/pop of port
> vlans on a VF.  The initial pds_core patchset[0] included this support
> through the legacy ip-link methods with a PF netdev that had no datapath,
> simply existing to enable commands such as
>     ip link set <pf> vf <vfid> vlan <vid>
> This was soundly squashed with a request to create proper VF representors.
> The pds_core driver has since been reworked and merged without this feature.

Have you read the representors documentation? Passing traffic is
crucial.

> This pair of patches is a first attempt at adding support for a simple
> VF representor and tc offload which I've been tinkering with off and
> on over the last few weeks.  I will acknowledge that we have no proper
> filtering offload language in our firmware's adminq interface yet.
> This has been mentioned internally and is a "future project" with no
> actual schedule yet.  Given that, I have worked here with what I have,
> using the existing vf_setattr function.
> 
> An alternative that later occured to me is to make this a "devlink port
> function" thing, similar to the existing port mac.  This would have the
> benefit of using a familiar concept from and similar single command as
> the legacy method, would allow early port setup as with setting the mac
> and other port features, and would not need to create a lot of mostly
> empty netdevs for the VF representors.  I don't know if this would then
> lead to adding "trust" and "spoofcheck" as well, but I'm not aware of any
> other solutions for them, either.  This also might make more sense for
> devices that don't end up as user network interfaces, such as a virtio
> block device that runs over ethernet on the back end.  I don't have RFC
> code for this idea, but thought I would toss it out for discussion -
> I didn't see any previous related discussion in a (rather quick) search.

No, no -- the problem is not rtnetlink vs devlink but the fact 
that the old API was inventing its own parallel way of configuring
forwarding outside of normal/SW netdev concepts.

