Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DCDD16D63C4
	for <lists+netdev@lfdr.de>; Tue,  4 Apr 2023 15:48:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235419AbjDDNsb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Apr 2023 09:48:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235385AbjDDNsQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Apr 2023 09:48:16 -0400
Received: from mail-qv1-xf49.google.com (mail-qv1-xf49.google.com [IPv6:2607:f8b0:4864:20::f49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 706784C28
        for <netdev@vger.kernel.org>; Tue,  4 Apr 2023 06:48:08 -0700 (PDT)
Received: by mail-qv1-xf49.google.com with SMTP id g14-20020ad457ae000000b005aab630eb8eso14709910qvx.13
        for <netdev@vger.kernel.org>; Tue, 04 Apr 2023 06:48:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1680616087;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=Cai39CQoW75/9psdxErWYiv2dgQOsoRMqIABinZedq8=;
        b=AsdoMFRWrcsccMVVboAU49FbZ09i4GHJVs9fBhEA8UqAXUlP6n1x9s9oQr1drPvDBa
         AoeBwxCpURL5/5qren0f/ZcK/JvoCdMRC1F6IewCxU36RrZofogvnR3bdfEDkqVCh+nu
         7bXwDFv2o9TrYM4mCMAzKvXQBkLB93A45EJoGovjvJuI37D/BF2TLXJ9FCdrCzHwQWH0
         ujUV9Jm4UeS+XVmfp7WBz1UyuJ8eBfMVaSLXM/T+SxUv1vaRmenn9Q3bHrjbnMfy4Lrt
         GfW0YxGhfMAvvNQ7GN75KLAMVhOF2D7wAaK3+yt5mJqMXAxnb55KGNyMZ03GCh1njr3x
         2Gjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680616087;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Cai39CQoW75/9psdxErWYiv2dgQOsoRMqIABinZedq8=;
        b=oJPYNwwauWXLUpFoL/wEOht7ZZ791WxwaNwNoZnxnBQY5YHBYFS1eaFoh/FypbIIsy
         cLImEAeNDIf/1xnGctVV/YKrJuiCSH1BT1v/823yloBUA2n9LHmXjEvdaiDqb1KIjhm9
         fSLxVEoBY7motPevvHks/kZzAH/p/LOwZ/RfHidnqBBDn4AYgVe2Lhjf6GpM0NfHOtuD
         NxPe4FhPTQQD4wA/ZgrZLmqBn8JkanefTWgz7eGGrQW9JTBOtrp71pYLU3iCTx4z03eV
         SXAuAA88IT0jnCrcT0G8OEg5cN0aE4UBZ27yczOUUkZyIMTQZBHvyx+Kr3d2fch1ZMn6
         UM9w==
X-Gm-Message-State: AAQBX9fnPLmvhiNKkTW9Mh046YI79P+ZxphBBm5NSXtIH8JxDgwvTZFi
        v0GzzRE/t1io/738OxdkEzcUPTzxObQv+A==
X-Google-Smtp-Source: AKy350ZMZngXV8aDPdmoeQ9Tb/VI/fqz3mGD56GCZTpWYTxR1dZS+soIifu/48TDzHydv5CgjF9uH0FGsDZyJA==
X-Received: from edumazet1.c.googlers.com ([fda3:e722:ac3:cc00:2b:7d90:c0a8:395a])
 (user=edumazet job=sendgmr) by 2002:a05:6214:17c8:b0:56c:224c:f64b with SMTP
 id cu8-20020a05621417c800b0056c224cf64bmr471883qvb.6.1680616087568; Tue, 04
 Apr 2023 06:48:07 -0700 (PDT)
Date:   Tue,  4 Apr 2023 13:48:03 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.40.0.348.gf938b09366-goog
Message-ID: <20230404134803.889673-1-edumazet@google.com>
Subject: [PATCH net] mac80211_hwsim: fix potential NULL deref in hwsim_pmsr_report_nl()
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Johannes Berg <johannes@sipsolutions.net>
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        eric.dumazet@gmail.com, Eric Dumazet <edumazet@google.com>,
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

syzbot reported a NULL deref caused by a missing check
in hwsim_pmsr_report_nl(), and bisected the issue to cited commit.

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
 drivers/net/wireless/virtual/mac80211_hwsim.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/wireless/virtual/mac80211_hwsim.c b/drivers/net/wireless/virtual/mac80211_hwsim.c
index f446d8f6e1f6e1df108db00e898fa02970162585..701e14b8e6fe0cae7ee2478c8dff0f2327b54a70 100644
--- a/drivers/net/wireless/virtual/mac80211_hwsim.c
+++ b/drivers/net/wireless/virtual/mac80211_hwsim.c
@@ -3761,6 +3761,8 @@ static int hwsim_pmsr_report_nl(struct sk_buff *msg, struct genl_info *info)
 	int rem;
 
 	src = nla_data(info->attrs[HWSIM_ATTR_ADDR_TRANSMITTER]);
+	if (!src)
+		return -EINVAL;
 	data = get_hwsim_data_ref_from_addr(src);
 	if (!data)
 		return -EINVAL;
-- 
2.40.0.348.gf938b09366-goog

