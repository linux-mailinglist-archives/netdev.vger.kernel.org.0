Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A8DB43072A1
	for <lists+netdev@lfdr.de>; Thu, 28 Jan 2021 10:29:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232455AbhA1JVI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jan 2021 04:21:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232516AbhA1JT3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Jan 2021 04:19:29 -0500
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5EC3BC06174A
        for <netdev@vger.kernel.org>; Thu, 28 Jan 2021 01:18:49 -0800 (PST)
Received: by mail-pf1-x42a.google.com with SMTP id w18so3593651pfu.9
        for <netdev@vger.kernel.org>; Thu, 28 Jan 2021 01:18:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :in-reply-to:references;
        bh=eWfTH8I5aZb+Qsz9WIhVj682ORKxn6wMT2Ob0SnJQMs=;
        b=WRu/WLLADRMs7rOUUXYsaT0bBvccGuMdgRjSgp0oySkSQqUTvO3R6QcBxVcEzUBVod
         gawynDuw/AF85FxcuRIEx078kvyQ/M8AugjhAdo71cw/MNvMIBIDwaNLpaM5QzyR6Tm2
         Wydb3MDeSG/56yuBjhYp6fmoyeT8ZnJATyQtEjlLyyWk4XATvhSzyNxBJEqxBPlIAX8w
         6UfkUMEFGeNyUi135rZnJlUCxC/RwqO9I+AYIiu+iyYRLU+f2tlg2bE8+/NtXD4WyOb2
         lvu00jmNbTn1DrfG7HuMB33abk+yFkgV/+E6c2zCTRyF4Ab0tFUkqdfv9Ru/lCrQX92y
         VpZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:in-reply-to:references;
        bh=eWfTH8I5aZb+Qsz9WIhVj682ORKxn6wMT2Ob0SnJQMs=;
        b=JHHmBJyuHpTeGsXfj3zxWotH6+0fk8rAimA5GVJ8CRRKKRNJEzfUsmXIbwG28OpYIM
         Kw5WKJx2A48EKNkmUjUYXJj6vo38CPJmsc9kzgDsGC1N0Ty9tCKmhTXgnhyV7XlB52yJ
         CU7hXVWltJLOjEuk3J2klvtDjuH6JPDqeqc52GwtBFewIz3jkzpagOeR+LkM0rmZH5DN
         ghePqmPaIR3rmBklJIt3K5h6EnKdP3jHLED4Tu0zqS/deABQ8fvpfGgtHuqT+FnpQB1T
         Fkly9IWx9MgnvhhW9OT/i09ZFqMMqgQ6Sf8XxIyVnE3mHLy8An6uqOB6jNaNemftxFU3
         ucJw==
X-Gm-Message-State: AOAM531kOyyGNeswS47XgQAIFVq1Skcjeug/vlmIZV/qgL7gMXfX5M7g
        3vhUHA409D/mFqxNfRZ7noQbq3vKa03Dxw==
X-Google-Smtp-Source: ABdhPJyTAI/fFaRhNbltKHUy3ZiX6MCX2j+aNYU5jyn/FBZQSLsqq9V7Ae/QfSR0yFuWTyZtb0gHzg==
X-Received: by 2002:aa7:90cf:0:b029:1a3:a176:f4d0 with SMTP id k15-20020aa790cf0000b02901a3a176f4d0mr14916769pfk.8.1611825528641;
        Thu, 28 Jan 2021 01:18:48 -0800 (PST)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id o14sm4618646pjf.12.2021.01.28.01.18.47
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 28 Jan 2021 01:18:48 -0800 (PST)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>
Cc:     Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Davide Caratti <dcaratti@redhat.com>, davem@davemloft.net,
        Jakub Kicinski <kuba@kernel.org>,
        Willem de Bruijn <willemb@google.com>,
        Alexander Duyck <alexander.duyck@gmail.com>
Subject: [PATCHv3 net-next 1/2] net: support ip generic csum processing in skb_csum_hwoffload_help
Date:   Thu, 28 Jan 2021 17:18:31 +0800
Message-Id: <02bef0921778d2053ab63140c31704712bb5a864.1611825446.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <cover.1611825446.git.lucien.xin@gmail.com>
References: <cover.1611825446.git.lucien.xin@gmail.com>
In-Reply-To: <cover.1611825446.git.lucien.xin@gmail.com>
References: <cover.1611825446.git.lucien.xin@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

NETIF_F_IP|IPV6_CSUM feature flag indicates UDP and TCP csum offload
while NETIF_F_HW_CSUM feature flag indicates ip generic csum offload
for HW, which includes not only for TCP/UDP csum, but also for other
protocols' csum like GRE's.

However, in skb_csum_hwoffload_help() it only checks features against
NETIF_F_CSUM_MASK(NETIF_F_HW|IP|IPV6_CSUM). So if it's a non TCP/UDP
packet and the features doesn't support NETIF_F_HW_CSUM, but supports
NETIF_F_IP|IPV6_CSUM only, it would still return 0 and leave the HW
to do csum.

This patch is to support ip generic csum processing by checking
NETIF_F_HW_CSUM for all protocols, and check (NETIF_F_IP_CSUM |
NETIF_F_IPV6_CSUM) only for TCP and UDP.

Note that we're using skb->csum_offset to check if it's a TCP/UDP
proctol, this might be fragile. However, as Alex said, for now we
only have a few L4 protocols that are requesting Tx csum offload,
we'd better fix this until a new protocol comes with a same csum
offset.

v1->v2:
  - not extend skb->csum_not_inet, but use skb->csum_offset to tell
    if it's an UDP/TCP csum packet.
v2->v3:
  - add a note in the changelog, as Willem suggested.

Suggested-by: Alexander Duyck <alexander.duyck@gmail.com>
Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 net/core/dev.c | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/net/core/dev.c b/net/core/dev.c
index 6df3f1b..aae116d 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -3621,7 +3621,18 @@ int skb_csum_hwoffload_help(struct sk_buff *skb,
 		return !!(features & NETIF_F_SCTP_CRC) ? 0 :
 			skb_crc32c_csum_help(skb);
 
-	return !!(features & NETIF_F_CSUM_MASK) ? 0 : skb_checksum_help(skb);
+	if (features & NETIF_F_HW_CSUM)
+		return 0;
+
+	if (features & (NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM)) {
+		switch (skb->csum_offset) {
+		case offsetof(struct tcphdr, check):
+		case offsetof(struct udphdr, check):
+			return 0;
+		}
+	}
+
+	return skb_checksum_help(skb);
 }
 EXPORT_SYMBOL(skb_csum_hwoffload_help);
 
-- 
2.1.0

