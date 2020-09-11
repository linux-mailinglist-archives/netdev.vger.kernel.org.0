Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6968026648C
	for <lists+netdev@lfdr.de>; Fri, 11 Sep 2020 18:41:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726276AbgIKQle (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Sep 2020 12:41:34 -0400
Received: from wout4-smtp.messagingengine.com ([64.147.123.20]:50565 "EHLO
        wout4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725786AbgIKPLN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Sep 2020 11:11:13 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.west.internal (Postfix) with ESMTP id EDBE4972;
        Fri, 11 Sep 2020 09:25:07 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Fri, 11 Sep 2020 09:25:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :message-id:mime-version:subject:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=Nc81uF+mob/bBUle1
        3jkpOUiabXO09c1T6O3Yh/6G0g=; b=EyU54ZQcNEvV1Lrv3gj8oshfbjnlBWiXZ
        0Homm4Ak1wXjI9hgDHllXAOLqbQVKs9VXt3rTuP2Hl/7c91Fv2uskZAP17D4zrGe
        1hz1RgLuhbTutxo7f65sK3n//SKxSBRVn/z7+TRIsEdQlMmhAohz+dAQCpiTlfS+
        X1vsw794vWmcM3ip805bOkaVzoeLPW3jr6roHK+iUBTT00ROHuV2ugtrhgZpqQL1
        FF1E07qDea1hZhiKgkpeBz1Czw40sBszNgDJyBsCMWOOsk4wX+NDdQYZIZHHm2+r
        kBDKaBqL9rIdNxb0/5/QtrXymeCx9IpnAJCaFJ10TvhZRsc94lc8w==
X-ME-Sender: <xms:s3pbXwYDaYez3GqeuJMnfMLUZL8PqoCbXyRVvpGvQw5UKmQEWgCsHg>
    <xme:s3pbX7bJ60XwKcQAaKchRR8PRMfniM_gx-CiYyGvWY_A6FVKXgtz1_nyYJ327NgNt
    x_bo1axx8agOEw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedrudehledgieeiucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgggfestdekredtre
    dttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiughoshgt
    hhdrohhrgheqnecuggftrfgrthhtvghrnhepteevgefhvefggfffkeeuffeuvdfhueehhe
    etffeikeegheevfedvgeelvdffudfhnecukfhppeekgedrvddvledrfeeirddufedunecu
    vehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepihguohhstg
    hhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:s3pbX6--xlunksqM4Vv-eWD0rORr7aBoFGL9OtbSEFbY8k2ywe5dIQ>
    <xmx:s3pbX6rWJ3Okk9ToAVBz2JlsbxMl7poGyf2sTcIc4rFM1X_G5z04kQ>
    <xmx:s3pbX7rmzl84sBUaqE78rg_I-_iyTKq-6KR5GWfKtKQdOHkvJ6yuMw>
    <xmx:s3pbX8Cn0Ye3Bf_UA_cAacjErJ212zsNptIPAZ9gb5momZ-cV8NW9g>
Received: from shredder.mtl.com (igld-84-229-36-131.inter.net.il [84.229.36.131])
        by mail.messagingengine.com (Postfix) with ESMTPA id B0B383064674;
        Fri, 11 Sep 2020 09:25:05 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org, bridge@lists.linux-foundation.org
Cc:     davem@davemloft.net, kuba@kernel.org, roopa@nvidia.com,
        nikolay@nvidia.com, jiri@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next] bridge: mcast: Fix incomplete MDB dump
Date:   Fri, 11 Sep 2020 16:24:47 +0300
Message-Id: <20200911132447.3158141-1-idosch@idosch.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@nvidia.com>

Each MDB entry is encoded in a nested netlink attribute called
'MDBA_MDB_ENTRY'. In turn, this attribute contains another nested
attributed called 'MDBA_MDB_ENTRY_INFO', which encodes a single port
group entry within the MDB entry.

The cited commit added the ability to restart a dump from a specific
port group entry. However, on failure to add a port group entry to the
dump the entire MDB entry (stored in 'nest2') is removed, resulting in
missing port group entries.

Fix this by finalizing the MDB entry with the partial list of already
encoded port group entries.

Fixes: 5205e919c9f0 ("net: bridge: mcast: add support for src list and filter mode dumping")
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Acked-by: Nikolay Aleksandrov <nikolay@nvidia.com>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
---
 net/bridge/br_mdb.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/bridge/br_mdb.c b/net/bridge/br_mdb.c
index 67e0976aeed2..00f1651a6aba 100644
--- a/net/bridge/br_mdb.c
+++ b/net/bridge/br_mdb.c
@@ -243,7 +243,7 @@ static int br_mdb_fill_info(struct sk_buff *skb, struct netlink_callback *cb,
 
 			err = __mdb_fill_info(skb, mp, p);
 			if (err) {
-				nla_nest_cancel(skb, nest2);
+				nla_nest_end(skb, nest2);
 				goto out;
 			}
 skip_pg:
-- 
2.26.2

