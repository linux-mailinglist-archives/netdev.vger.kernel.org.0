Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9918C1A202F
	for <lists+netdev@lfdr.de>; Wed,  8 Apr 2020 13:51:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728639AbgDHLu6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Apr 2020 07:50:58 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:60359 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728635AbgDHLu6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Apr 2020 07:50:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1586346657;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=T5Pk5DJLVGFLtCPU8i1qdArebWBTUU2KueadN/fIUUM=;
        b=K77aMVfCSNUmu9YbLGP6rIpzX+qUy3Bu8KNDJj5+fK5+8ZECCiBzdtuhJZqw/94oliufl1
        Z62WaaTyV42+7FJA5qFaDrff9S42vzs76Fjm216DoPtz4lQKIbW+1yHVav8qr9JPfR/RuV
        +8t+xs0ckVElguem4K5OQFWy+aiiDsE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-69-S-fwJTaSO4WDqMdkIR_rwQ-1; Wed, 08 Apr 2020 07:50:53 -0400
X-MC-Unique: S-fwJTaSO4WDqMdkIR_rwQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D69F72F62;
        Wed,  8 Apr 2020 11:50:50 +0000 (UTC)
Received: from firesoul.localdomain (unknown [10.40.208.40])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8130661069;
        Wed,  8 Apr 2020 11:50:50 +0000 (UTC)
Received: from [192.168.42.3] (localhost [IPv6:::1])
        by firesoul.localdomain (Postfix) with ESMTP id 94348300020FA;
        Wed,  8 Apr 2020 13:50:49 +0200 (CEST)
Subject: [PATCH RFC v2 03/33] sfc: add XDP frame size
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
        Saeed Mahameed <saeedm@mellanox.com>
Date:   Wed, 08 Apr 2020 13:50:49 +0200
Message-ID: <158634664953.707275.13465095292337872793.stgit@firesoul>
In-Reply-To: <158634658714.707275.7903484085370879864.stgit@firesoul>
References: <158634658714.707275.7903484085370879864.stgit@firesoul>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
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


