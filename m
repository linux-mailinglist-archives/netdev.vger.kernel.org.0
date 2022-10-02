Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 771465F2698
	for <lists+netdev@lfdr.de>; Mon,  3 Oct 2022 00:55:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230292AbiJBWzK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Oct 2022 18:55:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230167AbiJBWyF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 Oct 2022 18:54:05 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 508D83E760;
        Sun,  2 Oct 2022 15:51:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4F9E660F0C;
        Sun,  2 Oct 2022 22:51:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8F5FC43470;
        Sun,  2 Oct 2022 22:51:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664751095;
        bh=uHkFqy/3KX5ATWrvmJSZU7yLAobRW9HH8hZoqhzThtc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QKwC0uVCaRZWIk6WMrWR90a0qMLUl8HuKnfy/RTOL+FQ1dL7U/LoP06bbLZ0Vou9V
         W7sCPPQKuWjIDktlyj2r7hplUhtPOS0g7ZFrkHW/DoFcFI4BIuHxarixkzH932E0+e
         TZGUrma5DzaaNFKzh5tTg9/UOmYWUA+pBAqF8p5416jqxYxTnp2lVuwOofoWeaayJ0
         bsu0jRbYyvKnYsF3ao15pOxc6M3PcxbcizGvxzEWjNZkY9KqkVIu0/0g1FgbivXZHt
         uNzxHGCFoNgO4qkPBmpPr2/3BBYm4ZRjQiCswEVznKQyXuW65urcuargWg46d8/eEg
         F8FR1BzDnZpOA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jianglei Nie <niejianglei2021@163.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, irusskikh@marvell.com,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 16/20] net: atlantic: fix potential memory leak in aq_ndev_close()
Date:   Sun,  2 Oct 2022 18:50:55 -0400
Message-Id: <20221002225100.239217-16-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221002225100.239217-1-sashal@kernel.org>
References: <20221002225100.239217-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jianglei Nie <niejianglei2021@163.com>

[ Upstream commit 65e5d27df61283e5390f04b09dc79cd832f95607 ]

If aq_nic_stop() fails, aq_ndev_close() returns err without calling
aq_nic_deinit() to release the relevant memory and resource, which
will lead to a memory leak.

We can fix it by deleting the if condition judgment and goto statement to
call aq_nic_deinit() directly after aq_nic_stop() to fix the memory leak.

Signed-off-by: Jianglei Nie <niejianglei2021@163.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/aquantia/atlantic/aq_main.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_main.c b/drivers/net/ethernet/aquantia/atlantic/aq_main.c
index e22935ce9573..f069312463fb 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_main.c
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_main.c
@@ -89,11 +89,8 @@ static int aq_ndev_close(struct net_device *ndev)
 	int err = 0;
 
 	err = aq_nic_stop(aq_nic);
-	if (err < 0)
-		goto err_exit;
 	aq_nic_deinit(aq_nic, true);
 
-err_exit:
 	return err;
 }
 
-- 
2.35.1

