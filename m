Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E268124E74E
	for <lists+netdev@lfdr.de>; Sat, 22 Aug 2020 14:06:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727952AbgHVMGz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 22 Aug 2020 08:06:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726704AbgHVMGy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 22 Aug 2020 08:06:54 -0400
Received: from mail-wr1-x444.google.com (mail-wr1-x444.google.com [IPv6:2a00:1450:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19016C061573
        for <netdev@vger.kernel.org>; Sat, 22 Aug 2020 05:06:53 -0700 (PDT)
Received: by mail-wr1-x444.google.com with SMTP id z18so4248154wrm.12
        for <netdev@vger.kernel.org>; Sat, 22 Aug 2020 05:06:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=uyZVZUFpBtCxrrxjsB+xh6eo4LrouZnpQIAitNXa0b0=;
        b=YEZq6mphfQ5gFPQmxZiscU90LLiXxREcLPDn6stlSuk/tYSEYSdaKejiXDa6s5Be1l
         PFHkZXgOHsi7Xs/lL2iv7nOdYtpmM2RoMtZRHQpOq41Gzpg8U4gcl8tISKL/2TN5FODa
         T7dHjmI+NvTPhOXUD+XDKtL/F949YYs5cpjWU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=uyZVZUFpBtCxrrxjsB+xh6eo4LrouZnpQIAitNXa0b0=;
        b=p0RviwdUp8uV8xfuFFdjRMuUyQf1Kt9R+rXqOSD18kFmJn+fPMf0hSAkWlJPQX9RnH
         48RHoJcyYU0pCvyr5QZhG+G33ciP5DDuq3aioLx8bVSyyQ4V5NPNS/FcCt8jqqKGldpv
         xiQRzHfq4eKTi8jAKbS6ZaaHiXEpcXIU7oxlUt91ugpLHhxmulJWlz8eB6DSwUhBFOJe
         mwGdLeHlw1KBblZ4EQeX4nwc0PsygUW2DvQpPCchaVdj4HnZ76XBtz5wiAwvQRpql/dk
         FrRPdf70f96QI8yzRlfDn3JvgqGN49JgtMUF0rdPstj+fxtcLSM8KLoqYgycq1HZlyM6
         lF6w==
X-Gm-Message-State: AOAM5326Cxb/xM51BtInbFnpFDBvYUbHq/+9FTOWG3Rcl1skGp9443JA
        aNfo5PaO+z1D6gdU6R/nCArlIU50WzlS2w==
X-Google-Smtp-Source: ABdhPJzCcfELNK2ctztSq88oI9bWu2pF7U8r7jKQBf1FCYcpp2WCDPKNq3HuKVoqzPvBjjuS5vXfwQ==
X-Received: by 2002:a5d:4241:: with SMTP id s1mr6848487wrr.411.1598098010547;
        Sat, 22 Aug 2020 05:06:50 -0700 (PDT)
Received: from wrk.www.tendawifi.com ([79.134.173.43])
        by smtp.gmail.com with ESMTPSA id z8sm10997516wmf.42.2020.08.22.05.06.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 22 Aug 2020 05:06:49 -0700 (PDT)
From:   Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net,
        Nikolay Aleksandrov <nikolay@cumulusnetworks.com>,
        David Ahern <dsahern@gmail.com>,
        syzbot+a61aa19b0c14c8770bd9@syzkaller.appspotmail.com
Subject: [PATCH net v2] net: nexthop: don't allow empty NHA_GROUP
Date:   Sat, 22 Aug 2020 15:06:36 +0300
Message-Id: <20200822120636.194237-1-nikolay@cumulusnetworks.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200822103340.184978-1-nikolay@cumulusnetworks.com>
References: <20200822103340.184978-1-nikolay@cumulusnetworks.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently the nexthop code will use an empty NHA_GROUP attribute, but it
requires at least 1 entry in order to function properly. Otherwise we
end up derefencing null or random pointers all over the place due to not
having any nh_grp_entry members allocated, nexthop code relies on having at
least the first member present. Empty NHA_GROUP doesn't make any sense so
just disallow it.
Also add a WARN_ON for any future users of nexthop_create_group().

 BUG: kernel NULL pointer dereference, address: 0000000000000080
 #PF: supervisor read access in kernel mode
 #PF: error_code(0x0000) - not-present page
 PGD 0 P4D 0 
 Oops: 0000 [#1] SMP
 CPU: 0 PID: 558 Comm: ip Not tainted 5.9.0-rc1+ #93
 Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.13.0-2.fc32 04/01/2014
 RIP: 0010:fib_check_nexthop+0x4a/0xaa
 Code: 0f 84 83 00 00 00 48 c7 02 80 03 f7 81 c3 40 80 fe fe 75 12 b8 ea ff ff ff 48 85 d2 74 6b 48 c7 02 40 03 f7 81 c3 48 8b 40 10 <48> 8b 80 80 00 00 00 eb 36 80 78 1a 00 74 12 b8 ea ff ff ff 48 85
 RSP: 0018:ffff88807983ba00 EFLAGS: 00010213
 RAX: 0000000000000000 RBX: ffff88807983bc00 RCX: 0000000000000000
 RDX: ffff88807983bc00 RSI: 0000000000000000 RDI: ffff88807bdd0a80
 RBP: ffff88807983baf8 R08: 0000000000000dc0 R09: 000000000000040a
 R10: 0000000000000000 R11: ffff88807bdd0ae8 R12: 0000000000000000
 R13: 0000000000000000 R14: ffff88807bea3100 R15: 0000000000000001
 FS:  00007f10db393700(0000) GS:ffff88807dc00000(0000) knlGS:0000000000000000
 CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
 CR2: 0000000000000080 CR3: 000000007bd0f004 CR4: 00000000003706f0
 Call Trace:
  fib_create_info+0x64d/0xaf7
  fib_table_insert+0xf6/0x581
  ? __vma_adjust+0x3b6/0x4d4
  inet_rtm_newroute+0x56/0x70
  rtnetlink_rcv_msg+0x1e3/0x20d
  ? rtnl_calcit.isra.0+0xb8/0xb8
  netlink_rcv_skb+0x5b/0xac
  netlink_unicast+0xfa/0x17b
  netlink_sendmsg+0x334/0x353
  sock_sendmsg_nosec+0xf/0x3f
  ____sys_sendmsg+0x1a0/0x1fc
  ? copy_msghdr_from_user+0x4c/0x61
  ___sys_sendmsg+0x63/0x84
  ? handle_mm_fault+0xa39/0x11b5
  ? sockfd_lookup_light+0x72/0x9a
  __sys_sendmsg+0x50/0x6e
  do_syscall_64+0x54/0xbe
  entry_SYSCALL_64_after_hwframe+0x44/0xa9
 RIP: 0033:0x7f10dacc0bb7
 Code: d8 64 89 02 48 c7 c0 ff ff ff ff eb cd 66 0f 1f 44 00 00 8b 05 9a 4b 2b 00 85 c0 75 2e 48 63 ff 48 63 d2 b8 2e 00 00 00 0f 05 <48> 3d 00 f0 ff ff 77 01 c3 48 8b 15 b1 f2 2a 00 f7 d8 64 89 02 48
 RSP: 002b:00007ffcbe628bf8 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
 RAX: ffffffffffffffda RBX: 00007ffcbe628f80 RCX: 00007f10dacc0bb7
 RDX: 0000000000000000 RSI: 00007ffcbe628c60 RDI: 0000000000000003
 RBP: 000000005f41099c R08: 0000000000000001 R09: 0000000000000008
 R10: 00000000000005e9 R11: 0000000000000246 R12: 0000000000000000
 R13: 0000000000000000 R14: 00007ffcbe628d70 R15: 0000563a86c6e440
 Modules linked in:
 CR2: 0000000000000080

CC: David Ahern <dsahern@gmail.com>
Fixes: 430a049190de ("nexthop: Add support for nexthop groups")
Reported-by: syzbot+a61aa19b0c14c8770bd9@syzkaller.appspotmail.com
Signed-off-by: Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
---
Tested on 5.3 and latest -net by adding a nexthop with an empty NHA_GROUP
(purposefully broken iproute2) and then adding a route which uses it.

v2: no changes, include stack trace in commit message

 net/ipv4/nexthop.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/net/ipv4/nexthop.c b/net/ipv4/nexthop.c
index cc8049b100b2..134e92382275 100644
--- a/net/ipv4/nexthop.c
+++ b/net/ipv4/nexthop.c
@@ -446,7 +446,7 @@ static int nh_check_attr_group(struct net *net, struct nlattr *tb[],
 	unsigned int i, j;
 	u8 nhg_fdb = 0;
 
-	if (len & (sizeof(struct nexthop_grp) - 1)) {
+	if (!len || len & (sizeof(struct nexthop_grp) - 1)) {
 		NL_SET_ERR_MSG(extack,
 			       "Invalid length for nexthop group attribute");
 		return -EINVAL;
@@ -1187,6 +1187,9 @@ static struct nexthop *nexthop_create_group(struct net *net,
 	struct nexthop *nh;
 	int i;
 
+	if (WARN_ON(!num_nh))
+		return ERR_PTR(-EINVAL);
+
 	nh = nexthop_alloc();
 	if (!nh)
 		return ERR_PTR(-ENOMEM);
-- 
2.26.2

