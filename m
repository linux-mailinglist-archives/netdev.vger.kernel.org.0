Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C950964AD4B
	for <lists+netdev@lfdr.de>; Tue, 13 Dec 2022 02:42:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234284AbiLMBms (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Dec 2022 20:42:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234309AbiLMBmm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Dec 2022 20:42:42 -0500
Received: from mail-pg1-x532.google.com (mail-pg1-x532.google.com [IPv6:2607:f8b0:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9577915713
        for <netdev@vger.kernel.org>; Mon, 12 Dec 2022 17:42:34 -0800 (PST)
Received: by mail-pg1-x532.google.com with SMTP id f9so9451511pgf.7
        for <netdev@vger.kernel.org>; Mon, 12 Dec 2022 17:42:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=yonsei-ac-kr.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=MqPeC2t0t877Nqfv/MaZjTgcanbQtZAMu3OOCrAY554=;
        b=nQ3HYZETogAXY9UyfReA6tQ+DDRSJ6TmvwoGB38GGmkZyycCAYCyYYZDY1QZUJhYF8
         aFv+3RDzzOltbQzFacFq8t60jEo93QBDPcgFUO2jlMEm0kwlCf+jGC+l8HDOkZq9g7uP
         nd6bztkEGBHZ3zr8GhALBe8kzaAg97/Vrs8iftGJPCijyZ0imFEWsS8f9dQASSr6hBTX
         YrOfRuO7YB4UsTsHO5vxlIA7hIHxMlYdbYNY5x9BH2IuRqb6P++fQ3sXbEPaRuIqa9f/
         obWWwDpWfxnw1+xyUkQbN4/ihRnsQa6jBWfBlPv55nw3OJnDfkkrctOSTcuwLlPIbBSr
         bhNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=MqPeC2t0t877Nqfv/MaZjTgcanbQtZAMu3OOCrAY554=;
        b=n0ZwsX11ni4bmcZmZsPow7vttZW9dSWxE0etFdZ6V6z8tBqmpThzimceHluwlF9vea
         fp+JgglZIJtgb+41uq+4YIHz5JrGqvqYtuIDKpp+h6IbBa888uaaObToH2NqQfMgeRgT
         wpKzqGRBZBvrYfYZgcrHI4mYgilDCuYPJdkgJMKw71jUNIIX9v33LZKWvzAUBi708wrB
         DloEA9bXzUqxpnHt/I/LYn6aqnGSvhOJSYDhlzdnRmh9RhKwtlbU6rafLd0d+sCRFnz/
         ZTNn2O9Tb7AP8XIJAa21RFfTxXp8+8xu93ouare1SwDzc+0HnupMV0NJxLn/I02TUv7G
         byfg==
X-Gm-Message-State: ANoB5pmz0Jc7Y0chk15vYxz6J4MP25TLq0l0xmwXlok0MBLB7MH6uTo4
        UFlavubpJhWYwWin32KyJpiHqw==
X-Google-Smtp-Source: AA0mqf6+mGtXv7feF8ulcUVZpZBD3eMVUACy4KP2BR/vahVt2+0Uw5Ucm8BYJJnWIoG2VnOU7z/beg==
X-Received: by 2002:aa7:814f:0:b0:566:900d:51d2 with SMTP id d15-20020aa7814f000000b00566900d51d2mr16672273pfn.1.1670895753914;
        Mon, 12 Dec 2022 17:42:33 -0800 (PST)
Received: from localhost.localdomain ([211.207.219.171])
        by smtp.gmail.com with ESMTPSA id w124-20020a628282000000b005774f19b41csm6410257pfd.88.2022.12.12.17.42.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Dec 2022 17:42:33 -0800 (PST)
From:   Minsuk Kang <linuxlovemin@yonsei.ac.kr>
To:     krzysztof.kozlowski@linaro.org, netdev@vger.kernel.org
Cc:     linma@zju.edu.cn, davem@davemloft.net, sameo@linux.intel.com,
        dokyungs@yonsei.ac.kr, jisoo.jang@yonsei.ac.kr,
        Minsuk Kang <linuxlovemin@yonsei.ac.kr>
Subject: [PATCH net] nfc: pn533: Clear nfc_target in pn533_poll_dep_complete() before being used
Date:   Tue, 13 Dec 2022 10:41:20 +0900
Message-Id: <20221213014120.969-1-linuxlovemin@yonsei.ac.kr>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch fixes a slab-out-of-bounds read in pn533 that occurs in
nla_put() called from nfc_genl_send_target() when target->sensb_res_len,
which is duplicated from nfc_target in pn533_poll_dep_complete(), is
too large as the nfc_target is not properly initialized and retains
garbage values. The patch clears the nfc_target before it is used.

Found by a modified version of syzkaller.

==================================================================
BUG: KASAN: slab-out-of-bounds in nla_put+0xe0/0x120
Read of size 94 at addr ffff888109d1dfa0 by task syz-executor/4367

CPU: 0 PID: 4367 Comm: syz-executor Not tainted 5.14.0+ #171
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.12.1-0-ga5cab58e9a3f-prebuilt.qemu.org 04/01/2014
Call Trace:
 dump_stack_lvl+0x8e/0xd1
 print_address_description.constprop.0.cold+0x93/0x334
 kasan_report.cold+0x83/0xdf
 kasan_check_range+0x14e/0x1b0
 memcpy+0x20/0x60
 nla_put+0xe0/0x120
 nfc_genl_dump_targets+0x74f/0xb20
 genl_lock_dumpit+0x65/0x90
 netlink_dump+0x4b0/0xa40
 __netlink_dump_start+0x5dc/0x8c0
 genl_family_rcv_msg_dumpit.isra.0+0x2a1/0x300
 genl_rcv_msg+0x3c8/0x4f0
 netlink_rcv_skb+0x130/0x3b0
 genl_rcv+0x29/0x40
 netlink_unicast+0x4a1/0x6a0
 netlink_sendmsg+0x788/0xc90
 sock_sendmsg+0xca/0x110
 ____sys_sendmsg+0x63f/0x780
 ___sys_sendmsg+0xfb/0x170
 __sys_sendmsg+0xd8/0x190
 do_syscall_64+0x35/0x80
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x46b55d
Code: 02 b8 ff ff ff ff c3 66 0f 1f 44 00 00 f3 0f 1e fa 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 bc ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f167a757c48 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 0000000000686b60 RCX: 000000000046b55d
RDX: 0000000000000000 RSI: 000000004004fb80 RDI: 0000000000000009
RBP: 00000000004d9ba0 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000686b60
R13: 0000000000686b68 R14: 00007ffd2f2facc0 R15: 00007f167a757dc0

Allocated by task 0:
(stack is not available)

The buggy address belongs to the object at ffff888109d1df80
 which belongs to the cache kmalloc-96 of size 96
The buggy address is located 32 bytes inside of
 96-byte region [ffff888109d1df80, ffff888109d1dfe0)
The buggy address belongs to the page:
page:ffffea0004274740 refcount:1 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x109d1d
flags: 0x200000000000200(slab|node=0|zone=2)
raw: 0200000000000200 0000000000000000 dead000000000122 ffff888100041780
raw: 0000000000000000 0000000080200020 00000001ffffffff 0000000000000000
page dumped because: kasan: bad access detected
page_owner tracks the page as allocated
page last allocated via order 0, migratetype Unmovable, gfp_mask 0x12c40(GFP_NOFS|__GFP_NOWARN|__GFP_NORETRY), pid 4366, ts 19572546791, free_ts 19568585127
 prep_new_page+0x1aa/0x240
 get_page_from_freelist+0x159a/0x27c0
 __alloc_pages+0x2da/0x6a0
 alloc_pages+0xec/0x1e0
 allocate_slab+0x380/0x4e0
 ___slab_alloc+0x5bc/0x940
 __slab_alloc+0x6d/0x80
 __kmalloc+0x329/0x390
 tomoyo_supervisor+0xb7f/0xd10
 tomoyo_path_permission+0x26a/0x3a0
 tomoyo_check_open_permission+0x2b0/0x310
 tomoyo_file_open+0x99/0xc0
 security_file_open+0x57/0x470
 do_dentry_open+0x318/0xfe0
 path_openat+0x1852/0x2310
 do_filp_open+0x1c6/0x290
page last free stack trace:
 free_pcp_prepare+0x3d3/0x7f0
 free_unref_page+0x1e/0x3d0
 unfreeze_partials.isra.0+0x211/0x2f0
 put_cpu_partial+0x66/0x160
 qlist_free_all+0x5a/0xc0
 kasan_quarantine_reduce+0x13d/0x180
 __kasan_slab_alloc+0x73/0x80
 slab_post_alloc_hook+0x4d/0x490
 __kmalloc+0x180/0x390
 tomoyo_supervisor+0xb7f/0xd10
 tomoyo_path_permission+0x26a/0x3a0
 tomoyo_path_perm+0x2c1/0x3c0
 security_inode_getattr+0xc2/0x130
 vfs_getattr+0x27/0x60
 vfs_fstat+0x3e/0x80
 __do_sys_newfstat+0x7d/0xf0

Memory state around the buggy address:
 ffff888109d1de80: fa fb fb fb fb fb fb fb fb fb fb fb fc fc fc fc
 ffff888109d1df00: 00 00 00 00 00 00 00 00 00 00 00 00 fc fc fc fc
>ffff888109d1df80: 00 00 00 00 00 00 00 00 00 00 00 00 fc fc fc fc
                                                       ^
 ffff888109d1e000: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
 ffff888109d1e080: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
==================================================================

Fixes: 673088fb42d0 ("NFC: pn533: Send ATR_REQ directly for active device detection")
Reported-by: Dokyung Song <dokyungs@yonsei.ac.kr>
Reported-by: Jisoo Jang <jisoo.jang@yonsei.ac.kr>
Reported-by: Minsuk Kang <linuxlovemin@yonsei.ac.kr>
Signed-off-by: Minsuk Kang <linuxlovemin@yonsei.ac.kr>
---
 drivers/nfc/pn533/pn533.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/nfc/pn533/pn533.c b/drivers/nfc/pn533/pn533.c
index d9f6367b9993..c6a611622668 100644
--- a/drivers/nfc/pn533/pn533.c
+++ b/drivers/nfc/pn533/pn533.c
@@ -1295,6 +1295,8 @@ static int pn533_poll_dep_complete(struct pn533 *dev, void *arg,
 	if (IS_ERR(resp))
 		return PTR_ERR(resp);

+	memset(&nfc_target, 0, sizeof(struct nfc_target));
+
 	rsp = (struct pn533_cmd_jump_dep_response *)resp->data;

 	rc = rsp->status & PN533_CMD_RET_MASK;
--
2.25.1

