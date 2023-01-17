Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CB1B866DE7B
	for <lists+netdev@lfdr.de>; Tue, 17 Jan 2023 14:15:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237070AbjAQNP3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Jan 2023 08:15:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237069AbjAQNPX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Jan 2023 08:15:23 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A5A538B44;
        Tue, 17 Jan 2023 05:15:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8EC4BB81604;
        Tue, 17 Jan 2023 13:15:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CEAB7C433D2;
        Tue, 17 Jan 2023 13:15:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673961311;
        bh=ejtpF20k13sCXEE5K2/biJvCrzncPMMbaATqN9mK928=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YSSFMvCk5BbkuAIYQzC0Oo6j2A5bZpdyimd+e8Iz9uwuwzBb6fJNydpJ2OulUt3Np
         tDITnEI8R02XvhbZPVOraAQlt2q3tWGFICwH30NqOKrJXz4Gud5rc8964QFgV4I2Cw
         /tzGu3tqRn7SZod02j2CI/wF3RtyQjwS1hP6cIwBTRE672+ZGXnkJPijplLFIgFRTP
         HT6LjMVKxRVdyennI0lJEvdpo88MFo+L4GAHv9FAgolZy9m6/kiSfl6t2gIuPTS9KZ
         6Y8trxqNiKAIy169O14GTF7f9ZhSA6vUtlZEHsotpfMj1/craZzgxFE8wAGDBweuGc
         hG4y9d6ai5DfQ==
From:   Leon Romanovsky <leon@kernel.org>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Or Har-Toov <ohartoov@nvidia.com>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>, linux-rdma@vger.kernel.org,
        Michael Guralnik <michaelgur@nvidia.com>,
        netdev@vger.kernel.org, Paolo Abeni <pabeni@redhat.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [PATCH mlx5-next v2 1/4] net/mlx5: Expose bits for querying special mkeys
Date:   Tue, 17 Jan 2023 15:14:49 +0200
Message-Id: <080ebb563a9717c15b1ea75d669aede676df386b.1673960981.git.leon@kernel.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <cover.1673960981.git.leon@kernel.org>
References: <cover.1673960981.git.leon@kernel.org>
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

From: Or Har-Toov <ohartoov@nvidia.com>

Add needed HW bits to query the values of all special mkeys.

Signed-off-by: Or Har-Toov <ohartoov@nvidia.com>
Reviewed-by: Michael Guralnik <michaelgur@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 include/linux/mlx5/mlx5_ifc.h | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/include/linux/mlx5/mlx5_ifc.h b/include/linux/mlx5/mlx5_ifc.h
index 2d17b6a6d82d..8bbf15433bb2 100644
--- a/include/linux/mlx5/mlx5_ifc.h
+++ b/include/linux/mlx5/mlx5_ifc.h
@@ -1480,7 +1480,9 @@ struct mlx5_ifc_cmd_hca_cap_bits {
 	u8         relaxed_ordering_write[0x1];
 	u8         relaxed_ordering_read[0x1];
 	u8         log_max_mkey[0x6];
-	u8         reserved_at_f0[0x8];
+	u8         reserved_at_f0[0x6];
+	u8	   terminate_scatter_list_mkey[0x1];
+	u8	   repeated_mkey[0x1];
 	u8         dump_fill_mkey[0x1];
 	u8         reserved_at_f9[0x2];
 	u8         fast_teardown[0x1];
@@ -5202,7 +5204,11 @@ struct mlx5_ifc_query_special_contexts_out_bits {
 
 	u8         null_mkey[0x20];
 
-	u8         reserved_at_a0[0x60];
+	u8	   terminate_scatter_list_mkey[0x20];
+
+	u8	   repeated_mkey[0x20];
+
+	u8         reserved_at_a0[0x20];
 };
 
 struct mlx5_ifc_query_special_contexts_in_bits {
-- 
2.39.0

