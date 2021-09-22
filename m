Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6AAA8414318
	for <lists+netdev@lfdr.de>; Wed, 22 Sep 2021 09:57:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233360AbhIVH6m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Sep 2021 03:58:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233577AbhIVH6c (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Sep 2021 03:58:32 -0400
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7DFDDC0613E3;
        Wed, 22 Sep 2021 00:57:00 -0700 (PDT)
Received: by mail-wr1-x434.google.com with SMTP id t18so4316456wrb.0;
        Wed, 22 Sep 2021 00:57:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=hE7wLYt6S0eWPxLVOXggLGnZBoU+LaQoXkdBXrdKzPE=;
        b=B9i91TF2Gc1eE5f/AhvPZCz+AtgRInom4SOJpwRm18MVzf3TSGoS/S2TiE5jppZo/5
         kLdTTFQLCurwhvCbiRngBCbsiY0x23L6HXuczPKx+aD/18HkFgln3axJEtw98P+Dai7U
         hY7alVisU+eG54zzpuv5G+PzvZRiqMXNnGfCZoJo6oRFJlkDhf3Op1wBp44U1BOSbxcj
         tSSWlk1P2myVQqZMlxWKB9yjMWAVnk7bxDEpqZiB7B5E12a4g/9+LusBUnn+5oZV8WM3
         kXyfQobtmm0brHrvJNO5RaZlay/0pZPbKrkSUHo3P3y8PVFGzcs22pZvhekyzgF4gZJt
         LFDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=hE7wLYt6S0eWPxLVOXggLGnZBoU+LaQoXkdBXrdKzPE=;
        b=KJkrpy6QFmXpKX3kpGh4b49sXocw29J9Hb0dsN7X8u8g3doAmDPmjc/FlFErBBz72S
         0KrkGN00HGKOH9CsLG397n6UE9APjmOEArswNHqIEJhWPpzMqZwDBtiwWoNMEiSuKnYz
         1yCBd9xD0A/umURtGOKiDz/wa8k47yiCi4J76ZkuBVNQinV4Ev6TxMtCoTAuy6zWTCyp
         +oOciNbxlujap1jq771pco3IvKst4ZeVrLahalAA8aCxIU98jhTR8xDlHYLyCuow8wtj
         DQwVDHmh8A+2izw4B+9K3PFVszKHdzdZu2Xm26yfUd/e3MxOeSxnvuuM3Kk7PesI+5Iq
         IE4A==
X-Gm-Message-State: AOAM532gbowyCxART16gArKP/NYZ9l1HTGS0J0tyFwFA/7TXKrupCuXR
        XtyB1nLMswoXbTjHvol5H32WXBeKzMMd5V1A
X-Google-Smtp-Source: ABdhPJyeP4X/wjuMypYXc346j+Qm+YXZ4Clpi4+VXI6Vmn7WIt1dK6MErRftEh7XmzblQi5CQPYUqw==
X-Received: by 2002:a5d:6d8a:: with SMTP id l10mr40271262wrs.121.1632297418622;
        Wed, 22 Sep 2021 00:56:58 -0700 (PDT)
Received: from localhost.localdomain (h-46-59-47-246.A165.priv.bahnhof.se. [46.59.47.246])
        by smtp.gmail.com with ESMTPSA id j7sm1673087wrr.27.2021.09.22.00.56.57
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 22 Sep 2021 00:56:58 -0700 (PDT)
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
To:     magnus.karlsson@intel.com, bjorn@kernel.org, ast@kernel.org,
        daniel@iogearbox.net, netdev@vger.kernel.org,
        maciej.fijalkowski@intel.com, ciara.loftus@intel.com
Cc:     jonathan.lemon@gmail.com, bpf@vger.kernel.org,
        anthony.l.nguyen@intel.com
Subject: [PATCH bpf-next 12/13] selftests: xsk: change interleaving of packets in unaligned mode
Date:   Wed, 22 Sep 2021 09:56:12 +0200
Message-Id: <20210922075613.12186-13-magnus.karlsson@gmail.com>
X-Mailer: git-send-email 2.29.0
In-Reply-To: <20210922075613.12186-1-magnus.karlsson@gmail.com>
References: <20210922075613.12186-1-magnus.karlsson@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Magnus Karlsson <magnus.karlsson@intel.com>

Change the interleaving of packets in unaligned mode. With the current
buffer addresses in the packet stream, the last buffer in the umem
could not be used as a large packet could potentially write over the
end of the umem. The kernel correctly threw this buffer address away
and refused to use it. This is perfectly fine for all regular packet
streams, but the ones used for unaligned mode have every other packet
being at some different offset. As we will add checks for correct
offsets in the next patch, this needs to be fixed. Just start these
page-boundary straddling buffers one page earlier so that the last
one is not on the last page of the umem, making all buffers valid.

Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
---
 tools/testing/selftests/bpf/xdpxceiver.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/bpf/xdpxceiver.c b/tools/testing/selftests/bpf/xdpxceiver.c
index 3beea7531c8e..fd620f8accfd 100644
--- a/tools/testing/selftests/bpf/xdpxceiver.c
+++ b/tools/testing/selftests/bpf/xdpxceiver.c
@@ -543,14 +543,14 @@ static void pkt_stream_replace(struct test_spec *test, u32 nb_pkts, u32 pkt_len)
 	test->ifobj_rx->pkt_stream = pkt_stream;
 }
 
-static void pkt_stream_replace_half(struct test_spec *test, u32 pkt_len, u32 offset)
+static void pkt_stream_replace_half(struct test_spec *test, u32 pkt_len, int offset)
 {
 	struct xsk_umem_info *umem = test->ifobj_tx->umem;
 	struct pkt_stream *pkt_stream;
 	u32 i;
 
 	pkt_stream = pkt_stream_clone(umem, test->pkt_stream_default);
-	for (i = 0; i < test->pkt_stream_default->nb_pkts; i += 2) {
+	for (i = 1; i < test->pkt_stream_default->nb_pkts; i += 2) {
 		pkt_stream->pkts[i].addr = (i % umem->num_frames) * umem->frame_size + offset;
 		pkt_stream->pkts[i].len = pkt_len;
 	}
@@ -1209,7 +1209,7 @@ static bool testapp_unaligned(struct test_spec *test)
 	test->ifobj_tx->umem->unaligned_mode = true;
 	test->ifobj_rx->umem->unaligned_mode = true;
 	/* Let half of the packets straddle a buffer boundrary */
-	pkt_stream_replace_half(test, PKT_SIZE, test->ifobj_tx->umem->frame_size - 32);
+	pkt_stream_replace_half(test, PKT_SIZE, -PKT_SIZE / 2);
 	test->ifobj_rx->pkt_stream->use_addr_for_fill = true;
 	testapp_validate_traffic(test);
 
-- 
2.29.0

