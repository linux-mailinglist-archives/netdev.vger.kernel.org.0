Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4E76F4ECD7D
	for <lists+netdev@lfdr.de>; Wed, 30 Mar 2022 21:47:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230407AbiC3Tse (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Mar 2022 15:48:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230379AbiC3Tsd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Mar 2022 15:48:33 -0400
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 461AB49F1E
        for <netdev@vger.kernel.org>; Wed, 30 Mar 2022 12:46:48 -0700 (PDT)
Received: by mail-pf1-x436.google.com with SMTP id w7so17082712pfu.11
        for <netdev@vger.kernel.org>; Wed, 30 Mar 2022 12:46:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=9oNPqzSJlTVFGUAf0xlf3A7Vhhnbt51vMN/ORAdSjEU=;
        b=cNK5ttBlNs03e4VVEMHozz0MCjkGeiMcTOZ8RmteN2H7tLkyFvVsziI8Gvc8RKDsDG
         lDvSRHxZf1XjCv1GXk2sFUwSBEhIIEMOF28/Z6ppWC9wED/aClq5/5rAu2lSOf1ttebO
         s0h3pj8CfA/c1E9TsMSxNk6NV1GiLVgwEMciGk4EnqKub+KIqw7dfQ1cDckeiBa+otNo
         FlgYNMyR1dE8x6WzKx6IK66ByGTgmMPIBVXumLUbm+KdZ71A0weKBhUzkKJ7kzzEeJ97
         ei1GkPYIZpOVwuqORtMkdU/a9ypBKBfB33BEd4V6DAR8xk6LbbxLss+ZbE77yNMN0pa/
         LQ0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=9oNPqzSJlTVFGUAf0xlf3A7Vhhnbt51vMN/ORAdSjEU=;
        b=cV7oHM7TE/X8ou4kqLNQU/c/o1awriuPc1tse0O8szd9T5KmeRiCrxogTmZhACOzRz
         0bCw+/wpj6WhKfRwUe7dh8kL9DExV3LYArw9LTJzaaPTQZ/YwWQcP4JLJmXf+ljjAugq
         ZyviSpq+ABgU7itOiq1fG4SC6HBIKcdQYG5+9+2JUI4YJB+UQaqSLfTLYS6VoKI2BBJS
         flgOjWBQxjJYdUEkI4tXZaI0JN5nD6UVPTrhDmp+IVWckuQ77yOUX+NkcbwWseXmz+04
         Fr6l2wr3V4T1N24yo/OqxIzPXutph7TwoASYi3FOsKERHGcOM/DN+4o53g6ZaEsKeq2V
         9aEw==
X-Gm-Message-State: AOAM532ti2mPGn2XcZOncnypV59zPCeUqzRZZP97sFBJ6GazxyiYGwpm
        J5Ti8FwwbHWX2gXspnRDndM=
X-Google-Smtp-Source: ABdhPJzZ3RmvdxnL1xD95WCQs9cAbeSosygVWm4UmTVnLVOq4UuP8+62BtseYQcj0tI/LkMzqXLbBg==
X-Received: by 2002:a05:6a00:2148:b0:4fa:92f2:bae3 with SMTP id o8-20020a056a00214800b004fa92f2bae3mr1071085pfk.69.1648669607621;
        Wed, 30 Mar 2022 12:46:47 -0700 (PDT)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:e48a:4a29:56a5:672a])
        by smtp.gmail.com with ESMTPSA id p128-20020a625b86000000b004fa666a1327sm23779700pfb.102.2022.03.30.12.46.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Mar 2022 12:46:47 -0700 (PDT)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        syzbot <syzkaller@googlegroups.com>
Subject: [PATCH net] vxlan: do not feed vxlan_vnifilter_dump_dev with non vxlan devices
Date:   Wed, 30 Mar 2022 12:46:43 -0700
Message-Id: <20220330194643.2706132-1-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.35.1.1021.g381101b075-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

vxlan_vnifilter_dump_dev() assumes it is called only
for vxlan devices. Make sure it is the case.

BUG: KASAN: slab-out-of-bounds in vxlan_vnifilter_dump_dev+0x9a0/0xb40 drivers/net/vxlan/vxlan_vnifilter.c:349
Read of size 4 at addr ffff888060d1ce70 by task syz-executor.3/17662

CPU: 0 PID: 17662 Comm: syz-executor.3 Tainted: G        W         5.17.0-syzkaller-12888-g77c9387c0c5b #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:88 [inline]
 dump_stack_lvl+0xcd/0x134 lib/dump_stack.c:106
 print_address_description.constprop.0.cold+0xeb/0x495 mm/kasan/report.c:313
 print_report mm/kasan/report.c:429 [inline]
 kasan_report.cold+0xf4/0x1c6 mm/kasan/report.c:491
 vxlan_vnifilter_dump_dev+0x9a0/0xb40 drivers/net/vxlan/vxlan_vnifilter.c:349
 vxlan_vnifilter_dump+0x3ff/0x650 drivers/net/vxlan/vxlan_vnifilter.c:428
 netlink_dump+0x4b5/0xb70 net/netlink/af_netlink.c:2270
 __netlink_dump_start+0x647/0x900 net/netlink/af_netlink.c:2375
 netlink_dump_start include/linux/netlink.h:245 [inline]
 rtnetlink_rcv_msg+0x70c/0xb80 net/core/rtnetlink.c:5953
 netlink_rcv_skb+0x153/0x420 net/netlink/af_netlink.c:2496
 netlink_unicast_kernel net/netlink/af_netlink.c:1319 [inline]
 netlink_unicast+0x543/0x7f0 net/netlink/af_netlink.c:1345
 netlink_sendmsg+0x904/0xe00 net/netlink/af_netlink.c:1921
 sock_sendmsg_nosec net/socket.c:705 [inline]
 sock_sendmsg+0xcf/0x120 net/socket.c:725
 ____sys_sendmsg+0x6e2/0x800 net/socket.c:2413
 ___sys_sendmsg+0xf3/0x170 net/socket.c:2467
 __sys_sendmsg+0xe5/0x1b0 net/socket.c:2496
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0x80 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x7f87b8e89049

Fixes: f9c4bb0b245c ("vxlan: vni filtering support on collect metadata device")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Roopa Prabhu <roopa@nvidia.com>
Reported-by: syzbot <syzkaller@googlegroups.com>
---
 drivers/net/vxlan/vxlan_vnifilter.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/vxlan/vxlan_vnifilter.c b/drivers/net/vxlan/vxlan_vnifilter.c
index 9f28d0b6a6b26690fec5379956d75b988ea07a36..3e04af4c5daa10f5bebf68f7b33876fe9b09fea9 100644
--- a/drivers/net/vxlan/vxlan_vnifilter.c
+++ b/drivers/net/vxlan/vxlan_vnifilter.c
@@ -425,6 +425,12 @@ static int vxlan_vnifilter_dump(struct sk_buff *skb, struct netlink_callback *cb
 			err = -ENODEV;
 			goto out_err;
 		}
+		if (!netif_is_vxlan(dev)) {
+			NL_SET_ERR_MSG(cb->extack,
+				       "The device is not a vxlan device");
+			err = -EINVAL;
+			goto out_err;
+		}
 		err = vxlan_vnifilter_dump_dev(dev, skb, cb);
 		/* if the dump completed without an error we return 0 here */
 		if (err != -EMSGSIZE)
-- 
2.35.1.1021.g381101b075-goog

