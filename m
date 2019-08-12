Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0A65F89D65
	for <lists+netdev@lfdr.de>; Mon, 12 Aug 2019 13:57:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728294AbfHLL5b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Aug 2019 07:57:31 -0400
Received: from mail-pf1-f202.google.com ([209.85.210.202]:36961 "EHLO
        mail-pf1-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728258AbfHLL5b (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Aug 2019 07:57:31 -0400
Received: by mail-pf1-f202.google.com with SMTP id w30so2292372pfj.4
        for <netdev@vger.kernel.org>; Mon, 12 Aug 2019 04:57:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=UzSMxK+UAAOHFHbeOa3MB1gvBMsAZ0DjmysKjpRO2+k=;
        b=RFUToEB4qiUGFiAiYYdwu9W+SndND11Ks8Aw2ur6sOTSfqaFY2wTEZwcG+PcBve5S0
         IBuuh3hSEfSaHqi76ckfoseFmluMkkLxNul3+K/lwmp1CPl8n35WjsJgZNoQwBctq2Cd
         aWzbuwXeyAKcq4axX3aEfi0nPXJRWFJ+Onp7fA7zGuhIHY5FVFlZyj8m1cm91GCWNVef
         oZMCBpeO36hBq69eTr2HLP/UJAQi9hMAoaHmvdme41k6dZCob8DkdvGgoBk8tyk1CXMJ
         TuiJa4Nw4usva+P/TRZ2bFYNYKDZCEsgcx7Giwf0MHPVySXhGBY7s7qTSa7zEb9j78SH
         bIsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=UzSMxK+UAAOHFHbeOa3MB1gvBMsAZ0DjmysKjpRO2+k=;
        b=RduKhUVkKz0kh/eh64hemBysD1mlxUCx2Q48TK7XiFhhzDQ+ev5KMPMqMVBiNPEdO5
         H2OM7p2VetLx1lEh6aW+DuzPhBYZZyN0o9T56aUT902gddGFmyLu+AtVa4doDMveqKcc
         XrxavLp8kWW09CB12b6apqNQvuXF+EHkooJHuOVGDB21nNMuAovoH+5gXKBispql1KP7
         XjaZyIV3hAUhcBgNHiRN1qa8RMEqajE3e1lQXSUl2T2r4R54cfon7xSnq+wyKL+l/xay
         BAduT1mJb2su9TvQN/YdLvOMPrz4REQ3LemRJXmMqjOdZRoYGxAnUQ2rG4cXbTUR8Ino
         VtbQ==
X-Gm-Message-State: APjAAAXEnWNXcBbJo/b4UJl2diPTUTx/MXuVw2iHwiMdRsIkPSU31oMB
        pvq2t4HtfsEhxzgoCaeReS8umtD0nM0Rcw==
X-Google-Smtp-Source: APXvYqxPmTDa5NumJ3C4uq40TBkWSsGhiIPCoonuLQMkluDbNUvr5GFk9kGkAQ0EvMvg31sTRIY0IaEbSpDA2w==
X-Received: by 2002:a63:df06:: with SMTP id u6mr28125304pgg.96.1565611050593;
 Mon, 12 Aug 2019 04:57:30 -0700 (PDT)
Date:   Mon, 12 Aug 2019 04:57:27 -0700
Message-Id: <20190812115727.72149-1-edumazet@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.23.0.rc1.153.gdeed80330f-goog
Subject: [PATCH net] batman-adv: fix uninit-value in batadv_netlink_get_ifindex()
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        syzbot <syzkaller@googlegroups.com>,
        Marek Lindner <mareklindner@neomailbox.ch>,
        Simon Wunderlich <sw@simonwunderlich.de>,
        Antonio Quartulli <a@unstable.cc>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

batadv_netlink_get_ifindex() needs to make sure user passed
a correct u32 attribute.

syzbot reported :
BUG: KMSAN: uninit-value in batadv_netlink_dump_hardif+0x70d/0x880 net/batman-adv/netlink.c:968
CPU: 1 PID: 11705 Comm: syz-executor888 Not tainted 5.1.0+ #1
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x191/0x1f0 lib/dump_stack.c:113
 kmsan_report+0x130/0x2a0 mm/kmsan/kmsan.c:622
 __msan_warning+0x75/0xe0 mm/kmsan/kmsan_instr.c:310
 batadv_netlink_dump_hardif+0x70d/0x880 net/batman-adv/netlink.c:968
 genl_lock_dumpit+0xc6/0x130 net/netlink/genetlink.c:482
 netlink_dump+0xa84/0x1ab0 net/netlink/af_netlink.c:2253
 __netlink_dump_start+0xa3a/0xb30 net/netlink/af_netlink.c:2361
 genl_family_rcv_msg net/netlink/genetlink.c:550 [inline]
 genl_rcv_msg+0xfc1/0x1a40 net/netlink/genetlink.c:627
 netlink_rcv_skb+0x431/0x620 net/netlink/af_netlink.c:2486
 genl_rcv+0x63/0x80 net/netlink/genetlink.c:638
 netlink_unicast_kernel net/netlink/af_netlink.c:1311 [inline]
 netlink_unicast+0xf3e/0x1020 net/netlink/af_netlink.c:1337
 netlink_sendmsg+0x127e/0x12f0 net/netlink/af_netlink.c:1926
 sock_sendmsg_nosec net/socket.c:651 [inline]
 sock_sendmsg net/socket.c:661 [inline]
 ___sys_sendmsg+0xcc6/0x1200 net/socket.c:2260
 __sys_sendmsg net/socket.c:2298 [inline]
 __do_sys_sendmsg net/socket.c:2307 [inline]
 __se_sys_sendmsg+0x305/0x460 net/socket.c:2305
 __x64_sys_sendmsg+0x4a/0x70 net/socket.c:2305
 do_syscall_64+0xbc/0xf0 arch/x86/entry/common.c:291
 entry_SYSCALL_64_after_hwframe+0x63/0xe7
RIP: 0033:0x440209

Fixes: b60620cf567b ("batman-adv: netlink: hardif query")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reported-by: syzbot <syzkaller@googlegroups.com>
Cc: Marek Lindner <mareklindner@neomailbox.ch>
Cc: Simon Wunderlich <sw@simonwunderlich.de>
Cc: Antonio Quartulli <a@unstable.cc>
---
 net/batman-adv/netlink.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/batman-adv/netlink.c b/net/batman-adv/netlink.c
index 6f08fd122a8ddea43600c856a6be171dc7625d9c..7e052d6f759b659dbee0edd7546c367cf14b8e9e 100644
--- a/net/batman-adv/netlink.c
+++ b/net/batman-adv/netlink.c
@@ -164,7 +164,7 @@ batadv_netlink_get_ifindex(const struct nlmsghdr *nlh, int attrtype)
 {
 	struct nlattr *attr = nlmsg_find_attr(nlh, GENL_HDRLEN, attrtype);
 
-	return attr ? nla_get_u32(attr) : 0;
+	return (attr && nla_len(attr) == sizeof(u32)) ? nla_get_u32(attr) : 0;
 }
 
 /**
-- 
2.23.0.rc1.153.gdeed80330f-goog

