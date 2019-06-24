Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B78DD518AA
	for <lists+netdev@lfdr.de>; Mon, 24 Jun 2019 18:28:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730038AbfFXQ22 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jun 2019 12:28:28 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:36805 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728884AbfFXQ22 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Jun 2019 12:28:28 -0400
Received: by mail-pg1-f195.google.com with SMTP id f21so7406046pgi.3
        for <netdev@vger.kernel.org>; Mon, 24 Jun 2019 09:28:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=83z9MONIXRv9fBBn1KzHdssv0tegBm2CExMBDwk9bQw=;
        b=EIFFnYWlXLF0BEqdMqYG20aPVNojU1l7RF30JxVkmbB98K7FF6gOhgtIeSk7aI1hzQ
         yO2+oD+R9EqcauIPf16qiSzW7QFVoqIZzJk5/iWQuQYM6afOCpFcsB7/Zg1lNdrCPvHt
         kax8lbUsIZa3dbzxpvr4rITPSzPA4XWg/Flp68+TWSqhnqOlyoL95hBrm/cLo0hb0Gyp
         f7/dITp8FKGl2XXr6X90p4PbWL6QQ75uoCEkKVnGXs5XUliv8FTRaTX2JQw6zGGmzJAp
         1VycskLh1sRbc7wCYtgDmuQLV2WpkL6+agA+R26CIefVH3fOTKVzxKOLYfYdetHNdWRt
         oNiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=83z9MONIXRv9fBBn1KzHdssv0tegBm2CExMBDwk9bQw=;
        b=kMJQP7SGpbPP0rsfXRK14x4dXQ2bJ/9G6cZ/FxPqZS8/R/7qwmimt+rES1VSKysyoP
         tRNm2pdcjXydmGRrPwTf/AG+65A1smad0h+dwvlGATYbMlb/KNo8DJLpH8/XLqzPU5RY
         fZKNgRrbpY1BK9B616Hr/CJjb1625mGjZvkPM+2WnaQnYlHQ/c1rUaf/OkSrhcbl9Ix9
         ZuAjZVlAYg8kavKLz8dwmDQtX4HApzDiUco1fafS9nQCyPtDlPJnepk/C5dpsUvslGf/
         FrGS8MNnbbHaB9xZno9Un9/hO24T3QgAI3HXl90HzbxozgvjeGemr9zGeWJASsrldgBc
         +MlQ==
X-Gm-Message-State: APjAAAWb97jbw/sKqNsrO4VB+fvKoAXVWK6D4XWspl7H0sMB9zcPUgIQ
        kdMeqhCWjLWzQKFFQbtwjNvTjBr0
X-Google-Smtp-Source: APXvYqylrliEPCXf6k1P5k4XUbLBqv6VeEpmWsZNxNJn1fxjtuiyi3iWX5xqAlgkA+Mq3LVRGGFkcQ==
X-Received: by 2002:a63:c508:: with SMTP id f8mr34435737pgd.48.1561393707527;
        Mon, 24 Jun 2019 09:28:27 -0700 (PDT)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id q3sm10884826pgv.21.2019.06.24.09.28.26
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 24 Jun 2019 09:28:26 -0700 (PDT)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>
Cc:     davem@davemloft.net, Eric Dumazet <edumazet@google.com>,
        Jon Maloy <jon.maloy@ericsson.com>,
        Ying Xue <ying.xue@windriver.com>,
        tipc-discussion@lists.sourceforge.net,
        syzkaller-bugs@googlegroups.com
Subject: [PATCHv2 net] tipc: check msg->req data len in tipc_nl_compat_bearer_disable
Date:   Tue, 25 Jun 2019 00:28:19 +0800
Message-Id: <58c46f0c73a4c1aea970e52de69188e2dd20d3b4.1561393699.git.lucien.xin@gmail.com>
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

v1->v2:
  - add the missing Fixes tags per Eric's request.

Fixes: 0762216c0ad2 ("tipc: fix uninit-value in tipc_nl_compat_bearer_enable")
Fixes: 8b66fee7f8ee ("tipc: fix uninit-value in tipc_nl_compat_link_reset_stats")
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

