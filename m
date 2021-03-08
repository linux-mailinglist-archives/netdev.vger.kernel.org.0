Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6EDCB330A11
	for <lists+netdev@lfdr.de>; Mon,  8 Mar 2021 10:14:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229829AbhCHJOS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Mar 2021 04:14:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229775AbhCHJOK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Mar 2021 04:14:10 -0500
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9CE60C06174A;
        Mon,  8 Mar 2021 01:14:10 -0800 (PST)
Received: by mail-pl1-x630.google.com with SMTP id a24so4545316plm.11;
        Mon, 08 Mar 2021 01:14:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=LapUqhPgY5pST1dV0LdNgE6achMdsluxGY9BNdUk6gM=;
        b=M92hkSmWsEPzlaOkTjyVbMet0gfve3NV9knTG3VWroGQy/URdxilBQ1Eg56nzg3POR
         GUyn6yTh0v60khwdKLeyyqPdJ4Lt6lPEU2PSQcxotG0KdHaM27R7EDsZsaD9BiadyvOr
         c2IOPU078wYi8AN0nUzjTQud0bQZRd9STxj8HEwQrn2rcSBRgvlDr9ZyBtfr2CDsNjfi
         KB03YEPmfFfzC5LiCz/5/XEp6a34bmCCE98cN6ThGWB1jS4G/YQnPUh3YSGiCqOcnqK/
         Y9VqoTFfkRv0BXfyVheYEt5I3IVfFwOgB9MNV+xsG+41ReG8nB1pyeLntwS52xbByYhG
         O7kQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=LapUqhPgY5pST1dV0LdNgE6achMdsluxGY9BNdUk6gM=;
        b=nSBUYNzYryMJz8lbjuQP7L+WnEbFgJzooLSsZIe8je2VX31OBcoOCEdpkMFbYzu48G
         H3uxN4LVFHCgntPWzZIA2vtCPpAlnJ9Yh0pDDF7F9dVQlvBpbgvYYatbuSC/7hM0XUKe
         KQ/xSWIQFThn4NmvgkhGIf7UG9IKktN9Ng7ex59KCGpdEUyp0SjYLC4vNsl8I+Xy1Obk
         bjwNxpKofaZz8NM7PGCNxy0/5UX43UY9d5Lvhs4oG0NfPEj0aCFWK7qBf2F9qAxNIwGX
         HBBwjEMt8CR/ass7yFNDX+YZKM69uDNTob7zfZWmd595uOeyAvGPdoqd8a5IVLAMVIxT
         VkqA==
X-Gm-Message-State: AOAM531+QXzree+LNO7g9awC/t4hIZSGgor61+07k13Hy45vwDNz8eM/
        EOT5WBk9mpANja5q+pIs13E=
X-Google-Smtp-Source: ABdhPJzlzqOByUyGkswp00tSv/DGdDAYKsCCKsWrYMzRJ35ZT0k6dHCmfyPYcjSXwxqwy2z+KDYQRA==
X-Received: by 2002:a17:90a:ce0c:: with SMTP id f12mr23879065pju.11.1615194850228;
        Mon, 08 Mar 2021 01:14:10 -0800 (PST)
Received: from localhost.localdomain ([45.135.186.99])
        by smtp.gmail.com with ESMTPSA id w8sm9511874pgk.46.2021.03.08.01.14.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Mar 2021 01:14:09 -0800 (PST)
From:   Jia-Ju Bai <baijiaju1990@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, loic.poulain@linaro.org,
        bjorn.andersson@linaro.org, mani@kernel.org,
        cjhuang@codeaurora.org, necip@google.com, edumazet@google.com,
        miaoqinglang@huawei.com, dan.carpenter@oracle.com,
        wenhu.wang@vivo.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jia-Ju Bai <baijiaju1990@gmail.com>
Subject: [PATCH] net: qrtr: fix error return code of qrtr_sendmsg()
Date:   Mon,  8 Mar 2021 01:13:55 -0800
Message-Id: <20210308091355.8726-1-baijiaju1990@gmail.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When sock_alloc_send_skb() returns NULL to skb, no error return code of
qrtr_sendmsg() is assigned.
To fix this bug, rc is assigned with -ENOMEM in this case.

Fixes: 194ccc88297a ("net: qrtr: Support decoding incoming v2 packets")
Reported-by: TOTE Robot <oslab@tsinghua.edu.cn>
Signed-off-by: Jia-Ju Bai <baijiaju1990@gmail.com>
---
 net/qrtr/qrtr.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/qrtr/qrtr.c b/net/qrtr/qrtr.c
index b34358282f37..ac2a4a7711da 100644
--- a/net/qrtr/qrtr.c
+++ b/net/qrtr/qrtr.c
@@ -958,8 +958,10 @@ static int qrtr_sendmsg(struct socket *sock, struct msghdr *msg, size_t len)
 	plen = (len + 3) & ~3;
 	skb = sock_alloc_send_skb(sk, plen + QRTR_HDR_MAX_SIZE,
 				  msg->msg_flags & MSG_DONTWAIT, &rc);
-	if (!skb)
+	if (!skb) {
+		rc = -ENOMEM;
 		goto out_node;
+	}
 
 	skb_reserve(skb, QRTR_HDR_MAX_SIZE);
 
-- 
2.17.1

