Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4C0754D3474
	for <lists+netdev@lfdr.de>; Wed,  9 Mar 2022 17:25:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234411AbiCIQZO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Mar 2022 11:25:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238099AbiCIQVR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Mar 2022 11:21:17 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97DB7151D2B;
        Wed,  9 Mar 2022 08:18:31 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2CC606195C;
        Wed,  9 Mar 2022 16:18:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D6C3C340F3;
        Wed,  9 Mar 2022 16:18:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646842710;
        bh=94Eezw0rkaghiNp0XtbPiQ+zQlAXCbVMeFdXKfkMh5s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=C6LT1CmR0bVDarGjCQscOX3e9yz6PuHfBl0WPjllTU0mSB5YnaJQpxJ27DYNufMey
         4qlVhYoACC+m2VwYpAH/CFub3XmaweOMRZbUbi7WU/8qVTm3Cm4bBVn4t8fw/rgHTQ
         3tRJzMhYg/CQ7lFfvFhKSrJSOFmE9QTlhsFGu6Rvgv75vwJQIvJ33ikS8UB95l1L4u
         nOpCoXub6l2IbswKHG8MS86auduDp1Zg8f/Rj7bp3cmgmj+bzBv5HGXkGRMKrwb4bj
         /yDRjRFovIgscpAyKrsOVMpzj12UbYPSipJ4ijaG0PfEfV+gHbqHsRbzR1omWrNQ8j
         oX3ETFYEOqZ5w==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        Sasha Levin <sashal@kernel.org>, johan.hedberg@gmail.com,
        luiz.dentz@gmail.com, davem@davemloft.net, kuba@kernel.org,
        linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.16 14/27] Bluetooth: hci_core: Fix leaking sent_cmd skb
Date:   Wed,  9 Mar 2022 11:16:51 -0500
Message-Id: <20220309161711.135679-14-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220309161711.135679-1-sashal@kernel.org>
References: <20220309161711.135679-1-sashal@kernel.org>
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

From: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>

[ Upstream commit dd3b1dc3dd050f1f47cd13e300732852414270f8 ]

sent_cmd memory is not freed before freeing hci_dev causing it to leak
it contents.

Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Marcel Holtmann <marcel@holtmann.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/hci_core.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/bluetooth/hci_core.c b/net/bluetooth/hci_core.c
index 6c00ce302f09..1c8fb27b155a 100644
--- a/net/bluetooth/hci_core.c
+++ b/net/bluetooth/hci_core.c
@@ -3969,6 +3969,7 @@ void hci_release_dev(struct hci_dev *hdev)
 	hci_dev_unlock(hdev);
 
 	ida_simple_remove(&hci_index_ida, hdev->id);
+	kfree_skb(hdev->sent_cmd);
 	kfree(hdev);
 }
 EXPORT_SYMBOL(hci_release_dev);
-- 
2.34.1

