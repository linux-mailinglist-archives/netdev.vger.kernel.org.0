Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 427C51A2069
	for <lists+netdev@lfdr.de>; Wed,  8 Apr 2020 13:53:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728793AbgDHLxZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Apr 2020 07:53:25 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:45350 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728787AbgDHLxY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Apr 2020 07:53:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1586346804;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=EfxAyvFhtEeMjfTkBH/0AHfmW+lD5OuNv7RpEYCIYQY=;
        b=IVEhNtfUxHbnXV+79++obFgz2UmCG3xI5T0uGIQPYKWjzksZx7JBqnmxf8MhB/OGSRlX1z
        xn63r/HJHeDXxz1bhiIyI4I8ZWp7NSMCu9J4N/MHNakZTPlEA1bwXdWAQbIolydbN3YLl8
        M2P5X9tnq9XxwgNvG1wsZluK6SJzhGg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-121-PZqJk64pNL2buSdbaebS2g-1; Wed, 08 Apr 2020 07:53:20 -0400
X-MC-Unique: PZqJk64pNL2buSdbaebS2g-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 267748017F3;
        Wed,  8 Apr 2020 11:53:18 +0000 (UTC)
Received: from firesoul.localdomain (unknown [10.40.208.40])
        by smtp.corp.redhat.com (Postfix) with ESMTP id CC0791001938;
        Wed,  8 Apr 2020 11:53:12 +0000 (UTC)
Received: from [192.168.42.3] (localhost [IPv6:::1])
        by firesoul.localdomain (Postfix) with ESMTP id E650A300020FB;
        Wed,  8 Apr 2020 13:53:11 +0200 (CEST)
Subject: [PATCH RFC v2 31/33] bpf: add xdp.frame_sz in
 bpf_prog_test_run_xdp().
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
Date:   Wed, 08 Apr 2020 13:53:11 +0200
Message-ID: <158634679187.707275.8614666114354672642.stgit@firesoul>
In-Reply-To: <158634658714.707275.7903484085370879864.stgit@firesoul>
References: <158634658714.707275.7903484085370879864.stgit@firesoul>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Update the memory requirements, when adding xdp.frame_sz in BPF test_run
function bpf_prog_test_run_xdp() which e.g. is used by XDP selftests.

Specifically add the expected reserved tailroom, but also allocated a
larger memory area to reflect that XDP frames usually comes in this
format. Limit the provided packet data size to 4096 minus headroom +
tailroom, as this also reflect a common 3520 bytes MTU limit with XDP.

Note that bpf_test_init already use a memory allocation method that clears
memory.  Thus, this already guards against leaking uninit kernel memory.

Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
---
 net/bpf/test_run.c |   16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

diff --git a/net/bpf/test_run.c b/net/bpf/test_run.c
index 29dbdd4c29f6..30ba7d38941d 100644
--- a/net/bpf/test_run.c
+++ b/net/bpf/test_run.c
@@ -470,25 +470,34 @@ int bpf_prog_test_run_skb(struct bpf_prog *prog, const union bpf_attr *kattr,
 int bpf_prog_test_run_xdp(struct bpf_prog *prog, const union bpf_attr *kattr,
 			  union bpf_attr __user *uattr)
 {
+	u32 tailroom = SKB_DATA_ALIGN(sizeof(struct skb_shared_info));
+	u32 headroom = XDP_PACKET_HEADROOM;
 	u32 size = kattr->test.data_size_in;
 	u32 repeat = kattr->test.repeat;
 	struct netdev_rx_queue *rxqueue;
 	struct xdp_buff xdp = {};
 	u32 retval, duration;
+	u32 max_data_sz;
 	void *data;
 	int ret;
 
 	if (kattr->test.ctx_in || kattr->test.ctx_out)
 		return -EINVAL;
 
-	data = bpf_test_init(kattr, size, XDP_PACKET_HEADROOM + NET_IP_ALIGN, 0);
+	/* XDP have extra tailroom as (most) drivers use full page */
+	max_data_sz = 4096 - headroom - tailroom;
+	if (size > max_data_sz)
+		return -EINVAL;
+
+	data = bpf_test_init(kattr, max_data_sz, headroom, tailroom);
 	if (IS_ERR(data))
 		return PTR_ERR(data);
 
 	xdp.data_hard_start = data;
-	xdp.data = data + XDP_PACKET_HEADROOM + NET_IP_ALIGN;
+	xdp.data = data + headroom;
 	xdp.data_meta = xdp.data;
 	xdp.data_end = xdp.data + size;
+	xdp.frame_sz = headroom + max_data_sz + tailroom;
 
 	rxqueue = __netif_get_rx_queue(current->nsproxy->net_ns->loopback_dev, 0);
 	xdp.rxq = &rxqueue->xdp_rxq;
@@ -496,8 +505,7 @@ int bpf_prog_test_run_xdp(struct bpf_prog *prog, const union bpf_attr *kattr,
 	ret = bpf_test_run(prog, &xdp, repeat, &retval, &duration, true);
 	if (ret)
 		goto out;
-	if (xdp.data != data + XDP_PACKET_HEADROOM + NET_IP_ALIGN ||
-	    xdp.data_end != xdp.data + size)
+	if (xdp.data != data + headroom || xdp.data_end != xdp.data + size)
 		size = xdp.data_end - xdp.data;
 	ret = bpf_test_finish(kattr, uattr, xdp.data, size, retval, duration);
 out:


