Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 633735B091B
	for <lists+netdev@lfdr.de>; Wed,  7 Sep 2022 17:47:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229983AbiIGPrM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Sep 2022 11:47:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230019AbiIGPqw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Sep 2022 11:46:52 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E227BB95A7
        for <netdev@vger.kernel.org>; Wed,  7 Sep 2022 08:46:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1662565596;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=RpZB9X0DET31F7pJclkQNUipKM0FnFOUPz4JB+ooQnY=;
        b=WBjf/fOrIRRZbWK8IXtGipUjEIhFd7vCGWrF64FDKYuoQA6xH31PpU4HbR2uOXRJo8c2hg
        5PEMIgDYBKs9D1m9TujwuYgbwx8IADGR88SJb5ZiJoS04CTdP/XlWtF2OsjaIYLq135yzJ
        bPE7DBjbW1ImfS1vr3am61BUxmqPGCA=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-554-pSXxsqiNPUWLKJjMVin8Pg-1; Wed, 07 Sep 2022 11:46:33 -0400
X-MC-Unique: pSXxsqiNPUWLKJjMVin8Pg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E15878039B2;
        Wed,  7 Sep 2022 15:46:32 +0000 (UTC)
Received: from firesoul.localdomain (unknown [10.40.208.22])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A63C6C15BB3;
        Wed,  7 Sep 2022 15:46:32 +0000 (UTC)
Received: from [192.168.42.3] (localhost [IPv6:::1])
        by firesoul.localdomain (Postfix) with ESMTP id A37D430721A6C;
        Wed,  7 Sep 2022 17:46:31 +0200 (CEST)
Subject: [PATCH RFCv2 bpf-next 18/18] ixgbe: AF_XDP xdp-hints processing in
 ixgbe_clean_rx_irq_zc
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
Date:   Wed, 07 Sep 2022 17:46:31 +0200
Message-ID: <166256559162.1434226.13443800671075647862.stgit@firesoul>
In-Reply-To: <166256538687.1434226.15760041133601409770.stgit@firesoul>
References: <166256538687.1434226.15760041133601409770.stgit@firesoul>
User-Agent: StGit/1.4
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
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

Add XDP-hints processing to the AF_XDP zero-copy code path.

Signed-off-by: Maryam Tahhan <mtahhan@redhat.com>
Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
---
 drivers/net/ethernet/intel/ixgbe/ixgbe.h      |    3 +++
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c |    4 ++--
 drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c  |    2 ++
 3 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe.h b/drivers/net/ethernet/intel/ixgbe/ixgbe.h
index 97b3fbd2de28..22eddadb3f7c 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe.h
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe.h
@@ -1025,6 +1025,9 @@ void ixgbe_ptp_rx_pktstamp(struct ixgbe_q_vector *, struct sk_buff *);
 void ixgbe_ptp_rx_rgtstamp(struct ixgbe_q_vector *, struct sk_buff *skb);
 u64 ixgbe_ptp_convert_to_hwtstamp(struct ixgbe_adapter *adapter, u64 timestamp);
 u64 ixgbe_ptp_rx_hwtstamp_raw(struct ixgbe_adapter *adapter);
+inline void ixgbe_process_xdp_hints(struct ixgbe_ring *ring,
+						union ixgbe_adv_rx_desc *rx_desc,
+						struct xdp_buff *xdp);
 static inline void ixgbe_ptp_rx_hwtstamp(struct ixgbe_ring *rx_ring,
 					 union ixgbe_adv_rx_desc *rx_desc,
 					 struct sk_buff *skb)
diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
index dc371b4c65bb..18f00f2bacaf 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
@@ -1798,7 +1798,7 @@ static inline u32 ixgbe_rx_hash_xdp(struct ixgbe_ring *ring,
 	return flags;
 }
 
-static inline void ixgbe_process_xdp_hints(struct ixgbe_ring *ring,
+inline void ixgbe_process_xdp_hints(struct ixgbe_ring *ring,
 						union ixgbe_adv_rx_desc *rx_desc,
 						struct xdp_buff *xdp)
 {
@@ -2395,7 +2395,7 @@ static struct sk_buff *ixgbe_run_xdp(struct ixgbe_adapter *adapter,
 	return ERR_PTR(-result);
 }
 
-static unsigned int ixgbe_rx_frame_truesize(struct ixgbe_ring *rx_ring,
+static inline unsigned int ixgbe_rx_frame_truesize(struct ixgbe_ring *rx_ring,
 					    unsigned int size)
 {
 	unsigned int truesize;
diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c
index 1703c640a434..c3fb8f7660df 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c
@@ -304,7 +304,9 @@ int ixgbe_clean_rx_irq_zc(struct ixgbe_q_vector *q_vector,
 		}
 
 		bi->xdp->data_end = bi->xdp->data + size;
+		ixgbe_process_xdp_hints(rx_ring, rx_desc, bi->xdp);
 		xsk_buff_dma_sync_for_cpu(bi->xdp, rx_ring->xsk_pool);
+
 		xdp_res = ixgbe_run_xdp_zc(adapter, rx_ring, bi->xdp);
 
 		if (likely(xdp_res & (IXGBE_XDP_TX | IXGBE_XDP_REDIR))) {


