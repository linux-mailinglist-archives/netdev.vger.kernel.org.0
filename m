Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB0AC23FAEA
	for <lists+netdev@lfdr.de>; Sun,  9 Aug 2020 01:46:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728909AbgHHXp4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 8 Aug 2020 19:45:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:52538 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726688AbgHHXic (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 8 Aug 2020 19:38:32 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6F6E7207BB;
        Sat,  8 Aug 2020 23:38:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596929912;
        bh=/UEqwzic9EGyYzOQJVauOsfUX8Ho4axU58aHeAfs0dI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=O7o68cShqio1gGgw4l4d5fCj6JQjYapgoJXO/Z+R7Jki8gamlXMAAriO88V8aHZqA
         vNJEIlqOzayTMHUoyLtYIuqBN0cgkqJwBpb3D67HkDNGrLoQ8sKCPZ8gIpoIiLkh6M
         4W6wdZ7DM2Eu8hsL+SAOENZmDpWF3hp0YZGcLd9g=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Kees Cook <keescook@chromium.org>, Sasha Levin <sashal@kernel.org>,
        linux-kselftest@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: [PATCH AUTOSEL 5.7 49/58] seccomp: Fix ioctl number for SECCOMP_IOCTL_NOTIF_ID_VALID
Date:   Sat,  8 Aug 2020 19:37:15 -0400
Message-Id: <20200808233724.3618168-49-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200808233724.3618168-1-sashal@kernel.org>
References: <20200808233724.3618168-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Kees Cook <keescook@chromium.org>

[ Upstream commit 47e33c05f9f07cac3de833e531bcac9ae052c7ca ]

When SECCOMP_IOCTL_NOTIF_ID_VALID was first introduced it had the wrong
direction flag set. While this isn't a big deal as nothing currently
enforces these bits in the kernel, it should be defined correctly. Fix
the define and provide support for the old command until it is no longer
needed for backward compatibility.

Fixes: 6a21cc50f0c7 ("seccomp: add a return code to trap to userspace")
Signed-off-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/uapi/linux/seccomp.h                  | 3 ++-
 kernel/seccomp.c                              | 9 +++++++++
 tools/testing/selftests/seccomp/seccomp_bpf.c | 2 +-
 3 files changed, 12 insertions(+), 2 deletions(-)

diff --git a/include/uapi/linux/seccomp.h b/include/uapi/linux/seccomp.h
index c1735455bc536..965290f7dcc28 100644
--- a/include/uapi/linux/seccomp.h
+++ b/include/uapi/linux/seccomp.h
@@ -123,5 +123,6 @@ struct seccomp_notif_resp {
 #define SECCOMP_IOCTL_NOTIF_RECV	SECCOMP_IOWR(0, struct seccomp_notif)
 #define SECCOMP_IOCTL_NOTIF_SEND	SECCOMP_IOWR(1,	\
 						struct seccomp_notif_resp)
-#define SECCOMP_IOCTL_NOTIF_ID_VALID	SECCOMP_IOR(2, __u64)
+#define SECCOMP_IOCTL_NOTIF_ID_VALID	SECCOMP_IOW(2, __u64)
+
 #endif /* _UAPI_LINUX_SECCOMP_H */
diff --git a/kernel/seccomp.c b/kernel/seccomp.c
index 55a6184f59903..63e283c4c58eb 100644
--- a/kernel/seccomp.c
+++ b/kernel/seccomp.c
@@ -42,6 +42,14 @@
 #include <linux/uaccess.h>
 #include <linux/anon_inodes.h>
 
+/*
+ * When SECCOMP_IOCTL_NOTIF_ID_VALID was first introduced, it had the
+ * wrong direction flag in the ioctl number. This is the broken one,
+ * which the kernel needs to keep supporting until all userspaces stop
+ * using the wrong command number.
+ */
+#define SECCOMP_IOCTL_NOTIF_ID_VALID_WRONG_DIR	SECCOMP_IOR(2, __u64)
+
 enum notify_state {
 	SECCOMP_NOTIFY_INIT,
 	SECCOMP_NOTIFY_SENT,
@@ -1186,6 +1194,7 @@ static long seccomp_notify_ioctl(struct file *file, unsigned int cmd,
 		return seccomp_notify_recv(filter, buf);
 	case SECCOMP_IOCTL_NOTIF_SEND:
 		return seccomp_notify_send(filter, buf);
+	case SECCOMP_IOCTL_NOTIF_ID_VALID_WRONG_DIR:
 	case SECCOMP_IOCTL_NOTIF_ID_VALID:
 		return seccomp_notify_id_valid(filter, buf);
 	default:
diff --git a/tools/testing/selftests/seccomp/seccomp_bpf.c b/tools/testing/selftests/seccomp/seccomp_bpf.c
index c0aa46ce14f6c..c84c7b50331c6 100644
--- a/tools/testing/selftests/seccomp/seccomp_bpf.c
+++ b/tools/testing/selftests/seccomp/seccomp_bpf.c
@@ -180,7 +180,7 @@ struct seccomp_metadata {
 #define SECCOMP_IOCTL_NOTIF_RECV	SECCOMP_IOWR(0, struct seccomp_notif)
 #define SECCOMP_IOCTL_NOTIF_SEND	SECCOMP_IOWR(1,	\
 						struct seccomp_notif_resp)
-#define SECCOMP_IOCTL_NOTIF_ID_VALID	SECCOMP_IOR(2, __u64)
+#define SECCOMP_IOCTL_NOTIF_ID_VALID	SECCOMP_IOW(2, __u64)
 
 struct seccomp_notif {
 	__u64 id;
-- 
2.25.1

