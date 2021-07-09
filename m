Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 85A7B3C2708
	for <lists+netdev@lfdr.de>; Fri,  9 Jul 2021 17:43:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232405AbhGIPqg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Jul 2021 11:46:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232269AbhGIPqg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Jul 2021 11:46:36 -0400
Received: from mail-qt1-x82a.google.com (mail-qt1-x82a.google.com [IPv6:2607:f8b0:4864:20::82a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5B40C0613DD
        for <netdev@vger.kernel.org>; Fri,  9 Jul 2021 08:43:51 -0700 (PDT)
Received: by mail-qt1-x82a.google.com with SMTP id d1so7891631qto.4
        for <netdev@vger.kernel.org>; Fri, 09 Jul 2021 08:43:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=wf5dC1+OO8X1FTDU3W8+cu2By12/7/1B+AQomCmsAiw=;
        b=QbQQKMlzbBh5hAEj+ZUmKBoRrZjs6M5S024RPta5oLnlS1QFl/gm6fhOMfrLOM4Rk0
         jsfiAV8xlRSi9DmvBPw3vqQvwGLzc4BLkbLGX7ktkzxuVn+g7OnoFqx3lHSqg5JuYOtr
         J3MTUR/7bszyVqfjCWx898YAepAnL60iV5LhxhGlw3T5NPO+c2pArpGFCqV7NLpKN/KU
         uUFAb+0GX7XNhpIKRoD9ZXPs1xSBbqJZx7yl2xBwWP/vUl2tmdvHoZap5zdVozRTzjVG
         RcrYr8QcwVvMWGsZKfRt9ZNBFUoOHU3PtiUOt6NeL1MROBzriXVOp1BIJ8rs2EvZ7VSS
         dL1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=wf5dC1+OO8X1FTDU3W8+cu2By12/7/1B+AQomCmsAiw=;
        b=BtOlw5gcvY2TdwdBN5u5KSw6dtUP0OYas5RUud48pvrQcQ0anzjBD9WsaJyt0VUj7g
         H4n6SGXhBSXqpzeMaW+JUfsTAnoUvpy1kYs2c67hOMquK6l4LvwMH7lRsvmSFv0SzqqH
         9zfomU1jNnGYzkHKZF2OQMIuN0i6cULxNkco/OvtSDx/grbI2uSpeU4xkqLTvs44oO+1
         vGws8hiax1UTFJUVSqK+ZnKqFYlZCLdv9j4p+koNdGJ/G3flXYNzc5IuKjLb/4D13UHP
         f3eXhOs3rpuRwRTsHSrTI3bjYnHhbch0yj+KF/vKnv6n9iTDhznHWYxxkVaYuJsCaIMT
         +6vQ==
X-Gm-Message-State: AOAM531fVmAjesMcIALFde8wv4YmA6SBTiYZ/z40T8kT2lsVthHZ3lUH
        5xHbejYlOIQ00+WEvq2T05dhg9dtDwIzEg==
X-Google-Smtp-Source: ABdhPJyGkvuOFpVyM3tFZyJ38THGFkFVNhx3T9VltBXv0gfRh8kG267qibZ0dvvg2mrI9A/lFiDg5A==
X-Received: by 2002:ac8:74c4:: with SMTP id j4mr180203qtr.161.1625845430980;
        Fri, 09 Jul 2021 08:43:50 -0700 (PDT)
Received: from talalahmad1.nyc.corp.google.com ([2620:0:1003:312:1ee8:3b51:b598:8f8d])
        by smtp.gmail.com with ESMTPSA id x28sm2441331qtm.71.2021.07.09.08.43.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Jul 2021 08:43:50 -0700 (PDT)
From:   Talal Ahmad <mailtalalahmad@gmail.com>
To:     David Miller <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, Talal Ahmad <talalahmad@google.com>,
        Willem de Bruijn <willemb@google.com>,
        Wei Wang <weiwan@google.com>,
        Soheil Hassas Yeganeh <soheil@google.com>,
        Eric Dumazet <edumazet@google.com>
Subject: [PATCH net] tcp: call sk_wmem_schedule before sk_mem_charge in zerocopy path
Date:   Fri,  9 Jul 2021 11:43:06 -0400
Message-Id: <20210709154306.2276391-1-mailtalalahmad@gmail.com>
X-Mailer: git-send-email 2.32.0.93.g670b81a890-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Talal Ahmad <talalahmad@google.com>

sk_wmem_schedule makes sure that sk_forward_alloc has enough
bytes for charging that is going to be done by sk_mem_charge.

In the transmit zerocopy path, there is sk_mem_charge but there was
no call to sk_wmem_schedule. This change adds that call.

Without this call to sk_wmem_schedule, sk_forward_alloc can go
negetive which is a bug because sk_forward_alloc is a per-socket
space that has been forward charged so this can't be negative.

Fixes: f214f915e7db ("tcp: enable MSG_ZEROCOPY")
Signed-off-by: Talal Ahmad <talalahmad@google.com>
Reviewed-by: Willem de Bruijn <willemb@google.com>
Reviewed-by: Wei Wang <weiwan@google.com>
Reviewed-by: Soheil Hassas Yeganeh <soheil@google.com>
Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 net/ipv4/tcp.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index d5ab5f243640..8cb44040ec68 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -1375,6 +1375,9 @@ int tcp_sendmsg_locked(struct sock *sk, struct msghdr *msg, size_t size)
 			}
 			pfrag->offset += copy;
 		} else {
+			if (!sk_wmem_schedule(sk, copy))
+				goto wait_for_space;
+
 			err = skb_zerocopy_iter_stream(sk, skb, msg, copy, uarg);
 			if (err == -EMSGSIZE || err == -EEXIST) {
 				tcp_mark_push(tp, skb);
-- 
2.32.0.93.g670b81a890-goog

