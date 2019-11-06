Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0CA34F1926
	for <lists+netdev@lfdr.de>; Wed,  6 Nov 2019 15:53:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727463AbfKFOx3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Nov 2019 09:53:29 -0500
Received: from szxga05-in.huawei.com ([45.249.212.191]:5736 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727028AbfKFOx3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 6 Nov 2019 09:53:29 -0500
Received: from DGGEMS404-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 162957F8FDE31D17B9B2;
        Wed,  6 Nov 2019 22:53:27 +0800 (CST)
Received: from localhost.localdomain.localdomain (10.175.113.25) by
 DGGEMS404-HUB.china.huawei.com (10.3.19.204) with Microsoft SMTP Server id
 14.3.439.0; Wed, 6 Nov 2019 22:53:17 +0800
From:   Wei Yongjun <weiyongjun1@huawei.com>
To:     Jiri Pirko <jiri@mellanox.com>, Ido Schimmel <idosch@mellanox.com>
CC:     Wei Yongjun <weiyongjun1@huawei.com>, <netdev@vger.kernel.org>,
        <kernel-janitors@vger.kernel.org>
Subject: [PATCH net-next] mlxsw: spectrum: Fix error return code in mlxsw_sp_port_module_info_init()
Date:   Wed, 6 Nov 2019 14:52:31 +0000
Message-ID: <20191106145231.39128-1-weiyongjun1@huawei.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Type:   text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Originating-IP: [10.175.113.25]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix to return negative error code -ENOMEM from the error handling
case instead of 0, as done elsewhere in this function.

Fixes: 4a7f970f1240 ("mlxsw: spectrum: Replace port_to_module array with array of structs")
Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>
---
 drivers/net/ethernet/mellanox/mlxsw/spectrum.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
index ea4cc2aa99e0..838c014f6ed1 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
@@ -4079,8 +4079,10 @@ static int mlxsw_sp_port_module_info_init(struct mlxsw_sp *mlxsw_sp)
 		mlxsw_sp->port_mapping[i] = kmemdup(&port_mapping,
 						    sizeof(port_mapping),
 						    GFP_KERNEL);
-		if (!mlxsw_sp->port_mapping[i])
+		if (!mlxsw_sp->port_mapping[i]) {
+			err = -ENOMEM;
 			goto err_port_module_info_dup;
+		}
 	}
 	return 0;



