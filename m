Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0037B60B18F
	for <lists+netdev@lfdr.de>; Mon, 24 Oct 2022 18:27:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232371AbiJXQ1o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Oct 2022 12:27:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231709AbiJXQ1J (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Oct 2022 12:27:09 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38D29B6036
        for <netdev@vger.kernel.org>; Mon, 24 Oct 2022 08:14:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C51E961372
        for <netdev@vger.kernel.org>; Mon, 24 Oct 2022 14:00:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BBAAAC433C1;
        Mon, 24 Oct 2022 14:00:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666620040;
        bh=SyTLqmwX2zJf1qgW9ZZLTf1c9BGhv3ScdwDSsP34Db8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oi0UjtQ0rXYPni84lisdeCBuZkUHmL60rJ0FC11S1kXmd9oo2Fofe/hq17dFWCZYz
         soVpz0G6RxpjCHbsfYnTTnv4WgUEzXP3OEjxSeLHZqfZF5SRJxF/ZD4P+eBUa4phZo
         JjU3iqI8iqv3jZH3tc9JBuQ0OPzOMiXP/upX1c35EDmS0ZDXorNq9h0QfpQrUTGIOm
         Cxjku176UKYgKzSqDSaBChti9NmoFF6UMeVMDApCwgpaWGZpW63zlpwcuMGJZ01Sk4
         pY5IpiOlq+PK3zsLAFDfpWTNhJ7zM1Plc3A26McCQQv6i77Ww2mY/SnIyR/jTtniwO
         f2BKo6zSYKmqQ==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Yevgeny Kliteynik <kliteyn@nvidia.com>,
        Erez Shitrit <erezsh@nvidia.com>,
        Alex Vesker <valex@nvidia.com>
Subject: [net-next 08/14] net/mlx5: DR, In rehash write the line in the entry immediately
Date:   Mon, 24 Oct 2022 14:57:28 +0100
Message-Id: <20221024135734.69673-9-saeed@kernel.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20221024135734.69673-1-saeed@kernel.org>
References: <20221024135734.69673-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yevgeny Kliteynik <kliteyn@nvidia.com>

Don't wait for the whole table to be ready - write each row immediately.
This way we save allocations of the ste_send_info structure and improve
performance.

Signed-off-by: Erez Shitrit <erezsh@nvidia.com>
Signed-off-by: Yevgeny Kliteynik <kliteyn@nvidia.com>
Reviewed-by: Alex Vesker <valex@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/steering/dr_rule.c   | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_rule.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_rule.c
index cd90f0a02434..b739bafcaa6c 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_rule.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_rule.c
@@ -357,6 +357,15 @@ static int dr_rule_rehash_copy_htbl(struct mlx5dr_matcher *matcher,
 						    update_list);
 		if (err)
 			goto clean_copy;
+
+		/* In order to decrease the number of allocated ste_send_info
+		 * structs, send the current table row now.
+		 */
+		err = dr_rule_send_update_list(update_list, matcher->tbl->dmn, false);
+		if (err) {
+			mlx5dr_dbg(matcher->tbl->dmn, "Failed updating table to HW\n");
+			goto clean_copy;
+		}
 	}
 
 clean_copy:
-- 
2.37.3

