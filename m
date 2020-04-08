Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3F24B1A2047
	for <lists+netdev@lfdr.de>; Wed,  8 Apr 2020 13:52:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728712AbgDHLv6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Apr 2020 07:51:58 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:40589 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728703AbgDHLv6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Apr 2020 07:51:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1586346717;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=9XBd9DbnuDkKdHjbEZMfwzYD2hyIES8PBbL3EmYvA18=;
        b=fUm4YeZtYujSYngNfN3RePnV7kkSx5AkB79Vzb8n1/nu2SUXccfudWG8LOAWtqVl2no8bD
        4SRKZfAR1qlRPrlQbiH4lr5NutRs+CprIuSbW7x9fKgZkNhQhHb2AWR5PUxojPCG8brYIB
        crLCPUWf7UuzS9EC3p+oydE+e8V646o=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-18-7v4feL3AP9mqYa0FGX-wPw-1; Wed, 08 Apr 2020 07:51:54 -0400
X-MC-Unique: 7v4feL3AP9mqYa0FGX-wPw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D11C88018A4;
        Wed,  8 Apr 2020 11:51:51 +0000 (UTC)
Received: from firesoul.localdomain (unknown [10.40.208.40])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 782125D9CA;
        Wed,  8 Apr 2020 11:51:51 +0000 (UTC)
Received: from [192.168.42.3] (localhost [IPv6:::1])
        by firesoul.localdomain (Postfix) with ESMTP id 90F7A300020FB;
        Wed,  8 Apr 2020 13:51:50 +0200 (CEST)
Subject: [PATCH RFC v2 15/33] ena: add XDP frame size to amazon NIC driver
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     sameehj@amazon.com
Cc:     Arthur Kiyanovski <akiyano@amazon.com>,
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
        Saeed Mahameed <saeedm@mellanox.com>
Date:   Wed, 08 Apr 2020 13:51:50 +0200
Message-ID: <158634671052.707275.5680515403770560550.stgit@firesoul>
In-Reply-To: <158634658714.707275.7903484085370879864.stgit@firesoul>
References: <158634658714.707275.7903484085370879864.stgit@firesoul>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Frame size ENA_PAGE_SIZE is limited to 16K on systems with larger
PAGE_SIZE than 16K. Change ENA_XDP_MAX_MTU to also take into account
the reserved tailroom.

Cc: Arthur Kiyanovski <akiyano@amazon.com>
Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
---
 drivers/net/ethernet/amazon/ena/ena_netdev.c |    1 +
 drivers/net/ethernet/amazon/ena/ena_netdev.h |    5 +++--
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/amazon/ena/ena_netdev.c b/drivers/net/ethernet/amazon/ena/ena_netdev.c
index 2cc765df8da3..0fd7db1769f8 100644
--- a/drivers/net/ethernet/amazon/ena/ena_netdev.c
+++ b/drivers/net/ethernet/amazon/ena/ena_netdev.c
@@ -1606,6 +1606,7 @@ static int ena_clean_rx_irq(struct ena_ring *rx_ring, struct napi_struct *napi,
 		  "%s qid %d\n", __func__, rx_ring->qid);
 	res_budget = budget;
 	xdp.rxq = &rx_ring->xdp_rxq;
+	xdp.frame_sz = ENA_PAGE_SIZE;
 
 	do {
 		xdp_verdict = XDP_PASS;
diff --git a/drivers/net/ethernet/amazon/ena/ena_netdev.h b/drivers/net/ethernet/amazon/ena/ena_netdev.h
index 97dfd0c67e84..dd00127dfe9f 100644
--- a/drivers/net/ethernet/amazon/ena/ena_netdev.h
+++ b/drivers/net/ethernet/amazon/ena/ena_netdev.h
@@ -151,8 +151,9 @@
  * The buffer size we share with the device is defined to be ENA_PAGE_SIZE
  */
 
-#define ENA_XDP_MAX_MTU (ENA_PAGE_SIZE - ETH_HLEN - ETH_FCS_LEN - \
-				VLAN_HLEN - XDP_PACKET_HEADROOM)
+#define ENA_XDP_MAX_MTU (ENA_PAGE_SIZE - ETH_HLEN - ETH_FCS_LEN -	\
+			 VLAN_HLEN - XDP_PACKET_HEADROOM -		\
+			 SKB_DATA_ALIGN(sizeof(struct skb_shared_info)))
 
 #define ENA_IS_XDP_INDEX(adapter, index) (((index) >= (adapter)->xdp_first_ring) && \
 	((index) < (adapter)->xdp_first_ring + (adapter)->xdp_num_queues))


