Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 783D528C11D
	for <lists+netdev@lfdr.de>; Mon, 12 Oct 2020 21:09:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731269AbgJLTJP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Oct 2020 15:09:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:52268 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388034AbgJLTC5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 12 Oct 2020 15:02:57 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1C9A1214DB;
        Mon, 12 Oct 2020 19:02:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602529376;
        bh=F5mjsWYsKPjZrD1iqQb+SSvkejCTMVs+yDwLbTwN5aQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0UxSPQLq8O2sGbxMAHQgzStP9kJVqpeyXNr0ncLHRDSqQ5MdJRdsuaV9JUj7WNRcl
         QPDBx7y1/U9y5WBSG1Q++Bte0Fkkyl0JDeEZOHdHmRUA5fp7OcU3gSsE7aqRnPibMV
         gwdLOEB1bhpO0pMy2l1OyfVQaZOYIX0+JQyLffM0=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Vladimir Oltean <vladimir.oltean@nxp.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.8 13/24] net: dsa: felix: fix incorrect action offsets for VCAP IS2
Date:   Mon, 12 Oct 2020 15:02:28 -0400
Message-Id: <20201012190239.3279198-13-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201012190239.3279198-1-sashal@kernel.org>
References: <20201012190239.3279198-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

[ Upstream commit 460e985ea07ec23d46af257e84e57b5409576577 ]

The port mask width was larger than the actual number of ports, and
therefore, all fields following this one were also shifted by the number
of excess bits. But the driver doesn't use the REW_OP, SMAC_REPLACE_ENA
or ACL_ID bits from the action vector, so the bug was inconsequential.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/ocelot/felix_vsc9959.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/net/dsa/ocelot/felix_vsc9959.c b/drivers/net/dsa/ocelot/felix_vsc9959.c
index 7c167a394b762..885a59c97ff23 100644
--- a/drivers/net/dsa/ocelot/felix_vsc9959.c
+++ b/drivers/net/dsa/ocelot/felix_vsc9959.c
@@ -647,12 +647,12 @@ struct vcap_field vsc9959_vcap_is2_actions[] = {
 	[VCAP_IS2_ACT_POLICE_ENA]		= {  9,  1},
 	[VCAP_IS2_ACT_POLICE_IDX]		= { 10,  9},
 	[VCAP_IS2_ACT_POLICE_VCAP_ONLY]		= { 19,  1},
-	[VCAP_IS2_ACT_PORT_MASK]		= { 20, 11},
-	[VCAP_IS2_ACT_REW_OP]			= { 31,  9},
-	[VCAP_IS2_ACT_SMAC_REPLACE_ENA]		= { 40,  1},
-	[VCAP_IS2_ACT_RSV]			= { 41,  2},
-	[VCAP_IS2_ACT_ACL_ID]			= { 43,  6},
-	[VCAP_IS2_ACT_HIT_CNT]			= { 49, 32},
+	[VCAP_IS2_ACT_PORT_MASK]		= { 20,  6},
+	[VCAP_IS2_ACT_REW_OP]			= { 26,  9},
+	[VCAP_IS2_ACT_SMAC_REPLACE_ENA]		= { 35,  1},
+	[VCAP_IS2_ACT_RSV]			= { 36,  2},
+	[VCAP_IS2_ACT_ACL_ID]			= { 38,  6},
+	[VCAP_IS2_ACT_HIT_CNT]			= { 44, 32},
 };
 
 static const struct vcap_props vsc9959_vcap_props[] = {
-- 
2.25.1

