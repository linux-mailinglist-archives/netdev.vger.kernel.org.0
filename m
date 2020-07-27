Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C95522FDCB
	for <lists+netdev@lfdr.de>; Tue, 28 Jul 2020 01:29:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728008AbgG0XYB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jul 2020 19:24:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:34820 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727977AbgG0XX7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 27 Jul 2020 19:23:59 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E456B2173E;
        Mon, 27 Jul 2020 23:23:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595892238;
        bh=2lk5uht8HIRYz3UwO/2cD6dc8jKUN8zbECfiXqIVzu0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=piJAQTQA24wKRgpgdp95mEazTRdEb+3MCVqPsveWwpAK1CgmSjAoWAqCzqFakpe9w
         AvoxrSa5NjiBTCILEfb3ydl/qQ3xaDPepLoY0dgWW/QJrylQK9kyFLN+2dZ7l/iArp
         k5719aLxq9o3fpXNyaSo0XiyS1FxqlkPQBGxJ/5s=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Navid Emamdoost <navid.emamdoost@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, linux-nfc@lists.01.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.7 09/25] nfc: s3fwrn5: add missing release on skb in s3fwrn5_recv_frame
Date:   Mon, 27 Jul 2020 19:23:29 -0400
Message-Id: <20200727232345.717432-9-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200727232345.717432-1-sashal@kernel.org>
References: <20200727232345.717432-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Navid Emamdoost <navid.emamdoost@gmail.com>

[ Upstream commit 1e8fd3a97f2d83a7197876ceb4f37b4c2b00a0f3 ]

The implementation of s3fwrn5_recv_frame() is supposed to consume skb on
all execution paths. Release skb before returning -ENODEV.

Signed-off-by: Navid Emamdoost <navid.emamdoost@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nfc/s3fwrn5/core.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/nfc/s3fwrn5/core.c b/drivers/nfc/s3fwrn5/core.c
index 91d4d5b28a7d9..ba6c486d64659 100644
--- a/drivers/nfc/s3fwrn5/core.c
+++ b/drivers/nfc/s3fwrn5/core.c
@@ -198,6 +198,7 @@ int s3fwrn5_recv_frame(struct nci_dev *ndev, struct sk_buff *skb,
 	case S3FWRN5_MODE_FW:
 		return s3fwrn5_fw_recv_frame(ndev, skb);
 	default:
+		kfree_skb(skb);
 		return -ENODEV;
 	}
 }
-- 
2.25.1

