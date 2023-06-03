Return-Path: <netdev+bounces-7619-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id EDE29720DFE
	for <lists+netdev@lfdr.de>; Sat,  3 Jun 2023 07:55:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A8691281B77
	for <lists+netdev@lfdr.de>; Sat,  3 Jun 2023 05:55:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F037D524A;
	Sat,  3 Jun 2023 05:55:21 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF91423A2
	for <netdev@vger.kernel.org>; Sat,  3 Jun 2023 05:55:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD340C433D2;
	Sat,  3 Jun 2023 05:55:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1685771720;
	bh=BY2PwvlTytRqfRCUBmDd8GS5hKDMoCaWTKd22a+Jz7g=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=eXbV5kUQyk/ndeeFuEAYQ2mjH9VqVcghvb6SRK5JEmWREgCJDta+zkb5TacF0BMFE
	 7NTX2djcBKIWj+mqddnlnqz+tU9/yhD6KfmISw/hOc4QQgPsOj1K2et9boIjWcjPNg
	 50dsOkWKHz2rhXKzfbAZZqD2KJGHrYuRw0bt+rU/ii09eBKHNz6IZXPj7GNJtqAv38
	 KQAboIaP2DUgxIwu6h4bqIrt9wF8grcXzWqZppwe5tj9PcKaejywkknT2SGwNaJY3b
	 6pHloOodNZu98yQm3BAcklIyzGOTYWjBeGDVoFRH8Lq1sB9jB7rXSMs1awpFSGEXBi
	 FpOEFSrV1beKw==
Date: Fri, 2 Jun 2023 22:55:19 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Ding Hui <dinghui@sangfor.com.cn>
Cc: Alexander Duyck <alexander.duyck@gmail.com>, Andrew Lunn
 <andrew@lunn.ch>, davem@davemloft.net, edumazet@google.com,
 pabeni@redhat.com, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
 pengdonglin@sangfor.com.cn, huangcun@sangfor.com.cn
Subject: Re: [PATCH net-next] net: ethtool: Fix out-of-bounds copy to user
Message-ID: <20230602225519.66c2c987@kernel.org>
In-Reply-To: <44905acd-3ac4-cfe5-5e91-d182c1959407@sangfor.com.cn>
References: <20230601112839.13799-1-dinghui@sangfor.com.cn>
	<135a45b2c388fbaf9db4620cb01b95230709b9ac.camel@gmail.com>
	<eed0cbf7-ff12-057e-e133-0ddf5e98ef68@sangfor.com.cn>
	<6110cf9f-c10e-4b9b-934d-8d202b7f5794@lunn.ch>
	<f7e23fe6-4d30-ef1b-a431-3ef6ec6f77ba@sangfor.com.cn>
	<6e28cea9-d615-449d-9c68-aa155efc8444@lunn.ch>
	<CAKgT0UdyykQL-BidjaNpjX99FwJTxET51U29q4_CDqmABUuVbw@mail.gmail.com>
	<ece228a3-5c31-4390-b6ba-ec3f2b6c5dcb@lunn.ch>
	<CAKgT0Uf+XaKCFgBRTn-viVsKkNE7piAuDpht=efixsAV=3JdFQ@mail.gmail.com>
	<44905acd-3ac4-cfe5-5e91-d182c1959407@sangfor.com.cn>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Sat, 3 Jun 2023 09:51:34 +0800 Ding Hui wrote:
> > If that is the case maybe it would just make more sense to just return
> > an error if we are at risk of overrunning the userspace allocated
> > buffer.
> 
> In that case, I can modify to return an error, however, I think the
> ENOSPC or EFBIG mentioned in a previous email may not be suitable,
> maybe like others length/size checking return EINVAL.
> 
> Another thing I wondered is that should I update the current length
> back to user if user buffer is not enough, assuming we update the new
> length with error returned, the userspace can use it to reallocate
> buffer if he wants to, which can avoid re-call previous ioctl to get
> the new length.

This entire thread presupposes that user provides the length of 
the buffer. I don't see that in the code. Take ethtool_get_stats()
as an example, you assume that stats.n_stats is set correctly,
but it's not enforced today. Some app somewhere may pass in zeroed
out stats and work just fine.

