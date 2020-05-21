Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F2CA1DD5FD
	for <lists+netdev@lfdr.de>; Thu, 21 May 2020 20:30:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729166AbgEUSaE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 May 2020 14:30:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728240AbgEUSaE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 May 2020 14:30:04 -0400
Received: from mail-qt1-x849.google.com (mail-qt1-x849.google.com [IPv6:2607:f8b0:4864:20::849])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16D28C061A0E
        for <netdev@vger.kernel.org>; Thu, 21 May 2020 11:30:03 -0700 (PDT)
Received: by mail-qt1-x849.google.com with SMTP id m2so332054qtd.7
        for <netdev@vger.kernel.org>; Thu, 21 May 2020 11:30:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=XLS24cejbtc6Htky1a093lmIhjzBrNYI8TJ1SeDPjXw=;
        b=SNWiUqAAzgW/pxeTIJLY47L6u7nQZUvA68VJY1lqNmW+Qy4zqREM7jxmDPA9oeUVBy
         QBIsLOISWJi0vuI/I68/N/0hVo2C0kX0iQ+0BZCVN0lm+Y0NLA7ojct/g6sSNlvhA80n
         RoLwYB6/t7k21lP+IThvnkvMb9N3FkuKCesWf7WdOBWSMhQPsc2t/XICbH8YBpbAeGPb
         A/TIRWv51Ve7JOLIDRcCiOvMD9PIYjcA2+avNKoDez6ZPMSI36CFoJvr6HigZzbc7C4+
         IjL4IAEIRORCfT3rt/b8IYlBxsZZxWn8YyYszh7QRXDHSstip4VQfqI0nfHgJbUDROha
         dfSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=XLS24cejbtc6Htky1a093lmIhjzBrNYI8TJ1SeDPjXw=;
        b=YmINXHU46hK8PjUgwSREvcc5tM1TDMsI7TAfuVneeg3QuMTIImliX/rhDF74NPkgNg
         E6UlYAbA4Ik7VHtS7fvmPiGz9srE1cr/w43IzlD8sLrkCWzUeyvrSLgij9oL6CTANfas
         WoyN/jo8zCayjz8HkR4rqgE/tbNOO+LgKNK5JNSm0ZZ/9Zbi8GqcYvO6heU7hkQnH0nO
         NHXLKmW7Qs0pZDT0UgwBd9VwEPb22TOIEe/+wY1scJWXszeY6RHmnvOdrjDK58UvY4IJ
         XZtLCtCoLkwdjMmzdh15mLRLi97YmR1cuQzfUPAsW60yJYIT1Lvt8Hx6dqWJuz+7Yoh0
         02xg==
X-Gm-Message-State: AOAM532qHV5zTYnUkiIHiCOAQBCwd6b+v0o8DsRp2FTVjNAONqwbA8dp
        KvzS7osTBDmLvA0AZn4CYOKjlvLOBC+SFw==
X-Google-Smtp-Source: ABdhPJy5c/g1BgNN/fpRuUMtbgZTuNiY/q8rfPsY4AujeOo3OucijGeVGmRur8rpo+6aQUPk572roFjC1Mvfjg==
X-Received: by 2002:a05:6214:b0c:: with SMTP id u12mr47490qvj.242.1590085802178;
 Thu, 21 May 2020 11:30:02 -0700 (PDT)
Date:   Thu, 21 May 2020 11:29:58 -0700
Message-Id: <20200521182958.163436-1-edumazet@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.27.0.rc0.183.gde8f92d652-goog
Subject: [PATCH net] tipc: block BH before using dst_cache
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Xin Long <lucien.xin@gmail.com>,
        Jon Maloy <jon.maloy@ericsson.com>,
        syzbot <syzkaller@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

dst_cache_get() documents it must be used with BH disabled.

sysbot reported :

BUG: using smp_processor_id() in preemptible [00000000] code: /21697
caller is dst_cache_get+0x3a/0xb0 net/core/dst_cache.c:68
CPU: 0 PID: 21697 Comm:  Not tainted 5.7.0-rc6-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x188/0x20d lib/dump_stack.c:118
 check_preemption_disabled lib/smp_processor_id.c:47 [inline]
 debug_smp_processor_id.cold+0x88/0x9b lib/smp_processor_id.c:57
 dst_cache_get+0x3a/0xb0 net/core/dst_cache.c:68
 tipc_udp_xmit.isra.0+0xb9/0xad0 net/tipc/udp_media.c:164
 tipc_udp_send_msg+0x3e6/0x490 net/tipc/udp_media.c:244
 tipc_bearer_xmit_skb+0x1de/0x3f0 net/tipc/bearer.c:526
 tipc_enable_bearer+0xb2f/0xd60 net/tipc/bearer.c:331
 __tipc_nl_bearer_enable+0x2bf/0x390 net/tipc/bearer.c:995
 tipc_nl_bearer_enable+0x1e/0x30 net/tipc/bearer.c:1003
 genl_family_rcv_msg_doit net/netlink/genetlink.c:673 [inline]
 genl_family_rcv_msg net/netlink/genetlink.c:718 [inline]
 genl_rcv_msg+0x627/0xdf0 net/netlink/genetlink.c:735
 netlink_rcv_skb+0x15a/0x410 net/netlink/af_netlink.c:2469
 genl_rcv+0x24/0x40 net/netlink/genetlink.c:746
 netlink_unicast_kernel net/netlink/af_netlink.c:1303 [inline]
 netlink_unicast+0x537/0x740 net/netlink/af_netlink.c:1329
 netlink_sendmsg+0x882/0xe10 net/netlink/af_netlink.c:1918
 sock_sendmsg_nosec net/socket.c:652 [inline]
 sock_sendmsg+0xcf/0x120 net/socket.c:672
 ____sys_sendmsg+0x6bf/0x7e0 net/socket.c:2362
 ___sys_sendmsg+0x100/0x170 net/socket.c:2416
 __sys_sendmsg+0xec/0x1b0 net/socket.c:2449
 do_syscall_64+0xf6/0x7d0 arch/x86/entry/common.c:295
 entry_SYSCALL_64_after_hwframe+0x49/0xb3
RIP: 0033:0x45ca29

Fixes: e9c1a793210f ("tipc: add dst_cache support for udp media")
Cc: Xin Long <lucien.xin@gmail.com>
Cc: Jon Maloy <jon.maloy@ericsson.com>
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reported-by: syzbot <syzkaller@googlegroups.com>
---
 net/tipc/udp_media.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/net/tipc/udp_media.c b/net/tipc/udp_media.c
index d6620ad535461a4d04ed5ba90569ce8b7df9f994..28a283f26a8dff24d613e6ed57e5e69d894dae66 100644
--- a/net/tipc/udp_media.c
+++ b/net/tipc/udp_media.c
@@ -161,9 +161,11 @@ static int tipc_udp_xmit(struct net *net, struct sk_buff *skb,
 			 struct udp_bearer *ub, struct udp_media_addr *src,
 			 struct udp_media_addr *dst, struct dst_cache *cache)
 {
-	struct dst_entry *ndst = dst_cache_get(cache);
+	struct dst_entry *ndst;
 	int ttl, err = 0;
 
+	local_bh_disable();
+	ndst = dst_cache_get(cache);
 	if (dst->proto == htons(ETH_P_IP)) {
 		struct rtable *rt = (struct rtable *)ndst;
 
@@ -210,9 +212,11 @@ static int tipc_udp_xmit(struct net *net, struct sk_buff *skb,
 					   src->port, dst->port, false);
 #endif
 	}
+	local_bh_enable();
 	return err;
 
 tx_error:
+	local_bh_enable();
 	kfree_skb(skb);
 	return err;
 }
-- 
2.27.0.rc0.183.gde8f92d652-goog

