Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 782C04EEF9C
	for <lists+netdev@lfdr.de>; Fri,  1 Apr 2022 16:27:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347083AbiDAO26 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Apr 2022 10:28:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346996AbiDAO23 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Apr 2022 10:28:29 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E59AA1DF855;
        Fri,  1 Apr 2022 07:26:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A110EB824FD;
        Fri,  1 Apr 2022 14:26:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D400C34111;
        Fri,  1 Apr 2022 14:26:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648823197;
        bh=i4thxzazsMrvV6+OrMgNHpCD1BrjujPV8ivaYkSDGZE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=A2LLqRLzDHUGOAx7P4LHNH7VHYOIunJ3oBvMo7Hp0Otkp36D4kVTYEc0l54YZR9P2
         OM0KOurmwR30K6t8v0ZJQ8WK8H3YitNHtRx7NA8wdRqa0/XlVaJvV4N6R9fmymqN0k
         02EvMZob4DonwsB+Ie+b9wMxf6Rx4l/Pf1fQ5W4McVcFvQFlHXjwYXtOgRgUWgKeok
         4L52tPXRxkS4SdpKcRWC5ilLfoT3/Y2ffvwUkyezHe2VpOdOYOgNOd+yf0RsUFnBLR
         3leoOvzgPMfJzFJBI0gap3NYwiPB0HLfDQnVWIAjPn7d6TApe3jywgBOIwyPUxz8Yr
         Qgv5e+9nAGGcQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        Sasha Levin <sashal@kernel.org>, johan.hedberg@gmail.com,
        luiz.dentz@gmail.com, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, linux-bluetooth@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.17 018/149] Bluetooth: hci_sync: Fix queuing commands when HCI_UNREGISTER is set
Date:   Fri,  1 Apr 2022 10:23:25 -0400
Message-Id: <20220401142536.1948161-18-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220401142536.1948161-1-sashal@kernel.org>
References: <20220401142536.1948161-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>

[ Upstream commit 0b94f2651f56b9e4aa5f012b0d7eb57308c773cf ]

hci_cmd_sync_queue shall return an error if HCI_UNREGISTER flag has
been set as that means hci_unregister_dev has been called so it will
likely cause a uaf after the timeout as the hdev will be freed.

Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Marcel Holtmann <marcel@holtmann.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/hci_sync.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/bluetooth/hci_sync.c b/net/bluetooth/hci_sync.c
index 4426cc2aaf4a..21350dc88868 100644
--- a/net/bluetooth/hci_sync.c
+++ b/net/bluetooth/hci_sync.c
@@ -379,6 +379,9 @@ int hci_cmd_sync_queue(struct hci_dev *hdev, hci_cmd_sync_work_func_t func,
 {
 	struct hci_cmd_sync_work_entry *entry;
 
+	if (hci_dev_test_flag(hdev, HCI_UNREGISTER))
+		return -ENODEV;
+
 	entry = kmalloc(sizeof(*entry), GFP_KERNEL);
 	if (!entry)
 		return -ENOMEM;
-- 
2.34.1

