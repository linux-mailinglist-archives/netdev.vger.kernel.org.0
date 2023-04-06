Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7D4CE6D95AB
	for <lists+netdev@lfdr.de>; Thu,  6 Apr 2023 13:35:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238302AbjDFLfu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Apr 2023 07:35:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238127AbjDFLe6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Apr 2023 07:34:58 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5BEBAD0D;
        Thu,  6 Apr 2023 04:33:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6FA756448A;
        Thu,  6 Apr 2023 11:33:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4C03C433D2;
        Thu,  6 Apr 2023 11:33:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680780812;
        bh=F//45VwgUYwqnq/zqqoCuZrjr2a4lXeB7zZZmi+WW18=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ix4ifbsgIjd7Tco/WO+y8ew6V6mTHe4FZQGVti6K+JSO51Bn5paoqTz6CJLqvBQfw
         dOsUNIyMxnggaI6/hcgFMHVPIU7OfaPbrL+x1nnJuIz+/GPdd9ixvtH/Ced5TOOHrs
         0OMNBzdCoCtXwC5GNCxudCYFa09sL44/xIIcLjNUvfZ/5ypiU1nRqA2079CX2HCL7o
         2t8y+75DOBqSnzo6dOqQlmpfsY4LHyqWm8njGCJhPElDD6FsDOY90TKpxewoTFcCwh
         66iRRsvMjMdhnM5GL3y1uzkkiAaqnJLW/+ntNwlEdMvLBrSjaocsCieH1i+4zsO/tY
         adappPsAeELmg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     =?UTF-8?q?=C3=81lvaro=20Fern=C3=A1ndez=20Rojas?= 
        <noltari@gmail.com>, Florian Fainelli <f.fainelli@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, andrew@lunn.ch,
        olteanv@gmail.com, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 6/9] net: dsa: b53: mmap: add phy ops
Date:   Thu,  6 Apr 2023 07:33:12 -0400
Message-Id: <20230406113315.648777-6-sashal@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230406113315.648777-1-sashal@kernel.org>
References: <20230406113315.648777-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
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
index c628d0980c0b1..1d52cb3e46d52 100644
--- a/drivers/net/dsa/b53/b53_mmap.c
+++ b/drivers/net/dsa/b53/b53_mmap.c
@@ -215,6 +215,18 @@ static int b53_mmap_write64(struct b53_device *dev, u8 page, u8 reg,
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
@@ -226,6 +238,8 @@ static const struct b53_io_ops b53_mmap_ops = {
 	.write32 = b53_mmap_write32,
 	.write48 = b53_mmap_write48,
 	.write64 = b53_mmap_write64,
+	.phy_read16 = b53_mmap_phy_read16,
+	.phy_write16 = b53_mmap_phy_write16,
 };
 
 static int b53_mmap_probe(struct platform_device *pdev)
-- 
2.39.2

