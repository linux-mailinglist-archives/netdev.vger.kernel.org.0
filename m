Return-Path: <netdev+bounces-55-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 2E0FB6F4EF9
	for <lists+netdev@lfdr.de>; Wed,  3 May 2023 05:03:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 52F14280D4C
	for <lists+netdev@lfdr.de>; Wed,  3 May 2023 03:03:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F20B980D;
	Wed,  3 May 2023 03:03:09 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B14357F4
	for <netdev@vger.kernel.org>; Wed,  3 May 2023 03:03:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C1C9C433EF;
	Wed,  3 May 2023 03:03:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1683082988;
	bh=HWnPzdzfRZfaKJQmjGlFiyIXN5Cfhb/XR7QK2inUdIk=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=ksq81tb+JNyTjstOI4DZyRVOqgXX87QPTwka45tR1MQyeRMBC2YmeErsBw8mVGi6i
	 zdvf+upXOdOTPBYUjsIFwFPTQQkM5Kcl9FVkO123KtvVU/Ij5msK24Ly/8vqR0wvRS
	 Vy0BNp7nHMIeFi8Tq8o7r0tYuY5nuHZit2IYTKNJJA/EBHKcE935wRXqr/4blc+kpk
	 lwkZ9gf/xRyW9S6P/SRQbo/Xp4cWrbtT/rDAq3uAb044BxZ+zyON5yCkdF5Z7/9mTS
	 p3NsJ3QsZq+UVI89rZNE5rRzAYRNuQFZfEa2/lH9VjmkLv2Hld2PoBnEJY7A0gTG7i
	 bH9pYTk1NN2gw==
Date: Tue, 2 May 2023 20:03:07 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Manish Chopra <manishc@marvell.com>
Cc: Stephen Hemminger <stephen@networkplumber.org>,
 <netdev@vger.kernel.org>, <aelior@marvell.com>, <palok@marvell.com>,
 Sudarsana Kalluru <skalluru@marvell.com>, "David S . Miller"
 <davem@davemloft.net>
Subject: Re: [PATCH v3 net] qed/qede: Fix scheduling while atomic
Message-ID: <20230502200307.11bbe4ef@kernel.org>
In-Reply-To: <20230428102651.01215795@hermes.local>
References: <20230428161337.8485-1-manishc@marvell.com>
	<20230428102651.01215795@hermes.local>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Fri, 28 Apr 2023 10:26:51 -0700 Stephen Hemminger wrote:
> On Fri, 28 Apr 2023 09:13:37 -0700
> Manish Chopra <manishc@marvell.com> wrote:
> 
> > -		usleep_range(1000, 2000);
> > +
> > +		if (is_atomic)
> > +			udelay(QED_BAR_ACQUIRE_TIMEOUT_UDELAY);
> > +		else
> > +			usleep_range(QED_BAR_ACQUIRE_TIMEOUT_USLEEP,
> > +				     QED_BAR_ACQUIRE_TIMEOUT_USLEEP * 2);
> >  	}  
> 
> This is a variant of the conditional locking which is an ugly design pattern.
> It makes static checking tools break and
> a source of more bugs.
> 
> Better to fix the infrastructure or caller to not spin, or have two different
> functions.

FWIW the most common way to solve this issue is using a delayed work
which reads out the stats periodically from a non-atomic context, and
return a stashed copy from get_stat64.

