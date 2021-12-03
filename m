Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 13D77466ED5
	for <lists+netdev@lfdr.de>; Fri,  3 Dec 2021 01:56:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244443AbhLCA7u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Dec 2021 19:59:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242803AbhLCA7u (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Dec 2021 19:59:50 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76B83C06174A
        for <netdev@vger.kernel.org>; Thu,  2 Dec 2021 16:56:27 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 02C75628ED
        for <netdev@vger.kernel.org>; Fri,  3 Dec 2021 00:56:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C8C7C53FD3;
        Fri,  3 Dec 2021 00:56:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638492986;
        bh=+Eir5sacTqr4F7mw9aLL0hA04sWv3S4swr8KFkrvyvw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XEd5Vz15he5xQlonWkOUixfUGAIwTLbuYSzftkRw/BD5MxNiBx50kwkPBW9UAwUBn
         /vDQNy1NXK6cCcUpTf1DUKk0XEUJDxinr+rk3lyn1gjOkTAehA90a9hM83iDNWSnyB
         1/xOszAd31H9nGUeL59Jf9K/nrg17wmlngLOoJqWVGFR8wx3zk2/wtI3RRqkIzcCy2
         wTLqjCSKsa6AUjap2z/AwKZs07aKZTp7GyJeGinaCUsZgh2IfcsegCFTOaRU89LHzu
         erW4vjTY3AwjxJhgT8MbGD8BSF1G3/8D7j5ryEOKJeO3k1fkOShZ8gV0H0jf1B1/KG
         mA1En0LonjJgA==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Wei Yongjun <weiyongjun1@huawei.com>,
        Hulk Robot <hulkci@huawei.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next v0 03/14] net/mlx5: Fix error return code in esw_qos_create()
Date:   Thu,  2 Dec 2021 16:56:11 -0800
Message-Id: <20211203005622.183325-4-saeed@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211203005622.183325-1-saeed@kernel.org>
References: <20211203005622.183325-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Wei Yongjun <weiyongjun1@huawei.com>

Fix to return a negative error code from the error handling
case instead of 0, as done elsewhere in this function.

Fixes: 85c5f7c9200e ("net/mlx5: E-switch, Create QoS on demand")
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/esw/qos.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/esw/qos.c b/drivers/net/ethernet/mellanox/mlx5/core/esw/qos.c
index eead33defa80..11bbcd5f5b8b 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/esw/qos.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/esw/qos.c
@@ -590,6 +590,7 @@ static int esw_qos_create(struct mlx5_eswitch *esw, struct netlink_ext_ack *exta
 		if (IS_ERR(esw->qos.group0)) {
 			esw_warn(dev, "E-Switch create rate group 0 failed (%ld)\n",
 				 PTR_ERR(esw->qos.group0));
+			err = PTR_ERR(esw->qos.group0);
 			goto err_group0;
 		}
 	}
-- 
2.31.1

