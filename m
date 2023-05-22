Return-Path: <netdev+bounces-4369-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id D5DCA70C3C1
	for <lists+netdev@lfdr.de>; Mon, 22 May 2023 18:55:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id ACD751C20B95
	for <lists+netdev@lfdr.de>; Mon, 22 May 2023 16:55:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C2A2C14A92;
	Mon, 22 May 2023 16:55:09 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3958813AE5
	for <netdev@vger.kernel.org>; Mon, 22 May 2023 16:55:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20C77C433D2;
	Mon, 22 May 2023 16:55:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1684774507;
	bh=vkAlwsQMx2wZNoXGzlwhaRS7dm4lCOLkXVDx8xGJ3QY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=S6ZxzaCe0ikG/2Rj3oLs0VQA3AEkydLg7ymC0nDJwmwsgtVbwMTqeugWRVbSmnTov
	 4+7X84zzR/ZLUQGIjMl3GQvWJxmanZTHPmL7vLBUIG+1D6MbV3/rcA11GUm0nF161B
	 y8aSkXNKCD/OqIKPKxB2MJaDImIMNB0tPbVzX1iXixpmh5B607+m6h+DuKJhhXf9so
	 2hF61GaU0qaFvcyHiaDbO+wEEq9TO6l0ENrOEl2M/yRuLlfSMefTEkb1d4PDqUp+Dc
	 qL6y8f7sq7GvDMoD75yybkrZFbYc0Qii66y+rBfsBtQbjycPUAALhrntK/J+MrCtT+
	 MiI63dT4bnd8Q==
From: SeongJae Park <sj@kernel.org>
To: Pratyush Yadav <ptyadav@amazon.de>
Cc: "David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Kuniyuki Iwashima <kuniyu@amazon.com>,
	Willem de Bruijn <willemb@google.com>,
	Norbert Manthey <nmanthey@amazon.de>,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH net] net: fix skb leak in __skb_tstamp_tx()
Date: Mon, 22 May 2023 16:55:05 +0000
Message-Id: <20230522165505.90105-1-sj@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230522153020.32422-1-ptyadav@amazon.de>
References: 
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi Pratyush,

On Mon, 22 May 2023 17:30:20 +0200 Pratyush Yadav <ptyadav@amazon.de> wrote:

> Commit 50749f2dd685 ("tcp/udp: Fix memleaks of sk and zerocopy skbs with
> TX timestamp.") added a call to skb_orphan_frags_rx() to fix leaks with
> zerocopy skbs. But it ended up adding a leak of its own. When
> skb_orphan_frags_rx() fails, the function just returns, leaking the skb
> it just cloned. Free it before returning.
> 
> This bug was discovered and resolved using Coverity Static Analysis
> Security Testing (SAST) by Synopsys, Inc.
> 
> Fixes: 50749f2dd685 ("tcp/udp: Fix memleaks of sk and zerocopy skbs with TX timestamp.")

Seems the commit has merged in several stable kernels.  Is the bug also
affecting those?  If so, would it be better to Cc stable@vger.kernel.org?


Thanks,
SJ

> Signed-off-by: Pratyush Yadav <ptyadav@amazon.de>
> ---
> 
> I do not know this code very well, this was caught by our static
> analysis tool. I did not try specifically reproducing the leak but I did
> do a boot test by adding this patch on 6.4-rc3 and the kernel boots
> fine.
> 
>  net/core/skbuff.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/net/core/skbuff.c b/net/core/skbuff.c
> index 515ec5cdc79c..cea28d30abb5 100644
> --- a/net/core/skbuff.c
> +++ b/net/core/skbuff.c
> @@ -5224,8 +5224,10 @@ void __skb_tstamp_tx(struct sk_buff *orig_skb,
>  	} else {
>  		skb = skb_clone(orig_skb, GFP_ATOMIC);
> 
> -		if (skb_orphan_frags_rx(skb, GFP_ATOMIC))
> +		if (skb_orphan_frags_rx(skb, GFP_ATOMIC)) {
> +			kfree_skb(skb);
>  			return;
> +		}
>  	}
>  	if (!skb)
>  		return;
> --
> 2.39.2
> 

