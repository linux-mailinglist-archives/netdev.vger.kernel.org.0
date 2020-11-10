Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A18412AD428
	for <lists+netdev@lfdr.de>; Tue, 10 Nov 2020 11:53:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726884AbgKJKx3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Nov 2020 05:53:29 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:26484 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726280AbgKJKx2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Nov 2020 05:53:28 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1605005607;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=35q3iM7jQZTNyKhSQJyZvAW4FTGsp21AnAWgfjWL+W8=;
        b=ZFTw2c+Rh622Am1x8GQRXXFD5zAMt601EsDGrlLOy1NetF9hyEHIT6MPJZ1k1Q0WDUmgyd
        C59ue0yrhthXun5+Ws2f1S6W18RKxzkzPfUZJv8/US44WNFyfPqaJJgqQtL0xbml6wwoIq
        C+fo2BRE0O08nUgcUluu3yDz1x/3lw4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-447-iwUwMm62N46gKy5mrKVY7g-1; Tue, 10 Nov 2020 05:53:23 -0500
X-MC-Unique: iwUwMm62N46gKy5mrKVY7g-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4124264150;
        Tue, 10 Nov 2020 10:53:22 +0000 (UTC)
Received: from carbon (unknown [10.36.110.8])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 37E575E9D0;
        Tue, 10 Nov 2020 10:53:13 +0000 (UTC)
Date:   Tue, 10 Nov 2020 11:53:12 +0100
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        lorenzo.bianconi@redhat.com, davem@davemloft.net, kuba@kernel.org,
        ilias.apalodimas@linaro.org, brouer@redhat.com
Subject: Re: [PATCH v4 net-next 1/5] net: xdp: introduce bulking for xdp tx
 return path
Message-ID: <20201110115313.6654141b@carbon>
In-Reply-To: <3764c855c42d719000aa56bb946b3ddfd00971f2.1604686496.git.lorenzo@kernel.org>
References: <cover.1604686496.git.lorenzo@kernel.org>
        <3764c855c42d719000aa56bb946b3ddfd00971f2.1604686496.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri,  6 Nov 2020 19:19:07 +0100
Lorenzo Bianconi <lorenzo@kernel.org> wrote:

> XDP bulk APIs introduce a defer/flush mechanism to return
> pages belonging to the same xdp_mem_allocator object
> (identified via the mem.id field) in bulk to optimize
> I-cache and D-cache since xdp_return_frame is usually run
> inside the driver NAPI tx completion loop.
> The bulk queue size is set to 16 to be aligned to how
> XDP_REDIRECT bulking works. The bulk is flushed when
> it is full or when mem.id changes.
> xdp_frame_bulk is usually stored/allocated on the function
> call-stack to avoid locking penalties.
> Current implementation considers only page_pool memory model.
> 
> Suggested-by: Jesper Dangaard Brouer <brouer@redhat.com>
> Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> ---
>  include/net/xdp.h | 11 ++++++++-
>  net/core/xdp.c    | 61 +++++++++++++++++++++++++++++++++++++++++++++++
>  2 files changed, 71 insertions(+), 1 deletion(-)

I have a number of optimization improvements to this patch.  Mostly
related to simple likely/unlikely compiler annotations, that give
better code layout for I-cache benefit.  Details in[1]. (Lorenzo is informed)

[1] https://github.com/xdp-project/xdp-project/blob/master/areas/mem/xdp_bulk_return01.org
-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

