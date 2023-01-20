Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 235AD675C7B
	for <lists+netdev@lfdr.de>; Fri, 20 Jan 2023 19:11:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229841AbjATSLk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Jan 2023 13:11:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229489AbjATSLj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Jan 2023 13:11:39 -0500
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05A317B2EE
        for <netdev@vger.kernel.org>; Fri, 20 Jan 2023 10:11:39 -0800 (PST)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-4d5097a95f5so58050387b3.1
        for <netdev@vger.kernel.org>; Fri, 20 Jan 2023 10:11:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=ZJu/SVCYNxSPiaMmg76gOBZypbrB1PNBefLpDrKin6A=;
        b=mKm3V1IJ57G1RwVnPRnhvVS0xEhumSBMpYLcZ9zUWJHadXEN7qoDijePC2Zbh4LaYj
         thXMDFy7Pi7/kwDVX5qX6SqJ5sHucILOwuNJXg+uhCX+owMb0s4y62gkBXhiZ8ObcQEc
         7qVLSL1hHafjDygC77IQEqQUIY1hzIrdnI+KmVG6qiypDloYEeZgVb8NYXdLQcPNlfYu
         YQcd6SNI5L/PCSRuXdWK3LtaxBWhg7skQzjiBui5MIQgdzYATxJlUrgmWv8C1y/oN07a
         LEd90T/560GwISS+Y8uORT2mP739Fwtz6Th6TVGuaYk1fCpJ/2gGLuut+xprLGkTFgEx
         Z/CQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ZJu/SVCYNxSPiaMmg76gOBZypbrB1PNBefLpDrKin6A=;
        b=WmVgpNIX7HorNS5rsoARgArE0mTg7Ce2yN8o73LbJSZ5AKhZkXuVdVM3clkK1j1wqp
         BKTaai/kV4r7FQFWTuOv/mDFdLvTpoE3QR7HRtg6+/fZRE3mYWo65VnvQ9Oqm50OieS+
         46ejBGoQ/yAFrOf3QS4GQn+vFu14X8bu+B4OAkcJxRM96JAYSjCvMZpQRe9gt315oMsH
         ZeBcsJYwrhKnRch6fn4Guz6eFxgWTEBM5p5oHvVZrgFI8ujgxwtmckPuwuXkoHodfXRv
         DF3NoBhPR1ikAswtDbj3Jx0CNjGBzGs9jT6LHmXfIt4R1elPDJ3DfS3BxlVty79EwzDU
         2oMQ==
X-Gm-Message-State: AFqh2kogwTOKdQ6TDI4W6L/QlAo9hONrAtrG4ZFyRWBErfMTgr/XEM/P
        fl40Yn9Czj8Eb0HBH/Ak6rI66/vaUpV1vg==
X-Google-Smtp-Source: AMrXdXtoRZ+yTtnDCcjXCtyCFUUnOmJkViOZpIVUON9IYRAowS1ZNbb1GOJnXabVuQj7qdzp8bZCvamSKtg+NQ==
X-Received: from edumazet1.c.googlers.com ([fda3:e722:ac3:cc00:2b:7d90:c0a8:395a])
 (user=edumazet job=sendgmr) by 2002:a05:6902:349:b0:763:8e38:3fb3 with SMTP
 id e9-20020a056902034900b007638e383fb3mr955274ybs.547.1674238298218; Fri, 20
 Jan 2023 10:11:38 -0800 (PST)
Date:   Fri, 20 Jan 2023 18:11:36 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.39.1.405.gd4c25cc71f-goog
Message-ID: <20230120181136.3764521-1-edumazet@google.com>
Subject: [PATCH net-next] selftests: net: tcp_mmap: populate pages in send path
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, eric.dumazet@gmail.com,
        Eric Dumazet <edumazet@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In commit 72653ae5303c ("selftests: net: tcp_mmap:
Use huge pages in send path") I made a change to use hugepages
for the buffer used by the client (tx path)

Today, I understood that the cause for poor zerocopy
performance was that after a mmap() for a 512KB memory
zone, kernel uses a single zeropage, mapped 128 times.

This was really the reason for poor tx path performance
in zero copy mode, because this zero page refcount is
under high pressure, especially when TCP ACK packets
are processed on another cpu.

We need either to force a COW on all the memory range,
or use MAP_POPULATE so that a zero page is not abused.

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 tools/testing/selftests/net/tcp_mmap.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/net/tcp_mmap.c b/tools/testing/selftests/net/tcp_mmap.c
index 00f837c9bc6c4549c19dfc27aa2d08c454ea169e..46a02bbd31d0be4d54b2b372415bce6c0d538b22 100644
--- a/tools/testing/selftests/net/tcp_mmap.c
+++ b/tools/testing/selftests/net/tcp_mmap.c
@@ -137,7 +137,8 @@ static void *mmap_large_buffer(size_t need, size_t *allocated)
 	if (buffer == (void *)-1) {
 		sz = need;
 		buffer = mmap(NULL, sz, PROT_READ | PROT_WRITE,
-			      MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
+			      MAP_PRIVATE | MAP_ANONYMOUS | MAP_POPULATE,
+			      -1, 0);
 		if (buffer != (void *)-1)
 			fprintf(stderr, "MAP_HUGETLB attempt failed, look at /sys/kernel/mm/hugepages for optimal performance\n");
 	}
-- 
2.39.1.405.gd4c25cc71f-goog

