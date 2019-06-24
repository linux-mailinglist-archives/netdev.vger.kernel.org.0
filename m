Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B62A15040A
	for <lists+netdev@lfdr.de>; Mon, 24 Jun 2019 09:59:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727900AbfFXH7Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jun 2019 03:59:16 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:35689 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725916AbfFXH7Q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Jun 2019 03:59:16 -0400
Received: by mail-pf1-f193.google.com with SMTP id d126so7046765pfd.2
        for <netdev@vger.kernel.org>; Mon, 24 Jun 2019 00:59:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=MGJ6U38u9kg9A9w/pYRC62pm74NVACWkpq9XfaU8sY4=;
        b=WNDOkEETcZ89O+7+2ZBc5hk3kK61etFN6xXvRkZaeXiuURDsmp2lFCTUDl1hLqWyNG
         4OV2OEIq+RbeT0CVdnn7Hl3g+TdMh51WRmudLM2pK/YIr+wEOFXjTGgjqEmNBXD/7kxj
         pGfsMOG2XidZZ+slFgXWjOko3vx3wbaKOojOWHpmY6wJ6KLuVGr/kN8aFkrL3m9NjNrq
         cYkawDL+vm+DSTVwh7nC3UDl94dwSPRsE9CESazhlCyWdzgEIAXBtJy3Dlq62orgHyAM
         DrYeTXIVkh9QC9ZiNBo1LMjCq8CL/aRu9vU5zxmaFzNw0y1q8NdUfCC4vKdFOk2cpA8y
         zFkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=MGJ6U38u9kg9A9w/pYRC62pm74NVACWkpq9XfaU8sY4=;
        b=FDFMkUG8klOqzzGpoBWHWRf5WAWN92KHKulQViJ9lcBtjwHro/iz1pBGSEMHASO7yt
         /1osuuXRE6wedHwoxbV+/sZuBFXZ3tr45/qYv9wm2O2BrbZgqpvpaU8pJuTU7oj/LQW3
         Ih0MvmtDChksEIBzfeCyBbDrh+jW/T8OScYHEF48M7m0M3nN8XBXzzzteo3jHiQN2Kxq
         HNXjq/8GFHXdYoQQUNjbvnf+3x1m4zHnKK2VKlma7J8DsgTDKMbp6xYKfEwhmAejsva/
         1HW/n7VJUL1viZTKF3XgGHREpNlXrjLKCPK9sOdth/hQEYwfGbol8Tn1VKCLO4kcve7Z
         yntQ==
X-Gm-Message-State: APjAAAU1120YIv6phjgyb7QkyG7vhTdU9+kU4BK54MsHZPjORYozQLIc
        HY+1TjFXFIRV6WlxaH5zAVd+GcXp
X-Google-Smtp-Source: APXvYqxAprCQVcNrN4zWvDsHJYXXv3CuOZglLYpMRa5eO55s99aoRzd+cXWbW8sNaCxrgJZF46G1DA==
X-Received: by 2002:a63:85c6:: with SMTP id u189mr20442525pgd.451.1561363154898;
        Mon, 24 Jun 2019 00:59:14 -0700 (PDT)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id r15sm12285518pfh.121.2019.06.24.00.59.13
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 24 Jun 2019 00:59:14 -0700 (PDT)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>
Cc:     davem@davemloft.net, Jon Maloy <jon.maloy@ericsson.com>,
        Ying Xue <ying.xue@windriver.com>,
        tipc-discussion@lists.sourceforge.net,
        syzkaller-bugs@googlegroups.com
Subject: [PATCH net] tipc: check msg->req data len in tipc_nl_compat_bearer_disable
Date:   Mon, 24 Jun 2019 15:59:06 +0800
Message-Id: <4fd888cb669434b00dce24ace4410524665be285.1561363146.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch is to fix an uninit-value issue, reported by syzbot:

  BUG: KMSAN: uninit-value in memchr+0xce/0x110 lib/string.c:981
  Call Trace:
    __dump_stack lib/dump_stack.c:77 [inline]
    dump_stack+0x191/0x1f0 lib/dump_stack.c:113
    kmsan_report+0x130/0x2a0 mm/kmsan/kmsan.c:622
    __msan_warning+0x75/0xe0 mm/kmsan/kmsan_instr.c:310
    memchr+0xce/0x110 lib/string.c:981
    string_is_valid net/tipc/netlink_compat.c:176 [inline]
    tipc_nl_compat_bearer_disable+0x2a1/0x480 net/tipc/netlink_compat.c:449
    __tipc_nl_compat_doit net/tipc/netlink_compat.c:327 [inline]
    tipc_nl_compat_doit+0x3ac/0xb00 net/tipc/netlink_compat.c:360
    tipc_nl_compat_handle net/tipc/netlink_compat.c:1178 [inline]
    tipc_nl_compat_recv+0x1b1b/0x27b0 net/tipc/netlink_compat.c:1281

TLV_GET_DATA_LEN() may return a negtive int value, which will be
used as size_t (becoming a big unsigned long) passed into memchr,
cause this issue.

Similar to what it does in tipc_nl_compat_bearer_enable(), this
fix is to return -EINVAL when TLV_GET_DATA_LEN() is negtive in
tipc_nl_compat_bearer_disable(), as well as in
tipc_nl_compat_link_stat_dump() and tipc_nl_compat_link_reset_stats().

Reported-by: syzbot+30eaa8bf392f7fafffaf@syzkaller.appspotmail.com
Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 net/tipc/netlink_compat.c | 18 +++++++++++++++---
 1 file changed, 15 insertions(+), 3 deletions(-)

diff --git a/net/tipc/netlink_compat.c b/net/tipc/netlink_compat.c
index c6a04c0..cf15506 100644
--- a/net/tipc/netlink_compat.c
+++ b/net/tipc/netlink_compat.c
@@ -445,7 +445,11 @@ static int tipc_nl_compat_bearer_disable(struct tipc_nl_compat_cmd_doit *cmd,
 	if (!bearer)
 		return -EMSGSIZE;
 
-	len = min_t(int, TLV_GET_DATA_LEN(msg->req), TIPC_MAX_BEARER_NAME);
+	len = TLV_GET_DATA_LEN(msg->req);
+	if (len <= 0)
+		return -EINVAL;
+
+	len = min_t(int, len, TIPC_MAX_BEARER_NAME);
 	if (!string_is_valid(name, len))
 		return -EINVAL;
 
@@ -539,7 +543,11 @@ static int tipc_nl_compat_link_stat_dump(struct tipc_nl_compat_msg *msg,
 
 	name = (char *)TLV_DATA(msg->req);
 
-	len = min_t(int, TLV_GET_DATA_LEN(msg->req), TIPC_MAX_LINK_NAME);
+	len = TLV_GET_DATA_LEN(msg->req);
+	if (len <= 0)
+		return -EINVAL;
+
+	len = min_t(int, len, TIPC_MAX_BEARER_NAME);
 	if (!string_is_valid(name, len))
 		return -EINVAL;
 
@@ -817,7 +825,11 @@ static int tipc_nl_compat_link_reset_stats(struct tipc_nl_compat_cmd_doit *cmd,
 	if (!link)
 		return -EMSGSIZE;
 
-	len = min_t(int, TLV_GET_DATA_LEN(msg->req), TIPC_MAX_LINK_NAME);
+	len = TLV_GET_DATA_LEN(msg->req);
+	if (len <= 0)
+		return -EINVAL;
+
+	len = min_t(int, len, TIPC_MAX_BEARER_NAME);
 	if (!string_is_valid(name, len))
 		return -EINVAL;
 
-- 
2.1.0

