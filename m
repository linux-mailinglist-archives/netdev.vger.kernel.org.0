Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EBD311B4999
	for <lists+netdev@lfdr.de>; Wed, 22 Apr 2020 18:07:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726670AbgDVQHl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Apr 2020 12:07:41 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:55979 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726381AbgDVQHl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Apr 2020 12:07:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1587571659;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=qVN5D4k6CPXm/CsTfZRedU5FchFYXq2H0A5tWQjBfY8=;
        b=CAUUzF+2NiBUwm+GxEOgTnzInJLud6v0msD1649xk0u23eT+PYsZuex7KKqTFaPhi3bsZA
        Khtk+XpMHb5wUDziPOFgcMhOJd7eR1JjLtQ392wCTxNqLS0FK0PSKLecfmVq4kJCkjyW49
        gajOnE/zMlE7gf/oStuR55bZK61smew=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-206-YV49HgVKNa-_S5jl1L2EyQ-1; Wed, 22 Apr 2020 12:07:35 -0400
X-MC-Unique: YV49HgVKNa-_S5jl1L2EyQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7F09D107ACC7;
        Wed, 22 Apr 2020 16:07:33 +0000 (UTC)
Received: from firesoul.localdomain (unknown [10.40.208.3])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0EBBF5C541;
        Wed, 22 Apr 2020 16:07:27 +0000 (UTC)
Received: from [192.168.42.3] (localhost [IPv6:::1])
        by firesoul.localdomain (Postfix) with ESMTP id 2FE9930000E43;
        Wed, 22 Apr 2020 18:07:26 +0200 (CEST)
Subject: [PATCH net-next 01/33] xdp: add frame size to xdp_buff
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
Date:   Wed, 22 Apr 2020 18:07:26 +0200
Message-ID: <158757164613.1370371.2655437650342381672.stgit@firesoul>
In-Reply-To: <158757160439.1370371.13213378122947426220.stgit@firesoul>
References: <158757160439.1370371.13213378122947426220.stgit@firesoul>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

XDP have evolved to support several frame sizes, but xdp_buff was not
updated with this information. The frame size (frame_sz) member of
xdp_buff is introduced to know the real size of the memory the frame is
delivered in.

When introducing this also make it clear that some tailroom is
reserved/required when creating SKBs using build_skb().

It would also have been an option to introduce a pointer to
data_hard_end (with reserved offset). The advantage with frame_sz is
that (like rxq) drivers only need to setup/assign this value once per
NAPI cycle. Due to XDP-generic (and some drivers) it's not possible to
store frame_sz inside xdp_rxq_info, because it's varies per packet as it
can be based/depend on packet length.

Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
---
 include/net/xdp.h |   13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/include/net/xdp.h b/include/net/xdp.h
index 40c6d3398458..1ccf7df98bee 100644
--- a/include/net/xdp.h
+++ b/include/net/xdp.h
@@ -6,6 +6,8 @@
 #ifndef __LINUX_NET_XDP_H__
 #define __LINUX_NET_XDP_H__
 
+#include <linux/skbuff.h> /* skb_shared_info */
+
 /**
  * DOC: XDP RX-queue information
  *
@@ -70,8 +72,19 @@ struct xdp_buff {
 	void *data_hard_start;
 	unsigned long handle;
 	struct xdp_rxq_info *rxq;
+	u32 frame_sz; /* frame size to deduct data_hard_end/reserved tailroom*/
 };
 
+/* Reserve memory area at end-of data area.
+ *
+ * This macro reserves tailroom in the XDP buffer by limiting the
+ * XDP/BPF data access to data_hard_end.  Notice same area (and size)
+ * is used for XDP_PASS, when constructing the SKB via build_skb().
+ */
+#define xdp_data_hard_end(xdp)				\
+	((xdp)->data_hard_start + (xdp)->frame_sz -	\
+	 SKB_DATA_ALIGN(sizeof(struct skb_shared_info)))
+
 struct xdp_frame {
 	void *data;
 	u16 len;


