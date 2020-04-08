Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7B9351A2036
	for <lists+netdev@lfdr.de>; Wed,  8 Apr 2020 13:51:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728659AbgDHLvT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Apr 2020 07:51:19 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:40966 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728648AbgDHLvS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Apr 2020 07:51:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1586346677;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=NDjKx6IwnF/NmrEYCxfuH2dwTT6/S8zsEJsWIeaXprg=;
        b=EN51ivSCtI5EW4wxF5ss9MrvHvtzkSHddbV7kLlfwL0SmGqu+f4kb6nhBznOEppks2h2MB
        yzaGikmA0PrlRk1SNAduBdCwCtO2R8MqwQ1CKZcnhAJ5LysECcP68hN7B4CoWnHR81cjx5
        OAu/HrEKZpDYOlUZWIaBiQ8b8qj/wdM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-246-abD4zobdP5eA8qu5LJhn0Q-1; Wed, 08 Apr 2020 07:51:13 -0400
X-MC-Unique: abD4zobdP5eA8qu5LJhn0Q-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 396AE100DFC9;
        Wed,  8 Apr 2020 11:51:11 +0000 (UTC)
Received: from firesoul.localdomain (unknown [10.40.208.40])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D88E85C28F;
        Wed,  8 Apr 2020 11:51:10 +0000 (UTC)
Received: from [192.168.42.3] (localhost [IPv6:::1])
        by firesoul.localdomain (Postfix) with ESMTP id E5283300020FC;
        Wed,  8 Apr 2020 13:51:09 +0200 (CEST)
Subject: [PATCH RFC v2 07/33] xdp: xdp_frame add member frame_sz and handle in
 convert_to_xdp_frame
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
Date:   Wed, 08 Apr 2020 13:51:09 +0200
Message-ID: <158634666986.707275.3125872827455406207.stgit@firesoul>
In-Reply-To: <158634658714.707275.7903484085370879864.stgit@firesoul>
References: <158634658714.707275.7903484085370879864.stgit@firesoul>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use hole in struct xdp_frame, when adding member frame_sz, which keeps
same sizeof struct (32 bytes)

Drivers ixgbe and sfc had bug cases where the necessary/expected
tailroom was not reserved. This can lead to some hard to catch memory
corruption issues. Having the drivers frame_sz this can be detected when
packet length/end via xdp->data_end exceed the xdp_data_hard_end
pointer, which accounts for the reserved the tailroom.

When detecting this driver issue, simply fail the conversion with NULL,
which results in feedback to driver (failing xdp_do_redirect()) causing
driver to drop packet. Given the lack of consistent XDP stats, this can
be hard to troubleshoot. And given this is a driver bug, we want to
generate some more noise in form of a WARN stack dump (to ID the driver
code that inlined convert_to_xdp_frame).

Inlining the WARN macro is problematic, because it adds an asm
instruction (on Intel CPUs ud2) what influence instruction cache
prefetching. Thus, introduce xdp_warn and macro XDP_WARN, to avoid this
and at the same time make identifying the function and line of this
inlined function easier.

Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
---
 include/net/xdp.h |   14 +++++++++++++-
 net/core/xdp.c    |    7 +++++++
 2 files changed, 20 insertions(+), 1 deletion(-)

diff --git a/include/net/xdp.h b/include/net/xdp.h
index 99f4374f6214..55a885aa4e53 100644
--- a/include/net/xdp.h
+++ b/include/net/xdp.h
@@ -93,7 +93,8 @@ struct xdp_frame {
 	void *data;
 	u16 len;
 	u16 headroom;
-	u16 metasize;
+	u32 metasize:8;
+	u32 frame_sz:24;
 	/* Lifetime of xdp_rxq_info is limited to NAPI/enqueue time,
 	 * while mem info is valid on remote CPU.
 	 */
@@ -108,6 +109,10 @@ static inline void xdp_scrub_frame(struct xdp_frame *frame)
 	frame->dev_rx = NULL;
 }
 
+/* Avoids inlining WARN macro in fast-path */
+void xdp_warn(const char* msg, const char* func, const int line);
+#define XDP_WARN(msg) xdp_warn(msg, __func__, __LINE__)
+
 struct xdp_frame *xdp_convert_zc_to_xdp_frame(struct xdp_buff *xdp);
 
 /* Convert xdp_buff to xdp_frame */
@@ -128,6 +133,12 @@ struct xdp_frame *convert_to_xdp_frame(struct xdp_buff *xdp)
 	if (unlikely((headroom - metasize) < sizeof(*xdp_frame)))
 		return NULL;
 
+	/* Catch if driver didn't reserve tailroom for skb_shared_info */
+	if (unlikely(xdp->data_end > xdp_data_hard_end(xdp))) {
+		XDP_WARN("Driver BUG: missing reserved tailroom");
+		return NULL;
+	}
+
 	/* Store info in top of packet */
 	xdp_frame = xdp->data_hard_start;
 
@@ -135,6 +146,7 @@ struct xdp_frame *convert_to_xdp_frame(struct xdp_buff *xdp)
 	xdp_frame->len  = xdp->data_end - xdp->data;
 	xdp_frame->headroom = headroom - sizeof(*xdp_frame);
 	xdp_frame->metasize = metasize;
+	xdp_frame->frame_sz = xdp->frame_sz;
 
 	/* rxq only valid until napi_schedule ends, convert to xdp_mem_info */
 	xdp_frame->mem = xdp->rxq->mem;
diff --git a/net/core/xdp.c b/net/core/xdp.c
index 4c7ea85486af..4bc3026ae218 100644
--- a/net/core/xdp.c
+++ b/net/core/xdp.c
@@ -11,6 +11,7 @@
 #include <linux/slab.h>
 #include <linux/idr.h>
 #include <linux/rhashtable.h>
+#include <linux/bug.h>
 #include <net/page_pool.h>
 
 #include <net/xdp.h>
@@ -496,3 +497,9 @@ struct xdp_frame *xdp_convert_zc_to_xdp_frame(struct xdp_buff *xdp)
 	return xdpf;
 }
 EXPORT_SYMBOL_GPL(xdp_convert_zc_to_xdp_frame);
+
+/* Used by XDP_WARN macro, to avoid inlining WARN() in fast-path */
+void xdp_warn(const char* msg, const char* func, const int line) {
+	WARN(1, "XDP_WARN: %s(line:%d): %s\n", func, line, msg);
+};
+EXPORT_SYMBOL_GPL(xdp_warn);


