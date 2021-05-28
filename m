Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6396139478B
	for <lists+netdev@lfdr.de>; Fri, 28 May 2021 21:44:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229500AbhE1Tp6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 May 2021 15:45:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:36112 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229476AbhE1Tp5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 28 May 2021 15:45:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 53DB261358;
        Fri, 28 May 2021 19:44:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622231062;
        bh=AhwGjIPN1NYNNepR4E6SKy/8tv+XfULKUlR7rNUETVY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=JPXPkAPhuFTRoNRK657jMqw99uHUepnkCUbesWgB3WfyCUW3PBTaPZpDNJszma5pQ
         DXt5w5G9tds7AaF/zrtAX1AkDLywyrKP9sZgehiuu8nVOebk1nnVauMvLhtANjYgg/
         BJ6KRnlIAEjMNRf59rKJF4aM7mXyFxvBbdeT2lvHFozxB+SRv34QA7V8dJTys6fjvi
         hIRB8dI0gjQDSJaReLv3RTsTHtPYGTcV2gHcRNVPq0IlcG2WpboosDdyrZ5PqKT1AB
         DxDNzJYkjT011b42ke2X9UoOzP5mAjahHdHba47YARkwnfD1XaEN3Z1NQJVaFEWDVi
         XSOxSkySRJgWA==
Date:   Fri, 28 May 2021 12:44:21 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Maxim Mikityanskiy <maximmi@nvidia.com>
Cc:     Boris Pismenny <borisp@nvidia.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S. Miller" <davem@davemloft.net>,
        Aviad Yehezkel <aviadye@nvidia.com>,
        "Tariq Toukan" <tariqt@nvidia.com>, <netdev@vger.kernel.org>
Subject: Re: [PATCH net 2/2] net/tls: Fix use-after-free after the TLS
 device goes down and up
Message-ID: <20210528124421.12a84cb7@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <afa246d3-acfd-f3be-445c-3beace105c8f@nvidia.com>
References: <20210524121220.1577321-1-maximmi@nvidia.com>
        <20210524121220.1577321-3-maximmi@nvidia.com>
        <20210525103915.05264e8c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <afa246d3-acfd-f3be-445c-3beace105c8f@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 28 May 2021 15:40:38 +0300 Maxim Mikityanskiy wrote:
> >> @@ -961,6 +964,17 @@ int tls_device_decrypted(struct sock *sk, struct tls_context *tls_ctx,
> >>   
> >>   	ctx->sw.decrypted |= is_decrypted;
> >>   
> >> +	if (unlikely(test_bit(TLS_RX_DEV_DEGRADED, &tls_ctx->flags))) {  
> > 
> > Why not put the check in tls_device_core_ctrl_rx_resync()?
> > Would be less code, right?  
> 
> I see what you mean, and I considered this option, but I think my option 
> has better readability and is more future-proof. By doing an early 
> return, I skip all code irrelevant to the degraded mode, and even though 
> changing ctx->resync_nh_reset won't have effect in the degraded mode, it 
> will be easier for readers to understand that this part of code is not 
> relevant. Furthermore, if someone decides to add more code to 
> !is_encrypted branches in the future, there is a chance that the 
> degraded mode will be missed from consideration. With the early return 
> there is not problem, but if I follow your suggestion and do the check 
> only under is_encrypted, a future contributor unfamiliar with this 
> "degraded flow" might fail to add that check where it will be needed.
> 
> This was the reason I implemented it this way. What do you think?

In general "someone may miss this in the future" is better served by
adding a test case than code duplication. But we don't have infra to 
fake-offload TLS so I don't feel strongly. You can keep as is if that's
your preference.
