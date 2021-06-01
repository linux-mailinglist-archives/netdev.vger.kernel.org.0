Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C84C9396D7B
	for <lists+netdev@lfdr.de>; Tue,  1 Jun 2021 08:40:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232935AbhFAGlq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Jun 2021 02:41:46 -0400
Received: from out30-44.freemail.mail.aliyun.com ([115.124.30.44]:54865 "EHLO
        out30-44.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232725AbhFAGlo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Jun 2021 02:41:44 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R581e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04420;MF=xuanzhuo@linux.alibaba.com;NM=1;PH=DS;RN=12;SR=0;TI=SMTPD_---0Uaqwlqf_1622529601;
Received: from localhost(mailfrom:xuanzhuo@linux.alibaba.com fp:SMTPD_---0Uaqwlqf_1622529601)
          by smtp.aliyun-inc.com(127.0.0.1);
          Tue, 01 Jun 2021 14:40:01 +0800
From:   Xuan Zhuo <xuanzhuo@linux.alibaba.com>
To:     netdev@vger.kernel.org, Jason Wang <jasowang@redhat.com>
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
        virtualization@lists.linux-foundation.org, bpf@vger.kernel.org
Subject: [PATCH net v2 2/2] virtio_net: get build_skb() buf by data ptr
Date:   Tue,  1 Jun 2021 14:40:00 +0800
Message-Id: <20210601064000.66909-3-xuanzhuo@linux.alibaba.com>
X-Mailer: git-send-email 2.31.0
In-Reply-To: <20210601064000.66909-1-xuanzhuo@linux.alibaba.com>
References: <20210601064000.66909-1-xuanzhuo@linux.alibaba.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In the case of merge, the page passed into page_to_skb() may be a head
page, not the page where the current data is located. So when trying to
get the buf where the data is located, we should get buf based on
headroom instead of offset.

This patch solves this problem. But if you don't use this patch, the
original code can also run, because if the page is not the page of the
current data, the calculated tailroom will be less than 0, and will not
enter the logic of build_skb() . The significance of this patch is to
modify this logical problem, allowing more situations to use
build_skb().

Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
---
 drivers/net/virtio_net.c | 17 ++++++-----------
 1 file changed, 6 insertions(+), 11 deletions(-)

diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index 6b929aca155a..fa407eb8b457 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -401,18 +401,13 @@ static struct sk_buff *page_to_skb(struct virtnet_info *vi,
 	/* If headroom is not 0, there is an offset between the beginning of the
 	 * data and the allocated space, otherwise the data and the allocated
 	 * space are aligned.
+	 *
+	 * Buffers with headroom use PAGE_SIZE as alloc size, see
+	 * add_recvbuf_mergeable() + get_mergeable_buf_len()
 	 */
-	if (headroom) {
-		/* Buffers with headroom use PAGE_SIZE as alloc size,
-		 * see add_recvbuf_mergeable() + get_mergeable_buf_len()
-		 */
-		truesize = PAGE_SIZE;
-		tailroom = truesize - len - offset;
-		buf = page_address(page);
-	} else {
-		tailroom = truesize - len;
-		buf = p;
-	}
+	truesize = headroom ? PAGE_SIZE : truesize;
+	tailroom = truesize - len - headroom;
+	buf = p - headroom;
 
 	len -= hdr_len;
 	offset += hdr_padded_len;
-- 
2.31.0

