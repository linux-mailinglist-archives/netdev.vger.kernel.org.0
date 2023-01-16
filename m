Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DB86366CE24
	for <lists+netdev@lfdr.de>; Mon, 16 Jan 2023 18:59:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231268AbjAPR7A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Jan 2023 12:59:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235083AbjAPR6h (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Jan 2023 12:58:37 -0500
Received: from mail-qt1-x82f.google.com (mail-qt1-x82f.google.com [IPv6:2607:f8b0:4864:20::82f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF78BF768
        for <netdev@vger.kernel.org>; Mon, 16 Jan 2023 09:40:17 -0800 (PST)
Received: by mail-qt1-x82f.google.com with SMTP id j9so2431276qtv.4
        for <netdev@vger.kernel.org>; Mon, 16 Jan 2023 09:40:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=+qlDcNTPT7CDPaPkP5UhPWnuoxxEqjF0fuveHWOcVig=;
        b=hfEbrU0MDl/4OsvFfSIDaAEBEkpdjiM9CuWSUbS51PGvjW9RVq+kwyh1OQqn4LNBJw
         WvxuJCHfGIr2szyguXkP7zCLcvQf/ed+XOJkdX27dtOXcy/04eArCvVeQeb4tNbLhVHD
         VcU4XGgI6bq59X6NV8SFFAQ1H39OlJMKGXJLBMKISYGwwpdDp8BV6VjRpe0Bo5DdwXzB
         Q7xvSvEZuVmQwCppxwGS71j503HCT9+CJK1BZhDnxzLLvgFtK7zDsbJdbo+PuH3GoFBf
         rejNgXpcribWdWLhbKTMgWo7AVZo9ds7nmWyLUQDrWpo8VkGslbZKHHGMej7e1soiZ0k
         +HCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=+qlDcNTPT7CDPaPkP5UhPWnuoxxEqjF0fuveHWOcVig=;
        b=UJATeRIKvmtLsWztbNPLhROe8cPHiIxP0obsrCFFK6ox2ZJ+LBN88lgJsylfiYbgBe
         x32Ny8NihEY/vY7o3EzoGfQx2YH70eW2uSiXxP9i3BoTaEZF7hZ8ZEs0ZaidhIlP1GvU
         LRQ5fqFDKqIxBdpFxSrpOcJpiUcbzewFfFKMCWkWCyD9/AW9VwR/so8fCL/lPA2oF93w
         d/p9jLTAEsO7pmz4y/Q+nA+oevIrhzVJwbu3zFHp9gHWUMmeHti/ssQypXoTfxwT1V60
         AiVU28+ddrraXWYOBqTKiIV/yGydRsYm3hj7qjVS4s9B5e1zbIbLkqZUrXVkkkRMFF+q
         AyNw==
X-Gm-Message-State: AFqh2kqB4usvGMKoIJDKWMA3rHWUrjmGxSVsgYqXtZqnq7oKBJkjh2eu
        nwtGF32sAiXb+CswSKl+pW0k2aeRzmc=
X-Google-Smtp-Source: AMrXdXuxpylrTEGd928SaOcaw2IFi3nvR8ZX2mEA/wQcFXYq9uAkNE0zqNW7CHsIIjaNzwzs0tOnWw==
X-Received: by 2002:ac8:4a13:0:b0:3b5:4aae:cb0b with SMTP id x19-20020ac84a13000000b003b54aaecb0bmr10702865qtq.22.1673890816810;
        Mon, 16 Jan 2023 09:40:16 -0800 (PST)
Received: from willemb.c.googlers.com.com (240.157.150.34.bc.googleusercontent.com. [34.150.157.240])
        by smtp.gmail.com with ESMTPSA id x10-20020a05620a448a00b006faa2c0100bsm18815689qkp.110.2023.01.16.09.40.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Jan 2023 09:40:16 -0800 (PST)
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, edumazet@google.com,
        pabeni@redhat.com, Willem de Bruijn <willemb@google.com>
Subject: [PATCH net] selftests/net: toeplitz: fix race on tpacket_v3 block close
Date:   Mon, 16 Jan 2023 12:40:13 -0500
Message-Id: <20230116174013.3272728-1-willemdebruijn.kernel@gmail.com>
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

Somewhat awkward while () notation dictated by checkpatch: no empty
braces allowed, nor statement on the same line as the condition.

Fixes: 5ebfb4cc3048 ("selftests/net: toeplitz test")
Signed-off-by: Willem de Bruijn <willemb@google.com>
---
 tools/testing/selftests/net/toeplitz.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/tools/testing/selftests/net/toeplitz.c b/tools/testing/selftests/net/toeplitz.c
index 90026a27eac0c..66f7f6568643a 100644
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
@@ -245,7 +247,8 @@ static void process_rings(void)
 	usleep(1000 * cfg_timeout_msec);
 
 	for (i = 0; i < num_cpus; i++)
-		recv_block(&rings[i]);
+		while (recv_block(&rings[i]))
+			;
 
 	fprintf(stderr, "count: pass=%u nohash=%u fail=%u\n",
 		frames_received - frames_nohash - frames_error,
@@ -257,12 +260,12 @@ static char *setup_ring(int fd)
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

