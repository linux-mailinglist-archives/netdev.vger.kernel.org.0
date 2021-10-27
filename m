Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B50343D602
	for <lists+netdev@lfdr.de>; Wed, 27 Oct 2021 23:46:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229534AbhJ0Vs3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Oct 2021 17:48:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229437AbhJ0Vs3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Oct 2021 17:48:29 -0400
Received: from mail-oi1-x263.google.com (mail-oi1-x263.google.com [IPv6:2607:f8b0:4864:20::263])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 446ECC061570
        for <netdev@vger.kernel.org>; Wed, 27 Oct 2021 14:46:03 -0700 (PDT)
Received: by mail-oi1-x263.google.com with SMTP id g125so5415741oif.9
        for <netdev@vger.kernel.org>; Wed, 27 Oct 2021 14:46:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=hdinRnkymwgowuW3/zzhXbpykU4a+XV563k5vOYr+/I=;
        b=Wc3IduUnBzQEl9OAqlwKx2mgAO21J1/6MbKoFSSJAndQd/qb3G2V5iIl0ZRLgSl5qu
         SZo82uIgyljFLT2F2iDVGg81cyOHhl3nF1+4TRFbDPS3iL5l/2jeE3B08TY/0eENOH3u
         MlYF8/f7BhN9fKYBP716IjzTcJGYIxAQXK4Yw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=hdinRnkymwgowuW3/zzhXbpykU4a+XV563k5vOYr+/I=;
        b=4G2b9by+r7WsbqlpHwovIP0FK6IBr1U3luftNMQxGwPfvvbagEshr7e8BKtFwXGbDM
         pE/5oST81K/+pD2unRVEBvlBkl5putMcU5tPz0RDFDqbZwVOGnhradNyKCjuhTQHEZuK
         AIgNoHPyagsRUT1FBuSVFfvV+DTh9oBGJi+qctgmYFrwaPQgcgJuTiDZyk9iSNCRhh88
         Ev57XaEXjbr0uHqVDZB43pTeGMMBUhkIqDXzPD1gjZKrvbWtlhQ41OYcFMEtRj8QsDiV
         OHXbNwjkthESgo7Im6kEvrC3UEe1QYif+OdKkJV2yUAQk6lEJiKhbIHWjXs0q9gXNo7r
         hsgw==
X-Gm-Message-State: AOAM530qabZIHbvj7Juf4RJescQKLREJDUiPbC+DiVXBmsVs0v79mtq1
        6ZHQAereLGUd5AHBypCubWmoUa5NqpqDMMUocGiMPRmkiNbr0z5eu7nHOIHXQxnoXQ==
X-Google-Smtp-Source: ABdhPJxMYe7/wGoms+QhGj1P2vhwYakCUWuuNCr3bJFbR6Ng+pspsnGAA3vnGG2oGb1CJzbzcNVRNoauHdQc
X-Received: by 2002:aca:4283:: with SMTP id p125mr5648027oia.81.1635371162526;
        Wed, 27 Oct 2021 14:46:02 -0700 (PDT)
Received: from c7-smtp.dev.purestorage.com ([2620:125:9007:320:7:32:106:0])
        by smtp-relay.gmail.com with ESMTPS id k3sm19704otn.9.2021.10.27.14.46.02
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 27 Oct 2021 14:46:02 -0700 (PDT)
X-Relaying-Domain: purestorage.com
Received: from dev-csander.dev.purestorage.com (dev-csander.dev.purestorage.com [10.7.70.37])
        by c7-smtp.dev.purestorage.com (Postfix) with ESMTP id 9AD812214A;
        Wed, 27 Oct 2021 15:46:01 -0600 (MDT)
Received: by dev-csander.dev.purestorage.com (Postfix, from userid 1557716354)
        id 98348E4078E; Wed, 27 Oct 2021 15:46:01 -0600 (MDT)
From:   Caleb Sander <csander@purestorage.com>
To:     netdev@vger.kernel.org
Cc:     Ariel Elior <aelior@marvell.com>, GR-everest-linux-l2@marvell.com,
        Caleb Sander <csander@purestorage.com>,
        Joern Engel <joern@purestorage.com>
Subject: [PATCH] qed: avoid spin loops in _qed_mcp_cmd_and_union()
Date:   Wed, 27 Oct 2021 15:45:19 -0600
Message-Id: <20211027214519.606096-1-csander@purestorage.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

By default, qed_mcp_cmd_and_union() sets max_retries to 500K and
usecs to 10, so these loops can together delay up to 5s.
We observed thread scheduling delays of over 700ms in production,
with stacktraces pointing to this code as the culprit.

Add calls to cond_resched() in both loops to yield the CPU if necessary.

Signed-off-by: Caleb Sander <csander@purestorage.com>
Reviewed-by: Joern Engel <joern@purestorage.com>
---
 drivers/net/ethernet/qlogic/qed/qed_mcp.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/qlogic/qed/qed_mcp.c b/drivers/net/ethernet/qlogic/qed/qed_mcp.c
index 24cd41567..d6944f020 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_mcp.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_mcp.c
@@ -485,10 +485,12 @@ _qed_mcp_cmd_and_union(struct qed_hwfn *p_hwfn,
 
 		spin_unlock_bh(&p_hwfn->mcp_info->cmd_lock);
 
-		if (QED_MB_FLAGS_IS_SET(p_mb_params, CAN_SLEEP))
+		if (QED_MB_FLAGS_IS_SET(p_mb_params, CAN_SLEEP)) {
 			msleep(msecs);
-		else
+		} else {
+			cond_resched();
 			udelay(usecs);
+		}
 	} while (++cnt < max_retries);
 
 	if (cnt >= max_retries) {
@@ -517,10 +519,12 @@ _qed_mcp_cmd_and_union(struct qed_hwfn *p_hwfn,
 		 * The spinlock stays locked until the list element is removed.
 		 */
 
-		if (QED_MB_FLAGS_IS_SET(p_mb_params, CAN_SLEEP))
+		if (QED_MB_FLAGS_IS_SET(p_mb_params, CAN_SLEEP)) {
 			msleep(msecs);
-		else
+		} else {
+			cond_resched();
 			udelay(usecs);
+		}
 
 		spin_lock_bh(&p_hwfn->mcp_info->cmd_lock);
 
-- 
2.25.1

