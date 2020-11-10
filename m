Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5316A2AD3B4
	for <lists+netdev@lfdr.de>; Tue, 10 Nov 2020 11:26:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730924AbgKJK0d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Nov 2020 05:26:33 -0500
Received: from wout3-smtp.messagingengine.com ([64.147.123.19]:54997 "EHLO
        wout3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729962AbgKJK0c (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Nov 2020 05:26:32 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.west.internal (Postfix) with ESMTP id 561ADE04;
        Tue, 10 Nov 2020 05:26:31 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Tue, 10 Nov 2020 05:26:31 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :message-id:mime-version:subject:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=sgfGru3BXocR26EDA
        frijI+Th3Ula/Obk66Vog+MbSo=; b=A8ReP0hk6p0ikJVGSvsSn3EKOjUTO7m+g
        sV+u+eKNQStXk7t2Rwcmrc0S3Y2tsiUsJ/y08GXo9S/uy7aLUyraOJ3MBc4Qq8Gd
        nLcVUiP9wjxIIOJFtW2oPtCznO+jGUFM18EQjWqGmo437kI1TbzxNsFrf85GYqgu
        5CWseOgGaY+U0qxwvIdWhT2f3NBtTOvtl7Hb6BWl7UJ0C7/r9mCNYSwQRk6t+FkB
        td1dTt2FB7qdrTKQW6YET6jzIaA/efQTiQe9I+Rl5XXkU3A7h1UyM+4EdT4xw6kH
        /Yd1KDT7Db8CUbeoYO2CR6xfPtCetfAErINOufNcxT7TPD6zyX5vA==
X-ME-Sender: <xms:1mqqX_AxWpnQWNm1bi1oWiMpTXc8vn1Ocen488jPf6X-FaR9TnjISA>
    <xme:1mqqX1j_esWu-5Ydd8Qi-njeAL_Lq6mvXEEGnmL8pBjZGLuoYFCfTMnKafZjk54o5
    7Bp6DmJjDGc2do>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedruddujedgudeiucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgggfestdekredtre
    dttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiughoshgt
    hhdrohhrgheqnecuggftrfgrthhtvghrnhepteevgefhvefggfffkeeuffeuvdfhueehhe
    etffeikeegheevfedvgeelvdffudfhnecukfhppeekgedrvddvledrudehgedrudegjeen
    ucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiughosh
    gthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:1mqqX6kgSEPIVKwpN5MvbG2WCVmLpuhrlzoUjc7680AdOMW62NgXFg>
    <xmx:1mqqXxwqvWExcL9jgFaOBiyQ8VVmdbPKBi3NyOXwDCWfiY97BJcv9w>
    <xmx:1mqqX0Tac-cET7-9X4dLpYtQUTMyvsNRPyBbHPkOyzafDmg7570LRw>
    <xmx:1mqqX_drHk-Xe8AutQsEQH5IaQAOIuMhN2Ai3BHBYPBMvA6TbqHFAg>
Received: from shredder.mtl.com (igld-84-229-154-147.inter.net.il [84.229.154.147])
        by mail.messagingengine.com (Postfix) with ESMTPA id 4E2C73280060;
        Tue, 10 Nov 2020 05:26:29 -0500 (EST)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, dsahern@gmail.com,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next] ipv4: Set nexthop flags in a more consistent way
Date:   Tue, 10 Nov 2020 12:25:53 +0200
Message-Id: <20201110102553.1924232-1-idosch@idosch.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@nvidia.com>

Be more consistent about the way in which the nexthop flags are set and
set them in one go.

Suggested-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
RTNH_F_DEAD and RTNH_F_LINKDOWN are set separately above, so I decided
to keep them as-is.
---
 net/ipv4/fib_semantics.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/net/ipv4/fib_semantics.c b/net/ipv4/fib_semantics.c
index f70b9a0c4957..7612ff6111a7 100644
--- a/net/ipv4/fib_semantics.c
+++ b/net/ipv4/fib_semantics.c
@@ -1641,11 +1641,8 @@ int fib_nexthop_info(struct sk_buff *skb, const struct fib_nh_common *nhc,
 		break;
 	}
 
-	*flags |= (nhc->nhc_flags & RTNH_F_ONLINK);
-	if (nhc->nhc_flags & RTNH_F_OFFLOAD)
-		*flags |= RTNH_F_OFFLOAD;
-	if (nhc->nhc_flags & RTNH_F_TRAP)
-		*flags |= RTNH_F_TRAP;
+	*flags |= (nhc->nhc_flags &
+		   (RTNH_F_ONLINK | RTNH_F_OFFLOAD | RTNH_F_TRAP));
 
 	if (!skip_oif && nhc->nhc_dev &&
 	    nla_put_u32(skb, RTA_OIF, nhc->nhc_dev->ifindex))
-- 
2.26.2

