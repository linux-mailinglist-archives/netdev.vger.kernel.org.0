Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 60C743B9BDA
	for <lists+netdev@lfdr.de>; Fri,  2 Jul 2021 07:06:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235075AbhGBFIk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Jul 2021 01:08:40 -0400
Received: from mail-pl1-f181.google.com ([209.85.214.181]:33589 "EHLO
        mail-pl1-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235003AbhGBFIb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Jul 2021 01:08:31 -0400
Received: by mail-pl1-f181.google.com with SMTP id f11so5010459plg.0;
        Thu, 01 Jul 2021 22:05:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=4FAlwqE5abcbNbARikw4H/w3FhoLS+d1SpBZUryZHXE=;
        b=Du+WxiaQJWHxuO0mTWeBkJUmL9QF+n6GlMXsp/ObXfSLRF965EpaF568f/tqukch5U
         If5VgUCVO0USx/aGcugi84GekdU9bk8kEBncLX9dh8ICDkYZP7Lwr39noHVsfMx93QvO
         SsFWLNChfR1O0XtWAoZx5FQ/vv0TshiXMw7BiP4Bov/dJMQ89O2zGoqxJ7HOUxQ/hM0n
         W2+IZ6j6GcrxcaWLXU/UDQYaXcW6w79oh7GfaG2TEnY+xBn6i1CkSd+HCvjtT0bdXiww
         HHtvrEajsJuHUfUECq7pm4Ueqi3WsyxXXfJL6NgpRUJnPw63JcZZ88sRSopS1GBiXLbf
         lkRw==
X-Gm-Message-State: AOAM5309OlXxg6I73rxjOhGADU0YYOd6CbMSuMqhv3P72Vs+Mrk3fXkr
        P0zDVutVzp2LC6HXHtfq3Pg=
X-Google-Smtp-Source: ABdhPJyCOgxuaUma+YJ2cqUlJwByO+Ym7oGxM3ZykqbwzmKTRiezUsqXJuyFPFoFdDnmHxf8H99lRw==
X-Received: by 2002:a17:902:74c7:b029:129:2e87:a869 with SMTP id f7-20020a17090274c7b02901292e87a869mr3014920plt.71.1625202359400;
        Thu, 01 Jul 2021 22:05:59 -0700 (PDT)
Received: from localhost ([191.96.121.144])
        by smtp.gmail.com with ESMTPSA id a9sm1617809pfv.185.2021.07.01.22.05.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 01 Jul 2021 22:05:58 -0700 (PDT)
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
Subject: [PATCH 3/4] test_sysfs: add support to use kernfs failure injection
Date:   Thu,  1 Jul 2021 22:05:42 -0700
Message-Id: <20210702050543.2693141-4-mcgrof@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210702050543.2693141-1-mcgrof@kernel.org>
References: <20210702050543.2693141-1-mcgrof@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This extends test_sysfs with support for using the failure injection
wait completion and knobs to force a few race conditions which
demonstrates that kernfs active reference protection is sufficient
for kobject / device protection at higher layers.

This adds 4 new tests which tries to remove the device attribute
store operation in 4 different situations:

  1) at the start of kernfs_kernfs_fop_write_iter()
  2) before the of->mutex is held in kernfs_kernfs_fop_write_iter()
  3) after the of->mutex is held in kernfs_kernfs_fop_write_iter()
  4) after the kernfs node active reference is taken

A write fails in call cases.

No null dereferences are reproduced, even though this has been observed
in some complex testing cases [0]. If this issue really exists we should
have enough tools on the sysfs_test toolbox now to try to reproduce
this easily without having to poke around other drivers.

[0] https://lkml.kernel.org/r/20210623215007.862787-1-mcgrof@kernel.org

Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
---
 lib/Kconfig.debug                      |   3 +
 lib/test_sysfs.c                       |  31 +++++
 tools/testing/selftests/sysfs/config   |   3 +
 tools/testing/selftests/sysfs/sysfs.sh | 174 +++++++++++++++++++++++++
 4 files changed, 211 insertions(+)

diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index 9d3c0d0db0f3..61bf0bad15ec 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -2356,6 +2356,9 @@ config TEST_SYSCTL
 config TEST_SYSFS
 	tristate "sysfs test driver"
 	depends on SYSFS
+	select FAULT_INJECTION
+	select FAULT_INJECTION_DEBUG_FS
+	select FAIL_KERNFS_KNOBS
 	help
 	  This builds the "test_sysfs" module. This driver enables to test the
 	  sysfs file system safely without affecting production knobs which
diff --git a/lib/test_sysfs.c b/lib/test_sysfs.c
index 8e844e30e8f9..96af668edd4a 100644
--- a/lib/test_sysfs.c
+++ b/lib/test_sysfs.c
@@ -38,6 +38,11 @@
 #include <linux/rtnetlink.h>
 #include <linux/genhd.h>
 #include <linux/blkdev.h>
+#include <linux/kernfs.h>
+
+#ifdef CONFIG_FAIL_KERNFS_KNOBS
+MODULE_IMPORT_NS(KERNFS_DEBUG_PRIVATE);
+#endif
 
 static bool enable_lock;
 module_param(enable_lock, bool_enable_only, 0644);
@@ -82,6 +87,13 @@ static bool enable_verbose_rmmod;
 module_param(enable_verbose_rmmod, bool_enable_only, 0644);
 MODULE_PARM_DESC(enable_verbose_rmmod, "enable verbose print messages on rmmod");
 
+#ifdef CONFIG_FAIL_KERNFS_KNOBS
+static bool enable_completion_on_rmmod;
+module_param(enable_completion_on_rmmod, bool_enable_only, 0644);
+MODULE_PARM_DESC(enable_completion_on_rmmod,
+		 "enable sending a kernfs completion on rmmod");
+#endif
+
 static int sysfs_test_major;
 
 /**
@@ -289,6 +301,12 @@ static ssize_t config_show(struct device *dev,
 			"enable_verbose_writes:\t%s\n",
 			enable_verbose_writes ? "true" : "false");
 
+#ifdef CONFIG_FAIL_KERNFS_KNOBS
+	len += snprintf(buf+len, PAGE_SIZE - len,
+			"enable_completion_on_rmmod:\t%s\n",
+			enable_completion_on_rmmod ? "true" : "false");
+#endif
+
 	test_dev_config_unlock(test_dev);
 
 	return len;
@@ -936,10 +954,23 @@ static int __init test_sysfs_init(void)
 }
 module_init(test_sysfs_init);
 
+#ifdef CONFIG_FAIL_KERNFS_KNOBS
+/* The goal is to race our device removal with a pending kernfs -> store call */
+static void test_sysfs_kernfs_send_completion_rmmod(void)
+{
+	if (!enable_completion_on_rmmod)
+		return;
+	complete(&kernfs_debug_wait_completion);
+}
+#else
+static inline void test_sysfs_kernfs_send_completion_rmmod(void) {}
+#endif
+
 static void __exit test_sysfs_exit(void)
 {
 	if (enable_debugfs)
 		debugfs_remove(debugfs_dir);
+	test_sysfs_kernfs_send_completion_rmmod();
 	if (delay_rmmod_ms)
 		msleep(delay_rmmod_ms);
 	unregister_test_dev_sysfs(first_test_dev);
diff --git a/tools/testing/selftests/sysfs/config b/tools/testing/selftests/sysfs/config
index 9196f452ecd5..2876a229f95b 100644
--- a/tools/testing/selftests/sysfs/config
+++ b/tools/testing/selftests/sysfs/config
@@ -1,2 +1,5 @@
 CONFIG_SYSFS=m
 CONFIG_TEST_SYSFS=m
+CONFIG_FAULT_INJECTION=y
+CONFIG_FAULT_INJECTION_DEBUG_FS=y
+CONFIG_FAIL_KERNFS_KNOBS=y
diff --git a/tools/testing/selftests/sysfs/sysfs.sh b/tools/testing/selftests/sysfs/sysfs.sh
index 681b27579f6f..f27ea61e0e95 100755
--- a/tools/testing/selftests/sysfs/sysfs.sh
+++ b/tools/testing/selftests/sysfs/sysfs.sh
@@ -62,6 +62,10 @@ ALL_TESTS="$ALL_TESTS 0025:1:1:test_dev_y:block"
 ALL_TESTS="$ALL_TESTS 0026:1:1:test_dev_y:block"
 ALL_TESTS="$ALL_TESTS 0027:1:0:test_dev_x:block" # deadlock test
 ALL_TESTS="$ALL_TESTS 0028:1:0:test_dev_x:block" # deadlock test with rntl_lock
+ALL_TESTS="$ALL_TESTS 0029:1:1:test_dev_x:block" # kernfs race removal of store
+ALL_TESTS="$ALL_TESTS 0030:1:1:test_dev_x:block" # kernfs race removal before mutex
+ALL_TESTS="$ALL_TESTS 0031:1:1:test_dev_x:block" # kernfs race removal after mutex
+ALL_TESTS="$ALL_TESTS 0032:1:1:test_dev_x:block" # kernfs race removal after active
 
 allow_user_defaults()
 {
@@ -92,6 +96,9 @@ allow_user_defaults()
 	if [ -z $SYSFS_DEBUGFS_DIR ]; then
 		SYSFS_DEBUGFS_DIR="/sys/kernel/debug/test_sysfs"
 	fi
+	if [ -z $KERNFS_DEBUGFS_DIR ]; then
+		KERNFS_DEBUGFS_DIR="/sys/kernel/debug/kernfs"
+	fi
 	if [ -z $PAGE_SIZE ]; then
 		PAGE_SIZE=$(getconf PAGESIZE)
 	fi
@@ -167,6 +174,14 @@ modprobe_reset_enable_rtnl_lock_on_rmmod()
 	unset FIRST_MODPROBE_ARGS
 }
 
+modprobe_reset_enable_completion()
+{
+	FIRST_MODPROBE_ARGS="enable_completion_on_rmmod=1 enable_verbose_writes=1"
+	FIRST_MODPROBE_ARGS="$FIRST_MODPROBE_ARGS enable_verbose_rmmod=1 delay_rmmod_ms=0"
+	modprobe_reset
+	unset FIRST_MODPROBE_ARGS
+}
+
 load_req_mod()
 {
 	modprobe_reset
@@ -197,6 +212,63 @@ debugfs_reset_first_test_dev_ignore_errors()
 	echo -n "1" >"$SYSFS_DEBUGFS_DIR"/reset_first_test_dev
 }
 
+debugfs_kernfs_kernfs_fop_write_iter_exists()
+{
+	KNOB_DIR="${KERNFS_DEBUGFS_DIR}/config_fail_kernfs_fop_write_iter"
+	if [[ ! -d $KNOB_DIR ]]; then
+		echo "kernfs debugfs does not exist $KNOB_DIR"
+		return 0;
+	fi
+	KNOB_DEBUGFS="${KERNFS_DEBUGFS_DIR}/fail_kernfs_fop_write_iter"
+	if [[ ! -d $KNOB_DEBUGFS ]]; then
+		echo -n "kernfs debugfs for coniguring fail_kernfs_fop_write_iter "
+		echo "does not exist $KNOB_DIR"
+		return 0;
+	fi
+	return 1
+}
+
+debugfs_kernfs_kernfs_fop_write_iter_set_fail_once()
+{
+	KNOB_DEBUGFS="${KERNFS_DEBUGFS_DIR}/fail_kernfs_fop_write_iter"
+	echo 1 > $KNOB_DEBUGFS/interval
+	echo 100 > $KNOB_DEBUGFS/probability
+	echo 0 > $KNOB_DEBUGFS/space
+	# Disable verbose messages on the kernel ring buffer which may
+	# confuse developers with a kernel panic.
+	echo 0 > $KNOB_DEBUGFS/verbose
+
+	# Fail only once
+	echo 1 > $KNOB_DEBUGFS/times
+}
+
+debugfs_kernfs_kernfs_fop_write_iter_set_fail_never()
+{
+	KNOB_DEBUGFS="${KERNFS_DEBUGFS_DIR}/fail_kernfs_fop_write_iter"
+	echo 0 > $KNOB_DEBUGFS/times
+}
+
+debugfs_kernfs_set_wait_ms()
+{
+	SLEEP_AFTER_WAIT_MS="${KERNFS_DEBUGFS_DIR}/sleep_after_wait_ms"
+	echo $1 > $SLEEP_AFTER_WAIT_MS
+}
+
+debugfs_kernfs_disable_wait_kernfs_fop_write_iter()
+{
+	ENABLE_WAIT_KNOB="${KERNFS_DEBUGFS_DIR}/config_fail_kernfs_fop_write_iter/wait_"
+	for KNOB in ${ENABLE_WAIT_KNOB}*; do
+		echo 0 > $KNOB
+	done
+}
+
+debugfs_kernfs_enable_wait_kernfs_fop_write_iter()
+{
+	ENABLE_WAIT_KNOB="${KERNFS_DEBUGFS_DIR}/config_fail_kernfs_fop_write_iter/wait_$1"
+	echo -n "1" > $ENABLE_WAIT_KNOB
+	return $?
+}
+
 set_orig()
 {
 	if [[ ! -z $TARGET ]] && [[ ! -z $ORIG ]]; then
@@ -972,6 +1044,104 @@ sysfs_test_0028()
 	fi
 }
 
+sysfs_race_kernfs_kernfs_fop_write_iter()
+{
+	TARGET="${DIR}/$(get_test_target $1)"
+	WAIT_AT=$2
+	EXPECT_WRITE_RETURNS=$3
+	MSDELAY=$4
+
+	modprobe_reset_enable_completion
+	ORIG=$(cat "${TARGET}")
+	TEST_STR=$(( $ORIG + 1 ))
+
+	echo -n "Test racing removal of sysfs store op with kernfs $WAIT_AT ... "
+
+	if debugfs_kernfs_kernfs_fop_write_iter_exists; then
+		echo -n "skipping test as CONFIG_FAIL_KERNFS_KNOBS "
+		echo " or CONFIG_FAULT_INJECTION_DEBUG_FS is disabled"
+		return $ksft_skip
+	fi
+
+	# Allow for failing the kernfs_kernfs_fop_write_iter call once,
+	# we'll provide exact context shortly afterwards.
+	debugfs_kernfs_kernfs_fop_write_iter_set_fail_once
+
+	# First disable all waits
+	debugfs_kernfs_disable_wait_kernfs_fop_write_iter
+
+	# Enable a wait_for_completion(&kernfs_debug_wait_completion) at the
+	# specified location inside the kernfs_fop_write_iter() routine
+	debugfs_kernfs_enable_wait_kernfs_fop_write_iter $WAIT_AT
+
+	# Configure kernfs so that after its wait_for_completion() it
+	# will msleep() this amount of time and schedule(). We figure this
+	# will be sufficient time to allow for our module removal to complete.
+	debugfs_kernfs_set_wait_ms $MSDELAY
+
+	# Now we trigger a kernfs write op, which will run kernfs_fop_write_iter,
+	# but will wait until our driver sends a respective completion
+	set_test_ignore_errors &
+	write_pid=$!
+
+	# At this point kernfs_fop_write_iter() hasn't run our op, its
+	# waiting for our completion at the specified time $WAIT_AT.
+	# We now remove our module which will send a
+	# complete(&kernfs_debug_wait_completion) right before we deregister
+	# our device and the sysfs device attributes are removed.
+	#
+	# After the completion is sent, the test_sysfs driver races with
+	# kernfs to do the device deregistration with the kernfs msleep
+	# and schedule(). This should mean we've forced trying to remove the
+	# module prior to allowing kernfs to run our store operation. If the
+	# race did happen we'll panic with a null dereference on the store op.
+	#
+	# If no race happens we should see no write operation triggered.
+	modprobe -r $TEST_DRIVER > /dev/null 2>&1
+
+	debugfs_kernfs_kernfs_fop_write_iter_set_fail_never
+
+	wait $write_pid
+	if [[ $? -eq $EXPECT_WRITE_RETURNS ]]; then
+		echo "ok"
+	else
+		echo "FAIL" >&2
+	fi
+}
+
+sysfs_test_0029()
+{
+	for delay in 0 2 4 8 16 32 64 128 246 512 1024; do
+		echo "Using delay-after-completion: $delay"
+		sysfs_race_kernfs_kernfs_fop_write_iter 0029 at_start 1 $delay
+	done
+}
+
+sysfs_test_0030()
+{
+	for delay in 0 2 4 8 16 32 64 128 246 512 1024; do
+		echo "Using delay-after-completion: $delay"
+		sysfs_race_kernfs_kernfs_fop_write_iter 0030 before_mutex 1 $delay
+	done
+}
+
+sysfs_test_0031()
+{
+	for delay in 0 2 4 8 16 32 64 128 246 512 1024; do
+		echo "Using delay-after-completion: $delay"
+		sysfs_race_kernfs_kernfs_fop_write_iter 0031 after_mutex 1 $delay
+	done
+}
+
+# Even if we get the active reference the write fails
+sysfs_test_0032()
+{
+	for delay in 0 2 4 8 16 32 64 128 246 512 1024; do
+		echo "Using delay-after-completion: $delay"
+		sysfs_race_kernfs_kernfs_fop_write_iter 0032 after_active 1 $delay
+	done
+}
+
 test_gen_desc()
 {
 	echo -n "$1 x $(get_test_count $1)"
@@ -1013,6 +1183,10 @@ list_tests()
 	echo "$(test_gen_desc 0026) - block test writing y larger delay and resetting device"
 	echo "$(test_gen_desc 0027) - test rmmod deadlock while writing x ... "
 	echo "$(test_gen_desc 0028) - test rmmod deadlock using rtnl_lock while writing x ..."
+	echo "$(test_gen_desc 0029) - racing removal of store op with kernfs at start"
+	echo "$(test_gen_desc 0030) - racing removal of store op with kernfs before mutex"
+	echo "$(test_gen_desc 0031) - racing removal of store op with kernfs after mutex"
+	echo "$(test_gen_desc 0032) - racing removal of store op with kernfs after active"
 }
 
 usage()
-- 
2.27.0

