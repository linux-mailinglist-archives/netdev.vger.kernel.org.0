Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6EB781C6BEB
	for <lists+netdev@lfdr.de>; Wed,  6 May 2020 10:38:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728890AbgEFIiP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 May 2020 04:38:15 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:26925 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728826AbgEFIiO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 May 2020 04:38:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588754293;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=c+eJgg/zkz4zS/BPXZUC0rvuRWK7Cs0ZNQXjC8ebbiU=;
        b=ZbY8Q5LnfmoWjSVih674FpzxqQHi2bPwZ9p4KpgK4mOcAj1h8OiorlwIgwj/zvQ53KYogv
        PCsQxL4l73KQBp/T5TAIVXpPCLzEJAyslpF1CkA1+ShvyTmecqXfms/Xxi9RaWTn2dQl6p
        aIK/p0rlkLiRRkvSwGNqeg2a9vx4ikc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-514-HeCLntpdMIC6iS_s-5Rckg-1; Wed, 06 May 2020 04:38:08 -0400
X-MC-Unique: HeCLntpdMIC6iS_s-5Rckg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1C1C3468;
        Wed,  6 May 2020 08:38:07 +0000 (UTC)
Received: from carbon (unknown [10.40.208.15])
        by smtp.corp.redhat.com (Postfix) with ESMTP id ACBFF1001B07;
        Wed,  6 May 2020 08:37:58 +0000 (UTC)
Date:   Wed, 6 May 2020 10:37:57 +0200
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     Jason Wang <jasowang@redhat.com>,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, bpf@vger.kernel.org,
        Eugenio Perez Martin <eperezma@redhat.com>, brouer@redhat.com
Subject: Re: performance bug in virtio net xdp
Message-ID: <20200506103757.4bc78b3a@carbon>
In-Reply-To: <20200506035704-mutt-send-email-mst@kernel.org>
References: <20200506035704-mutt-send-email-mst@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 6 May 2020 04:08:27 -0400
"Michael S. Tsirkin" <mst@redhat.com> wrote:

> So for mergeable bufs, we use ewma machinery to guess the correct buffer
> size. If we don't guess correctly, XDP has to do aggressive copies.
> 
> Problem is, xdp paths do not update the ewma at all, except
> sometimes with XDP_PASS. So whatever we happen to have
> before we attach XDP, will mostly stay around.
> 
> The fix is probably to update ewma unconditionally.

I personally find the code hard to follow, and (I admit) that it took
me some time to understand this code path (so I might still be wrong).

In patch[1] I tried to explain (my understanding):

  In receive_mergeable() the frame size is more dynamic. There are two
  basic cases: (1) buffer size is based on a exponentially weighted
  moving average (see DECLARE_EWMA) of packet length. Or (2) in case
  virtnet_get_headroom() have any headroom then buffer size is
  PAGE_SIZE. The ctx pointer is this time used for encoding two values;
  the buffer len "truesize" and headroom. In case (1) if the rx buffer
  size is underestimated, the packet will have been split over more
  buffers (num_buf info in virtio_net_hdr_mrg_rxbuf placed in top of
  buffer area). If that happens the XDP path does a xdp_linearize_page
  operation.


The EWMA code is not used when headroom is defined, which e.g. gets
enabled when running XDP.


[1] https://lore.kernel.org/netdev/158824572816.2172139.1358700000273697123.stgit@firesoul/
-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

