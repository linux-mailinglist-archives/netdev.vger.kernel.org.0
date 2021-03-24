Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6571334821F
	for <lists+netdev@lfdr.de>; Wed, 24 Mar 2021 20:45:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237885AbhCXTop (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Mar 2021 15:44:45 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:54593 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237902AbhCXToa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Mar 2021 15:44:30 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id A61CA5C0121;
        Wed, 24 Mar 2021 15:44:29 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Wed, 24 Mar 2021 15:44:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :message-id:mime-version:subject:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=OSvGFeMLpIfrexF8H
        7K3MEeCkS9y1Jf9n2UXA/OA91A=; b=R4YXLX1Hkr+onWBVGn9N+iYSzO3NJ+oy/
        htRGetvGOmV5O0ru2a47WNjuu0NpeuxCPJKG9o+dgMaTyZTy8aS3QvD1CLSC7s4W
        S0YxFhc/cG4H8NiuIhTD5y9m5vVvVcbhGSDCbUCZT750QU++Qz11Dbc5oGEvWROO
        MozQRXhKheYD++uOd0GrTeKr+U893yF3Y8t1SGJYeHks6+ty1lDE7nCopv4AVQO8
        fewH7BwO92n3tbfoPsRbpqDXr0xWgN0MTc4nmqR79MnMLJoBA3jKLyD/MlssFeW1
        46X4ekxKwBXb4qkC0tUxj0GAXvB48eOD1IYk2tPSvHxDdX4Rxl5QQ==
X-ME-Sender: <xms:m5ZbYN4-1NQzYH9IxYC1b3DWa6JLXRVT0cQHJNCmTZFc-QGlr2GZSQ>
    <xme:m5ZbYK5UeA-3mLiilVZzmVEIZnhMNfK44b54ir1fjQSACSIEqTdMBYNRz1p1OVOFU
    mLcCT6nBVCfwQc>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrudegkedguddvjecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffoggfgsedtkeertd
    ertddtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihguohhs
    tghhrdhorhhgqeenucggtffrrghtthgvrhhnpeekkefgteeguedvtdegffeitefgueeiie
    dutefhtdfhkeetteelgfevleetueeigeenucffohhmrghinhepghhithhhuhgsrdgtohhm
    necukfhppeekgedrvddvledrudehfedrgeegnecuvehluhhsthgvrhfuihiivgeptdenuc
    frrghrrghmpehmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:nJZbYEe6GJ753W7zv6wbGNfkiMQ72BuDCJwH_REZOPpYOsk9L5moOA>
    <xmx:nJZbYGKGOhgZ_pUi0JPIaa4hsB0tt_rCIkPEfNdufTAGrvPrL53d8g>
    <xmx:nJZbYBIIQwBAN3x2MajTQ3CH_5t8kSCYi2DAf7F74t6kXUz5zB9UwQ>
    <xmx:nZZbYJ8XZxpsiozJL2jJeJX6VRCjjyiAG1kFgwQfci4487UstsM9TQ>
Received: from shredder.lan (igld-84-229-153-44.inter.net.il [84.229.153.44])
        by mail.messagingengine.com (Postfix) with ESMTPA id 701A51080063;
        Wed, 24 Mar 2021 15:44:25 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, yotam.gi@gmail.com,
        jiri@nvidia.com, petrm@nvidia.com, chrism@mellanox.com,
        sfr@canb.auug.org.au, Ido Schimmel <idosch@nvidia.com>,
        stable@vger.kernel.org
Subject: [PATCH net] psample: Fix user API breakage
Date:   Wed, 24 Mar 2021 21:43:32 +0200
Message-Id: <20210324194332.153658-1-idosch@idosch.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@nvidia.com>

Cited commit added a new attribute before the existing group reference
count attribute, thereby changing its value and breaking existing
applications on new kernels.

Before:

 # psample -l
 libpsample ERROR psample_group_foreach: failed to recv message: Operation not supported

After:

 # psample -l
 Group Num       Refcount        Group Seq
 1               1               0

Fix by restoring the value of the old attribute and remove the
misleading comments from the enumerator to avoid future bugs.

Cc: stable@vger.kernel.org
Fixes: d8bed686ab96 ("net: psample: Add tunnel support")
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Reported-by: Adiel Bidani <adielb@nvidia.com>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
Reviewed-by: Petr Machata <petrm@nvidia.com>
---
Dave, Jakub, Stephen, there might be a trivial conflict when you merge
net into net-next. If so, see resolution here:
https://github.com/jpirko/linux_mlxsw/commit/d47ac079ef169d3ab07c85e9178a925f7dffbebe.patch
---
 include/uapi/linux/psample.h | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/include/uapi/linux/psample.h b/include/uapi/linux/psample.h
index aea26ab1431c..bff5032c98df 100644
--- a/include/uapi/linux/psample.h
+++ b/include/uapi/linux/psample.h
@@ -3,7 +3,6 @@
 #define __UAPI_PSAMPLE_H
 
 enum {
-	/* sampled packet metadata */
 	PSAMPLE_ATTR_IIFINDEX,
 	PSAMPLE_ATTR_OIFINDEX,
 	PSAMPLE_ATTR_ORIGSIZE,
@@ -11,10 +10,8 @@ enum {
 	PSAMPLE_ATTR_GROUP_SEQ,
 	PSAMPLE_ATTR_SAMPLE_RATE,
 	PSAMPLE_ATTR_DATA,
-	PSAMPLE_ATTR_TUNNEL,
-
-	/* commands attributes */
 	PSAMPLE_ATTR_GROUP_REFCOUNT,
+	PSAMPLE_ATTR_TUNNEL,
 
 	__PSAMPLE_ATTR_MAX
 };
-- 
2.30.2

