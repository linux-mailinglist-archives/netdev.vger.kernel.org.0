Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 272D91D2D34
	for <lists+netdev@lfdr.de>; Thu, 14 May 2020 12:49:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726102AbgENKtT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 May 2020 06:49:19 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:25983 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726087AbgENKtS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 May 2020 06:49:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1589453356;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=trPujvYz5SvEy7z1NUQtuAKWwmuh/Ej+2Q+sFIkhFGU=;
        b=hhC4mSE8QbxC3YFRtOPVMtawgZGU0grcy38Hv/tq30xrxuegIelXKPW0QILIklNjGQchoJ
        RfNmuzBwsjMWiOOHCpAlOXv6Zwtvrx2jyHsOsJTtAfo2MQIva7auZUjOVy6pdVIPq0PPVI
        gJH8jQ9zCZGFlpBheotxbZBDJ+b8kso=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-486-mib0L_xdNrudoeOSOF_51Q-1; Thu, 14 May 2020 06:49:13 -0400
X-MC-Unique: mib0L_xdNrudoeOSOF_51Q-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4EE2580B719;
        Thu, 14 May 2020 10:49:11 +0000 (UTC)
Received: from firesoul.localdomain (unknown [10.40.208.32])
        by smtp.corp.redhat.com (Postfix) with ESMTP id CFCFC5D9F3;
        Thu, 14 May 2020 10:49:03 +0000 (UTC)
Received: from [192.168.42.3] (localhost [IPv6:::1])
        by firesoul.localdomain (Postfix) with ESMTP id A64BE325159C9;
        Thu, 14 May 2020 12:49:02 +0200 (CEST)
Subject: [PATCH net-next v4 01/33] xdp: add frame size to xdp_buff
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
Date:   Thu, 14 May 2020 12:49:02 +0200
Message-ID: <158945334261.97035.555255657490688547.stgit@firesoul>
In-Reply-To: <158945314698.97035.5286827951225578467.stgit@firesoul>
References: <158945314698.97035.5286827951225578467.stgit@firesoul>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
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
Acked-by: Toke Høiland-Jørgensen <toke@redhat.com>
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


