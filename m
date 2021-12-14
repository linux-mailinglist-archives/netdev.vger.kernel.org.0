Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 64B72473A97
	for <lists+netdev@lfdr.de>; Tue, 14 Dec 2021 03:11:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231209AbhLNCLf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Dec 2021 21:11:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229511AbhLNCLe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Dec 2021 21:11:34 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 636B2C061574;
        Mon, 13 Dec 2021 18:11:34 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 46D6C612DC;
        Tue, 14 Dec 2021 02:11:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 690B8C34600;
        Tue, 14 Dec 2021 02:11:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1639447892;
        bh=ywX8EBMOa98jZfSDW0h+3ONlLByfYz43ou23F5UXt7g=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=YQS1GZbES3k3xgcG+lVaq0wnXEyRu+tJvtSgcR59nyNb2Ak0fhu/Clu/Xg+LiTkcW
         s8kETeYsu1R3j9uciE+p/JQ85AeSI0eWhtJ6KiXfA5DUwWd6Dzx3cO9QL0zR4cYgu5
         nWAW8vqSbFrmaXuwvejsgSakHq7TD9B6Y8fYfgzEASIiTMtpBDRz55IdjIDBdC0c3W
         mRTm/y6oBTK9GTBCKQM9z1jcUpEUWsb6Qk/3P3eoSibX6V6gIXxGoUPRvDQyJU2ot7
         wuQfLMg/7X7c4OUZWRhsstkv1j8yP3yRsQsB9O6/XbuShYMXoGcxIhuHe9M96p873C
         QYd5EgKhGMjTA==
Date:   Mon, 13 Dec 2021 18:11:31 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     George Kennedy <george.kennedy@oracle.com>
Cc:     stephen@networkplumber.org, davem@davemloft.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] tun: avoid double free in tun_free_netdev
Message-ID: <20211213181131.771581d9@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <1639415051-10245-1-git-send-email-george.kennedy@oracle.com>
References: <1639415051-10245-1-git-send-email-george.kennedy@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 13 Dec 2021 12:04:11 -0500 George Kennedy wrote:
> Avoid double free in tun_free_netdev() by checking if
> dev->reg_state is NETREG_UNREGISTERING in the tun_set_iff()
> error paths. If dev->reg_state is NETREG_UNREGISTERING that means
> the destructor will be called later.
> 
> BUG: KASAN: double-free or invalid-free in selinux_tun_dev_free_security+0x1a/0x20 security/selinux/hooks.c:5605

> 
> Reported-by: syzkaller <syzkaller@googlegroups.com>
> Signed-off-by: George Kennedy <george.kennedy@oracle.com>
> ---
> Jakub, decided to go the less code churn route and just
> check for dev->reg_state is NETREG_UNREGISTERING.

I don't think this is correct. E.g. if NETDEV_POST_INIT notifier 
fails the destructor will already have been called and reg_state 
will be NETREG_UNINITIALIZED which is != NETREG_UNREGISTERING.

What I had in mind is replacing if (!dev->tstats) goto .. with 
if (reg_state == NETREG_UNREGISTERING) goto ..

But as proven partial destruction on failure of register_netdevice() is
extra tricky, I believe moving the code into ndo_init would be less
error-prone even if higher LoC delta. Unless there's some trickery in
the code move as well, I haven't investigated.
