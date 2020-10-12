Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A8FC928C4DC
	for <lists+netdev@lfdr.de>; Tue, 13 Oct 2020 00:42:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730348AbgJLWmN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Oct 2020 18:42:13 -0400
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:15025 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389220AbgJLWmM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Oct 2020 18:42:12 -0400
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5f84dbb80000>; Mon, 12 Oct 2020 15:42:00 -0700
Received: from sx1.mtl.com (10.124.1.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Mon, 12 Oct
 2020 22:42:12 +0000
From:   Saeed Mahameed <saeedm@nvidia.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, "David S. Miller" <davem@davemloft.net>,
        "Colin Ian King" <colin.king@canonical.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 1/4] net/mlx5: Fix uininitialized pointer read on pointer attr
Date:   Mon, 12 Oct 2020 15:41:49 -0700
Message-ID: <20201012224152.191479-2-saeedm@nvidia.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201012224152.191479-1-saeedm@nvidia.com>
References: <20201012224152.191479-1-saeedm@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL105.nvidia.com (172.20.187.12) To
 HQMAIL107.nvidia.com (172.20.187.13)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1602542520; bh=dNWhVFlcaLVZPdR7pQZm+7nWq+II5tIQDwsuMWqpOKo=;
        h=From:To:CC:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
         References:MIME-Version:Content-Transfer-Encoding:Content-Type:
         X-Originating-IP:X-ClientProxiedBy;
        b=IdpJK+rlVrjz0aiia8O+Qcby6KJxTkr2Z8PcxEofF2UHufe9DvZjFfkWGKfBSSviy
         BD+Djhahd22Eb5H09riWVT+VlmoBGq1e1ejseH43yUNNcfD7n+RX3q04fE3fdfT/cA
         8L41ID4fJHr5siSIBp/DOgAZjPOaKtE3ycq44M5rZzE2v2z4U5Ku1jQUd6fvok2+SO
         eBuwDTeKjfdJOCfIHjJrHB8rsNR6F5khWsQzdHTewAl2/ETwZ9UBb2wTPcgxEova2E
         UIhWmlQ22Sb0ymCPK1taUDKY6h9IS7tr887RfqqGa8OH+w4RPVNedytvj8gAbShNdc
         jlCcSZopgfirQ==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

Currently the error exit path err_free kfree's attr. In the case where
flow and parse_attr failed to be allocated this return path will free
the uninitialized pointer attr, which is not correct.  In the other
case where attr fails to allocate attr does not need to be freed. So
in both error exits via err_free attr should not be freed, so remove
it.

Addresses-Coverity: ("Uninitialized pointer read")
Fixes: ff7ea04ad579 ("net/mlx5e: Fix potential null pointer dereference")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/=
ethernet/mellanox/mlx5/core/en_tc.c
index a0c356987e1a..e3a968e9e2a0 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -4569,7 +4569,6 @@ mlx5e_alloc_flow(struct mlx5e_priv *priv, int attr_si=
ze,
 err_free:
 	kfree(flow);
 	kvfree(parse_attr);
-	kfree(attr);
 	return err;
 }
=20
--=20
2.26.2

