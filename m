Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4D1A25B0917
	for <lists+netdev@lfdr.de>; Wed,  7 Sep 2022 17:46:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229863AbiIGPq4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Sep 2022 11:46:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229799AbiIGPqf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Sep 2022 11:46:35 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3A177674A
        for <netdev@vger.kernel.org>; Wed,  7 Sep 2022 08:46:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1662565591;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Z1uHBXgN3LQWGJMOETV0xAA89SFw6+HHNLzEdVhd4bc=;
        b=Wmqw4l1niQoOHaLwqpRuGtDmAi49XEIKak1kR6JVM9xu5pQNm0dPqxgplLqMQtiDBI3xOv
        Ts2vUh8cXdBhLLHTcaUCBDsjJI0axKswtIu4L3H76eeeDN5cydOt57VR4pa1qr2PrKr59I
        jTaJjbt5lvSM7FswDWVL5gvZFqGimqY=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-599-fkIafPXaMWCR--5Do-l_ZQ-1; Wed, 07 Sep 2022 11:46:28 -0400
X-MC-Unique: fkIafPXaMWCR--5Do-l_ZQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D4DFB3C01D8B;
        Wed,  7 Sep 2022 15:46:27 +0000 (UTC)
Received: from firesoul.localdomain (unknown [10.40.208.22])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 97DC290A04;
        Wed,  7 Sep 2022 15:46:27 +0000 (UTC)
Received: from [192.168.42.3] (localhost [IPv6:::1])
        by firesoul.localdomain (Postfix) with ESMTP id 9479D30721A6C;
        Wed,  7 Sep 2022 17:46:26 +0200 (CEST)
Subject: [PATCH RFCv2 bpf-next 17/18] xsk: AF_XDP xdp-hints support in desc
 options
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     bpf@vger.kernel.org
Cc:     Jesper Dangaard Brouer <brouer@redhat.com>, netdev@vger.kernel.org,
        xdp-hints@xdp-project.net, larysa.zaremba@intel.com,
        memxor@gmail.com, Lorenzo Bianconi <lorenzo@kernel.org>,
        mtahhan@redhat.com,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Daniel Borkmann <borkmann@iogearbox.net>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        dave@dtucker.co.uk, Magnus Karlsson <magnus.karlsson@intel.com>,
        bjorn@kernel.org
Date:   Wed, 07 Sep 2022 17:46:26 +0200
Message-ID: <166256558657.1434226.7390735974413846384.stgit@firesoul>
In-Reply-To: <166256538687.1434226.15760041133601409770.stgit@firesoul>
References: <166256538687.1434226.15760041133601409770.stgit@firesoul>
User-Agent: StGit/1.4
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maryam Tahhan <mtahhan@redhat.com>

Simply set AF_XDP descriptor options to XDP flags.

Jesper: Will this really be acceptable by AF_XDP maintainers?

Signed-off-by: Maryam Tahhan <mtahhan@redhat.com>
---
 include/uapi/linux/if_xdp.h |    2 +-
 net/xdp/xsk.c               |    2 +-
 net/xdp/xsk_queue.h         |    3 ++-
 3 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/include/uapi/linux/if_xdp.h b/include/uapi/linux/if_xdp.h
index a78a8096f4ce..9335b56474e7 100644
--- a/include/uapi/linux/if_xdp.h
+++ b/include/uapi/linux/if_xdp.h
@@ -103,7 +103,7 @@ struct xdp_options {
 struct xdp_desc {
 	__u64 addr;
 	__u32 len;
-	__u32 options;
+	__u32 options; /* set to the values of xdp_hints_flags*/
 };
 
 /* UMEM descriptor is __u64 */
diff --git a/net/xdp/xsk.c b/net/xdp/xsk.c
index 5b4ce6ba1bc7..32095d78f06b 100644
--- a/net/xdp/xsk.c
+++ b/net/xdp/xsk.c
@@ -141,7 +141,7 @@ static int __xsk_rcv_zc(struct xdp_sock *xs, struct xdp_buff *xdp, u32 len)
 	int err;
 
 	addr = xp_get_handle(xskb);
-	err = xskq_prod_reserve_desc(xs->rx, addr, len);
+	err = xskq_prod_reserve_desc(xs->rx, addr, len, xdp->flags);
 	if (err) {
 		xs->rx_queue_full++;
 		return err;
diff --git a/net/xdp/xsk_queue.h b/net/xdp/xsk_queue.h
index fb20bf7207cf..7a66f082f97e 100644
--- a/net/xdp/xsk_queue.h
+++ b/net/xdp/xsk_queue.h
@@ -368,7 +368,7 @@ static inline u32 xskq_prod_reserve_addr_batch(struct xsk_queue *q, struct xdp_d
 }
 
 static inline int xskq_prod_reserve_desc(struct xsk_queue *q,
-					 u64 addr, u32 len)
+					 u64 addr, u32 len, u32 flags)
 {
 	struct xdp_rxtx_ring *ring = (struct xdp_rxtx_ring *)q->ring;
 	u32 idx;
@@ -380,6 +380,7 @@ static inline int xskq_prod_reserve_desc(struct xsk_queue *q,
 	idx = q->cached_prod++ & q->ring_mask;
 	ring->desc[idx].addr = addr;
 	ring->desc[idx].len = len;
+	ring->desc[idx].options = flags;
 
 	return 0;
 }


