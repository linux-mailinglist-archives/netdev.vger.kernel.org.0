Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 13F573BD59B
	for <lists+netdev@lfdr.de>; Tue,  6 Jul 2021 14:21:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234238AbhGFMX2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Jul 2021 08:23:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:42668 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235815AbhGFLa1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 6 Jul 2021 07:30:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 02FF661DE8;
        Tue,  6 Jul 2021 11:21:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625570514;
        bh=wKQaD3i8J5jYXUh1Yy/Y0cldgAZqqXbZWRzqs1T2oP4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DYqaix3YeMAPH86SEV6rwcXDwLHNY0MFgbC6mZpdAPAFpzAMUo/Fgryd/7vwREkhu
         SYpLlcEGw0ORTtH2nFTPGh1QE2LrmGXWRIWipc7fG5zydsdrey+uy6Z58Q0S08liqM
         yAzaDcM44WcJu3HGqp29Vj1iRs1aaWk7/qAtXgInfA8vrqh/bUHvLNFBtnkApAolW4
         Q+vf9CcwAkwR5Mzec9Ir5hiA+cxGvlm27gQVC32IWjP0u9RfRe/uQFFQSrDe6Exmum
         c/v9HD2uqe56/ETn0jP5CYy31s7LB4Jf132w4AkQUaBeQrMHuVYqRtxMUXS9qkMEhv
         3mmgGkblSa9rw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     gushengxian <gushengxian@yulong.com>,
        gushengxian <13145886936@163.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.12 155/160] flow_offload: action should not be NULL when it is referenced
Date:   Tue,  6 Jul 2021 07:18:21 -0400
Message-Id: <20210706111827.2060499-155-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210706111827.2060499-1-sashal@kernel.org>
References: <20210706111827.2060499-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: gushengxian <gushengxian@yulong.com>

[ Upstream commit 9ea3e52c5bc8bb4a084938dc1e3160643438927a ]

"action" should not be NULL when it is referenced.

Signed-off-by: gushengxian <13145886936@163.com>
Signed-off-by: gushengxian <gushengxian@yulong.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/flow_offload.h | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/include/net/flow_offload.h b/include/net/flow_offload.h
index e6bd8ebf9ac3..c28ea1f0ec9c 100644
--- a/include/net/flow_offload.h
+++ b/include/net/flow_offload.h
@@ -313,12 +313,14 @@ flow_action_mixed_hw_stats_check(const struct flow_action *action,
 	if (flow_offload_has_one_action(action))
 		return true;
 
-	flow_action_for_each(i, action_entry, action) {
-		if (i && action_entry->hw_stats != last_hw_stats) {
-			NL_SET_ERR_MSG_MOD(extack, "Mixing HW stats types for actions is not supported");
-			return false;
+	if (action) {
+		flow_action_for_each(i, action_entry, action) {
+			if (i && action_entry->hw_stats != last_hw_stats) {
+				NL_SET_ERR_MSG_MOD(extack, "Mixing HW stats types for actions is not supported");
+				return false;
+			}
+			last_hw_stats = action_entry->hw_stats;
 		}
-		last_hw_stats = action_entry->hw_stats;
 	}
 	return true;
 }
-- 
2.30.2

