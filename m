Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2009031548B
	for <lists+netdev@lfdr.de>; Tue,  9 Feb 2021 18:01:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232805AbhBIRAW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Feb 2021 12:00:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:50394 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232605AbhBIRAV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 9 Feb 2021 12:00:21 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B107464E9D;
        Tue,  9 Feb 2021 16:59:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612889980;
        bh=/1A3L1eghaXwXpnRebjOxvneVfvPd1Pf8hw8BSyiYeQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=jlThc8EKSiBm29IH/+ahFuRrsXjISMXU2z0+ZXYX/E7Mce7sy8jho3zXeoDcyPwBV
         dQNghC6L1RIdOww2Bb8R/bT6rjashjVAL5RNrqPzXaT3+rmw12EdOyGgvm0GRKCvoL
         RIQvsg80VV1ClgrrI5puwRBPhdJmeUzpj4KUobuBTupMJlS4EkV628uxXjP9DpYObp
         M4CMXj3FvXpttCtOlQ1erZZje+LONQu7SFwflzcDuFrD+vV7XspSm9Gv1Dn6QEFYrm
         Ts0xgdWWcYcu3dGtMOhvfiSd2s+KMc/z2TQy6yXML34pDgEYAEyhvgkAIqRdIDtaXo
         BymKSAydU//pA==
Date:   Tue, 9 Feb 2021 08:59:38 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     Arjun Roy <arjunroy.kdev@gmail.com>, davem@davemloft.net,
        netdev@vger.kernel.org, arjunroy@google.com, edumazet@google.com,
        soheil@google.com, David Ahern <dsahern@gmail.com>
Subject: Re: [net-next v2] tcp: Explicitly mark reserved field in
 tcp_zerocopy_receive args.
Message-ID: <20210209085938.579f3187@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210209061511.GI20265@unreal>
References: <20210206203648.609650-1-arjunroy.kdev@gmail.com>
        <20210206152828.6610da2b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <20210207082654.GC4656@unreal>
        <20210208104143.60a6d730@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <20210209061511.GI20265@unreal>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 9 Feb 2021 08:15:11 +0200 Leon Romanovsky wrote:
> At least in my tree, we have the length check:
>   4155                 if (len > sizeof(zc)) {
>   4156                         len = sizeof(zc);
>   4157                         if (put_user(len, optlen))
>   4158                                 return -EFAULT;
>   4159                 }
> 
> 
> Ad David wrote below, the "if (zc.reserved)" is enough.
> 
> We have following options:
> 1. Old kernel that have sizeof(sz) upto .reserved and old userspace
> -> len <= sizeof(sz) - works correctly.  
> 2. Old kernel that have sizeof(sz) upto .reserved and new userspace that
> sends larger struct -> "f (len > sizeof(zc))" will return -EFAULT

Based on the code you quoted? I don't see how. Maybe I need a vacation.
put_user() just copies len back to user space after truncation.

> 3. New kernel that have sizeof(sz) beyond reserved and old userspace
> -> any new added field to struct sz should be checked and anyway it is the same as item 1.  
> 4. New kernel and new userspace
> -> standard flow.  
