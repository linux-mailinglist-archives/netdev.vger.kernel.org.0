Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DAD366DF9E5
	for <lists+netdev@lfdr.de>; Wed, 12 Apr 2023 17:25:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229939AbjDLPZy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Apr 2023 11:25:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229814AbjDLPZx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Apr 2023 11:25:53 -0400
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24DF219A8;
        Wed, 12 Apr 2023 08:25:52 -0700 (PDT)
Received: by verein.lst.de (Postfix, from userid 2407)
        id C796A68AA6; Wed, 12 Apr 2023 17:25:48 +0200 (CEST)
Date:   Wed, 12 Apr 2023 17:25:48 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Kevin Brodsky <kevin.brodsky@arm.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Christoph Hellwig <hch@lst.de>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH] net: Finish up ->msg_control{,_user} split
Message-ID: <20230412152548.GA26786@lst.de>
References: <20230411122625.3902339-1-kevin.brodsky@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230411122625.3902339-1-kevin.brodsky@arm.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 11, 2023 at 01:26:25PM +0100, Kevin Brodsky wrote:
> This patch is attempting to complete the split. Most issues are about
> msg_control being used when in fact a user pointer is stored in the
> union; msg_control_user is now used instead. An exception is made
> for null checks, as it should be safe to use msg_control
> unconditionally for that purpose.

So all of the fixes looks good to me.

> Additionally, a special situation in
> cmsghdr_from_user_compat_to_kern() is addressed. There the input
> struct msghdr holds a user pointer (msg_control_user), but a kernel
> pointer is stored in msg_control when returning. msg_control_is_user
> is now updated accordingly.

But this is a small isolated real bugfix.  So I'd suggest to split
this into a simple and easily backportable patch, and do the rest
in another.

> diff --git a/net/ipv6/ipv6_sockglue.c b/net/ipv6/ipv6_sockglue.c
> index 2917dd8d198c..ae818ff46224 100644
> --- a/net/ipv6/ipv6_sockglue.c
> +++ b/net/ipv6/ipv6_sockglue.c
> @@ -716,6 +716,7 @@ int do_ipv6_setsockopt(struct sock *sk, int level, int optname,
>  			goto done;
>  
>  		msg.msg_controllen = optlen;
> +		msg.msg_control_is_user = false;

And this is another one that has a real effect.
