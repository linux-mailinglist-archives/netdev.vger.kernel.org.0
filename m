Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C6AF01EA7F0
	for <lists+netdev@lfdr.de>; Mon,  1 Jun 2020 18:46:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727795AbgFAQpm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Jun 2020 12:45:42 -0400
Received: from mail-lf1-f66.google.com ([209.85.167.66]:45496 "EHLO
        mail-lf1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726017AbgFAQpm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Jun 2020 12:45:42 -0400
Received: by mail-lf1-f66.google.com with SMTP id d7so4289590lfi.12;
        Mon, 01 Jun 2020 09:45:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=L4x8df+FWwhO9CVIfOrtORCmIfKK22E1tDxPOTpXN5A=;
        b=jMYlF33eeg9WmJ+6Vi/Uu2VVNPTMBe5oCe/clmgJOkHaGrZwVXhjdb+XBHalXjXqAa
         hxB9rWx6MqmQHD6oFwFaMVoEhg5+45kVb3aDiFexPgLnB2nNIF2MdsG+CPuBJ4w/PGcc
         DXH+GzKp9TWm3enMrSDnCvKNrGxWtc/lnLSpZ6r01yRVAx/xvcSZEm+Gq96Cod+Ute3e
         s2bSUL639xBP0njFEph6bpB8sAgDDKbtYdjQhQlFDqWtCd01P2dL1KLM4RMa1MQg2sho
         83GEKkgq8R5/OZSgfDzyBxLvYLb+qDzp0mMAzcGoA1vra7WuXAOSf/EpzCAgcENNze53
         qeVg==
X-Gm-Message-State: AOAM530femQKKB+0ThsKBHXYVGmWtNxSFOpkssnCyTB8kw3kcmrcLvMB
        oovJlxfddAXsfv/vCX3kOuY=
X-Google-Smtp-Source: ABdhPJze/gK70GwzModVzszP+ciOscUjhqgAb3Eeh1HMv7Nyf+c7n9VafFTWzUM0c3z3gPpxUDmLhQ==
X-Received: by 2002:a19:d57:: with SMTP id 84mr11809132lfn.112.1591029939553;
        Mon, 01 Jun 2020 09:45:39 -0700 (PDT)
Received: from localhost.localdomain (broadband-37-110-38-130.ip.moscow.rt.ru. [37.110.38.130])
        by smtp.googlemail.com with ESMTPSA id 4sm11062ljq.34.2020.06.01.09.45.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Jun 2020 09:45:38 -0700 (PDT)
From:   Denis Efremov <efremov@linux.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Leon Romanovsky <leon@kernel.org>,
        Alex Vesker <valex@mellanox.com>
Cc:     Denis Efremov <efremov@linux.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: [PATCH] net/mlx5: DR, Fix freeing in dr_create_rc_qp()
Date:   Mon,  1 Jun 2020 19:45:26 +0300
Message-Id: <20200601164526.19430-1-efremov@linux.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Variable "in" in dr_create_rc_qp() is allocated with kvzalloc() and
should be freed with kvfree().

Fixes: 297cccebdc5a ("net/mlx5: DR, Expose an internal API to issue RDMA operations")
Cc: stable@vger.kernel.org
Signed-off-by: Denis Efremov <efremov@linux.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/steering/dr_send.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_send.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_send.c
index 18719acb7e54..eff8bb64899d 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_send.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_send.c
@@ -181,7 +181,7 @@ static struct mlx5dr_qp *dr_create_rc_qp(struct mlx5_core_dev *mdev,
 							 in, pas));
 
 	err = mlx5_core_create_qp(mdev, &dr_qp->mqp, in, inlen);
-	kfree(in);
+	kvfree(in);
 
 	if (err) {
 		mlx5_core_warn(mdev, " Can't create QP\n");
-- 
2.26.2

