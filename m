Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ACC821EF7B6
	for <lists+netdev@lfdr.de>; Fri,  5 Jun 2020 14:29:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726997AbgFEMZ4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Jun 2020 08:25:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:57618 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726965AbgFEMZv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 5 Jun 2020 08:25:51 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 81C0920820;
        Fri,  5 Jun 2020 12:25:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591359950;
        bh=tCBSlHI63YTEIG2JR4d62oOhc6aMNrY2obvYr7pkk18=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eI9yBqYJQSMS4L7AI5dOJX8KQwGNnCuOe30Mf5phjn93ebWjn1rdvrqlOtOKM1Njn
         FVaZoKDaTGHph2UtthcdJMpD90FC+a4r9odFDQfCR7gAf4tprt1DBv552rLC6drriw
         jrNlYUcCEEPFrd7qAqqvtZ42qNZmYN9nrehBKlkc=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Heinrich Kuhn <heinrich.kuhn@netronome.com>,
        Simon Horman <simon.horman@netronome.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, oss-drivers@netronome.com,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 08/14] nfp: flower: fix used time of merge flow statistics
Date:   Fri,  5 Jun 2020 08:25:34 -0400
Message-Id: <20200605122540.2882539-8-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200605122540.2882539-1-sashal@kernel.org>
References: <20200605122540.2882539-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Heinrich Kuhn <heinrich.kuhn@netronome.com>

[ Upstream commit 5b186cd60f033110960a3db424ffbd6de4cee528 ]

Prior to this change the correct value for the used counter is calculated
but not stored nor, therefore, propagated to user-space. In use-cases such
as OVS use-case at least this results in active flows being removed from
the hardware datapath. Which results in both unnecessary flow tear-down
and setup, and packet processing on the host.

This patch addresses the problem by saving the calculated used value
which allows the value to propagate to user-space.

Found by inspection.

Fixes: aa6ce2ea0c93 ("nfp: flower: support stats update for merge flows")
Signed-off-by: Heinrich Kuhn <heinrich.kuhn@netronome.com>
Signed-off-by: Simon Horman <simon.horman@netronome.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/netronome/nfp/flower/offload.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/netronome/nfp/flower/offload.c b/drivers/net/ethernet/netronome/nfp/flower/offload.c
index 987ae221f6be..4dd3f8a5a9b8 100644
--- a/drivers/net/ethernet/netronome/nfp/flower/offload.c
+++ b/drivers/net/ethernet/netronome/nfp/flower/offload.c
@@ -1368,7 +1368,8 @@ __nfp_flower_update_merge_stats(struct nfp_app *app,
 		ctx_id = be32_to_cpu(sub_flow->meta.host_ctx_id);
 		priv->stats[ctx_id].pkts += pkts;
 		priv->stats[ctx_id].bytes += bytes;
-		max_t(u64, priv->stats[ctx_id].used, used);
+		priv->stats[ctx_id].used = max_t(u64, used,
+						 priv->stats[ctx_id].used);
 	}
 }
 
-- 
2.25.1

