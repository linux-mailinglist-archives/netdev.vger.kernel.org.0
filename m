Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 252BD46CD61
	for <lists+netdev@lfdr.de>; Wed,  8 Dec 2021 06:49:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236230AbhLHFwk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Dec 2021 00:52:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235019AbhLHFwj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Dec 2021 00:52:39 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 683ACC061574
        for <netdev@vger.kernel.org>; Tue,  7 Dec 2021 21:49:08 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id B1DA6CE1FE7
        for <netdev@vger.kernel.org>; Wed,  8 Dec 2021 05:49:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2445C341CA;
        Wed,  8 Dec 2021 05:49:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638942544;
        bh=Dq8KQ7rK1zuJhXdskfqJIGg9ka0fpuWqxFIbnv7gPWU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=C82bxN54zOO1Bd6SG65zfxMpwXICQiVcTjhHKBzBBksn8npLoJMM99BoJ7KBM4jyH
         BiltbmvkfKbqubHZ6BlU6Fp3r6s/5okV0+xCMWP1UTT+uHoNz4WrvZnGx9UsXoM2PX
         tRWE+WAFf6JaHfBSDaQjJucvCdHoCtBuLgfurCAH/apjoKFlZ8nujdPT75JxTRNeK5
         csXBvlJbHSvZ+zFvH0xy4qNY1ppSCP4okxLk8B/3jpTaR8oQYDFDEeJlccBDhh1Dm6
         aLafB+rVuigbW0SmIRl4hyoneUxRwzO1w1qY+ZYEgt+yeMiOROQEUTV93xr1aFGWDg
         X3EytA6BRsmtg==
Date:   Tue, 7 Dec 2021 21:49:03 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     <netdev@vger.kernel.org>
Cc:     Joanne Koong <joannekoong@fb.com>, <davem@davemloft.net>,
        <kafai@fb.com>, <Kernel-team@fb.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [PATCH net-next] net: Enable unix sysctls to be configurable by
 non-init user namespaces
Message-ID: <20211207214903.7a900743@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20211207202101.2457994-1-joannekoong@fb.com>
References: <20211207202101.2457994-1-joannekoong@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

CC: Eric B

On Tue, 7 Dec 2021 12:21:01 -0800 Joanne Koong wrote:
> Currently, when a networking namespace is initialized, its unix sysctls
> are exposed only if the user namespace that "owns" it is the init user
> namespace.
> 
> If there is a non-init user namespace that "owns" a networking
> namespace (for example, in the case after we call clone() with both
> CLONE_NEWUSER and CLONE_NEWNET set), the sysctls are hidden from view
> and not configurable.
> 
> This patch enables the unix networking sysctls (there is currently only
> 1, "sysctl_max_dgram_qlen", which is used as the default
> "sk_max_ack_backlog" value when a unix socket is created) to be exposed
> to non-init user namespaces.
> 
> This is safe because any changes made to these sysctls will be limited
> in scope to the networking namespace the non-init user namespace "owns"
> and has privileges over.
> 
> Signed-off-by: Joanne Koong <joannekoong@fb.com>
> ---
>  net/unix/sysctl_net_unix.c | 4 ----
>  1 file changed, 4 deletions(-)
> 
> diff --git a/net/unix/sysctl_net_unix.c b/net/unix/sysctl_net_unix.c
> index c09bea89151b..01d44e2598e2 100644
> --- a/net/unix/sysctl_net_unix.c
> +++ b/net/unix/sysctl_net_unix.c
> @@ -30,10 +30,6 @@ int __net_init unix_sysctl_register(struct net *net)
>  	if (table == NULL)
>  		goto err_alloc;
>  
> -	/* Don't export sysctls to unprivileged users */
> -	if (net->user_ns != &init_user_ns)
> -		table[0].procname = NULL;
> -
>  	table[0].data = &net->unx.sysctl_max_dgram_qlen;
>  	net->unx.ctl = register_net_sysctl(net, "net/unix", table);
>  	if (net->unx.ctl == NULL)

