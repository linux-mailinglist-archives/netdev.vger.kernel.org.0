Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6691353B374
	for <lists+netdev@lfdr.de>; Thu,  2 Jun 2022 08:23:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230388AbiFBGVd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jun 2022 02:21:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229457AbiFBGVb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Jun 2022 02:21:31 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8869C2AD5FB
        for <netdev@vger.kernel.org>; Wed,  1 Jun 2022 23:21:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0CC0461737
        for <netdev@vger.kernel.org>; Thu,  2 Jun 2022 06:21:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1EBFC3411C;
        Thu,  2 Jun 2022 06:21:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654150889;
        bh=rqYX9Mgj7/6uYHJNkpYIAN5vR/slOsdY1uwFjY0mzB8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=FKkCxQ2mTg86jJ0KIREYhuvH+BnazzzJ1S9KPTFR9PjxC2iPZBWG5Qm3VCI09mA4Q
         cW4PRAil7JsoNJ+7wg4Z4oVk9CyXVFqFvMwAzccU83tEFMpM8i45fSuWw7ztyAfB3e
         IG47ZEqOt67apByF3p8Q7RnXsuhWF8PsnGXE32qzBmcQxqwANm6s3+CqIpdRQ4x55B
         GClaLF/keyUsc/gv8QtDvIc3JhN7KFxHzzwA/uvF+XcsWr9NpRdRRhufGLUcf8D+88
         ECQ/TcS84vD+q68yPYZkiIk/bmVfgVnPiuKH8Kborz9kd+A+Ki5LGzUhkqQvtPkJSQ
         4phOJ11xYfvTA==
Date:   Thu, 2 Jun 2022 09:21:24 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Hoang Le <hoang.h.le@dektech.com.au>
Cc:     jmaloy@redhat.com, maloy@donjonn.com, ying.xue@windriver.com,
        tung.q.nguyen@dektech.com.au, kuba@kernel.org,
        netdev@vger.kernel.org, tipc-discussion@lists.sourceforge.net,
        syzbot+e820fdc8ce362f2dea51@syzkaller.appspotmail.com
Subject: Re: [net v2] tipc: check attribute length for bearer name
Message-ID: <YphW5LU6zYpEX73+@unreal>
References: <20220602012313.4255-1-hoang.h.le@dektech.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220602012313.4255-1-hoang.h.le@dektech.com.au>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 02, 2022 at 08:23:13AM +0700, Hoang Le wrote:
> syzbot reported uninit-value:
> =====================================================
> BUG: KMSAN: uninit-value in string_nocheck lib/vsprintf.c:644 [inline]
> BUG: KMSAN: uninit-value in string+0x4f9/0x6f0 lib/vsprintf.c:725
>  string_nocheck lib/vsprintf.c:644 [inline]
>  string+0x4f9/0x6f0 lib/vsprintf.c:725
>  vsnprintf+0x2222/0x3650 lib/vsprintf.c:2806
>  vprintk_store+0x537/0x2150 kernel/printk/printk.c:2158
>  vprintk_emit+0x28b/0xab0 kernel/printk/printk.c:2256
>  vprintk_default+0x86/0xa0 kernel/printk/printk.c:2283
>  vprintk+0x15f/0x180 kernel/printk/printk_safe.c:50
>  _printk+0x18d/0x1cf kernel/printk/printk.c:2293
>  tipc_enable_bearer net/tipc/bearer.c:371 [inline]
>  __tipc_nl_bearer_enable+0x2022/0x22a0 net/tipc/bearer.c:1033
>  tipc_nl_bearer_enable+0x6c/0xb0 net/tipc/bearer.c:1042
>  genl_family_rcv_msg_doit net/netlink/genetlink.c:731 [inline]
> 
> - Do sanity check the attribute length for TIPC_NLA_BEARER_NAME.
> - Do not use 'illegal name' in printing message.
> 
> v2: remove unnecessary sanity check as Jakub's comment

Please put changelog under --- trailer, it doesn't belong to commit
message.

Thanks

> 
> Reported-by: syzbot+e820fdc8ce362f2dea51@syzkaller.appspotmail.com
> Acked-by: Jon Maloy <jmaloy@redhat.com>
> Signed-off-by: Hoang Le <hoang.h.le@dektech.com.au>
> ---
>  net/tipc/bearer.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/net/tipc/bearer.c b/net/tipc/bearer.c
> index 6d39ca05f249..932c87b98eca 100644
> --- a/net/tipc/bearer.c
> +++ b/net/tipc/bearer.c
> @@ -259,9 +259,8 @@ static int tipc_enable_bearer(struct net *net, const char *name,
>  	u32 i;
>  
>  	if (!bearer_name_validate(name, &b_names)) {
> -		errstr = "illegal name";
>  		NL_SET_ERR_MSG(extack, "Illegal name");
> -		goto rejected;
> +		return res;
>  	}
>  
>  	if (prio > TIPC_MAX_LINK_PRI && prio != TIPC_MEDIA_LINK_PRI) {
> -- 
> 2.30.2
> 
