Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9D4B359EFC6
	for <lists+netdev@lfdr.de>; Wed, 24 Aug 2022 01:40:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232007AbiHWXjf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Aug 2022 19:39:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229445AbiHWXjd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Aug 2022 19:39:33 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E444C89CFA
        for <netdev@vger.kernel.org>; Tue, 23 Aug 2022 16:39:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7F0DD616BE
        for <netdev@vger.kernel.org>; Tue, 23 Aug 2022 23:39:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8807C433D6;
        Tue, 23 Aug 2022 23:39:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661297971;
        bh=1GZOnSVNyb2xRN1ldhJ5eq2dsXlLoocROv6iRlgcKa4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=VP6dohBa05h57O/QlO1PgdHvaf4MJnKWC+iL0AwsIpSGnPMyFt9pav5yJnxvYdIUf
         ihPWhebL0+rkUpCdYoLk/UJUlR6MBIcDsecEhOSLp8SbbyathfovDivsAul1OUfasP
         OyTjIfF8dUiq0MBpFt0LKUrorBtyhL70/yYZ4ST9GZ/KNGI++/Coi4wFI5cxS1hJnA
         Me9iqOqWeDi2HSo9NDZnH7zIUFvqdC3HoYpHw2351ziDnqJ6TzHosHDDGhAaMYL53D
         TiIHyKsyZ3Yt5Gm/QhcH/AYVXeDQNK+Capw294kpXy9yhY4Ee+xpKiibwJVAF/Jz7B
         BVrnRCiBmNcAw==
Date:   Tue, 23 Aug 2022 16:39:30 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Cong Wang <xiyou.wangcong@gmail.com>
Cc:     netdev@vger.kernel.org, Cong Wang <cong.wang@bytedance.com>,
        syzbot+9fc084a4348493ef65d2@syzkaller.appspotmail.com,
        syzbot+e696806ef96cdd2d87cd@syzkaller.appspotmail.com,
        Tom Herbert <tom@herbertland.com>
Subject: Re: [Patch net] kcm: get rid of unnecessary cleanup
Message-ID: <20220823163930.033b1330@kernel.org>
In-Reply-To: <20220822040628.177649-1-xiyou.wangcong@gmail.com>
References: <20220822040628.177649-1-xiyou.wangcong@gmail.com>
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

On Sun, 21 Aug 2022 21:06:28 -0700 Cong Wang wrote:
> From: Cong Wang <cong.wang@bytedance.com>
> 
> strp_init() is called just a few lines above this csk->sk_user_data
> check, it also initializes strp->work etc., therefore, it is
> unnecessary to call strp_done() to cancel the freshly initialized
> work.
> 
> This also makes a lockdep warning reported by syzbot go away.
> 
> Reported-and-tested-by: syzbot+9fc084a4348493ef65d2@syzkaller.appspotmail.com
> Reported-by: syzbot+e696806ef96cdd2d87cd@syzkaller.appspotmail.com
> Fixes: e5571240236c ("kcm: Check if sk_user_data already set in kcm_attach")
> Fixes: dff8baa26117 ("kcm: Call strp_stop before strp_done in kcm_attach")
> Cc: Jakub Kicinski <kuba@kernel.org>
> Cc: Tom Herbert <tom@herbertland.com>
> Signed-off-by: Cong Wang <cong.wang@bytedance.com>
> ---
>  net/kcm/kcmsock.c | 2 --
>  1 file changed, 2 deletions(-)
> 
> diff --git a/net/kcm/kcmsock.c b/net/kcm/kcmsock.c
> index 71899e5a5a11..661c40cdab3e 100644
> --- a/net/kcm/kcmsock.c
> +++ b/net/kcm/kcmsock.c
> @@ -1425,8 +1425,6 @@ static int kcm_attach(struct socket *sock, struct socket *csock,
>  	 */
>  	if (csk->sk_user_data) {
>  		write_unlock_bh(&csk->sk_callback_lock);
> -		strp_stop(&psock->strp);
> -		strp_done(&psock->strp);
>  		kmem_cache_free(kcm_psockp, psock);
>  		err = -EALREADY;
>  		goto out;

Looks correct, but if strp_init() ever grows code which needs 
to be unwound in strp_done() we'd risk a leak. This seems to
have been Tom's intent.

Could we perhaps reorder the sk_user_data check vs the strp_init() call?
sock_map already calls strp_init() under the callback lock so we'd not
be introducing any new lock ordering.
