Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CB966596012
	for <lists+netdev@lfdr.de>; Tue, 16 Aug 2022 18:23:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236138AbiHPQWo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Aug 2022 12:22:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236102AbiHPQWm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Aug 2022 12:22:42 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6567478BEB
        for <netdev@vger.kernel.org>; Tue, 16 Aug 2022 09:22:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1660666960;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=4DAtuJXwJxNFl0h5f041851ZUlBg+KLhg+1Meihp510=;
        b=BbLxY1a6H1DvUszEuLlF6/99CAvxsL38I3olRnbLWWpExpWkx/VyffpcT1X+yu1mo+/TVV
        f3pUhoQHHurW1UQW7GoUf7zNYG1CykPARyFvycmVgJByZ/kVc6fSRFMnAR3f4x+KK+zYYV
        8JlAcucrh0yo5v7lxygkW6uzQtaYm28=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-224-rbAWc-cgOSWzhDIFudp8oA-1; Tue, 16 Aug 2022 12:22:35 -0400
X-MC-Unique: rbAWc-cgOSWzhDIFudp8oA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id ABCD01C06ECB;
        Tue, 16 Aug 2022 16:22:33 +0000 (UTC)
Received: from p1.luc.cera.cz (unknown [10.40.192.152])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 971BF945D9;
        Tue, 16 Aug 2022 16:22:31 +0000 (UTC)
From:   Ivan Vecera <ivecera@redhat.com>
To:     netdev@vger.kernel.org
Cc:     Patryk Piotrowski <patryk.piotrowski@intel.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Mitch Williams <mitch.a.williams@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Jacob Keller <jacob.e.keller@intel.com>,
        intel-wired-lan@lists.osuosl.org (moderated list:INTEL ETHERNET DRIVERS),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH net] i40e: Fix kernel crash during module removal
Date:   Tue, 16 Aug 2022 18:22:30 +0200
Message-Id: <20220816162230.3486915-1-ivecera@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The driver incorrectly frees client instance and subsequent
i40e module removal leads to kernel crash.

Reproducer:
1. Do ethtool offline test followed immediately by another one
host# ethtool -t eth0 offline; ethtool -t eth0 offline
2. Remove recursively irdma module that also removes i40e module
host# modprobe -r irdma

Result:
[ 8675.035651] i40e 0000:3d:00.0 eno1: offline testing starting
[ 8675.193774] i40e 0000:3d:00.0 eno1: testing finished
[ 8675.201316] i40e 0000:3d:00.0 eno1: offline testing starting
[ 8675.358921] i40e 0000:3d:00.0 eno1: testing finished
[ 8675.496921] i40e 0000:3d:00.0: IRDMA hardware initialization FAILED init_state=2 status=-110
[ 8686.188955] i40e 0000:3d:00.1: i40e_ptp_stop: removed PHC on eno2
[ 8686.943890] i40e 0000:3d:00.1: Deleted LAN device PF1 bus=0x3d dev=0x00 func=0x01
[ 8686.952669] i40e 0000:3d:00.0: i40e_ptp_stop: removed PHC on eno1
[ 8687.761787] BUG: kernel NULL pointer dereference, address: 0000000000000030
[ 8687.768755] #PF: supervisor read access in kernel mode
[ 8687.773895] #PF: error_code(0x0000) - not-present page
[ 8687.779034] PGD 0 P4D 0
[ 8687.781575] Oops: 0000 [#1] PREEMPT SMP NOPTI
[ 8687.785935] CPU: 51 PID: 172891 Comm: rmmod Kdump: loaded Tainted: G        W I        5.19.0+ #2
[ 8687.794800] Hardware name: Intel Corporation S2600WFD/S2600WFD, BIOS SE5C620.86B.0X.02.0001.051420190324 05/14/2019
[ 8687.805222] RIP: 0010:i40e_lan_del_device+0x13/0xb0 [i40e]
[ 8687.810719] Code: d4 84 c0 0f 84 b8 25 01 00 e9 9c 25 01 00 41 bc f4 ff ff ff eb 91 90 0f 1f 44 00 00 41 54 55 53 48 8b 87 58 08 00 00 48 89 fb <48> 8b 68 30 48 89 ef e8 21 8a 0f d5 48 89 ef e8 a9 78 0f d5 48 8b
[ 8687.829462] RSP: 0018:ffffa604072efce0 EFLAGS: 00010202
[ 8687.834689] RAX: 0000000000000000 RBX: ffff8f43833b2000 RCX: 0000000000000000
[ 8687.841821] RDX: 0000000000000000 RSI: ffff8f4b0545b298 RDI: ffff8f43833b2000
[ 8687.848955] RBP: ffff8f43833b2000 R08: 0000000000000001 R09: 0000000000000000
[ 8687.856086] R10: 0000000000000000 R11: 000ffffffffff000 R12: ffff8f43833b2ef0
[ 8687.863218] R13: ffff8f43833b2ef0 R14: ffff915103966000 R15: ffff8f43833b2008
[ 8687.870342] FS:  00007f79501c3740(0000) GS:ffff8f4adffc0000(0000) knlGS:0000000000000000
[ 8687.878427] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 8687.884174] CR2: 0000000000000030 CR3: 000000014276e004 CR4: 00000000007706e0
[ 8687.891306] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[ 8687.898441] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
[ 8687.905572] PKRU: 55555554
[ 8687.908286] Call Trace:
[ 8687.910737]  <TASK>
[ 8687.912843]  i40e_remove+0x2c0/0x330 [i40e]
[ 8687.917040]  pci_device_remove+0x33/0xa0
[ 8687.920962]  device_release_driver_internal+0x1aa/0x230
[ 8687.926188]  driver_detach+0x44/0x90
[ 8687.929770]  bus_remove_driver+0x55/0xe0
[ 8687.933693]  pci_unregister_driver+0x2a/0xb0
[ 8687.937967]  i40e_exit_module+0xc/0xf48 [i40e]

Two offline tests cause IRDMA driver failure (ETIMEDOUT) and this
failure is indicated back to i40e_client_subtask() that calls
i40e_client_del_instance() to free client instance referenced
by pf->cinst and sets this pointer to NULL. During the module
removal i40e_remove() calls i40e_lan_del_device() that dereferences
pf->cinst that is NULL -> crash.
Do not remove client instance when client open callbacks fails and
just clear __I40E_CLIENT_INSTANCE_OPENED bit. The driver also needs
to take care about this situation (when netdev is up and client
is NOT opened) in i40e_notify_client_of_netdev_close() and
calls client close callback only when __I40E_CLIENT_INSTANCE_OPENED
is set.

Fixes: 0ef2d5afb12d ("i40e: KISS the client interface")
Signed-off-by: Ivan Vecera <ivecera@redhat.com>
---
 drivers/net/ethernet/intel/i40e/i40e_client.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_client.c b/drivers/net/ethernet/intel/i40e/i40e_client.c
index ea2bb0140a6e..10d7a982a5b9 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_client.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_client.c
@@ -177,6 +177,10 @@ void i40e_notify_client_of_netdev_close(struct i40e_vsi *vsi, bool reset)
 			"Cannot locate client instance close routine\n");
 		return;
 	}
+	if (!test_bit(__I40E_CLIENT_INSTANCE_OPENED, &cdev->state)) {
+		dev_dbg(&pf->pdev->dev, "Client is not open, abort close\n");
+		return;
+	}
 	cdev->client->ops->close(&cdev->lan_info, cdev->client, reset);
 	clear_bit(__I40E_CLIENT_INSTANCE_OPENED, &cdev->state);
 	i40e_client_release_qvlist(&cdev->lan_info);
@@ -429,7 +433,6 @@ void i40e_client_subtask(struct i40e_pf *pf)
 				/* Remove failed client instance */
 				clear_bit(__I40E_CLIENT_INSTANCE_OPENED,
 					  &cdev->state);
-				i40e_client_del_instance(pf);
 				return;
 			}
 		}
-- 
2.35.1

