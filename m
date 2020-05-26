Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B96C61BF693
	for <lists+netdev@lfdr.de>; Thu, 30 Apr 2020 13:22:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727812AbgD3LVl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Apr 2020 07:21:41 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:31075 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727785AbgD3LVh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Apr 2020 07:21:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588245696;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Sxz3Gtr8WDW+IsB5KoB8WPkeWPz04U19AJVW79YnYhE=;
        b=QhEh73qpMFjtt5Pq4x2lDHiHOR/pdmcNvZ3MCenolX+yLCkhqfJ6uysoP3xonqkrnxaiZB
        +kxw6Tl6/maSifSQ/nximESjjq3sRlDS/O9V5UNktwb1e0ghBNtI+yPhHOqX4/AOlALS1i
        ADU16eG8pst3R2R1KGjoQOmVKvUOSE8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-183-8Sr_7X-FMJ-KeLFow8vA-w-1; Thu, 30 Apr 2020 07:21:32 -0400
X-MC-Unique: 8Sr_7X-FMJ-KeLFow8vA-w-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id EFF531005510;
        Thu, 30 Apr 2020 11:21:28 +0000 (UTC)
Received: from firesoul.localdomain (unknown [10.40.208.4])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9C0BB5EDE3;
        Thu, 30 Apr 2020 11:21:28 +0000 (UTC)
Received: from [192.168.42.3] (localhost [IPv6:::1])
        by firesoul.localdomain (Postfix) with ESMTP id 8BD36324DB2C1;
        Thu, 30 Apr 2020 13:21:27 +0200 (CEST)
Subject: [PATCH net-next v2 13/33] qlogic/qede: add XDP frame size to driver
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     sameehj@amazon.com
Cc:     Ariel Elior <aelior@marvell.com>, GR-everest-linux-l2@marvell.com,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        netdev@vger.kernel.org, bpf@vger.kernel.org, zorik@amazon.com,
        akiyano@amazon.com, gtzalik@amazon.com,
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
Date:   Thu, 30 Apr 2020 13:21:27 +0200
Message-ID: <158824568750.2172139.3373468229477905541.stgit@firesoul>
In-Reply-To: <158824557985.2172139.4173570969543904434.stgit@firesoul>
References: <158824557985.2172139.4173570969543904434.stgit@firesoul>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The driver qede uses a full page, when XDP is enabled. The drivers value
in rx_buf_seg_size (struct qede_rx_queue) will be PAGE_SIZE when an
XDP bpf_prog is attached.

Cc: Ariel Elior <aelior@marvell.com>
Cc: GR-everest-linux-l2@marvell.com
Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
---
 drivers/net/ethernet/qlogic/qede/qede_fp.c   |    1 +
 drivers/net/ethernet/qlogic/qede/qede_main.c |    2 +-
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/qlogic/qede/qede_fp.c b/drivers/net/ethernet/qlogic/qede/qede_fp.c
index c6c20776b474..7598ebe0962a 100644
--- a/drivers/net/ethernet/qlogic/qede/qede_fp.c
+++ b/drivers/net/ethernet/qlogic/qede/qede_fp.c
@@ -1066,6 +1066,7 @@ static bool qede_rx_xdp(struct qede_dev *edev,
 	xdp_set_data_meta_invalid(&xdp);
 	xdp.data_end = xdp.data + *len;
 	xdp.rxq = &rxq->xdp_rxq;
+	xdp.frame_sz = rxq->rx_buf_seg_size; /* PAGE_SIZE when XDP enabled */
 
 	/* Queues always have a full reset currently, so for the time
 	 * being until there's atomic program replace just mark read
diff --git a/drivers/net/ethernet/qlogic/qede/qede_main.c b/drivers/net/ethernet/qlogic/qede/qede_main.c
index 9b456198cb50..7e359c2bf2dc 100644
--- a/drivers/net/ethernet/qlogic/qede/qede_main.c
+++ b/drivers/net/ethernet/qlogic/qede/qede_main.c
@@ -1418,7 +1418,7 @@ static int qede_alloc_mem_rxq(struct qede_dev *edev, struct qede_rx_queue *rxq)
 	if (rxq->rx_buf_size + size > PAGE_SIZE)
 		rxq->rx_buf_size = PAGE_SIZE - size;
 
-	/* Segment size to spilt a page in multiple equal parts ,
+	/* Segment size to split a page in multiple equal parts,
 	 * unless XDP is used in which case we'd use the entire page.
 	 */
 	if (!edev->xdp_prog) {


