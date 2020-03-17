Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3C8A618778B
	for <lists+netdev@lfdr.de>; Tue, 17 Mar 2020 02:42:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726651AbgCQBmr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Mar 2020 21:42:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:46492 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726596AbgCQBmr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 16 Mar 2020 21:42:47 -0400
Received: from kicinski-fedora-PC1C0HJN.thefacebook.com (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8EEB420719;
        Tue, 17 Mar 2020 01:42:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584409366;
        bh=dajjltS70DyT0tGcFX9CImUOD2RAIdlVGDKEpxCSmhY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2FKcCT4yUOLyEnY9Mtf9l9EWT4ipnYLHD7eaTdsx/OR0T2ktTcPhvh+2b1YIfYUfU
         OTHJojLQOL4AK+ZqX+0kZ2POKrSCC3DeeHAmav/UlGVfl+dn574hG9qslpHfupFnrX
         7VQ9x9ulQyUxzfQWzN82lwntpbuhNI28x545xu3c=
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net, jiri@resnulli.us
Cc:     netdev@vger.kernel.org, kernel-team@fb.com, ecree@solarflare.com,
        pablo@netfilter.org, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next 2/2] nfp: allow explicitly selected delayed stats
Date:   Mon, 16 Mar 2020 18:42:12 -0700
Message-Id: <20200317014212.3467451-3-kuba@kernel.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200317014212.3467451-1-kuba@kernel.org>
References: <20200317014212.3467451-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

NFP flower offload uses delayed stats. Kernel recently gained
the ability to specify stats types. Make nfp accept DELAYED
stats, not just the catch all "any".

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 drivers/net/ethernet/netronome/nfp/flower/action.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/netronome/nfp/flower/action.c b/drivers/net/ethernet/netronome/nfp/flower/action.c
index 5fb9869f85d7..1c76e1592ca2 100644
--- a/drivers/net/ethernet/netronome/nfp/flower/action.c
+++ b/drivers/net/ethernet/netronome/nfp/flower/action.c
@@ -1207,7 +1207,8 @@ int nfp_flower_compile_action(struct nfp_app *app,
 	bool pkt_host = false;
 	u32 csum_updated = 0;
 
-	if (!flow_action_basic_hw_stats_check(&flow->rule->action, extack))
+	if (!flow_action_hw_stats_check(&flow->rule->action, extack,
+					FLOW_ACTION_HW_STATS_DELAYED_BIT))
 		return -EOPNOTSUPP;
 
 	memset(nfp_flow->action_data, 0, NFP_FL_MAX_A_SIZ);
-- 
2.24.1

