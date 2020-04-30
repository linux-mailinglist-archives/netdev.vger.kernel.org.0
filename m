Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7874A1BF2A9
	for <lists+netdev@lfdr.de>; Thu, 30 Apr 2020 10:24:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726770AbgD3IX6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Apr 2020 04:23:58 -0400
Received: from mga03.intel.com ([134.134.136.65]:43699 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726412AbgD3IX5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 30 Apr 2020 04:23:57 -0400
IronPort-SDR: ceiqa/CRytXVJruMm6YW0+WLvY1FbzXl4LZawV9dsGz6dXyQxxJtfgAoDQpLTaBnRZrGJZJR4b
 CZFg6+QAU5Pg==
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Apr 2020 01:23:10 -0700
IronPort-SDR: /YkxLoIQgBBE+BqwPyVofOhBYM+eU/4XLIRWaOr9rpuY/W6canE5cKbeUWd7twk0/6Y2JufQlJ
 qe1Il8NiPhkQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,334,1583222400"; 
   d="xz'?gz'50?scan'50,208,50";a="459488249"
Received: from shao2-debian.sh.intel.com (HELO localhost) ([10.239.13.3])
  by fmsmga005.fm.intel.com with ESMTP; 30 Apr 2020 01:23:08 -0700
Date:   Thu, 30 Apr 2020 16:22:56 +0800
From:   kernel test robot <lkp@intel.com>
To:     Xiyu Yang <xiyuyang19@fudan.edu.cn>
Cc:     Xin Tan <tanxin.ctf@gmail.com>, linux-x25@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        LKP <lkp@lists.01.org>
Subject: 4becb7ee5b ("net/x25: Fix x25_neigh refcnt leak when x25 .."): [
   89.261843] BUG: kernel NULL pointer dereference, address: 00000074
Message-ID: <20200430082255.GH5770@shao2-debian>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="aF3LVLvitz/VQU3c"
Content-Disposition: inline
User-Agent: Heirloom mailx 12.5 6/20/10
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--aF3LVLvitz/VQU3c
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline

Greetings,

0day kernel testing robot got the below dmesg and the first bad commit is

https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git master

commit 4becb7ee5b3d2829ed7b9261a245a77d5b7de902
Author:     Xiyu Yang <xiyuyang19@fudan.edu.cn>
AuthorDate: Sat Apr 25 21:06:25 2020 +0800
Commit:     David S. Miller <davem@davemloft.net>
CommitDate: Mon Apr 27 11:20:30 2020 -0700

    net/x25: Fix x25_neigh refcnt leak when x25 disconnect
    
    x25_connect() invokes x25_get_neigh(), which returns a reference of the
    specified x25_neigh object to "x25->neighbour" with increased refcnt.
    
    When x25 connect success and returns, the reference still be hold by
    "x25->neighbour", so the refcount should be decreased in
    x25_disconnect() to keep refcount balanced.
    
    The reference counting issue happens in x25_disconnect(), which forgets
    to decrease the refcnt increased by x25_get_neigh() in x25_connect(),
    causing a refcnt leak.
    
    Fix this issue by calling x25_neigh_put() before x25_disconnect()
    returns.
    
    Signed-off-by: Xiyu Yang <xiyuyang19@fudan.edu.cn>
    Signed-off-by: Xin Tan <tanxin.ctf@gmail.com>
    Signed-off-by: David S. Miller <davem@davemloft.net>

095f5614bf  net/tls: Fix sk_psock refcnt leak in bpf_exec_tx_verdict()
4becb7ee5b  net/x25: Fix x25_neigh refcnt leak when x25 disconnect
+-------------------------------------------------------+------------+------------+
|                                                       | 095f5614bf | 4becb7ee5b |
+-------------------------------------------------------+------------+------------+
| boot_successes                                        | 29         | 1          |
| boot_failures                                         | 4          | 10         |
| BUG:kernel_timeout_in_boot_stage                      | 1          |            |
| BUG:kernel_hang_in_test_stage                         | 2          |            |
| BUG:kernel_hang_in_boot_stage                         | 1          | 1          |
| BUG:kernel_NULL_pointer_dereference,address           | 0          | 9          |
| Oops:#[##]                                            | 0          | 9          |
| EIP:x25_disconnect                                    | 0          | 9          |
| Kernel_panic-not_syncing:Fatal_exception_in_interrupt | 0          | 9          |
| WARNING:at_lib/refcount.c:#refcount_warn_saturate     | 0          | 1          |
| EIP:refcount_warn_saturate                            | 0          | 1          |
+-------------------------------------------------------+------------+------------+

If you fix the issue, kindly add following tag
Reported-by: kernel test robot <lkp@intel.com>

Stopping syslogd/klogd: stopped syslogd (pid 459)
stopped klogd (pid 462)
done
Deconfiguring network interfaces... done.
Sending all processes the TERM signal...
[   89.261843] BUG: kernel NULL pointer dereference, address: 00000074
[   89.263892] #PF: supervisor write access in kernel mode
[   89.264352] #PF: error_code(0x0002) - not-present page
[   89.264799] *pde = 00000000 
[   89.265057] Oops: 0002 [#1] SMP
[   89.265338] CPU: 1 PID: 785 Comm: trinity-c2 Not tainted 5.7.0-rc2-00379-g4becb7ee5b3d2 #1
[   89.303957] EIP: x25_disconnect+0x81/0xbc
[   89.304969] Code: b3 7c 02 00 00 75 0d 89 d8 ff 93 08 03 00 00 0f ba 6b 50 00 b8 a0 b9 f8 81 e8 a6 70 03 00 8b 8b 50 03 00 00 83 ca ff 8d 41 74 <f0> 0f c1 51 74 83 fa 01 75 09 89 c8 e8 12 32 81 ff eb 0e 85 d2 7f
[   89.309273] EAX: 00000074 EBX: f25fb800 ECX: 00000000 EDX: ffffffff
[   89.310597] ESI: 00000000 EDI: 00000008 EBP: f2ff5ed0 ESP: f2ff5ec0
[   89.312086] DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068 EFLAGS: 00010286
[   89.313295] CR0: 80050033 CR2: 00000074 CR3: 72eb6000 CR4: 00140690
[   89.314409] Call Trace:
[   89.314796]  x25_release+0x98/0xec
[   89.317726]  __sock_release+0x26/0x78
[   89.318307]  sock_close+0xd/0x11
[   89.332917]  __fput+0xe5/0x1a2
[   89.333443]  ____fput+0x8/0xa
[   89.334210]  task_work_run+0x53/0x76
[   89.334789]  do_exit+0x404/0x8f8
[   89.335286]  do_group_exit+0x82/0x82
[   89.335833]  __ia32_sys_exit_group+0x10/0x10
[   89.336506]  do_fast_syscall_32+0x8c/0xc5
[   89.337749]  entry_SYSENTER_32+0xaa/0x102
[   89.338246] EIP: 0x77fc1c3d
[   89.338588] Code: Bad RIP value.
[   89.339050] EAX: ffffffda EBX: 00000000 ECX: 00000000 EDX: 00000000
[   89.339782] ESI: 00000080 EDI: 09d30ef8 EBP: 0000006e ESP: 7fc0c0fc
[   89.340549] DS: 007b ES: 007b FS: 0000 GS: 0033 SS: 007b EFLAGS: 00000216
[   89.341451] Modules linked in:
[   89.341834] CR2: 0000000000000074
[   89.342300] ---[ end trace 4adddd6044784e2e ]---
[   89.342971] EIP: x25_disconnect+0x81/0xbc

                                                          # HH:MM RESULT GOOD BAD GOOD_BUT_DIRTY DIRTY_NOT_BAD
git bisect start b54e1dda887def1d16df3f47692ce7fbaccfb7d1 6a8b55ed4056ea5559ebe4f6a4b247f627870d4c --
git bisect  bad 8ea28476ea8059845ba55223fc779048553f4914  # 06:25  B      0     3   19   0  Merge 'nsaenz-linux-rpi/for-next' into devel-hourly-2020042823
git bisect  bad 00be51a8460ac2298cf6515ca5ff90ec0214f986  # 07:05  B      0     4   20   0  Merge 'linux-review/Mason-Yang/mtd-spi-nor-macronix-Add-support-for-mx25l512-mx25u512/20200426-125136' into devel-hourly-2020042823
git bisect  bad 5b07957c29cdcb3f9fd2850460abe343b3cb6edd  # 07:56  B      0     2   18   0  Merge 'linux-review/Like-Xu/KVM-x86-pmu-Support-full-width-counting/20200428-055206' into devel-hourly-2020042823
git bisect  bad ea46db9609519c8a9cbe7bfec63194adefd51a2d  # 10:26  B      0     6   22   0  Merge 'linux-review/Ranjani-Sridharan/Kconfig-updates-for-DMIC-and-SOF-HDMI-support/20200428-093102' into devel-hourly-2020042823
git bisect good 98e97b9813c233f075a74c9a89e62e3ca35b00d3  # 14:34  G     10     0    0   0  Merge 'linux-review/Anders-Roxell/memory-tegra-mark-PM-functions-as-__maybe_unused/20200428-094935' into devel-hourly-2020042823
git bisect good e16c3f98a1906ef3b1a2c8d61c937b7a4f6a7628  # 16:07  G     11     0    0   0  Merge 'linux-review/sathyanarayanan-kuppuswamy-linux-intel-com/PCI-AER-Use-_OSC-negotiation-to-determine-AER-ownership/20200428-040550' into devel-hourly-2020042823
git bisect  bad 60da1f95aa465e3b6ea917b753cfc8e8e0796459  # 17:01  B      1     1    1   1  Merge 'linux-review/Toke-H-iland-J-rgensen/wireguard-Use-tunnel-helpers-for-decapsulating-ECN-markings/20200428-082513' into devel-hourly-2020042823
git bisect good 7358cb29b9fd5a2553da6210e824052406698177  # 17:44  G     10     0    1   1  Merge 'linux-review/Eric-Dumazet/fq_codel-fix-TCA_FQ_CODEL_DROP_BATCH_SIZE-sanity-checks/20200427-190619' into devel-hourly-2020042823
git bisect good ffe419ae8a3e08aa9bad4878b99f5543d4ee5d6b  # 18:17  G     10     0    0   0  Merge 'linux-review/UPDATE-20200428-085738/Sakari-Ailus/IPU3-ImgU-driver-parameter-struct-fixes/20200416-195812' into devel-hourly-2020042823
git bisect  bad bae361c54fb6ac6eba3b4762f49ce14beb73ef13  # 18:56  B      0     4   20   0  bnxt_en: Improve AER slot reset.
git bisect  bad 4becb7ee5b3d2829ed7b9261a245a77d5b7de902  # 19:28  B      0     2   18   0  net/x25: Fix x25_neigh refcnt leak when x25 disconnect
git bisect good 18e6719c141e472fe3b9dce2d089eb89fdbce0b5  # 20:05  G     10     0    3   3  Merge branch 'vsock-virtio-fixes-about-packet-delivery-to-monitoring-devices'
git bisect good 095f5614bfe16e5b3e191b34ea41b10d6fdd4ced  # 21:02  G     10     0    1   1  net/tls: Fix sk_psock refcnt leak in bpf_exec_tx_verdict()
# first bad commit: [4becb7ee5b3d2829ed7b9261a245a77d5b7de902] net/x25: Fix x25_neigh refcnt leak when x25 disconnect
git bisect good 095f5614bfe16e5b3e191b34ea41b10d6fdd4ced  # 21:14  G     30     0    1   2  net/tls: Fix sk_psock refcnt leak in bpf_exec_tx_verdict()
# extra tests with debug options
git bisect  bad 4becb7ee5b3d2829ed7b9261a245a77d5b7de902  # 21:31  B      0     2   18   0  net/x25: Fix x25_neigh refcnt leak when x25 disconnect
# extra tests on revert first bad commit
git bisect good c56c1e56fe4c60e83308391f3faf5100ff5d3874  # 22:30  G     10     0    1   1  Revert "net/x25: Fix x25_neigh refcnt leak when x25 disconnect"
# good: [c56c1e56fe4c60e83308391f3faf5100ff5d3874] Revert "net/x25: Fix x25_neigh refcnt leak when x25 disconnect"

---
0-DAY CI Kernel Test Service, Intel Corporation
https://lists.01.org/hyperkitty/list/lkp@lists.01.org

--aF3LVLvitz/VQU3c
Content-Type: application/gzip
Content-Disposition: attachment; filename="dmesg-yocto-vm-yocto-29:20200429193013:i386-randconfig-a003-20200428:5.7.0-rc2-00379-g4becb7ee5b3d2:1.gz"
Content-Transfer-Encoding: base64

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
GwpX7gAA

--aF3LVLvitz/VQU3c
Content-Type: application/gzip
Content-Disposition: attachment; filename="dmesg-yocto-vm-yocto-11:20200429210130:i386-randconfig-a003-20200428:5.7.0-rc2-00378-g095f5614bfe16e:1.gz"
Content-Transfer-Encoding: base64

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

--aF3LVLvitz/VQU3c
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="reproduce-yocto-vm-yocto-29:20200429193013:i386-randconfig-a003-20200428:5.7.0-rc2-00379-g4becb7ee5b3d2:1"

#!/bin/bash

kernel=$1
initrd=yocto-i386-trinity.cgz

wget --no-clobber https://download.01.org/0day-ci/lkp-qemu/osimage/yocto/$initrd

kvm=(
	qemu-system-x86_64
	-enable-kvm
	-cpu Haswell,+smep,+smap
	-kernel $kernel
	-initrd $initrd
	-m 8192
	-smp 2
	-device e1000,netdev=net0
	-netdev user,id=net0,hostfwd=tcp::32032-:22
	-boot order=nc
	-no-reboot
	-watchdog i6300esb
	-watchdog-action debug
	-rtc base=localtime
	-serial stdio
	-display none
	-monitor null
)

append=(
	root=/dev/ram0
	hung_task_panic=1
	debug
	apic=debug
	sysrq_always_enabled
	rcupdate.rcu_cpu_stall_timeout=100
	net.ifnames=0
	printk.devkmsg=on
	panic=-1
	softlockup_panic=1
	nmi_watchdog=panic
	oops=panic
	load_ramdisk=2
	prompt_ramdisk=0
	drbd.minor_count=8
	systemd.log_level=err
	ignore_loglevel
	console=tty0
	earlyprintk=ttyS0,115200
	console=ttyS0,115200
	vga=normal
	rw
	rcuperf.shutdown=0
	watchdog_thresh=60
)

"${kvm[@]}" -append "${append[*]}"

--aF3LVLvitz/VQU3c
Content-Type: application/x-xz
Content-Disposition: attachment; filename="b54e1dda887def1d16df3f47692ce7fbaccfb7d1:gcc-7:i386-randconfig-a003-20200428:EIP:x25_disconnect.xz"
Content-Transfer-Encoding: base64

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

--aF3LVLvitz/VQU3c
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="config-5.7.0-rc2-00379-g4becb7ee5b3d2"

#
# Automatically generated file; DO NOT EDIT.
# Linux/i386 5.7.0-rc2 Kernel Configuration
#

#
# Compiler: gcc-7 (Ubuntu 7.5.0-6ubuntu2) 7.5.0
#
CONFIG_CC_IS_GCC=y
CONFIG_GCC_VERSION=70500
CONFIG_LD_VERSION=234000000
CONFIG_CLANG_VERSION=0
CONFIG_CC_CAN_LINK=y
CONFIG_CC_HAS_ASM_GOTO=y
CONFIG_CC_HAS_ASM_INLINE=y
CONFIG_CC_HAS_WARN_MAYBE_UNINITIALIZED=y
CONFIG_CC_DISABLE_WARN_MAYBE_UNINITIALIZED=y
CONFIG_IRQ_WORK=y
CONFIG_BUILDTIME_TABLE_SORT=y
CONFIG_THREAD_INFO_IN_TASK=y

#
# General setup
#
CONFIG_INIT_ENV_ARG_LIMIT=32
# CONFIG_COMPILE_TEST is not set
CONFIG_UAPI_HEADER_TEST=y
CONFIG_LOCALVERSION=""
CONFIG_LOCALVERSION_AUTO=y
CONFIG_BUILD_SALT=""
CONFIG_HAVE_KERNEL_GZIP=y
CONFIG_HAVE_KERNEL_BZIP2=y
CONFIG_HAVE_KERNEL_LZMA=y
CONFIG_HAVE_KERNEL_XZ=y
CONFIG_HAVE_KERNEL_LZO=y
CONFIG_HAVE_KERNEL_LZ4=y
# CONFIG_KERNEL_GZIP is not set
# CONFIG_KERNEL_BZIP2 is not set
# CONFIG_KERNEL_LZMA is not set
# CONFIG_KERNEL_XZ is not set
# CONFIG_KERNEL_LZO is not set
CONFIG_KERNEL_LZ4=y
CONFIG_DEFAULT_HOSTNAME="(none)"
# CONFIG_SWAP is not set
CONFIG_SYSVIPC=y
CONFIG_SYSVIPC_SYSCTL=y
# CONFIG_POSIX_MQUEUE is not set
CONFIG_CROSS_MEMORY_ATTACH=y
# CONFIG_USELIB is not set
CONFIG_AUDIT=y
CONFIG_HAVE_ARCH_AUDITSYSCALL=y
CONFIG_AUDITSYSCALL=y

#
# IRQ subsystem
#
CONFIG_GENERIC_IRQ_PROBE=y
CONFIG_GENERIC_IRQ_SHOW=y
CONFIG_GENERIC_IRQ_EFFECTIVE_AFF_MASK=y
CONFIG_GENERIC_PENDING_IRQ=y
CONFIG_GENERIC_IRQ_MIGRATION=y
CONFIG_HARDIRQS_SW_RESEND=y
CONFIG_GENERIC_IRQ_CHIP=y
CONFIG_IRQ_DOMAIN=y
CONFIG_IRQ_SIM=y
CONFIG_IRQ_DOMAIN_HIERARCHY=y
CONFIG_GENERIC_IRQ_MATRIX_ALLOCATOR=y
CONFIG_GENERIC_IRQ_RESERVATION_MODE=y
CONFIG_IRQ_FORCED_THREADING=y
CONFIG_SPARSE_IRQ=y
# CONFIG_GENERIC_IRQ_DEBUGFS is not set
# end of IRQ subsystem

CONFIG_CLOCKSOURCE_WATCHDOG=y
CONFIG_ARCH_CLOCKSOURCE_INIT=y
CONFIG_CLOCKSOURCE_VALIDATE_LAST_CYCLE=y
CONFIG_GENERIC_TIME_VSYSCALL=y
CONFIG_GENERIC_CLOCKEVENTS=y
CONFIG_GENERIC_CLOCKEVENTS_BROADCAST=y
CONFIG_GENERIC_CLOCKEVENTS_MIN_ADJUST=y
CONFIG_GENERIC_CMOS_UPDATE=y

#
# Timers subsystem
#
CONFIG_TICK_ONESHOT=y
CONFIG_NO_HZ_COMMON=y
# CONFIG_HZ_PERIODIC is not set
CONFIG_NO_HZ_IDLE=y
CONFIG_NO_HZ=y
# CONFIG_HIGH_RES_TIMERS is not set
# end of Timers subsystem

CONFIG_PREEMPT_NONE=y
# CONFIG_PREEMPT_VOLUNTARY is not set
# CONFIG_PREEMPT is not set
CONFIG_PREEMPT_COUNT=y

#
# CPU/Task time and stats accounting
#
CONFIG_TICK_CPU_ACCOUNTING=y
CONFIG_IRQ_TIME_ACCOUNTING=y
CONFIG_HAVE_SCHED_AVG_IRQ=y
# CONFIG_SCHED_THERMAL_PRESSURE is not set
CONFIG_BSD_PROCESS_ACCT=y
CONFIG_BSD_PROCESS_ACCT_V3=y
CONFIG_TASKSTATS=y
# CONFIG_TASK_DELAY_ACCT is not set
# CONFIG_TASK_XACCT is not set
CONFIG_PSI=y
CONFIG_PSI_DEFAULT_DISABLED=y
# end of CPU/Task time and stats accounting

# CONFIG_CPU_ISOLATION is not set

#
# RCU Subsystem
#
CONFIG_TREE_RCU=y
# CONFIG_RCU_EXPERT is not set
CONFIG_SRCU=y
CONFIG_TREE_SRCU=y
CONFIG_TASKS_RCU=y
CONFIG_RCU_STALL_COMMON=y
CONFIG_RCU_NEED_SEGCBLIST=y
# end of RCU Subsystem

CONFIG_IKCONFIG=y
CONFIG_IKCONFIG_PROC=y
CONFIG_IKHEADERS=m
CONFIG_LOG_BUF_SHIFT=20
CONFIG_LOG_CPU_MAX_BUF_SHIFT=12
CONFIG_PRINTK_SAFE_LOG_BUF_SHIFT=13
CONFIG_HAVE_UNSTABLE_SCHED_CLOCK=y

#
# Scheduler features
#
# end of Scheduler features

CONFIG_ARCH_WANT_BATCHED_UNMAP_TLB_FLUSH=y
CONFIG_CGROUPS=y
# CONFIG_MEMCG is not set
# CONFIG_BLK_CGROUP is not set
# CONFIG_CGROUP_SCHED is not set
# CONFIG_CGROUP_PIDS is not set
# CONFIG_CGROUP_RDMA is not set
# CONFIG_CGROUP_FREEZER is not set
# CONFIG_CPUSETS is not set
# CONFIG_CGROUP_DEVICE is not set
# CONFIG_CGROUP_CPUACCT is not set
# CONFIG_CGROUP_PERF is not set
CONFIG_CGROUP_BPF=y
# CONFIG_CGROUP_DEBUG is not set
CONFIG_SOCK_CGROUP_DATA=y
CONFIG_NAMESPACES=y
CONFIG_UTS_NS=y
CONFIG_TIME_NS=y
# CONFIG_IPC_NS is not set
CONFIG_USER_NS=y
CONFIG_PID_NS=y
CONFIG_NET_NS=y
CONFIG_CHECKPOINT_RESTORE=y
# CONFIG_SCHED_AUTOGROUP is not set
# CONFIG_SYSFS_DEPRECATED is not set
CONFIG_RELAY=y
CONFIG_BLK_DEV_INITRD=y
CONFIG_INITRAMFS_SOURCE=""
CONFIG_RD_GZIP=y
CONFIG_RD_BZIP2=y
CONFIG_RD_LZMA=y
CONFIG_RD_XZ=y
CONFIG_RD_LZO=y
CONFIG_RD_LZ4=y
# CONFIG_BOOT_CONFIG is not set
# CONFIG_CC_OPTIMIZE_FOR_PERFORMANCE is not set
CONFIG_CC_OPTIMIZE_FOR_SIZE=y
CONFIG_SYSCTL=y
CONFIG_HAVE_UID16=y
CONFIG_SYSCTL_EXCEPTION_TRACE=y
CONFIG_HAVE_PCSPKR_PLATFORM=y
CONFIG_BPF=y
CONFIG_EXPERT=y
# CONFIG_UID16 is not set
CONFIG_MULTIUSER=y
CONFIG_SGETMASK_SYSCALL=y
CONFIG_SYSFS_SYSCALL=y
CONFIG_FHANDLE=y
CONFIG_POSIX_TIMERS=y
CONFIG_PRINTK=y
CONFIG_PRINTK_NMI=y
CONFIG_BUG=y
# CONFIG_PCSPKR_PLATFORM is not set
CONFIG_BASE_FULL=y
CONFIG_FUTEX=y
CONFIG_FUTEX_PI=y
CONFIG_EPOLL=y
CONFIG_SIGNALFD=y
CONFIG_TIMERFD=y
CONFIG_EVENTFD=y
CONFIG_SHMEM=y
# CONFIG_AIO is not set
CONFIG_IO_URING=y
# CONFIG_ADVISE_SYSCALLS is not set
# CONFIG_MEMBARRIER is not set
CONFIG_KALLSYMS=y
CONFIG_KALLSYMS_ALL=y
CONFIG_KALLSYMS_BASE_RELATIVE=y
CONFIG_BPF_SYSCALL=y
CONFIG_BPF_JIT_ALWAYS_ON=y
CONFIG_BPF_JIT_DEFAULT_ON=y
CONFIG_USERFAULTFD=y
CONFIG_ARCH_HAS_MEMBARRIER_SYNC_CORE=y
# CONFIG_RSEQ is not set
CONFIG_EMBEDDED=y
CONFIG_HAVE_PERF_EVENTS=y
# CONFIG_PC104 is not set

#
# Kernel Performance Events And Counters
#
CONFIG_PERF_EVENTS=y
# CONFIG_DEBUG_PERF_USE_VMALLOC is not set
# end of Kernel Performance Events And Counters

# CONFIG_VM_EVENT_COUNTERS is not set
# CONFIG_COMPAT_BRK is not set
CONFIG_SLAB=y
# CONFIG_SLUB is not set
# CONFIG_SLOB is not set
# CONFIG_SLAB_MERGE_DEFAULT is not set
# CONFIG_SLAB_FREELIST_RANDOM is not set
CONFIG_SHUFFLE_PAGE_ALLOCATOR=y
CONFIG_SYSTEM_DATA_VERIFICATION=y
CONFIG_PROFILING=y
CONFIG_TRACEPOINTS=y
# end of General setup

CONFIG_X86_32=y
CONFIG_X86=y
CONFIG_INSTRUCTION_DECODER=y
CONFIG_OUTPUT_FORMAT="elf32-i386"
CONFIG_LOCKDEP_SUPPORT=y
CONFIG_STACKTRACE_SUPPORT=y
CONFIG_MMU=y
CONFIG_ARCH_MMAP_RND_BITS_MIN=8
CONFIG_ARCH_MMAP_RND_BITS_MAX=16
CONFIG_ARCH_MMAP_RND_COMPAT_BITS_MIN=8
CONFIG_ARCH_MMAP_RND_COMPAT_BITS_MAX=16
CONFIG_GENERIC_ISA_DMA=y
CONFIG_GENERIC_BUG=y
CONFIG_ARCH_MAY_HAVE_PC_FDC=y
CONFIG_GENERIC_CALIBRATE_DELAY=y
CONFIG_ARCH_HAS_CPU_RELAX=y
CONFIG_ARCH_HAS_CACHE_LINE_SIZE=y
CONFIG_ARCH_HAS_FILTER_PGPROT=y
CONFIG_HAVE_SETUP_PER_CPU_AREA=y
CONFIG_NEED_PER_CPU_EMBED_FIRST_CHUNK=y
CONFIG_NEED_PER_CPU_PAGE_FIRST_CHUNK=y
CONFIG_ARCH_HIBERNATION_POSSIBLE=y
CONFIG_ARCH_SUSPEND_POSSIBLE=y
CONFIG_ARCH_WANT_GENERAL_HUGETLB=y
CONFIG_ARCH_SUPPORTS_DEBUG_PAGEALLOC=y
CONFIG_X86_32_SMP=y
CONFIG_ARCH_SUPPORTS_UPROBES=y
CONFIG_FIX_EARLYCON_MEM=y
CONFIG_PGTABLE_LEVELS=2
CONFIG_CC_HAS_SANE_STACKPROTECTOR=y

#
# Processor type and features
#
CONFIG_ZONE_DMA=y
CONFIG_SMP=y
CONFIG_X86_FEATURE_NAMES=y
CONFIG_X86_MPPARSE=y
CONFIG_GOLDFISH=y
# CONFIG_RETPOLINE is not set
CONFIG_X86_CPU_RESCTRL=y
CONFIG_X86_BIGSMP=y
# CONFIG_X86_EXTENDED_PLATFORM is not set
# CONFIG_X86_INTEL_LPSS is not set
# CONFIG_X86_AMD_PLATFORM_DEVICE is not set
CONFIG_IOSF_MBI=m
CONFIG_IOSF_MBI_DEBUG=y
# CONFIG_X86_32_IRIS is not set
# CONFIG_SCHED_OMIT_FRAME_POINTER is not set
CONFIG_HYPERVISOR_GUEST=y
CONFIG_PARAVIRT=y
# CONFIG_PARAVIRT_DEBUG is not set
# CONFIG_PARAVIRT_SPINLOCKS is not set
CONFIG_KVM_GUEST=y
CONFIG_ARCH_CPUIDLE_HALTPOLL=y
# CONFIG_PVH is not set
# CONFIG_KVM_DEBUG_FS is not set
# CONFIG_PARAVIRT_TIME_ACCOUNTING is not set
CONFIG_PARAVIRT_CLOCK=y
# CONFIG_M486SX is not set
# CONFIG_M486 is not set
# CONFIG_M586 is not set
# CONFIG_M586TSC is not set
# CONFIG_M586MMX is not set
CONFIG_M686=y
# CONFIG_MPENTIUMII is not set
# CONFIG_MPENTIUMIII is not set
# CONFIG_MPENTIUMM is not set
# CONFIG_MPENTIUM4 is not set
# CONFIG_MK6 is not set
# CONFIG_MK7 is not set
# CONFIG_MK8 is not set
# CONFIG_MCRUSOE is not set
# CONFIG_MEFFICEON is not set
# CONFIG_MWINCHIPC6 is not set
# CONFIG_MWINCHIP3D is not set
# CONFIG_MELAN is not set
# CONFIG_MGEODEGX1 is not set
# CONFIG_MGEODE_LX is not set
# CONFIG_MCYRIXIII is not set
# CONFIG_MVIAC3_2 is not set
# CONFIG_MVIAC7 is not set
# CONFIG_MCORE2 is not set
# CONFIG_MATOM is not set
# CONFIG_X86_GENERIC is not set
CONFIG_X86_INTERNODE_CACHE_SHIFT=5
CONFIG_X86_L1_CACHE_SHIFT=5
CONFIG_X86_USE_PPRO_CHECKSUM=y
CONFIG_X86_TSC=y
CONFIG_X86_CMPXCHG64=y
CONFIG_X86_CMOV=y
CONFIG_X86_MINIMUM_CPU_FAMILY=6
CONFIG_X86_DEBUGCTLMSR=y
CONFIG_IA32_FEAT_CTL=y
CONFIG_X86_VMX_FEATURE_NAMES=y
# CONFIG_PROCESSOR_SELECT is not set
CONFIG_CPU_SUP_INTEL=y
CONFIG_CPU_SUP_CYRIX_32=y
CONFIG_CPU_SUP_AMD=y
CONFIG_CPU_SUP_HYGON=y
CONFIG_CPU_SUP_CENTAUR=y
CONFIG_CPU_SUP_TRANSMETA_32=y
CONFIG_CPU_SUP_UMC_32=y
CONFIG_CPU_SUP_ZHAOXIN=y
CONFIG_HPET_TIMER=y
CONFIG_HPET_EMULATE_RTC=y
# CONFIG_DMI is not set
CONFIG_NR_CPUS_RANGE_BEGIN=2
CONFIG_NR_CPUS_RANGE_END=64
CONFIG_NR_CPUS_DEFAULT=32
CONFIG_NR_CPUS=32
CONFIG_SCHED_SMT=y
# CONFIG_SCHED_MC is not set
CONFIG_X86_LOCAL_APIC=y
CONFIG_X86_IO_APIC=y
# CONFIG_X86_REROUTE_FOR_BROKEN_BOOT_IRQS is not set
# CONFIG_X86_MCE is not set

#
# Performance monitoring
#
CONFIG_PERF_EVENTS_INTEL_UNCORE=m
CONFIG_PERF_EVENTS_INTEL_RAPL=m
CONFIG_PERF_EVENTS_INTEL_CSTATE=m
# CONFIG_PERF_EVENTS_AMD_POWER is not set
# end of Performance monitoring

# CONFIG_X86_LEGACY_VM86 is not set
CONFIG_X86_16BIT=y
CONFIG_X86_ESPFIX32=y
CONFIG_X86_IOPL_IOPERM=y
CONFIG_TOSHIBA=y
CONFIG_I8K=y
# CONFIG_X86_REBOOTFIXUPS is not set
CONFIG_MICROCODE=y
CONFIG_MICROCODE_INTEL=y
# CONFIG_MICROCODE_AMD is not set
CONFIG_MICROCODE_OLD_INTERFACE=y
CONFIG_X86_MSR=y
# CONFIG_X86_CPUID is not set
# CONFIG_NOHIGHMEM is not set
CONFIG_HIGHMEM4G=y
# CONFIG_HIGHMEM64G is not set
# CONFIG_VMSPLIT_3G is not set
# CONFIG_VMSPLIT_3G_OPT is not set
CONFIG_VMSPLIT_2G=y
# CONFIG_VMSPLIT_2G_OPT is not set
# CONFIG_VMSPLIT_1G is not set
CONFIG_PAGE_OFFSET=0x80000000
CONFIG_HIGHMEM=y
CONFIG_X86_CPA_STATISTICS=y
CONFIG_ARCH_FLATMEM_ENABLE=y
CONFIG_ARCH_SPARSEMEM_ENABLE=y
CONFIG_ARCH_SELECT_MEMORY_MODEL=y
CONFIG_ILLEGAL_POINTER_VALUE=0
# CONFIG_HIGHPTE is not set
CONFIG_X86_CHECK_BIOS_CORRUPTION=y
# CONFIG_X86_BOOTPARAM_MEMORY_CORRUPTION_CHECK is not set
CONFIG_X86_RESERVE_LOW=64
# CONFIG_MTRR is not set
CONFIG_ARCH_RANDOM=y
# CONFIG_X86_SMAP is not set
CONFIG_X86_UMIP=y
# CONFIG_X86_INTEL_TSX_MODE_OFF is not set
CONFIG_X86_INTEL_TSX_MODE_ON=y
# CONFIG_X86_INTEL_TSX_MODE_AUTO is not set
CONFIG_EFI=y
# CONFIG_EFI_STUB is not set
# CONFIG_SECCOMP is not set
# CONFIG_HZ_100 is not set
# CONFIG_HZ_250 is not set
CONFIG_HZ_300=y
# CONFIG_HZ_1000 is not set
CONFIG_HZ=300
# CONFIG_KEXEC is not set
# CONFIG_CRASH_DUMP is not set
CONFIG_PHYSICAL_START=0x1000000
# CONFIG_RELOCATABLE is not set
CONFIG_PHYSICAL_ALIGN=0x200000
CONFIG_HOTPLUG_CPU=y
CONFIG_BOOTPARAM_HOTPLUG_CPU0=y
# CONFIG_DEBUG_HOTPLUG_CPU0 is not set
# CONFIG_COMPAT_VDSO is not set
# CONFIG_CMDLINE_BOOL is not set
CONFIG_MODIFY_LDT_SYSCALL=y
# end of Processor type and features

CONFIG_ARCH_ENABLE_MEMORY_HOTPLUG=y

#
# Power management and ACPI options
#
# CONFIG_SUSPEND is not set
CONFIG_PM=y
CONFIG_PM_DEBUG=y
# CONFIG_PM_ADVANCED_DEBUG is not set
# CONFIG_DPM_WATCHDOG is not set
CONFIG_PM_CLK=y
# CONFIG_WQ_POWER_EFFICIENT_DEFAULT is not set
CONFIG_ENERGY_MODEL=y
CONFIG_ARCH_SUPPORTS_ACPI=y
CONFIG_ACPI=y
CONFIG_ACPI_LEGACY_TABLES_LOOKUP=y
CONFIG_ARCH_MIGHT_HAVE_ACPI_PDC=y
CONFIG_ACPI_SYSTEM_POWER_STATES_SUPPORT=y
# CONFIG_ACPI_DEBUGGER is not set
CONFIG_ACPI_SPCR_TABLE=y
# CONFIG_ACPI_PROCFS_POWER is not set
CONFIG_ACPI_REV_OVERRIDE_POSSIBLE=y
# CONFIG_ACPI_EC_DEBUGFS is not set
CONFIG_ACPI_AC=y
CONFIG_ACPI_BATTERY=y
CONFIG_ACPI_BUTTON=y
CONFIG_ACPI_VIDEO=m
CONFIG_ACPI_FAN=y
# CONFIG_ACPI_DOCK is not set
CONFIG_ACPI_CPU_FREQ_PSS=y
CONFIG_ACPI_PROCESSOR_CSTATE=y
CONFIG_ACPI_PROCESSOR_IDLE=y
CONFIG_ACPI_PROCESSOR=y
CONFIG_ACPI_HOTPLUG_CPU=y
# CONFIG_ACPI_PROCESSOR_AGGREGATOR is not set
CONFIG_ACPI_THERMAL=y
CONFIG_ARCH_HAS_ACPI_TABLE_UPGRADE=y
CONFIG_ACPI_TABLE_UPGRADE=y
# CONFIG_ACPI_DEBUG is not set
# CONFIG_ACPI_PCI_SLOT is not set
CONFIG_ACPI_CONTAINER=y
CONFIG_ACPI_HOTPLUG_IOAPIC=y
# CONFIG_ACPI_SBS is not set
# CONFIG_ACPI_HED is not set
# CONFIG_ACPI_CUSTOM_METHOD is not set
# CONFIG_ACPI_BGRT is not set
# CONFIG_ACPI_REDUCED_HARDWARE_ONLY is not set
CONFIG_HAVE_ACPI_APEI=y
CONFIG_HAVE_ACPI_APEI_NMI=y
# CONFIG_ACPI_APEI is not set
# CONFIG_DPTF_POWER is not set
# CONFIG_PMIC_OPREGION is not set
# CONFIG_ACPI_CONFIGFS is not set
CONFIG_X86_PM_TIMER=y
# CONFIG_SFI is not set

#
# CPU Frequency scaling
#
CONFIG_CPU_FREQ=y
CONFIG_CPU_FREQ_GOV_ATTR_SET=y
CONFIG_CPU_FREQ_GOV_COMMON=y
# CONFIG_CPU_FREQ_STAT is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_PERFORMANCE is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_POWERSAVE is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_USERSPACE is not set
CONFIG_CPU_FREQ_DEFAULT_GOV_ONDEMAND=y
# CONFIG_CPU_FREQ_DEFAULT_GOV_CONSERVATIVE is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_SCHEDUTIL is not set
CONFIG_CPU_FREQ_GOV_PERFORMANCE=y
CONFIG_CPU_FREQ_GOV_POWERSAVE=m
CONFIG_CPU_FREQ_GOV_USERSPACE=y
CONFIG_CPU_FREQ_GOV_ONDEMAND=y
CONFIG_CPU_FREQ_GOV_CONSERVATIVE=m
# CONFIG_CPU_FREQ_GOV_SCHEDUTIL is not set

#
# CPU frequency scaling drivers
#
CONFIG_CPUFREQ_DT=m
CONFIG_CPUFREQ_DT_PLATDEV=y
# CONFIG_X86_INTEL_PSTATE is not set
# CONFIG_X86_PCC_CPUFREQ is not set
# CONFIG_X86_ACPI_CPUFREQ is not set
CONFIG_X86_POWERNOW_K6=y
# CONFIG_X86_POWERNOW_K7 is not set
CONFIG_X86_GX_SUSPMOD=y
CONFIG_X86_SPEEDSTEP_CENTRINO=y
CONFIG_X86_SPEEDSTEP_CENTRINO_TABLE=y
# CONFIG_X86_SPEEDSTEP_ICH is not set
CONFIG_X86_SPEEDSTEP_SMI=m
# CONFIG_X86_P4_CLOCKMOD is not set
CONFIG_X86_CPUFREQ_NFORCE2=m
# CONFIG_X86_LONGRUN is not set
# CONFIG_X86_LONGHAUL is not set
# CONFIG_X86_E_POWERSAVER is not set

#
# shared options
#
CONFIG_X86_SPEEDSTEP_LIB=m
CONFIG_X86_SPEEDSTEP_RELAXED_CAP_CHECK=y
# end of CPU Frequency scaling

#
# CPU Idle
#
CONFIG_CPU_IDLE=y
# CONFIG_CPU_IDLE_GOV_LADDER is not set
CONFIG_CPU_IDLE_GOV_MENU=y
# CONFIG_CPU_IDLE_GOV_TEO is not set
# CONFIG_CPU_IDLE_GOV_HALTPOLL is not set
CONFIG_HALTPOLL_CPUIDLE=y
# end of CPU Idle

CONFIG_INTEL_IDLE=y
# end of Power management and ACPI options

#
# Bus options (PCI etc.)
#
CONFIG_PCI_GOBIOS=y
# CONFIG_PCI_GOMMCONFIG is not set
# CONFIG_PCI_GODIRECT is not set
# CONFIG_PCI_GOOLPC is not set
# CONFIG_PCI_GOANY is not set
CONFIG_PCI_BIOS=y
# CONFIG_PCI_CNB20LE_QUIRK is not set
CONFIG_ISA_BUS=y
CONFIG_ISA_DMA_API=y
CONFIG_ISA=y
# CONFIG_SCx200 is not set
CONFIG_OLPC=y
# CONFIG_OLPC_XO15_SCI is not set
# CONFIG_ALIX is not set
# CONFIG_NET5501 is not set
CONFIG_AMD_NB=y
# CONFIG_X86_SYSFB is not set
# end of Bus options (PCI etc.)

#
# Binary Emulations
#
CONFIG_COMPAT_32=y
# end of Binary Emulations

CONFIG_HAVE_ATOMIC_IOMAP=y

#
# Firmware Drivers
#
CONFIG_EDD=m
CONFIG_EDD_OFF=y
CONFIG_FIRMWARE_MEMMAP=y
# CONFIG_ISCSI_IBFT is not set
CONFIG_FW_CFG_SYSFS=m
CONFIG_FW_CFG_SYSFS_CMDLINE=y
CONFIG_GOOGLE_FIRMWARE=y
# CONFIG_GOOGLE_COREBOOT_TABLE is not set

#
# EFI (Extensible Firmware Interface) Support
#
# CONFIG_EFI_VARS is not set
CONFIG_EFI_ESRT=y
# CONFIG_EFI_FAKE_MEMMAP is not set
CONFIG_EFI_RUNTIME_WRAPPERS=y
CONFIG_EFI_CAPSULE_LOADER=y
CONFIG_EFI_CAPSULE_QUIRK_QUARK_CSH=y
# CONFIG_EFI_TEST is not set
# CONFIG_EFI_RCI2_TABLE is not set
# CONFIG_EFI_DISABLE_PCI_DMA is not set
# end of EFI (Extensible Firmware Interface) Support

CONFIG_EFI_EARLYCON=y

#
# Tegra firmware driver
#
# end of Tegra firmware driver
# end of Firmware Drivers

CONFIG_HAVE_KVM=y
# CONFIG_VIRTUALIZATION is not set
CONFIG_AS_AVX512=y
CONFIG_AS_SHA1_NI=y
CONFIG_AS_SHA256_NI=y

#
# General architecture-dependent options
#
CONFIG_CRASH_CORE=y
CONFIG_HOTPLUG_SMT=y
CONFIG_OPROFILE=y
# CONFIG_OPROFILE_EVENT_MULTIPLEX is not set
CONFIG_HAVE_OPROFILE=y
CONFIG_OPROFILE_NMI_TIMER=y
# CONFIG_KPROBES is not set
# CONFIG_JUMP_LABEL is not set
CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS=y
CONFIG_ARCH_USE_BUILTIN_BSWAP=y
CONFIG_HAVE_IOREMAP_PROT=y
CONFIG_HAVE_KPROBES=y
CONFIG_HAVE_KRETPROBES=y
CONFIG_HAVE_OPTPROBES=y
CONFIG_HAVE_KPROBES_ON_FTRACE=y
CONFIG_HAVE_FUNCTION_ERROR_INJECTION=y
CONFIG_HAVE_NMI=y
CONFIG_HAVE_ARCH_TRACEHOOK=y
CONFIG_HAVE_DMA_CONTIGUOUS=y
CONFIG_GENERIC_SMP_IDLE_THREAD=y
CONFIG_ARCH_HAS_FORTIFY_SOURCE=y
CONFIG_ARCH_HAS_SET_MEMORY=y
CONFIG_ARCH_HAS_SET_DIRECT_MAP=y
CONFIG_HAVE_ARCH_THREAD_STRUCT_WHITELIST=y
CONFIG_ARCH_WANTS_DYNAMIC_TASK_STRUCT=y
CONFIG_ARCH_32BIT_OFF_T=y
CONFIG_HAVE_ASM_MODVERSIONS=y
CONFIG_HAVE_REGS_AND_STACK_ACCESS_API=y
CONFIG_HAVE_RSEQ=y
CONFIG_HAVE_FUNCTION_ARG_ACCESS_API=y
CONFIG_HAVE_CLK=y
CONFIG_HAVE_HW_BREAKPOINT=y
CONFIG_HAVE_MIXED_BREAKPOINTS_REGS=y
CONFIG_HAVE_USER_RETURN_NOTIFIER=y
CONFIG_HAVE_PERF_EVENTS_NMI=y
CONFIG_HAVE_HARDLOCKUP_DETECTOR_PERF=y
CONFIG_HAVE_PERF_REGS=y
CONFIG_HAVE_PERF_USER_STACK_DUMP=y
CONFIG_HAVE_ARCH_JUMP_LABEL=y
CONFIG_HAVE_ARCH_JUMP_LABEL_RELATIVE=y
CONFIG_MMU_GATHER_TABLE_FREE=y
CONFIG_MMU_GATHER_RCU_TABLE_FREE=y
CONFIG_ARCH_HAVE_NMI_SAFE_CMPXCHG=y
CONFIG_HAVE_CMPXCHG_LOCAL=y
CONFIG_HAVE_CMPXCHG_DOUBLE=y
CONFIG_ARCH_WANT_IPC_PARSE_VERSION=y
CONFIG_HAVE_ARCH_SECCOMP_FILTER=y
CONFIG_HAVE_ARCH_STACKLEAK=y
CONFIG_HAVE_STACKPROTECTOR=y
CONFIG_CC_HAS_STACKPROTECTOR_NONE=y
CONFIG_STACKPROTECTOR=y
CONFIG_STACKPROTECTOR_STRONG=y
CONFIG_HAVE_ARCH_WITHIN_STACK_FRAMES=y
CONFIG_HAVE_IRQ_TIME_ACCOUNTING=y
CONFIG_HAVE_MOVE_PMD=y
CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE=y
CONFIG_ARCH_WANT_HUGE_PMD_SHARE=y
CONFIG_HAVE_MOD_ARCH_SPECIFIC=y
CONFIG_MODULES_USE_ELF_REL=y
CONFIG_ARCH_HAS_ELF_RANDOMIZE=y
CONFIG_HAVE_ARCH_MMAP_RND_BITS=y
CONFIG_HAVE_EXIT_THREAD=y
CONFIG_ARCH_MMAP_RND_BITS=8
CONFIG_HAVE_COPY_THREAD_TLS=y
CONFIG_ISA_BUS_API=y
CONFIG_CLONE_BACKWARDS=y
CONFIG_OLD_SIGSUSPEND3=y
CONFIG_OLD_SIGACTION=y
CONFIG_COMPAT_32BIT_TIME=y
CONFIG_ARCH_HAS_STRICT_KERNEL_RWX=y
CONFIG_STRICT_KERNEL_RWX=y
CONFIG_ARCH_HAS_STRICT_MODULE_RWX=y
CONFIG_STRICT_MODULE_RWX=y
CONFIG_HAVE_ARCH_PREL32_RELOCATIONS=y
CONFIG_ARCH_USE_MEMREMAP_PROT=y
CONFIG_LOCK_EVENT_COUNTS=y
CONFIG_ARCH_HAS_MEM_ENCRYPT=y

#
# GCOV-based kernel profiling
#
# CONFIG_GCOV_KERNEL is not set
CONFIG_ARCH_HAS_GCOV_PROFILE_ALL=y
# end of GCOV-based kernel profiling

CONFIG_HAVE_GCC_PLUGINS=y
# end of General architecture-dependent options

CONFIG_RT_MUTEXES=y
CONFIG_BASE_SMALL=0
CONFIG_MODULES=y
CONFIG_MODULE_FORCE_LOAD=y
# CONFIG_MODULE_UNLOAD is not set
# CONFIG_MODVERSIONS is not set
# CONFIG_MODULE_SRCVERSION_ALL is not set
# CONFIG_MODULE_SIG is not set
# CONFIG_MODULE_COMPRESS is not set
# CONFIG_MODULE_ALLOW_MISSING_NAMESPACE_IMPORTS is not set
# CONFIG_UNUSED_SYMBOLS is not set
# CONFIG_TRIM_UNUSED_KSYMS is not set
CONFIG_MODULES_TREE_LOOKUP=y
CONFIG_BLOCK=y
CONFIG_BLK_SCSI_REQUEST=y
CONFIG_BLK_DEV_BSG=y
CONFIG_BLK_DEV_BSGLIB=y
CONFIG_BLK_DEV_INTEGRITY=y
CONFIG_BLK_DEV_INTEGRITY_T10=y
# CONFIG_BLK_DEV_ZONED is not set
CONFIG_BLK_CMDLINE_PARSER=y
CONFIG_BLK_WBT=y
# CONFIG_BLK_WBT_MQ is not set
CONFIG_BLK_DEBUG_FS=y
# CONFIG_BLK_SED_OPAL is not set

#
# Partition Types
#
CONFIG_PARTITION_ADVANCED=y
CONFIG_ACORN_PARTITION=y
CONFIG_ACORN_PARTITION_CUMANA=y
# CONFIG_ACORN_PARTITION_EESOX is not set
# CONFIG_ACORN_PARTITION_ICS is not set
CONFIG_ACORN_PARTITION_ADFS=y
# CONFIG_ACORN_PARTITION_POWERTEC is not set
CONFIG_ACORN_PARTITION_RISCIX=y
# CONFIG_AIX_PARTITION is not set
CONFIG_OSF_PARTITION=y
# CONFIG_AMIGA_PARTITION is not set
CONFIG_ATARI_PARTITION=y
CONFIG_MAC_PARTITION=y
CONFIG_MSDOS_PARTITION=y
# CONFIG_BSD_DISKLABEL is not set
# CONFIG_MINIX_SUBPARTITION is not set
# CONFIG_SOLARIS_X86_PARTITION is not set
CONFIG_UNIXWARE_DISKLABEL=y
# CONFIG_LDM_PARTITION is not set
# CONFIG_SGI_PARTITION is not set
CONFIG_ULTRIX_PARTITION=y
# CONFIG_SUN_PARTITION is not set
CONFIG_KARMA_PARTITION=y
# CONFIG_EFI_PARTITION is not set
CONFIG_SYSV68_PARTITION=y
# CONFIG_CMDLINE_PARTITION is not set
# end of Partition Types

CONFIG_BLK_MQ_PCI=y
CONFIG_BLK_MQ_VIRTIO=y
CONFIG_BLK_PM=y

#
# IO Schedulers
#
CONFIG_MQ_IOSCHED_DEADLINE=y
# CONFIG_MQ_IOSCHED_KYBER is not set
CONFIG_IOSCHED_BFQ=y
# end of IO Schedulers

CONFIG_PADATA=y
CONFIG_ASN1=y
CONFIG_UNINLINE_SPIN_UNLOCK=y
CONFIG_ARCH_SUPPORTS_ATOMIC_RMW=y
CONFIG_MUTEX_SPIN_ON_OWNER=y
CONFIG_RWSEM_SPIN_ON_OWNER=y
CONFIG_LOCK_SPIN_ON_OWNER=y
CONFIG_ARCH_USE_QUEUED_SPINLOCKS=y
CONFIG_QUEUED_SPINLOCKS=y
CONFIG_ARCH_USE_QUEUED_RWLOCKS=y
CONFIG_QUEUED_RWLOCKS=y
CONFIG_ARCH_HAS_SYNC_CORE_BEFORE_USERMODE=y
CONFIG_ARCH_HAS_SYSCALL_WRAPPER=y

#
# Executable file formats
#
CONFIG_BINFMT_ELF=y
CONFIG_ELFCORE=y
CONFIG_BINFMT_SCRIPT=y
# CONFIG_BINFMT_MISC is not set
# CONFIG_COREDUMP is not set
# end of Executable file formats

#
# Memory Management options
#
CONFIG_SELECT_MEMORY_MODEL=y
CONFIG_FLATMEM_MANUAL=y
# CONFIG_SPARSEMEM_MANUAL is not set
CONFIG_FLATMEM=y
CONFIG_FLAT_NODE_MEM_MAP=y
CONFIG_SPARSEMEM_STATIC=y
CONFIG_HAVE_MEMBLOCK_NODE_MAP=y
CONFIG_HAVE_FAST_GUP=y
CONFIG_SPLIT_PTLOCK_CPUS=4
CONFIG_MEMORY_BALLOON=y
# CONFIG_BALLOON_COMPACTION is not set
CONFIG_COMPACTION=y
CONFIG_PAGE_REPORTING=y
CONFIG_MIGRATION=y
# CONFIG_BOUNCE is not set
CONFIG_VIRT_TO_BUS=y
# CONFIG_KSM is not set
CONFIG_DEFAULT_MMAP_MIN_ADDR=4096
CONFIG_TRANSPARENT_HUGEPAGE=y
# CONFIG_TRANSPARENT_HUGEPAGE_ALWAYS is not set
CONFIG_TRANSPARENT_HUGEPAGE_MADVISE=y
CONFIG_CLEANCACHE=y
# CONFIG_CMA is not set
CONFIG_ZPOOL=y
# CONFIG_ZBUD is not set
CONFIG_Z3FOLD=y
CONFIG_ZSMALLOC=y
# CONFIG_PGTABLE_MAPPING is not set
# CONFIG_ZSMALLOC_STAT is not set
CONFIG_GENERIC_EARLY_IOREMAP=y
# CONFIG_IDLE_PAGE_TRACKING is not set
CONFIG_FRAME_VECTOR=y
CONFIG_PERCPU_STATS=y
CONFIG_GUP_BENCHMARK=y
CONFIG_READ_ONLY_THP_FOR_FS=y
CONFIG_ARCH_HAS_PTE_SPECIAL=y
CONFIG_MAPPING_DIRTY_HELPERS=y
# end of Memory Management options

CONFIG_NET=y
CONFIG_SKB_EXTENSIONS=y

#
# Networking options
#
CONFIG_PACKET=m
CONFIG_PACKET_DIAG=m
CONFIG_UNIX=y
CONFIG_UNIX_SCM=y
# CONFIG_UNIX_DIAG is not set
CONFIG_TLS=m
# CONFIG_TLS_DEVICE is not set
# CONFIG_TLS_TOE is not set
CONFIG_XFRM=y
CONFIG_XFRM_OFFLOAD=y
CONFIG_XFRM_ALGO=y
CONFIG_XFRM_USER=m
CONFIG_XFRM_INTERFACE=m
# CONFIG_XFRM_SUB_POLICY is not set
CONFIG_XFRM_MIGRATE=y
# CONFIG_XFRM_STATISTICS is not set
CONFIG_XFRM_IPCOMP=y
CONFIG_NET_KEY=y
CONFIG_NET_KEY_MIGRATE=y
# CONFIG_XDP_SOCKETS is not set
CONFIG_INET=y
# CONFIG_IP_MULTICAST is not set
CONFIG_IP_ADVANCED_ROUTER=y
# CONFIG_IP_FIB_TRIE_STATS is not set
CONFIG_IP_MULTIPLE_TABLES=y
# CONFIG_IP_ROUTE_MULTIPATH is not set
CONFIG_IP_ROUTE_VERBOSE=y
CONFIG_IP_PNP=y
CONFIG_IP_PNP_DHCP=y
# CONFIG_IP_PNP_BOOTP is not set
# CONFIG_IP_PNP_RARP is not set
CONFIG_NET_IPIP=y
# CONFIG_NET_IPGRE_DEMUX is not set
CONFIG_NET_IP_TUNNEL=y
CONFIG_SYN_COOKIES=y
CONFIG_NET_IPVTI=m
CONFIG_NET_UDP_TUNNEL=y
CONFIG_NET_FOU=y
CONFIG_NET_FOU_IP_TUNNELS=y
# CONFIG_INET_AH is not set
CONFIG_INET_ESP=y
CONFIG_INET_ESP_OFFLOAD=y
# CONFIG_INET_ESPINTCP is not set
CONFIG_INET_IPCOMP=y
CONFIG_INET_XFRM_TUNNEL=y
CONFIG_INET_TUNNEL=y
# CONFIG_INET_DIAG is not set
# CONFIG_TCP_CONG_ADVANCED is not set
CONFIG_TCP_CONG_CUBIC=y
CONFIG_DEFAULT_TCP_CONG="cubic"
CONFIG_TCP_MD5SIG=y
CONFIG_IPV6=y
CONFIG_IPV6_ROUTER_PREF=y
CONFIG_IPV6_ROUTE_INFO=y
CONFIG_IPV6_OPTIMISTIC_DAD=y
# CONFIG_INET6_AH is not set
# CONFIG_INET6_ESP is not set
CONFIG_INET6_IPCOMP=m
CONFIG_IPV6_MIP6=y
CONFIG_INET6_XFRM_TUNNEL=m
CONFIG_INET6_TUNNEL=y
CONFIG_IPV6_VTI=y
CONFIG_IPV6_SIT=y
# CONFIG_IPV6_SIT_6RD is not set
CONFIG_IPV6_NDISC_NODETYPE=y
CONFIG_IPV6_TUNNEL=y
CONFIG_IPV6_FOU=y
CONFIG_IPV6_FOU_TUNNEL=y
CONFIG_IPV6_MULTIPLE_TABLES=y
# CONFIG_IPV6_SUBTREES is not set
# CONFIG_IPV6_MROUTE is not set
CONFIG_IPV6_SEG6_LWTUNNEL=y
CONFIG_IPV6_SEG6_HMAC=y
CONFIG_IPV6_SEG6_BPF=y
# CONFIG_IPV6_RPL_LWTUNNEL is not set
CONFIG_NETLABEL=y
CONFIG_MPTCP=y
CONFIG_MPTCP_IPV6=y
# CONFIG_MPTCP_HMAC_TEST is not set
# CONFIG_NETWORK_SECMARK is not set
CONFIG_NET_PTP_CLASSIFY=y
# CONFIG_NETWORK_PHY_TIMESTAMPING is not set
# CONFIG_NETFILTER is not set
CONFIG_BPFILTER=y
CONFIG_BPFILTER_UMH=m
# CONFIG_IP_DCCP is not set
CONFIG_IP_SCTP=m
# CONFIG_SCTP_DBG_OBJCNT is not set
CONFIG_SCTP_DEFAULT_COOKIE_HMAC_MD5=y
# CONFIG_SCTP_DEFAULT_COOKIE_HMAC_SHA1 is not set
# CONFIG_SCTP_DEFAULT_COOKIE_HMAC_NONE is not set
CONFIG_SCTP_COOKIE_HMAC_MD5=y
CONFIG_SCTP_COOKIE_HMAC_SHA1=y
# CONFIG_RDS is not set
CONFIG_TIPC=m
CONFIG_TIPC_MEDIA_UDP=y
CONFIG_TIPC_CRYPTO=y
# CONFIG_TIPC_DIAG is not set
# CONFIG_ATM is not set
CONFIG_L2TP=y
CONFIG_L2TP_DEBUGFS=y
# CONFIG_L2TP_V3 is not set
CONFIG_STP=m
CONFIG_MRP=m
CONFIG_BRIDGE=m
# CONFIG_BRIDGE_IGMP_SNOOPING is not set
CONFIG_BRIDGE_VLAN_FILTERING=y
CONFIG_HAVE_NET_DSA=y
CONFIG_NET_DSA=m
CONFIG_NET_DSA_TAG_8021Q=m
# CONFIG_NET_DSA_TAG_AR9331 is not set
CONFIG_NET_DSA_TAG_BRCM_COMMON=m
CONFIG_NET_DSA_TAG_BRCM=m
CONFIG_NET_DSA_TAG_BRCM_PREPEND=m
CONFIG_NET_DSA_TAG_GSWIP=m
CONFIG_NET_DSA_TAG_DSA=m
CONFIG_NET_DSA_TAG_EDSA=m
CONFIG_NET_DSA_TAG_MTK=m
CONFIG_NET_DSA_TAG_KSZ=m
# CONFIG_NET_DSA_TAG_OCELOT is not set
CONFIG_NET_DSA_TAG_QCA=m
CONFIG_NET_DSA_TAG_LAN9303=m
CONFIG_NET_DSA_TAG_SJA1105=m
CONFIG_NET_DSA_TAG_TRAILER=m
CONFIG_VLAN_8021Q=m
# CONFIG_VLAN_8021Q_GVRP is not set
CONFIG_VLAN_8021Q_MVRP=y
CONFIG_DECNET=y
CONFIG_DECNET_ROUTER=y
CONFIG_LLC=y
CONFIG_LLC2=y
# CONFIG_ATALK is not set
CONFIG_X25=y
CONFIG_LAPB=m
# CONFIG_PHONET is not set
CONFIG_6LOWPAN=m
CONFIG_6LOWPAN_DEBUGFS=y
# CONFIG_6LOWPAN_NHC is not set
# CONFIG_IEEE802154 is not set
# CONFIG_NET_SCHED is not set
CONFIG_DCB=y
CONFIG_DNS_RESOLVER=y
# CONFIG_BATMAN_ADV is not set
CONFIG_OPENVSWITCH=m
CONFIG_OPENVSWITCH_VXLAN=m
# CONFIG_VSOCKETS is not set
CONFIG_NETLINK_DIAG=m
CONFIG_MPLS=y
CONFIG_NET_MPLS_GSO=m
CONFIG_MPLS_ROUTING=m
CONFIG_MPLS_IPTUNNEL=m
CONFIG_NET_NSH=m
CONFIG_HSR=m
CONFIG_NET_SWITCHDEV=y
CONFIG_NET_L3_MASTER_DEV=y
# CONFIG_NET_NCSI is not set
CONFIG_RPS=y
CONFIG_RFS_ACCEL=y
CONFIG_XPS=y
# CONFIG_CGROUP_NET_PRIO is not set
# CONFIG_CGROUP_NET_CLASSID is not set
CONFIG_NET_RX_BUSY_POLL=y
CONFIG_BQL=y
CONFIG_BPF_JIT=y
CONFIG_BPF_STREAM_PARSER=y
CONFIG_NET_FLOW_LIMIT=y

#
# Network testing
#
CONFIG_NET_PKTGEN=y
CONFIG_NET_DROP_MONITOR=y
# end of Network testing
# end of Networking options

# CONFIG_HAMRADIO is not set
CONFIG_CAN=y
CONFIG_CAN_RAW=m
# CONFIG_CAN_BCM is not set
CONFIG_CAN_GW=m
CONFIG_CAN_J1939=y

#
# CAN Device Drivers
#
CONFIG_CAN_VCAN=y
CONFIG_CAN_VXCAN=y
CONFIG_CAN_SLCAN=y
# CONFIG_CAN_DEV is not set
# CONFIG_CAN_DEBUG_DEVICES is not set
# end of CAN Device Drivers

CONFIG_BT=m
CONFIG_BT_BREDR=y
# CONFIG_BT_RFCOMM is not set
CONFIG_BT_BNEP=m
CONFIG_BT_BNEP_MC_FILTER=y
CONFIG_BT_BNEP_PROTO_FILTER=y
CONFIG_BT_HIDP=m
# CONFIG_BT_HS is not set
# CONFIG_BT_LE is not set
CONFIG_BT_LEDS=y
# CONFIG_BT_SELFTEST is not set
# CONFIG_BT_DEBUGFS is not set

#
# Bluetooth device drivers
#
CONFIG_BT_INTEL=m
# CONFIG_BT_HCIBTSDIO is not set
CONFIG_BT_HCIUART=m
CONFIG_BT_HCIUART_SERDEV=y
CONFIG_BT_HCIUART_H4=y
# CONFIG_BT_HCIUART_NOKIA is not set
CONFIG_BT_HCIUART_BCSP=y
CONFIG_BT_HCIUART_ATH3K=y
# CONFIG_BT_HCIUART_LL is not set
# CONFIG_BT_HCIUART_3WIRE is not set
# CONFIG_BT_HCIUART_INTEL is not set
# CONFIG_BT_HCIUART_RTL is not set
# CONFIG_BT_HCIUART_QCA is not set
CONFIG_BT_HCIUART_AG6XX=y
CONFIG_BT_HCIUART_MRVL=y
CONFIG_BT_HCIVHCI=m
# CONFIG_BT_MRVL is not set
CONFIG_BT_MTKSDIO=m
# CONFIG_BT_MTKUART is not set
# end of Bluetooth device drivers

# CONFIG_AF_RXRPC is not set
CONFIG_AF_KCM=m
CONFIG_STREAM_PARSER=y
CONFIG_FIB_RULES=y
# CONFIG_WIRELESS is not set
CONFIG_WIMAX=m
CONFIG_WIMAX_DEBUG_LEVEL=8
CONFIG_RFKILL=m
CONFIG_RFKILL_LEDS=y
CONFIG_RFKILL_INPUT=y
# CONFIG_RFKILL_GPIO is not set
CONFIG_NET_9P=y
CONFIG_NET_9P_VIRTIO=y
# CONFIG_NET_9P_DEBUG is not set
CONFIG_CAIF=y
# CONFIG_CAIF_DEBUG is not set
CONFIG_CAIF_NETDEV=y
CONFIG_CAIF_USB=m
CONFIG_CEPH_LIB=m
# CONFIG_CEPH_LIB_PRETTYDEBUG is not set
# CONFIG_CEPH_LIB_USE_DNS_RESOLVER is not set
# CONFIG_NFC is not set
CONFIG_PSAMPLE=m
CONFIG_NET_IFE=m
CONFIG_LWTUNNEL=y
# CONFIG_LWTUNNEL_BPF is not set
CONFIG_DST_CACHE=y
CONFIG_GRO_CELLS=y
CONFIG_NET_SOCK_MSG=y
CONFIG_NET_DEVLINK=y
CONFIG_PAGE_POOL=y
CONFIG_FAILOVER=y
CONFIG_ETHTOOL_NETLINK=y
CONFIG_HAVE_EBPF_JIT=y

#
# Device Drivers
#
CONFIG_HAVE_EISA=y
CONFIG_EISA=y
CONFIG_EISA_VLB_PRIMING=y
CONFIG_EISA_PCI_EISA=y
# CONFIG_EISA_VIRTUAL_ROOT is not set
# CONFIG_EISA_NAMES is not set
CONFIG_HAVE_PCI=y
CONFIG_PCI=y
CONFIG_PCI_DOMAINS=y
# CONFIG_PCIEPORTBUS is not set
CONFIG_PCIEASPM=y
CONFIG_PCIEASPM_DEFAULT=y
# CONFIG_PCIEASPM_POWERSAVE is not set
# CONFIG_PCIEASPM_POWER_SUPERSAVE is not set
# CONFIG_PCIEASPM_PERFORMANCE is not set
# CONFIG_PCIE_PTM is not set
# CONFIG_PCI_MSI is not set
CONFIG_PCI_QUIRKS=y
# CONFIG_PCI_DEBUG is not set
# CONFIG_PCI_REALLOC_ENABLE_AUTO is not set
# CONFIG_PCI_STUB is not set
CONFIG_PCI_PF_STUB=m
CONFIG_PCI_ATS=y
CONFIG_PCI_LOCKLESS_CONFIG=y
CONFIG_PCI_IOV=y
# CONFIG_PCI_PRI is not set
CONFIG_PCI_PASID=y
CONFIG_PCI_LABEL=y
# CONFIG_HOTPLUG_PCI is not set

#
# PCI controller drivers
#
# CONFIG_PCI_FTPCI100 is not set
# CONFIG_PCI_HOST_GENERIC is not set
CONFIG_PCIE_XILINX=y

#
# DesignWare PCI Core Support
#
# end of DesignWare PCI Core Support

#
# Mobiveil PCIe Core Support
#
# end of Mobiveil PCIe Core Support

#
# Cadence PCIe controllers support
#
# CONFIG_PCIE_CADENCE_PLAT_HOST is not set
# end of Cadence PCIe controllers support
# end of PCI controller drivers

#
# PCI Endpoint
#
# CONFIG_PCI_ENDPOINT is not set
# end of PCI Endpoint

#
# PCI switch controller drivers
#
CONFIG_PCI_SW_SWITCHTEC=y
# end of PCI switch controller drivers

# CONFIG_PCCARD is not set
CONFIG_RAPIDIO=y
CONFIG_RAPIDIO_DISC_TIMEOUT=30
# CONFIG_RAPIDIO_ENABLE_RX_TX_PORTS is not set
# CONFIG_RAPIDIO_DMA_ENGINE is not set
CONFIG_RAPIDIO_DEBUG=y
# CONFIG_RAPIDIO_ENUM_BASIC is not set
CONFIG_RAPIDIO_CHMAN=m
CONFIG_RAPIDIO_MPORT_CDEV=y

#
# RapidIO Switch drivers
#
CONFIG_RAPIDIO_TSI57X=m
CONFIG_RAPIDIO_CPS_XX=m
CONFIG_RAPIDIO_TSI568=y
CONFIG_RAPIDIO_CPS_GEN2=m
CONFIG_RAPIDIO_RXS_GEN3=m
# end of RapidIO Switch drivers

#
# Generic Driver Options
#
# CONFIG_UEVENT_HELPER is not set
CONFIG_DEVTMPFS=y
# CONFIG_DEVTMPFS_MOUNT is not set
CONFIG_STANDALONE=y
CONFIG_PREVENT_FIRMWARE_BUILD=y

#
# Firmware loader
#
CONFIG_FW_LOADER=y
CONFIG_FW_LOADER_PAGED_BUF=y
CONFIG_EXTRA_FIRMWARE=""
CONFIG_FW_LOADER_USER_HELPER=y
CONFIG_FW_LOADER_USER_HELPER_FALLBACK=y
# CONFIG_FW_LOADER_COMPRESS is not set
# end of Firmware loader

CONFIG_WANT_DEV_COREDUMP=y
# CONFIG_ALLOW_DEV_COREDUMP is not set
# CONFIG_DEBUG_DRIVER is not set
# CONFIG_DEBUG_DEVRES is not set
# CONFIG_DEBUG_TEST_DRIVER_REMOVE is not set
CONFIG_TEST_ASYNC_DRIVER_PROBE=m
CONFIG_GENERIC_CPU_AUTOPROBE=y
CONFIG_GENERIC_CPU_VULNERABILITIES=y
CONFIG_REGMAP=y
CONFIG_REGMAP_I2C=y
CONFIG_REGMAP_MMIO=y
CONFIG_REGMAP_IRQ=y
CONFIG_REGMAP_SCCB=m
CONFIG_REGMAP_I3C=m
CONFIG_DMA_SHARED_BUFFER=y
# CONFIG_DMA_FENCE_TRACE is not set
# end of Generic Driver Options

#
# Bus devices
#
# CONFIG_SIMPLE_PM_BUS is not set
# CONFIG_MHI_BUS is not set
# end of Bus devices

CONFIG_CONNECTOR=m
CONFIG_GNSS=m
CONFIG_GNSS_SERIAL=m
# CONFIG_GNSS_MTK_SERIAL is not set
# CONFIG_GNSS_SIRF_SERIAL is not set
CONFIG_GNSS_UBX_SERIAL=m
CONFIG_MTD=m
CONFIG_MTD_TESTS=m

#
# Partition parsers
#
# CONFIG_MTD_AR7_PARTS is not set
# CONFIG_MTD_CMDLINE_PARTS is not set
CONFIG_MTD_OF_PARTS=m
# CONFIG_MTD_REDBOOT_PARTS is not set
# end of Partition parsers

#
# User Modules And Translation Layers
#
CONFIG_MTD_BLKDEVS=m
# CONFIG_MTD_BLOCK is not set
CONFIG_MTD_BLOCK_RO=m
CONFIG_FTL=m
# CONFIG_NFTL is not set
# CONFIG_INFTL is not set
CONFIG_RFD_FTL=m
CONFIG_SSFDC=m
CONFIG_SM_FTL=m
CONFIG_MTD_OOPS=m
# CONFIG_MTD_PARTITIONED_MASTER is not set

#
# RAM/ROM/Flash chip drivers
#
CONFIG_MTD_CFI=m
CONFIG_MTD_JEDECPROBE=m
CONFIG_MTD_GEN_PROBE=m
CONFIG_MTD_CFI_ADV_OPTIONS=y
CONFIG_MTD_CFI_NOSWAP=y
# CONFIG_MTD_CFI_BE_BYTE_SWAP is not set
# CONFIG_MTD_CFI_LE_BYTE_SWAP is not set
CONFIG_MTD_CFI_GEOMETRY=y
# CONFIG_MTD_MAP_BANK_WIDTH_1 is not set
CONFIG_MTD_MAP_BANK_WIDTH_2=y
CONFIG_MTD_MAP_BANK_WIDTH_4=y
CONFIG_MTD_MAP_BANK_WIDTH_8=y
# CONFIG_MTD_MAP_BANK_WIDTH_16 is not set
# CONFIG_MTD_MAP_BANK_WIDTH_32 is not set
# CONFIG_MTD_CFI_I1 is not set
# CONFIG_MTD_CFI_I2 is not set
CONFIG_MTD_CFI_I4=y
CONFIG_MTD_CFI_I8=y
# CONFIG_MTD_OTP is not set
# CONFIG_MTD_CFI_INTELEXT is not set
CONFIG_MTD_CFI_AMDSTD=m
CONFIG_MTD_CFI_STAA=m
CONFIG_MTD_CFI_UTIL=m
CONFIG_MTD_RAM=m
CONFIG_MTD_ROM=m
CONFIG_MTD_ABSENT=m
# end of RAM/ROM/Flash chip drivers

#
# Mapping drivers for chip access
#
CONFIG_MTD_COMPLEX_MAPPINGS=y
CONFIG_MTD_PHYSMAP=m
# CONFIG_MTD_PHYSMAP_COMPAT is not set
CONFIG_MTD_PHYSMAP_OF=y
# CONFIG_MTD_PHYSMAP_VERSATILE is not set
CONFIG_MTD_PHYSMAP_GEMINI=y
# CONFIG_MTD_PHYSMAP_GPIO_ADDR is not set
CONFIG_MTD_AMD76XROM=m
CONFIG_MTD_ICHXROM=m
# CONFIG_MTD_ESB2ROM is not set
CONFIG_MTD_CK804XROM=m
CONFIG_MTD_SCB2_FLASH=m
# CONFIG_MTD_NETtel is not set
CONFIG_MTD_L440GX=m
CONFIG_MTD_PCI=m
CONFIG_MTD_INTEL_VR_NOR=m
CONFIG_MTD_PLATRAM=m
# end of Mapping drivers for chip access

#
# Self-contained MTD device drivers
#
# CONFIG_MTD_PMC551 is not set
CONFIG_MTD_SLRAM=m
# CONFIG_MTD_PHRAM is not set
# CONFIG_MTD_MTDRAM is not set
CONFIG_MTD_BLOCK2MTD=m

#
# Disk-On-Chip Device Drivers
#
CONFIG_MTD_DOCG3=m
CONFIG_BCH_CONST_M=14
CONFIG_BCH_CONST_T=4
# end of Self-contained MTD device drivers

CONFIG_MTD_ONENAND=m
CONFIG_MTD_ONENAND_VERIFY_WRITE=y
# CONFIG_MTD_ONENAND_GENERIC is not set
CONFIG_MTD_ONENAND_OTP=y
CONFIG_MTD_ONENAND_2X_PROGRAM=y
CONFIG_MTD_NAND_ECC_SW_HAMMING=m
# CONFIG_MTD_NAND_ECC_SW_HAMMING_SMC is not set
# CONFIG_MTD_RAW_NAND is not set

#
# LPDDR & LPDDR2 PCM memory drivers
#
CONFIG_MTD_LPDDR=m
CONFIG_MTD_QINFO_PROBE=m
# end of LPDDR & LPDDR2 PCM memory drivers

CONFIG_MTD_UBI=m
CONFIG_MTD_UBI_WL_THRESHOLD=4096
CONFIG_MTD_UBI_BEB_LIMIT=20
# CONFIG_MTD_UBI_FASTMAP is not set
CONFIG_MTD_UBI_GLUEBI=m
CONFIG_MTD_UBI_BLOCK=y
CONFIG_MTD_HYPERBUS=m
CONFIG_DTC=y
CONFIG_OF=y
# CONFIG_OF_UNITTEST is not set
CONFIG_OF_FLATTREE=y
CONFIG_OF_PROMTREE=y
CONFIG_OF_KOBJ=y
CONFIG_OF_DYNAMIC=y
CONFIG_OF_ADDRESS=y
CONFIG_OF_IRQ=y
CONFIG_OF_NET=y
CONFIG_OF_MDIO=y
CONFIG_OF_RESOLVE=y
CONFIG_OF_OVERLAY=y
CONFIG_ARCH_MIGHT_HAVE_PC_PARPORT=y
CONFIG_PARPORT=m
CONFIG_PARPORT_PC=m
CONFIG_PARPORT_SERIAL=m
# CONFIG_PARPORT_PC_FIFO is not set
# CONFIG_PARPORT_PC_SUPERIO is not set
CONFIG_PARPORT_AX88796=m
# CONFIG_PARPORT_1284 is not set
CONFIG_PARPORT_NOT_PC=y
CONFIG_PNP=y
CONFIG_PNP_DEBUG_MESSAGES=y

#
# Protocols
#
# CONFIG_ISAPNP is not set
# CONFIG_PNPBIOS is not set
CONFIG_PNPACPI=y
CONFIG_BLK_DEV=y
CONFIG_BLK_DEV_NULL_BLK=m
CONFIG_BLK_DEV_NULL_BLK_FAULT_INJECTION=y
CONFIG_BLK_DEV_FD=y
CONFIG_CDROM=m
# CONFIG_PARIDE is not set
CONFIG_BLK_DEV_PCIESSD_MTIP32XX=y
# CONFIG_ZRAM is not set
CONFIG_BLK_DEV_UMEM=m
CONFIG_BLK_DEV_LOOP=y
CONFIG_BLK_DEV_LOOP_MIN_COUNT=8
CONFIG_BLK_DEV_CRYPTOLOOP=y
CONFIG_BLK_DEV_DRBD=m
CONFIG_DRBD_FAULT_INJECTION=y
CONFIG_BLK_DEV_NBD=y
CONFIG_BLK_DEV_SX8=m
# CONFIG_BLK_DEV_RAM is not set
CONFIG_CDROM_PKTCDVD=m
CONFIG_CDROM_PKTCDVD_BUFFERS=8
# CONFIG_CDROM_PKTCDVD_WCACHE is not set
CONFIG_ATA_OVER_ETH=m
CONFIG_VIRTIO_BLK=m
CONFIG_BLK_DEV_RBD=m
# CONFIG_BLK_DEV_RSXX is not set

#
# NVME Support
#
CONFIG_NVME_CORE=m
CONFIG_BLK_DEV_NVME=m
CONFIG_NVME_MULTIPATH=y
# CONFIG_NVME_HWMON is not set
# CONFIG_NVME_FC is not set
# CONFIG_NVME_TCP is not set
# CONFIG_NVME_TARGET is not set
# end of NVME Support

#
# Misc devices
#
CONFIG_SENSORS_LIS3LV02D=y
# CONFIG_AD525X_DPOT is not set
CONFIG_DUMMY_IRQ=m
CONFIG_IBM_ASM=m
CONFIG_PHANTOM=y
CONFIG_TIFM_CORE=m
CONFIG_TIFM_7XX1=m
# CONFIG_ICS932S401 is not set
# CONFIG_ENCLOSURE_SERVICES is not set
# CONFIG_CS5535_MFGPT is not set
CONFIG_HP_ILO=y
CONFIG_APDS9802ALS=y
# CONFIG_ISL29003 is not set
# CONFIG_ISL29020 is not set
# CONFIG_SENSORS_TSL2550 is not set
CONFIG_SENSORS_BH1770=m
# CONFIG_SENSORS_APDS990X is not set
CONFIG_HMC6352=y
CONFIG_DS1682=y
# CONFIG_VMWARE_BALLOON is not set
CONFIG_PCH_PHUB=y
# CONFIG_SRAM is not set
CONFIG_PCI_ENDPOINT_TEST=m
# CONFIG_XILINX_SDFEC is not set
CONFIG_MISC_RTSX=y
CONFIG_PVPANIC=y
CONFIG_C2PORT=y
# CONFIG_C2PORT_DURAMAR_2150 is not set

#
# EEPROM support
#
# CONFIG_EEPROM_AT24 is not set
CONFIG_EEPROM_LEGACY=m
# CONFIG_EEPROM_MAX6875 is not set
CONFIG_EEPROM_93CX6=y
# CONFIG_EEPROM_IDT_89HPESX is not set
CONFIG_EEPROM_EE1004=m
# end of EEPROM support

# CONFIG_CB710_CORE is not set

#
# Texas Instruments shared transport line discipline
#
CONFIG_TI_ST=m
# end of Texas Instruments shared transport line discipline

CONFIG_SENSORS_LIS3_I2C=y
# CONFIG_ALTERA_STAPL is not set
CONFIG_INTEL_MEI=y
CONFIG_INTEL_MEI_ME=y
# CONFIG_INTEL_MEI_TXE is not set
CONFIG_INTEL_MEI_HDCP=m
CONFIG_VMWARE_VMCI=m

#
# Intel MIC & related support
#
CONFIG_VOP_BUS=m
# CONFIG_VOP is not set
# end of Intel MIC & related support

CONFIG_ECHO=y
# CONFIG_MISC_ALCOR_PCI is not set
CONFIG_MISC_RTSX_PCI=y
CONFIG_HABANA_AI=m
# end of Misc devices

CONFIG_HAVE_IDE=y
CONFIG_IDE=y

#
# Please see Documentation/ide/ide.rst for help/info on IDE drives
#
CONFIG_IDE_XFER_MODE=y
CONFIG_IDE_TIMINGS=y
CONFIG_IDE_ATAPI=y
CONFIG_IDE_LEGACY=y
# CONFIG_BLK_DEV_IDE_SATA is not set
CONFIG_IDE_GD=y
CONFIG_IDE_GD_ATA=y
CONFIG_IDE_GD_ATAPI=y
CONFIG_BLK_DEV_IDECD=m
# CONFIG_BLK_DEV_IDECD_VERBOSE_ERRORS is not set
CONFIG_BLK_DEV_IDETAPE=y
# CONFIG_BLK_DEV_IDEACPI is not set
# CONFIG_IDE_TASK_IOCTL is not set
CONFIG_IDE_PROC_FS=y

#
# IDE chipset support/bugfixes
#
CONFIG_IDE_GENERIC=y
# CONFIG_BLK_DEV_PLATFORM is not set
# CONFIG_BLK_DEV_CMD640 is not set
# CONFIG_BLK_DEV_IDEPNP is not set
CONFIG_BLK_DEV_IDEDMA_SFF=y

#
# PCI IDE chipsets support
#
CONFIG_BLK_DEV_IDEPCI=y
CONFIG_IDEPCI_PCIBUS_ORDER=y
# CONFIG_BLK_DEV_OFFBOARD is not set
CONFIG_BLK_DEV_GENERIC=m
CONFIG_BLK_DEV_OPTI621=y
CONFIG_BLK_DEV_RZ1000=m
CONFIG_BLK_DEV_IDEDMA_PCI=y
CONFIG_BLK_DEV_AEC62XX=y
# CONFIG_BLK_DEV_ALI15X3 is not set
CONFIG_BLK_DEV_AMD74XX=m
CONFIG_BLK_DEV_ATIIXP=y
CONFIG_BLK_DEV_CMD64X=m
CONFIG_BLK_DEV_TRIFLEX=m
CONFIG_BLK_DEV_CS5520=m
# CONFIG_BLK_DEV_CS5530 is not set
# CONFIG_BLK_DEV_CS5535 is not set
# CONFIG_BLK_DEV_CS5536 is not set
# CONFIG_BLK_DEV_HPT366 is not set
# CONFIG_BLK_DEV_JMICRON is not set
CONFIG_BLK_DEV_SC1200=y
CONFIG_BLK_DEV_PIIX=m
CONFIG_BLK_DEV_IT8172=y
CONFIG_BLK_DEV_IT8213=m
CONFIG_BLK_DEV_IT821X=m
CONFIG_BLK_DEV_NS87415=m
CONFIG_BLK_DEV_PDC202XX_OLD=y
# CONFIG_BLK_DEV_PDC202XX_NEW is not set
CONFIG_BLK_DEV_SVWKS=m
# CONFIG_BLK_DEV_SIIMAGE is not set
CONFIG_BLK_DEV_SIS5513=m
CONFIG_BLK_DEV_SLC90E66=m
CONFIG_BLK_DEV_TRM290=m
CONFIG_BLK_DEV_VIA82CXXX=y
CONFIG_BLK_DEV_TC86C001=y

#
# Other IDE chipsets support
#

#
# Note: most of these also require special kernel boot parameters
#
CONFIG_BLK_DEV_4DRIVES=y
CONFIG_BLK_DEV_ALI14XX=m
# CONFIG_BLK_DEV_DTC2278 is not set
CONFIG_BLK_DEV_HT6560B=m
CONFIG_BLK_DEV_QD65XX=y
CONFIG_BLK_DEV_UMC8672=y
CONFIG_BLK_DEV_IDEDMA=y

#
# SCSI device support
#
CONFIG_SCSI_MOD=y
CONFIG_RAID_ATTRS=y
CONFIG_SCSI=y
CONFIG_SCSI_DMA=y
CONFIG_SCSI_NETLINK=y
# CONFIG_SCSI_PROC_FS is not set

#
# SCSI support type (disk, tape, CD-ROM)
#
CONFIG_BLK_DEV_SD=y
CONFIG_CHR_DEV_ST=m
CONFIG_BLK_DEV_SR=m
CONFIG_CHR_DEV_SG=y
CONFIG_CHR_DEV_SCH=y
CONFIG_SCSI_CONSTANTS=y
# CONFIG_SCSI_LOGGING is not set
# CONFIG_SCSI_SCAN_ASYNC is not set

#
# SCSI Transports
#
CONFIG_SCSI_SPI_ATTRS=y
CONFIG_SCSI_FC_ATTRS=m
CONFIG_SCSI_ISCSI_ATTRS=y
CONFIG_SCSI_SAS_ATTRS=y
CONFIG_SCSI_SAS_LIBSAS=y
# CONFIG_SCSI_SAS_ATA is not set
CONFIG_SCSI_SAS_HOST_SMP=y
# CONFIG_SCSI_SRP_ATTRS is not set
# end of SCSI Transports

CONFIG_SCSI_LOWLEVEL=y
CONFIG_ISCSI_TCP=y
CONFIG_ISCSI_BOOT_SYSFS=m
CONFIG_SCSI_CXGB3_ISCSI=m
CONFIG_SCSI_CXGB4_ISCSI=m
CONFIG_SCSI_BNX2_ISCSI=m
# CONFIG_SCSI_BNX2X_FCOE is not set
# CONFIG_BE2ISCSI is not set
CONFIG_BLK_DEV_3W_XXXX_RAID=y
CONFIG_SCSI_HPSA=m
CONFIG_SCSI_3W_9XXX=y
# CONFIG_SCSI_3W_SAS is not set
# CONFIG_SCSI_ACARD is not set
CONFIG_SCSI_AHA152X=m
CONFIG_SCSI_AHA1542=y
# CONFIG_SCSI_AHA1740 is not set
# CONFIG_SCSI_AACRAID is not set
CONFIG_SCSI_AIC7XXX=y
CONFIG_AIC7XXX_CMDS_PER_DEVICE=32
CONFIG_AIC7XXX_RESET_DELAY_MS=5000
CONFIG_AIC7XXX_DEBUG_ENABLE=y
CONFIG_AIC7XXX_DEBUG_MASK=0
CONFIG_AIC7XXX_REG_PRETTY_PRINT=y
# CONFIG_SCSI_AIC79XX is not set
CONFIG_SCSI_AIC94XX=m
# CONFIG_AIC94XX_DEBUG is not set
CONFIG_SCSI_MVSAS=y
# CONFIG_SCSI_MVSAS_DEBUG is not set
CONFIG_SCSI_MVSAS_TASKLET=y
# CONFIG_SCSI_MVUMI is not set
# CONFIG_SCSI_DPT_I2O is not set
CONFIG_SCSI_ADVANSYS=y
CONFIG_SCSI_ARCMSR=y
CONFIG_SCSI_ESAS2R=y
CONFIG_MEGARAID_NEWGEN=y
# CONFIG_MEGARAID_MM is not set
# CONFIG_MEGARAID_LEGACY is not set
# CONFIG_MEGARAID_SAS is not set
CONFIG_SCSI_MPT3SAS=y
CONFIG_SCSI_MPT2SAS_MAX_SGE=128
CONFIG_SCSI_MPT3SAS_MAX_SGE=128
# CONFIG_SCSI_MPT2SAS is not set
# CONFIG_SCSI_SMARTPQI is not set
CONFIG_SCSI_UFSHCD=y
CONFIG_SCSI_UFSHCD_PCI=y
CONFIG_SCSI_UFS_DWC_TC_PCI=y
CONFIG_SCSI_UFSHCD_PLATFORM=y
# CONFIG_SCSI_UFS_CDNS_PLATFORM is not set
CONFIG_SCSI_UFS_DWC_TC_PLATFORM=y
CONFIG_SCSI_UFS_BSG=y
CONFIG_SCSI_HPTIOP=m
# CONFIG_SCSI_BUSLOGIC is not set
CONFIG_SCSI_MYRB=m
CONFIG_SCSI_MYRS=m
CONFIG_VMWARE_PVSCSI=m
CONFIG_LIBFC=m
CONFIG_LIBFCOE=m
CONFIG_FCOE=m
# CONFIG_FCOE_FNIC is not set
CONFIG_SCSI_SNIC=m
# CONFIG_SCSI_SNIC_DEBUG_FS is not set
CONFIG_SCSI_DMX3191D=y
CONFIG_SCSI_FDOMAIN=y
CONFIG_SCSI_FDOMAIN_PCI=y
CONFIG_SCSI_FDOMAIN_ISA=y
CONFIG_SCSI_GDTH=m
CONFIG_SCSI_ISCI=m
# CONFIG_SCSI_GENERIC_NCR5380 is not set
CONFIG_SCSI_IPS=y
# CONFIG_SCSI_INITIO is not set
# CONFIG_SCSI_INIA100 is not set
# CONFIG_SCSI_PPA is not set
CONFIG_SCSI_IMM=m
CONFIG_SCSI_IZIP_EPP16=y
CONFIG_SCSI_IZIP_SLOW_CTR=y
CONFIG_SCSI_STEX=y
CONFIG_SCSI_SYM53C8XX_2=y
CONFIG_SCSI_SYM53C8XX_DMA_ADDRESSING_MODE=1
CONFIG_SCSI_SYM53C8XX_DEFAULT_TAGS=16
CONFIG_SCSI_SYM53C8XX_MAX_TAGS=64
CONFIG_SCSI_SYM53C8XX_MMIO=y
CONFIG_SCSI_IPR=m
CONFIG_SCSI_IPR_TRACE=y
# CONFIG_SCSI_IPR_DUMP is not set
CONFIG_SCSI_QLOGIC_FAS=m
# CONFIG_SCSI_QLOGIC_1280 is not set
# CONFIG_SCSI_QLA_FC is not set
CONFIG_SCSI_QLA_ISCSI=m
# CONFIG_SCSI_LPFC is not set
# CONFIG_SCSI_SIM710 is not set
CONFIG_SCSI_DC395x=y
CONFIG_SCSI_AM53C974=m
CONFIG_SCSI_NSP32=y
CONFIG_SCSI_WD719X=y
# CONFIG_SCSI_DEBUG is not set
# CONFIG_SCSI_PMCRAID is not set
CONFIG_SCSI_PM8001=y
# CONFIG_SCSI_BFA_FC is not set
CONFIG_SCSI_VIRTIO=y
CONFIG_SCSI_CHELSIO_FCOE=m
# CONFIG_SCSI_DH is not set
# end of SCSI device support

CONFIG_ATA=y
CONFIG_SATA_HOST=y
CONFIG_PATA_TIMINGS=y
CONFIG_ATA_VERBOSE_ERROR=y
CONFIG_ATA_FORCE=y
CONFIG_ATA_ACPI=y
# CONFIG_SATA_ZPODD is not set
CONFIG_SATA_PMP=y

#
# Controllers with non-SFF native interface
#
# CONFIG_SATA_AHCI is not set
CONFIG_SATA_AHCI_PLATFORM=m
CONFIG_AHCI_CEVA=y
CONFIG_AHCI_QORIQ=m
CONFIG_SATA_INIC162X=m
# CONFIG_SATA_ACARD_AHCI is not set
CONFIG_SATA_SIL24=m
# CONFIG_ATA_SFF is not set
CONFIG_MD=y
CONFIG_BLK_DEV_MD=y
# CONFIG_MD_AUTODETECT is not set
CONFIG_MD_LINEAR=y
CONFIG_MD_RAID0=m
CONFIG_MD_RAID1=m
CONFIG_MD_RAID10=m
CONFIG_MD_RAID456=y
CONFIG_MD_MULTIPATH=m
CONFIG_MD_FAULTY=y
# CONFIG_BCACHE is not set
CONFIG_BLK_DEV_DM_BUILTIN=y
CONFIG_BLK_DEV_DM=m
CONFIG_DM_DEBUG=y
CONFIG_DM_BUFIO=m
# CONFIG_DM_DEBUG_BLOCK_MANAGER_LOCKING is not set
CONFIG_DM_BIO_PRISON=m
CONFIG_DM_PERSISTENT_DATA=m
CONFIG_DM_UNSTRIPED=m
# CONFIG_DM_CRYPT is not set
CONFIG_DM_SNAPSHOT=m
# CONFIG_DM_THIN_PROVISIONING is not set
# CONFIG_DM_CACHE is not set
CONFIG_DM_WRITECACHE=m
CONFIG_DM_ERA=m
CONFIG_DM_CLONE=m
# CONFIG_DM_MIRROR is not set
CONFIG_DM_RAID=m
CONFIG_DM_ZERO=m
CONFIG_DM_MULTIPATH=m
CONFIG_DM_MULTIPATH_QL=m
# CONFIG_DM_MULTIPATH_ST is not set
CONFIG_DM_DELAY=m
CONFIG_DM_DUST=m
# CONFIG_DM_UEVENT is not set
CONFIG_DM_FLAKEY=m
CONFIG_DM_VERITY=m
# CONFIG_DM_VERITY_VERIFY_ROOTHASH_SIG is not set
# CONFIG_DM_VERITY_FEC is not set
CONFIG_DM_SWITCH=m
# CONFIG_DM_LOG_WRITES is not set
CONFIG_DM_INTEGRITY=m
# CONFIG_TARGET_CORE is not set
# CONFIG_FUSION is not set

#
# IEEE 1394 (FireWire) support
#
# CONFIG_FIREWIRE is not set
CONFIG_FIREWIRE_NOSY=m
# end of IEEE 1394 (FireWire) support

CONFIG_MACINTOSH_DRIVERS=y
CONFIG_MAC_EMUMOUSEBTN=m
CONFIG_NETDEVICES=y
CONFIG_MII=y
CONFIG_NET_CORE=y
CONFIG_BONDING=y
# CONFIG_DUMMY is not set
# CONFIG_WIREGUARD is not set
# CONFIG_EQUALIZER is not set
# CONFIG_NET_FC is not set
# CONFIG_NET_TEAM is not set
CONFIG_MACVLAN=m
# CONFIG_MACVTAP is not set
CONFIG_IPVLAN=m
# CONFIG_IPVTAP is not set
CONFIG_VXLAN=y
# CONFIG_GENEVE is not set
# CONFIG_BAREUDP is not set
CONFIG_GTP=y
CONFIG_MACSEC=y
CONFIG_NETCONSOLE=m
CONFIG_NETCONSOLE_DYNAMIC=y
CONFIG_NETPOLL=y
CONFIG_NET_POLL_CONTROLLER=y
CONFIG_NTB_NETDEV=m
CONFIG_RIONET=m
CONFIG_RIONET_TX_SIZE=128
CONFIG_RIONET_RX_SIZE=128
CONFIG_TUN=m
CONFIG_TUN_VNET_CROSS_LE=y
CONFIG_VETH=m
CONFIG_VIRTIO_NET=y
CONFIG_NLMON=y
CONFIG_NET_VRF=y
CONFIG_ARCNET=m
CONFIG_ARCNET_1201=m
CONFIG_ARCNET_1051=m
CONFIG_ARCNET_RAW=m
# CONFIG_ARCNET_CAP is not set
# CONFIG_ARCNET_COM90xx is not set
CONFIG_ARCNET_COM90xxIO=m
CONFIG_ARCNET_RIM_I=m
# CONFIG_ARCNET_COM20020 is not set
# CONFIG_CAIF_DRIVERS is not set

#
# Distributed Switch Architecture drivers
#
CONFIG_B53=m
# CONFIG_B53_MDIO_DRIVER is not set
# CONFIG_B53_MMAP_DRIVER is not set
# CONFIG_B53_SRAB_DRIVER is not set
CONFIG_B53_SERDES=m
CONFIG_NET_DSA_BCM_SF2=m
CONFIG_NET_DSA_LOOP=m
CONFIG_NET_DSA_LANTIQ_GSWIP=m
# CONFIG_NET_DSA_MT7530 is not set
CONFIG_NET_DSA_MV88E6060=m
CONFIG_NET_DSA_MICROCHIP_KSZ_COMMON=m
CONFIG_NET_DSA_MICROCHIP_KSZ9477=m
CONFIG_NET_DSA_MICROCHIP_KSZ9477_I2C=m
CONFIG_NET_DSA_MICROCHIP_KSZ8795=m
CONFIG_NET_DSA_MV88E6XXX=m
CONFIG_NET_DSA_MV88E6XXX_GLOBAL2=y
# CONFIG_NET_DSA_MV88E6XXX_PTP is not set
# CONFIG_NET_DSA_AR9331 is not set
CONFIG_NET_DSA_QCA8K=m
CONFIG_NET_DSA_REALTEK_SMI=m
CONFIG_NET_DSA_SMSC_LAN9303=m
CONFIG_NET_DSA_SMSC_LAN9303_I2C=m
# CONFIG_NET_DSA_SMSC_LAN9303_MDIO is not set
CONFIG_NET_DSA_VITESSE_VSC73XX=m
CONFIG_NET_DSA_VITESSE_VSC73XX_PLATFORM=m
# end of Distributed Switch Architecture drivers

CONFIG_ETHERNET=y
CONFIG_MDIO=y
CONFIG_NET_VENDOR_3COM=y
CONFIG_EL3=y
CONFIG_3C515=y
CONFIG_VORTEX=y
CONFIG_TYPHOON=m
CONFIG_NET_VENDOR_ADAPTEC=y
# CONFIG_ADAPTEC_STARFIRE is not set
# CONFIG_NET_VENDOR_AGERE is not set
CONFIG_NET_VENDOR_ALACRITECH=y
CONFIG_SLICOSS=m
CONFIG_NET_VENDOR_ALTEON=y
CONFIG_ACENIC=y
# CONFIG_ACENIC_OMIT_TIGON_I is not set
# CONFIG_ALTERA_TSE is not set
CONFIG_NET_VENDOR_AMAZON=y
CONFIG_NET_VENDOR_AMD=y
# CONFIG_AMD8111_ETH is not set
CONFIG_LANCE=m
# CONFIG_PCNET32 is not set
CONFIG_NI65=m
# CONFIG_AMD_XGBE is not set
CONFIG_NET_VENDOR_AQUANTIA=y
# CONFIG_NET_VENDOR_ARC is not set
CONFIG_NET_VENDOR_ATHEROS=y
CONFIG_ATL2=m
CONFIG_ATL1=m
CONFIG_ATL1E=m
CONFIG_ATL1C=m
CONFIG_ALX=y
CONFIG_NET_VENDOR_AURORA=y
# CONFIG_AURORA_NB8800 is not set
CONFIG_NET_VENDOR_BROADCOM=y
# CONFIG_B44 is not set
CONFIG_BCMGENET=y
CONFIG_BNX2=y
CONFIG_CNIC=y
# CONFIG_TIGON3 is not set
CONFIG_BNX2X=y
# CONFIG_BNX2X_SRIOV is not set
# CONFIG_SYSTEMPORT is not set
CONFIG_BNXT=y
# CONFIG_BNXT_SRIOV is not set
# CONFIG_BNXT_FLOWER_OFFLOAD is not set
# CONFIG_BNXT_DCB is not set
# CONFIG_BNXT_HWMON is not set
# CONFIG_NET_VENDOR_BROCADE is not set
# CONFIG_NET_VENDOR_CADENCE is not set
CONFIG_NET_VENDOR_CAVIUM=y
CONFIG_NET_VENDOR_CHELSIO=y
CONFIG_CHELSIO_T1=y
# CONFIG_CHELSIO_T1_1G is not set
CONFIG_CHELSIO_T3=y
CONFIG_CHELSIO_T4=m
CONFIG_CHELSIO_T4_DCB=y
CONFIG_CHELSIO_T4_FCOE=y
# CONFIG_CHELSIO_T4VF is not set
CONFIG_CHELSIO_LIB=m
# CONFIG_NET_VENDOR_CIRRUS is not set
CONFIG_NET_VENDOR_CISCO=y
# CONFIG_ENIC is not set
# CONFIG_NET_VENDOR_CORTINA is not set
CONFIG_CX_ECAT=m
CONFIG_DNET=y
# CONFIG_NET_VENDOR_DEC is not set
CONFIG_NET_VENDOR_DLINK=y
# CONFIG_DL2K is not set
CONFIG_SUNDANCE=m
# CONFIG_SUNDANCE_MMIO is not set
CONFIG_NET_VENDOR_EMULEX=y
CONFIG_BE2NET=y
CONFIG_BE2NET_HWMON=y
# CONFIG_BE2NET_BE2 is not set
# CONFIG_BE2NET_BE3 is not set
CONFIG_BE2NET_LANCER=y
CONFIG_BE2NET_SKYHAWK=y
CONFIG_NET_VENDOR_EZCHIP=y
CONFIG_EZCHIP_NPS_MANAGEMENT_ENET=y
# CONFIG_NET_VENDOR_GOOGLE is not set
# CONFIG_NET_VENDOR_HUAWEI is not set
CONFIG_NET_VENDOR_I825XX=y
CONFIG_NET_VENDOR_INTEL=y
CONFIG_E100=m
CONFIG_E1000=y
# CONFIG_E1000E is not set
CONFIG_IGB=m
# CONFIG_IGB_HWMON is not set
CONFIG_IGBVF=m
# CONFIG_IXGB is not set
CONFIG_IXGBE=y
# CONFIG_IXGBE_HWMON is not set
CONFIG_IXGBE_DCB=y
# CONFIG_IXGBE_IPSEC is not set
# CONFIG_I40E is not set
# CONFIG_IGC is not set
CONFIG_JME=m
CONFIG_NET_VENDOR_MARVELL=y
CONFIG_MVMDIO=y
# CONFIG_SKGE is not set
CONFIG_SKY2=y
# CONFIG_SKY2_DEBUG is not set
# CONFIG_NET_VENDOR_MELLANOX is not set
CONFIG_NET_VENDOR_MICREL=y
CONFIG_KS8842=y
# CONFIG_KS8851_MLL is not set
CONFIG_KSZ884X_PCI=y
CONFIG_NET_VENDOR_MICROCHIP=y
CONFIG_LAN743X=m
CONFIG_NET_VENDOR_MICROSEMI=y
# CONFIG_MSCC_OCELOT_SWITCH is not set
CONFIG_NET_VENDOR_MYRI=y
CONFIG_MYRI10GE=m
# CONFIG_FEALNX is not set
# CONFIG_NET_VENDOR_NATSEMI is not set
# CONFIG_NET_VENDOR_NETERION is not set
# CONFIG_NET_VENDOR_NETRONOME is not set
CONFIG_NET_VENDOR_NI=y
CONFIG_NI_XGE_MANAGEMENT_ENET=m
CONFIG_NET_VENDOR_NVIDIA=y
# CONFIG_FORCEDETH is not set
# CONFIG_NET_VENDOR_OKI is not set
CONFIG_ETHOC=y
CONFIG_NET_VENDOR_PACKET_ENGINES=y
CONFIG_HAMACHI=m
CONFIG_YELLOWFIN=y
CONFIG_NET_VENDOR_PENSANDO=y
# CONFIG_NET_VENDOR_QLOGIC is not set
CONFIG_NET_VENDOR_QUALCOMM=y
# CONFIG_QCA7000_UART is not set
CONFIG_QCOM_EMAC=y
# CONFIG_RMNET is not set
# CONFIG_NET_VENDOR_RDC is not set
CONFIG_NET_VENDOR_REALTEK=y
CONFIG_ATP=m
# CONFIG_8139CP is not set
CONFIG_8139TOO=y
# CONFIG_8139TOO_PIO is not set
# CONFIG_8139TOO_TUNE_TWISTER is not set
CONFIG_8139TOO_8129=y
CONFIG_8139_OLD_RX_RESET=y
CONFIG_R8169=m
CONFIG_NET_VENDOR_RENESAS=y
CONFIG_NET_VENDOR_ROCKER=y
# CONFIG_ROCKER is not set
CONFIG_NET_VENDOR_SAMSUNG=y
CONFIG_SXGBE_ETH=y
# CONFIG_NET_VENDOR_SEEQ is not set
# CONFIG_NET_VENDOR_SOLARFLARE is not set
CONFIG_NET_VENDOR_SILAN=y
CONFIG_SC92031=y
# CONFIG_NET_VENDOR_SIS is not set
CONFIG_NET_VENDOR_SMSC=y
# CONFIG_SMC9194 is not set
CONFIG_EPIC100=y
CONFIG_SMSC911X=m
# CONFIG_SMSC9420 is not set
# CONFIG_NET_VENDOR_SOCIONEXT is not set
CONFIG_NET_VENDOR_STMICRO=y
CONFIG_STMMAC_ETH=m
CONFIG_STMMAC_SELFTESTS=y
# CONFIG_STMMAC_PLATFORM is not set
CONFIG_DWMAC_INTEL=m
CONFIG_STMMAC_PCI=m
# CONFIG_NET_VENDOR_SUN is not set
# CONFIG_NET_VENDOR_SYNOPSYS is not set
CONFIG_NET_VENDOR_TEHUTI=y
# CONFIG_TEHUTI is not set
# CONFIG_NET_VENDOR_TI is not set
# CONFIG_NET_VENDOR_VIA is not set
CONFIG_NET_VENDOR_WIZNET=y
# CONFIG_WIZNET_W5100 is not set
# CONFIG_WIZNET_W5300 is not set
CONFIG_NET_VENDOR_XILINX=y
# CONFIG_XILINX_AXI_EMAC is not set
CONFIG_XILINX_LL_TEMAC=y
# CONFIG_FDDI is not set
CONFIG_HIPPI=y
CONFIG_ROADRUNNER=m
CONFIG_ROADRUNNER_LARGE_RINGS=y
# CONFIG_NET_SB1000 is not set
CONFIG_MDIO_DEVICE=y
CONFIG_MDIO_BUS=y
CONFIG_MDIO_BCM_UNIMAC=y
CONFIG_MDIO_BITBANG=y
CONFIG_MDIO_BUS_MUX=y
CONFIG_MDIO_BUS_MUX_GPIO=m
# CONFIG_MDIO_BUS_MUX_MMIOREG is not set
CONFIG_MDIO_BUS_MUX_MULTIPLEXER=y
# CONFIG_MDIO_GPIO is not set
CONFIG_MDIO_HISI_FEMAC=y
CONFIG_MDIO_I2C=m
# CONFIG_MDIO_IPQ8064 is not set
# CONFIG_MDIO_MSCC_MIIM is not set
CONFIG_MDIO_XPCS=m
CONFIG_PHYLINK=m
CONFIG_PHYLIB=y
CONFIG_SWPHY=y
CONFIG_LED_TRIGGER_PHY=y

#
# MII PHY device drivers
#
CONFIG_SFP=m
CONFIG_ADIN_PHY=y
# CONFIG_AMD_PHY is not set
CONFIG_AQUANTIA_PHY=m
CONFIG_AX88796B_PHY=y
CONFIG_BCM7XXX_PHY=y
CONFIG_BCM87XX_PHY=y
CONFIG_BCM_NET_PHYLIB=y
# CONFIG_BROADCOM_PHY is not set
# CONFIG_BCM84881_PHY is not set
# CONFIG_CICADA_PHY is not set
CONFIG_CORTINA_PHY=y
CONFIG_DAVICOM_PHY=y
CONFIG_DP83822_PHY=m
# CONFIG_DP83TC811_PHY is not set
# CONFIG_DP83848_PHY is not set
# CONFIG_DP83867_PHY is not set
# CONFIG_DP83869_PHY is not set
CONFIG_FIXED_PHY=y
CONFIG_ICPLUS_PHY=m
# CONFIG_INTEL_XWAY_PHY is not set
CONFIG_LSI_ET1011C_PHY=y
CONFIG_LXT_PHY=y
CONFIG_MARVELL_PHY=m
CONFIG_MARVELL_10G_PHY=m
# CONFIG_MICREL_PHY is not set
CONFIG_MICROCHIP_PHY=y
CONFIG_MICROCHIP_T1_PHY=y
# CONFIG_MICROSEMI_PHY is not set
CONFIG_NATIONAL_PHY=y
# CONFIG_NXP_TJA11XX_PHY is not set
CONFIG_AT803X_PHY=m
CONFIG_QSEMI_PHY=y
CONFIG_REALTEK_PHY=m
CONFIG_RENESAS_PHY=m
# CONFIG_ROCKCHIP_PHY is not set
CONFIG_SMSC_PHY=m
# CONFIG_STE10XP is not set
CONFIG_TERANETICS_PHY=y
CONFIG_VITESSE_PHY=m
CONFIG_XILINX_GMII2RGMII=y
CONFIG_PLIP=m
CONFIG_PPP=m
CONFIG_PPP_BSDCOMP=m
# CONFIG_PPP_DEFLATE is not set
# CONFIG_PPP_FILTER is not set
CONFIG_PPP_MPPE=m
CONFIG_PPP_MULTILINK=y
CONFIG_PPPOE=m
CONFIG_PPPOL2TP=m
CONFIG_PPP_ASYNC=m
# CONFIG_PPP_SYNC_TTY is not set
# CONFIG_SLIP is not set
CONFIG_SLHC=m

#
# Host-side USB support is needed for USB Network Adapter support
#
# CONFIG_WLAN is not set

#
# WiMAX Wireless Broadband devices
#

#
# Enable USB support to see WiMAX USB drivers
#
# end of WiMAX Wireless Broadband devices

CONFIG_WAN=y
# CONFIG_HOSTESS_SV11 is not set
# CONFIG_COSA is not set
CONFIG_LANMEDIA=m
CONFIG_SEALEVEL_4021=m
CONFIG_HDLC=m
CONFIG_HDLC_RAW=m
CONFIG_HDLC_RAW_ETH=m
CONFIG_HDLC_CISCO=m
CONFIG_HDLC_FR=m
# CONFIG_HDLC_PPP is not set
# CONFIG_HDLC_X25 is not set
# CONFIG_PCI200SYN is not set
CONFIG_WANXL=m
# CONFIG_PC300TOO is not set
# CONFIG_N2 is not set
# CONFIG_C101 is not set
CONFIG_FARSYNC=m
CONFIG_DLCI=y
CONFIG_DLCI_MAX=8
CONFIG_SDLA=y
# CONFIG_LAPBETHER is not set
# CONFIG_X25_ASY is not set
CONFIG_SBNI=m
CONFIG_SBNI_MULTILINE=y
CONFIG_VMXNET3=m
# CONFIG_FUJITSU_ES is not set
CONFIG_NETDEVSIM=m
CONFIG_NET_FAILOVER=y
# CONFIG_ISDN is not set
CONFIG_NVM=y
# CONFIG_NVM_PBLK is not set

#
# Input device support
#
CONFIG_INPUT=y
CONFIG_INPUT_LEDS=y
CONFIG_INPUT_FF_MEMLESS=y
CONFIG_INPUT_POLLDEV=y
CONFIG_INPUT_SPARSEKMAP=y
CONFIG_INPUT_MATRIXKMAP=y

#
# Userland interfaces
#
CONFIG_INPUT_MOUSEDEV=y
CONFIG_INPUT_MOUSEDEV_PSAUX=y
CONFIG_INPUT_MOUSEDEV_SCREEN_X=1024
CONFIG_INPUT_MOUSEDEV_SCREEN_Y=768
CONFIG_INPUT_JOYDEV=y
CONFIG_INPUT_EVDEV=y
CONFIG_INPUT_EVBUG=m

#
# Input Device Drivers
#
CONFIG_INPUT_KEYBOARD=y
CONFIG_KEYBOARD_ADC=m
CONFIG_KEYBOARD_ADP5520=m
# CONFIG_KEYBOARD_ADP5588 is not set
CONFIG_KEYBOARD_ADP5589=m
CONFIG_KEYBOARD_ATKBD=y
CONFIG_KEYBOARD_QT1050=y
CONFIG_KEYBOARD_QT1070=m
# CONFIG_KEYBOARD_QT2160 is not set
# CONFIG_KEYBOARD_DLINK_DIR685 is not set
CONFIG_KEYBOARD_LKKBD=m
CONFIG_KEYBOARD_GPIO=m
CONFIG_KEYBOARD_GPIO_POLLED=m
CONFIG_KEYBOARD_TCA6416=y
# CONFIG_KEYBOARD_TCA8418 is not set
# CONFIG_KEYBOARD_MATRIX is not set
# CONFIG_KEYBOARD_LM8323 is not set
# CONFIG_KEYBOARD_LM8333 is not set
CONFIG_KEYBOARD_MAX7359=m
# CONFIG_KEYBOARD_MCS is not set
CONFIG_KEYBOARD_MPR121=y
CONFIG_KEYBOARD_NEWTON=y
# CONFIG_KEYBOARD_OPENCORES is not set
CONFIG_KEYBOARD_SAMSUNG=y
CONFIG_KEYBOARD_GOLDFISH_EVENTS=y
CONFIG_KEYBOARD_STOWAWAY=m
CONFIG_KEYBOARD_SUNKBD=m
# CONFIG_KEYBOARD_STMPE is not set
CONFIG_KEYBOARD_OMAP4=m
# CONFIG_KEYBOARD_TM2_TOUCHKEY is not set
CONFIG_KEYBOARD_TWL4030=y
CONFIG_KEYBOARD_XTKBD=m
CONFIG_KEYBOARD_CAP11XX=y
CONFIG_KEYBOARD_BCM=m
CONFIG_KEYBOARD_MTK_PMIC=y
# CONFIG_INPUT_MOUSE is not set
# CONFIG_INPUT_JOYSTICK is not set
CONFIG_INPUT_TABLET=y
# CONFIG_TABLET_USB_ACECAD is not set
# CONFIG_TABLET_USB_AIPTEK is not set
# CONFIG_TABLET_USB_HANWANG is not set
# CONFIG_TABLET_USB_KBTAB is not set
# CONFIG_TABLET_USB_PEGASUS is not set
# CONFIG_TABLET_SERIAL_WACOM4 is not set
# CONFIG_INPUT_TOUCHSCREEN is not set
CONFIG_INPUT_MISC=y
CONFIG_INPUT_88PM80X_ONKEY=m
CONFIG_INPUT_AD714X=y
CONFIG_INPUT_AD714X_I2C=y
# CONFIG_INPUT_ATMEL_CAPTOUCH is not set
CONFIG_INPUT_BMA150=m
CONFIG_INPUT_E3X0_BUTTON=y
# CONFIG_INPUT_MSM_VIBRATOR is not set
# CONFIG_INPUT_MAX77693_HAPTIC is not set
CONFIG_INPUT_MAX8925_ONKEY=m
CONFIG_INPUT_MMA8450=y
CONFIG_INPUT_APANEL=y
# CONFIG_INPUT_GP2A is not set
CONFIG_INPUT_GPIO_BEEPER=m
# CONFIG_INPUT_GPIO_DECODER is not set
# CONFIG_INPUT_GPIO_VIBRA is not set
CONFIG_INPUT_WISTRON_BTNS=m
# CONFIG_INPUT_ATLAS_BTNS is not set
# CONFIG_INPUT_ATI_REMOTE2 is not set
# CONFIG_INPUT_KEYSPAN_REMOTE is not set
CONFIG_INPUT_KXTJ9=y
# CONFIG_INPUT_POWERMATE is not set
# CONFIG_INPUT_YEALINK is not set
# CONFIG_INPUT_CM109 is not set
# CONFIG_INPUT_REGULATOR_HAPTIC is not set
CONFIG_INPUT_TPS65218_PWRBUTTON=m
CONFIG_INPUT_AXP20X_PEK=m
CONFIG_INPUT_TWL4030_PWRBUTTON=y
# CONFIG_INPUT_TWL4030_VIBRA is not set
# CONFIG_INPUT_TWL6040_VIBRA is not set
CONFIG_INPUT_UINPUT=m
# CONFIG_INPUT_PALMAS_PWRBUTTON is not set
CONFIG_INPUT_PCF8574=m
# CONFIG_INPUT_PWM_BEEPER is not set
CONFIG_INPUT_PWM_VIBRA=y
# CONFIG_INPUT_GPIO_ROTARY_ENCODER is not set
CONFIG_INPUT_DA9063_ONKEY=m
CONFIG_INPUT_ADXL34X=y
CONFIG_INPUT_ADXL34X_I2C=y
# CONFIG_INPUT_CMA3000 is not set
# CONFIG_INPUT_IDEAPAD_SLIDEBAR is not set
# CONFIG_INPUT_SOC_BUTTON_ARRAY is not set
# CONFIG_INPUT_DRV260X_HAPTICS is not set
CONFIG_INPUT_DRV2665_HAPTICS=y
CONFIG_INPUT_DRV2667_HAPTICS=y
# CONFIG_INPUT_RAVE_SP_PWRBUTTON is not set
CONFIG_INPUT_STPMIC1_ONKEY=m
CONFIG_RMI4_CORE=m
# CONFIG_RMI4_I2C is not set
# CONFIG_RMI4_SMB is not set
CONFIG_RMI4_F03=y
CONFIG_RMI4_F03_SERIO=m
CONFIG_RMI4_2D_SENSOR=y
CONFIG_RMI4_F11=y
CONFIG_RMI4_F12=y
CONFIG_RMI4_F30=y
# CONFIG_RMI4_F34 is not set
# CONFIG_RMI4_F54 is not set
# CONFIG_RMI4_F55 is not set

#
# Hardware I/O ports
#
CONFIG_SERIO=y
CONFIG_ARCH_MIGHT_HAVE_PC_SERIO=y
CONFIG_SERIO_I8042=y
CONFIG_SERIO_SERPORT=m
CONFIG_SERIO_CT82C710=m
CONFIG_SERIO_PARKBD=m
# CONFIG_SERIO_PCIPS2 is not set
CONFIG_SERIO_LIBPS2=y
# CONFIG_SERIO_RAW is not set
# CONFIG_SERIO_ALTERA_PS2 is not set
CONFIG_SERIO_PS2MULT=y
CONFIG_SERIO_ARC_PS2=y
CONFIG_SERIO_APBPS2=y
CONFIG_SERIO_GPIO_PS2=y
CONFIG_USERIO=m
CONFIG_GAMEPORT=y
# CONFIG_GAMEPORT_NS558 is not set
CONFIG_GAMEPORT_L4=y
CONFIG_GAMEPORT_EMU10K1=m
CONFIG_GAMEPORT_FM801=m
# end of Hardware I/O ports
# end of Input device support

#
# Character devices
#
CONFIG_TTY=y
# CONFIG_VT is not set
CONFIG_UNIX98_PTYS=y
CONFIG_LEGACY_PTYS=y
CONFIG_LEGACY_PTY_COUNT=256
# CONFIG_LDISC_AUTOLOAD is not set

#
# Serial drivers
#
CONFIG_SERIAL_EARLYCON=y
CONFIG_SERIAL_8250=y
# CONFIG_SERIAL_8250_DEPRECATED_OPTIONS is not set
CONFIG_SERIAL_8250_PNP=y
# CONFIG_SERIAL_8250_16550A_VARIANTS is not set
CONFIG_SERIAL_8250_FINTEK=y
CONFIG_SERIAL_8250_CONSOLE=y
# CONFIG_SERIAL_8250_DMA is not set
CONFIG_SERIAL_8250_PCI=m
CONFIG_SERIAL_8250_EXAR=m
# CONFIG_SERIAL_8250_MEN_MCB is not set
CONFIG_SERIAL_8250_NR_UARTS=4
CONFIG_SERIAL_8250_RUNTIME_UARTS=4
CONFIG_SERIAL_8250_EXTENDED=y
CONFIG_SERIAL_8250_MANY_PORTS=y
CONFIG_SERIAL_8250_FOURPORT=m
CONFIG_SERIAL_8250_ACCENT=y
CONFIG_SERIAL_8250_ASPEED_VUART=m
CONFIG_SERIAL_8250_BOCA=m
# CONFIG_SERIAL_8250_EXAR_ST16C554 is not set
CONFIG_SERIAL_8250_HUB6=m
CONFIG_SERIAL_8250_SHARE_IRQ=y
# CONFIG_SERIAL_8250_DETECT_IRQ is not set
CONFIG_SERIAL_8250_RSA=y
CONFIG_SERIAL_8250_DWLIB=y
CONFIG_SERIAL_8250_DW=m
# CONFIG_SERIAL_8250_RT288X is not set
CONFIG_SERIAL_8250_LPSS=m
# CONFIG_SERIAL_8250_MID is not set
# CONFIG_SERIAL_OF_PLATFORM is not set

#
# Non-8250 serial port support
#
CONFIG_SERIAL_UARTLITE=m
CONFIG_SERIAL_UARTLITE_NR_UARTS=1
CONFIG_SERIAL_CORE=y
CONFIG_SERIAL_CORE_CONSOLE=y
CONFIG_SERIAL_JSM=m
CONFIG_SERIAL_SIFIVE=y
# CONFIG_SERIAL_SIFIVE_CONSOLE is not set
CONFIG_SERIAL_SCCNXP=y
# CONFIG_SERIAL_SCCNXP_CONSOLE is not set
CONFIG_SERIAL_SC16IS7XX_CORE=y
CONFIG_SERIAL_SC16IS7XX=y
CONFIG_SERIAL_SC16IS7XX_I2C=y
CONFIG_SERIAL_TIMBERDALE=m
# CONFIG_SERIAL_ALTERA_JTAGUART is not set
# CONFIG_SERIAL_ALTERA_UART is not set
CONFIG_SERIAL_PCH_UART=m
CONFIG_SERIAL_XILINX_PS_UART=y
CONFIG_SERIAL_XILINX_PS_UART_CONSOLE=y
CONFIG_SERIAL_ARC=m
CONFIG_SERIAL_ARC_NR_PORTS=1
CONFIG_SERIAL_RP2=m
CONFIG_SERIAL_RP2_NR_UARTS=32
CONFIG_SERIAL_FSL_LPUART=y
# CONFIG_SERIAL_FSL_LPUART_CONSOLE is not set
CONFIG_SERIAL_FSL_LINFLEXUART=m
# CONFIG_SERIAL_CONEXANT_DIGICOLOR is not set
CONFIG_SERIAL_MEN_Z135=m
# CONFIG_SERIAL_SPRD is not set
# end of Serial drivers

CONFIG_SERIAL_MCTRL_GPIO=y
# CONFIG_SERIAL_NONSTANDARD is not set
# CONFIG_GOLDFISH_TTY is not set
# CONFIG_N_GSM is not set
CONFIG_NOZOMI=m
CONFIG_NULL_TTY=m
# CONFIG_TRACE_SINK is not set
CONFIG_HVC_DRIVER=y
CONFIG_SERIAL_DEV_BUS=m
CONFIG_TTY_PRINTK=y
CONFIG_TTY_PRINTK_LEVEL=6
CONFIG_PRINTER=m
# CONFIG_LP_CONSOLE is not set
CONFIG_PPDEV=m
CONFIG_VIRTIO_CONSOLE=m
# CONFIG_IPMI_HANDLER is not set
CONFIG_IPMB_DEVICE_INTERFACE=y
CONFIG_HW_RANDOM=m
CONFIG_HW_RANDOM_TIMERIOMEM=m
CONFIG_HW_RANDOM_INTEL=m
CONFIG_HW_RANDOM_AMD=m
# CONFIG_HW_RANDOM_GEODE is not set
CONFIG_HW_RANDOM_VIA=m
# CONFIG_HW_RANDOM_VIRTIO is not set
# CONFIG_DTLK is not set
CONFIG_APPLICOM=m
CONFIG_SONYPI=m
CONFIG_MWAVE=m
CONFIG_PC8736x_GPIO=y
CONFIG_NSC_GPIO=y
# CONFIG_DEVMEM is not set
CONFIG_DEVKMEM=y
CONFIG_NVRAM=y
CONFIG_RAW_DRIVER=y
CONFIG_MAX_RAW_DEVS=256
# CONFIG_DEVPORT is not set
# CONFIG_HPET is not set
CONFIG_HANGCHECK_TIMER=m
# CONFIG_TCG_TPM is not set
CONFIG_TELCLOCK=m
# CONFIG_XILLYBUS is not set
# end of Character devices

CONFIG_RANDOM_TRUST_CPU=y
# CONFIG_RANDOM_TRUST_BOOTLOADER is not set

#
# I2C support
#
CONFIG_I2C=y
CONFIG_ACPI_I2C_OPREGION=y
CONFIG_I2C_BOARDINFO=y
CONFIG_I2C_COMPAT=y
CONFIG_I2C_CHARDEV=m
CONFIG_I2C_MUX=y

#
# Multiplexer I2C Chip support
#
# CONFIG_I2C_ARB_GPIO_CHALLENGE is not set
CONFIG_I2C_MUX_GPIO=y
# CONFIG_I2C_MUX_GPMUX is not set
CONFIG_I2C_MUX_LTC4306=m
CONFIG_I2C_MUX_PCA9541=m
# CONFIG_I2C_MUX_PCA954x is not set
# CONFIG_I2C_MUX_PINCTRL is not set
# CONFIG_I2C_MUX_REG is not set
CONFIG_I2C_DEMUX_PINCTRL=y
CONFIG_I2C_MUX_MLXCPLD=y
# end of Multiplexer I2C Chip support

# CONFIG_I2C_HELPER_AUTO is not set
CONFIG_I2C_SMBUS=m

#
# I2C Algorithms
#
CONFIG_I2C_ALGOBIT=y
CONFIG_I2C_ALGOPCF=y
CONFIG_I2C_ALGOPCA=m
# end of I2C Algorithms

#
# I2C Hardware Bus support
#

#
# PC SMBus host controller drivers
#
# CONFIG_I2C_ALI1535 is not set
CONFIG_I2C_ALI1563=m
# CONFIG_I2C_ALI15X3 is not set
CONFIG_I2C_AMD756=m
CONFIG_I2C_AMD756_S4882=m
CONFIG_I2C_AMD8111=y
# CONFIG_I2C_AMD_MP2 is not set
# CONFIG_I2C_I801 is not set
# CONFIG_I2C_ISCH is not set
# CONFIG_I2C_ISMT is not set
# CONFIG_I2C_PIIX4 is not set
CONFIG_I2C_NFORCE2=m
CONFIG_I2C_NFORCE2_S4985=m
# CONFIG_I2C_NVIDIA_GPU is not set
# CONFIG_I2C_SIS5595 is not set
CONFIG_I2C_SIS630=m
# CONFIG_I2C_SIS96X is not set
# CONFIG_I2C_VIA is not set
# CONFIG_I2C_VIAPRO is not set

#
# ACPI drivers
#
# CONFIG_I2C_SCMI is not set

#
# I2C system bus drivers (mostly embedded / system-on-chip)
#
# CONFIG_I2C_CBUS_GPIO is not set
CONFIG_I2C_DESIGNWARE_CORE=m
CONFIG_I2C_DESIGNWARE_PLATFORM=m
# CONFIG_I2C_DESIGNWARE_SLAVE is not set
CONFIG_I2C_DESIGNWARE_PCI=m
# CONFIG_I2C_DESIGNWARE_BAYTRAIL is not set
CONFIG_I2C_EG20T=m
CONFIG_I2C_EMEV2=y
CONFIG_I2C_GPIO=y
CONFIG_I2C_GPIO_FAULT_INJECTOR=y
CONFIG_I2C_KEMPLD=m
CONFIG_I2C_OCORES=m
# CONFIG_I2C_PCA_PLATFORM is not set
CONFIG_I2C_PXA=m
CONFIG_I2C_PXA_PCI=y
# CONFIG_I2C_RK3X is not set
CONFIG_I2C_SIMTEC=y
CONFIG_I2C_XILINX=y

#
# External I2C/SMBus adapter drivers
#
CONFIG_I2C_PARPORT=m
CONFIG_I2C_TAOS_EVM=m

#
# Other I2C/SMBus bus drivers
#
CONFIG_I2C_PCA_ISA=m
# CONFIG_SCx200_ACB is not set
CONFIG_I2C_FSI=m
# end of I2C Hardware Bus support

# CONFIG_I2C_STUB is not set
CONFIG_I2C_SLAVE=y
CONFIG_I2C_SLAVE_EEPROM=m
# CONFIG_I2C_DEBUG_CORE is not set
# CONFIG_I2C_DEBUG_ALGO is not set
# CONFIG_I2C_DEBUG_BUS is not set
# end of I2C support

CONFIG_I3C=y
CONFIG_CDNS_I3C_MASTER=m
CONFIG_DW_I3C_MASTER=y
# CONFIG_SPI is not set
# CONFIG_SPMI is not set
# CONFIG_HSI is not set
CONFIG_PPS=y
# CONFIG_PPS_DEBUG is not set

#
# PPS clients support
#
# CONFIG_PPS_CLIENT_KTIMER is not set
# CONFIG_PPS_CLIENT_LDISC is not set
# CONFIG_PPS_CLIENT_PARPORT is not set
CONFIG_PPS_CLIENT_GPIO=m

#
# PPS generators support
#

#
# PTP clock support
#
CONFIG_PTP_1588_CLOCK=y

#
# Enable PHYLIB and NETWORK_PHY_TIMESTAMPING to see the additional clocks.
#
CONFIG_PTP_1588_CLOCK_PCH=m
CONFIG_PTP_1588_CLOCK_KVM=y
# CONFIG_PTP_1588_CLOCK_IDT82P33 is not set
# CONFIG_PTP_1588_CLOCK_IDTCM is not set
# CONFIG_PTP_1588_CLOCK_VMW is not set
# end of PTP clock support

CONFIG_PINCTRL=y
CONFIG_GENERIC_PINCTRL_GROUPS=y
CONFIG_PINMUX=y
CONFIG_GENERIC_PINMUX_FUNCTIONS=y
CONFIG_PINCONF=y
CONFIG_GENERIC_PINCONF=y
# CONFIG_DEBUG_PINCTRL is not set
CONFIG_PINCTRL_AS3722=m
CONFIG_PINCTRL_AXP209=m
CONFIG_PINCTRL_AMD=y
# CONFIG_PINCTRL_MCP23S08 is not set
CONFIG_PINCTRL_SINGLE=m
CONFIG_PINCTRL_SX150X=y
CONFIG_PINCTRL_STMFX=m
# CONFIG_PINCTRL_PALMAS is not set
CONFIG_PINCTRL_OCELOT=y
# CONFIG_PINCTRL_BAYTRAIL is not set
# CONFIG_PINCTRL_CHERRYVIEW is not set
# CONFIG_PINCTRL_LYNXPOINT is not set
# CONFIG_PINCTRL_BROXTON is not set
# CONFIG_PINCTRL_CANNONLAKE is not set
# CONFIG_PINCTRL_CEDARFORK is not set
# CONFIG_PINCTRL_DENVERTON is not set
# CONFIG_PINCTRL_GEMINILAKE is not set
# CONFIG_PINCTRL_ICELAKE is not set
# CONFIG_PINCTRL_LEWISBURG is not set
# CONFIG_PINCTRL_SUNRISEPOINT is not set
# CONFIG_PINCTRL_TIGERLAKE is not set
CONFIG_PINCTRL_LOCHNAGAR=m
CONFIG_PINCTRL_MADERA=y
CONFIG_PINCTRL_CS47L15=y
CONFIG_PINCTRL_CS47L35=y
CONFIG_PINCTRL_CS47L85=y
CONFIG_PINCTRL_CS47L90=y
CONFIG_PINCTRL_CS47L92=y
# CONFIG_PINCTRL_EQUILIBRIUM is not set
CONFIG_GPIOLIB=y
CONFIG_GPIOLIB_FASTPATH_LIMIT=512
CONFIG_OF_GPIO=y
CONFIG_GPIO_ACPI=y
CONFIG_GPIOLIB_IRQCHIP=y
# CONFIG_DEBUG_GPIO is not set
CONFIG_GPIO_SYSFS=y
CONFIG_GPIO_GENERIC=y
CONFIG_GPIO_MAX730X=m

#
# Memory mapped GPIO drivers
#
CONFIG_GPIO_74XX_MMIO=y
CONFIG_GPIO_ALTERA=m
# CONFIG_GPIO_AMDPT is not set
CONFIG_GPIO_CADENCE=m
CONFIG_GPIO_DWAPB=y
# CONFIG_GPIO_EXAR is not set
CONFIG_GPIO_FTGPIO010=y
CONFIG_GPIO_GENERIC_PLATFORM=m
# CONFIG_GPIO_GRGPIO is not set
CONFIG_GPIO_HLWD=m
CONFIG_GPIO_ICH=y
# CONFIG_GPIO_LOGICVC is not set
CONFIG_GPIO_MB86S7X=m
# CONFIG_GPIO_MENZ127 is not set
CONFIG_GPIO_SAMA5D2_PIOBU=m
# CONFIG_GPIO_SIFIVE is not set
# CONFIG_GPIO_SIOX is not set
CONFIG_GPIO_SYSCON=m
# CONFIG_GPIO_VX855 is not set
CONFIG_GPIO_XILINX=y
CONFIG_GPIO_AMD_FCH=m
# end of Memory mapped GPIO drivers

#
# Port-mapped I/O GPIO drivers
#
CONFIG_GPIO_F7188X=y
CONFIG_GPIO_IT87=m
CONFIG_GPIO_SCH=y
CONFIG_GPIO_SCH311X=m
CONFIG_GPIO_WINBOND=y
CONFIG_GPIO_WS16C48=y
# end of Port-mapped I/O GPIO drivers

#
# I2C GPIO expanders
#
CONFIG_GPIO_ADP5588=y
CONFIG_GPIO_ADP5588_IRQ=y
CONFIG_GPIO_ADNP=y
CONFIG_GPIO_GW_PLD=m
CONFIG_GPIO_MAX7300=m
CONFIG_GPIO_MAX732X=y
# CONFIG_GPIO_MAX732X_IRQ is not set
CONFIG_GPIO_PCA953X=m
# CONFIG_GPIO_PCF857X is not set
CONFIG_GPIO_TPIC2810=y
# end of I2C GPIO expanders

#
# MFD GPIO expanders
#
CONFIG_GPIO_ADP5520=y
# CONFIG_GPIO_ARIZONA is not set
CONFIG_GPIO_BD70528=y
# CONFIG_GPIO_BD9571MWV is not set
CONFIG_GPIO_CS5535=m
# CONFIG_GPIO_KEMPLD is not set
CONFIG_GPIO_LP3943=m
# CONFIG_GPIO_LP873X is not set
CONFIG_GPIO_MADERA=y
# CONFIG_GPIO_PALMAS is not set
# CONFIG_GPIO_STMPE is not set
CONFIG_GPIO_TPS65086=y
CONFIG_GPIO_TPS65218=m
CONFIG_GPIO_TPS65910=y
CONFIG_GPIO_TPS65912=m
CONFIG_GPIO_TWL4030=y
CONFIG_GPIO_TWL6040=y
CONFIG_GPIO_WM8994=m
# end of MFD GPIO expanders

#
# PCI GPIO expanders
#
CONFIG_GPIO_AMD8111=y
# CONFIG_GPIO_BT8XX is not set
CONFIG_GPIO_ML_IOH=m
CONFIG_GPIO_PCH=m
CONFIG_GPIO_PCI_IDIO_16=m
CONFIG_GPIO_PCIE_IDIO_24=y
CONFIG_GPIO_RDC321X=m
# CONFIG_GPIO_SODAVILLE is not set
# end of PCI GPIO expanders

CONFIG_GPIO_MOCKUP=y
CONFIG_W1=m
# CONFIG_W1_CON is not set

#
# 1-wire Bus Masters
#
CONFIG_W1_MASTER_MATROX=m
CONFIG_W1_MASTER_DS2482=m
CONFIG_W1_MASTER_DS1WM=m
CONFIG_W1_MASTER_GPIO=m
CONFIG_W1_MASTER_SGI=m
# end of 1-wire Bus Masters

#
# 1-wire Slaves
#
CONFIG_W1_SLAVE_THERM=m
# CONFIG_W1_SLAVE_SMEM is not set
# CONFIG_W1_SLAVE_DS2405 is not set
CONFIG_W1_SLAVE_DS2408=m
# CONFIG_W1_SLAVE_DS2408_READBACK is not set
# CONFIG_W1_SLAVE_DS2413 is not set
CONFIG_W1_SLAVE_DS2406=m
CONFIG_W1_SLAVE_DS2423=m
CONFIG_W1_SLAVE_DS2805=m
# CONFIG_W1_SLAVE_DS2430 is not set
# CONFIG_W1_SLAVE_DS2431 is not set
# CONFIG_W1_SLAVE_DS2433 is not set
CONFIG_W1_SLAVE_DS2438=m
CONFIG_W1_SLAVE_DS250X=m
CONFIG_W1_SLAVE_DS2780=m
# CONFIG_W1_SLAVE_DS2781 is not set
# CONFIG_W1_SLAVE_DS28E04 is not set
# CONFIG_W1_SLAVE_DS28E17 is not set
# end of 1-wire Slaves

# CONFIG_POWER_AVS is not set
CONFIG_POWER_RESET=y
# CONFIG_POWER_RESET_AS3722 is not set
# CONFIG_POWER_RESET_GPIO is not set
CONFIG_POWER_RESET_GPIO_RESTART=y
# CONFIG_POWER_RESET_LTC2952 is not set
# CONFIG_POWER_RESET_MT6323 is not set
CONFIG_POWER_RESET_RESTART=y
CONFIG_POWER_RESET_SYSCON=y
CONFIG_POWER_RESET_SYSCON_POWEROFF=y
# CONFIG_SYSCON_REBOOT_MODE is not set
# CONFIG_NVMEM_REBOOT_MODE is not set
CONFIG_POWER_SUPPLY=y
# CONFIG_POWER_SUPPLY_DEBUG is not set
# CONFIG_POWER_SUPPLY_HWMON is not set
CONFIG_PDA_POWER=y
# CONFIG_GENERIC_ADC_BATTERY is not set
CONFIG_MAX8925_POWER=y
# CONFIG_TEST_POWER is not set
CONFIG_CHARGER_ADP5061=y
CONFIG_BATTERY_ACT8945A=y
# CONFIG_BATTERY_DS2760 is not set
CONFIG_BATTERY_DS2780=m
# CONFIG_BATTERY_DS2781 is not set
CONFIG_BATTERY_DS2782=m
CONFIG_BATTERY_LEGO_EV3=m
# CONFIG_BATTERY_OLPC is not set
# CONFIG_BATTERY_SBS is not set
CONFIG_CHARGER_SBS=y
# CONFIG_MANAGER_SBS is not set
# CONFIG_BATTERY_BQ27XXX is not set
# CONFIG_BATTERY_DA9150 is not set
# CONFIG_AXP20X_POWER is not set
CONFIG_AXP288_FUEL_GAUGE=m
CONFIG_BATTERY_MAX17040=y
# CONFIG_BATTERY_MAX17042 is not set
# CONFIG_BATTERY_MAX1721X is not set
CONFIG_BATTERY_TWL4030_MADC=m
CONFIG_BATTERY_RX51=m
# CONFIG_CHARGER_MAX8903 is not set
CONFIG_CHARGER_TWL4030=m
CONFIG_CHARGER_LP8727=m
# CONFIG_CHARGER_GPIO is not set
# CONFIG_CHARGER_MANAGER is not set
CONFIG_CHARGER_LT3651=m
CONFIG_CHARGER_MAX14577=m
CONFIG_CHARGER_DETECTOR_MAX14656=m
CONFIG_CHARGER_MAX77693=m
CONFIG_CHARGER_MAX8998=m
# CONFIG_CHARGER_BQ2415X is not set
CONFIG_CHARGER_BQ24190=m
# CONFIG_CHARGER_BQ24257 is not set
CONFIG_CHARGER_BQ24735=y
CONFIG_CHARGER_BQ25890=y
CONFIG_CHARGER_SMB347=y
CONFIG_CHARGER_TPS65217=m
CONFIG_BATTERY_GAUGE_LTC2941=y
# CONFIG_BATTERY_GOLDFISH is not set
# CONFIG_CHARGER_RT9455 is not set
# CONFIG_CHARGER_UCS1002 is not set
CONFIG_CHARGER_BD70528=y
CONFIG_HWMON=y
CONFIG_HWMON_VID=y
CONFIG_HWMON_DEBUG_CHIP=y

#
# Native drivers
#
# CONFIG_SENSORS_AD7414 is not set
# CONFIG_SENSORS_AD7418 is not set
CONFIG_SENSORS_ADM1021=y
CONFIG_SENSORS_ADM1025=y
# CONFIG_SENSORS_ADM1026 is not set
CONFIG_SENSORS_ADM1029=y
CONFIG_SENSORS_ADM1031=m
# CONFIG_SENSORS_ADM1177 is not set
CONFIG_SENSORS_ADM9240=m
CONFIG_SENSORS_ADT7X10=m
CONFIG_SENSORS_ADT7410=m
# CONFIG_SENSORS_ADT7411 is not set
# CONFIG_SENSORS_ADT7462 is not set
CONFIG_SENSORS_ADT7470=y
CONFIG_SENSORS_ADT7475=m
CONFIG_SENSORS_AS370=y
CONFIG_SENSORS_ASC7621=y
# CONFIG_SENSORS_AXI_FAN_CONTROL is not set
CONFIG_SENSORS_K8TEMP=y
# CONFIG_SENSORS_K10TEMP is not set
# CONFIG_SENSORS_FAM15H_POWER is not set
CONFIG_SENSORS_APPLESMC=y
# CONFIG_SENSORS_ASB100 is not set
CONFIG_SENSORS_ASPEED=m
# CONFIG_SENSORS_ATXP1 is not set
# CONFIG_SENSORS_DRIVETEMP is not set
CONFIG_SENSORS_DS620=m
CONFIG_SENSORS_DS1621=y
CONFIG_SENSORS_DELL_SMM=y
CONFIG_SENSORS_I5K_AMB=y
# CONFIG_SENSORS_F71805F is not set
CONFIG_SENSORS_F71882FG=m
CONFIG_SENSORS_F75375S=m
CONFIG_SENSORS_FSCHMD=y
CONFIG_SENSORS_FTSTEUTATES=y
# CONFIG_SENSORS_GL518SM is not set
CONFIG_SENSORS_GL520SM=m
CONFIG_SENSORS_G760A=m
# CONFIG_SENSORS_G762 is not set
# CONFIG_SENSORS_GPIO_FAN is not set
CONFIG_SENSORS_HIH6130=y
CONFIG_SENSORS_IIO_HWMON=m
CONFIG_SENSORS_I5500=m
CONFIG_SENSORS_CORETEMP=m
CONFIG_SENSORS_IT87=y
CONFIG_SENSORS_JC42=m
# CONFIG_SENSORS_POWR1220 is not set
CONFIG_SENSORS_LINEAGE=m
# CONFIG_SENSORS_LOCHNAGAR is not set
# CONFIG_SENSORS_LTC2945 is not set
# CONFIG_SENSORS_LTC2947_I2C is not set
CONFIG_SENSORS_LTC2990=m
CONFIG_SENSORS_LTC4151=y
CONFIG_SENSORS_LTC4215=m
# CONFIG_SENSORS_LTC4222 is not set
CONFIG_SENSORS_LTC4245=m
CONFIG_SENSORS_LTC4260=y
CONFIG_SENSORS_LTC4261=m
CONFIG_SENSORS_MAX16065=m
CONFIG_SENSORS_MAX1619=m
CONFIG_SENSORS_MAX1668=m
CONFIG_SENSORS_MAX197=m
# CONFIG_SENSORS_MAX31730 is not set
CONFIG_SENSORS_MAX6621=m
CONFIG_SENSORS_MAX6639=m
CONFIG_SENSORS_MAX6642=m
CONFIG_SENSORS_MAX6650=y
CONFIG_SENSORS_MAX6697=y
CONFIG_SENSORS_MAX31790=y
CONFIG_SENSORS_MCP3021=m
CONFIG_SENSORS_TC654=m
CONFIG_SENSORS_MENF21BMC_HWMON=m
CONFIG_SENSORS_LM63=y
CONFIG_SENSORS_LM73=m
CONFIG_SENSORS_LM75=m
CONFIG_SENSORS_LM77=y
# CONFIG_SENSORS_LM78 is not set
# CONFIG_SENSORS_LM80 is not set
# CONFIG_SENSORS_LM83 is not set
CONFIG_SENSORS_LM85=y
CONFIG_SENSORS_LM87=y
CONFIG_SENSORS_LM90=y
CONFIG_SENSORS_LM92=y
# CONFIG_SENSORS_LM93 is not set
# CONFIG_SENSORS_LM95234 is not set
CONFIG_SENSORS_LM95241=y
# CONFIG_SENSORS_LM95245 is not set
CONFIG_SENSORS_PC87360=y
CONFIG_SENSORS_PC87427=m
# CONFIG_SENSORS_NTC_THERMISTOR is not set
CONFIG_SENSORS_NCT6683=y
CONFIG_SENSORS_NCT6775=y
CONFIG_SENSORS_NCT7802=m
# CONFIG_SENSORS_NCT7904 is not set
# CONFIG_SENSORS_NPCM7XX is not set
CONFIG_SENSORS_PCF8591=m
CONFIG_PMBUS=y
CONFIG_SENSORS_PMBUS=y
CONFIG_SENSORS_ADM1275=m
# CONFIG_SENSORS_BEL_PFE is not set
# CONFIG_SENSORS_IBM_CFFPS is not set
CONFIG_SENSORS_INSPUR_IPSPS=y
CONFIG_SENSORS_IR35221=y
CONFIG_SENSORS_IR38064=m
CONFIG_SENSORS_IRPS5401=m
# CONFIG_SENSORS_ISL68137 is not set
CONFIG_SENSORS_LM25066=m
CONFIG_SENSORS_LTC2978=m
# CONFIG_SENSORS_LTC2978_REGULATOR is not set
CONFIG_SENSORS_LTC3815=y
CONFIG_SENSORS_MAX16064=y
# CONFIG_SENSORS_MAX20730 is not set
CONFIG_SENSORS_MAX20751=m
# CONFIG_SENSORS_MAX31785 is not set
# CONFIG_SENSORS_MAX34440 is not set
CONFIG_SENSORS_MAX8688=y
CONFIG_SENSORS_PXE1610=y
CONFIG_SENSORS_TPS40422=m
# CONFIG_SENSORS_TPS53679 is not set
CONFIG_SENSORS_UCD9000=m
CONFIG_SENSORS_UCD9200=y
# CONFIG_SENSORS_XDPE122 is not set
CONFIG_SENSORS_ZL6100=m
CONFIG_SENSORS_PWM_FAN=y
CONFIG_SENSORS_SHT15=m
# CONFIG_SENSORS_SHT21 is not set
# CONFIG_SENSORS_SHT3x is not set
CONFIG_SENSORS_SHTC1=y
CONFIG_SENSORS_SIS5595=y
CONFIG_SENSORS_DME1737=m
CONFIG_SENSORS_EMC1403=y
CONFIG_SENSORS_EMC2103=m
CONFIG_SENSORS_EMC6W201=y
# CONFIG_SENSORS_SMSC47M1 is not set
CONFIG_SENSORS_SMSC47M192=y
CONFIG_SENSORS_SMSC47B397=m
CONFIG_SENSORS_SCH56XX_COMMON=y
CONFIG_SENSORS_SCH5627=y
CONFIG_SENSORS_SCH5636=y
CONFIG_SENSORS_STTS751=m
CONFIG_SENSORS_SMM665=y
CONFIG_SENSORS_ADC128D818=y
CONFIG_SENSORS_ADS7828=y
# CONFIG_SENSORS_AMC6821 is not set
CONFIG_SENSORS_INA209=y
# CONFIG_SENSORS_INA2XX is not set
# CONFIG_SENSORS_INA3221 is not set
CONFIG_SENSORS_TC74=y
# CONFIG_SENSORS_THMC50 is not set
# CONFIG_SENSORS_TMP102 is not set
# CONFIG_SENSORS_TMP103 is not set
# CONFIG_SENSORS_TMP108 is not set
CONFIG_SENSORS_TMP401=y
CONFIG_SENSORS_TMP421=y
# CONFIG_SENSORS_TMP513 is not set
CONFIG_SENSORS_VIA_CPUTEMP=m
# CONFIG_SENSORS_VIA686A is not set
# CONFIG_SENSORS_VT1211 is not set
CONFIG_SENSORS_VT8231=m
CONFIG_SENSORS_W83773G=y
# CONFIG_SENSORS_W83781D is not set
# CONFIG_SENSORS_W83791D is not set
CONFIG_SENSORS_W83792D=y
CONFIG_SENSORS_W83793=y
# CONFIG_SENSORS_W83795 is not set
# CONFIG_SENSORS_W83L785TS is not set
CONFIG_SENSORS_W83L786NG=m
CONFIG_SENSORS_W83627HF=m
CONFIG_SENSORS_W83627EHF=m

#
# ACPI drivers
#
# CONFIG_SENSORS_ACPI_POWER is not set
# CONFIG_SENSORS_ATK0110 is not set
CONFIG_THERMAL=y
# CONFIG_THERMAL_STATISTICS is not set
CONFIG_THERMAL_EMERGENCY_POWEROFF_DELAY_MS=0
CONFIG_THERMAL_HWMON=y
CONFIG_THERMAL_OF=y
# CONFIG_THERMAL_WRITABLE_TRIPS is not set
CONFIG_THERMAL_DEFAULT_GOV_STEP_WISE=y
# CONFIG_THERMAL_DEFAULT_GOV_FAIR_SHARE is not set
# CONFIG_THERMAL_DEFAULT_GOV_USER_SPACE is not set
# CONFIG_THERMAL_GOV_FAIR_SHARE is not set
CONFIG_THERMAL_GOV_STEP_WISE=y
# CONFIG_THERMAL_GOV_BANG_BANG is not set
# CONFIG_THERMAL_GOV_USER_SPACE is not set
# CONFIG_THERMAL_GOV_POWER_ALLOCATOR is not set
# CONFIG_CPU_THERMAL is not set
# CONFIG_CLOCK_THERMAL is not set
# CONFIG_DEVFREQ_THERMAL is not set
# CONFIG_THERMAL_EMULATION is not set
# CONFIG_THERMAL_MMIO is not set
# CONFIG_QORIQ_THERMAL is not set

#
# Intel thermal drivers
#
# CONFIG_INTEL_POWERCLAMP is not set
# CONFIG_INTEL_SOC_DTS_THERMAL is not set

#
# ACPI INT340X thermal drivers
#
# CONFIG_INT340X_THERMAL is not set
# end of ACPI INT340X thermal drivers

# CONFIG_INTEL_PCH_THERMAL is not set
# end of Intel thermal drivers

# CONFIG_GENERIC_ADC_THERMAL is not set
CONFIG_WATCHDOG=y
CONFIG_WATCHDOG_CORE=y
CONFIG_WATCHDOG_NOWAYOUT=y
# CONFIG_WATCHDOG_HANDLE_BOOT_ENABLED is not set
CONFIG_WATCHDOG_OPEN_TIMEOUT=0
# CONFIG_WATCHDOG_SYSFS is not set

#
# Watchdog Pretimeout Governors
#
CONFIG_WATCHDOG_PRETIMEOUT_GOV=y
CONFIG_WATCHDOG_PRETIMEOUT_GOV_SEL=m
CONFIG_WATCHDOG_PRETIMEOUT_GOV_NOOP=y
CONFIG_WATCHDOG_PRETIMEOUT_GOV_PANIC=m
# CONFIG_WATCHDOG_PRETIMEOUT_DEFAULT_GOV_NOOP is not set
CONFIG_WATCHDOG_PRETIMEOUT_DEFAULT_GOV_PANIC=y

#
# Watchdog Device Drivers
#
# CONFIG_SOFT_WATCHDOG is not set
CONFIG_BD70528_WATCHDOG=m
# CONFIG_DA9063_WATCHDOG is not set
CONFIG_GPIO_WATCHDOG=y
CONFIG_GPIO_WATCHDOG_ARCH_INITCALL=y
CONFIG_MENF21BMC_WATCHDOG=m
CONFIG_MENZ069_WATCHDOG=m
# CONFIG_WDAT_WDT is not set
CONFIG_XILINX_WATCHDOG=m
CONFIG_ZIIRAVE_WATCHDOG=y
# CONFIG_RAVE_SP_WATCHDOG is not set
CONFIG_CADENCE_WATCHDOG=y
# CONFIG_DW_WATCHDOG is not set
# CONFIG_RN5T618_WATCHDOG is not set
# CONFIG_TWL4030_WATCHDOG is not set
# CONFIG_MAX63XX_WATCHDOG is not set
CONFIG_STPMIC1_WATCHDOG=m
CONFIG_ACQUIRE_WDT=m
CONFIG_ADVANTECH_WDT=m
CONFIG_ALIM1535_WDT=y
CONFIG_ALIM7101_WDT=y
CONFIG_EBC_C384_WDT=y
CONFIG_F71808E_WDT=y
# CONFIG_SP5100_TCO is not set
CONFIG_SBC_FITPC2_WATCHDOG=y
# CONFIG_EUROTECH_WDT is not set
CONFIG_IB700_WDT=m
# CONFIG_IBMASR is not set
CONFIG_WAFER_WDT=y
CONFIG_I6300ESB_WDT=y
CONFIG_IE6XX_WDT=m
# CONFIG_ITCO_WDT is not set
# CONFIG_IT8712F_WDT is not set
CONFIG_IT87_WDT=m
CONFIG_HP_WATCHDOG=m
CONFIG_HPWDT_NMI_DECODING=y
CONFIG_KEMPLD_WDT=m
CONFIG_SC1200_WDT=y
# CONFIG_PC87413_WDT is not set
# CONFIG_NV_TCO is not set
# CONFIG_60XX_WDT is not set
# CONFIG_SBC8360_WDT is not set
CONFIG_SBC7240_WDT=m
CONFIG_CPU5_WDT=m
CONFIG_SMSC_SCH311X_WDT=y
# CONFIG_SMSC37B787_WDT is not set
# CONFIG_TQMX86_WDT is not set
CONFIG_VIA_WDT=m
CONFIG_W83627HF_WDT=y
# CONFIG_W83877F_WDT is not set
CONFIG_W83977F_WDT=m
CONFIG_MACHZ_WDT=m
# CONFIG_SBC_EPX_C3_WATCHDOG is not set
# CONFIG_INTEL_MEI_WDT is not set
# CONFIG_NI903X_WDT is not set
# CONFIG_NIC7018_WDT is not set
# CONFIG_MEN_A21_WDT is not set

#
# ISA-based Watchdog Cards
#
CONFIG_PCWATCHDOG=y
# CONFIG_MIXCOMWD is not set
# CONFIG_WDT is not set

#
# PCI-based Watchdog Cards
#
CONFIG_PCIPCWATCHDOG=m
# CONFIG_WDTPCI is not set
CONFIG_SSB_POSSIBLE=y
CONFIG_SSB=m
CONFIG_SSB_SPROM=y
CONFIG_SSB_PCIHOST_POSSIBLE=y
CONFIG_SSB_PCIHOST=y
CONFIG_SSB_SDIOHOST_POSSIBLE=y
CONFIG_SSB_SDIOHOST=y
CONFIG_SSB_DRIVER_PCICORE_POSSIBLE=y
CONFIG_SSB_DRIVER_PCICORE=y
CONFIG_SSB_DRIVER_GPIO=y
CONFIG_BCMA_POSSIBLE=y
CONFIG_BCMA=y
CONFIG_BCMA_HOST_PCI_POSSIBLE=y
CONFIG_BCMA_HOST_PCI=y
CONFIG_BCMA_HOST_SOC=y
CONFIG_BCMA_DRIVER_PCI=y
CONFIG_BCMA_SFLASH=y
# CONFIG_BCMA_DRIVER_GMAC_CMN is not set
# CONFIG_BCMA_DRIVER_GPIO is not set
CONFIG_BCMA_DEBUG=y

#
# Multifunction device drivers
#
CONFIG_MFD_CORE=y
CONFIG_MFD_CS5535=m
CONFIG_MFD_ACT8945A=y
# CONFIG_MFD_AS3711 is not set
CONFIG_MFD_AS3722=m
CONFIG_PMIC_ADP5520=y
# CONFIG_MFD_AAT2870_CORE is not set
# CONFIG_MFD_ATMEL_FLEXCOM is not set
CONFIG_MFD_ATMEL_HLCDC=m
# CONFIG_MFD_BCM590XX is not set
CONFIG_MFD_BD9571MWV=y
CONFIG_MFD_AXP20X=m
CONFIG_MFD_AXP20X_I2C=m
CONFIG_MFD_MADERA=y
CONFIG_MFD_MADERA_I2C=y
CONFIG_MFD_CS47L15=y
CONFIG_MFD_CS47L35=y
CONFIG_MFD_CS47L85=y
CONFIG_MFD_CS47L90=y
CONFIG_MFD_CS47L92=y
# CONFIG_PMIC_DA903X is not set
# CONFIG_MFD_DA9052_I2C is not set
# CONFIG_MFD_DA9055 is not set
# CONFIG_MFD_DA9062 is not set
CONFIG_MFD_DA9063=y
CONFIG_MFD_DA9150=y
# CONFIG_MFD_MC13XXX_I2C is not set
CONFIG_MFD_HI6421_PMIC=y
CONFIG_HTC_PASIC3=m
CONFIG_HTC_I2CPLD=y
CONFIG_MFD_INTEL_QUARK_I2C_GPIO=y
CONFIG_LPC_ICH=y
CONFIG_LPC_SCH=y
# CONFIG_INTEL_SOC_PMIC_CHTDC_TI is not set
CONFIG_MFD_INTEL_LPSS=m
# CONFIG_MFD_INTEL_LPSS_ACPI is not set
CONFIG_MFD_INTEL_LPSS_PCI=m
# CONFIG_MFD_IQS62X is not set
# CONFIG_MFD_JANZ_CMODIO is not set
CONFIG_MFD_KEMPLD=m
CONFIG_MFD_88PM800=m
CONFIG_MFD_88PM805=y
# CONFIG_MFD_88PM860X is not set
CONFIG_MFD_MAX14577=m
# CONFIG_MFD_MAX77620 is not set
# CONFIG_MFD_MAX77650 is not set
CONFIG_MFD_MAX77686=m
CONFIG_MFD_MAX77693=y
# CONFIG_MFD_MAX77843 is not set
CONFIG_MFD_MAX8907=y
CONFIG_MFD_MAX8925=y
# CONFIG_MFD_MAX8997 is not set
CONFIG_MFD_MAX8998=y
CONFIG_MFD_MT6397=y
CONFIG_MFD_MENF21BMC=m
# CONFIG_MFD_RETU is not set
# CONFIG_MFD_PCF50633 is not set
CONFIG_MFD_RDC321X=y
# CONFIG_MFD_RT5033 is not set
# CONFIG_MFD_RC5T583 is not set
# CONFIG_MFD_RK808 is not set
CONFIG_MFD_RN5T618=m
CONFIG_MFD_SEC_CORE=m
# CONFIG_MFD_SI476X_CORE is not set
# CONFIG_MFD_SM501 is not set
# CONFIG_MFD_SKY81452 is not set
# CONFIG_MFD_SMSC is not set
# CONFIG_ABX500_CORE is not set
CONFIG_MFD_STMPE=y

#
# STMicroelectronics STMPE Interface Drivers
#
# CONFIG_STMPE_I2C is not set
# end of STMicroelectronics STMPE Interface Drivers

CONFIG_MFD_SYSCON=y
# CONFIG_MFD_TI_AM335X_TSCADC is not set
CONFIG_MFD_LP3943=m
# CONFIG_MFD_LP8788 is not set
CONFIG_MFD_TI_LMU=m
CONFIG_MFD_PALMAS=y
CONFIG_TPS6105X=m
# CONFIG_TPS65010 is not set
CONFIG_TPS6507X=m
CONFIG_MFD_TPS65086=y
# CONFIG_MFD_TPS65090 is not set
CONFIG_MFD_TPS65217=m
CONFIG_MFD_TI_LP873X=y
# CONFIG_MFD_TI_LP87565 is not set
CONFIG_MFD_TPS65218=m
# CONFIG_MFD_TPS6586X is not set
CONFIG_MFD_TPS65910=y
CONFIG_MFD_TPS65912=y
CONFIG_MFD_TPS65912_I2C=y
CONFIG_MFD_TPS80031=y
CONFIG_TWL4030_CORE=y
CONFIG_MFD_TWL4030_AUDIO=y
CONFIG_TWL6040_CORE=y
# CONFIG_MFD_WL1273_CORE is not set
CONFIG_MFD_LM3533=m
# CONFIG_MFD_TIMBERDALE is not set
# CONFIG_MFD_TC3589X is not set
# CONFIG_MFD_TQMX86 is not set
CONFIG_MFD_VX855=y
CONFIG_MFD_LOCHNAGAR=y
CONFIG_MFD_ARIZONA=y
CONFIG_MFD_ARIZONA_I2C=m
# CONFIG_MFD_CS47L24 is not set
CONFIG_MFD_WM5102=y
# CONFIG_MFD_WM5110 is not set
# CONFIG_MFD_WM8997 is not set
# CONFIG_MFD_WM8998 is not set
CONFIG_MFD_WM8400=y
# CONFIG_MFD_WM831X_I2C is not set
# CONFIG_MFD_WM8350_I2C is not set
CONFIG_MFD_WM8994=m
# CONFIG_MFD_ROHM_BD718XX is not set
CONFIG_MFD_ROHM_BD70528=y
# CONFIG_MFD_ROHM_BD71828 is not set
CONFIG_MFD_STPMIC1=m
CONFIG_MFD_STMFX=m
CONFIG_RAVE_SP_CORE=m
# end of Multifunction device drivers

CONFIG_REGULATOR=y
# CONFIG_REGULATOR_DEBUG is not set
CONFIG_REGULATOR_FIXED_VOLTAGE=m
CONFIG_REGULATOR_VIRTUAL_CONSUMER=y
CONFIG_REGULATOR_USERSPACE_CONSUMER=m
CONFIG_REGULATOR_88PG86X=y
CONFIG_REGULATOR_88PM800=m
CONFIG_REGULATOR_ACT8865=y
# CONFIG_REGULATOR_ACT8945A is not set
# CONFIG_REGULATOR_AD5398 is not set
CONFIG_REGULATOR_AS3722=m
CONFIG_REGULATOR_AXP20X=m
# CONFIG_REGULATOR_BD70528 is not set
CONFIG_REGULATOR_BD9571MWV=y
CONFIG_REGULATOR_DA9063=m
# CONFIG_REGULATOR_DA9210 is not set
CONFIG_REGULATOR_DA9211=y
CONFIG_REGULATOR_FAN53555=y
CONFIG_REGULATOR_GPIO=m
CONFIG_REGULATOR_HI6421=m
CONFIG_REGULATOR_HI6421V530=m
CONFIG_REGULATOR_ISL9305=m
# CONFIG_REGULATOR_ISL6271A is not set
# CONFIG_REGULATOR_LM363X is not set
# CONFIG_REGULATOR_LOCHNAGAR is not set
CONFIG_REGULATOR_LP3971=y
CONFIG_REGULATOR_LP3972=m
CONFIG_REGULATOR_LP872X=y
# CONFIG_REGULATOR_LP873X is not set
# CONFIG_REGULATOR_LP8755 is not set
# CONFIG_REGULATOR_LTC3589 is not set
# CONFIG_REGULATOR_LTC3676 is not set
CONFIG_REGULATOR_MAX14577=m
CONFIG_REGULATOR_MAX1586=y
CONFIG_REGULATOR_MAX8649=m
# CONFIG_REGULATOR_MAX8660 is not set
# CONFIG_REGULATOR_MAX8907 is not set
CONFIG_REGULATOR_MAX8925=m
CONFIG_REGULATOR_MAX8952=m
# CONFIG_REGULATOR_MAX8973 is not set
CONFIG_REGULATOR_MAX8998=m
# CONFIG_REGULATOR_MAX77686 is not set
# CONFIG_REGULATOR_MAX77693 is not set
CONFIG_REGULATOR_MAX77802=m
# CONFIG_REGULATOR_MCP16502 is not set
# CONFIG_REGULATOR_MP5416 is not set
# CONFIG_REGULATOR_MP8859 is not set
# CONFIG_REGULATOR_MP886X is not set
# CONFIG_REGULATOR_MPQ7920 is not set
CONFIG_REGULATOR_MT6311=m
# CONFIG_REGULATOR_MT6323 is not set
CONFIG_REGULATOR_MT6397=y
CONFIG_REGULATOR_PALMAS=m
CONFIG_REGULATOR_PFUZE100=m
CONFIG_REGULATOR_PV88060=m
CONFIG_REGULATOR_PV88080=m
# CONFIG_REGULATOR_PV88090 is not set
CONFIG_REGULATOR_PWM=y
CONFIG_REGULATOR_RN5T618=m
CONFIG_REGULATOR_S2MPA01=m
# CONFIG_REGULATOR_S2MPS11 is not set
CONFIG_REGULATOR_S5M8767=m
CONFIG_REGULATOR_SLG51000=y
# CONFIG_REGULATOR_STPMIC1 is not set
# CONFIG_REGULATOR_SY8106A is not set
CONFIG_REGULATOR_SY8824X=m
CONFIG_REGULATOR_TPS51632=y
CONFIG_REGULATOR_TPS6105X=m
CONFIG_REGULATOR_TPS62360=m
CONFIG_REGULATOR_TPS65023=y
CONFIG_REGULATOR_TPS6507X=y
CONFIG_REGULATOR_TPS65086=y
CONFIG_REGULATOR_TPS65132=y
# CONFIG_REGULATOR_TPS65217 is not set
CONFIG_REGULATOR_TPS65218=m
CONFIG_REGULATOR_TPS65910=m
CONFIG_REGULATOR_TPS65912=y
CONFIG_REGULATOR_TPS80031=y
CONFIG_REGULATOR_TWL4030=m
CONFIG_REGULATOR_VCTRL=m
CONFIG_REGULATOR_WM8400=y
CONFIG_REGULATOR_WM8994=m
CONFIG_CEC_CORE=m
CONFIG_CEC_NOTIFIER=y
CONFIG_RC_CORE=m
# CONFIG_RC_MAP is not set
CONFIG_LIRC=y
CONFIG_RC_DECODERS=y
# CONFIG_IR_NEC_DECODER is not set
# CONFIG_IR_RC5_DECODER is not set
# CONFIG_IR_RC6_DECODER is not set
# CONFIG_IR_JVC_DECODER is not set
# CONFIG_IR_SONY_DECODER is not set
# CONFIG_IR_SANYO_DECODER is not set
CONFIG_IR_SHARP_DECODER=m
# CONFIG_IR_MCE_KBD_DECODER is not set
# CONFIG_IR_XMP_DECODER is not set
CONFIG_IR_IMON_DECODER=m
# CONFIG_IR_RCMM_DECODER is not set
CONFIG_RC_DEVICES=y
# CONFIG_RC_ATI_REMOTE is not set
# CONFIG_IR_ENE is not set
# CONFIG_IR_HIX5HD2 is not set
# CONFIG_IR_IMON is not set
# CONFIG_IR_IMON_RAW is not set
# CONFIG_IR_MCEUSB is not set
# CONFIG_IR_ITE_CIR is not set
# CONFIG_IR_FINTEK is not set
# CONFIG_IR_NUVOTON is not set
# CONFIG_IR_REDRAT3 is not set
# CONFIG_IR_STREAMZAP is not set
# CONFIG_IR_WINBOND_CIR is not set
# CONFIG_IR_IGORPLUGUSB is not set
# CONFIG_IR_IGUANA is not set
# CONFIG_IR_TTUSBIR is not set
CONFIG_RC_LOOPBACK=m
# CONFIG_IR_GPIO_CIR is not set
# CONFIG_IR_GPIO_TX is not set
# CONFIG_IR_PWM_TX is not set
# CONFIG_IR_SERIAL is not set
# CONFIG_IR_SIR is not set
# CONFIG_RC_XBOX_DVD is not set
CONFIG_MEDIA_SUPPORT=y

#
# Multimedia core support
#
CONFIG_MEDIA_CAMERA_SUPPORT=y
# CONFIG_MEDIA_ANALOG_TV_SUPPORT is not set
# CONFIG_MEDIA_DIGITAL_TV_SUPPORT is not set
CONFIG_MEDIA_RADIO_SUPPORT=y
# CONFIG_MEDIA_SDR_SUPPORT is not set
# CONFIG_MEDIA_CEC_SUPPORT is not set
# CONFIG_MEDIA_CEC_RC is not set
# CONFIG_MEDIA_CONTROLLER is not set
CONFIG_VIDEO_DEV=y
CONFIG_VIDEO_V4L2=y
CONFIG_VIDEO_V4L2_I2C=y
CONFIG_VIDEO_ADV_DEBUG=y
CONFIG_VIDEO_FIXED_MINOR_RANGES=y
CONFIG_V4L2_FWNODE=y

#
# Media drivers
#
CONFIG_MEDIA_PCI_SUPPORT=y

#
# Media capture support
#
CONFIG_VIDEO_TW5864=y
CONFIG_VIDEO_TW68=y
CONFIG_V4L_PLATFORM_DRIVERS=y
# CONFIG_VIDEO_CAFE_CCIC is not set
# CONFIG_VIDEO_VIA_CAMERA is not set
CONFIG_VIDEO_CADENCE=y
# CONFIG_VIDEO_ASPEED is not set
# CONFIG_V4L_MEM2MEM_DRIVERS is not set
# CONFIG_V4L_TEST_DRIVERS is not set

#
# Supported MMC/SDIO adapters
#
CONFIG_RADIO_ADAPTERS=y
CONFIG_RADIO_TEA575X=y
CONFIG_RADIO_SI470X=m
CONFIG_I2C_SI470X=m
# CONFIG_RADIO_SI4713 is not set
CONFIG_RADIO_MAXIRADIO=y
# CONFIG_RADIO_TEA5764 is not set
CONFIG_RADIO_SAA7706H=m
# CONFIG_RADIO_TEF6862 is not set
# CONFIG_RADIO_WL1273 is not set

#
# Texas Instruments WL128x FM driver (ST based)
#
CONFIG_RADIO_WL128X=m
# end of Texas Instruments WL128x FM driver (ST based)

CONFIG_V4L_RADIO_ISA_DRIVERS=y
CONFIG_RADIO_ISA=y
CONFIG_RADIO_CADET=y
CONFIG_RADIO_RTRACK=m
# CONFIG_RADIO_RTRACK2 is not set
CONFIG_RADIO_AZTECH=m
CONFIG_RADIO_GEMTEK=m
CONFIG_RADIO_SF16FMI=y
CONFIG_RADIO_SF16FMR2=m
CONFIG_RADIO_TERRATEC=m
CONFIG_RADIO_TRUST=y
CONFIG_RADIO_TRUST_PORT=350
# CONFIG_RADIO_TYPHOON is not set
CONFIG_RADIO_ZOLTRIX=y
CONFIG_RADIO_ZOLTRIX_PORT=20c
CONFIG_VIDEOBUF2_CORE=y
CONFIG_VIDEOBUF2_V4L2=y
CONFIG_VIDEOBUF2_MEMOPS=y
CONFIG_VIDEOBUF2_DMA_CONTIG=y
CONFIG_VIDEOBUF2_VMALLOC=m
CONFIG_VIDEOBUF2_DMA_SG=y

#
# Media ancillary drivers (tuners, sensors, i2c, spi, frontends)
#
CONFIG_MEDIA_SUBDRV_AUTOSELECT=y
CONFIG_MEDIA_ATTACH=y
# CONFIG_VIDEO_IR_I2C is not set

#
# I2C Encoders, decoders, sensors and other helper chips
#

#
# Audio decoders, processors and mixers
#
CONFIG_VIDEO_TVAUDIO=m
CONFIG_VIDEO_TDA7432=m
CONFIG_VIDEO_TDA9840=m
CONFIG_VIDEO_TEA6415C=m
# CONFIG_VIDEO_TEA6420 is not set
# CONFIG_VIDEO_MSP3400 is not set
CONFIG_VIDEO_CS3308=y
# CONFIG_VIDEO_CS5345 is not set
CONFIG_VIDEO_CS53L32A=y
CONFIG_VIDEO_TLV320AIC23B=m
# CONFIG_VIDEO_UDA1342 is not set
CONFIG_VIDEO_WM8775=m
CONFIG_VIDEO_WM8739=y
CONFIG_VIDEO_VP27SMPX=m
CONFIG_VIDEO_SONY_BTF_MPX=m

#
# RDS decoders
#
# CONFIG_VIDEO_SAA6588 is not set

#
# Video decoders
#
# CONFIG_VIDEO_ADV7183 is not set
CONFIG_VIDEO_BT819=m
CONFIG_VIDEO_BT856=y
CONFIG_VIDEO_BT866=m
CONFIG_VIDEO_KS0127=m
# CONFIG_VIDEO_ML86V7667 is not set
# CONFIG_VIDEO_SAA7110 is not set
# CONFIG_VIDEO_SAA711X is not set
# CONFIG_VIDEO_TVP514X is not set
# CONFIG_VIDEO_TVP5150 is not set
CONFIG_VIDEO_TVP7002=y
CONFIG_VIDEO_TW2804=y
CONFIG_VIDEO_TW9903=y
CONFIG_VIDEO_TW9906=m
# CONFIG_VIDEO_TW9910 is not set
CONFIG_VIDEO_VPX3220=y

#
# Video and audio decoders
#
# CONFIG_VIDEO_SAA717X is not set
CONFIG_VIDEO_CX25840=m

#
# Video encoders
#
CONFIG_VIDEO_SAA7127=y
CONFIG_VIDEO_SAA7185=m
CONFIG_VIDEO_ADV7170=m
CONFIG_VIDEO_ADV7175=m
CONFIG_VIDEO_ADV7343=y
CONFIG_VIDEO_ADV7393=y
CONFIG_VIDEO_AK881X=y
CONFIG_VIDEO_THS8200=m

#
# Camera sensor devices
#
# CONFIG_VIDEO_OV2640 is not set
# CONFIG_VIDEO_OV2659 is not set
# CONFIG_VIDEO_OV6650 is not set
CONFIG_VIDEO_OV5695=m
CONFIG_VIDEO_OV772X=m
# CONFIG_VIDEO_OV7640 is not set
CONFIG_VIDEO_OV7670=y
CONFIG_VIDEO_OV7740=y
CONFIG_VIDEO_OV9640=m
CONFIG_VIDEO_VS6624=y
# CONFIG_VIDEO_MT9M111 is not set
CONFIG_VIDEO_MT9T112=y
CONFIG_VIDEO_MT9V011=m
# CONFIG_VIDEO_MT9V111 is not set
# CONFIG_VIDEO_SR030PC30 is not set
CONFIG_VIDEO_RJ54N1=m

#
# Lens drivers
#

#
# Flash devices
#

#
# Video improvement chips
#
CONFIG_VIDEO_UPD64031A=y
# CONFIG_VIDEO_UPD64083 is not set

#
# Audio/Video compression chips
#
CONFIG_VIDEO_SAA6752HS=y

#
# SDR tuner chips
#

#
# Miscellaneous helper chips
#
CONFIG_VIDEO_THS7303=y
CONFIG_VIDEO_M52790=m
CONFIG_VIDEO_I2C=m
# end of I2C Encoders, decoders, sensors and other helper chips

#
# SPI helper chips
#
# end of SPI helper chips

CONFIG_MEDIA_TUNER=y

#
# Customize TV tuners
#
CONFIG_MEDIA_TUNER_SIMPLE=y
# CONFIG_MEDIA_TUNER_TDA18250 is not set
CONFIG_MEDIA_TUNER_TDA8290=y
CONFIG_MEDIA_TUNER_TDA827X=y
CONFIG_MEDIA_TUNER_TDA18271=y
CONFIG_MEDIA_TUNER_TDA9887=y
CONFIG_MEDIA_TUNER_TEA5761=y
CONFIG_MEDIA_TUNER_TEA5767=y
CONFIG_MEDIA_TUNER_MT20XX=y
# CONFIG_MEDIA_TUNER_MT2060 is not set
CONFIG_MEDIA_TUNER_MT2063=m
CONFIG_MEDIA_TUNER_MT2266=y
# CONFIG_MEDIA_TUNER_MT2131 is not set
CONFIG_MEDIA_TUNER_QT1010=m
CONFIG_MEDIA_TUNER_XC2028=y
CONFIG_MEDIA_TUNER_XC5000=y
CONFIG_MEDIA_TUNER_XC4000=y
CONFIG_MEDIA_TUNER_MXL5005S=y
CONFIG_MEDIA_TUNER_MXL5007T=y
CONFIG_MEDIA_TUNER_MC44S803=y
CONFIG_MEDIA_TUNER_MAX2165=m
# CONFIG_MEDIA_TUNER_TDA18218 is not set
CONFIG_MEDIA_TUNER_FC0011=m
CONFIG_MEDIA_TUNER_FC0012=y
CONFIG_MEDIA_TUNER_FC0013=m
CONFIG_MEDIA_TUNER_TDA18212=y
CONFIG_MEDIA_TUNER_E4000=m
CONFIG_MEDIA_TUNER_FC2580=m
# CONFIG_MEDIA_TUNER_M88RS6000T is not set
CONFIG_MEDIA_TUNER_TUA9001=m
# CONFIG_MEDIA_TUNER_SI2157 is not set
CONFIG_MEDIA_TUNER_IT913X=m
CONFIG_MEDIA_TUNER_R820T=y
CONFIG_MEDIA_TUNER_MXL301RF=y
# CONFIG_MEDIA_TUNER_QM1D1C0042 is not set
CONFIG_MEDIA_TUNER_QM1D1B0004=m
# end of Customize TV tuners

#
# Customise DVB Frontends
#

#
# Tools to develop new frontends
#
# end of Customise DVB Frontends

#
# Graphics support
#
# CONFIG_AGP is not set
CONFIG_INTEL_GTT=m
CONFIG_VGA_ARB=y
CONFIG_VGA_ARB_MAX_GPUS=16
# CONFIG_VGA_SWITCHEROO is not set
CONFIG_DRM=m
CONFIG_DRM_MIPI_DSI=y
CONFIG_DRM_DP_AUX_CHARDEV=y
CONFIG_DRM_DEBUG_SELFTEST=m
CONFIG_DRM_KMS_HELPER=m
CONFIG_DRM_KMS_FB_HELPER=y
# CONFIG_DRM_DEBUG_DP_MST_TOPOLOGY_REFS is not set
# CONFIG_DRM_FBDEV_EMULATION is not set
# CONFIG_DRM_LOAD_EDID_FIRMWARE is not set
CONFIG_DRM_DP_CEC=y
CONFIG_DRM_TTM=m
CONFIG_DRM_VRAM_HELPER=m
CONFIG_DRM_TTM_HELPER=m
CONFIG_DRM_GEM_CMA_HELPER=y
CONFIG_DRM_KMS_CMA_HELPER=y
CONFIG_DRM_VM=y

#
# I2C encoder or helper chips
#
# CONFIG_DRM_I2C_CH7006 is not set
CONFIG_DRM_I2C_SIL164=m
CONFIG_DRM_I2C_NXP_TDA998X=m
CONFIG_DRM_I2C_NXP_TDA9950=m
# end of I2C encoder or helper chips

#
# ARM devices
#
# CONFIG_DRM_KOMEDA is not set
# end of ARM devices

# CONFIG_DRM_RADEON is not set
# CONFIG_DRM_AMDGPU is not set
# CONFIG_DRM_NOUVEAU is not set
CONFIG_DRM_I915=m
CONFIG_DRM_I915_FORCE_PROBE=""
# CONFIG_DRM_I915_CAPTURE_ERROR is not set
# CONFIG_DRM_I915_USERPTR is not set

#
# drm/i915 Debugging
#
# CONFIG_DRM_I915_WERROR is not set
CONFIG_DRM_I915_DEBUG=y
CONFIG_DRM_I915_DEBUG_MMIO=y
CONFIG_DRM_I915_SW_FENCE_DEBUG_OBJECTS=y
# CONFIG_DRM_I915_SW_FENCE_CHECK_DAG is not set
CONFIG_DRM_I915_DEBUG_GUC=y
CONFIG_DRM_I915_SELFTEST=y
# CONFIG_DRM_I915_LOW_LEVEL_TRACEPOINTS is not set
# CONFIG_DRM_I915_DEBUG_VBLANK_EVADE is not set
CONFIG_DRM_I915_DEBUG_RUNTIME_PM=y
# end of drm/i915 Debugging

#
# drm/i915 Profile Guided Optimisation
#
CONFIG_DRM_I915_USERFAULT_AUTOSUSPEND=250
CONFIG_DRM_I915_HEARTBEAT_INTERVAL=2500
CONFIG_DRM_I915_PREEMPT_TIMEOUT=640
CONFIG_DRM_I915_MAX_REQUEST_BUSYWAIT=8000
CONFIG_DRM_I915_STOP_TIMEOUT=100
CONFIG_DRM_I915_TIMESLICE_DURATION=1
# end of drm/i915 Profile Guided Optimisation

CONFIG_DRM_VGEM=m
CONFIG_DRM_VKMS=m
CONFIG_DRM_VMWGFX=m
CONFIG_DRM_VMWGFX_FBCON=y
# CONFIG_DRM_GMA500 is not set
CONFIG_DRM_AST=m
CONFIG_DRM_MGAG200=m
# CONFIG_DRM_CIRRUS_QEMU is not set
CONFIG_DRM_RCAR_DW_HDMI=m
CONFIG_DRM_RCAR_LVDS=m
CONFIG_DRM_QXL=m
# CONFIG_DRM_BOCHS is not set
# CONFIG_DRM_VIRTIO_GPU is not set
CONFIG_DRM_PANEL=y

#
# Display Panels
#
CONFIG_DRM_PANEL_ARM_VERSATILE=m
# CONFIG_DRM_PANEL_BOE_HIMAX8279D is not set
# CONFIG_DRM_PANEL_BOE_TV101WUM_NL6 is not set
CONFIG_DRM_PANEL_LVDS=m
CONFIG_DRM_PANEL_SIMPLE=m
# CONFIG_DRM_PANEL_ELIDA_KD35T133 is not set
# CONFIG_DRM_PANEL_FEIXIN_K101_IM2BA02 is not set
# CONFIG_DRM_PANEL_FEIYANG_FY07024DI26A30D is not set
CONFIG_DRM_PANEL_ILITEK_ILI9881C=m
# CONFIG_DRM_PANEL_INNOLUX_P079ZCA is not set
CONFIG_DRM_PANEL_JDI_LT070ME05000=m
# CONFIG_DRM_PANEL_KINGDISPLAY_KD097D04 is not set
# CONFIG_DRM_PANEL_LEADTEK_LTK500HD1829 is not set
# CONFIG_DRM_PANEL_NOVATEK_NT35510 is not set
CONFIG_DRM_PANEL_OLIMEX_LCD_OLINUXINO=m
CONFIG_DRM_PANEL_ORISETECH_OTM8009A=m
# CONFIG_DRM_PANEL_OSD_OSD101T2587_53TS is not set
CONFIG_DRM_PANEL_PANASONIC_VVX10F034N00=m
CONFIG_DRM_PANEL_RASPBERRYPI_TOUCHSCREEN=m
# CONFIG_DRM_PANEL_RAYDIUM_RM67191 is not set
CONFIG_DRM_PANEL_RAYDIUM_RM68200=m
CONFIG_DRM_PANEL_ROCKTECH_JH057N00900=m
CONFIG_DRM_PANEL_RONBO_RB070D30=m
# CONFIG_DRM_PANEL_SAMSUNG_S6D16D0 is not set
CONFIG_DRM_PANEL_SAMSUNG_S6E3HA2=m
CONFIG_DRM_PANEL_SAMSUNG_S6E63J0X03=m
# CONFIG_DRM_PANEL_SAMSUNG_S6E88A0_AMS452EF01 is not set
CONFIG_DRM_PANEL_SAMSUNG_S6E8AA0=m
CONFIG_DRM_PANEL_SEIKO_43WVF1G=m
# CONFIG_DRM_PANEL_SHARP_LQ101R1SX01 is not set
CONFIG_DRM_PANEL_SHARP_LS037V7DW01=m
CONFIG_DRM_PANEL_SHARP_LS043T1LE01=m
# CONFIG_DRM_PANEL_SITRONIX_ST7701 is not set
# CONFIG_DRM_PANEL_SONY_ACX424AKP is not set
CONFIG_DRM_PANEL_TRULY_NT35597_WQXGA=m
# CONFIG_DRM_PANEL_XINPENG_XPP055C272 is not set
# end of Display Panels

CONFIG_DRM_BRIDGE=y
CONFIG_DRM_PANEL_BRIDGE=y

#
# Display Interface Bridges
#
CONFIG_DRM_CDNS_DSI=m
# CONFIG_DRM_DISPLAY_CONNECTOR is not set
# CONFIG_DRM_LVDS_CODEC is not set
# CONFIG_DRM_MEGACHIPS_STDPXXXX_GE_B850V3_FW is not set
CONFIG_DRM_NXP_PTN3460=m
# CONFIG_DRM_PARADE_PS8622 is not set
# CONFIG_DRM_PARADE_PS8640 is not set
CONFIG_DRM_SIL_SII8620=m
CONFIG_DRM_SII902X=m
CONFIG_DRM_SII9234=m
# CONFIG_DRM_SIMPLE_BRIDGE is not set
CONFIG_DRM_THINE_THC63LVD1024=m
CONFIG_DRM_TOSHIBA_TC358764=m
CONFIG_DRM_TOSHIBA_TC358767=m
# CONFIG_DRM_TOSHIBA_TC358768 is not set
# CONFIG_DRM_TI_TFP410 is not set
# CONFIG_DRM_TI_SN65DSI86 is not set
# CONFIG_DRM_TI_TPD12S015 is not set
# CONFIG_DRM_ANALOGIX_ANX6345 is not set
CONFIG_DRM_ANALOGIX_ANX78XX=m
CONFIG_DRM_ANALOGIX_DP=m
CONFIG_DRM_I2C_ADV7511=m
# CONFIG_DRM_I2C_ADV7511_CEC is not set
CONFIG_DRM_DW_HDMI=m
CONFIG_DRM_DW_HDMI_CEC=m
# end of Display Interface Bridges

# CONFIG_DRM_ETNAVIV is not set
# CONFIG_DRM_ARCPGU is not set
CONFIG_DRM_MXS=y
CONFIG_DRM_MXSFB=m
CONFIG_DRM_VBOXVIDEO=m
CONFIG_DRM_LEGACY=y
# CONFIG_DRM_TDFX is not set
CONFIG_DRM_R128=m
CONFIG_DRM_MGA=m
CONFIG_DRM_VIA=m
CONFIG_DRM_SAVAGE=m
CONFIG_DRM_EXPORT_FOR_TESTS=y
CONFIG_DRM_PANEL_ORIENTATION_QUIRKS=m
CONFIG_DRM_LIB_RANDOM=y

#
# Frame buffer Devices
#
CONFIG_FB_CMDLINE=y
CONFIG_FB_NOTIFY=y
CONFIG_FB=m
CONFIG_FIRMWARE_EDID=y
CONFIG_FB_DDC=m
CONFIG_FB_CFB_FILLRECT=m
CONFIG_FB_CFB_COPYAREA=m
CONFIG_FB_CFB_IMAGEBLIT=m
CONFIG_FB_SYS_FILLRECT=m
CONFIG_FB_SYS_COPYAREA=m
CONFIG_FB_SYS_IMAGEBLIT=m
# CONFIG_FB_FOREIGN_ENDIAN is not set
CONFIG_FB_SYS_FOPS=m
CONFIG_FB_DEFERRED_IO=y
CONFIG_FB_SVGALIB=m
CONFIG_FB_BACKLIGHT=m
CONFIG_FB_MODE_HELPERS=y
CONFIG_FB_TILEBLITTING=y

#
# Frame buffer hardware drivers
#
# CONFIG_FB_CIRRUS is not set
CONFIG_FB_PM2=m
# CONFIG_FB_PM2_FIFO_DISCONNECT is not set
CONFIG_FB_CYBER2000=m
CONFIG_FB_CYBER2000_DDC=y
CONFIG_FB_ARC=m
# CONFIG_FB_VGA16 is not set
# CONFIG_FB_UVESA is not set
# CONFIG_FB_N411 is not set
CONFIG_FB_HGA=m
CONFIG_FB_OPENCORES=m
# CONFIG_FB_S1D13XXX is not set
# CONFIG_FB_NVIDIA is not set
# CONFIG_FB_RIVA is not set
# CONFIG_FB_I740 is not set
# CONFIG_FB_LE80578 is not set
# CONFIG_FB_MATROX is not set
CONFIG_FB_RADEON=m
CONFIG_FB_RADEON_I2C=y
# CONFIG_FB_RADEON_BACKLIGHT is not set
# CONFIG_FB_RADEON_DEBUG is not set
# CONFIG_FB_ATY128 is not set
# CONFIG_FB_ATY is not set
CONFIG_FB_S3=m
CONFIG_FB_S3_DDC=y
CONFIG_FB_SAVAGE=m
# CONFIG_FB_SAVAGE_I2C is not set
# CONFIG_FB_SAVAGE_ACCEL is not set
# CONFIG_FB_SIS is not set
CONFIG_FB_VIA=m
CONFIG_FB_VIA_DIRECT_PROCFS=y
CONFIG_FB_VIA_X_COMPATIBILITY=y
CONFIG_FB_NEOMAGIC=m
CONFIG_FB_KYRO=m
CONFIG_FB_3DFX=m
# CONFIG_FB_3DFX_ACCEL is not set
# CONFIG_FB_3DFX_I2C is not set
# CONFIG_FB_VOODOO1 is not set
# CONFIG_FB_VT8623 is not set
CONFIG_FB_TRIDENT=m
CONFIG_FB_ARK=m
# CONFIG_FB_PM3 is not set
CONFIG_FB_CARMINE=m
CONFIG_FB_CARMINE_DRAM_EVAL=y
# CONFIG_CARMINE_DRAM_CUSTOM is not set
# CONFIG_FB_GEODE is not set
# CONFIG_FB_IBM_GXT4500 is not set
CONFIG_FB_GOLDFISH=m
# CONFIG_FB_VIRTUAL is not set
CONFIG_FB_METRONOME=m
CONFIG_FB_MB862XX=m
CONFIG_FB_MB862XX_PCI_GDC=y
CONFIG_FB_MB862XX_I2C=y
CONFIG_FB_SSD1307=m
CONFIG_FB_SM712=m
# end of Frame buffer Devices

#
# Backlight & LCD device support
#
CONFIG_LCD_CLASS_DEVICE=m
# CONFIG_LCD_PLATFORM is not set
CONFIG_BACKLIGHT_CLASS_DEVICE=m
CONFIG_BACKLIGHT_GENERIC=m
CONFIG_BACKLIGHT_LM3533=m
CONFIG_BACKLIGHT_PWM=m
CONFIG_BACKLIGHT_MAX8925=m
# CONFIG_BACKLIGHT_APPLE is not set
# CONFIG_BACKLIGHT_QCOM_WLED is not set
CONFIG_BACKLIGHT_SAHARA=m
CONFIG_BACKLIGHT_ADP5520=m
CONFIG_BACKLIGHT_ADP8860=m
# CONFIG_BACKLIGHT_ADP8870 is not set
# CONFIG_BACKLIGHT_LM3630A is not set
CONFIG_BACKLIGHT_LM3639=m
# CONFIG_BACKLIGHT_LP855X is not set
CONFIG_BACKLIGHT_PANDORA=m
CONFIG_BACKLIGHT_TPS65217=m
# CONFIG_BACKLIGHT_GPIO is not set
CONFIG_BACKLIGHT_LV5207LP=m
# CONFIG_BACKLIGHT_BD6107 is not set
CONFIG_BACKLIGHT_ARCXCNN=m
CONFIG_BACKLIGHT_RAVE_SP=m
# CONFIG_BACKLIGHT_LED is not set
# end of Backlight & LCD device support

CONFIG_VGASTATE=m
CONFIG_VIDEOMODE_HELPERS=y
CONFIG_HDMI=y
CONFIG_LOGO=y
CONFIG_LOGO_LINUX_MONO=y
CONFIG_LOGO_LINUX_VGA16=y
# CONFIG_LOGO_LINUX_CLUT224 is not set
# end of Graphics support

CONFIG_SOUND=y
# CONFIG_SND is not set

#
# HID support
#
CONFIG_HID=y
CONFIG_HID_BATTERY_STRENGTH=y
CONFIG_HIDRAW=y
CONFIG_UHID=y
CONFIG_HID_GENERIC=y

#
# Special HID drivers
#
# CONFIG_HID_A4TECH is not set
CONFIG_HID_ACRUX=y
# CONFIG_HID_ACRUX_FF is not set
CONFIG_HID_APPLE=m
CONFIG_HID_ASUS=y
# CONFIG_HID_AUREAL is not set
# CONFIG_HID_BELKIN is not set
CONFIG_HID_CHERRY=y
CONFIG_HID_CHICONY=y
CONFIG_HID_COUGAR=y
# CONFIG_HID_MACALLY is not set
# CONFIG_HID_CMEDIA is not set
CONFIG_HID_CYPRESS=y
CONFIG_HID_DRAGONRISE=m
CONFIG_DRAGONRISE_FF=y
# CONFIG_HID_EMS_FF is not set
CONFIG_HID_ELECOM=m
CONFIG_HID_EZKEY=m
CONFIG_HID_GEMBIRD=y
CONFIG_HID_GFRM=m
# CONFIG_HID_GLORIOUS is not set
CONFIG_HID_KEYTOUCH=y
CONFIG_HID_KYE=y
CONFIG_HID_WALTOP=m
# CONFIG_HID_VIEWSONIC is not set
CONFIG_HID_GYRATION=m
CONFIG_HID_ICADE=y
CONFIG_HID_ITE=y
CONFIG_HID_JABRA=m
CONFIG_HID_TWINHAN=m
CONFIG_HID_KENSINGTON=m
CONFIG_HID_LCPOWER=y
CONFIG_HID_LED=m
CONFIG_HID_LENOVO=y
CONFIG_HID_LOGITECH=m
CONFIG_HID_LOGITECH_HIDPP=m
CONFIG_LOGITECH_FF=y
CONFIG_LOGIRUMBLEPAD2_FF=y
CONFIG_LOGIG940_FF=y
# CONFIG_LOGIWHEELS_FF is not set
CONFIG_HID_MAGICMOUSE=y
# CONFIG_HID_MALTRON is not set
CONFIG_HID_MAYFLASH=m
CONFIG_HID_REDRAGON=m
CONFIG_HID_MICROSOFT=m
CONFIG_HID_MONTEREY=y
CONFIG_HID_MULTITOUCH=m
# CONFIG_HID_NTI is not set
CONFIG_HID_ORTEK=m
CONFIG_HID_PANTHERLORD=m
# CONFIG_PANTHERLORD_FF is not set
CONFIG_HID_PETALYNX=y
# CONFIG_HID_PICOLCD is not set
# CONFIG_HID_PLANTRONICS is not set
# CONFIG_HID_PRIMAX is not set
CONFIG_HID_SAITEK=y
CONFIG_HID_SAMSUNG=m
CONFIG_HID_SPEEDLINK=m
# CONFIG_HID_STEAM is not set
# CONFIG_HID_STEELSERIES is not set
CONFIG_HID_SUNPLUS=m
CONFIG_HID_RMI=m
# CONFIG_HID_GREENASIA is not set
CONFIG_HID_SMARTJOYPLUS=y
# CONFIG_SMARTJOYPLUS_FF is not set
CONFIG_HID_TIVO=m
CONFIG_HID_TOPSEED=m
# CONFIG_HID_THINGM is not set
CONFIG_HID_THRUSTMASTER=m
# CONFIG_THRUSTMASTER_FF is not set
CONFIG_HID_UDRAW_PS3=m
CONFIG_HID_WIIMOTE=y
CONFIG_HID_XINMO=y
CONFIG_HID_ZEROPLUS=m
CONFIG_ZEROPLUS_FF=y
CONFIG_HID_ZYDACRON=m
CONFIG_HID_SENSOR_HUB=y
CONFIG_HID_SENSOR_CUSTOM_SENSOR=y
CONFIG_HID_ALPS=y
# end of Special HID drivers

#
# I2C HID support
#
CONFIG_I2C_HID=y
# end of I2C HID support
# end of HID support

CONFIG_USB_OHCI_LITTLE_ENDIAN=y
CONFIG_USB_SUPPORT=y
# CONFIG_USB_LED_TRIG is not set
# CONFIG_USB_ULPI_BUS is not set
# CONFIG_USB_CONN_GPIO is not set
CONFIG_USB_ARCH_HAS_HCD=y
# CONFIG_USB is not set
CONFIG_USB_PCI=y

#
# USB port drivers
#

#
# USB Physical Layer drivers
#
# CONFIG_NOP_USB_XCEIV is not set
# CONFIG_USB_GPIO_VBUS is not set
# end of USB Physical Layer drivers

# CONFIG_USB_GADGET is not set
# CONFIG_TYPEC is not set
# CONFIG_USB_ROLE_SWITCH is not set
CONFIG_MMC=m
CONFIG_PWRSEQ_EMMC=m
CONFIG_PWRSEQ_SIMPLE=m
# CONFIG_MMC_BLOCK is not set
CONFIG_SDIO_UART=m
CONFIG_MMC_TEST=m

#
# MMC/SD/SDIO Host Controller Drivers
#
# CONFIG_MMC_DEBUG is not set
CONFIG_MMC_SDHCI=m
CONFIG_MMC_SDHCI_IO_ACCESSORS=y
CONFIG_MMC_SDHCI_PCI=m
# CONFIG_MMC_RICOH_MMC is not set
# CONFIG_MMC_SDHCI_ACPI is not set
# CONFIG_MMC_SDHCI_PLTFM is not set
CONFIG_MMC_WBSD=m
# CONFIG_MMC_TIFM_SD is not set
# CONFIG_MMC_GOLDFISH is not set
# CONFIG_MMC_CB710 is not set
CONFIG_MMC_VIA_SDMMC=m
CONFIG_MMC_USDHI6ROL0=m
# CONFIG_MMC_REALTEK_PCI is not set
CONFIG_MMC_CQHCI=m
CONFIG_MMC_HSQ=m
CONFIG_MMC_TOSHIBA_PCI=m
CONFIG_MMC_MTK=m
CONFIG_MEMSTICK=m
# CONFIG_MEMSTICK_DEBUG is not set

#
# MemoryStick drivers
#
CONFIG_MEMSTICK_UNSAFE_RESUME=y
# CONFIG_MSPRO_BLOCK is not set
# CONFIG_MS_BLOCK is not set

#
# MemoryStick Host Controller Drivers
#
CONFIG_MEMSTICK_TIFM_MS=m
CONFIG_MEMSTICK_JMICRON_38X=m
# CONFIG_MEMSTICK_R592 is not set
CONFIG_MEMSTICK_REALTEK_PCI=m
CONFIG_NEW_LEDS=y
CONFIG_LEDS_CLASS=y
CONFIG_LEDS_CLASS_FLASH=m
CONFIG_LEDS_BRIGHTNESS_HW_CHANGED=y

#
# LED drivers
#
CONFIG_LEDS_AAT1290=m
CONFIG_LEDS_AN30259A=m
# CONFIG_LEDS_AS3645A is not set
CONFIG_LEDS_BCM6328=y
CONFIG_LEDS_BCM6358=y
# CONFIG_LEDS_LM3530 is not set
# CONFIG_LEDS_LM3532 is not set
CONFIG_LEDS_LM3533=m
# CONFIG_LEDS_LM3642 is not set
# CONFIG_LEDS_LM3692X is not set
CONFIG_LEDS_LM3601X=m
# CONFIG_LEDS_MT6323 is not set
CONFIG_LEDS_PCA9532=m
# CONFIG_LEDS_PCA9532_GPIO is not set
# CONFIG_LEDS_GPIO is not set
CONFIG_LEDS_LP3944=m
CONFIG_LEDS_LP3952=m
CONFIG_LEDS_LP55XX_COMMON=y
CONFIG_LEDS_LP5521=y
CONFIG_LEDS_LP5523=m
# CONFIG_LEDS_LP5562 is not set
CONFIG_LEDS_LP8501=m
CONFIG_LEDS_LP8860=m
CONFIG_LEDS_PCA955X=y
CONFIG_LEDS_PCA955X_GPIO=y
CONFIG_LEDS_PCA963X=y
# CONFIG_LEDS_PWM is not set
CONFIG_LEDS_REGULATOR=m
CONFIG_LEDS_BD2802=m
CONFIG_LEDS_LT3593=m
# CONFIG_LEDS_ADP5520 is not set
CONFIG_LEDS_TCA6507=m
CONFIG_LEDS_TLC591XX=y
CONFIG_LEDS_MAX77693=m
# CONFIG_LEDS_LM355x is not set
CONFIG_LEDS_OT200=y
CONFIG_LEDS_MENF21BMC=m
CONFIG_LEDS_KTD2692=m
# CONFIG_LEDS_IS31FL319X is not set
# CONFIG_LEDS_IS31FL32XX is not set

#
# LED driver for blink(1) USB RGB LED is under Special HID drivers (HID_THINGM)
#
CONFIG_LEDS_BLINKM=y
# CONFIG_LEDS_SYSCON is not set
CONFIG_LEDS_MLXREG=m
CONFIG_LEDS_USER=y
# CONFIG_LEDS_NIC78BX is not set
CONFIG_LEDS_TI_LMU_COMMON=y
# CONFIG_LEDS_LM3697 is not set
CONFIG_LEDS_LM36274=m
CONFIG_LEDS_TPS6105X=m

#
# LED Triggers
#
CONFIG_LEDS_TRIGGERS=y
CONFIG_LEDS_TRIGGER_TIMER=y
CONFIG_LEDS_TRIGGER_ONESHOT=m
CONFIG_LEDS_TRIGGER_DISK=y
# CONFIG_LEDS_TRIGGER_MTD is not set
CONFIG_LEDS_TRIGGER_HEARTBEAT=m
CONFIG_LEDS_TRIGGER_BACKLIGHT=y
# CONFIG_LEDS_TRIGGER_CPU is not set
CONFIG_LEDS_TRIGGER_ACTIVITY=m
CONFIG_LEDS_TRIGGER_GPIO=m
CONFIG_LEDS_TRIGGER_DEFAULT_ON=m

#
# iptables trigger is under Netfilter config (LED target)
#
CONFIG_LEDS_TRIGGER_TRANSIENT=m
CONFIG_LEDS_TRIGGER_CAMERA=m
# CONFIG_LEDS_TRIGGER_PANIC is not set
CONFIG_LEDS_TRIGGER_NETDEV=y
CONFIG_LEDS_TRIGGER_PATTERN=y
# CONFIG_LEDS_TRIGGER_AUDIO is not set
CONFIG_ACCESSIBILITY=y
# CONFIG_INFINIBAND is not set
CONFIG_EDAC_ATOMIC_SCRUB=y
CONFIG_EDAC_SUPPORT=y
CONFIG_EDAC=y
# CONFIG_EDAC_LEGACY_SYSFS is not set
CONFIG_EDAC_DEBUG=y
# CONFIG_EDAC_AMD76X is not set
CONFIG_EDAC_E7XXX=y
CONFIG_EDAC_E752X=m
CONFIG_EDAC_I82875P=y
CONFIG_EDAC_I82975X=y
# CONFIG_EDAC_I3000 is not set
# CONFIG_EDAC_I3200 is not set
CONFIG_EDAC_IE31200=m
CONFIG_EDAC_X38=m
# CONFIG_EDAC_I5400 is not set
CONFIG_EDAC_I82860=y
# CONFIG_EDAC_R82600 is not set
# CONFIG_EDAC_I5000 is not set
# CONFIG_EDAC_I5100 is not set
# CONFIG_EDAC_I7300 is not set
CONFIG_RTC_LIB=y
CONFIG_RTC_MC146818_LIB=y
CONFIG_RTC_CLASS=y
# CONFIG_RTC_HCTOSYS is not set
# CONFIG_RTC_SYSTOHC is not set
CONFIG_RTC_DEBUG=y
CONFIG_RTC_NVMEM=y

#
# RTC interfaces
#
CONFIG_RTC_INTF_SYSFS=y
CONFIG_RTC_INTF_PROC=y
# CONFIG_RTC_INTF_DEV is not set
CONFIG_RTC_DRV_TEST=y

#
# I2C RTC drivers
#
# CONFIG_RTC_DRV_88PM80X is not set
CONFIG_RTC_DRV_ABB5ZES3=m
CONFIG_RTC_DRV_ABEOZ9=y
# CONFIG_RTC_DRV_ABX80X is not set
CONFIG_RTC_DRV_AS3722=m
# CONFIG_RTC_DRV_DS1307 is not set
CONFIG_RTC_DRV_DS1374=y
CONFIG_RTC_DRV_DS1374_WDT=y
# CONFIG_RTC_DRV_DS1672 is not set
CONFIG_RTC_DRV_HYM8563=m
CONFIG_RTC_DRV_MAX6900=m
CONFIG_RTC_DRV_MAX8907=m
CONFIG_RTC_DRV_MAX8925=y
# CONFIG_RTC_DRV_MAX8998 is not set
# CONFIG_RTC_DRV_MAX77686 is not set
CONFIG_RTC_DRV_RS5C372=y
CONFIG_RTC_DRV_ISL1208=m
# CONFIG_RTC_DRV_ISL12022 is not set
CONFIG_RTC_DRV_ISL12026=y
CONFIG_RTC_DRV_X1205=m
CONFIG_RTC_DRV_PCF8523=m
# CONFIG_RTC_DRV_PCF85063 is not set
# CONFIG_RTC_DRV_PCF85363 is not set
# CONFIG_RTC_DRV_PCF8563 is not set
CONFIG_RTC_DRV_PCF8583=m
# CONFIG_RTC_DRV_M41T80 is not set
# CONFIG_RTC_DRV_BD70528 is not set
# CONFIG_RTC_DRV_BQ32K is not set
# CONFIG_RTC_DRV_TWL4030 is not set
CONFIG_RTC_DRV_PALMAS=y
# CONFIG_RTC_DRV_TPS65910 is not set
CONFIG_RTC_DRV_TPS80031=m
# CONFIG_RTC_DRV_RC5T619 is not set
# CONFIG_RTC_DRV_S35390A is not set
CONFIG_RTC_DRV_FM3130=y
# CONFIG_RTC_DRV_RX8010 is not set
# CONFIG_RTC_DRV_RX8581 is not set
# CONFIG_RTC_DRV_RX8025 is not set
CONFIG_RTC_DRV_EM3027=m
CONFIG_RTC_DRV_RV3028=m
CONFIG_RTC_DRV_RV8803=m
# CONFIG_RTC_DRV_S5M is not set
# CONFIG_RTC_DRV_SD3078 is not set

#
# SPI RTC drivers
#
CONFIG_RTC_I2C_AND_SPI=y

#
# SPI and I2C RTC drivers
#
# CONFIG_RTC_DRV_DS3232 is not set
CONFIG_RTC_DRV_PCF2127=m
# CONFIG_RTC_DRV_RV3029C2 is not set

#
# Platform RTC drivers
#
CONFIG_RTC_DRV_CMOS=m
# CONFIG_RTC_DRV_DS1286 is not set
CONFIG_RTC_DRV_DS1511=m
CONFIG_RTC_DRV_DS1553=y
# CONFIG_RTC_DRV_DS1685_FAMILY is not set
CONFIG_RTC_DRV_DS1742=m
# CONFIG_RTC_DRV_DS2404 is not set
CONFIG_RTC_DRV_DA9063=y
# CONFIG_RTC_DRV_STK17TA8 is not set
CONFIG_RTC_DRV_M48T86=y
# CONFIG_RTC_DRV_M48T35 is not set
# CONFIG_RTC_DRV_M48T59 is not set
CONFIG_RTC_DRV_MSM6242=y
CONFIG_RTC_DRV_BQ4802=y
# CONFIG_RTC_DRV_RP5C01 is not set
CONFIG_RTC_DRV_V3020=m
# CONFIG_RTC_DRV_ZYNQMP is not set

#
# on-CPU RTC drivers
#
# CONFIG_RTC_DRV_CADENCE is not set
CONFIG_RTC_DRV_FTRTC010=y
CONFIG_RTC_DRV_MT6397=m
CONFIG_RTC_DRV_R7301=m

#
# HID Sensor RTC drivers
#
CONFIG_RTC_DRV_GOLDFISH=m
CONFIG_DMADEVICES=y
# CONFIG_DMADEVICES_DEBUG is not set

#
# DMA Devices
#
CONFIG_DMA_ENGINE=y
CONFIG_DMA_VIRTUAL_CHANNELS=y
CONFIG_DMA_ACPI=y
CONFIG_DMA_OF=y
CONFIG_ALTERA_MSGDMA=y
CONFIG_DW_AXI_DMAC=y
# CONFIG_FSL_EDMA is not set
# CONFIG_INTEL_IDMA64 is not set
CONFIG_PCH_DMA=m
# CONFIG_PLX_DMA is not set
CONFIG_QCOM_HIDMA_MGMT=y
CONFIG_QCOM_HIDMA=y
CONFIG_DW_DMAC_CORE=m
CONFIG_DW_DMAC=m
# CONFIG_DW_DMAC_PCI is not set
# CONFIG_SF_PDMA is not set

#
# DMA Clients
#
CONFIG_ASYNC_TX_DMA=y
CONFIG_DMATEST=y
CONFIG_DMA_ENGINE_RAID=y

#
# DMABUF options
#
CONFIG_SYNC_FILE=y
CONFIG_SW_SYNC=y
CONFIG_UDMABUF=y
# CONFIG_DMABUF_MOVE_NOTIFY is not set
CONFIG_DMABUF_SELFTESTS=m
# CONFIG_DMABUF_HEAPS is not set
# end of DMABUF options

CONFIG_AUXDISPLAY=y
# CONFIG_HD44780 is not set
CONFIG_KS0108=m
CONFIG_KS0108_PORT=0x378
CONFIG_KS0108_DELAY=2
# CONFIG_CFAG12864B is not set
CONFIG_IMG_ASCII_LCD=m
CONFIG_HT16K33=m
# CONFIG_PARPORT_PANEL is not set
# CONFIG_CHARLCD_BL_OFF is not set
CONFIG_CHARLCD_BL_ON=y
# CONFIG_CHARLCD_BL_FLASH is not set
# CONFIG_PANEL is not set
CONFIG_UIO=y
CONFIG_UIO_CIF=y
# CONFIG_UIO_PDRV_GENIRQ is not set
CONFIG_UIO_DMEM_GENIRQ=y
CONFIG_UIO_AEC=m
# CONFIG_UIO_SERCOS3 is not set
# CONFIG_UIO_PCI_GENERIC is not set
CONFIG_UIO_NETX=m
# CONFIG_UIO_PRUSS is not set
CONFIG_UIO_MF624=y
CONFIG_VIRT_DRIVERS=y
CONFIG_VBOXGUEST=y
CONFIG_VIRTIO=y
CONFIG_VIRTIO_MENU=y
CONFIG_VIRTIO_PCI=m
# CONFIG_VIRTIO_PCI_LEGACY is not set
CONFIG_VIRTIO_BALLOON=y
# CONFIG_VIRTIO_INPUT is not set
CONFIG_VIRTIO_MMIO=y
# CONFIG_VIRTIO_MMIO_CMDLINE_DEVICES is not set
# CONFIG_VDPA is not set
CONFIG_VHOST_DPN=y
CONFIG_VHOST_MENU=y
# CONFIG_VHOST_NET is not set
# CONFIG_VHOST_CROSS_ENDIAN_LEGACY is not set

#
# Microsoft Hyper-V guest support
#
# CONFIG_HYPERV is not set
# end of Microsoft Hyper-V guest support

# CONFIG_GREYBUS is not set
CONFIG_STAGING=y
# CONFIG_COMEDI is not set
# CONFIG_FB_OLPC_DCON is not set
# CONFIG_RTS5208 is not set

#
# IIO staging drivers
#

#
# Accelerometers
#
# end of Accelerometers

#
# Analog to digital converters
#
# end of Analog to digital converters

#
# Analog digital bi-direction converters
#
# CONFIG_ADT7316 is not set
# end of Analog digital bi-direction converters

#
# Capacitance to digital converters
#
# CONFIG_AD7150 is not set
# CONFIG_AD7746 is not set
# end of Capacitance to digital converters

#
# Direct Digital Synthesis
#
# end of Direct Digital Synthesis

#
# Network Analyzer, Impedance Converters
#
# CONFIG_AD5933 is not set
# end of Network Analyzer, Impedance Converters

#
# Active energy metering IC
#
# CONFIG_ADE7854 is not set
# end of Active energy metering IC

#
# Resolver to digital converters
#
# end of Resolver to digital converters
# end of IIO staging drivers

# CONFIG_FB_SM750 is not set

#
# Speakup console speech
#
# end of Speakup console speech

# CONFIG_STAGING_MEDIA is not set

#
# Android
#
# CONFIG_ASHMEM is not set
CONFIG_ION=y
CONFIG_ION_SYSTEM_HEAP=y
# end of Android

# CONFIG_STAGING_BOARD is not set
# CONFIG_GOLDFISH_AUDIO is not set
# CONFIG_GS_FPGABOOT is not set
# CONFIG_UNISYSSPAR is not set
# CONFIG_COMMON_CLK_XLNX_CLKWZRD is not set

#
# Gasket devices
#
# end of Gasket devices

# CONFIG_XIL_AXIS_FIFO is not set
# CONFIG_FIELDBUS_DEV is not set
# CONFIG_KPC2000 is not set
# CONFIG_QLGE is not set
# CONFIG_X86_PLATFORM_DEVICES is not set
CONFIG_PMC_ATOM=y
CONFIG_GOLDFISH_PIPE=m
# CONFIG_MFD_CROS_EC is not set
CONFIG_CHROME_PLATFORMS=y
CONFIG_CHROMEOS_PSTORE=y
# CONFIG_CHROMEOS_TBMC is not set
# CONFIG_CROS_EC is not set
# CONFIG_CROS_KBD_LED_BACKLIGHT is not set
# CONFIG_MELLANOX_PLATFORM is not set
CONFIG_OLPC_EC=y
CONFIG_CLKDEV_LOOKUP=y
CONFIG_HAVE_CLK_PREPARE=y
CONFIG_COMMON_CLK=y

#
# Common Clock Framework
#
# CONFIG_CLK_HSDK is not set
# CONFIG_COMMON_CLK_MAX77686 is not set
CONFIG_COMMON_CLK_MAX9485=y
CONFIG_COMMON_CLK_SI5341=y
CONFIG_COMMON_CLK_SI5351=m
CONFIG_COMMON_CLK_SI514=m
# CONFIG_COMMON_CLK_SI544 is not set
CONFIG_COMMON_CLK_SI570=y
# CONFIG_COMMON_CLK_CDCE706 is not set
CONFIG_COMMON_CLK_CDCE925=m
CONFIG_COMMON_CLK_CS2000_CP=m
CONFIG_COMMON_CLK_S2MPS11=m
# CONFIG_CLK_TWL6040 is not set
CONFIG_COMMON_CLK_LOCHNAGAR=m
# CONFIG_COMMON_CLK_PALMAS is not set
# CONFIG_COMMON_CLK_PWM is not set
CONFIG_COMMON_CLK_VC5=m
CONFIG_COMMON_CLK_BD718XX=m
CONFIG_COMMON_CLK_FIXED_MMIO=y
# end of Common Clock Framework

# CONFIG_HWSPINLOCK is not set

#
# Clock Source drivers
#
CONFIG_CLKSRC_I8253=y
CONFIG_CLKEVT_I8253=y
CONFIG_CLKBLD_I8253=y
# CONFIG_MICROCHIP_PIT64B is not set
# end of Clock Source drivers

CONFIG_MAILBOX=y
CONFIG_PLATFORM_MHU=m
# CONFIG_PCC is not set
# CONFIG_ALTERA_MBOX is not set
# CONFIG_MAILBOX_TEST is not set
CONFIG_IOMMU_SUPPORT=y

#
# Generic IOMMU Pagetable Support
#
# end of Generic IOMMU Pagetable Support

# CONFIG_IOMMU_DEBUGFS is not set

#
# Remoteproc drivers
#
CONFIG_REMOTEPROC=y
# end of Remoteproc drivers

#
# Rpmsg drivers
#
CONFIG_RPMSG=y
CONFIG_RPMSG_CHAR=m
# CONFIG_RPMSG_QCOM_GLINK_RPM is not set
CONFIG_RPMSG_VIRTIO=y
# end of Rpmsg drivers

CONFIG_SOUNDWIRE=m

#
# SoundWire Devices
#

#
# SOC (System On Chip) specific Drivers
#

#
# Amlogic SoC drivers
#
# end of Amlogic SoC drivers

#
# Aspeed SoC drivers
#
# end of Aspeed SoC drivers

#
# Broadcom SoC drivers
#
# end of Broadcom SoC drivers

#
# NXP/Freescale QorIQ SoC drivers
#
# end of NXP/Freescale QorIQ SoC drivers

#
# i.MX SoC drivers
#
# end of i.MX SoC drivers

#
# Qualcomm SoC drivers
#
# end of Qualcomm SoC drivers

CONFIG_SOC_TI=y

#
# Xilinx SoC drivers
#
CONFIG_XILINX_VCU=m
# end of Xilinx SoC drivers
# end of SOC (System On Chip) specific Drivers

CONFIG_PM_DEVFREQ=y

#
# DEVFREQ Governors
#
CONFIG_DEVFREQ_GOV_SIMPLE_ONDEMAND=y
# CONFIG_DEVFREQ_GOV_PERFORMANCE is not set
CONFIG_DEVFREQ_GOV_POWERSAVE=m
# CONFIG_DEVFREQ_GOV_USERSPACE is not set
CONFIG_DEVFREQ_GOV_PASSIVE=y

#
# DEVFREQ Drivers
#
CONFIG_PM_DEVFREQ_EVENT=y
CONFIG_EXTCON=y

#
# Extcon Device Drivers
#
CONFIG_EXTCON_ADC_JACK=m
# CONFIG_EXTCON_AXP288 is not set
CONFIG_EXTCON_FSA9480=y
CONFIG_EXTCON_GPIO=y
# CONFIG_EXTCON_INTEL_INT3496 is not set
CONFIG_EXTCON_MAX14577=m
CONFIG_EXTCON_MAX3355=m
CONFIG_EXTCON_MAX77693=y
CONFIG_EXTCON_PALMAS=m
CONFIG_EXTCON_PTN5150=m
# CONFIG_EXTCON_RT8973A is not set
CONFIG_EXTCON_SM5502=y
# CONFIG_EXTCON_USB_GPIO is not set
# CONFIG_MEMORY is not set
CONFIG_IIO=m
CONFIG_IIO_BUFFER=y
CONFIG_IIO_BUFFER_CB=m
CONFIG_IIO_BUFFER_HW_CONSUMER=m
CONFIG_IIO_KFIFO_BUF=m
CONFIG_IIO_TRIGGERED_BUFFER=m
CONFIG_IIO_CONFIGFS=m
CONFIG_IIO_TRIGGER=y
CONFIG_IIO_CONSUMERS_PER_TRIGGER=2
CONFIG_IIO_SW_DEVICE=m
CONFIG_IIO_SW_TRIGGER=m

#
# Accelerometers
#
CONFIG_ADXL372=m
CONFIG_ADXL372_I2C=m
CONFIG_BMA180=m
# CONFIG_BMA400 is not set
CONFIG_BMC150_ACCEL=m
CONFIG_BMC150_ACCEL_I2C=m
# CONFIG_DA280 is not set
CONFIG_DA311=m
CONFIG_DMARD06=m
CONFIG_DMARD09=m
CONFIG_DMARD10=m
CONFIG_HID_SENSOR_ACCEL_3D=m
CONFIG_KXSD9=m
# CONFIG_KXSD9_I2C is not set
CONFIG_KXCJK1013=m
CONFIG_MC3230=m
CONFIG_MMA7455=m
CONFIG_MMA7455_I2C=m
# CONFIG_MMA7660 is not set
# CONFIG_MMA8452 is not set
CONFIG_MMA9551_CORE=m
CONFIG_MMA9551=m
CONFIG_MMA9553=m
# CONFIG_MXC4005 is not set
CONFIG_MXC6255=m
CONFIG_STK8312=m
CONFIG_STK8BA50=m
# end of Accelerometers

#
# Analog to digital converters
#
# CONFIG_AD7091R5 is not set
CONFIG_AD7291=m
# CONFIG_AD7606_IFACE_PARALLEL is not set
# CONFIG_AD799X is not set
# CONFIG_AXP20X_ADC is not set
CONFIG_AXP288_ADC=m
CONFIG_CC10001_ADC=m
# CONFIG_DA9150_GPADC is not set
CONFIG_ENVELOPE_DETECTOR=m
CONFIG_HX711=m
# CONFIG_INA2XX_ADC is not set
# CONFIG_LTC2471 is not set
CONFIG_LTC2485=m
CONFIG_LTC2497=m
CONFIG_MAX1363=m
CONFIG_MAX9611=m
CONFIG_MCP3422=m
CONFIG_MEN_Z188_ADC=m
CONFIG_NAU7802=m
CONFIG_PALMAS_GPADC=m
# CONFIG_RN5T618_ADC is not set
CONFIG_SD_ADC_MODULATOR=m
# CONFIG_STMPE_ADC is not set
# CONFIG_TI_ADC081C is not set
CONFIG_TI_ADS1015=m
CONFIG_TWL4030_MADC=m
CONFIG_TWL6030_GPADC=m
CONFIG_VF610_ADC=m
CONFIG_XILINX_XADC=m
# end of Analog to digital converters

#
# Analog Front Ends
#
CONFIG_IIO_RESCALE=m
# end of Analog Front Ends

#
# Amplifiers
#
# CONFIG_HMC425 is not set
# end of Amplifiers

#
# Chemical Sensors
#
# CONFIG_ATLAS_PH_SENSOR is not set
CONFIG_BME680=m
CONFIG_BME680_I2C=m
# CONFIG_CCS811 is not set
CONFIG_IAQCORE=m
# CONFIG_PMS7003 is not set
CONFIG_SENSIRION_SGP30=m
CONFIG_SPS30=m
# CONFIG_VZ89X is not set
# end of Chemical Sensors

#
# Hid Sensor IIO Common
#
CONFIG_HID_SENSOR_IIO_COMMON=m
CONFIG_HID_SENSOR_IIO_TRIGGER=m
# end of Hid Sensor IIO Common

CONFIG_IIO_MS_SENSORS_I2C=m

#
# SSP Sensor Common
#
# end of SSP Sensor Common

CONFIG_IIO_ST_SENSORS_I2C=m
CONFIG_IIO_ST_SENSORS_CORE=m

#
# Digital to analog converters
#
# CONFIG_AD5064 is not set
# CONFIG_AD5380 is not set
CONFIG_AD5446=m
CONFIG_AD5592R_BASE=m
CONFIG_AD5593R=m
# CONFIG_AD5696_I2C is not set
CONFIG_CIO_DAC=m
# CONFIG_DPOT_DAC is not set
# CONFIG_DS4424 is not set
CONFIG_M62332=m
CONFIG_MAX517=m
CONFIG_MAX5821=m
CONFIG_MCP4725=m
CONFIG_TI_DAC5571=m
CONFIG_VF610_DAC=m
# end of Digital to analog converters

#
# IIO dummy driver
#
CONFIG_IIO_SIMPLE_DUMMY=m
# CONFIG_IIO_SIMPLE_DUMMY_EVENTS is not set
CONFIG_IIO_SIMPLE_DUMMY_BUFFER=y
# end of IIO dummy driver

#
# Frequency Synthesizers DDS/PLL
#

#
# Clock Generator/Distribution
#
# end of Clock Generator/Distribution

#
# Phase-Locked Loop (PLL) frequency synthesizers
#
# end of Phase-Locked Loop (PLL) frequency synthesizers
# end of Frequency Synthesizers DDS/PLL

#
# Digital gyroscope sensors
#
CONFIG_BMG160=m
CONFIG_BMG160_I2C=m
CONFIG_FXAS21002C=m
CONFIG_FXAS21002C_I2C=m
CONFIG_HID_SENSOR_GYRO_3D=m
# CONFIG_MPU3050_I2C is not set
# CONFIG_IIO_ST_GYRO_3AXIS is not set
# CONFIG_ITG3200 is not set
# end of Digital gyroscope sensors

#
# Health Sensors
#

#
# Heart Rate Monitors
#
# CONFIG_AFE4404 is not set
CONFIG_MAX30100=m
CONFIG_MAX30102=m
# end of Heart Rate Monitors
# end of Health Sensors

#
# Humidity sensors
#
# CONFIG_AM2315 is not set
CONFIG_DHT11=m
# CONFIG_HDC100X is not set
CONFIG_HID_SENSOR_HUMIDITY=m
# CONFIG_HTS221 is not set
CONFIG_HTU21=m
# CONFIG_SI7005 is not set
# CONFIG_SI7020 is not set
# end of Humidity sensors

#
# Inertial measurement units
#
# CONFIG_BMI160_I2C is not set
# CONFIG_FXOS8700_I2C is not set
CONFIG_KMX61=m
# CONFIG_INV_MPU6050_I2C is not set
CONFIG_IIO_ST_LSM6DSX=m
CONFIG_IIO_ST_LSM6DSX_I2C=m
CONFIG_IIO_ST_LSM6DSX_I3C=m
# end of Inertial measurement units

#
# Light sensors
#
# CONFIG_ACPI_ALS is not set
CONFIG_ADJD_S311=m
# CONFIG_ADUX1020 is not set
# CONFIG_AL3010 is not set
CONFIG_AL3320A=m
CONFIG_APDS9300=m
CONFIG_APDS9960=m
CONFIG_BH1750=m
CONFIG_BH1780=m
CONFIG_CM32181=m
# CONFIG_CM3232 is not set
CONFIG_CM3323=m
CONFIG_CM3605=m
CONFIG_CM36651=m
# CONFIG_GP2AP002 is not set
CONFIG_GP2AP020A00F=m
# CONFIG_SENSORS_ISL29018 is not set
CONFIG_SENSORS_ISL29028=m
# CONFIG_ISL29125 is not set
CONFIG_HID_SENSOR_ALS=m
CONFIG_HID_SENSOR_PROX=m
# CONFIG_JSA1212 is not set
CONFIG_RPR0521=m
CONFIG_SENSORS_LM3533=m
CONFIG_LTR501=m
# CONFIG_LV0104CS is not set
CONFIG_MAX44000=m
CONFIG_MAX44009=m
CONFIG_NOA1305=m
CONFIG_OPT3001=m
# CONFIG_PA12203001 is not set
CONFIG_SI1133=m
# CONFIG_SI1145 is not set
# CONFIG_STK3310 is not set
# CONFIG_ST_UVIS25 is not set
# CONFIG_TCS3414 is not set
# CONFIG_TCS3472 is not set
CONFIG_SENSORS_TSL2563=m
CONFIG_TSL2583=m
CONFIG_TSL2772=m
# CONFIG_TSL4531 is not set
# CONFIG_US5182D is not set
# CONFIG_VCNL4000 is not set
CONFIG_VCNL4035=m
# CONFIG_VEML6030 is not set
CONFIG_VEML6070=m
CONFIG_VL6180=m
CONFIG_ZOPT2201=m
# end of Light sensors

#
# Magnetometer sensors
#
# CONFIG_AK8974 is not set
CONFIG_AK8975=m
CONFIG_AK09911=m
# CONFIG_BMC150_MAGN_I2C is not set
CONFIG_MAG3110=m
# CONFIG_HID_SENSOR_MAGNETOMETER_3D is not set
# CONFIG_MMC35240 is not set
# CONFIG_IIO_ST_MAGN_3AXIS is not set
CONFIG_SENSORS_HMC5843=m
CONFIG_SENSORS_HMC5843_I2C=m
# CONFIG_SENSORS_RM3100_I2C is not set
# end of Magnetometer sensors

#
# Multiplexers
#
CONFIG_IIO_MUX=m
# end of Multiplexers

#
# Inclinometer sensors
#
CONFIG_HID_SENSOR_INCLINOMETER_3D=m
CONFIG_HID_SENSOR_DEVICE_ROTATION=m
# end of Inclinometer sensors

#
# Triggers - standalone
#
CONFIG_IIO_HRTIMER_TRIGGER=m
CONFIG_IIO_INTERRUPT_TRIGGER=m
CONFIG_IIO_TIGHTLOOP_TRIGGER=m
# CONFIG_IIO_SYSFS_TRIGGER is not set
# end of Triggers - standalone

#
# Linear and angular position sensors
#
# end of Linear and angular position sensors

#
# Digital potentiometers
#
CONFIG_AD5272=m
CONFIG_DS1803=m
CONFIG_MAX5432=m
# CONFIG_MCP4018 is not set
CONFIG_MCP4531=m
CONFIG_TPL0102=m
# end of Digital potentiometers

#
# Digital potentiostats
#
CONFIG_LMP91000=m
# end of Digital potentiostats

#
# Pressure sensors
#
# CONFIG_ABP060MG is not set
CONFIG_BMP280=m
CONFIG_BMP280_I2C=m
# CONFIG_DLHL60D is not set
CONFIG_DPS310=m
# CONFIG_HID_SENSOR_PRESS is not set
CONFIG_HP03=m
# CONFIG_ICP10100 is not set
CONFIG_MPL115=m
CONFIG_MPL115_I2C=m
# CONFIG_MPL3115 is not set
# CONFIG_MS5611 is not set
# CONFIG_MS5637 is not set
CONFIG_IIO_ST_PRESS=m
CONFIG_IIO_ST_PRESS_I2C=m
CONFIG_T5403=m
CONFIG_HP206C=m
CONFIG_ZPA2326=m
CONFIG_ZPA2326_I2C=m
# end of Pressure sensors

#
# Lightning sensors
#
# end of Lightning sensors

#
# Proximity and distance sensors
#
# CONFIG_ISL29501 is not set
CONFIG_LIDAR_LITE_V2=m
CONFIG_MB1232=m
# CONFIG_PING is not set
# CONFIG_RFD77402 is not set
# CONFIG_SRF04 is not set
CONFIG_SX9500=m
# CONFIG_SRF08 is not set
CONFIG_VL53L0X_I2C=m
# end of Proximity and distance sensors

#
# Resolver to digital converters
#
# end of Resolver to digital converters

#
# Temperature sensors
#
# CONFIG_HID_SENSOR_TEMP is not set
CONFIG_MLX90614=m
# CONFIG_MLX90632 is not set
# CONFIG_TMP006 is not set
CONFIG_TMP007=m
CONFIG_TSYS01=m
# CONFIG_TSYS02D is not set
# end of Temperature sensors

CONFIG_NTB=y
CONFIG_NTB_IDT=m
CONFIG_NTB_SWITCHTEC=y
CONFIG_NTB_PINGPONG=y
CONFIG_NTB_TOOL=y
CONFIG_NTB_PERF=y
CONFIG_NTB_TRANSPORT=m
CONFIG_VME_BUS=y

#
# VME Bridge Drivers
#
# CONFIG_VME_CA91CX42 is not set
# CONFIG_VME_TSI148 is not set
CONFIG_VME_FAKE=y

#
# VME Board Drivers
#
# CONFIG_VMIVME_7805 is not set

#
# VME Device Drivers
#
# CONFIG_VME_USER is not set
CONFIG_PWM=y
CONFIG_PWM_SYSFS=y
# CONFIG_PWM_DEBUG is not set
CONFIG_PWM_ATMEL_HLCDC_PWM=m
CONFIG_PWM_FSL_FTM=m
# CONFIG_PWM_LP3943 is not set
# CONFIG_PWM_LPSS_PCI is not set
# CONFIG_PWM_LPSS_PLATFORM is not set
# CONFIG_PWM_PCA9685 is not set
CONFIG_PWM_STMPE=y
CONFIG_PWM_TWL=y
CONFIG_PWM_TWL_LED=m

#
# IRQ chip support
#
CONFIG_IRQCHIP=y
CONFIG_AL_FIC=y
CONFIG_MADERA_IRQ=y
# end of IRQ chip support

CONFIG_IPACK_BUS=y
# CONFIG_BOARD_TPCI200 is not set
# CONFIG_SERIAL_IPOCTAL is not set
CONFIG_RESET_CONTROLLER=y
# CONFIG_RESET_BRCMSTB_RESCAL is not set
# CONFIG_RESET_INTEL_GW is not set
CONFIG_RESET_TI_SYSCON=m

#
# PHY Subsystem
#
CONFIG_GENERIC_PHY=y
CONFIG_GENERIC_PHY_MIPI_DPHY=y
CONFIG_BCM_KONA_USB2_PHY=y
# CONFIG_PHY_CADENCE_TORRENT is not set
CONFIG_PHY_CADENCE_DPHY=m
CONFIG_PHY_CADENCE_SIERRA=m
CONFIG_PHY_FSL_IMX8MQ_USB=y
CONFIG_PHY_MIXEL_MIPI_DPHY=m
CONFIG_PHY_PXA_28NM_HSIC=y
# CONFIG_PHY_PXA_28NM_USB2 is not set
# CONFIG_PHY_CPCAP_USB is not set
# CONFIG_PHY_MAPPHONE_MDM6600 is not set
CONFIG_PHY_OCELOT_SERDES=m
# CONFIG_PHY_INTEL_EMMC is not set
# end of PHY Subsystem

CONFIG_POWERCAP=y
# CONFIG_INTEL_RAPL is not set
# CONFIG_IDLE_INJECT is not set
CONFIG_MCB=m
# CONFIG_MCB_PCI is not set
CONFIG_MCB_LPC=m

#
# Performance monitor support
#
# end of Performance monitor support

CONFIG_RAS=y
# CONFIG_USB4 is not set

#
# Android
#
CONFIG_ANDROID=y
# CONFIG_ANDROID_BINDER_IPC is not set
# end of Android

CONFIG_DAX=y
CONFIG_DEV_DAX=m
CONFIG_NVMEM=y
CONFIG_NVMEM_SYSFS=y
CONFIG_RAVE_SP_EEPROM=m

#
# HW tracing support
#
# CONFIG_STM is not set
# CONFIG_INTEL_TH is not set
# end of HW tracing support

CONFIG_FPGA=m
CONFIG_ALTERA_PR_IP_CORE=m
# CONFIG_ALTERA_PR_IP_CORE_PLAT is not set
CONFIG_FPGA_MGR_ALTERA_CVP=m
CONFIG_FPGA_BRIDGE=m
CONFIG_ALTERA_FREEZE_BRIDGE=m
CONFIG_XILINX_PR_DECOUPLER=m
CONFIG_FPGA_REGION=m
CONFIG_OF_FPGA_REGION=m
# CONFIG_FPGA_DFL is not set
CONFIG_FSI=m
# CONFIG_FSI_NEW_DEV_NODE is not set
CONFIG_FSI_MASTER_GPIO=m
# CONFIG_FSI_MASTER_HUB is not set
# CONFIG_FSI_MASTER_ASPEED is not set
# CONFIG_FSI_SCOM is not set
CONFIG_FSI_SBEFIFO=m
CONFIG_FSI_OCC=m
CONFIG_TEE=m

#
# TEE drivers
#
# end of TEE drivers

CONFIG_MULTIPLEXER=y

#
# Multiplexer drivers
#
CONFIG_MUX_ADG792A=m
CONFIG_MUX_GPIO=y
CONFIG_MUX_MMIO=m
# end of Multiplexer drivers

CONFIG_PM_OPP=y
CONFIG_SIOX=m
# CONFIG_SIOX_BUS_GPIO is not set
# CONFIG_SLIMBUS is not set
CONFIG_INTERCONNECT=y
CONFIG_COUNTER=m
# CONFIG_FTM_QUADDEC is not set
# CONFIG_MOST is not set
# end of Device Drivers

#
# File systems
#
CONFIG_DCACHE_WORD_ACCESS=y
CONFIG_VALIDATE_FS_PARSER=y
CONFIG_FS_IOMAP=y
CONFIG_EXT2_FS=m
CONFIG_EXT2_FS_XATTR=y
CONFIG_EXT2_FS_POSIX_ACL=y
CONFIG_EXT2_FS_SECURITY=y
CONFIG_EXT3_FS=m
# CONFIG_EXT3_FS_POSIX_ACL is not set
# CONFIG_EXT3_FS_SECURITY is not set
CONFIG_EXT4_FS=y
# CONFIG_EXT4_FS_POSIX_ACL is not set
# CONFIG_EXT4_FS_SECURITY is not set
CONFIG_EXT4_DEBUG=y
CONFIG_JBD2=y
# CONFIG_JBD2_DEBUG is not set
CONFIG_FS_MBCACHE=y
# CONFIG_REISERFS_FS is not set
CONFIG_JFS_FS=y
# CONFIG_JFS_POSIX_ACL is not set
# CONFIG_JFS_SECURITY is not set
CONFIG_JFS_DEBUG=y
CONFIG_JFS_STATISTICS=y
CONFIG_XFS_FS=m
CONFIG_XFS_QUOTA=y
CONFIG_XFS_POSIX_ACL=y
CONFIG_XFS_RT=y
CONFIG_XFS_ONLINE_SCRUB=y
CONFIG_XFS_ONLINE_REPAIR=y
CONFIG_XFS_WARN=y
# CONFIG_XFS_DEBUG is not set
CONFIG_GFS2_FS=y
CONFIG_OCFS2_FS=m
# CONFIG_OCFS2_FS_O2CB is not set
CONFIG_OCFS2_FS_STATS=y
# CONFIG_OCFS2_DEBUG_MASKLOG is not set
CONFIG_OCFS2_DEBUG_FS=y
CONFIG_BTRFS_FS=m
# CONFIG_BTRFS_FS_POSIX_ACL is not set
# CONFIG_BTRFS_FS_CHECK_INTEGRITY is not set
# CONFIG_BTRFS_FS_RUN_SANITY_TESTS is not set
# CONFIG_BTRFS_DEBUG is not set
CONFIG_BTRFS_ASSERT=y
# CONFIG_BTRFS_FS_REF_VERIFY is not set
# CONFIG_NILFS2_FS is not set
# CONFIG_F2FS_FS is not set
CONFIG_FS_DAX=y
CONFIG_FS_POSIX_ACL=y
CONFIG_EXPORTFS=y
CONFIG_EXPORTFS_BLOCK_OPS=y
CONFIG_FILE_LOCKING=y
CONFIG_MANDATORY_FILE_LOCKING=y
# CONFIG_FS_ENCRYPTION is not set
CONFIG_FS_VERITY=y
CONFIG_FS_VERITY_DEBUG=y
CONFIG_FS_VERITY_BUILTIN_SIGNATURES=y
CONFIG_FSNOTIFY=y
# CONFIG_DNOTIFY is not set
CONFIG_INOTIFY_USER=y
CONFIG_FANOTIFY=y
CONFIG_FANOTIFY_ACCESS_PERMISSIONS=y
CONFIG_QUOTA=y
# CONFIG_QUOTA_NETLINK_INTERFACE is not set
CONFIG_PRINT_QUOTA_WARNING=y
# CONFIG_QUOTA_DEBUG is not set
CONFIG_QUOTA_TREE=m
CONFIG_QFMT_V1=y
CONFIG_QFMT_V2=m
CONFIG_QUOTACTL=y
CONFIG_AUTOFS4_FS=m
CONFIG_AUTOFS_FS=y
CONFIG_FUSE_FS=y
CONFIG_CUSE=y
CONFIG_VIRTIO_FS=m
CONFIG_OVERLAY_FS=m
# CONFIG_OVERLAY_FS_REDIRECT_DIR is not set
CONFIG_OVERLAY_FS_REDIRECT_ALWAYS_FOLLOW=y
CONFIG_OVERLAY_FS_INDEX=y
CONFIG_OVERLAY_FS_NFS_EXPORT=y
# CONFIG_OVERLAY_FS_METACOPY is not set

#
# Caches
#
# CONFIG_FSCACHE is not set
# end of Caches

#
# CD-ROM/DVD Filesystems
#
CONFIG_ISO9660_FS=y
CONFIG_JOLIET=y
# CONFIG_ZISOFS is not set
CONFIG_UDF_FS=m
# end of CD-ROM/DVD Filesystems

#
# DOS/FAT/EXFAT/NT Filesystems
#
CONFIG_FAT_FS=y
CONFIG_MSDOS_FS=y
CONFIG_VFAT_FS=y
CONFIG_FAT_DEFAULT_CODEPAGE=437
CONFIG_FAT_DEFAULT_IOCHARSET="iso8859-1"
CONFIG_FAT_DEFAULT_UTF8=y
# CONFIG_EXFAT_FS is not set
# CONFIG_NTFS_FS is not set
# end of DOS/FAT/EXFAT/NT Filesystems

#
# Pseudo filesystems
#
CONFIG_PROC_FS=y
CONFIG_PROC_KCORE=y
CONFIG_PROC_SYSCTL=y
CONFIG_PROC_PAGE_MONITOR=y
CONFIG_PROC_CHILDREN=y
CONFIG_PROC_PID_ARCH_STATUS=y
CONFIG_PROC_CPU_RESCTRL=y
CONFIG_KERNFS=y
CONFIG_SYSFS=y
CONFIG_TMPFS=y
CONFIG_TMPFS_POSIX_ACL=y
CONFIG_TMPFS_XATTR=y
# CONFIG_HUGETLBFS is not set
CONFIG_MEMFD_CREATE=y
CONFIG_CONFIGFS_FS=m
CONFIG_EFIVAR_FS=m
# end of Pseudo filesystems

CONFIG_MISC_FILESYSTEMS=y
CONFIG_ORANGEFS_FS=y
# CONFIG_ADFS_FS is not set
CONFIG_AFFS_FS=m
CONFIG_ECRYPT_FS=m
CONFIG_ECRYPT_FS_MESSAGING=y
CONFIG_HFS_FS=m
CONFIG_HFSPLUS_FS=y
# CONFIG_BEFS_FS is not set
# CONFIG_BFS_FS is not set
# CONFIG_EFS_FS is not set
CONFIG_JFFS2_FS=m
CONFIG_JFFS2_FS_DEBUG=0
CONFIG_JFFS2_FS_WRITEBUFFER=y
# CONFIG_JFFS2_FS_WBUF_VERIFY is not set
CONFIG_JFFS2_SUMMARY=y
# CONFIG_JFFS2_FS_XATTR is not set
# CONFIG_JFFS2_COMPRESSION_OPTIONS is not set
CONFIG_JFFS2_ZLIB=y
CONFIG_JFFS2_RTIME=y
CONFIG_UBIFS_FS=m
CONFIG_UBIFS_FS_ADVANCED_COMPR=y
CONFIG_UBIFS_FS_LZO=y
# CONFIG_UBIFS_FS_ZLIB is not set
CONFIG_UBIFS_FS_ZSTD=y
CONFIG_UBIFS_ATIME_SUPPORT=y
# CONFIG_UBIFS_FS_XATTR is not set
# CONFIG_UBIFS_FS_AUTHENTICATION is not set
CONFIG_CRAMFS=m
CONFIG_CRAMFS_BLOCKDEV=y
CONFIG_CRAMFS_MTD=y
CONFIG_SQUASHFS=m
# CONFIG_SQUASHFS_FILE_CACHE is not set
CONFIG_SQUASHFS_FILE_DIRECT=y
# CONFIG_SQUASHFS_DECOMP_SINGLE is not set
CONFIG_SQUASHFS_DECOMP_MULTI=y
# CONFIG_SQUASHFS_DECOMP_MULTI_PERCPU is not set
CONFIG_SQUASHFS_XATTR=y
# CONFIG_SQUASHFS_ZLIB is not set
CONFIG_SQUASHFS_LZ4=y
CONFIG_SQUASHFS_LZO=y
CONFIG_SQUASHFS_XZ=y
CONFIG_SQUASHFS_ZSTD=y
CONFIG_SQUASHFS_4K_DEVBLK_SIZE=y
# CONFIG_SQUASHFS_EMBEDDED is not set
CONFIG_SQUASHFS_FRAGMENT_CACHE_SIZE=3
CONFIG_VXFS_FS=m
CONFIG_MINIX_FS=m
CONFIG_OMFS_FS=y
CONFIG_HPFS_FS=y
# CONFIG_QNX4FS_FS is not set
CONFIG_QNX6FS_FS=m
CONFIG_QNX6FS_DEBUG=y
CONFIG_ROMFS_FS=y
CONFIG_ROMFS_BACKED_BY_BLOCK=y
CONFIG_ROMFS_ON_BLOCK=y
CONFIG_PSTORE=y
CONFIG_PSTORE_DEFLATE_COMPRESS=y
# CONFIG_PSTORE_LZO_COMPRESS is not set
# CONFIG_PSTORE_LZ4_COMPRESS is not set
# CONFIG_PSTORE_LZ4HC_COMPRESS is not set
# CONFIG_PSTORE_842_COMPRESS is not set
# CONFIG_PSTORE_ZSTD_COMPRESS is not set
CONFIG_PSTORE_COMPRESS=y
CONFIG_PSTORE_DEFLATE_COMPRESS_DEFAULT=y
CONFIG_PSTORE_COMPRESS_DEFAULT="deflate"
CONFIG_PSTORE_CONSOLE=y
CONFIG_PSTORE_PMSG=y
CONFIG_PSTORE_RAM=m
CONFIG_SYSV_FS=y
CONFIG_UFS_FS=m
# CONFIG_UFS_FS_WRITE is not set
# CONFIG_UFS_DEBUG is not set
CONFIG_EROFS_FS=y
# CONFIG_EROFS_FS_DEBUG is not set
# CONFIG_EROFS_FS_XATTR is not set
CONFIG_EROFS_FS_ZIP=y
CONFIG_EROFS_FS_CLUSTER_PAGE_LIMIT=1
# CONFIG_VBOXSF_FS is not set
# CONFIG_NETWORK_FILESYSTEMS is not set
CONFIG_NLS=y
CONFIG_NLS_DEFAULT="iso8859-1"
CONFIG_NLS_CODEPAGE_437=m
CONFIG_NLS_CODEPAGE_737=m
CONFIG_NLS_CODEPAGE_775=m
CONFIG_NLS_CODEPAGE_850=m
# CONFIG_NLS_CODEPAGE_852 is not set
CONFIG_NLS_CODEPAGE_855=y
CONFIG_NLS_CODEPAGE_857=y
CONFIG_NLS_CODEPAGE_860=m
CONFIG_NLS_CODEPAGE_861=y
CONFIG_NLS_CODEPAGE_862=y
# CONFIG_NLS_CODEPAGE_863 is not set
CONFIG_NLS_CODEPAGE_864=y
CONFIG_NLS_CODEPAGE_865=y
# CONFIG_NLS_CODEPAGE_866 is not set
# CONFIG_NLS_CODEPAGE_869 is not set
CONFIG_NLS_CODEPAGE_936=m
# CONFIG_NLS_CODEPAGE_950 is not set
CONFIG_NLS_CODEPAGE_932=m
# CONFIG_NLS_CODEPAGE_949 is not set
CONFIG_NLS_CODEPAGE_874=y
CONFIG_NLS_ISO8859_8=m
# CONFIG_NLS_CODEPAGE_1250 is not set
CONFIG_NLS_CODEPAGE_1251=m
CONFIG_NLS_ASCII=y
CONFIG_NLS_ISO8859_1=m
CONFIG_NLS_ISO8859_2=y
CONFIG_NLS_ISO8859_3=y
# CONFIG_NLS_ISO8859_4 is not set
CONFIG_NLS_ISO8859_5=y
# CONFIG_NLS_ISO8859_6 is not set
# CONFIG_NLS_ISO8859_7 is not set
# CONFIG_NLS_ISO8859_9 is not set
# CONFIG_NLS_ISO8859_13 is not set
CONFIG_NLS_ISO8859_14=y
# CONFIG_NLS_ISO8859_15 is not set
# CONFIG_NLS_KOI8_R is not set
# CONFIG_NLS_KOI8_U is not set
CONFIG_NLS_MAC_ROMAN=y
# CONFIG_NLS_MAC_CELTIC is not set
CONFIG_NLS_MAC_CENTEURO=y
# CONFIG_NLS_MAC_CROATIAN is not set
CONFIG_NLS_MAC_CYRILLIC=y
CONFIG_NLS_MAC_GAELIC=m
# CONFIG_NLS_MAC_GREEK is not set
CONFIG_NLS_MAC_ICELAND=y
CONFIG_NLS_MAC_INUIT=y
CONFIG_NLS_MAC_ROMANIAN=m
CONFIG_NLS_MAC_TURKISH=y
CONFIG_NLS_UTF8=y
# CONFIG_DLM is not set
# CONFIG_UNICODE is not set
CONFIG_IO_WQ=y
# end of File systems

#
# Security options
#
CONFIG_KEYS=y
# CONFIG_KEYS_REQUEST_CACHE is not set
CONFIG_PERSISTENT_KEYRINGS=y
CONFIG_BIG_KEYS=y
CONFIG_ENCRYPTED_KEYS=m
CONFIG_KEY_DH_OPERATIONS=y
# CONFIG_SECURITY_DMESG_RESTRICT is not set
CONFIG_SECURITY=y
CONFIG_SECURITYFS=y
CONFIG_SECURITY_NETWORK=y
CONFIG_SECURITY_NETWORK_XFRM=y
CONFIG_SECURITY_PATH=y
CONFIG_HAVE_HARDENED_USERCOPY_ALLOCATOR=y
CONFIG_HARDENED_USERCOPY=y
# CONFIG_HARDENED_USERCOPY_FALLBACK is not set
CONFIG_HARDENED_USERCOPY_PAGESPAN=y
# CONFIG_FORTIFY_SOURCE is not set
# CONFIG_STATIC_USERMODEHELPER is not set
# CONFIG_SECURITY_SELINUX is not set
# CONFIG_SECURITY_SMACK is not set
# CONFIG_SECURITY_TOMOYO is not set
# CONFIG_SECURITY_APPARMOR is not set
# CONFIG_SECURITY_LOADPIN is not set
CONFIG_SECURITY_YAMA=y
CONFIG_SECURITY_SAFESETID=y
# CONFIG_SECURITY_LOCKDOWN_LSM is not set
# CONFIG_INTEGRITY is not set
# CONFIG_IMA_SECURE_AND_OR_TRUSTED_BOOT is not set
CONFIG_DEFAULT_SECURITY_DAC=y
CONFIG_LSM="lockdown,yama,loadpin,safesetid,integrity,tomoyo"

#
# Kernel hardening options
#

#
# Memory initialization
#
CONFIG_INIT_STACK_NONE=y
CONFIG_INIT_ON_ALLOC_DEFAULT_ON=y
CONFIG_INIT_ON_FREE_DEFAULT_ON=y
# end of Memory initialization
# end of Kernel hardening options
# end of Security options

CONFIG_XOR_BLOCKS=y
CONFIG_ASYNC_CORE=y
CONFIG_ASYNC_MEMCPY=y
CONFIG_ASYNC_XOR=y
CONFIG_ASYNC_PQ=y
CONFIG_ASYNC_RAID6_RECOV=y
CONFIG_CRYPTO=y

#
# Crypto core or helper
#
CONFIG_CRYPTO_ALGAPI=y
CONFIG_CRYPTO_ALGAPI2=y
CONFIG_CRYPTO_AEAD=y
CONFIG_CRYPTO_AEAD2=y
CONFIG_CRYPTO_SKCIPHER=y
CONFIG_CRYPTO_SKCIPHER2=y
CONFIG_CRYPTO_HASH=y
CONFIG_CRYPTO_HASH2=y
CONFIG_CRYPTO_RNG=y
CONFIG_CRYPTO_RNG2=y
CONFIG_CRYPTO_RNG_DEFAULT=y
CONFIG_CRYPTO_AKCIPHER2=y
CONFIG_CRYPTO_AKCIPHER=y
CONFIG_CRYPTO_KPP2=y
CONFIG_CRYPTO_KPP=y
CONFIG_CRYPTO_ACOMP2=y
CONFIG_CRYPTO_MANAGER=y
CONFIG_CRYPTO_MANAGER2=y
# CONFIG_CRYPTO_USER is not set
CONFIG_CRYPTO_MANAGER_DISABLE_TESTS=y
CONFIG_CRYPTO_GF128MUL=y
CONFIG_CRYPTO_NULL=y
CONFIG_CRYPTO_NULL2=y
CONFIG_CRYPTO_PCRYPT=m
CONFIG_CRYPTO_CRYPTD=y
CONFIG_CRYPTO_AUTHENC=y
# CONFIG_CRYPTO_TEST is not set
CONFIG_CRYPTO_SIMD=y

#
# Public-key cryptography
#
CONFIG_CRYPTO_RSA=y
CONFIG_CRYPTO_DH=y
CONFIG_CRYPTO_ECC=y
CONFIG_CRYPTO_ECDH=y
CONFIG_CRYPTO_ECRDSA=y
# CONFIG_CRYPTO_CURVE25519 is not set

#
# Authenticated Encryption with Associated Data
#
CONFIG_CRYPTO_CCM=m
CONFIG_CRYPTO_GCM=y
CONFIG_CRYPTO_CHACHA20POLY1305=y
CONFIG_CRYPTO_AEGIS128=m
CONFIG_CRYPTO_SEQIV=y
CONFIG_CRYPTO_ECHAINIV=y

#
# Block modes
#
CONFIG_CRYPTO_CBC=y
CONFIG_CRYPTO_CFB=y
CONFIG_CRYPTO_CTR=y
CONFIG_CRYPTO_CTS=m
CONFIG_CRYPTO_ECB=m
# CONFIG_CRYPTO_LRW is not set
CONFIG_CRYPTO_OFB=y
CONFIG_CRYPTO_PCBC=y
CONFIG_CRYPTO_XTS=m
CONFIG_CRYPTO_KEYWRAP=m
CONFIG_CRYPTO_NHPOLY1305=m
CONFIG_CRYPTO_ADIANTUM=m
# CONFIG_CRYPTO_ESSIV is not set

#
# Hash modes
#
CONFIG_CRYPTO_CMAC=y
CONFIG_CRYPTO_HMAC=y
CONFIG_CRYPTO_XCBC=m
CONFIG_CRYPTO_VMAC=y

#
# Digest
#
CONFIG_CRYPTO_CRC32C=y
CONFIG_CRYPTO_CRC32C_INTEL=m
CONFIG_CRYPTO_CRC32=y
# CONFIG_CRYPTO_CRC32_PCLMUL is not set
CONFIG_CRYPTO_XXHASH=y
CONFIG_CRYPTO_BLAKE2B=m
# CONFIG_CRYPTO_BLAKE2S is not set
CONFIG_CRYPTO_CRCT10DIF=y
CONFIG_CRYPTO_GHASH=y
CONFIG_CRYPTO_POLY1305=y
# CONFIG_CRYPTO_MD4 is not set
CONFIG_CRYPTO_MD5=y
# CONFIG_CRYPTO_MICHAEL_MIC is not set
CONFIG_CRYPTO_RMD128=y
CONFIG_CRYPTO_RMD160=m
# CONFIG_CRYPTO_RMD256 is not set
CONFIG_CRYPTO_RMD320=m
CONFIG_CRYPTO_SHA1=y
CONFIG_CRYPTO_SHA256=y
CONFIG_CRYPTO_SHA512=y
CONFIG_CRYPTO_SHA3=y
CONFIG_CRYPTO_SM3=m
CONFIG_CRYPTO_STREEBOG=y
# CONFIG_CRYPTO_TGR192 is not set
CONFIG_CRYPTO_WP512=y

#
# Ciphers
#
CONFIG_CRYPTO_AES=y
# CONFIG_CRYPTO_AES_TI is not set
CONFIG_CRYPTO_AES_NI_INTEL=y
CONFIG_CRYPTO_ANUBIS=y
CONFIG_CRYPTO_ARC4=y
# CONFIG_CRYPTO_BLOWFISH is not set
CONFIG_CRYPTO_CAMELLIA=y
CONFIG_CRYPTO_CAST_COMMON=y
CONFIG_CRYPTO_CAST5=y
CONFIG_CRYPTO_CAST6=y
CONFIG_CRYPTO_DES=y
CONFIG_CRYPTO_FCRYPT=m
CONFIG_CRYPTO_KHAZAD=m
CONFIG_CRYPTO_SALSA20=m
CONFIG_CRYPTO_CHACHA20=y
CONFIG_CRYPTO_SEED=y
CONFIG_CRYPTO_SERPENT=m
# CONFIG_CRYPTO_SERPENT_SSE2_586 is not set
CONFIG_CRYPTO_SM4=y
CONFIG_CRYPTO_TEA=y
CONFIG_CRYPTO_TWOFISH=y
CONFIG_CRYPTO_TWOFISH_COMMON=y
CONFIG_CRYPTO_TWOFISH_586=y

#
# Compression
#
CONFIG_CRYPTO_DEFLATE=y
CONFIG_CRYPTO_LZO=y
CONFIG_CRYPTO_842=y
# CONFIG_CRYPTO_LZ4 is not set
CONFIG_CRYPTO_LZ4HC=y
CONFIG_CRYPTO_ZSTD=y

#
# Random Number Generation
#
# CONFIG_CRYPTO_ANSI_CPRNG is not set
CONFIG_CRYPTO_DRBG_MENU=y
CONFIG_CRYPTO_DRBG_HMAC=y
# CONFIG_CRYPTO_DRBG_HASH is not set
CONFIG_CRYPTO_DRBG_CTR=y
CONFIG_CRYPTO_DRBG=y
CONFIG_CRYPTO_JITTERENTROPY=y
CONFIG_CRYPTO_USER_API=y
CONFIG_CRYPTO_USER_API_HASH=m
# CONFIG_CRYPTO_USER_API_SKCIPHER is not set
# CONFIG_CRYPTO_USER_API_RNG is not set
CONFIG_CRYPTO_USER_API_AEAD=y
CONFIG_CRYPTO_HASH_INFO=y

#
# Crypto library routines
#
CONFIG_CRYPTO_LIB_AES=y
CONFIG_CRYPTO_LIB_ARC4=y
# CONFIG_CRYPTO_LIB_BLAKE2S is not set
CONFIG_CRYPTO_LIB_CHACHA_GENERIC=y
# CONFIG_CRYPTO_LIB_CHACHA is not set
# CONFIG_CRYPTO_LIB_CURVE25519 is not set
CONFIG_CRYPTO_LIB_DES=y
CONFIG_CRYPTO_LIB_POLY1305_RSIZE=1
CONFIG_CRYPTO_LIB_POLY1305_GENERIC=y
# CONFIG_CRYPTO_LIB_POLY1305 is not set
# CONFIG_CRYPTO_LIB_CHACHA20POLY1305 is not set
CONFIG_CRYPTO_LIB_SHA256=y
# CONFIG_CRYPTO_HW is not set
CONFIG_ASYMMETRIC_KEY_TYPE=y
CONFIG_ASYMMETRIC_PUBLIC_KEY_SUBTYPE=y
CONFIG_X509_CERTIFICATE_PARSER=y
# CONFIG_PKCS8_PRIVATE_KEY_PARSER is not set
CONFIG_PKCS7_MESSAGE_PARSER=y
CONFIG_PKCS7_TEST_KEY=y
# CONFIG_SIGNED_PE_FILE_VERIFICATION is not set

#
# Certificates for signature checking
#
CONFIG_SYSTEM_TRUSTED_KEYRING=y
CONFIG_SYSTEM_TRUSTED_KEYS=""
CONFIG_SYSTEM_EXTRA_CERTIFICATE=y
CONFIG_SYSTEM_EXTRA_CERTIFICATE_SIZE=4096
CONFIG_SECONDARY_TRUSTED_KEYRING=y
# CONFIG_SYSTEM_BLACKLIST_KEYRING is not set
# end of Certificates for signature checking

CONFIG_BINARY_PRINTF=y

#
# Library routines
#
CONFIG_RAID6_PQ=y
CONFIG_RAID6_PQ_BENCHMARK=y
CONFIG_PACKING=y
CONFIG_BITREVERSE=y
CONFIG_GENERIC_STRNCPY_FROM_USER=y
CONFIG_GENERIC_STRNLEN_USER=y
CONFIG_GENERIC_NET_UTILS=y
CONFIG_GENERIC_FIND_FIRST_BIT=y
CONFIG_CORDIC=m
CONFIG_PRIME_NUMBERS=m
CONFIG_RATIONAL=y
CONFIG_GENERIC_PCI_IOMAP=y
CONFIG_GENERIC_IOMAP=y
CONFIG_ARCH_HAS_FAST_MULTIPLIER=y
CONFIG_CRC_CCITT=y
CONFIG_CRC16=y
CONFIG_CRC_T10DIF=y
CONFIG_CRC_ITU_T=y
CONFIG_CRC32=y
# CONFIG_CRC32_SELFTEST is not set
# CONFIG_CRC32_SLICEBY8 is not set
# CONFIG_CRC32_SLICEBY4 is not set
CONFIG_CRC32_SARWATE=y
# CONFIG_CRC32_BIT is not set
# CONFIG_CRC64 is not set
CONFIG_CRC4=m
CONFIG_CRC7=y
CONFIG_LIBCRC32C=y
CONFIG_CRC8=m
CONFIG_XXHASH=y
CONFIG_AUDIT_GENERIC=y
CONFIG_RANDOM32_SELFTEST=y
CONFIG_842_COMPRESS=y
CONFIG_842_DECOMPRESS=y
CONFIG_ZLIB_INFLATE=y
CONFIG_ZLIB_DEFLATE=y
CONFIG_LZO_COMPRESS=y
CONFIG_LZO_DECOMPRESS=y
CONFIG_LZ4HC_COMPRESS=y
CONFIG_LZ4_DECOMPRESS=y
CONFIG_ZSTD_COMPRESS=y
CONFIG_ZSTD_DECOMPRESS=y
CONFIG_XZ_DEC=y
CONFIG_XZ_DEC_X86=y
CONFIG_XZ_DEC_POWERPC=y
# CONFIG_XZ_DEC_IA64 is not set
# CONFIG_XZ_DEC_ARM is not set
CONFIG_XZ_DEC_ARMTHUMB=y
CONFIG_XZ_DEC_SPARC=y
CONFIG_XZ_DEC_BCJ=y
CONFIG_XZ_DEC_TEST=m
CONFIG_DECOMPRESS_GZIP=y
CONFIG_DECOMPRESS_BZIP2=y
CONFIG_DECOMPRESS_LZMA=y
CONFIG_DECOMPRESS_XZ=y
CONFIG_DECOMPRESS_LZO=y
CONFIG_DECOMPRESS_LZ4=y
CONFIG_GENERIC_ALLOCATOR=y
CONFIG_REED_SOLOMON=m
CONFIG_REED_SOLOMON_ENC8=y
CONFIG_REED_SOLOMON_DEC8=y
CONFIG_BCH=m
CONFIG_BCH_CONST_PARAMS=y
CONFIG_INTERVAL_TREE=y
CONFIG_XARRAY_MULTI=y
CONFIG_ASSOCIATIVE_ARRAY=y
CONFIG_HAS_IOMEM=y
CONFIG_HAS_IOPORT_MAP=y
CONFIG_HAS_DMA=y
CONFIG_NEED_SG_DMA_LENGTH=y
# CONFIG_DMA_API_DEBUG is not set
CONFIG_SGL_ALLOC=y
CONFIG_CHECK_SIGNATURE=y
CONFIG_CPUMASK_OFFSTACK=y
CONFIG_CPU_RMAP=y
CONFIG_DQL=y
CONFIG_GLOB=y
# CONFIG_GLOB_SELFTEST is not set
CONFIG_NLATTR=y
CONFIG_LRU_CACHE=m
CONFIG_CLZ_TAB=y
CONFIG_IRQ_POLL=y
CONFIG_MPILIB=y
CONFIG_DIMLIB=y
CONFIG_LIBFDT=y
CONFIG_OID_REGISTRY=y
CONFIG_UCS2_STRING=y
CONFIG_HAVE_GENERIC_VDSO=y
CONFIG_GENERIC_GETTIMEOFDAY=y
CONFIG_GENERIC_VDSO_32=y
CONFIG_GENERIC_VDSO_TIME_NS=y
CONFIG_FONT_SUPPORT=y
CONFIG_FONT_8x16=y
CONFIG_FONT_AUTOSELECT=y
CONFIG_SG_POOL=y
CONFIG_ARCH_STACKWALK=y
CONFIG_STACKDEPOT=y
CONFIG_SBITMAP=y
# CONFIG_STRING_SELFTEST is not set
# end of Library routines

#
# Kernel hacking
#

#
# printk and dmesg options
#
CONFIG_PRINTK_TIME=y
# CONFIG_PRINTK_CALLER is not set
CONFIG_CONSOLE_LOGLEVEL_DEFAULT=7
CONFIG_CONSOLE_LOGLEVEL_QUIET=4
CONFIG_MESSAGE_LOGLEVEL_DEFAULT=4
CONFIG_BOOT_PRINTK_DELAY=y
# CONFIG_DYNAMIC_DEBUG is not set
CONFIG_SYMBOLIC_ERRNAME=y
CONFIG_DEBUG_BUGVERBOSE=y
# end of printk and dmesg options

#
# Compile-time checks and compiler options
#
CONFIG_DEBUG_INFO=y
CONFIG_DEBUG_INFO_REDUCED=y
# CONFIG_DEBUG_INFO_SPLIT is not set
# CONFIG_DEBUG_INFO_DWARF4 is not set
# CONFIG_GDB_SCRIPTS is not set
# CONFIG_ENABLE_MUST_CHECK is not set
CONFIG_FRAME_WARN=2048
# CONFIG_STRIP_ASM_SYMS is not set
CONFIG_READABLE_ASM=y
CONFIG_HEADERS_INSTALL=y
# CONFIG_DEBUG_SECTION_MISMATCH is not set
# CONFIG_SECTION_MISMATCH_WARN_ONLY is not set
CONFIG_FRAME_POINTER=y
# CONFIG_DEBUG_FORCE_WEAK_PER_CPU is not set
# end of Compile-time checks and compiler options

#
# Generic Kernel Debugging Instruments
#
CONFIG_MAGIC_SYSRQ=y
CONFIG_MAGIC_SYSRQ_DEFAULT_ENABLE=0x1
CONFIG_MAGIC_SYSRQ_SERIAL=y
CONFIG_MAGIC_SYSRQ_SERIAL_SEQUENCE=""
CONFIG_DEBUG_FS=y
CONFIG_HAVE_ARCH_KGDB=y
# CONFIG_KGDB is not set
CONFIG_ARCH_HAS_UBSAN_SANITIZE_ALL=y
CONFIG_UBSAN=y
# CONFIG_UBSAN_TRAP is not set
CONFIG_UBSAN_BOUNDS=y
CONFIG_UBSAN_MISC=y
# CONFIG_UBSAN_SANITIZE_ALL is not set
CONFIG_UBSAN_NO_ALIGNMENT=y
# CONFIG_TEST_UBSAN is not set
# end of Generic Kernel Debugging Instruments

CONFIG_DEBUG_KERNEL=y
CONFIG_DEBUG_MISC=y

#
# Memory Debugging
#
# CONFIG_PAGE_EXTENSION is not set
# CONFIG_DEBUG_PAGEALLOC is not set
# CONFIG_PAGE_OWNER is not set
# CONFIG_PAGE_POISONING is not set
# CONFIG_DEBUG_PAGE_REF is not set
CONFIG_DEBUG_RODATA_TEST=y
CONFIG_GENERIC_PTDUMP=y
# CONFIG_PTDUMP_DEBUGFS is not set
CONFIG_DEBUG_OBJECTS=y
# CONFIG_DEBUG_OBJECTS_SELFTEST is not set
CONFIG_DEBUG_OBJECTS_FREE=y
# CONFIG_DEBUG_OBJECTS_TIMERS is not set
# CONFIG_DEBUG_OBJECTS_WORK is not set
# CONFIG_DEBUG_OBJECTS_RCU_HEAD is not set
CONFIG_DEBUG_OBJECTS_PERCPU_COUNTER=y
CONFIG_DEBUG_OBJECTS_ENABLE_DEFAULT=1
# CONFIG_DEBUG_SLAB is not set
CONFIG_HAVE_DEBUG_KMEMLEAK=y
# CONFIG_DEBUG_KMEMLEAK is not set
CONFIG_DEBUG_STACK_USAGE=y
CONFIG_SCHED_STACK_END_CHECK=y
CONFIG_DEBUG_VM=y
# CONFIG_DEBUG_VM_VMACACHE is not set
# CONFIG_DEBUG_VM_RB is not set
# CONFIG_DEBUG_VM_PGFLAGS is not set
CONFIG_ARCH_HAS_DEBUG_VIRTUAL=y
# CONFIG_DEBUG_VIRTUAL is not set
# CONFIG_DEBUG_MEMORY_INIT is not set
CONFIG_DEBUG_PER_CPU_MAPS=y
CONFIG_DEBUG_HIGHMEM=y
CONFIG_HAVE_DEBUG_STACKOVERFLOW=y
# CONFIG_DEBUG_STACKOVERFLOW is not set
CONFIG_CC_HAS_KASAN_GENERIC=y
CONFIG_KASAN_STACK=1
# end of Memory Debugging

CONFIG_DEBUG_SHIRQ=y

#
# Debug Oops, Lockups and Hangs
#
CONFIG_PANIC_ON_OOPS=y
CONFIG_PANIC_ON_OOPS_VALUE=1
CONFIG_PANIC_TIMEOUT=0
CONFIG_LOCKUP_DETECTOR=y
CONFIG_SOFTLOCKUP_DETECTOR=y
# CONFIG_BOOTPARAM_SOFTLOCKUP_PANIC is not set
CONFIG_BOOTPARAM_SOFTLOCKUP_PANIC_VALUE=0
# CONFIG_HARDLOCKUP_DETECTOR is not set
# CONFIG_DETECT_HUNG_TASK is not set
# CONFIG_WQ_WATCHDOG is not set
# CONFIG_TEST_LOCKUP is not set
# end of Debug Oops, Lockups and Hangs

#
# Scheduler Debugging
#
CONFIG_SCHED_DEBUG=y
CONFIG_SCHED_INFO=y
CONFIG_SCHEDSTATS=y
# end of Scheduler Debugging

CONFIG_DEBUG_TIMEKEEPING=y

#
# Lock Debugging (spinlocks, mutexes, etc...)
#
CONFIG_LOCK_DEBUGGING_SUPPORT=y
CONFIG_PROVE_LOCKING=y
# CONFIG_PROVE_RAW_LOCK_NESTING is not set
# CONFIG_LOCK_STAT is not set
CONFIG_DEBUG_RT_MUTEXES=y
CONFIG_DEBUG_SPINLOCK=y
CONFIG_DEBUG_MUTEXES=y
CONFIG_DEBUG_WW_MUTEX_SLOWPATH=y
CONFIG_DEBUG_RWSEMS=y
CONFIG_DEBUG_LOCK_ALLOC=y
CONFIG_LOCKDEP=y
# CONFIG_DEBUG_LOCKDEP is not set
CONFIG_DEBUG_ATOMIC_SLEEP=y
# CONFIG_DEBUG_LOCKING_API_SELFTESTS is not set
CONFIG_LOCK_TORTURE_TEST=y
CONFIG_WW_MUTEX_SELFTEST=m
# end of Lock Debugging (spinlocks, mutexes, etc...)

CONFIG_TRACE_IRQFLAGS=y
CONFIG_STACKTRACE=y
# CONFIG_WARN_ALL_UNSEEDED_RANDOM is not set
# CONFIG_DEBUG_KOBJECT is not set

#
# Debug kernel data structures
#
CONFIG_DEBUG_LIST=y
# CONFIG_DEBUG_PLIST is not set
# CONFIG_DEBUG_SG is not set
# CONFIG_DEBUG_NOTIFIERS is not set
CONFIG_BUG_ON_DATA_CORRUPTION=y
# end of Debug kernel data structures

CONFIG_DEBUG_CREDENTIALS=y

#
# RCU Debugging
#
CONFIG_PROVE_RCU=y
CONFIG_TORTURE_TEST=y
CONFIG_RCU_PERF_TEST=y
# CONFIG_RCU_TORTURE_TEST is not set
CONFIG_RCU_CPU_STALL_TIMEOUT=21
CONFIG_RCU_TRACE=y
# CONFIG_RCU_EQS_DEBUG is not set
# end of RCU Debugging

CONFIG_DEBUG_WQ_FORCE_RR_CPU=y
# CONFIG_DEBUG_BLOCK_EXT_DEVT is not set
# CONFIG_CPU_HOTPLUG_STATE_CONTROL is not set
CONFIG_LATENCYTOP=y
CONFIG_USER_STACKTRACE_SUPPORT=y
CONFIG_NOP_TRACER=y
CONFIG_HAVE_FUNCTION_TRACER=y
CONFIG_HAVE_FUNCTION_GRAPH_TRACER=y
CONFIG_HAVE_DYNAMIC_FTRACE=y
CONFIG_HAVE_DYNAMIC_FTRACE_WITH_REGS=y
CONFIG_HAVE_DYNAMIC_FTRACE_WITH_DIRECT_CALLS=y
CONFIG_HAVE_FTRACE_MCOUNT_RECORD=y
CONFIG_HAVE_SYSCALL_TRACEPOINTS=y
CONFIG_HAVE_C_RECORDMCOUNT=y
CONFIG_TRACER_MAX_TRACE=y
CONFIG_TRACE_CLOCK=y
CONFIG_RING_BUFFER=y
CONFIG_EVENT_TRACING=y
CONFIG_CONTEXT_SWITCH_TRACER=y
CONFIG_RING_BUFFER_ALLOW_SWAP=y
CONFIG_PREEMPTIRQ_TRACEPOINTS=y
CONFIG_TRACING=y
CONFIG_GENERIC_TRACER=y
CONFIG_TRACING_SUPPORT=y
CONFIG_FTRACE=y
# CONFIG_BOOTTIME_TRACING is not set
# CONFIG_FUNCTION_TRACER is not set
# CONFIG_STACK_TRACER is not set
CONFIG_PREEMPTIRQ_EVENTS=y
# CONFIG_IRQSOFF_TRACER is not set
# CONFIG_SCHED_TRACER is not set
CONFIG_HWLAT_TRACER=y
# CONFIG_MMIOTRACE is not set
# CONFIG_FTRACE_SYSCALLS is not set
CONFIG_TRACER_SNAPSHOT=y
CONFIG_TRACER_SNAPSHOT_PER_CPU_SWAP=y
CONFIG_BRANCH_PROFILE_NONE=y
# CONFIG_PROFILE_ANNOTATED_BRANCHES is not set
# CONFIG_PROFILE_ALL_BRANCHES is not set
CONFIG_BLK_DEV_IO_TRACE=y
# CONFIG_UPROBE_EVENTS is not set
CONFIG_DYNAMIC_EVENTS=y
CONFIG_TRACING_MAP=y
CONFIG_HIST_TRIGGERS=y
# CONFIG_TRACE_EVENT_INJECT is not set
CONFIG_TRACEPOINT_BENCHMARK=y
CONFIG_RING_BUFFER_BENCHMARK=y
CONFIG_TRACE_EVAL_MAP_FILE=y
# CONFIG_FTRACE_STARTUP_TEST is not set
# CONFIG_RING_BUFFER_STARTUP_TEST is not set
CONFIG_PREEMPTIRQ_DELAY_TEST=m
# CONFIG_SYNTH_EVENT_GEN_TEST is not set
CONFIG_PROVIDE_OHCI1394_DMA_INIT=y
# CONFIG_SAMPLES is not set
CONFIG_ARCH_HAS_DEVMEM_IS_ALLOWED=y
# CONFIG_STRICT_DEVMEM is not set

#
# x86 Debugging
#
CONFIG_TRACE_IRQFLAGS_SUPPORT=y
CONFIG_EARLY_PRINTK_USB=y
CONFIG_X86_VERBOSE_BOOTUP=y
CONFIG_EARLY_PRINTK=y
CONFIG_EARLY_PRINTK_DBGP=y
CONFIG_EARLY_PRINTK_USB_XDBC=y
# CONFIG_EFI_PGT_DUMP is not set
# CONFIG_DEBUG_WX is not set
CONFIG_DOUBLEFAULT=y
# CONFIG_DEBUG_TLBFLUSH is not set
CONFIG_HAVE_MMIOTRACE_SUPPORT=y
# CONFIG_X86_DECODER_SELFTEST is not set
CONFIG_IO_DELAY_0X80=y
# CONFIG_IO_DELAY_0XED is not set
# CONFIG_IO_DELAY_UDELAY is not set
# CONFIG_IO_DELAY_NONE is not set
# CONFIG_DEBUG_BOOT_PARAMS is not set
# CONFIG_CPA_DEBUG is not set
# CONFIG_DEBUG_ENTRY is not set
# CONFIG_DEBUG_NMI_SELFTEST is not set
CONFIG_X86_DEBUG_FPU=y
# CONFIG_PUNIT_ATOM_DEBUG is not set
CONFIG_UNWINDER_FRAME_POINTER=y
# end of x86 Debugging

#
# Kernel Testing and Coverage
#
# CONFIG_KUNIT is not set
CONFIG_NOTIFIER_ERROR_INJECTION=m
CONFIG_PM_NOTIFIER_ERROR_INJECT=m
# CONFIG_OF_RECONFIG_NOTIFIER_ERROR_INJECT is not set
# CONFIG_NETDEV_NOTIFIER_ERROR_INJECT is not set
CONFIG_FAULT_INJECTION=y
CONFIG_FAILSLAB=y
# CONFIG_FAIL_PAGE_ALLOC is not set
# CONFIG_FAIL_MAKE_REQUEST is not set
CONFIG_FAIL_IO_TIMEOUT=y
CONFIG_FAIL_FUTEX=y
CONFIG_FAULT_INJECTION_DEBUG_FS=y
CONFIG_FAIL_MMC_REQUEST=y
# CONFIG_FAULT_INJECTION_STACKTRACE_FILTER is not set
CONFIG_CC_HAS_SANCOV_TRACE_PC=y
CONFIG_RUNTIME_TESTING_MENU=y
# CONFIG_LKDTM is not set
# CONFIG_TEST_LIST_SORT is not set
# CONFIG_TEST_MIN_HEAP is not set
# CONFIG_TEST_SORT is not set
# CONFIG_BACKTRACE_SELF_TEST is not set
# CONFIG_RBTREE_TEST is not set
# CONFIG_REED_SOLOMON_TEST is not set
# CONFIG_INTERVAL_TREE_TEST is not set
# CONFIG_PERCPU_TEST is not set
# CONFIG_ATOMIC64_SELFTEST is not set
# CONFIG_ASYNC_RAID6_TEST is not set
# CONFIG_TEST_HEXDUMP is not set
# CONFIG_TEST_STRING_HELPERS is not set
CONFIG_TEST_STRSCPY=m
# CONFIG_TEST_KSTRTOX is not set
CONFIG_TEST_PRINTF=m
CONFIG_TEST_BITMAP=m
# CONFIG_TEST_BITFIELD is not set
# CONFIG_TEST_UUID is not set
# CONFIG_TEST_XARRAY is not set
# CONFIG_TEST_OVERFLOW is not set
# CONFIG_TEST_RHASHTABLE is not set
# CONFIG_TEST_HASH is not set
# CONFIG_TEST_IDA is not set
CONFIG_TEST_LKM=m
CONFIG_TEST_VMALLOC=m
CONFIG_TEST_USER_COPY=m
CONFIG_TEST_BPF=m
CONFIG_TEST_BLACKHOLE_DEV=m
# CONFIG_FIND_BIT_BENCHMARK is not set
CONFIG_TEST_FIRMWARE=m
CONFIG_TEST_SYSCTL=m
# CONFIG_TEST_UDELAY is not set
CONFIG_TEST_STATIC_KEYS=m
CONFIG_TEST_KMOD=m
# CONFIG_TEST_MEMCAT_P is not set
# CONFIG_TEST_STACKINIT is not set
# CONFIG_TEST_MEMINIT is not set
# CONFIG_MEMTEST is not set
# end of Kernel Testing and Coverage
# end of Kernel hacking

--aF3LVLvitz/VQU3c--
