Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9B4BB6D6A3D
	for <lists+netdev@lfdr.de>; Tue,  4 Apr 2023 19:17:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235898AbjDDRRN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Apr 2023 13:17:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235892AbjDDRRG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Apr 2023 13:17:06 -0400
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F3A730E3
        for <netdev@vger.kernel.org>; Tue,  4 Apr 2023 10:17:04 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-54629ed836aso192856137b3.10
        for <netdev@vger.kernel.org>; Tue, 04 Apr 2023 10:17:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1680628623;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=kTP1H6pT1R6LxnC9sdVUFmPmb5TyA1Ai2Mhqa/v/wJ8=;
        b=mHCXeuEwZwwypex1JYLLx5FlBEFAWgmsZSCojXTjwGaUQPozUcQpRwmhKVq+wMNJWm
         UPRtpkLQFsvd9c25KMcOu7N2tz7j1k9RQpFyIEgX3q4+qXz8PXzZEUfiT6+/cmWgUt0m
         AZ3m4IcNaD/OULIVts/50OBNObNOPeTd8Cn+L7/zuDraUMcYFvJteEQN56CdmL9J5aPX
         zGerUA/QG8E+QrVw9e9WUgfl60JvyQsJuPtSGQTZMtap21qvayqU605GgGUFQlJhZW+3
         M+/Q6C6SHBxDakB0mzNSCjyjWf+IlvE1BTLxQfSRKcx7hf+qRqNlRmvEDgg50aaap/ob
         JOAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680628623;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=kTP1H6pT1R6LxnC9sdVUFmPmb5TyA1Ai2Mhqa/v/wJ8=;
        b=er8jnb/zRMeaFiWLn9qArndke5Kci0RgFMiC1SRo9f2nHWBAu6/wXDsMDn41NUD93p
         f0eFzkZzlPk4deoKdGehzsyAewAtQl7UEKgKGK+LFen7v08aSWHs9tC+4V0lm8kiua7j
         OQVlojJbeRmFz7MVBvO0wvW73u9Vc3UKvy/Oygp3jsNTf+RecrsfdWulWP1Bbi+iQ7m5
         y3SR4HYW9Hc/iKyiuGx9W8DXLtF8tcWYVKodWFRgxGOjsGIFdlU48/EzrHNS4C9YTU0l
         pplv9J6pivim75PZaA3RvbgYzwvAl4UylGyNGUSFQ4GXpUEvJp4t4HJi1zvOG1uuAiqV
         JC3w==
X-Gm-Message-State: AAQBX9dosCOx4YoaWosO4IWz7cJ4ZOCKt++6ArvmEtGCh4C87GziHJze
        qL6ZnGpo5DuIwA2ucFM7mC+Qf6/DAibb3g==
X-Google-Smtp-Source: AKy350bBCoRayxVb9jnnGZIIgdnI42aL3e8mBBEA+1IpcRuy2pZm2cV8yT0LUvRF4uU0l4QbaBUDAF+rFU3UqA==
X-Received: from edumazet1.c.googlers.com ([fda3:e722:ac3:cc00:2b:7d90:c0a8:395a])
 (user=edumazet job=sendgmr) by 2002:a25:da02:0:b0:b75:968e:f282 with SMTP id
 n2-20020a25da02000000b00b75968ef282mr2269935ybf.11.1680628623682; Tue, 04 Apr
 2023 10:17:03 -0700 (PDT)
Date:   Tue,  4 Apr 2023 17:16:58 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.40.0.348.gf938b09366-goog
Message-ID: <20230404171658.917361-1-edumazet@google.com>
Subject: [PATCH v2 net-next] mac80211_hwsim: fix potential NULL deref in hwsim_pmsr_report_nl()
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Johannes Berg <johannes@sipsolutions.net>
Cc:     linux-wireless@vger.kernel.org,
        Simon Horman <simon.horman@corigine.com>,
        netdev@vger.kernel.org, eric.dumazet@gmail.com,
        Eric Dumazet <edumazet@google.com>,
        syzbot <syzkaller@googlegroups.com>,
        Jaewan Kim <jaewan@google.com>,
        Johannes Berg <johannes.berg@intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-7.7 required=5.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot reported a NULL dereference caused by a missing check
in hwsim_pmsr_report_nl(), and bisected the issue to cited commit.

v2: test the nlattr before using nla_data() on it (Simon Horman)

general protection fault, probably for non-canonical address 0xdffffc0000000001: 0000 [#1] PREEMPT SMP KASAN
KASAN: null-ptr-deref in range [0x0000000000000008-0x000000000000000f]
CPU: 0 PID: 5084 Comm: syz-executor104 Not tainted 6.3.0-rc4-next-20230331-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 03/02/2023
RIP: 0010:jhash+0x339/0x610 include/linux/jhash.h:95
Code: 83 fd 01 0f 84 5f ff ff ff eb de 83 fd 05 74 3a e8 ac f5 71 fd 48 8d 7b 05 48 b8 00 00 00 00 00 fc ff df 48 89 fa 48 c1 ea 03 <0f> b6 04 02 48 89 fa 83 e2 07 38 d0 7f 08 84 c0 0f 85 96 02 00 00
RSP: 0018:ffffc90003abf298 EFLAGS: 00010202
RAX: dffffc0000000000 RBX: 0000000000000004 RCX: 0000000000000000
RDX: 0000000000000001 RSI: ffffffff84111ba4 RDI: 0000000000000009
RBP: 0000000000000006 R08: 0000000000000005 R09: 000000000000000c
R10: 0000000000000006 R11: 0000000000000000 R12: 000000004d2c27cd
R13: 000000002bd9e6c2 R14: 000000002bd9e6c2 R15: 000000002bd9e6c2
FS: 0000555556847300(0000) GS:ffff8880b9800000(0000) knlGS:0000000000000000
CS: 0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 000000000045ad50 CR3: 0000000078aa6000 CR4: 00000000003506f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
<TASK>
rht_key_hashfn include/linux/rhashtable.h:159 [inline]
__rhashtable_lookup include/linux/rhashtable.h:604 [inline]
rhashtable_lookup include/linux/rhashtable.h:646 [inline]
rhashtable_lookup_fast include/linux/rhashtable.h:672 [inline]
get_hwsim_data_ref_from_addr+0xb9/0x600 drivers/net/wireless/virtual/mac80211_hwsim.c:757
hwsim_pmsr_report_nl+0xe7/0xd50 drivers/net/wireless/virtual/mac80211_hwsim.c:3764
genl_family_rcv_msg_doit.isra.0+0x1e6/0x2d0 net/netlink/genetlink.c:968
genl_family_rcv_msg net/netlink/genetlink.c:1048 [inline]
genl_rcv_msg+0x4ff/0x7e0 net/netlink/genetlink.c:1065
netlink_rcv_skb+0x165/0x440 net/netlink/af_netlink.c:2572
genl_rcv+0x28/0x40 net/netlink/genetlink.c:1076
netlink_unicast_kernel net/netlink/af_netlink.c:1339 [inline]
netlink_unicast+0x547/0x7f0 net/netlink/af_netlink.c:1365
netlink_sendmsg+0x925/0xe30 net/netlink/af_netlink.c:1942
sock_sendmsg_nosec net/socket.c:724 [inline]
sock_sendmsg+0xde/0x190 net/socket.c:747
____sys_sendmsg+0x71c/0x900 net/socket.c:2501
___sys_sendmsg+0x110/0x1b0 net/socket.c:2555
__sys_sendmsg+0xf7/0x1c0 net/socket.c:2584
do_syscall_x64 arch/x86/entry/common.c:50 [inline]
do_syscall_64+0x39/0xb0 arch/x86/entry/common.c:80
entry_SYSCALL_64_after_hwframe+0x63/0xcd

Fixes: 2af3b2a631b1 ("mac80211_hwsim: add PMSR report support via virtio")
Reported-by: syzbot <syzkaller@googlegroups.com>
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Jaewan Kim <jaewan@google.com>
Cc: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/virtual/mac80211_hwsim.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/wireless/virtual/mac80211_hwsim.c b/drivers/net/wireless/virtual/mac80211_hwsim.c
index f446d8f6e1f6e1df108db00e898fa02970162585..2211fa58fe4140177d53232f4ceafee57185d057 100644
--- a/drivers/net/wireless/virtual/mac80211_hwsim.c
+++ b/drivers/net/wireless/virtual/mac80211_hwsim.c
@@ -3760,6 +3760,9 @@ static int hwsim_pmsr_report_nl(struct sk_buff *msg, struct genl_info *info)
 	int err;
 	int rem;
 
+	if (!info->attrs[HWSIM_ATTR_ADDR_TRANSMITTER])
+		return -EINVAL;
+
 	src = nla_data(info->attrs[HWSIM_ATTR_ADDR_TRANSMITTER]);
 	data = get_hwsim_data_ref_from_addr(src);
 	if (!data)
-- 
2.40.0.348.gf938b09366-goog

