Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3106F2ED30A
	for <lists+netdev@lfdr.de>; Thu,  7 Jan 2021 15:51:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728801AbhAGOt6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Jan 2021 09:49:58 -0500
Received: from wout1-smtp.messagingengine.com ([64.147.123.24]:41129 "EHLO
        wout1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727753AbhAGOt5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Jan 2021 09:49:57 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.west.internal (Postfix) with ESMTP id 5EE25183C;
        Thu,  7 Jan 2021 09:49:11 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Thu, 07 Jan 2021 09:49:12 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; bh=TE+ODLiQyN2P7Bg6hD6Za/tmHI1PvmN3/pDSvJHkgl0=; b=MY4jm2Ku
        cd1U944H+DM1KYXvkUWyP3OzLnRFypIbr4L/i7mIOxouXkw5RaPKdde4qPfKPFP9
        n1ZHXe+pKSxbWiyZ/43zCtmm/cTyfksvq5mI/JMjJr98L2gwCyqP53Y2SymWCA4z
        KyLwYlDguhAldTLlwxheYnK7ozGJsAkqxV52yRr1BQOMLEyyzjnZ2tR83huQUvWG
        SRw39kBq+w6RkHmRNiHcjlrPmudy9ZDcBgE/Smz8G8FTiuzVICx8JANtKtnD0+KR
        8B6aSf3XGwGVUbvtrixeXNDji1oG830Ug11ehI6D3U9ZCeUuQAVy1+L73kRKdPz1
        LScxfmEaRlfI1A==
X-ME-Sender: <xms:Zh_3XxRV7beKC8zwSI5Gn7iQEXmWoJ_O4bE2s9pjyfCIakQn8qtVfw>
    <xme:Zh_3X6xN45i7G2wxptAJz7vjLNN5_Qj5fCXhsyEBPyz0pf45YALNHIDMB09bAFGbL
    k_nePTeZpG2YYg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrvdegvddgjedtucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepudetieevffffveelkeeljeffkefhke
    ehgfdtffethfelvdejgffghefgveejkefhnecukfhppeekgedrvddvledrudehfedrgeeg
    necuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepihguoh
    hstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:Zh_3X23ygApIC3Wxzdu_mbx1Ke8CvcdSOinO9y7yM2z1DFT6iNPH5Q>
    <xmx:Zh_3X5CSFJpk_3VNezRV5Hk_QpktEhbLW3eUR5Qq7SQ7rgMKLPJBEw>
    <xmx:Zh_3X6iLc0_8pr2QwQF4-6D9kRnOje7OatWIwWGSI3zKiKqTrRaemw>
    <xmx:Zx_3X8Z-HL7M4SSjKMMZR-NuwqXOs_eQioSIoO-WYqlW89JxmZ2P6Q>
Received: from shredder.lan (igld-84-229-153-44.inter.net.il [84.229.153.44])
        by mail.messagingengine.com (Postfix) with ESMTPA id 8BA3E108005B;
        Thu,  7 Jan 2021 09:49:08 -0500 (EST)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, petrm@nvidia.com,
        dsahern@gmail.com, roopa@nvidia.com, nikolay@nvidia.com,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net 2/4] nexthop: Unlink nexthop group entry in error path
Date:   Thu,  7 Jan 2021 16:48:22 +0200
Message-Id: <20210107144824.1135691-3-idosch@idosch.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210107144824.1135691-1-idosch@idosch.org>
References: <20210107144824.1135691-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@nvidia.com>

In case of error, remove the nexthop group entry from the list to which
it was previously added.

Fixes: 430a049190de ("nexthop: Add support for nexthop groups")
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Reviewed-by: Petr Machata <petrm@nvidia.com>
---
 net/ipv4/nexthop.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/ipv4/nexthop.c b/net/ipv4/nexthop.c
index f8035cfa9c20..712cdc061cde 100644
--- a/net/ipv4/nexthop.c
+++ b/net/ipv4/nexthop.c
@@ -1459,8 +1459,10 @@ static struct nexthop *nexthop_create_group(struct net *net,
 	return nh;
 
 out_no_nh:
-	for (i--; i >= 0; --i)
+	for (i--; i >= 0; --i) {
+		list_del(&nhg->nh_entries[i].nh_list);
 		nexthop_put(nhg->nh_entries[i].nh);
+	}
 
 	kfree(nhg->spare);
 	kfree(nhg);
-- 
2.29.2

