Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8062821C6DC
	for <lists+netdev@lfdr.de>; Sun, 12 Jul 2020 02:49:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727914AbgGLAs7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Jul 2020 20:48:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726948AbgGLAs6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 11 Jul 2020 20:48:58 -0400
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54BA5C08C5DD
        for <netdev@vger.kernel.org>; Sat, 11 Jul 2020 17:48:58 -0700 (PDT)
Received: by mail-pj1-x1043.google.com with SMTP id k5so4416033pjg.3
        for <netdev@vger.kernel.org>; Sat, 11 Jul 2020 17:48:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=a7E5Y0QUDl9De63awScI6MSxW+qt8ojTBYIR7NZp7RQ=;
        b=Z5+CTMtPcY3ZPOmIS/A69kTAEVTLyTRM77M5nfWYJSpCGV+hV3Yc4ty0cMoYEpUGJk
         +Uq6C2hQgaD76M4SB7Pdlze/g2L9lQTFYWdun9XU4FcuwfqVVU738Llyg6UZer7z2Wpy
         hh+LVlVlbChCAXplw2rExwK4ufK1cZY2KpRZk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=a7E5Y0QUDl9De63awScI6MSxW+qt8ojTBYIR7NZp7RQ=;
        b=GIvHS1X/+8C8qQxAOfc5G3GkbHE4OsDUo8SQ9jBFUtfvShV8tGy8g+vMUFsPWzFoZC
         mvXllMZG+skvb1f95AMca3oqt/a0lGElAT2keFfA+Bc5t+m6ui8A7UWJMROl8YmMoApE
         hw7iVWWuyh5PY4ZRUeFh+0YUAsoO3Cpsh1kRHrW8g8xaoNNaCwrrORdk7c7lZM8ojTFc
         nNduz7bnU+Cm4JmKitggzuLNQVbr8bT/CSu74ahAwwE3gM43dDPYf4YFF25V+ouhkS/h
         ssqmPX+0wpOjRL7Oi8rCsv+lV85FHiSu1BRlRCOyHa74b12C/RSrTqvDnDaBtyZ5aVJz
         shxA==
X-Gm-Message-State: AOAM533yHIbCpeZkebg1E93xNbVKJkzJcassJm7Y32KnPOv8t0jmp7XF
        I+pyZ0GLu8Ia/CluUuGPNE+GGBQiE8Y=
X-Google-Smtp-Source: ABdhPJyuJyPX+nfBdPA2mi1eaLMV41nk92ctFUVYnnXM7AApwZu9CnETFi+cuuYoZgzZfTl50Z3Z1g==
X-Received: by 2002:a17:90b:1a86:: with SMTP id ng6mr13013196pjb.88.1594514937778;
        Sat, 11 Jul 2020 17:48:57 -0700 (PDT)
Received: from localhost.swdvt.lab.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id q6sm10157589pfg.76.2020.07.11.17.48.55
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 11 Jul 2020 17:48:57 -0700 (PDT)
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net 1/3] bnxt_en: Fix race when modifying pause settings.
Date:   Sat, 11 Jul 2020 20:48:23 -0400
Message-Id: <1594514905-688-2-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1594514905-688-1-git-send-email-michael.chan@broadcom.com>
References: <1594514905-688-1-git-send-email-michael.chan@broadcom.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vasundhara Volam <vasundhara-v.volam@broadcom.com>

The driver was modified to not rely on rtnl lock to protect link
settings about 2 years ago.  The pause setting was missed when
making that change.  Fix it by acquiring link_lock mutex before
calling bnxt_hwrm_set_pause().

Fixes: e2dc9b6e38fa ("bnxt_en: Don't use rtnl lock to protect link change logic in workqueue.")
Signed-off-by: Vasundhara Volam <vasundhara-v.volam@broadcom.com>
Reviewed-by: Edwin Peer <edwin.peer@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
index 6b88143..b4aa56d 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
@@ -1765,8 +1765,11 @@ static int bnxt_set_pauseparam(struct net_device *dev,
 	if (epause->tx_pause)
 		link_info->req_flow_ctrl |= BNXT_LINK_PAUSE_TX;
 
-	if (netif_running(dev))
+	if (netif_running(dev)) {
+		mutex_lock(&bp->link_lock);
 		rc = bnxt_hwrm_set_pause(bp);
+		mutex_unlock(&bp->link_lock);
+	}
 	return rc;
 }
 
-- 
1.8.3.1

