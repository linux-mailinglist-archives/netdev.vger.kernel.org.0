Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2727C36E7A6
	for <lists+netdev@lfdr.de>; Thu, 29 Apr 2021 11:11:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233264AbhD2JMD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Apr 2021 05:12:03 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:36083 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231467AbhD2JMC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Apr 2021 05:12:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1619687476;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=7mHkYV6GvGmzf+0JAfgaOq9O6URrv/lDXhBCCexc0WU=;
        b=YkREO9pEUnikO0oiiQFVUdJcj3xU7g7/ng+odqCq0xMa4NyoJqJ98NgCVjhn5zgN2ZkXVh
        pG4zasfbxcA1DTe0GMdTdfllJfAE7bSXHXo2Kv/MP0iHisvm9T8wB/ShTbYN9HG/nNm3Xe
        W8/w5lTw8rXAN5wrAfNaK/OBH1wSNpc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-322-Gkd90IT6N6q5OYn13yOhog-1; Thu, 29 Apr 2021 05:11:13 -0400
X-MC-Unique: Gkd90IT6N6q5OYn13yOhog-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E1E22107ACC7;
        Thu, 29 Apr 2021 09:11:11 +0000 (UTC)
Received: from carbon (unknown [10.36.110.19])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C8DF016D2A;
        Thu, 29 Apr 2021 09:10:57 +0000 (UTC)
Date:   Thu, 29 Apr 2021 11:10:56 +0200
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Magnus Karlsson <magnus.karlsson@gmail.com>
Cc:     magnus.karlsson@intel.com, intel-wired-lan@lists.osuosl.org,
        anthony.l.nguyen@intel.com, maciej.fijalkowski@intel.com,
        netdev@vger.kernel.org, brouer@redhat.com,
        Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Hangbin Liu <haliu@redhat.com>
Subject: Re: [PATCH intel-net] i40e: fix broken XDP support
Message-ID: <20210429111056.2174ee76@carbon>
In-Reply-To: <20210426111401.28369-1-magnus.karlsson@gmail.com>
References: <20210426111401.28369-1-magnus.karlsson@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Tony, (+ Kuba and DaveM),

What is the status on this patch[2] that fixes a crash[1] for i40e driver?

I'm getting offlist and internal IRC questions to why i40e doesn't
work, and I noticed that it seems this have not been applied.

I don't see it in net-next or net tree... would it make sense to route
this via DaveM, or does it depend on the other fixes for i40e.

[1] https://lore.kernel.org/netdev/20210422170508.22c58226@carbon/
[2] https://patchwork.kernel.org/project/netdevbpf/patch/20210426111401.28369-1-magnus.karlsson@gmail.com/

(top-post)

On Mon, 26 Apr 2021 13:14:01 +0200
Magnus Karlsson <magnus.karlsson@gmail.com> wrote:

> From: Magnus Karlsson <magnus.karlsson@intel.com>
> 
> Commit 12738ac4754e ("i40e: Fix sparse errors in i40e_txrx.c") broke
> XDP support in the i40e driver. That commit was fixing a sparse error
> in the code by introducing a new variable xdp_res instead of
> overloading this into the skb pointer. The problem is that the code
> later uses the skb pointer in if statements and these where not
> extended to also test for the new xdp_res variable. Fix this by adding
> the correct tests for xdp_res in these places.
> 
> The skb pointer was used to store the result of the XDP program by
> overloading the results in the errror pointer
> ERR_PTR(-result). Therefore, the allocation failure test that used to
> only test for !skb now need to be extended to also consider !xdp_res.
> 
> i40e_cleanup_headers() had a check that based on the skb value being
> an error pointer, i.e. a result from the XDP program != XDP_PASS, and
> if so start to process a new packet immediately, instead of populating
> skb fields and sending the skb to the stack. This check is not needed
> anymore, since we have added an explicit test for xdp_res being set
> and if so just do continue to pick the next packet from the NIC.
> 
> v1 -> v2:
> 
> * Improved commit message.
> 
> * Restored the xdp_res = 0 initialization to its original place
>   outside the per-packet loop. The original reason to move it inside
>   the loop was that it was only initialized inside the loop code if
>   skb was not set. But as skb can only be non-null if we have packets
>   consisting of multiple frames (skb is set for all frames except the
>   last one in a packet) and when this is true XDP cannot be active, so
>   this does not matter. xdp_res == 0 is the same as I40E_XDP_PASS
>   which is the default action if XDP is not active and it is then true
>   for every single packet in this case.
> 
> Fixes: 12738ac4754e ("i40e: Fix sparse errors in i40e_txrx.c")
> Acked-by: Jesper Dangaard Brouer <brouer@redhat.com>
> Tested-by: Jesper Dangaard Brouer <brouer@redhat.com>
> Reported-by: Jesper Dangaard Brouer <brouer@redhat.com>
> Reviewed-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
> Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
> ---
>  drivers/net/ethernet/intel/i40e/i40e_txrx.c | 8 ++------
>  1 file changed, 2 insertions(+), 6 deletions(-)

-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

