Return-Path: <netdev+bounces-5996-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 63CDF7144ED
	for <lists+netdev@lfdr.de>; Mon, 29 May 2023 08:33:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B5638280D67
	for <lists+netdev@lfdr.de>; Mon, 29 May 2023 06:33:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E404A36D;
	Mon, 29 May 2023 06:33:37 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6830365
	for <netdev@vger.kernel.org>; Mon, 29 May 2023 06:33:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7F71C4339B;
	Mon, 29 May 2023 06:33:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1685342016;
	bh=HL3sVgWFuWHslef+sITmFfKHwkVIuHsQsOF8Wnhb87o=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=EV4SD6glj8a/cjF0MF/dJ3YmJGc5KNiRMBDDGPDwJm+CS9dkJiIAbHYvOi0vBXESe
	 17XLcvl6OyB116bucMWR3/3u/vk+xLXDN/KsKBXErN6zyWcTLBNfW/wKVwTHjG+cdH
	 GqsPBGf8Q+0/uaHktAynEReQcOUIBd78G24cjm9tOjEtXToxt+1ww5KS/iiBiZ0cIl
	 XkdEUM3BBKscQQ4u5PPoescLvMG9YTSyRRwHwzG0yI4YXIykwNMZxCQale6veIJ+W2
	 IpMdj3b+6CNO2M3UP4Pzka6+PCLoO3N+lOjK5IY9H6giFj7VY1rj4RbPmMopQ2g3xg
	 pWDEeCaOjRNGg==
Date: Sun, 28 May 2023 23:33:34 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Jiri Pirko <jiri@resnulli.us>
Cc: netdev@vger.kernel.org, pabeni@redhat.com, davem@davemloft.net,
 edumazet@google.com, leon@kernel.org, saeedm@nvidia.com, moshe@nvidia.com,
 jesse.brandeburg@intel.com, anthony.l.nguyen@intel.com, tariqt@nvidia.com,
 idosch@nvidia.com, petrm@nvidia.com, simon.horman@corigine.com,
 ecree.xilinx@gmail.com, habetsm.xilinx@gmail.com,
 michal.wilczynski@intel.com, jacob.e.keller@intel.com
Subject: Re: [patch net-next v2 14/15] devlink: move port_del() to
 devlink_port_ops
Message-ID: <20230528233334.77dc191d@kernel.org>
In-Reply-To: <ZHG0dSuA7s0ggN0o@nanopsycho>
References: <20230526102841.2226553-1-jiri@resnulli.us>
	<20230526102841.2226553-15-jiri@resnulli.us>
	<20230526211008.7b06ac3e@kernel.org>
	<ZHG0dSuA7s0ggN0o@nanopsycho>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Sat, 27 May 2023 09:42:45 +0200 Jiri Pirko wrote:
> >I didn't think this thru last time, I thought port_new will move 
> >in another patch, but that's impossible (obviously?).
> >
> >Isn't it kinda weird that the new callback is in one place and del
> >callback is in another? Asymmetric ?  
> 
> Yeah, I don't know how to do it differently. port_new() has to be
> devlink op, as it operates not on the port but on the device. However,
> port_del() operates on device. I was thinking about changing the name of
> port_del() to port_destructor() or something like that which would make
> the symmetricity issue bit less visible. IDK, up to you. One way or
> another, I think this could be easily done as a follow-up (I have 15
> patches now already anyway).

One could argue logically removing a port is also an operation of 
the parent (i.e. the devlink instance). The fact that the port gets
destroyed in the process is secondary. Ergo maybe we should skip 
this patch?

