Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3D734672728
	for <lists+netdev@lfdr.de>; Wed, 18 Jan 2023 19:36:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231157AbjARSgr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Jan 2023 13:36:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230509AbjARSgW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Jan 2023 13:36:22 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0104C56880
        for <netdev@vger.kernel.org>; Wed, 18 Jan 2023 10:36:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 802E0B81E9D
        for <netdev@vger.kernel.org>; Wed, 18 Jan 2023 18:36:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23584C433EF;
        Wed, 18 Jan 2023 18:36:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674066978;
        bh=1wDgrUABev5KcpnNy1JLDVFONe7DixRkGZmFQej7Deo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PxCEkivWDpW7lgQC3PCe/Z1xqd9NnSMtXxyioXD9cXQnIpJfomQPBEoLBS+Zrn1XX
         +HsPdf1mO1ubA3by0d/Knri85PDuKX26mxFdgGpPJqKwzDbN4rZ073lIa7c0VoRQyr
         wZBOVc13TDlbzimQ6GLTKdBPYTYxovCG9bkwr/LF14dIwh6AdZpXoKV761qAegu1Ui
         +j6hb+aue+aD5znWooHq3UhUsAmJx3pWux+sTlqkIL0z5wig1nzLiGl2m4z1+r7k+w
         d1VMfnY0t8SIvakOgRTecWsk/BhwyCKssVP+DX9IUwIm25TimrwcJH6FguEB3aJpVl
         bqAnmV4o51OZg==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>, Roi Dayan <roid@nvidia.com>,
        Maor Dickman <maord@nvidia.com>
Subject: [net-next 11/15] net/mlx5e: Warn when destroying mod hdr hash table that is not empty
Date:   Wed, 18 Jan 2023 10:35:58 -0800
Message-Id: <20230118183602.124323-12-saeed@kernel.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230118183602.124323-1-saeed@kernel.org>
References: <20230118183602.124323-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Roi Dayan <roid@nvidia.com>

To avoid memory leaks add a warn when destroying mod hdr hash table
but the hash table is not empty.

Signed-off-by: Roi Dayan <roid@nvidia.com>
Reviewed-by: Maor Dickman <maord@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en/mod_hdr.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/mod_hdr.c b/drivers/net/ethernet/mellanox/mlx5/core/en/mod_hdr.c
index 17325c5d6516..cf60f0a3ff23 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/mod_hdr.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/mod_hdr.c
@@ -47,6 +47,7 @@ void mlx5e_mod_hdr_tbl_init(struct mod_hdr_tbl *tbl)
 
 void mlx5e_mod_hdr_tbl_destroy(struct mod_hdr_tbl *tbl)
 {
+	WARN_ON(!hash_empty(tbl->hlist));
 	mutex_destroy(&tbl->lock);
 }
 
-- 
2.39.0

