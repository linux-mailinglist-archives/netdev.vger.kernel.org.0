Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EE40D188C02
	for <lists+netdev@lfdr.de>; Tue, 17 Mar 2020 18:29:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726550AbgCQR3X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Mar 2020 13:29:23 -0400
Received: from us-smtp-delivery-74.mimecast.com ([216.205.24.74]:24674 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726386AbgCQR3X (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Mar 2020 13:29:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1584466161;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=2eXzQtSYdeTw5pRT+LOtyhNeBfnI40tGkZtZgT4bf9k=;
        b=CuwA65ApuGvU88Q7RSzdo4XdvwO5Y1rPpYSMK6Lk8+r1lgXROdFtWVzUpIe5tORN5tli2J
        Qofetai29OFVI40tlEpxnz5b7F2z5BiQVuMWnBxinCyqcmmfqvFzaC+6njHFDaQD3dE1fW
        iTcdV2kCXyEjIFvEjVdrLfwGUyJf9O8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-457-iEtUXIaaMICncPlOobuNEg-1; Tue, 17 Mar 2020 13:29:16 -0400
X-MC-Unique: iEtUXIaaMICncPlOobuNEg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 608EA92A64;
        Tue, 17 Mar 2020 17:29:14 +0000 (UTC)
Received: from firesoul.localdomain (unknown [10.40.208.26])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C3D323A4;
        Tue, 17 Mar 2020 17:29:13 +0000 (UTC)
Received: from [192.168.42.3] (localhost [IPv6:::1])
        by firesoul.localdomain (Postfix) with ESMTP id C31DC30740457;
        Tue, 17 Mar 2020 18:29:12 +0100 (CET)
Subject: [PATCH RFC v1 01/15] xdp: add frame size to xdp_buff
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     sameehj@amazon.com
Cc:     Jesper Dangaard Brouer <brouer@redhat.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, zorik@amazon.com, akiyano@amazon.com,
        gtzalik@amazon.com,
        =?utf-8?q?Toke_H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>,
        Daniel Borkmann <borkmann@iogearbox.net>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        David Ahern <dsahern@gmail.com>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Lorenzo Bianconi <lorenzo@kernel.org>
Date:   Tue, 17 Mar 2020 18:29:12 +0100
Message-ID: <158446615272.702578.2884467013936153419.stgit@firesoul>
In-Reply-To: <158446612466.702578.2795159620575737080.stgit@firesoul>
References: <158446612466.702578.2795159620575737080.stgit@firesoul>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
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
 include/net/xdp.h |   17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/include/net/xdp.h b/include/net/xdp.h
index 40c6d3398458..99f4374f6214 100644
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
@@ -70,8 +72,23 @@ struct xdp_buff {
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
+/* Like skb_shinfo */
+#define xdp_shinfo(xdp)	((struct skb_shared_info *)(xdp_data_hard_end(xdp)))
+// XXX: Above likely belongs in later patch
+
 struct xdp_frame {
 	void *data;
 	u16 len;


