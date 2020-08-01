Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F5122350DF
	for <lists+netdev@lfdr.de>; Sat,  1 Aug 2020 09:08:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728103AbgHAHIB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 1 Aug 2020 03:08:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725275AbgHAHIA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 1 Aug 2020 03:08:00 -0400
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62153C06174A
        for <netdev@vger.kernel.org>; Sat,  1 Aug 2020 00:08:00 -0700 (PDT)
Received: by mail-pg1-x541.google.com with SMTP id h12so5793325pgf.7
        for <netdev@vger.kernel.org>; Sat, 01 Aug 2020 00:08:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=Cn2UI312fiYX6zSoChqgK+mTON6P1wJq2sFmk4xDT5Q=;
        b=HbU2M5ZyeKSlmx+avK9x6U6wZs2pCzFAQYMHAvYSOWoFKcbigXBzqmcqLNjXIBMvWj
         9DeGLR6OEk3OZXoprp3qs+PIbFvoRYNyosAr5a9H2XAA4kZWMtcFRSRQXd36XKHjZdNW
         HfueFSwkIlS+Onr2+FmfQZIrv171vfyMOuVWrdmOUhmSgSQ5OSJO/69O8jeokdwxu955
         Gjn1YrON1GobtBeChjR8h9hprgJiegudNGUumzvoLE/mHMXJ4li2ut5EB5C/UIyuHKWV
         4Q1r06ln4q/nqtdA0XDWoKdaI4Zlvg7GiBseZjnnEuU9B3jRnmACh72IHmBUabp6DvBT
         AQ3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=Cn2UI312fiYX6zSoChqgK+mTON6P1wJq2sFmk4xDT5Q=;
        b=UU+oawKcj5FQ+Kvu94TprwmedQ3CwcU2M633Gd4kKINGJiNnreaIaX4+QeQBkvcfey
         Fk1p5fBJ2Eeq3QPui3jdvr9Cgod0o3inXFFZUg471IvgYytnq5nx8Pq71SqXNwCEScep
         /t7PUwfdyd6KiS175XglbPlQqdZh2PiAU/vHhcdbbdB06xnk/kTbDTiswSztpj/0tr0o
         BFkx9sheTKp6n/0RhjyxKrXiSidto7djkdKTLJ4xYdX6MESw0dJOoiEK3wRcBz7d3Fq6
         VzO7YAoruDLqL84Lngw71mg0xSxrYjPGPxg9B6hQuOgjejE+ejcLgYr7bUSkEkOyi5ct
         WTpQ==
X-Gm-Message-State: AOAM5306naS2rsWFOAYZIY7KH3J4kiB/eQhHYz7amafZ+u1OOX50n6VM
        jiKTZdA9WxTtddZuJwBh0qA=
X-Google-Smtp-Source: ABdhPJy7IGamvHHpjHTFmYvvC4wS3/SxwSqG/RwRLW3aCWt5PjXzKJwVVJxAIwU6gZeNN9kRktDKjQ==
X-Received: by 2002:a63:df03:: with SMTP id u3mr6602567pgg.84.1596265679737;
        Sat, 01 Aug 2020 00:07:59 -0700 (PDT)
Received: from localhost.localdomain ([180.70.143.152])
        by smtp.gmail.com with ESMTPSA id mj6sm11171926pjb.15.2020.08.01.00.07.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 01 Aug 2020 00:07:58 -0700 (PDT)
From:   Taehee Yoo <ap420073@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Cc:     roopa@cumulusnetworks.com, ap420073@gmail.com
Subject: [PATCH net] vxlan: fix memleak of fdb
Date:   Sat,  1 Aug 2020 07:07:50 +0000
Message-Id: <20200801070750.7993-1-ap420073@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When vxlan interface is deleted, all fdbs are deleted by vxlan_flush().
vxlan_flush() flushes fdbs but it doesn't delete fdb, which contains
all-zeros-mac because it is deleted by vxlan_uninit().
But vxlan_uninit() deletes only the fdb, which contains both all-zeros-mac
and default vni.
So, the fdb, which contains both all-zeros-mac and non-default vni
will not be deleted.

Test commands:
    ip link add vxlan0 type vxlan dstport 4789 external
    ip link set vxlan0 up
    bridge fdb add to 00:00:00:00:00:00 dst 172.0.0.1 dev vxlan0 via lo \
	    src_vni 10000 self permanent
    ip link del vxlan0

kmemleak reports as follows:
unreferenced object 0xffff9486b25ced88 (size 96):
  comm "bridge", pid 2151, jiffies 4294701712 (age 35506.901s)
  hex dump (first 32 bytes):
    02 00 00 00 ac 00 00 01 40 00 09 b1 86 94 ff ff  ........@.......
    46 02 00 00 00 00 00 00 a7 03 00 00 12 b5 6a 6b  F.............jk
  backtrace:
    [<00000000c10cf651>] vxlan_fdb_append.part.51+0x3c/0xf0 [vxlan]
    [<000000006b31a8d9>] vxlan_fdb_create+0x184/0x1a0 [vxlan]
    [<0000000049399045>] vxlan_fdb_update+0x12f/0x220 [vxlan]
    [<0000000090b1ef00>] vxlan_fdb_add+0x12a/0x1b0 [vxlan]
    [<0000000056633c2c>] rtnl_fdb_add+0x187/0x270
    [<00000000dd5dfb6b>] rtnetlink_rcv_msg+0x264/0x490
    [<00000000fc44dd54>] netlink_rcv_skb+0x4a/0x110
    [<00000000dff433e7>] netlink_unicast+0x18e/0x250
    [<00000000b87fb421>] netlink_sendmsg+0x2e9/0x400
    [<000000002ed55153>] ____sys_sendmsg+0x237/0x260
    [<00000000faa51c66>] ___sys_sendmsg+0x88/0xd0
    [<000000006c3982f1>] __sys_sendmsg+0x4e/0x80
    [<00000000a8f875d2>] do_syscall_64+0x56/0xe0
    [<000000003610eefa>] entry_SYSCALL_64_after_hwframe+0x44/0xa9
unreferenced object 0xffff9486b1c40080 (size 128):
  comm "bridge", pid 2157, jiffies 4294701754 (age 35506.866s)
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 f8 dc 42 b2 86 94 ff ff  ..........B.....
    6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
  backtrace:
    [<00000000a2981b60>] vxlan_fdb_create+0x67/0x1a0 [vxlan]
    [<0000000049399045>] vxlan_fdb_update+0x12f/0x220 [vxlan]
    [<0000000090b1ef00>] vxlan_fdb_add+0x12a/0x1b0 [vxlan]
    [<0000000056633c2c>] rtnl_fdb_add+0x187/0x270
    [<00000000dd5dfb6b>] rtnetlink_rcv_msg+0x264/0x490
    [<00000000fc44dd54>] netlink_rcv_skb+0x4a/0x110
    [<00000000dff433e7>] netlink_unicast+0x18e/0x250
    [<00000000b87fb421>] netlink_sendmsg+0x2e9/0x400
    [<000000002ed55153>] ____sys_sendmsg+0x237/0x260
    [<00000000faa51c66>] ___sys_sendmsg+0x88/0xd0
    [<000000006c3982f1>] __sys_sendmsg+0x4e/0x80
    [<00000000a8f875d2>] do_syscall_64+0x56/0xe0
    [<000000003610eefa>] entry_SYSCALL_64_after_hwframe+0x44/0xa9

Fixes: 3ad7a4b141eb ("vxlan: support fdb and learning in COLLECT_METADATA mode")
Signed-off-by: Taehee Yoo <ap420073@gmail.com>
---
 drivers/net/vxlan.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/vxlan.c b/drivers/net/vxlan.c
index 5efe1e28f270..a7c3939264b0 100644
--- a/drivers/net/vxlan.c
+++ b/drivers/net/vxlan.c
@@ -3076,8 +3076,10 @@ static void vxlan_flush(struct vxlan_dev *vxlan, bool do_all)
 			if (!do_all && (f->state & (NUD_PERMANENT | NUD_NOARP)))
 				continue;
 			/* the all_zeros_mac entry is deleted at vxlan_uninit */
-			if (!is_zero_ether_addr(f->eth_addr))
-				vxlan_fdb_destroy(vxlan, f, true, true);
+			if (is_zero_ether_addr(f->eth_addr) &&
+			    f->vni == vxlan->cfg.vni)
+				continue;
+			vxlan_fdb_destroy(vxlan, f, true, true);
 		}
 		spin_unlock_bh(&vxlan->hash_lock[h]);
 	}
-- 
2.17.1

