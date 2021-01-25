Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B740E303439
	for <lists+netdev@lfdr.de>; Tue, 26 Jan 2021 06:21:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732008AbhAZFUR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jan 2021 00:20:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730249AbhAYPm1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Jan 2021 10:42:27 -0500
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42883C06178C;
        Mon, 25 Jan 2021 07:09:54 -0800 (PST)
Received: by mail-pl1-x62b.google.com with SMTP id j21so3163725pls.7;
        Mon, 25 Jan 2021 07:09:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=RYxADnYMRchUgTOy48tkQSBlztEHNvLefhQm8TPvbX0=;
        b=sE8UuLyxUfm0R4uGaLB4Yj6rj1oV2Rr2w5Lna6duL1SdE0meCn62CPUc+O1qIjjO5+
         Jf4t+FD2yuTzrFBRPOLhPPhU87kko7zcG4AUhOtc2Qn4KmsyjW5H7TE8/FLxURP4kcWG
         CQE0N/EuPsqso3bST75Kd4KLlJ7n6MPAmN6yNUYt4OFxjf+d+skH/cup52yLgPHojI2Y
         /rdtADiyylRdzfWeADLXla7tl5oqESqOzmm4RmFN8fSkLjOdUnQ7xD6oePunDtOCpivG
         6cGmAF5JsRclbyIQTu3hXmYabXG+pAGg4l1Ild+miGKPs1u46fGv0abNExDE11VEixxS
         4/LA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=RYxADnYMRchUgTOy48tkQSBlztEHNvLefhQm8TPvbX0=;
        b=QnkyVWiKpu6xJ01KGNuPwsNWNWeMahF3PrBMHb9Qzvb/OHBk/qx9oYyEhNdkAR/LeK
         FyPMssRU+Tu8HePiao7At+wse9VQXN7+xLMG4EQW+6tMI3WAIIvqE00wl58zFg4hmJBj
         zLMkxmWKzlIaa/OvDk7KqiGrMTQPge89qhE5zWqjVhZBsQM9+TaiKcDV6VK5gBU7V3Pv
         ZJyl/NfxBNebcfI9mr3ngNpQW60HlAEpDlsxrKiHdKkj3cmCPj1AEXC9y69logHo7TPZ
         oAo9hcspBNcDrrfzGM0PVrgm2um7SIohKWkjmNoAy/hgnFqiJeIMfuMZDpCU2ac9oR+H
         evFQ==
X-Gm-Message-State: AOAM530Y7dX8jN83pGnLc3A0S1RtORczGKpYW/qdeBJVRyf2P+pGgVuR
        Swac4A4hIgLpXVebuTUMLnI=
X-Google-Smtp-Source: ABdhPJxDXCu6YdnfYRFewUmZwuTYEoFvmSjWkLU0XEZelSLgTNlBv83PeBIU35IndnUysO9dNHzeyA==
X-Received: by 2002:a17:90b:46cf:: with SMTP id jx15mr635181pjb.61.1611587393778;
        Mon, 25 Jan 2021 07:09:53 -0800 (PST)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:7220:84ff:fe09:1424])
        by smtp.gmail.com with ESMTPSA id i1sm18134090pfb.54.2021.01.25.07.09.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Jan 2021 07:09:53 -0800 (PST)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Ben Greear <greearb@candelatech.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        linux-wireless@vger.kernel.org,
        Johannes Berg <johannes@sipsolutions.net>
Subject: [PATCH net] iwlwifi: provide gso_type to GSO packets
Date:   Mon, 25 Jan 2021 07:09:49 -0800
Message-Id: <20210125150949.619309-1-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.30.0.280.ga3ce27912f-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

net/core/tso.c got recent support for USO, and this broke iwlfifi
because the driver implemented a limited form of GSO.

Providing ->gso_type allows for skb_is_gso_tcp() to provide
a correct result.

Fixes: 3d5b459ba0e3 ("net: tso: add UDP segmentation support")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reported-by: Ben Greear <greearb@candelatech.com>
Bisected-by: Ben Greear <greearb@candelatech.com>
Tested-by: Ben Greear <greearb@candelatech.com>
Cc: Luca Coelho <luciano.coelho@intel.com>
Cc: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes@sipsolutions.net>
---
 drivers/net/wireless/intel/iwlwifi/mvm/tx.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/tx.c b/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
index a983c215df310776ffe67f3b3ffa203eab609bfc..3712adc3ccc2511d46bcc855efbfba41c487d8e6 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
@@ -773,6 +773,7 @@ iwl_mvm_tx_tso_segment(struct sk_buff *skb, unsigned int num_subframes,
 
 	next = skb_gso_segment(skb, netdev_flags);
 	skb_shinfo(skb)->gso_size = mss;
+	skb_shinfo(skb)->gso_type = ipv4 ? SKB_GSO_TCPV4 : SKB_GSO_TCPV6;
 	if (WARN_ON_ONCE(IS_ERR(next)))
 		return -EINVAL;
 	else if (next)
@@ -795,6 +796,8 @@ iwl_mvm_tx_tso_segment(struct sk_buff *skb, unsigned int num_subframes,
 
 		if (tcp_payload_len > mss) {
 			skb_shinfo(tmp)->gso_size = mss;
+			skb_shinfo(tmp)->gso_type = ipv4 ? SKB_GSO_TCPV4 :
+							   SKB_GSO_TCPV6;
 		} else {
 			if (qos) {
 				u8 *qc;
-- 
2.30.0.280.ga3ce27912f-goog

