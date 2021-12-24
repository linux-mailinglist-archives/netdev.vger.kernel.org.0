Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2DE9A47F158
	for <lists+netdev@lfdr.de>; Fri, 24 Dec 2021 23:45:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229719AbhLXWed (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Dec 2021 17:34:33 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:50594 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229464AbhLXWec (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Dec 2021 17:34:32 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 40B1FB8233D;
        Fri, 24 Dec 2021 22:34:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09799C36AE8;
        Fri, 24 Dec 2021 22:34:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1640385269;
        bh=NMGUhYwV4WBlPsAMtZhQzx0ZP9lDdLJBtFIBPXnnSaA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=EiseSKytRuFT/o7uqe+d3ncxZr0HeZI5Qrw7lgGJs2Imsv44IRYPocGVtueaSq9nU
         oE4tWx+ehO1tcUJGVllFEB2HfySVlS2+OqjIPCegSLxmMKYr9KHN2yp6WkVm3x/u7y
         jEAKvT9x9bLo01x+D4ZwANRKgJuWwA7I2D1C/Vo2aLlgptbU7KfORJeHs0gF+Lb6lX
         et51nt+L81TRxsCiY4aJa7B4Foa1WdtEE9Tc+juRAliDUJkg5tltZ2HcB3cPs1/1K1
         3Pm1iAxO6sW2th1UY1YoYjLSG2qpxbqqLJsGveAUYMAwcP5I8NyR2H8xqVGKt3r1tJ
         2+4YDFEhFM9TQ==
Date:   Fri, 24 Dec 2021 14:34:27 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jiasheng Jiang <jiasheng@iscas.ac.cn>
Cc:     jmaloy@redhat.com, ying.xue@windriver.com, davem@davemloft.net,
        netdev@vger.kernel.org, tipc-discussion@lists.sourceforge.net,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net/tipc: Check null mem pointer
Message-ID: <20211224143427.6aeebb8f@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20211224074646.1588903-1-jiasheng@iscas.ac.cn>
References: <20211224074646.1588903-1-jiasheng@iscas.ac.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 24 Dec 2021 15:46:46 +0800 Jiasheng Jiang wrote:
> For the possible alloc failure of the kmemdup(), it may return null
> pointer.
> Therefore, the returned pointer should be checked to guarantee the
> success of the init.
> 
> Fixes: fc1b6d6de220 ("tipc: introduce TIPC encryption & authentication")
> Signed-off-by: Jiasheng Jiang <jiasheng@iscas.ac.cn>
> ---
>  net/tipc/crypto.c | 7 +++++++
>  1 file changed, 7 insertions(+)
> 
> diff --git a/net/tipc/crypto.c b/net/tipc/crypto.c
> index c9391d38de85..19015e08e750 100644
> --- a/net/tipc/crypto.c
> +++ b/net/tipc/crypto.c
> @@ -596,7 +596,14 @@ static int tipc_aead_init(struct tipc_aead **aead, struct tipc_aead_key *ukey,
>  	tmp->mode = mode;
>  	tmp->cloned = NULL;
>  	tmp->authsize = TIPC_AES_GCM_TAG_SIZE;
> +
>  	tmp->key = kmemdup(ukey, tipc_aead_key_size(ukey), GFP_KERNEL);
> +	if (!tmp->key) {
> +		free_percpu(tmp->tfm_entry);
> +		kfree_sensitive(tmp);
> +		return -ENOMEM;
> +	}
> +
>  	memcpy(&tmp->salt, ukey->key + keylen, TIPC_AES_GCM_SALT_SIZE);
>  	atomic_set(&tmp->users, 0);
>  	atomic64_set(&tmp->seqno, 0);

Fixed over a month ago 3e6db079751a ("tipc: check for null after calling
kmemdup")
