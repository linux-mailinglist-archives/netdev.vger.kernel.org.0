Return-Path: <netdev+bounces-5383-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 3FEC3710FD5
	for <lists+netdev@lfdr.de>; Thu, 25 May 2023 17:41:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id AC3B11C20EEF
	for <lists+netdev@lfdr.de>; Thu, 25 May 2023 15:41:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CD99419BB4;
	Thu, 25 May 2023 15:41:42 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E90F43D7C
	for <netdev@vger.kernel.org>; Thu, 25 May 2023 15:41:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3EF89C433D2;
	Thu, 25 May 2023 15:41:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1685029300;
	bh=mE3JdQ4IVTJW5EnMsaQFQKF0IBoNFJyIySUUiYE4Hm8=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=vHfSZp4q9TGUciYt956Q1qqGmTXBlC+Xn31Yog1LJh0jXpnXfqPJdG6vthVhO4Tru
	 bTshjdahrch33pZ8PIVDuPZa0OgtLUM1bPHLQkB5Cqs1rayxnxTJI4h2B+cskygHa+
	 LahggifZ3Q7Is0rCwJETmdoJqruQUvCYJ5yMvv3J0GH6IIUEXGCT7iItw/ozTIoxj8
	 /87fueZYy+YtY86NXLfRkOgiWc/dxjLL51BH9yWfmEI1CktSWXeg2vG/n0evfZjJgZ
	 VLCVVR66Bfiig6Csu6pirjUOEWyQlZmStdDRc0H1MHGp6aqwE5JWLoy2S9M16jLy9A
	 zqQl3oSvsi61Q==
Date: Thu, 25 May 2023 08:41:39 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: "Wilczynski, Michal" <michal.wilczynski@intel.com>
Cc: Jiri Pirko <jiri@resnulli.us>, Tony Nguyen <anthony.l.nguyen@intel.com>,
 <davem@davemloft.net>, <pabeni@redhat.com>, <edumazet@google.com>,
 <netdev@vger.kernel.org>, <lukasz.czapnik@intel.com>,
 <przemyslaw.kitszel@intel.com>
Subject: Re: [PATCH net-next 0/5][pull request] ice: Support 5 layer Tx
 scheduler topology
Message-ID: <20230525084139.7e381557@kernel.org>
In-Reply-To: <e5a3edb9-1f6b-d7af-3f3a-4c80ee567c6b@intel.com>
References: <20230523174008.3585300-1-anthony.l.nguyen@intel.com>
	<ZG367+pNuYtvHXPh@nanopsycho>
	<98366fa5-dc88-aa73-d07b-10e3bc84321c@intel.com>
	<20230524092607.17123289@kernel.org>
	<7ece1ba9-03bf-b836-1c55-c57f5235467c@intel.com>
	<20230524130240.24a47852@kernel.org>
	<e5a3edb9-1f6b-d7af-3f3a-4c80ee567c6b@intel.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Thu, 25 May 2023 09:49:53 +0200 Wilczynski, Michal wrote:
> On 5/24/2023 10:02 PM, Jakub Kicinski wrote:
> > On Wed, 24 May 2023 18:59:20 +0200 Wilczynski, Michal wrote:  
> >> Sorry about that, I gave examples from the top of my head, since those are the
> >> features that potentially could modify the scheduler tree, seemed obvious to me
> >> at the time. Lowering number of layers in the scheduling tree increases performance,
> >> but only allows you to create a much simpler scheduling tree. I agree that mentioning the
> >> features that actually modify the scheduling tree could be helpful to the reviewer.  
> > Reviewer is one thing, but also the user. The documentation needs to be
> > clear enough for the user to be able to confidently make a choice one
> > way or the other. I'm not sure 5- vs 9-layer is meaningful to the user
> > at all.  
> 
> It is relevant especially if the number of VF's/queues is not a multiply of 8, as described
> in the first commit of this series - that's the real-world user problem. Performance was
> not consistent among queues if you had 9 queues for example.
> 
> But I was also trying to provide some background on why we don't want to make 5-layer
> topology the default in the answers above.

What I'm saying is that 5- vs 9-layer is not meaningful as 
a description. The user has to (somehow?!) know that the number 
of layers in the hierarchy implies the grouping problem.
The documentation doesn't mention the grouping problem!

+     - This parameter gives user flexibility to choose the 5-layer
+       transmit scheduler topology, which helps to smooth out the transmit
+       performance. The default topology is 9-layer. Each layer represents
+       a physical junction in the network. Decreased number of layers
+       improves performance, but at the same time number of network junctions
+       is reduced, which might not be desirable depending on the use case.

> >  In fact, the entire configuration would be better defined as
> > a choice of features user wants to be available and the FW || driver
> > makes the decision on how to implement that most efficiently.  
> 
> User can change number of queues/VF's 'on the fly' , but change in topology
> requires a reboot basically, since the contents of the NVM are changed.
> 
> So to accomplish that we would need to perform topology change after each
> change to number of queues to adapt, and it's not feasible to reboot every time
> user changes number of queues.
> 
> Additionally 5-layer topology doesn't disable any of the features mentioned
> (i.e. DCB/devlink-rate) it just makes them work a bit differently, but they still
> should work.
> 
> To summarize: I would say that this series address specific performance problem
> user might have if their queue count is not a power of 8. I can't see how this can
> be solved by a choice of features, as the decision regarding number of queues can
> be made 'on-the-fly'.

Well, think among yourselves. "txbalancing" and a enigmatic
documentation talking about topology and junctions is a no go.

