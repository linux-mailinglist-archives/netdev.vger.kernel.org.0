Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA23A31701F
	for <lists+netdev@lfdr.de>; Wed, 10 Feb 2021 20:29:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232585AbhBJT33 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Feb 2021 14:29:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:35402 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231543AbhBJT3Y (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 10 Feb 2021 14:29:24 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 73BCB64D87;
        Wed, 10 Feb 2021 19:28:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612985324;
        bh=HZeRA0wf6cQ3iF2juNEpRdU2/esbK6so0nxyIbO5Qu4=;
        h=Date:From:To:Cc:Subject:From;
        b=U1wp5D8vd+zgKyEV2qXFtNCoC1kmwkcRgYB67fcWOaPmaLIn9dFDsK4Km61cGcRKN
         FujIPamUoEbKtfsJ0OBaYHOUQqfPEtKsnOIxtQD5cSeCfGHyDKgrqnmIqHC2P5bDNP
         RkG0z2+uAuVOmfIJD0AS7HbbbkbRyxJelmaKXrGQ2i+XV7lqvDDGidMi5NqQwfXd2k
         EORJtMYvuWDqNuSUou7gw4mqmhTGDg6vrgvHNC4aIcriyqnrTExCyj0ZUyIX7K1HDT
         FrqRh92vDxE8cHfVzzg7a9/WU72SPZsV7xdhw/AmHkXgG7IPpMMkAKXzkjb1J/e3iH
         zjB7FeGZXxqoQ==
Date:   Wed, 10 Feb 2021 13:28:41 -0600
From:   "Gustavo A. R. Silva" <gustavoars@kernel.org>
To:     Yisen Zhuang <yisen.zhuang@huawei.com>,
        Salil Mehta <salil.mehta@huawei.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Huazhong Tan <tanhuazhong@huawei.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>
Subject: [PATCH][next] net: hns3: fix return of random stack value
Message-ID: <20210210192841.GA838928@embeddedor>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently, a random stack value is being returned because variable
_ret_ is not properly initialized. This variable is actually not
used anymore and it should be removed.

Fix this by removing all instances of variable ret and return 0.

Fixes: 64749c9c38a9 ("net: hns3: remove redundant return value of hns3_uninit_all_ring()")
Addresses-Coverity-ID: 1501700 ("Uninitialized scalar variable")
Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
---
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
index 9565b7999426..bf4302a5cf95 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
@@ -4640,7 +4640,6 @@ static int hns3_reset_notify_uninit_enet(struct hnae3_handle *handle)
 {
 	struct net_device *netdev = handle->kinfo.netdev;
 	struct hns3_nic_priv *priv = netdev_priv(netdev);
-	int ret;
 
 	if (!test_and_clear_bit(HNS3_NIC_STATE_INITED, &priv->state)) {
 		netdev_warn(netdev, "already uninitialized\n");
@@ -4662,7 +4661,7 @@ static int hns3_reset_notify_uninit_enet(struct hnae3_handle *handle)
 
 	hns3_put_ring_config(priv);
 
-	return ret;
+	return 0;
 }
 
 static int hns3_reset_notify(struct hnae3_handle *handle,
-- 
2.27.0

