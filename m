Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 458B28C882
	for <lists+netdev@lfdr.de>; Wed, 14 Aug 2019 04:32:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728992AbfHNCQX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Aug 2019 22:16:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:47868 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729020AbfHNCQW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 13 Aug 2019 22:16:22 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D8E9D2085A;
        Wed, 14 Aug 2019 02:16:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565748981;
        bh=3pR9tdI3PUn2xwphxQu6fBzLnYl6h0dWcli9kTSxdSI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lghyhlJJOxM3703MN/4VyqmvPNJBt1jXiw0M0e1SM0xI8ck2ipPtZZhxu+H8YHUoi
         NuoVJKI9IV3H2kYY5VbaUqd70ovzDhoEQDcbRewoVOwOqTbPKq7wRKKuWAaJ6GNh8o
         xuD4xh16u1iIks49RAYqvDlyw58P3gfuIZrlQMP0=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Navid Emamdoost <navid.emamdoost@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 18/68] st_nci_hci_connectivity_event_received: null check the allocation
Date:   Tue, 13 Aug 2019 22:14:56 -0400
Message-Id: <20190814021548.16001-18-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190814021548.16001-1-sashal@kernel.org>
References: <20190814021548.16001-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Navid Emamdoost <navid.emamdoost@gmail.com>

[ Upstream commit 3008e06fdf0973770370f97d5f1fba3701d8281d ]

devm_kzalloc may fail and return NULL. So the null check is needed.

Signed-off-by: Navid Emamdoost <navid.emamdoost@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nfc/st-nci/se.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/nfc/st-nci/se.c b/drivers/nfc/st-nci/se.c
index f55d082ace715..5d6e7e931bc6c 100644
--- a/drivers/nfc/st-nci/se.c
+++ b/drivers/nfc/st-nci/se.c
@@ -344,6 +344,8 @@ static int st_nci_hci_connectivity_event_received(struct nci_dev *ndev,
 
 		transaction = (struct nfc_evt_transaction *)devm_kzalloc(dev,
 					    skb->len - 2, GFP_KERNEL);
+		if (!transaction)
+			return -ENOMEM;
 
 		transaction->aid_len = skb->data[1];
 		memcpy(transaction->aid, &skb->data[2], transaction->aid_len);
-- 
2.20.1

