Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 90C6E1B499C
	for <lists+netdev@lfdr.de>; Wed, 22 Apr 2020 18:07:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726748AbgDVQHv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Apr 2020 12:07:51 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:30613 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726431AbgDVQHu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Apr 2020 12:07:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1587571669;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=T5Pk5DJLVGFLtCPU8i1qdArebWBTUU2KueadN/fIUUM=;
        b=F+WGVG59aZrZI2ZVhaAzRX33B+VGq2laXUWCL8daRBcmT6X8GJ/BXtl3kve+CIWKePXo0E
        NglZYj4EvaoUJvgPXrmvGqb2nkumIrb7HYdUHjhiboybBzkJNk41/Jt4IfQk59Cxm3VrA/
        YeDxsi+9nOcAqYBpXYTg5S3VCU1T2Jc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-373-4bwqBsW4OBulu4Wh6bfXJQ-1; Wed, 22 Apr 2020 12:07:45 -0400
X-MC-Unique: 4bwqBsW4OBulu4Wh6bfXJQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 44CAD13FC;
        Wed, 22 Apr 2020 16:07:43 +0000 (UTC)
Received: from firesoul.localdomain (unknown [10.40.208.3])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2FC541000327;
        Wed, 22 Apr 2020 16:07:37 +0000 (UTC)
Received: from [192.168.42.3] (localhost [IPv6:::1])
        by firesoul.localdomain (Postfix) with ESMTP id 55F3130000272;
        Wed, 22 Apr 2020 18:07:36 +0200 (CEST)
Subject: [PATCH net-next 03/33] sfc: add XDP frame size
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     sameehj@amazon.com
Cc:     Jesper Dangaard Brouer <brouer@redhat.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, zorik@amazon.com, akiyano@amazon.com,
        gtzalik@amazon.com,
        =?utf-8?q?Toke_H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Daniel Borkmann <borkmann@iogearbox.net>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        David Ahern <dsahern@gmail.com>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Saeed Mahameed <saeedm@mellanox.com>,
        steffen.klassert@secunet.com
Date:   Wed, 22 Apr 2020 18:07:36 +0200
Message-ID: <158757165628.1370371.12418646229242084926.stgit@firesoul>
In-Reply-To: <158757160439.1370371.13213378122947426220.stgit@firesoul>
References: <158757160439.1370371.13213378122947426220.stgit@firesoul>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This driver uses RX page-split when possible. It was recently fixed
in commit 86e85bf6981c ("sfc: fix XDP-redirect in this driver") to
add needed tailroom for XDP-redirect.

After the fix efx->rx_page_buf_step is the frame size, with enough
head and tail-room for XDP-redirect.

Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
---
 drivers/net/ethernet/sfc/rx.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/sfc/rx.c b/drivers/net/ethernet/sfc/rx.c
index 260352d97d9d..68c47a8c71df 100644
--- a/drivers/net/ethernet/sfc/rx.c
+++ b/drivers/net/ethernet/sfc/rx.c
@@ -308,6 +308,7 @@ static bool efx_do_xdp(struct efx_nic *efx, struct efx_channel *channel,
 	xdp_set_data_meta_invalid(&xdp);
 	xdp.data_end = xdp.data + rx_buf->len;
 	xdp.rxq = &rx_queue->xdp_rxq_info;
+	xdp.frame_sz = efx->rx_page_buf_step;
 
 	xdp_act = bpf_prog_run_xdp(xdp_prog, &xdp);
 	rcu_read_unlock();


