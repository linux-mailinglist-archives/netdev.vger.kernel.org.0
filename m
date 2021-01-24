Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A7B0301AB4
	for <lists+netdev@lfdr.de>; Sun, 24 Jan 2021 09:48:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726587AbhAXIqJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 Jan 2021 03:46:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726456AbhAXIp7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 24 Jan 2021 03:45:59 -0500
Received: from mail-pg1-x534.google.com (mail-pg1-x534.google.com [IPv6:2607:f8b0:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4528FC06174A
        for <netdev@vger.kernel.org>; Sun, 24 Jan 2021 00:45:09 -0800 (PST)
Received: by mail-pg1-x534.google.com with SMTP id v19so6866814pgj.12
        for <netdev@vger.kernel.org>; Sun, 24 Jan 2021 00:45:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :in-reply-to:references;
        bh=yF1/rZdC1UjfjxzVhZlCIxkNqUGI4he3FVfdNHhm1u0=;
        b=DnxOl4DO+Do8EXLOaalACs63drdQmC43tBRVk5Htr3/5OsYF4TzFitNCylHVSHSOqC
         VDJuI4Ut3++yPBwigUspgAtCQME9d4d8jV4DRx/hHC4Z0FdVjJeTciDFdwdw6lZK8ur+
         6DuThnCb6lHCgvXTzSQ82RpUG1IDbBQ460J5TDjHf7s6dRnav+Jx5JJAJKPp0Zfz8LWK
         qWPLIuHR8joiRNNwzxOEIxv3F0y1JNxZD/7uwFlWl8qgM/7C2kWuSWVee6NfGYSaZTua
         HsmHM66PW/L3nZsr2TVvzfx1cewsQNBazjZay76LvZCvbDdAYLviKepRuqCyl/wrnKY4
         YHFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:in-reply-to:references;
        bh=yF1/rZdC1UjfjxzVhZlCIxkNqUGI4he3FVfdNHhm1u0=;
        b=ep3mAIGMB0TJ0hcFPrd91TD1AkkE+OAMWXC7WCAg9241iexISaJFGdjN7FtLT/Wcmg
         JaN2+wtj/LPpywDLHNtJFvEmP6xCZmGGRLk2TCaz8NcTE8JKVhyDT4NM6/9ww1yiPq+V
         P3GiCqkesXnBbYJ++e1MqMD/L9qvPP9Xsj/9MEIXjvRk9y0fAlABhUIfptH6yZz0A0oP
         ZYobL7IRkcWGwjqEsKEVZQ0HePXzyPFDgI/ounojc2y0aD4P59/QLtmrPHsaOihKUIp+
         vnI9xPGJXMd9xTa+G4S+He1GdacB4XGMTTtfs5bWBlK13somF7CJej3jKZj1V19uhiJN
         MPsA==
X-Gm-Message-State: AOAM530ZdEDh2H/ZVGgPK6K3YiXP7Xp+vSVHATsf0mSzPtqj7nue42Bn
        ElbQx07wGDoLjv3m5s+Prx38ckCG8Ax+aw==
X-Google-Smtp-Source: ABdhPJx1tji78g97p0SQRGsXcEGVoeib9DhrpC+XLfbLrUIJGRKU00r50kaFRA8vFaTo4ADDtPMIwg==
X-Received: by 2002:a62:7fc1:0:b029:19f:1dab:5029 with SMTP id a184-20020a627fc10000b029019f1dab5029mr12835258pfd.13.1611477908613;
        Sun, 24 Jan 2021 00:45:08 -0800 (PST)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id i10sm13550354pgt.85.2021.01.24.00.45.07
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 24 Jan 2021 00:45:08 -0800 (PST)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>
Cc:     Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        davem@davemloft.net, Jakub Kicinski <kuba@kernel.org>,
        Davide Caratti <dcaratti@redhat.com>,
        Alexander Duyck <alexander.duyck@gmail.com>
Subject: [PATCH net-next 1/2] net: support ip generic csum processing in skb_csum_hwoffload_help
Date:   Sun, 24 Jan 2021 16:44:51 +0800
Message-Id: <100e0b32b0322e70127f415ea5b26afd26ac0fed.1611477858.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <cover.1611477858.git.lucien.xin@gmail.com>
References: <cover.1611477858.git.lucien.xin@gmail.com>
In-Reply-To: <cover.1611477858.git.lucien.xin@gmail.com>
References: <cover.1611477858.git.lucien.xin@gmail.com>
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

v1->v2:
  - not extend skb->csum_not_inet, but use skb->csum_offset to tell
    if it's an UDP/TCP csum packet.

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

