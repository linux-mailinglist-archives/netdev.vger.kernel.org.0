Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D21129CD25
	for <lists+netdev@lfdr.de>; Wed, 28 Oct 2020 02:47:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726118AbgJ1Bie (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Oct 2020 21:38:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:36356 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1833072AbgJ1AFJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 27 Oct 2020 20:05:09 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1AA0E2223C;
        Wed, 28 Oct 2020 00:05:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603843508;
        bh=YpqKaox/vV0oHuKCNaESYtTE/1kegOMdnVOuMXgDRIE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=gMJvpnzAE8V4ZvJVCAHNJ0LQgzK2Mvtegmar101/gMaGMS2e5PM5yjkwuY9SE0p7S
         Cmgm8AdH5TzLmkpyO1ThhJ6dl6JMApu7c9V97rJcvocrz2tD5JbrbDeVDbz5yWHFYd
         vlyuE2IGCKQm8GPOBQx37ZZnYmhgfcLnsw2rbdZ8=
Date:   Tue, 27 Oct 2020 17:05:07 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Vinay Kumar Yadav <vinay.yadav@chelsio.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, secdev@chelsio.com
Subject: Re: [PATCH net,v2] chelsio/chtls: fix memory leaks
Message-ID: <20201027170507.2266e96b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201025194935.31754-1-vinay.yadav@chelsio.com>
References: <20201025194935.31754-1-vinay.yadav@chelsio.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 26 Oct 2020 01:19:36 +0530 Vinay Kumar Yadav wrote:
> Correct skb refcount in alloc_ctrl_skb(), causing skb memleak
> when chtls_send_abort() called with NULL skb.
> Also race between user context and softirq causing memleak,
> consider the call sequence scenario

Sounds like two separate fixes?

> chtls_setkey()         //user context
> chtls_peer_close()
> chtls_abort_req_rss()
> chtls_setkey()         //user context
> 
> work request skb queued in chtls_setkey() won't be freed
> because resources are already cleaned for this connection,
> fix it by not queuing work request while socket is closing.
> 
> v1->v2:
> - fix W=1 warning.
> 
> Fixes: cc35c88ae4db ("crypto : chtls - CPL handler definition")
> Signed-off-by: Vinay Kumar Yadav <vinay.yadav@chelsio.com>
> ---
>  drivers/net/ethernet/chelsio/inline_crypto/chtls/chtls_cm.c | 2 +-
>  drivers/net/ethernet/chelsio/inline_crypto/chtls/chtls_hw.c | 3 +++
>  2 files changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/chelsio/inline_crypto/chtls/chtls_cm.c b/drivers/net/ethernet/chelsio/inline_crypto/chtls/chtls_cm.c
> index 24154816d1d1..63aacc184f68 100644
> --- a/drivers/net/ethernet/chelsio/inline_crypto/chtls/chtls_cm.c
> +++ b/drivers/net/ethernet/chelsio/inline_crypto/chtls/chtls_cm.c
> @@ -212,7 +212,7 @@ static struct sk_buff *alloc_ctrl_skb(struct sk_buff *skb, int len)
>  {
>  	if (likely(skb && !skb_shared(skb) && !skb_cloned(skb))) {
>  		__skb_trim(skb, 0);
> -		refcount_add(2, &skb->users);
> +		refcount_inc(&skb->users);

You just switched from adding two refs to adding one.
Was this always leaking the skb?

Also skb_get().

>  	} else {
>  		skb = alloc_skb(len, GFP_KERNEL | __GFP_NOFAIL);
>  	}
> diff --git a/drivers/net/ethernet/chelsio/inline_crypto/chtls/chtls_hw.c b/drivers/net/ethernet/chelsio/inline_crypto/chtls/chtls_hw.c
> index f1820aca0d33..62c829023da5 100644
> --- a/drivers/net/ethernet/chelsio/inline_crypto/chtls/chtls_hw.c
> +++ b/drivers/net/ethernet/chelsio/inline_crypto/chtls/chtls_hw.c
> @@ -383,6 +383,9 @@ int chtls_setkey(struct chtls_sock *csk, u32 keylen,
>  	if (ret)
>  		goto out_notcb;
>  
> +	if (unlikely(csk_flag(sk, CSK_ABORT_SHUTDOWN)))
> +		goto out_notcb;
> +
>  	set_wr_txq(skb, CPL_PRIORITY_DATA, csk->tlshws.txqid);
>  	csk->wr_credits -= DIV_ROUND_UP(len, 16);
>  	csk->wr_unacked += DIV_ROUND_UP(len, 16);

