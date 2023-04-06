Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D673D6D9532
	for <lists+netdev@lfdr.de>; Thu,  6 Apr 2023 13:32:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237230AbjDFLcN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Apr 2023 07:32:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237363AbjDFLcA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Apr 2023 07:32:00 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11AE19740;
        Thu,  6 Apr 2023 04:31:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1F2BE6465C;
        Thu,  6 Apr 2023 11:31:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73D99C4339E;
        Thu,  6 Apr 2023 11:31:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680780709;
        bh=2mxQnyIbun5nh7sgVCBRUrrK5WNidCF0V7zcXrMZs5g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mRzMU8VcsDp/Z6B3JqircvvfdNpYyxhglMj8Bzp6Tx/KTfbwwyp9q1P+VLG2l5+4n
         H7EXAg2afRRckmxGc+UjHId4R52AUa6iDIos/ZCIIhfFSQHcbmudk4L8uxXEPRZYVP
         vt2ozcMB0rZoFNfCcsM4nNlq82DKdYnsy309Ib7NGMSyq2a/lzBce73w+HpQWV9n4j
         yQzJ7ei7wfXwP7fyuWYCtpP0pIvCOoauznDrkDsk50ISTtMpEPUYm7xYb+0FNHBKRz
         IdN583pYEg/8Bidsz+t6RU864BbF+bCxGkfuSikW6ywcxDe2tT9wJf8leOmtQAfS2L
         3h3OBn4PmpLZQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     =?UTF-8?q?=C3=81lvaro=20Fern=C3=A1ndez=20Rojas?= 
        <noltari@gmail.com>, Florian Fainelli <f.fainelli@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, andrew@lunn.ch,
        olteanv@gmail.com, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 6.2 07/17] net: dsa: b53: mmap: add phy ops
Date:   Thu,  6 Apr 2023 07:31:21 -0400
Message-Id: <20230406113131.648213-7-sashal@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230406113131.648213-1-sashal@kernel.org>
References: <20230406113131.648213-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Álvaro Fernández Rojas <noltari@gmail.com>

[ Upstream commit 45977e58ce65ed0459edc9a0466d9dfea09463f5 ]

Implement phy_read16() and phy_write16() ops for B53 MMAP to avoid accessing
B53_PORT_MII_PAGE registers which hangs the device.
This access should be done through the MDIO Mux bus controller.

Signed-off-by: Álvaro Fernández Rojas <noltari@gmail.com>
Acked-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/b53/b53_mmap.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/drivers/net/dsa/b53/b53_mmap.c b/drivers/net/dsa/b53/b53_mmap.c
index 70887e0aece33..d9434ed9450df 100644
--- a/drivers/net/dsa/b53/b53_mmap.c
+++ b/drivers/net/dsa/b53/b53_mmap.c
@@ -216,6 +216,18 @@ static int b53_mmap_write64(struct b53_device *dev, u8 page, u8 reg,
 	return 0;
 }
 
+static int b53_mmap_phy_read16(struct b53_device *dev, int addr, int reg,
+			       u16 *value)
+{
+	return -EIO;
+}
+
+static int b53_mmap_phy_write16(struct b53_device *dev, int addr, int reg,
+				u16 value)
+{
+	return -EIO;
+}
+
 static const struct b53_io_ops b53_mmap_ops = {
 	.read8 = b53_mmap_read8,
 	.read16 = b53_mmap_read16,
@@ -227,6 +239,8 @@ static const struct b53_io_ops b53_mmap_ops = {
 	.write32 = b53_mmap_write32,
 	.write48 = b53_mmap_write48,
 	.write64 = b53_mmap_write64,
+	.phy_read16 = b53_mmap_phy_read16,
+	.phy_write16 = b53_mmap_phy_write16,
 };
 
 static int b53_mmap_probe_of(struct platform_device *pdev,
-- 
2.39.2

