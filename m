Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 551204D3614
	for <lists+netdev@lfdr.de>; Wed,  9 Mar 2022 18:43:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236526AbiCIQfz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Mar 2022 11:35:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236396AbiCIQ34 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Mar 2022 11:29:56 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2022670F4E;
        Wed,  9 Mar 2022 08:23:01 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E196EB82256;
        Wed,  9 Mar 2022 16:22:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB2FCC36AE2;
        Wed,  9 Mar 2022 16:22:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646842978;
        bh=k8jhjV4CJs7IhI95iarqfAAHzfd8JtOKmNL1gm3q48s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jA2i52ZG2U+NpejyI/EWW+NAvF7BcwLaMnAtCiSjJyZmBoGri2dKDqirWJWinxVIM
         oE2E8Zk+D1688OKxXupitrG9wkizQpqnnqqEe/CWoh2ynm3RElMyUmv3lBKxNBqolx
         MElpk7J0nH14W/hl2Iik5KJ+OKBJ3+cnhbPrYjEm0sVfx4TvIHjO4JoGtTjBwdfQAo
         qVwxuvAYfD1KRLjXtAL4CSMSgH8cA3zS4/Rr989Gu6aEYL5XA41EVO0b3xNp5vQiTj
         0etdx3bgME8tMQT1u4y2EleA3Ce1cvivO7fcHqjMgu8CzxcQSR44PRggwMFnybW3E+
         50j8htSRqrDpA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jia-Ju Bai <baijiaju1990@gmail.com>,
        TOTE Robot <oslab@tsinghua.edu.cn>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, 3chas3@gmail.com,
        linux-atm-general@lists.sourceforge.net, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 12/20] atm: firestream: check the return value of ioremap() in fs_init()
Date:   Wed,  9 Mar 2022 11:21:50 -0500
Message-Id: <20220309162158.136467-12-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220309162158.136467-1-sashal@kernel.org>
References: <20220309162158.136467-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jia-Ju Bai <baijiaju1990@gmail.com>

[ Upstream commit d4e26aaea7f82ba884dcb4acfe689406bc092dc3 ]

The function ioremap() in fs_init() can fail, so its return value should
be checked.

Reported-by: TOTE Robot <oslab@tsinghua.edu.cn>
Signed-off-by: Jia-Ju Bai <baijiaju1990@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/atm/firestream.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/atm/firestream.c b/drivers/atm/firestream.c
index 0ddd611b4277..43a34aee33b8 100644
--- a/drivers/atm/firestream.c
+++ b/drivers/atm/firestream.c
@@ -1675,6 +1675,8 @@ static int fs_init(struct fs_dev *dev)
 	dev->hw_base = pci_resource_start(pci_dev, 0);
 
 	dev->base = ioremap(dev->hw_base, 0x1000);
+	if (!dev->base)
+		return 1;
 
 	reset_chip (dev);
   
-- 
2.34.1

