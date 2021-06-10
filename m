Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 79C923A2996
	for <lists+netdev@lfdr.de>; Thu, 10 Jun 2021 12:46:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230199AbhFJKr4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Jun 2021 06:47:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229778AbhFJKrz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Jun 2021 06:47:55 -0400
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 306D6C061574
        for <netdev@vger.kernel.org>; Thu, 10 Jun 2021 03:45:49 -0700 (PDT)
Received: by mail-ej1-x62f.google.com with SMTP id a11so42700551ejf.3
        for <netdev@vger.kernel.org>; Thu, 10 Jun 2021 03:45:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=hD8fPsRet4ILI2ZqLWaNZjnbEkYaKbtss9dKK+ZgOyw=;
        b=BaLArFcF4khkys2mXt7mJw8mXxlXO+j6UB9ENdQ0lvXBtBH84PsRaXiwWEDRHCbkwF
         1HGnFogLXJVOTieIqs7UAHkAXpsMiCgSGQQ+SZtDf5bbJs1Hez2mUBx71Bymq7hNJM7B
         dJaxXn2RR3QEIOzsVxjWyYyn5ZIYAc1nSBzvaCtsGtTV69KL4yv7LA2aaxIe1TVe9nxF
         Qp0HvM57VaUnvwQSd0H4/SAasWejC6G58+HYxpEmh3U8aTArYLfe9HafhUmFZ/PkWuu2
         h+xGi56fqX/RZug+X8sBcQJMAQtsdmOpLpQPsLBYAwe6kgo7AwUy+bVdTLwyXCCy7Flx
         5z6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=hD8fPsRet4ILI2ZqLWaNZjnbEkYaKbtss9dKK+ZgOyw=;
        b=kqeHMKD79SsFsPLYL7vf+PXq5+8lDSHEVvIrMlyRaLP/g2dHaP82PiYHOYdWe8USB9
         O9z3TP9CDixx5GEMDCd8/xO0wH8IT5Gf30PVbnIiQDyET3TY+dlaMFFo5oCGhRyol3Ld
         oZoKv1cfM1mjSfAIRyzbG3ySuiB0mSs/vGg0KDnmumdyzEHqXpDtD0mJQGBez+0M+dod
         wbzzGN3HB45Yr3zif5MiphXJM4MvCyRp9lxGtgltjZV+nGYzATwG83qjQN5YRJhbmozz
         Ty/jOTncZbdrpX+SYNamwE++hWWrKe4CNI5G9eCSehORcxwL8i89P26Ta836J9cvyPAj
         YVng==
X-Gm-Message-State: AOAM533pxQfCzyG28EU38q2vP+ys+1lf3N2Hc6PYgG27iGwLHPJ/O5FE
        imF3P0wmY3OOmpDehLLah0OAljztUx7U8p67Hsw=
X-Google-Smtp-Source: ABdhPJy0Ntl5eLRAzxpza4PaVoYcOab3BALHOh6a//cqI41PcQWWbcNGblDv/YLXq65AE5MzPpaaxw==
X-Received: by 2002:a17:906:9888:: with SMTP id zc8mr3759147ejb.26.1623321947473;
        Thu, 10 Jun 2021 03:45:47 -0700 (PDT)
Received: from debil.vdiclient.nvidia.com (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id y1sm866526ejl.7.2021.06.10.03.45.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Jun 2021 03:45:47 -0700 (PDT)
From:   Nikolay Aleksandrov <razor@blackwall.org>
To:     netdev@vger.kernel.org
Cc:     roopa@nvidia.com, davem@davemloft.net,
        bridge@lists.linux-foundation.org,
        Nikolay Aleksandrov <nikolay@nvidia.com>
Subject: [PATCH net 2/2] net: bridge: fix vlan tunnel dst refcnt when egressing
Date:   Thu, 10 Jun 2021 13:45:37 +0300
Message-Id: <20210610104537.119538-3-razor@blackwall.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210610104537.119538-1-razor@blackwall.org>
References: <20210610104537.119538-1-razor@blackwall.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Nikolay Aleksandrov <nikolay@nvidia.com>

The egress tunnel code uses dst_clone() and directly sets the result
which is wrong because the entry might have 0 refcnt or be already deleted,
causing number of problems. It also triggers the WARN_ON() in dst_hold()[1]
when a refcnt couldn't be taken. Fix it by using dst_hold_safe() and
checking if a reference was actually taken before setting the dst.

[1] dmesg WARN_ON log and following refcnt errors
 WARNING: CPU: 5 PID: 38 at include/net/dst.h:230 br_handle_egress_vlan_tunnel+0x10b/0x134 [bridge]
 Modules linked in: 8021q garp mrp bridge stp llc bonding ipv6 virtio_net
 CPU: 5 PID: 38 Comm: ksoftirqd/5 Kdump: loaded Tainted: G        W         5.13.0-rc3+ #360
 Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.14.0-1.fc33 04/01/2014
 RIP: 0010:br_handle_egress_vlan_tunnel+0x10b/0x134 [bridge]
 Code: e8 85 bc 01 e1 45 84 f6 74 90 45 31 f6 85 db 48 c7 c7 a0 02 19 a0 41 0f 94 c6 31 c9 31 d2 44 89 f6 e8 64 bc 01 e1 85 db 75 02 <0f> 0b 31 c9 31 d2 44 89 f6 48 c7 c7 70 02 19 a0 e8 4b bc 01 e1 49
 RSP: 0018:ffff8881003d39e8 EFLAGS: 00010246
 RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000000
 RDX: 0000000000000000 RSI: 0000000000000001 RDI: ffffffffa01902a0
 RBP: ffff8881040c6700 R08: 0000000000000000 R09: 0000000000000001
 R10: 2ce93d0054fe0d00 R11: 54fe0d00000e0000 R12: ffff888109515000
 R13: 0000000000000000 R14: 0000000000000001 R15: 0000000000000401
 FS:  0000000000000000(0000) GS:ffff88822bf40000(0000) knlGS:0000000000000000
 CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
 CR2: 00007f42ba70f030 CR3: 0000000109926000 CR4: 00000000000006e0
 Call Trace:
  br_handle_vlan+0xbc/0xca [bridge]
  __br_forward+0x23/0x164 [bridge]
  deliver_clone+0x41/0x48 [bridge]
  br_handle_frame_finish+0x36f/0x3aa [bridge]
  ? skb_dst+0x2e/0x38 [bridge]
  ? br_handle_ingress_vlan_tunnel+0x3e/0x1c8 [bridge]
  ? br_handle_frame_finish+0x3aa/0x3aa [bridge]
  br_handle_frame+0x2c3/0x377 [bridge]
  ? __skb_pull+0x33/0x51
  ? vlan_do_receive+0x4f/0x36a
  ? br_handle_frame_finish+0x3aa/0x3aa [bridge]
  __netif_receive_skb_core+0x539/0x7c6
  ? __list_del_entry_valid+0x16e/0x1c2
  __netif_receive_skb_list_core+0x6d/0xd6
  netif_receive_skb_list_internal+0x1d9/0x1fa
  gro_normal_list+0x22/0x3e
  dev_gro_receive+0x55b/0x600
  ? detach_buf_split+0x58/0x140
  napi_gro_receive+0x94/0x12e
  virtnet_poll+0x15d/0x315 [virtio_net]
  __napi_poll+0x2c/0x1c9
  net_rx_action+0xe6/0x1fb
  __do_softirq+0x115/0x2d8
  run_ksoftirqd+0x18/0x20
  smpboot_thread_fn+0x183/0x19c
  ? smpboot_unregister_percpu_thread+0x66/0x66
  kthread+0x10a/0x10f
  ? kthread_mod_delayed_work+0xb6/0xb6
  ret_from_fork+0x22/0x30
 ---[ end trace 49f61b07f775fd2b ]---
 dst_release: dst:00000000c02d677a refcnt:-1
 dst_release underflow

Fixes: 11538d039ac6 ("bridge: vlan dst_metadata hooks in ingress and egress paths")
Signed-off-by: Nikolay Aleksandrov <nikolay@nvidia.com>
---
 net/bridge/br_vlan_tunnel.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/bridge/br_vlan_tunnel.c b/net/bridge/br_vlan_tunnel.c
index 03de461a0d44..01017448ebde 100644
--- a/net/bridge/br_vlan_tunnel.c
+++ b/net/bridge/br_vlan_tunnel.c
@@ -204,8 +204,8 @@ int br_handle_egress_vlan_tunnel(struct sk_buff *skb,
 		return err;
 
 	tunnel_dst = rcu_dereference(vlan->tinfo.tunnel_dst);
-	if (tunnel_dst)
-		skb_dst_set(skb, dst_clone(&tunnel_dst->dst));
+	if (tunnel_dst && dst_hold_safe(&tunnel_dst->dst))
+		skb_dst_set(skb, &tunnel_dst->dst);
 
 	return 0;
 }
-- 
2.31.1

