Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2C1A55F2647
	for <lists+netdev@lfdr.de>; Mon,  3 Oct 2022 00:51:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229681AbiJBWvp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Oct 2022 18:51:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229935AbiJBWus (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 Oct 2022 18:50:48 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64E9F1274C;
        Sun,  2 Oct 2022 15:50:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A512CB80DAF;
        Sun,  2 Oct 2022 22:50:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54954C433B5;
        Sun,  2 Oct 2022 22:50:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664751018;
        bh=lGWll2ZLCWNFayanlIW957ru5Q6QTijFAVemujlKJ1U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dc3N2lDCwKzfw0jBI3rrHXH1zLDITD5Ph2hOK3Zs27H7Qc5HsSUPnJwbt5to6A3et
         EX7zxhAlHJUQn20rfeq2dop34uw1qzDjOJFsfzf//o7N2bjfHHzQB1YJ6H3/i3wlzI
         fS/ocMZvGPkv1gKN2ciMbdN1jQFdYeYOWKb+k1Bl0gnxv443VE7wbLzDyNOPq3OX8N
         oToRhLGA3YpxSuLtZkLLrqfjclEmD5uK85b+N9vmJgIs8+h7glsOssHLbI/A2wrKSK
         FCdRj9cErfscqJ0ZX+LLlnOkX3JejVLPTCExgSeb7cnW+ZI/+/NozD/Gz3d5lxMfdy
         5HrvaCgn7KucQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jianglei Nie <niejianglei2021@163.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, irusskikh@marvell.com,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.19 21/29] net: atlantic: fix potential memory leak in aq_ndev_close()
Date:   Sun,  2 Oct 2022 18:49:14 -0400
Message-Id: <20221002224922.238837-21-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221002224922.238837-1-sashal@kernel.org>
References: <20221002224922.238837-1-sashal@kernel.org>
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
index 88595863d8bc..8a0af371e7dc 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_main.c
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_main.c
@@ -94,11 +94,8 @@ static int aq_ndev_close(struct net_device *ndev)
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

