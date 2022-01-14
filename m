Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B35C48E816
	for <lists+netdev@lfdr.de>; Fri, 14 Jan 2022 11:08:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237542AbiANKH6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Jan 2022 05:07:58 -0500
Received: from mail-m971.mail.163.com ([123.126.97.1]:29376 "EHLO
        mail-m971.mail.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231187AbiANKH6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Jan 2022 05:07:58 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
        s=s110527; h=From:Subject:Date:Message-Id:MIME-Version; bh=xKG0/
        VpM8JY7qr+GY07L9dUEfdhlUMTKwgIXVuXGgaM=; b=oSPemfIEe1p9bZCRO0hrk
        NYDlF7vFo9qlEi02jZPFUQ9QvePhcYGMF/E62m6cUjtENaDh5tvGAhAzlyqEVJc9
        dtXX/qyleu/hj840qfb+rPyuWmeWPc5vS9IApHximty5/2Y8SnG7FpOcBo12jXYi
        qgAkmAJFvbYdOWPEIJ/xPI=
Received: from localhost.localdomain (unknown [112.97.56.99])
        by smtp1 (Coremail) with SMTP id GdxpCgAn3qpoS+FhBrA7AA--.2798S2;
        Fri, 14 Jan 2022 18:07:38 +0800 (CST)
From:   Slark Xiao <slark_xiao@163.com>
To:     loic.poulain@linaro.org, ryazanov.s.a@gmail.com,
        johannes@sipsolutions.net, davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Slark Xiao <slark_xiao@163.com>, Shujun Wang <wsj20369@163.com>
Subject: [PATCH] Fix MRU mismatch issue which may lead to data connection lost
Date:   Fri, 14 Jan 2022 18:07:31 +0800
Message-Id: <20220114100731.4033-1-slark_xiao@163.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: GdxpCgAn3qpoS+FhBrA7AA--.2798S2
X-Coremail-Antispam: 1Uf129KBjvJXoW7AFyDWFW5KFyfZw4fCw4fAFb_yoW8Jw15pF
        WY9345trn7X3y2ga1kGr17ZFy5K3Z8Wry7KrWa93yFqFn5ZFn0grZ0gr1Fvr4Fyay8CF4j
        yF4vqF47uan8uw7anT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07Uv0PhUUUUU=
X-Originating-IP: [112.97.56.99]
X-CM-SenderInfo: xvod2y5b0lt0i6rwjhhfrp/1tbiNQqIZFrPfATt3gAAsN
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In pci_generic.c there is a 'mru_default' in struct mhi_pci_dev_info.
This value shall be used for whole mhi if it's given a value for a specific product.
But in function mhi_net_rx_refill_work(), it's still using hard code value MHI_DEFAULT_MRU.
'mru_default' shall have higher priority than MHI_DEFAULT_MRU.
And after checking, this change could help fix a data connection lost issue.

Signed-off-by: Shujun Wang <wsj20369@163.com>
Signed-off-by: Slark Xiao <slark_xiao@163.com>
---
 drivers/net/wwan/mhi_wwan_mbim.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wwan/mhi_wwan_mbim.c b/drivers/net/wwan/mhi_wwan_mbim.c
index 71bf9b4f769f..6872782e8dd8 100644
--- a/drivers/net/wwan/mhi_wwan_mbim.c
+++ b/drivers/net/wwan/mhi_wwan_mbim.c
@@ -385,13 +385,13 @@ static void mhi_net_rx_refill_work(struct work_struct *work)
 	int err;
 
 	while (!mhi_queue_is_full(mdev, DMA_FROM_DEVICE)) {
-		struct sk_buff *skb = alloc_skb(MHI_DEFAULT_MRU, GFP_KERNEL);
+		struct sk_buff *skb = alloc_skb(mbim->mru, GFP_KERNEL);
 
 		if (unlikely(!skb))
 			break;
 
 		err = mhi_queue_skb(mdev, DMA_FROM_DEVICE, skb,
-				    MHI_DEFAULT_MRU, MHI_EOT);
+				    mbim->mru, MHI_EOT);
 		if (unlikely(err)) {
 			kfree_skb(skb);
 			break;
-- 
2.25.1

