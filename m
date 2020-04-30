Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D721A1BF673
	for <lists+netdev@lfdr.de>; Thu, 30 Apr 2020 13:20:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726962AbgD3LUj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Apr 2020 07:20:39 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:38459 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726483AbgD3LUi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Apr 2020 07:20:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588245637;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=O9fQrK3QGrJL4UsVTT1BjsaZ4mQubvGNYU2PTJvcHmE=;
        b=NodTBZlfZ6U/6a2EjalMEyZrU2yx0BzqwK9OlyD1I71uu5aqR1TlBOBiUAr8xGBdYcsMLh
        rvf4u1petJ1sMZkvN7vwi6DMXaXxmR5ymiSfa522bCqelgAzaXLoFFrQ3I3o2hoe2XO86r
        Pj99UEHR6qCC9sey7nR7iiLF/Horr/g=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-353-Lg0IBU8OPOyS0vg36vyxXQ-1; Thu, 30 Apr 2020 07:20:35 -0400
X-MC-Unique: Lg0IBU8OPOyS0vg36vyxXQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4BC2745F;
        Thu, 30 Apr 2020 11:20:33 +0000 (UTC)
Received: from firesoul.localdomain (unknown [10.40.208.4])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 852C7165F6;
        Thu, 30 Apr 2020 11:20:27 +0000 (UTC)
Received: from [192.168.42.3] (localhost [IPv6:::1])
        by firesoul.localdomain (Postfix) with ESMTP id 7D882324DB2C1;
        Thu, 30 Apr 2020 13:20:26 +0200 (CEST)
Subject: [PATCH net-next v2 01/33] xdp: add frame size to xdp_buff
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     sameehj@amazon.com
Cc:     =?utf-8?q?Toke_H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
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
Date:   Thu, 30 Apr 2020 13:20:26 +0200
Message-ID: <158824562644.2172139.9670830558460527639.stgit@firesoul>
In-Reply-To: <158824557985.2172139.4173570969543904434.stgit@firesoul>
References: <158824557985.2172139.4173570969543904434.stgit@firesoul>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Content-Transfer-Encoding: quoted-printable
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

V2: nitpick: deduct -> deduce

Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
Acked-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
---
 include/net/xdp.h |   13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/include/net/xdp.h b/include/net/xdp.h
index 3cc6d5d84aa4..a764af4ae0ea 100644
--- a/include/net/xdp.h
+++ b/include/net/xdp.h
@@ -6,6 +6,8 @@
 #ifndef __LINUX_NET_XDP_H__
 #define __LINUX_NET_XDP_H__
=20
+#include <linux/skbuff.h> /* skb_shared_info */
+
 /**
  * DOC: XDP RX-queue information
  *
@@ -70,8 +72,19 @@ struct xdp_buff {
 	void *data_hard_start;
 	unsigned long handle;
 	struct xdp_rxq_info *rxq;
+	u32 frame_sz; /* frame size to deduce data_hard_end/reserved tailroom*/
 };
=20
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


