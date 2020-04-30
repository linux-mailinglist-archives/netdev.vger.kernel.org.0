Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B5441BF692
	for <lists+netdev@lfdr.de>; Thu, 30 Apr 2020 13:22:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727805AbgD3LVk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Apr 2020 07:21:40 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:30757 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727798AbgD3LVi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Apr 2020 07:21:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588245697;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=E+Fa11a8aGuOJg54L4Y3OCGgdDIxawWq4V0asjQCeJI=;
        b=HCsVVFcsvYPCImLKlft4uQA9etInunlOY7leQ9xD+OHr9AkJw5/eX78hT81uWblY7D+/xb
        pABh6jMHtWyDh3EypjXCp/jT5WMxSyDT/o78+FhEmWFJU6gF1TK9ilWFH5V3mXGoEvTbOA
        xXFYNAVb4j9v9fFlZl7a4jnatHGSsXk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-451-xIfORqB5Nsq_4hgAkJIovw-1; Thu, 30 Apr 2020 07:21:33 -0400
X-MC-Unique: xIfORqB5Nsq_4hgAkJIovw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 14B3F107B265;
        Thu, 30 Apr 2020 11:21:29 +0000 (UTC)
Received: from firesoul.localdomain (unknown [10.40.208.4])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 84ED7165F6;
        Thu, 30 Apr 2020 11:21:23 +0000 (UTC)
Received: from [192.168.42.3] (localhost [IPv6:::1])
        by firesoul.localdomain (Postfix) with ESMTP id 7741D324DB2C0;
        Thu, 30 Apr 2020 13:21:22 +0200 (CEST)
Subject: [PATCH net-next v2 12/33] hv_netvsc: add XDP frame size to driver
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     sameehj@amazon.com
Cc:     Wei Liu <wei.liu@kernel.org>,
        "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
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
Date:   Thu, 30 Apr 2020 13:21:22 +0200
Message-ID: <158824568241.2172139.9308631605958332864.stgit@firesoul>
In-Reply-To: <158824557985.2172139.4173570969543904434.stgit@firesoul>
References: <158824557985.2172139.4173570969543904434.stgit@firesoul>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The hyperv NIC drivers XDP implementation is rather disappointing as it
will be a slowdown to enable XDP on this driver, given it will allocate a
new page for each packet and copy over the payload, before invoking the
XDP BPF-prog.

The positive thing it that its easy to determine the xdp.frame_sz.

The XDP implementation for hv_netvsc transparently passes xdp_prog
to the associated VF NIC. Many of the Azure VMs are using SRIOV, so
majority of the data are actually processed directly on the VF driver's XDP
path. So the overhead of the synthetic data path (hv_netvsc) is minimal.

Then XDP is enabled on this driver, XDP_PASS and XDP_TX will create the
SKB via build_skb (based on the newly allocated page). Now using XDP
frame_sz this will provide more skb_tailroom, which netstack can use for
SKB coalescing (e.g tcp_try_coalesce -> skb_try_coalesce).

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
index d8e86bdbfba1..651344fea0a5 100644
--- a/drivers/net/hyperv/netvsc_drv.c
+++ b/drivers/net/hyperv/netvsc_drv.c
@@ -794,7 +794,7 @@ static struct sk_buff *netvsc_alloc_recv_skb(struct net_device *net,
 	if (xbuf) {
 		unsigned int hdroom = xdp->data - xdp->data_hard_start;
 		unsigned int xlen = xdp->data_end - xdp->data;
-		unsigned int frag_size = netvsc_xdp_fraglen(hdroom + xlen);
+		unsigned int frag_size = xdp->frame_sz;
 
 		skb = build_skb(xbuf, frag_size);
 


