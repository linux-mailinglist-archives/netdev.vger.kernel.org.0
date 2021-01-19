Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 29A172FB47E
	for <lists+netdev@lfdr.de>; Tue, 19 Jan 2021 09:47:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727781AbhASIrI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jan 2021 03:47:08 -0500
Received: from m9785.mail.qiye.163.com ([220.181.97.85]:27372 "EHLO
        m9785.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726296AbhASIrB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Jan 2021 03:47:01 -0500
Received: from localhost.localdomain (unknown [123.59.132.129])
        by m9785.mail.qiye.163.com (Hmail) with ESMTPA id 925DE5C1E43;
        Tue, 19 Jan 2021 16:34:59 +0800 (CST)
From:   wenxu@ucloud.cn
To:     marcelo.leitner@gmail.com, dsahern@gmail.com
Cc:     netdev@vger.kernel.org
Subject: [PATCH iproute2-next] tc: flower: add tc conntrack inv ct_state support
Date:   Tue, 19 Jan 2021 16:34:59 +0800
Message-Id: <1611045299-764-1-git-send-email-wenxu@ucloud.cn>
X-Mailer: git-send-email 1.8.3.1
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgYFAkeWUFZS1VLWVdZKFlBSUI3V1ktWUFJV1kPCR
        oVCBIfWUFZGR1JGRgZHRlKGR1LVkpNSkpLT05JQkJNQkJVGRETFhoSFyQUDg9ZV1kWGg8SFR0UWU
        FZT0tIVUpKS0hKTFVLWQY+
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6OU06LRw5OD0zTRQQPR5NNUI8
        NUgKCjVVSlVKTUpKS09OSUJCQ09PVTMWGhIXVQweFQMOOw4YFxQOH1UYFUVZV1kSC1lBWUpJSFVO
        QlVKSElVSklCWVdZCAFZQUlKTU43Bg++
X-HM-Tid: 0a7719c865a52087kuqy925de5c1e43
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: wenxu <wenxu@ucloud.cn>

Matches on conntrack inv ct_state.

Signed-off-by: wenxu <wenxu@ucloud.cn>
---
 include/uapi/linux/pkt_cls.h | 1 +
 man/man8/tc-flower.8         | 2 ++
 tc/f_flower.c                | 1 +
 3 files changed, 4 insertions(+)

diff --git a/include/uapi/linux/pkt_cls.h b/include/uapi/linux/pkt_cls.h
index ee95f42..709668e 100644
--- a/include/uapi/linux/pkt_cls.h
+++ b/include/uapi/linux/pkt_cls.h
@@ -591,6 +591,7 @@ enum {
 	TCA_FLOWER_KEY_CT_FLAGS_ESTABLISHED = 1 << 1, /* Part of an existing connection. */
 	TCA_FLOWER_KEY_CT_FLAGS_RELATED = 1 << 2, /* Related to an established connection. */
 	TCA_FLOWER_KEY_CT_FLAGS_TRACKED = 1 << 3, /* Conntrack has occurred. */
+	TCA_FLOWER_KEY_CT_FLAGS_INVALID = 1 << 4, /* Conntrack is invalid. */
 };
 
 enum {
diff --git a/man/man8/tc-flower.8 b/man/man8/tc-flower.8
index 1a76b37..8de68d1 100644
--- a/man/man8/tc-flower.8
+++ b/man/man8/tc-flower.8
@@ -387,6 +387,8 @@ new - New connection.
 .TP
 est - Established connection.
 .TP
+inv - The packet is associated with no known connection.
+.TP
 Example: +trk+est
 .RE
 .TP
diff --git a/tc/f_flower.c b/tc/f_flower.c
index 1fe0ef4..489c0d7 100644
--- a/tc/f_flower.c
+++ b/tc/f_flower.c
@@ -345,6 +345,7 @@ static struct flower_ct_states {
 	{ "trk", TCA_FLOWER_KEY_CT_FLAGS_TRACKED },
 	{ "new", TCA_FLOWER_KEY_CT_FLAGS_NEW },
 	{ "est", TCA_FLOWER_KEY_CT_FLAGS_ESTABLISHED },
+	{ "inv", TCA_FLOWER_KEY_CT_FLAGS_INVALID},
 };
 
 static int flower_parse_ct_state(char *str, struct nlmsghdr *n)
-- 
1.8.3.1

