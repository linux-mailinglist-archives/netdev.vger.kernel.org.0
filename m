Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C39081FDA08
	for <lists+netdev@lfdr.de>; Thu, 18 Jun 2020 02:02:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727081AbgFRACb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Jun 2020 20:02:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:49910 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726848AbgFRACb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 17 Jun 2020 20:02:31 -0400
Received: from kicinski-fedora-PC1C0HJN (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 092B821556;
        Thu, 18 Jun 2020 00:02:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592438551;
        bh=Kk6q5VCfw7IqMGn1txGsseTZJQaqHsQeZ7M1IRvXLoA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ptvmTvdy8XBsC1YP7iV78gMfJ/EhKa2aTcyQz9szsZPgJWPY+7dPDGGSH/IwfR8yQ
         SKRNmE6UbpmDyuTn5bLcE2ss9QVmOo+WshTv0Y6yYzEB02csXfQdTuMldQ5BXBFUFq
         hA2p0TkUyPanRkalBkyXNkjDz8se9dFKRxUydQfs=
Date:   Wed, 17 Jun 2020 17:02:29 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Eric Dumazet <edumazet@google.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Willem de Bruijn <willemb@google.com>,
        Antoine Tenart <antoine.tenart@bootlin.com>
Subject: Re: [PATCH net-next 1/5] net: tso: double TSO_HEADER_SIZE value
Message-ID: <20200617170229.04454d36@kicinski-fedora-PC1C0HJN>
In-Reply-To: <20200617184819.49986-2-edumazet@google.com>
References: <20200617184819.49986-1-edumazet@google.com>
        <20200617184819.49986-2-edumazet@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 17 Jun 2020 11:48:15 -0700 Eric Dumazet wrote:
> Transport header size could be 60 bytes, and network header
> size can also be 60 bytes. Add the Ethernet header and we
> are above 128 bytes.
> 
> Since drivers using net/core/tso.c usually allocates
> one DMA coherent piece of memory per TX queue, this patch
> might cause issues if a driver was using too many slots.
> 
> For 1024 slots, we would need 256 KB of physically
> contiguous memory instead of 128 KB.
> 
> Alternative fix would be to add checks in the fast path,
> but this involves more work in all drivers using net/core/tso.c.
> 
> Fixes: f9cbe9a556af ("net: define the TSO header size in net/tso.h")
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Cc: Antoine Tenart <antoine.tenart@bootlin.com>

Some warnings popping up in this series with W=1 C=1:

drivers/net/ethernet/marvell/octeontx2/af/common.h:65:26: warning: cast truncates bits from constant value (100 becomes 0)
