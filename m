Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1196C35DF14
	for <lists+netdev@lfdr.de>; Tue, 13 Apr 2021 14:41:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231310AbhDMMmB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Apr 2021 08:42:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230449AbhDMMl7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Apr 2021 08:41:59 -0400
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02EFEC061574
        for <netdev@vger.kernel.org>; Tue, 13 Apr 2021 05:41:40 -0700 (PDT)
Received: by mail-pf1-x42f.google.com with SMTP id m11so11344259pfc.11
        for <netdev@vger.kernel.org>; Tue, 13 Apr 2021 05:41:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=opUzB3eTmDP6Bt69/GX/ex4UqF+MDRj/bhyGWT7WwcU=;
        b=ITAAbhFu3kgJyyVKsyNLRNMNOhBy3Xw19QEDaq2csA/jYDv528rCEyOICaL4BgZSAY
         WEzp7GJkHNg967ik9Y1P3aUglUPQCTa7g/UOHD5jYzT5C501ZMSDujZiMhfZ9bgIUpYj
         qUPWbTVF6uVk6vmN3dfXPYXmj9573IUqUfpvLI3+x08q2K9Bh7roPF6WAeEVdFE52YJr
         1qFmZbwP6ZQ+YYi1BfH+JNSi3YxNspm7wg84K+rJuNboCGRvqQCIKYDbp/cmiGGBa5hu
         Cb+e2oKN7BoFySgJzHM1VqNhWe6EkjguKntgF7Rgc+Muqz/r5zBvYfYXNs3eJvaX0f15
         BcUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=opUzB3eTmDP6Bt69/GX/ex4UqF+MDRj/bhyGWT7WwcU=;
        b=Y8E7LUde2I2hQJCMddoSn9CZDkNNBWqLHoPRGm7lTj+uvTacyRg2OXkax7KSMg7+sv
         1k65jyWn9eG0SQrZXoHMofUvDH5kie4H5A1uE5BqfqG1VYct7hSzGYAROMvf+Bieflh/
         jAdOo+6t928Z6U+M9p6z79YKjEcQuMYhY2cA9T6WGjoBzxZuafTpidQsy/SNAE6ZV9Is
         Kzp14A91z8WhwXX1/9aWAfs3RejKgppKH9Pw2kJOSX22ycQYcXpFkAfehAO76fMu/9o/
         INUgiQBe6ZaJobJA7GcyVlkiihZkp0BaKOXbStywoTPU6NY9A814A97T6cQ8EZCxtbYb
         c3hw==
X-Gm-Message-State: AOAM531uljJ+bhPDpqq3SuPfD6V7JPNNKS18OHaBf+m4riPQ2SCzOTD8
        ZYXETc/dKZ48fiFSyaHOOxFfhoB0Tas=
X-Google-Smtp-Source: ABdhPJzZnC+97YvscCF3NJVKA1wVe6WlFDI8srf3t9P6ULxQXnbgtkMpgHO2RuiNHRw0EVNISLeHBg==
X-Received: by 2002:a65:4046:: with SMTP id h6mr31417369pgp.345.1618317699630;
        Tue, 13 Apr 2021 05:41:39 -0700 (PDT)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:485b:46b2:8be1:2cdd])
        by smtp.gmail.com with ESMTPSA id a25sm7988108pfo.27.2021.04.13.05.41.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Apr 2021 05:41:39 -0700 (PDT)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>
Subject: [PATCH net] gro: ensure frag0 meets IP header alignment
Date:   Tue, 13 Apr 2021 05:41:35 -0700
Message-Id: <20210413124136.2750358-1-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.31.1.295.g9ea45b61b8-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

After commit 0f6925b3e8da ("virtio_net: Do not pull payload in skb->head")
Guenter Roeck reported one failure in his tests using sh architecture.

After much debugging, we have been able to spot silent unaligned accesses
in inet_gro_receive()

The issue at hand is that upper networking stacks assume their header
is word-aligned. Low level drivers are supposed to reserve NET_IP_ALIGN
bytes before the Ethernet header to make that happen.

This patch hardens skb_gro_reset_offset() to not allow frag0 fast-path
if the fragment is not properly aligned.

Some arches like x86, arm64 and powerpc do not care and define NET_IP_ALIGN
as 0, this extra check will be a NOP for them.

Note that if frag0 is not used, GRO will call pskb_may_pull()
as many times as needed to pull network and transport headers.

Fixes: 0f6925b3e8da ("virtio_net: Do not pull payload in skb->head")
Fixes: 78a478d0efd9 ("gro: Inline skb_gro_header and cache frag0 virtual address")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reported-by: Guenter Roeck <linux@roeck-us.net>
Cc: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Cc: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Jason Wang <jasowang@redhat.com>
---
 net/core/dev.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/core/dev.c b/net/core/dev.c
index af8c1ea040b9364b076e2d72f04dc3de2d7e2f11..1f79b9aa9a3f2392fddd1401f95ad098b5e03204 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -5924,7 +5924,8 @@ static void skb_gro_reset_offset(struct sk_buff *skb)
 	NAPI_GRO_CB(skb)->frag0_len = 0;
 
 	if (!skb_headlen(skb) && pinfo->nr_frags &&
-	    !PageHighMem(skb_frag_page(frag0))) {
+	    !PageHighMem(skb_frag_page(frag0)) &&
+	    (!NET_IP_ALIGN || !(skb_frag_off(frag0) & 3))) {
 		NAPI_GRO_CB(skb)->frag0 = skb_frag_address(frag0);
 		NAPI_GRO_CB(skb)->frag0_len = min_t(unsigned int,
 						    skb_frag_size(frag0),
-- 
2.31.1.295.g9ea45b61b8-goog

