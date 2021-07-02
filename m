Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A2E5C3B9BDE
	for <lists+netdev@lfdr.de>; Fri,  2 Jul 2021 07:06:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235118AbhGBFIt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Jul 2021 01:08:49 -0400
Received: from mail-pf1-f177.google.com ([209.85.210.177]:39693 "EHLO
        mail-pf1-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235042AbhGBFIf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Jul 2021 01:08:35 -0400
Received: by mail-pf1-f177.google.com with SMTP id b12so6849841pfv.6;
        Thu, 01 Jul 2021 22:06:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=yb7yd96lVQdzsAfi54y0XMr48MTe0F0qlcJZv2yL6qg=;
        b=INugmE317P0sozjHcViV6CvnrWg4hGKMKZnu4MISS6csJPHuKilZjNv+qKAc9pbQMA
         F9waEiIyZYDvIBaW90zTJ2HaCWq+K0U5UHSjTiOwVje88VDAvQ4ViufcYu4nAo7dnccP
         Mf0H5WpWEvtqHWGr9FXMdseCatQu0EsTe/21poTWXXLyzzs/s5tfcP1Ognp/OVAVD/O1
         bFq6vNEk+LTvNPQgEg8CED5GAQfAT/uWPbpij62IeGnoRcp1VVqCKhIeHRc7v+WbI4Xb
         zx44WUh6Ft9uqYGiMI9vWaNWTI1+7j15djpoUsWesWoIqdQKP3dp2WfKsL/l1tDiYyEA
         msYQ==
X-Gm-Message-State: AOAM530SO8CyYaJTII/2pGf4SxJCR3cne+TsBwdLRYiG+6ooVnpirxKJ
        K0ghsjqMBn8wZHZl496Bo4A=
X-Google-Smtp-Source: ABdhPJz/xW1JT7tQMx5UpXTUIanmhykMXdMIGdizdHoHH8iToRv8f+jdEVj3jS05k5GRICWmyHtehQ==
X-Received: by 2002:a65:5086:: with SMTP id r6mr1661647pgp.237.1625202363120;
        Thu, 01 Jul 2021 22:06:03 -0700 (PDT)
Received: from localhost ([191.96.121.144])
        by smtp.gmail.com with ESMTPSA id x22sm1768206pfr.214.2021.07.01.22.06.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 01 Jul 2021 22:06:02 -0700 (PDT)
From:   Luis Chamberlain <mcgrof@kernel.org>
To:     gregkh@linuxfoundation.org, tj@kernel.org, shuah@kernel.org,
        akpm@linux-foundation.org, rafael@kernel.org, davem@davemloft.net,
        kuba@kernel.org, ast@kernel.org, andriin@fb.com,
        daniel@iogearbox.net, atenart@kernel.org, alobakin@pm.me,
        weiwan@google.com, ap420073@gmail.com
Cc:     jeyu@kernel.org, ngupta@vflare.org,
        sergey.senozhatsky.work@gmail.com, minchan@kernel.org,
        mcgrof@kernel.org, axboe@kernel.dk, mbenes@suse.com,
        jpoimboe@redhat.com, tglx@linutronix.de, keescook@chromium.org,
        jikos@kernel.org, rostedt@goodmis.org, peterz@infradead.org,
        linux-block@vger.kernel.org, netdev@vger.kernel.org,
        linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 4/4] test_sysfs: demonstrate deadlock fix
Date:   Thu,  1 Jul 2021 22:05:43 -0700
Message-Id: <20210702050543.2693141-5-mcgrof@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210702050543.2693141-1-mcgrof@kernel.org>
References: <20210702050543.2693141-1-mcgrof@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Two mechanisms have been proposed to fix the sysfs deadlock issue.
The first approach proposed is by optionally allowing drivers to specify
a module and augmenting attributes with module information [0]. A secondary
approach is to use macros on drivers which needs this, in the meantime. This
embraces the secondary approach, in lieu of agreement of a generic solution.
This should be enough to allow for room for experimentation and demonstration
of the issue.

This then also enables the two test cases which we have disabled as
otherwise they would deadlock your system.

./tools/testing/selftests/sysfs/sysfs.sh -t 0027
Running test: sysfs_test_0027 - run #0
Test for possible rmmod deadlock while writing x ... ok

./tools/testing/selftests/sysfs/sysfs.sh -t 0028
Running test: sysfs_test_0028 - run #0
Test for possible rmmod deadlock using rtnl_lock while writing x ... ok

[0] https://lkml.kernel.org/r/20210401235925.GR4332@42.do-not-panic.com

Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
---
 lib/test_sysfs.c                       | 71 ++++++++++++++++++++++----
 tools/testing/selftests/sysfs/sysfs.sh |  4 +-
 2 files changed, 64 insertions(+), 11 deletions(-)

diff --git a/lib/test_sysfs.c b/lib/test_sysfs.c
index 96af668edd4a..0a77f2887c87 100644
--- a/lib/test_sysfs.c
+++ b/lib/test_sysfs.c
@@ -94,6 +94,59 @@ MODULE_PARM_DESC(enable_completion_on_rmmod,
 		 "enable sending a kernfs completion on rmmod");
 #endif
 
+#undef __ATTR_RO
+#undef __ATTR_RW
+#undef __ATTR_WO
+
+#define __ATTR_RO(_name) {						\
+	.attr	= { .name = __stringify(_name), .mode = 0444 },		\
+	.show	= module_##_name##_show,						\
+}
+#define __ATTR_RW(_name) __ATTR(_name, 0644, module_##_name##_show, module_##_name##_store)
+#define __ATTR_WO(_name) {						\
+	.attr	= { .name = __stringify(_name), .mode = 0200 },		\
+	.store	= module_##_name##_store,				\
+}
+
+#define MODULE_DEVICE_ATTR_FUNC_STORE(_name) \
+static ssize_t module_ ## _name ## _store(struct device *dev, \
+				   struct device_attribute *attr, \
+				   const char *buf, size_t len) \
+{ \
+	ssize_t __ret; \
+	if (!try_module_get(THIS_MODULE)) \
+		return -ENODEV; \
+	__ret = _name ## _store(dev, attr, buf, len); \
+	module_put(THIS_MODULE); \
+	return __ret; \
+}
+
+#define MODULE_DEVICE_ATTR_FUNC_SHOW(_name) \
+static ssize_t module_ ## _name ## _show(struct device *dev, \
+					 struct device_attribute *attr, \
+					 char *buf) \
+{ \
+	ssize_t __ret; \
+	if (!try_module_get(THIS_MODULE)) \
+		return -ENODEV; \
+	__ret = _name ## _show(dev, attr, buf); \
+	module_put(THIS_MODULE); \
+	return __ret; \
+}
+
+#define MODULE_DEVICE_ATTR_WO(_name) \
+MODULE_DEVICE_ATTR_FUNC_STORE(_name); \
+static DEVICE_ATTR_WO(_name)
+
+#define MODULE_DEVICE_ATTR_RW(_name) \
+MODULE_DEVICE_ATTR_FUNC_STORE(_name); \
+MODULE_DEVICE_ATTR_FUNC_SHOW(_name); \
+static DEVICE_ATTR_RW(_name)
+
+#define MODULE_DEVICE_ATTR_RO(_name) \
+MODULE_DEVICE_ATTR_FUNC_SHOW(_name); \
+static DEVICE_ATTR_RO(_name)
+
 static int sysfs_test_major;
 
 /**
@@ -311,7 +364,7 @@ static ssize_t config_show(struct device *dev,
 
 	return len;
 }
-static DEVICE_ATTR_RO(config);
+MODULE_DEVICE_ATTR_RO(config);
 
 static ssize_t reset_store(struct device *dev,
 			   struct device_attribute *attr,
@@ -336,7 +389,7 @@ static ssize_t reset_store(struct device *dev,
 
 	return count;
 }
-static DEVICE_ATTR_WO(reset);
+MODULE_DEVICE_ATTR_WO(reset);
 
 static void test_dev_busy_alloc(struct sysfs_test_device *test_dev)
 {
@@ -388,7 +441,7 @@ static ssize_t test_dev_x_show(struct device *dev,
 
 	return ret;
 }
-static DEVICE_ATTR_RW(test_dev_x);
+MODULE_DEVICE_ATTR_RW(test_dev_x);
 
 static ssize_t test_dev_y_store(struct device *dev,
 				struct device_attribute *attr,
@@ -432,7 +485,7 @@ static ssize_t test_dev_y_show(struct device *dev,
 
 	return ret;
 }
-static DEVICE_ATTR_RW(test_dev_y);
+MODULE_DEVICE_ATTR_RW(test_dev_y);
 
 static ssize_t config_enable_lock_store(struct device *dev,
 					struct device_attribute *attr,
@@ -477,7 +530,7 @@ static ssize_t config_enable_lock_show(struct device *dev,
 
 	return ret;
 }
-static DEVICE_ATTR_RW(config_enable_lock);
+MODULE_DEVICE_ATTR_RW(config_enable_lock);
 
 static ssize_t config_enable_lock_on_rmmod_store(struct device *dev,
 						 struct device_attribute *attr,
@@ -519,7 +572,7 @@ static ssize_t config_enable_lock_on_rmmod_show(struct device *dev,
 
 	return ret;
 }
-static DEVICE_ATTR_RW(config_enable_lock_on_rmmod);
+MODULE_DEVICE_ATTR_RW(config_enable_lock_on_rmmod);
 
 static ssize_t config_use_rtnl_lock_store(struct device *dev,
 					  struct device_attribute *attr,
@@ -558,7 +611,7 @@ static ssize_t config_use_rtnl_lock_show(struct device *dev,
 
 	return snprintf(buf, PAGE_SIZE, "%d\n", config->use_rtnl_lock);
 }
-static DEVICE_ATTR_RW(config_use_rtnl_lock);
+MODULE_DEVICE_ATTR_RW(config_use_rtnl_lock);
 
 static ssize_t config_write_delay_msec_y_store(struct device *dev,
 					       struct device_attribute *attr,
@@ -592,7 +645,7 @@ static ssize_t config_write_delay_msec_y_show(struct device *dev,
 
 	return snprintf(buf, PAGE_SIZE, "%d\n", config->write_delay_msec_y);
 }
-static DEVICE_ATTR_RW(config_write_delay_msec_y);
+MODULE_DEVICE_ATTR_RW(config_write_delay_msec_y);
 
 static ssize_t config_enable_busy_alloc_store(struct device *dev,
 					      struct device_attribute *attr,
@@ -626,7 +679,7 @@ static ssize_t config_enable_busy_alloc_show(struct device *dev,
 
 	return snprintf(buf, PAGE_SIZE, "%d\n", config->enable_busy_alloc);
 }
-static DEVICE_ATTR_RW(config_enable_busy_alloc);
+MODULE_DEVICE_ATTR_RW(config_enable_busy_alloc);
 
 #define TEST_SYSFS_DEV_ATTR(name)		(&dev_attr_##name.attr)
 
diff --git a/tools/testing/selftests/sysfs/sysfs.sh b/tools/testing/selftests/sysfs/sysfs.sh
index f27ea61e0e95..2de9f37cb00b 100755
--- a/tools/testing/selftests/sysfs/sysfs.sh
+++ b/tools/testing/selftests/sysfs/sysfs.sh
@@ -60,8 +60,8 @@ ALL_TESTS="$ALL_TESTS 0023:1:1:test_dev_y:block"
 ALL_TESTS="$ALL_TESTS 0024:1:1:test_dev_x:block"
 ALL_TESTS="$ALL_TESTS 0025:1:1:test_dev_y:block"
 ALL_TESTS="$ALL_TESTS 0026:1:1:test_dev_y:block"
-ALL_TESTS="$ALL_TESTS 0027:1:0:test_dev_x:block" # deadlock test
-ALL_TESTS="$ALL_TESTS 0028:1:0:test_dev_x:block" # deadlock test with rntl_lock
+ALL_TESTS="$ALL_TESTS 0027:1:1:test_dev_x:block" # deadlock test
+ALL_TESTS="$ALL_TESTS 0028:1:1:test_dev_x:block" # deadlock test with rntl_lock
 ALL_TESTS="$ALL_TESTS 0029:1:1:test_dev_x:block" # kernfs race removal of store
 ALL_TESTS="$ALL_TESTS 0030:1:1:test_dev_x:block" # kernfs race removal before mutex
 ALL_TESTS="$ALL_TESTS 0031:1:1:test_dev_x:block" # kernfs race removal after mutex
-- 
2.27.0

