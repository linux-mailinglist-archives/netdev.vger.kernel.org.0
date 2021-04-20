Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B37D1366089
	for <lists+netdev@lfdr.de>; Tue, 20 Apr 2021 22:01:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233747AbhDTUCW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Apr 2021 16:02:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233541AbhDTUCV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Apr 2021 16:02:21 -0400
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CECA8C06174A
        for <netdev@vger.kernel.org>; Tue, 20 Apr 2021 13:01:48 -0700 (PDT)
Received: by mail-pf1-x42d.google.com with SMTP id h11so8724352pfn.0
        for <netdev@vger.kernel.org>; Tue, 20 Apr 2021 13:01:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=5Du+IgrLZVk7ZDdZOmMvPOwEkpYwzoUizXPLLUwb/Xs=;
        b=sFilqoIvdyvdUn2hWPJbGe/ooVv4/L2Dap7lINRZHOYNqZcW5XfWpNsE5bCbHWP5e7
         WPH4qSp8X2Jv3ZYO55OcPeufO4FGq+qqnFChoXx2+Mk1P5y/kS2HsVAeD9mR0Y8Fq3nC
         kIxV+sBhyAK3eW/6J27xvzd+yEOasxlLZE0UbJTKl0PgjlfQya6Cj6+gRhtczMWkx1LT
         XgvI2SGlY78L2kxfBw3giaej/lLt01GXEsLmWrSwpKuc+l68vp6bsUWfYtPqnPUz+A/o
         0cK3Q3o1jOCbYcSRjhiHBXFiYfyIbFWgS/SzLnt/rocIbszzXRSiqRZGXIS8YGIDTSFb
         UB3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=5Du+IgrLZVk7ZDdZOmMvPOwEkpYwzoUizXPLLUwb/Xs=;
        b=ljAV06QdvCE4yK2UljR3UgEjGQIzrFMhMo9Y10ZqrarXYN5L64l1m7GgihZZT63dlu
         0Al5U8vhYYY/pmd/X2zdgovtoXVLPVBDfYhOhnhZZp+LDgtP37mPetlV+ypQtBWpfJIN
         R4vWeTjD4+rU3BxbNIhxEKZzfH7yICihag1U3R9j3IFViyVg5Q4D/LkuaP1MyzPgubzc
         qwFZi7ZxI71C/FkwepCnMuqLSkjTIvSeZYnMdDAZuHL5WLCxGpyQZzt1IRxuVkro694U
         +DlKcvQN01C+1vNPj7BRZg2cn2DpIB+VzW25E3t+JtqPnJQZgnAy6rrkGNXVTn87mpmh
         ZBCw==
X-Gm-Message-State: AOAM530XrK921PGAMz35+rMdZUDN95zfxzFPmFFS4CDrddQNF6TP6LGp
        fAJiPYEGe1LPfI28o9m39s4=
X-Google-Smtp-Source: ABdhPJwAprjfL6fB0YmGSq6icSibdyl0XAn+8HLS1XyldP7O8e6qmhRuYHSc0TD53nD3Mv/n4S/TRw==
X-Received: by 2002:a17:90a:6583:: with SMTP id k3mr4578048pjj.227.1618948908347;
        Tue, 20 Apr 2021 13:01:48 -0700 (PDT)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:71c5:2f2b:f562:605b])
        by smtp.gmail.com with ESMTPSA id e14sm16367605pga.14.2021.04.20.13.01.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Apr 2021 13:01:47 -0700 (PDT)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
        Jason Wang <jasowang@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        virtualization@lists.linux-foundation.org
Subject: [PATCH net-next] virtio-net: restrict build_skb() use to some arches
Date:   Tue, 20 Apr 2021 13:01:44 -0700
Message-Id: <20210420200144.4189597-1-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.31.1.368.gbe11c130af-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

build_skb() is supposed to be followed by
skb_reserve(skb, NET_IP_ALIGN), so that IP headers are word-aligned.
(Best practice is to reserve NET_IP_ALIGN+NET_SKB_PAD, but the NET_SKB_PAD
part is only a performance optimization if tunnel encaps are added.)

Unfortunately virtio_net has not provisioned this reserve.
We can only use build_skb() for arches where NET_IP_ALIGN == 0

We might refine this later, with enough testing.

Fixes: fb32856b16ad ("virtio-net: page_to_skb() use build_skb when there's sufficient tailroom")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reported-by: Guenter Roeck <linux@roeck-us.net>
Cc: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Cc: Jason Wang <jasowang@redhat.com>
Cc: "Michael S. Tsirkin" <mst@redhat.com>
Cc: virtualization@lists.linux-foundation.org
---
 drivers/net/virtio_net.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index 2e28c04aa6351d2b4016f7d277ce104c4970069d..74d2d49264f3f3b7039be70331d4a44c53b8cc28 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -416,7 +416,7 @@ static struct sk_buff *page_to_skb(struct virtnet_info *vi,
 
 	shinfo_size = SKB_DATA_ALIGN(sizeof(struct skb_shared_info));
 
-	if (len > GOOD_COPY_LEN && tailroom >= shinfo_size) {
+	if (!NET_IP_ALIGN && len > GOOD_COPY_LEN && tailroom >= shinfo_size) {
 		skb = build_skb(p, truesize);
 		if (unlikely(!skb))
 			return NULL;
-- 
2.31.1.368.gbe11c130af-goog

