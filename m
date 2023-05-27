Return-Path: <netdev+bounces-5848-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id BA836713239
	for <lists+netdev@lfdr.de>; Sat, 27 May 2023 05:50:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7199F28198E
	for <lists+netdev@lfdr.de>; Sat, 27 May 2023 03:50:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 94A4D389;
	Sat, 27 May 2023 03:49:59 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 099F91382
	for <netdev@vger.kernel.org>; Sat, 27 May 2023 03:49:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E3B2C433EF;
	Sat, 27 May 2023 03:49:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1685159397;
	bh=yrP6Wc7Ct6gZAhT7/KtzaiBmgH2CB/ztS5uBAkQWQJ8=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=aQzY2jZpmUhKEO8UCMWIntQ6C2Dy7JlhNgQ6O/590el5SEk5pWsWjZcteFivvm2Ov
	 sXca2QJQMRsm1wPJ44i4dNz/0qLbof46cF/Bh3jeVlRyUtv6N/BVRtByRfEOOFKWTS
	 SB6CjpwuP7fdXEc9R+EwmsYB4V7jQPO0v2iceN86O9+7Rt8CFSY5/BKDi6dc/SzZCM
	 CniUW9KfV7Rtpnpo523WI5PktF3IpiNvr1FoDIiqQzBrpF8KPbI+5hhvIsplarvffF
	 wbH6uoF0r4A6lM257kn8n7CNZRjmlonh8OH8sWt2c/pge75hM6xajPwlSiLz1lV2Dy
	 J1MxWX/G5oj6Q==
Date: Fri, 26 May 2023 20:49:56 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Xin Long <lucien.xin@gmail.com>
Cc: network dev <netdev@vger.kernel.org>, davem@davemloft.net, Eric Dumazet
 <edumazet@google.com>, Paolo Abeni <pabeni@redhat.com>, Thomas Graf
 <tgraf@infradead.org>, Alexander Duyck <alexanderduyck@fb.com>
Subject: Re: [PATCH net 1/3] rtnetlink: move validate_linkmsg into
 rtnl_create_link
Message-ID: <20230526204956.4cc0ddf3@kernel.org>
In-Reply-To: <7fde1eac7583cc93bc5b1cb3b386c522b32a94c9.1685051273.git.lucien.xin@gmail.com>
References: <cover.1685051273.git.lucien.xin@gmail.com>
	<7fde1eac7583cc93bc5b1cb3b386c522b32a94c9.1685051273.git.lucien.xin@gmail.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Thu, 25 May 2023 17:49:15 -0400 Xin Long wrote:
> In commit 644c7eebbfd5 ("rtnetlink: validate attributes in do_setlink()"),
> it moved validate_linkmsg() from rtnl_setlink() to do_setlink(). However,
> as validate_linkmsg() is also called in __rtnl_newlink(), it caused
> validate_linkmsg() being called twice when running 'ip link set'.
> 
> The validate_linkmsg() was introduced by commit 1840bb13c22f5b ("[RTNL]:
> Validate hardware and broadcast address attribute for RTM_NEWLINK") for
> existing links. After adding it in do_setlink(), there's no need to call
> it in __rtnl_newlink().
> 
> Instead of deleting it from __rtnl_newlink(), this patch moves it to
> rtnl_create_link() to fix the missing validation for the new created
> links.
> 
> Fixes: 644c7eebbfd5 ("rtnetlink: validate attributes in do_setlink()")

I don't see any bug in here, is there one? Or you're just trying 
to avoid calling validation twice? I think it's better to validate 
twice than validate after some changes have already been applied 
by __rtnl_newlink()...  If we really care about the double validation
we should pull the validation out of do_setlink(), IMHO.
-- 
pw-bot: cr

