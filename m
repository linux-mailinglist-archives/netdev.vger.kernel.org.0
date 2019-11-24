Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 715E4108196
	for <lists+netdev@lfdr.de>; Sun, 24 Nov 2019 04:32:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727095AbfKXDbc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 23 Nov 2019 22:31:32 -0500
Received: from mail-pf1-f195.google.com ([209.85.210.195]:38383 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727071AbfKXDbb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 23 Nov 2019 22:31:31 -0500
Received: by mail-pf1-f195.google.com with SMTP id c13so5580204pfp.5
        for <netdev@vger.kernel.org>; Sat, 23 Nov 2019 19:31:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=ZYpmNvjxbXfyCZqHEdGn7Jrx+pFdBX8t7L6GtZ4CRG0=;
        b=IwVb4olvEdTsc37WVyZugbqqmMeMZcXb2v8ffxTW+5lBWNmXGyd9JStgAuSq+IxtZI
         cQZ6L6m3YNUwVT4uTOos7JBZYwMwTCmIbLDBqEQoAiNYcF17caf8Mv2ujknj83bNcxjM
         3pe3AAf7EHBzf40HX757LI5qQ/DH22Y77FwWg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=ZYpmNvjxbXfyCZqHEdGn7Jrx+pFdBX8t7L6GtZ4CRG0=;
        b=k5ASXpv83uPQn+pJ3CGkDBidxVf8YI23ubi2mphmP24QnFsGW18O9dUTlnZla+L9EK
         OyGTwXMYbFgKQPjIAHlq+XfKXXk0KBH7uzz7oxPxAT4sbd7iK6xNGZ42yiegz3pPVXtl
         OSCH6z0ltOAo/VqGg86CiB3k/LbRlE18XkFPcSITcPf2TZW/IU5yH08KZnwHhKPiQ63X
         RbnWCKBOXnq7jjNO1GlmkkRHh+VKXSCGIEisUZ2kCnaJ6w0+hXLkhuErGkwV0ulN+K8l
         iUyMUlWd9Cq2ANO+WFjA/JYgpUGA6sSHid2lwjXc6UrpX5/83riNGEhmfWwz1FJYLqsY
         Tu+w==
X-Gm-Message-State: APjAAAWNElHdpOHfMKzcO66jZuvH7cEB9PXibST0klDxfpYbKdmPXwND
        /pm1b6q8vXAHGglKIyQgB6MXKg==
X-Google-Smtp-Source: APXvYqxnF1ermyOW1qVy3jN4EbUjS9YlvbDp0akIHm6D048+Czwlf0G23WwWHC71lMwLnrB/k+5Pfw==
X-Received: by 2002:a63:3741:: with SMTP id g1mr5326720pgn.434.1574566290775;
        Sat, 23 Nov 2019 19:31:30 -0800 (PST)
Received: from localhost.swdvt.lab.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id v63sm3111901pfb.181.2019.11.23.19.31.28
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 23 Nov 2019 19:31:30 -0800 (PST)
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net, jakub.kicinski@netronome.com
Cc:     netdev@vger.kernel.org
Subject: [PATCH net-next v2 09/13] bnxt_en: Skip disabling autoneg before PHY loopback when appropriate.
Date:   Sat, 23 Nov 2019 22:30:46 -0500
Message-Id: <1574566250-7546-10-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1574566250-7546-1-git-send-email-michael.chan@broadcom.com>
References: <1574566250-7546-1-git-send-email-michael.chan@broadcom.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

New firmware allows PHY loopback to be set without disabling autoneg
first.  Check this capability and skip disabling autoneg when
it is supported by firmware.  Using this scheme, loopback will
always work even if the PHY only supports autoneg.

Signed-off-by: Michael Chan <michael.chan@broadcom.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c         | 7 ++++++-
 drivers/net/ethernet/broadcom/bnxt/bnxt.h         | 3 ++-
 drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c | 3 ++-
 3 files changed, 10 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index 0e384c5..9d02232 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -8419,7 +8419,8 @@ static int bnxt_hwrm_phy_qcaps(struct bnxt *bp)
 
 	bp->flags &= ~BNXT_FLAG_EEE_CAP;
 	if (bp->test_info)
-		bp->test_info->flags &= ~BNXT_TEST_FL_EXT_LPBK;
+		bp->test_info->flags &= ~(BNXT_TEST_FL_EXT_LPBK |
+					  BNXT_TEST_FL_AN_PHY_LPBK);
 	if (bp->hwrm_spec_code < 0x10201)
 		return 0;
 
@@ -8445,6 +8446,10 @@ static int bnxt_hwrm_phy_qcaps(struct bnxt *bp)
 		if (bp->test_info)
 			bp->test_info->flags |= BNXT_TEST_FL_EXT_LPBK;
 	}
+	if (resp->flags & PORT_PHY_QCAPS_RESP_FLAGS_AUTONEG_LPBK_SUPPORTED) {
+		if (bp->test_info)
+			bp->test_info->flags |= BNXT_TEST_FL_AN_PHY_LPBK;
+	}
 	if (resp->supported_speeds_auto_mode)
 		link_info->support_auto_speeds =
 			le16_to_cpu(resp->supported_speeds_auto_mode);
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.h b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
index dbdd097..94c8a92 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.h
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
@@ -1226,7 +1226,8 @@ struct bnxt_led_info {
 struct bnxt_test_info {
 	u8 offline_mask;
 	u8 flags;
-#define BNXT_TEST_FL_EXT_LPBK	0x1
+#define BNXT_TEST_FL_EXT_LPBK		0x1
+#define BNXT_TEST_FL_AN_PHY_LPBK	0x2
 	u16 timeout;
 	char string[BNXT_MAX_TEST][ETH_GSTRING_LEN];
 };
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
index 0641020..62ef847 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
@@ -2698,7 +2698,8 @@ static int bnxt_disable_an_for_lpbk(struct bnxt *bp,
 	u16 fw_speed;
 	int rc;
 
-	if (!link_info->autoneg)
+	if (!link_info->autoneg ||
+	    (bp->test_info->flags & BNXT_TEST_FL_AN_PHY_LPBK))
 		return 0;
 
 	rc = bnxt_query_force_speeds(bp, &fw_advertising);
-- 
2.5.1

