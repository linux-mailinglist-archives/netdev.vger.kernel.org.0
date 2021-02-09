Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 68ABA3146A6
	for <lists+netdev@lfdr.de>; Tue,  9 Feb 2021 03:54:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229891AbhBICyI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Feb 2021 21:54:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:36226 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229692AbhBICyG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 8 Feb 2021 21:54:06 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id CB6CC64E0B;
        Tue,  9 Feb 2021 02:53:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612839205;
        bh=LA/z27QeigL5ShSYaItMvx2FJE2OnzHBzoj/AOnYgjE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=R1Wnyoi5WLviJZOfbi18b1bWtWaOFP33jMqKHbGwx2SrI5uSevvXJNdaxZFcSi1od
         IU6OtKsX+sWAoq4sD7QcZ2+OAsFw4Zmu8pm/wQL8cCk4uJwiH9dDh3+8pomFmboDWn
         SuwaMiOM3aCeN0b9h22tmOOcx9rfgQJIrxNfTpBlz4cwtOvt+IgtaqOJe8UkrohpE0
         q5dQjdngw+RlYqbpjiZ4dhu8rpU0FHW3eMoNaPr+UPDCd13HiUpTxkHJjsaFEmsdOg
         bW6z18QusfGZZMWkwFi5oWd8SHnuER9t0zrfNiaWyZBeOTrJb5BWm9vrFrZO2tuPF2
         A0C55kq2VLzlg==
Date:   Mon, 8 Feb 2021 18:53:23 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     David Ahern <dsahern@gmail.com>
Cc:     Leon Romanovsky <leon@kernel.org>,
        Arjun Roy <arjunroy.kdev@gmail.com>, davem@davemloft.net,
        netdev@vger.kernel.org, arjunroy@google.com, edumazet@google.com,
        soheil@google.com
Subject: Re: [net-next v2] tcp: Explicitly mark reserved field in
 tcp_zerocopy_receive args.
Message-ID: <20210208185323.11c2bacf@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <09fa284e-ea02-a6ca-cd8f-6d90dff2fa00@gmail.com>
References: <20210206203648.609650-1-arjunroy.kdev@gmail.com>
        <20210206152828.6610da2b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <20210207082654.GC4656@unreal>
        <20210208104143.60a6d730@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <09fa284e-ea02-a6ca-cd8f-6d90dff2fa00@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 8 Feb 2021 19:24:05 -0700 David Ahern wrote:
> On 2/8/21 11:41 AM, Jakub Kicinski wrote:
> > On Sun, 7 Feb 2021 10:26:54 +0200 Leon Romanovsky wrote:  
> >> There is a check that len is not larger than zs and users can't give
> >> large buffer.
> >>
> >> I would say that is pretty safe to write "if (zc.reserved)".  
> > 
> > Which check? There's a check which truncates (writes back to user space
> > len = min(len, sizeof(zc)). Application can still pass garbage beyond
> > sizeof(zc) and syscall may start failing in the future if sizeof(zc)
> > changes.
> 
> That would be the case for new userspace on old kernel. Extending the
> check to the end of the struct would guarantee new userspace can not ask
> for something that the running kernel does not understand.

Indeed, so we're agreeing that check_zeroed_user() is needed before
original optlen from user space gets truncated?
