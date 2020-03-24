Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 51918190D6E
	for <lists+netdev@lfdr.de>; Tue, 24 Mar 2020 13:31:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727578AbgCXMbC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Mar 2020 08:31:02 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:38084 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727256AbgCXMbB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Mar 2020 08:31:01 -0400
Received: by mail-pf1-f195.google.com with SMTP id z25so4867447pfa.5;
        Tue, 24 Mar 2020 05:31:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=nqAcdWRnqSA/uVQmjWL4caKhzvHsEqccflrG15Mc1BU=;
        b=rjcQwrEEwd38HKXiiRHyTNtX0owKMWahas2q3bAKpZ1vIA4OUp3hbVUqW1LGfxqMZr
         erGnJNkhR3tAMGTxniU/ZRotGBQvYFEQEFFDqSzeUTi0ZszrjcoraZE5ZTxWCYUZTmaY
         I8B9Htzw5eYOpCrniauwt4bO7n72EQtSYl9GjjcCR/KvuI0vLJZiIIQ/9fO5bOZnby0g
         3xnh2OnRis2zvZvVO/eeX59k5mwLZhLkV7EZbngbRoTb4nYOi1d8u18WdzfUd5z1KNKd
         yCWqU799wMfom4lGqpgo+ycYYv+YBAhE5C0/KiK2sKK5rc/0Rln9FPd61TFroyHQZ7mP
         hEwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=nqAcdWRnqSA/uVQmjWL4caKhzvHsEqccflrG15Mc1BU=;
        b=l+KECkUuPi4c2AZw+tTQFF2RQYogbCY9wT6x2OCmwjcnFmZtrQv6daOS30OsuCAGFU
         5g68YZXGatUA+WWJBRiroROeFUcLioAH/VvViYxDdOhs/GmwX3pf+I29EVlI3o6scphE
         AL+5h4EleqsK+B7OlBzwDt3UNZJmR41A6wgTdRjnIkOUuDv2mqN2cmaHlmg6wp4V528E
         WPw/QS+/V9GSnO94OUStqod7eOivY/H9i0gh3MtsGi4NsxJ2o9wOabIoUb3WDyh+9dWk
         7Qwr6FVBvfXCGC4VGn3bNQSigtDsk0/4PmxTpNpC4Ofg9oouYHwGc3b6G5AdjgsLitNN
         zHTg==
X-Gm-Message-State: ANhLgQ34aae9IL2Kf4KSIHzObJM2rQ8oICtr8IoHxPBvqnwoNDLJOprm
        l3PwFph2isHec2myixGwdyA=
X-Google-Smtp-Source: ADFU+vvf33TJmQrGUFdzHUfRsPxkmjO7EFt1Uq5CQXRJ7pqbjC9tsRCv1U6/9456hIJojqhMXy9JPA==
X-Received: by 2002:a63:fd0d:: with SMTP id d13mr23986197pgh.302.1585053059651;
        Tue, 24 Mar 2020 05:30:59 -0700 (PDT)
Received: from localhost.localdomain ([180.70.143.152])
        by smtp.gmail.com with ESMTPSA id v26sm2966546pfn.51.2020.03.24.05.30.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Mar 2020 05:30:58 -0700 (PDT)
From:   Taehee Yoo <ap420073@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, gregkh@linuxfoundation.org,
        rafael@kernel.org, j.vosburgh@gmail.com, vfalico@gmail.com,
        andy@greyhouse.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     ap420073@gmail.com, mitch.a.williams@intel.com
Subject: [PATCH net 1/3] class: add class_find_and_get_file_ns() helper function
Date:   Tue, 24 Mar 2020 12:30:52 +0000
Message-Id: <20200324123052.18904-1-ap420073@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The new helper function is to find and get a class file.
This function is useful for checking whether the class file is existing
or not. This function will be used by networking stack to
check "/sys/class/net/*" file.

Reported-by: syzbot+830c6dbfc71edc4f0b8f@syzkaller.appspotmail.com
Fixes: b76cdba9cdb2 ("[PATCH] bonding: add sysfs functionality to bonding (large)")
Signed-off-by: Taehee Yoo <ap420073@gmail.com>
---
 drivers/base/class.c         | 12 ++++++++++++
 include/linux/device/class.h |  4 +++-
 2 files changed, 15 insertions(+), 1 deletion(-)

diff --git a/drivers/base/class.c b/drivers/base/class.c
index bcd410e6d70a..dedf41f32f0d 100644
--- a/drivers/base/class.c
+++ b/drivers/base/class.c
@@ -105,6 +105,17 @@ void class_remove_file_ns(struct class *cls, const struct class_attribute *attr,
 		sysfs_remove_file_ns(&cls->p->subsys.kobj, &attr->attr, ns);
 }
 
+struct kernfs_node *class_find_and_get_file_ns(struct class *cls,
+					       const char *name,
+					       const void *ns)
+{
+	struct kernfs_node *kn = NULL;
+
+	if (cls)
+		kn = kernfs_find_and_get_ns(cls->p->subsys.kobj.sd, name, ns);
+	return kn;
+}
+
 static struct class *class_get(struct class *cls)
 {
 	if (cls)
@@ -580,6 +591,7 @@ int __init classes_init(void)
 
 EXPORT_SYMBOL_GPL(class_create_file_ns);
 EXPORT_SYMBOL_GPL(class_remove_file_ns);
+EXPORT_SYMBOL_GPL(class_find_and_get_file_ns);
 EXPORT_SYMBOL_GPL(class_unregister);
 EXPORT_SYMBOL_GPL(class_destroy);
 
diff --git a/include/linux/device/class.h b/include/linux/device/class.h
index e8d470c457d1..230cf2ce6d3f 100644
--- a/include/linux/device/class.h
+++ b/include/linux/device/class.h
@@ -209,7 +209,9 @@ extern int __must_check class_create_file_ns(struct class *class,
 extern void class_remove_file_ns(struct class *class,
 				 const struct class_attribute *attr,
 				 const void *ns);
-
+struct kernfs_node *class_find_and_get_file_ns(struct class *cls,
+					       const char *name,
+					       const void *ns);
 static inline int __must_check class_create_file(struct class *class,
 					const struct class_attribute *attr)
 {
-- 
2.17.1

