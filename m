Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C6EF0279EF8
	for <lists+netdev@lfdr.de>; Sun, 27 Sep 2020 08:42:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730378AbgI0Gmg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 27 Sep 2020 02:42:36 -0400
Received: from wout5-smtp.messagingengine.com ([64.147.123.21]:57013 "EHLO
        wout5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726840AbgI0Gmg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 27 Sep 2020 02:42:36 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.west.internal (Postfix) with ESMTP id 42E6D489;
        Sun, 27 Sep 2020 02:42:35 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Sun, 27 Sep 2020 02:42:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :message-id:mime-version:subject:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=4qJgCanZkGcqvMfCA
        iWWU5v7M/z8hJRqPRiYoSPRU+I=; b=K261SEQ4VLOE1ZlVWM7JPmrL4XCMBBHw/
        Qrglab6G0orgj4P7FLEarR3SEJoC0JzyTo5q2tawv7CInor9Z1juAPdLYZBiSW7H
        oBpNO+g+IjLYlnQzZbMfKFGHmFWmRZlbyxdQmKxrhpIRl5OuJRuI5UjkHmXzPvh9
        tjZEovRJsLS8LZzdA3dnMjDua6CZHkl/Bu5p7R1MsYLnmZg81CLTSYrC36QlKlPy
        MdtPdDmcp++QDZ2j99vc1n2wU9udIdEFuzhkGz1jGvLpFt4bdJR3U7OjY5B/6cJU
        UjTLigSBkMmeRDIAr4TgyKXUqg8VBFEENRCiEdPGXkBO/5MJrpHrA==
X-ME-Sender: <xms:WjRwX0WC4ElPUtqdzQ-zoREf07OdsVEoaStUDpdVnCVGcFqwJtg7Pg>
    <xme:WjRwX4mRM1-EQvIGn2q54M7O7SGoe0pQQrtHn8lpGJr54JoViVvtoR7RBCfeTKPs7
    jLgjObhmSbaZAc>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrvdefgddutdefucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgggfestdekredtre
    dttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiughoshgt
    hhdrohhrgheqnecuggftrfgrthhtvghrnhepteevgefhvefggfffkeeuffeuvdfhueehhe
    etffeikeegheevfedvgeelvdffudfhnecukfhppeekgedrvddvledrfeejrddugeeknecu
    vehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepihguohhstg
    hhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:WjRwX4ZlYs0mCEeGKxS90eZXehMKjivOG7ZzFEKL3jsS4FizqCsClg>
    <xmx:WjRwXzUKh-qJNJoakYK7pvyZVVwUhj1t73BDwoKuGN_UxXO7ffGhww>
    <xmx:WjRwX-m6ysmx2PPJSFGPYvvvfL2kYptpGiJItBwRYpaci-9JqlWmdw>
    <xmx:WjRwXzzcsGTS3YyKu1eMOU37tw-FSEUhZMWdxyv7_U-1UjE38lX_nQ>
Received: from shredder.mtl.com (igld-84-229-37-148.inter.net.il [84.229.37.148])
        by mail.messagingengine.com (Postfix) with ESMTPA id C9FA9328005A;
        Sun, 27 Sep 2020 02:42:32 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@nvidia.com,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net] mlxsw: spectrum_acl: Fix mlxsw_sp_acl_tcam_group_add()'s error path
Date:   Sun, 27 Sep 2020 09:42:11 +0300
Message-Id: <20200927064211.1412383-1-idosch@idosch.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@nvidia.com>

If mlxsw_sp_acl_tcam_group_id_get() fails, the mutex initialized earlier
is not destroyed.

Fix this by initializing the mutex after calling the function. This is
symmetric to mlxsw_sp_acl_tcam_group_del().

Fixes: 5ec2ee28d27b ("mlxsw: spectrum_acl: Introduce a mutex to guard region list updates")
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlxsw/spectrum_acl_tcam.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_acl_tcam.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_acl_tcam.c
index 5c020403342f..7cccc41dd69c 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_acl_tcam.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_acl_tcam.c
@@ -292,13 +292,14 @@ mlxsw_sp_acl_tcam_group_add(struct mlxsw_sp_acl_tcam *tcam,
 	int err;
 
 	group->tcam = tcam;
-	mutex_init(&group->lock);
 	INIT_LIST_HEAD(&group->region_list);
 
 	err = mlxsw_sp_acl_tcam_group_id_get(tcam, &group->id);
 	if (err)
 		return err;
 
+	mutex_init(&group->lock);
+
 	return 0;
 }
 
-- 
2.26.2

