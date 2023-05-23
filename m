Return-Path: <netdev+bounces-4462-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B2BBE70D096
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 03:37:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id EA5521C20B18
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 01:37:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0543B186F;
	Tue, 23 May 2023 01:37:24 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A563D1110
	for <netdev@vger.kernel.org>; Tue, 23 May 2023 01:37:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23528C433D2;
	Tue, 23 May 2023 01:37:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1684805842;
	bh=/1JJh/86oj1jP3fYXZvZXF70z0+5YYFZNktJc7MjB6g=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=vQ7/Hbg4KBpaSfzBNuu/LFtovRdIvPFvn//f1t0q1DJvwSmC1RvOxTQ9Py7Vzqnbj
	 76HfILZtRYKtI9lJ/STZ3Ly5nRm7qiLOM8iKHU6fdP0lQ/tlyO3Ep1cxZ9twsa5hgG
	 xSjarqTR6bJ1ic/Ogl0v0rMP3Q05RuTLhlkk1NzqjCzlUxI3evvskMsjeYdwNk/Hth
	 VuGcQHiip4M9TRyGJQbIKDtTi5N5PGCJ5HiCHCu86w2OSyLQXHfYs697qIikDIJGu8
	 F8vzAmWD6CG1D8W8pij3CueqFDoybsVRPtUrT/h1bJoUB06Dj4AplNEPVvDygYFSf1
	 lXyZI/IguPEGA==
Date: Mon, 22 May 2023 18:37:21 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Chris Adams <linux@cmadams.net>
Cc: Florian Fainelli <f.fainelli@gmail.com>, netdev@vger.kernel.org, Igor
 Russkikh <irusskikh@marvell.com>, Egor Pomozov <epomozov@marvell.com>
Subject: Re: netconsole not working on bridge+atlantic
Message-ID: <20230522183721.74c395ec@kernel.org>
In-Reply-To: <20230520030924.GB30096@cmadams.net>
References: <20230520003818.GA30096@cmadams.net>
	<ced226b9-e14c-a1fc-4974-8492efd45270@gmail.com>
	<20230520030924.GB30096@cmadams.net>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Fri, 19 May 2023 22:09:24 -0500 Chris Adams wrote:
> Once upon a time, Florian Fainelli <f.fainelli@gmail.com> said:
> > On 5/19/2023 5:38 PM, Chris Adams wrote:  
> > >I have a system with an Aquantia AQC107 NIC connected to a bridge (for
> > >VM NICs).  I set up netconsole on it, and it logs that it configures
> > >correctly in dmesg, but it doesn't actually send anything (or log any
> > >errors).  Any ideas?  
> > 
> > It does not look like there is a ndo_poll_controller callback
> > implemented by the atlantic driver which is usually a prerequisite
> > to supporting netconsole.  

I don't think ndo_poll_controller is strictly necessary any more.
If absent core will poll all NAPI instances of the driver with budget
of 0.

> Is that something that netconsole (or anything else in the kernel) could
> check and warn about?  Is there a way other than looking at the source
> (and knowing what to look for) to tell which NICs do or don't support
> netconsole?  I searched around and didn't see that netconsole is only
> expected to work with some NICs, or has certain requirements for
> working.
> 
> > >This is on Fedora 37, updated to distro kernel 6.3.3-100.fc37.x86_64.
> > >It hasn't worked for some time (not sure exactly when).  
> > 
> > Does that mean that it worked up to a certain point and then stopped?  
> 
> I'm not sure, I didn't check it for a while (I only use it when
> something isn't working right, and that doesn't happen much).  It's
> possible it hasn't worked since I added the Aquantia NIC.

You can try to use the kfree_skb tracepoint to see where the netcons
skbs get dropped.

