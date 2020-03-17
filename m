Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3A6CA188C0F
	for <lists+netdev@lfdr.de>; Tue, 17 Mar 2020 18:30:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726824AbgCQRaB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Mar 2020 13:30:01 -0400
Received: from us-smtp-delivery-74.mimecast.com ([63.128.21.74]:54128 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726814AbgCQRaB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Mar 2020 13:30:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1584466200;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=T5Pk5DJLVGFLtCPU8i1qdArebWBTUU2KueadN/fIUUM=;
        b=Gh7SEXxioluSeZioR/ZvNwy8hjys89WJROY8jozGqWtnTHuYWQJ/sdNoKgiPiDD9MVPo8L
        BDGypp9W0er/weUvVwx/saKtVqCUZdkejDla7OScg1XPoDEjvFhbAyLdnG39lYYmdMIOmI
        dbZkQEiOutz36RADDV3MGho1sIyygwo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-416-6qrgC6CoNQq1XM7U1mWMVg-1; Tue, 17 Mar 2020 13:29:56 -0400
X-MC-Unique: 6qrgC6CoNQq1XM7U1mWMVg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A24988C60B3;
        Tue, 17 Mar 2020 17:29:44 +0000 (UTC)
Received: from firesoul.localdomain (unknown [10.40.208.26])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4917560BEE;
        Tue, 17 Mar 2020 17:29:44 +0000 (UTC)
Received: from [192.168.42.3] (localhost [IPv6:::1])
        by firesoul.localdomain (Postfix) with ESMTP id 4F39D30721A66;
        Tue, 17 Mar 2020 18:29:43 +0100 (CET)
Subject: [PATCH RFC v1 07/15] sfc: add XDP frame size
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     sameehj@amazon.com
Cc:     Jesper Dangaard Brouer <brouer@redhat.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, zorik@amazon.com, akiyano@amazon.com,
        gtzalik@amazon.com,
        =?utf-8?q?Toke_H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>,
        Daniel Borkmann <borkmann@iogearbox.net>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        David Ahern <dsahern@gmail.com>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Lorenzo Bianconi <lorenzo@kernel.org>
Date:   Tue, 17 Mar 2020 18:29:43 +0100
Message-ID: <158446618325.702578.18228925927628029079.stgit@firesoul>
In-Reply-To: <158446612466.702578.2795159620575737080.stgit@firesoul>
References: <158446612466.702578.2795159620575737080.stgit@firesoul>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
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


