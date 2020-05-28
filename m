Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B5B31E5440
	for <lists+netdev@lfdr.de>; Thu, 28 May 2020 04:53:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726856AbgE1CxU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 May 2020 22:53:20 -0400
Received: from out4436.biz.mail.alibaba.com ([47.88.44.36]:52361 "EHLO
        out4436.biz.mail.alibaba.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725896AbgE1CxS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 May 2020 22:53:18 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R611e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01f04427;MF=yun.wang@linux.alibaba.com;NM=1;PH=DS;RN=11;SR=0;TI=SMTPD_---0TzrIeTf_1590634393;
Received: from testdeMacBook-Pro.local(mailfrom:yun.wang@linux.alibaba.com fp:SMTPD_---0TzrIeTf_1590634393)
          by smtp.aliyun-inc.com(127.0.0.1);
          Thu, 28 May 2020 10:53:14 +0800
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        open list <linux-kernel@vger.kernel.org>,
        "open list:BPF (Safe dynamic programs and tools)" 
        <netdev@vger.kernel.org>,
        "open list:BPF (Safe dynamic programs and tools)" 
        <bpf@vger.kernel.org>
From:   =?UTF-8?B?546L6LSH?= <yun.wang@linux.alibaba.com>
Subject: [RFC PATCH] samples:bpf: introduce task detector
Message-ID: <6561a67d-6dac-0302-8590-5f46bb0205c2@linux.alibaba.com>
Date:   Thu, 28 May 2020 10:53:13 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.13; rv:68.0)
 Gecko/20100101 Thunderbird/68.8.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is a tool to trace the related schedule events of a
specified task, eg the migration, sched in/out, wakeup and
sleep/block.

The event was translated into sentence to be more readable,
by execute command 'task_detector -p 49870' we continually
tracing the schedule events related to 'top' like:

----------------------------
923455517688  CPU=23  PID=49870  COMM=top          ENQUEUE
923455519633  CPU=23  PID=0      COMM=IDLE         PREEMPTED                1945ns
923455519868  CPU=23  PID=49870  COMM=top          EXECUTE AFTER WAITED     2180ns
923468279019  CPU=23  PID=49870  COMM=top          WAIT AFTER EXECUTED      12ms
923468279220  CPU=23  PID=128    COMM=ksoftirqd/23 PREEMPT
923468283051  CPU=23  PID=128    COMM=ksoftirqd/23 DEQUEUE AFTER PREEMPTED  3831ns
923468283216  CPU=23  PID=49870  COMM=top          EXECUTE AFTER WAITED     4197ns
923476280180  CPU=23  PID=49870  COMM=top          WAIT AFTER EXECUTED      7996us
923476280350  CPU=23  PID=128    COMM=ksoftirqd/23 PREEMPT
923476322029  CPU=23  PID=128    COMM=ksoftirqd/23 DEQUEUE AFTER PREEMPTED  41us
923476322150  CPU=23  PID=49870  COMM=top          EXECUTE AFTER WAITED     41us
923479726879  CPU=23  PID=49870  COMM=top          DEQUEUE AFTER EXECUTED   3404us
----------------------------

This could be helpful on debugging the competition on CPU
resource, to find out who has stolen the CPU and how much
it stolen.

It can also tracing the syscall by append option -s.

Signed-off-by: Michael Wang <yun.wang@linux.alibaba.com>
---
 samples/bpf/Makefile             |   3 +
 samples/bpf/task_detector.h      | 382 +++++++++++++++++++++++++++++++++++++++
 samples/bpf/task_detector_kern.c | 329 +++++++++++++++++++++++++++++++++
 samples/bpf/task_detector_user.c | 314 ++++++++++++++++++++++++++++++++
 4 files changed, 1028 insertions(+)
 create mode 100644 samples/bpf/task_detector.h
 create mode 100644 samples/bpf/task_detector_kern.c
 create mode 100644 samples/bpf/task_detector_user.c

diff --git a/samples/bpf/Makefile b/samples/bpf/Makefile
index 8403e4762306..a8e468e0eac9 100644
--- a/samples/bpf/Makefile
+++ b/samples/bpf/Makefile
@@ -53,6 +53,7 @@ tprogs-y += task_fd_query
 tprogs-y += xdp_sample_pkts
 tprogs-y += ibumad
 tprogs-y += hbm
+tprogs-y += task_detector

 # Libbpf dependencies
 LIBBPF = $(TOOLS_PATH)/lib/bpf/libbpf.a
@@ -109,6 +110,7 @@ task_fd_query-objs := bpf_load.o task_fd_query_user.o $(TRACE_HELPERS)
 xdp_sample_pkts-objs := xdp_sample_pkts_user.o $(TRACE_HELPERS)
 ibumad-objs := bpf_load.o ibumad_user.o $(TRACE_HELPERS)
 hbm-objs := bpf_load.o hbm.o $(CGROUP_HELPERS)
+task_detector-objs := bpf_load.o task_detector_user.o $(TRACE_HELPERS)

 # Tell kbuild to always build the programs
 always-y := $(tprogs-y)
@@ -170,6 +172,7 @@ always-y += ibumad_kern.o
 always-y += hbm_out_kern.o
 always-y += hbm_edt_kern.o
 always-y += xdpsock_kern.o
+always-y += task_detector_kern.o

 ifeq ($(ARCH), arm)
 # Strip all except -D__LINUX_ARM_ARCH__ option needed to handle linux
diff --git a/samples/bpf/task_detector.h b/samples/bpf/task_detector.h
new file mode 100644
index 000000000000..9b5f3f73a46a
--- /dev/null
+++ b/samples/bpf/task_detector.h
@@ -0,0 +1,382 @@
+#ifndef TASK_DETECTOR_H
+#define TASK_DETECTOR_H
+
+#define NR_ENTRY_MAX		10000
+#define NR_CPU_MAX		512
+
+typedef unsigned long long u64;
+typedef int pid_t;
+
+enum {
+	TYPE_MIGRATE,
+	TYPE_ENQUEUE,
+	TYPE_WAIT,
+	TYPE_EXECUTE,
+	TYPE_DEQUEUE,
+	TYPE_SYSCALL_ENTER,
+	TYPE_SYSCALL_EXIT,
+};
+
+struct user_info {
+	pid_t pid;
+	int exit;
+	int trace_syscall;
+};
+
+struct trace_info {
+	int type;
+	int cpu;
+	int syscall;
+	pid_t pid;
+	u64 ts;
+	char comm[16];
+};
+
+struct si_key {
+	int cpu;
+	int syscall;
+	pid_t pid;
+};
+
+char *syscall_name[] = {
+	"read",
+	"write",
+	"open",
+	"close",
+	"stat",
+	"fstat",
+	"lstat",
+	"poll",
+	"lseek",
+	"mmap",
+	"mprotect",
+	"munmap",
+	"brk",
+	"rt_sigaction",
+	"rt_sigprocmask",
+	"rt_sigreturn",
+	"ioctl",
+	"pread64",
+	"pwrite64",
+	"readv",
+	"writev",
+	"access",
+	"pipe",
+	"select",
+	"sched_yield",
+	"mremap",
+	"msync",
+	"mincore",
+	"madvise",
+	"shmget",
+	"shmat",
+	"shmctl",
+	"dup",
+	"dup2",
+	"pause",
+	"nanosleep",
+	"getitimer",
+	"alarm",
+	"setitimer",
+	"getpid",
+	"sendfile",
+	"socket",
+	"connect",
+	"accept",
+	"sendto",
+	"recvfrom",
+	"sendmsg",
+	"recvmsg",
+	"shutdown",
+	"bind",
+	"listen",
+	"getsockname",
+	"getpeername",
+	"socketpair",
+	"setsockopt",
+	"getsockopt",
+	"clone",
+	"fork",
+	"vfork",
+	"execve",
+	"exit",
+	"wait4",
+	"kill",
+	"uname",
+	"semget",
+	"semop",
+	"semctl",
+	"shmdt",
+	"msgget",
+	"msgsnd",
+	"msgrcv",
+	"msgctl",
+	"fcntl",
+	"flock",
+	"fsync",
+	"fdatasync",
+	"truncate",
+	"ftruncate",
+	"getdents",
+	"getcwd",
+	"chdir",
+	"fchdir",
+	"rename",
+	"mkdir",
+	"rmdir",
+	"creat",
+	"link",
+	"unlink",
+	"symlink",
+	"readlink",
+	"chmod",
+	"fchmod",
+	"chown",
+	"fchown",
+	"lchown",
+	"umask",
+	"gettimeofday",
+	"getrlimit",
+	"getrusage",
+	"sysinfo",
+	"times",
+	"ptrace",
+	"getuid",
+	"syslog",
+	"getgid",
+	"setuid",
+	"setgid",
+	"geteuid",
+	"getegid",
+	"setpgid",
+	"getppid",
+	"getpgrp",
+	"setsid",
+	"setreuid",
+	"setregid",
+	"getgroups",
+	"setgroups",
+	"setresuid",
+	"getresuid",
+	"setresgid",
+	"getresgid",
+	"getpgid",
+	"setfsuid",
+	"setfsgid",
+	"getsid",
+	"capget",
+	"capset",
+	"rt_sigpending",
+	"rt_sigtimedwait",
+	"rt_sigqueueinfo",
+	"rt_sigsuspend",
+	"sigaltstack",
+	"utime",
+	"mknod",
+	"uselib",
+	"personality",
+	"ustat",
+	"statfs",
+	"fstatfs",
+	"sysfs",
+	"getpriority",
+	"setpriority",
+	"sched_setparam",
+	"sched_getparam",
+	"sched_setscheduler",
+	"sched_getscheduler",
+	"sched_get_priority_max",
+	"sched_get_priority_min",
+	"sched_rr_get_interval",
+	"mlock",
+	"munlock",
+	"mlockall",
+	"munlockall",
+	"vhangup",
+	"modify_ldt",
+	"pivot_root",
+	"_sysctl",
+	"prctl",
+	"arch_prctl",
+	"adjtimex",
+	"setrlimit",
+	"chroot",
+	"sync",
+	"acct",
+	"settimeofday",
+	"mount",
+	"umount2",
+	"swapon",
+	"swapoff",
+	"reboot",
+	"sethostname",
+	"setdomainname",
+	"iopl",
+	"ioperm",
+	"create_module",
+	"init_module",
+	"delete_module",
+	"get_kernel_syms",
+	"query_module",
+	"quotactl",
+	"nfsservctl",
+	"getpmsg",
+	"putpmsg",
+	"afs_syscall",
+	"tuxcall",
+	"security",
+	"gettid",
+	"readahead",
+	"setxattr",
+	"lsetxattr",
+	"fsetxattr",
+	"getxattr",
+	"lgetxattr",
+	"fgetxattr",
+	"listxattr",
+	"llistxattr",
+	"flistxattr",
+	"removexattr",
+	"lremovexattr",
+	"fremovexattr",
+	"tkill",
+	"time",
+	"futex",
+	"sched_setaffinity",
+	"sched_getaffinity",
+	"set_thread_area",
+	"io_setup",
+	"io_destroy",
+	"io_getevents",
+	"io_submit",
+	"io_cancel",
+	"get_thread_area",
+	"lookup_dcookie",
+	"epoll_create",
+	"epoll_ctl_old",
+	"epoll_wait_old",
+	"remap_file_pages",
+	"getdents64",
+	"set_tid_address",
+	"restart_syscall",
+	"semtimedop",
+	"fadvise64",
+	"timer_create",
+	"timer_settime",
+	"timer_gettime",
+	"timer_getoverrun",
+	"timer_delete",
+	"clock_settime",
+	"clock_gettime",
+	"clock_getres",
+	"clock_nanosleep",
+	"exit_group",
+	"epoll_wait",
+	"epoll_ctl",
+	"tgkill",
+	"utimes",
+	"vserver",
+	"mbind",
+	"set_mempolicy",
+	"get_mempolicy",
+	"mq_open",
+	"mq_unlink",
+	"mq_timedsend",
+	"mq_timedreceive",
+	"mq_notify",
+	"mq_getsetattr",
+	"kexec_load",
+	"waitid",
+	"add_key",
+	"request_key",
+	"keyctl",
+	"ioprio_set",
+	"ioprio_get",
+	"inotify_init",
+	"inotify_add_watch",
+	"inotify_rm_watch",
+	"migrate_pages",
+	"openat",
+	"mkdirat",
+	"mknodat",
+	"fchownat",
+	"futimesat",
+	"newfstatat",
+	"unlinkat",
+	"renameat",
+	"linkat",
+	"symlinkat",
+	"readlinkat",
+	"fchmodat",
+	"faccessat",
+	"pselect6",
+	"ppoll",
+	"unshare",
+	"set_robust_list",
+	"get_robust_list",
+	"splice",
+	"tee",
+	"sync_file_range",
+	"vmsplice",
+	"move_pages",
+	"utimensat",
+	"epoll_pwait",
+	"signalfd",
+	"timerfd_create",
+	"eventfd",
+	"fallocate",
+	"timerfd_settime",
+	"timerfd_gettime",
+	"accept4",
+	"signalfd4",
+	"eventfd2",
+	"epoll_create1",
+	"dup3",
+	"pipe2",
+	"inotify_init1",
+	"preadv",
+	"pwritev",
+	"rt_tgsigqueueinfo",
+	"perf_event_open",
+	"recvmmsg",
+	"fanotify_init",
+	"fanotify_mark",
+	"prlimit64",
+	"name_to_handle_at",
+	"open_by_handle_at",
+	"clock_adjtime",
+	"syncfs",
+	"sendmmsg",
+	"setns",
+	"getcpu",
+	"process_vm_readv",
+	"process_vm_writev",
+	"kcmp",
+	"finit_module",
+	"sched_setattr",
+	"sched_getattr",
+	"renameat2",
+	"seccomp",
+	"getrandom",
+	"memfd_create",
+	"kexec_file_load",
+	"bpf",
+	"execveat",
+	"userfaultfd",
+	"membarrier",
+	"mlock2",
+	"copy_file_range",
+	"preadv2",
+	"pwritev2",
+	"pkey_mprotect",
+	"pkey_alloc",
+	"pkey_free",
+	"statx",
+	"io_pgetevents",
+	"rseq",
+	"io_uring_setup",
+	"io_uring_enter",
+	"io_uring_register",
+};
+
+#endif
diff --git a/samples/bpf/task_detector_kern.c b/samples/bpf/task_detector_kern.c
new file mode 100644
index 000000000000..35a7f1cba6bb
--- /dev/null
+++ b/samples/bpf/task_detector_kern.c
@@ -0,0 +1,329 @@
+// SPDX-License-Identifier: GPL-2.0
+
+#ifdef asm_volatile_goto
+#undef asm_volatile_goto
+#endif
+
+#define asm_volatile_goto(x...) asm volatile("invalid use of asm_volatile_goto")
+
+#include <linux/version.h>
+#include <linux/ptrace.h>
+#include <uapi/linux/bpf.h>
+#include <bpf/bpf_helpers.h>
+#include "task_detector.h"
+
+#define DEBUG_ON 0
+
+struct bpf_map_def SEC("maps") user_info_maps = {
+	.type		= BPF_MAP_TYPE_ARRAY,
+	.key_size	= sizeof(int),
+	.value_size	= sizeof(struct user_info),
+	.max_entries	= 1,
+};
+
+struct bpf_map_def SEC("maps") trace_info_maps = {
+	.type		= BPF_MAP_TYPE_ARRAY,
+	.key_size	= sizeof(int),
+	.value_size	= sizeof(struct trace_info),
+	.max_entries	= NR_ENTRY_MAX,
+};
+
+struct bpf_map_def SEC("maps") syscall_info_maps = {
+	.type		= BPF_MAP_TYPE_HASH,
+	.key_size	= sizeof(struct si_key),
+	.value_size	= sizeof(u64),
+	.max_entries	= NR_ENTRY_MAX,
+};
+
+struct bpf_map_def SEC("maps") start_maps = {
+	.type		= BPF_MAP_TYPE_ARRAY,
+	.key_size	= sizeof(int),
+	.value_size	= sizeof(int),
+	.max_entries	= 1,
+};
+
+struct bpf_map_def SEC("maps") end_maps = {
+	.type		= BPF_MAP_TYPE_ARRAY,
+	.key_size	= sizeof(int),
+	.value_size	= sizeof(int),
+	.max_entries	= 1,
+};
+
+struct bpf_map_def SEC("maps") trace_on_maps = {
+	.type		= BPF_MAP_TYPE_ARRAY,
+	.key_size	= sizeof(int),
+	.value_size	= sizeof(int),
+	.max_entries	= 1,
+};
+
+static inline void *get_user_info(void)
+{
+	int key = 0;
+
+	return bpf_map_lookup_elem(&user_info_maps, &key);
+}
+
+static inline void set_trace_on(int cpu)
+{
+	int key = 0;
+	int *trace_on = bpf_map_lookup_elem(&trace_on_maps, &key);
+
+	if (trace_on)
+		*trace_on = cpu + 1;
+}
+
+static inline void set_trace_off(void)
+{
+	int key = 0;
+	int *trace_on = bpf_map_lookup_elem(&trace_on_maps, &key);
+
+	if (trace_on)
+		*trace_on = 0;
+}
+
+static inline int should_trace(int cpu)
+{
+	int key = 0;
+	int *trace_on = bpf_map_lookup_elem(&trace_on_maps, &key);
+
+	return (trace_on && *trace_on == cpu + 1);
+}
+
+static inline void *get_trace(int key)
+{
+	return bpf_map_lookup_elem(&trace_info_maps, &key);
+}
+
+static inline void add_trace(struct trace_info ti)
+{
+	int orig_end, key = 0;
+	struct trace_info *tip;
+	int *start, *end;
+
+	start = bpf_map_lookup_elem(&start_maps, &key);
+	end = bpf_map_lookup_elem(&end_maps, &key);
+
+	if (!start || !end)
+		return;
+
+	orig_end = *end;
+	*end = (*end + 1);
+
+	if (*end == NR_ENTRY_MAX)
+		*end = 0;
+
+	if (*end == *start)
+		return;
+
+	tip = get_trace(orig_end);
+	if (!tip) {
+		*end = orig_end;
+		return;
+	}
+
+	memcpy(tip, &ti, sizeof(ti));
+	tip->ts = bpf_ktime_get_ns();
+
+	if (ti.type == TYPE_SYSCALL_ENTER ||
+	    ti.type == TYPE_SYSCALL_EXIT ||
+	    ti.type == TYPE_WAIT ||
+	    ti.type == TYPE_DEQUEUE)
+		bpf_get_current_comm(&tip->comm, sizeof(tip->comm));
+}
+
+struct sched_process_exit_args {
+	unsigned short common_type;
+	unsigned char common_flags;
+	unsigned char common_preempt_count;
+	int common_pid;
+	char comm[16];
+	pid_t pid;
+	int prio;
+};
+
+SEC("tracepoint/sched/sched_process_exit")
+int bpf_trace_sched_process_exit(struct sched_process_exit_args *args)
+{
+	struct user_info *ui = get_user_info();
+
+	if (ui && ui->pid && ui->pid == args->pid)
+		ui->exit = 1;
+
+	return 0;
+}
+
+struct sched_migrate_task_args {
+	unsigned short common_type;
+	unsigned char common_flags;
+	unsigned char common_preempt_count;
+	int common_pid;
+	char comm[16];
+	pid_t pid;
+	int prio;
+	int orig_cpu;
+	int dest_cpu;
+};
+
+SEC("tracepoint/sched/sched_migrate_task")
+int bpf_trace_sched_migrate_task(struct sched_migrate_task_args *args)
+{
+	struct trace_info ti = {
+		.cpu = args->dest_cpu,
+		.pid = args->pid,
+		.type = TYPE_MIGRATE,
+	};
+	struct user_info *ui = get_user_info();
+
+	if (!ui || !ui->pid || ui->pid != args->pid)
+		return 0;
+
+	set_trace_on(1 + args->dest_cpu);
+
+	add_trace(ti);
+
+	return 0;
+}
+
+struct sched_wakeup_args {
+	unsigned short common_type;
+	unsigned char common_flags;
+	unsigned char common_preempt_count;
+	int common_pid;
+	char comm[16];
+	pid_t pid;
+	int prio;
+	int success;
+	int target_cpu;
+};
+
+SEC("tracepoint/sched/sched_wakeup")
+int bpf_trace_sched_wakeup(struct sched_wakeup_args *args)
+{
+	struct trace_info ti = {
+		.cpu = args->target_cpu,
+		.pid = args->pid,
+		.type = TYPE_ENQUEUE,
+	};
+	struct user_info *ui = get_user_info();
+
+	if (!ui || !ui->pid || ui->pid != args->pid)
+		return 0;
+
+	set_trace_on(1 + args->target_cpu);
+
+	add_trace(ti);
+
+	return 0;
+}
+
+struct sched_switch_args {
+	unsigned short common_type;
+	unsigned char common_flags;
+	unsigned char common_preempt_count;
+	int common_pid;
+	char prev_comm[16];
+	pid_t prev_pid;
+	int prev_prio;
+	long prev_state;
+	char next_comm[16];
+	pid_t next_pid;
+	int next_prio;
+};
+
+SEC("tracepoint/sched/sched_switch")
+int bpf_trace_sched_switch(struct sched_switch_args *args)
+{
+	struct trace_info ti = {
+		.cpu = bpf_get_smp_processor_id(),
+	}, *tip;
+	struct user_info *ui = get_user_info();
+
+	if (!ui || !ui->pid)
+		return 0;
+
+	if (!should_trace(ti.cpu + 1)) {
+		if (ui->pid != args->prev_pid &&
+		    ui->pid != args->next_pid)
+			return 0;
+
+		set_trace_on(ti.cpu + 1);
+
+		ti.pid = ui->pid;
+		ti.type = TYPE_MIGRATE;
+		add_trace(ti);
+	}
+
+	if (args->prev_state != TASK_RUNNING &&
+	    args->prev_state != TASK_REPORT_MAX) {
+		if (ui->pid == args->prev_pid)
+			set_trace_off();
+		ti.type = TYPE_DEQUEUE;
+	} else
+		ti.type = TYPE_WAIT;
+	ti.pid = args->prev_pid;
+	add_trace(ti);
+
+	if (!should_trace(ti.cpu + 1))
+		return 0;
+
+	ti.type = TYPE_EXECUTE;
+	ti.pid = args->next_pid,
+	add_trace(ti);
+
+	return 0;
+}
+
+struct sys_enter_args {
+	unsigned short common_type;
+	unsigned char common_flags;
+	unsigned char common_preempt_count;
+	int common_pid;
+	long id;
+	unsigned long args[6];
+};
+
+SEC("tracepoint/raw_syscalls/sys_enter")
+int bpf_trace_sys_enter(struct sys_enter_args *args)
+{
+	struct trace_info ti = {
+		.cpu = bpf_get_smp_processor_id(),
+		.pid = bpf_get_current_pid_tgid(),
+		.type = TYPE_SYSCALL_ENTER,
+		.syscall = args->id,
+	}, *tip;
+	struct user_info *ui = get_user_info();
+
+	if (args->id && ui && ui->trace_syscall && should_trace(ti.cpu + 1))
+		add_trace(ti);
+
+	return 0;
+}
+
+struct sys_exit_args {
+	unsigned short common_type;
+	unsigned char common_flags;
+	unsigned char common_preempt_count;
+	int common_pid;
+	long id;
+	long ret;
+};
+
+SEC("tracepoint/raw_syscalls/sys_exit")
+int bpf_trace_sys_exit(struct sys_exit_args *args)
+{
+	struct trace_info ti = {
+		.cpu = bpf_get_smp_processor_id(),
+		.pid = bpf_get_current_pid_tgid(),
+		.type = TYPE_SYSCALL_EXIT,
+		.syscall = args->id,
+	}, *tip;
+	struct user_info *ui = get_user_info();
+
+	if (args->id && ui && ui->trace_syscall && should_trace(ti.cpu + 1))
+		add_trace(ti);
+
+	return 0;
+}
+
+char _license[] SEC("license") = "GPL";
+u32 _version SEC("version") = LINUX_VERSION_CODE;
diff --git a/samples/bpf/task_detector_user.c b/samples/bpf/task_detector_user.c
new file mode 100644
index 000000000000..d113546acddd
--- /dev/null
+++ b/samples/bpf/task_detector_user.c
@@ -0,0 +1,314 @@
+// SPDX-License-Identifier: GPL-2.0
+
+#define _GNU_SOURCE
+
+#include <errno.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <signal.h>
+#include <sched.h>
+#include <string.h>
+#include <unistd.h>
+#include <fcntl.h>
+#include <linux/bpf.h>
+#include <locale.h>
+#include <sys/types.h>
+#include <sys/stat.h>
+#include <sys/time.h>
+#include <sys/resource.h>
+#include <sys/wait.h>
+#include <dirent.h>
+
+#include <bpf/bpf.h>
+#include "bpf_load.h"
+#include "trace_helpers.h"
+#include "task_detector.h"
+
+#define ROOT_CG	"/sys/fs/cgroup/cpu/"
+
+static int ui_map_fd;
+static int ti_map_fd;
+static int si_map_fd;
+static int start_map_fd;
+static int end_map_fd;
+
+static int nr_cpus;
+static int trace_syscall;
+static char *target;
+
+static inline int get_comm(int pid, char comm[])
+{
+	int fd, ret = 1;
+	char path_buf[512];
+
+	comm[0] = '\0';
+
+	if (!pid) {
+		strcpy(comm, "IDLE");
+		return 0;
+	}
+
+	snprintf(path_buf, sizeof(path_buf), "/proc/%d/comm", pid);
+	fd = open(path_buf, O_RDONLY);
+	if (fd) {
+		int cnt;
+
+		cnt = read(fd, comm, 16);
+		if (cnt > 0) {
+			comm[cnt - 1] = '\0';
+			ret = 0;
+		}
+	}
+	close(fd);
+	return ret;
+}
+
+static inline int time_to_str(u64 ns, char *buf, size_t len)
+{
+	u64 us = ns / 1000;
+	u64 ms = us / 1000;
+	u64 s = ms / 1000;
+
+	if (s > 10)
+		snprintf(buf, len, "%llus", s);
+	else if (ms > 10)
+		snprintf(buf, len, "%llums", ms);
+	else if (us > 10)
+		snprintf(buf, len, "%lluus", us);
+	else
+		snprintf(buf, len, "%lluns", ns);
+
+	return (s || ms > 10);
+}
+
+static inline void pr_ti(struct trace_info *ti, char *opt, char *delay)
+{
+	char comm[16];
+
+	if (get_comm(ti->pid, comm))
+		memcpy(comm, ti->comm, sizeof(comm));
+
+	printf("%-27lluCPU=%-7dPID=%-7dCOMM=%-20s%-37s%-17s\n",
+				ti->ts, ti->cpu, ti->pid, comm, opt,
+				delay ? delay : "");
+}
+
+static int print_trace_info(int start, int end)
+{
+	int key;
+	char d_str[16];
+	static u64 w_start, p_start;
+	static struct trace_info ti_last;
+
+	for (key = start; key != end; key = (key + 1) % NR_ENTRY_MAX) {
+		char func[37];
+		struct trace_info ti;
+		struct si_key sik;
+		u64 siv;
+
+		if (bpf_map_lookup_elem(ti_map_fd, &key, &ti))
+			continue;
+
+		time_to_str(ti.ts - ti_last.ts, d_str, sizeof(d_str));
+
+		switch (ti.type) {
+		case TYPE_MIGRATE:
+			w_start = p_start = ti.ts;
+			pr_ti(&ti, "MIGRATE", NULL);
+			break;
+		case TYPE_ENQUEUE:
+			w_start = p_start = ti.ts;
+			printf("----------------------------\n");
+			pr_ti(&ti, "ENQUEUE", NULL);
+			break;
+		case TYPE_WAIT:
+			if (ti.pid == atoi(target)) {
+				w_start = ti.ts;
+				pr_ti(&ti, "WAIT AFTER EXECUTED", d_str);
+			} else {
+				time_to_str(ti.ts - p_start,
+						d_str, sizeof(d_str));
+				pr_ti(&ti, "PREEMPTED", d_str);
+			}
+			break;
+		case TYPE_EXECUTE:
+			if (ti.pid == atoi(target)) {
+				time_to_str(ti.ts - w_start,
+						d_str, sizeof(d_str));
+				pr_ti(&ti, "EXECUTE AFTER WAITED", d_str);
+			} else {
+				p_start = ti.ts;
+				pr_ti(&ti, "PREEMPT", NULL);
+			}
+			break;
+		case TYPE_DEQUEUE:
+			if (ti.pid == atoi(target))
+				pr_ti(&ti, "DEQUEUE AFTER EXECUTED", d_str);
+			else {
+				time_to_str(ti.ts - p_start,
+						d_str, sizeof(d_str));
+				pr_ti(&ti, "DEQUEUE AFTER PREEMPTED", d_str);
+			}
+			break;
+		case TYPE_SYSCALL_ENTER:
+			siv = ti.ts;
+			sik.cpu = ti.cpu;
+			sik.pid = ti.pid;
+			sik.syscall = ti.syscall;
+			bpf_map_update_elem(si_map_fd, &sik, &siv, BPF_ANY);
+			snprintf(func, sizeof(func), "SC [%d:%s] ENTER",
+					ti.syscall, syscall_name[ti.syscall]);
+			pr_ti(&ti, func, NULL);
+			break;
+		case TYPE_SYSCALL_EXIT:
+			sik.cpu = ti.cpu;
+			sik.pid = ti.pid;
+			sik.syscall = ti.syscall;
+			if (bpf_map_lookup_elem(si_map_fd, &sik, &siv))
+				break;
+			time_to_str(ti.ts - siv, d_str, sizeof(d_str));
+			bpf_map_delete_elem(si_map_fd, &sik);
+			snprintf(func, sizeof(func), "SC [%d:%s] TAKE %s TO EXIT",
+					ti.syscall, syscall_name[ti.syscall], d_str);
+			pr_ti(&ti, func, NULL);
+			break;
+		default:
+			break;
+		}
+
+		memcpy(&ti_last, &ti, sizeof(ti));
+	}
+
+	return end;
+}
+
+static int setup_user_info(char *pid)
+{
+	int key = 0;
+	DIR *dir;
+	char buf[256];
+	struct user_info ui;
+
+	snprintf(buf, sizeof(buf), "/proc/%s", pid);
+
+	dir = opendir(buf);
+	if (!dir) {
+		printf("Open %s failed: %s\n", buf, strerror(errno));
+		return -1;
+	}
+
+	memset(&ui, 0, sizeof(ui));
+	ui.pid = atoi(pid);
+	ui.trace_syscall = trace_syscall;
+
+	bpf_map_update_elem(ui_map_fd, &key, &ui, BPF_ANY);
+
+	closedir(dir);
+
+	return 0;
+}
+
+static inline void print_help(char *cmd)
+{
+	fprintf(stderr,
+		"Usage: %s [options]\n"
+		"\t-p PID\n"
+		"\t-s Trace SYSCALL Info\n"
+		, cmd);
+}
+
+static void int_exit(int sig)
+{
+	exit(0);
+}
+
+int main(int argc, char **argv)
+{
+	char filename[256];
+	struct rlimit r = {RLIM_INFINITY, RLIM_INFINITY};
+	int opt;
+
+	while ((opt = getopt(argc, argv, "p:i:s")) != -1) {
+		switch (opt) {
+		case 'p':
+			target = optarg;
+			break;
+		case 's':
+			trace_syscall = 1;
+			break;
+		default:
+help:
+			print_help(argv[0]);
+			return 1;
+		}
+	}
+
+	if (!target)
+		goto help;
+
+	nr_cpus = sysconf(_SC_NPROCESSORS_CONF);
+	if (nr_cpus > NR_CPU_MAX) {
+		printf("Support Maximum %d cpus\n", NR_CPU_MAX);
+		return 1;
+	}
+
+	if (setrlimit(RLIMIT_MEMLOCK, &r)) {
+		printf("Failed To Set Unlimited Memory\n");
+		return 1;
+	}
+
+	if (load_kallsyms()) {
+		printf("Load kallsyms Failed\n");
+		return 1;
+	}
+
+	snprintf(filename, sizeof(filename), "%s_kern.o", argv[0]);
+	if (load_bpf_file(filename)) {
+		snprintf(filename, sizeof(filename), "/bin/%s_kern.o", argv[0]);
+		if (load_bpf_file(filename)) {
+			printf("Load %s Failed\n%s", filename, bpf_log_buf);
+			return 1;
+		}
+	}
+
+	ui_map_fd = map_fd[0];
+	ti_map_fd = map_fd[1];
+	si_map_fd = map_fd[2];
+	start_map_fd = map_fd[3];
+	end_map_fd = map_fd[4];
+
+	if (setup_user_info(target)) {
+		printf("Illegal Target %s\n", target);
+		return 1;
+	}
+
+	signal(SIGINT, int_exit);
+	signal(SIGTERM, int_exit);
+
+	while (1) {
+		int key = 0, start = 0, end = 0;
+		struct user_info ui = {
+			.exit = 0,
+		};
+
+		bpf_map_lookup_elem(ui_map_fd, &key, &ui);
+		if (ui.exit) {
+			printf("Target \"%s\" Destroyed\n", target);
+			return 0;
+		}
+
+		bpf_map_lookup_elem(start_map_fd, &key, &start);
+		bpf_map_lookup_elem(end_map_fd, &key, &end);
+
+		if (start == end) {
+			sleep(1);
+			continue;
+		}
+
+		start = print_trace_info(start, end);
+
+		bpf_map_update_elem(start_map_fd, &key, &start, BPF_ANY);
+	}
+
+	return 0;
+}
-- 
2.14.4.44.g2045bb6

