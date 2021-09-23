Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A78941574B
	for <lists+netdev@lfdr.de>; Thu, 23 Sep 2021 06:05:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229585AbhIWEGk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Sep 2021 00:06:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229436AbhIWEGj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Sep 2021 00:06:39 -0400
Received: from mail-wr1-x42f.google.com (mail-wr1-x42f.google.com [IPv6:2a00:1450:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6D51C061574;
        Wed, 22 Sep 2021 21:05:08 -0700 (PDT)
Received: by mail-wr1-x42f.google.com with SMTP id q26so13071191wrc.7;
        Wed, 22 Sep 2021 21:05:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=9n7b6JE6XUS8B7KMsBIbTq7nC4Yv0zk+28FewktZ7M0=;
        b=VbDMCxiBOWCtOhR4/6hWEdw+qiRR9Q/bHUGCg6CclPX+jJyNHjBZy28/e6zWBUV5xj
         1dlnePMUt9l79r98nlpVhQr0SZsuXAU6nrVWus6iN05C6c6W5tDeKbpN+k7UML8nq0jp
         GdY/0qhURuWS00IxOkI3jtN249RGkzYNP6adcvXfpBuXsuUba8WiBFM1SVZWGRcgM7ky
         Gfb+fDzhsaHramFnliVqKPPs+Gcuz1ZeLqHrpk8JvT+l29YvLRcsYWPqwJlOQUQfC6WW
         HJ4zSkQw9oKkgMmdcaPtwTEbEgmjAU5w71yk+J4tadxRu6zrgnwptVOzBLywfsR3GQ9f
         Kngw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=9n7b6JE6XUS8B7KMsBIbTq7nC4Yv0zk+28FewktZ7M0=;
        b=zC6olqOaTHjhwKtDoOAbRHggA0rC57BiAxNsHL12tCG5jky+pCQ7LwMaivGw+k2YHT
         +iyS9ARDgCubNncHZmXlGG5FY/FkKuREZqwg8IKG/Qqp2DBRccXqFU/vDyuWoCLlnRfy
         BZSeL40y1xqeVAOrM3Ddz1DJQ56IgOOwPZYHUduwbGK+n3I0nzoBEtEDcwwUTqKGvXMF
         f/QTvkZnOpSYjD6o8yUMG1NwzT65iUXLj+3fMppZ7FAoSvF1yIT5fwPcOYCRZqFq0ZpJ
         qxm3ANkQxszMlZn3LXWKy28LdPBp/HAifuQDLORbJXe5dECxD4x6g1r13SX2j9SLVeWK
         n85Q==
X-Gm-Message-State: AOAM53012aNTH8Pvksj2M4SyeK8HCJVmKAfaSGtlCDHq3HQl6YB8YbkJ
        aJa23AgARHxbr8YhipkrH9wcZwKcxkOlYQ==
X-Google-Smtp-Source: ABdhPJynVBJ1kG++Hn4Az6MuWIRa7TQo52FO/vxGwWdI1la7Z38pilcEqmSc9m86GYI3ryjgrulFFQ==
X-Received: by 2002:adf:f844:: with SMTP id d4mr2463591wrq.370.1632369907192;
        Wed, 22 Sep 2021 21:05:07 -0700 (PDT)
Received: from wsfd-netdev15.ntdv.lab.eng.bos.redhat.com (nat-pool-bos-t.redhat.com. [66.187.233.206])
        by smtp.gmail.com with ESMTPSA id f8sm3946659wrx.15.2021.09.22.21.05.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Sep 2021 21:05:06 -0700 (PDT)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>, davem@davemloft.net,
        kuba@kernel.org, linux-sctp@vger.kernel.org
Cc:     Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Subject: [PATCH net] sctp: break out if skb_header_pointer returns NULL in sctp_rcv_ootb
Date:   Thu, 23 Sep 2021 00:05:04 -0400
Message-Id: <8f91703995c8de638695e330c06d17ecec8c9135.1632369904.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We should always check if skb_header_pointer's return is NULL before
using it, otherwise it may cause null-ptr-deref, as syzbot reported:

  KASAN: null-ptr-deref in range [0x0000000000000000-0x0000000000000007]
  RIP: 0010:sctp_rcv_ootb net/sctp/input.c:705 [inline]
  RIP: 0010:sctp_rcv+0x1d84/0x3220 net/sctp/input.c:196
  Call Trace:
  <IRQ>
   sctp6_rcv+0x38/0x60 net/sctp/ipv6.c:1109
   ip6_protocol_deliver_rcu+0x2e9/0x1ca0 net/ipv6/ip6_input.c:422
   ip6_input_finish+0x62/0x170 net/ipv6/ip6_input.c:463
   NF_HOOK include/linux/netfilter.h:307 [inline]
   NF_HOOK include/linux/netfilter.h:301 [inline]
   ip6_input+0x9c/0xd0 net/ipv6/ip6_input.c:472
   dst_input include/net/dst.h:460 [inline]
   ip6_rcv_finish net/ipv6/ip6_input.c:76 [inline]
   NF_HOOK include/linux/netfilter.h:307 [inline]
   NF_HOOK include/linux/netfilter.h:301 [inline]
   ipv6_rcv+0x28c/0x3c0 net/ipv6/ip6_input.c:297

Fixes: 3acb50c18d8d ("sctp: delay as much as possible skb_linearize")
Reported-by: syzbot+581aff2ae6b860625116@syzkaller.appspotmail.com
Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 net/sctp/input.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/sctp/input.c b/net/sctp/input.c
index 5ef86fdb1176..1f1786021d9c 100644
--- a/net/sctp/input.c
+++ b/net/sctp/input.c
@@ -702,7 +702,7 @@ static int sctp_rcv_ootb(struct sk_buff *skb)
 		ch = skb_header_pointer(skb, offset, sizeof(*ch), &_ch);
 
 		/* Break out if chunk length is less then minimal. */
-		if (ntohs(ch->length) < sizeof(_ch))
+		if (!ch || ntohs(ch->length) < sizeof(_ch))
 			break;
 
 		ch_end = offset + SCTP_PAD4(ntohs(ch->length));
-- 
2.27.0

