Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 30B2853B379
	for <lists+netdev@lfdr.de>; Thu,  2 Jun 2022 08:23:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230450AbiFBGWf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jun 2022 02:22:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230222AbiFBGW2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Jun 2022 02:22:28 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B1542871D
        for <netdev@vger.kernel.org>; Wed,  1 Jun 2022 23:22:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0667261727
        for <netdev@vger.kernel.org>; Thu,  2 Jun 2022 06:22:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBF69C385A5;
        Thu,  2 Jun 2022 06:22:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654150946;
        bh=j8BMyGAYE9Wja1pZ2m3I1XQIFMgm84RQJwGTfcAOoXI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=MkH0PUlM1sqTRBjAyHXqYPIRU93Kd0MBHP+mMXQIH+n9O7+7hlIf3RxoiJr+5M/0V
         QpM/yKAXda+LmuM6z26nX1GR4VjwEnTBBm7kGlvcktadGSEWkVLuLNO/NgAJ8UbwBd
         Lv6cCsnl41LyXhpe5Br+LzFZYwajjofqDOAGpx7RKwBtTzOuepEOGkFDrnkK/IPRju
         nV7EEKbk6m6puTKXvYKdQC7DhuFiRA10PeoOI+UH7PwnVDu86QlvhbczjCT+audGdX
         ZFXET8rGPF9XGoiEKv+NacZbcDUlFehLEdk623UTV3gG41IECFSX6YZzHNSYWy4rZx
         Gqx6s/B1aP5hg==
Date:   Thu, 2 Jun 2022 09:22:22 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Hoang Le <hoang.h.le@dektech.com.au>
Cc:     jmaloy@redhat.com, maloy@donjonn.com, ying.xue@windriver.com,
        tung.q.nguyen@dektech.com.au, kuba@kernel.org,
        netdev@vger.kernel.org, tipc-discussion@lists.sourceforge.net,
        syzbot+e820fdc8ce362f2dea51@syzkaller.appspotmail.com
Subject: Re: [net v3] tipc: check attribute length for bearer name
Message-ID: <YphXHswwVuINRsit@unreal>
References: <20220602045757.3943-1-hoang.h.le@dektech.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220602045757.3943-1-hoang.h.le@dektech.com.au>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 02, 2022 at 11:57:57AM +0700, Hoang Le wrote:
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
> v3: add Fixes tag in commit message.
> v2: remove unnecessary sanity check as Jakub's comment.

Same comment as for v2, please put changelog after --- trailer.

Thanks

> 
> Reported-by: syzbot+e820fdc8ce362f2dea51@syzkaller.appspotmail.com
> Fixes: cb30a63384bc ("tipc: refactor function tipc_enable_bearer()")
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
