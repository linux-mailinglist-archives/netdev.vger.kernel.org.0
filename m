Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A81CE68E668
	for <lists+netdev@lfdr.de>; Wed,  8 Feb 2023 04:03:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229649AbjBHDDa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Feb 2023 22:03:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230307AbjBHDDW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Feb 2023 22:03:22 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 748D23E634
        for <netdev@vger.kernel.org>; Tue,  7 Feb 2023 19:03:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id D4D2BCE1F20
        for <netdev@vger.kernel.org>; Wed,  8 Feb 2023 03:03:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1694FC433EF;
        Wed,  8 Feb 2023 03:03:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675825397;
        bh=cqUmVFvKnMIzG3uueNcI1TnmUbHH+Hxc2+9KMnuQ3SI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DpaAqawvV9fMsG/khV21Wj2SRH2SctfrpJ/rVOfOzQmBeQ+pbyGyB+dSYTbVaaf0e
         kme5KWx4nebvuKLB3B7QIEOgtmwlLMeHV6auZzcMc/hYV3wvL4EM46s0qDD5CyVHQc
         jWHILy41cu3yqtPcAgVM7+k8ExcfYZD7//j3ualR2OwLszZ56YaCAujTZQ9rLcbebh
         lnsBxGASNwCABCSqPyPshmDXkVAMHGzJmpgcjQy0BDdrmVge4nmNBbUoYOwoPioNXx
         57wxDZaYjO0CGFazlVhXN3asrd7suUKEd+oti3dnb5q/hFoxDAP/fGfNzZ+nZqKBd7
         BNBcRXlVN1iXA==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Shay Drory <shayd@nvidia.com>, Moshe Shemesh <moshe@nvidia.com>
Subject: [net 08/10] net/mlx5: fw_tracer, Clear load bit when freeing string DBs buffers
Date:   Tue,  7 Feb 2023 19:03:00 -0800
Message-Id: <20230208030302.95378-9-saeed@kernel.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230208030302.95378-1-saeed@kernel.org>
References: <20230208030302.95378-1-saeed@kernel.org>
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

From: Shay Drory <shayd@nvidia.com>

Whenever the driver is reading the string DBs into buffers, the driver
is setting the load bit, but the driver never clears this bit.
As a result, in case load bit is on and the driver query the device for
new string DBs, the driver won't read again the string DBs.
Fix it by clearing the load bit when query the device for new string
DBs.

Fixes: 2d69356752ff ("net/mlx5: Add support for fw live patch event")
Signed-off-by: Shay Drory <shayd@nvidia.com>
Reviewed-by: Moshe Shemesh <moshe@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/diag/fw_tracer.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/diag/fw_tracer.c b/drivers/net/ethernet/mellanox/mlx5/core/diag/fw_tracer.c
index 21831386b26e..d82e98a0cdfa 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/diag/fw_tracer.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/diag/fw_tracer.c
@@ -64,6 +64,7 @@ static int mlx5_query_mtrc_caps(struct mlx5_fw_tracer *tracer)
 			MLX5_GET(mtrc_cap, out, num_string_trace);
 	tracer->str_db.num_string_db = MLX5_GET(mtrc_cap, out, num_string_db);
 	tracer->owner = !!MLX5_GET(mtrc_cap, out, trace_owner);
+	tracer->str_db.loaded = false;
 
 	for (i = 0; i < tracer->str_db.num_string_db; i++) {
 		mtrc_cap_sp = MLX5_ADDR_OF(mtrc_cap, out, string_db_param[i]);
-- 
2.39.1

