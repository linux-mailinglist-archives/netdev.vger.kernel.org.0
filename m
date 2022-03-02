Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7FB764C9D72
	for <lists+netdev@lfdr.de>; Wed,  2 Mar 2022 06:35:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237500AbiCBFgS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Mar 2022 00:36:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229727AbiCBFgR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Mar 2022 00:36:17 -0500
Received: from isilmar-4.linta.de (isilmar-4.linta.de [136.243.71.142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C048B16D3;
        Tue,  1 Mar 2022 21:35:34 -0800 (PST)
X-isilmar-external: YES
X-isilmar-external: YES
X-isilmar-external: YES
X-isilmar-external: YES
X-isilmar-external: YES
X-isilmar-external: YES
X-isilmar-external: YES
X-isilmar-external: YES
Received: from owl.dominikbrodowski.net (owl.brodo.linta [10.2.0.111])
        by isilmar-4.linta.de (Postfix) with ESMTPSA id 8941D2013B0;
        Wed,  2 Mar 2022 05:35:31 +0000 (UTC)
Received: by owl.dominikbrodowski.net (Postfix, from userid 1000)
        id 1C34D8084F; Wed,  2 Mar 2022 06:33:38 +0100 (CET)
Date:   Wed, 2 Mar 2022 06:33:38 +0100
From:   Dominik Brodowski <linux@dominikbrodowski.net>
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
        netdev@vger.kernel.org, Alexander Graf <graf@amazon.com>,
        Jann Horn <jannh@google.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 1/3] random: replace custom notifier chain with standard
 one
Message-ID: <Yh8Bsk9RSm22Yr8d@owl.dominikbrodowski.net>
References: <20220301231038.530897-1-Jason@zx2c4.com>
 <20220301231038.530897-2-Jason@zx2c4.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220301231038.530897-2-Jason@zx2c4.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Am Wed, Mar 02, 2022 at 12:10:36AM +0100 schrieb Jason A. Donenfeld:
>  /*
>   * Delete a previously registered readiness callback function.
>   */
> -void del_random_ready_callback(struct random_ready_callback *rdy)
> +int unregister_random_ready_notifier(struct notifier_block *nb)
>  {
>  	unsigned long flags;
> -	struct module *owner = NULL;
> -
> -	spin_lock_irqsave(&random_ready_list_lock, flags);
> -	if (!list_empty(&rdy->list)) {
> -		list_del_init(&rdy->list);
> -		owner = rdy->owner;
> -	}
> -	spin_unlock_irqrestore(&random_ready_list_lock, flags);
> +	int ret;
>  
> -	module_put(owner);
> +	spin_lock_irqsave(&random_ready_chain_lock, flags);
> +	ret = raw_notifier_chain_unregister(&random_ready_chain, nb);
> +	spin_unlock_irqrestore(&random_ready_chain_lock, flags);
> +	return ret;
>  }
> -EXPORT_SYMBOL(del_random_ready_callback);

That doesn't seem to be used anywhere, so I'd suggest removing this function
altogether.

Otherwise:
	Reviewed-by: Dominik Brodowski <linux@dominikbrodowski.net>
