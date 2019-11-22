Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 81F8A107A81
	for <lists+netdev@lfdr.de>; Fri, 22 Nov 2019 23:27:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726690AbfKVW0z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Nov 2019 17:26:55 -0500
Received: from Chamillionaire.breakpoint.cc ([193.142.43.52]:36250 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726089AbfKVW0z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Nov 2019 17:26:55 -0500
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1iYHNs-0000DW-TO; Fri, 22 Nov 2019 23:26:36 +0100
Date:   Fri, 22 Nov 2019 23:26:36 +0100
From:   Florian Westphal <fw@strlen.de>
To:     Navid Emamdoost <navid.emamdoost@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Johannes Berg <johannes.berg@intel.com>,
        Taehee Yoo <ap420073@gmail.com>,
        Andreas Steinmetz <ast@domdv.de>,
        Michal Kubecek <mkubecek@suse.cz>,
        Florian Westphal <fw@strlen.de>,
        Thomas Gleixner <tglx@linutronix.de>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, emamd001@umn.edu
Subject: Re: [PATCH] macsec: Fix memory leaks in macsec_decrypt()
Message-ID: <20191122222636.GA21689@breakpoint.cc>
References: <20191122220242.29359-1-navid.emamdoost@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191122220242.29359-1-navid.emamdoost@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Navid Emamdoost <navid.emamdoost@gmail.com> wrote:
> In the implementation of macsec_decrypt(), there are two memory leaks
> when crypto_aead_decrypt() fails. Release allocated req and skb before
> return.
> 
> Fixes: c3b7d0bd7ac2 ("macsec: fix rx_sa refcounting with decrypt callback")
> Signed-off-by: Navid Emamdoost <navid.emamdoost@gmail.com>
> ---
>  drivers/net/macsec.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/drivers/net/macsec.c b/drivers/net/macsec.c
> index afd8b2a08245..34c6fb4eb9ef 100644
> --- a/drivers/net/macsec.c
> +++ b/drivers/net/macsec.c
> @@ -986,6 +986,8 @@ static struct sk_buff *macsec_decrypt(struct sk_buff *skb,
>  	dev_hold(dev);
>  	ret = crypto_aead_decrypt(req);
>  	if (ret == -EINPROGRESS) {
> +		aead_request_free(req);
> +		kfree_skb(skb);

-EINPROGRESS means decryption is handled asynchronously, no?

>  		return ERR_PTR(ret);
>  	} else if (ret != 0) {
>  		/* decryption/authentication failed

This is the error handling/failure path.
