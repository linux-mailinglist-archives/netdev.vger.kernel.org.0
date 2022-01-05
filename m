Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D18A48511D
	for <lists+netdev@lfdr.de>; Wed,  5 Jan 2022 11:27:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239436AbiAEK1t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Jan 2022 05:27:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235437AbiAEK1s (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Jan 2022 05:27:48 -0500
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A4FEC061761
        for <netdev@vger.kernel.org>; Wed,  5 Jan 2022 02:27:48 -0800 (PST)
Received: by mail-pf1-x436.google.com with SMTP id s15so34832121pfk.6
        for <netdev@vger.kernel.org>; Wed, 05 Jan 2022 02:27:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=+TKQ8UcDqR1lWxIxQn1jg25Nk+8EFBMVMphgbg/X9bk=;
        b=ZSUpd1pfx1U7mijxdNtBM/Qs62bCybMhX9TsiBoFnHp6bfV9OU4eDdBuFegPtvInXd
         rJcFr3GEDpYIN5R2L9Cn7GQateSkfF+d9d2DGT301yzqA6fyW2Ehi/JhlYuKS/7rtEfd
         bkaojhCisPIcsdOtWflzPo/ixSlmrbyB/Y6PbgMVwHRtn69pKxO9a7AFo9lx4FC6Dvmp
         7VWX9hQqnBh0Gdijzlkp+GtcKWPtKzz/eKXp2ofnMkiXmiDK/grcaat8uOx6faqq/k59
         7EsM9+pGVot8gR29QGJCYlcToahC4wb5Rm2rNTIUAOOxGtI82cKT9yWv1ynXmQH+TrnT
         LMMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=+TKQ8UcDqR1lWxIxQn1jg25Nk+8EFBMVMphgbg/X9bk=;
        b=31wMSZ+Vcf2NXPYllT9ZRqQG9oTGyvir01Ob4qzMHoaKI6p3PCVMsknTl7rMllRNW7
         wGumo+Q8CKs61w899C8s952yYGzsFAWBotniQbe0+lZwBKISVgovzGXYc2Nw3FsyuUCl
         J/6MUFDZNNdhi1L/XLviMcFg+WNeSOS8T9c8C1OCtaFoSx5l3PIcENEUetxAh7vl3TaG
         5wDs5/0kOo8is8ItQ5S/dcsvxSvDELAPlISChWj5R5teVs18uaHiqDg5VYuOap27O47R
         35JEdNuFm9YS6tP0R8AjAjZq51GCmqni/T+xxB/RLr4fORm6N1c2vlQJJt1GAIQHZKap
         z+NQ==
X-Gm-Message-State: AOAM533QqH8x/RI2nrF/ijGngA9z2A0EI/kwPP7Wk1Ud6vay+ZzSFrkV
        jKz8i9tcYb5NF1jaBs+hBOA=
X-Google-Smtp-Source: ABdhPJyED3QWt9QhRSFBmdHfcyGKYqkbNZiawXHen7oTfT/WVlano0NGF/p/uSrfsIKKCcxfgehNPA==
X-Received: by 2002:a63:4864:: with SMTP id x36mr48654456pgk.96.1641378468048;
        Wed, 05 Jan 2022 02:27:48 -0800 (PST)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:af04:a4cf:7c72:9c40])
        by smtp.gmail.com with ESMTPSA id t27sm46716926pfg.41.2022.01.05.02.27.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Jan 2022 02:27:47 -0800 (PST)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Maxim Mikityanskiy <maximmi@mellanox.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>
Subject: [BUG HTB offload] syzbot: C repro for b/213075475
Date:   Wed,  5 Jan 2022 02:27:37 -0800
Message-Id: <20220105102737.2072844-1-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.34.1.448.ga2b2bfdf31-goog
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

I had an internal syzbot report with a repro, leading to the infamous:

unregister_netdevice: waiting for DEV to become free

This repro was also working on upstream kernels, so I started
a bisection leading to this ~one year old commit

commit d03b195b5aa015f6c11988b86a3625f8d5dbac52 (HEAD, refs/bisect/bad)
Author: Maxim Mikityanskiy <maximmi@mellanox.com>
Date:   Tue Jan 19 14:08:13 2021 +0200

    sch_htb: Hierarchical QoS hardware offload

The repro seems to install a HTB qdisc on lo device, on TC_H_INGRESS
It appears your patches were focused on egress, so there is probably
a missing check to avoid bad things.

I spent already too much time to bisect the issue
I am thus giving a copy of the C repro.

gcc -static -o b213075475 b213075475.c -lpthread

Run the program, observe the unregister_netdevice messages in
dmesg/console in less than 20 seconds.

Reported-by: Eric Dumazet <edumazet@google.com>
Cc: Maxim Mikityanskiy <maximmi@mellanox.com>
Cc: Tariq Toukan <tariqt@nvidia.com>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Jamal Hadi Salim <jhs@mojatatu.com>
Cc: Cong Wang <xiyou.wangcong@gmail.com>
Cc: Jiri Pirko <jiri@resnulli.us>
---
 b213075475.c | 669 +++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 669 insertions(+)
 create mode 100644 b213075475.c

diff --git a/b213075475.c b/b213075475.c
new file mode 100644
index 0000000000000000000000000000000000000000..a6bf5462d15f05ff66c66883ac5df3edd18df0bc
--- /dev/null
+++ b/b213075475.c
@@ -0,0 +1,669 @@
+// autogenerated by syzkaller (https://github.com/google/syzkaller)
+
+#define _GNU_SOURCE
+
+#include <dirent.h>
+#include <endian.h>
+#include <errno.h>
+#include <fcntl.h>
+#include <pthread.h>
+#include <sched.h>
+#include <signal.h>
+#include <stdarg.h>
+#include <stdbool.h>
+#include <stdint.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+#include <sys/ioctl.h>
+#include <sys/mount.h>
+#include <sys/prctl.h>
+#include <sys/resource.h>
+#include <sys/stat.h>
+#include <sys/syscall.h>
+#include <sys/time.h>
+#include <sys/types.h>
+#include <sys/wait.h>
+#include <time.h>
+#include <unistd.h>
+
+#include <linux/capability.h>
+#include <linux/futex.h>
+
+static unsigned long long procid;
+
+static void sleep_ms(uint64_t ms)
+{
+  usleep(ms * 1000);
+}
+
+static uint64_t current_time_ms(void)
+{
+  struct timespec ts;
+  if (clock_gettime(CLOCK_MONOTONIC, &ts))
+    exit(1);
+  return (uint64_t)ts.tv_sec * 1000 + (uint64_t)ts.tv_nsec / 1000000;
+}
+
+static void use_temporary_dir(void)
+{
+  char tmpdir_template[] = "./syzkaller.XXXXXX";
+  char* tmpdir = mkdtemp(tmpdir_template);
+  if (!tmpdir)
+    exit(1);
+  if (chmod(tmpdir, 0777))
+    exit(1);
+  if (chdir(tmpdir))
+    exit(1);
+}
+
+static void thread_start(void* (*fn)(void*), void* arg)
+{
+  pthread_t th;
+  pthread_attr_t attr;
+  pthread_attr_init(&attr);
+  pthread_attr_setstacksize(&attr, 128 << 10);
+  int i = 0;
+  for (; i < 100; i++) {
+    if (pthread_create(&th, &attr, fn, arg) == 0) {
+      pthread_attr_destroy(&attr);
+      return;
+    }
+    if (errno == EAGAIN) {
+      usleep(50);
+      continue;
+    }
+    break;
+  }
+  exit(1);
+}
+
+typedef struct {
+  int state;
+} event_t;
+
+static void event_init(event_t* ev)
+{
+  ev->state = 0;
+}
+
+static void event_reset(event_t* ev)
+{
+  ev->state = 0;
+}
+
+static void event_set(event_t* ev)
+{
+  if (ev->state)
+    exit(1);
+  __atomic_store_n(&ev->state, 1, __ATOMIC_RELEASE);
+  syscall(SYS_futex, &ev->state, FUTEX_WAKE | FUTEX_PRIVATE_FLAG, 1000000);
+}
+
+static void event_wait(event_t* ev)
+{
+  while (!__atomic_load_n(&ev->state, __ATOMIC_ACQUIRE))
+    syscall(SYS_futex, &ev->state, FUTEX_WAIT | FUTEX_PRIVATE_FLAG, 0, 0);
+}
+
+static int event_isset(event_t* ev)
+{
+  return __atomic_load_n(&ev->state, __ATOMIC_ACQUIRE);
+}
+
+static int event_timedwait(event_t* ev, uint64_t timeout)
+{
+  uint64_t start = current_time_ms();
+  uint64_t now = start;
+  for (;;) {
+    uint64_t remain = timeout - (now - start);
+    struct timespec ts;
+    ts.tv_sec = remain / 1000;
+    ts.tv_nsec = (remain % 1000) * 1000 * 1000;
+    syscall(SYS_futex, &ev->state, FUTEX_WAIT | FUTEX_PRIVATE_FLAG, 0, &ts);
+    if (__atomic_load_n(&ev->state, __ATOMIC_ACQUIRE))
+      return 1;
+    now = current_time_ms();
+    if (now - start > timeout)
+      return 0;
+  }
+}
+
+static bool write_file(const char* file, const char* what, ...)
+{
+  char buf[1024];
+  va_list args;
+  va_start(args, what);
+  vsnprintf(buf, sizeof(buf), what, args);
+  va_end(args);
+  buf[sizeof(buf) - 1] = 0;
+  int len = strlen(buf);
+  int fd = open(file, O_WRONLY | O_CLOEXEC);
+  if (fd == -1)
+    return false;
+  if (write(fd, buf, len) != len) {
+    int err = errno;
+    close(fd);
+    errno = err;
+    return false;
+  }
+  close(fd);
+  return true;
+}
+
+#define MAX_FDS 30
+
+static void mount_cgroups(const char* dir, const char** controllers, int count)
+{
+  if (mkdir(dir, 0777)) {
+  }
+  char enabled[128] = {0};
+  int i = 0;
+  for (; i < count; i++) {
+    if (mount("none", dir, "cgroup", 0, controllers[i])) {
+      continue;
+    }
+    umount(dir);
+    strcat(enabled, ",");
+    strcat(enabled, controllers[i]);
+  }
+  if (enabled[0] == 0)
+    return;
+  if (mount("none", dir, "cgroup", 0, enabled + 1)) {
+  }
+  if (chmod(dir, 0777)) {
+  }
+}
+
+static void setup_cgroups()
+{
+  const char* unified_controllers[] = {"+cpu", "+memory", "+io", "+pids"};
+  const char* net_controllers[] = {"net", "net_prio", "devices", "blkio",
+                                   "freezer"};
+  const char* cpu_controllers[] = {"cpuset", "cpuacct", "hugetlb", "rlimit"};
+  if (mkdir("/syzcgroup", 0777)) {
+  }
+  if (mkdir("/syzcgroup/unified", 0777)) {
+  }
+  if (mount("none", "/syzcgroup/unified", "cgroup2", 0, NULL)) {
+  }
+  if (chmod("/syzcgroup/unified", 0777)) {
+  }
+  int unified_control =
+      open("/syzcgroup/unified/cgroup.subtree_control", O_WRONLY);
+  if (unified_control != -1) {
+    unsigned i;
+    for (i = 0;
+         i < sizeof(unified_controllers) / sizeof(unified_controllers[0]); i++)
+      if (write(unified_control, unified_controllers[i],
+                strlen(unified_controllers[i])) < 0) {
+      }
+    close(unified_control);
+  }
+  mount_cgroups("/syzcgroup/net", net_controllers,
+                sizeof(net_controllers) / sizeof(net_controllers[0]));
+  mount_cgroups("/syzcgroup/cpu", cpu_controllers,
+                sizeof(cpu_controllers) / sizeof(cpu_controllers[0]));
+  write_file("/syzcgroup/cpu/cgroup.clone_children", "1");
+  write_file("/syzcgroup/cpu/cpuset.memory_pressure_enabled", "1");
+}
+
+static void setup_cgroups_loop()
+{
+  int pid = getpid();
+  char file[128];
+  char cgroupdir[64];
+  snprintf(cgroupdir, sizeof(cgroupdir), "/syzcgroup/unified/syz%llu", procid);
+  if (mkdir(cgroupdir, 0777)) {
+  }
+  snprintf(file, sizeof(file), "%s/pids.max", cgroupdir);
+  write_file(file, "32");
+  snprintf(file, sizeof(file), "%s/memory.low", cgroupdir);
+  write_file(file, "%d", 298 << 20);
+  snprintf(file, sizeof(file), "%s/memory.high", cgroupdir);
+  write_file(file, "%d", 299 << 20);
+  snprintf(file, sizeof(file), "%s/memory.max", cgroupdir);
+  write_file(file, "%d", 300 << 20);
+  snprintf(file, sizeof(file), "%s/cgroup.procs", cgroupdir);
+  write_file(file, "%d", pid);
+  snprintf(cgroupdir, sizeof(cgroupdir), "/syzcgroup/cpu/syz%llu", procid);
+  if (mkdir(cgroupdir, 0777)) {
+  }
+  snprintf(file, sizeof(file), "%s/cgroup.procs", cgroupdir);
+  write_file(file, "%d", pid);
+  snprintf(cgroupdir, sizeof(cgroupdir), "/syzcgroup/net/syz%llu", procid);
+  if (mkdir(cgroupdir, 0777)) {
+  }
+  snprintf(file, sizeof(file), "%s/cgroup.procs", cgroupdir);
+  write_file(file, "%d", pid);
+}
+
+static void setup_cgroups_test()
+{
+  char cgroupdir[64];
+  snprintf(cgroupdir, sizeof(cgroupdir), "/syzcgroup/unified/syz%llu", procid);
+  if (symlink(cgroupdir, "./cgroup")) {
+  }
+  snprintf(cgroupdir, sizeof(cgroupdir), "/syzcgroup/cpu/syz%llu", procid);
+  if (symlink(cgroupdir, "./cgroup.cpu")) {
+  }
+  snprintf(cgroupdir, sizeof(cgroupdir), "/syzcgroup/net/syz%llu", procid);
+  if (symlink(cgroupdir, "./cgroup.net")) {
+  }
+}
+
+static void setup_common()
+{
+  if (mount(0, "/sys/fs/fuse/connections", "fusectl", 0, 0)) {
+  }
+}
+
+static void setup_binderfs()
+{
+  if (mkdir("/dev/binderfs", 0777)) {
+  }
+  if (mount("binder", "/dev/binderfs", "binder", 0, NULL)) {
+  }
+}
+
+static void loop();
+
+static void sandbox_common()
+{
+  prctl(PR_SET_PDEATHSIG, SIGKILL, 0, 0, 0);
+  setsid();
+  struct rlimit rlim;
+  rlim.rlim_cur = rlim.rlim_max = (200 << 20);
+  setrlimit(RLIMIT_AS, &rlim);
+  rlim.rlim_cur = rlim.rlim_max = 32 << 20;
+  setrlimit(RLIMIT_MEMLOCK, &rlim);
+  rlim.rlim_cur = rlim.rlim_max = 136 << 20;
+  setrlimit(RLIMIT_FSIZE, &rlim);
+  rlim.rlim_cur = rlim.rlim_max = 1 << 20;
+  setrlimit(RLIMIT_STACK, &rlim);
+  rlim.rlim_cur = rlim.rlim_max = 0;
+  setrlimit(RLIMIT_CORE, &rlim);
+  rlim.rlim_cur = rlim.rlim_max = 256;
+  setrlimit(RLIMIT_NOFILE, &rlim);
+  if (unshare(CLONE_NEWNS)) {
+  }
+  if (mount(NULL, "/", NULL, MS_REC | MS_PRIVATE, NULL)) {
+  }
+  if (unshare(CLONE_NEWIPC)) {
+  }
+  if (unshare(0x02000000)) {
+  }
+  if (unshare(CLONE_NEWUTS)) {
+  }
+  if (unshare(CLONE_SYSVSEM)) {
+  }
+  typedef struct {
+    const char* name;
+    const char* value;
+  } sysctl_t;
+  static const sysctl_t sysctls[] = {
+      {"/proc/sys/kernel/shmmax", "16777216"},
+      {"/proc/sys/kernel/shmall", "536870912"},
+      {"/proc/sys/kernel/shmmni", "1024"},
+      {"/proc/sys/kernel/msgmax", "8192"},
+      {"/proc/sys/kernel/msgmni", "1024"},
+      {"/proc/sys/kernel/msgmnb", "1024"},
+      {"/proc/sys/kernel/sem", "1024 1048576 500 1024"},
+  };
+  unsigned i;
+  for (i = 0; i < sizeof(sysctls) / sizeof(sysctls[0]); i++)
+    write_file(sysctls[i].name, sysctls[i].value);
+}
+
+static int wait_for_loop(int pid)
+{
+  if (pid < 0)
+    exit(1);
+  int status = 0;
+  while (waitpid(-1, &status, __WALL) != pid) {
+  }
+  return WEXITSTATUS(status);
+}
+
+static void drop_caps(void)
+{
+  struct __user_cap_header_struct cap_hdr = {};
+  struct __user_cap_data_struct cap_data[2] = {};
+  cap_hdr.version = _LINUX_CAPABILITY_VERSION_3;
+  cap_hdr.pid = getpid();
+  if (syscall(SYS_capget, &cap_hdr, &cap_data))
+    exit(1);
+  const int drop = (1 << CAP_SYS_PTRACE) | (1 << CAP_SYS_NICE);
+  cap_data[0].effective &= ~drop;
+  cap_data[0].permitted &= ~drop;
+  cap_data[0].inheritable &= ~drop;
+  if (syscall(SYS_capset, &cap_hdr, &cap_data))
+    exit(1);
+}
+
+static int do_sandbox_none(void)
+{
+  if (unshare(CLONE_NEWPID)) {
+  }
+  int pid = fork();
+  if (pid != 0)
+    return wait_for_loop(pid);
+  setup_common();
+  sandbox_common();
+  drop_caps();
+  if (unshare(CLONE_NEWNET)) {
+  }
+  setup_binderfs();
+  loop();
+  exit(1);
+}
+
+#define FS_IOC_SETFLAGS _IOW('f', 2, long)
+static void remove_dir(const char* dir)
+{
+  int iter = 0;
+  DIR* dp = 0;
+retry:
+  while (umount2(dir, MNT_DETACH | UMOUNT_NOFOLLOW) == 0) {
+  }
+  dp = opendir(dir);
+  if (dp == NULL) {
+    if (errno == EMFILE) {
+      exit(1);
+    }
+    exit(1);
+  }
+  struct dirent* ep = 0;
+  while ((ep = readdir(dp))) {
+    if (strcmp(ep->d_name, ".") == 0 || strcmp(ep->d_name, "..") == 0)
+      continue;
+    char filename[FILENAME_MAX];
+    snprintf(filename, sizeof(filename), "%s/%s", dir, ep->d_name);
+    while (umount2(filename, MNT_DETACH | UMOUNT_NOFOLLOW) == 0) {
+    }
+    struct stat st;
+    if (lstat(filename, &st))
+      exit(1);
+    if (S_ISDIR(st.st_mode)) {
+      remove_dir(filename);
+      continue;
+    }
+    int i;
+    for (i = 0;; i++) {
+      if (unlink(filename) == 0)
+        break;
+      if (errno == EPERM) {
+        int fd = open(filename, O_RDONLY);
+        if (fd != -1) {
+          long flags = 0;
+          if (ioctl(fd, FS_IOC_SETFLAGS, &flags) == 0) {
+          }
+          close(fd);
+          continue;
+        }
+      }
+      if (errno == EROFS) {
+        break;
+      }
+      if (errno != EBUSY || i > 100)
+        exit(1);
+      if (umount2(filename, MNT_DETACH | UMOUNT_NOFOLLOW))
+        exit(1);
+    }
+  }
+  closedir(dp);
+  for (int i = 0;; i++) {
+    if (rmdir(dir) == 0)
+      break;
+    if (i < 100) {
+      if (errno == EPERM) {
+        int fd = open(dir, O_RDONLY);
+        if (fd != -1) {
+          long flags = 0;
+          if (ioctl(fd, FS_IOC_SETFLAGS, &flags) == 0) {
+          }
+          close(fd);
+          continue;
+        }
+      }
+      if (errno == EROFS) {
+        break;
+      }
+      if (errno == EBUSY) {
+        if (umount2(dir, MNT_DETACH | UMOUNT_NOFOLLOW))
+          exit(1);
+        continue;
+      }
+      if (errno == ENOTEMPTY) {
+        if (iter < 100) {
+          iter++;
+          goto retry;
+        }
+      }
+    }
+    exit(1);
+  }
+}
+
+static void kill_and_wait(int pid, int* status)
+{
+  kill(-pid, SIGKILL);
+  kill(pid, SIGKILL);
+  for (int i = 0; i < 100; i++) {
+    if (waitpid(-1, status, WNOHANG | __WALL) == pid)
+      return;
+    usleep(1000);
+  }
+  DIR* dir = opendir("/sys/fs/fuse/connections");
+  if (dir) {
+    for (;;) {
+      struct dirent* ent = readdir(dir);
+      if (!ent)
+        break;
+      if (strcmp(ent->d_name, ".") == 0 || strcmp(ent->d_name, "..") == 0)
+        continue;
+      char abort[300];
+      snprintf(abort, sizeof(abort), "/sys/fs/fuse/connections/%s/abort",
+               ent->d_name);
+      int fd = open(abort, O_WRONLY);
+      if (fd == -1) {
+        continue;
+      }
+      if (write(fd, abort, 1) < 0) {
+      }
+      close(fd);
+    }
+    closedir(dir);
+  } else {
+  }
+  while (waitpid(-1, status, __WALL) != pid) {
+  }
+}
+
+static void setup_loop()
+{
+  setup_cgroups_loop();
+}
+
+static void setup_test()
+{
+  prctl(PR_SET_PDEATHSIG, SIGKILL, 0, 0, 0);
+  setpgrp();
+  setup_cgroups_test();
+  write_file("/proc/self/oom_score_adj", "1000");
+  if (symlink("/dev/binderfs", "./binderfs")) {
+  }
+}
+
+static void close_fds()
+{
+  for (int fd = 3; fd < MAX_FDS; fd++)
+    close(fd);
+}
+
+struct thread_t {
+  int created, call;
+  event_t ready, done;
+};
+
+static struct thread_t threads[16];
+static void execute_call(int call);
+static int running;
+
+static void* thr(void* arg)
+{
+  struct thread_t* th = (struct thread_t*)arg;
+  for (;;) {
+    event_wait(&th->ready);
+    event_reset(&th->ready);
+    execute_call(th->call);
+    __atomic_fetch_sub(&running, 1, __ATOMIC_RELAXED);
+    event_set(&th->done);
+  }
+  return 0;
+}
+
+static void execute_one(void)
+{
+  int i, call, thread;
+  for (call = 0; call < 6; call++) {
+    for (thread = 0; thread < (int)(sizeof(threads) / sizeof(threads[0]));
+         thread++) {
+      struct thread_t* th = &threads[thread];
+      if (!th->created) {
+        th->created = 1;
+        event_init(&th->ready);
+        event_init(&th->done);
+        event_set(&th->done);
+        thread_start(thr, th);
+      }
+      if (!event_isset(&th->done))
+        continue;
+      event_reset(&th->done);
+      th->call = call;
+      __atomic_fetch_add(&running, 1, __ATOMIC_RELAXED);
+      event_set(&th->ready);
+      event_timedwait(&th->done, 50);
+      break;
+    }
+  }
+  for (i = 0; i < 100 && __atomic_load_n(&running, __ATOMIC_RELAXED); i++)
+    sleep_ms(1);
+  close_fds();
+}
+
+static void execute_one(void);
+
+#define WAIT_FLAGS __WALL
+
+static void loop(void)
+{
+  setup_loop();
+  int iter = 0;
+  for (;; iter++) {
+    char cwdbuf[32];
+    sprintf(cwdbuf, "./%d", iter);
+    if (mkdir(cwdbuf, 0777))
+      exit(1);
+    int pid = fork();
+    if (pid < 0)
+      exit(1);
+    if (pid == 0) {
+      if (chdir(cwdbuf))
+        exit(1);
+      setup_test();
+      execute_one();
+      exit(0);
+    }
+    int status = 0;
+    uint64_t start = current_time_ms();
+    for (;;) {
+      if (waitpid(-1, &status, WNOHANG | WAIT_FLAGS) == pid)
+        break;
+      sleep_ms(1);
+      if (current_time_ms() - start < 5000)
+        continue;
+      kill_and_wait(pid, &status);
+      break;
+    }
+    remove_dir(cwdbuf);
+  }
+}
+
+uint64_t r[3] = {0xffffffffffffffff, 0xffffffffffffffff, 0xffffffffffffffff};
+
+void execute_call(int call)
+{
+  intptr_t res = 0;
+  switch (call) {
+  case 0:
+    res = syscall(__NR_socket, 0x10ul, 3ul, 0);
+    if (res != -1)
+      r[0] = res;
+    break;
+  case 1:
+    res = syscall(__NR_socket, 0x11ul, 2ul, 0);
+    if (res != -1)
+      r[1] = res;
+    break;
+  case 2:
+    *(uint16_t*)0x20000080 = 0x11;
+    memcpy((void*)0x20000082,
+           "\x00\x00\x01\x00\x00\x00\x00\x00\x08\xfc\x9d\x71\xfc\x00\x00\x00"
+           "\x00\x00\x00\x00\xf8\xff\xff\x00\x2e\x0b\x38\x36\x00\x54\x04\xb0"
+           "\xd6\x30\x1a\x4c\xe8\x75\xf2\xe3\xff\x5f\x16\x3e\xe3\x40\xb7\x67"
+           "\x95\x00\x80\x00\xf8\x00\x00\x00\x00\x01\x04\x00\x3c\x58\x11\x03"
+           "\x9e\x15\x77\x50\x27\xec\xce\x66\xfd\x79\x2b\xbf\x0e\x5b\xf5\xff"
+           "\x9b\x08\x16\xf3\xf6\xdb\x1c\x00\x01\x00\x00\x00\x00\x00\x00\x00"
+           "\x49\x74\x00\x00\x00\x00\x00\x00\x00\x06\xad\x8e\x5e\xcc\x32\x6d"
+           "\x3a\x09\xff\x42\xc6\x54\x00\x00\x00\x00\x00\x00\x00\x00",
+           126);
+    syscall(__NR_bind, r[1], 0x20000080ul, 0x80ul);
+    break;
+  case 3:
+    *(uint32_t*)0x200003c0 = 0x14;
+    res = syscall(__NR_getsockname, r[1], 0x200004c0ul, 0x200003c0ul);
+    if (res != -1)
+      r[2] = *(uint32_t*)0x200004c4;
+    break;
+  case 4:
+    *(uint64_t*)0x20000240 = 0;
+    *(uint32_t*)0x20000248 = 0;
+    *(uint64_t*)0x20000250 = 0x20000080;
+    *(uint64_t*)0x20000080 = 0x20000380;
+    memcpy((void*)0x20000380,
+           "\x48\x00\x00\x00\x24\x00\x07\x05\x00\x00\x00\x00\x00\x00\x10\x00"
+           "\x00\x00\x1f\x00",
+           20);
+    *(uint32_t*)0x20000394 = r[2];
+    memcpy((void*)0x20000398,
+           "\x00\x00\x04\x00\xf1\xff\xff\xff\x00\x00\x00\x00\x08\x00\x01\x00"
+           "\x68\x74\x62\x00\x1c\x00\x02\x00\x18\x00\x02\x00\x03",
+           29);
+    *(uint64_t*)0x20000088 = 0x48;
+    *(uint64_t*)0x20000258 = 1;
+    *(uint64_t*)0x20000260 = 0;
+    *(uint64_t*)0x20000268 = 0;
+    *(uint32_t*)0x20000270 = 0;
+    syscall(__NR_sendmsg, r[0], 0x20000240ul, 0ul);
+    break;
+  case 5:
+    syscall(__NR_clone, 0xbb002100ul, 0ul, 0x9999999999999999ul, 0ul, -1ul);
+    break;
+  }
+}
+int main(void)
+{
+  syscall(__NR_mmap, 0x1ffff000ul, 0x1000ul, 0ul, 0x32ul, -1, 0ul);
+  syscall(__NR_mmap, 0x20000000ul, 0x1000000ul, 7ul, 0x32ul, -1, 0ul);
+  syscall(__NR_mmap, 0x21000000ul, 0x1000ul, 0ul, 0x32ul, -1, 0ul);
+  setup_cgroups();
+  for (procid = 0; procid < 6; procid++) {
+    if (fork() == 0) {
+      use_temporary_dir();
+      do_sandbox_none();
+    }
+  }
+  sleep(1000000);
+  return 0;
+}
-- 
2.34.1.448.ga2b2bfdf31-goog

