Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 304D9453428
	for <lists+netdev@lfdr.de>; Tue, 16 Nov 2021 15:28:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237338AbhKPOaf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Nov 2021 09:30:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:42562 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237311AbhKPOaa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 16 Nov 2021 09:30:30 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 57CE461407;
        Tue, 16 Nov 2021 14:27:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637072853;
        bh=1miKUwPYKBn0ByKqlOhMTqwAqtpkh6jnrbN1CsIZa48=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=jmUTk9buppxu+bNJ7JJju6SCg1bYp2bRWHMxmnMeWkZJbdUVaZoASqF1UfhglcAqy
         E6Kz7yRRZKWW3wju6XRARFtRRoC6WK3feXsIAPiZi6PxLiDaqt9ptrlV6W4CWf6Iq2
         BIWnB3jiIBVSTFOfPFLBLnExZUqqhiAiOO7tTRGwScIW2D9oTrYXdbyrQ4miASt7HD
         BcBsLyTt+KpAzgz//aYIGRiZGXWub9yGEVnnjbxiW7Fm0TT9yL0iBjAwqYVmi/TIFu
         WHl43dLKV9bAxsFMEfWs0ZRVhEQ99Al4nxNIlX4rYaYdlXU4SSf0OsYnN+j1Qttx35
         ajz3PwRSrWVeg==
Date:   Tue, 16 Nov 2021 06:27:32 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Soheil Hassas Yeganeh <soheil@google.com>,
        Neal Cardwell <ncardwell@google.com>,
        Arjun Roy <arjunroy@google.com>
Subject: Re: [PATCH net-next 17/20] tcp: defer skb freeing after socket lock
 is released
Message-ID: <20211116062732.60260cd2@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20211115190249.3936899-18-eric.dumazet@gmail.com>
References: <20211115190249.3936899-1-eric.dumazet@gmail.com>
        <20211115190249.3936899-18-eric.dumazet@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 15 Nov 2021 11:02:46 -0800 Eric Dumazet wrote:
> One cpu can now be fully utilized for the kernel->user copy,
> and another cpu is handling BH processing and skb/page
> allocs/frees (assuming RFS is not forcing use of a single CPU)

Are you saying the kernel->user copy is not under the socket lock
today? I'm working on getting the crypto & copy from under the socket
lock for ktls, and it looked like tcp does the copy under the lock.
