Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DACA52D18D0
	for <lists+netdev@lfdr.de>; Mon,  7 Dec 2020 19:55:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726423AbgLGSy2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Dec 2020 13:54:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:41978 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725877AbgLGSy1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 7 Dec 2020 13:54:27 -0500
Date:   Mon, 7 Dec 2020 10:53:45 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1607367227;
        bh=50Fbpy3MX6B8trLlZELaraTyt75dPDYAPrm+Bv+kS68=;
        h=From:To:Cc:Subject:In-Reply-To:References:From;
        b=amTGpTydm7QXBa9jITflWxd2+dZ0EfIdAUYMKy7Gkb4tt5VJQDYrjJHLI3uPWnPKc
         RJWNRDGyaWkETYu84jN0Sv7ZT59nrgyFQ4f4s3x49JbG8lzxVchDyvZW7H2KH2+7sO
         jM2CiZmK78bmiq59G4iokXDOnmz2+6WdrzTuNU/5d5jSLvlqbZqWHlPX2KZH7fS99d
         wygCa8Yym49Jp2OYfkxm1OJo3O5+BpOkll26MTHRzcwqkhgfN1CqsHa7inwGWdHVkD
         s8Zb18Av0oQzPzkNuocbbAWT03/+5HHYBX/euwhzU0LcdXp6Fneew0YKUOI1zMzesF
         pDkgOSBV5Gbyg==
From:   Jakub Kicinski <kuba@kernel.org>
To:     Hazem Mohamed Abuelfotoh <abuehaze@amazon.com>
Cc:     <netdev@vger.kernel.org>, <stable@vger.kernel.org>,
        <edumazet@google.com>, <ycheng@google.com>, <ncardwell@google.com>,
        <weiwan@google.com>, <astroh@amazon.com>, <benh@amazon.com>
Subject: Re: [PATCH net] tcp: fix receive buffer autotuning to trigger for
 any valid advertised MSS
Message-ID: <20201207105345.4a4474f3@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
In-Reply-To: <20201207114625.9079-1-abuehaze@amazon.com>
References: <CADVnQymC1fLFhb=0_rXNSp2NsNncMMRv77aY=5pYxgmicwowgA@mail.gmail.com>
        <20201207114625.9079-1-abuehaze@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 7 Dec 2020 11:46:25 +0000 Hazem Mohamed Abuelfotoh wrote:
>     Previously receiver buffer auto-tuning starts after receiving
>     one advertised window amount of data.After the initial
>     receiver buffer was raised by
>     commit a337531b942b ("tcp: up initial rmem to 128KB
>     and SYN rwin to around 64KB"),the receiver buffer may
>     take too long for TCP autotuning to start raising
>     the receiver buffer size.
>     commit 041a14d26715 ("tcp: start receiver buffer autotuning sooner")
>     tried to decrease the threshold at which TCP auto-tuning starts
>     but it's doesn't work well in some environments
>     where the receiver has large MTU (9001) especially with high RTT
>     connections as in these environments rcvq_space.space will be the same
>     as rcv_wnd so TCP autotuning will never start because
>     sender can't send more than rcv_wnd size in one round trip.
>     To address this issue this patch is decreasing the initial
>     rcvq_space.space so TCP autotuning kicks in whenever the sender is
>     able to send more than 5360 bytes in one round trip regardless the
>     receiver's configured MTU.
> 
>     Fixes: a337531b942b ("tcp: up initial rmem to 128KB and SYN rwin to around 64KB")
>     Fixes: 041a14d26715 ("tcp: start receiver buffer autotuning sooner")
> 
> Signed-off-by: Hazem Mohamed Abuelfotoh <abuehaze@amazon.com>

If the discussion concludes in favor of this patch please un-indent
this commit message, remove the empty line after the fixes tag, and 
repost.
