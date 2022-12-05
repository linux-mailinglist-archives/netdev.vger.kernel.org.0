Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A3AD06427D9
	for <lists+netdev@lfdr.de>; Mon,  5 Dec 2022 12:53:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231566AbiLELxh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Dec 2022 06:53:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231706AbiLELwr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Dec 2022 06:52:47 -0500
Received: from gw.red-soft.ru (red-soft.ru [188.246.186.2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id F3DBF1A805;
        Mon,  5 Dec 2022 03:52:06 -0800 (PST)
Received: from localhost.biz (unknown [10.81.81.211])
        by gw.red-soft.ru (Postfix) with ESMTPA id 2CFCF3E6085;
        Mon,  5 Dec 2022 14:52:04 +0300 (MSK)
From:   Artem Chernyshev <artem.chernyshev@red-soft.ru>
To:     Stefano Garzarella <sgarzare@redhat.com>,
        Vishnu Dasa <vdasa@vmware.com>
Cc:     Artem Chernyshev <artem.chernyshev@red-soft.ru>,
        VMware PV-Drivers Reviewers <pv-drivers@vmware.com>,
        Bryan Tan <bryantan@vmware.com>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        lvc-project@linuxtesting.org
Subject: [PATCH v3] net: vmw_vsock: vmci: Check memcpy_from_msg()
Date:   Mon,  5 Dec 2022 14:52:00 +0300
Message-Id: <20221205115200.2987942-1-artem.chernyshev@red-soft.ru>
X-Mailer: git-send-email 2.30.3
In-Reply-To: <20221205094736.k3yuwk7emijpitvw@sgarzare-redhat>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-KLMS-Rule-ID: 1
X-KLMS-Message-Action: clean
X-KLMS-AntiSpam-Lua-Profiles: 173924 [Dec 05 2022]
X-KLMS-AntiSpam-Version: 5.9.59.0
X-KLMS-AntiSpam-Envelope-From: artem.chernyshev@red-soft.ru
X-KLMS-AntiSpam-Rate: 0
X-KLMS-AntiSpam-Status: not_detected
X-KLMS-AntiSpam-Method: none
X-KLMS-AntiSpam-Auth: dkim=none
X-KLMS-AntiSpam-Info: LuaCore: 502 502 69dee8ef46717dd3cb3eeb129cb7cc8dab9e30f6, {Tracking_from_domain_doesnt_match_to}, 127.0.0.199:7.1.2;localhost.biz:7.1.1;red-soft.ru:7.1.1;d41d8cd98f00b204e9800998ecf8427e.com:7.1.1
X-MS-Exchange-Organization-SCL: -1
X-KLMS-AntiSpam-Interceptor-Info: scan successful
X-KLMS-AntiPhishing: Clean, bases: 2022/12/05 07:18:00
X-KLMS-AntiVirus: Kaspersky Security for Linux Mail Server, version 8.0.3.30, bases: 2022/12/05 09:01:00 #20651080
X-KLMS-AntiVirus-Status: Clean, skipped
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

vmci_transport_dgram_enqueue() does not check the return value
of memcpy_from_msg(). Return with an error if the memcpy fails.

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Fixes: 0f7db23a07af ("vmci_transport: switch ->enqeue_dgram, ->enqueue_stream and ->dequeue_stream to msghdr")
Signed-off-by: Artem Chernyshev <artem.chernyshev@red-soft.ru>
---
V1->V2 Fix memory leaking and updates for description
V2->V3 Return the value of memcpy_from_msg()

 net/vmw_vsock/vmci_transport.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/net/vmw_vsock/vmci_transport.c b/net/vmw_vsock/vmci_transport.c
index 842c94286d31..36eb16a40745 100644
--- a/net/vmw_vsock/vmci_transport.c
+++ b/net/vmw_vsock/vmci_transport.c
@@ -1711,7 +1711,11 @@ static int vmci_transport_dgram_enqueue(
 	if (!dg)
 		return -ENOMEM;
 
-	memcpy_from_msg(VMCI_DG_PAYLOAD(dg), msg, len);
+	err = memcpy_from_msg(VMCI_DG_PAYLOAD(dg), msg, len);
+	if (err) {
+		kfree(dg);
+		return err;
+	}
 
 	dg->dst = vmci_make_handle(remote_addr->svm_cid,
 				   remote_addr->svm_port);
-- 
2.30.3

