Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 757C23077AE
	for <lists+netdev@lfdr.de>; Thu, 28 Jan 2021 15:09:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231327AbhA1OIg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jan 2021 09:08:36 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:50847 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229791AbhA1OIf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Jan 2021 09:08:35 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1611842829;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=7eI6M/q6WEZM0vfD6xJ0DHSlAZxg7rWvQfBqNR6INvs=;
        b=LW+epOyoq7RFmpv4nkJKz9+cpX+cOKAdLKlQdQcdypacHe+h5/Z6TMuCgn/ZJmASm5J6AX
        Xfge0RgNnH6Jks9Y+XyeGu/FADAD8etvYJgD9ZMXKo9uAs9x2CvDTB0FIux1ejNBWYGOpa
        pgiyEcm9yHvPOowiEIHgg3q/ikdLVy4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-504-CjidSeiqOIq0mNmk1zjo5Q-1; Thu, 28 Jan 2021 09:07:06 -0500
X-MC-Unique: CjidSeiqOIq0mNmk1zjo5Q-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 53935192781B;
        Thu, 28 Jan 2021 14:07:05 +0000 (UTC)
Received: from carbon (unknown [10.36.110.4])
        by smtp.corp.redhat.com (Postfix) with ESMTP id CFC535D9F8;
        Thu, 28 Jan 2021 14:06:45 +0000 (UTC)
Date:   Thu, 28 Jan 2021 15:06:44 +0100
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org, davem@davemloft.net,
        kuba@kernel.org, ast@kernel.org, daniel@iogearbox.net,
        toshiaki.makita1@gmail.com, lorenzo.bianconi@redhat.com,
        toke@redhat.com, brouer@redhat.com
Subject: Re: [PATCH bpf-next 1/3] net: veth: introduce bulking for XDP_PASS
Message-ID: <20210128150644.78b981cb@carbon>
In-Reply-To: <adca75284e30320e9d692d618a6349319d9340f3.1611685778.git.lorenzo@kernel.org>
References: <cover.1611685778.git.lorenzo@kernel.org>
        <adca75284e30320e9d692d618a6349319d9340f3.1611685778.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 26 Jan 2021 19:41:59 +0100
Lorenzo Bianconi <lorenzo@kernel.org> wrote:

> Introduce bulking support for XDP_PASS verdict forwarding skbs to
> the networking stack
> 
> Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> ---
>  drivers/net/veth.c | 43 ++++++++++++++++++++++++++-----------------
>  1 file changed, 26 insertions(+), 17 deletions(-)
> 
> diff --git a/drivers/net/veth.c b/drivers/net/veth.c
> index 6e03b619c93c..23137d9966da 100644
> --- a/drivers/net/veth.c
> +++ b/drivers/net/veth.c
> @@ -35,6 +35,7 @@
>  #define VETH_XDP_HEADROOM	(XDP_PACKET_HEADROOM + NET_IP_ALIGN)
>  
>  #define VETH_XDP_TX_BULK_SIZE	16
> +#define VETH_XDP_BATCH		8
>

I suspect that VETH_XDP_BATCH = 8 is not the optimal value.

You have taken this value from CPUMAP code, which cannot be generalized
to this case.  The optimal value for CPUMAP is actually to bulk dequeue
16 frames from ptr_ring, but there is a prefetch in one of the loops,
which should not be larger than 10, due to the Intel Line-Fill-Buffer
cannot have more than 10 out-standing prefetch instructions in flight.
(Yes, I measured this[1] with perf stat, when coding that)

Could you please test with 16, to see if results are better?

In this veth case, we will likely be started on the same CPU that
received the xdp_frames.  Thus, things are likely hot in cache, and we
don't have to care so much about moving cachelines across CPUs.  So, I
don't expect it will make much difference.


[1] https://github.com/xdp-project/xdp-project/blob/master/areas/cpumap/cpumap02-optimizations.org
-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

