Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6A8674EF63D
	for <lists+netdev@lfdr.de>; Fri,  1 Apr 2022 17:53:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346030AbiDAPbx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Apr 2022 11:31:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350728AbiDAPA1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Apr 2022 11:00:27 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 822E93BA4F;
        Fri,  1 Apr 2022 07:49:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 42E7BB8250F;
        Fri,  1 Apr 2022 14:49:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A61DC34114;
        Fri,  1 Apr 2022 14:49:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648824542;
        bh=rIvHxtySldOSeWF+66j94P3hjlzOzagHJheeXYZ9Y2M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tgSH7m1ldijPb+q5NCwn8ca4Fx07Z486aaaVxvFMPWc6v9/7DDMYCObhWL70P66MQ
         NzPPk2Ezz6d3xphelsD/y7PWhDZoDJfFtem/V7YCl5L8lKdk3/9E+KJ9qUQWc6zU2k
         kjvvjaPO9j4XEg6vLwhcQyScFidZD1EtIVuppq5Xs2H6uj6nqEJzqP068cyeC4CFKI
         VwtgYHEaidMeQxBlVTwgL9tKn1q774dx1VfhhJl6vXVdvhfYfTAYoFRwtiIVCBA7qv
         tksZMjj19PRI+e5Oe+b7dxhOGuG1H+BddLLb1va4EZbSgv2i1ns1CODhF2UF2boS2c
         bFtN7MjDcFU1g==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
        =?UTF-8?q?S=C3=B6nke=20Huster?= <soenke.huster@eknoes.de>,
        Marcel Holtmann <marcel@holtmann.org>,
        Sasha Levin <sashal@kernel.org>, johan.hedberg@gmail.com,
        luiz.dentz@gmail.com, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, linux-bluetooth@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 15/16] Bluetooth: Fix use after free in hci_send_acl
Date:   Fri,  1 Apr 2022 10:48:26 -0400
Message-Id: <20220401144827.1955845-15-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220401144827.1955845-1-sashal@kernel.org>
References: <20220401144827.1955845-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

[ Upstream commit f63d24baff787e13b723d86fe036f84bdbc35045 ]

This fixes the following trace caused by receiving
HCI_EV_DISCONN_PHY_LINK_COMPLETE which does call hci_conn_del without
first checking if conn->type is in fact AMP_LINK and in case it is
do properly cleanup upper layers with hci_disconn_cfm:

 ==================================================================
    BUG: KASAN: use-after-free in hci_send_acl+0xaba/0xc50
    Read of size 8 at addr ffff88800e404818 by task bluetoothd/142

    CPU: 0 PID: 142 Comm: bluetoothd Not tainted
    5.17.0-rc5-00006-gda4022eeac1a #7
    Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS
    rel-1.14.0-0-g155821a1990b-prebuilt.qemu.org 04/01/2014
    Call Trace:
     <TASK>
     dump_stack_lvl+0x45/0x59
     print_address_description.constprop.0+0x1f/0x150
     kasan_report.cold+0x7f/0x11b
     hci_send_acl+0xaba/0xc50
     l2cap_do_send+0x23f/0x3d0
     l2cap_chan_send+0xc06/0x2cc0
     l2cap_sock_sendmsg+0x201/0x2b0
     sock_sendmsg+0xdc/0x110
     sock_write_iter+0x20f/0x370
     do_iter_readv_writev+0x343/0x690
     do_iter_write+0x132/0x640
     vfs_writev+0x198/0x570
     do_writev+0x202/0x280
     do_syscall_64+0x38/0x90
     entry_SYSCALL_64_after_hwframe+0x44/0xae
    RSP: 002b:00007ffce8a099b8 EFLAGS: 00000246 ORIG_RAX: 0000000000000014
    Code: 0f 00 f7 d8 64 89 02 48 c7 c0 ff ff ff ff eb b8 0f 1f 00 f3
    0f 1e fa 64 8b 04 25 18 00 00 00 85 c0 75 10 b8 14 00 00 00 0f 05
    <48> 3d 00 f0 ff ff 77 51 c3 48 83 ec 28 89 54 24 1c 48 89 74 24 10
    RDX: 0000000000000001 RSI: 00007ffce8a099e0 RDI: 0000000000000015
    RAX: ffffffffffffffda RBX: 00007ffce8a099e0 RCX: 00007f788fc3cf77
    R10: 00007ffce8af7080 R11: 0000000000000246 R12: 000055e4ccf75580
    RBP: 0000000000000015 R08: 0000000000000002 R09: 0000000000000001
    </TASK>
    R13: 000055e4ccf754a0 R14: 000055e4ccf75cd0 R15: 000055e4ccf4a6b0

    Allocated by task 45:
        kasan_save_stack+0x1e/0x40
        __kasan_kmalloc+0x81/0xa0
        hci_chan_create+0x9a/0x2f0
        l2cap_conn_add.part.0+0x1a/0xdc0
        l2cap_connect_cfm+0x236/0x1000
        le_conn_complete_evt+0x15a7/0x1db0
        hci_le_conn_complete_evt+0x226/0x2c0
        hci_le_meta_evt+0x247/0x450
        hci_event_packet+0x61b/0xe90
        hci_rx_work+0x4d5/0xc50
        process_one_work+0x8fb/0x15a0
        worker_thread+0x576/0x1240
        kthread+0x29d/0x340
        ret_from_fork+0x1f/0x30

    Freed by task 45:
        kasan_save_stack+0x1e/0x40
        kasan_set_track+0x21/0x30
        kasan_set_free_info+0x20/0x30
        __kasan_slab_free+0xfb/0x130
        kfree+0xac/0x350
        hci_conn_cleanup+0x101/0x6a0
        hci_conn_del+0x27e/0x6c0
        hci_disconn_phylink_complete_evt+0xe0/0x120
        hci_event_packet+0x812/0xe90
        hci_rx_work+0x4d5/0xc50
        process_one_work+0x8fb/0x15a0
        worker_thread+0x576/0x1240
        kthread+0x29d/0x340
        ret_from_fork+0x1f/0x30

    The buggy address belongs to the object at ffff88800c0f0500
    The buggy address is located 24 bytes inside of
    which belongs to the cache kmalloc-128 of size 128
    The buggy address belongs to the page:
    128-byte region [ffff88800c0f0500, ffff88800c0f0580)
    flags: 0x100000000000200(slab|node=0|zone=1)
    page:00000000fe45cd86 refcount:1 mapcount:0
    mapping:0000000000000000 index:0x0 pfn:0xc0f0
    raw: 0000000000000000 0000000080100010 00000001ffffffff
    0000000000000000
    raw: 0100000000000200 ffffea00003a2c80 dead000000000004
    ffff8880078418c0
    page dumped because: kasan: bad access detected
    ffff88800c0f0400: 00 00 00 00 00 00 00 00 00 00 00 00 00 fc fc fc
    Memory state around the buggy address:
    >ffff88800c0f0500: fa fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
    ffff88800c0f0480: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
    ffff88800c0f0580: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
                                ^
    ==================================================================
    ffff88800c0f0600: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb

Reported-by: Sönke Huster <soenke.huster@eknoes.de>
Tested-by: Sönke Huster <soenke.huster@eknoes.de>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Marcel Holtmann <marcel@holtmann.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/hci_event.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/bluetooth/hci_event.c b/net/bluetooth/hci_event.c
index cff87c465bcb..8face15b42d8 100644
--- a/net/bluetooth/hci_event.c
+++ b/net/bluetooth/hci_event.c
@@ -4470,8 +4470,9 @@ static void hci_disconn_phylink_complete_evt(struct hci_dev *hdev,
 	hci_dev_lock(hdev);
 
 	hcon = hci_conn_hash_lookup_handle(hdev, ev->phy_handle);
-	if (hcon) {
+	if (hcon && hcon->type == AMP_LINK) {
 		hcon->state = BT_CLOSED;
+		hci_disconn_cfm(hcon, ev->reason);
 		hci_conn_del(hcon);
 	}
 
-- 
2.34.1

