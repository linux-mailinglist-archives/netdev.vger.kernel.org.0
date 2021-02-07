Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5AC193120A2
	for <lists+netdev@lfdr.de>; Sun,  7 Feb 2021 01:58:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229615AbhBGA5f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 6 Feb 2021 19:57:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:59830 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229522AbhBGA5e (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 6 Feb 2021 19:57:34 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6DD3F64E89;
        Sun,  7 Feb 2021 00:56:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612659413;
        bh=x3rM4GO59tCwGORaar/zQMO4k0jJ0iPX/kraCzE0nrQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=qJX4sts2Ye6Xn0Ao88oA1OSzoF3SVBFRuJHdTCXbkMHfa/OQriQtNW0jrAz5xqagT
         xcOh9kr2XY+21yh6lAI1T7ubgmpb9NxqD0MrDgyc+kjRdYQpoMgswzn6rql2UT3FQM
         ViuGpXdS3nTpBGdouGlftbBofOBgZ4Z3lFZ40ZX6K50gcQlnpXWdWgwqwN9BV6raeS
         VSVvL19TU+OYA13RVfV+7AbQcGDS4r0gvTL1Xh6H7KeCyTIJ17w0rbRJCrG5wMRaow
         +BPHnnSI2l9u8MHem7QbpLrAdqRg57Fc6qpduJW7SR3z4Slwl683FVhsyMyVpq5Msm
         ktY/hgZmvG6ew==
Date:   Sat, 6 Feb 2021 16:56:52 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Stefano Garzarella <sgarzare@redhat.com>
Cc:     Norbert Slusarek <nslusarek@gmx.net>, alex.popov@linux.com,
        eric.dumazet@gmail.com, netdev@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH] net/vmw_vsock: improve locking in
 vsock_connect_timeout()
Message-ID: <20210206165652.5bb69b67@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210205171951.emlq5t5fuiwtpse3@steredhat>
References: <trinity-f8e0937a-cf0e-4d80-a76e-d9a958ba3ef1-1612535522360@3c-app-gmx-bap12>
        <20210205171951.emlq5t5fuiwtpse3@steredhat>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 5 Feb 2021 18:19:51 +0100 Stefano Garzarella wrote:
> On Fri, Feb 05, 2021 at 03:32:02PM +0100, Norbert Slusarek wrote:
> >From: Norbert Slusarek <nslusarek@gmx.net>
> >Date: Fri, 5 Feb 2021 13:14:05 +0100
> >Subject: [PATCH] net/vmw_vsock: improve locking in vsock_connect_timeout()
> >
> >A possible locking issue in vsock_connect_timeout() was recognized by
> >Eric Dumazet which might cause a null pointer dereference in
> >vsock_transport_cancel_pkt(). This patch assures that
> >vsock_transport_cancel_pkt() will be called within the lock, so a race
> >condition won't occur which could result in vsk->transport to be set to NULL.
> >
> >Fixes: 380feae0def7 ("vsock: cancel packets when failing to connect")  
> 
> I have a doubt about the tag to use, since until we introduced 
> transports in commit c0cfa2d8a788 ("vsock: add multi-transports 
> support") this issue didn't cause many problems.
> 
> But it must be said that in the commit 380feae0def7 ("vsock: cancel 
> packets when failing to connect") the vsock_transport_cancel_pkt() was 
> called with the lock held in vsock_stream_connect() and without lock in 
> vsock_connect_timeout(), so maybe this tag is okay.
> 
> Anyway, the patch LGTM:
> 
> Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>

Applied, thanks!
