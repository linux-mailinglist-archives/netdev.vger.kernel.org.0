Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 838E81BAF4B
	for <lists+netdev@lfdr.de>; Mon, 27 Apr 2020 22:23:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726676AbgD0UXF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Apr 2020 16:23:05 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:26531 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726442AbgD0UXF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Apr 2020 16:23:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588018983;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=CKwh3xsWU983LAUC3Pq70EcGdIYIXiDTkZaaPUN5hpw=;
        b=c/U/J+F8bTSdfApNjdamCS6Scgdr7GM5pvBQF+jLwsQvvo2WMT+sf6+nmogqPc2cyoMQ3J
        B579mxm2oEEnFhnu9+LBr8dCwyzv8oPoRjstuDm0rLJ0QrR3IuoLZlQ7x8FPG2Tq3l2NI+
        jhJDZ2ghksAvWzH2705KSoq1vsrBQWI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-422-nalA4JwUOvqLyKwPhAyinA-1; Mon, 27 Apr 2020 16:22:59 -0400
X-MC-Unique: nalA4JwUOvqLyKwPhAyinA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E245418FF663;
        Mon, 27 Apr 2020 20:22:56 +0000 (UTC)
Received: from carbon (unknown [10.40.208.55])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B0CF95D9DA;
        Mon, 27 Apr 2020 20:22:46 +0000 (UTC)
Date:   Mon, 27 Apr 2020 22:22:45 +0200
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     sameehj@amazon.com
Cc:     Tariq Toukan <tariqt@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, zorik@amazon.com, akiyano@amazon.com,
        gtzalik@amazon.com,
        Toke =?UTF-8?B?SMO4aWxhbmQtSsO4cmdlbnNlbg==?= <toke@redhat.com>,
        Daniel Borkmann <borkmann@iogearbox.net>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        David Ahern <dsahern@gmail.com>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        steffen.klassert@secunet.com, brouer@redhat.com
Subject: Re: [PATCH net-next 28/33] mlx5: rx queue setup time determine
 frame_sz for XDP
Message-ID: <20200427222245.5350afbb@carbon>
In-Reply-To: <158757178332.1370371.3518949026344543513.stgit@firesoul>
References: <158757160439.1370371.13213378122947426220.stgit@firesoul>
        <158757178332.1370371.3518949026344543513.stgit@firesoul>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 22 Apr 2020 18:09:43 +0200
Jesper Dangaard Brouer <brouer@redhat.com> wrote:

> The mlx5 driver have multiple memory models, which are also changed
> according to whether a XDP bpf_prog is attached.
> 
> The 'rx_striding_rq' setting is adjusted via ethtool priv-flags e.g.:
>  # ethtool --set-priv-flags mlx5p2 rx_striding_rq off
> 
> On the general case with 4K page_size and regular MTU packet, then
> the frame_sz is 2048 and 4096 when XDP is enabled, in both modes.
> 
> The info on the given frame size is stored differently depending on the
> RQ-mode and encoded in a union in struct mlx5e_rq union wqe/mpwqe.
> In rx striding mode rq->mpwqe.log_stride_sz is either 11 or 12, which
> corresponds to 2048 or 4096 (MLX5_WQ_TYPE_LINKED_LIST_STRIDING_RQ).
> In non-striding mode (MLX5_WQ_TYPE_CYCLIC) the frag_stride is stored
> in rq->wqe.info.arr[0].frag_stride, for the first fragment, which is
> what the XDP case cares about.
> 
> To reduce effect on fast-path, this patch determine the frame_sz at
> setup time, to avoid determining the memory model runtime. Variable
> is named first_frame_sz to make it clear that this is only the frame
> size of the first fragment.
> 
> This mlx5 driver does a DMA-sync on XDP_TX action, but grow is safe
> as it have done a DMA-map on the entire PAGE_SIZE. The driver also
> already does a XDP length check against sq->hw_mtu on the possible
> XDP xmit paths mlx5e_xmit_xdp_frame() + mlx5e_xmit_xdp_frame_mpwqe().
> 
> Cc: Tariq Toukan <tariqt@mellanox.com>
> Cc: Saeed Mahameed <saeedm@mellanox.com>
> Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
> ---
>  drivers/net/ethernet/mellanox/mlx5/core/en.h      |    1 +
>  drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c  |    1 +
>  drivers/net/ethernet/mellanox/mlx5/core/en_main.c |    6 ++++++
>  3 files changed, 8 insertions(+)

I found a bug in this patch, that can lead to BUG in skb_panic() in
XDP_PASS case when growing the tail. (Hint why I fixed output in [1]).
I already have a fix, but this implies I will send a V2 tomorrow.

I'll pickup all the ACKs manually tomorrow, before I resubmit.

[1] https://lore.kernel.org/netdev/158800546361.1962096.4535216438507756179.stgit@firesoul/
-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

