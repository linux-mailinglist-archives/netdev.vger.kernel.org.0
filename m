Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C97C1B49CF
	for <lists+netdev@lfdr.de>; Wed, 22 Apr 2020 18:10:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726723AbgDVQJi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Apr 2020 12:09:38 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:36034 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727006AbgDVQJg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Apr 2020 12:09:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1587571775;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=7dTeFcQvmgHvPXRpxDawO1wGRsJikECgYeQpNLBP5vo=;
        b=g866Rp3xuzg4ehda5SYXdVHdLjv4dy9YZd4BMev34RTWjwKYYUrTnQi12KGvtzVLzLJZrS
        8hL8bMiTjCTASkegG3JAZnYVljvuEatFXJKBygfQHJEXOmM4tmx2kHYfpbb/xpTPHu/zfz
        B0m0JiUmtDlBCj2KQS6NiBH80q4pycM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-13-CRR41_jJMN6IayhXjhL35A-1; Wed, 22 Apr 2020 12:09:31 -0400
X-MC-Unique: CRR41_jJMN6IayhXjhL35A-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 87133DBF3;
        Wed, 22 Apr 2020 16:09:23 +0000 (UTC)
Received: from firesoul.localdomain (unknown [10.40.208.3])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 663B461073;
        Wed, 22 Apr 2020 16:08:33 +0000 (UTC)
Received: from [192.168.42.3] (localhost [IPv6:::1])
        by firesoul.localdomain (Postfix) with ESMTP id 3AF9D30631A9B;
        Wed, 22 Apr 2020 18:08:32 +0200 (CEST)
Subject: [PATCH net-next 14/33] net: ethernet: ti: add XDP frame size to
 driver cpsw
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     sameehj@amazon.com
Cc:     Grygorii Strashko <grygorii.strashko@ti.com>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
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
Date:   Wed, 22 Apr 2020 18:08:32 +0200
Message-ID: <158757171217.1370371.5128677508831971161.stgit@firesoul>
In-Reply-To: <158757160439.1370371.13213378122947426220.stgit@firesoul>
References: <158757160439.1370371.13213378122947426220.stgit@firesoul>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The driver code cpsw.c and cpsw_new.c both use page_pool
with default order-0 pages or their RX-pages.

Cc: Grygorii Strashko <grygorii.strashko@ti.com>
Cc: Ilias Apalodimas <ilias.apalodimas@linaro.org>
Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
---
 drivers/net/ethernet/ti/cpsw.c     |    1 +
 drivers/net/ethernet/ti/cpsw_new.c |    1 +
 2 files changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/ti/cpsw.c b/drivers/net/ethernet/ti/cpsw.c
index c2c5bf87da01..58e346ea9898 100644
--- a/drivers/net/ethernet/ti/cpsw.c
+++ b/drivers/net/ethernet/ti/cpsw.c
@@ -406,6 +406,7 @@ static void cpsw_rx_handler(void *token, int len, int status)
 
 		xdp.data_hard_start = pa;
 		xdp.rxq = &priv->xdp_rxq[ch];
+		xdp.frame_sz = PAGE_SIZE;
 
 		port = priv->emac_port + cpsw->data.dual_emac;
 		ret = cpsw_run_xdp(priv, ch, &xdp, page, port);
diff --git a/drivers/net/ethernet/ti/cpsw_new.c b/drivers/net/ethernet/ti/cpsw_new.c
index 9209e613257d..08e1c5b8f00e 100644
--- a/drivers/net/ethernet/ti/cpsw_new.c
+++ b/drivers/net/ethernet/ti/cpsw_new.c
@@ -348,6 +348,7 @@ static void cpsw_rx_handler(void *token, int len, int status)
 
 		xdp.data_hard_start = pa;
 		xdp.rxq = &priv->xdp_rxq[ch];
+		xdp.frame_sz = PAGE_SIZE;
 
 		ret = cpsw_run_xdp(priv, ch, &xdp, page, priv->emac_port);
 		if (ret != CPSW_XDP_PASS)


