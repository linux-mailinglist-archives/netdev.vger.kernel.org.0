Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D6192F8BD6
	for <lists+netdev@lfdr.de>; Sat, 16 Jan 2021 07:14:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726395AbhAPGOl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 Jan 2021 01:14:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725781AbhAPGOl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 16 Jan 2021 01:14:41 -0500
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E111C0613D3;
        Fri, 15 Jan 2021 22:14:00 -0800 (PST)
Received: by mail-pl1-x632.google.com with SMTP id t6so5836829plq.1;
        Fri, 15 Jan 2021 22:14:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :in-reply-to:references;
        bh=I/5Du7qPUEoAkb/XhaPW7rJMvAwX/2S0SMJ5Ik87vvk=;
        b=oTLLb3ze9CaFXpQP4trMv2SGZ0RnAMg+FrqP0ctLs0vr2/fTEEVxRTg9QYSzes1VRL
         29r9Ql1o4LjHvX7BOIal8O+In4K2MaYV/vcwL+68tRRK7tsDQQzPsTAvDvWH48dsTAo6
         3j7MvPCmY0php0/57U/7U02tSavISNC/NdyeIUGmh+jbKUYBaFKUOHK/Ox1hfxQf0tCY
         n1issAJrv/DienryubwHhvlX5QFUazKSNGgwICQd9zVerwJya0WlUmj1bME7aJ3UEU3n
         ypZNyX1R76M+Xr5Lmib0kTpytxr+lMA+VBGvhxIh3oIkta9eoYS35e9mRlOgRw247rqF
         unfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:in-reply-to:references;
        bh=I/5Du7qPUEoAkb/XhaPW7rJMvAwX/2S0SMJ5Ik87vvk=;
        b=WoAkLmhzqbpBwy7Hqr0wzK2YlNr0gevP6tkx8SH2xiCC8vmWRlikRK5plEYb0bS/rI
         UZ97IyZun6GJAQFWbIIY1+LuMNShwmSGPUaCdUxl9K2DqmFqyUoUPgxeXOU87CNL7nwV
         SZXFww9pBOZuEARb2+hJgYWd1CkV7aXivx44xOETovHF4McMaEHJf0Rd0U9yKEHZPFQ9
         5o5jPMLSrzXdbgYuGDaARL7Ef68MyA8+2QlDmej5Koju+9M/fwVdPpwSk+ep6oDnkn0R
         lKD6VK9Bs7M3y+xI9MJ1GCu5u8sH9NiQN0ymJNYGPHN8ykGEuucNjmB+PfTMCLzpxsKG
         mcEA==
X-Gm-Message-State: AOAM532N6VEQkA/vhMMRcs1kwE0h8JwP/Z3kRJvXCx2Vp0gDVkVlpq8J
        S3DQXTpOKK/Bi1bP0SgnMtbRYqtRASFULA==
X-Google-Smtp-Source: ABdhPJwYE1rCasHJsP2JtEWgQWy0+8wznldbHOM8YUKDYBiZc7Pl4iJ8egKOwPwk3lKaTdt14uGQ3g==
X-Received: by 2002:a17:90a:9ac:: with SMTP id 41mr14531399pjo.46.1610777639488;
        Fri, 15 Jan 2021 22:13:59 -0800 (PST)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id t8sm10461353pjd.51.2021.01.15.22.13.58
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 15 Jan 2021 22:13:58 -0800 (PST)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc:     Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>, davem@davemloft.net,
        Jakub Kicinski <kuba@kernel.org>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        intel-wired-lan@lists.osuosl.org
Subject: [PATCH net-next 1/6] net: add inline function skb_csum_is_sctp
Date:   Sat, 16 Jan 2021 14:13:37 +0800
Message-Id: <34c9f5b8c31610687925d9db1f151d5bc87deba7.1610777159.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <cover.1610777159.git.lucien.xin@gmail.com>
References: <cover.1610777159.git.lucien.xin@gmail.com>
In-Reply-To: <cover.1610777159.git.lucien.xin@gmail.com>
References: <cover.1610777159.git.lucien.xin@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch is to define a inline function skb_csum_is_sctp(), and
also replace all places where it checks if it's a SCTP CSUM skb.
This function would be used later in many networking drivers in
the following patches.

Suggested-by: Alexander Duyck <alexander.duyck@gmail.com>
Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 drivers/net/ethernet/pensando/ionic/ionic_txrx.c | 2 +-
 include/linux/skbuff.h                           | 5 +++++
 net/core/dev.c                                   | 2 +-
 3 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/pensando/ionic/ionic_txrx.c b/drivers/net/ethernet/pensando/ionic/ionic_txrx.c
index ac4cd5d..162a1ff 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_txrx.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_txrx.c
@@ -979,7 +979,7 @@ static int ionic_tx_calc_csum(struct ionic_queue *q, struct sk_buff *skb)
 		stats->vlan_inserted++;
 	}
 
-	if (skb->csum_not_inet)
+	if (skb_csum_is_sctp(skb))
 		stats->crc32_csum++;
 	else
 		stats->csum++;
diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index c9568cf..46f901a 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -4621,6 +4621,11 @@ static inline void skb_reset_redirect(struct sk_buff *skb)
 #endif
 }
 
+static inline bool skb_csum_is_sctp(struct sk_buff *skb)
+{
+	return skb->csum_not_inet;
+}
+
 static inline void skb_set_kcov_handle(struct sk_buff *skb,
 				       const u64 kcov_handle)
 {
diff --git a/net/core/dev.c b/net/core/dev.c
index 0a31d4e..bbd306f 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -3617,7 +3617,7 @@ static struct sk_buff *validate_xmit_vlan(struct sk_buff *skb,
 int skb_csum_hwoffload_help(struct sk_buff *skb,
 			    const netdev_features_t features)
 {
-	if (unlikely(skb->csum_not_inet))
+	if (unlikely(skb_csum_is_sctp(skb)))
 		return !!(features & NETIF_F_SCTP_CRC) ? 0 :
 			skb_crc32c_csum_help(skb);
 
-- 
2.1.0

