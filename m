Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 43FD72FC884
	for <lists+netdev@lfdr.de>; Wed, 20 Jan 2021 04:12:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730536AbhATDKk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jan 2021 22:10:40 -0500
Received: from m9785.mail.qiye.163.com ([220.181.97.85]:23304 "EHLO
        m9785.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728716AbhATDB6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Jan 2021 22:01:58 -0500
Received: from localhost.localdomain (unknown [123.59.132.129])
        by m9785.mail.qiye.163.com (Hmail) with ESMTPA id 3AE005C1DEE;
        Wed, 20 Jan 2021 10:52:13 +0800 (CST)
From:   wenxu@ucloud.cn
To:     marcelo.leitner@gmail.com, dsahern@gmail.com
Cc:     netdev@vger.kernel.org
Subject: [PATCH iproute2-next v2] tc: flower: add tc conntrack inv ct_state support
Date:   Wed, 20 Jan 2021 10:52:12 +0800
Message-Id: <1611111132-25552-1-git-send-email-wenxu@ucloud.cn>
X-Mailer: git-send-email 1.8.3.1
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgYFAkeWUFZS1VLWVdZKFlBSUI3V1ktWUFJV1kPCR
        oVCBIfWUFZH0oZH0sdGkwdGE4fVkpNSkpKSkpKSEhISkpVGRETFhoSFyQUDg9ZV1kWGg8SFR0UWU
        FZT0tIVUpKS0hNSlVLWQY+
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6NRw6TQw5OT02HBQQNxgLGjc1
        AzwKCSJVSlVKTUpKSkpKSkhITkhNVTMWGhIXVQweFQMOOw4YFxQOH1UYFUVZV1kSC1lBWUpJSFVO
        QlVKSElVSklCWVdZCAFZQUlJSUw3Bg++
X-HM-Tid: 0a771db4f04d2087kuqy3ae005c1dee
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: wenxu <wenxu@ucloud.cn>

Matches on conntrack inv ct_state.

Signed-off-by: wenxu <wenxu@ucloud.cn>
---
v2: change the description

 include/uapi/linux/pkt_cls.h | 1 +
 man/man8/tc-flower.8         | 2 ++
 tc/f_flower.c                | 1 +
 3 files changed, 4 insertions(+)

diff --git a/include/uapi/linux/pkt_cls.h b/include/uapi/linux/pkt_cls.h
index 449a639..e8f2aed 100644
--- a/include/uapi/linux/pkt_cls.h
+++ b/include/uapi/linux/pkt_cls.h
@@ -563,6 +563,7 @@ enum {
 	TCA_FLOWER_KEY_CT_FLAGS_ESTABLISHED = 1 << 1, /* Part of an existing connection. */
 	TCA_FLOWER_KEY_CT_FLAGS_RELATED = 1 << 2, /* Related to an established connection. */
 	TCA_FLOWER_KEY_CT_FLAGS_TRACKED = 1 << 3, /* Conntrack has occurred. */
+	TCA_FLOWER_KEY_CT_FLAGS_INVALID = 1 << 4, /* Conntrack is invalid. */
 };
 
 enum {
diff --git a/man/man8/tc-flower.8 b/man/man8/tc-flower.8
index eb9eb5f..f90117b 100644
--- a/man/man8/tc-flower.8
+++ b/man/man8/tc-flower.8
@@ -312,6 +312,8 @@ new - New connection.
 .TP
 est - Established connection.
 .TP
+inv - The state is invalid. The packet couldn't be associated to a connection.
+.TP
 Example: +trk+est
 .RE
 .TP
diff --git a/tc/f_flower.c b/tc/f_flower.c
index 9d59d71..7d2df9d 100644
--- a/tc/f_flower.c
+++ b/tc/f_flower.c
@@ -340,6 +340,7 @@ static struct flower_ct_states {
 	{ "trk", TCA_FLOWER_KEY_CT_FLAGS_TRACKED },
 	{ "new", TCA_FLOWER_KEY_CT_FLAGS_NEW },
 	{ "est", TCA_FLOWER_KEY_CT_FLAGS_ESTABLISHED },
+	{ "inv", TCA_FLOWER_KEY_CT_FLAGS_INVALID},
 };
 
 static int flower_parse_ct_state(char *str, struct nlmsghdr *n)
-- 
1.8.3.1

