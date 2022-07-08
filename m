Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 83C5F56C0D6
	for <lists+netdev@lfdr.de>; Fri,  8 Jul 2022 20:37:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238963AbiGHSSK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Jul 2022 14:18:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238842AbiGHSSI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Jul 2022 14:18:08 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DDB4A81481;
        Fri,  8 Jul 2022 11:18:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 804FA624E8;
        Fri,  8 Jul 2022 18:18:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8AB81C341C0;
        Fri,  8 Jul 2022 18:18:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657304286;
        bh=n3wgaJngrgCkL8bcS0N4AajDmxSzJKFmSoMI2iWiD18=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=fS9A+VWYe//i/KBEloHTL05PVW2tW+wyYkImDACVKT/HP6IV0qE2TuTwVgxc3h1Zb
         A8XLcdCSvE3uNvvqq6Oh9oc8lYB8HOGXG4BNfLU7U9BZ2vMqtywsFbkKhmQrFL3tOL
         xSOfFhReBSJpSK5Gep3tJLnw2Qch2OtgVqDXYYR2gcdnOAF8bSvBIfZ0n7huNpBeoL
         VGU7sqsyvIjU7x9h0Z4t5HZorxug/mIgmYfnQbb4uwCcNkwV47lAbIVe4i+2SjPuXm
         APdYep+xIacGaBl6p0fA5zx19/o27meNSqsR0MiKN/TxXW+b4nTTgiXaHdGveq4bPN
         y8jrZOf/xd7cg==
Date:   Fri, 8 Jul 2022 11:18:05 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Maxim Mikityanskiy <maximmi@nvidia.com>
Cc:     "davem@davemloft.net" <davem@davemloft.net>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kselftest@vger.kernel.org" <linux-kselftest@vger.kernel.org>,
        "edumazet@google.com" <edumazet@google.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "john.fastabend@gmail.com" <john.fastabend@gmail.com>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        Boris Pismenny <borisp@nvidia.com>
Subject: Re: [PATCH net-next 3/5] tls: rx: add sockopt for enabling
 optimistic decrypt with TLS 1.3
Message-ID: <20220708111805.5282cb3d@kernel.org>
In-Reply-To: <b111828e6ac34baad9f4e783127eba8344ac252d.camel@nvidia.com>
References: <20220705235926.1035407-1-kuba@kernel.org>
        <20220705235926.1035407-4-kuba@kernel.org>
        <b111828e6ac34baad9f4e783127eba8344ac252d.camel@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 8 Jul 2022 14:14:44 +0000 Maxim Mikityanskiy wrote:
> On Tue, 2022-07-05 at 16:59 -0700, Jakub Kicinski wrote:
> > +static int do_tls_getsockopt_no_pad(struct sock *sk, char __user *optval,
> > +				    int __user *optlen)
> > +{
> > +	struct tls_context *ctx = tls_get_ctx(sk);
> > +	unsigned int value;
> > +	int err, len;
> > +
> > +	if (ctx->prot_info.version != TLS_1_3_VERSION)
> > +		return -EINVAL;
> > +
> > +	if (get_user(len, optlen))
> > +		return -EFAULT;
> > +	if (len < sizeof(value))
> > +		return -EINVAL;
> > +
> > +	lock_sock(sk);
> > +	err = -EINVAL;
> > +	if (ctx->rx_conf == TLS_SW || ctx->rx_conf == TLS_HW)
> > +		value = ctx->rx_no_pad;
> > +	release_sock(sk);
> > +	if (err)
> > +		return err;  
> 
> Bug: always returns -EINVAL here, because it's assigned a few lines
> above unconditionally.

Ah, thanks. Let me add a self-test while at it.

> > diff --git a/net/tls/tls_sw.c b/net/tls/tls_sw.c
> > index 2bac57684429..7592b6519953 100644
> > --- a/net/tls/tls_sw.c
> > +++ b/net/tls/tls_sw.c
> > @@ -1601,6 +1601,7 @@ static int decrypt_skb_update(struct sock *sk, struct sk_buff *skb,
> >  	if (unlikely(darg->zc && prot->version == TLS_1_3_VERSION &&
> >  		     darg->tail != TLS_RECORD_TYPE_DATA)) {
> >  		darg->zc = false;
> > +		TLS_INC_STATS(sock_net(sk), LINUX_MIN_TLSDECRYPTRETRY);
> >  		return decrypt_skb_update(sk, skb, dest, darg);
> >  	}  
> 
> I recall you planned to have two counters:
> 
> > You have a point about the more specific counter, let me add a
> > counter for NoPad being violated (tail == 0) as well as the overall
> > "decryption happened twice" counter.  
> 
> Did you decide to stick with one?

I was going back and forth on whether it's "worth the memory" because 
I was considering breaking the counters out per socket. At least that's
what I recall, it was like 3 rewrites ago, getting rid of strparser was
tricky. But I never made the stats per sock so let me add it. Also I
think s/MIN/MIB/ in the name of the retry?

Thanks for the review!
