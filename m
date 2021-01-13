Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 289DE2F41BE
	for <lists+netdev@lfdr.de>; Wed, 13 Jan 2021 03:27:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727784AbhAMC0P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jan 2021 21:26:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:38430 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726831AbhAMC0P (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 12 Jan 2021 21:26:15 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3DE59230FC;
        Wed, 13 Jan 2021 02:25:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610504734;
        bh=OVSsCu3O6op4evDB7dHlA1IoxeA8C7iVziAjW3AVx3c=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Euyu0tk7CxMojhWaKk/ScBCLLnnZFXPPLHo0zvqtqotElCRaUwYxwhTFDk8AX0uzV
         zRfNQiE+kBMz+Odw5jUcK2KI2aPa6KVtHCuhYzcaIhteYfNX4w5qB29eijGrapCvdT
         DWitOfmJLGOTD7sEIoy+RhF0lzAtOM3EH1kbEfaJ63Ca3E31PMUeNBBi9Ye9qTLYjL
         QAV/1R8zLL7VtvObbPPqpVvmx3qi1uznghGpv0wVjpDproKaIE6DIqGVVHjoyJn9D/
         KFbPdEOdlpjRvCh1hhknZRnnOm2gR2mi/MorhohbtjbCWI9IhVIPS+kDdJ80bLPa6h
         Vyy0UdyNQ6Bpg==
Date:   Tue, 12 Jan 2021 18:25:33 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     David Howells <dhowells@redhat.com>
Cc:     netdev@vger.kernel.org,
        Baptiste Lepers <baptiste.lepers@gmail.com>,
        linux-afs@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net] rxrpc: Call state should be read with READ_ONCE()
 under some circumstances
Message-ID: <20210112182533.13b1c787@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <161046715522.2450566.488819910256264150.stgit@warthog.procyon.org.uk>
References: <161046715522.2450566.488819910256264150.stgit@warthog.procyon.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 12 Jan 2021 15:59:15 +0000 David Howells wrote:
> From: Baptiste Lepers <baptiste.lepers@gmail.com>
> 
> The call state may be changed at any time by the data-ready routine in
> response to received packets, so if the call state is to be read and acted
> upon several times in a function, READ_ONCE() must be used unless the call
> state lock is held.
> 
> As it happens, we used READ_ONCE() to read the state a few lines above the
> unmarked read in rxrpc_input_data(), so use that value rather than
> re-reading it.
> 
> Signed-off-by: Baptiste Lepers <baptiste.lepers@gmail.com>
> Signed-off-by: David Howells <dhowells@redhat.com>

Fixes: a158bdd3247b ("rxrpc: Fix call timeouts")

maybe?

> diff --git a/net/rxrpc/input.c b/net/rxrpc/input.c
> index 667c44aa5a63..dc201363f2c4 100644
> --- a/net/rxrpc/input.c
> +++ b/net/rxrpc/input.c
> @@ -430,7 +430,7 @@ static void rxrpc_input_data(struct rxrpc_call *call, struct sk_buff *skb)
>  		return;
>  	}
>  
> -	if (call->state == RXRPC_CALL_SERVER_RECV_REQUEST) {
> +	if (state == RXRPC_CALL_SERVER_RECV_REQUEST) {
>  		unsigned long timo = READ_ONCE(call->next_req_timo);
>  		unsigned long now, expect_req_by;
>  
> 
> 

