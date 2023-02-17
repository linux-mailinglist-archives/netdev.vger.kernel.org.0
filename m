Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DFE7869AD60
	for <lists+netdev@lfdr.de>; Fri, 17 Feb 2023 15:09:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229974AbjBQOJo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Feb 2023 09:09:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229948AbjBQOJn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Feb 2023 09:09:43 -0500
Received: from exchange.fintech.ru (exchange.fintech.ru [195.54.195.159])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90E1F67816;
        Fri, 17 Feb 2023 06:09:42 -0800 (PST)
Received: from Ex16-01.fintech.ru (10.0.10.18) by exchange.fintech.ru
 (195.54.195.159) with Microsoft SMTP Server (TLS) id 14.3.498.0; Fri, 17 Feb
 2023 17:09:40 +0300
Received: from KANASHIN1.fintech.ru (10.0.253.125) by Ex16-01.fintech.ru
 (10.0.10.18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2242.4; Fri, 17 Feb
 2023 17:09:40 +0300
From:   Natalia Petrova <n.petrova@fintech.ru>
To:     Ido Schimmel <idosch@nvidia.com>
CC:     Natalia Petrova <n.petrova@fintech.ru>,
        Petr Machata <petrm@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <lvc-project@linuxtesting.org>
Subject: [PATCH] mlxsw_spectrum_router: add check for return value of 'mlxsw_sp_rif_find_by_dev'
Date:   Fri, 17 Feb 2023 17:09:39 +0300
Message-ID: <20230217140939.487978-1-n.petrova@fintech.ru>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.0.253.125]
X-ClientProxiedBy: Ex16-01.fintech.ru (10.0.10.18) To Ex16-01.fintech.ru
 (10.0.10.18)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Pointer 'rif' that contains the return value of 'mlxsw_sp_rif_find_by_dev'
is checked for NULL to avoid possible undefined behavior below caused by
dereference in 'mlxsw_sp_rif_destroy'.

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Fixes: e4f3c1c17b6d ("mlxsw: spectrum_router: Implement common RIF core")
Signed-off-by: Natalia Petrova <n.petrova@fintech.ru>
---
 drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
index 2c4443c6b964..4f41b83d7c9e 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
@@ -8658,7 +8658,8 @@ static int mlxsw_sp_inetaddr_bridge_event(struct mlxsw_sp *mlxsw_sp,
 		break;
 	case NETDEV_DOWN:
 		rif = mlxsw_sp_rif_find_by_dev(mlxsw_sp, l3_dev);
-		mlxsw_sp_rif_destroy(rif);
+		if (rif)
+			mlxsw_sp_rif_destroy(rif);
 		break;
 	}
 
-- 
2.34.1

