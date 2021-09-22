Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7382F41430E
	for <lists+netdev@lfdr.de>; Wed, 22 Sep 2021 09:57:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233442AbhIVH6c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Sep 2021 03:58:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233529AbhIVH6Z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Sep 2021 03:58:25 -0400
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E42EC061764;
        Wed, 22 Sep 2021 00:56:54 -0700 (PDT)
Received: by mail-wr1-x42d.google.com with SMTP id d6so4018427wrc.11;
        Wed, 22 Sep 2021 00:56:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=xQ3j+gm5mNnCepQPddJli3oJUFEqEk+hChC7iEMm+lI=;
        b=lsfUb5G3CL0IrrysqvkMIwaMQHITP3EgDKts7TSyUv5bCiL2qNHvgjE2Mi8Lk+BbxU
         0QGtDX6waiQg+WemoP+mNS7jwA2047+G5OE5k/LrU/5Wwl1dKo8HybtrDyXbxRuquN2X
         nIKLFjiVqnDOluio5v1bFfiAxbwfWwrwryHe0aNPWotHHwPHJfqS7pQoXZS71G/TkEun
         BHZ6umHwaLn03khYdTHxYQGBtPOckIzoE2eZka5eeu1VJhKpzbeEeNKB6EhKb5ud4L9Q
         fneky6lcDv7VZDpgSj5iu8Eb5spmbuJmFFRvdr+sWKdxbiIy+HhKzs8i+mFphy0ww74J
         vQ5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=xQ3j+gm5mNnCepQPddJli3oJUFEqEk+hChC7iEMm+lI=;
        b=58CjedX3ytsZ8wF/RcgGaOT3/EaDMf1Rslw0MBi38mv5dsZWDZBCQ0ordbI5f1kzM/
         lnPzv1FSIMbyL6CfiVUK7+yKMWE7kLJUuov7h7ao1IpCMrQckUw5k3cRyjzR+XCC0UWB
         NYt93aVYzV/gTIQH0KHN2trdaZpBKigwyjBvVje6GRN4iSjB+Tx1Z8POKobdRMkAqkp9
         9JYSsyVReVNmVfEbEL3O5mdEbetY28wF7rCcSwsvoHqaISwZtenSsBgkyONyJhyIhEko
         +SWe4oEgKVDmm7PsZMRP80eVlz5ElVlKMzYUTQ/1OyFKfEH+qT83NwynF3pOHXVNodD1
         vr5w==
X-Gm-Message-State: AOAM531nA7JVNO2u9TJ6qGPdrtoAtUYYDYVxvj65FRodKxf8LIITVmn0
        pWzeXVhpYQSDSodaiWuvl2sffdrA0PVZxBBM
X-Google-Smtp-Source: ABdhPJwr2VxXkWj+COfMFQCm5bl0XbNkutfiZCQ2ACfWw0Aw4hKes1cyPjWda/ftH9aqStXC2XimNQ==
X-Received: by 2002:adf:ebcd:: with SMTP id v13mr39800269wrn.400.1632297413029;
        Wed, 22 Sep 2021 00:56:53 -0700 (PDT)
Received: from localhost.localdomain (h-46-59-47-246.A165.priv.bahnhof.se. [46.59.47.246])
        by smtp.gmail.com with ESMTPSA id j7sm1673087wrr.27.2021.09.22.00.56.51
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 22 Sep 2021 00:56:52 -0700 (PDT)
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
To:     magnus.karlsson@intel.com, bjorn@kernel.org, ast@kernel.org,
        daniel@iogearbox.net, netdev@vger.kernel.org,
        maciej.fijalkowski@intel.com, ciara.loftus@intel.com
Cc:     jonathan.lemon@gmail.com, bpf@vger.kernel.org,
        anthony.l.nguyen@intel.com
Subject: [PATCH bpf-next 08/13] selftests: xsk: put the same buffer only once in the fill ring
Date:   Wed, 22 Sep 2021 09:56:08 +0200
Message-Id: <20210922075613.12186-9-magnus.karlsson@gmail.com>
X-Mailer: git-send-email 2.29.0
In-Reply-To: <20210922075613.12186-1-magnus.karlsson@gmail.com>
References: <20210922075613.12186-1-magnus.karlsson@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Magnus Karlsson <magnus.karlsson@intel.com>

Fix a problem where the fill ring was populated with too many
entries. If number of buffers in the umem was smaller than the fill
ring size, the code used to loop over from the beginning of the umem
and start putting the same buffers in again. This is racy indeed as a
later packet can be received overwriting an earlier one before the Rx
thread manages to validate it.

Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
---
 tools/testing/selftests/bpf/xdpxceiver.c | 17 +++++++++++------
 1 file changed, 11 insertions(+), 6 deletions(-)

diff --git a/tools/testing/selftests/bpf/xdpxceiver.c b/tools/testing/selftests/bpf/xdpxceiver.c
index 97591e2a69f7..c5c68b860ae0 100644
--- a/tools/testing/selftests/bpf/xdpxceiver.c
+++ b/tools/testing/selftests/bpf/xdpxceiver.c
@@ -977,13 +977,18 @@ static void *worker_testapp_validate_tx(void *arg)
 
 static void xsk_populate_fill_ring(struct xsk_umem_info *umem, struct pkt_stream *pkt_stream)
 {
-	u32 idx = 0, i;
+	u32 idx = 0, i, buffers_to_fill;
 	int ret;
 
-	ret = xsk_ring_prod__reserve(&umem->fq, XSK_RING_PROD__DEFAULT_NUM_DESCS, &idx);
-	if (ret != XSK_RING_PROD__DEFAULT_NUM_DESCS)
+	if (umem->num_frames < XSK_RING_PROD__DEFAULT_NUM_DESCS)
+		buffers_to_fill = umem->num_frames;
+	else
+		buffers_to_fill = XSK_RING_PROD__DEFAULT_NUM_DESCS;
+
+	ret = xsk_ring_prod__reserve(&umem->fq, buffers_to_fill, &idx);
+	if (ret != buffers_to_fill)
 		exit_with_error(ENOSPC);
-	for (i = 0; i < XSK_RING_PROD__DEFAULT_NUM_DESCS; i++) {
+	for (i = 0; i < buffers_to_fill; i++) {
 		u64 addr;
 
 		if (pkt_stream->use_addr_for_fill) {
@@ -993,12 +998,12 @@ static void xsk_populate_fill_ring(struct xsk_umem_info *umem, struct pkt_stream
 				break;
 			addr = pkt->addr;
 		} else {
-			addr = (i % umem->num_frames) * umem->frame_size + DEFAULT_OFFSET;
+			addr = i * umem->frame_size + DEFAULT_OFFSET;
 		}
 
 		*xsk_ring_prod__fill_addr(&umem->fq, idx++) = addr;
 	}
-	xsk_ring_prod__submit(&umem->fq, XSK_RING_PROD__DEFAULT_NUM_DESCS);
+	xsk_ring_prod__submit(&umem->fq, buffers_to_fill);
 }
 
 static void *worker_testapp_validate_rx(void *arg)
-- 
2.29.0

