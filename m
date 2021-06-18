Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD32F3AD57D
	for <lists+netdev@lfdr.de>; Sat, 19 Jun 2021 00:55:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235093AbhFRW5j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Jun 2021 18:57:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:43014 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231270AbhFRW5i (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 18 Jun 2021 18:57:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4B24D60D07;
        Fri, 18 Jun 2021 22:55:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624056928;
        bh=OiRKeXuzYXGJiKhzPK0PM/6hxSUtzLCk4VoP8Q7/46k=;
        h=From:To:Cc:Subject:Date:From;
        b=g9N5yaK7pIkZT4CbtN6BiuQY9VedhKl/LJOWXjQc9xLKlBBnw/ga0VjaKSCdyblhW
         G3Zah0/9yrrQnl5f3TGKn5I+kKPsUc0x7qdFNvHlblLU0c+9OzEnox8g1GOZPkiNCa
         KG4g1akddD9sGyeli2dYdP6XYOBYv+epvk3A6pip90kWmr0ouI2C66OyPlG1SulZ6e
         Lvzhwj37SpCJoYTwjyJpaGFJh+ePBwayKItX3uQ7HyYbA+WihsDHdYwE+0lnyJtVKW
         RCsiUfWcPqQdsYtwUNk2X/om5mHXv1AcoecQ3HSXYeYANxLfpq8YdDlwgHyQepPZ17
         IFdzPs2BkoBFA==
From:   Saeed Mahameed <saeed@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, Saeed Mahameed <saeedm@nvidia.com>,
        Michal Kubecek <mkubecek@suse.cz>
Subject: [PATCH net-next] ethtool: strset: account for nesting in reply size
Date:   Fri, 18 Jun 2021 15:55:02 -0700
Message-Id: <20210618225502.170644-1-saeed@kernel.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Saeed Mahameed <saeedm@nvidia.com>

The cited patch revealed a bug in strset reply size where the
calculation didn't include the 1st nla_nest_start(), a size of 4 Bytes in
strset_fill_reply().

To fix the issue we account for the missing nla_nest 4Bytes by reporting
them in strset_reply_size()

Before this patch issuing "ethtool -k" command will produce the
following call trace:

 [  918.829930] ------------[ cut here ]------------
 [  918.830948] ethnl cmd 1: calculated reply length 2236, but consumed 2240
 [  918.832259] WARNING: CPU: 4 PID: 33733 at net/ethtool/netlink.c:360 ethnl_default_doit+0x309/0x3b0
...
 [  918.842656] CPU: 4 PID: 33733 Comm: ethtool Tainted: G        W         5.13.0-rc3_net_next_615461e #1
 [  918.844539] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS rel-1.13.0-0-gf21b5a4aeb02-prebuilt.qemu.org 04/01/2014
 [  918.846779] RIP: 0010:ethnl_default_doit+0x309/0x3b0
 [  918.847807] Code: 85 7d fe ff ff 41 8b 48 70 44 89 fa 44 89 f6 4c 89 04 24 2b 4c 24 0c 48 c7 c7 20 7b 5b 82 c6 05 86 47 17 01 01 e8 4c 03 26 00 <0f> 0b 4c 8b 04 24 e9 4d fe ff ff be 04 00 00 00 4c 89 04 24 e8 be
 [  918.851370] RSP: 0018:ffff88812e64fb58 EFLAGS: 00010282
 [  918.852424] RAX: 0000000000000000 RBX: ffffffff822e30a0 RCX: ffff8882f5c278b8
 [  918.853799] RDX: 00000000ffffffd8 RSI: 0000000000000027 RDI: ffff8882f5c278b0
 [  918.855190] RBP: ffff88812ba829c0 R08: 0000000000000000 R09: 0000000000000000
 [  918.856572] R10: 0000000000000730 R11: 6d63206c6e687465 R12: ffff88812e64fbc0
 [  918.857962] R13: ffff888130cd8000 R14: 0000000000000001 R15: 00000000000008bc
 [  918.859343] FS:  00007f41f3e1c740(0000) GS:ffff8882f5c00000(0000) knlGS:0000000000000000
 [  918.860941] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
 [  918.862097] CR2: 00000000013984a8 CR3: 00000001049e0001 CR4: 0000000000170ea0
 [  918.863486] Call Trace:
 [  918.864072]  genl_family_rcv_msg_doit+0xe2/0x140
 [  918.865020]  genl_rcv_msg+0xde/0x1e0
 [  918.865801]  ? ethnl_reply_init+0xd0/0xd0
 [  918.866656]  ? ethnl_default_parse+0x60/0x60
 [  918.867543]  ? ethnl_fill_reply_header.part.0+0x100/0x100
 [  918.868617]  ? __ethtool_get_ts_info+0x70/0x70
 [  918.869542]  ? genl_get_cmd+0xd0/0xd0
 [  918.881174]  netlink_rcv_skb+0x4e/0xf0
 [  918.882002]  genl_rcv+0x24/0x40
 [  918.882703]  netlink_unicast+0x18b/0x240
 [  918.883526]  netlink_sendmsg+0x25a/0x4a0
 [  918.884353]  sock_sendmsg+0x33/0x40
 [  918.885117]  __sys_sendto+0xd7/0x120
 [  918.885904]  ? lock_release+0x1a5/0x2e0
 [  918.886718]  ? trace_hardirqs_off+0xd/0xc0
 [  918.887580]  ? exc_page_fault+0x2d7/0x8e0
 [  918.888426]  __x64_sys_sendto+0x25/0x30
 [  918.889248]  do_syscall_64+0x3f/0x80
 [  918.890032]  entry_SYSCALL_64_after_hwframe+0x44/0xae
 [  918.891081] RIP: 0033:0x7f41f3f21cba

Fixes: 4d1fb7cde0cc ("ethtool: add a stricter length check")
Fixes: 7c87e32d2e38 ("ethtool: count header size in reply size estimate")
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
CC: Jakub Kicinski <kuba@kernel.org>
CC: Michal Kubecek <mkubecek@suse.cz>

---

Note: I used nla_total_size(0); to report the missing bytes, i see in
other places they use nla_total_size(sizeof(u32)). Since nla_nest uses a
payload of 0, I prefer my version of nla_total_size(0); since it
resembles what the nla_nest is actually doing. I might be wrong though
:), comments ?
---
 net/ethtool/strset.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ethtool/strset.c b/net/ethtool/strset.c
index b3029fff715d..23d517a61e08 100644
--- a/net/ethtool/strset.c
+++ b/net/ethtool/strset.c
@@ -349,8 +349,8 @@ static int strset_reply_size(const struct ethnl_req_info *req_base,
 {
 	const struct strset_req_info *req_info = STRSET_REQINFO(req_base);
 	const struct strset_reply_data *data = STRSET_REPDATA(reply_base);
+	int len = nla_total_size(0); /* account for nesting */
 	unsigned int i;
-	int len = 0;
 	int ret;
 
 	for (i = 0; i < ETH_SS_COUNT; i++) {
-- 
2.31.1

