Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D1083A663F
	for <lists+netdev@lfdr.de>; Mon, 14 Jun 2021 14:07:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233414AbhFNMJE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Jun 2021 08:09:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232809AbhFNMJA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Jun 2021 08:09:00 -0400
Received: from mail-lf1-x136.google.com (mail-lf1-x136.google.com [IPv6:2a00:1450:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A49DCC061574;
        Mon, 14 Jun 2021 05:06:57 -0700 (PDT)
Received: by mail-lf1-x136.google.com with SMTP id v22so20758260lfa.3;
        Mon, 14 Jun 2021 05:06:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=YvCTZ8Ov3VDpQbRCsTM4YPqIWNSx/HQdD9qBch5pmqM=;
        b=Rn660CcH4NICQmGulWlYdC8iDhHyqwQBhdMkYPV0WtMEfdJIeHOcSn62tKuerNOglg
         +Davlc/9jecoZE8351ZMz8/V/GQtJHT9FPIX0lSmMA/AkFW7BfW7Df9p1GEBbgXq+k5E
         WpbsvAh8/hJf4YbdZc0Y/CWRofX/076tJpstkfp6ZCORseYjCPxXbk8LFs1oPliiBc2a
         dB1Xqj4LqIwAsUkNSKKo2mpyUNuTlKICM40DSArDVycLJKdg5OLmWoJ/MDUv5kRzaw7q
         a8zL6P/WEqqkmX1iIG6EClcnE1rr1nt7LfZhPiUMKsUULAnjrgGP5WOM4JQ8P34GTZs1
         Osjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=YvCTZ8Ov3VDpQbRCsTM4YPqIWNSx/HQdD9qBch5pmqM=;
        b=WWARCpXQLI6QfRm1h/j/kj84aB9805bg6tSXQ9a/j0lTg5Sn/FoBN+gki4wGhj2dUp
         ZTC4i3TkjsC4eeyIZhTEjrRRvB2i9E9CDqhkWwaMBxsUTwwnLs3VgASpSA+nWB+8/rDQ
         RnCTE8lzN+cpLdjdFKfMs1rPMESK2lBcJLlVcdPkcj7F53cv0uJWsi++QHSOysB58/iK
         +dqgrjl8BwK9xT3MhPWLyFTn2qe3ZbvsNgTw/Sndf9lSs0ZY/vyzjh381GN2Yfh67LRE
         ETA7ukaH7SFH6HOYWwUouoG5mt9MEFZ5KbQeEdSbUgl7hugyQpgiYk5HSH8hCFoVBQ6B
         04jQ==
X-Gm-Message-State: AOAM5326uSP92R7bA+A1plsIk2+CljIAN/Kx/2lknauGtTtvLsty9RsQ
        i24gtyKT3E5GjJwBK3smKsQ=
X-Google-Smtp-Source: ABdhPJygl9rxk2JNOkZNkFoxlvl7VNgZYvRDtsB5F+1jfOqxhOZuxtwluYZnU2AkZBtupmb77CWbDA==
X-Received: by 2002:a19:383:: with SMTP id 125mr11789671lfd.228.1623672415968;
        Mon, 14 Jun 2021 05:06:55 -0700 (PDT)
Received: from localhost.localdomain ([94.103.229.24])
        by smtp.gmail.com with ESMTPSA id h12sm1789212ljg.59.2021.06.14.05.06.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Jun 2021 05:06:54 -0700 (PDT)
From:   Pavel Skripkin <paskripkin@gmail.com>
To:     mani@kernel.org, davem@davemloft.net, bjorn.andersson@linaro.org
Cc:     linux-arm-msm@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Pavel Skripkin <paskripkin@gmail.com>,
        syzbot+1917d778024161609247@syzkaller.appspotmail.com
Subject: [PATCH] net: qrtr: fix OOB Read in qrtr_endpoint_post
Date:   Mon, 14 Jun 2021 15:06:50 +0300
Message-Id: <20210614120650.2731-1-paskripkin@gmail.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Syzbot reported slab-out-of-bounds Read in
qrtr_endpoint_post. The problem was in wrong
_size_ type:

	if (len != ALIGN(size, 4) + hdrlen)
		goto err;

If size from qrtr_hdr is 4294967293 (0xfffffffd), the result of
ALIGN(size, 4) will be 0. In case of len == hdrlen and size == 4294967293
in header this check won't fail and

	skb_put_data(skb, data + hdrlen, size);

will read out of bound from data, which is hdrlen allocated block.

Fixes: 194ccc88297a ("net: qrtr: Support decoding incoming v2 packets")
Reported-and-tested-by: syzbot+1917d778024161609247@syzkaller.appspotmail.com
Signed-off-by: Pavel Skripkin <paskripkin@gmail.com>
---
 net/qrtr/qrtr.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/qrtr/qrtr.c b/net/qrtr/qrtr.c
index c0477bec09bd..f2efaa4225f9 100644
--- a/net/qrtr/qrtr.c
+++ b/net/qrtr/qrtr.c
@@ -436,7 +436,7 @@ int qrtr_endpoint_post(struct qrtr_endpoint *ep, const void *data, size_t len)
 	struct qrtr_sock *ipc;
 	struct sk_buff *skb;
 	struct qrtr_cb *cb;
-	unsigned int size;
+	size_t size;
 	unsigned int ver;
 	size_t hdrlen;
 
-- 
2.32.0

