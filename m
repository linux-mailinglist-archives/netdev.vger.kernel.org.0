Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C3833A1237
	for <lists+netdev@lfdr.de>; Wed,  9 Jun 2021 13:18:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238703AbhFILUc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Jun 2021 07:20:32 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:40215 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236685AbhFILUc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Jun 2021 07:20:32 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 718C15C0337;
        Wed,  9 Jun 2021 07:18:37 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Wed, 09 Jun 2021 07:18:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :message-id:mime-version:subject:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=DtgBPMNmxi5+KwZCm
        ZcOCpAF0X5T1rXpZ7H2VabGRpM=; b=RJm7GUtiLdnw60PF7oEP/qUXoNkvrSZBY
        A7+HBABXNrFd0mLXBdlaZCZIcQPhUP2ngLlrNsb95Jfjqfm/GzvFIyMI4vXrhVn/
        ixophjHai0GCCNuU9ZFgux/oDrKv8E1mhie3X2zKOC65q4Y3Gr5eMI5rnMLz+7ze
        VotGH1CItIh7aWLESUPCOJ4OmjvLoToH0ynppju2xYbPMO2MTbRWHx8bqwBgxy2E
        QWSFUx4q3xbhjE0UJKXqzjkMJDg9sx+GuAH5m2zBxeFvh+NXh2DrPCWGdQcI1QVl
        mEbwaKcpIsq+qByLlxSw0ZtOUE1ejx445ogdozkU8zzJXAZbeeGkQ==
X-ME-Sender: <xms:jKPAYJPdaC6DCaonTAY2kb6c9ksoSFCj_UGcc1YC0nGfMtp7DeZorg>
    <xme:jKPAYL-FMv9LFpGthCt6n-eyHz9G-rrjKSMIJHaP6YqQGnpP959a_o0CTvNGLaNwJ
    IJT_Z3w6j5fJWs>
X-ME-Received: <xmr:jKPAYITkIPLeilk5TwxThkjajzyHO4qLi0jN880qB0lvyE3Q-tWvOcP4oByIwYDP_wLh57-C8CHx1wLJYOAq_-EwpZ8TuMNWOeo1fND3pECEyw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrfeduuddgfeelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgggfestdekredtre
    dttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiughoshgt
    hhdrohhrgheqnecuggftrfgrthhtvghrnhepteevgefhvefggfffkeeuffeuvdfhueehhe
    etffeikeegheevfedvgeelvdffudfhnecuvehluhhsthgvrhfuihiivgeptdenucfrrghr
    rghmpehmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:jKPAYFtQ4wvOe66Fjt3Rd8BDSe9H5DDAP_qQPkCwxowuS4-ii7_7ng>
    <xmx:jKPAYBe9IoTB0g1DOgtjCBFE-Gy9MZQewdJg-_jO-hfr7t7mMfW4EA>
    <xmx:jKPAYB3JxzxGhCltAsIBZcRIgdEYARHygrEqjF5FWFOJwY1OajhQ2w>
    <xmx:jaPAYKHCS23oOWuh3JuRRg5DlKCi7ZsqIjDzUHlAiIw70qPeuUUmzg>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 9 Jun 2021 07:18:34 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, nikolay@nvidia.com,
        roopa@nvidia.com, jiapeng.chong@linux.alibaba.com,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net] rtnetlink: Fix regression in bridge VLAN configuration
Date:   Wed,  9 Jun 2021 14:17:53 +0300
Message-Id: <20210609111753.1739008-1-idosch@idosch.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@nvidia.com>

Cited commit started returning errors when notification info is not
filled by the bridge driver, resulting in the following regression:

 # ip link add name br1 type bridge vlan_filtering 1
 # bridge vlan add dev br1 vid 555 self pvid untagged
 RTNETLINK answers: Invalid argument

As long as the bridge driver does not fill notification info for the
bridge device itself, an empty notification should not be considered as
an error. This is explained in commit 59ccaaaa49b5 ("bridge: dont send
notification when skb->len == 0 in rtnl_bridge_notify").

Fix by removing the error and add a comment to avoid future bugs.

Fixes: a8db57c1d285 ("rtnetlink: Fix missing error code in rtnl_bridge_notify()")
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Reviewed-by: Nikolay Aleksandrov <nikolay@nvidia.com>
---
 net/core/rtnetlink.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c
index 3e84279c4123..ec931b080156 100644
--- a/net/core/rtnetlink.c
+++ b/net/core/rtnetlink.c
@@ -4842,10 +4842,12 @@ static int rtnl_bridge_notify(struct net_device *dev)
 	if (err < 0)
 		goto errout;
 
-	if (!skb->len) {
-		err = -EINVAL;
+	/* Notification info is only filled for bridge ports, not the bridge
+	 * device itself. Therefore, a zero notification length is valid and
+	 * should not result in an error.
+	 */
+	if (!skb->len)
 		goto errout;
-	}
 
 	rtnl_notify(skb, net, 0, RTNLGRP_LINK, NULL, GFP_ATOMIC);
 	return 0;
-- 
2.31.1

