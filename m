Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C45E1CA91A
	for <lists+netdev@lfdr.de>; Fri,  8 May 2020 13:10:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727824AbgEHLKP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 May 2020 07:10:15 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:23483 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727816AbgEHLKN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 May 2020 07:10:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588936212;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=r02YC3At2N2XY+PDSF73JQ0eJDbIVrsICXPbjmggfSU=;
        b=CCHiGiS0MMgSPzzmFwXhea/bG28NW9vhvuVJqC5evYCHhckxfK1FjIL9P93ZYUXvqVUd9Q
        iA5HENCui8UnGmwIEpA258aIDCsBQfeKs42511WxU8Mp41k3hXLAUb4mCxGakGbs20l28p
        n4DGqHhZf4sNxBUDW1TVy9HZ195ePjg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-350-sl0t0KQNNNul9bG4_T3wHw-1; Fri, 08 May 2020 07:10:08 -0400
X-MC-Unique: sl0t0KQNNNul9bG4_T3wHw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E36AF8015D2;
        Fri,  8 May 2020 11:10:06 +0000 (UTC)
Received: from firesoul.localdomain (unknown [10.40.208.11])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3E70F5D9CA;
        Fri,  8 May 2020 11:09:58 +0000 (UTC)
Received: from [192.168.42.3] (localhost [IPv6:::1])
        by firesoul.localdomain (Postfix) with ESMTP id 1C27B3063F605;
        Fri,  8 May 2020 13:09:57 +0200 (CEST)
Subject: [PATCH net-next v3 14/33] net: ethernet: ti: add XDP frame size to
 driver cpsw
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     sameehj@amazon.com
Cc:     Jesper Dangaard Brouer <brouer@redhat.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org,
        =?utf-8?q?Toke_H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Daniel Borkmann <borkmann@iogearbox.net>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        John Fastabend <john.fastabend@gmail.com>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        David Ahern <dsahern@gmail.com>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Tariq Toukan <tariqt@mellanox.com>
Date:   Fri, 08 May 2020 13:09:57 +0200
Message-ID: <158893619703.2321140.12631116595774465249.stgit@firesoul>
In-Reply-To: <158893607924.2321140.16117992313983615627.stgit@firesoul>
References: <158893607924.2321140.16117992313983615627.stgit@firesoul>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The driver code cpsw.c and cpsw_new.c both use page_pool
with default order-0 pages or their RX-pages.

Cc: Grygorii Strashko <grygorii.strashko@ti.com>
Cc: Ilias Apalodimas <ilias.apalodimas@linaro.org>
Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
Reviewed-by: Grygorii Strashko <grygorii.strashko@ti.com>
---
 drivers/net/ethernet/ti/cpsw.c     |    1 +
 drivers/net/ethernet/ti/cpsw_new.c |    1 +
 2 files changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/ti/cpsw.c b/drivers/net/ethernet/ti/cpsw.c
index 09f98fa2fb4e..ce0645ada6e7 100644
--- a/drivers/net/ethernet/ti/cpsw.c
+++ b/drivers/net/ethernet/ti/cpsw.c
@@ -406,6 +406,7 @@ static void cpsw_rx_handler(void *token, int len, int status)
 
 		xdp.data_hard_start = pa;
 		xdp.rxq = &priv->xdp_rxq[ch];
+		xdp.frame_sz = PAGE_SIZE;
 
 		port = priv->emac_port + cpsw->data.dual_emac;
 		ret = cpsw_run_xdp(priv, ch, &xdp, page, port);
diff --git a/drivers/net/ethernet/ti/cpsw_new.c b/drivers/net/ethernet/ti/cpsw_new.c
index dce49311d3d3..1247d35d42ef 100644
--- a/drivers/net/ethernet/ti/cpsw_new.c
+++ b/drivers/net/ethernet/ti/cpsw_new.c
@@ -348,6 +348,7 @@ static void cpsw_rx_handler(void *token, int len, int status)
 
 		xdp.data_hard_start = pa;
 		xdp.rxq = &priv->xdp_rxq[ch];
+		xdp.frame_sz = PAGE_SIZE;
 
 		ret = cpsw_run_xdp(priv, ch, &xdp, page, priv->emac_port);
 		if (ret != CPSW_XDP_PASS)


