Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8DC435F271A
	for <lists+netdev@lfdr.de>; Mon,  3 Oct 2022 01:11:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230334AbiJBXLu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Oct 2022 19:11:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230267AbiJBXLb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 Oct 2022 19:11:31 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 861B74BA77;
        Sun,  2 Oct 2022 16:05:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B4CF8B80D9B;
        Sun,  2 Oct 2022 22:52:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83BD9C433D6;
        Sun,  2 Oct 2022 22:52:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664751146;
        bh=O05FW3w/LggRXO4vo3CZH9qAGGAoImGTQJbu+UYiAMQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AxiEIMno+TzWPgz9qe7ZxF78gc61VgTRl4RxvSEZSB1cuv5srOUHhawcRGz03sGmk
         CyvdPiOrDc2FefKLb/yX89u31JKC2huwPVG9kDrxfDnRul6huhKDbaPsis8g7EWaPy
         +iw59Hlujp592UHTp9mlBafylCKWxgzDU021KnMNOgZiX+AGk6K5eV+hSLkJDC8YII
         EhsrW1Uzo+A3eBVut5eT73lDh7RZdJs7nOHM4bpVXgbbDmzi1wKDyrtwIP3P9DxhWL
         ffeYA4ZXnyUNTD9sztd8BJ+n0MpbRm5tKQ7BTsBX2m+p+F/S1bEBvPg0vlMJJEiIhl
         jXqaFDjvRFyZQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jianglei Nie <niejianglei2021@163.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, irusskikh@marvell.com,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 12/14] net: atlantic: fix potential memory leak in aq_ndev_close()
Date:   Sun,  2 Oct 2022 18:51:53 -0400
Message-Id: <20221002225155.239480-12-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221002225155.239480-1-sashal@kernel.org>
References: <20221002225155.239480-1-sashal@kernel.org>
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
index 4af0cd9530de..ff245f75fa3d 100644
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

