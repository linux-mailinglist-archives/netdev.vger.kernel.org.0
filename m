Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 597564D3494
	for <lists+netdev@lfdr.de>; Wed,  9 Mar 2022 17:26:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235275AbiCIQZp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Mar 2022 11:25:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238386AbiCIQV7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Mar 2022 11:21:59 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CF563A5;
        Wed,  9 Mar 2022 08:21:00 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 23FBEB82212;
        Wed,  9 Mar 2022 16:20:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57812C340F4;
        Wed,  9 Mar 2022 16:20:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646842857;
        bh=6tcnReq4dlKG8UQNN1H5WqTssEeBvARoDbZQTqK+57o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rEEqkjnifxkc10cIn9soREV2HXkOFNuEMazySeey9nk22iRcBy17il2LUIKYRMG9q
         SW31YDIPrCW1z+5eTXmWjkv9dlj2sDpwxv1s/3oij0xJSd61wNp5P7ZSt+vbIr/2vY
         2fJc0YfzKYyL7mChUUocDCrupZtCx/Qhx0Gt+29K2k89/5y1KuzdlSlCKM1R6li9uU
         eSLhQUtGFwWNhgfbKs9HksUoZxV8Utxcxn55TweHSSFw1f0VX1xYjWlZ/rpX5GFOv7
         7Q9mYuIhY/qQC/FI+7fY75swB2APSqX8+HPGrjfq6CVsV/KJ2GxTmyepQYbQ1bKy/O
         dMUtviK5h3DNg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        Sasha Levin <sashal@kernel.org>, johan.hedberg@gmail.com,
        luiz.dentz@gmail.com, davem@davemloft.net, kuba@kernel.org,
        linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 13/24] Bluetooth: hci_core: Fix leaking sent_cmd skb
Date:   Wed,  9 Mar 2022 11:19:32 -0500
Message-Id: <20220309161946.136122-13-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220309161946.136122-1-sashal@kernel.org>
References: <20220309161946.136122-1-sashal@kernel.org>
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
index 53f1b08017aa..c67390367cc2 100644
--- a/net/bluetooth/hci_core.c
+++ b/net/bluetooth/hci_core.c
@@ -4083,6 +4083,7 @@ void hci_release_dev(struct hci_dev *hdev)
 	hci_dev_unlock(hdev);
 
 	ida_simple_remove(&hci_index_ida, hdev->id);
+	kfree_skb(hdev->sent_cmd);
 	kfree(hdev);
 }
 EXPORT_SYMBOL(hci_release_dev);
-- 
2.34.1

