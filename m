Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A8DA06C9871
	for <lists+netdev@lfdr.de>; Mon, 27 Mar 2023 00:16:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231575AbjCZWQh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Mar 2023 18:16:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229456AbjCZWQg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 Mar 2023 18:16:36 -0400
Received: from mail-yw1-x1130.google.com (mail-yw1-x1130.google.com [IPv6:2607:f8b0:4864:20::1130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1072846BF;
        Sun, 26 Mar 2023 15:16:35 -0700 (PDT)
Received: by mail-yw1-x1130.google.com with SMTP id 00721157ae682-5418d54d77bso137205417b3.12;
        Sun, 26 Mar 2023 15:16:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679868994;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=1P2bezaT/u+Scbs1rr3MlchzCBSv/VKeJL8doctcbxc=;
        b=kqVeQ0N3b8tFo9o1ulILg3HyV99oQvQrv7RcUG5EYbvUE4z0RAyFVqvuBu0mvBk61i
         NjnBgKYxEPfnUhjijHpqlI/Yp+K8lo7kEKQGZ7481uc4J5Y8ISNlAnVXoizR8S6dyO5p
         iP8AMe65ChrNWP/K/vmdh6A75Px5iBt1TBPbOGBdVBwCIGiORLRDJxJA9d1RBL+SeLAf
         r1Vunmt9cz77PudeZeQyrLJ2ezlUiV0gjsHuO5OpB/E2FcrexHzSv8W8QBWEK92SJrwk
         BEWfjaIA//QqJeJvI4g75ZOMZKybmKmmvBzJXAuAaf4fnp14AxHcmGg+UkiVGUJN6WMo
         R5uw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679868994;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=1P2bezaT/u+Scbs1rr3MlchzCBSv/VKeJL8doctcbxc=;
        b=qPg3KWesd329W+ZjZsmgS/1a86vCKQJLoaSCrWV6QsNOHRlOs3NzglPN1t1r9gG6Sg
         9YpAvJKPNnb4lRvz6+7PyNcJ3XVxdfI88paZDsN+wmzjuP555AiDkGbjYd7MYmXfSISr
         pggjTLxCYS8iUSP8JJPHKIiJblc5+UDgYGwG93f8syzPsTk6Pn6RZP2RQr34Xp496PGq
         uxd5rAQMLcRgB0SWod8TI4/CUur84S1mXWE2B8AlAnzd+VuSrqmA5FCvhJL9feTPd+Ut
         7HayPHtaZ6P03bWjrdiFWytLJt2EIcrEC7gFkAdkCFhrIU0NG4SuMszU9VqNn34KiKwK
         CSKQ==
X-Gm-Message-State: AAQBX9fjbUBk1YRC7jTUhcnKMTwxRzJSTkrVAgxRYX4mLwkEjPFYKJvz
        i2Q8O2aQgsxljec55lpgOHRPa/0VxWI=
X-Google-Smtp-Source: AKy350ZyKf8Gu8V3ojqUQsehhjLiQ1gpHz92tP9/hFfDWPeN/370zK1szIzvnChxHg8qEC/A4P2V7g==
X-Received: by 2002:a0d:f285:0:b0:541:8744:ae5 with SMTP id b127-20020a0df285000000b0054187440ae5mr9211836ywf.8.1679868993930;
        Sun, 26 Mar 2023 15:16:33 -0700 (PDT)
Received: from pop-os.attlocal.net ([2600:1700:65a0:ab60:2caa:28f3:5004:3e2d])
        by smtp.gmail.com with ESMTPSA id a67-20020a811a46000000b00545a0818482sm1657744ywa.18.2023.03.26.15.16.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 26 Mar 2023 15:16:33 -0700 (PDT)
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     netdev@vger.kernel.org
Cc:     bpf@vger.kernel.org, Cong Wang <cong.wang@bytedance.com>,
        Yafang Shao <laoar.shao@gmail.com>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        John Fastabend <john.fastabend@gmail.com>
Subject: [Patch bpf-next] sock_map: include sk_psock memory overhead too
Date:   Sun, 26 Mar 2023 15:16:12 -0700
Message-Id: <20230326221612.169289-1-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Cong Wang <cong.wang@bytedance.com>

When a socket is added to a sockmap, sk_psock is allocated too as its
sk_user_data, therefore it should be consider as an overhead of sockmap
memory usage.

Before this patch:

1: sockmap  flags 0x0
	key 4B  value 4B  max_entries 2  memlock 656B
	pids echo-sockmap(549)

After this patch:

9: sockmap  flags 0x0
	key 4B  value 4B  max_entries 2  memlock 1824B
	pids echo-sockmap(568)

Fixes: 73d2c61919e9 ("bpf, net: sock_map memory usage")
Cc: Yafang Shao <laoar.shao@gmail.com>
Cc: Jakub Sitnicki <jakub@cloudflare.com>
Cc: John Fastabend <john.fastabend@gmail.com>
Signed-off-by: Cong Wang <cong.wang@bytedance.com>
---
 net/core/sock_map.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/net/core/sock_map.c b/net/core/sock_map.c
index 7c189c2e2fbf..22197e565ece 100644
--- a/net/core/sock_map.c
+++ b/net/core/sock_map.c
@@ -799,9 +799,17 @@ static void sock_map_fini_seq_private(void *priv_data)
 
 static u64 sock_map_mem_usage(const struct bpf_map *map)
 {
+	struct bpf_stab *stab = container_of(map, struct bpf_stab, map);
 	u64 usage = sizeof(struct bpf_stab);
+	int i;
 
 	usage += (u64)map->max_entries * sizeof(struct sock *);
+
+	for (i = 0; i < stab->map.max_entries; i++) {
+		if (stab->sks[i])
+			usage += sizeof(struct sk_psock);
+	}
+
 	return usage;
 }
 
@@ -1412,7 +1420,7 @@ static u64 sock_hash_mem_usage(const struct bpf_map *map)
 	u64 usage = sizeof(*htab);
 
 	usage += htab->buckets_num * sizeof(struct bpf_shtab_bucket);
-	usage += atomic_read(&htab->count) * (u64)htab->elem_size;
+	usage += atomic_read(&htab->count) * ((u64)htab->elem_size + sizeof(struct sk_psock));
 	return usage;
 }
 
-- 
2.34.1

