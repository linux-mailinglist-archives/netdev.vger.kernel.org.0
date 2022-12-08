Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B926C647463
	for <lists+netdev@lfdr.de>; Thu,  8 Dec 2022 17:34:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229989AbiLHQeL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Dec 2022 11:34:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230170AbiLHQd7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Dec 2022 11:33:59 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A5F61FCCD
        for <netdev@vger.kernel.org>; Thu,  8 Dec 2022 08:33:58 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4D55BB824D2
        for <netdev@vger.kernel.org>; Thu,  8 Dec 2022 16:33:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6FA8C433EF;
        Thu,  8 Dec 2022 16:33:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670517236;
        bh=iqiJD35d76xukWCdOWd/vQtb4LhNvhJ8NgLo2lE96UM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=gItihvERuzQRfaVHroh3G1tBP9opbvAX9MJ6c+QdFY+dz3nbh/0g1wvvg4z/L8PgH
         9ACjxX/+vgzfmq3NoeWTZYOw3pJyNkpExa95oT9PPX/FRn2hHGX0sVpyXy5hY7Z+4l
         Mh3cssbuJElqs2ximPM3H4ePqFuCj2emxL6dX0D+rl0eEz9TPI0PrHY/usLFZ8j6aE
         USdUIczFnMDA38mSD1LVSgjmQC1/NtkRFdVeWrsqm+a22uVG/6Fo9lNB9Nb+1hWm2k
         g8bF/mCnN/Wr2+kPL7L6JmIlsmr6jtoXv6ZIkgl9g8Iadd3ypl+IFuWwB0glJpQO9n
         RnmRrfoUpxwag==
Date:   Thu, 8 Dec 2022 08:33:55 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Yang Yingliang <yangyingliang@huawei.com>
Cc:     Leon Romanovsky <leon@kernel.org>, <netdev@vger.kernel.org>,
        <davem@davemloft.net>, <edumazet@google.com>, <pabeni@redhat.com>
Subject: Re: [PATCH net v2 1/2] net: apple: mace: don't call dev_kfree_skb()
 under spin_lock_irqsave()
Message-ID: <20221208083355.7ca2a99a@kernel.org>
In-Reply-To: <0d01feea-973a-0331-e669-bc362ba93f56@huawei.com>
References: <20221207012959.2800421-1-yangyingliang@huawei.com>
        <Y5GZJ2rBuMZoZ0e7@unreal>
        <0d01feea-973a-0331-e669-bc362ba93f56@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 8 Dec 2022 16:39:03 +0800 Yang Yingliang wrote:
> >> @@ -846,7 +846,7 @@ static void mace_tx_timeout(struct timer_list *t)
> >>       if (mp->tx_bad_runt) {
> >>   	mp->tx_bad_runt = 0;
> >>       } else if (i != mp->tx_fill) {
> >> -	dev_kfree_skb(mp->tx_bufs[i]);
> >> +	dev_consume_skb_irq(mp->tx_bufs[i]);  
> > Same question, why did you chose dev_consume_skb_irq and not dev_kfree_skb_irq?  
> I chose dev_consume_skb_irq(), because dev_kfree_skb() is consume_skb().

kfree_skb() should be used on error paths, when packet is dropped.
consume_skb() on normal paths, when packet left the system successfully.

dev_kfree* helpers probably default to consume_skb() to avoid spamming
drop monitor, but switching to dev_consume explicitly is not right.
