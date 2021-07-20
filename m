Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7ADC73D01F1
	for <lists+netdev@lfdr.de>; Tue, 20 Jul 2021 20:52:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233517AbhGTSJs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Jul 2021 14:09:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231948AbhGTSIh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Jul 2021 14:08:37 -0400
Received: from mail-il1-x130.google.com (mail-il1-x130.google.com [IPv6:2607:f8b0:4864:20::130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E625BC0613DB;
        Tue, 20 Jul 2021 11:48:48 -0700 (PDT)
Received: by mail-il1-x130.google.com with SMTP id s5so196360ild.5;
        Tue, 20 Jul 2021 11:48:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=YpcMaDPI7P19glmj5zvUUN7s8ahSgBugvVXf8ibq5PY=;
        b=nJ4dvBw87qBktvxRy3yIDFpo6vehdxL3VOx61oLSBiz3NtwbJdaeF9aSCz4gIlW3/L
         elQFWMZhnc8FX/u8ZQG0c31okZcPXP3OCaDD9q0GF8+zqiDVsQqCVB5KVsBoSlIzf6A5
         jdWSdCwZZiGnTN9LQqV7lHGrgrUZhXJ2/GcUNO5cadcfL9Q6nP0TeQT8hmWQZHhQoSsX
         /XHT37b5oSbzS+CQbq1v9KYhLu2wwhlxCDgj2DkPvBqu5l7vvttfZkYAi2QwvSKAd9Xc
         NwOx0NZfbjEx3IawppTxaSWBIeN0bVjNw255+6qdS+Gt/dEU1UUTn/RSLmqNmPN2Ws1v
         ASVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=YpcMaDPI7P19glmj5zvUUN7s8ahSgBugvVXf8ibq5PY=;
        b=TVbv7AbYC95a86/5Tmn/RWZ1wnzESjJ6/ui8WCMHrCoNmlojxR9AcxoJ87m03THbhe
         icclGkYsUw4wmIpC8AGwsopT2ldwHr83zlc8SV7gPgjfWkB4xCgjuzHcpKvGaoy6KjdI
         k0wufEZ8Ws2NmbOHa5gByZM8ZUGw82A6/7j2d1XhUMLR6oRu5H/1qKxWFZOiOKv6EL3r
         cIx6N8dsw2rj01G2g9aFQkd6J4S+Hqt4ji4wPScaRjHRtWeM8SvGEHKH73j6A1zHhLpw
         m+gjXbwCO1tW8C4MwVBuYayjXsmU+a5u5EhGalNcb7RJrxlsAi1J+Wu6m8Tq9ZtsClIA
         6R6w==
X-Gm-Message-State: AOAM530EzT8f3U/6yh5aftf2bT+IcSoOKksrbgJhusDFqJhC9Majjz5Y
        5E68e68GQt8nJA4oS9CoKX0=
X-Google-Smtp-Source: ABdhPJwxZviUgrvxmZ6pOtGFafyW20KCgsCcWL9wGy6BSC1qhHQEvPn/L4SZGs/bEoKo7S2YJIFeDA==
X-Received: by 2002:a92:b111:: with SMTP id t17mr22536443ilh.208.1626806927292;
        Tue, 20 Jul 2021 11:48:47 -0700 (PDT)
Received: from john-XPS-13-9370.lan ([172.243.157.240])
        by smtp.gmail.com with ESMTPSA id a11sm12693352ioq.12.2021.07.20.11.48.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Jul 2021 11:48:46 -0700 (PDT)
From:   John Fastabend <john.fastabend@gmail.com>
To:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        xiyou.wangcong@gmail.com
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        john.fastabend@gmail.com
Subject: [PATCH bpf-next] bpf, selftests: fix test_maps now that sockmap supports UDP
Date:   Tue, 20 Jul 2021 11:48:32 -0700
Message-Id: <20210720184832.452430-1-john.fastabend@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

UDP socket support was added recently so testing UDP insert failure is no
longer correct and causes test_maps failure. The fix is easy though, we
simply need to test that UDP is correctly added instead of blocked.

Reported-by: Andrii Nakryiko <andrii@kernel.org>
Fixes: 122e6c79efe1c ("sock_map: Update sock type checks for UDP")
Signed-off-by: John Fastabend <john.fastabend@gmail.com>
---
 tools/testing/selftests/bpf/test_maps.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/bpf/test_maps.c b/tools/testing/selftests/bpf/test_maps.c
index d832d135211c..5a8e069e64fa 100644
--- a/tools/testing/selftests/bpf/test_maps.c
+++ b/tools/testing/selftests/bpf/test_maps.c
@@ -764,8 +764,8 @@ static void test_sockmap(unsigned int tasks, void *data)
 	udp = socket(AF_INET, SOCK_DGRAM, 0);
 	i = 0;
 	err = bpf_map_update_elem(fd, &i, &udp, BPF_ANY);
-	if (!err) {
-		printf("Failed socket SOCK_DGRAM allowed '%i:%i'\n",
+	if (err) {
+		printf("Failed socket update SOCK_DGRAM '%i:%i'\n",
 		       i, udp);
 		goto out_sockmap;
 	}
-- 
2.25.1

