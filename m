Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D4F73DCC77
	for <lists+netdev@lfdr.de>; Sun,  1 Aug 2021 17:37:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232299AbhHAPhz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 1 Aug 2021 11:37:55 -0400
Received: from smtp-relay-canonical-0.canonical.com ([185.125.188.120]:34980
        "EHLO smtp-relay-canonical-0.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232117AbhHAPhy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 1 Aug 2021 11:37:54 -0400
Received: from localhost (1.general.cking.uk.vpn [10.172.193.212])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-canonical-0.canonical.com (Postfix) with ESMTPSA id 5EE3A3F0A6;
        Sun,  1 Aug 2021 15:37:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1627832265;
        bh=iLN8TLgdbvtmYaSUrV7g9uz/p2+EVNuytQVWi86ahzk=;
        h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type;
        b=t8Fam8VC535Ic8aJxhQoRDVyQCzWKu3d4lIVBZ/POU19Bi0STVDy2y8lyutq5WdAD
         8Q8BHNSVEF63yv55++n7UOgmygzQcvouHNFDq28M8b6dhJgk9Zt+R99ewDHavGOyqR
         Yu8khXUp6YYRbol1kJNsKAu+zPIr6CC/eteiCc7haB7MENS2p3FX1Dq3w15jqh45Lk
         8AsVEzReRJNwxQg+GTFkqgqxtm7VvntT8dWYubiW/4wxyZOtjPDI3Wuh9G2l8VXKxe
         Zxc3TObvjpl9iTgua6GC5RSg/vrTUYjAxJbdKnqHQUo/SBRlVWzLIdFpwUhjWzps1F
         pVBGXzRqmML8w==
From:   Colin King <colin.king@canonical.com>
To:     Tariq Toukan <tariqt@nvidia.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] net/mlx4: make the array states static const, makes object smaller
Date:   Sun,  1 Aug 2021 16:37:42 +0100
Message-Id: <20210801153742.147304-1-colin.king@canonical.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

Don't populate the array states on the stack but instead it
static const. Makes the object code smaller by 79 bytes.

Before:
   text   data   bss    dec    hex filename
  21309   8304   192  29805   746d drivers/net/ethernet/mellanox/mlx4/qp.o

After:
   text   data   bss    dec    hex filename
  21166   8368   192  29726   741e drivers/net/ethernet/mellanox/mlx4/qp.o

(gcc version 10.2.0)

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/net/ethernet/mellanox/mlx4/qp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx4/qp.c b/drivers/net/ethernet/mellanox/mlx4/qp.c
index 427e7a31862c..2584bc038f94 100644
--- a/drivers/net/ethernet/mellanox/mlx4/qp.c
+++ b/drivers/net/ethernet/mellanox/mlx4/qp.c
@@ -917,7 +917,7 @@ int mlx4_qp_to_ready(struct mlx4_dev *dev, struct mlx4_mtt *mtt,
 {
 	int err;
 	int i;
-	enum mlx4_qp_state states[] = {
+	static const enum mlx4_qp_state states[] = {
 		MLX4_QP_STATE_RST,
 		MLX4_QP_STATE_INIT,
 		MLX4_QP_STATE_RTR,
-- 
2.31.1

