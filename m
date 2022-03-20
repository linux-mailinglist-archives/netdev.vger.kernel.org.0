Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 291654E1A50
	for <lists+netdev@lfdr.de>; Sun, 20 Mar 2022 07:08:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244774AbiCTGJp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 20 Mar 2022 02:09:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244768AbiCTGJl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 20 Mar 2022 02:09:41 -0400
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51DB32DE9;
        Sat, 19 Mar 2022 23:08:18 -0700 (PDT)
Received: by mail-pl1-x62a.google.com with SMTP id n18so10196254plg.5;
        Sat, 19 Mar 2022 23:08:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=W9+v4Drfx/EPiN0Sy9NIt9/vAIWyM2Vs6+JIbxhXlp0=;
        b=SjtFIr7RO1nYKdaMEnJKtORiVZ1P3rlLlfYBYs7TiudyGp/JTTrrl6i4K5mVlDYSl8
         o4Tr3NGKDnDU1Pt6DyosxGeHyPXVEiNRyd5C9ryGTjs//FtJZBvEU/YEjKiVHwtTp9EP
         nKxRJTL52CXey+4S1I2AiTpcmu45+tspCU9nXBv4zrAncUWdiloLYuXfjJIKoaiWCN/1
         xp9QXZW62ESkzQuO5k0jbgGX55ehdMxTE7w7E3h5cJ42UZbLyitHioHu2vatj2E8dWDB
         CGfH33SESJMBb+o75v8ybw99IelAdWSzBoDV6cTMzv6hDGb6Xx2vaczvLLFANhkVoqGe
         7x0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=W9+v4Drfx/EPiN0Sy9NIt9/vAIWyM2Vs6+JIbxhXlp0=;
        b=BnftJKoJOlyHpCZnX5BAOUxQrg/nnvvQ8Y3LaqDUFSctnlJTSXlKnAgw6iQAF7xCZf
         1dlfjJNN8V1bnUuIexm4aquyd0qfTjzNWUYd7rYVE+w5GWTp+7esxFBE8QmDLu64Z46p
         1Slt36JGZ9oerVSWFIRTe0mTD7leeXRbEU+Kg56w9A4eXO/uanD+f6KIYrdmHLM41A0o
         g2Q3iFVAiK+725zPiXWm5sn99hofyXUJC+jKJnaOjCPX1PSCy1U8egddRjKKmb1WvUDs
         DnTe6SkLrtXCAJfn9ezpktXEu7w4Q8nfdPHwQLDOu3CrwDW6p8oynMKyWaUYw/yKcNMq
         R5+g==
X-Gm-Message-State: AOAM532PXDK9as90p7jr0DHD2Su0lIQqAA3QsMkfPRLMxhz809S3FMu/
        LcnOdpxh5ss/rMX/Lu8WBnpz71Bk0ywUZkmp
X-Google-Smtp-Source: ABdhPJwn8V5+HxgvfApCV4NJnExiQ9oW9LHNmOIb5IQuD0lJyFgKI8SpeeLKaZSHtkW8DVdjmAVtAA==
X-Received: by 2002:a17:902:7109:b0:153:2ed8:b140 with SMTP id a9-20020a170902710900b001532ed8b140mr7238430pll.52.1647756497843;
        Sat, 19 Mar 2022 23:08:17 -0700 (PDT)
Received: from vultr.guest ([2001:19f0:6001:3dea:5400:3ff:fee9:c745])
        by smtp.gmail.com with ESMTPSA id y21-20020a056a00191500b004f78813b2d6sm15541662pfi.178.2022.03.19.23.08.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 19 Mar 2022 23:08:17 -0700 (PDT)
From:   Yafang Shao <laoar.shao@gmail.com>
To:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        Yafang Shao <laoar.shao@gmail.com>,
        Joanne Koong <joannekoong@fb.com>
Subject: [PATCH] bpf: bpftool: fix print error when show bpf map
Date:   Sun, 20 Mar 2022 06:08:14 +0000
Message-Id: <20220320060815.7716-1-laoar.shao@gmail.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If there is no btf_id or frozen, it will not show the pids,
but the pids doesn't depends on any one of them.

Below is the result after this change,
$ ./bpftool map show
2: lpm_trie  flags 0x1
	key 8B  value 8B  max_entries 1  memlock 4096B
	pids systemd(1)
3: lpm_trie  flags 0x1
	key 20B  value 8B  max_entries 1  memlock 4096B
	pids systemd(1)

While before this change, the 'pids systemd(1)' can't be displayed.

Fixes: 9330986c0300 ("bpf: Add bloom filter map implementation")
Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
Cc: Joanne Koong <joannekoong@fb.com>
---
 tools/bpf/bpftool/map.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/tools/bpf/bpftool/map.c b/tools/bpf/bpftool/map.c
index f91d9bf9054e..c26378f20831 100644
--- a/tools/bpf/bpftool/map.c
+++ b/tools/bpf/bpftool/map.c
@@ -620,17 +620,14 @@ static int show_map_close_plain(int fd, struct bpf_map_info *info)
 					    u32_as_hash_field(info->id))
 			printf("\n\tpinned %s", (char *)entry->value);
 	}
-	printf("\n");
 
 	if (frozen_str) {
 		frozen = atoi(frozen_str);
 		free(frozen_str);
 	}
 
-	if (!info->btf_id && !frozen)
-		return 0;
-
-	printf("\t");
+	if (info->btf_id || frozen)
+		printf("\n\t");
 
 	if (info->btf_id)
 		printf("btf_id %d", info->btf_id);
-- 
2.17.1

