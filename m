Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2CC3A3BA223
	for <lists+netdev@lfdr.de>; Fri,  2 Jul 2021 16:27:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233114AbhGBOaE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Jul 2021 10:30:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233069AbhGBOaD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Jul 2021 10:30:03 -0400
Received: from mail-pg1-x530.google.com (mail-pg1-x530.google.com [IPv6:2607:f8b0:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9D74C061762
        for <netdev@vger.kernel.org>; Fri,  2 Jul 2021 07:27:31 -0700 (PDT)
Received: by mail-pg1-x530.google.com with SMTP id g22so9699049pgl.7
        for <netdev@vger.kernel.org>; Fri, 02 Jul 2021 07:27:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=YGzwo74PITAdnO2EbX8IeIiPmdm/XXefg9e29Ut921g=;
        b=Vu++n8itO99kuOUqLcxbbUHiah/HrFBHPvTlvmzsZY6K82qwduUwWcQLhHLDXvDaJA
         t4Jt6DK+3w1qDygGH524YY6pvf6dqPjzKPvvUwVjwiL3X6kLHgNEH9IP5ZiBM548IFoI
         rIyCNqneUl+xl99d4qEAXmdWq+hthtK3oTMstA5KtvRnGASaAvF2uv0xWdiSPr17toR3
         g8UcJaCf9sjUGZXpxdFMPT2J5m6y5ETIKMfHlpvysCtKOiTyNV63YTVA6luIKxcqLfn6
         aE1HYMokxb6uh1JS+JsM304LqsZjX4qbokbwImYZ1Ha0tAmnEMEEcvH0pQnCeSwQyiUy
         N72A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=YGzwo74PITAdnO2EbX8IeIiPmdm/XXefg9e29Ut921g=;
        b=KjsKFF7qyTFwUJPCIcfBseUW7ZrUyiHtz43ccWhPpHiBIHf/RKSiskgcJ3gEzJvYJA
         ho7hwnKroHgtIPEv/tD4iAmPs57g/Hln6vgAEGnKuHejTGgL+cov71bkq+aYDQblGO3t
         A0AnOlLoUSUm1rs35Z0u5xphykpvJiCwI6SoWYfqA7vAyIJBfoXO1xgDil8RH3GNtQq/
         13RcRcIMN4CJEGkTjYQ7WYsh9J/0Prn8ldK0dETk8dDe/NVwNxixudHeRh78xs9s3jGj
         AUdZfzAc8dGIU/5jxOKWqOX6/X8Ufqo5AdtKq87P72HvEb1+DpaWxdbxgUrp4H9uXaLV
         Xvug==
X-Gm-Message-State: AOAM5310rrruB8UCeW+v45VBbW8t7sYFZlg75Hn9sEI13DHAaiZ+XA7W
        ctCZvaO79ACHYHWWJtConHM=
X-Google-Smtp-Source: ABdhPJzrTa+GWkBRWib1XgNviUfFb+T8T2YfFhS3/A52ToaJ3xVKToMZkc/Kn2rfqcWKpwKJ1Sorfg==
X-Received: by 2002:a63:d612:: with SMTP id q18mr295333pgg.77.1625236051222;
        Fri, 02 Jul 2021 07:27:31 -0700 (PDT)
Received: from localhost.localdomain ([49.173.165.50])
        by smtp.gmail.com with ESMTPSA id nr12sm12683747pjb.1.2021.07.02.07.27.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 02 Jul 2021 07:27:30 -0700 (PDT)
From:   Taehee Yoo <ap420073@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, j.vosburgh@gmail.com,
        vfalico@gmail.com, andy@greyhouse.net, jesse.brandeburg@intel.com,
        anthony.l.nguyen@intel.com, jarod@redhat.com,
        netdev@vger.kernel.org, intel-wired-lan@lists.osuosl.org
Cc:     ap420073@gmail.com
Subject: [PATCH net 4/8] ixgbevf: use xso.real_dev instead of xso.dev in callback functions of struct xfrmdev_ops
Date:   Fri,  2 Jul 2021 14:26:44 +0000
Message-Id: <20210702142648.7677-5-ap420073@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210702142648.7677-1-ap420073@gmail.com>
References: <20210702142648.7677-1-ap420073@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There are two pointers in struct xfrm_state_offload, *dev, *real_dev.
These are used in callback functions of struct xfrmdev_ops.
The *dev points whether bonding interface or real interface.
If bonding ipsec offload is used, it points bonding interface If not,
it points real interface.
And real_dev always points real interface.
So, ixgbevf should always use real_dev instead of dev.
Of course, real_dev always not be null.

Test commands:
    ip link add bond0 type bond
    #eth0 is ixgbevf interface
    ip link set eth0 master bond0
    ip link set bond0 up
    ip x s add proto esp dst 14.1.1.1 src 15.1.1.1 spi 0x07 mode \
transport reqid 0x07 replay-window 32 aead 'rfc4106(gcm(aes))' \
0x44434241343332312423222114131211f4f3f2f1 128 sel src 14.0.0.52/24 \
dst 14.0.0.70/24 proto tcp offload dev bond0 dir in

Splat looks like:
KASAN: null-ptr-deref in range [0x0000000000000000-0x0000000000000007]
CPU: 6 PID: 688 Comm: ip Not tainted 5.13.0-rc3+ #1168
RIP: 0010:ixgbevf_ipsec_find_empty_idx+0x28/0x1b0 [ixgbevf]
Code: 00 00 0f 1f 44 00 00 55 53 48 89 fb 48 83 ec 08 40 84 f6 0f 84 9c
00 00 00 48 b8 00 00 00 00 00 fc ff df 48 89 fa 48 c1 ea 03 <0f> b6 04 02
84 c0 74 08 3c 01 0f 8e 4c 01 00 00 66 81 3b 00 04 0f
RSP: 0018:ffff8880089af390 EFLAGS: 00010246
RAX: dffffc0000000000 RBX: 0000000000000000 RCX: 0000000000000001
RDX: 0000000000000000 RSI: 0000000000000001 RDI: 0000000000000000
RBP: ffff8880089af4f8 R08: 0000000000000003 R09: fffffbfff4287e11
R10: 0000000000000001 R11: ffff888005de8908 R12: 0000000000000000
R13: ffff88810936a000 R14: ffff88810936a000 R15: ffff888004d78040
FS:  00007fdf9883a680(0000) GS:ffff88811a400000(0000)
knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 000055bc14adbf40 CR3: 000000000b87c005 CR4: 00000000003706e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 ixgbevf_ipsec_add_sa+0x1bf/0x9c0 [ixgbevf]
 ? rcu_read_lock_sched_held+0x91/0xc0
 ? ixgbevf_ipsec_parse_proto_keys.isra.9+0x280/0x280 [ixgbevf]
 ? lock_acquire+0x191/0x720
 ? bond_ipsec_add_sa+0x48/0x350 [bonding]
 ? lockdep_hardirqs_on_prepare+0x3e0/0x3e0
 ? rcu_read_lock_held+0x91/0xa0
 ? rcu_read_lock_sched_held+0xc0/0xc0
 bond_ipsec_add_sa+0x193/0x350 [bonding]
 xfrm_dev_state_add+0x2a9/0x770
 ? memcpy+0x38/0x60
 xfrm_add_sa+0x2278/0x3b10 [xfrm_user]
 ? xfrm_get_policy+0xaa0/0xaa0 [xfrm_user]
 ? register_lock_class+0x1750/0x1750
 xfrm_user_rcv_msg+0x331/0x660 [xfrm_user]
 ? rcu_read_lock_sched_held+0x91/0xc0
 ? xfrm_user_state_lookup.constprop.39+0x320/0x320 [xfrm_user]
 ? find_held_lock+0x3a/0x1c0
 ? mutex_lock_io_nested+0x1210/0x1210
 ? sched_clock_cpu+0x18/0x170
 netlink_rcv_skb+0x121/0x350
[ ... ]

Fixes: 272c2330adc9 ("xfrm: bail early on slave pass over skb")
Signed-off-by: Taehee Yoo <ap420073@gmail.com>
---
 drivers/net/ethernet/intel/ixgbevf/ipsec.c | 20 +++++++++++++-------
 1 file changed, 13 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/intel/ixgbevf/ipsec.c b/drivers/net/ethernet/intel/ixgbevf/ipsec.c
index caaea2c920a6..e3e4676af9e4 100644
--- a/drivers/net/ethernet/intel/ixgbevf/ipsec.c
+++ b/drivers/net/ethernet/intel/ixgbevf/ipsec.c
@@ -211,7 +211,7 @@ struct xfrm_state *ixgbevf_ipsec_find_rx_state(struct ixgbevf_ipsec *ipsec,
 static int ixgbevf_ipsec_parse_proto_keys(struct xfrm_state *xs,
 					  u32 *mykey, u32 *mysalt)
 {
-	struct net_device *dev = xs->xso.dev;
+	struct net_device *dev = xs->xso.real_dev;
 	unsigned char *key_data;
 	char *alg_name = NULL;
 	int key_len;
@@ -260,12 +260,15 @@ static int ixgbevf_ipsec_parse_proto_keys(struct xfrm_state *xs,
  **/
 static int ixgbevf_ipsec_add_sa(struct xfrm_state *xs)
 {
-	struct net_device *dev = xs->xso.dev;
-	struct ixgbevf_adapter *adapter = netdev_priv(dev);
-	struct ixgbevf_ipsec *ipsec = adapter->ipsec;
+	struct net_device *dev = xs->xso.real_dev;
+	struct ixgbevf_adapter *adapter;
+	struct ixgbevf_ipsec *ipsec;
 	u16 sa_idx;
 	int ret;
 
+	adapter = netdev_priv(dev);
+	ipsec = adapter->ipsec;
+
 	if (xs->id.proto != IPPROTO_ESP && xs->id.proto != IPPROTO_AH) {
 		netdev_err(dev, "Unsupported protocol 0x%04x for IPsec offload\n",
 			   xs->id.proto);
@@ -383,11 +386,14 @@ static int ixgbevf_ipsec_add_sa(struct xfrm_state *xs)
  **/
 static void ixgbevf_ipsec_del_sa(struct xfrm_state *xs)
 {
-	struct net_device *dev = xs->xso.dev;
-	struct ixgbevf_adapter *adapter = netdev_priv(dev);
-	struct ixgbevf_ipsec *ipsec = adapter->ipsec;
+	struct net_device *dev = xs->xso.real_dev;
+	struct ixgbevf_adapter *adapter;
+	struct ixgbevf_ipsec *ipsec;
 	u16 sa_idx;
 
+	adapter = netdev_priv(dev);
+	ipsec = adapter->ipsec;
+
 	if (xs->xso.flags & XFRM_OFFLOAD_INBOUND) {
 		sa_idx = xs->xso.offload_handle - IXGBE_IPSEC_BASE_RX_INDEX;
 
-- 
2.17.1

