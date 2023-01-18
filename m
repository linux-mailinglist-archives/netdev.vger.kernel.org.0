Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E8D4C67211B
	for <lists+netdev@lfdr.de>; Wed, 18 Jan 2023 16:22:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231513AbjARPWf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Jan 2023 10:22:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230519AbjARPVt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Jan 2023 10:21:49 -0500
Received: from mail-yw1-x1131.google.com (mail-yw1-x1131.google.com [IPv6:2607:f8b0:4864:20::1131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38B85241DA
        for <netdev@vger.kernel.org>; Wed, 18 Jan 2023 07:18:52 -0800 (PST)
Received: by mail-yw1-x1131.google.com with SMTP id 00721157ae682-4d0f843c417so358453277b3.7
        for <netdev@vger.kernel.org>; Wed, 18 Jan 2023 07:18:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=P3woLcZU0M+Ws7f4KlZMW8+JzNL4ekYAVdY+86C0Ih4=;
        b=OJMt0r2GFajH9L77vZVuNc71Qmv1epeaUqQJPEPadLo/DGCuN4NPFzpaRPCOIKlHAh
         2Kxi7VVwkEZNRgi4OZzp5oeYrzTRsojYfvPS9A1i5wotwvi+FQPrVYWLjNLnzUjXoAt4
         s+HiRfwVs9EzJRgOTNTfGqdTSSr0J0NeEc9JfTfhwTMxjdXK7Ygd7v2fVfhi0+FEYAgT
         JOEVRscrIo9tNSS38fKa1RYbvPlaSDT2yyGdFMB9TWaroGTzLc/ZIRJAAHzT9ZrNPvxy
         Yvrbi/9x9/Koma4Z5qsTdIs0K0AR39xhjEs+vGjvVennvFiM3nJ3pfWDiR8itUUgTBHI
         /btA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=P3woLcZU0M+Ws7f4KlZMW8+JzNL4ekYAVdY+86C0Ih4=;
        b=sgVqGz2SQb17ADOeCYwqefEqxuXuCs7fBDp8YDDi2oXw361cHlB0rseCebTepT15tc
         0RXhV/DahbTBkgckN4cd+Q+u2AWrcCP1CTvb1+wVPypdsA+ALOGr3HrYbmm/R6le5Et+
         2fJ5TTtC7rbaSrg6sdTQPMjqA+fI16UHXYt25flS2H7bxnUJlPwiZtlBq2er6OGsvVPX
         HQkw+a7cA1Ril73MAh5uhsBqZ7asUmigvGG+wF+ezcvNCV3zGVLGYm/Ru/+GPqHqcEW3
         gfbHZQ+UWiPEXN2s6XzcsPcJLbmYb+mc1ktgfMnAsCiLWoH8kFOX6cpnoOF3gVkv8qeC
         GloA==
X-Gm-Message-State: AFqh2kqmch6WZ5Fvc/ajgC2v381ZLFrnoBIO4CpqzA1bltNTuHZ6MRrH
        KbG1XU40eZrL9neApZvilZ+QMBWGo2A=
X-Google-Smtp-Source: AMrXdXuHJXKJx2QQYlmHT1NOLd0hUsdAJeH+d1ytY8XFqs5pvCG3aIZE5Awhf3Q7Z5kGDWCKlyubtg==
X-Received: by 2002:a05:7500:6614:b0:f1:d598:66ff with SMTP id ix20-20020a057500661400b000f1d59866ffmr634058gab.4.1674055131229;
        Wed, 18 Jan 2023 07:18:51 -0800 (PST)
Received: from willemb.c.googlers.com.com (240.157.150.34.bc.googleusercontent.com. [34.150.157.240])
        by smtp.gmail.com with ESMTPSA id do1-20020a05620a2b0100b00706284b74b5sm10168586qkb.52.2023.01.18.07.18.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Jan 2023 07:18:50 -0800 (PST)
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, edumazet@google.com,
        pabeni@redhat.com, Willem de Bruijn <willemb@google.com>
Subject: [PATCH net v2] selftests/net: toeplitz: fix race on tpacket_v3 block close
Date:   Wed, 18 Jan 2023 10:18:47 -0500
Message-Id: <20230118151847.4124260-1-willemdebruijn.kernel@gmail.com>
X-Mailer: git-send-email 2.39.0.314.g84b9a713c41-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Willem de Bruijn <willemb@google.com>

Avoid race between process wakeup and tpacket_v3 block timeout.

The test waits for cfg_timeout_msec for packets to arrive. Packets
arrive in tpacket_v3 rings, which pass packets ("frames") to the
process in batches ("blocks"). The sk waits for req3.tp_retire_blk_tov
msec to release a block.

Set the block timeout lower than the process waiting time, else
the process may find that no block has been released by the time it
scans the socket list. Convert to a ring of more than one, smaller,
blocks with shorter timeouts. Blocks must be page aligned, so >= 64KB.

Fixes: 5ebfb4cc3048 ("selftests/net: toeplitz test")
Signed-off-by: Willem de Bruijn <willemb@google.com>

---

v1->v2: replace while with ; on next line with single-line do while
---
 tools/testing/selftests/net/toeplitz.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/tools/testing/selftests/net/toeplitz.c b/tools/testing/selftests/net/toeplitz.c
index 90026a27eac0c..9ba03164d73a6 100644
--- a/tools/testing/selftests/net/toeplitz.c
+++ b/tools/testing/selftests/net/toeplitz.c
@@ -215,7 +215,7 @@ static char *recv_frame(const struct ring_state *ring, char *frame)
 }
 
 /* A single TPACKET_V3 block can hold multiple frames */
-static void recv_block(struct ring_state *ring)
+static bool recv_block(struct ring_state *ring)
 {
 	struct tpacket_block_desc *block;
 	char *frame;
@@ -223,7 +223,7 @@ static void recv_block(struct ring_state *ring)
 
 	block = (void *)(ring->mmap + ring->idx * ring_block_sz);
 	if (!(block->hdr.bh1.block_status & TP_STATUS_USER))
-		return;
+		return false;
 
 	frame = (char *)block;
 	frame += block->hdr.bh1.offset_to_first_pkt;
@@ -235,6 +235,8 @@ static void recv_block(struct ring_state *ring)
 
 	block->hdr.bh1.block_status = TP_STATUS_KERNEL;
 	ring->idx = (ring->idx + 1) % ring_block_nr;
+
+	return true;
 }
 
 /* simple test: sleep once unconditionally and then process all rings */
@@ -245,7 +247,7 @@ static void process_rings(void)
 	usleep(1000 * cfg_timeout_msec);
 
 	for (i = 0; i < num_cpus; i++)
-		recv_block(&rings[i]);
+		do {} while (recv_block(&rings[i]));
 
 	fprintf(stderr, "count: pass=%u nohash=%u fail=%u\n",
 		frames_received - frames_nohash - frames_error,
@@ -257,12 +259,12 @@ static char *setup_ring(int fd)
 	struct tpacket_req3 req3 = {0};
 	void *ring;
 
-	req3.tp_retire_blk_tov = cfg_timeout_msec;
+	req3.tp_retire_blk_tov = cfg_timeout_msec / 8;
 	req3.tp_feature_req_word = TP_FT_REQ_FILL_RXHASH;
 
 	req3.tp_frame_size = 2048;
 	req3.tp_frame_nr = 1 << 10;
-	req3.tp_block_nr = 2;
+	req3.tp_block_nr = 16;
 
 	req3.tp_block_size = req3.tp_frame_size * req3.tp_frame_nr;
 	req3.tp_block_size /= req3.tp_block_nr;
-- 
2.39.0.314.g84b9a713c41-goog

