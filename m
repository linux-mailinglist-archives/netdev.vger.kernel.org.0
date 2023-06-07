Return-Path: <netdev+bounces-8936-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9AE097265B1
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 18:19:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id AE82E1C20E06
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 16:19:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 69CD337325;
	Wed,  7 Jun 2023 16:19:13 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10F65C8CA
	for <netdev@vger.kernel.org>; Wed,  7 Jun 2023 16:19:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2F85C433EF;
	Wed,  7 Jun 2023 16:19:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686154751;
	bh=aQC2SIhgbGQP6vPMDcforICIRjbQ3XlpE3iaJwWJlxc=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=KEA1pDLkuWW0O8jeB4lN31JCEYHYGaOR1lTE4Cgtq0bHXrTh/Gdvs1u/xiQIcuZhh
	 72vNP3zkmrpwBSdn1d49fHwLZ5PwSXh26QbV3rkyMdcLyYlXd3lQjDP+h3/Yu448TC
	 0kJornPXmhJ5GARA9k3BkPz2UdPnF5FnQBkpoeAwYnQG52F3TPaPP9FO/oiTsELrx8
	 9v9Ie0wg+CYhGB5W4KWfVjH6EmZdO6ulEq4ayLJpk9UFvSrxB2Dv5wXphFjAJdFe8R
	 w2SIo7uOw/iNK2xsllTZoRdah4c7sdXta8bVKp0BD9IKeqOIyoFNfI1jI93t8oQyX+
	 8yUFUawqnIcng==
Date: Wed, 7 Jun 2023 09:19:09 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Saeed Mahameed <saeed@kernel.org>, "David S. Miller"
 <davem@davemloft.net>, Paolo Abeni <pabeni@redhat.com>, Eric Dumazet
 <edumazet@google.com>, Saeed Mahameed <saeedm@nvidia.com>,
 netdev@vger.kernel.org, Tariq Toukan <tariqt@nvidia.com>, Leon Romanovsky
 <leonro@nvidia.com>, linux-rdma@vger.kernel.org, Jiri Pirko
 <jiri@nvidia.com>
Subject: Re: [net-next 13/15] net/mlx5: Skip inline mode check after
 mlx5_eswitch_enable_locked() failure
Message-ID: <20230607091909.321fc5d7@kernel.org>
In-Reply-To: <ZICP4kWm5moYRKm1@ziepe.ca>
References: <20230606071219.483255-1-saeed@kernel.org>
	<20230606071219.483255-14-saeed@kernel.org>
	<20230606220117.0696be3e@kernel.org>
	<ZICP4kWm5moYRKm1@ziepe.ca>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed, 7 Jun 2023 11:10:42 -0300 Jason Gunthorpe wrote:
> On Tue, Jun 06, 2023 at 10:01:17PM -0700, Jakub Kicinski wrote:
> > On Tue,  6 Jun 2023 00:12:17 -0700 Saeed Mahameed wrote:  
> > > Fixes: bffaa916588e ("net/mlx5: E-Switch, Add control for inline mode")
> > > Fixes: 8c98ee77d911 ("net/mlx5e: E-Switch, Add extack messages to devlink callbacks")  
> > 
> > The combination of net-next and Fixes is always odd.
> > Why? 
> > Either it's important enough to be a fix or its not important 
> > and can go to net-next...  
> 
> Generally I tell people to mark things as Fixes if it is a fix,
> regardless of how small, minor or unimportant.

Yes, exactly, we do the same, but also to send them all to net.

> It helps backporters because they can suck in the original patch and
> all the touchups then test that result. If people try to predict if it
> is "important" or not they get it wrong quite often.
> 
> Fixes is not supposed to mean "this is important" or "send this to
> -rc" or "apply it to -stable"

Agreed with the distinction that we consider every fix -rc worthy.
We'll obviously apply our own judgment but submitter should send all
fixes against net.

> If it is really important add a 'cc: stable'.
> 
> If it is sort of important then send it to the -rc tree.
> 
> Otherwise dump it in the merge window.

You just said that people can't predict the importance of their fixes
and yet you draw categories.

> But mark it with Fixes regardless

Every subsystem can make their own rules. In netdev Fixes go to net.

