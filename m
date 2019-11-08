Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3899EF3CDD
	for <lists+netdev@lfdr.de>; Fri,  8 Nov 2019 01:27:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728320AbfKHA14 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Nov 2019 19:27:56 -0500
Received: from mail-pl1-f201.google.com ([209.85.214.201]:38440 "EHLO
        mail-pl1-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727544AbfKHA14 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Nov 2019 19:27:56 -0500
Received: by mail-pl1-f201.google.com with SMTP id g7so2934510plo.5
        for <netdev@vger.kernel.org>; Thu, 07 Nov 2019 16:27:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=D3OWjMgLTbPwF4N9Oca4/z2d8T9UgQqzLDjEN4DgrT0=;
        b=FwfziWqbC9qBGCq+WrhVl+1VqZl/SD0ilmF7CzfAGIX1OUTHhE+8H4FO7TIFv+a/Pe
         IUQiqa+Eul7U2+hQgoaKjNaLVxCcBauAdxFleue6c67qHmheBZ4r8Ek5sT0WSU/7YFcG
         t8Gq7yTj5VHziXHenYZeNM0XAGiV4ml7G73BYrzBHRFDKibC7KneVE7emO047uw4sUbx
         m9X20mjTZ1dXEmAkgxRTKh2XZwWG7oKt5X+ZgdYI+99+bdFRg2mCL727JVY/BSFqP400
         QdHvDXp9G48qX7VEsYZDyoRXAlgQDu7xyqh/+fJ+Hw5ErmJmAPHQosVycJBupD7G0cyk
         /QAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=D3OWjMgLTbPwF4N9Oca4/z2d8T9UgQqzLDjEN4DgrT0=;
        b=uFZKJ5LLtfo9tgSzfWUY94v8FKwitdtcRnjFxq/SzAaCqqJEHXmnJPHdbnu9gHCHul
         HiBOSneKSMIHRxeT0UpUsSJMO5sB6lhehqVElWtYb1opn2THkMplq1JxhP7pO8JFvpnA
         aJpgxXxEFq1h4c++bwk0M4Xv7TVw9rt9ZTvIPPKHooTYoDGb6oc67bJPm9X2MyN9Li0S
         Ke3Hnu+SRU4GTV+OdGc/JzWjLUVPNyktQ44s1IYLebXrMVsxDZwKtKfKlgRnFKsrf0tV
         fsmJu6g/Qb4XZb4MVGRHupS0YNbfycnn6kZEFbjXJc7Mzs/ZPXLKa5IjRHiXVhRau4qJ
         A4zg==
X-Gm-Message-State: APjAAAV+DMawOiK3ZJSQvG9MTdXSkyIsj15jSp0OfW+8mqKxHQuvyI0T
        O8yW5mxvmwJcVdx5cbhG5ltiSsIKjLV6kQ==
X-Google-Smtp-Source: APXvYqyUgpp2iIk25Sf4ru9xoe9hXKlOmnmiDyUVKw6FiMGCsga1MzpDtIkmGTnrmmgOp8l+UvxL6MByCIj+TA==
X-Received: by 2002:a63:fc19:: with SMTP id j25mr8493507pgi.204.1573172875365;
 Thu, 07 Nov 2019 16:27:55 -0800 (PST)
Date:   Thu,  7 Nov 2019 16:27:21 -0800
In-Reply-To: <20191108002722.129055-1-edumazet@google.com>
Message-Id: <20191108002722.129055-9-edumazet@google.com>
Mime-Version: 1.0
References: <20191108002722.129055-1-edumazet@google.com>
X-Mailer: git-send-email 2.24.0.432.g9d3f5f5b63-goog
Subject: [PATCH net-next 8/9] tun: switch to u64_stats_t
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In order to fix this data-race found by KCSAN [1],
switch to u64_stats_t helpers. They provide all
the needed annotations, without adding extra cost.

[1]
BUG: KCSAN: data-race in tun_get_user / tun_net_get_stats64

read to 0xffffe8ffffd8aca8 of 8 bytes by task 4882 on cpu 0:
 tun_net_get_stats64+0x9b/0x230 drivers/net/tun.c:1171
 dev_get_stats+0x89/0x1e0 net/core/dev.c:9103
 rtnl_fill_stats+0x56/0x370 net/core/rtnetlink.c:1177
 rtnl_fill_ifinfo+0xd3b/0x2100 net/core/rtnetlink.c:1667
 rtmsg_ifinfo_build_skb+0xb0/0x150 net/core/rtnetlink.c:3472
 rtmsg_ifinfo_event.part.0+0x4e/0xb0 net/core/rtnetlink.c:3504
 rtmsg_ifinfo_event net/core/rtnetlink.c:3515 [inline]
 rtmsg_ifinfo+0x85/0x90 net/core/rtnetlink.c:3513
 __dev_notify_flags+0x18b/0x200 net/core/dev.c:7649
 dev_change_flags+0xb8/0xe0 net/core/dev.c:7691
 dev_ifsioc+0x201/0x6a0 net/core/dev_ioctl.c:237
 dev_ioctl+0x149/0x660 net/core/dev_ioctl.c:489
 sock_do_ioctl+0xdb/0x230 net/socket.c:1061
 sock_ioctl+0x3a3/0x5e0 net/socket.c:1189
 vfs_ioctl fs/ioctl.c:46 [inline]
 file_ioctl fs/ioctl.c:509 [inline]
 do_vfs_ioctl+0x991/0xc60 fs/ioctl.c:696

write to 0xffffe8ffffd8aca8 of 8 bytes by task 4883 on cpu 1:
 tun_get_user+0x1d94/0x2ba0 drivers/net/tun.c:2002
 tun_chr_write_iter+0x79/0xd0 drivers/net/tun.c:2022
 call_write_iter include/linux/fs.h:1895 [inline]
 new_sync_write+0x388/0x4a0 fs/read_write.c:483
 __vfs_write+0xb1/0xc0 fs/read_write.c:496
 __kernel_write+0xb8/0x240 fs/read_write.c:515
 write_pipe_buf+0xb6/0xf0 fs/splice.c:794
 splice_from_pipe_feed fs/splice.c:500 [inline]
 __splice_from_pipe+0x248/0x480 fs/splice.c:624
 splice_from_pipe+0xbb/0x100 fs/splice.c:659
 default_file_splice_write+0x45/0x90 fs/splice.c:806
 do_splice_from fs/splice.c:848 [inline]
 direct_splice_actor+0xa0/0xc0 fs/splice.c:1020
 splice_direct_to_actor+0x215/0x510 fs/splice.c:975
 do_splice_direct+0x161/0x1e0 fs/splice.c:1063
 do_sendfile+0x384/0x7f0 fs/read_write.c:1464

Reported by Kernel Concurrency Sanitizer on:
CPU: 1 PID: 4883 Comm: syz-executor.1 Not tainted 5.4.0-rc3+ #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 drivers/net/tun.c | 32 ++++++++++++++++----------------
 1 file changed, 16 insertions(+), 16 deletions(-)

diff --git a/drivers/net/tun.c b/drivers/net/tun.c
index dab6cccfeb521f53c9c9958bc4d8e0001d235506..dcb63f1f9110762191a2c658ce7af7b5b474d868 100644
--- a/drivers/net/tun.c
+++ b/drivers/net/tun.c
@@ -136,10 +136,10 @@ struct tap_filter {
 #define TUN_FLOW_EXPIRE (3 * HZ)
 
 struct tun_pcpu_stats {
-	u64 rx_packets;
-	u64 rx_bytes;
-	u64 tx_packets;
-	u64 tx_bytes;
+	u64_stats_t rx_packets;
+	u64_stats_t rx_bytes;
+	u64_stats_t tx_packets;
+	u64_stats_t tx_bytes;
 	struct u64_stats_sync syncp;
 	u32 rx_dropped;
 	u32 tx_dropped;
@@ -1167,10 +1167,10 @@ tun_net_get_stats64(struct net_device *dev, struct rtnl_link_stats64 *stats)
 		p = per_cpu_ptr(tun->pcpu_stats, i);
 		do {
 			start = u64_stats_fetch_begin(&p->syncp);
-			rxpackets	= p->rx_packets;
-			rxbytes		= p->rx_bytes;
-			txpackets	= p->tx_packets;
-			txbytes		= p->tx_bytes;
+			rxpackets	= u64_stats_read(&p->rx_packets);
+			rxbytes		= u64_stats_read(&p->rx_bytes);
+			txpackets	= u64_stats_read(&p->tx_packets);
+			txbytes		= u64_stats_read(&p->tx_bytes);
 		} while (u64_stats_fetch_retry(&p->syncp, start));
 
 		stats->rx_packets	+= rxpackets;
@@ -1998,8 +1998,8 @@ static ssize_t tun_get_user(struct tun_struct *tun, struct tun_file *tfile,
 
 	stats = get_cpu_ptr(tun->pcpu_stats);
 	u64_stats_update_begin(&stats->syncp);
-	stats->rx_packets++;
-	stats->rx_bytes += len;
+	u64_stats_inc(&stats->rx_packets);
+	u64_stats_add(&stats->rx_bytes, len);
 	u64_stats_update_end(&stats->syncp);
 	put_cpu_ptr(stats);
 
@@ -2052,8 +2052,8 @@ static ssize_t tun_put_user_xdp(struct tun_struct *tun,
 
 	stats = get_cpu_ptr(tun->pcpu_stats);
 	u64_stats_update_begin(&stats->syncp);
-	stats->tx_packets++;
-	stats->tx_bytes += ret;
+	u64_stats_inc(&stats->tx_packets);
+	u64_stats_add(&stats->tx_bytes, ret);
 	u64_stats_update_end(&stats->syncp);
 	put_cpu_ptr(tun->pcpu_stats);
 
@@ -2147,8 +2147,8 @@ static ssize_t tun_put_user(struct tun_struct *tun,
 	/* caller is in process context, */
 	stats = get_cpu_ptr(tun->pcpu_stats);
 	u64_stats_update_begin(&stats->syncp);
-	stats->tx_packets++;
-	stats->tx_bytes += skb->len + vlan_hlen;
+	u64_stats_inc(&stats->tx_packets);
+	u64_stats_add(&stats->tx_bytes, skb->len + vlan_hlen);
 	u64_stats_update_end(&stats->syncp);
 	put_cpu_ptr(tun->pcpu_stats);
 
@@ -2511,8 +2511,8 @@ static int tun_xdp_one(struct tun_struct *tun,
 	 */
 	stats = this_cpu_ptr(tun->pcpu_stats);
 	u64_stats_update_begin(&stats->syncp);
-	stats->rx_packets++;
-	stats->rx_bytes += datasize;
+	u64_stats_inc(&stats->rx_packets);
+	u64_stats_add(&stats->rx_bytes, datasize);
 	u64_stats_update_end(&stats->syncp);
 
 	if (rxhash)
-- 
2.24.0.432.g9d3f5f5b63-goog

