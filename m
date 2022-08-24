Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EBDA95A043F
	for <lists+netdev@lfdr.de>; Thu, 25 Aug 2022 00:46:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230304AbiHXWqk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Aug 2022 18:46:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230246AbiHXWqj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Aug 2022 18:46:39 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9F0961706
        for <netdev@vger.kernel.org>; Wed, 24 Aug 2022 15:46:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6416A6196E
        for <netdev@vger.kernel.org>; Wed, 24 Aug 2022 22:46:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8BB98C433C1;
        Wed, 24 Aug 2022 22:46:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661381197;
        bh=F1PLaiGzaTJ9HDb+FNa4oscf6jSALM0pUAfR7jKqbos=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ZWE67tI+AjghPKBMIdEHXnKoksqhDD4v9dovPtdQsYTE/qzhTupwL5NwUkVWInTkv
         Y/IoyRa314zDse2nEB7VPeeYQDwu2jS8y/Ut8tKe9xxWLnmIgt0X3T4X0gr7Ugz7OI
         oB2opqVW8Yjjy8m9XkdxIqj/4kp27sP555azQUB4sFjJ7sCWWBlbmezYQnZNU/6l3A
         NuYlfnDISkuKVJvX9DdvKQrXlrQvBF2X8rUDAITwzSqNmT5b0UWz7XNpE+ui1wCE7S
         eg/OSR5Y23bT05HABMh/ZOGOf3dHtmhLtDN8nOhJ+B85xV/dN8Ja/P628Avgrtr6ym
         HqWcwDTwOKzlg==
Date:   Wed, 24 Aug 2022 15:46:36 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
        pabeni@redhat.com, mkubecek@suse.cz
Subject: Re: [PATCH net-next 3/6] genetlink: add helper for checking
 required attrs and use it in devlink
Message-ID: <20220824154636.2368afb3@kernel.org>
In-Reply-To: <e652424b85218d370a9bbf922cf09f8b21b26822.camel@sipsolutions.net>
References: <20220824045024.1107161-1-kuba@kernel.org>
        <20220824045024.1107161-4-kuba@kernel.org>
        <e652424b85218d370a9bbf922cf09f8b21b26822.camel@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 24 Aug 2022 21:44:22 +0200 Johannes Berg wrote:
> On Tue, 2022-08-23 at 21:50 -0700, Jakub Kicinski wrote:
> > 
> > +/* Report that a root attribute is missing */
> > +#define GENL_REQ_ATTR_CHECK(info, attr) ({				\
> > +	struct genl_info *__info = (info);				\
> > +	u32 __attr = (attr);						\
> > +	int __retval;							\
> > +									\
> > +	__retval = !__info->attrs[__attr];				\
> > +	if (__retval)							\
> > +		NL_SET_ERR_ATTR_MISS(__info->extack,			\
> > +				     __info->userhdr ? : __info->genlhdr, \
> > +				     __attr);				\
> > +	__retval;							\
> > +})  
> 
> Not sure this needs to be a macro btw, could be an inline returning a
> bool? You're not really expanding anything here, nor doing something
> with strings (unlike GENL_SET_ERR_MSG for example.)

Initially I typed up both flavors with and without the message 
but I dropped the _MSG() one since I didn't find a strong enough 
reason to use it.

If we do get the _MSG() version at some point (perhaps to preserve 
an existing message during conversion?) having different case
would seem off.

I have no opinion which way is better, LMK if you prefer lower case
(ignoring existing non-MSG helpers being upper case) and I'll sed thru
the patches, no problem at all.
