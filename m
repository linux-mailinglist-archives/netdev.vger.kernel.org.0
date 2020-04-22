Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 233FB1B49E1
	for <lists+netdev@lfdr.de>; Wed, 22 Apr 2020 18:10:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727116AbgDVQKI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Apr 2020 12:10:08 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:44017 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727105AbgDVQKH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Apr 2020 12:10:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1587571805;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=EfxAyvFhtEeMjfTkBH/0AHfmW+lD5OuNv7RpEYCIYQY=;
        b=O5IbsoWUnFm/q+wsfgLXZdQcGSyWs8gHcu5Z5Q1R48XPsjSiFEq5gZIHripuZY3IYGZ0xQ
        XOdn/22obg5PJjuCPu3vZhckGzKhmFxJ5UATJPSqIZmNydufov2af8Q7JxhoNVkPdEHghX
        TKqsYSpjkrz6MNXLaPHl7OBg2q20/ys=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-405-u2OkTgy3ODCCDss4hr1uPA-1; Wed, 22 Apr 2020 12:10:02 -0400
X-MC-Unique: u2OkTgy3ODCCDss4hr1uPA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id CD9F11005510;
        Wed, 22 Apr 2020 16:09:59 +0000 (UTC)
Received: from firesoul.localdomain (unknown [10.40.208.3])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 77AB660C63;
        Wed, 22 Apr 2020 16:09:59 +0000 (UTC)
Received: from [192.168.42.3] (localhost [IPv6:::1])
        by firesoul.localdomain (Postfix) with ESMTP id 9D36C30000272;
        Wed, 22 Apr 2020 18:09:58 +0200 (CEST)
Subject: [PATCH net-next 31/33] bpf: add xdp.frame_sz in
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
        Saeed Mahameed <saeedm@mellanox.com>,
        steffen.klassert@secunet.com
Date:   Wed, 22 Apr 2020 18:09:58 +0200
Message-ID: <158757179857.1370371.14328542658097773569.stgit@firesoul>
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


