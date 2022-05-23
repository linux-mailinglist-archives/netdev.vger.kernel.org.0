Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9481E5312ED
	for <lists+netdev@lfdr.de>; Mon, 23 May 2022 18:23:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236354AbiEWNlq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 May 2022 09:41:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236355AbiEWNlp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 May 2022 09:41:45 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 197331BEB4;
        Mon, 23 May 2022 06:41:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A9617B810FD;
        Mon, 23 May 2022 13:41:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 904A7C385AA;
        Mon, 23 May 2022 13:41:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1653313301;
        bh=OMpkXxkn2R6SfejQJFfS7rUtkmYzMV9IbIwdJiT8sz0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=YDfLAXN8c63oR9BIbgEAQ8nsFOym7bY9PY8tA5stVO8pa1Nhc6ic1PsOWQFBRhfTl
         nLkAgHOg73D4TaM0wv6PvjeJd20IVupNSHgp3OwMtt8/L93aECpk7dEY067M2qLX4O
         NMmFUxfm47fh3CvWEEm9u9ajpU9uQOttkqjelWYY=
Date:   Mon, 23 May 2022 15:41:37 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Kalle Valo <kvalo@kernel.org>
Cc:     duoming@zju.edu.cn, linux-wireless@vger.kernel.org,
        amitkarwar@gmail.com, ganapathi017@gmail.com,
        sharvari.harisangam@nxp.com, huxinming820@gmail.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, rafael@kernel.org,
        Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH v3] mwifiex: fix sleep in atomic context bugs caused by
 dev_coredumpv
Message-ID: <YouPEdlNbU2ea1Cx@kroah.com>
References: <20220523052810.24767-1-duoming@zju.edu.cn>
 <YosqUjCYioGh3kBW@kroah.com>
 <41a266af.2abb6.180efa8594d.Coremail.duoming@zju.edu.cn>
 <87r14kzdqz.fsf@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87r14kzdqz.fsf@kernel.org>
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 23, 2022 at 02:31:48PM +0300, Kalle Valo wrote:
> (adding Johannes)
> 
> duoming@zju.edu.cn writes:
> 
> >> > --- a/lib/kobject.c
> >> > +++ b/lib/kobject.c
> >> > @@ -254,7 +254,7 @@ int kobject_set_name_vargs(struct kobject *kobj, const char *fmt,
> >> >  	if (kobj->name && !fmt)
> >> >  		return 0;
> >> >  
> >> > -	s = kvasprintf_const(GFP_KERNEL, fmt, vargs);
> >> > +	s = kvasprintf_const(GFP_ATOMIC, fmt, vargs);
> >> >  	if (!s)
> >> >  		return -ENOMEM;
> >> >  
> >> > @@ -267,7 +267,7 @@ int kobject_set_name_vargs(struct kobject *kobj, const char *fmt,
> >> >  	if (strchr(s, '/')) {
> >> >  		char *t;
> >> >  
> >> > -		t = kstrdup(s, GFP_KERNEL);
> >> > +		t = kstrdup(s, GFP_ATOMIC);
> >> >  		kfree_const(s);
> >> >  		if (!t)
> >> >  			return -ENOMEM;
> >> 
> >> Please no, you are hurting the whole kernel because of one odd user.
> >> Please do not make these calls under atomic context.
> >
> > Thanks for your time and suggestions. I will remove the gfp_t
> > parameter of dev_coredumpv in order to show it could not be used in
> > atomic context.
> 
> In a way it would be nice to be able to call dev_coredump from atomic
> contexts, though I don't know how practical it actually is.

Dumping core information from atomic context feels very very wrong to
me.

Why not just not do that?

> Is there any other option? What about adding a gfp_t parameter to
> dev_set_name()? Or is there an alternative for dev_set_name() which
> can be called in atomic contexts?

dev_set_name() should not be called in atomic context as that implies
you are doing a very slow operation with locks disabled, not a good
thing at all.

thanks,

greg k-h
