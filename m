Return-Path: <netdev+bounces-6694-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5BA2B717738
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 08:53:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D196B2810DF
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 06:53:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7E29479EA;
	Wed, 31 May 2023 06:53:42 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D19E84C67
	for <netdev@vger.kernel.org>; Wed, 31 May 2023 06:53:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0CF78C433EF;
	Wed, 31 May 2023 06:53:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1685516020;
	bh=P/Gordd1Z3H5zhziKkJrDF2UZKDWe/Y4d6SpG+mnKac=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=iiOjHmgIh6qfidvfdWUde2IXym800uLQ7EfNLjGoADzAb4mWOG2vqNx3XKuxkO8is
	 /8sdaocmmp9TcrkLk/2uIF1T15SqSAW9qxvxO2CKrIAsrwj7eUmz22IZa2LoPXYjfw
	 11VB+P+sgfqgvJUvI3dSSVZOqgTtdpizPNFp4JZhh3NekSUleYyKcxlqa5xcl2Nt/W
	 w20CQ5CZYpwqRCiACYpoEc0a7C+2CT8ERDve6pTaRIPMNdSSo2HFXTh40qNEIue08X
	 RzVwIwPCsJBBGyeAAAIhTLb8S7eSrlBsakKRjm/NQ+IcY17AEzs8Gej31BPIW6Ox3z
	 RLBAov2dZi50w==
Date: Tue, 30 May 2023 23:53:39 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Jiri Pirko <jiri@resnulli.us>
Cc: netdev@vger.kernel.org, pabeni@redhat.com, davem@davemloft.net,
 edumazet@google.com, saeedm@nvidia.com, moshe@nvidia.com,
 simon.horman@corigine.com, leon@kernel.org
Subject: Re: [patch net-next] devlink: bring port new reply back
Message-ID: <20230530235339.13f82dbe@kernel.org>
In-Reply-To: <ZHbq6aH+S69heG44@nanopsycho>
References: <20230530063829.2493909-1-jiri@resnulli.us>
	<20230530095435.70a733fc@kernel.org>
	<20230530151444.09a5d7c1@kernel.org>
	<ZHbq6aH+S69heG44@nanopsycho>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed, 31 May 2023 08:36:25 +0200 Jiri Pirko wrote:
> >> FWIW it should be fairly trivial to write tests for notifications and
> >> replies now that YNL exists and describes devlink..  
> >
> >Actually, I'm not 100% sure notifications work for devlink, with its
> >rtnl-inspired command ID sharing.  
> 
> Could you elaborate more where could be a problem?

right here

https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next.git/tree/tools/net/ynl/lib/ynl.py#n518

;)  If we treat Netlink as more of an RPC than.. state replication(?)
mechanism having responses and notifications with the same ID is a bit
awkward. I felt like I had to make a recommendation in YNL either to
ask users not to enable notifications and issue commands on the same
socket, or for family authors to use different IDs. I went with the
latter. And made YNL be a bit conservative as to what it will consider
to be a notification.

