Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E8BF21CA912
	for <lists+netdev@lfdr.de>; Fri,  8 May 2020 13:10:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727790AbgEHLJ7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 May 2020 07:09:59 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:31361 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726618AbgEHLJ6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 May 2020 07:09:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588936197;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=8Rj7wa2GATFjAg6ic4DZAIY6MkXEq/mx3F2FWQ7wrcU=;
        b=BheqPdTjWvCATWsFwDBakrV/bgd2TmQieaU+kbH5XxHxyV5FI5uf4IdwuY4ZDmBGo7l5sw
        K1bkqMNAHrnzbqQZszVADLCGKmXAp75XbWPe/2hzlgH89cRLysw0uLxjkHpWFqzxE1dRVS
        ZtRGV/hEkYyJ6fUprVy9ILdxWyjVZKI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-273-Fj7jLLWfNmqcCJtFxKCpZg-1; Fri, 08 May 2020 07:09:55 -0400
X-MC-Unique: Fj7jLLWfNmqcCJtFxKCpZg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8C6201895A2A;
        Fri,  8 May 2020 11:09:53 +0000 (UTC)
Received: from firesoul.localdomain (unknown [10.40.208.11])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D5C7810013BD;
        Fri,  8 May 2020 11:09:47 +0000 (UTC)
Received: from [192.168.42.3] (localhost [IPv6:::1])
        by firesoul.localdomain (Postfix) with ESMTP id E3D053063F605;
        Fri,  8 May 2020 13:09:46 +0200 (CEST)
Subject: [PATCH net-next v3 12/33] hv_netvsc: add XDP frame size to driver
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
Date:   Fri, 08 May 2020 13:09:46 +0200
Message-ID: <158893618685.2321140.12701548043443547795.stgit@firesoul>
In-Reply-To: <158893607924.2321140.16117992313983615627.stgit@firesoul>
References: <158893607924.2321140.16117992313983615627.stgit@firesoul>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The hyperv NIC driver does memory allocation and copy even without XDP.
In XDP mode it will allocate a new page for each packet and copy over
the payload, before invoking the XDP BPF-prog.

The positive thing it that its easy to determine the xdp.frame_sz.

The XDP implementation for hv_netvsc transparently passes xdp_prog
to the associated VF NIC. Many of the Azure VMs are using SRIOV, so
majority of the data are actually processed directly on the VF driver's XDP
path. So the overhead of the synthetic data path (hv_netvsc) is minimal.

Then XDP is enabled on this driver, XDP_PASS and XDP_TX will create the
SKB via build_skb (based on the newly allocated page). Now using XDP
frame_sz this will provide more skb_tailroom, which netstack can use for
SKB coalescing (e.g tcp_try_coalesce -> skb_try_coalesce).

V3: Adjust patch desc to be more positive.

Cc: Wei Liu <wei.liu@kernel.org>
Cc: "K. Y. Srinivasan" <kys@microsoft.com>
Cc: Haiyang Zhang <haiyangz@microsoft.com>
Cc: Stephen Hemminger <sthemmin@microsoft.com>
Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
---
 drivers/net/hyperv/netvsc_bpf.c |    1 +
 drivers/net/hyperv/netvsc_drv.c |    2 +-
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/hyperv/netvsc_bpf.c b/drivers/net/hyperv/netvsc_bpf.c
index b86611041db6..1e0c024b0a93 100644
--- a/drivers/net/hyperv/netvsc_bpf.c
+++ b/drivers/net/hyperv/netvsc_bpf.c
@@ -49,6 +49,7 @@ u32 netvsc_run_xdp(struct net_device *ndev, struct netvsc_channel *nvchan,
 	xdp_set_data_meta_invalid(xdp);
 	xdp->data_end = xdp->data + len;
 	xdp->rxq = &nvchan->xdp_rxq;
+	xdp->frame_sz = PAGE_SIZE;
 	xdp->handle = 0;
 
 	memcpy(xdp->data, data, len);
diff --git a/drivers/net/hyperv/netvsc_drv.c b/drivers/net/hyperv/netvsc_drv.c
index 5de57fc3ec60..6267f706e8ee 100644
--- a/drivers/net/hyperv/netvsc_drv.c
+++ b/drivers/net/hyperv/netvsc_drv.c
@@ -795,7 +795,7 @@ static struct sk_buff *netvsc_alloc_recv_skb(struct net_device *net,
 	if (xbuf) {
 		unsigned int hdroom = xdp->data - xdp->data_hard_start;
 		unsigned int xlen = xdp->data_end - xdp->data;
-		unsigned int frag_size = netvsc_xdp_fraglen(hdroom + xlen);
+		unsigned int frag_size = xdp->frame_sz;
 
 		skb = build_skb(xbuf, frag_size);
 


