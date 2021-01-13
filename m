Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 02CE52F4388
	for <lists+netdev@lfdr.de>; Wed, 13 Jan 2021 06:14:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725846AbhAMFMy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jan 2021 00:12:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725773AbhAMFMx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Jan 2021 00:12:53 -0500
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77F0CC061575
        for <netdev@vger.kernel.org>; Tue, 12 Jan 2021 21:12:13 -0800 (PST)
Received: by mail-pl1-x62d.google.com with SMTP id q4so409062plr.7
        for <netdev@vger.kernel.org>; Tue, 12 Jan 2021 21:12:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=KS9zKNWnlZGMGSJTeN3Ir6H+5nEXyxOsPC5vJwRtu+g=;
        b=XC/fvuhzI/yJ5M8v/CgD4GuZQ9OkgL/hseuvUCr96nAG4UYrx58j2FrCq4676mnl4M
         Uxyq6gM/3oV+Oz7v4fQEcDTq7U/PA3mBr+/7fJQs3RMwHCAb/Gq0N5iu8vUH2dLevgj4
         fGYKB1oDuNyHl4dwYob94iH9LQ7fF8fJAHaJ1aHBA6r9JRXQjweLVBEzGYLPDeQHhVA2
         SivdTsMR2iQX5UdzZXHVYm5ZmbFnPUc4j2EMOUl8x+quv6C/R+W9nTU+f6TFqeIJsvjO
         5/M4dykWV2ziP3ELc+c+di0dr3DMv3VA6eo6+NQtppiDVY7G9t9lM0lEr/oKnpVpgorP
         HmDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=KS9zKNWnlZGMGSJTeN3Ir6H+5nEXyxOsPC5vJwRtu+g=;
        b=Sm0Xdo89qnBd02grchChKJFo73u7ZkCYHpoVRI7UouEVw7Psc3ifwqedT+JAGLW/W9
         7KmF2cCQAfplILGuDZM2m4DKoyEvHvBT5l/g3aJS6P5Rg6eWkuTL93Qy1R1xaAxChW+t
         ol7lrucMbvupM6LmvbPwchXANQ2Z7rjwTDA3ul98kHQ+T4lrX1giM/KjE+COzDlqQSDB
         rMa76kJCAi1/29Ez5/fOE/GFyLVm+5SsKlN0oEhpEnNPqewd2lRQ6S/f/NbivkzAXOQo
         42nBwk8/KW1C34xgyMNJRXKocD1HwmOFIx/utaZddL/0CTdeOdxXd/9gmCuw73XkVegO
         J0YQ==
X-Gm-Message-State: AOAM5336v6/57ykdGy+SHQVogxakYxglr6zWKt64n+hoETiZtiVP6kZk
        Iew9FlXjm5h1f1vZRurkkhA=
X-Google-Smtp-Source: ABdhPJzYceds6v61I5AsDBBdpZv2YENBzM3Qoy23smYpIGZG2nFOIO0aI4bpekMwrxFPqc/5wQLIJQ==
X-Received: by 2002:a17:902:ea94:b029:da:a547:b6a6 with SMTP id x20-20020a170902ea94b02900daa547b6a6mr569504plb.78.1610514733121;
        Tue, 12 Jan 2021 21:12:13 -0800 (PST)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:7220:84ff:fe09:1424])
        by smtp.gmail.com with ESMTPSA id h24sm913974pfq.13.2021.01.12.21.12.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Jan 2021 21:12:12 -0800 (PST)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Greg Thelen <gthelen@google.com>
Subject: [PATCH net] Revert "virtio_net: replace netdev_alloc_skb_ip_align() with napi_alloc_skb()"
Date:   Tue, 12 Jan 2021 21:12:07 -0800
Message-Id: <20210113051207.142711-1-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.30.0.284.gd98b1dd5eaa7-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

This reverts commit c67f5db82027ba6d2ea4ac9176bc45996a03ae6a.

While using page fragments instead of a kmalloc backed skb->head might give
a small performance improvement in some cases, there is a huge risk of
memory use under estimation.

GOOD_COPY_LEN is 128 bytes. This means that we need a small amount
of memory to hold the headers and struct skb_shared_info

Yet, napi_alloc_skb() might use a whole 32KB page (or 64KB on PowerPc)
for long lived incoming TCP packets.

We have been tracking OOM issues on GKE hosts hitting tcp_mem limits
but consuming far more memory for TCP buffers than instructed in tcp_mem[2]

Even if we force napi_alloc_skb() to only use order-0 pages, the issue
would still be there on arches with PAGE_SIZE >= 32768

Using alloc_skb() and thus standard kmallloc() for skb->head allocations
will get the benefit of letting other objects in each page being independently
used by other skbs, regardless of the lifetime.

Note that a similar problem exists for skbs allocated from napi_get_frags(),
this is handled in a separate patch.

I would like to thank Greg Thelen for his precious help on this matter,
analysing crash dumps is always a time consuming task.

Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Paolo Abeni <pabeni@redhat.com>
Cc: Michael S. Tsirkin <mst@redhat.com>
Cc: Greg Thelen <gthelen@google.com>
---
 drivers/net/virtio_net.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index 508408fbe78fbd8658dc226834b5b1b334b8b011..5886504c1acacf3f6148127b5c1cc7f6a906b827 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -386,7 +386,7 @@ static struct sk_buff *page_to_skb(struct virtnet_info *vi,
 	p = page_address(page) + offset;
 
 	/* copy small packet so we can reuse these pages for small data */
-	skb = napi_alloc_skb(&rq->napi, GOOD_COPY_LEN);
+	skb = netdev_alloc_skb_ip_align(vi->dev, GOOD_COPY_LEN);
 	if (unlikely(!skb))
 		return NULL;
 
-- 
2.30.0.284.gd98b1dd5eaa7-goog

