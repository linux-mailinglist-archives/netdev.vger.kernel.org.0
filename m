Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B9CB844BBC7
	for <lists+netdev@lfdr.de>; Wed, 10 Nov 2021 07:39:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230171AbhKJGm0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Nov 2021 01:42:26 -0500
Received: from mga07.intel.com ([134.134.136.100]:11891 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230117AbhKJGmZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 10 Nov 2021 01:42:25 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10163"; a="296053006"
X-IronPort-AV: E=Sophos;i="5.87,223,1631602800"; 
   d="xz'?yaml'?scan'208";a="296053006"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Nov 2021 22:39:36 -0800
X-IronPort-AV: E=Sophos;i="5.87,223,1631602800"; 
   d="xz'?yaml'?scan'208";a="503842133"
Received: from xsang-optiplex-9020.sh.intel.com (HELO xsang-OptiPlex-9020) ([10.239.159.143])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Nov 2021 22:39:31 -0800
Date:   Wed, 10 Nov 2021 14:39:28 +0800
From:   kernel test robot <oliver.sang@intel.com>
To:     Kuniyuki Iwashima <kuniyu@amazon.co.jp>
Cc:     lkp@lists.01.org, lkp@intel.com,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Kuniyuki Iwashima <kuniyu@amazon.co.jp>,
        Kuniyuki Iwashima <kuni1840@gmail.com>,
        Benjamin Herrenschmidt <benh@amazon.com>,
        netdev@vger.kernel.org
Subject: [af_unix]  95e381b609: WARNING:possible_recursive_locking_detected
Message-ID: <20211110063928.GB30217@xsang-OptiPlex-9020>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="jho1yZJdad60DJr+"
Content-Disposition: inline
In-Reply-To: <20211106091712.15206-13-kuniyu@amazon.co.jp>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--jho1yZJdad60DJr+
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline



Greeting,

FYI, we noticed the following commit (built with gcc-9):

commit: 95e381b6095d0808a64ecbe36515cca2ea2df477 ("[PATCH net-next 12/13] af_unix: Replace the big lock with small locks.")
url: https://github.com/0day-ci/linux/commits/Kuniyuki-Iwashima/af_unix-Replace-unix_table_lock-with-per-hash-locks/20211106-172208
base: https://git.kernel.org/cgit/linux/kernel/git/davem/net-next.git 84882cf72cd774cf16fd338bdbf00f69ac9f9194
patch link: https://lore.kernel.org/netdev/20211106091712.15206-13-kuniyu@amazon.co.jp

in testcase: kernel-selftests
version: kernel-selftests-x86_64-c8c9111a-1_20210929
with following parameters:

	group: x86
	ucode: 0xde

test-description: The kernel contains a set of "self tests" under the tools/testing/selftests/ directory. These are intended to be small unit tests to exercise individual code paths in the kernel.
test-url: https://www.kernel.org/doc/Documentation/kselftest.txt


on test machine: 4 threads 1 sockets Intel(R) Core(TM) i7-7567U CPU @ 3.50GHz with 32G memory

caused below changes (please refer to attached dmesg/kmsg for entire log/backtrace):


+---------------------------------------------+------------+------------+
|                                             | 5c1456529e | 95e381b609 |
+---------------------------------------------+------------+------------+
| boot_successes                              | 4          | 0          |
| boot_failures                               | 0          | 4          |
| WARNING:possible_recursive_locking_detected | 0          | 4          |
+---------------------------------------------+------------+------------+


If you fix the issue, kindly add following tag
Reported-by: kernel test robot <oliver.sang@intel.com>


kern  :warn  : [   39.215794] WARNING: possible recursive locking detected
kern  :warn  : [   39.216286] 5.15.0-rc7-02477-g95e381b6095d #1 Not tainted
kern  :warn  : [   39.216816] --------------------------------------------
kern  :warn  : [   39.217306] systemd/1 is trying to acquire lock:
kern :warn : [   39.217783] ffffffff87c53fb8 (&unix_table_locks[i]){+.+.}-{2:2}, at: unix_bind (net/unix/af_unix.c:1176 net/unix/af_unix.c:1253) 
kern  :warn  : [   39.218514]
but task is already holding lock:
kern :warn : [   39.219142] ffffffff87c4de38 (&unix_table_locks[i]){+.+.}-{2:2}, at: unix_table_double_lock (net/unix/af_unix.c:170) 
kern  :warn  : [   39.219969]
other info that might help us debug this:
kern  :warn  : [   39.220611]  Possible unsafe locking scenario:

kern  :warn  : [   39.221209]        CPU0
kern  :warn  : [   39.221499]        ----
kern  :warn  : [   39.221789]   lock(&unix_table_locks[i]);
kern  :warn  : [   39.222191]   lock(&unix_table_locks[i]);
kern  :warn  : [   39.222592]
*** DEADLOCK ***

kern  :warn  : [   39.223256]  May be due to missing lock nesting notation

kern  :warn  : [   39.223919] 4 locks held by systemd/1:
kern :warn : [   39.224301] #0: ffff8888765ca448 (sb_writers#6){.+.+}-{0:0}, at: filename_create (fs/namei.c:3656) 
kern :warn : [   39.225037] #1: ffff888100275280 (&type->i_mutex_dir_key#4/1){+.+.}-{3:3}, at: filename_create (fs/namei.c:3657) 
kern :warn : [   39.225863] #2: ffff888874f82e18 (&u->bindlock){+.+.}-{3:3}, at: unix_bind (net/unix/af_unix.c:1168 net/unix/af_unix.c:1253) 
kern :warn : [   39.226571] #3: ffffffff87c4de38 (&unix_table_locks[i]){+.+.}-{2:2}, at: unix_table_double_lock (net/unix/af_unix.c:170) 
kern  :warn  : [   39.227394]
stack backtrace:
kern  :warn  : [   39.227885] CPU: 2 PID: 1 Comm: systemd Not tainted 5.15.0-rc7-02477-g95e381b6095d #1
kern  :warn  : [   39.228571] Hardware name: Intel Corporation NUC7i7BNH/NUC7i7BNB, BIOS BNKBL357.86A.0067.2018.0814.1500 08/14/2018
kern  :warn  : [   39.229434] Call Trace:
kern :warn : [   39.229727] dump_stack_lvl (lib/dump_stack.c:107) 
kern :warn : [   39.230107] __lock_acquire.cold (kernel/locking/lockdep.c:2944 kernel/locking/lockdep.c:2987 kernel/locking/lockdep.c:3776 kernel/locking/lockdep.c:5015) 
kern :warn : [   39.230530] ? lockdep_hardirqs_on_prepare (kernel/locking/lockdep.c:4873) 
kern :warn : [   39.231012] ? lock_is_held_type (kernel/locking/lockdep.c:438 kernel/locking/lockdep.c:5669) 
kern :warn : [   39.231426] ? lockdep_hardirqs_on_prepare (kernel/locking/lockdep.c:4873) 
kern :warn : [   39.231907] ? lock_is_held_type (kernel/locking/lockdep.c:438 kernel/locking/lockdep.c:5669) 
kern :warn : [   39.232321] ? rcu_read_lock_sched_held (include/linux/lockdep.h:283 kernel/rcu/update.c:125) 
kern :warn : [   39.232779] lock_acquire (kernel/locking/lockdep.c:438 kernel/locking/lockdep.c:5627 kernel/locking/lockdep.c:5590) 
kern :warn : [   39.233155] ? unix_bind (net/unix/af_unix.c:1176 net/unix/af_unix.c:1253) 
kern :warn : [   39.233533] ? rcu_read_unlock (include/linux/rcupdate.h:716 (discriminator 5)) 
kern :warn : [   39.233932] ? do_raw_spin_lock (arch/x86/include/asm/atomic.h:202 include/linux/atomic/atomic-instrumented.h:513 include/asm-generic/qspinlock.h:82 kernel/locking/spinlock_debug.c:115) 
kern :warn : [   39.234346] ? rwlock_bug+0xc0/0xc0 
kern :warn : [   39.234757] _raw_spin_lock (include/linux/spinlock_api_smp.h:143 kernel/locking/spinlock.c:154) 
kern :warn : [   39.235135] ? unix_bind (net/unix/af_unix.c:1176 net/unix/af_unix.c:1253) 
kern :warn : [   39.235513] unix_bind (net/unix/af_unix.c:1176 net/unix/af_unix.c:1253) 
kern :warn : [   39.235880] ? unix_socketpair (net/unix/af_unix.c:1239) 
kern :warn : [   39.236289] ? _copy_from_user (arch/x86/include/asm/uaccess_64.h:46 arch/x86/include/asm/uaccess_64.h:52 lib/usercopy.c:16) 
kern :warn : [   39.236694] __sys_bind (net/socket.c:1693) 
kern :warn : [   39.237061] ? __ia32_sys_socketpair (net/socket.c:1680) 
kern :warn : [   39.237504] ? lock_is_held_type (kernel/locking/lockdep.c:438 kernel/locking/lockdep.c:5669) 
kern :warn : [   39.237919] ? lock_is_held_type (kernel/locking/lockdep.c:438 kernel/locking/lockdep.c:5669) 
kern :warn : [   39.238332] ? syscall_enter_from_user_mode (kernel/entry/common.c:107) 
kern :warn : [   39.241493] ? rcu_read_lock_sched_held (include/linux/lockdep.h:283 kernel/rcu/update.c:125) 
kern :warn : [   39.241951] ? rcu_read_lock_bh_held (kernel/rcu/update.c:120) 
kern :warn : [   39.242382] ? do_syscall_64 (arch/x86/entry/common.c:87) 
kern :warn : [   39.242768] __x64_sys_bind (net/socket.c:1702) 
kern :warn : [   39.243145] ? syscall_enter_from_user_mode (arch/x86/include/asm/irqflags.h:45 arch/x86/include/asm/irqflags.h:80 kernel/entry/common.c:107) 
kern :warn : [   39.243620] do_syscall_64 (arch/x86/entry/common.c:50 arch/x86/entry/common.c:80) 
kern :warn : [   39.243994] ? do_syscall_64 (arch/x86/entry/common.c:87) 
kern :warn : [   39.244378] ? lockdep_hardirqs_on (kernel/locking/lockdep.c:4344) 
kern :warn : [   39.244803] ? do_syscall_64 (arch/x86/entry/common.c:87) 
kern :warn : [   39.245188] ? do_syscall_64 (arch/x86/entry/common.c:87) 
kern :warn : [   39.245571] ? lockdep_hardirqs_on (kernel/locking/lockdep.c:4344) 
kern :warn : [   39.245997] ? do_syscall_64 (arch/x86/entry/common.c:87) 
kern :warn : [   39.246380] ? asm_sysvec_apic_timer_interrupt (arch/x86/include/asm/idtentry.h:638) 
kern :warn : [   39.246873] ? asm_sysvec_apic_timer_interrupt (arch/x86/include/asm/idtentry.h:638) 
kern :warn : [   39.247359] ? lockdep_hardirqs_on (kernel/locking/lockdep.c:4344) 
kern :warn : [   39.247786] entry_SYSCALL_64_after_hwframe (arch/x86/entry/entry_64.S:113) 
kern  :warn  : [   39.248260] RIP: 0033:0x7f84b7e22497
kern :warn : [ 39.248632] Code: ff ff ff ff c3 48 8b 15 f7 09 0c 00 f7 d8 64 89 02 b8 ff ff ff ff eb ba 66 2e 0f 1f 84 00 00 00 00 00 90 b8 31 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d c9 09 0c 00 f7 d8 64 89 01 48
All code
========
   0:	ff                   	(bad)  
   1:	ff                   	(bad)  
   2:	ff                   	(bad)  
   3:	ff c3                	inc    %ebx
   5:	48 8b 15 f7 09 0c 00 	mov    0xc09f7(%rip),%rdx        # 0xc0a03
   c:	f7 d8                	neg    %eax
   e:	64 89 02             	mov    %eax,%fs:(%rdx)
  11:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  16:	eb ba                	jmp    0xffffffffffffffd2
  18:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
  1f:	00 00 00 
  22:	90                   	nop
  23:	b8 31 00 00 00       	mov    $0x31,%eax
  28:	0f 05                	syscall 
  2a:*	48 3d 01 f0 ff ff    	cmp    $0xfffffffffffff001,%rax		<-- trapping instruction
  30:	73 01                	jae    0x33
  32:	c3                   	retq   
  33:	48 8b 0d c9 09 0c 00 	mov    0xc09c9(%rip),%rcx        # 0xc0a03
  3a:	f7 d8                	neg    %eax
  3c:	64 89 01             	mov    %eax,%fs:(%rcx)
  3f:	48                   	rex.W

Code starting with the faulting instruction
===========================================
   0:	48 3d 01 f0 ff ff    	cmp    $0xfffffffffffff001,%rax
   6:	73 01                	jae    0x9
   8:	c3                   	retq   
   9:	48 8b 0d c9 09 0c 00 	mov    0xc09c9(%rip),%rcx        # 0xc09d9
  10:	f7 d8                	neg    %eax
  12:	64 89 01             	mov    %eax,%fs:(%rcx)
  15:	48                   	rex.W
kern  :warn  : [   39.250101] RSP: 002b:00007ffd7751fa58 EFLAGS: 00000246 ORIG_RAX: 0000000000000031
kern  :warn  : [   39.250770] RAX: ffffffffffffffda RBX: 0000559d4fc70bb0 RCX: 00007f84b7e22497
kern  :warn  : [   39.251406] RDX: 0000000000000016 RSI: 00007ffd7751fa70 RDI: 000000000000000f
kern  :warn  : [   39.252042] RBP: 00007ffd7751fa70 R08: 000000000000000c R09: 0000559d4fcd6670
kern  :warn  : [   39.252679] R10: 00007ffd7751fa24 R11: 0000000000000246 R12: 000000000000000f
kern  :warn  : [   39.253314] R13: 0000000000000016 R14: 00007ffd7751fb50 R15: 00007ffd7751fb48
kern  :notice: [   39.425532] random: systemd-random-: uninitialized urandom read (512 bytes read)
kern  :info  : [   39.905355] intel_pmc_core INT33A1:00:  initialized
kern  :debug : [   40.139879] IOAPIC[2]: Set IRTE entry (P:1 FPD:0 Dst_Mode:1 Redir_hint:1 Trig_Mode:0 Dlvry_Mode:0 Avail:0 Vector:EF Dest:00000001 SID:F0F8 SQ:0 SVT:1)
kern  :debug : [   40.141118] IOAPIC[0]: Preconfigured routing entry (2-18 -> IRQ 18 Level:1 ActiveLow:1)
kern  :info  : [   40.186707] mei_me 0000:00:16.0: enabling device (0004 -> 0006)
kern  :debug : [   40.196333] libata version 3.00 loaded.
kern  :notice: [   40.361505] random: dbus-daemon: uninitialized urandom read (12 bytes read)
kern  :notice: [   40.365282] random: dbus-daemon: uninitialized urandom read (12 bytes read)
kern  :info  : [   40.969470] microcode: updated to revision 0xde, date = 2020-05-27
kern  :warn  : [   40.970115] x86/CPU: CPU features have changed after loading microcode, but might not take effect.
kern  :warn  : [   40.971061] x86/CPU: Please consider either early loading through initrd/built-in or a potential BIOS update.
kern  :info  : [   40.971992] microcode: Reload completed, microcode revision: 0xde
kern  :info  : [   41.013694] i801_smbus 0000:00:1f.4: SPD Write Disable is set
kern  :info  : [   41.014375] i801_smbus 0000:00:1f.4: SMBus using PCI interrupt
kern  :info  : [   41.015800] IPMI message handler: version 39.2
kern  :info  : [   41.022407] iTCO_wdt iTCO_wdt: Found a Intel PCH TCO device (Version=4, TCOBASE=0x0400)
kern  :info  : [   41.023587] ipmi device interface
kern  :info  : [   41.033277] iTCO_wdt iTCO_wdt: initialized. heartbeat=30 sec (nowayout=0)
kern  :notice: [   41.048766] random: ln: uninitialized urandom read (6 bytes read)
kern  :debug : [   41.068893] ahci 0000:00:17.0: version 3.0
kern  :info  : [   41.115078] ipmi_si: IPMI System Interface driver
kern  :warn  : [   41.117158] ipmi_si: Unable to find any System Interface(s)
kern  :info  : [   41.117819] ahci 0000:00:17.0: AHCI 0001.0301 32 slots 2 ports 6 Gbps 0x5 impl SATA mode
kern  :info  : [   41.118556] ahci 0000:00:17.0: flags: 64bit ncq pm led clo only pio slum part deso sadm sds apst
kern  :notice: [   41.138009] random: ln: uninitialized urandom read (6 bytes read)
kern  :info  : [   41.170985] RAPL PMU: API unit is 2^-32 Joules, 5 fixed counters, 655360 ms ovfl timer
kern  :info  : [   41.171706] RAPL PMU: hw unit of domain pp0-core 2^-14 Joules
kern  :info  : [   41.172240] RAPL PMU: hw unit of domain package 2^-14 Joules
kern  :info  : [   41.172781] RAPL PMU: hw unit of domain dram 2^-14 Joules
kern  :info  : [   41.173296] RAPL PMU: hw unit of domain pp1-gpu 2^-14 Joules
kern  :info  : [   41.174495] RAPL PMU: hw unit of domain psys 2^-14 Joules
kern  :info  : [   41.220484] scsi host0: ahci
kern  :info  : [   41.235600] i2c i2c-0: 2/2 memory slots populated (from DMI)
kern  :info  : [   41.236463] scsi host1: ahci
kern  :info  : [   41.243332] i2c i2c-0: Successfully instantiated SPD at 0x50
kern  :info  : [   41.251989] scsi host2: ahci
kern  :info  : [   41.254369] ata1: SATA max UDMA/133 abar m2048@0xdc24b000 port 0xdc24b100 irq 129
kern  :info  : [   41.255076] ata2: DUMMY
kern  :info  : [   41.255403] ata3: SATA max UDMA/133 abar m2048@0xdc24b000 port 0xdc24b200 irq 129
kern  :info  : [   41.428685] i915 0000:00:02.0: [drm] Found 64MB of eDRAM
kern  :info  : [   41.429635] i915 0000:00:02.0: vgaarb: deactivate vga console


To reproduce:

        git clone https://github.com/intel/lkp-tests.git
        cd lkp-tests
        sudo bin/lkp install job.yaml           # job file is attached in this email
        bin/lkp split-job --compatible job.yaml # generate the yaml file for lkp run
        sudo bin/lkp run generated-yaml-file

        # if come across any failure that blocks the test,
        # please remove ~/.lkp and /lkp dir to run from a clean state.



---
0DAY/LKP+ Test Infrastructure                   Open Source Technology Center
https://lists.01.org/hyperkitty/list/lkp@lists.01.org       Intel Corporation

Thanks,
Oliver Sang


--jho1yZJdad60DJr+
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="config-5.15.0-rc7-02477-g95e381b6095d"

#
# Automatically generated file; DO NOT EDIT.
# Linux/x86_64 5.15.0-rc7 Kernel Configuration
#
CONFIG_CC_VERSION_TEXT="gcc-9 (Debian 9.3.0-22) 9.3.0"
CONFIG_CC_IS_GCC=y
CONFIG_GCC_VERSION=90300
CONFIG_CLANG_VERSION=0
CONFIG_AS_IS_GNU=y
CONFIG_AS_VERSION=23502
CONFIG_LD_IS_BFD=y
CONFIG_LD_VERSION=23502
CONFIG_LLD_VERSION=0
CONFIG_CC_CAN_LINK=y
CONFIG_CC_CAN_LINK_STATIC=y
CONFIG_CC_HAS_ASM_GOTO=y
CONFIG_CC_HAS_ASM_INLINE=y
CONFIG_CC_HAS_NO_PROFILE_FN_ATTR=y
CONFIG_CONSTRUCTORS=y
CONFIG_IRQ_WORK=y
CONFIG_BUILDTIME_TABLE_SORT=y
CONFIG_THREAD_INFO_IN_TASK=y

#
# General setup
#
CONFIG_INIT_ENV_ARG_LIMIT=32
# CONFIG_COMPILE_TEST is not set
# CONFIG_WERROR is not set
CONFIG_LOCALVERSION=""
CONFIG_LOCALVERSION_AUTO=y
CONFIG_BUILD_SALT=""
CONFIG_HAVE_KERNEL_GZIP=y
CONFIG_HAVE_KERNEL_BZIP2=y
CONFIG_HAVE_KERNEL_LZMA=y
CONFIG_HAVE_KERNEL_XZ=y
CONFIG_HAVE_KERNEL_LZO=y
CONFIG_HAVE_KERNEL_LZ4=y
CONFIG_HAVE_KERNEL_ZSTD=y
CONFIG_KERNEL_GZIP=y
# CONFIG_KERNEL_BZIP2 is not set
# CONFIG_KERNEL_LZMA is not set
# CONFIG_KERNEL_XZ is not set
# CONFIG_KERNEL_LZO is not set
# CONFIG_KERNEL_LZ4 is not set
# CONFIG_KERNEL_ZSTD is not set
CONFIG_DEFAULT_INIT=""
CONFIG_DEFAULT_HOSTNAME="(none)"
CONFIG_SWAP=y
CONFIG_SYSVIPC=y
CONFIG_SYSVIPC_SYSCTL=y
CONFIG_POSIX_MQUEUE=y
CONFIG_POSIX_MQUEUE_SYSCTL=y
# CONFIG_WATCH_QUEUE is not set
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
CONFIG_GENERIC_IRQ_INJECTION=y
CONFIG_HARDIRQS_SW_RESEND=y
CONFIG_IRQ_DOMAIN=y
CONFIG_IRQ_SIM=y
CONFIG_IRQ_DOMAIN_HIERARCHY=y
CONFIG_GENERIC_MSI_IRQ=y
CONFIG_GENERIC_MSI_IRQ_DOMAIN=y
CONFIG_IRQ_MSI_IOMMU=y
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
CONFIG_HAVE_POSIX_CPU_TIMERS_TASK_WORK=y
CONFIG_POSIX_CPU_TIMERS_TASK_WORK=y

#
# Timers subsystem
#
CONFIG_TICK_ONESHOT=y
CONFIG_NO_HZ_COMMON=y
# CONFIG_HZ_PERIODIC is not set
# CONFIG_NO_HZ_IDLE is not set
CONFIG_NO_HZ_FULL=y
CONFIG_CONTEXT_TRACKING=y
# CONFIG_CONTEXT_TRACKING_FORCE is not set
CONFIG_NO_HZ=y
CONFIG_HIGH_RES_TIMERS=y
# end of Timers subsystem

CONFIG_BPF=y
CONFIG_HAVE_EBPF_JIT=y
CONFIG_ARCH_WANT_DEFAULT_BPF_JIT=y

#
# BPF subsystem
#
CONFIG_BPF_SYSCALL=y
CONFIG_BPF_JIT=y
CONFIG_BPF_JIT_ALWAYS_ON=y
CONFIG_BPF_JIT_DEFAULT_ON=y
CONFIG_BPF_UNPRIV_DEFAULT_OFF=y
# CONFIG_BPF_PRELOAD is not set
CONFIG_BPF_LSM=y
# end of BPF subsystem

# CONFIG_PREEMPT_NONE is not set
# CONFIG_PREEMPT_VOLUNTARY is not set
CONFIG_PREEMPT=y
CONFIG_PREEMPT_COUNT=y
CONFIG_PREEMPTION=y
CONFIG_PREEMPT_DYNAMIC=y
# CONFIG_SCHED_CORE is not set

#
# CPU/Task time and stats accounting
#
CONFIG_VIRT_CPU_ACCOUNTING=y
CONFIG_VIRT_CPU_ACCOUNTING_GEN=y
CONFIG_IRQ_TIME_ACCOUNTING=y
CONFIG_HAVE_SCHED_AVG_IRQ=y
CONFIG_BSD_PROCESS_ACCT=y
CONFIG_BSD_PROCESS_ACCT_V3=y
CONFIG_TASKSTATS=y
CONFIG_TASK_DELAY_ACCT=y
CONFIG_TASK_XACCT=y
CONFIG_TASK_IO_ACCOUNTING=y
# CONFIG_PSI is not set
# end of CPU/Task time and stats accounting

CONFIG_CPU_ISOLATION=y

#
# RCU Subsystem
#
CONFIG_TREE_RCU=y
CONFIG_PREEMPT_RCU=y
# CONFIG_RCU_EXPERT is not set
CONFIG_SRCU=y
CONFIG_TREE_SRCU=y
CONFIG_TASKS_RCU_GENERIC=y
CONFIG_TASKS_RCU=y
CONFIG_TASKS_RUDE_RCU=y
CONFIG_TASKS_TRACE_RCU=y
CONFIG_RCU_STALL_COMMON=y
CONFIG_RCU_NEED_SEGCBLIST=y
CONFIG_RCU_NOCB_CPU=y
# end of RCU Subsystem

CONFIG_BUILD_BIN2C=y
CONFIG_IKCONFIG=y
CONFIG_IKCONFIG_PROC=y
# CONFIG_IKHEADERS is not set
CONFIG_LOG_BUF_SHIFT=20
CONFIG_LOG_CPU_MAX_BUF_SHIFT=12
CONFIG_PRINTK_SAFE_LOG_BUF_SHIFT=13
# CONFIG_PRINTK_INDEX is not set
CONFIG_HAVE_UNSTABLE_SCHED_CLOCK=y

#
# Scheduler features
#
# CONFIG_UCLAMP_TASK is not set
# end of Scheduler features

CONFIG_ARCH_SUPPORTS_NUMA_BALANCING=y
CONFIG_ARCH_WANT_BATCHED_UNMAP_TLB_FLUSH=y
CONFIG_CC_HAS_INT128=y
CONFIG_ARCH_SUPPORTS_INT128=y
CONFIG_NUMA_BALANCING=y
CONFIG_NUMA_BALANCING_DEFAULT_ENABLED=y
CONFIG_CGROUPS=y
CONFIG_PAGE_COUNTER=y
CONFIG_MEMCG=y
CONFIG_MEMCG_SWAP=y
CONFIG_MEMCG_KMEM=y
CONFIG_BLK_CGROUP=y
CONFIG_CGROUP_WRITEBACK=y
CONFIG_CGROUP_SCHED=y
CONFIG_FAIR_GROUP_SCHED=y
CONFIG_CFS_BANDWIDTH=y
CONFIG_RT_GROUP_SCHED=y
CONFIG_CGROUP_PIDS=y
CONFIG_CGROUP_RDMA=y
CONFIG_CGROUP_FREEZER=y
CONFIG_CGROUP_HUGETLB=y
CONFIG_CPUSETS=y
CONFIG_PROC_PID_CPUSET=y
CONFIG_CGROUP_DEVICE=y
CONFIG_CGROUP_CPUACCT=y
CONFIG_CGROUP_PERF=y
CONFIG_CGROUP_BPF=y
# CONFIG_CGROUP_MISC is not set
# CONFIG_CGROUP_DEBUG is not set
CONFIG_SOCK_CGROUP_DATA=y
CONFIG_NAMESPACES=y
CONFIG_UTS_NS=y
CONFIG_TIME_NS=y
CONFIG_IPC_NS=y
CONFIG_USER_NS=y
CONFIG_PID_NS=y
CONFIG_NET_NS=y
CONFIG_CHECKPOINT_RESTORE=y
CONFIG_SCHED_AUTOGROUP=y
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
CONFIG_RD_ZSTD=y
# CONFIG_BOOT_CONFIG is not set
CONFIG_CC_OPTIMIZE_FOR_PERFORMANCE=y
# CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
CONFIG_LD_ORPHAN_WARN=y
CONFIG_SYSCTL=y
CONFIG_HAVE_UID16=y
CONFIG_SYSCTL_EXCEPTION_TRACE=y
CONFIG_HAVE_PCSPKR_PLATFORM=y
CONFIG_EXPERT=y
CONFIG_UID16=y
CONFIG_MULTIUSER=y
CONFIG_SGETMASK_SYSCALL=y
CONFIG_SYSFS_SYSCALL=y
CONFIG_FHANDLE=y
CONFIG_POSIX_TIMERS=y
CONFIG_PRINTK=y
CONFIG_BUG=y
CONFIG_ELF_CORE=y
CONFIG_PCSPKR_PLATFORM=y
CONFIG_BASE_FULL=y
CONFIG_FUTEX=y
CONFIG_FUTEX_PI=y
CONFIG_EPOLL=y
CONFIG_SIGNALFD=y
CONFIG_TIMERFD=y
CONFIG_EVENTFD=y
CONFIG_SHMEM=y
CONFIG_AIO=y
CONFIG_IO_URING=y
CONFIG_ADVISE_SYSCALLS=y
CONFIG_HAVE_ARCH_USERFAULTFD_WP=y
CONFIG_HAVE_ARCH_USERFAULTFD_MINOR=y
CONFIG_MEMBARRIER=y
CONFIG_KALLSYMS=y
CONFIG_KALLSYMS_ALL=y
CONFIG_KALLSYMS_ABSOLUTE_PERCPU=y
CONFIG_KALLSYMS_BASE_RELATIVE=y
CONFIG_USERFAULTFD=y
CONFIG_ARCH_HAS_MEMBARRIER_SYNC_CORE=y
CONFIG_KCMP=y
CONFIG_RSEQ=y
# CONFIG_DEBUG_RSEQ is not set
CONFIG_EMBEDDED=y
CONFIG_HAVE_PERF_EVENTS=y
# CONFIG_PC104 is not set

#
# Kernel Performance Events And Counters
#
CONFIG_PERF_EVENTS=y
# CONFIG_DEBUG_PERF_USE_VMALLOC is not set
# end of Kernel Performance Events And Counters

CONFIG_VM_EVENT_COUNTERS=y
CONFIG_SLUB_DEBUG=y
# CONFIG_COMPAT_BRK is not set
# CONFIG_SLAB is not set
CONFIG_SLUB=y
# CONFIG_SLOB is not set
CONFIG_SLAB_MERGE_DEFAULT=y
CONFIG_SLAB_FREELIST_RANDOM=y
CONFIG_SLAB_FREELIST_HARDENED=y
CONFIG_SHUFFLE_PAGE_ALLOCATOR=y
CONFIG_SLUB_CPU_PARTIAL=y
CONFIG_SYSTEM_DATA_VERIFICATION=y
CONFIG_PROFILING=y
CONFIG_TRACEPOINTS=y
# end of General setup

CONFIG_64BIT=y
CONFIG_X86_64=y
CONFIG_X86=y
CONFIG_INSTRUCTION_DECODER=y
CONFIG_OUTPUT_FORMAT="elf64-x86-64"
CONFIG_LOCKDEP_SUPPORT=y
CONFIG_STACKTRACE_SUPPORT=y
CONFIG_MMU=y
CONFIG_ARCH_MMAP_RND_BITS_MIN=28
CONFIG_ARCH_MMAP_RND_BITS_MAX=32
CONFIG_ARCH_MMAP_RND_COMPAT_BITS_MIN=8
CONFIG_ARCH_MMAP_RND_COMPAT_BITS_MAX=16
CONFIG_GENERIC_ISA_DMA=y
CONFIG_GENERIC_BUG=y
CONFIG_GENERIC_BUG_RELATIVE_POINTERS=y
CONFIG_ARCH_MAY_HAVE_PC_FDC=y
CONFIG_GENERIC_CALIBRATE_DELAY=y
CONFIG_ARCH_HAS_CPU_RELAX=y
CONFIG_ARCH_HAS_FILTER_PGPROT=y
CONFIG_HAVE_SETUP_PER_CPU_AREA=y
CONFIG_NEED_PER_CPU_EMBED_FIRST_CHUNK=y
CONFIG_NEED_PER_CPU_PAGE_FIRST_CHUNK=y
CONFIG_ARCH_HIBERNATION_POSSIBLE=y
CONFIG_ARCH_NR_GPIO=1024
CONFIG_ARCH_SUSPEND_POSSIBLE=y
CONFIG_ARCH_WANT_GENERAL_HUGETLB=y
CONFIG_AUDIT_ARCH=y
CONFIG_KASAN_SHADOW_OFFSET=0xdffffc0000000000
CONFIG_HAVE_INTEL_TXT=y
CONFIG_X86_64_SMP=y
CONFIG_ARCH_SUPPORTS_UPROBES=y
CONFIG_FIX_EARLYCON_MEM=y
CONFIG_PGTABLE_LEVELS=5
CONFIG_CC_HAS_SANE_STACKPROTECTOR=y

#
# Processor type and features
#
CONFIG_SMP=y
CONFIG_X86_FEATURE_NAMES=y
CONFIG_X86_X2APIC=y
CONFIG_X86_MPPARSE=y
# CONFIG_GOLDFISH is not set
CONFIG_RETPOLINE=y
CONFIG_X86_CPU_RESCTRL=y
CONFIG_X86_EXTENDED_PLATFORM=y
# CONFIG_X86_NUMACHIP is not set
# CONFIG_X86_VSMP is not set
CONFIG_X86_UV=y
# CONFIG_X86_GOLDFISH is not set
# CONFIG_X86_INTEL_MID is not set
CONFIG_X86_INTEL_LPSS=y
# CONFIG_X86_AMD_PLATFORM_DEVICE is not set
CONFIG_IOSF_MBI=y
# CONFIG_IOSF_MBI_DEBUG is not set
CONFIG_X86_SUPPORTS_MEMORY_FAILURE=y
# CONFIG_SCHED_OMIT_FRAME_POINTER is not set
CONFIG_HYPERVISOR_GUEST=y
CONFIG_PARAVIRT=y
# CONFIG_PARAVIRT_DEBUG is not set
CONFIG_PARAVIRT_SPINLOCKS=y
CONFIG_X86_HV_CALLBACK_VECTOR=y
# CONFIG_XEN is not set
CONFIG_KVM_GUEST=y
CONFIG_ARCH_CPUIDLE_HALTPOLL=y
# CONFIG_PVH is not set
CONFIG_PARAVIRT_TIME_ACCOUNTING=y
CONFIG_PARAVIRT_CLOCK=y
# CONFIG_JAILHOUSE_GUEST is not set
# CONFIG_ACRN_GUEST is not set
# CONFIG_MK8 is not set
# CONFIG_MPSC is not set
# CONFIG_MCORE2 is not set
# CONFIG_MATOM is not set
CONFIG_GENERIC_CPU=y
CONFIG_X86_INTERNODE_CACHE_SHIFT=6
CONFIG_X86_L1_CACHE_SHIFT=6
CONFIG_X86_TSC=y
CONFIG_X86_CMPXCHG64=y
CONFIG_X86_CMOV=y
CONFIG_X86_MINIMUM_CPU_FAMILY=64
CONFIG_X86_DEBUGCTLMSR=y
CONFIG_IA32_FEAT_CTL=y
CONFIG_X86_VMX_FEATURE_NAMES=y
# CONFIG_PROCESSOR_SELECT is not set
CONFIG_CPU_SUP_INTEL=y
CONFIG_CPU_SUP_AMD=y
CONFIG_CPU_SUP_HYGON=y
CONFIG_CPU_SUP_CENTAUR=y
CONFIG_CPU_SUP_ZHAOXIN=y
CONFIG_HPET_TIMER=y
CONFIG_HPET_EMULATE_RTC=y
CONFIG_DMI=y
# CONFIG_GART_IOMMU is not set
CONFIG_MAXSMP=y
CONFIG_NR_CPUS_RANGE_BEGIN=8192
CONFIG_NR_CPUS_RANGE_END=8192
CONFIG_NR_CPUS_DEFAULT=8192
CONFIG_NR_CPUS=8192
CONFIG_SCHED_SMT=y
CONFIG_SCHED_MC=y
CONFIG_SCHED_MC_PRIO=y
CONFIG_X86_LOCAL_APIC=y
CONFIG_X86_IO_APIC=y
CONFIG_X86_REROUTE_FOR_BROKEN_BOOT_IRQS=y
CONFIG_X86_MCE=y
CONFIG_X86_MCELOG_LEGACY=y
CONFIG_X86_MCE_INTEL=y
CONFIG_X86_MCE_AMD=y
CONFIG_X86_MCE_THRESHOLD=y
CONFIG_X86_MCE_INJECT=m

#
# Performance monitoring
#
CONFIG_PERF_EVENTS_INTEL_UNCORE=m
CONFIG_PERF_EVENTS_INTEL_RAPL=m
CONFIG_PERF_EVENTS_INTEL_CSTATE=m
# CONFIG_PERF_EVENTS_AMD_POWER is not set
CONFIG_PERF_EVENTS_AMD_UNCORE=y
# end of Performance monitoring

CONFIG_X86_16BIT=y
CONFIG_X86_ESPFIX64=y
CONFIG_X86_VSYSCALL_EMULATION=y
CONFIG_X86_IOPL_IOPERM=y
CONFIG_I8K=m
CONFIG_MICROCODE=y
CONFIG_MICROCODE_INTEL=y
CONFIG_MICROCODE_AMD=y
CONFIG_MICROCODE_OLD_INTERFACE=y
CONFIG_X86_MSR=y
CONFIG_X86_CPUID=y
CONFIG_X86_5LEVEL=y
CONFIG_X86_DIRECT_GBPAGES=y
# CONFIG_X86_CPA_STATISTICS is not set
# CONFIG_AMD_MEM_ENCRYPT is not set
CONFIG_NUMA=y
# CONFIG_AMD_NUMA is not set
CONFIG_X86_64_ACPI_NUMA=y
CONFIG_NUMA_EMU=y
CONFIG_NODES_SHIFT=10
CONFIG_ARCH_SPARSEMEM_ENABLE=y
CONFIG_ARCH_SPARSEMEM_DEFAULT=y
CONFIG_ARCH_SELECT_MEMORY_MODEL=y
# CONFIG_ARCH_MEMORY_PROBE is not set
CONFIG_ARCH_PROC_KCORE_TEXT=y
CONFIG_ILLEGAL_POINTER_VALUE=0xdead000000000000
CONFIG_X86_PMEM_LEGACY_DEVICE=y
CONFIG_X86_PMEM_LEGACY=m
CONFIG_X86_CHECK_BIOS_CORRUPTION=y
# CONFIG_X86_BOOTPARAM_MEMORY_CORRUPTION_CHECK is not set
CONFIG_MTRR=y
CONFIG_MTRR_SANITIZER=y
CONFIG_MTRR_SANITIZER_ENABLE_DEFAULT=1
CONFIG_MTRR_SANITIZER_SPARE_REG_NR_DEFAULT=1
CONFIG_X86_PAT=y
CONFIG_ARCH_USES_PG_UNCACHED=y
CONFIG_ARCH_RANDOM=y
CONFIG_X86_SMAP=y
CONFIG_X86_UMIP=y
CONFIG_X86_INTEL_MEMORY_PROTECTION_KEYS=y
CONFIG_X86_INTEL_TSX_MODE_OFF=y
# CONFIG_X86_INTEL_TSX_MODE_ON is not set
# CONFIG_X86_INTEL_TSX_MODE_AUTO is not set
CONFIG_X86_SGX=y
CONFIG_EFI=y
CONFIG_EFI_STUB=y
CONFIG_EFI_MIXED=y
# CONFIG_HZ_100 is not set
# CONFIG_HZ_250 is not set
# CONFIG_HZ_300 is not set
CONFIG_HZ_1000=y
CONFIG_HZ=1000
CONFIG_SCHED_HRTICK=y
CONFIG_KEXEC=y
CONFIG_KEXEC_FILE=y
CONFIG_ARCH_HAS_KEXEC_PURGATORY=y
# CONFIG_KEXEC_SIG is not set
CONFIG_CRASH_DUMP=y
CONFIG_KEXEC_JUMP=y
CONFIG_PHYSICAL_START=0x1000000
CONFIG_RELOCATABLE=y
CONFIG_RANDOMIZE_BASE=y
CONFIG_X86_NEED_RELOCS=y
CONFIG_PHYSICAL_ALIGN=0x200000
CONFIG_DYNAMIC_MEMORY_LAYOUT=y
CONFIG_RANDOMIZE_MEMORY=y
CONFIG_RANDOMIZE_MEMORY_PHYSICAL_PADDING=0xa
CONFIG_HOTPLUG_CPU=y
CONFIG_BOOTPARAM_HOTPLUG_CPU0=y
# CONFIG_DEBUG_HOTPLUG_CPU0 is not set
# CONFIG_COMPAT_VDSO is not set
CONFIG_LEGACY_VSYSCALL_EMULATE=y
# CONFIG_LEGACY_VSYSCALL_XONLY is not set
# CONFIG_LEGACY_VSYSCALL_NONE is not set
# CONFIG_CMDLINE_BOOL is not set
CONFIG_MODIFY_LDT_SYSCALL=y
CONFIG_HAVE_LIVEPATCH=y
CONFIG_LIVEPATCH=y
# end of Processor type and features

CONFIG_ARCH_HAS_ADD_PAGES=y
CONFIG_ARCH_MHP_MEMMAP_ON_MEMORY_ENABLE=y
CONFIG_USE_PERCPU_NUMA_NODE_ID=y

#
# Power management and ACPI options
#
CONFIG_ARCH_HIBERNATION_HEADER=y
CONFIG_SUSPEND=y
CONFIG_SUSPEND_FREEZER=y
# CONFIG_SUSPEND_SKIP_SYNC is not set
CONFIG_HIBERNATE_CALLBACKS=y
CONFIG_HIBERNATION=y
CONFIG_HIBERNATION_SNAPSHOT_DEV=y
CONFIG_PM_STD_PARTITION=""
CONFIG_PM_SLEEP=y
CONFIG_PM_SLEEP_SMP=y
# CONFIG_PM_AUTOSLEEP is not set
# CONFIG_PM_WAKELOCKS is not set
CONFIG_PM=y
CONFIG_PM_DEBUG=y
# CONFIG_PM_ADVANCED_DEBUG is not set
# CONFIG_PM_TEST_SUSPEND is not set
CONFIG_PM_SLEEP_DEBUG=y
# CONFIG_DPM_WATCHDOG is not set
# CONFIG_PM_TRACE_RTC is not set
CONFIG_PM_CLK=y
# CONFIG_WQ_POWER_EFFICIENT_DEFAULT is not set
# CONFIG_ENERGY_MODEL is not set
CONFIG_ARCH_SUPPORTS_ACPI=y
CONFIG_ACPI=y
CONFIG_ACPI_LEGACY_TABLES_LOOKUP=y
CONFIG_ARCH_MIGHT_HAVE_ACPI_PDC=y
CONFIG_ACPI_SYSTEM_POWER_STATES_SUPPORT=y
# CONFIG_ACPI_DEBUGGER is not set
CONFIG_ACPI_SPCR_TABLE=y
# CONFIG_ACPI_FPDT is not set
CONFIG_ACPI_LPIT=y
CONFIG_ACPI_SLEEP=y
CONFIG_ACPI_REV_OVERRIDE_POSSIBLE=y
CONFIG_ACPI_EC_DEBUGFS=m
CONFIG_ACPI_AC=y
CONFIG_ACPI_BATTERY=y
CONFIG_ACPI_BUTTON=y
CONFIG_ACPI_VIDEO=m
CONFIG_ACPI_FAN=y
CONFIG_ACPI_TAD=m
CONFIG_ACPI_DOCK=y
CONFIG_ACPI_CPU_FREQ_PSS=y
CONFIG_ACPI_PROCESSOR_CSTATE=y
CONFIG_ACPI_PROCESSOR_IDLE=y
CONFIG_ACPI_CPPC_LIB=y
CONFIG_ACPI_PROCESSOR=y
CONFIG_ACPI_IPMI=m
CONFIG_ACPI_HOTPLUG_CPU=y
CONFIG_ACPI_PROCESSOR_AGGREGATOR=m
CONFIG_ACPI_THERMAL=y
CONFIG_ACPI_PLATFORM_PROFILE=m
CONFIG_ARCH_HAS_ACPI_TABLE_UPGRADE=y
CONFIG_ACPI_TABLE_UPGRADE=y
# CONFIG_ACPI_DEBUG is not set
CONFIG_ACPI_PCI_SLOT=y
CONFIG_ACPI_CONTAINER=y
CONFIG_ACPI_HOTPLUG_MEMORY=y
CONFIG_ACPI_HOTPLUG_IOAPIC=y
CONFIG_ACPI_SBS=m
CONFIG_ACPI_HED=y
# CONFIG_ACPI_CUSTOM_METHOD is not set
CONFIG_ACPI_BGRT=y
# CONFIG_ACPI_REDUCED_HARDWARE_ONLY is not set
CONFIG_ACPI_NFIT=m
# CONFIG_NFIT_SECURITY_DEBUG is not set
CONFIG_ACPI_NUMA=y
# CONFIG_ACPI_HMAT is not set
CONFIG_HAVE_ACPI_APEI=y
CONFIG_HAVE_ACPI_APEI_NMI=y
CONFIG_ACPI_APEI=y
CONFIG_ACPI_APEI_GHES=y
CONFIG_ACPI_APEI_PCIEAER=y
CONFIG_ACPI_APEI_MEMORY_FAILURE=y
CONFIG_ACPI_APEI_EINJ=m
# CONFIG_ACPI_APEI_ERST_DEBUG is not set
# CONFIG_ACPI_DPTF is not set
CONFIG_ACPI_WATCHDOG=y
CONFIG_ACPI_EXTLOG=m
CONFIG_ACPI_ADXL=y
# CONFIG_ACPI_CONFIGFS is not set
CONFIG_PMIC_OPREGION=y
CONFIG_X86_PM_TIMER=y
CONFIG_ACPI_PRMT=y

#
# CPU Frequency scaling
#
CONFIG_CPU_FREQ=y
CONFIG_CPU_FREQ_GOV_ATTR_SET=y
CONFIG_CPU_FREQ_GOV_COMMON=y
CONFIG_CPU_FREQ_STAT=y
CONFIG_CPU_FREQ_DEFAULT_GOV_PERFORMANCE=y
# CONFIG_CPU_FREQ_DEFAULT_GOV_POWERSAVE is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_USERSPACE is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_SCHEDUTIL is not set
CONFIG_CPU_FREQ_GOV_PERFORMANCE=y
CONFIG_CPU_FREQ_GOV_POWERSAVE=y
CONFIG_CPU_FREQ_GOV_USERSPACE=y
CONFIG_CPU_FREQ_GOV_ONDEMAND=y
CONFIG_CPU_FREQ_GOV_CONSERVATIVE=y
CONFIG_CPU_FREQ_GOV_SCHEDUTIL=y

#
# CPU frequency scaling drivers
#
CONFIG_X86_INTEL_PSTATE=y
# CONFIG_X86_PCC_CPUFREQ is not set
CONFIG_X86_ACPI_CPUFREQ=m
CONFIG_X86_ACPI_CPUFREQ_CPB=y
CONFIG_X86_POWERNOW_K8=m
# CONFIG_X86_AMD_FREQ_SENSITIVITY is not set
# CONFIG_X86_SPEEDSTEP_CENTRINO is not set
CONFIG_X86_P4_CLOCKMOD=m

#
# shared options
#
CONFIG_X86_SPEEDSTEP_LIB=m
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
CONFIG_PCI_DIRECT=y
CONFIG_PCI_MMCONFIG=y
CONFIG_MMCONF_FAM10H=y
# CONFIG_PCI_CNB20LE_QUIRK is not set
# CONFIG_ISA_BUS is not set
CONFIG_ISA_DMA_API=y
CONFIG_AMD_NB=y
# end of Bus options (PCI etc.)

#
# Binary Emulations
#
CONFIG_IA32_EMULATION=y
# CONFIG_X86_X32 is not set
CONFIG_COMPAT_32=y
CONFIG_COMPAT=y
CONFIG_COMPAT_FOR_U64_ALIGNMENT=y
CONFIG_SYSVIPC_COMPAT=y
# end of Binary Emulations

CONFIG_HAVE_KVM=y
CONFIG_HAVE_KVM_IRQCHIP=y
CONFIG_HAVE_KVM_IRQFD=y
CONFIG_HAVE_KVM_IRQ_ROUTING=y
CONFIG_HAVE_KVM_EVENTFD=y
CONFIG_KVM_MMIO=y
CONFIG_KVM_ASYNC_PF=y
CONFIG_HAVE_KVM_MSI=y
CONFIG_HAVE_KVM_CPU_RELAX_INTERCEPT=y
CONFIG_KVM_VFIO=y
CONFIG_KVM_GENERIC_DIRTYLOG_READ_PROTECT=y
CONFIG_KVM_COMPAT=y
CONFIG_HAVE_KVM_IRQ_BYPASS=y
CONFIG_HAVE_KVM_NO_POLL=y
CONFIG_KVM_XFER_TO_GUEST_WORK=y
CONFIG_HAVE_KVM_PM_NOTIFIER=y
CONFIG_VIRTUALIZATION=y
CONFIG_KVM=y
# CONFIG_KVM_WERROR is not set
CONFIG_KVM_INTEL=y
# CONFIG_X86_SGX_KVM is not set
CONFIG_KVM_AMD=y
# CONFIG_KVM_XEN is not set
CONFIG_KVM_MMU_AUDIT=y
CONFIG_AS_AVX512=y
CONFIG_AS_SHA1_NI=y
CONFIG_AS_SHA256_NI=y
CONFIG_AS_TPAUSE=y

#
# General architecture-dependent options
#
CONFIG_CRASH_CORE=y
CONFIG_KEXEC_CORE=y
CONFIG_HOTPLUG_SMT=y
CONFIG_GENERIC_ENTRY=y
CONFIG_KPROBES=y
CONFIG_JUMP_LABEL=y
# CONFIG_STATIC_KEYS_SELFTEST is not set
# CONFIG_STATIC_CALL_SELFTEST is not set
CONFIG_OPTPROBES=y
CONFIG_KPROBES_ON_FTRACE=y
CONFIG_UPROBES=y
CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS=y
CONFIG_ARCH_USE_BUILTIN_BSWAP=y
CONFIG_KRETPROBES=y
CONFIG_USER_RETURN_NOTIFIER=y
CONFIG_HAVE_IOREMAP_PROT=y
CONFIG_HAVE_KPROBES=y
CONFIG_HAVE_KRETPROBES=y
CONFIG_HAVE_OPTPROBES=y
CONFIG_HAVE_KPROBES_ON_FTRACE=y
CONFIG_HAVE_FUNCTION_ERROR_INJECTION=y
CONFIG_HAVE_NMI=y
CONFIG_TRACE_IRQFLAGS_SUPPORT=y
CONFIG_HAVE_ARCH_TRACEHOOK=y
CONFIG_HAVE_DMA_CONTIGUOUS=y
CONFIG_GENERIC_SMP_IDLE_THREAD=y
CONFIG_ARCH_HAS_FORTIFY_SOURCE=y
CONFIG_ARCH_HAS_SET_MEMORY=y
CONFIG_ARCH_HAS_SET_DIRECT_MAP=y
CONFIG_HAVE_ARCH_THREAD_STRUCT_WHITELIST=y
CONFIG_ARCH_WANTS_DYNAMIC_TASK_STRUCT=y
CONFIG_ARCH_WANTS_NO_INSTR=y
CONFIG_HAVE_ASM_MODVERSIONS=y
CONFIG_HAVE_REGS_AND_STACK_ACCESS_API=y
CONFIG_HAVE_RSEQ=y
CONFIG_HAVE_FUNCTION_ARG_ACCESS_API=y
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
CONFIG_HAVE_ALIGNED_STRUCT_PAGE=y
CONFIG_HAVE_CMPXCHG_LOCAL=y
CONFIG_HAVE_CMPXCHG_DOUBLE=y
CONFIG_ARCH_WANT_COMPAT_IPC_PARSE_VERSION=y
CONFIG_ARCH_WANT_OLD_COMPAT_IPC=y
CONFIG_HAVE_ARCH_SECCOMP=y
CONFIG_HAVE_ARCH_SECCOMP_FILTER=y
CONFIG_SECCOMP=y
CONFIG_SECCOMP_FILTER=y
# CONFIG_SECCOMP_CACHE_DEBUG is not set
CONFIG_HAVE_ARCH_STACKLEAK=y
CONFIG_HAVE_STACKPROTECTOR=y
CONFIG_STACKPROTECTOR=y
CONFIG_STACKPROTECTOR_STRONG=y
CONFIG_ARCH_SUPPORTS_LTO_CLANG=y
CONFIG_ARCH_SUPPORTS_LTO_CLANG_THIN=y
CONFIG_LTO_NONE=y
CONFIG_HAVE_ARCH_WITHIN_STACK_FRAMES=y
CONFIG_HAVE_CONTEXT_TRACKING=y
CONFIG_HAVE_CONTEXT_TRACKING_OFFSTACK=y
CONFIG_HAVE_VIRT_CPU_ACCOUNTING_GEN=y
CONFIG_HAVE_IRQ_TIME_ACCOUNTING=y
CONFIG_HAVE_MOVE_PUD=y
CONFIG_HAVE_MOVE_PMD=y
CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE=y
CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD=y
CONFIG_HAVE_ARCH_HUGE_VMAP=y
CONFIG_ARCH_WANT_HUGE_PMD_SHARE=y
CONFIG_HAVE_ARCH_SOFT_DIRTY=y
CONFIG_HAVE_MOD_ARCH_SPECIFIC=y
CONFIG_MODULES_USE_ELF_RELA=y
CONFIG_HAVE_IRQ_EXIT_ON_IRQ_STACK=y
CONFIG_HAVE_SOFTIRQ_ON_OWN_STACK=y
CONFIG_ARCH_HAS_ELF_RANDOMIZE=y
CONFIG_HAVE_ARCH_MMAP_RND_BITS=y
CONFIG_HAVE_EXIT_THREAD=y
CONFIG_ARCH_MMAP_RND_BITS=28
CONFIG_HAVE_ARCH_MMAP_RND_COMPAT_BITS=y
CONFIG_ARCH_MMAP_RND_COMPAT_BITS=8
CONFIG_HAVE_ARCH_COMPAT_MMAP_BASES=y
CONFIG_HAVE_STACK_VALIDATION=y
CONFIG_HAVE_RELIABLE_STACKTRACE=y
CONFIG_OLD_SIGSUSPEND3=y
CONFIG_COMPAT_OLD_SIGACTION=y
CONFIG_COMPAT_32BIT_TIME=y
CONFIG_HAVE_ARCH_VMAP_STACK=y
CONFIG_VMAP_STACK=y
CONFIG_HAVE_ARCH_RANDOMIZE_KSTACK_OFFSET=y
CONFIG_RANDOMIZE_KSTACK_OFFSET_DEFAULT=y
CONFIG_ARCH_HAS_STRICT_KERNEL_RWX=y
CONFIG_STRICT_KERNEL_RWX=y
CONFIG_ARCH_HAS_STRICT_MODULE_RWX=y
CONFIG_STRICT_MODULE_RWX=y
CONFIG_HAVE_ARCH_PREL32_RELOCATIONS=y
CONFIG_ARCH_USE_MEMREMAP_PROT=y
# CONFIG_LOCK_EVENT_COUNTS is not set
CONFIG_ARCH_HAS_MEM_ENCRYPT=y
CONFIG_HAVE_STATIC_CALL=y
CONFIG_HAVE_STATIC_CALL_INLINE=y
CONFIG_HAVE_PREEMPT_DYNAMIC=y
CONFIG_ARCH_WANT_LD_ORPHAN_WARN=y
CONFIG_ARCH_SUPPORTS_DEBUG_PAGEALLOC=y
CONFIG_ARCH_HAS_ELFCORE_COMPAT=y
CONFIG_ARCH_HAS_PARANOID_L1D_FLUSH=y

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
CONFIG_MODULE_SIG_FORMAT=y
CONFIG_MODULES=y
CONFIG_MODULE_FORCE_LOAD=y
CONFIG_MODULE_UNLOAD=y
# CONFIG_MODULE_FORCE_UNLOAD is not set
# CONFIG_MODVERSIONS is not set
# CONFIG_MODULE_SRCVERSION_ALL is not set
CONFIG_MODULE_SIG=y
# CONFIG_MODULE_SIG_FORCE is not set
CONFIG_MODULE_SIG_ALL=y
# CONFIG_MODULE_SIG_SHA1 is not set
# CONFIG_MODULE_SIG_SHA224 is not set
CONFIG_MODULE_SIG_SHA256=y
# CONFIG_MODULE_SIG_SHA384 is not set
# CONFIG_MODULE_SIG_SHA512 is not set
CONFIG_MODULE_SIG_HASH="sha256"
CONFIG_MODULE_COMPRESS_NONE=y
# CONFIG_MODULE_COMPRESS_GZIP is not set
# CONFIG_MODULE_COMPRESS_XZ is not set
# CONFIG_MODULE_COMPRESS_ZSTD is not set
# CONFIG_MODULE_ALLOW_MISSING_NAMESPACE_IMPORTS is not set
CONFIG_MODPROBE_PATH="/sbin/modprobe"
# CONFIG_TRIM_UNUSED_KSYMS is not set
CONFIG_MODULES_TREE_LOOKUP=y
CONFIG_BLOCK=y
CONFIG_BLK_CGROUP_RWSTAT=y
CONFIG_BLK_DEV_BSG_COMMON=y
CONFIG_BLK_DEV_BSGLIB=y
CONFIG_BLK_DEV_INTEGRITY=y
CONFIG_BLK_DEV_INTEGRITY_T10=m
# CONFIG_BLK_DEV_ZONED is not set
CONFIG_BLK_DEV_THROTTLING=y
# CONFIG_BLK_DEV_THROTTLING_LOW is not set
CONFIG_BLK_WBT=y
CONFIG_BLK_WBT_MQ=y
# CONFIG_BLK_CGROUP_IOLATENCY is not set
# CONFIG_BLK_CGROUP_FC_APPID is not set
# CONFIG_BLK_CGROUP_IOCOST is not set
# CONFIG_BLK_CGROUP_IOPRIO is not set
CONFIG_BLK_DEBUG_FS=y
# CONFIG_BLK_SED_OPAL is not set
# CONFIG_BLK_INLINE_ENCRYPTION is not set

#
# Partition Types
#
CONFIG_PARTITION_ADVANCED=y
# CONFIG_ACORN_PARTITION is not set
# CONFIG_AIX_PARTITION is not set
CONFIG_OSF_PARTITION=y
CONFIG_AMIGA_PARTITION=y
# CONFIG_ATARI_PARTITION is not set
CONFIG_MAC_PARTITION=y
CONFIG_MSDOS_PARTITION=y
CONFIG_BSD_DISKLABEL=y
CONFIG_MINIX_SUBPARTITION=y
CONFIG_SOLARIS_X86_PARTITION=y
CONFIG_UNIXWARE_DISKLABEL=y
# CONFIG_LDM_PARTITION is not set
CONFIG_SGI_PARTITION=y
# CONFIG_ULTRIX_PARTITION is not set
CONFIG_SUN_PARTITION=y
CONFIG_KARMA_PARTITION=y
CONFIG_EFI_PARTITION=y
# CONFIG_SYSV68_PARTITION is not set
# CONFIG_CMDLINE_PARTITION is not set
# end of Partition Types

CONFIG_BLOCK_COMPAT=y
CONFIG_BLK_MQ_PCI=y
CONFIG_BLK_MQ_VIRTIO=y
CONFIG_BLK_PM=y
CONFIG_BLOCK_HOLDER_DEPRECATED=y

#
# IO Schedulers
#
CONFIG_MQ_IOSCHED_DEADLINE=y
CONFIG_MQ_IOSCHED_KYBER=y
CONFIG_IOSCHED_BFQ=y
CONFIG_BFQ_GROUP_IOSCHED=y
# CONFIG_BFQ_CGROUP_DEBUG is not set
# end of IO Schedulers

CONFIG_PREEMPT_NOTIFIERS=y
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
CONFIG_ARCH_HAS_NON_OVERLAPPING_ADDRESS_SPACE=y
CONFIG_ARCH_HAS_SYNC_CORE_BEFORE_USERMODE=y
CONFIG_ARCH_HAS_SYSCALL_WRAPPER=y
CONFIG_FREEZER=y

#
# Executable file formats
#
CONFIG_BINFMT_ELF=y
CONFIG_COMPAT_BINFMT_ELF=y
CONFIG_ELFCORE=y
CONFIG_CORE_DUMP_DEFAULT_ELF_HEADERS=y
CONFIG_BINFMT_SCRIPT=y
CONFIG_BINFMT_MISC=m
CONFIG_COREDUMP=y
# end of Executable file formats

#
# Memory Management options
#
CONFIG_SELECT_MEMORY_MODEL=y
CONFIG_SPARSEMEM_MANUAL=y
CONFIG_SPARSEMEM=y
CONFIG_SPARSEMEM_EXTREME=y
CONFIG_SPARSEMEM_VMEMMAP_ENABLE=y
CONFIG_SPARSEMEM_VMEMMAP=y
CONFIG_HAVE_FAST_GUP=y
CONFIG_NUMA_KEEP_MEMINFO=y
CONFIG_MEMORY_ISOLATION=y
CONFIG_HAVE_BOOTMEM_INFO_NODE=y
CONFIG_ARCH_ENABLE_MEMORY_HOTPLUG=y
CONFIG_MEMORY_HOTPLUG=y
CONFIG_MEMORY_HOTPLUG_SPARSE=y
# CONFIG_MEMORY_HOTPLUG_DEFAULT_ONLINE is not set
CONFIG_ARCH_ENABLE_MEMORY_HOTREMOVE=y
CONFIG_MEMORY_HOTREMOVE=y
CONFIG_MHP_MEMMAP_ON_MEMORY=y
CONFIG_SPLIT_PTLOCK_CPUS=4
CONFIG_ARCH_ENABLE_SPLIT_PMD_PTLOCK=y
CONFIG_MEMORY_BALLOON=y
CONFIG_BALLOON_COMPACTION=y
CONFIG_COMPACTION=y
CONFIG_PAGE_REPORTING=y
CONFIG_MIGRATION=y
CONFIG_ARCH_ENABLE_HUGEPAGE_MIGRATION=y
CONFIG_ARCH_ENABLE_THP_MIGRATION=y
CONFIG_CONTIG_ALLOC=y
CONFIG_PHYS_ADDR_T_64BIT=y
CONFIG_VIRT_TO_BUS=y
CONFIG_MMU_NOTIFIER=y
CONFIG_KSM=y
CONFIG_DEFAULT_MMAP_MIN_ADDR=4096
CONFIG_ARCH_SUPPORTS_MEMORY_FAILURE=y
CONFIG_MEMORY_FAILURE=y
CONFIG_HWPOISON_INJECT=m
CONFIG_TRANSPARENT_HUGEPAGE=y
CONFIG_TRANSPARENT_HUGEPAGE_ALWAYS=y
# CONFIG_TRANSPARENT_HUGEPAGE_MADVISE is not set
CONFIG_ARCH_WANTS_THP_SWAP=y
CONFIG_THP_SWAP=y
CONFIG_CLEANCACHE=y
CONFIG_FRONTSWAP=y
# CONFIG_CMA is not set
# CONFIG_MEM_SOFT_DIRTY is not set
CONFIG_ZSWAP=y
# CONFIG_ZSWAP_COMPRESSOR_DEFAULT_DEFLATE is not set
CONFIG_ZSWAP_COMPRESSOR_DEFAULT_LZO=y
# CONFIG_ZSWAP_COMPRESSOR_DEFAULT_842 is not set
# CONFIG_ZSWAP_COMPRESSOR_DEFAULT_LZ4 is not set
# CONFIG_ZSWAP_COMPRESSOR_DEFAULT_LZ4HC is not set
# CONFIG_ZSWAP_COMPRESSOR_DEFAULT_ZSTD is not set
CONFIG_ZSWAP_COMPRESSOR_DEFAULT="lzo"
CONFIG_ZSWAP_ZPOOL_DEFAULT_ZBUD=y
# CONFIG_ZSWAP_ZPOOL_DEFAULT_Z3FOLD is not set
# CONFIG_ZSWAP_ZPOOL_DEFAULT_ZSMALLOC is not set
CONFIG_ZSWAP_ZPOOL_DEFAULT="zbud"
# CONFIG_ZSWAP_DEFAULT_ON is not set
CONFIG_ZPOOL=y
CONFIG_ZBUD=y
# CONFIG_Z3FOLD is not set
CONFIG_ZSMALLOC=y
CONFIG_ZSMALLOC_STAT=y
CONFIG_GENERIC_EARLY_IOREMAP=y
CONFIG_DEFERRED_STRUCT_PAGE_INIT=y
CONFIG_PAGE_IDLE_FLAG=y
CONFIG_IDLE_PAGE_TRACKING=y
CONFIG_ARCH_HAS_CACHE_LINE_SIZE=y
CONFIG_ARCH_HAS_PTE_DEVMAP=y
CONFIG_ARCH_HAS_ZONE_DMA_SET=y
CONFIG_ZONE_DMA=y
CONFIG_ZONE_DMA32=y
CONFIG_ZONE_DEVICE=y
CONFIG_DEV_PAGEMAP_OPS=y
CONFIG_HMM_MIRROR=y
CONFIG_DEVICE_PRIVATE=y
CONFIG_VMAP_PFN=y
CONFIG_ARCH_USES_HIGH_VMA_FLAGS=y
CONFIG_ARCH_HAS_PKEYS=y
# CONFIG_PERCPU_STATS is not set
CONFIG_GUP_TEST=y
# CONFIG_READ_ONLY_THP_FOR_FS is not set
CONFIG_ARCH_HAS_PTE_SPECIAL=y

#
# Data Access Monitoring
#
# CONFIG_DAMON is not set
# end of Data Access Monitoring
# end of Memory Management options

CONFIG_NET=y
CONFIG_NET_INGRESS=y
CONFIG_NET_EGRESS=y
CONFIG_NET_REDIRECT=y
CONFIG_SKB_EXTENSIONS=y

#
# Networking options
#
# CONFIG_PACKET is not set
CONFIG_UNIX=y
CONFIG_UNIX_SCM=y
CONFIG_AF_UNIX_OOB=y
CONFIG_UNIX_DIAG=m
CONFIG_TLS=m
CONFIG_TLS_DEVICE=y
# CONFIG_TLS_TOE is not set
CONFIG_XFRM=y
CONFIG_XFRM_OFFLOAD=y
CONFIG_XFRM_ALGO=y
CONFIG_XFRM_USER=y
# CONFIG_XFRM_USER_COMPAT is not set
# CONFIG_XFRM_INTERFACE is not set
CONFIG_XFRM_SUB_POLICY=y
CONFIG_XFRM_MIGRATE=y
CONFIG_XFRM_STATISTICS=y
CONFIG_XFRM_AH=m
CONFIG_XFRM_ESP=m
CONFIG_XFRM_IPCOMP=m
CONFIG_NET_KEY=m
CONFIG_NET_KEY_MIGRATE=y
CONFIG_XDP_SOCKETS=y
# CONFIG_XDP_SOCKETS_DIAG is not set
CONFIG_INET=y
CONFIG_IP_MULTICAST=y
CONFIG_IP_ADVANCED_ROUTER=y
CONFIG_IP_FIB_TRIE_STATS=y
CONFIG_IP_MULTIPLE_TABLES=y
CONFIG_IP_ROUTE_MULTIPATH=y
CONFIG_IP_ROUTE_VERBOSE=y
CONFIG_IP_ROUTE_CLASSID=y
CONFIG_IP_PNP=y
CONFIG_IP_PNP_DHCP=y
# CONFIG_IP_PNP_BOOTP is not set
# CONFIG_IP_PNP_RARP is not set
CONFIG_NET_IPIP=y
CONFIG_NET_IPGRE_DEMUX=y
CONFIG_NET_IP_TUNNEL=y
CONFIG_NET_IPGRE=y
CONFIG_NET_IPGRE_BROADCAST=y
CONFIG_IP_MROUTE_COMMON=y
CONFIG_IP_MROUTE=y
CONFIG_IP_MROUTE_MULTIPLE_TABLES=y
CONFIG_IP_PIMSM_V1=y
CONFIG_IP_PIMSM_V2=y
CONFIG_SYN_COOKIES=y
CONFIG_NET_IPVTI=m
CONFIG_NET_UDP_TUNNEL=y
CONFIG_NET_FOU=y
CONFIG_NET_FOU_IP_TUNNELS=y
CONFIG_INET_AH=m
CONFIG_INET_ESP=m
CONFIG_INET_ESP_OFFLOAD=m
# CONFIG_INET_ESPINTCP is not set
CONFIG_INET_IPCOMP=m
CONFIG_INET_XFRM_TUNNEL=m
CONFIG_INET_TUNNEL=y
CONFIG_INET_DIAG=m
CONFIG_INET_TCP_DIAG=m
CONFIG_INET_UDP_DIAG=m
CONFIG_INET_RAW_DIAG=m
# CONFIG_INET_DIAG_DESTROY is not set
CONFIG_TCP_CONG_ADVANCED=y
CONFIG_TCP_CONG_BIC=m
CONFIG_TCP_CONG_CUBIC=y
CONFIG_TCP_CONG_WESTWOOD=m
CONFIG_TCP_CONG_HTCP=m
CONFIG_TCP_CONG_HSTCP=m
CONFIG_TCP_CONG_HYBLA=m
CONFIG_TCP_CONG_VEGAS=m
CONFIG_TCP_CONG_NV=m
CONFIG_TCP_CONG_SCALABLE=m
CONFIG_TCP_CONG_LP=m
CONFIG_TCP_CONG_VENO=m
CONFIG_TCP_CONG_YEAH=m
CONFIG_TCP_CONG_ILLINOIS=m
CONFIG_TCP_CONG_DCTCP=m
# CONFIG_TCP_CONG_CDG is not set
CONFIG_TCP_CONG_BBR=m
CONFIG_DEFAULT_CUBIC=y
# CONFIG_DEFAULT_RENO is not set
CONFIG_DEFAULT_TCP_CONG="cubic"
CONFIG_TCP_MD5SIG=y
CONFIG_IPV6=y
CONFIG_IPV6_ROUTER_PREF=y
CONFIG_IPV6_ROUTE_INFO=y
CONFIG_IPV6_OPTIMISTIC_DAD=y
CONFIG_INET6_AH=m
CONFIG_INET6_ESP=m
CONFIG_INET6_ESP_OFFLOAD=m
# CONFIG_INET6_ESPINTCP is not set
CONFIG_INET6_IPCOMP=m
CONFIG_IPV6_MIP6=m
# CONFIG_IPV6_ILA is not set
CONFIG_INET6_XFRM_TUNNEL=m
CONFIG_INET6_TUNNEL=y
CONFIG_IPV6_VTI=m
CONFIG_IPV6_SIT=m
CONFIG_IPV6_SIT_6RD=y
CONFIG_IPV6_NDISC_NODETYPE=y
CONFIG_IPV6_TUNNEL=y
CONFIG_IPV6_GRE=y
CONFIG_IPV6_FOU=y
CONFIG_IPV6_FOU_TUNNEL=y
CONFIG_IPV6_MULTIPLE_TABLES=y
# CONFIG_IPV6_SUBTREES is not set
CONFIG_IPV6_MROUTE=y
CONFIG_IPV6_MROUTE_MULTIPLE_TABLES=y
CONFIG_IPV6_PIMSM_V2=y
CONFIG_IPV6_SEG6_LWTUNNEL=y
# CONFIG_IPV6_SEG6_HMAC is not set
CONFIG_IPV6_SEG6_BPF=y
# CONFIG_IPV6_RPL_LWTUNNEL is not set
CONFIG_IPV6_IOAM6_LWTUNNEL=y
CONFIG_NETLABEL=y
CONFIG_MPTCP=y
CONFIG_INET_MPTCP_DIAG=m
CONFIG_MPTCP_IPV6=y
CONFIG_NETWORK_SECMARK=y
CONFIG_NET_PTP_CLASSIFY=y
CONFIG_NETWORK_PHY_TIMESTAMPING=y
CONFIG_NETFILTER=y
CONFIG_NETFILTER_ADVANCED=y
CONFIG_BRIDGE_NETFILTER=m

#
# Core Netfilter Configuration
#
CONFIG_NETFILTER_INGRESS=y
CONFIG_NETFILTER_EGRESS=y
CONFIG_NETFILTER_SKIP_EGRESS=y
CONFIG_NETFILTER_NETLINK=m
CONFIG_NETFILTER_FAMILY_BRIDGE=y
CONFIG_NETFILTER_FAMILY_ARP=y
# CONFIG_NETFILTER_NETLINK_HOOK is not set
# CONFIG_NETFILTER_NETLINK_ACCT is not set
CONFIG_NETFILTER_NETLINK_QUEUE=m
CONFIG_NETFILTER_NETLINK_LOG=m
CONFIG_NETFILTER_NETLINK_OSF=m
CONFIG_NF_CONNTRACK=m
CONFIG_NF_LOG_SYSLOG=m
CONFIG_NETFILTER_CONNCOUNT=m
CONFIG_NF_CONNTRACK_MARK=y
CONFIG_NF_CONNTRACK_SECMARK=y
CONFIG_NF_CONNTRACK_ZONES=y
CONFIG_NF_CONNTRACK_PROCFS=y
CONFIG_NF_CONNTRACK_EVENTS=y
CONFIG_NF_CONNTRACK_TIMEOUT=y
CONFIG_NF_CONNTRACK_TIMESTAMP=y
CONFIG_NF_CONNTRACK_LABELS=y
CONFIG_NF_CT_PROTO_DCCP=y
CONFIG_NF_CT_PROTO_GRE=y
CONFIG_NF_CT_PROTO_SCTP=y
CONFIG_NF_CT_PROTO_UDPLITE=y
CONFIG_NF_CONNTRACK_AMANDA=m
CONFIG_NF_CONNTRACK_FTP=m
CONFIG_NF_CONNTRACK_H323=m
CONFIG_NF_CONNTRACK_IRC=m
CONFIG_NF_CONNTRACK_BROADCAST=m
CONFIG_NF_CONNTRACK_NETBIOS_NS=m
CONFIG_NF_CONNTRACK_SNMP=m
CONFIG_NF_CONNTRACK_PPTP=m
CONFIG_NF_CONNTRACK_SANE=m
CONFIG_NF_CONNTRACK_SIP=m
CONFIG_NF_CONNTRACK_TFTP=m
CONFIG_NF_CT_NETLINK=m
CONFIG_NF_CT_NETLINK_TIMEOUT=m
CONFIG_NF_CT_NETLINK_HELPER=m
CONFIG_NETFILTER_NETLINK_GLUE_CT=y
CONFIG_NF_NAT=m
CONFIG_NF_NAT_AMANDA=m
CONFIG_NF_NAT_FTP=m
CONFIG_NF_NAT_IRC=m
CONFIG_NF_NAT_SIP=m
CONFIG_NF_NAT_TFTP=m
CONFIG_NF_NAT_REDIRECT=y
CONFIG_NF_NAT_MASQUERADE=y
CONFIG_NETFILTER_SYNPROXY=m
CONFIG_NF_TABLES=m
CONFIG_NF_TABLES_INET=y
CONFIG_NF_TABLES_NETDEV=y
CONFIG_NFT_NUMGEN=m
CONFIG_NFT_CT=m
CONFIG_NFT_FLOW_OFFLOAD=m
CONFIG_NFT_COUNTER=m
CONFIG_NFT_CONNLIMIT=m
CONFIG_NFT_LOG=m
CONFIG_NFT_LIMIT=m
CONFIG_NFT_MASQ=m
CONFIG_NFT_REDIR=m
CONFIG_NFT_NAT=m
# CONFIG_NFT_TUNNEL is not set
CONFIG_NFT_OBJREF=m
CONFIG_NFT_QUEUE=m
CONFIG_NFT_QUOTA=m
CONFIG_NFT_REJECT=m
CONFIG_NFT_REJECT_INET=m
CONFIG_NFT_COMPAT=m
CONFIG_NFT_HASH=m
CONFIG_NFT_FIB=m
CONFIG_NFT_FIB_INET=m
# CONFIG_NFT_XFRM is not set
CONFIG_NFT_SOCKET=m
# CONFIG_NFT_OSF is not set
# CONFIG_NFT_TPROXY is not set
# CONFIG_NFT_SYNPROXY is not set
CONFIG_NF_DUP_NETDEV=m
CONFIG_NFT_DUP_NETDEV=m
CONFIG_NFT_FWD_NETDEV=m
CONFIG_NFT_FIB_NETDEV=m
# CONFIG_NFT_REJECT_NETDEV is not set
CONFIG_NF_FLOW_TABLE_INET=m
CONFIG_NF_FLOW_TABLE=m
CONFIG_NETFILTER_XTABLES=y
CONFIG_NETFILTER_XTABLES_COMPAT=y

#
# Xtables combined modules
#
CONFIG_NETFILTER_XT_MARK=m
CONFIG_NETFILTER_XT_CONNMARK=m
CONFIG_NETFILTER_XT_SET=m

#
# Xtables targets
#
CONFIG_NETFILTER_XT_TARGET_AUDIT=m
CONFIG_NETFILTER_XT_TARGET_CHECKSUM=m
CONFIG_NETFILTER_XT_TARGET_CLASSIFY=m
CONFIG_NETFILTER_XT_TARGET_CONNMARK=m
CONFIG_NETFILTER_XT_TARGET_CONNSECMARK=m
CONFIG_NETFILTER_XT_TARGET_CT=m
CONFIG_NETFILTER_XT_TARGET_DSCP=m
CONFIG_NETFILTER_XT_TARGET_HL=m
CONFIG_NETFILTER_XT_TARGET_HMARK=m
CONFIG_NETFILTER_XT_TARGET_IDLETIMER=m
# CONFIG_NETFILTER_XT_TARGET_LED is not set
CONFIG_NETFILTER_XT_TARGET_LOG=m
CONFIG_NETFILTER_XT_TARGET_MARK=m
CONFIG_NETFILTER_XT_NAT=m
CONFIG_NETFILTER_XT_TARGET_NETMAP=m
CONFIG_NETFILTER_XT_TARGET_NFLOG=m
CONFIG_NETFILTER_XT_TARGET_NFQUEUE=m
CONFIG_NETFILTER_XT_TARGET_NOTRACK=m
CONFIG_NETFILTER_XT_TARGET_RATEEST=m
CONFIG_NETFILTER_XT_TARGET_REDIRECT=m
CONFIG_NETFILTER_XT_TARGET_MASQUERADE=m
CONFIG_NETFILTER_XT_TARGET_TEE=m
CONFIG_NETFILTER_XT_TARGET_TPROXY=m
CONFIG_NETFILTER_XT_TARGET_TRACE=m
CONFIG_NETFILTER_XT_TARGET_SECMARK=m
CONFIG_NETFILTER_XT_TARGET_TCPMSS=m
CONFIG_NETFILTER_XT_TARGET_TCPOPTSTRIP=m

#
# Xtables matches
#
CONFIG_NETFILTER_XT_MATCH_ADDRTYPE=m
CONFIG_NETFILTER_XT_MATCH_BPF=m
CONFIG_NETFILTER_XT_MATCH_CGROUP=m
CONFIG_NETFILTER_XT_MATCH_CLUSTER=m
CONFIG_NETFILTER_XT_MATCH_COMMENT=m
CONFIG_NETFILTER_XT_MATCH_CONNBYTES=m
CONFIG_NETFILTER_XT_MATCH_CONNLABEL=m
CONFIG_NETFILTER_XT_MATCH_CONNLIMIT=m
CONFIG_NETFILTER_XT_MATCH_CONNMARK=m
CONFIG_NETFILTER_XT_MATCH_CONNTRACK=m
CONFIG_NETFILTER_XT_MATCH_CPU=m
CONFIG_NETFILTER_XT_MATCH_DCCP=m
CONFIG_NETFILTER_XT_MATCH_DEVGROUP=m
CONFIG_NETFILTER_XT_MATCH_DSCP=m
CONFIG_NETFILTER_XT_MATCH_ECN=m
CONFIG_NETFILTER_XT_MATCH_ESP=m
CONFIG_NETFILTER_XT_MATCH_HASHLIMIT=m
CONFIG_NETFILTER_XT_MATCH_HELPER=m
CONFIG_NETFILTER_XT_MATCH_HL=m
# CONFIG_NETFILTER_XT_MATCH_IPCOMP is not set
CONFIG_NETFILTER_XT_MATCH_IPRANGE=m
CONFIG_NETFILTER_XT_MATCH_IPVS=m
# CONFIG_NETFILTER_XT_MATCH_L2TP is not set
CONFIG_NETFILTER_XT_MATCH_LENGTH=m
CONFIG_NETFILTER_XT_MATCH_LIMIT=m
CONFIG_NETFILTER_XT_MATCH_MAC=m
CONFIG_NETFILTER_XT_MATCH_MARK=m
CONFIG_NETFILTER_XT_MATCH_MULTIPORT=m
# CONFIG_NETFILTER_XT_MATCH_NFACCT is not set
CONFIG_NETFILTER_XT_MATCH_OSF=m
CONFIG_NETFILTER_XT_MATCH_OWNER=m
CONFIG_NETFILTER_XT_MATCH_POLICY=m
CONFIG_NETFILTER_XT_MATCH_PHYSDEV=m
CONFIG_NETFILTER_XT_MATCH_PKTTYPE=m
CONFIG_NETFILTER_XT_MATCH_QUOTA=m
CONFIG_NETFILTER_XT_MATCH_RATEEST=m
CONFIG_NETFILTER_XT_MATCH_REALM=m
CONFIG_NETFILTER_XT_MATCH_RECENT=m
CONFIG_NETFILTER_XT_MATCH_SCTP=m
CONFIG_NETFILTER_XT_MATCH_SOCKET=m
CONFIG_NETFILTER_XT_MATCH_STATE=m
CONFIG_NETFILTER_XT_MATCH_STATISTIC=m
CONFIG_NETFILTER_XT_MATCH_STRING=m
CONFIG_NETFILTER_XT_MATCH_TCPMSS=m
# CONFIG_NETFILTER_XT_MATCH_TIME is not set
# CONFIG_NETFILTER_XT_MATCH_U32 is not set
# end of Core Netfilter Configuration

CONFIG_IP_SET=m
CONFIG_IP_SET_MAX=256
CONFIG_IP_SET_BITMAP_IP=m
CONFIG_IP_SET_BITMAP_IPMAC=m
CONFIG_IP_SET_BITMAP_PORT=m
CONFIG_IP_SET_HASH_IP=m
CONFIG_IP_SET_HASH_IPMARK=m
CONFIG_IP_SET_HASH_IPPORT=m
CONFIG_IP_SET_HASH_IPPORTIP=m
CONFIG_IP_SET_HASH_IPPORTNET=m
CONFIG_IP_SET_HASH_IPMAC=m
CONFIG_IP_SET_HASH_MAC=m
CONFIG_IP_SET_HASH_NETPORTNET=m
CONFIG_IP_SET_HASH_NET=m
CONFIG_IP_SET_HASH_NETNET=m
CONFIG_IP_SET_HASH_NETPORT=m
CONFIG_IP_SET_HASH_NETIFACE=m
CONFIG_IP_SET_LIST_SET=m
CONFIG_IP_VS=m
CONFIG_IP_VS_IPV6=y
# CONFIG_IP_VS_DEBUG is not set
CONFIG_IP_VS_TAB_BITS=12

#
# IPVS transport protocol load balancing support
#
CONFIG_IP_VS_PROTO_TCP=y
CONFIG_IP_VS_PROTO_UDP=y
CONFIG_IP_VS_PROTO_AH_ESP=y
CONFIG_IP_VS_PROTO_ESP=y
CONFIG_IP_VS_PROTO_AH=y
CONFIG_IP_VS_PROTO_SCTP=y

#
# IPVS scheduler
#
CONFIG_IP_VS_RR=m
CONFIG_IP_VS_WRR=m
CONFIG_IP_VS_LC=m
CONFIG_IP_VS_WLC=m
CONFIG_IP_VS_FO=m
CONFIG_IP_VS_OVF=m
CONFIG_IP_VS_LBLC=m
CONFIG_IP_VS_LBLCR=m
CONFIG_IP_VS_DH=m
CONFIG_IP_VS_SH=m
# CONFIG_IP_VS_MH is not set
CONFIG_IP_VS_SED=m
CONFIG_IP_VS_NQ=m
# CONFIG_IP_VS_TWOS is not set

#
# IPVS SH scheduler
#
CONFIG_IP_VS_SH_TAB_BITS=8

#
# IPVS MH scheduler
#
CONFIG_IP_VS_MH_TAB_INDEX=12

#
# IPVS application helper
#
CONFIG_IP_VS_FTP=m
CONFIG_IP_VS_NFCT=y
CONFIG_IP_VS_PE_SIP=m

#
# IP: Netfilter Configuration
#
CONFIG_NF_DEFRAG_IPV4=m
CONFIG_NF_SOCKET_IPV4=m
CONFIG_NF_TPROXY_IPV4=m
CONFIG_NF_TABLES_IPV4=y
CONFIG_NFT_REJECT_IPV4=m
CONFIG_NFT_DUP_IPV4=m
CONFIG_NFT_FIB_IPV4=m
CONFIG_NF_TABLES_ARP=y
CONFIG_NF_FLOW_TABLE_IPV4=m
CONFIG_NF_DUP_IPV4=m
CONFIG_NF_LOG_ARP=m
CONFIG_NF_LOG_IPV4=m
CONFIG_NF_REJECT_IPV4=m
CONFIG_NF_NAT_SNMP_BASIC=m
CONFIG_NF_NAT_PPTP=m
CONFIG_NF_NAT_H323=m
CONFIG_IP_NF_IPTABLES=m
CONFIG_IP_NF_MATCH_AH=m
CONFIG_IP_NF_MATCH_ECN=m
CONFIG_IP_NF_MATCH_RPFILTER=m
CONFIG_IP_NF_MATCH_TTL=m
CONFIG_IP_NF_FILTER=m
CONFIG_IP_NF_TARGET_REJECT=m
CONFIG_IP_NF_TARGET_SYNPROXY=m
CONFIG_IP_NF_NAT=m
CONFIG_IP_NF_TARGET_MASQUERADE=m
CONFIG_IP_NF_TARGET_NETMAP=m
CONFIG_IP_NF_TARGET_REDIRECT=m
CONFIG_IP_NF_MANGLE=m
# CONFIG_IP_NF_TARGET_CLUSTERIP is not set
CONFIG_IP_NF_TARGET_ECN=m
CONFIG_IP_NF_TARGET_TTL=m
CONFIG_IP_NF_RAW=m
CONFIG_IP_NF_SECURITY=m
CONFIG_IP_NF_ARPTABLES=m
CONFIG_IP_NF_ARPFILTER=m
CONFIG_IP_NF_ARP_MANGLE=m
# end of IP: Netfilter Configuration

#
# IPv6: Netfilter Configuration
#
CONFIG_NF_SOCKET_IPV6=m
CONFIG_NF_TPROXY_IPV6=m
CONFIG_NF_TABLES_IPV6=y
CONFIG_NFT_REJECT_IPV6=m
CONFIG_NFT_DUP_IPV6=m
CONFIG_NFT_FIB_IPV6=m
CONFIG_NF_FLOW_TABLE_IPV6=m
CONFIG_NF_DUP_IPV6=m
CONFIG_NF_REJECT_IPV6=m
CONFIG_NF_LOG_IPV6=m
CONFIG_IP6_NF_IPTABLES=m
CONFIG_IP6_NF_MATCH_AH=m
CONFIG_IP6_NF_MATCH_EUI64=m
CONFIG_IP6_NF_MATCH_FRAG=m
CONFIG_IP6_NF_MATCH_OPTS=m
CONFIG_IP6_NF_MATCH_HL=m
CONFIG_IP6_NF_MATCH_IPV6HEADER=m
CONFIG_IP6_NF_MATCH_MH=m
CONFIG_IP6_NF_MATCH_RPFILTER=m
CONFIG_IP6_NF_MATCH_RT=m
# CONFIG_IP6_NF_MATCH_SRH is not set
# CONFIG_IP6_NF_TARGET_HL is not set
CONFIG_IP6_NF_FILTER=m
CONFIG_IP6_NF_TARGET_REJECT=m
CONFIG_IP6_NF_TARGET_SYNPROXY=m
CONFIG_IP6_NF_MANGLE=m
CONFIG_IP6_NF_RAW=m
CONFIG_IP6_NF_SECURITY=m
CONFIG_IP6_NF_NAT=m
CONFIG_IP6_NF_TARGET_MASQUERADE=m
CONFIG_IP6_NF_TARGET_NPT=m
# end of IPv6: Netfilter Configuration

CONFIG_NF_DEFRAG_IPV6=m
CONFIG_NF_TABLES_BRIDGE=m
# CONFIG_NFT_BRIDGE_META is not set
CONFIG_NFT_BRIDGE_REJECT=m
# CONFIG_NF_CONNTRACK_BRIDGE is not set
CONFIG_BRIDGE_NF_EBTABLES=m
CONFIG_BRIDGE_EBT_BROUTE=m
CONFIG_BRIDGE_EBT_T_FILTER=m
CONFIG_BRIDGE_EBT_T_NAT=m
CONFIG_BRIDGE_EBT_802_3=m
CONFIG_BRIDGE_EBT_AMONG=m
CONFIG_BRIDGE_EBT_ARP=m
CONFIG_BRIDGE_EBT_IP=m
CONFIG_BRIDGE_EBT_IP6=m
CONFIG_BRIDGE_EBT_LIMIT=m
CONFIG_BRIDGE_EBT_MARK=m
CONFIG_BRIDGE_EBT_PKTTYPE=m
CONFIG_BRIDGE_EBT_STP=m
CONFIG_BRIDGE_EBT_VLAN=m
CONFIG_BRIDGE_EBT_ARPREPLY=m
CONFIG_BRIDGE_EBT_DNAT=m
CONFIG_BRIDGE_EBT_MARK_T=m
CONFIG_BRIDGE_EBT_REDIRECT=m
CONFIG_BRIDGE_EBT_SNAT=m
CONFIG_BRIDGE_EBT_LOG=m
CONFIG_BRIDGE_EBT_NFLOG=m
# CONFIG_BPFILTER is not set
# CONFIG_IP_DCCP is not set
CONFIG_IP_SCTP=m
# CONFIG_SCTP_DBG_OBJCNT is not set
# CONFIG_SCTP_DEFAULT_COOKIE_HMAC_MD5 is not set
CONFIG_SCTP_DEFAULT_COOKIE_HMAC_SHA1=y
# CONFIG_SCTP_DEFAULT_COOKIE_HMAC_NONE is not set
CONFIG_SCTP_COOKIE_HMAC_MD5=y
CONFIG_SCTP_COOKIE_HMAC_SHA1=y
CONFIG_INET_SCTP_DIAG=m
# CONFIG_RDS is not set
CONFIG_TIPC=m
CONFIG_TIPC_MEDIA_UDP=y
CONFIG_TIPC_CRYPTO=y
CONFIG_TIPC_DIAG=m
CONFIG_ATM=m
CONFIG_ATM_CLIP=m
# CONFIG_ATM_CLIP_NO_ICMP is not set
CONFIG_ATM_LANE=m
# CONFIG_ATM_MPOA is not set
CONFIG_ATM_BR2684=m
# CONFIG_ATM_BR2684_IPFILTER is not set
CONFIG_L2TP=m
CONFIG_L2TP_DEBUGFS=m
CONFIG_L2TP_V3=y
CONFIG_L2TP_IP=m
CONFIG_L2TP_ETH=m
CONFIG_STP=y
CONFIG_GARP=y
CONFIG_MRP=y
CONFIG_BRIDGE=y
CONFIG_BRIDGE_IGMP_SNOOPING=y
CONFIG_BRIDGE_VLAN_FILTERING=y
# CONFIG_BRIDGE_MRP is not set
# CONFIG_BRIDGE_CFM is not set
# CONFIG_NET_DSA is not set
CONFIG_VLAN_8021Q=y
CONFIG_VLAN_8021Q_GVRP=y
CONFIG_VLAN_8021Q_MVRP=y
# CONFIG_DECNET is not set
CONFIG_LLC=y
# CONFIG_LLC2 is not set
# CONFIG_ATALK is not set
# CONFIG_X25 is not set
# CONFIG_LAPB is not set
# CONFIG_PHONET is not set
CONFIG_6LOWPAN=m
# CONFIG_6LOWPAN_DEBUGFS is not set
# CONFIG_6LOWPAN_NHC is not set
CONFIG_IEEE802154=m
# CONFIG_IEEE802154_NL802154_EXPERIMENTAL is not set
CONFIG_IEEE802154_SOCKET=m
CONFIG_IEEE802154_6LOWPAN=m
CONFIG_MAC802154=m
CONFIG_NET_SCHED=y

#
# Queueing/Scheduling
#
CONFIG_NET_SCH_CBQ=m
CONFIG_NET_SCH_HTB=m
CONFIG_NET_SCH_HFSC=m
CONFIG_NET_SCH_ATM=m
CONFIG_NET_SCH_PRIO=m
CONFIG_NET_SCH_MULTIQ=m
CONFIG_NET_SCH_RED=m
CONFIG_NET_SCH_SFB=m
CONFIG_NET_SCH_SFQ=m
CONFIG_NET_SCH_TEQL=m
CONFIG_NET_SCH_TBF=m
# CONFIG_NET_SCH_CBS is not set
CONFIG_NET_SCH_ETF=m
# CONFIG_NET_SCH_TAPRIO is not set
CONFIG_NET_SCH_GRED=m
CONFIG_NET_SCH_DSMARK=m
CONFIG_NET_SCH_NETEM=y
CONFIG_NET_SCH_DRR=m
CONFIG_NET_SCH_MQPRIO=m
# CONFIG_NET_SCH_SKBPRIO is not set
CONFIG_NET_SCH_CHOKE=m
CONFIG_NET_SCH_QFQ=m
CONFIG_NET_SCH_CODEL=m
CONFIG_NET_SCH_FQ_CODEL=y
# CONFIG_NET_SCH_CAKE is not set
CONFIG_NET_SCH_FQ=m
CONFIG_NET_SCH_HHF=m
CONFIG_NET_SCH_PIE=m
# CONFIG_NET_SCH_FQ_PIE is not set
CONFIG_NET_SCH_INGRESS=y
CONFIG_NET_SCH_PLUG=m
CONFIG_NET_SCH_ETS=m
CONFIG_NET_SCH_DEFAULT=y
# CONFIG_DEFAULT_FQ is not set
# CONFIG_DEFAULT_CODEL is not set
CONFIG_DEFAULT_FQ_CODEL=y
# CONFIG_DEFAULT_SFQ is not set
# CONFIG_DEFAULT_PFIFO_FAST is not set
CONFIG_DEFAULT_NET_SCH="fq_codel"

#
# Classification
#
CONFIG_NET_CLS=y
CONFIG_NET_CLS_BASIC=m
CONFIG_NET_CLS_TCINDEX=m
CONFIG_NET_CLS_ROUTE4=m
CONFIG_NET_CLS_FW=m
CONFIG_NET_CLS_U32=m
CONFIG_CLS_U32_PERF=y
CONFIG_CLS_U32_MARK=y
CONFIG_NET_CLS_RSVP=m
CONFIG_NET_CLS_RSVP6=m
CONFIG_NET_CLS_FLOW=m
CONFIG_NET_CLS_CGROUP=y
CONFIG_NET_CLS_BPF=m
CONFIG_NET_CLS_FLOWER=m
CONFIG_NET_CLS_MATCHALL=m
CONFIG_NET_EMATCH=y
CONFIG_NET_EMATCH_STACK=32
CONFIG_NET_EMATCH_CMP=m
CONFIG_NET_EMATCH_NBYTE=m
CONFIG_NET_EMATCH_U32=m
CONFIG_NET_EMATCH_META=m
CONFIG_NET_EMATCH_TEXT=m
CONFIG_NET_EMATCH_CANID=m
CONFIG_NET_EMATCH_IPSET=m
CONFIG_NET_EMATCH_IPT=m
CONFIG_NET_CLS_ACT=y
CONFIG_NET_ACT_POLICE=m
CONFIG_NET_ACT_GACT=m
CONFIG_GACT_PROB=y
CONFIG_NET_ACT_MIRRED=m
CONFIG_NET_ACT_SAMPLE=m
CONFIG_NET_ACT_IPT=m
CONFIG_NET_ACT_NAT=m
CONFIG_NET_ACT_PEDIT=m
CONFIG_NET_ACT_SIMP=m
CONFIG_NET_ACT_SKBEDIT=m
CONFIG_NET_ACT_CSUM=m
CONFIG_NET_ACT_MPLS=m
CONFIG_NET_ACT_VLAN=m
CONFIG_NET_ACT_BPF=m
CONFIG_NET_ACT_CONNMARK=m
CONFIG_NET_ACT_CTINFO=m
CONFIG_NET_ACT_SKBMOD=m
CONFIG_NET_ACT_IFE=m
CONFIG_NET_ACT_TUNNEL_KEY=m
CONFIG_NET_ACT_CT=m
# CONFIG_NET_ACT_GATE is not set
CONFIG_NET_IFE_SKBMARK=m
CONFIG_NET_IFE_SKBPRIO=m
CONFIG_NET_IFE_SKBTCINDEX=m
# CONFIG_NET_TC_SKB_EXT is not set
CONFIG_NET_SCH_FIFO=y
CONFIG_DCB=y
CONFIG_DNS_RESOLVER=m
# CONFIG_BATMAN_ADV is not set
CONFIG_OPENVSWITCH=m
CONFIG_OPENVSWITCH_GRE=m
CONFIG_OPENVSWITCH_VXLAN=m
CONFIG_OPENVSWITCH_GENEVE=m
CONFIG_VSOCKETS=m
CONFIG_VSOCKETS_DIAG=m
CONFIG_VSOCKETS_LOOPBACK=m
CONFIG_VMWARE_VMCI_VSOCKETS=m
CONFIG_VIRTIO_VSOCKETS=m
CONFIG_VIRTIO_VSOCKETS_COMMON=m
CONFIG_HYPERV_VSOCKETS=m
CONFIG_NETLINK_DIAG=m
CONFIG_MPLS=y
CONFIG_NET_MPLS_GSO=m
CONFIG_MPLS_ROUTING=m
CONFIG_MPLS_IPTUNNEL=m
CONFIG_NET_NSH=y
# CONFIG_HSR is not set
CONFIG_NET_SWITCHDEV=y
CONFIG_NET_L3_MASTER_DEV=y
# CONFIG_QRTR is not set
# CONFIG_NET_NCSI is not set
CONFIG_PCPU_DEV_REFCNT=y
CONFIG_RPS=y
CONFIG_RFS_ACCEL=y
CONFIG_SOCK_RX_QUEUE_MAPPING=y
CONFIG_XPS=y
CONFIG_CGROUP_NET_PRIO=y
CONFIG_CGROUP_NET_CLASSID=y
CONFIG_NET_RX_BUSY_POLL=y
CONFIG_BQL=y
CONFIG_BPF_STREAM_PARSER=y
CONFIG_NET_FLOW_LIMIT=y

#
# Network testing
#
CONFIG_NET_PKTGEN=m
CONFIG_NET_DROP_MONITOR=y
# end of Network testing
# end of Networking options

# CONFIG_HAMRADIO is not set
CONFIG_CAN=m
CONFIG_CAN_RAW=m
CONFIG_CAN_BCM=m
CONFIG_CAN_GW=m
# CONFIG_CAN_J1939 is not set
# CONFIG_CAN_ISOTP is not set

#
# CAN Device Drivers
#
CONFIG_CAN_VCAN=m
# CONFIG_CAN_VXCAN is not set
CONFIG_CAN_SLCAN=m
CONFIG_CAN_DEV=m
CONFIG_CAN_CALC_BITTIMING=y
# CONFIG_CAN_KVASER_PCIEFD is not set
CONFIG_CAN_C_CAN=m
CONFIG_CAN_C_CAN_PLATFORM=m
CONFIG_CAN_C_CAN_PCI=m
CONFIG_CAN_CC770=m
# CONFIG_CAN_CC770_ISA is not set
CONFIG_CAN_CC770_PLATFORM=m
# CONFIG_CAN_IFI_CANFD is not set
# CONFIG_CAN_M_CAN is not set
# CONFIG_CAN_PEAK_PCIEFD is not set
CONFIG_CAN_SJA1000=m
CONFIG_CAN_EMS_PCI=m
# CONFIG_CAN_F81601 is not set
CONFIG_CAN_KVASER_PCI=m
CONFIG_CAN_PEAK_PCI=m
CONFIG_CAN_PEAK_PCIEC=y
CONFIG_CAN_PLX_PCI=m
# CONFIG_CAN_SJA1000_ISA is not set
CONFIG_CAN_SJA1000_PLATFORM=m
CONFIG_CAN_SOFTING=m

#
# CAN SPI interfaces
#
# CONFIG_CAN_HI311X is not set
# CONFIG_CAN_MCP251X is not set
# CONFIG_CAN_MCP251XFD is not set
# end of CAN SPI interfaces

#
# CAN USB interfaces
#
# CONFIG_CAN_8DEV_USB is not set
# CONFIG_CAN_EMS_USB is not set
# CONFIG_CAN_ESD_USB2 is not set
# CONFIG_CAN_ETAS_ES58X is not set
# CONFIG_CAN_GS_USB is not set
# CONFIG_CAN_KVASER_USB is not set
# CONFIG_CAN_MCBA_USB is not set
# CONFIG_CAN_PEAK_USB is not set
# CONFIG_CAN_UCAN is not set
# end of CAN USB interfaces

# CONFIG_CAN_DEBUG_DEVICES is not set
# end of CAN Device Drivers

CONFIG_BT=m
CONFIG_BT_BREDR=y
CONFIG_BT_RFCOMM=m
CONFIG_BT_RFCOMM_TTY=y
CONFIG_BT_BNEP=m
CONFIG_BT_BNEP_MC_FILTER=y
CONFIG_BT_BNEP_PROTO_FILTER=y
CONFIG_BT_HIDP=m
CONFIG_BT_HS=y
CONFIG_BT_LE=y
# CONFIG_BT_6LOWPAN is not set
# CONFIG_BT_LEDS is not set
# CONFIG_BT_MSFTEXT is not set
# CONFIG_BT_AOSPEXT is not set
CONFIG_BT_DEBUGFS=y
# CONFIG_BT_SELFTEST is not set

#
# Bluetooth device drivers
#
# CONFIG_BT_HCIBTUSB is not set
# CONFIG_BT_HCIBTSDIO is not set
CONFIG_BT_HCIUART=m
CONFIG_BT_HCIUART_H4=y
CONFIG_BT_HCIUART_BCSP=y
CONFIG_BT_HCIUART_ATH3K=y
# CONFIG_BT_HCIUART_INTEL is not set
# CONFIG_BT_HCIUART_AG6XX is not set
# CONFIG_BT_HCIBCM203X is not set
# CONFIG_BT_HCIBPA10X is not set
# CONFIG_BT_HCIBFUSB is not set
CONFIG_BT_HCIVHCI=m
CONFIG_BT_MRVL=m
# CONFIG_BT_MRVL_SDIO is not set
# CONFIG_BT_MTKSDIO is not set
# CONFIG_BT_VIRTIO is not set
# end of Bluetooth device drivers

# CONFIG_AF_RXRPC is not set
# CONFIG_AF_KCM is not set
CONFIG_STREAM_PARSER=y
# CONFIG_MCTP is not set
CONFIG_FIB_RULES=y
CONFIG_WIRELESS=y
CONFIG_CFG80211=m
# CONFIG_NL80211_TESTMODE is not set
# CONFIG_CFG80211_DEVELOPER_WARNINGS is not set
# CONFIG_CFG80211_CERTIFICATION_ONUS is not set
CONFIG_CFG80211_REQUIRE_SIGNED_REGDB=y
CONFIG_CFG80211_USE_KERNEL_REGDB_KEYS=y
CONFIG_CFG80211_DEFAULT_PS=y
# CONFIG_CFG80211_DEBUGFS is not set
CONFIG_CFG80211_CRDA_SUPPORT=y
# CONFIG_CFG80211_WEXT is not set
CONFIG_MAC80211=m
CONFIG_MAC80211_HAS_RC=y
CONFIG_MAC80211_RC_MINSTREL=y
CONFIG_MAC80211_RC_DEFAULT_MINSTREL=y
CONFIG_MAC80211_RC_DEFAULT="minstrel_ht"
# CONFIG_MAC80211_MESH is not set
CONFIG_MAC80211_LEDS=y
CONFIG_MAC80211_DEBUGFS=y
# CONFIG_MAC80211_MESSAGE_TRACING is not set
# CONFIG_MAC80211_DEBUG_MENU is not set
CONFIG_MAC80211_STA_HASH_MAX_SIZE=0
CONFIG_RFKILL=m
CONFIG_RFKILL_LEDS=y
CONFIG_RFKILL_INPUT=y
# CONFIG_RFKILL_GPIO is not set
CONFIG_NET_9P=y
CONFIG_NET_9P_VIRTIO=y
# CONFIG_NET_9P_DEBUG is not set
# CONFIG_CAIF is not set
CONFIG_CEPH_LIB=m
# CONFIG_CEPH_LIB_PRETTYDEBUG is not set
CONFIG_CEPH_LIB_USE_DNS_RESOLVER=y
CONFIG_NFC=m
# CONFIG_NFC_DIGITAL is not set
CONFIG_NFC_NCI=m
# CONFIG_NFC_NCI_SPI is not set
# CONFIG_NFC_NCI_UART is not set
# CONFIG_NFC_HCI is not set

#
# Near Field Communication (NFC) devices
#
CONFIG_NFC_VIRTUAL_NCI=m
# CONFIG_NFC_FDP is not set
# CONFIG_NFC_PN533_USB is not set
# CONFIG_NFC_PN533_I2C is not set
# CONFIG_NFC_MRVL_USB is not set
# CONFIG_NFC_ST_NCI_I2C is not set
# CONFIG_NFC_ST_NCI_SPI is not set
# CONFIG_NFC_NXP_NCI is not set
# CONFIG_NFC_S3FWRN5_I2C is not set
# end of Near Field Communication (NFC) devices

CONFIG_PSAMPLE=m
CONFIG_NET_IFE=m
CONFIG_LWTUNNEL=y
CONFIG_LWTUNNEL_BPF=y
CONFIG_DST_CACHE=y
CONFIG_GRO_CELLS=y
CONFIG_SOCK_VALIDATE_XMIT=y
CONFIG_NET_SELFTESTS=y
CONFIG_NET_SOCK_MSG=y
CONFIG_NET_DEVLINK=y
CONFIG_FAILOVER=m
CONFIG_ETHTOOL_NETLINK=y

#
# Device Drivers
#
CONFIG_HAVE_EISA=y
# CONFIG_EISA is not set
CONFIG_HAVE_PCI=y
CONFIG_PCI=y
CONFIG_PCI_DOMAINS=y
CONFIG_PCIEPORTBUS=y
CONFIG_HOTPLUG_PCI_PCIE=y
CONFIG_PCIEAER=y
CONFIG_PCIEAER_INJECT=m
CONFIG_PCIE_ECRC=y
CONFIG_PCIEASPM=y
CONFIG_PCIEASPM_DEFAULT=y
# CONFIG_PCIEASPM_POWERSAVE is not set
# CONFIG_PCIEASPM_POWER_SUPERSAVE is not set
# CONFIG_PCIEASPM_PERFORMANCE is not set
CONFIG_PCIE_PME=y
CONFIG_PCIE_DPC=y
# CONFIG_PCIE_PTM is not set
# CONFIG_PCIE_EDR is not set
CONFIG_PCI_MSI=y
CONFIG_PCI_MSI_IRQ_DOMAIN=y
CONFIG_PCI_QUIRKS=y
# CONFIG_PCI_DEBUG is not set
# CONFIG_PCI_REALLOC_ENABLE_AUTO is not set
CONFIG_PCI_STUB=y
CONFIG_PCI_PF_STUB=m
CONFIG_PCI_ATS=y
CONFIG_PCI_LOCKLESS_CONFIG=y
CONFIG_PCI_IOV=y
CONFIG_PCI_PRI=y
CONFIG_PCI_PASID=y
# CONFIG_PCI_P2PDMA is not set
CONFIG_PCI_LABEL=y
CONFIG_PCI_HYPERV=m
# CONFIG_PCIE_BUS_TUNE_OFF is not set
CONFIG_PCIE_BUS_DEFAULT=y
# CONFIG_PCIE_BUS_SAFE is not set
# CONFIG_PCIE_BUS_PERFORMANCE is not set
# CONFIG_PCIE_BUS_PEER2PEER is not set
CONFIG_HOTPLUG_PCI=y
CONFIG_HOTPLUG_PCI_ACPI=y
CONFIG_HOTPLUG_PCI_ACPI_IBM=m
# CONFIG_HOTPLUG_PCI_CPCI is not set
CONFIG_HOTPLUG_PCI_SHPC=y

#
# PCI controller drivers
#
CONFIG_VMD=y
CONFIG_PCI_HYPERV_INTERFACE=m

#
# DesignWare PCI Core Support
#
# CONFIG_PCIE_DW_PLAT_HOST is not set
# CONFIG_PCI_MESON is not set
# end of DesignWare PCI Core Support

#
# Mobiveil PCIe Core Support
#
# end of Mobiveil PCIe Core Support

#
# Cadence PCIe controllers support
#
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
# CONFIG_PCI_SW_SWITCHTEC is not set
# end of PCI switch controller drivers

# CONFIG_CXL_BUS is not set
# CONFIG_PCCARD is not set
# CONFIG_RAPIDIO is not set

#
# Generic Driver Options
#
CONFIG_AUXILIARY_BUS=y
# CONFIG_UEVENT_HELPER is not set
CONFIG_DEVTMPFS=y
CONFIG_DEVTMPFS_MOUNT=y
CONFIG_STANDALONE=y
CONFIG_PREVENT_FIRMWARE_BUILD=y

#
# Firmware loader
#
CONFIG_FW_LOADER=y
CONFIG_FW_LOADER_PAGED_BUF=y
CONFIG_EXTRA_FIRMWARE=""
CONFIG_FW_LOADER_USER_HELPER=y
# CONFIG_FW_LOADER_USER_HELPER_FALLBACK is not set
# CONFIG_FW_LOADER_COMPRESS is not set
CONFIG_FW_CACHE=y
# end of Firmware loader

CONFIG_ALLOW_DEV_COREDUMP=y
# CONFIG_DEBUG_DRIVER is not set
# CONFIG_DEBUG_DEVRES is not set
# CONFIG_DEBUG_TEST_DRIVER_REMOVE is not set
# CONFIG_TEST_ASYNC_DRIVER_PROBE is not set
CONFIG_GENERIC_CPU_AUTOPROBE=y
CONFIG_GENERIC_CPU_VULNERABILITIES=y
CONFIG_REGMAP=y
CONFIG_REGMAP_I2C=m
CONFIG_REGMAP_SPI=m
CONFIG_DMA_SHARED_BUFFER=y
# CONFIG_DMA_FENCE_TRACE is not set
# end of Generic Driver Options

#
# Bus devices
#
# CONFIG_MHI_BUS is not set
# end of Bus devices

CONFIG_CONNECTOR=y
CONFIG_PROC_EVENTS=y

#
# Firmware Drivers
#

#
# ARM System Control and Management Interface Protocol
#
# end of ARM System Control and Management Interface Protocol

CONFIG_EDD=m
# CONFIG_EDD_OFF is not set
CONFIG_FIRMWARE_MEMMAP=y
CONFIG_DMIID=y
CONFIG_DMI_SYSFS=y
CONFIG_DMI_SCAN_MACHINE_NON_EFI_FALLBACK=y
# CONFIG_ISCSI_IBFT is not set
CONFIG_FW_CFG_SYSFS=y
# CONFIG_FW_CFG_SYSFS_CMDLINE is not set
CONFIG_SYSFB=y
# CONFIG_SYSFB_SIMPLEFB is not set
# CONFIG_GOOGLE_FIRMWARE is not set

#
# EFI (Extensible Firmware Interface) Support
#
CONFIG_EFI_VARS=y
CONFIG_EFI_ESRT=y
CONFIG_EFI_VARS_PSTORE=y
CONFIG_EFI_VARS_PSTORE_DEFAULT_DISABLE=y
CONFIG_EFI_RUNTIME_MAP=y
# CONFIG_EFI_FAKE_MEMMAP is not set
CONFIG_EFI_RUNTIME_WRAPPERS=y
CONFIG_EFI_GENERIC_STUB_INITRD_CMDLINE_LOADER=y
# CONFIG_EFI_BOOTLOADER_CONTROL is not set
# CONFIG_EFI_CAPSULE_LOADER is not set
# CONFIG_EFI_TEST is not set
CONFIG_APPLE_PROPERTIES=y
# CONFIG_RESET_ATTACK_MITIGATION is not set
# CONFIG_EFI_RCI2_TABLE is not set
# CONFIG_EFI_DISABLE_PCI_DMA is not set
# end of EFI (Extensible Firmware Interface) Support

CONFIG_UEFI_CPER=y
CONFIG_UEFI_CPER_X86=y
CONFIG_EFI_DEV_PATH_PARSER=y
CONFIG_EFI_EARLYCON=y
CONFIG_EFI_CUSTOM_SSDT_OVERLAYS=y

#
# Tegra firmware driver
#
# end of Tegra firmware driver
# end of Firmware Drivers

# CONFIG_GNSS is not set
# CONFIG_MTD is not set
# CONFIG_OF is not set
CONFIG_ARCH_MIGHT_HAVE_PC_PARPORT=y
CONFIG_PARPORT=m
CONFIG_PARPORT_PC=m
CONFIG_PARPORT_SERIAL=m
# CONFIG_PARPORT_PC_FIFO is not set
# CONFIG_PARPORT_PC_SUPERIO is not set
# CONFIG_PARPORT_AX88796 is not set
CONFIG_PARPORT_1284=y
CONFIG_PNP=y
# CONFIG_PNP_DEBUG_MESSAGES is not set

#
# Protocols
#
CONFIG_PNPACPI=y
CONFIG_BLK_DEV=y
CONFIG_BLK_DEV_NULL_BLK=m
# CONFIG_BLK_DEV_FD is not set
CONFIG_CDROM=m
# CONFIG_PARIDE is not set
# CONFIG_BLK_DEV_PCIESSD_MTIP32XX is not set
CONFIG_ZRAM=m
CONFIG_ZRAM_DEF_COMP_LZORLE=y
# CONFIG_ZRAM_DEF_COMP_LZO is not set
CONFIG_ZRAM_DEF_COMP="lzo-rle"
CONFIG_ZRAM_WRITEBACK=y
# CONFIG_ZRAM_MEMORY_TRACKING is not set
CONFIG_BLK_DEV_LOOP=y
CONFIG_BLK_DEV_LOOP_MIN_COUNT=0
# CONFIG_BLK_DEV_CRYPTOLOOP is not set
# CONFIG_BLK_DEV_DRBD is not set
CONFIG_BLK_DEV_NBD=m
# CONFIG_BLK_DEV_SX8 is not set
CONFIG_BLK_DEV_RAM=m
CONFIG_BLK_DEV_RAM_COUNT=16
CONFIG_BLK_DEV_RAM_SIZE=16384
CONFIG_CDROM_PKTCDVD=m
CONFIG_CDROM_PKTCDVD_BUFFERS=8
# CONFIG_CDROM_PKTCDVD_WCACHE is not set
# CONFIG_ATA_OVER_ETH is not set
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
CONFIG_NVME_FABRICS=m
CONFIG_NVME_FC=m
# CONFIG_NVME_TCP is not set
CONFIG_NVME_TARGET=m
# CONFIG_NVME_TARGET_PASSTHRU is not set
CONFIG_NVME_TARGET_LOOP=m
CONFIG_NVME_TARGET_FC=m
CONFIG_NVME_TARGET_FCLOOP=m
# CONFIG_NVME_TARGET_TCP is not set
# end of NVME Support

#
# Misc devices
#
CONFIG_SENSORS_LIS3LV02D=m
# CONFIG_AD525X_DPOT is not set
# CONFIG_DUMMY_IRQ is not set
# CONFIG_IBM_ASM is not set
# CONFIG_PHANTOM is not set
CONFIG_TIFM_CORE=m
CONFIG_TIFM_7XX1=m
# CONFIG_ICS932S401 is not set
CONFIG_ENCLOSURE_SERVICES=m
CONFIG_SGI_XP=m
CONFIG_HP_ILO=m
CONFIG_SGI_GRU=m
# CONFIG_SGI_GRU_DEBUG is not set
CONFIG_APDS9802ALS=m
CONFIG_ISL29003=m
CONFIG_ISL29020=m
CONFIG_SENSORS_TSL2550=m
CONFIG_SENSORS_BH1770=m
CONFIG_SENSORS_APDS990X=m
# CONFIG_HMC6352 is not set
# CONFIG_DS1682 is not set
CONFIG_VMWARE_BALLOON=m
# CONFIG_LATTICE_ECP3_CONFIG is not set
# CONFIG_SRAM is not set
# CONFIG_DW_XDATA_PCIE is not set
# CONFIG_PCI_ENDPOINT_TEST is not set
# CONFIG_XILINX_SDFEC is not set
CONFIG_MISC_RTSX=m
# CONFIG_C2PORT is not set

#
# EEPROM support
#
# CONFIG_EEPROM_AT24 is not set
# CONFIG_EEPROM_AT25 is not set
CONFIG_EEPROM_LEGACY=m
CONFIG_EEPROM_MAX6875=m
CONFIG_EEPROM_93CX6=m
# CONFIG_EEPROM_93XX46 is not set
# CONFIG_EEPROM_IDT_89HPESX is not set
# CONFIG_EEPROM_EE1004 is not set
# end of EEPROM support

CONFIG_CB710_CORE=m
# CONFIG_CB710_DEBUG is not set
CONFIG_CB710_DEBUG_ASSUMPTIONS=y

#
# Texas Instruments shared transport line discipline
#
# CONFIG_TI_ST is not set
# end of Texas Instruments shared transport line discipline

CONFIG_SENSORS_LIS3_I2C=m
CONFIG_ALTERA_STAPL=m
CONFIG_INTEL_MEI=m
CONFIG_INTEL_MEI_ME=m
# CONFIG_INTEL_MEI_TXE is not set
# CONFIG_INTEL_MEI_HDCP is not set
CONFIG_VMWARE_VMCI=m
# CONFIG_GENWQE is not set
# CONFIG_ECHO is not set
# CONFIG_BCM_VK is not set
# CONFIG_MISC_ALCOR_PCI is not set
CONFIG_MISC_RTSX_PCI=m
# CONFIG_MISC_RTSX_USB is not set
# CONFIG_HABANA_AI is not set
# CONFIG_UACCE is not set
CONFIG_PVPANIC=y
# CONFIG_PVPANIC_MMIO is not set
# CONFIG_PVPANIC_PCI is not set
# end of Misc devices

#
# SCSI device support
#
CONFIG_SCSI_MOD=y
CONFIG_RAID_ATTRS=m
CONFIG_SCSI_COMMON=y
CONFIG_SCSI=y
CONFIG_SCSI_DMA=y
CONFIG_SCSI_NETLINK=y
CONFIG_SCSI_PROC_FS=y

#
# SCSI support type (disk, tape, CD-ROM)
#
CONFIG_BLK_DEV_SD=m
CONFIG_CHR_DEV_ST=m
CONFIG_BLK_DEV_SR=m
CONFIG_CHR_DEV_SG=m
CONFIG_BLK_DEV_BSG=y
CONFIG_CHR_DEV_SCH=m
CONFIG_SCSI_ENCLOSURE=m
CONFIG_SCSI_CONSTANTS=y
CONFIG_SCSI_LOGGING=y
CONFIG_SCSI_SCAN_ASYNC=y

#
# SCSI Transports
#
CONFIG_SCSI_SPI_ATTRS=m
CONFIG_SCSI_FC_ATTRS=m
CONFIG_SCSI_ISCSI_ATTRS=m
CONFIG_SCSI_SAS_ATTRS=m
CONFIG_SCSI_SAS_LIBSAS=m
CONFIG_SCSI_SAS_ATA=y
CONFIG_SCSI_SAS_HOST_SMP=y
CONFIG_SCSI_SRP_ATTRS=m
# end of SCSI Transports

CONFIG_SCSI_LOWLEVEL=y
# CONFIG_ISCSI_TCP is not set
# CONFIG_ISCSI_BOOT_SYSFS is not set
# CONFIG_SCSI_CXGB3_ISCSI is not set
# CONFIG_SCSI_CXGB4_ISCSI is not set
# CONFIG_SCSI_BNX2_ISCSI is not set
# CONFIG_BE2ISCSI is not set
# CONFIG_BLK_DEV_3W_XXXX_RAID is not set
# CONFIG_SCSI_HPSA is not set
# CONFIG_SCSI_3W_9XXX is not set
# CONFIG_SCSI_3W_SAS is not set
# CONFIG_SCSI_ACARD is not set
# CONFIG_SCSI_AACRAID is not set
# CONFIG_SCSI_AIC7XXX is not set
# CONFIG_SCSI_AIC79XX is not set
# CONFIG_SCSI_AIC94XX is not set
# CONFIG_SCSI_MVSAS is not set
# CONFIG_SCSI_MVUMI is not set
# CONFIG_SCSI_DPT_I2O is not set
# CONFIG_SCSI_ADVANSYS is not set
# CONFIG_SCSI_ARCMSR is not set
# CONFIG_SCSI_ESAS2R is not set
# CONFIG_MEGARAID_NEWGEN is not set
# CONFIG_MEGARAID_LEGACY is not set
# CONFIG_MEGARAID_SAS is not set
CONFIG_SCSI_MPT3SAS=m
CONFIG_SCSI_MPT2SAS_MAX_SGE=128
CONFIG_SCSI_MPT3SAS_MAX_SGE=128
# CONFIG_SCSI_MPT2SAS is not set
# CONFIG_SCSI_MPI3MR is not set
# CONFIG_SCSI_SMARTPQI is not set
# CONFIG_SCSI_UFSHCD is not set
# CONFIG_SCSI_HPTIOP is not set
# CONFIG_SCSI_BUSLOGIC is not set
# CONFIG_SCSI_MYRB is not set
# CONFIG_SCSI_MYRS is not set
# CONFIG_VMWARE_PVSCSI is not set
CONFIG_HYPERV_STORAGE=m
# CONFIG_LIBFC is not set
# CONFIG_SCSI_SNIC is not set
# CONFIG_SCSI_DMX3191D is not set
# CONFIG_SCSI_FDOMAIN_PCI is not set
CONFIG_SCSI_ISCI=m
# CONFIG_SCSI_IPS is not set
# CONFIG_SCSI_INITIO is not set
# CONFIG_SCSI_INIA100 is not set
# CONFIG_SCSI_PPA is not set
# CONFIG_SCSI_IMM is not set
# CONFIG_SCSI_STEX is not set
# CONFIG_SCSI_SYM53C8XX_2 is not set
# CONFIG_SCSI_IPR is not set
# CONFIG_SCSI_QLOGIC_1280 is not set
# CONFIG_SCSI_QLA_FC is not set
# CONFIG_SCSI_QLA_ISCSI is not set
# CONFIG_SCSI_LPFC is not set
# CONFIG_SCSI_EFCT is not set
# CONFIG_SCSI_DC395x is not set
# CONFIG_SCSI_AM53C974 is not set
# CONFIG_SCSI_WD719X is not set
# CONFIG_SCSI_DEBUG is not set
# CONFIG_SCSI_PMCRAID is not set
# CONFIG_SCSI_PM8001 is not set
# CONFIG_SCSI_BFA_FC is not set
# CONFIG_SCSI_VIRTIO is not set
# CONFIG_SCSI_CHELSIO_FCOE is not set
CONFIG_SCSI_DH=y
CONFIG_SCSI_DH_RDAC=y
CONFIG_SCSI_DH_HP_SW=y
CONFIG_SCSI_DH_EMC=y
CONFIG_SCSI_DH_ALUA=y
# end of SCSI device support

CONFIG_ATA=m
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
CONFIG_SATA_AHCI=m
CONFIG_SATA_MOBILE_LPM_POLICY=0
CONFIG_SATA_AHCI_PLATFORM=m
# CONFIG_SATA_INIC162X is not set
# CONFIG_SATA_ACARD_AHCI is not set
# CONFIG_SATA_SIL24 is not set
CONFIG_ATA_SFF=y

#
# SFF controllers with custom DMA interface
#
# CONFIG_PDC_ADMA is not set
# CONFIG_SATA_QSTOR is not set
# CONFIG_SATA_SX4 is not set
CONFIG_ATA_BMDMA=y

#
# SATA SFF controllers with BMDMA
#
CONFIG_ATA_PIIX=m
# CONFIG_SATA_DWC is not set
# CONFIG_SATA_MV is not set
# CONFIG_SATA_NV is not set
# CONFIG_SATA_PROMISE is not set
# CONFIG_SATA_SIL is not set
# CONFIG_SATA_SIS is not set
# CONFIG_SATA_SVW is not set
# CONFIG_SATA_ULI is not set
# CONFIG_SATA_VIA is not set
# CONFIG_SATA_VITESSE is not set

#
# PATA SFF controllers with BMDMA
#
# CONFIG_PATA_ALI is not set
# CONFIG_PATA_AMD is not set
# CONFIG_PATA_ARTOP is not set
# CONFIG_PATA_ATIIXP is not set
# CONFIG_PATA_ATP867X is not set
# CONFIG_PATA_CMD64X is not set
# CONFIG_PATA_CYPRESS is not set
# CONFIG_PATA_EFAR is not set
# CONFIG_PATA_HPT366 is not set
# CONFIG_PATA_HPT37X is not set
# CONFIG_PATA_HPT3X2N is not set
# CONFIG_PATA_HPT3X3 is not set
# CONFIG_PATA_IT8213 is not set
# CONFIG_PATA_IT821X is not set
# CONFIG_PATA_JMICRON is not set
# CONFIG_PATA_MARVELL is not set
# CONFIG_PATA_NETCELL is not set
# CONFIG_PATA_NINJA32 is not set
# CONFIG_PATA_NS87415 is not set
# CONFIG_PATA_OLDPIIX is not set
# CONFIG_PATA_OPTIDMA is not set
# CONFIG_PATA_PDC2027X is not set
# CONFIG_PATA_PDC_OLD is not set
# CONFIG_PATA_RADISYS is not set
# CONFIG_PATA_RDC is not set
# CONFIG_PATA_SCH is not set
# CONFIG_PATA_SERVERWORKS is not set
# CONFIG_PATA_SIL680 is not set
# CONFIG_PATA_SIS is not set
# CONFIG_PATA_TOSHIBA is not set
# CONFIG_PATA_TRIFLEX is not set
# CONFIG_PATA_VIA is not set
# CONFIG_PATA_WINBOND is not set

#
# PIO-only SFF controllers
#
# CONFIG_PATA_CMD640_PCI is not set
# CONFIG_PATA_MPIIX is not set
# CONFIG_PATA_NS87410 is not set
# CONFIG_PATA_OPTI is not set
# CONFIG_PATA_PLATFORM is not set
# CONFIG_PATA_RZ1000 is not set

#
# Generic fallback / legacy drivers
#
# CONFIG_PATA_ACPI is not set
CONFIG_ATA_GENERIC=m
# CONFIG_PATA_LEGACY is not set
CONFIG_MD=y
CONFIG_BLK_DEV_MD=y
CONFIG_MD_AUTODETECT=y
CONFIG_MD_LINEAR=m
CONFIG_MD_RAID0=m
CONFIG_MD_RAID1=m
CONFIG_MD_RAID10=m
CONFIG_MD_RAID456=m
# CONFIG_MD_MULTIPATH is not set
CONFIG_MD_FAULTY=m
CONFIG_MD_CLUSTER=m
# CONFIG_BCACHE is not set
CONFIG_BLK_DEV_DM_BUILTIN=y
CONFIG_BLK_DEV_DM=m
CONFIG_DM_DEBUG=y
CONFIG_DM_BUFIO=m
# CONFIG_DM_DEBUG_BLOCK_MANAGER_LOCKING is not set
CONFIG_DM_BIO_PRISON=m
CONFIG_DM_PERSISTENT_DATA=m
# CONFIG_DM_UNSTRIPED is not set
CONFIG_DM_CRYPT=m
CONFIG_DM_SNAPSHOT=m
CONFIG_DM_THIN_PROVISIONING=m
CONFIG_DM_CACHE=m
CONFIG_DM_CACHE_SMQ=m
CONFIG_DM_WRITECACHE=m
# CONFIG_DM_EBS is not set
CONFIG_DM_ERA=m
# CONFIG_DM_CLONE is not set
CONFIG_DM_MIRROR=m
CONFIG_DM_LOG_USERSPACE=m
CONFIG_DM_RAID=m
CONFIG_DM_ZERO=m
CONFIG_DM_MULTIPATH=m
CONFIG_DM_MULTIPATH_QL=m
CONFIG_DM_MULTIPATH_ST=m
# CONFIG_DM_MULTIPATH_HST is not set
# CONFIG_DM_MULTIPATH_IOA is not set
CONFIG_DM_DELAY=m
# CONFIG_DM_DUST is not set
CONFIG_DM_UEVENT=y
CONFIG_DM_FLAKEY=m
CONFIG_DM_VERITY=m
# CONFIG_DM_VERITY_VERIFY_ROOTHASH_SIG is not set
# CONFIG_DM_VERITY_FEC is not set
CONFIG_DM_SWITCH=m
CONFIG_DM_LOG_WRITES=m
CONFIG_DM_INTEGRITY=m
CONFIG_TARGET_CORE=m
CONFIG_TCM_IBLOCK=m
CONFIG_TCM_FILEIO=m
CONFIG_TCM_PSCSI=m
CONFIG_TCM_USER2=m
CONFIG_LOOPBACK_TARGET=m
CONFIG_ISCSI_TARGET=m
# CONFIG_SBP_TARGET is not set
# CONFIG_FUSION is not set

#
# IEEE 1394 (FireWire) support
#
CONFIG_FIREWIRE=m
CONFIG_FIREWIRE_OHCI=m
CONFIG_FIREWIRE_SBP2=m
CONFIG_FIREWIRE_NET=m
# CONFIG_FIREWIRE_NOSY is not set
# end of IEEE 1394 (FireWire) support

CONFIG_MACINTOSH_DRIVERS=y
CONFIG_MAC_EMUMOUSEBTN=y
CONFIG_NETDEVICES=y
CONFIG_MII=y
CONFIG_NET_CORE=y
# CONFIG_BONDING is not set
CONFIG_DUMMY=y
# CONFIG_WIREGUARD is not set
# CONFIG_EQUALIZER is not set
# CONFIG_NET_FC is not set
CONFIG_IFB=m
# CONFIG_NET_TEAM is not set
# CONFIG_MACVLAN is not set
# CONFIG_IPVLAN is not set
CONFIG_VXLAN=y
CONFIG_GENEVE=y
CONFIG_BAREUDP=m
# CONFIG_GTP is not set
CONFIG_AMT=m
CONFIG_MACSEC=y
CONFIG_NETCONSOLE=m
CONFIG_NETCONSOLE_DYNAMIC=y
CONFIG_NETPOLL=y
CONFIG_NET_POLL_CONTROLLER=y
CONFIG_TUN=m
# CONFIG_TUN_VNET_CROSS_LE is not set
CONFIG_VETH=y
CONFIG_VIRTIO_NET=m
# CONFIG_NLMON is not set
CONFIG_NET_VRF=y
# CONFIG_VSOCKMON is not set
# CONFIG_ARCNET is not set
CONFIG_ATM_DRIVERS=y
# CONFIG_ATM_DUMMY is not set
# CONFIG_ATM_TCP is not set
# CONFIG_ATM_LANAI is not set
# CONFIG_ATM_ENI is not set
# CONFIG_ATM_FIRESTREAM is not set
# CONFIG_ATM_ZATM is not set
# CONFIG_ATM_NICSTAR is not set
# CONFIG_ATM_IDT77252 is not set
# CONFIG_ATM_AMBASSADOR is not set
# CONFIG_ATM_HORIZON is not set
# CONFIG_ATM_IA is not set
# CONFIG_ATM_FORE200E is not set
# CONFIG_ATM_HE is not set
# CONFIG_ATM_SOLOS is not set
CONFIG_ETHERNET=y
CONFIG_MDIO=y
# CONFIG_NET_VENDOR_3COM is not set
CONFIG_NET_VENDOR_ADAPTEC=y
# CONFIG_ADAPTEC_STARFIRE is not set
CONFIG_NET_VENDOR_AGERE=y
# CONFIG_ET131X is not set
CONFIG_NET_VENDOR_ALACRITECH=y
# CONFIG_SLICOSS is not set
CONFIG_NET_VENDOR_ALTEON=y
# CONFIG_ACENIC is not set
# CONFIG_ALTERA_TSE is not set
CONFIG_NET_VENDOR_AMAZON=y
# CONFIG_ENA_ETHERNET is not set
CONFIG_NET_VENDOR_AMD=y
# CONFIG_AMD8111_ETH is not set
# CONFIG_PCNET32 is not set
# CONFIG_AMD_XGBE is not set
CONFIG_NET_VENDOR_AQUANTIA=y
# CONFIG_AQTION is not set
CONFIG_NET_VENDOR_ARC=y
CONFIG_NET_VENDOR_ASIX=y
# CONFIG_SPI_AX88796C is not set
CONFIG_NET_VENDOR_ATHEROS=y
# CONFIG_ATL2 is not set
# CONFIG_ATL1 is not set
# CONFIG_ATL1E is not set
# CONFIG_ATL1C is not set
# CONFIG_ALX is not set
CONFIG_NET_VENDOR_BROADCOM=y
# CONFIG_B44 is not set
# CONFIG_BCMGENET is not set
# CONFIG_BNX2 is not set
# CONFIG_CNIC is not set
# CONFIG_TIGON3 is not set
# CONFIG_BNX2X is not set
# CONFIG_SYSTEMPORT is not set
# CONFIG_BNXT is not set
CONFIG_NET_VENDOR_BROCADE=y
# CONFIG_BNA is not set
CONFIG_NET_VENDOR_CADENCE=y
# CONFIG_MACB is not set
CONFIG_NET_VENDOR_CAVIUM=y
# CONFIG_THUNDER_NIC_PF is not set
# CONFIG_THUNDER_NIC_VF is not set
# CONFIG_THUNDER_NIC_BGX is not set
# CONFIG_THUNDER_NIC_RGX is not set
CONFIG_CAVIUM_PTP=y
# CONFIG_LIQUIDIO is not set
# CONFIG_LIQUIDIO_VF is not set
CONFIG_NET_VENDOR_CHELSIO=y
# CONFIG_CHELSIO_T1 is not set
# CONFIG_CHELSIO_T3 is not set
# CONFIG_CHELSIO_T4 is not set
# CONFIG_CHELSIO_T4VF is not set
CONFIG_NET_VENDOR_CISCO=y
# CONFIG_ENIC is not set
CONFIG_NET_VENDOR_CORTINA=y
# CONFIG_CX_ECAT is not set
# CONFIG_DNET is not set
CONFIG_NET_VENDOR_DEC=y
# CONFIG_NET_TULIP is not set
CONFIG_NET_VENDOR_DLINK=y
# CONFIG_DL2K is not set
# CONFIG_SUNDANCE is not set
CONFIG_NET_VENDOR_EMULEX=y
# CONFIG_BE2NET is not set
CONFIG_NET_VENDOR_EZCHIP=y
CONFIG_NET_VENDOR_GOOGLE=y
# CONFIG_GVE is not set
CONFIG_NET_VENDOR_HUAWEI=y
# CONFIG_HINIC is not set
CONFIG_NET_VENDOR_I825XX=y
CONFIG_NET_VENDOR_INTEL=y
# CONFIG_E100 is not set
CONFIG_E1000=y
CONFIG_E1000E=y
CONFIG_E1000E_HWTS=y
CONFIG_IGB=y
CONFIG_IGB_HWMON=y
# CONFIG_IGBVF is not set
# CONFIG_IXGB is not set
CONFIG_IXGBE=y
CONFIG_IXGBE_HWMON=y
# CONFIG_IXGBE_DCB is not set
CONFIG_IXGBE_IPSEC=y
# CONFIG_IXGBEVF is not set
CONFIG_I40E=y
# CONFIG_I40E_DCB is not set
# CONFIG_I40EVF is not set
# CONFIG_ICE is not set
# CONFIG_FM10K is not set
CONFIG_IGC=y
CONFIG_NET_VENDOR_MICROSOFT=y
# CONFIG_MICROSOFT_MANA is not set
# CONFIG_JME is not set
CONFIG_NET_VENDOR_LITEX=y
CONFIG_NET_VENDOR_MARVELL=y
# CONFIG_MVMDIO is not set
# CONFIG_SKGE is not set
# CONFIG_SKY2 is not set
# CONFIG_PRESTERA is not set
CONFIG_NET_VENDOR_MELLANOX=y
# CONFIG_MLX4_EN is not set
# CONFIG_MLX5_CORE is not set
# CONFIG_MLXSW_CORE is not set
# CONFIG_MLXFW is not set
CONFIG_NET_VENDOR_MICREL=y
# CONFIG_KS8842 is not set
# CONFIG_KS8851 is not set
# CONFIG_KS8851_MLL is not set
# CONFIG_KSZ884X_PCI is not set
CONFIG_NET_VENDOR_MICROCHIP=y
# CONFIG_ENC28J60 is not set
# CONFIG_ENCX24J600 is not set
# CONFIG_LAN743X is not set
CONFIG_NET_VENDOR_MICROSEMI=y
CONFIG_NET_VENDOR_MYRI=y
# CONFIG_MYRI10GE is not set
# CONFIG_FEALNX is not set
CONFIG_NET_VENDOR_NATSEMI=y
# CONFIG_NATSEMI is not set
# CONFIG_NS83820 is not set
CONFIG_NET_VENDOR_NETERION=y
# CONFIG_S2IO is not set
# CONFIG_VXGE is not set
CONFIG_NET_VENDOR_NETRONOME=y
# CONFIG_NFP is not set
CONFIG_NET_VENDOR_NI=y
# CONFIG_NI_XGE_MANAGEMENT_ENET is not set
CONFIG_NET_VENDOR_8390=y
# CONFIG_NE2K_PCI is not set
CONFIG_NET_VENDOR_NVIDIA=y
# CONFIG_FORCEDETH is not set
CONFIG_NET_VENDOR_OKI=y
# CONFIG_ETHOC is not set
CONFIG_NET_VENDOR_PACKET_ENGINES=y
# CONFIG_HAMACHI is not set
# CONFIG_YELLOWFIN is not set
CONFIG_NET_VENDOR_PENSANDO=y
# CONFIG_IONIC is not set
CONFIG_NET_VENDOR_QLOGIC=y
# CONFIG_QLA3XXX is not set
# CONFIG_QLCNIC is not set
# CONFIG_NETXEN_NIC is not set
# CONFIG_QED is not set
CONFIG_NET_VENDOR_QUALCOMM=y
# CONFIG_QCOM_EMAC is not set
# CONFIG_RMNET is not set
CONFIG_NET_VENDOR_RDC=y
# CONFIG_R6040 is not set
CONFIG_NET_VENDOR_REALTEK=y
# CONFIG_ATP is not set
# CONFIG_8139CP is not set
# CONFIG_8139TOO is not set
CONFIG_R8169=y
CONFIG_NET_VENDOR_RENESAS=y
CONFIG_NET_VENDOR_ROCKER=y
# CONFIG_ROCKER is not set
CONFIG_NET_VENDOR_SAMSUNG=y
# CONFIG_SXGBE_ETH is not set
CONFIG_NET_VENDOR_SEEQ=y
CONFIG_NET_VENDOR_SOLARFLARE=y
# CONFIG_SFC is not set
# CONFIG_SFC_FALCON is not set
CONFIG_NET_VENDOR_SILAN=y
# CONFIG_SC92031 is not set
CONFIG_NET_VENDOR_SIS=y
# CONFIG_SIS900 is not set
# CONFIG_SIS190 is not set
CONFIG_NET_VENDOR_SMSC=y
# CONFIG_EPIC100 is not set
# CONFIG_SMSC911X is not set
# CONFIG_SMSC9420 is not set
CONFIG_NET_VENDOR_SOCIONEXT=y
CONFIG_NET_VENDOR_STMICRO=y
# CONFIG_STMMAC_ETH is not set
CONFIG_NET_VENDOR_SUN=y
# CONFIG_HAPPYMEAL is not set
# CONFIG_SUNGEM is not set
# CONFIG_CASSINI is not set
# CONFIG_NIU is not set
CONFIG_NET_VENDOR_SYNOPSYS=y
# CONFIG_DWC_XLGMAC is not set
CONFIG_NET_VENDOR_TEHUTI=y
# CONFIG_TEHUTI is not set
CONFIG_NET_VENDOR_TI=y
# CONFIG_TI_CPSW_PHY_SEL is not set
# CONFIG_TLAN is not set
CONFIG_NET_VENDOR_VIA=y
# CONFIG_VIA_RHINE is not set
# CONFIG_VIA_VELOCITY is not set
CONFIG_NET_VENDOR_WIZNET=y
# CONFIG_WIZNET_W5100 is not set
# CONFIG_WIZNET_W5300 is not set
CONFIG_NET_VENDOR_XILINX=y
# CONFIG_XILINX_EMACLITE is not set
# CONFIG_XILINX_AXI_EMAC is not set
# CONFIG_XILINX_LL_TEMAC is not set
# CONFIG_FDDI is not set
# CONFIG_HIPPI is not set
# CONFIG_NET_SB1000 is not set
CONFIG_PHYLIB=y
CONFIG_SWPHY=y
# CONFIG_LED_TRIGGER_PHY is not set
CONFIG_FIXED_PHY=y

#
# MII PHY device drivers
#
# CONFIG_AMD_PHY is not set
# CONFIG_ADIN_PHY is not set
# CONFIG_AQUANTIA_PHY is not set
CONFIG_AX88796B_PHY=y
# CONFIG_BROADCOM_PHY is not set
# CONFIG_BCM54140_PHY is not set
# CONFIG_BCM7XXX_PHY is not set
# CONFIG_BCM84881_PHY is not set
# CONFIG_BCM87XX_PHY is not set
# CONFIG_CICADA_PHY is not set
# CONFIG_CORTINA_PHY is not set
# CONFIG_DAVICOM_PHY is not set
# CONFIG_ICPLUS_PHY is not set
# CONFIG_LXT_PHY is not set
# CONFIG_INTEL_XWAY_PHY is not set
# CONFIG_LSI_ET1011C_PHY is not set
# CONFIG_MARVELL_PHY is not set
# CONFIG_MARVELL_10G_PHY is not set
# CONFIG_MARVELL_88X2222_PHY is not set
# CONFIG_MAXLINEAR_GPHY is not set
# CONFIG_MEDIATEK_GE_PHY is not set
# CONFIG_MICREL_PHY is not set
# CONFIG_MICROCHIP_PHY is not set
# CONFIG_MICROCHIP_T1_PHY is not set
# CONFIG_MICROSEMI_PHY is not set
# CONFIG_MOTORCOMM_PHY is not set
# CONFIG_NATIONAL_PHY is not set
# CONFIG_NXP_C45_TJA11XX_PHY is not set
# CONFIG_NXP_TJA11XX_PHY is not set
# CONFIG_QSEMI_PHY is not set
CONFIG_REALTEK_PHY=y
# CONFIG_RENESAS_PHY is not set
# CONFIG_ROCKCHIP_PHY is not set
# CONFIG_SMSC_PHY is not set
# CONFIG_STE10XP is not set
# CONFIG_TERANETICS_PHY is not set
# CONFIG_DP83822_PHY is not set
# CONFIG_DP83TC811_PHY is not set
# CONFIG_DP83848_PHY is not set
# CONFIG_DP83867_PHY is not set
# CONFIG_DP83869_PHY is not set
# CONFIG_VITESSE_PHY is not set
# CONFIG_XILINX_GMII2RGMII is not set
# CONFIG_MICREL_KS8995MA is not set
CONFIG_MDIO_DEVICE=y
CONFIG_MDIO_BUS=y
CONFIG_FWNODE_MDIO=y
CONFIG_ACPI_MDIO=y
CONFIG_MDIO_DEVRES=y
# CONFIG_MDIO_BITBANG is not set
# CONFIG_MDIO_BCM_UNIMAC is not set
# CONFIG_MDIO_MVUSB is not set
# CONFIG_MDIO_MSCC_MIIM is not set
# CONFIG_MDIO_THUNDER is not set

#
# MDIO Multiplexers
#

#
# PCS device drivers
#
# CONFIG_PCS_XPCS is not set
# end of PCS device drivers

# CONFIG_PLIP is not set
# CONFIG_PPP is not set
# CONFIG_SLIP is not set
CONFIG_USB_NET_DRIVERS=y
# CONFIG_USB_CATC is not set
# CONFIG_USB_KAWETH is not set
# CONFIG_USB_PEGASUS is not set
# CONFIG_USB_RTL8150 is not set
CONFIG_USB_RTL8152=y
# CONFIG_USB_LAN78XX is not set
CONFIG_USB_USBNET=y
CONFIG_USB_NET_AX8817X=y
CONFIG_USB_NET_AX88179_178A=y
# CONFIG_USB_NET_CDCETHER is not set
# CONFIG_USB_NET_CDC_EEM is not set
# CONFIG_USB_NET_CDC_NCM is not set
# CONFIG_USB_NET_HUAWEI_CDC_NCM is not set
# CONFIG_USB_NET_CDC_MBIM is not set
# CONFIG_USB_NET_DM9601 is not set
# CONFIG_USB_NET_SR9700 is not set
# CONFIG_USB_NET_SR9800 is not set
# CONFIG_USB_NET_SMSC75XX is not set
# CONFIG_USB_NET_SMSC95XX is not set
# CONFIG_USB_NET_GL620A is not set
# CONFIG_USB_NET_NET1080 is not set
# CONFIG_USB_NET_PLUSB is not set
# CONFIG_USB_NET_MCS7830 is not set
# CONFIG_USB_NET_RNDIS_HOST is not set
# CONFIG_USB_NET_CDC_SUBSET is not set
# CONFIG_USB_NET_ZAURUS is not set
# CONFIG_USB_NET_CX82310_ETH is not set
# CONFIG_USB_NET_KALMIA is not set
# CONFIG_USB_NET_QMI_WWAN is not set
# CONFIG_USB_HSO is not set
# CONFIG_USB_NET_INT51X1 is not set
# CONFIG_USB_IPHETH is not set
# CONFIG_USB_SIERRA_NET is not set
# CONFIG_USB_NET_CH9200 is not set
# CONFIG_USB_NET_AQC111 is not set
CONFIG_WLAN=y
CONFIG_WLAN_VENDOR_ADMTEK=y
# CONFIG_ADM8211 is not set
CONFIG_WLAN_VENDOR_ATH=y
# CONFIG_ATH_DEBUG is not set
# CONFIG_ATH5K is not set
# CONFIG_ATH5K_PCI is not set
# CONFIG_ATH9K is not set
# CONFIG_ATH9K_HTC is not set
# CONFIG_CARL9170 is not set
# CONFIG_ATH6KL is not set
# CONFIG_AR5523 is not set
# CONFIG_WIL6210 is not set
# CONFIG_ATH10K is not set
# CONFIG_WCN36XX is not set
# CONFIG_ATH11K is not set
CONFIG_WLAN_VENDOR_ATMEL=y
# CONFIG_ATMEL is not set
# CONFIG_AT76C50X_USB is not set
CONFIG_WLAN_VENDOR_BROADCOM=y
# CONFIG_B43 is not set
# CONFIG_B43LEGACY is not set
# CONFIG_BRCMSMAC is not set
# CONFIG_BRCMFMAC is not set
CONFIG_WLAN_VENDOR_CISCO=y
# CONFIG_AIRO is not set
CONFIG_WLAN_VENDOR_INTEL=y
# CONFIG_IPW2100 is not set
# CONFIG_IPW2200 is not set
# CONFIG_IWL4965 is not set
# CONFIG_IWL3945 is not set
# CONFIG_IWLWIFI is not set
CONFIG_WLAN_VENDOR_INTERSIL=y
# CONFIG_HOSTAP is not set
# CONFIG_HERMES is not set
# CONFIG_P54_COMMON is not set
CONFIG_WLAN_VENDOR_MARVELL=y
# CONFIG_LIBERTAS is not set
# CONFIG_LIBERTAS_THINFIRM is not set
# CONFIG_MWIFIEX is not set
# CONFIG_MWL8K is not set
# CONFIG_WLAN_VENDOR_MEDIATEK is not set
CONFIG_WLAN_VENDOR_MICROCHIP=y
# CONFIG_WILC1000_SDIO is not set
# CONFIG_WILC1000_SPI is not set
CONFIG_WLAN_VENDOR_RALINK=y
# CONFIG_RT2X00 is not set
CONFIG_WLAN_VENDOR_REALTEK=y
# CONFIG_RTL8180 is not set
# CONFIG_RTL8187 is not set
CONFIG_RTL_CARDS=m
# CONFIG_RTL8192CE is not set
# CONFIG_RTL8192SE is not set
# CONFIG_RTL8192DE is not set
# CONFIG_RTL8723AE is not set
# CONFIG_RTL8723BE is not set
# CONFIG_RTL8188EE is not set
# CONFIG_RTL8192EE is not set
# CONFIG_RTL8821AE is not set
# CONFIG_RTL8192CU is not set
# CONFIG_RTL8XXXU is not set
# CONFIG_RTW88 is not set
# CONFIG_RTW89 is not set
CONFIG_WLAN_VENDOR_RSI=y
# CONFIG_RSI_91X is not set
CONFIG_WLAN_VENDOR_ST=y
# CONFIG_CW1200 is not set
CONFIG_WLAN_VENDOR_TI=y
# CONFIG_WL1251 is not set
# CONFIG_WL12XX is not set
# CONFIG_WL18XX is not set
# CONFIG_WLCORE is not set
CONFIG_WLAN_VENDOR_ZYDAS=y
# CONFIG_USB_ZD1201 is not set
# CONFIG_ZD1211RW is not set
CONFIG_WLAN_VENDOR_QUANTENNA=y
# CONFIG_QTNFMAC_PCIE is not set
# CONFIG_MAC80211_HWSIM is not set
# CONFIG_USB_NET_RNDIS_WLAN is not set
# CONFIG_VIRT_WIFI is not set
# CONFIG_WAN is not set
CONFIG_IEEE802154_DRIVERS=m
# CONFIG_IEEE802154_FAKELB is not set
# CONFIG_IEEE802154_AT86RF230 is not set
# CONFIG_IEEE802154_MRF24J40 is not set
# CONFIG_IEEE802154_CC2520 is not set
# CONFIG_IEEE802154_ATUSB is not set
# CONFIG_IEEE802154_ADF7242 is not set
# CONFIG_IEEE802154_CA8210 is not set
# CONFIG_IEEE802154_MCR20A is not set
# CONFIG_IEEE802154_HWSIM is not set

#
# Wireless WAN
#
# CONFIG_WWAN is not set
# end of Wireless WAN

# CONFIG_VMXNET3 is not set
# CONFIG_FUJITSU_ES is not set
# CONFIG_HYPERV_NET is not set
CONFIG_NETDEVSIM=m
CONFIG_NET_FAILOVER=m
# CONFIG_ISDN is not set

#
# Input device support
#
CONFIG_INPUT=y
CONFIG_INPUT_LEDS=y
CONFIG_INPUT_FF_MEMLESS=m
CONFIG_INPUT_SPARSEKMAP=m
# CONFIG_INPUT_MATRIXKMAP is not set

#
# Userland interfaces
#
CONFIG_INPUT_MOUSEDEV=y
# CONFIG_INPUT_MOUSEDEV_PSAUX is not set
CONFIG_INPUT_MOUSEDEV_SCREEN_X=1024
CONFIG_INPUT_MOUSEDEV_SCREEN_Y=768
CONFIG_INPUT_JOYDEV=m
CONFIG_INPUT_EVDEV=y
# CONFIG_INPUT_EVBUG is not set

#
# Input Device Drivers
#
CONFIG_INPUT_KEYBOARD=y
# CONFIG_KEYBOARD_ADP5588 is not set
# CONFIG_KEYBOARD_ADP5589 is not set
# CONFIG_KEYBOARD_APPLESPI is not set
CONFIG_KEYBOARD_ATKBD=y
# CONFIG_KEYBOARD_QT1050 is not set
# CONFIG_KEYBOARD_QT1070 is not set
# CONFIG_KEYBOARD_QT2160 is not set
# CONFIG_KEYBOARD_DLINK_DIR685 is not set
# CONFIG_KEYBOARD_LKKBD is not set
# CONFIG_KEYBOARD_GPIO is not set
# CONFIG_KEYBOARD_GPIO_POLLED is not set
# CONFIG_KEYBOARD_TCA6416 is not set
# CONFIG_KEYBOARD_TCA8418 is not set
# CONFIG_KEYBOARD_MATRIX is not set
# CONFIG_KEYBOARD_LM8323 is not set
# CONFIG_KEYBOARD_LM8333 is not set
# CONFIG_KEYBOARD_MAX7359 is not set
# CONFIG_KEYBOARD_MCS is not set
# CONFIG_KEYBOARD_MPR121 is not set
# CONFIG_KEYBOARD_NEWTON is not set
# CONFIG_KEYBOARD_OPENCORES is not set
# CONFIG_KEYBOARD_SAMSUNG is not set
# CONFIG_KEYBOARD_STOWAWAY is not set
# CONFIG_KEYBOARD_SUNKBD is not set
# CONFIG_KEYBOARD_TM2_TOUCHKEY is not set
# CONFIG_KEYBOARD_XTKBD is not set
CONFIG_INPUT_MOUSE=y
CONFIG_MOUSE_PS2=y
CONFIG_MOUSE_PS2_ALPS=y
CONFIG_MOUSE_PS2_BYD=y
CONFIG_MOUSE_PS2_LOGIPS2PP=y
CONFIG_MOUSE_PS2_SYNAPTICS=y
CONFIG_MOUSE_PS2_SYNAPTICS_SMBUS=y
CONFIG_MOUSE_PS2_CYPRESS=y
CONFIG_MOUSE_PS2_LIFEBOOK=y
CONFIG_MOUSE_PS2_TRACKPOINT=y
CONFIG_MOUSE_PS2_ELANTECH=y
CONFIG_MOUSE_PS2_ELANTECH_SMBUS=y
CONFIG_MOUSE_PS2_SENTELIC=y
# CONFIG_MOUSE_PS2_TOUCHKIT is not set
CONFIG_MOUSE_PS2_FOCALTECH=y
CONFIG_MOUSE_PS2_VMMOUSE=y
CONFIG_MOUSE_PS2_SMBUS=y
CONFIG_MOUSE_SERIAL=m
# CONFIG_MOUSE_APPLETOUCH is not set
# CONFIG_MOUSE_BCM5974 is not set
CONFIG_MOUSE_CYAPA=m
CONFIG_MOUSE_ELAN_I2C=m
CONFIG_MOUSE_ELAN_I2C_I2C=y
CONFIG_MOUSE_ELAN_I2C_SMBUS=y
CONFIG_MOUSE_VSXXXAA=m
# CONFIG_MOUSE_GPIO is not set
CONFIG_MOUSE_SYNAPTICS_I2C=m
# CONFIG_MOUSE_SYNAPTICS_USB is not set
# CONFIG_INPUT_JOYSTICK is not set
# CONFIG_INPUT_TABLET is not set
# CONFIG_INPUT_TOUCHSCREEN is not set
# CONFIG_INPUT_MISC is not set
CONFIG_RMI4_CORE=m
CONFIG_RMI4_I2C=m
CONFIG_RMI4_SPI=m
CONFIG_RMI4_SMB=m
CONFIG_RMI4_F03=y
CONFIG_RMI4_F03_SERIO=m
CONFIG_RMI4_2D_SENSOR=y
CONFIG_RMI4_F11=y
CONFIG_RMI4_F12=y
CONFIG_RMI4_F30=y
CONFIG_RMI4_F34=y
# CONFIG_RMI4_F3A is not set
# CONFIG_RMI4_F54 is not set
CONFIG_RMI4_F55=y

#
# Hardware I/O ports
#
CONFIG_SERIO=y
CONFIG_ARCH_MIGHT_HAVE_PC_SERIO=y
CONFIG_SERIO_I8042=y
CONFIG_SERIO_SERPORT=y
# CONFIG_SERIO_CT82C710 is not set
# CONFIG_SERIO_PARKBD is not set
# CONFIG_SERIO_PCIPS2 is not set
CONFIG_SERIO_LIBPS2=y
CONFIG_SERIO_RAW=m
CONFIG_SERIO_ALTERA_PS2=m
# CONFIG_SERIO_PS2MULT is not set
CONFIG_SERIO_ARC_PS2=m
CONFIG_HYPERV_KEYBOARD=m
# CONFIG_SERIO_GPIO_PS2 is not set
# CONFIG_USERIO is not set
# CONFIG_GAMEPORT is not set
# end of Hardware I/O ports
# end of Input device support

#
# Character devices
#
CONFIG_TTY=y
CONFIG_VT=y
CONFIG_CONSOLE_TRANSLATIONS=y
CONFIG_VT_CONSOLE=y
CONFIG_VT_CONSOLE_SLEEP=y
CONFIG_HW_CONSOLE=y
CONFIG_VT_HW_CONSOLE_BINDING=y
CONFIG_UNIX98_PTYS=y
# CONFIG_LEGACY_PTYS is not set
CONFIG_LDISC_AUTOLOAD=y

#
# Serial drivers
#
CONFIG_SERIAL_EARLYCON=y
CONFIG_SERIAL_8250=y
# CONFIG_SERIAL_8250_DEPRECATED_OPTIONS is not set
CONFIG_SERIAL_8250_PNP=y
# CONFIG_SERIAL_8250_16550A_VARIANTS is not set
# CONFIG_SERIAL_8250_FINTEK is not set
CONFIG_SERIAL_8250_CONSOLE=y
CONFIG_SERIAL_8250_DMA=y
CONFIG_SERIAL_8250_PCI=y
CONFIG_SERIAL_8250_EXAR=y
CONFIG_SERIAL_8250_NR_UARTS=64
CONFIG_SERIAL_8250_RUNTIME_UARTS=4
CONFIG_SERIAL_8250_EXTENDED=y
CONFIG_SERIAL_8250_MANY_PORTS=y
CONFIG_SERIAL_8250_SHARE_IRQ=y
# CONFIG_SERIAL_8250_DETECT_IRQ is not set
CONFIG_SERIAL_8250_RSA=y
CONFIG_SERIAL_8250_DWLIB=y
CONFIG_SERIAL_8250_DW=y
# CONFIG_SERIAL_8250_RT288X is not set
CONFIG_SERIAL_8250_LPSS=y
CONFIG_SERIAL_8250_MID=y

#
# Non-8250 serial port support
#
# CONFIG_SERIAL_MAX3100 is not set
# CONFIG_SERIAL_MAX310X is not set
# CONFIG_SERIAL_UARTLITE is not set
CONFIG_SERIAL_CORE=y
CONFIG_SERIAL_CORE_CONSOLE=y
CONFIG_SERIAL_JSM=m
# CONFIG_SERIAL_LANTIQ is not set
# CONFIG_SERIAL_SCCNXP is not set
# CONFIG_SERIAL_SC16IS7XX is not set
# CONFIG_SERIAL_BCM63XX is not set
# CONFIG_SERIAL_ALTERA_JTAGUART is not set
# CONFIG_SERIAL_ALTERA_UART is not set
CONFIG_SERIAL_ARC=m
CONFIG_SERIAL_ARC_NR_PORTS=1
# CONFIG_SERIAL_RP2 is not set
# CONFIG_SERIAL_FSL_LPUART is not set
# CONFIG_SERIAL_FSL_LINFLEXUART is not set
# CONFIG_SERIAL_SPRD is not set
# end of Serial drivers

CONFIG_SERIAL_MCTRL_GPIO=y
CONFIG_SERIAL_NONSTANDARD=y
# CONFIG_MOXA_INTELLIO is not set
# CONFIG_MOXA_SMARTIO is not set
CONFIG_SYNCLINK_GT=m
CONFIG_N_HDLC=m
CONFIG_N_GSM=m
CONFIG_NOZOMI=m
# CONFIG_NULL_TTY is not set
CONFIG_HVC_DRIVER=y
# CONFIG_SERIAL_DEV_BUS is not set
# CONFIG_TTY_PRINTK is not set
CONFIG_PRINTER=m
# CONFIG_LP_CONSOLE is not set
CONFIG_PPDEV=m
CONFIG_VIRTIO_CONSOLE=m
CONFIG_IPMI_HANDLER=m
CONFIG_IPMI_DMI_DECODE=y
CONFIG_IPMI_PLAT_DATA=y
CONFIG_IPMI_PANIC_EVENT=y
CONFIG_IPMI_PANIC_STRING=y
CONFIG_IPMI_DEVICE_INTERFACE=m
CONFIG_IPMI_SI=m
CONFIG_IPMI_SSIF=m
CONFIG_IPMI_WATCHDOG=m
CONFIG_IPMI_POWEROFF=m
CONFIG_HW_RANDOM=y
CONFIG_HW_RANDOM_TIMERIOMEM=m
CONFIG_HW_RANDOM_INTEL=m
CONFIG_HW_RANDOM_AMD=m
# CONFIG_HW_RANDOM_BA431 is not set
CONFIG_HW_RANDOM_VIA=m
CONFIG_HW_RANDOM_VIRTIO=y
# CONFIG_HW_RANDOM_XIPHERA is not set
# CONFIG_APPLICOM is not set
# CONFIG_MWAVE is not set
CONFIG_DEVMEM=y
CONFIG_NVRAM=y
CONFIG_DEVPORT=y
CONFIG_HPET=y
CONFIG_HPET_MMAP=y
# CONFIG_HPET_MMAP_DEFAULT is not set
CONFIG_HANGCHECK_TIMER=m
CONFIG_UV_MMTIMER=m
CONFIG_TCG_TPM=y
CONFIG_HW_RANDOM_TPM=y
CONFIG_TCG_TIS_CORE=y
CONFIG_TCG_TIS=y
# CONFIG_TCG_TIS_SPI is not set
# CONFIG_TCG_TIS_I2C_CR50 is not set
CONFIG_TCG_TIS_I2C_ATMEL=m
CONFIG_TCG_TIS_I2C_INFINEON=m
CONFIG_TCG_TIS_I2C_NUVOTON=m
CONFIG_TCG_NSC=m
CONFIG_TCG_ATMEL=m
CONFIG_TCG_INFINEON=m
CONFIG_TCG_CRB=y
# CONFIG_TCG_VTPM_PROXY is not set
CONFIG_TCG_TIS_ST33ZP24=m
CONFIG_TCG_TIS_ST33ZP24_I2C=m
# CONFIG_TCG_TIS_ST33ZP24_SPI is not set
CONFIG_TELCLOCK=m
# CONFIG_XILLYBUS is not set
# CONFIG_XILLYUSB is not set
# CONFIG_RANDOM_TRUST_CPU is not set
# CONFIG_RANDOM_TRUST_BOOTLOADER is not set
# end of Character devices

#
# I2C support
#
CONFIG_I2C=y
CONFIG_ACPI_I2C_OPREGION=y
CONFIG_I2C_BOARDINFO=y
CONFIG_I2C_COMPAT=y
CONFIG_I2C_CHARDEV=m
CONFIG_I2C_MUX=m

#
# Multiplexer I2C Chip support
#
# CONFIG_I2C_MUX_GPIO is not set
# CONFIG_I2C_MUX_LTC4306 is not set
# CONFIG_I2C_MUX_PCA9541 is not set
# CONFIG_I2C_MUX_PCA954x is not set
# CONFIG_I2C_MUX_REG is not set
CONFIG_I2C_MUX_MLXCPLD=m
# end of Multiplexer I2C Chip support

CONFIG_I2C_HELPER_AUTO=y
CONFIG_I2C_SMBUS=m
CONFIG_I2C_ALGOBIT=y
CONFIG_I2C_ALGOPCA=m

#
# I2C Hardware Bus support
#

#
# PC SMBus host controller drivers
#
# CONFIG_I2C_ALI1535 is not set
# CONFIG_I2C_ALI1563 is not set
# CONFIG_I2C_ALI15X3 is not set
CONFIG_I2C_AMD756=m
CONFIG_I2C_AMD756_S4882=m
CONFIG_I2C_AMD8111=m
# CONFIG_I2C_AMD_MP2 is not set
CONFIG_I2C_I801=m
CONFIG_I2C_ISCH=m
CONFIG_I2C_ISMT=m
CONFIG_I2C_PIIX4=m
CONFIG_I2C_NFORCE2=m
CONFIG_I2C_NFORCE2_S4985=m
# CONFIG_I2C_NVIDIA_GPU is not set
# CONFIG_I2C_SIS5595 is not set
# CONFIG_I2C_SIS630 is not set
CONFIG_I2C_SIS96X=m
CONFIG_I2C_VIA=m
CONFIG_I2C_VIAPRO=m

#
# ACPI drivers
#
CONFIG_I2C_SCMI=m

#
# I2C system bus drivers (mostly embedded / system-on-chip)
#
# CONFIG_I2C_CBUS_GPIO is not set
CONFIG_I2C_DESIGNWARE_CORE=m
# CONFIG_I2C_DESIGNWARE_SLAVE is not set
CONFIG_I2C_DESIGNWARE_PLATFORM=m
CONFIG_I2C_DESIGNWARE_BAYTRAIL=y
# CONFIG_I2C_DESIGNWARE_PCI is not set
# CONFIG_I2C_EMEV2 is not set
# CONFIG_I2C_GPIO is not set
# CONFIG_I2C_OCORES is not set
CONFIG_I2C_PCA_PLATFORM=m
CONFIG_I2C_SIMTEC=m
# CONFIG_I2C_XILINX is not set

#
# External I2C/SMBus adapter drivers
#
# CONFIG_I2C_DIOLAN_U2C is not set
# CONFIG_I2C_CP2615 is not set
CONFIG_I2C_PARPORT=m
# CONFIG_I2C_ROBOTFUZZ_OSIF is not set
# CONFIG_I2C_TAOS_EVM is not set
# CONFIG_I2C_TINY_USB is not set

#
# Other I2C/SMBus bus drivers
#
CONFIG_I2C_MLXCPLD=m
# CONFIG_I2C_VIRTIO is not set
# end of I2C Hardware Bus support

CONFIG_I2C_STUB=m
# CONFIG_I2C_SLAVE is not set
# CONFIG_I2C_DEBUG_CORE is not set
# CONFIG_I2C_DEBUG_ALGO is not set
# CONFIG_I2C_DEBUG_BUS is not set
# end of I2C support

# CONFIG_I3C is not set
CONFIG_SPI=y
# CONFIG_SPI_DEBUG is not set
CONFIG_SPI_MASTER=y
# CONFIG_SPI_MEM is not set

#
# SPI Master Controller Drivers
#
# CONFIG_SPI_ALTERA is not set
# CONFIG_SPI_AXI_SPI_ENGINE is not set
# CONFIG_SPI_BITBANG is not set
# CONFIG_SPI_BUTTERFLY is not set
# CONFIG_SPI_CADENCE is not set
# CONFIG_SPI_DESIGNWARE is not set
# CONFIG_SPI_NXP_FLEXSPI is not set
# CONFIG_SPI_GPIO is not set
# CONFIG_SPI_LM70_LLP is not set
# CONFIG_SPI_LANTIQ_SSC is not set
# CONFIG_SPI_OC_TINY is not set
# CONFIG_SPI_PXA2XX is not set
# CONFIG_SPI_ROCKCHIP is not set
# CONFIG_SPI_SC18IS602 is not set
# CONFIG_SPI_SIFIVE is not set
# CONFIG_SPI_MXIC is not set
# CONFIG_SPI_XCOMM is not set
# CONFIG_SPI_XILINX is not set
# CONFIG_SPI_ZYNQMP_GQSPI is not set
# CONFIG_SPI_AMD is not set

#
# SPI Multiplexer support
#
# CONFIG_SPI_MUX is not set

#
# SPI Protocol Masters
#
# CONFIG_SPI_SPIDEV is not set
# CONFIG_SPI_LOOPBACK_TEST is not set
# CONFIG_SPI_TLE62X0 is not set
# CONFIG_SPI_SLAVE is not set
CONFIG_SPI_DYNAMIC=y
# CONFIG_SPMI is not set
# CONFIG_HSI is not set
CONFIG_PPS=y
# CONFIG_PPS_DEBUG is not set

#
# PPS clients support
#
# CONFIG_PPS_CLIENT_KTIMER is not set
CONFIG_PPS_CLIENT_LDISC=m
CONFIG_PPS_CLIENT_PARPORT=m
CONFIG_PPS_CLIENT_GPIO=m

#
# PPS generators support
#

#
# PTP clock support
#
CONFIG_PTP_1588_CLOCK=y
CONFIG_PTP_1588_CLOCK_OPTIONAL=y
# CONFIG_DP83640_PHY is not set
# CONFIG_PTP_1588_CLOCK_INES is not set
CONFIG_PTP_1588_CLOCK_KVM=m
# CONFIG_PTP_1588_CLOCK_IDT82P33 is not set
# CONFIG_PTP_1588_CLOCK_IDTCM is not set
# CONFIG_PTP_1588_CLOCK_VMW is not set
# end of PTP clock support

CONFIG_PINCTRL=y
CONFIG_PINMUX=y
CONFIG_PINCONF=y
CONFIG_GENERIC_PINCONF=y
# CONFIG_DEBUG_PINCTRL is not set
CONFIG_PINCTRL_AMD=m
# CONFIG_PINCTRL_MCP23S08 is not set
# CONFIG_PINCTRL_SX150X is not set
CONFIG_PINCTRL_BAYTRAIL=y
# CONFIG_PINCTRL_CHERRYVIEW is not set
# CONFIG_PINCTRL_LYNXPOINT is not set
CONFIG_PINCTRL_INTEL=y
# CONFIG_PINCTRL_ALDERLAKE is not set
CONFIG_PINCTRL_BROXTON=m
CONFIG_PINCTRL_CANNONLAKE=m
CONFIG_PINCTRL_CEDARFORK=m
CONFIG_PINCTRL_DENVERTON=m
# CONFIG_PINCTRL_ELKHARTLAKE is not set
# CONFIG_PINCTRL_EMMITSBURG is not set
CONFIG_PINCTRL_GEMINILAKE=m
# CONFIG_PINCTRL_ICELAKE is not set
# CONFIG_PINCTRL_JASPERLAKE is not set
# CONFIG_PINCTRL_LAKEFIELD is not set
CONFIG_PINCTRL_LEWISBURG=m
CONFIG_PINCTRL_SUNRISEPOINT=m
# CONFIG_PINCTRL_TIGERLAKE is not set

#
# Renesas pinctrl drivers
#
# end of Renesas pinctrl drivers

CONFIG_GPIOLIB=y
CONFIG_GPIOLIB_FASTPATH_LIMIT=512
CONFIG_GPIO_ACPI=y
CONFIG_GPIOLIB_IRQCHIP=y
# CONFIG_DEBUG_GPIO is not set
CONFIG_GPIO_SYSFS=y
CONFIG_GPIO_CDEV=y
CONFIG_GPIO_CDEV_V1=y
CONFIG_GPIO_GENERIC=m

#
# Memory mapped GPIO drivers
#
CONFIG_GPIO_AMDPT=m
# CONFIG_GPIO_DWAPB is not set
# CONFIG_GPIO_EXAR is not set
# CONFIG_GPIO_GENERIC_PLATFORM is not set
CONFIG_GPIO_ICH=m
# CONFIG_GPIO_MB86S7X is not set
# CONFIG_GPIO_VX855 is not set
# CONFIG_GPIO_AMD_FCH is not set
# end of Memory mapped GPIO drivers

#
# Port-mapped I/O GPIO drivers
#
# CONFIG_GPIO_F7188X is not set
# CONFIG_GPIO_IT87 is not set
# CONFIG_GPIO_SCH is not set
# CONFIG_GPIO_SCH311X is not set
# CONFIG_GPIO_WINBOND is not set
# CONFIG_GPIO_WS16C48 is not set
# end of Port-mapped I/O GPIO drivers

#
# I2C GPIO expanders
#
# CONFIG_GPIO_ADP5588 is not set
# CONFIG_GPIO_MAX7300 is not set
# CONFIG_GPIO_MAX732X is not set
# CONFIG_GPIO_PCA953X is not set
# CONFIG_GPIO_PCA9570 is not set
# CONFIG_GPIO_PCF857X is not set
# CONFIG_GPIO_TPIC2810 is not set
# end of I2C GPIO expanders

#
# MFD GPIO expanders
#
# end of MFD GPIO expanders

#
# PCI GPIO expanders
#
# CONFIG_GPIO_AMD8111 is not set
# CONFIG_GPIO_BT8XX is not set
# CONFIG_GPIO_ML_IOH is not set
# CONFIG_GPIO_PCI_IDIO_16 is not set
# CONFIG_GPIO_PCIE_IDIO_24 is not set
# CONFIG_GPIO_RDC321X is not set
# end of PCI GPIO expanders

#
# SPI GPIO expanders
#
# CONFIG_GPIO_MAX3191X is not set
# CONFIG_GPIO_MAX7301 is not set
# CONFIG_GPIO_MC33880 is not set
# CONFIG_GPIO_PISOSR is not set
# CONFIG_GPIO_XRA1403 is not set
# end of SPI GPIO expanders

#
# USB GPIO expanders
#
# end of USB GPIO expanders

#
# Virtual GPIO drivers
#
# CONFIG_GPIO_AGGREGATOR is not set
CONFIG_GPIO_MOCKUP=m
# CONFIG_GPIO_VIRTIO is not set
# end of Virtual GPIO drivers

# CONFIG_W1 is not set
CONFIG_POWER_RESET=y
# CONFIG_POWER_RESET_RESTART is not set
CONFIG_POWER_SUPPLY=y
# CONFIG_POWER_SUPPLY_DEBUG is not set
CONFIG_POWER_SUPPLY_HWMON=y
# CONFIG_PDA_POWER is not set
# CONFIG_TEST_POWER is not set
# CONFIG_CHARGER_ADP5061 is not set
# CONFIG_BATTERY_CW2015 is not set
# CONFIG_BATTERY_DS2780 is not set
# CONFIG_BATTERY_DS2781 is not set
# CONFIG_BATTERY_DS2782 is not set
# CONFIG_BATTERY_SBS is not set
# CONFIG_CHARGER_SBS is not set
# CONFIG_MANAGER_SBS is not set
# CONFIG_BATTERY_BQ27XXX is not set
# CONFIG_BATTERY_MAX17040 is not set
# CONFIG_BATTERY_MAX17042 is not set
# CONFIG_CHARGER_MAX8903 is not set
# CONFIG_CHARGER_LP8727 is not set
# CONFIG_CHARGER_GPIO is not set
# CONFIG_CHARGER_LT3651 is not set
# CONFIG_CHARGER_LTC4162L is not set
# CONFIG_CHARGER_BQ2415X is not set
# CONFIG_CHARGER_BQ24257 is not set
# CONFIG_CHARGER_BQ24735 is not set
# CONFIG_CHARGER_BQ2515X is not set
# CONFIG_CHARGER_BQ25890 is not set
# CONFIG_CHARGER_BQ25980 is not set
# CONFIG_CHARGER_BQ256XX is not set
# CONFIG_BATTERY_GAUGE_LTC2941 is not set
# CONFIG_BATTERY_GOLDFISH is not set
# CONFIG_BATTERY_RT5033 is not set
# CONFIG_CHARGER_RT9455 is not set
# CONFIG_CHARGER_BD99954 is not set
CONFIG_HWMON=y
CONFIG_HWMON_VID=m
# CONFIG_HWMON_DEBUG_CHIP is not set

#
# Native drivers
#
CONFIG_SENSORS_ABITUGURU=m
CONFIG_SENSORS_ABITUGURU3=m
# CONFIG_SENSORS_AD7314 is not set
CONFIG_SENSORS_AD7414=m
CONFIG_SENSORS_AD7418=m
CONFIG_SENSORS_ADM1021=m
CONFIG_SENSORS_ADM1025=m
CONFIG_SENSORS_ADM1026=m
CONFIG_SENSORS_ADM1029=m
CONFIG_SENSORS_ADM1031=m
# CONFIG_SENSORS_ADM1177 is not set
CONFIG_SENSORS_ADM9240=m
CONFIG_SENSORS_ADT7X10=m
# CONFIG_SENSORS_ADT7310 is not set
CONFIG_SENSORS_ADT7410=m
CONFIG_SENSORS_ADT7411=m
CONFIG_SENSORS_ADT7462=m
CONFIG_SENSORS_ADT7470=m
CONFIG_SENSORS_ADT7475=m
# CONFIG_SENSORS_AHT10 is not set
# CONFIG_SENSORS_AQUACOMPUTER_D5NEXT is not set
# CONFIG_SENSORS_AS370 is not set
CONFIG_SENSORS_ASC7621=m
# CONFIG_SENSORS_AXI_FAN_CONTROL is not set
CONFIG_SENSORS_K8TEMP=m
CONFIG_SENSORS_K10TEMP=m
CONFIG_SENSORS_FAM15H_POWER=m
CONFIG_SENSORS_APPLESMC=m
CONFIG_SENSORS_ASB100=m
# CONFIG_SENSORS_ASPEED is not set
CONFIG_SENSORS_ATXP1=m
# CONFIG_SENSORS_CORSAIR_CPRO is not set
# CONFIG_SENSORS_CORSAIR_PSU is not set
# CONFIG_SENSORS_DRIVETEMP is not set
CONFIG_SENSORS_DS620=m
CONFIG_SENSORS_DS1621=m
CONFIG_SENSORS_DELL_SMM=m
CONFIG_SENSORS_I5K_AMB=m
CONFIG_SENSORS_F71805F=m
CONFIG_SENSORS_F71882FG=m
CONFIG_SENSORS_F75375S=m
CONFIG_SENSORS_FSCHMD=m
# CONFIG_SENSORS_FTSTEUTATES is not set
CONFIG_SENSORS_GL518SM=m
CONFIG_SENSORS_GL520SM=m
CONFIG_SENSORS_G760A=m
# CONFIG_SENSORS_G762 is not set
# CONFIG_SENSORS_HIH6130 is not set
CONFIG_SENSORS_IBMAEM=m
CONFIG_SENSORS_IBMPEX=m
CONFIG_SENSORS_I5500=m
CONFIG_SENSORS_CORETEMP=m
CONFIG_SENSORS_IT87=m
CONFIG_SENSORS_JC42=m
# CONFIG_SENSORS_POWR1220 is not set
CONFIG_SENSORS_LINEAGE=m
# CONFIG_SENSORS_LTC2945 is not set
# CONFIG_SENSORS_LTC2947_I2C is not set
# CONFIG_SENSORS_LTC2947_SPI is not set
# CONFIG_SENSORS_LTC2990 is not set
# CONFIG_SENSORS_LTC2992 is not set
CONFIG_SENSORS_LTC4151=m
CONFIG_SENSORS_LTC4215=m
# CONFIG_SENSORS_LTC4222 is not set
CONFIG_SENSORS_LTC4245=m
# CONFIG_SENSORS_LTC4260 is not set
CONFIG_SENSORS_LTC4261=m
# CONFIG_SENSORS_MAX1111 is not set
# CONFIG_SENSORS_MAX127 is not set
CONFIG_SENSORS_MAX16065=m
CONFIG_SENSORS_MAX1619=m
CONFIG_SENSORS_MAX1668=m
CONFIG_SENSORS_MAX197=m
# CONFIG_SENSORS_MAX31722 is not set
# CONFIG_SENSORS_MAX31730 is not set
# CONFIG_SENSORS_MAX6621 is not set
CONFIG_SENSORS_MAX6639=m
CONFIG_SENSORS_MAX6642=m
CONFIG_SENSORS_MAX6650=m
CONFIG_SENSORS_MAX6697=m
# CONFIG_SENSORS_MAX31790 is not set
CONFIG_SENSORS_MCP3021=m
# CONFIG_SENSORS_MLXREG_FAN is not set
# CONFIG_SENSORS_TC654 is not set
# CONFIG_SENSORS_TPS23861 is not set
# CONFIG_SENSORS_MR75203 is not set
# CONFIG_SENSORS_ADCXX is not set
CONFIG_SENSORS_LM63=m
# CONFIG_SENSORS_LM70 is not set
CONFIG_SENSORS_LM73=m
CONFIG_SENSORS_LM75=m
CONFIG_SENSORS_LM77=m
CONFIG_SENSORS_LM78=m
CONFIG_SENSORS_LM80=m
CONFIG_SENSORS_LM83=m
CONFIG_SENSORS_LM85=m
CONFIG_SENSORS_LM87=m
CONFIG_SENSORS_LM90=m
CONFIG_SENSORS_LM92=m
CONFIG_SENSORS_LM93=m
CONFIG_SENSORS_LM95234=m
CONFIG_SENSORS_LM95241=m
CONFIG_SENSORS_LM95245=m
CONFIG_SENSORS_PC87360=m
CONFIG_SENSORS_PC87427=m
CONFIG_SENSORS_NTC_THERMISTOR=m
# CONFIG_SENSORS_NCT6683 is not set
CONFIG_SENSORS_NCT6775=m
# CONFIG_SENSORS_NCT7802 is not set
# CONFIG_SENSORS_NCT7904 is not set
# CONFIG_SENSORS_NPCM7XX is not set
# CONFIG_SENSORS_NZXT_KRAKEN2 is not set
CONFIG_SENSORS_PCF8591=m
CONFIG_PMBUS=m
CONFIG_SENSORS_PMBUS=m
# CONFIG_SENSORS_ADM1266 is not set
CONFIG_SENSORS_ADM1275=m
# CONFIG_SENSORS_BEL_PFE is not set
# CONFIG_SENSORS_BPA_RS600 is not set
# CONFIG_SENSORS_FSP_3Y is not set
# CONFIG_SENSORS_IBM_CFFPS is not set
# CONFIG_SENSORS_DPS920AB is not set
# CONFIG_SENSORS_INSPUR_IPSPS is not set
# CONFIG_SENSORS_IR35221 is not set
# CONFIG_SENSORS_IR36021 is not set
# CONFIG_SENSORS_IR38064 is not set
# CONFIG_SENSORS_IRPS5401 is not set
# CONFIG_SENSORS_ISL68137 is not set
CONFIG_SENSORS_LM25066=m
CONFIG_SENSORS_LTC2978=m
# CONFIG_SENSORS_LTC3815 is not set
# CONFIG_SENSORS_MAX15301 is not set
CONFIG_SENSORS_MAX16064=m
# CONFIG_SENSORS_MAX16601 is not set
# CONFIG_SENSORS_MAX20730 is not set
# CONFIG_SENSORS_MAX20751 is not set
# CONFIG_SENSORS_MAX31785 is not set
CONFIG_SENSORS_MAX34440=m
CONFIG_SENSORS_MAX8688=m
# CONFIG_SENSORS_MP2888 is not set
# CONFIG_SENSORS_MP2975 is not set
# CONFIG_SENSORS_PIM4328 is not set
# CONFIG_SENSORS_PM6764TR is not set
# CONFIG_SENSORS_PXE1610 is not set
# CONFIG_SENSORS_Q54SJ108A2 is not set
# CONFIG_SENSORS_STPDDC60 is not set
# CONFIG_SENSORS_TPS40422 is not set
# CONFIG_SENSORS_TPS53679 is not set
CONFIG_SENSORS_UCD9000=m
CONFIG_SENSORS_UCD9200=m
# CONFIG_SENSORS_XDPE122 is not set
CONFIG_SENSORS_ZL6100=m
# CONFIG_SENSORS_SBTSI is not set
# CONFIG_SENSORS_SBRMI is not set
CONFIG_SENSORS_SHT15=m
CONFIG_SENSORS_SHT21=m
# CONFIG_SENSORS_SHT3x is not set
# CONFIG_SENSORS_SHT4x is not set
# CONFIG_SENSORS_SHTC1 is not set
CONFIG_SENSORS_SIS5595=m
CONFIG_SENSORS_DME1737=m
CONFIG_SENSORS_EMC1403=m
# CONFIG_SENSORS_EMC2103 is not set
CONFIG_SENSORS_EMC6W201=m
CONFIG_SENSORS_SMSC47M1=m
CONFIG_SENSORS_SMSC47M192=m
CONFIG_SENSORS_SMSC47B397=m
CONFIG_SENSORS_SCH56XX_COMMON=m
CONFIG_SENSORS_SCH5627=m
CONFIG_SENSORS_SCH5636=m
# CONFIG_SENSORS_STTS751 is not set
# CONFIG_SENSORS_SMM665 is not set
# CONFIG_SENSORS_ADC128D818 is not set
CONFIG_SENSORS_ADS7828=m
# CONFIG_SENSORS_ADS7871 is not set
CONFIG_SENSORS_AMC6821=m
CONFIG_SENSORS_INA209=m
CONFIG_SENSORS_INA2XX=m
# CONFIG_SENSORS_INA3221 is not set
# CONFIG_SENSORS_TC74 is not set
CONFIG_SENSORS_THMC50=m
CONFIG_SENSORS_TMP102=m
# CONFIG_SENSORS_TMP103 is not set
# CONFIG_SENSORS_TMP108 is not set
CONFIG_SENSORS_TMP401=m
CONFIG_SENSORS_TMP421=m
# CONFIG_SENSORS_TMP513 is not set
CONFIG_SENSORS_VIA_CPUTEMP=m
CONFIG_SENSORS_VIA686A=m
CONFIG_SENSORS_VT1211=m
CONFIG_SENSORS_VT8231=m
# CONFIG_SENSORS_W83773G is not set
CONFIG_SENSORS_W83781D=m
CONFIG_SENSORS_W83791D=m
CONFIG_SENSORS_W83792D=m
CONFIG_SENSORS_W83793=m
CONFIG_SENSORS_W83795=m
# CONFIG_SENSORS_W83795_FANCTRL is not set
CONFIG_SENSORS_W83L785TS=m
CONFIG_SENSORS_W83L786NG=m
CONFIG_SENSORS_W83627HF=m
CONFIG_SENSORS_W83627EHF=m
# CONFIG_SENSORS_XGENE is not set

#
# ACPI drivers
#
CONFIG_SENSORS_ACPI_POWER=m
CONFIG_SENSORS_ATK0110=m
CONFIG_THERMAL=y
# CONFIG_THERMAL_NETLINK is not set
# CONFIG_THERMAL_STATISTICS is not set
CONFIG_THERMAL_EMERGENCY_POWEROFF_DELAY_MS=0
CONFIG_THERMAL_HWMON=y
CONFIG_THERMAL_WRITABLE_TRIPS=y
CONFIG_THERMAL_DEFAULT_GOV_STEP_WISE=y
# CONFIG_THERMAL_DEFAULT_GOV_FAIR_SHARE is not set
# CONFIG_THERMAL_DEFAULT_GOV_USER_SPACE is not set
CONFIG_THERMAL_GOV_FAIR_SHARE=y
CONFIG_THERMAL_GOV_STEP_WISE=y
CONFIG_THERMAL_GOV_BANG_BANG=y
CONFIG_THERMAL_GOV_USER_SPACE=y
# CONFIG_THERMAL_EMULATION is not set

#
# Intel thermal drivers
#
CONFIG_INTEL_POWERCLAMP=m
CONFIG_X86_THERMAL_VECTOR=y
CONFIG_X86_PKG_TEMP_THERMAL=m
CONFIG_INTEL_SOC_DTS_IOSF_CORE=m
# CONFIG_INTEL_SOC_DTS_THERMAL is not set

#
# ACPI INT340X thermal drivers
#
CONFIG_INT340X_THERMAL=m
CONFIG_ACPI_THERMAL_REL=m
# CONFIG_INT3406_THERMAL is not set
CONFIG_PROC_THERMAL_MMIO_RAPL=m
# end of ACPI INT340X thermal drivers

CONFIG_INTEL_PCH_THERMAL=m
# CONFIG_INTEL_TCC_COOLING is not set
# CONFIG_INTEL_MENLOW is not set
# end of Intel thermal drivers

CONFIG_WATCHDOG=y
CONFIG_WATCHDOG_CORE=y
# CONFIG_WATCHDOG_NOWAYOUT is not set
CONFIG_WATCHDOG_HANDLE_BOOT_ENABLED=y
CONFIG_WATCHDOG_OPEN_TIMEOUT=0
CONFIG_WATCHDOG_SYSFS=y
# CONFIG_WATCHDOG_HRTIMER_PRETIMEOUT is not set

#
# Watchdog Pretimeout Governors
#
# CONFIG_WATCHDOG_PRETIMEOUT_GOV is not set

#
# Watchdog Device Drivers
#
CONFIG_SOFT_WATCHDOG=m
CONFIG_WDAT_WDT=m
# CONFIG_XILINX_WATCHDOG is not set
# CONFIG_ZIIRAVE_WATCHDOG is not set
# CONFIG_MLX_WDT is not set
# CONFIG_CADENCE_WATCHDOG is not set
# CONFIG_DW_WATCHDOG is not set
# CONFIG_MAX63XX_WATCHDOG is not set
# CONFIG_ACQUIRE_WDT is not set
# CONFIG_ADVANTECH_WDT is not set
CONFIG_ALIM1535_WDT=m
CONFIG_ALIM7101_WDT=m
# CONFIG_EBC_C384_WDT is not set
CONFIG_F71808E_WDT=m
CONFIG_SP5100_TCO=m
CONFIG_SBC_FITPC2_WATCHDOG=m
# CONFIG_EUROTECH_WDT is not set
CONFIG_IB700_WDT=m
CONFIG_IBMASR=m
# CONFIG_WAFER_WDT is not set
CONFIG_I6300ESB_WDT=y
CONFIG_IE6XX_WDT=m
CONFIG_ITCO_WDT=y
CONFIG_ITCO_VENDOR_SUPPORT=y
CONFIG_IT8712F_WDT=m
CONFIG_IT87_WDT=m
CONFIG_HP_WATCHDOG=m
CONFIG_HPWDT_NMI_DECODING=y
# CONFIG_SC1200_WDT is not set
# CONFIG_PC87413_WDT is not set
CONFIG_NV_TCO=m
# CONFIG_60XX_WDT is not set
# CONFIG_CPU5_WDT is not set
CONFIG_SMSC_SCH311X_WDT=m
# CONFIG_SMSC37B787_WDT is not set
# CONFIG_TQMX86_WDT is not set
CONFIG_VIA_WDT=m
CONFIG_W83627HF_WDT=m
CONFIG_W83877F_WDT=m
CONFIG_W83977F_WDT=m
CONFIG_MACHZ_WDT=m
# CONFIG_SBC_EPX_C3_WATCHDOG is not set
CONFIG_INTEL_MEI_WDT=m
# CONFIG_NI903X_WDT is not set
# CONFIG_NIC7018_WDT is not set
# CONFIG_MEN_A21_WDT is not set

#
# PCI-based Watchdog Cards
#
CONFIG_PCIPCWATCHDOG=m
CONFIG_WDTPCI=m

#
# USB-based Watchdog Cards
#
# CONFIG_USBPCWATCHDOG is not set
CONFIG_SSB_POSSIBLE=y
# CONFIG_SSB is not set
CONFIG_BCMA_POSSIBLE=y
CONFIG_BCMA=m
CONFIG_BCMA_HOST_PCI_POSSIBLE=y
CONFIG_BCMA_HOST_PCI=y
# CONFIG_BCMA_HOST_SOC is not set
CONFIG_BCMA_DRIVER_PCI=y
CONFIG_BCMA_DRIVER_GMAC_CMN=y
CONFIG_BCMA_DRIVER_GPIO=y
# CONFIG_BCMA_DEBUG is not set

#
# Multifunction device drivers
#
CONFIG_MFD_CORE=y
# CONFIG_MFD_AS3711 is not set
# CONFIG_PMIC_ADP5520 is not set
# CONFIG_MFD_AAT2870_CORE is not set
# CONFIG_MFD_BCM590XX is not set
# CONFIG_MFD_BD9571MWV is not set
# CONFIG_MFD_AXP20X_I2C is not set
# CONFIG_MFD_MADERA is not set
# CONFIG_PMIC_DA903X is not set
# CONFIG_MFD_DA9052_SPI is not set
# CONFIG_MFD_DA9052_I2C is not set
# CONFIG_MFD_DA9055 is not set
# CONFIG_MFD_DA9062 is not set
# CONFIG_MFD_DA9063 is not set
# CONFIG_MFD_DA9150 is not set
# CONFIG_MFD_DLN2 is not set
# CONFIG_MFD_MC13XXX_SPI is not set
# CONFIG_MFD_MC13XXX_I2C is not set
# CONFIG_MFD_MP2629 is not set
# CONFIG_HTC_PASIC3 is not set
# CONFIG_HTC_I2CPLD is not set
# CONFIG_MFD_INTEL_QUARK_I2C_GPIO is not set
CONFIG_LPC_ICH=m
CONFIG_LPC_SCH=m
# CONFIG_INTEL_SOC_PMIC_CHTDC_TI is not set
CONFIG_MFD_INTEL_LPSS=y
CONFIG_MFD_INTEL_LPSS_ACPI=y
CONFIG_MFD_INTEL_LPSS_PCI=y
# CONFIG_MFD_INTEL_PMC_BXT is not set
# CONFIG_MFD_INTEL_PMT is not set
# CONFIG_MFD_IQS62X is not set
# CONFIG_MFD_JANZ_CMODIO is not set
# CONFIG_MFD_KEMPLD is not set
# CONFIG_MFD_88PM800 is not set
# CONFIG_MFD_88PM805 is not set
# CONFIG_MFD_88PM860X is not set
# CONFIG_MFD_MAX14577 is not set
# CONFIG_MFD_MAX77693 is not set
# CONFIG_MFD_MAX77843 is not set
# CONFIG_MFD_MAX8907 is not set
# CONFIG_MFD_MAX8925 is not set
# CONFIG_MFD_MAX8997 is not set
# CONFIG_MFD_MAX8998 is not set
# CONFIG_MFD_MT6360 is not set
# CONFIG_MFD_MT6397 is not set
# CONFIG_MFD_MENF21BMC is not set
# CONFIG_EZX_PCAP is not set
# CONFIG_MFD_VIPERBOARD is not set
# CONFIG_MFD_RETU is not set
# CONFIG_MFD_PCF50633 is not set
# CONFIG_MFD_RDC321X is not set
# CONFIG_MFD_RT4831 is not set
# CONFIG_MFD_RT5033 is not set
# CONFIG_MFD_RC5T583 is not set
# CONFIG_MFD_SI476X_CORE is not set
CONFIG_MFD_SM501=m
CONFIG_MFD_SM501_GPIO=y
# CONFIG_MFD_SKY81452 is not set
# CONFIG_MFD_SYSCON is not set
# CONFIG_MFD_TI_AM335X_TSCADC is not set
# CONFIG_MFD_LP3943 is not set
# CONFIG_MFD_LP8788 is not set
# CONFIG_MFD_TI_LMU is not set
# CONFIG_MFD_PALMAS is not set
# CONFIG_TPS6105X is not set
# CONFIG_TPS65010 is not set
# CONFIG_TPS6507X is not set
# CONFIG_MFD_TPS65086 is not set
# CONFIG_MFD_TPS65090 is not set
# CONFIG_MFD_TI_LP873X is not set
# CONFIG_MFD_TPS6586X is not set
# CONFIG_MFD_TPS65910 is not set
# CONFIG_MFD_TPS65912_I2C is not set
# CONFIG_MFD_TPS65912_SPI is not set
# CONFIG_MFD_TPS80031 is not set
# CONFIG_TWL4030_CORE is not set
# CONFIG_TWL6040_CORE is not set
# CONFIG_MFD_WL1273_CORE is not set
# CONFIG_MFD_LM3533 is not set
# CONFIG_MFD_TQMX86 is not set
CONFIG_MFD_VX855=m
# CONFIG_MFD_ARIZONA_I2C is not set
# CONFIG_MFD_ARIZONA_SPI is not set
# CONFIG_MFD_WM8400 is not set
# CONFIG_MFD_WM831X_I2C is not set
# CONFIG_MFD_WM831X_SPI is not set
# CONFIG_MFD_WM8350_I2C is not set
# CONFIG_MFD_WM8994 is not set
# CONFIG_MFD_ATC260X_I2C is not set
# CONFIG_MFD_INTEL_M10_BMC is not set
# end of Multifunction device drivers

# CONFIG_REGULATOR is not set
CONFIG_RC_CORE=m
CONFIG_RC_MAP=m
CONFIG_LIRC=y
CONFIG_RC_DECODERS=y
CONFIG_IR_NEC_DECODER=m
CONFIG_IR_RC5_DECODER=m
CONFIG_IR_RC6_DECODER=m
CONFIG_IR_JVC_DECODER=m
CONFIG_IR_SONY_DECODER=m
CONFIG_IR_SANYO_DECODER=m
CONFIG_IR_SHARP_DECODER=m
CONFIG_IR_MCE_KBD_DECODER=m
# CONFIG_IR_XMP_DECODER is not set
CONFIG_IR_IMON_DECODER=m
# CONFIG_IR_RCMM_DECODER is not set
CONFIG_RC_DEVICES=y
# CONFIG_RC_ATI_REMOTE is not set
CONFIG_IR_ENE=m
# CONFIG_IR_IMON is not set
# CONFIG_IR_IMON_RAW is not set
# CONFIG_IR_MCEUSB is not set
CONFIG_IR_ITE_CIR=m
CONFIG_IR_FINTEK=m
CONFIG_IR_NUVOTON=m
# CONFIG_IR_REDRAT3 is not set
# CONFIG_IR_STREAMZAP is not set
CONFIG_IR_WINBOND_CIR=m
# CONFIG_IR_IGORPLUGUSB is not set
# CONFIG_IR_IGUANA is not set
# CONFIG_IR_TTUSBIR is not set
CONFIG_RC_LOOPBACK=m
CONFIG_IR_SERIAL=m
CONFIG_IR_SERIAL_TRANSMITTER=y
CONFIG_IR_SIR=m
# CONFIG_RC_XBOX_DVD is not set
# CONFIG_IR_TOY is not set
CONFIG_MEDIA_CEC_SUPPORT=y
# CONFIG_CEC_CH7322 is not set
# CONFIG_CEC_GPIO is not set
# CONFIG_CEC_SECO is not set
# CONFIG_USB_PULSE8_CEC is not set
# CONFIG_USB_RAINSHADOW_CEC is not set
CONFIG_MEDIA_SUPPORT=m
# CONFIG_MEDIA_SUPPORT_FILTER is not set
# CONFIG_MEDIA_SUBDRV_AUTOSELECT is not set

#
# Media device types
#
CONFIG_MEDIA_CAMERA_SUPPORT=y
CONFIG_MEDIA_ANALOG_TV_SUPPORT=y
CONFIG_MEDIA_DIGITAL_TV_SUPPORT=y
CONFIG_MEDIA_RADIO_SUPPORT=y
CONFIG_MEDIA_SDR_SUPPORT=y
CONFIG_MEDIA_PLATFORM_SUPPORT=y
CONFIG_MEDIA_TEST_SUPPORT=y
# end of Media device types

#
# Media core support
#
CONFIG_VIDEO_DEV=m
CONFIG_MEDIA_CONTROLLER=y
CONFIG_DVB_CORE=m
# end of Media core support

#
# Video4Linux options
#
CONFIG_VIDEO_V4L2=m
CONFIG_VIDEO_V4L2_I2C=y
CONFIG_VIDEO_V4L2_SUBDEV_API=y
# CONFIG_VIDEO_ADV_DEBUG is not set
# CONFIG_VIDEO_FIXED_MINOR_RANGES is not set
# end of Video4Linux options

#
# Media controller options
#
# CONFIG_MEDIA_CONTROLLER_DVB is not set
# end of Media controller options

#
# Digital TV options
#
# CONFIG_DVB_MMAP is not set
CONFIG_DVB_NET=y
CONFIG_DVB_MAX_ADAPTERS=16
CONFIG_DVB_DYNAMIC_MINORS=y
# CONFIG_DVB_DEMUX_SECTION_LOSS_LOG is not set
# CONFIG_DVB_ULE_DEBUG is not set
# end of Digital TV options

#
# Media drivers
#
# CONFIG_MEDIA_USB_SUPPORT is not set
# CONFIG_MEDIA_PCI_SUPPORT is not set
CONFIG_RADIO_ADAPTERS=y
# CONFIG_RADIO_SI470X is not set
# CONFIG_RADIO_SI4713 is not set
# CONFIG_USB_MR800 is not set
# CONFIG_USB_DSBR is not set
# CONFIG_RADIO_MAXIRADIO is not set
# CONFIG_RADIO_SHARK is not set
# CONFIG_RADIO_SHARK2 is not set
# CONFIG_USB_KEENE is not set
# CONFIG_USB_RAREMONO is not set
# CONFIG_USB_MA901 is not set
# CONFIG_RADIO_TEA5764 is not set
# CONFIG_RADIO_SAA7706H is not set
# CONFIG_RADIO_TEF6862 is not set
# CONFIG_RADIO_WL1273 is not set
CONFIG_VIDEOBUF2_CORE=m
CONFIG_VIDEOBUF2_V4L2=m
CONFIG_VIDEOBUF2_MEMOPS=m
CONFIG_VIDEOBUF2_VMALLOC=m
# CONFIG_V4L_PLATFORM_DRIVERS is not set
# CONFIG_V4L_MEM2MEM_DRIVERS is not set
# CONFIG_DVB_PLATFORM_DRIVERS is not set
# CONFIG_SDR_PLATFORM_DRIVERS is not set

#
# MMC/SDIO DVB adapters
#
# CONFIG_SMS_SDIO_DRV is not set
# CONFIG_V4L_TEST_DRIVERS is not set
# CONFIG_DVB_TEST_DRIVERS is not set

#
# FireWire (IEEE 1394) Adapters
#
# CONFIG_DVB_FIREDTV is not set
# end of Media drivers

#
# Media ancillary drivers
#
CONFIG_MEDIA_ATTACH=y
CONFIG_VIDEO_IR_I2C=m

#
# Audio decoders, processors and mixers
#
# CONFIG_VIDEO_TVAUDIO is not set
# CONFIG_VIDEO_TDA7432 is not set
# CONFIG_VIDEO_TDA9840 is not set
# CONFIG_VIDEO_TEA6415C is not set
# CONFIG_VIDEO_TEA6420 is not set
# CONFIG_VIDEO_MSP3400 is not set
# CONFIG_VIDEO_CS3308 is not set
# CONFIG_VIDEO_CS5345 is not set
# CONFIG_VIDEO_CS53L32A is not set
# CONFIG_VIDEO_TLV320AIC23B is not set
# CONFIG_VIDEO_UDA1342 is not set
# CONFIG_VIDEO_WM8775 is not set
# CONFIG_VIDEO_WM8739 is not set
# CONFIG_VIDEO_VP27SMPX is not set
# CONFIG_VIDEO_SONY_BTF_MPX is not set
# end of Audio decoders, processors and mixers

#
# RDS decoders
#
# CONFIG_VIDEO_SAA6588 is not set
# end of RDS decoders

#
# Video decoders
#
# CONFIG_VIDEO_ADV7180 is not set
# CONFIG_VIDEO_ADV7183 is not set
# CONFIG_VIDEO_ADV7604 is not set
# CONFIG_VIDEO_ADV7842 is not set
# CONFIG_VIDEO_BT819 is not set
# CONFIG_VIDEO_BT856 is not set
# CONFIG_VIDEO_BT866 is not set
# CONFIG_VIDEO_KS0127 is not set
# CONFIG_VIDEO_ML86V7667 is not set
# CONFIG_VIDEO_SAA7110 is not set
# CONFIG_VIDEO_SAA711X is not set
# CONFIG_VIDEO_TC358743 is not set
# CONFIG_VIDEO_TVP514X is not set
# CONFIG_VIDEO_TVP5150 is not set
# CONFIG_VIDEO_TVP7002 is not set
# CONFIG_VIDEO_TW2804 is not set
# CONFIG_VIDEO_TW9903 is not set
# CONFIG_VIDEO_TW9906 is not set
# CONFIG_VIDEO_TW9910 is not set
# CONFIG_VIDEO_VPX3220 is not set

#
# Video and audio decoders
#
# CONFIG_VIDEO_SAA717X is not set
# CONFIG_VIDEO_CX25840 is not set
# end of Video decoders

#
# Video encoders
#
# CONFIG_VIDEO_SAA7127 is not set
# CONFIG_VIDEO_SAA7185 is not set
# CONFIG_VIDEO_ADV7170 is not set
# CONFIG_VIDEO_ADV7175 is not set
# CONFIG_VIDEO_ADV7343 is not set
# CONFIG_VIDEO_ADV7393 is not set
# CONFIG_VIDEO_ADV7511 is not set
# CONFIG_VIDEO_AD9389B is not set
# CONFIG_VIDEO_AK881X is not set
# CONFIG_VIDEO_THS8200 is not set
# end of Video encoders

#
# Video improvement chips
#
# CONFIG_VIDEO_UPD64031A is not set
# CONFIG_VIDEO_UPD64083 is not set
# end of Video improvement chips

#
# Audio/Video compression chips
#
# CONFIG_VIDEO_SAA6752HS is not set
# end of Audio/Video compression chips

#
# SDR tuner chips
#
# CONFIG_SDR_MAX2175 is not set
# end of SDR tuner chips

#
# Miscellaneous helper chips
#
# CONFIG_VIDEO_THS7303 is not set
# CONFIG_VIDEO_M52790 is not set
# CONFIG_VIDEO_I2C is not set
# CONFIG_VIDEO_ST_MIPID02 is not set
# end of Miscellaneous helper chips

#
# Camera sensor devices
#
# CONFIG_VIDEO_HI556 is not set
# CONFIG_VIDEO_IMX208 is not set
# CONFIG_VIDEO_IMX214 is not set
# CONFIG_VIDEO_IMX219 is not set
# CONFIG_VIDEO_IMX258 is not set
# CONFIG_VIDEO_IMX274 is not set
# CONFIG_VIDEO_IMX290 is not set
# CONFIG_VIDEO_IMX319 is not set
# CONFIG_VIDEO_IMX355 is not set
# CONFIG_VIDEO_OV02A10 is not set
# CONFIG_VIDEO_OV2640 is not set
# CONFIG_VIDEO_OV2659 is not set
# CONFIG_VIDEO_OV2680 is not set
# CONFIG_VIDEO_OV2685 is not set
# CONFIG_VIDEO_OV2740 is not set
# CONFIG_VIDEO_OV5647 is not set
# CONFIG_VIDEO_OV5648 is not set
# CONFIG_VIDEO_OV6650 is not set
# CONFIG_VIDEO_OV5670 is not set
# CONFIG_VIDEO_OV5675 is not set
# CONFIG_VIDEO_OV5695 is not set
# CONFIG_VIDEO_OV7251 is not set
# CONFIG_VIDEO_OV772X is not set
# CONFIG_VIDEO_OV7640 is not set
# CONFIG_VIDEO_OV7670 is not set
# CONFIG_VIDEO_OV7740 is not set
# CONFIG_VIDEO_OV8856 is not set
# CONFIG_VIDEO_OV8865 is not set
# CONFIG_VIDEO_OV9640 is not set
# CONFIG_VIDEO_OV9650 is not set
# CONFIG_VIDEO_OV9734 is not set
# CONFIG_VIDEO_OV13858 is not set
# CONFIG_VIDEO_VS6624 is not set
# CONFIG_VIDEO_MT9M001 is not set
# CONFIG_VIDEO_MT9M032 is not set
# CONFIG_VIDEO_MT9M111 is not set
# CONFIG_VIDEO_MT9P031 is not set
# CONFIG_VIDEO_MT9T001 is not set
# CONFIG_VIDEO_MT9T112 is not set
# CONFIG_VIDEO_MT9V011 is not set
# CONFIG_VIDEO_MT9V032 is not set
# CONFIG_VIDEO_MT9V111 is not set
# CONFIG_VIDEO_SR030PC30 is not set
# CONFIG_VIDEO_NOON010PC30 is not set
# CONFIG_VIDEO_M5MOLS is not set
# CONFIG_VIDEO_RDACM20 is not set
# CONFIG_VIDEO_RDACM21 is not set
# CONFIG_VIDEO_RJ54N1 is not set
# CONFIG_VIDEO_S5K6AA is not set
# CONFIG_VIDEO_S5K6A3 is not set
# CONFIG_VIDEO_S5K4ECGX is not set
# CONFIG_VIDEO_S5K5BAF is not set
# CONFIG_VIDEO_CCS is not set
# CONFIG_VIDEO_ET8EK8 is not set
# CONFIG_VIDEO_S5C73M3 is not set
# end of Camera sensor devices

#
# Lens drivers
#
# CONFIG_VIDEO_AD5820 is not set
# CONFIG_VIDEO_AK7375 is not set
# CONFIG_VIDEO_DW9714 is not set
# CONFIG_VIDEO_DW9768 is not set
# CONFIG_VIDEO_DW9807_VCM is not set
# end of Lens drivers

#
# Flash devices
#
# CONFIG_VIDEO_ADP1653 is not set
# CONFIG_VIDEO_LM3560 is not set
# CONFIG_VIDEO_LM3646 is not set
# end of Flash devices

#
# SPI helper chips
#
# CONFIG_VIDEO_GS1662 is not set
# end of SPI helper chips

#
# Media SPI Adapters
#
CONFIG_CXD2880_SPI_DRV=m
# end of Media SPI Adapters

CONFIG_MEDIA_TUNER=m

#
# Customize TV tuners
#
CONFIG_MEDIA_TUNER_SIMPLE=m
CONFIG_MEDIA_TUNER_TDA18250=m
CONFIG_MEDIA_TUNER_TDA8290=m
CONFIG_MEDIA_TUNER_TDA827X=m
CONFIG_MEDIA_TUNER_TDA18271=m
CONFIG_MEDIA_TUNER_TDA9887=m
CONFIG_MEDIA_TUNER_TEA5761=m
CONFIG_MEDIA_TUNER_TEA5767=m
CONFIG_MEDIA_TUNER_MSI001=m
CONFIG_MEDIA_TUNER_MT20XX=m
CONFIG_MEDIA_TUNER_MT2060=m
CONFIG_MEDIA_TUNER_MT2063=m
CONFIG_MEDIA_TUNER_MT2266=m
CONFIG_MEDIA_TUNER_MT2131=m
CONFIG_MEDIA_TUNER_QT1010=m
CONFIG_MEDIA_TUNER_XC2028=m
CONFIG_MEDIA_TUNER_XC5000=m
CONFIG_MEDIA_TUNER_XC4000=m
CONFIG_MEDIA_TUNER_MXL5005S=m
CONFIG_MEDIA_TUNER_MXL5007T=m
CONFIG_MEDIA_TUNER_MC44S803=m
CONFIG_MEDIA_TUNER_MAX2165=m
CONFIG_MEDIA_TUNER_TDA18218=m
CONFIG_MEDIA_TUNER_FC0011=m
CONFIG_MEDIA_TUNER_FC0012=m
CONFIG_MEDIA_TUNER_FC0013=m
CONFIG_MEDIA_TUNER_TDA18212=m
CONFIG_MEDIA_TUNER_E4000=m
CONFIG_MEDIA_TUNER_FC2580=m
CONFIG_MEDIA_TUNER_M88RS6000T=m
CONFIG_MEDIA_TUNER_TUA9001=m
CONFIG_MEDIA_TUNER_SI2157=m
CONFIG_MEDIA_TUNER_IT913X=m
CONFIG_MEDIA_TUNER_R820T=m
CONFIG_MEDIA_TUNER_MXL301RF=m
CONFIG_MEDIA_TUNER_QM1D1C0042=m
CONFIG_MEDIA_TUNER_QM1D1B0004=m
# end of Customize TV tuners

#
# Customise DVB Frontends
#

#
# Multistandard (satellite) frontends
#
CONFIG_DVB_STB0899=m
CONFIG_DVB_STB6100=m
CONFIG_DVB_STV090x=m
CONFIG_DVB_STV0910=m
CONFIG_DVB_STV6110x=m
CONFIG_DVB_STV6111=m
CONFIG_DVB_MXL5XX=m
CONFIG_DVB_M88DS3103=m

#
# Multistandard (cable + terrestrial) frontends
#
CONFIG_DVB_DRXK=m
CONFIG_DVB_TDA18271C2DD=m
CONFIG_DVB_SI2165=m
CONFIG_DVB_MN88472=m
CONFIG_DVB_MN88473=m

#
# DVB-S (satellite) frontends
#
CONFIG_DVB_CX24110=m
CONFIG_DVB_CX24123=m
CONFIG_DVB_MT312=m
CONFIG_DVB_ZL10036=m
CONFIG_DVB_ZL10039=m
CONFIG_DVB_S5H1420=m
CONFIG_DVB_STV0288=m
CONFIG_DVB_STB6000=m
CONFIG_DVB_STV0299=m
CONFIG_DVB_STV6110=m
CONFIG_DVB_STV0900=m
CONFIG_DVB_TDA8083=m
CONFIG_DVB_TDA10086=m
CONFIG_DVB_TDA8261=m
CONFIG_DVB_VES1X93=m
CONFIG_DVB_TUNER_ITD1000=m
CONFIG_DVB_TUNER_CX24113=m
CONFIG_DVB_TDA826X=m
CONFIG_DVB_TUA6100=m
CONFIG_DVB_CX24116=m
CONFIG_DVB_CX24117=m
CONFIG_DVB_CX24120=m
CONFIG_DVB_SI21XX=m
CONFIG_DVB_TS2020=m
CONFIG_DVB_DS3000=m
CONFIG_DVB_MB86A16=m
CONFIG_DVB_TDA10071=m

#
# DVB-T (terrestrial) frontends
#
CONFIG_DVB_SP887X=m
CONFIG_DVB_CX22700=m
CONFIG_DVB_CX22702=m
CONFIG_DVB_S5H1432=m
CONFIG_DVB_DRXD=m
CONFIG_DVB_L64781=m
CONFIG_DVB_TDA1004X=m
CONFIG_DVB_NXT6000=m
CONFIG_DVB_MT352=m
CONFIG_DVB_ZL10353=m
CONFIG_DVB_DIB3000MB=m
CONFIG_DVB_DIB3000MC=m
CONFIG_DVB_DIB7000M=m
CONFIG_DVB_DIB7000P=m
CONFIG_DVB_DIB9000=m
CONFIG_DVB_TDA10048=m
CONFIG_DVB_AF9013=m
CONFIG_DVB_EC100=m
CONFIG_DVB_STV0367=m
CONFIG_DVB_CXD2820R=m
CONFIG_DVB_CXD2841ER=m
CONFIG_DVB_RTL2830=m
CONFIG_DVB_RTL2832=m
CONFIG_DVB_RTL2832_SDR=m
CONFIG_DVB_SI2168=m
CONFIG_DVB_ZD1301_DEMOD=m
CONFIG_DVB_CXD2880=m

#
# DVB-C (cable) frontends
#
CONFIG_DVB_VES1820=m
CONFIG_DVB_TDA10021=m
CONFIG_DVB_TDA10023=m
CONFIG_DVB_STV0297=m

#
# ATSC (North American/Korean Terrestrial/Cable DTV) frontends
#
CONFIG_DVB_NXT200X=m
CONFIG_DVB_OR51211=m
CONFIG_DVB_OR51132=m
CONFIG_DVB_BCM3510=m
CONFIG_DVB_LGDT330X=m
CONFIG_DVB_LGDT3305=m
CONFIG_DVB_LGDT3306A=m
CONFIG_DVB_LG2160=m
CONFIG_DVB_S5H1409=m
CONFIG_DVB_AU8522=m
CONFIG_DVB_AU8522_DTV=m
CONFIG_DVB_AU8522_V4L=m
CONFIG_DVB_S5H1411=m
CONFIG_DVB_MXL692=m

#
# ISDB-T (terrestrial) frontends
#
CONFIG_DVB_S921=m
CONFIG_DVB_DIB8000=m
CONFIG_DVB_MB86A20S=m

#
# ISDB-S (satellite) & ISDB-T (terrestrial) frontends
#
CONFIG_DVB_TC90522=m
CONFIG_DVB_MN88443X=m

#
# Digital terrestrial only tuners/PLL
#
CONFIG_DVB_PLL=m
CONFIG_DVB_TUNER_DIB0070=m
CONFIG_DVB_TUNER_DIB0090=m

#
# SEC control devices for DVB-S
#
CONFIG_DVB_DRX39XYJ=m
CONFIG_DVB_LNBH25=m
CONFIG_DVB_LNBH29=m
CONFIG_DVB_LNBP21=m
CONFIG_DVB_LNBP22=m
CONFIG_DVB_ISL6405=m
CONFIG_DVB_ISL6421=m
CONFIG_DVB_ISL6423=m
CONFIG_DVB_A8293=m
CONFIG_DVB_LGS8GL5=m
CONFIG_DVB_LGS8GXX=m
CONFIG_DVB_ATBM8830=m
CONFIG_DVB_TDA665x=m
CONFIG_DVB_IX2505V=m
CONFIG_DVB_M88RS2000=m
CONFIG_DVB_AF9033=m
CONFIG_DVB_HORUS3A=m
CONFIG_DVB_ASCOT2E=m
CONFIG_DVB_HELENE=m

#
# Common Interface (EN50221) controller drivers
#
CONFIG_DVB_CXD2099=m
CONFIG_DVB_SP2=m
# end of Customise DVB Frontends

#
# Tools to develop new frontends
#
# CONFIG_DVB_DUMMY_FE is not set
# end of Media ancillary drivers

#
# Graphics support
#
# CONFIG_AGP is not set
CONFIG_INTEL_GTT=m
CONFIG_VGA_ARB=y
CONFIG_VGA_ARB_MAX_GPUS=64
CONFIG_VGA_SWITCHEROO=y
CONFIG_DRM=y
CONFIG_DRM_MIPI_DSI=y
CONFIG_DRM_DP_AUX_CHARDEV=y
# CONFIG_DRM_DEBUG_MM is not set
CONFIG_DRM_DEBUG_SELFTEST=m
CONFIG_DRM_KMS_HELPER=y
# CONFIG_DRM_DEBUG_DP_MST_TOPOLOGY_REFS is not set
CONFIG_DRM_FBDEV_EMULATION=y
CONFIG_DRM_FBDEV_OVERALLOC=100
# CONFIG_DRM_FBDEV_LEAK_PHYS_SMEM is not set
CONFIG_DRM_LOAD_EDID_FIRMWARE=y
# CONFIG_DRM_DP_CEC is not set
CONFIG_DRM_TTM=m
CONFIG_DRM_VRAM_HELPER=m
CONFIG_DRM_TTM_HELPER=m
CONFIG_DRM_GEM_SHMEM_HELPER=y

#
# I2C encoder or helper chips
#
CONFIG_DRM_I2C_CH7006=m
CONFIG_DRM_I2C_SIL164=m
# CONFIG_DRM_I2C_NXP_TDA998X is not set
# CONFIG_DRM_I2C_NXP_TDA9950 is not set
# end of I2C encoder or helper chips

#
# ARM devices
#
# end of ARM devices

# CONFIG_DRM_RADEON is not set
# CONFIG_DRM_AMDGPU is not set
# CONFIG_DRM_NOUVEAU is not set
CONFIG_DRM_I915=m
CONFIG_DRM_I915_FORCE_PROBE=""
CONFIG_DRM_I915_CAPTURE_ERROR=y
CONFIG_DRM_I915_COMPRESS_ERROR=y
CONFIG_DRM_I915_USERPTR=y
CONFIG_DRM_I915_GVT=y
# CONFIG_DRM_I915_GVT_KVMGT is not set

#
# drm/i915 Debugging
#
# CONFIG_DRM_I915_WERROR is not set
# CONFIG_DRM_I915_DEBUG is not set
# CONFIG_DRM_I915_DEBUG_MMIO is not set
# CONFIG_DRM_I915_SW_FENCE_DEBUG_OBJECTS is not set
# CONFIG_DRM_I915_SW_FENCE_CHECK_DAG is not set
# CONFIG_DRM_I915_DEBUG_GUC is not set
# CONFIG_DRM_I915_SELFTEST is not set
# CONFIG_DRM_I915_LOW_LEVEL_TRACEPOINTS is not set
# CONFIG_DRM_I915_DEBUG_VBLANK_EVADE is not set
# CONFIG_DRM_I915_DEBUG_RUNTIME_PM is not set
# end of drm/i915 Debugging

#
# drm/i915 Profile Guided Optimisation
#
CONFIG_DRM_I915_REQUEST_TIMEOUT=20000
CONFIG_DRM_I915_FENCE_TIMEOUT=10000
CONFIG_DRM_I915_USERFAULT_AUTOSUSPEND=250
CONFIG_DRM_I915_HEARTBEAT_INTERVAL=2500
CONFIG_DRM_I915_PREEMPT_TIMEOUT=640
CONFIG_DRM_I915_MAX_REQUEST_BUSYWAIT=8000
CONFIG_DRM_I915_STOP_TIMEOUT=100
CONFIG_DRM_I915_TIMESLICE_DURATION=1
# end of drm/i915 Profile Guided Optimisation

CONFIG_DRM_VGEM=y
# CONFIG_DRM_VKMS is not set
# CONFIG_DRM_VMWGFX is not set
CONFIG_DRM_GMA500=m
# CONFIG_DRM_UDL is not set
CONFIG_DRM_AST=m
CONFIG_DRM_MGAG200=m
CONFIG_DRM_QXL=m
CONFIG_DRM_VIRTIO_GPU=m
CONFIG_DRM_PANEL=y

#
# Display Panels
#
# CONFIG_DRM_PANEL_RASPBERRYPI_TOUCHSCREEN is not set
# CONFIG_DRM_PANEL_WIDECHIPS_WS2401 is not set
# end of Display Panels

CONFIG_DRM_BRIDGE=y
CONFIG_DRM_PANEL_BRIDGE=y

#
# Display Interface Bridges
#
# CONFIG_DRM_ANALOGIX_ANX78XX is not set
# end of Display Interface Bridges

# CONFIG_DRM_ETNAVIV is not set
CONFIG_DRM_BOCHS=m
CONFIG_DRM_CIRRUS_QEMU=m
# CONFIG_DRM_GM12U320 is not set
# CONFIG_DRM_SIMPLEDRM is not set
# CONFIG_TINYDRM_HX8357D is not set
# CONFIG_TINYDRM_ILI9225 is not set
# CONFIG_TINYDRM_ILI9341 is not set
# CONFIG_TINYDRM_ILI9486 is not set
# CONFIG_TINYDRM_MI0283QT is not set
# CONFIG_TINYDRM_REPAPER is not set
# CONFIG_TINYDRM_ST7586 is not set
# CONFIG_TINYDRM_ST7735R is not set
# CONFIG_DRM_VBOXVIDEO is not set
# CONFIG_DRM_GUD is not set
# CONFIG_DRM_HYPERV is not set
# CONFIG_DRM_LEGACY is not set
CONFIG_DRM_EXPORT_FOR_TESTS=y
CONFIG_DRM_PANEL_ORIENTATION_QUIRKS=y
CONFIG_DRM_LIB_RANDOM=y

#
# Frame buffer Devices
#
CONFIG_FB_CMDLINE=y
CONFIG_FB_NOTIFY=y
CONFIG_FB=y
# CONFIG_FIRMWARE_EDID is not set
CONFIG_FB_BOOT_VESA_SUPPORT=y
CONFIG_FB_CFB_FILLRECT=y
CONFIG_FB_CFB_COPYAREA=y
CONFIG_FB_CFB_IMAGEBLIT=y
CONFIG_FB_SYS_FILLRECT=y
CONFIG_FB_SYS_COPYAREA=y
CONFIG_FB_SYS_IMAGEBLIT=y
# CONFIG_FB_FOREIGN_ENDIAN is not set
CONFIG_FB_SYS_FOPS=y
CONFIG_FB_DEFERRED_IO=y
# CONFIG_FB_MODE_HELPERS is not set
CONFIG_FB_TILEBLITTING=y

#
# Frame buffer hardware drivers
#
# CONFIG_FB_CIRRUS is not set
# CONFIG_FB_PM2 is not set
# CONFIG_FB_CYBER2000 is not set
# CONFIG_FB_ARC is not set
# CONFIG_FB_ASILIANT is not set
# CONFIG_FB_IMSTT is not set
# CONFIG_FB_VGA16 is not set
# CONFIG_FB_UVESA is not set
CONFIG_FB_VESA=y
CONFIG_FB_EFI=y
# CONFIG_FB_N411 is not set
# CONFIG_FB_HGA is not set
# CONFIG_FB_OPENCORES is not set
# CONFIG_FB_S1D13XXX is not set
# CONFIG_FB_NVIDIA is not set
# CONFIG_FB_RIVA is not set
# CONFIG_FB_I740 is not set
# CONFIG_FB_LE80578 is not set
# CONFIG_FB_MATROX is not set
# CONFIG_FB_RADEON is not set
# CONFIG_FB_ATY128 is not set
# CONFIG_FB_ATY is not set
# CONFIG_FB_S3 is not set
# CONFIG_FB_SAVAGE is not set
# CONFIG_FB_SIS is not set
# CONFIG_FB_VIA is not set
# CONFIG_FB_NEOMAGIC is not set
# CONFIG_FB_KYRO is not set
# CONFIG_FB_3DFX is not set
# CONFIG_FB_VOODOO1 is not set
# CONFIG_FB_VT8623 is not set
# CONFIG_FB_TRIDENT is not set
# CONFIG_FB_ARK is not set
# CONFIG_FB_PM3 is not set
# CONFIG_FB_CARMINE is not set
# CONFIG_FB_SM501 is not set
# CONFIG_FB_SMSCUFX is not set
# CONFIG_FB_UDL is not set
# CONFIG_FB_IBM_GXT4500 is not set
# CONFIG_FB_VIRTUAL is not set
# CONFIG_FB_METRONOME is not set
# CONFIG_FB_MB862XX is not set
CONFIG_FB_HYPERV=m
# CONFIG_FB_SIMPLE is not set
# CONFIG_FB_SSD1307 is not set
# CONFIG_FB_SM712 is not set
# end of Frame buffer Devices

#
# Backlight & LCD device support
#
CONFIG_LCD_CLASS_DEVICE=m
# CONFIG_LCD_L4F00242T03 is not set
# CONFIG_LCD_LMS283GF05 is not set
# CONFIG_LCD_LTV350QV is not set
# CONFIG_LCD_ILI922X is not set
# CONFIG_LCD_ILI9320 is not set
# CONFIG_LCD_TDO24M is not set
# CONFIG_LCD_VGG2432A4 is not set
CONFIG_LCD_PLATFORM=m
# CONFIG_LCD_AMS369FG06 is not set
# CONFIG_LCD_LMS501KF03 is not set
# CONFIG_LCD_HX8357 is not set
# CONFIG_LCD_OTM3225A is not set
CONFIG_BACKLIGHT_CLASS_DEVICE=y
# CONFIG_BACKLIGHT_KTD253 is not set
# CONFIG_BACKLIGHT_PWM is not set
CONFIG_BACKLIGHT_APPLE=m
# CONFIG_BACKLIGHT_QCOM_WLED is not set
# CONFIG_BACKLIGHT_SAHARA is not set
# CONFIG_BACKLIGHT_ADP8860 is not set
# CONFIG_BACKLIGHT_ADP8870 is not set
# CONFIG_BACKLIGHT_LM3630A is not set
# CONFIG_BACKLIGHT_LM3639 is not set
CONFIG_BACKLIGHT_LP855X=m
# CONFIG_BACKLIGHT_GPIO is not set
# CONFIG_BACKLIGHT_LV5207LP is not set
# CONFIG_BACKLIGHT_BD6107 is not set
# CONFIG_BACKLIGHT_ARCXCNN is not set
# end of Backlight & LCD device support

CONFIG_HDMI=y

#
# Console display driver support
#
CONFIG_VGA_CONSOLE=y
CONFIG_DUMMY_CONSOLE=y
CONFIG_DUMMY_CONSOLE_COLUMNS=80
CONFIG_DUMMY_CONSOLE_ROWS=25
CONFIG_FRAMEBUFFER_CONSOLE=y
CONFIG_FRAMEBUFFER_CONSOLE_DETECT_PRIMARY=y
CONFIG_FRAMEBUFFER_CONSOLE_ROTATION=y
# CONFIG_FRAMEBUFFER_CONSOLE_DEFERRED_TAKEOVER is not set
# end of Console display driver support

CONFIG_LOGO=y
# CONFIG_LOGO_LINUX_MONO is not set
# CONFIG_LOGO_LINUX_VGA16 is not set
CONFIG_LOGO_LINUX_CLUT224=y
# end of Graphics support

# CONFIG_SOUND is not set

#
# HID support
#
CONFIG_HID=y
CONFIG_HID_BATTERY_STRENGTH=y
CONFIG_HIDRAW=y
CONFIG_UHID=m
CONFIG_HID_GENERIC=y

#
# Special HID drivers
#
CONFIG_HID_A4TECH=m
# CONFIG_HID_ACCUTOUCH is not set
CONFIG_HID_ACRUX=m
# CONFIG_HID_ACRUX_FF is not set
CONFIG_HID_APPLE=m
# CONFIG_HID_APPLEIR is not set
CONFIG_HID_ASUS=m
CONFIG_HID_AUREAL=m
CONFIG_HID_BELKIN=m
# CONFIG_HID_BETOP_FF is not set
# CONFIG_HID_BIGBEN_FF is not set
CONFIG_HID_CHERRY=m
CONFIG_HID_CHICONY=m
# CONFIG_HID_CORSAIR is not set
# CONFIG_HID_COUGAR is not set
# CONFIG_HID_MACALLY is not set
CONFIG_HID_CMEDIA=m
# CONFIG_HID_CP2112 is not set
# CONFIG_HID_CREATIVE_SB0540 is not set
CONFIG_HID_CYPRESS=m
CONFIG_HID_DRAGONRISE=m
# CONFIG_DRAGONRISE_FF is not set
# CONFIG_HID_EMS_FF is not set
# CONFIG_HID_ELAN is not set
CONFIG_HID_ELECOM=m
# CONFIG_HID_ELO is not set
CONFIG_HID_EZKEY=m
# CONFIG_HID_FT260 is not set
CONFIG_HID_GEMBIRD=m
CONFIG_HID_GFRM=m
# CONFIG_HID_GLORIOUS is not set
# CONFIG_HID_HOLTEK is not set
# CONFIG_HID_VIVALDI is not set
# CONFIG_HID_GT683R is not set
CONFIG_HID_KEYTOUCH=m
CONFIG_HID_KYE=m
# CONFIG_HID_UCLOGIC is not set
CONFIG_HID_WALTOP=m
# CONFIG_HID_VIEWSONIC is not set
CONFIG_HID_GYRATION=m
CONFIG_HID_ICADE=m
CONFIG_HID_ITE=m
CONFIG_HID_JABRA=m
CONFIG_HID_TWINHAN=m
CONFIG_HID_KENSINGTON=m
CONFIG_HID_LCPOWER=m
CONFIG_HID_LED=m
CONFIG_HID_LENOVO=m
CONFIG_HID_LOGITECH=m
CONFIG_HID_LOGITECH_DJ=m
CONFIG_HID_LOGITECH_HIDPP=m
# CONFIG_LOGITECH_FF is not set
# CONFIG_LOGIRUMBLEPAD2_FF is not set
# CONFIG_LOGIG940_FF is not set
# CONFIG_LOGIWHEELS_FF is not set
CONFIG_HID_MAGICMOUSE=y
# CONFIG_HID_MALTRON is not set
# CONFIG_HID_MAYFLASH is not set
# CONFIG_HID_REDRAGON is not set
CONFIG_HID_MICROSOFT=m
CONFIG_HID_MONTEREY=m
CONFIG_HID_MULTITOUCH=m
CONFIG_HID_NTI=m
# CONFIG_HID_NTRIG is not set
CONFIG_HID_ORTEK=m
CONFIG_HID_PANTHERLORD=m
# CONFIG_PANTHERLORD_FF is not set
# CONFIG_HID_PENMOUNT is not set
CONFIG_HID_PETALYNX=m
CONFIG_HID_PICOLCD=m
CONFIG_HID_PICOLCD_FB=y
CONFIG_HID_PICOLCD_BACKLIGHT=y
CONFIG_HID_PICOLCD_LCD=y
CONFIG_HID_PICOLCD_LEDS=y
CONFIG_HID_PICOLCD_CIR=y
CONFIG_HID_PLANTRONICS=m
# CONFIG_HID_PLAYSTATION is not set
CONFIG_HID_PRIMAX=m
# CONFIG_HID_RETRODE is not set
# CONFIG_HID_ROCCAT is not set
CONFIG_HID_SAITEK=m
CONFIG_HID_SAMSUNG=m
# CONFIG_HID_SEMITEK is not set
# CONFIG_HID_SONY is not set
CONFIG_HID_SPEEDLINK=m
# CONFIG_HID_STEAM is not set
CONFIG_HID_STEELSERIES=m
CONFIG_HID_SUNPLUS=m
CONFIG_HID_RMI=m
CONFIG_HID_GREENASIA=m
# CONFIG_GREENASIA_FF is not set
CONFIG_HID_HYPERV_MOUSE=m
CONFIG_HID_SMARTJOYPLUS=m
# CONFIG_SMARTJOYPLUS_FF is not set
CONFIG_HID_TIVO=m
CONFIG_HID_TOPSEED=m
CONFIG_HID_THINGM=m
CONFIG_HID_THRUSTMASTER=m
# CONFIG_THRUSTMASTER_FF is not set
# CONFIG_HID_UDRAW_PS3 is not set
# CONFIG_HID_U2FZERO is not set
# CONFIG_HID_WACOM is not set
CONFIG_HID_WIIMOTE=m
CONFIG_HID_XINMO=m
CONFIG_HID_ZEROPLUS=m
# CONFIG_ZEROPLUS_FF is not set
CONFIG_HID_ZYDACRON=m
CONFIG_HID_SENSOR_HUB=y
CONFIG_HID_SENSOR_CUSTOM_SENSOR=m
CONFIG_HID_ALPS=m
# CONFIG_HID_MCP2221 is not set
# end of Special HID drivers

#
# USB HID support
#
CONFIG_USB_HID=y
# CONFIG_HID_PID is not set
# CONFIG_USB_HIDDEV is not set
# end of USB HID support

#
# I2C HID support
#
# CONFIG_I2C_HID_ACPI is not set
# end of I2C HID support

#
# Intel ISH HID support
#
CONFIG_INTEL_ISH_HID=m
# CONFIG_INTEL_ISH_FIRMWARE_DOWNLOADER is not set
# end of Intel ISH HID support

#
# AMD SFH HID Support
#
# CONFIG_AMD_SFH_HID is not set
# end of AMD SFH HID Support
# end of HID support

CONFIG_USB_OHCI_LITTLE_ENDIAN=y
CONFIG_USB_SUPPORT=y
CONFIG_USB_COMMON=y
# CONFIG_USB_LED_TRIG is not set
# CONFIG_USB_ULPI_BUS is not set
# CONFIG_USB_CONN_GPIO is not set
CONFIG_USB_ARCH_HAS_HCD=y
CONFIG_USB=y
CONFIG_USB_PCI=y
CONFIG_USB_ANNOUNCE_NEW_DEVICES=y

#
# Miscellaneous USB options
#
CONFIG_USB_DEFAULT_PERSIST=y
# CONFIG_USB_FEW_INIT_RETRIES is not set
# CONFIG_USB_DYNAMIC_MINORS is not set
# CONFIG_USB_OTG is not set
# CONFIG_USB_OTG_PRODUCTLIST is not set
# CONFIG_USB_OTG_DISABLE_EXTERNAL_HUB is not set
CONFIG_USB_LEDS_TRIGGER_USBPORT=y
CONFIG_USB_AUTOSUSPEND_DELAY=2
CONFIG_USB_MON=y

#
# USB Host Controller Drivers
#
# CONFIG_USB_C67X00_HCD is not set
CONFIG_USB_XHCI_HCD=y
# CONFIG_USB_XHCI_DBGCAP is not set
CONFIG_USB_XHCI_PCI=y
# CONFIG_USB_XHCI_PCI_RENESAS is not set
# CONFIG_USB_XHCI_PLATFORM is not set
CONFIG_USB_EHCI_HCD=y
CONFIG_USB_EHCI_ROOT_HUB_TT=y
CONFIG_USB_EHCI_TT_NEWSCHED=y
CONFIG_USB_EHCI_PCI=y
# CONFIG_USB_EHCI_FSL is not set
# CONFIG_USB_EHCI_HCD_PLATFORM is not set
# CONFIG_USB_OXU210HP_HCD is not set
# CONFIG_USB_ISP116X_HCD is not set
# CONFIG_USB_FOTG210_HCD is not set
# CONFIG_USB_MAX3421_HCD is not set
CONFIG_USB_OHCI_HCD=y
CONFIG_USB_OHCI_HCD_PCI=y
# CONFIG_USB_OHCI_HCD_PLATFORM is not set
CONFIG_USB_UHCI_HCD=y
# CONFIG_USB_SL811_HCD is not set
# CONFIG_USB_R8A66597_HCD is not set
# CONFIG_USB_HCD_BCMA is not set
# CONFIG_USB_HCD_TEST_MODE is not set

#
# USB Device Class drivers
#
# CONFIG_USB_ACM is not set
# CONFIG_USB_PRINTER is not set
# CONFIG_USB_WDM is not set
# CONFIG_USB_TMC is not set

#
# NOTE: USB_STORAGE depends on SCSI but BLK_DEV_SD may
#

#
# also be needed; see USB_STORAGE Help for more info
#
CONFIG_USB_STORAGE=m
# CONFIG_USB_STORAGE_DEBUG is not set
# CONFIG_USB_STORAGE_REALTEK is not set
# CONFIG_USB_STORAGE_DATAFAB is not set
# CONFIG_USB_STORAGE_FREECOM is not set
# CONFIG_USB_STORAGE_ISD200 is not set
# CONFIG_USB_STORAGE_USBAT is not set
# CONFIG_USB_STORAGE_SDDR09 is not set
# CONFIG_USB_STORAGE_SDDR55 is not set
# CONFIG_USB_STORAGE_JUMPSHOT is not set
# CONFIG_USB_STORAGE_ALAUDA is not set
# CONFIG_USB_STORAGE_ONETOUCH is not set
# CONFIG_USB_STORAGE_KARMA is not set
# CONFIG_USB_STORAGE_CYPRESS_ATACB is not set
# CONFIG_USB_STORAGE_ENE_UB6250 is not set
# CONFIG_USB_UAS is not set

#
# USB Imaging devices
#
# CONFIG_USB_MDC800 is not set
# CONFIG_USB_MICROTEK is not set
# CONFIG_USBIP_CORE is not set
# CONFIG_USB_CDNS_SUPPORT is not set
# CONFIG_USB_MUSB_HDRC is not set
# CONFIG_USB_DWC3 is not set
# CONFIG_USB_DWC2 is not set
# CONFIG_USB_CHIPIDEA is not set
# CONFIG_USB_ISP1760 is not set

#
# USB port drivers
#
# CONFIG_USB_USS720 is not set
CONFIG_USB_SERIAL=m
CONFIG_USB_SERIAL_GENERIC=y
# CONFIG_USB_SERIAL_SIMPLE is not set
# CONFIG_USB_SERIAL_AIRCABLE is not set
# CONFIG_USB_SERIAL_ARK3116 is not set
# CONFIG_USB_SERIAL_BELKIN is not set
# CONFIG_USB_SERIAL_CH341 is not set
# CONFIG_USB_SERIAL_WHITEHEAT is not set
# CONFIG_USB_SERIAL_DIGI_ACCELEPORT is not set
# CONFIG_USB_SERIAL_CP210X is not set
# CONFIG_USB_SERIAL_CYPRESS_M8 is not set
# CONFIG_USB_SERIAL_EMPEG is not set
# CONFIG_USB_SERIAL_FTDI_SIO is not set
# CONFIG_USB_SERIAL_VISOR is not set
# CONFIG_USB_SERIAL_IPAQ is not set
# CONFIG_USB_SERIAL_IR is not set
# CONFIG_USB_SERIAL_EDGEPORT is not set
# CONFIG_USB_SERIAL_EDGEPORT_TI is not set
# CONFIG_USB_SERIAL_F81232 is not set
# CONFIG_USB_SERIAL_F8153X is not set
# CONFIG_USB_SERIAL_GARMIN is not set
# CONFIG_USB_SERIAL_IPW is not set
# CONFIG_USB_SERIAL_IUU is not set
# CONFIG_USB_SERIAL_KEYSPAN_PDA is not set
# CONFIG_USB_SERIAL_KEYSPAN is not set
# CONFIG_USB_SERIAL_KLSI is not set
# CONFIG_USB_SERIAL_KOBIL_SCT is not set
# CONFIG_USB_SERIAL_MCT_U232 is not set
# CONFIG_USB_SERIAL_METRO is not set
# CONFIG_USB_SERIAL_MOS7720 is not set
# CONFIG_USB_SERIAL_MOS7840 is not set
# CONFIG_USB_SERIAL_MXUPORT is not set
# CONFIG_USB_SERIAL_NAVMAN is not set
# CONFIG_USB_SERIAL_PL2303 is not set
# CONFIG_USB_SERIAL_OTI6858 is not set
# CONFIG_USB_SERIAL_QCAUX is not set
# CONFIG_USB_SERIAL_QUALCOMM is not set
# CONFIG_USB_SERIAL_SPCP8X5 is not set
# CONFIG_USB_SERIAL_SAFE is not set
# CONFIG_USB_SERIAL_SIERRAWIRELESS is not set
# CONFIG_USB_SERIAL_SYMBOL is not set
# CONFIG_USB_SERIAL_TI is not set
# CONFIG_USB_SERIAL_CYBERJACK is not set
# CONFIG_USB_SERIAL_OPTION is not set
# CONFIG_USB_SERIAL_OMNINET is not set
# CONFIG_USB_SERIAL_OPTICON is not set
# CONFIG_USB_SERIAL_XSENS_MT is not set
# CONFIG_USB_SERIAL_WISHBONE is not set
# CONFIG_USB_SERIAL_SSU100 is not set
# CONFIG_USB_SERIAL_QT2 is not set
# CONFIG_USB_SERIAL_UPD78F0730 is not set
# CONFIG_USB_SERIAL_XR is not set
CONFIG_USB_SERIAL_DEBUG=m

#
# USB Miscellaneous drivers
#
# CONFIG_USB_EMI62 is not set
# CONFIG_USB_EMI26 is not set
# CONFIG_USB_ADUTUX is not set
# CONFIG_USB_SEVSEG is not set
# CONFIG_USB_LEGOTOWER is not set
# CONFIG_USB_LCD is not set
# CONFIG_USB_CYPRESS_CY7C63 is not set
# CONFIG_USB_CYTHERM is not set
# CONFIG_USB_IDMOUSE is not set
# CONFIG_USB_FTDI_ELAN is not set
# CONFIG_USB_APPLEDISPLAY is not set
# CONFIG_APPLE_MFI_FASTCHARGE is not set
# CONFIG_USB_SISUSBVGA is not set
# CONFIG_USB_LD is not set
# CONFIG_USB_TRANCEVIBRATOR is not set
# CONFIG_USB_IOWARRIOR is not set
# CONFIG_USB_TEST is not set
# CONFIG_USB_EHSET_TEST_FIXTURE is not set
# CONFIG_USB_ISIGHTFW is not set
# CONFIG_USB_YUREX is not set
# CONFIG_USB_EZUSB_FX2 is not set
# CONFIG_USB_HUB_USB251XB is not set
# CONFIG_USB_HSIC_USB3503 is not set
# CONFIG_USB_HSIC_USB4604 is not set
# CONFIG_USB_LINK_LAYER_TEST is not set
# CONFIG_USB_CHAOSKEY is not set
# CONFIG_USB_ATM is not set

#
# USB Physical Layer drivers
#
# CONFIG_NOP_USB_XCEIV is not set
# CONFIG_USB_GPIO_VBUS is not set
# CONFIG_USB_ISP1301 is not set
# end of USB Physical Layer drivers

# CONFIG_USB_GADGET is not set
CONFIG_TYPEC=y
# CONFIG_TYPEC_TCPM is not set
CONFIG_TYPEC_UCSI=y
# CONFIG_UCSI_CCG is not set
CONFIG_UCSI_ACPI=y
# CONFIG_TYPEC_TPS6598X is not set
# CONFIG_TYPEC_STUSB160X is not set

#
# USB Type-C Multiplexer/DeMultiplexer Switch support
#
# CONFIG_TYPEC_MUX_PI3USB30532 is not set
# end of USB Type-C Multiplexer/DeMultiplexer Switch support

#
# USB Type-C Alternate Mode drivers
#
# CONFIG_TYPEC_DP_ALTMODE is not set
# end of USB Type-C Alternate Mode drivers

# CONFIG_USB_ROLE_SWITCH is not set
CONFIG_MMC=m
CONFIG_MMC_BLOCK=m
CONFIG_MMC_BLOCK_MINORS=8
CONFIG_SDIO_UART=m
# CONFIG_MMC_TEST is not set

#
# MMC/SD/SDIO Host Controller Drivers
#
# CONFIG_MMC_DEBUG is not set
CONFIG_MMC_SDHCI=m
CONFIG_MMC_SDHCI_IO_ACCESSORS=y
CONFIG_MMC_SDHCI_PCI=m
CONFIG_MMC_RICOH_MMC=y
CONFIG_MMC_SDHCI_ACPI=m
CONFIG_MMC_SDHCI_PLTFM=m
# CONFIG_MMC_SDHCI_F_SDH30 is not set
# CONFIG_MMC_WBSD is not set
# CONFIG_MMC_TIFM_SD is not set
# CONFIG_MMC_SPI is not set
# CONFIG_MMC_CB710 is not set
# CONFIG_MMC_VIA_SDMMC is not set
# CONFIG_MMC_VUB300 is not set
# CONFIG_MMC_USHC is not set
# CONFIG_MMC_USDHI6ROL0 is not set
# CONFIG_MMC_REALTEK_PCI is not set
CONFIG_MMC_CQHCI=m
# CONFIG_MMC_HSQ is not set
# CONFIG_MMC_TOSHIBA_PCI is not set
# CONFIG_MMC_MTK is not set
# CONFIG_MMC_SDHCI_XENON is not set
# CONFIG_MEMSTICK is not set
CONFIG_NEW_LEDS=y
CONFIG_LEDS_CLASS=y
# CONFIG_LEDS_CLASS_FLASH is not set
# CONFIG_LEDS_CLASS_MULTICOLOR is not set
# CONFIG_LEDS_BRIGHTNESS_HW_CHANGED is not set

#
# LED drivers
#
# CONFIG_LEDS_APU is not set
CONFIG_LEDS_LM3530=m
# CONFIG_LEDS_LM3532 is not set
# CONFIG_LEDS_LM3642 is not set
# CONFIG_LEDS_PCA9532 is not set
# CONFIG_LEDS_GPIO is not set
CONFIG_LEDS_LP3944=m
# CONFIG_LEDS_LP3952 is not set
# CONFIG_LEDS_LP50XX is not set
CONFIG_LEDS_CLEVO_MAIL=m
# CONFIG_LEDS_PCA955X is not set
# CONFIG_LEDS_PCA963X is not set
# CONFIG_LEDS_DAC124S085 is not set
# CONFIG_LEDS_PWM is not set
# CONFIG_LEDS_BD2802 is not set
CONFIG_LEDS_INTEL_SS4200=m
CONFIG_LEDS_LT3593=m
# CONFIG_LEDS_TCA6507 is not set
# CONFIG_LEDS_TLC591XX is not set
# CONFIG_LEDS_LM355x is not set

#
# LED driver for blink(1) USB RGB LED is under Special HID drivers (HID_THINGM)
#
CONFIG_LEDS_BLINKM=m
CONFIG_LEDS_MLXCPLD=m
# CONFIG_LEDS_MLXREG is not set
# CONFIG_LEDS_USER is not set
# CONFIG_LEDS_NIC78BX is not set
# CONFIG_LEDS_TI_LMU_COMMON is not set

#
# Flash and Torch LED drivers
#

#
# LED Triggers
#
CONFIG_LEDS_TRIGGERS=y
CONFIG_LEDS_TRIGGER_TIMER=m
CONFIG_LEDS_TRIGGER_ONESHOT=m
# CONFIG_LEDS_TRIGGER_DISK is not set
CONFIG_LEDS_TRIGGER_HEARTBEAT=m
CONFIG_LEDS_TRIGGER_BACKLIGHT=m
# CONFIG_LEDS_TRIGGER_CPU is not set
# CONFIG_LEDS_TRIGGER_ACTIVITY is not set
CONFIG_LEDS_TRIGGER_GPIO=m
CONFIG_LEDS_TRIGGER_DEFAULT_ON=m

#
# iptables trigger is under Netfilter config (LED target)
#
CONFIG_LEDS_TRIGGER_TRANSIENT=m
CONFIG_LEDS_TRIGGER_CAMERA=m
# CONFIG_LEDS_TRIGGER_PANIC is not set
# CONFIG_LEDS_TRIGGER_NETDEV is not set
# CONFIG_LEDS_TRIGGER_PATTERN is not set
CONFIG_LEDS_TRIGGER_AUDIO=m
# CONFIG_LEDS_TRIGGER_TTY is not set
# CONFIG_ACCESSIBILITY is not set
# CONFIG_INFINIBAND is not set
CONFIG_EDAC_ATOMIC_SCRUB=y
CONFIG_EDAC_SUPPORT=y
CONFIG_EDAC=y
CONFIG_EDAC_LEGACY_SYSFS=y
# CONFIG_EDAC_DEBUG is not set
CONFIG_EDAC_DECODE_MCE=m
CONFIG_EDAC_GHES=y
CONFIG_EDAC_AMD64=m
CONFIG_EDAC_E752X=m
CONFIG_EDAC_I82975X=m
CONFIG_EDAC_I3000=m
CONFIG_EDAC_I3200=m
CONFIG_EDAC_IE31200=m
CONFIG_EDAC_X38=m
CONFIG_EDAC_I5400=m
CONFIG_EDAC_I7CORE=m
CONFIG_EDAC_I5000=m
CONFIG_EDAC_I5100=m
CONFIG_EDAC_I7300=m
CONFIG_EDAC_SBRIDGE=m
CONFIG_EDAC_SKX=m
# CONFIG_EDAC_I10NM is not set
CONFIG_EDAC_PND2=m
# CONFIG_EDAC_IGEN6 is not set
CONFIG_RTC_LIB=y
CONFIG_RTC_MC146818_LIB=y
CONFIG_RTC_CLASS=y
CONFIG_RTC_HCTOSYS=y
CONFIG_RTC_HCTOSYS_DEVICE="rtc0"
# CONFIG_RTC_SYSTOHC is not set
# CONFIG_RTC_DEBUG is not set
CONFIG_RTC_NVMEM=y

#
# RTC interfaces
#
CONFIG_RTC_INTF_SYSFS=y
CONFIG_RTC_INTF_PROC=y
CONFIG_RTC_INTF_DEV=y
# CONFIG_RTC_INTF_DEV_UIE_EMUL is not set
# CONFIG_RTC_DRV_TEST is not set

#
# I2C RTC drivers
#
# CONFIG_RTC_DRV_ABB5ZES3 is not set
# CONFIG_RTC_DRV_ABEOZ9 is not set
# CONFIG_RTC_DRV_ABX80X is not set
CONFIG_RTC_DRV_DS1307=m
# CONFIG_RTC_DRV_DS1307_CENTURY is not set
CONFIG_RTC_DRV_DS1374=m
# CONFIG_RTC_DRV_DS1374_WDT is not set
CONFIG_RTC_DRV_DS1672=m
CONFIG_RTC_DRV_MAX6900=m
CONFIG_RTC_DRV_RS5C372=m
CONFIG_RTC_DRV_ISL1208=m
CONFIG_RTC_DRV_ISL12022=m
CONFIG_RTC_DRV_X1205=m
CONFIG_RTC_DRV_PCF8523=m
# CONFIG_RTC_DRV_PCF85063 is not set
# CONFIG_RTC_DRV_PCF85363 is not set
CONFIG_RTC_DRV_PCF8563=m
CONFIG_RTC_DRV_PCF8583=m
CONFIG_RTC_DRV_M41T80=m
CONFIG_RTC_DRV_M41T80_WDT=y
CONFIG_RTC_DRV_BQ32K=m
# CONFIG_RTC_DRV_S35390A is not set
CONFIG_RTC_DRV_FM3130=m
# CONFIG_RTC_DRV_RX8010 is not set
CONFIG_RTC_DRV_RX8581=m
CONFIG_RTC_DRV_RX8025=m
CONFIG_RTC_DRV_EM3027=m
# CONFIG_RTC_DRV_RV3028 is not set
# CONFIG_RTC_DRV_RV3032 is not set
# CONFIG_RTC_DRV_RV8803 is not set
# CONFIG_RTC_DRV_SD3078 is not set

#
# SPI RTC drivers
#
# CONFIG_RTC_DRV_M41T93 is not set
# CONFIG_RTC_DRV_M41T94 is not set
# CONFIG_RTC_DRV_DS1302 is not set
# CONFIG_RTC_DRV_DS1305 is not set
# CONFIG_RTC_DRV_DS1343 is not set
# CONFIG_RTC_DRV_DS1347 is not set
# CONFIG_RTC_DRV_DS1390 is not set
# CONFIG_RTC_DRV_MAX6916 is not set
# CONFIG_RTC_DRV_R9701 is not set
CONFIG_RTC_DRV_RX4581=m
# CONFIG_RTC_DRV_RS5C348 is not set
# CONFIG_RTC_DRV_MAX6902 is not set
# CONFIG_RTC_DRV_PCF2123 is not set
# CONFIG_RTC_DRV_MCP795 is not set
CONFIG_RTC_I2C_AND_SPI=y

#
# SPI and I2C RTC drivers
#
CONFIG_RTC_DRV_DS3232=m
CONFIG_RTC_DRV_DS3232_HWMON=y
# CONFIG_RTC_DRV_PCF2127 is not set
CONFIG_RTC_DRV_RV3029C2=m
# CONFIG_RTC_DRV_RV3029_HWMON is not set
# CONFIG_RTC_DRV_RX6110 is not set

#
# Platform RTC drivers
#
CONFIG_RTC_DRV_CMOS=y
CONFIG_RTC_DRV_DS1286=m
CONFIG_RTC_DRV_DS1511=m
CONFIG_RTC_DRV_DS1553=m
# CONFIG_RTC_DRV_DS1685_FAMILY is not set
CONFIG_RTC_DRV_DS1742=m
CONFIG_RTC_DRV_DS2404=m
CONFIG_RTC_DRV_STK17TA8=m
# CONFIG_RTC_DRV_M48T86 is not set
CONFIG_RTC_DRV_M48T35=m
CONFIG_RTC_DRV_M48T59=m
CONFIG_RTC_DRV_MSM6242=m
CONFIG_RTC_DRV_BQ4802=m
CONFIG_RTC_DRV_RP5C01=m
CONFIG_RTC_DRV_V3020=m

#
# on-CPU RTC drivers
#
# CONFIG_RTC_DRV_FTRTC010 is not set

#
# HID Sensor RTC drivers
#
# CONFIG_RTC_DRV_GOLDFISH is not set
CONFIG_DMADEVICES=y
# CONFIG_DMADEVICES_DEBUG is not set

#
# DMA Devices
#
CONFIG_DMA_ENGINE=y
CONFIG_DMA_VIRTUAL_CHANNELS=y
CONFIG_DMA_ACPI=y
# CONFIG_ALTERA_MSGDMA is not set
CONFIG_INTEL_IDMA64=m
# CONFIG_INTEL_IDXD is not set
# CONFIG_INTEL_IDXD_COMPAT is not set
CONFIG_INTEL_IOATDMA=m
# CONFIG_PLX_DMA is not set
# CONFIG_AMD_PTDMA is not set
# CONFIG_QCOM_HIDMA_MGMT is not set
# CONFIG_QCOM_HIDMA is not set
CONFIG_DW_DMAC_CORE=y
CONFIG_DW_DMAC=m
CONFIG_DW_DMAC_PCI=y
# CONFIG_DW_EDMA is not set
# CONFIG_DW_EDMA_PCIE is not set
CONFIG_HSU_DMA=y
# CONFIG_SF_PDMA is not set
# CONFIG_INTEL_LDMA is not set

#
# DMA Clients
#
CONFIG_ASYNC_TX_DMA=y
CONFIG_DMATEST=m
CONFIG_DMA_ENGINE_RAID=y

#
# DMABUF options
#
CONFIG_SYNC_FILE=y
CONFIG_SW_SYNC=y
CONFIG_UDMABUF=y
# CONFIG_DMABUF_MOVE_NOTIFY is not set
# CONFIG_DMABUF_DEBUG is not set
# CONFIG_DMABUF_SELFTESTS is not set
CONFIG_DMABUF_HEAPS=y
# CONFIG_DMABUF_SYSFS_STATS is not set
CONFIG_DMABUF_HEAPS_SYSTEM=y
# end of DMABUF options

CONFIG_DCA=m
# CONFIG_AUXDISPLAY is not set
# CONFIG_PANEL is not set
CONFIG_UIO=m
CONFIG_UIO_CIF=m
CONFIG_UIO_PDRV_GENIRQ=m
# CONFIG_UIO_DMEM_GENIRQ is not set
CONFIG_UIO_AEC=m
CONFIG_UIO_SERCOS3=m
CONFIG_UIO_PCI_GENERIC=m
# CONFIG_UIO_NETX is not set
# CONFIG_UIO_PRUSS is not set
# CONFIG_UIO_MF624 is not set
CONFIG_UIO_HV_GENERIC=m
CONFIG_VFIO=m
CONFIG_VFIO_IOMMU_TYPE1=m
CONFIG_VFIO_VIRQFD=m
CONFIG_VFIO_NOIOMMU=y
CONFIG_VFIO_PCI_CORE=m
CONFIG_VFIO_PCI_MMAP=y
CONFIG_VFIO_PCI_INTX=y
CONFIG_VFIO_PCI=m
# CONFIG_VFIO_PCI_VGA is not set
# CONFIG_VFIO_PCI_IGD is not set
CONFIG_VFIO_MDEV=m
CONFIG_IRQ_BYPASS_MANAGER=y
# CONFIG_VIRT_DRIVERS is not set
CONFIG_VIRTIO=y
CONFIG_VIRTIO_PCI_LIB=y
CONFIG_VIRTIO_MENU=y
CONFIG_VIRTIO_PCI=y
CONFIG_VIRTIO_PCI_LEGACY=y
# CONFIG_VIRTIO_PMEM is not set
CONFIG_VIRTIO_BALLOON=m
CONFIG_VIRTIO_MEM=m
CONFIG_VIRTIO_INPUT=m
# CONFIG_VIRTIO_MMIO is not set
CONFIG_VIRTIO_DMA_SHARED_BUFFER=m
# CONFIG_VDPA is not set
CONFIG_VHOST_IOTLB=m
CONFIG_VHOST=m
CONFIG_VHOST_MENU=y
CONFIG_VHOST_NET=m
# CONFIG_VHOST_SCSI is not set
CONFIG_VHOST_VSOCK=m
# CONFIG_VHOST_CROSS_ENDIAN_LEGACY is not set

#
# Microsoft Hyper-V guest support
#
CONFIG_HYPERV=m
CONFIG_HYPERV_TIMER=y
CONFIG_HYPERV_UTILS=m
CONFIG_HYPERV_BALLOON=m
# end of Microsoft Hyper-V guest support

# CONFIG_GREYBUS is not set
# CONFIG_COMEDI is not set
CONFIG_STAGING=y
# CONFIG_PRISM2_USB is not set
# CONFIG_RTL8192U is not set
# CONFIG_RTLLIB is not set
# CONFIG_RTL8723BS is not set
# CONFIG_R8712U is not set
# CONFIG_R8188EU is not set
# CONFIG_RTS5208 is not set
# CONFIG_VT6655 is not set
# CONFIG_VT6656 is not set
# CONFIG_FB_SM750 is not set
# CONFIG_STAGING_MEDIA is not set

#
# Android
#
# CONFIG_ASHMEM is not set
# end of Android

# CONFIG_LTE_GDM724X is not set
# CONFIG_FIREWIRE_SERIAL is not set
# CONFIG_GS_FPGABOOT is not set
# CONFIG_UNISYSSPAR is not set
# CONFIG_FB_TFT is not set
# CONFIG_KS7010 is not set
# CONFIG_PI433 is not set
# CONFIG_FIELDBUS_DEV is not set
# CONFIG_QLGE is not set
# CONFIG_WFX is not set
CONFIG_X86_PLATFORM_DEVICES=y
CONFIG_ACPI_WMI=m
CONFIG_WMI_BMOF=m
# CONFIG_HUAWEI_WMI is not set
# CONFIG_UV_SYSFS is not set
CONFIG_MXM_WMI=m
# CONFIG_PEAQ_WMI is not set
# CONFIG_XIAOMI_WMI is not set
# CONFIG_GIGABYTE_WMI is not set
CONFIG_ACERHDF=m
# CONFIG_ACER_WIRELESS is not set
CONFIG_ACER_WMI=m
# CONFIG_AMD_PMC is not set
# CONFIG_ADV_SWBUTTON is not set
CONFIG_APPLE_GMUX=m
CONFIG_ASUS_LAPTOP=m
# CONFIG_ASUS_WIRELESS is not set
CONFIG_ASUS_WMI=m
CONFIG_ASUS_NB_WMI=m
# CONFIG_MERAKI_MX100 is not set
CONFIG_EEEPC_LAPTOP=m
CONFIG_EEEPC_WMI=m
# CONFIG_X86_PLATFORM_DRIVERS_DELL is not set
CONFIG_AMILO_RFKILL=m
CONFIG_FUJITSU_LAPTOP=m
CONFIG_FUJITSU_TABLET=m
# CONFIG_GPD_POCKET_FAN is not set
CONFIG_HP_ACCEL=m
# CONFIG_WIRELESS_HOTKEY is not set
CONFIG_HP_WMI=m
# CONFIG_IBM_RTL is not set
CONFIG_IDEAPAD_LAPTOP=m
CONFIG_SENSORS_HDAPS=m
CONFIG_THINKPAD_ACPI=m
# CONFIG_THINKPAD_ACPI_DEBUGFACILITIES is not set
# CONFIG_THINKPAD_ACPI_DEBUG is not set
# CONFIG_THINKPAD_ACPI_UNSAFE_LEDS is not set
CONFIG_THINKPAD_ACPI_VIDEO=y
CONFIG_THINKPAD_ACPI_HOTKEY_POLL=y
# CONFIG_THINKPAD_LMI is not set
CONFIG_X86_PLATFORM_DRIVERS_INTEL=y
# CONFIG_INTEL_ATOMISP2_PM is not set
# CONFIG_INTEL_SAR_INT1092 is not set
CONFIG_INTEL_PMC_CORE=m

#
# Intel Speed Select Technology interface support
#
# CONFIG_INTEL_SPEED_SELECT_INTERFACE is not set
# end of Intel Speed Select Technology interface support

CONFIG_INTEL_WMI=y
# CONFIG_INTEL_WMI_SBL_FW_UPDATE is not set
CONFIG_INTEL_WMI_THUNDERBOLT=m
CONFIG_INTEL_HID_EVENT=m
CONFIG_INTEL_VBTN=m
# CONFIG_INTEL_INT0002_VGPIO is not set
CONFIG_INTEL_OAKTRAIL=m
# CONFIG_INTEL_PUNIT_IPC is not set
CONFIG_INTEL_RST=m
# CONFIG_INTEL_SMARTCONNECT is not set
CONFIG_INTEL_TURBO_MAX_3=y
# CONFIG_INTEL_UNCORE_FREQ_CONTROL is not set
CONFIG_MSI_LAPTOP=m
CONFIG_MSI_WMI=m
# CONFIG_PCENGINES_APU2 is not set
CONFIG_SAMSUNG_LAPTOP=m
CONFIG_SAMSUNG_Q10=m
CONFIG_TOSHIBA_BT_RFKILL=m
# CONFIG_TOSHIBA_HAPS is not set
# CONFIG_TOSHIBA_WMI is not set
CONFIG_ACPI_CMPC=m
CONFIG_COMPAL_LAPTOP=m
# CONFIG_LG_LAPTOP is not set
CONFIG_PANASONIC_LAPTOP=m
CONFIG_SONY_LAPTOP=m
CONFIG_SONYPI_COMPAT=y
# CONFIG_SYSTEM76_ACPI is not set
CONFIG_TOPSTAR_LAPTOP=m
# CONFIG_I2C_MULTI_INSTANTIATE is not set
CONFIG_MLX_PLATFORM=m
CONFIG_INTEL_IPS=m
# CONFIG_INTEL_SCU_PCI is not set
# CONFIG_INTEL_SCU_PLATFORM is not set
CONFIG_PMC_ATOM=y
# CONFIG_CHROME_PLATFORMS is not set
CONFIG_MELLANOX_PLATFORM=y
CONFIG_MLXREG_HOTPLUG=m
# CONFIG_MLXREG_IO is not set
CONFIG_SURFACE_PLATFORMS=y
# CONFIG_SURFACE3_WMI is not set
# CONFIG_SURFACE_3_POWER_OPREGION is not set
# CONFIG_SURFACE_GPE is not set
# CONFIG_SURFACE_HOTPLUG is not set
# CONFIG_SURFACE_PRO3_BUTTON is not set
CONFIG_HAVE_CLK=y
CONFIG_HAVE_CLK_PREPARE=y
CONFIG_COMMON_CLK=y

#
# Clock driver for ARM Reference designs
#
# CONFIG_ICST is not set
# CONFIG_CLK_SP810 is not set
# end of Clock driver for ARM Reference designs

# CONFIG_LMK04832 is not set
# CONFIG_COMMON_CLK_MAX9485 is not set
# CONFIG_COMMON_CLK_SI5341 is not set
# CONFIG_COMMON_CLK_SI5351 is not set
# CONFIG_COMMON_CLK_SI544 is not set
# CONFIG_COMMON_CLK_CDCE706 is not set
# CONFIG_COMMON_CLK_CS2000_CP is not set
# CONFIG_COMMON_CLK_PWM is not set
# CONFIG_XILINX_VCU is not set
CONFIG_HWSPINLOCK=y

#
# Clock Source drivers
#
CONFIG_CLKEVT_I8253=y
CONFIG_I8253_LOCK=y
CONFIG_CLKBLD_I8253=y
# end of Clock Source drivers

CONFIG_MAILBOX=y
CONFIG_PCC=y
# CONFIG_ALTERA_MBOX is not set
CONFIG_IOMMU_IOVA=y
CONFIG_IOASID=y
CONFIG_IOMMU_API=y
CONFIG_IOMMU_SUPPORT=y

#
# Generic IOMMU Pagetable Support
#
# end of Generic IOMMU Pagetable Support

# CONFIG_IOMMU_DEBUGFS is not set
# CONFIG_IOMMU_DEFAULT_DMA_STRICT is not set
CONFIG_IOMMU_DEFAULT_DMA_LAZY=y
# CONFIG_IOMMU_DEFAULT_PASSTHROUGH is not set
CONFIG_IOMMU_DMA=y
# CONFIG_AMD_IOMMU is not set
CONFIG_DMAR_TABLE=y
CONFIG_INTEL_IOMMU=y
# CONFIG_INTEL_IOMMU_SVM is not set
# CONFIG_INTEL_IOMMU_DEFAULT_ON is not set
CONFIG_INTEL_IOMMU_FLOPPY_WA=y
CONFIG_INTEL_IOMMU_SCALABLE_MODE_DEFAULT_ON=y
CONFIG_IRQ_REMAP=y
CONFIG_HYPERV_IOMMU=y
# CONFIG_VIRTIO_IOMMU is not set

#
# Remoteproc drivers
#
# CONFIG_REMOTEPROC is not set
# end of Remoteproc drivers

#
# Rpmsg drivers
#
# CONFIG_RPMSG_QCOM_GLINK_RPM is not set
# CONFIG_RPMSG_VIRTIO is not set
# end of Rpmsg drivers

# CONFIG_SOUNDWIRE is not set

#
# SOC (System On Chip) specific Drivers
#

#
# Amlogic SoC drivers
#
# end of Amlogic SoC drivers

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
# Enable LiteX SoC Builder specific drivers
#
# end of Enable LiteX SoC Builder specific drivers

#
# Qualcomm SoC drivers
#
# end of Qualcomm SoC drivers

# CONFIG_SOC_TI is not set

#
# Xilinx SoC drivers
#
# end of Xilinx SoC drivers
# end of SOC (System On Chip) specific Drivers

# CONFIG_PM_DEVFREQ is not set
# CONFIG_EXTCON is not set
# CONFIG_MEMORY is not set
# CONFIG_IIO is not set
CONFIG_NTB=m
# CONFIG_NTB_MSI is not set
# CONFIG_NTB_AMD is not set
# CONFIG_NTB_IDT is not set
# CONFIG_NTB_INTEL is not set
# CONFIG_NTB_EPF is not set
# CONFIG_NTB_SWITCHTEC is not set
# CONFIG_NTB_PINGPONG is not set
# CONFIG_NTB_TOOL is not set
# CONFIG_NTB_PERF is not set
# CONFIG_NTB_TRANSPORT is not set
# CONFIG_VME_BUS is not set
CONFIG_PWM=y
CONFIG_PWM_SYSFS=y
# CONFIG_PWM_DEBUG is not set
# CONFIG_PWM_DWC is not set
CONFIG_PWM_LPSS=m
CONFIG_PWM_LPSS_PCI=m
CONFIG_PWM_LPSS_PLATFORM=m
# CONFIG_PWM_PCA9685 is not set

#
# IRQ chip support
#
# end of IRQ chip support

# CONFIG_IPACK_BUS is not set
# CONFIG_RESET_CONTROLLER is not set

#
# PHY Subsystem
#
# CONFIG_GENERIC_PHY is not set
# CONFIG_USB_LGM_PHY is not set
# CONFIG_PHY_CAN_TRANSCEIVER is not set
# CONFIG_BCM_KONA_USB2_PHY is not set
# CONFIG_PHY_PXA_28NM_HSIC is not set
# CONFIG_PHY_PXA_28NM_USB2 is not set
# CONFIG_PHY_INTEL_LGM_EMMC is not set
# end of PHY Subsystem

CONFIG_POWERCAP=y
CONFIG_INTEL_RAPL_CORE=m
CONFIG_INTEL_RAPL=m
# CONFIG_IDLE_INJECT is not set
# CONFIG_DTPM is not set
# CONFIG_MCB is not set

#
# Performance monitor support
#
# end of Performance monitor support

CONFIG_RAS=y
# CONFIG_RAS_CEC is not set
# CONFIG_USB4 is not set

#
# Android
#
CONFIG_ANDROID=y
# CONFIG_ANDROID_BINDER_IPC is not set
# end of Android

CONFIG_LIBNVDIMM=m
CONFIG_BLK_DEV_PMEM=m
CONFIG_ND_BLK=m
CONFIG_ND_CLAIM=y
CONFIG_ND_BTT=m
CONFIG_BTT=y
CONFIG_ND_PFN=m
CONFIG_NVDIMM_PFN=y
CONFIG_NVDIMM_DAX=y
CONFIG_NVDIMM_KEYS=y
CONFIG_DAX_DRIVER=y
CONFIG_DAX=y
CONFIG_DEV_DAX=m
CONFIG_DEV_DAX_PMEM=m
CONFIG_DEV_DAX_KMEM=m
CONFIG_DEV_DAX_PMEM_COMPAT=m
CONFIG_NVMEM=y
CONFIG_NVMEM_SYSFS=y
# CONFIG_NVMEM_RMEM is not set

#
# HW tracing support
#
CONFIG_STM=m
# CONFIG_STM_PROTO_BASIC is not set
# CONFIG_STM_PROTO_SYS_T is not set
CONFIG_STM_DUMMY=m
CONFIG_STM_SOURCE_CONSOLE=m
CONFIG_STM_SOURCE_HEARTBEAT=m
CONFIG_STM_SOURCE_FTRACE=m
CONFIG_INTEL_TH=m
CONFIG_INTEL_TH_PCI=m
CONFIG_INTEL_TH_ACPI=m
CONFIG_INTEL_TH_GTH=m
CONFIG_INTEL_TH_STH=m
CONFIG_INTEL_TH_MSU=m
CONFIG_INTEL_TH_PTI=m
# CONFIG_INTEL_TH_DEBUG is not set
# end of HW tracing support

# CONFIG_FPGA is not set
# CONFIG_TEE is not set
# CONFIG_UNISYS_VISORBUS is not set
# CONFIG_SIOX is not set
# CONFIG_SLIMBUS is not set
# CONFIG_INTERCONNECT is not set
# CONFIG_COUNTER is not set
# CONFIG_MOST is not set
# end of Device Drivers

#
# File systems
#
CONFIG_DCACHE_WORD_ACCESS=y
# CONFIG_VALIDATE_FS_PARSER is not set
CONFIG_FS_IOMAP=y
# CONFIG_EXT2_FS is not set
# CONFIG_EXT3_FS is not set
CONFIG_EXT4_FS=y
CONFIG_EXT4_USE_FOR_EXT2=y
CONFIG_EXT4_FS_POSIX_ACL=y
CONFIG_EXT4_FS_SECURITY=y
# CONFIG_EXT4_DEBUG is not set
CONFIG_JBD2=y
# CONFIG_JBD2_DEBUG is not set
CONFIG_FS_MBCACHE=y
# CONFIG_REISERFS_FS is not set
# CONFIG_JFS_FS is not set
CONFIG_XFS_FS=m
CONFIG_XFS_SUPPORT_V4=y
CONFIG_XFS_QUOTA=y
CONFIG_XFS_POSIX_ACL=y
CONFIG_XFS_RT=y
CONFIG_XFS_ONLINE_SCRUB=y
# CONFIG_XFS_ONLINE_REPAIR is not set
CONFIG_XFS_DEBUG=y
CONFIG_XFS_ASSERT_FATAL=y
CONFIG_GFS2_FS=m
CONFIG_GFS2_FS_LOCKING_DLM=y
CONFIG_OCFS2_FS=m
CONFIG_OCFS2_FS_O2CB=m
CONFIG_OCFS2_FS_USERSPACE_CLUSTER=m
CONFIG_OCFS2_FS_STATS=y
CONFIG_OCFS2_DEBUG_MASKLOG=y
# CONFIG_OCFS2_DEBUG_FS is not set
CONFIG_BTRFS_FS=m
CONFIG_BTRFS_FS_POSIX_ACL=y
# CONFIG_BTRFS_FS_CHECK_INTEGRITY is not set
# CONFIG_BTRFS_FS_RUN_SANITY_TESTS is not set
# CONFIG_BTRFS_DEBUG is not set
# CONFIG_BTRFS_ASSERT is not set
# CONFIG_BTRFS_FS_REF_VERIFY is not set
# CONFIG_NILFS2_FS is not set
CONFIG_F2FS_FS=m
CONFIG_F2FS_STAT_FS=y
CONFIG_F2FS_FS_XATTR=y
CONFIG_F2FS_FS_POSIX_ACL=y
# CONFIG_F2FS_FS_SECURITY is not set
# CONFIG_F2FS_CHECK_FS is not set
# CONFIG_F2FS_FAULT_INJECTION is not set
# CONFIG_F2FS_FS_COMPRESSION is not set
CONFIG_F2FS_IOSTAT=y
CONFIG_FS_DAX=y
CONFIG_FS_DAX_PMD=y
CONFIG_FS_POSIX_ACL=y
CONFIG_EXPORTFS=y
CONFIG_EXPORTFS_BLOCK_OPS=y
CONFIG_FILE_LOCKING=y
CONFIG_FS_ENCRYPTION=y
CONFIG_FS_ENCRYPTION_ALGS=y
# CONFIG_FS_VERITY is not set
CONFIG_FSNOTIFY=y
CONFIG_DNOTIFY=y
CONFIG_INOTIFY_USER=y
CONFIG_FANOTIFY=y
CONFIG_FANOTIFY_ACCESS_PERMISSIONS=y
CONFIG_QUOTA=y
CONFIG_QUOTA_NETLINK_INTERFACE=y
CONFIG_PRINT_QUOTA_WARNING=y
# CONFIG_QUOTA_DEBUG is not set
CONFIG_QUOTA_TREE=y
# CONFIG_QFMT_V1 is not set
CONFIG_QFMT_V2=y
CONFIG_QUOTACTL=y
CONFIG_AUTOFS4_FS=y
CONFIG_AUTOFS_FS=y
CONFIG_FUSE_FS=m
CONFIG_CUSE=m
# CONFIG_VIRTIO_FS is not set
CONFIG_OVERLAY_FS=y
# CONFIG_OVERLAY_FS_REDIRECT_DIR is not set
# CONFIG_OVERLAY_FS_REDIRECT_ALWAYS_FOLLOW is not set
# CONFIG_OVERLAY_FS_INDEX is not set
# CONFIG_OVERLAY_FS_XINO_AUTO is not set
# CONFIG_OVERLAY_FS_METACOPY is not set

#
# Caches
#
CONFIG_NETFS_SUPPORT=m
CONFIG_NETFS_STATS=y
CONFIG_FSCACHE=m
CONFIG_FSCACHE_STATS=y
# CONFIG_FSCACHE_DEBUG is not set
CONFIG_CACHEFILES=m
# CONFIG_CACHEFILES_DEBUG is not set
# end of Caches

#
# CD-ROM/DVD Filesystems
#
CONFIG_ISO9660_FS=m
CONFIG_JOLIET=y
CONFIG_ZISOFS=y
CONFIG_UDF_FS=m
# end of CD-ROM/DVD Filesystems

#
# DOS/FAT/EXFAT/NT Filesystems
#
CONFIG_FAT_FS=m
CONFIG_MSDOS_FS=m
CONFIG_VFAT_FS=m
CONFIG_FAT_DEFAULT_CODEPAGE=437
CONFIG_FAT_DEFAULT_IOCHARSET="ascii"
# CONFIG_FAT_DEFAULT_UTF8 is not set
# CONFIG_EXFAT_FS is not set
# CONFIG_NTFS_FS is not set
# CONFIG_NTFS3_FS is not set
# end of DOS/FAT/EXFAT/NT Filesystems

#
# Pseudo filesystems
#
CONFIG_PROC_FS=y
CONFIG_PROC_KCORE=y
CONFIG_PROC_VMCORE=y
CONFIG_PROC_VMCORE_DEVICE_DUMP=y
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
# CONFIG_TMPFS_INODE64 is not set
CONFIG_HUGETLBFS=y
CONFIG_HUGETLB_PAGE=y
CONFIG_HUGETLB_PAGE_FREE_VMEMMAP=y
# CONFIG_HUGETLB_PAGE_FREE_VMEMMAP_DEFAULT_ON is not set
CONFIG_MEMFD_CREATE=y
CONFIG_ARCH_HAS_GIGANTIC_PAGE=y
CONFIG_CONFIGFS_FS=y
CONFIG_EFIVAR_FS=y
# end of Pseudo filesystems

CONFIG_MISC_FILESYSTEMS=y
# CONFIG_ORANGEFS_FS is not set
# CONFIG_ADFS_FS is not set
# CONFIG_AFFS_FS is not set
# CONFIG_ECRYPT_FS is not set
# CONFIG_HFS_FS is not set
# CONFIG_HFSPLUS_FS is not set
# CONFIG_BEFS_FS is not set
# CONFIG_BFS_FS is not set
# CONFIG_EFS_FS is not set
CONFIG_CRAMFS=m
CONFIG_CRAMFS_BLOCKDEV=y
CONFIG_SQUASHFS=m
# CONFIG_SQUASHFS_FILE_CACHE is not set
CONFIG_SQUASHFS_FILE_DIRECT=y
# CONFIG_SQUASHFS_DECOMP_SINGLE is not set
# CONFIG_SQUASHFS_DECOMP_MULTI is not set
CONFIG_SQUASHFS_DECOMP_MULTI_PERCPU=y
CONFIG_SQUASHFS_XATTR=y
CONFIG_SQUASHFS_ZLIB=y
# CONFIG_SQUASHFS_LZ4 is not set
CONFIG_SQUASHFS_LZO=y
CONFIG_SQUASHFS_XZ=y
# CONFIG_SQUASHFS_ZSTD is not set
# CONFIG_SQUASHFS_4K_DEVBLK_SIZE is not set
# CONFIG_SQUASHFS_EMBEDDED is not set
CONFIG_SQUASHFS_FRAGMENT_CACHE_SIZE=3
# CONFIG_VXFS_FS is not set
# CONFIG_MINIX_FS is not set
# CONFIG_OMFS_FS is not set
# CONFIG_HPFS_FS is not set
# CONFIG_QNX4FS_FS is not set
# CONFIG_QNX6FS_FS is not set
# CONFIG_ROMFS_FS is not set
CONFIG_PSTORE=y
CONFIG_PSTORE_DEFAULT_KMSG_BYTES=10240
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
# CONFIG_PSTORE_FTRACE is not set
CONFIG_PSTORE_RAM=m
# CONFIG_SYSV_FS is not set
# CONFIG_UFS_FS is not set
# CONFIG_EROFS_FS is not set
CONFIG_NETWORK_FILESYSTEMS=y
CONFIG_NFS_FS=y
# CONFIG_NFS_V2 is not set
CONFIG_NFS_V3=y
CONFIG_NFS_V3_ACL=y
CONFIG_NFS_V4=m
# CONFIG_NFS_SWAP is not set
CONFIG_NFS_V4_1=y
CONFIG_NFS_V4_2=y
CONFIG_PNFS_FILE_LAYOUT=m
CONFIG_PNFS_BLOCK=m
CONFIG_PNFS_FLEXFILE_LAYOUT=m
CONFIG_NFS_V4_1_IMPLEMENTATION_ID_DOMAIN="kernel.org"
# CONFIG_NFS_V4_1_MIGRATION is not set
CONFIG_NFS_V4_SECURITY_LABEL=y
CONFIG_ROOT_NFS=y
# CONFIG_NFS_USE_LEGACY_DNS is not set
CONFIG_NFS_USE_KERNEL_DNS=y
CONFIG_NFS_DEBUG=y
CONFIG_NFS_DISABLE_UDP_SUPPORT=y
# CONFIG_NFS_V4_2_READ_PLUS is not set
CONFIG_NFSD=m
CONFIG_NFSD_V2_ACL=y
CONFIG_NFSD_V3=y
CONFIG_NFSD_V3_ACL=y
CONFIG_NFSD_V4=y
CONFIG_NFSD_PNFS=y
# CONFIG_NFSD_BLOCKLAYOUT is not set
CONFIG_NFSD_SCSILAYOUT=y
# CONFIG_NFSD_FLEXFILELAYOUT is not set
# CONFIG_NFSD_V4_2_INTER_SSC is not set
CONFIG_NFSD_V4_SECURITY_LABEL=y
CONFIG_GRACE_PERIOD=y
CONFIG_LOCKD=y
CONFIG_LOCKD_V4=y
CONFIG_NFS_ACL_SUPPORT=y
CONFIG_NFS_COMMON=y
CONFIG_NFS_V4_2_SSC_HELPER=y
CONFIG_SUNRPC=y
CONFIG_SUNRPC_GSS=m
CONFIG_SUNRPC_BACKCHANNEL=y
CONFIG_RPCSEC_GSS_KRB5=m
# CONFIG_SUNRPC_DISABLE_INSECURE_ENCTYPES is not set
CONFIG_SUNRPC_DEBUG=y
CONFIG_CEPH_FS=m
# CONFIG_CEPH_FSCACHE is not set
CONFIG_CEPH_FS_POSIX_ACL=y
# CONFIG_CEPH_FS_SECURITY_LABEL is not set
CONFIG_CIFS=m
CONFIG_CIFS_STATS2=y
CONFIG_CIFS_ALLOW_INSECURE_LEGACY=y
CONFIG_CIFS_UPCALL=y
CONFIG_CIFS_XATTR=y
CONFIG_CIFS_POSIX=y
CONFIG_CIFS_DEBUG=y
# CONFIG_CIFS_DEBUG2 is not set
# CONFIG_CIFS_DEBUG_DUMP_KEYS is not set
CONFIG_CIFS_DFS_UPCALL=y
# CONFIG_CIFS_SWN_UPCALL is not set
# CONFIG_CIFS_FSCACHE is not set
# CONFIG_SMB_SERVER is not set
CONFIG_SMBFS_COMMON=m
# CONFIG_CODA_FS is not set
# CONFIG_AFS_FS is not set
# CONFIG_9P_FS is not set
CONFIG_NLS=y
CONFIG_NLS_DEFAULT="utf8"
CONFIG_NLS_CODEPAGE_437=y
CONFIG_NLS_CODEPAGE_737=m
CONFIG_NLS_CODEPAGE_775=m
CONFIG_NLS_CODEPAGE_850=m
CONFIG_NLS_CODEPAGE_852=m
CONFIG_NLS_CODEPAGE_855=m
CONFIG_NLS_CODEPAGE_857=m
CONFIG_NLS_CODEPAGE_860=m
CONFIG_NLS_CODEPAGE_861=m
CONFIG_NLS_CODEPAGE_862=m
CONFIG_NLS_CODEPAGE_863=m
CONFIG_NLS_CODEPAGE_864=m
CONFIG_NLS_CODEPAGE_865=m
CONFIG_NLS_CODEPAGE_866=m
CONFIG_NLS_CODEPAGE_869=m
CONFIG_NLS_CODEPAGE_936=m
CONFIG_NLS_CODEPAGE_950=m
CONFIG_NLS_CODEPAGE_932=m
CONFIG_NLS_CODEPAGE_949=m
CONFIG_NLS_CODEPAGE_874=m
CONFIG_NLS_ISO8859_8=m
CONFIG_NLS_CODEPAGE_1250=m
CONFIG_NLS_CODEPAGE_1251=m
CONFIG_NLS_ASCII=y
CONFIG_NLS_ISO8859_1=m
CONFIG_NLS_ISO8859_2=m
CONFIG_NLS_ISO8859_3=m
CONFIG_NLS_ISO8859_4=m
CONFIG_NLS_ISO8859_5=m
CONFIG_NLS_ISO8859_6=m
CONFIG_NLS_ISO8859_7=m
CONFIG_NLS_ISO8859_9=m
CONFIG_NLS_ISO8859_13=m
CONFIG_NLS_ISO8859_14=m
CONFIG_NLS_ISO8859_15=m
CONFIG_NLS_KOI8_R=m
CONFIG_NLS_KOI8_U=m
CONFIG_NLS_MAC_ROMAN=m
CONFIG_NLS_MAC_CELTIC=m
CONFIG_NLS_MAC_CENTEURO=m
CONFIG_NLS_MAC_CROATIAN=m
CONFIG_NLS_MAC_CYRILLIC=m
CONFIG_NLS_MAC_GAELIC=m
CONFIG_NLS_MAC_GREEK=m
CONFIG_NLS_MAC_ICELAND=m
CONFIG_NLS_MAC_INUIT=m
CONFIG_NLS_MAC_ROMANIAN=m
CONFIG_NLS_MAC_TURKISH=m
CONFIG_NLS_UTF8=m
CONFIG_DLM=m
CONFIG_DLM_DEBUG=y
# CONFIG_UNICODE is not set
CONFIG_IO_WQ=y
# end of File systems

#
# Security options
#
CONFIG_KEYS=y
# CONFIG_KEYS_REQUEST_CACHE is not set
CONFIG_PERSISTENT_KEYRINGS=y
CONFIG_TRUSTED_KEYS=y
CONFIG_ENCRYPTED_KEYS=y
# CONFIG_KEY_DH_OPERATIONS is not set
# CONFIG_SECURITY_DMESG_RESTRICT is not set
CONFIG_SECURITY=y
CONFIG_SECURITY_WRITABLE_HOOKS=y
CONFIG_SECURITYFS=y
CONFIG_SECURITY_NETWORK=y
CONFIG_PAGE_TABLE_ISOLATION=y
CONFIG_SECURITY_NETWORK_XFRM=y
CONFIG_SECURITY_PATH=y
CONFIG_INTEL_TXT=y
CONFIG_LSM_MMAP_MIN_ADDR=65535
CONFIG_HAVE_HARDENED_USERCOPY_ALLOCATOR=y
CONFIG_HARDENED_USERCOPY=y
CONFIG_HARDENED_USERCOPY_FALLBACK=y
# CONFIG_HARDENED_USERCOPY_PAGESPAN is not set
CONFIG_FORTIFY_SOURCE=y
# CONFIG_STATIC_USERMODEHELPER is not set
CONFIG_SECURITY_SELINUX=y
CONFIG_SECURITY_SELINUX_BOOTPARAM=y
CONFIG_SECURITY_SELINUX_DISABLE=y
CONFIG_SECURITY_SELINUX_DEVELOP=y
CONFIG_SECURITY_SELINUX_AVC_STATS=y
CONFIG_SECURITY_SELINUX_CHECKREQPROT_VALUE=1
CONFIG_SECURITY_SELINUX_SIDTAB_HASH_BITS=9
CONFIG_SECURITY_SELINUX_SID2STR_CACHE_SIZE=256
# CONFIG_SECURITY_SMACK is not set
# CONFIG_SECURITY_TOMOYO is not set
# CONFIG_SECURITY_APPARMOR is not set
# CONFIG_SECURITY_LOADPIN is not set
CONFIG_SECURITY_YAMA=y
# CONFIG_SECURITY_SAFESETID is not set
# CONFIG_SECURITY_LOCKDOWN_LSM is not set
CONFIG_SECURITY_LANDLOCK=y
CONFIG_INTEGRITY=y
CONFIG_INTEGRITY_SIGNATURE=y
CONFIG_INTEGRITY_ASYMMETRIC_KEYS=y
CONFIG_INTEGRITY_TRUSTED_KEYRING=y
# CONFIG_INTEGRITY_PLATFORM_KEYRING is not set
CONFIG_INTEGRITY_AUDIT=y
CONFIG_IMA=y
CONFIG_IMA_MEASURE_PCR_IDX=10
CONFIG_IMA_LSM_RULES=y
# CONFIG_IMA_TEMPLATE is not set
CONFIG_IMA_NG_TEMPLATE=y
# CONFIG_IMA_SIG_TEMPLATE is not set
CONFIG_IMA_DEFAULT_TEMPLATE="ima-ng"
CONFIG_IMA_DEFAULT_HASH_SHA1=y
# CONFIG_IMA_DEFAULT_HASH_SHA256 is not set
# CONFIG_IMA_DEFAULT_HASH_SHA512 is not set
CONFIG_IMA_DEFAULT_HASH="sha1"
CONFIG_IMA_WRITE_POLICY=y
CONFIG_IMA_READ_POLICY=y
CONFIG_IMA_APPRAISE=y
CONFIG_IMA_ARCH_POLICY=y
# CONFIG_IMA_APPRAISE_BUILD_POLICY is not set
CONFIG_IMA_APPRAISE_BOOTPARAM=y
# CONFIG_IMA_APPRAISE_MODSIG is not set
CONFIG_IMA_TRUSTED_KEYRING=y
# CONFIG_IMA_BLACKLIST_KEYRING is not set
# CONFIG_IMA_LOAD_X509 is not set
CONFIG_IMA_MEASURE_ASYMMETRIC_KEYS=y
CONFIG_IMA_QUEUE_EARLY_BOOT_KEYS=y
CONFIG_IMA_SECURE_AND_OR_TRUSTED_BOOT=y
# CONFIG_IMA_DISABLE_HTABLE is not set
CONFIG_EVM=y
CONFIG_EVM_ATTR_FSUUID=y
# CONFIG_EVM_ADD_XATTRS is not set
# CONFIG_EVM_LOAD_X509 is not set
CONFIG_DEFAULT_SECURITY_SELINUX=y
# CONFIG_DEFAULT_SECURITY_DAC is not set
CONFIG_LSM="landlock,lockdown,yama,loadpin,safesetid,integrity,selinux,smack,tomoyo,apparmor,bpf"

#
# Kernel hardening options
#

#
# Memory initialization
#
CONFIG_INIT_STACK_NONE=y
CONFIG_INIT_ON_ALLOC_DEFAULT_ON=y
# CONFIG_INIT_ON_FREE_DEFAULT_ON is not set
# end of Memory initialization
# end of Kernel hardening options
# end of Security options

CONFIG_XOR_BLOCKS=m
CONFIG_ASYNC_CORE=m
CONFIG_ASYNC_MEMCPY=m
CONFIG_ASYNC_XOR=m
CONFIG_ASYNC_PQ=m
CONFIG_ASYNC_RAID6_RECOV=m
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
CONFIG_CRYPTO_KPP=m
CONFIG_CRYPTO_ACOMP2=y
CONFIG_CRYPTO_MANAGER=y
CONFIG_CRYPTO_MANAGER2=y
CONFIG_CRYPTO_USER=m
CONFIG_CRYPTO_MANAGER_DISABLE_TESTS=y
CONFIG_CRYPTO_GF128MUL=y
CONFIG_CRYPTO_NULL=y
CONFIG_CRYPTO_NULL2=y
CONFIG_CRYPTO_PCRYPT=m
CONFIG_CRYPTO_CRYPTD=y
CONFIG_CRYPTO_AUTHENC=m
CONFIG_CRYPTO_TEST=m
CONFIG_CRYPTO_SIMD=y

#
# Public-key cryptography
#
CONFIG_CRYPTO_RSA=y
CONFIG_CRYPTO_DH=m
CONFIG_CRYPTO_ECC=m
CONFIG_CRYPTO_ECDH=m
# CONFIG_CRYPTO_ECDSA is not set
# CONFIG_CRYPTO_ECRDSA is not set
# CONFIG_CRYPTO_SM2 is not set
# CONFIG_CRYPTO_CURVE25519 is not set
# CONFIG_CRYPTO_CURVE25519_X86 is not set

#
# Authenticated Encryption with Associated Data
#
CONFIG_CRYPTO_CCM=m
CONFIG_CRYPTO_GCM=y
CONFIG_CRYPTO_CHACHA20POLY1305=m
# CONFIG_CRYPTO_AEGIS128 is not set
# CONFIG_CRYPTO_AEGIS128_AESNI_SSE2 is not set
CONFIG_CRYPTO_SEQIV=y
CONFIG_CRYPTO_ECHAINIV=m

#
# Block modes
#
CONFIG_CRYPTO_CBC=y
CONFIG_CRYPTO_CFB=y
CONFIG_CRYPTO_CTR=y
CONFIG_CRYPTO_CTS=m
CONFIG_CRYPTO_ECB=y
CONFIG_CRYPTO_LRW=m
# CONFIG_CRYPTO_OFB is not set
CONFIG_CRYPTO_PCBC=m
CONFIG_CRYPTO_XTS=m
# CONFIG_CRYPTO_KEYWRAP is not set
# CONFIG_CRYPTO_NHPOLY1305_SSE2 is not set
# CONFIG_CRYPTO_NHPOLY1305_AVX2 is not set
# CONFIG_CRYPTO_ADIANTUM is not set
CONFIG_CRYPTO_ESSIV=m

#
# Hash modes
#
CONFIG_CRYPTO_CMAC=m
CONFIG_CRYPTO_HMAC=y
CONFIG_CRYPTO_XCBC=m
CONFIG_CRYPTO_VMAC=m

#
# Digest
#
CONFIG_CRYPTO_CRC32C=y
CONFIG_CRYPTO_CRC32C_INTEL=m
CONFIG_CRYPTO_CRC32=m
CONFIG_CRYPTO_CRC32_PCLMUL=m
CONFIG_CRYPTO_XXHASH=m
CONFIG_CRYPTO_BLAKE2B=m
# CONFIG_CRYPTO_BLAKE2S is not set
# CONFIG_CRYPTO_BLAKE2S_X86 is not set
CONFIG_CRYPTO_CRCT10DIF=y
CONFIG_CRYPTO_CRCT10DIF_PCLMUL=m
CONFIG_CRYPTO_GHASH=y
CONFIG_CRYPTO_POLY1305=m
CONFIG_CRYPTO_POLY1305_X86_64=m
CONFIG_CRYPTO_MD4=m
CONFIG_CRYPTO_MD5=y
CONFIG_CRYPTO_MICHAEL_MIC=m
CONFIG_CRYPTO_RMD160=m
CONFIG_CRYPTO_SHA1=y
CONFIG_CRYPTO_SHA1_SSSE3=y
CONFIG_CRYPTO_SHA256_SSSE3=y
CONFIG_CRYPTO_SHA512_SSSE3=m
CONFIG_CRYPTO_SHA256=y
CONFIG_CRYPTO_SHA512=y
CONFIG_CRYPTO_SHA3=m
# CONFIG_CRYPTO_SM3 is not set
# CONFIG_CRYPTO_STREEBOG is not set
CONFIG_CRYPTO_WP512=m
CONFIG_CRYPTO_GHASH_CLMUL_NI_INTEL=m

#
# Ciphers
#
CONFIG_CRYPTO_AES=y
# CONFIG_CRYPTO_AES_TI is not set
CONFIG_CRYPTO_AES_NI_INTEL=y
CONFIG_CRYPTO_ANUBIS=m
CONFIG_CRYPTO_ARC4=m
CONFIG_CRYPTO_BLOWFISH=m
CONFIG_CRYPTO_BLOWFISH_COMMON=m
CONFIG_CRYPTO_BLOWFISH_X86_64=m
CONFIG_CRYPTO_CAMELLIA=m
CONFIG_CRYPTO_CAMELLIA_X86_64=m
CONFIG_CRYPTO_CAMELLIA_AESNI_AVX_X86_64=m
CONFIG_CRYPTO_CAMELLIA_AESNI_AVX2_X86_64=m
CONFIG_CRYPTO_CAST_COMMON=m
CONFIG_CRYPTO_CAST5=m
CONFIG_CRYPTO_CAST5_AVX_X86_64=m
CONFIG_CRYPTO_CAST6=m
CONFIG_CRYPTO_CAST6_AVX_X86_64=m
CONFIG_CRYPTO_DES=m
# CONFIG_CRYPTO_DES3_EDE_X86_64 is not set
CONFIG_CRYPTO_FCRYPT=m
CONFIG_CRYPTO_KHAZAD=m
CONFIG_CRYPTO_CHACHA20=m
CONFIG_CRYPTO_CHACHA20_X86_64=m
CONFIG_CRYPTO_SEED=m
CONFIG_CRYPTO_SERPENT=m
CONFIG_CRYPTO_SERPENT_SSE2_X86_64=m
CONFIG_CRYPTO_SERPENT_AVX_X86_64=m
CONFIG_CRYPTO_SERPENT_AVX2_X86_64=m
CONFIG_CRYPTO_SM4=y
# CONFIG_CRYPTO_SM4_AESNI_AVX_X86_64 is not set
# CONFIG_CRYPTO_SM4_AESNI_AVX2_X86_64 is not set
CONFIG_CRYPTO_TEA=m
CONFIG_CRYPTO_TWOFISH=m
CONFIG_CRYPTO_TWOFISH_COMMON=m
CONFIG_CRYPTO_TWOFISH_X86_64=m
CONFIG_CRYPTO_TWOFISH_X86_64_3WAY=m
CONFIG_CRYPTO_TWOFISH_AVX_X86_64=m

#
# Compression
#
CONFIG_CRYPTO_DEFLATE=y
CONFIG_CRYPTO_LZO=y
# CONFIG_CRYPTO_842 is not set
# CONFIG_CRYPTO_LZ4 is not set
# CONFIG_CRYPTO_LZ4HC is not set
# CONFIG_CRYPTO_ZSTD is not set

#
# Random Number Generation
#
CONFIG_CRYPTO_ANSI_CPRNG=m
CONFIG_CRYPTO_DRBG_MENU=y
CONFIG_CRYPTO_DRBG_HMAC=y
CONFIG_CRYPTO_DRBG_HASH=y
CONFIG_CRYPTO_DRBG_CTR=y
CONFIG_CRYPTO_DRBG=y
CONFIG_CRYPTO_JITTERENTROPY=y
CONFIG_CRYPTO_USER_API=y
CONFIG_CRYPTO_USER_API_HASH=y
CONFIG_CRYPTO_USER_API_SKCIPHER=y
CONFIG_CRYPTO_USER_API_RNG=y
# CONFIG_CRYPTO_USER_API_RNG_CAVP is not set
CONFIG_CRYPTO_USER_API_AEAD=y
CONFIG_CRYPTO_USER_API_ENABLE_OBSOLETE=y
# CONFIG_CRYPTO_STATS is not set
CONFIG_CRYPTO_HASH_INFO=y

#
# Crypto library routines
#
CONFIG_CRYPTO_LIB_AES=y
CONFIG_CRYPTO_LIB_ARC4=m
# CONFIG_CRYPTO_LIB_BLAKE2S is not set
CONFIG_CRYPTO_ARCH_HAVE_LIB_CHACHA=m
CONFIG_CRYPTO_LIB_CHACHA_GENERIC=m
# CONFIG_CRYPTO_LIB_CHACHA is not set
# CONFIG_CRYPTO_LIB_CURVE25519 is not set
CONFIG_CRYPTO_LIB_DES=m
CONFIG_CRYPTO_LIB_POLY1305_RSIZE=11
CONFIG_CRYPTO_ARCH_HAVE_LIB_POLY1305=m
CONFIG_CRYPTO_LIB_POLY1305_GENERIC=m
# CONFIG_CRYPTO_LIB_POLY1305 is not set
# CONFIG_CRYPTO_LIB_CHACHA20POLY1305 is not set
CONFIG_CRYPTO_LIB_SHA256=y
CONFIG_CRYPTO_LIB_SM4=y
CONFIG_CRYPTO_HW=y
CONFIG_CRYPTO_DEV_PADLOCK=m
CONFIG_CRYPTO_DEV_PADLOCK_AES=m
CONFIG_CRYPTO_DEV_PADLOCK_SHA=m
# CONFIG_CRYPTO_DEV_ATMEL_ECC is not set
# CONFIG_CRYPTO_DEV_ATMEL_SHA204A is not set
CONFIG_CRYPTO_DEV_CCP=y
CONFIG_CRYPTO_DEV_CCP_DD=m
CONFIG_CRYPTO_DEV_SP_CCP=y
CONFIG_CRYPTO_DEV_CCP_CRYPTO=m
CONFIG_CRYPTO_DEV_SP_PSP=y
# CONFIG_CRYPTO_DEV_CCP_DEBUGFS is not set
CONFIG_CRYPTO_DEV_QAT=m
CONFIG_CRYPTO_DEV_QAT_DH895xCC=m
CONFIG_CRYPTO_DEV_QAT_C3XXX=m
CONFIG_CRYPTO_DEV_QAT_C62X=m
# CONFIG_CRYPTO_DEV_QAT_4XXX is not set
CONFIG_CRYPTO_DEV_QAT_DH895xCCVF=m
CONFIG_CRYPTO_DEV_QAT_C3XXXVF=m
CONFIG_CRYPTO_DEV_QAT_C62XVF=m
CONFIG_CRYPTO_DEV_NITROX=m
CONFIG_CRYPTO_DEV_NITROX_CNN55XX=m
# CONFIG_CRYPTO_DEV_VIRTIO is not set
# CONFIG_CRYPTO_DEV_SAFEXCEL is not set
# CONFIG_CRYPTO_DEV_AMLOGIC_GXL is not set
CONFIG_ASYMMETRIC_KEY_TYPE=y
CONFIG_ASYMMETRIC_PUBLIC_KEY_SUBTYPE=y
# CONFIG_ASYMMETRIC_TPM_KEY_SUBTYPE is not set
CONFIG_X509_CERTIFICATE_PARSER=y
# CONFIG_PKCS8_PRIVATE_KEY_PARSER is not set
CONFIG_PKCS7_MESSAGE_PARSER=y
# CONFIG_PKCS7_TEST_KEY is not set
CONFIG_SIGNED_PE_FILE_VERIFICATION=y

#
# Certificates for signature checking
#
CONFIG_MODULE_SIG_KEY="certs/signing_key.pem"
CONFIG_MODULE_SIG_KEY_TYPE_RSA=y
# CONFIG_MODULE_SIG_KEY_TYPE_ECDSA is not set
CONFIG_SYSTEM_TRUSTED_KEYRING=y
CONFIG_SYSTEM_TRUSTED_KEYS=""
# CONFIG_SYSTEM_EXTRA_CERTIFICATE is not set
# CONFIG_SECONDARY_TRUSTED_KEYRING is not set
CONFIG_SYSTEM_BLACKLIST_KEYRING=y
CONFIG_SYSTEM_BLACKLIST_HASH_LIST=""
# CONFIG_SYSTEM_REVOCATION_LIST is not set
# end of Certificates for signature checking

CONFIG_BINARY_PRINTF=y

#
# Library routines
#
CONFIG_RAID6_PQ=m
CONFIG_RAID6_PQ_BENCHMARK=y
# CONFIG_PACKING is not set
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
CONFIG_ARCH_USE_CMPXCHG_LOCKREF=y
CONFIG_ARCH_HAS_FAST_MULTIPLIER=y
CONFIG_ARCH_USE_SYM_ANNOTATIONS=y
CONFIG_CRC_CCITT=y
CONFIG_CRC16=y
CONFIG_CRC_T10DIF=y
CONFIG_CRC_ITU_T=m
CONFIG_CRC32=y
# CONFIG_CRC32_SELFTEST is not set
CONFIG_CRC32_SLICEBY8=y
# CONFIG_CRC32_SLICEBY4 is not set
# CONFIG_CRC32_SARWATE is not set
# CONFIG_CRC32_BIT is not set
# CONFIG_CRC64 is not set
# CONFIG_CRC4 is not set
CONFIG_CRC7=m
CONFIG_LIBCRC32C=m
CONFIG_CRC8=m
CONFIG_XXHASH=y
# CONFIG_RANDOM32_SELFTEST is not set
CONFIG_ZLIB_INFLATE=y
CONFIG_ZLIB_DEFLATE=y
CONFIG_LZO_COMPRESS=y
CONFIG_LZO_DECOMPRESS=y
CONFIG_LZ4_DECOMPRESS=y
CONFIG_ZSTD_COMPRESS=m
CONFIG_ZSTD_DECOMPRESS=y
CONFIG_XZ_DEC=y
CONFIG_XZ_DEC_X86=y
CONFIG_XZ_DEC_POWERPC=y
CONFIG_XZ_DEC_IA64=y
CONFIG_XZ_DEC_ARM=y
CONFIG_XZ_DEC_ARMTHUMB=y
CONFIG_XZ_DEC_SPARC=y
CONFIG_XZ_DEC_BCJ=y
# CONFIG_XZ_DEC_TEST is not set
CONFIG_DECOMPRESS_GZIP=y
CONFIG_DECOMPRESS_BZIP2=y
CONFIG_DECOMPRESS_LZMA=y
CONFIG_DECOMPRESS_XZ=y
CONFIG_DECOMPRESS_LZO=y
CONFIG_DECOMPRESS_LZ4=y
CONFIG_DECOMPRESS_ZSTD=y
CONFIG_GENERIC_ALLOCATOR=y
CONFIG_REED_SOLOMON=m
CONFIG_REED_SOLOMON_ENC8=y
CONFIG_REED_SOLOMON_DEC8=y
CONFIG_TEXTSEARCH=y
CONFIG_TEXTSEARCH_KMP=m
CONFIG_TEXTSEARCH_BM=m
CONFIG_TEXTSEARCH_FSM=m
CONFIG_INTERVAL_TREE=y
CONFIG_XARRAY_MULTI=y
CONFIG_ASSOCIATIVE_ARRAY=y
CONFIG_HAS_IOMEM=y
CONFIG_HAS_IOPORT_MAP=y
CONFIG_HAS_DMA=y
CONFIG_DMA_OPS=y
CONFIG_NEED_SG_DMA_LENGTH=y
CONFIG_NEED_DMA_MAP_STATE=y
CONFIG_ARCH_DMA_ADDR_T_64BIT=y
CONFIG_SWIOTLB=y
# CONFIG_DMA_API_DEBUG is not set
CONFIG_DMA_MAP_BENCHMARK=y
CONFIG_SGL_ALLOC=y
CONFIG_CHECK_SIGNATURE=y
CONFIG_CPUMASK_OFFSTACK=y
CONFIG_CPU_RMAP=y
CONFIG_DQL=y
CONFIG_GLOB=y
# CONFIG_GLOB_SELFTEST is not set
CONFIG_NLATTR=y
CONFIG_CLZ_TAB=y
CONFIG_IRQ_POLL=y
CONFIG_MPILIB=y
CONFIG_SIGNATURE=y
CONFIG_OID_REGISTRY=y
CONFIG_UCS2_STRING=y
CONFIG_HAVE_GENERIC_VDSO=y
CONFIG_GENERIC_GETTIMEOFDAY=y
CONFIG_GENERIC_VDSO_TIME_NS=y
CONFIG_FONT_SUPPORT=y
# CONFIG_FONTS is not set
CONFIG_FONT_8x8=y
CONFIG_FONT_8x16=y
CONFIG_SG_POOL=y
CONFIG_ARCH_HAS_PMEM_API=y
CONFIG_MEMREGION=y
CONFIG_ARCH_HAS_UACCESS_FLUSHCACHE=y
CONFIG_ARCH_HAS_COPY_MC=y
CONFIG_ARCH_STACKWALK=y
CONFIG_STACKDEPOT=y
CONFIG_STACK_HASH_ORDER=20
CONFIG_SBITMAP=y
# end of Library routines

CONFIG_ASN1_ENCODER=y

#
# Kernel hacking
#

#
# printk and dmesg options
#
CONFIG_PRINTK_TIME=y
CONFIG_PRINTK_CALLER=y
# CONFIG_STACKTRACE_BUILD_ID is not set
CONFIG_CONSOLE_LOGLEVEL_DEFAULT=7
CONFIG_CONSOLE_LOGLEVEL_QUIET=4
CONFIG_MESSAGE_LOGLEVEL_DEFAULT=4
CONFIG_BOOT_PRINTK_DELAY=y
CONFIG_DYNAMIC_DEBUG=y
CONFIG_DYNAMIC_DEBUG_CORE=y
CONFIG_SYMBOLIC_ERRNAME=y
CONFIG_DEBUG_BUGVERBOSE=y
# end of printk and dmesg options

#
# Compile-time checks and compiler options
#
CONFIG_DEBUG_INFO=y
# CONFIG_DEBUG_INFO_REDUCED is not set
# CONFIG_DEBUG_INFO_COMPRESSED is not set
# CONFIG_DEBUG_INFO_SPLIT is not set
# CONFIG_DEBUG_INFO_DWARF_TOOLCHAIN_DEFAULT is not set
CONFIG_DEBUG_INFO_DWARF4=y
CONFIG_DEBUG_INFO_BTF=y
CONFIG_PAHOLE_HAS_SPLIT_BTF=y
CONFIG_DEBUG_INFO_BTF_MODULES=y
# CONFIG_GDB_SCRIPTS is not set
CONFIG_FRAME_WARN=8192
CONFIG_STRIP_ASM_SYMS=y
# CONFIG_READABLE_ASM is not set
# CONFIG_HEADERS_INSTALL is not set
CONFIG_DEBUG_SECTION_MISMATCH=y
CONFIG_SECTION_MISMATCH_WARN_ONLY=y
# CONFIG_DEBUG_FORCE_FUNCTION_ALIGN_64B is not set
CONFIG_STACK_VALIDATION=y
# CONFIG_VMLINUX_MAP is not set
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
CONFIG_DEBUG_FS_ALLOW_ALL=y
# CONFIG_DEBUG_FS_DISALLOW_MOUNT is not set
# CONFIG_DEBUG_FS_ALLOW_NONE is not set
CONFIG_HAVE_ARCH_KGDB=y
# CONFIG_KGDB is not set
CONFIG_ARCH_HAS_UBSAN_SANITIZE_ALL=y
CONFIG_UBSAN=y
# CONFIG_UBSAN_TRAP is not set
CONFIG_CC_HAS_UBSAN_BOUNDS=y
CONFIG_UBSAN_BOUNDS=y
CONFIG_UBSAN_ONLY_BOUNDS=y
CONFIG_UBSAN_SHIFT=y
# CONFIG_UBSAN_DIV_ZERO is not set
# CONFIG_UBSAN_BOOL is not set
# CONFIG_UBSAN_ENUM is not set
# CONFIG_UBSAN_ALIGNMENT is not set
CONFIG_UBSAN_SANITIZE_ALL=y
# CONFIG_TEST_UBSAN is not set
CONFIG_HAVE_ARCH_KCSAN=y
# end of Generic Kernel Debugging Instruments

CONFIG_DEBUG_KERNEL=y
CONFIG_DEBUG_MISC=y

#
# Memory Debugging
#
CONFIG_PAGE_EXTENSION=y
# CONFIG_DEBUG_PAGEALLOC is not set
CONFIG_PAGE_OWNER=y
# CONFIG_PAGE_POISONING is not set
# CONFIG_DEBUG_PAGE_REF is not set
# CONFIG_DEBUG_RODATA_TEST is not set
CONFIG_ARCH_HAS_DEBUG_WX=y
# CONFIG_DEBUG_WX is not set
CONFIG_GENERIC_PTDUMP=y
# CONFIG_PTDUMP_DEBUGFS is not set
# CONFIG_DEBUG_OBJECTS is not set
# CONFIG_SLUB_DEBUG_ON is not set
# CONFIG_SLUB_STATS is not set
CONFIG_HAVE_DEBUG_KMEMLEAK=y
# CONFIG_DEBUG_KMEMLEAK is not set
# CONFIG_DEBUG_STACK_USAGE is not set
# CONFIG_SCHED_STACK_END_CHECK is not set
CONFIG_ARCH_HAS_DEBUG_VM_PGTABLE=y
# CONFIG_DEBUG_VM is not set
# CONFIG_DEBUG_VM_PGTABLE is not set
CONFIG_ARCH_HAS_DEBUG_VIRTUAL=y
# CONFIG_DEBUG_VIRTUAL is not set
CONFIG_DEBUG_MEMORY_INIT=y
CONFIG_MEMORY_NOTIFIER_ERROR_INJECT=m
# CONFIG_DEBUG_PER_CPU_MAPS is not set
CONFIG_HAVE_ARCH_KASAN=y
CONFIG_HAVE_ARCH_KASAN_VMALLOC=y
CONFIG_CC_HAS_KASAN_GENERIC=y
CONFIG_CC_HAS_WORKING_NOSANITIZE_ADDRESS=y
CONFIG_KASAN=y
CONFIG_KASAN_GENERIC=y
# CONFIG_KASAN_OUTLINE is not set
CONFIG_KASAN_INLINE=y
CONFIG_KASAN_STACK=y
CONFIG_KASAN_VMALLOC=y
# CONFIG_KASAN_MODULE_TEST is not set
CONFIG_HAVE_ARCH_KFENCE=y
# CONFIG_KFENCE is not set
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
CONFIG_HARDLOCKUP_DETECTOR_PERF=y
CONFIG_HARDLOCKUP_CHECK_TIMESTAMP=y
CONFIG_HARDLOCKUP_DETECTOR=y
CONFIG_BOOTPARAM_HARDLOCKUP_PANIC=y
CONFIG_BOOTPARAM_HARDLOCKUP_PANIC_VALUE=1
CONFIG_DETECT_HUNG_TASK=y
CONFIG_DEFAULT_HUNG_TASK_TIMEOUT=480
# CONFIG_BOOTPARAM_HUNG_TASK_PANIC is not set
CONFIG_BOOTPARAM_HUNG_TASK_PANIC_VALUE=0
CONFIG_WQ_WATCHDOG=y
# CONFIG_TEST_LOCKUP is not set
# end of Debug Oops, Lockups and Hangs

#
# Scheduler Debugging
#
CONFIG_SCHED_DEBUG=y
CONFIG_SCHED_INFO=y
CONFIG_SCHEDSTATS=y
# end of Scheduler Debugging

# CONFIG_DEBUG_TIMEKEEPING is not set
CONFIG_DEBUG_PREEMPT=y

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
CONFIG_LOCKDEP_BITS=15
CONFIG_LOCKDEP_CHAINS_BITS=16
CONFIG_LOCKDEP_STACK_TRACE_BITS=19
CONFIG_LOCKDEP_STACK_TRACE_HASH_BITS=14
CONFIG_LOCKDEP_CIRCULAR_QUEUE_BITS=12
# CONFIG_DEBUG_LOCKDEP is not set
CONFIG_DEBUG_ATOMIC_SLEEP=y
# CONFIG_DEBUG_LOCKING_API_SELFTESTS is not set
# CONFIG_LOCK_TORTURE_TEST is not set
CONFIG_WW_MUTEX_SELFTEST=m
# CONFIG_SCF_TORTURE_TEST is not set
# CONFIG_CSD_LOCK_WAIT_DEBUG is not set
# end of Lock Debugging (spinlocks, mutexes, etc...)

CONFIG_TRACE_IRQFLAGS=y
CONFIG_TRACE_IRQFLAGS_NMI=y
# CONFIG_DEBUG_IRQFLAGS is not set
CONFIG_STACKTRACE=y
# CONFIG_WARN_ALL_UNSEEDED_RANDOM is not set
# CONFIG_DEBUG_KOBJECT is not set

#
# Debug kernel data structures
#
CONFIG_DEBUG_LIST=y
CONFIG_DEBUG_PLIST=y
# CONFIG_DEBUG_SG is not set
# CONFIG_DEBUG_NOTIFIERS is not set
CONFIG_BUG_ON_DATA_CORRUPTION=y
# end of Debug kernel data structures

# CONFIG_DEBUG_CREDENTIALS is not set

#
# RCU Debugging
#
CONFIG_PROVE_RCU=y
# CONFIG_RCU_SCALE_TEST is not set
# CONFIG_RCU_TORTURE_TEST is not set
# CONFIG_RCU_REF_SCALE_TEST is not set
CONFIG_RCU_CPU_STALL_TIMEOUT=60
# CONFIG_RCU_TRACE is not set
# CONFIG_RCU_EQS_DEBUG is not set
# end of RCU Debugging

# CONFIG_DEBUG_WQ_FORCE_RR_CPU is not set
# CONFIG_CPU_HOTPLUG_STATE_CONTROL is not set
CONFIG_LATENCYTOP=y
CONFIG_USER_STACKTRACE_SUPPORT=y
CONFIG_NOP_TRACER=y
CONFIG_HAVE_FUNCTION_TRACER=y
CONFIG_HAVE_FUNCTION_GRAPH_TRACER=y
CONFIG_HAVE_DYNAMIC_FTRACE=y
CONFIG_HAVE_DYNAMIC_FTRACE_WITH_REGS=y
CONFIG_HAVE_DYNAMIC_FTRACE_WITH_DIRECT_CALLS=y
CONFIG_HAVE_DYNAMIC_FTRACE_WITH_ARGS=y
CONFIG_HAVE_FTRACE_MCOUNT_RECORD=y
CONFIG_HAVE_SYSCALL_TRACEPOINTS=y
CONFIG_HAVE_FENTRY=y
CONFIG_HAVE_OBJTOOL_MCOUNT=y
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
CONFIG_FUNCTION_TRACER=y
CONFIG_FUNCTION_GRAPH_TRACER=y
CONFIG_DYNAMIC_FTRACE=y
CONFIG_DYNAMIC_FTRACE_WITH_REGS=y
CONFIG_DYNAMIC_FTRACE_WITH_DIRECT_CALLS=y
CONFIG_DYNAMIC_FTRACE_WITH_ARGS=y
CONFIG_FUNCTION_PROFILER=y
CONFIG_STACK_TRACER=y
CONFIG_TRACE_PREEMPT_TOGGLE=y
CONFIG_IRQSOFF_TRACER=y
CONFIG_PREEMPT_TRACER=y
CONFIG_SCHED_TRACER=y
CONFIG_HWLAT_TRACER=y
# CONFIG_OSNOISE_TRACER is not set
# CONFIG_TIMERLAT_TRACER is not set
# CONFIG_MMIOTRACE is not set
CONFIG_FTRACE_SYSCALLS=y
CONFIG_TRACER_SNAPSHOT=y
CONFIG_TRACER_SNAPSHOT_PER_CPU_SWAP=y
CONFIG_BRANCH_PROFILE_NONE=y
# CONFIG_PROFILE_ANNOTATED_BRANCHES is not set
CONFIG_BLK_DEV_IO_TRACE=y
CONFIG_KPROBE_EVENTS=y
# CONFIG_KPROBE_EVENTS_ON_NOTRACE is not set
CONFIG_UPROBE_EVENTS=y
CONFIG_BPF_EVENTS=y
CONFIG_DYNAMIC_EVENTS=y
CONFIG_PROBE_EVENTS=y
# CONFIG_BPF_KPROBE_OVERRIDE is not set
CONFIG_FTRACE_MCOUNT_RECORD=y
CONFIG_FTRACE_MCOUNT_USE_CC=y
CONFIG_TRACING_MAP=y
CONFIG_SYNTH_EVENTS=y
CONFIG_HIST_TRIGGERS=y
# CONFIG_TRACE_EVENT_INJECT is not set
# CONFIG_TRACEPOINT_BENCHMARK is not set
CONFIG_RING_BUFFER_BENCHMARK=m
# CONFIG_TRACE_EVAL_MAP_FILE is not set
# CONFIG_FTRACE_RECORD_RECURSION is not set
# CONFIG_FTRACE_STARTUP_TEST is not set
# CONFIG_RING_BUFFER_STARTUP_TEST is not set
# CONFIG_RING_BUFFER_VALIDATE_TIME_DELTAS is not set
CONFIG_PREEMPTIRQ_DELAY_TEST=m
# CONFIG_SYNTH_EVENT_GEN_TEST is not set
# CONFIG_KPROBE_EVENT_GEN_TEST is not set
# CONFIG_HIST_TRIGGERS_DEBUG is not set
CONFIG_PROVIDE_OHCI1394_DMA_INIT=y
CONFIG_SAMPLES=y
# CONFIG_SAMPLE_AUXDISPLAY is not set
# CONFIG_SAMPLE_TRACE_EVENTS is not set
CONFIG_SAMPLE_TRACE_PRINTK=m
CONFIG_SAMPLE_FTRACE_DIRECT=m
# CONFIG_SAMPLE_TRACE_ARRAY is not set
# CONFIG_SAMPLE_KOBJECT is not set
# CONFIG_SAMPLE_KPROBES is not set
# CONFIG_SAMPLE_HW_BREAKPOINT is not set
# CONFIG_SAMPLE_KFIFO is not set
# CONFIG_SAMPLE_LIVEPATCH is not set
# CONFIG_SAMPLE_CONFIGFS is not set
# CONFIG_SAMPLE_VFIO_MDEV_MTTY is not set
# CONFIG_SAMPLE_VFIO_MDEV_MDPY is not set
# CONFIG_SAMPLE_VFIO_MDEV_MDPY_FB is not set
# CONFIG_SAMPLE_VFIO_MDEV_MBOCHS is not set
# CONFIG_SAMPLE_WATCHDOG is not set
CONFIG_ARCH_HAS_DEVMEM_IS_ALLOWED=y
CONFIG_STRICT_DEVMEM=y
# CONFIG_IO_STRICT_DEVMEM is not set

#
# x86 Debugging
#
CONFIG_TRACE_IRQFLAGS_NMI_SUPPORT=y
CONFIG_EARLY_PRINTK_USB=y
CONFIG_X86_VERBOSE_BOOTUP=y
CONFIG_EARLY_PRINTK=y
CONFIG_EARLY_PRINTK_DBGP=y
CONFIG_EARLY_PRINTK_USB_XDBC=y
# CONFIG_EFI_PGT_DUMP is not set
# CONFIG_DEBUG_TLBFLUSH is not set
CONFIG_HAVE_MMIOTRACE_SUPPORT=y
CONFIG_X86_DECODER_SELFTEST=y
CONFIG_IO_DELAY_0X80=y
# CONFIG_IO_DELAY_0XED is not set
# CONFIG_IO_DELAY_UDELAY is not set
# CONFIG_IO_DELAY_NONE is not set
CONFIG_DEBUG_BOOT_PARAMS=y
# CONFIG_CPA_DEBUG is not set
# CONFIG_DEBUG_ENTRY is not set
# CONFIG_DEBUG_NMI_SELFTEST is not set
# CONFIG_X86_DEBUG_FPU is not set
# CONFIG_PUNIT_ATOM_DEBUG is not set
CONFIG_UNWINDER_ORC=y
# CONFIG_UNWINDER_FRAME_POINTER is not set
# end of x86 Debugging

#
# Kernel Testing and Coverage
#
# CONFIG_KUNIT is not set
CONFIG_NOTIFIER_ERROR_INJECTION=y
CONFIG_PM_NOTIFIER_ERROR_INJECT=m
# CONFIG_NETDEV_NOTIFIER_ERROR_INJECT is not set
CONFIG_FUNCTION_ERROR_INJECTION=y
# CONFIG_FAULT_INJECTION is not set
CONFIG_ARCH_HAS_KCOV=y
CONFIG_CC_HAS_SANCOV_TRACE_PC=y
# CONFIG_KCOV is not set
CONFIG_RUNTIME_TESTING_MENU=y
CONFIG_LKDTM=y
# CONFIG_TEST_MIN_HEAP is not set
# CONFIG_TEST_DIV64 is not set
# CONFIG_KPROBES_SANITY_TEST is not set
# CONFIG_BACKTRACE_SELF_TEST is not set
# CONFIG_RBTREE_TEST is not set
# CONFIG_REED_SOLOMON_TEST is not set
# CONFIG_INTERVAL_TREE_TEST is not set
# CONFIG_PERCPU_TEST is not set
CONFIG_ATOMIC64_SELFTEST=y
# CONFIG_ASYNC_RAID6_TEST is not set
# CONFIG_TEST_HEXDUMP is not set
# CONFIG_STRING_SELFTEST is not set
# CONFIG_TEST_STRING_HELPERS is not set
CONFIG_TEST_STRSCPY=m
# CONFIG_TEST_KSTRTOX is not set
CONFIG_TEST_PRINTF=m
CONFIG_TEST_SCANF=m
CONFIG_TEST_BITMAP=m
# CONFIG_TEST_UUID is not set
# CONFIG_TEST_XARRAY is not set
# CONFIG_TEST_OVERFLOW is not set
# CONFIG_TEST_RHASHTABLE is not set
# CONFIG_TEST_HASH is not set
# CONFIG_TEST_IDA is not set
CONFIG_TEST_LKM=m
CONFIG_TEST_BITOPS=m
CONFIG_TEST_VMALLOC=m
CONFIG_TEST_USER_COPY=m
CONFIG_TEST_BPF=m
CONFIG_TEST_BLACKHOLE_DEV=m
# CONFIG_FIND_BIT_BENCHMARK is not set
CONFIG_TEST_FIRMWARE=y
CONFIG_TEST_SYSCTL=y
# CONFIG_TEST_UDELAY is not set
CONFIG_TEST_STATIC_KEYS=m
CONFIG_TEST_KMOD=m
# CONFIG_TEST_MEMCAT_P is not set
CONFIG_TEST_LIVEPATCH=m
# CONFIG_TEST_STACKINIT is not set
# CONFIG_TEST_MEMINIT is not set
CONFIG_TEST_HMM=m
# CONFIG_TEST_FREE_PAGES is not set
# CONFIG_TEST_FPU is not set
# CONFIG_TEST_CLOCKSOURCE_WATCHDOG is not set
CONFIG_ARCH_USE_MEMTEST=y
# CONFIG_MEMTEST is not set
# CONFIG_HYPERV_TESTING is not set
# end of Kernel Testing and Coverage
# end of Kernel hacking

--jho1yZJdad60DJr+
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=job-script

#!/bin/sh

export_top_env()
{
	export suite='kernel-selftests'
	export testcase='kernel-selftests'
	export category='functional'
	export kconfig='x86_64-rhel-8.3-kselftests'
	export need_memory='2G'
	export need_cpu=2
	export kernel_cmdline='erst_disable'
	export job_origin='kernel-selftests-x86.yaml'
	export queue_cmdline_keys='branch
commit
queue_at_least_once'
	export queue='validate'
	export testbox='lkp-kbl-nuc1'
	export tbox_group='lkp-kbl-nuc1'
	export submit_id='618a3a90e6a3ead0df48507b'
	export job_file='/lkp/jobs/scheduled/lkp-kbl-nuc1/kernel-selftests-x86-ucode=0xde-debian-10.4-x86_64-20200603.cgz-95e381b6095d0808a64ecbe36515cca2ea2df477-20211109-53471-fhz5q7-3.yaml'
	export id='072cc31be4ca17bf32d8ee78c71458f39d3d9fe8'
	export queuer_version='/lkp-src'
	export model='Kaby Lake'
	export nr_node=1
	export nr_cpu=4
	export memory='32G'
	export nr_sdd_partitions=1
	export ssd_partitions='/dev/disk/by-id/ata-INTEL_SSDSC2BB800G4_PHWL4171000W800RGN-part2'
	export swap_partitions=
	export rootfs_partition='/dev/disk/by-id/ata-INTEL_SSDSC2BB800G4_PHWL4171000W800RGN-part1'
	export brand='Intel(R) Core(TM) i7-7567U CPU @ 3.50GHz'
	export commit='95e381b6095d0808a64ecbe36515cca2ea2df477'
	export netconsole_port=6674
	export ucode='0xde'
	export need_kconfig_hw='{"E1000E"=>"y"}
SATA_AHCI
DRM_I915'
	export need_kconfig=\{\"POSIX_TIMERS\"\=\>\"y,\ v4.10-rc1\"\}
	export initrds='linux_headers
linux_selftests'
	export enqueue_time='2021-11-09 17:08:33 +0800'
	export _id='618a3aa2e6a3ead0df48507d'
	export _rt='/result/kernel-selftests/x86-ucode=0xde/lkp-kbl-nuc1/debian-10.4-x86_64-20200603.cgz/x86_64-rhel-8.3-kselftests/gcc-9/95e381b6095d0808a64ecbe36515cca2ea2df477'
	export user='lkp'
	export compiler='gcc-9'
	export LKP_SERVER='internal-lkp-server'
	export head_commit='e0d453ef5cd3bed98369fb0fc7d2c78bcb3d0e93'
	export base_commit='8bb7eca972ad531c9b149c0a51ab43a417385813'
	export branch='linux-review/Kuniyuki-Iwashima/af_unix-Replace-unix_table_lock-with-per-hash-locks/20211106-172208'
	export rootfs='debian-10.4-x86_64-20200603.cgz'
	export result_root='/result/kernel-selftests/x86-ucode=0xde/lkp-kbl-nuc1/debian-10.4-x86_64-20200603.cgz/x86_64-rhel-8.3-kselftests/gcc-9/95e381b6095d0808a64ecbe36515cca2ea2df477/3'
	export scheduler_version='/lkp/lkp/.src-20211109-153149'
	export arch='x86_64'
	export max_uptime=2100
	export initrd='/osimage/debian/debian-10.4-x86_64-20200603.cgz'
	export bootloader_append='root=/dev/ram0
user=lkp
job=/lkp/jobs/scheduled/lkp-kbl-nuc1/kernel-selftests-x86-ucode=0xde-debian-10.4-x86_64-20200603.cgz-95e381b6095d0808a64ecbe36515cca2ea2df477-20211109-53471-fhz5q7-3.yaml
ARCH=x86_64
kconfig=x86_64-rhel-8.3-kselftests
branch=linux-review/Kuniyuki-Iwashima/af_unix-Replace-unix_table_lock-with-per-hash-locks/20211106-172208
commit=95e381b6095d0808a64ecbe36515cca2ea2df477
BOOT_IMAGE=/pkg/linux/x86_64-rhel-8.3-kselftests/gcc-9/95e381b6095d0808a64ecbe36515cca2ea2df477/vmlinuz-5.15.0-rc7-02477-g95e381b6095d
erst_disable
max_uptime=2100
RESULT_ROOT=/result/kernel-selftests/x86-ucode=0xde/lkp-kbl-nuc1/debian-10.4-x86_64-20200603.cgz/x86_64-rhel-8.3-kselftests/gcc-9/95e381b6095d0808a64ecbe36515cca2ea2df477/3
LKP_SERVER=internal-lkp-server
nokaslr
selinux=0
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
rw'
	export modules_initrd='/pkg/linux/x86_64-rhel-8.3-kselftests/gcc-9/95e381b6095d0808a64ecbe36515cca2ea2df477/modules.cgz'
	export linux_headers_initrd='/pkg/linux/x86_64-rhel-8.3-kselftests/gcc-9/95e381b6095d0808a64ecbe36515cca2ea2df477/linux-headers.cgz'
	export linux_selftests_initrd='/pkg/linux/x86_64-rhel-8.3-kselftests/gcc-9/95e381b6095d0808a64ecbe36515cca2ea2df477/linux-selftests.cgz'
	export bm_initrd='/osimage/deps/debian-10.4-x86_64-20200603.cgz/run-ipconfig_20200608.cgz,/osimage/deps/debian-10.4-x86_64-20200603.cgz/lkp_20210707.cgz,/osimage/deps/debian-10.4-x86_64-20200603.cgz/rsync-rootfs_20200608.cgz,/osimage/deps/debian-10.4-x86_64-20200603.cgz/kernel-selftests_20210920.cgz,/osimage/pkg/debian-10.4-x86_64-20200603.cgz/kernel-selftests-x86_64-c8c9111a-1_20210929.cgz,/osimage/deps/debian-10.4-x86_64-20200603.cgz/hw_20200715.cgz'
	export ucode_initrd='/osimage/ucode/intel-ucode-20210222.cgz'
	export lkp_initrd='/osimage/user/lkp/lkp-x86_64.cgz'
	export site='inn'
	export LKP_CGI_PORT=80
	export LKP_CIFS_PORT=139
	export last_kernel='4.20.0'
	export repeat_to=6
	export schedule_notify_address=
	export queue_at_least_once=1
	export kernel='/pkg/linux/x86_64-rhel-8.3-kselftests/gcc-9/95e381b6095d0808a64ecbe36515cca2ea2df477/vmlinuz-5.15.0-rc7-02477-g95e381b6095d'
	export dequeue_time='2021-11-09 17:18:14 +0800'
	export job_initrd='/lkp/jobs/scheduled/lkp-kbl-nuc1/kernel-selftests-x86-ucode=0xde-debian-10.4-x86_64-20200603.cgz-95e381b6095d0808a64ecbe36515cca2ea2df477-20211109-53471-fhz5q7-3.cgz'

	[ -n "$LKP_SRC" ] ||
	export LKP_SRC=/lkp/${user:-lkp}/src
}

run_job()
{
	echo $$ > $TMP/run-job.pid

	. $LKP_SRC/lib/http.sh
	. $LKP_SRC/lib/job.sh
	. $LKP_SRC/lib/env.sh

	export_top_env

	run_monitor $LKP_SRC/monitors/wrapper kmsg
	run_monitor $LKP_SRC/monitors/wrapper heartbeat
	run_monitor $LKP_SRC/monitors/wrapper meminfo
	run_monitor $LKP_SRC/monitors/wrapper oom-killer
	run_monitor $LKP_SRC/monitors/plain/watchdog

	run_test group='x86' $LKP_SRC/tests/wrapper kernel-selftests
}

extract_stats()
{
	export stats_part_begin=
	export stats_part_end=

	env group='x86' $LKP_SRC/stats/wrapper kernel-selftests
	$LKP_SRC/stats/wrapper kmsg
	$LKP_SRC/stats/wrapper meminfo

	$LKP_SRC/stats/wrapper time kernel-selftests.time
	$LKP_SRC/stats/wrapper dmesg
	$LKP_SRC/stats/wrapper kmsg
	$LKP_SRC/stats/wrapper last_state
	$LKP_SRC/stats/wrapper stderr
	$LKP_SRC/stats/wrapper time
}

"$@"

--jho1yZJdad60DJr+
Content-Type: application/x-xz
Content-Disposition: attachment; filename="kmsg.xz"
Content-Transfer-Encoding: base64

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
AARZWg==

--jho1yZJdad60DJr+
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=kernel-selftests

KERNEL SELFTESTS: linux_headers_dir is /usr/src/linux-headers-x86_64-rhel-8.3-kselftests-95e381b6095d0808a64ecbe36515cca2ea2df477
2021-11-09 09:19:39 ln -sf /usr/bin/clang
2021-11-09 09:19:39 ln -sf /usr/bin/llc
2021-11-09 09:19:39 sed -i s/default_timeout=45/default_timeout=1200/ kselftest/runner.sh
2021-11-09 09:19:39 make -C x86
make: Entering directory '/usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-95e381b6095d0808a64ecbe36515cca2ea2df477/tools/testing/selftests/x86'
gcc -m32 -o /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-95e381b6095d0808a64ecbe36515cca2ea2df477/tools/testing/selftests/x86/single_step_syscall_32 -O2 -g -std=gnu99 -pthread -Wall -no-pie -DCAN_BUILD_32 -DCAN_BUILD_64 single_step_syscall.c helpers.h -lrt -ldl -lm
gcc -m32 -o /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-95e381b6095d0808a64ecbe36515cca2ea2df477/tools/testing/selftests/x86/sysret_ss_attrs_32 -O2 -g -std=gnu99 -pthread -Wall -no-pie -DCAN_BUILD_32 -DCAN_BUILD_64 sysret_ss_attrs.c helpers.h -lrt -ldl -lm
gcc -m32 -o /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-95e381b6095d0808a64ecbe36515cca2ea2df477/tools/testing/selftests/x86/syscall_nt_32 -O2 -g -std=gnu99 -pthread -Wall -no-pie -DCAN_BUILD_32 -DCAN_BUILD_64 syscall_nt.c helpers.h -lrt -ldl -lm
gcc -m32 -o /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-95e381b6095d0808a64ecbe36515cca2ea2df477/tools/testing/selftests/x86/test_mremap_vdso_32 -O2 -g -std=gnu99 -pthread -Wall -no-pie -DCAN_BUILD_32 -DCAN_BUILD_64 test_mremap_vdso.c helpers.h -lrt -ldl -lm
gcc -m32 -o /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-95e381b6095d0808a64ecbe36515cca2ea2df477/tools/testing/selftests/x86/check_initial_reg_state_32 -O2 -g -std=gnu99 -pthread -Wall -no-pie -Wl,-ereal_start -static -DCAN_BUILD_32 -DCAN_BUILD_64 check_initial_reg_state.c helpers.h -lrt -ldl -lm
gcc -m32 -o /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-95e381b6095d0808a64ecbe36515cca2ea2df477/tools/testing/selftests/x86/sigreturn_32 -O2 -g -std=gnu99 -pthread -Wall -no-pie -DCAN_BUILD_32 -DCAN_BUILD_64 sigreturn.c helpers.h -lrt -ldl -lm
gcc -m32 -o /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-95e381b6095d0808a64ecbe36515cca2ea2df477/tools/testing/selftests/x86/iopl_32 -O2 -g -std=gnu99 -pthread -Wall -no-pie -DCAN_BUILD_32 -DCAN_BUILD_64 iopl.c helpers.h -lrt -ldl -lm
gcc -m32 -o /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-95e381b6095d0808a64ecbe36515cca2ea2df477/tools/testing/selftests/x86/ioperm_32 -O2 -g -std=gnu99 -pthread -Wall -no-pie -DCAN_BUILD_32 -DCAN_BUILD_64 ioperm.c helpers.h -lrt -ldl -lm
gcc -m32 -o /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-95e381b6095d0808a64ecbe36515cca2ea2df477/tools/testing/selftests/x86/test_vsyscall_32 -O2 -g -std=gnu99 -pthread -Wall -no-pie -DCAN_BUILD_32 -DCAN_BUILD_64 test_vsyscall.c helpers.h -lrt -ldl -lm
gcc -m32 -o /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-95e381b6095d0808a64ecbe36515cca2ea2df477/tools/testing/selftests/x86/mov_ss_trap_32 -O2 -g -std=gnu99 -pthread -Wall -no-pie -DCAN_BUILD_32 -DCAN_BUILD_64 mov_ss_trap.c helpers.h -lrt -ldl -lm
gcc -m32 -o /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-95e381b6095d0808a64ecbe36515cca2ea2df477/tools/testing/selftests/x86/syscall_arg_fault_32 -O2 -g -std=gnu99 -pthread -Wall -no-pie -DCAN_BUILD_32 -DCAN_BUILD_64 syscall_arg_fault.c helpers.h -lrt -ldl -lm
gcc -m32 -o /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-95e381b6095d0808a64ecbe36515cca2ea2df477/tools/testing/selftests/x86/fsgsbase_restore_32 -O2 -g -std=gnu99 -pthread -Wall -no-pie -DCAN_BUILD_32 -DCAN_BUILD_64 fsgsbase_restore.c helpers.h -lrt -ldl -lm
gcc -m32 -o /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-95e381b6095d0808a64ecbe36515cca2ea2df477/tools/testing/selftests/x86/sigaltstack_32 -O2 -g -std=gnu99 -pthread -Wall -no-pie -DCAN_BUILD_32 -DCAN_BUILD_64 sigaltstack.c helpers.h -lrt -ldl -lm
gcc -m32 -o /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-95e381b6095d0808a64ecbe36515cca2ea2df477/tools/testing/selftests/x86/entry_from_vm86_32 -O2 -g -std=gnu99 -pthread -Wall -no-pie -DCAN_BUILD_32 -DCAN_BUILD_64 entry_from_vm86.c helpers.h -lrt -ldl -lm
gcc -m32 -o /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-95e381b6095d0808a64ecbe36515cca2ea2df477/tools/testing/selftests/x86/test_syscall_vdso_32 -O2 -g -std=gnu99 -pthread -Wall -no-pie -DCAN_BUILD_32 -DCAN_BUILD_64 test_syscall_vdso.c helpers.h thunks_32.S -lrt -ldl -lm
gcc -m32 -o /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-95e381b6095d0808a64ecbe36515cca2ea2df477/tools/testing/selftests/x86/unwind_vdso_32 -O2 -g -std=gnu99 -pthread -Wall -no-pie -DCAN_BUILD_32 -DCAN_BUILD_64 unwind_vdso.c helpers.h -lrt -ldl -lm
gcc -m32 -o /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-95e381b6095d0808a64ecbe36515cca2ea2df477/tools/testing/selftests/x86/test_FCMOV_32 -O2 -g -std=gnu99 -pthread -Wall -no-pie -DCAN_BUILD_32 -DCAN_BUILD_64 test_FCMOV.c helpers.h -lrt -ldl -lm
gcc -m32 -o /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-95e381b6095d0808a64ecbe36515cca2ea2df477/tools/testing/selftests/x86/test_FCOMI_32 -O2 -g -std=gnu99 -pthread -Wall -no-pie -DCAN_BUILD_32 -DCAN_BUILD_64 test_FCOMI.c helpers.h -lrt -ldl -lm
gcc -m32 -o /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-95e381b6095d0808a64ecbe36515cca2ea2df477/tools/testing/selftests/x86/test_FISTTP_32 -O2 -g -std=gnu99 -pthread -Wall -no-pie -DCAN_BUILD_32 -DCAN_BUILD_64 test_FISTTP.c helpers.h -lrt -ldl -lm
gcc -m32 -o /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-95e381b6095d0808a64ecbe36515cca2ea2df477/tools/testing/selftests/x86/vdso_restorer_32 -O2 -g -std=gnu99 -pthread -Wall -no-pie -DCAN_BUILD_32 -DCAN_BUILD_64 vdso_restorer.c helpers.h -lrt -ldl -lm
gcc -m32 -o /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-95e381b6095d0808a64ecbe36515cca2ea2df477/tools/testing/selftests/x86/ldt_gdt_32 -O2 -g -std=gnu99 -pthread -Wall -no-pie -DCAN_BUILD_32 -DCAN_BUILD_64 ldt_gdt.c helpers.h -lrt -ldl -lm
gcc -m32 -o /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-95e381b6095d0808a64ecbe36515cca2ea2df477/tools/testing/selftests/x86/ptrace_syscall_32 -O2 -g -std=gnu99 -pthread -Wall -no-pie -DCAN_BUILD_32 -DCAN_BUILD_64 ptrace_syscall.c helpers.h raw_syscall_helper_32.S -lrt -ldl -lm
gcc -m64 -o /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-95e381b6095d0808a64ecbe36515cca2ea2df477/tools/testing/selftests/x86/single_step_syscall_64 -O2 -g -std=gnu99 -pthread -Wall -no-pie -DCAN_BUILD_32 -DCAN_BUILD_64 single_step_syscall.c helpers.h -lrt -ldl
gcc -m64 -o /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-95e381b6095d0808a64ecbe36515cca2ea2df477/tools/testing/selftests/x86/sysret_ss_attrs_64 -O2 -g -std=gnu99 -pthread -Wall -no-pie -DCAN_BUILD_32 -DCAN_BUILD_64 sysret_ss_attrs.c helpers.h thunks.S -lrt -ldl
gcc -m64 -o /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-95e381b6095d0808a64ecbe36515cca2ea2df477/tools/testing/selftests/x86/syscall_nt_64 -O2 -g -std=gnu99 -pthread -Wall -no-pie -DCAN_BUILD_32 -DCAN_BUILD_64 syscall_nt.c helpers.h -lrt -ldl
gcc -m64 -o /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-95e381b6095d0808a64ecbe36515cca2ea2df477/tools/testing/selftests/x86/test_mremap_vdso_64 -O2 -g -std=gnu99 -pthread -Wall -no-pie -DCAN_BUILD_32 -DCAN_BUILD_64 test_mremap_vdso.c helpers.h -lrt -ldl
gcc -m64 -o /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-95e381b6095d0808a64ecbe36515cca2ea2df477/tools/testing/selftests/x86/check_initial_reg_state_64 -O2 -g -std=gnu99 -pthread -Wall -no-pie -Wl,-ereal_start -static -DCAN_BUILD_32 -DCAN_BUILD_64 check_initial_reg_state.c helpers.h -lrt -ldl
gcc -m64 -o /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-95e381b6095d0808a64ecbe36515cca2ea2df477/tools/testing/selftests/x86/sigreturn_64 -O2 -g -std=gnu99 -pthread -Wall -no-pie -DCAN_BUILD_32 -DCAN_BUILD_64 sigreturn.c helpers.h -lrt -ldl
gcc -m64 -o /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-95e381b6095d0808a64ecbe36515cca2ea2df477/tools/testing/selftests/x86/iopl_64 -O2 -g -std=gnu99 -pthread -Wall -no-pie -DCAN_BUILD_32 -DCAN_BUILD_64 iopl.c helpers.h -lrt -ldl
gcc -m64 -o /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-95e381b6095d0808a64ecbe36515cca2ea2df477/tools/testing/selftests/x86/ioperm_64 -O2 -g -std=gnu99 -pthread -Wall -no-pie -DCAN_BUILD_32 -DCAN_BUILD_64 ioperm.c helpers.h -lrt -ldl
gcc -m64 -o /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-95e381b6095d0808a64ecbe36515cca2ea2df477/tools/testing/selftests/x86/test_vsyscall_64 -O2 -g -std=gnu99 -pthread -Wall -no-pie -DCAN_BUILD_32 -DCAN_BUILD_64 test_vsyscall.c helpers.h -lrt -ldl
gcc -m64 -o /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-95e381b6095d0808a64ecbe36515cca2ea2df477/tools/testing/selftests/x86/mov_ss_trap_64 -O2 -g -std=gnu99 -pthread -Wall -no-pie -DCAN_BUILD_32 -DCAN_BUILD_64 mov_ss_trap.c helpers.h -lrt -ldl
gcc -m64 -o /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-95e381b6095d0808a64ecbe36515cca2ea2df477/tools/testing/selftests/x86/syscall_arg_fault_64 -O2 -g -std=gnu99 -pthread -Wall -no-pie -DCAN_BUILD_32 -DCAN_BUILD_64 syscall_arg_fault.c helpers.h -lrt -ldl
gcc -m64 -o /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-95e381b6095d0808a64ecbe36515cca2ea2df477/tools/testing/selftests/x86/fsgsbase_restore_64 -O2 -g -std=gnu99 -pthread -Wall -no-pie -DCAN_BUILD_32 -DCAN_BUILD_64 fsgsbase_restore.c helpers.h -lrt -ldl
gcc -m64 -o /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-95e381b6095d0808a64ecbe36515cca2ea2df477/tools/testing/selftests/x86/sigaltstack_64 -O2 -g -std=gnu99 -pthread -Wall -no-pie -DCAN_BUILD_32 -DCAN_BUILD_64 sigaltstack.c helpers.h -lrt -ldl
gcc -m64 -o /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-95e381b6095d0808a64ecbe36515cca2ea2df477/tools/testing/selftests/x86/fsgsbase_64 -O2 -g -std=gnu99 -pthread -Wall -no-pie -DCAN_BUILD_32 -DCAN_BUILD_64 fsgsbase.c helpers.h -lrt -ldl
gcc -m64 -o /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-95e381b6095d0808a64ecbe36515cca2ea2df477/tools/testing/selftests/x86/sysret_rip_64 -O2 -g -std=gnu99 -pthread -Wall -no-pie -DCAN_BUILD_32 -DCAN_BUILD_64 sysret_rip.c helpers.h -lrt -ldl
gcc -m64 -o /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-95e381b6095d0808a64ecbe36515cca2ea2df477/tools/testing/selftests/x86/syscall_numbering_64 -O2 -g -std=gnu99 -pthread -Wall -no-pie -DCAN_BUILD_32 -DCAN_BUILD_64 syscall_numbering.c helpers.h -lrt -ldl
gcc -m64 -o /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-95e381b6095d0808a64ecbe36515cca2ea2df477/tools/testing/selftests/x86/corrupt_xstate_header_64 -O2 -g -std=gnu99 -pthread -Wall -no-pie -DCAN_BUILD_32 -DCAN_BUILD_64 corrupt_xstate_header.c helpers.h -lrt -ldl
gcc -m64 -o /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-95e381b6095d0808a64ecbe36515cca2ea2df477/tools/testing/selftests/x86/ldt_gdt_64 -O2 -g -std=gnu99 -pthread -Wall -no-pie -DCAN_BUILD_32 -DCAN_BUILD_64 ldt_gdt.c helpers.h -lrt -ldl
gcc -m64 -o /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-95e381b6095d0808a64ecbe36515cca2ea2df477/tools/testing/selftests/x86/ptrace_syscall_64 -O2 -g -std=gnu99 -pthread -Wall -no-pie -DCAN_BUILD_32 -DCAN_BUILD_64 ptrace_syscall.c helpers.h -lrt -ldl
make: Leaving directory '/usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-95e381b6095d0808a64ecbe36515cca2ea2df477/tools/testing/selftests/x86'
2021-11-09 09:19:46 make run_tests -C x86
make: Entering directory '/usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-95e381b6095d0808a64ecbe36515cca2ea2df477/tools/testing/selftests/x86'
TAP version 13
1..41
# selftests: x86: single_step_syscall_32
# [RUN]	Set TF and check nop
# [OK]	Survived with TF set and 15 traps
# [RUN]	Set TF and check int80
# [OK]	Survived with TF set and 14 traps
# [RUN]	Set TF and check a fast syscall
# [OK]	Survived with TF set and 45 traps
# [RUN]	Fast syscall with TF cleared
# [OK]	Nothing unexpected happened
# [RUN]	Set TF and check SYSENTER
# 	Got SIGSEGV with RIP=f7fd2549, TF=256
# [RUN]	Fast syscall with TF cleared
# [OK]	Nothing unexpected happened
ok 1 selftests: x86: single_step_syscall_32
# selftests: x86: sysret_ss_attrs_32
# [RUN]	Syscalls followed by SS validation
# [OK]	We survived
ok 2 selftests: x86: sysret_ss_attrs_32
# selftests: x86: syscall_nt_32
# [RUN]	Set NT and issue a syscall
# [OK]	The syscall worked and flags are still set
# [RUN]	Set AC and issue a syscall
# [OK]	The syscall worked and flags are still set
# [RUN]	Set NT|AC and issue a syscall
# [OK]	The syscall worked and flags are still set
# [RUN]	Set TF and issue a syscall
# [OK]	The syscall worked and flags are still set
# [RUN]	Set NT|TF and issue a syscall
# [OK]	The syscall worked and flags are still set
# [RUN]	Set AC|TF and issue a syscall
# [OK]	The syscall worked and flags are still set
# [RUN]	Set NT|AC|TF and issue a syscall
# [OK]	The syscall worked and flags are still set
# [RUN]	Set DF and issue a syscall
# [OK]	The syscall worked and flags are still set
# [RUN]	Set TF|DF and issue a syscall
# [OK]	The syscall worked and flags are still set
ok 3 selftests: x86: syscall_nt_32
# selftests: x86: test_mremap_vdso_32
# 	AT_SYSINFO_EHDR is 0xf7fbe000
# [NOTE]	Moving vDSO: [0xf7fbe000, 0xf7fbf000] -> [0xf7fe7000, 0xf7fe8000]
# [NOTE]	vDSO partial move failed, will try with bigger size
# [NOTE]	Moving vDSO: [0xf7fbe000, 0xf7fc0000] -> [0xf7fb6000, 0xf7fb8000]
# [OK]
ok 4 selftests: x86: test_mremap_vdso_32
# selftests: x86: check_initial_reg_state_32
# [OK]	All GPRs except SP are 0
# [OK]	FLAGS is 0x202
ok 5 selftests: x86: check_initial_reg_state_32
# selftests: x86: sigreturn_32
# [OK]	set_thread_area refused 16-bit data
# [OK]	set_thread_area refused 16-bit data
# [RUN]	Valid sigreturn: 64-bit CS (33), 32-bit SS (2b, GDT)
# [OK]	all registers okay
# [RUN]	Valid sigreturn: 32-bit CS (23), 32-bit SS (2b, GDT)
# [OK]	all registers okay
# [RUN]	Valid sigreturn: 16-bit CS (37), 32-bit SS (2b, GDT)
# [OK]	all registers okay
# [RUN]	Valid sigreturn: 64-bit CS (33), 16-bit SS (3f)
# [OK]	all registers okay
# [RUN]	Valid sigreturn: 32-bit CS (23), 16-bit SS (3f)
# [OK]	all registers okay
# [RUN]	Valid sigreturn: 16-bit CS (37), 16-bit SS (3f)
# [OK]	all registers okay
# [RUN]	64-bit CS (33), bogus SS (47)
# [OK]	Got #GP(0x0) (i.e. Segmentation fault)
# [RUN]	32-bit CS (23), bogus SS (47)
# [OK]	Got #GP(0x0) (i.e. Segmentation fault)
# [RUN]	16-bit CS (37), bogus SS (47)
# [OK]	Got #GP(0x0) (i.e. Segmentation fault)
# [RUN]	64-bit CS (33), bogus SS (23)
# [OK]	Got #GP(0x20) (i.e. GDT index 4, Segmentation fault)
# [RUN]	32-bit CS (23), bogus SS (23)
# [OK]	Got #GP(0x20) (i.e. GDT index 4, Segmentation fault)
# [RUN]	16-bit CS (37), bogus SS (23)
# [OK]	Got #GP(0x20) (i.e. GDT index 4, Segmentation fault)
# [RUN]	32-bit CS (4f), bogus SS (2b)
# [OK]	Got #NP(0x4c) (i.e. LDT index 9, Bus error)
# [RUN]	32-bit CS (23), bogus SS (57)
# [OK]	Got #GP(0x0) (i.e. Segmentation fault)
ok 6 selftests: x86: sigreturn_32
# selftests: x86: iopl_32
# [OK]	CLI faulted
# [OK]	STI faulted
# [OK]	outb to 0x80 worked
# [OK]	outb to 0x80 worked
# [OK]	outb to 0xed failed
# 	child: set IOPL to 3
# [RUN]	child: write to 0x80
# [OK]	CLI faulted
# [OK]	STI faulted
# [OK]	outb to 0x80 worked
# [OK]	outb to 0x80 worked
# [OK]	outb to 0xed failed
# [OK]	Child succeeded
# [RUN]	parent: write to 0x80 (should fail)
# [OK]	outb to 0x80 failed
# [OK]	CLI faulted
# [OK]	STI faulted
# 	iopl(3)
# 	Drop privileges
# [RUN]	iopl(3) unprivileged but with IOPL==3
# [RUN]	iopl(0) unprivileged
# [RUN]	iopl(3) unprivileged
# [OK]	Failed as expected
ok 7 selftests: x86: iopl_32
# selftests: x86: ioperm_32
# [OK]	outb to 0x80 failed
# [OK]	outb to 0xed failed
# [RUN]	enable 0x80
# [OK]	outb to 0x80 worked
# [OK]	outb to 0xed failed
# [RUN]	disable 0x80
# [OK]	outb to 0x80 failed
# [OK]	outb to 0xed failed
# [RUN]	child: check that we inherited permissions
# [OK]	outb to 0x80 worked
# [OK]	outb to 0xed failed
# [RUN]	child: Extend permissions to 0x81
# [RUN]	child: Drop permissions to 0x80
# [OK]	outb to 0x80 failed
# [OK]	outb to 0x80 failed
# [OK]	outb to 0xed failed
# [RUN]	enable 0x80
# [OK]	outb to 0x80 worked
# [OK]	outb to 0xed failed
# [RUN]	disable 0x80
# [OK]	outb to 0x80 failed
# [OK]	outb to 0xed failed
# [OK]	Child succeeded
# 	Verify that unsharing the bitmap worked
# [OK]	outb to 0x80 worked
# 	Drop privileges
# [RUN]	disable 0x80
# [OK]	it worked
# [RUN]	enable 0x80 again
# [OK]	it failed
ok 8 selftests: x86: ioperm_32
# selftests: x86: test_vsyscall_32
# [NOTE]	failed to find getcpu in vDSO
# [RUN]	test gettimeofday()
# 	vDSO time offsets: 0.000017 0.000000
# [OK]	vDSO gettimeofday()'s timeval was okay
# [RUN]	test time()
# [OK]	vDSO time() is okay
# [RUN]	getcpu() on CPU 0
# [RUN]	getcpu() on CPU 1
ok 9 selftests: x86: test_vsyscall_32
# selftests: x86: mov_ss_trap_32
# 	SS = 0x2b, &SS = 0x0x804c11c
# 	PR_SET_PTRACER_ANY succeeded
# 	Set up a watchpoint
# 	DR0 = 804c11c, DR1 = 80493d6, DR7 = 7000a
# 	SS = 0x2b, &SS = 0x0x804c11c
# 	PR_SET_PTRACER_ANY succeeded
# 	Set up a watchpoint
# [RUN]	Read from watched memory (should get SIGTRAP)
# 	Got SIGTRAP with RIP=804922c, EFLAGS.RF=0
# [RUN]	MOV SS; INT3
# 	Got SIGTRAP with RIP=804923d, EFLAGS.RF=0
# [RUN]	MOV SS; INT 3
# 	Got SIGTRAP with RIP=804924f, EFLAGS.RF=0
# [RUN]	MOV SS; CS CS INT3
# 	Got SIGTRAP with RIP=8049262, EFLAGS.RF=0
# [RUN]	MOV SS; CSx14 INT3
# 	Got SIGTRAP with RIP=8049281, EFLAGS.RF=0
# [RUN]	MOV SS; INT 4
# 	Got SIGSEGV with RIP=80492ab
# [RUN]	MOV SS; INTO
# 	Got SIGTRAP with RIP=80492db, EFLAGS.RF=0
# [RUN]	MOV SS; ICEBP
# 	Got SIGTRAP with RIP=8049326, EFLAGS.RF=0
# [RUN]	MOV SS; CLI
# 	Got SIGSEGV with RIP=8049659
# [RUN]	MOV SS; #PF
# 	Got SIGSEGV with RIP=804961b
# [RUN]	MOV SS; INT 1
# 	Got SIGSEGV with RIP=80493b6
# [RUN]	MOV SS; breakpointed NOP
# 	Got SIGTRAP with RIP=80493d7, EFLAGS.RF=0
# [RUN]	MOV SS; SYSENTER
# 	Got SIGSEGV with RIP=f7f10549
# [RUN]	MOV SS; INT $0x80
# [OK]	I aten't dead
ok 10 selftests: x86: mov_ss_trap_32
# selftests: x86: syscall_arg_fault_32
# [RUN]	SYSENTER with invalid state
# [OK]	Seems okay
# [RUN]	SYSCALL with invalid state
# [SKIP]	Illegal instruction
# [RUN]	SYSENTER with TF and invalid state
# [OK]	Seems okay
# [RUN]	SYSCALL with TF and invalid state
# [SKIP]	Illegal instruction
ok 11 selftests: x86: syscall_arg_fault_32
# selftests: x86: fsgsbase_restore_32
# 	Setting up a segment
# 	segment base address = 0xf7fa3000
# 	using LDT slot 0
# [OK]	The segment points to the right place.
# 	Tracee will take a nap until signaled
# 	Tracee: in tracee_zap_segment()
# 	Tracee is going back to sleep
# 	Tracee was resumed.  Will re-check segment.
# [OK]	The segment points to the right place.
# 	Setting up a segment
# 	segment base address = 0xf7fa3000
# 	using LDT slot 0
# [OK]	The segment points to the right place.
# 	Child FS=0x7
# 	Tracer: redirecting tracee to tracee_zap_segment()
# 	Tracer: restoring tracee state
# [OK]	All is well.
ok 12 selftests: x86: fsgsbase_restore_32
# selftests: x86: sigaltstack_32
# [RUN]	Test an alternate signal stack of sufficient size.
# 	Raise SIGALRM. It is expected to be delivered.
# [OK]	SIGALRM signal delivered.
ok 13 selftests: x86: sigaltstack_32
# selftests: x86: entry_from_vm86_32
# [RUN]	#BR from vm86 mode
# [SKIP]	vm86 not supported
# [RUN]	SYSENTER from vm86 mode
# [SKIP]	vm86 not supported
# [RUN]	SYSCALL from vm86 mode
# [SKIP]	vm86 not supported
# [RUN]	STI with VIP set from vm86 mode
# [SKIP]	vm86 not supported
# [RUN]	POPF with VIP set and IF clear from vm86 mode
# [SKIP]	vm86 not supported
# [RUN]	POPF with VIP and IF set from vm86 mode
# [SKIP]	vm86 not supported
# [RUN]	POPF with VIP clear and IF set from vm86 mode
# [SKIP]	vm86 not supported
# [RUN]	INT3 from vm86 mode
# [SKIP]	vm86 not supported
# [RUN]	int80 from vm86 mode
# [SKIP]	vm86 not supported
# [RUN]	UMIP tests from vm86 mode
# [SKIP]	vm86 not supported
# [INFO]	Result from SMSW:[0x0000]
# [INFO]	Result from SIDT: limit[0x0000]base[0x00000000]
# [INFO]	Result from SGDT: limit[0x0000]base[0x00000000]
# [PASS]	All the results from SMSW are identical.
# [PASS]	All the results from SGDT are identical.
# [PASS]	All the results from SIDT are identical.
# [RUN]	STR instruction from vm86 mode
# [SKIP]	vm86 not supported
# [RUN]	SLDT instruction from vm86 mode
# [SKIP]	vm86 not supported
# [RUN]	Execute null pointer from vm86 mode
# [SKIP]	vm86 not supported
# [RUN]	#BR from vm86 mode
# [SKIP]	vm86 not supported
# [RUN]	SYSENTER from vm86 mode
# [SKIP]	vm86 not supported
# [RUN]	SYSCALL from vm86 mode
# [SKIP]	vm86 not supported
# [RUN]	STI with VIP set from vm86 mode
# [SKIP]	vm86 not supported
# [RUN]	POPF with VIP set and IF clear from vm86 mode
# [SKIP]	vm86 not supported
# [RUN]	POPF with VIP and IF set from vm86 mode
# [SKIP]	vm86 not supported
# [RUN]	POPF with VIP clear and IF set from vm86 mode
# [SKIP]	vm86 not supported
# [RUN]	INT3 from vm86 mode
# [SKIP]	vm86 not supported
# [RUN]	int80 from vm86 mode
# [SKIP]	vm86 not supported
# [RUN]	UMIP tests from vm86 mode
# [SKIP]	vm86 not supported
# [INFO]	Result from SMSW:[0x0000]
# [INFO]	Result from SIDT: limit[0x0000]base[0x00000000]
# [INFO]	Result from SGDT: limit[0x0000]base[0x00000000]
# [PASS]	All the results from SMSW are identical.
# [PASS]	All the results from SGDT are identical.
# [PASS]	All the results from SIDT are identical.
# [RUN]	STR instruction from vm86 mode
# [SKIP]	vm86 not supported
# [RUN]	SLDT instruction from vm86 mode
# [SKIP]	vm86 not supported
# [RUN]	Execute null pointer from vm86 mode
# [SKIP]	vm86 not supported
ok 14 selftests: x86: entry_from_vm86_32
# selftests: x86: test_syscall_vdso_32
# [RUN]	Executing 6-argument 32-bit syscall via VDSO
# [WARN]	Flags before=0000000000200ed7 id 0 00 o d i s z 0 a 0 p 1 c
# [WARN]	Flags  after=0000000000200682 id 0 00 d i s 0 0 1 
# [WARN]	Flags change=0000000000000855 0 00 o z 0 a 0 p 0 c
# [OK]	Arguments are preserved across syscall
# [NOTE]	R11 has changed:0000000000200682 - assuming clobbered by SYSRET insn
# [OK]	R8..R15 did not leak kernel data
# [RUN]	Executing 6-argument 32-bit syscall via INT 80
# [OK]	Arguments are preserved across syscall
# [OK]	R8..R15 did not leak kernel data
# [RUN]	Executing 6-argument 32-bit syscall via VDSO
# [WARN]	Flags before=0000000000200ed7 id 0 00 o d i s z 0 a 0 p 1 c
# [WARN]	Flags  after=0000000000200686 id 0 00 d i s 0 0 p 1 
# [WARN]	Flags change=0000000000000851 0 00 o z 0 a 0 0 c
# [OK]	Arguments are preserved across syscall
# [NOTE]	R11 has changed:0000000000200686 - assuming clobbered by SYSRET insn
# [OK]	R8..R15 did not leak kernel data
# [RUN]	Executing 6-argument 32-bit syscall via INT 80
# [OK]	Arguments are preserved across syscall
# [OK]	R8..R15 did not leak kernel data
# [RUN]	Running tests under ptrace
ok 15 selftests: x86: test_syscall_vdso_32
# selftests: x86: unwind_vdso_32
# 	AT_SYSINFO is 0xf7fcd540
# [OK]	AT_SYSINFO maps to linux-gate.so.1, loaded at 0x0xf7fcd000
# [RUN]	Set TF and check a fast syscall
# 	In vsyscall at 0xf7fcd540, returning to 0xf7db6687
# 	SIGTRAP at 0xf7fcd540
# 	  0xf7fcd540
# 	  0xf7db6687
# [OK]	  NR = 20, args = 1, 2, 3, 4, 5, 6
# 	SIGTRAP at 0xf7fcd541
# 	  0xf7fcd541
# 	  0xf7db6687
# [OK]	  NR = 20, args = 1, 2, 3, 4, 5, 6
# 	SIGTRAP at 0xf7fcd542
# 	  0xf7fcd542
# 	  0xf7db6687
# [OK]	  NR = 20, args = 1, 2, 3, 4, 5, 6
# 	SIGTRAP at 0xf7fcd543
# 	  0xf7fcd543
# 	  0xf7db6687
# [OK]	  NR = 20, args = 1, 2, 3, 4, 5, 6
# 	SIGTRAP at 0xf7fcd545
# 	  0xf7fcd545
# 	  0xf7db6687
# [OK]	  NR = 20, args = 1, 2, 3, 4, 5, 6
# 	SIGTRAP at 0xf7fcd54a
# 	  0xf7fcd54a
# 	  0xf7db6687
# [OK]	  NR = 1646, args = 1, 2, 3, 4, 5, 6
# 	SIGTRAP at 0xf7fcd54b
# 	  0xf7fcd54b
# 	  0xf7db6687
# [OK]	  NR = 1646, args = 1, 2, 3, 4, 5, 6
# 	SIGTRAP at 0xf7fcd54c
# 	  0xf7fcd54c
# 	  0xf7db6687
# [OK]	  NR = 1646, args = 1, 2, 3, 4, 5, 6
# 	Vsyscall is done
# [OK]	All is well
ok 16 selftests: x86: unwind_vdso_32
# selftests: x86: test_FCMOV_32
# [RUN]	Testing fcmovCC instructions
# [OK]	fcmovCC
ok 17 selftests: x86: test_FCMOV_32
# selftests: x86: test_FCOMI_32
# [RUN]	Testing f[u]comi[p] instructions
# [OK]	f[u]comi[p]
ok 18 selftests: x86: test_FCOMI_32
# selftests: x86: test_FISTTP_32
# [RUN]	Testing fisttp instructions
# [OK]	fisttp
ok 19 selftests: x86: test_FISTTP_32
# selftests: x86: vdso_restorer_32
# [RUN]	Raise a signal, SA_SIGINFO, sa.restorer == NULL
# [OK]	SA_SIGINFO handler returned successfully
# [RUN]	Raise a signal, !SA_SIGINFO, sa.restorer == NULL
# [OK]	!SA_SIGINFO handler returned successfully
ok 20 selftests: x86: vdso_restorer_32
# selftests: x86: ldt_gdt_32
# [NOTE]	set_thread_area is available; will use GDT index 13
# [OK]	LDT entry 0 has AR 0x0040FB00 and limit 0x0000000A
# [OK]	LDT entry 0 has AR 0x00C0FB00 and limit 0x0000AFFF
# [OK]	LDT entry 1 is invalid
# [OK]	LDT entry 2 has AR 0x00C0FB00 and limit 0x0000AFFF
# [OK]	LDT entry 1 is invalid
# [OK]	LDT entry 2 has AR 0x00C0FB00 and limit 0x0000AFFF
# [OK]	LDT entry 2 has AR 0x00D0FB00 and limit 0x0000AFFF
# [OK]	LDT entry 2 has AR 0x00D07B00 and limit 0x0000AFFF
# [OK]	LDT entry 2 has AR 0x00907B00 and limit 0x0000AFFF
# [OK]	LDT entry 2 has AR 0x00D07300 and limit 0x0000AFFF
# [OK]	LDT entry 2 has AR 0x00D07100 and limit 0x0000AFFF
# [OK]	LDT entry 2 has AR 0x00D07500 and limit 0x0000AFFF
# [OK]	LDT entry 2 has AR 0x00507700 and limit 0x0000000A
# [OK]	LDT entry 2 has AR 0x00507F00 and limit 0x0000000A
# [OK]	LDT entry 2 has AR 0x00507D00 and limit 0x0000000A
# [OK]	LDT entry 2 has AR 0x00507B00 and limit 0x0000000A
# [OK]	LDT entry 2 has AR 0x00507900 and limit 0x0000000A
# [RUN]	Test fork
# [OK]	LDT entry 2 has AR 0x00507900 and limit 0x0000000A
# [OK]	LDT entry 1 is invalid
# [OK]	LDT entry 0 is invalid
# [NOTE]	set_thread_area is available; will use GDT index 13
# [OK]	LDT entry 0 has AR 0x0040FB00 and limit 0x0000000A
# [OK]	LDT entry 0 has AR 0x00C0FB00 and limit 0x0000AFFF
# [OK]	LDT entry 1 is invalid
# [OK]	LDT entry 2 has AR 0x00C0FB00 and limit 0x0000AFFF
# [OK]	LDT entry 1 is invalid
# [OK]	LDT entry 2 has AR 0x00C0FB00 and limit 0x0000AFFF
# [OK]	LDT entry 2 has AR 0x00D0FB00 and limit 0x0000AFFF
# [OK]	LDT entry 2 has AR 0x00D07B00 and limit 0x0000AFFF
# [OK]	LDT entry 2 has AR 0x00907B00 and limit 0x0000AFFF
# [OK]	LDT entry 2 has AR 0x00D07300 and limit 0x0000AFFF
# [OK]	LDT entry 2 has AR 0x00D07100 and limit 0x0000AFFF
# [OK]	LDT entry 2 has AR 0x00D07500 and limit 0x0000AFFF
# [OK]	LDT entry 2 has AR 0x00507700 and limit 0x0000000A
# [OK]	LDT entry 2 has AR 0x00507F00 and limit 0x0000000A
# [OK]	LDT entry 2 has AR 0x00507D00 and limit 0x0000000A
# [OK]	LDT entry 2 has AR 0x00507B00 and limit 0x0000000A
# [OK]	LDT entry 2 has AR 0x00507900 and limit 0x0000000A
# [RUN]	Test fork
# [OK]	Child succeeded
# [RUN]	Test size
# [DONE]	Size test
# [OK]	modify_ldt failure 22
# [OK]	LDT entry 0 has AR 0x0000F300 and limit 0x00000000
# [OK]	LDT entry 0 has AR 0x00007300 and limit 0x00000000
# [OK]	LDT entry 0 has AR 0x0000F100 and limit 0x00000000
# [OK]	LDT entry 0 has AR 0x00007300 and limit 0x00000000
# [OK]	LDT entry 0 has AR 0x00007100 and limit 0x00000001
# [OK]	LDT entry 0 has AR 0x00007100 and limit 0x00000000
# [OK]	LDT entry 0 is invalid
# [OK]	LDT entry 0 has AR 0x0040F300 and limit 0x000FFFFF
# [OK]	GDT entry 13 has AR 0x0040F300 and limit 0x000FFFFF
# [OK]	LDT entry 0 has AR 0x00C0F300 and limit 0xFFFFFFFF
# [OK]	GDT entry 13 has AR 0x00C0F300 and limit 0xFFFFFFFF
# [OK]	LDT entry 0 has AR 0x00C0F100 and limit 0xFFFFFFFF
# [OK]	GDT entry 13 has AR 0x00C0F100 and limit 0xFFFFFFFF
# [OK]	LDT entry 0 has AR 0x00C0F700 and limit 0xFFFFFFFF
# [OK]	GDT entry 13 has AR 0x00C0F700 and limit 0xFFFFFFFF
# [OK]	LDT entry 0 has AR 0x00C0F500 and limit 0xFFFFFFFF
# [OK]	GDT entry 13 has AR 0x00C0F500 and limit 0xFFFFFFFF
# [OK]	LDT entry 0 is invalid
# [RUN]	Cross-CPU LDT invalidation
# [OK]	All 5 iterations succeeded
# [RUN]	Test exec
# [OK]	LDT entry 0 has AR 0x0040FB00 and limit 0x0000002A
# [OK]	Child succeeded
# [OK]	Invalidate DS with set_thread_area: new DS = 0x0
# [OK]	Invalidate ES with set_thread_area: new ES = 0x0
# [OK]	Invalidate FS with set_thread_area: new FS = 0x0
# [OK]	Invalidate GS with set_thread_area: new GS = 0x0
ok 21 selftests: x86: ldt_gdt_32
# selftests: x86: ptrace_syscall_32
# [RUN]	Check int80 return regs
# [OK]	getpid() preserves regs
# [OK]	kill(getpid(), SIGUSR1) preserves regs
# [RUN]	Check AT_SYSINFO return regs
# [OK]	getpid() preserves regs
# [OK]	kill(getpid(), SIGUSR1) preserves regs
# [RUN]	ptrace-induced syscall restart
# [RUN]	SYSEMU
# [OK]	Initial nr and args are correct
# [RUN]	Restart the syscall (ip = 0xf7efe549)
# [OK]	Restarted nr and args are correct
# [RUN]	Change nr and args and restart the syscall (ip = 0xf7efe549)
# [OK]	Replacement nr and args are correct
# [OK]	Child exited cleanly
# [RUN]	kernel syscall restart under ptrace
# [RUN]	SYSCALL
# [OK]	Initial nr and args are correct
# [RUN]	SYSCALL
# [OK]	Args after SIGUSR1 are correct (ax = -514)
# [OK]	Child got SIGUSR1
# [RUN]	Step again
# [OK]	pause(2) restarted correctly
ok 22 selftests: x86: ptrace_syscall_32
# selftests: x86: single_step_syscall_64
# [RUN]	Set TF and check nop
# [OK]	Survived with TF set and 10 traps
# [RUN]	Set TF and check syscall-less opportunistic sysret
# [OK]	Survived with TF set and 12 traps
# [RUN]	Set TF and check int80
# [OK]	Survived with TF set and 9 traps
# [RUN]	Set TF and check a fast syscall
# [OK]	Survived with TF set and 22 traps
# [RUN]	Fast syscall with TF cleared
# [OK]	Nothing unexpected happened
# [RUN]	Set TF and check SYSENTER
# 	Got SIGSEGV with RIP=d81c0549, TF=256
# [RUN]	Fast syscall with TF cleared
# [OK]	Nothing unexpected happened
ok 23 selftests: x86: single_step_syscall_64
# selftests: x86: sysret_ss_attrs_64
# [RUN]	Syscalls followed by SS validation
# [OK]	We survived
ok 24 selftests: x86: sysret_ss_attrs_64
# selftests: x86: syscall_nt_64
# [RUN]	Set NT and issue a syscall
# [OK]	The syscall worked and flags are still set
# [RUN]	Set AC and issue a syscall
# [OK]	The syscall worked and flags are still set
# [RUN]	Set NT|AC and issue a syscall
# [OK]	The syscall worked and flags are still set
# [RUN]	Set TF and issue a syscall
# [OK]	The syscall worked and flags are still set
# [RUN]	Set NT|TF and issue a syscall
# [OK]	The syscall worked and flags are still set
# [RUN]	Set AC|TF and issue a syscall
# [OK]	The syscall worked and flags are still set
# [RUN]	Set NT|AC|TF and issue a syscall
# [OK]	The syscall worked and flags are still set
# [RUN]	Set DF and issue a syscall
# [OK]	The syscall worked and flags are still set
# [RUN]	Set TF|DF and issue a syscall
# [OK]	The syscall worked and flags are still set
ok 25 selftests: x86: syscall_nt_64
# selftests: x86: test_mremap_vdso_64
# 	AT_SYSINFO_EHDR is 0x7ffd16bcc000
# [NOTE]	Moving vDSO: [0x7ffd16bcc000, 0x7ffd16bcd000] -> [0x7f4193765000, 0x7f4193766000]
# [NOTE]	vDSO partial move failed, will try with bigger size
# [NOTE]	Moving vDSO: [0x7ffd16bcc000, 0x7ffd16bce000] -> [0x7f4193764000, 0x7f4193766000]
# [OK]
ok 26 selftests: x86: test_mremap_vdso_64
# selftests: x86: check_initial_reg_state_64
# [OK]	All GPRs except SP are 0
# [OK]	FLAGS is 0x202
ok 27 selftests: x86: check_initial_reg_state_64
# selftests: x86: sigreturn_64
# [OK]	set_thread_area refused 16-bit data
# [OK]	set_thread_area refused 16-bit data
# [RUN]	Valid sigreturn: 64-bit CS (33), 32-bit SS (2b, GDT)
# [OK]	all registers okay
# [RUN]	Valid sigreturn: 32-bit CS (23), 32-bit SS (2b, GDT)
# [NOTE]	SP: 8badf00d5aadc0de -> 5aadc0de
# [OK]	all registers okay
# [RUN]	Valid sigreturn: 16-bit CS (37), 32-bit SS (2b, GDT)
# [NOTE]	SP: 8badf00d5aadc0de -> 5aadc0de
# [OK]	all registers okay
# [RUN]	Valid sigreturn: 64-bit CS (33), 16-bit SS (3f)
# [OK]	all registers okay
# [RUN]	Valid sigreturn: 32-bit CS (23), 16-bit SS (3f)
# [NOTE]	SP: 8badf00d5aadc0de -> 5aadc0de
# [OK]	all registers okay
# [RUN]	Valid sigreturn: 16-bit CS (37), 16-bit SS (3f)
# [NOTE]	SP: 8badf00d5aadc0de -> 5aadc0de
# [OK]	all registers okay
# [RUN]	Valid sigreturn: 32-bit CS (23), 32-bit SS (2b, GDT)
# 	Corrupting SS on return to 64-bit mode
# [NOTE]	SP: 8badf00d5aadc0de -> 5aadc0de
# [OK]	all registers okay
# [RUN]	Valid sigreturn: 32-bit CS (23), 16-bit SS (3f)
# 	Corrupting SS on return to 64-bit mode
# [NOTE]	SP: 8badf00d5aadc0de -> 5aadc0de
# [OK]	all registers okay
# [RUN]	64-bit CS (33), bogus SS (47)
# [OK]	Got #GP(0x0) (i.e. Segmentation fault)
# [RUN]	32-bit CS (23), bogus SS (47)
# [OK]	Got #GP(0x0) (i.e. Segmentation fault)
# [RUN]	16-bit CS (37), bogus SS (47)
# [OK]	Got #GP(0x0) (i.e. Segmentation fault)
# [RUN]	64-bit CS (33), bogus SS (33)
# [OK]	Got #GP(0x30) (i.e. GDT index 6, Segmentation fault)
# [RUN]	32-bit CS (23), bogus SS (33)
# [OK]	Got #GP(0x30) (i.e. GDT index 6, Segmentation fault)
# [RUN]	16-bit CS (37), bogus SS (33)
# [OK]	Got #GP(0x30) (i.e. GDT index 6, Segmentation fault)
# [RUN]	32-bit CS (4f), bogus SS (2b)
# [OK]	Got #NP(0x4c) (i.e. LDT index 9, Bus error)
# [RUN]	32-bit CS (23), bogus SS (57)
# [OK]	Got #GP(0x0) (i.e. Segmentation fault)
# [RUN]	Clear UC_STRICT_RESTORE_SS and corrupt SS
# [OK]	It worked
ok 28 selftests: x86: sigreturn_64
# selftests: x86: iopl_64
# [OK]	CLI faulted
# [OK]	STI faulted
# [OK]	outb to 0x80 worked
# [OK]	outb to 0x80 worked
# [OK]	outb to 0xed failed
# 	child: set IOPL to 3
# [RUN]	child: write to 0x80
# [OK]	CLI faulted
# [OK]	STI faulted
# [OK]	outb to 0x80 worked
# [OK]	outb to 0x80 worked
# [OK]	outb to 0xed failed
# [OK]	Child succeeded
# [RUN]	parent: write to 0x80 (should fail)
# [OK]	outb to 0x80 failed
# [OK]	CLI faulted
# [OK]	STI faulted
# 	iopl(3)
# 	Drop privileges
# [RUN]	iopl(3) unprivileged but with IOPL==3
# [RUN]	iopl(0) unprivileged
# [RUN]	iopl(3) unprivileged
# [OK]	Failed as expected
ok 29 selftests: x86: iopl_64
# selftests: x86: ioperm_64
# [OK]	outb to 0x80 failed
# [OK]	outb to 0xed failed
# [RUN]	enable 0x80
# [OK]	outb to 0x80 worked
# [OK]	outb to 0xed failed
# [RUN]	disable 0x80
# [OK]	outb to 0x80 failed
# [OK]	outb to 0xed failed
# [RUN]	child: check that we inherited permissions
# [OK]	outb to 0x80 worked
# [OK]	outb to 0xed failed
# [RUN]	child: Extend permissions to 0x81
# [RUN]	child: Drop permissions to 0x80
# [OK]	outb to 0x80 failed
# [OK]	outb to 0x80 failed
# [OK]	outb to 0xed failed
# [RUN]	enable 0x80
# [OK]	outb to 0x80 worked
# [OK]	outb to 0xed failed
# [RUN]	disable 0x80
# [OK]	outb to 0x80 failed
# [OK]	outb to 0xed failed
# [OK]	Child succeeded
# 	Verify that unsharing the bitmap worked
# [OK]	outb to 0x80 worked
# 	Drop privileges
# [RUN]	disable 0x80
# [OK]	it worked
# [RUN]	enable 0x80 again
# [OK]	it failed
ok 30 selftests: x86: ioperm_64
# selftests: x86: test_vsyscall_64
# 	vsyscall map: ffffffffff600000-ffffffffff601000 r-xp 00000000 00:00 0                  [vsyscall]
# 	vsyscall permissions are r-x
# [RUN]	test gettimeofday()
# 	vDSO time offsets: 0.000013 0.000003
# [OK]	vDSO gettimeofday()'s timeval was okay
# 	vsyscall time offsets: 0.000015 0.000001
# [OK]	vsyscall gettimeofday()'s timeval was okay
# [RUN]	test time()
# [OK]	vDSO time() is okay
# [OK]	vsyscall time() is okay
# [RUN]	getcpu() on CPU 0
# [OK]	vDSO reported correct CPU
# [OK]	vDSO reported correct node
# [OK]	vsyscall reported correct CPU
# [OK]	vsyscall reported correct node
# [RUN]	getcpu() on CPU 1
# [OK]	vDSO reported correct CPU
# [OK]	vDSO reported correct node
# [OK]	vsyscall reported correct CPU
# [OK]	vsyscall reported correct node
# [RUN]	Checking read access to the vsyscall page
# [OK]	We have read access
# [RUN]	process_vm_readv() from vsyscall page
# [OK]	It worked and read correct data
# [RUN]	checking that vsyscalls are emulated
# [OK]	vsyscalls are emulated (1 instructions in vsyscall page)
ok 31 selftests: x86: test_vsyscall_64
# selftests: x86: mov_ss_trap_64
# 	SS = 0x2b, &SS = 0x0x4041a8
# 	PR_SET_PTRACER_ANY succeeded
# 	Set up a watchpoint
# 	DR0 = 4041a8, DR1 = 401358, DR7 = 7000a
# 	SS = 0x2b, &SS = 0x0x4041a8
# 	PR_SET_PTRACER_ANY succeeded
# 	Set up a watchpoint
# [RUN]	Read from watched memory (should get SIGTRAP)
# 	Got SIGTRAP with RIP=4011e8, EFLAGS.RF=0
# [RUN]	MOV SS; INT3
# 	Got SIGTRAP with RIP=4011fb, EFLAGS.RF=0
# [RUN]	MOV SS; INT 3
# 	Got SIGTRAP with RIP=40120f, EFLAGS.RF=0
# [RUN]	MOV SS; CS CS INT3
# 	Got SIGTRAP with RIP=401224, EFLAGS.RF=0
# [RUN]	MOV SS; CSx14 INT3
# 	Got SIGTRAP with RIP=401245, EFLAGS.RF=0
# [RUN]	MOV SS; INT 4
# 	Got SIGSEGV with RIP=40126f
# [RUN]	MOV SS; ICEBP
# 	Got SIGTRAP with RIP=4012ad, EFLAGS.RF=0
# [RUN]	MOV SS; CLI
# 	Got SIGSEGV with RIP=4015b9
# [RUN]	MOV SS; #PF
# 	Got SIGSEGV with RIP=401584
# [RUN]	MOV SS; INT 1
# 	Got SIGSEGV with RIP=401555
# [RUN]	MOV SS; SYSCALL
# [RUN]	MOV SS; breakpointed NOP
# 	Got SIGTRAP with RIP=401359, EFLAGS.RF=0
# [RUN]	MOV SS; SYSENTER
# 	Got SIGSEGV with RIP=ef10b549
# [RUN]	MOV SS; INT $0x80
# [OK]	I aten't dead
ok 32 selftests: x86: mov_ss_trap_64
# selftests: x86: syscall_arg_fault_64
# [RUN]	SYSENTER with invalid state
# [OK]	Seems okay
# [RUN]	SYSCALL with invalid state
# [OK]	SYSCALL returned normally
# [RUN]	SYSENTER with TF and invalid state
# [OK]	Seems okay
# [RUN]	SYSCALL with TF and invalid state
# [OK]	SYSCALL returned normally
# [RUN]	SYSENTER with TF, invalid state, and GSBASE < 0
# [OK]	Seems okay
ok 33 selftests: x86: syscall_arg_fault_64
# selftests: x86: fsgsbase_restore_64
# 	Setting up a segment
# 	segment base address = 0x41240000
# 	using LDT slot 0
# [OK]	The segment points to the right place.
# 	Tracee will take a nap until signaled
# 	Tracee: in tracee_zap_segment()
# 	Tracee is going back to sleep
# 	Tracee was resumed.  Will re-check segment.
# [OK]	The segment points to the right place.
# 	Setting up a segment
# 	segment base address = 0x41240000
# 	using LDT slot 0
# [OK]	The segment points to the right place.
# 	Child GS=0x7, GSBASE=0x41240000
# 	Tracer: redirecting tracee to tracee_zap_segment()
# 	Tracer: restoring tracee state
# [OK]	All is well.
ok 34 selftests: x86: fsgsbase_restore_64
# selftests: x86: sigaltstack_64
# [RUN]	Test an alternate signal stack of sufficient size.
# 	Raise SIGALRM. It is expected to be delivered.
# [OK]	SIGALRM signal delivered.
ok 35 selftests: x86: sigaltstack_64
# selftests: x86: fsgsbase_64
# [OK]	GSBASE started at 1
# [RUN]	Set GS = 0x7, read GSBASE
# [OK]	GSBASE reads as 0x1 with invalid GS
# 	FSGSBASE instructions are enabled
# [RUN]	ARCH_SET_GS to 0x0
# [OK]	GSBASE was set as expected (selector 0x0)
# [OK]	ARCH_GET_GS worked as expected (selector 0x0)
# [RUN]	ARCH_SET_GS to 0x1
# [OK]	GSBASE was set as expected (selector 0x0)
# [OK]	ARCH_GET_GS worked as expected (selector 0x0)
# [RUN]	ARCH_SET_GS to 0x200000000
# [OK]	GSBASE was set as expected (selector 0x0)
# [OK]	ARCH_GET_GS worked as expected (selector 0x0)
# [RUN]	ARCH_SET_GS to 0x0
# [OK]	GSBASE was set as expected (selector 0x0)
# [OK]	ARCH_GET_GS worked as expected (selector 0x0)
# [RUN]	ARCH_SET_GS to 0x200000000
# [OK]	GSBASE was set as expected (selector 0x0)
# [OK]	ARCH_GET_GS worked as expected (selector 0x0)
# [RUN]	ARCH_SET_GS to 0x1
# [OK]	GSBASE was set as expected (selector 0x0)
# [OK]	ARCH_GET_GS worked as expected (selector 0x0)
# [RUN]	ARCH_SET_GS to 0x0 then mov 0 to %gs
# [OK]	GSBASE is 0x0
# [RUN]	ARCH_SET_GS to 0x1 then mov 0 to %gs
# [OK]	GSBASE is 0x0
# [RUN]	ARCH_SET_GS to 0x200000000 then mov 0 to %gs
# [OK]	GSBASE is 0x0
# [RUN]	ARCH_SET_GS to 0x0 then mov 0 to %gs and schedule 
# [OK]	GSBASE is 0x0
# [RUN]	ARCH_SET_GS to 0x1 then mov 0 to %gs and schedule 
# [OK]	GSBASE is 0x0
# [RUN]	ARCH_SET_GS to 0x200000000 then mov 0 to %gs and schedule 
# [OK]	GSBASE is 0x0
# [RUN]	ARCH_SET_GS(0x0), then schedule to 0x0
# 	other thread: ARCH_SET_GS(0x0) -- sel is 0x0
# [OK]	GS/BASE remained 0x0/0x0
# [RUN]	ARCH_SET_GS(0x0), then schedule to 0x0
# 	Before schedule, set selector to 0x1
# 	other thread: ARCH_SET_GS(0x0) -- sel is 0x0
# [OK]	GS/BASE remained 0x1/0x0
# [RUN]	ARCH_SET_GS(0x0), then schedule to 0x0
# 	Before schedule, set selector to 0x2
# 	other thread: ARCH_SET_GS(0x0) -- sel is 0x0
# [OK]	GS/BASE remained 0x2/0x0
# [RUN]	ARCH_SET_GS(0x0), then schedule to 0x0
# 	Before schedule, set selector to 0x3
# 	other thread: ARCH_SET_GS(0x0) -- sel is 0x0
# [OK]	GS/BASE remained 0x3/0x0
# [RUN]	ARCH_SET_GS(0x0), then schedule to 0x0
# 	Before schedule, set selector to 0x2b
# 	other thread: ARCH_SET_GS(0x0) -- sel is 0x0
# [OK]	GS/BASE remained 0x2b/0x0
# [RUN]	ARCH_SET_GS(0x0), then schedule to 0xa1fa5f343cb85fa4
# 	other thread: ARCH_SET_GS(0x0) and clear gs -- sel is 0x0
# [OK]	GS/BASE remained 0x0/0x0
# [RUN]	ARCH_SET_GS(0x0), then schedule to 0xa1fa5f343cb85fa4
# 	Before schedule, set selector to 0x1
# 	other thread: ARCH_SET_GS(0x0) and clear gs -- sel is 0x0
# [OK]	GS/BASE remained 0x1/0x0
# [RUN]	ARCH_SET_GS(0x0), then schedule to 0xa1fa5f343cb85fa4
# 	Before schedule, set selector to 0x2
# 	other thread: ARCH_SET_GS(0x0) and clear gs -- sel is 0x0
# [OK]	GS/BASE remained 0x2/0x0
# [RUN]	ARCH_SET_GS(0x0), then schedule to 0xa1fa5f343cb85fa4
# 	Before schedule, set selector to 0x3
# 	other thread: ARCH_SET_GS(0x0) and clear gs -- sel is 0x0
# [OK]	GS/BASE remained 0x3/0x0
# [RUN]	ARCH_SET_GS(0x0), then schedule to 0xa1fa5f343cb85fa4
# 	Before schedule, set selector to 0x2b
# 	other thread: ARCH_SET_GS(0x0) and clear gs -- sel is 0x0
# [OK]	GS/BASE remained 0x2b/0x0
# [RUN]	ARCH_SET_GS(0x0), then schedule to 0x1
# 	other thread: ARCH_SET_GS(0x1) -- sel is 0x0
# [OK]	GS/BASE remained 0x0/0x0
# [RUN]	ARCH_SET_GS(0x0), then schedule to 0x1
# 	Before schedule, set selector to 0x1
# 	other thread: ARCH_SET_GS(0x1) -- sel is 0x0
# [OK]	GS/BASE remained 0x1/0x0
# [RUN]	ARCH_SET_GS(0x0), then schedule to 0x1
# 	Before schedule, set selector to 0x2
# 	other thread: ARCH_SET_GS(0x1) -- sel is 0x0
# [OK]	GS/BASE remained 0x2/0x0
# [RUN]	ARCH_SET_GS(0x0), then schedule to 0x1
# 	Before schedule, set selector to 0x3
# 	other thread: ARCH_SET_GS(0x1) -- sel is 0x0
# [OK]	GS/BASE remained 0x3/0x0
# [RUN]	ARCH_SET_GS(0x0), then schedule to 0x1
# 	Before schedule, set selector to 0x2b
# 	other thread: ARCH_SET_GS(0x1) -- sel is 0x0
# [OK]	GS/BASE remained 0x2b/0x0
# [RUN]	ARCH_SET_GS(0x0), then schedule to 0x200000000
# 	other thread: ARCH_SET_GS(0x200000000) -- sel is 0x0
# [OK]	GS/BASE remained 0x0/0x0
# [RUN]	ARCH_SET_GS(0x0), then schedule to 0x200000000
# 	Before schedule, set selector to 0x1
# 	other thread: ARCH_SET_GS(0x200000000) -- sel is 0x0
# [OK]	GS/BASE remained 0x1/0x0
# [RUN]	ARCH_SET_GS(0x0), then schedule to 0x200000000
# 	Before schedule, set selector to 0x2
# 	other thread: ARCH_SET_GS(0x200000000) -- sel is 0x0
# [OK]	GS/BASE remained 0x2/0x0
# [RUN]	ARCH_SET_GS(0x0), then schedule to 0x200000000
# 	Before schedule, set selector to 0x3
# 	other thread: ARCH_SET_GS(0x200000000) -- sel is 0x0
# [OK]	GS/BASE remained 0x3/0x0
# [RUN]	ARCH_SET_GS(0x0), then schedule to 0x200000000
# 	Before schedule, set selector to 0x2b
# 	other thread: ARCH_SET_GS(0x200000000) -- sel is 0x0
# [OK]	GS/BASE remained 0x2b/0x0
# [RUN]	ARCH_SET_GS(0x0) and clear gs, then schedule to 0x0
# 	other thread: ARCH_SET_GS(0x0) -- sel is 0x0
# [OK]	GS/BASE remained 0x0/0x0
# [RUN]	ARCH_SET_GS(0x0) and clear gs, then schedule to 0x0
# 	Before schedule, set selector to 0x1
# 	other thread: ARCH_SET_GS(0x0) -- sel is 0x0
# [OK]	GS/BASE remained 0x1/0x0
# [RUN]	ARCH_SET_GS(0x0) and clear gs, then schedule to 0x0
# 	Before schedule, set selector to 0x2
# 	other thread: ARCH_SET_GS(0x0) -- sel is 0x0
# [OK]	GS/BASE remained 0x2/0x0
# [RUN]	ARCH_SET_GS(0x0) and clear gs, then schedule to 0x0
# 	Before schedule, set selector to 0x3
# 	other thread: ARCH_SET_GS(0x0) -- sel is 0x0
# [OK]	GS/BASE remained 0x3/0x0
# [RUN]	ARCH_SET_GS(0x0) and clear gs, then schedule to 0x0
# 	Before schedule, set selector to 0x2b
# 	other thread: ARCH_SET_GS(0x0) -- sel is 0x0
# [OK]	GS/BASE remained 0x2b/0x0
# [RUN]	ARCH_SET_GS(0x0) and clear gs, then schedule to 0xa1fa5f343cb85fa4
# 	other thread: ARCH_SET_GS(0x0) and clear gs -- sel is 0x0
# [OK]	GS/BASE remained 0x0/0x0
# [RUN]	ARCH_SET_GS(0x0) and clear gs, then schedule to 0xa1fa5f343cb85fa4
# 	Before schedule, set selector to 0x1
# 	other thread: ARCH_SET_GS(0x0) and clear gs -- sel is 0x0
# [OK]	GS/BASE remained 0x1/0x0
# [RUN]	ARCH_SET_GS(0x0) and clear gs, then schedule to 0xa1fa5f343cb85fa4
# 	Before schedule, set selector to 0x2
# 	other thread: ARCH_SET_GS(0x0) and clear gs -- sel is 0x0
# [OK]	GS/BASE remained 0x2/0x0
# [RUN]	ARCH_SET_GS(0x0) and clear gs, then schedule to 0xa1fa5f343cb85fa4
# 	Before schedule, set selector to 0x3
# 	other thread: ARCH_SET_GS(0x0) and clear gs -- sel is 0x0
# [OK]	GS/BASE remained 0x3/0x0
# [RUN]	ARCH_SET_GS(0x0) and clear gs, then schedule to 0xa1fa5f343cb85fa4
# 	Before schedule, set selector to 0x2b
# 	other thread: ARCH_SET_GS(0x0) and clear gs -- sel is 0x0
# [OK]	GS/BASE remained 0x2b/0x0
# [RUN]	ARCH_SET_GS(0x0) and clear gs, then schedule to 0x1
# 	other thread: ARCH_SET_GS(0x1) -- sel is 0x0
# [OK]	GS/BASE remained 0x0/0x0
# [RUN]	ARCH_SET_GS(0x0) and clear gs, then schedule to 0x1
# 	Before schedule, set selector to 0x1
# 	other thread: ARCH_SET_GS(0x1) -- sel is 0x0
# [OK]	GS/BASE remained 0x1/0x0
# [RUN]	ARCH_SET_GS(0x0) and clear gs, then schedule to 0x1
# 	Before schedule, set selector to 0x2
# 	other thread: ARCH_SET_GS(0x1) -- sel is 0x0
# [OK]	GS/BASE remained 0x2/0x0
# [RUN]	ARCH_SET_GS(0x0) and clear gs, then schedule to 0x1
# 	Before schedule, set selector to 0x3
# 	other thread: ARCH_SET_GS(0x1) -- sel is 0x0
# [OK]	GS/BASE remained 0x3/0x0
# [RUN]	ARCH_SET_GS(0x0) and clear gs, then schedule to 0x1
# 	Before schedule, set selector to 0x2b
# 	other thread: ARCH_SET_GS(0x1) -- sel is 0x0
# [OK]	GS/BASE remained 0x2b/0x0
# [RUN]	ARCH_SET_GS(0x0) and clear gs, then schedule to 0x200000000
# 	other thread: ARCH_SET_GS(0x200000000) -- sel is 0x0
# [OK]	GS/BASE remained 0x0/0x0
# [RUN]	ARCH_SET_GS(0x0) and clear gs, then schedule to 0x200000000
# 	Before schedule, set selector to 0x1
# 	other thread: ARCH_SET_GS(0x200000000) -- sel is 0x0
# [OK]	GS/BASE remained 0x1/0x0
# [RUN]	ARCH_SET_GS(0x0) and clear gs, then schedule to 0x200000000
# 	Before schedule, set selector to 0x2
# 	other thread: ARCH_SET_GS(0x200000000) -- sel is 0x0
# [OK]	GS/BASE remained 0x2/0x0
# [RUN]	ARCH_SET_GS(0x0) and clear gs, then schedule to 0x200000000
# 	Before schedule, set selector to 0x3
# 	other thread: ARCH_SET_GS(0x200000000) -- sel is 0x0
# [OK]	GS/BASE remained 0x3/0x0
# [RUN]	ARCH_SET_GS(0x0) and clear gs, then schedule to 0x200000000
# 	Before schedule, set selector to 0x2b
# 	other thread: ARCH_SET_GS(0x200000000) -- sel is 0x0
# [OK]	GS/BASE remained 0x2b/0x0
# [RUN]	ARCH_SET_GS(0x1), then schedule to 0x0
# 	other thread: ARCH_SET_GS(0x0) -- sel is 0x0
# [OK]	GS/BASE remained 0x0/0x1
# [RUN]	ARCH_SET_GS(0x1), then schedule to 0x0
# 	Before schedule, set selector to 0x1
# 	other thread: ARCH_SET_GS(0x0) -- sel is 0x0
# [OK]	GS/BASE remained 0x1/0x0
# [RUN]	ARCH_SET_GS(0x1), then schedule to 0x0
# 	Before schedule, set selector to 0x2
# 	other thread: ARCH_SET_GS(0x0) -- sel is 0x0
# [OK]	GS/BASE remained 0x2/0x0
# [RUN]	ARCH_SET_GS(0x1), then schedule to 0x0
# 	Before schedule, set selector to 0x3
# 	other thread: ARCH_SET_GS(0x0) -- sel is 0x0
# [OK]	GS/BASE remained 0x3/0x0
# [RUN]	ARCH_SET_GS(0x1), then schedule to 0x0
# 	Before schedule, set selector to 0x2b
# 	other thread: ARCH_SET_GS(0x0) -- sel is 0x0
# [OK]	GS/BASE remained 0x2b/0x0
# [RUN]	ARCH_SET_GS(0x1), then schedule to 0xa1fa5f343cb85fa4
# 	other thread: ARCH_SET_GS(0x0) and clear gs -- sel is 0x0
# [OK]	GS/BASE remained 0x0/0x1
# [RUN]	ARCH_SET_GS(0x1), then schedule to 0xa1fa5f343cb85fa4
# 	Before schedule, set selector to 0x1
# 	other thread: ARCH_SET_GS(0x0) and clear gs -- sel is 0x0
# [OK]	GS/BASE remained 0x1/0x0
# [RUN]	ARCH_SET_GS(0x1), then schedule to 0xa1fa5f343cb85fa4
# 	Before schedule, set selector to 0x2
# 	other thread: ARCH_SET_GS(0x0) and clear gs -- sel is 0x0
# [OK]	GS/BASE remained 0x2/0x0
# [RUN]	ARCH_SET_GS(0x1), then schedule to 0xa1fa5f343cb85fa4
# 	Before schedule, set selector to 0x3
# 	other thread: ARCH_SET_GS(0x0) and clear gs -- sel is 0x0
# [OK]	GS/BASE remained 0x3/0x0
# [RUN]	ARCH_SET_GS(0x1), then schedule to 0xa1fa5f343cb85fa4
# 	Before schedule, set selector to 0x2b
# 	other thread: ARCH_SET_GS(0x0) and clear gs -- sel is 0x0
# [OK]	GS/BASE remained 0x2b/0x0
# [RUN]	ARCH_SET_GS(0x1), then schedule to 0x1
# 	other thread: ARCH_SET_GS(0x1) -- sel is 0x0
# [OK]	GS/BASE remained 0x0/0x1
# [RUN]	ARCH_SET_GS(0x1), then schedule to 0x1
# 	Before schedule, set selector to 0x1
# 	other thread: ARCH_SET_GS(0x1) -- sel is 0x0
# [OK]	GS/BASE remained 0x1/0x0
# [RUN]	ARCH_SET_GS(0x1), then schedule to 0x1
# 	Before schedule, set selector to 0x2
# 	other thread: ARCH_SET_GS(0x1) -- sel is 0x0
# [OK]	GS/BASE remained 0x2/0x0
# [RUN]	ARCH_SET_GS(0x1), then schedule to 0x1
# 	Before schedule, set selector to 0x3
# 	other thread: ARCH_SET_GS(0x1) -- sel is 0x0
# [OK]	GS/BASE remained 0x3/0x0
# [RUN]	ARCH_SET_GS(0x1), then schedule to 0x1
# 	Before schedule, set selector to 0x2b
# 	other thread: ARCH_SET_GS(0x1) -- sel is 0x0
# [OK]	GS/BASE remained 0x2b/0x0
# [RUN]	ARCH_SET_GS(0x1), then schedule to 0x200000000
# 	other thread: ARCH_SET_GS(0x200000000) -- sel is 0x0
# [OK]	GS/BASE remained 0x0/0x1
# [RUN]	ARCH_SET_GS(0x1), then schedule to 0x200000000
# 	Before schedule, set selector to 0x1
# 	other thread: ARCH_SET_GS(0x200000000) -- sel is 0x0
# [OK]	GS/BASE remained 0x1/0x0
# [RUN]	ARCH_SET_GS(0x1), then schedule to 0x200000000
# 	Before schedule, set selector to 0x2
# 	other thread: ARCH_SET_GS(0x200000000) -- sel is 0x0
# [OK]	GS/BASE remained 0x2/0x0
# [RUN]	ARCH_SET_GS(0x1), then schedule to 0x200000000
# 	Before schedule, set selector to 0x3
# 	other thread: ARCH_SET_GS(0x200000000) -- sel is 0x0
# [OK]	GS/BASE remained 0x3/0x0
# [RUN]	ARCH_SET_GS(0x1), then schedule to 0x200000000
# 	Before schedule, set selector to 0x2b
# 	other thread: ARCH_SET_GS(0x200000000) -- sel is 0x0
# [OK]	GS/BASE remained 0x2b/0x0
# [RUN]	ARCH_SET_GS(0x200000000), then schedule to 0x0
# 	other thread: ARCH_SET_GS(0x0) -- sel is 0x0
# [OK]	GS/BASE remained 0x0/0x200000000
# [RUN]	ARCH_SET_GS(0x200000000), then schedule to 0x0
# 	Before schedule, set selector to 0x1
# 	other thread: ARCH_SET_GS(0x0) -- sel is 0x0
# [OK]	GS/BASE remained 0x1/0x0
# [RUN]	ARCH_SET_GS(0x200000000), then schedule to 0x0
# 	Before schedule, set selector to 0x2
# 	other thread: ARCH_SET_GS(0x0) -- sel is 0x0
# [OK]	GS/BASE remained 0x2/0x0
# [RUN]	ARCH_SET_GS(0x200000000), then schedule to 0x0
# 	Before schedule, set selector to 0x3
# 	other thread: ARCH_SET_GS(0x0) -- sel is 0x0
# [OK]	GS/BASE remained 0x3/0x0
# [RUN]	ARCH_SET_GS(0x200000000), then schedule to 0x0
# 	Before schedule, set selector to 0x2b
# 	other thread: ARCH_SET_GS(0x0) -- sel is 0x0
# [OK]	GS/BASE remained 0x2b/0x0
# [RUN]	ARCH_SET_GS(0x200000000), then schedule to 0xa1fa5f343cb85fa4
# 	other thread: ARCH_SET_GS(0x0) and clear gs -- sel is 0x0
# [OK]	GS/BASE remained 0x0/0x200000000
# [RUN]	ARCH_SET_GS(0x200000000), then schedule to 0xa1fa5f343cb85fa4
# 	Before schedule, set selector to 0x1
# 	other thread: ARCH_SET_GS(0x0) and clear gs -- sel is 0x0
# [OK]	GS/BASE remained 0x1/0x0
# [RUN]	ARCH_SET_GS(0x200000000), then schedule to 0xa1fa5f343cb85fa4
# 	Before schedule, set selector to 0x2
# 	other thread: ARCH_SET_GS(0x0) and clear gs -- sel is 0x0
# [OK]	GS/BASE remained 0x2/0x0
# [RUN]	ARCH_SET_GS(0x200000000), then schedule to 0xa1fa5f343cb85fa4
# 	Before schedule, set selector to 0x3
# 	other thread: ARCH_SET_GS(0x0) and clear gs -- sel is 0x0
# [OK]	GS/BASE remained 0x3/0x0
# [RUN]	ARCH_SET_GS(0x200000000), then schedule to 0xa1fa5f343cb85fa4
# 	Before schedule, set selector to 0x2b
# 	other thread: ARCH_SET_GS(0x0) and clear gs -- sel is 0x0
# [OK]	GS/BASE remained 0x2b/0x0
# [RUN]	ARCH_SET_GS(0x200000000), then schedule to 0x1
# 	other thread: ARCH_SET_GS(0x1) -- sel is 0x0
# [OK]	GS/BASE remained 0x0/0x200000000
# [RUN]	ARCH_SET_GS(0x200000000), then schedule to 0x1
# 	Before schedule, set selector to 0x1
# 	other thread: ARCH_SET_GS(0x1) -- sel is 0x0
# [OK]	GS/BASE remained 0x1/0x0
# [RUN]	ARCH_SET_GS(0x200000000), then schedule to 0x1
# 	Before schedule, set selector to 0x2
# 	other thread: ARCH_SET_GS(0x1) -- sel is 0x0
# [OK]	GS/BASE remained 0x2/0x0
# [RUN]	ARCH_SET_GS(0x200000000), then schedule to 0x1
# 	Before schedule, set selector to 0x3
# 	other thread: ARCH_SET_GS(0x1) -- sel is 0x0
# [OK]	GS/BASE remained 0x3/0x0
# [RUN]	ARCH_SET_GS(0x200000000), then schedule to 0x1
# 	Before schedule, set selector to 0x2b
# 	other thread: ARCH_SET_GS(0x1) -- sel is 0x0
# [OK]	GS/BASE remained 0x2b/0x0
# [RUN]	ARCH_SET_GS(0x200000000), then schedule to 0x200000000
# 	other thread: ARCH_SET_GS(0x200000000) -- sel is 0x0
# [OK]	GS/BASE remained 0x0/0x200000000
# [RUN]	ARCH_SET_GS(0x200000000), then schedule to 0x200000000
# 	Before schedule, set selector to 0x1
# 	other thread: ARCH_SET_GS(0x200000000) -- sel is 0x0
# [OK]	GS/BASE remained 0x1/0x0
# [RUN]	ARCH_SET_GS(0x200000000), then schedule to 0x200000000
# 	Before schedule, set selector to 0x2
# 	other thread: ARCH_SET_GS(0x200000000) -- sel is 0x0
# [OK]	GS/BASE remained 0x2/0x0
# [RUN]	ARCH_SET_GS(0x200000000), then schedule to 0x200000000
# 	Before schedule, set selector to 0x3
# 	other thread: ARCH_SET_GS(0x200000000) -- sel is 0x0
# [OK]	GS/BASE remained 0x3/0x0
# [RUN]	ARCH_SET_GS(0x200000000), then schedule to 0x200000000
# 	Before schedule, set selector to 0x2b
# 	other thread: ARCH_SET_GS(0x200000000) -- sel is 0x0
# [OK]	GS/BASE remained 0x2b/0x0
# [RUN]	ARCH_SET_GS(0), clear gs, then manipulate GSBASE in a different thread
# 	using LDT slot 0
# [OK]	GSBASE remained 0
# [RUN]	GS = 0x0, GSBASE = 0x0
# 	other thread: ARCH_SET_GS(0x0) -- sel is 0x0
# [OK]	Index and base were preserved
# [RUN]	GS = 0x0, GSBASE = 0x1
# 	other thread: ARCH_SET_GS(0x0) -- sel is 0x0
# [OK]	Index and base were preserved
# [RUN]	GS = 0x0, GSBASE = 0x200000000
# 	other thread: ARCH_SET_GS(0x0) -- sel is 0x0
# [OK]	Index and base were preserved
# [RUN]	GS = 0x0, GSBASE = 0xffffffffffffffff
# 	other thread: ARCH_SET_GS(0x0) -- sel is 0x0
# [OK]	Index and base were preserved
# [RUN]	GS = 0x2b, GSBASE = 0x0
# 	other thread: ARCH_SET_GS(0x0) -- sel is 0x0
# [OK]	Index and base were preserved
# [RUN]	GS = 0x2b, GSBASE = 0x1
# 	other thread: ARCH_SET_GS(0x0) -- sel is 0x0
# [OK]	Index and base were preserved
# [RUN]	GS = 0x2b, GSBASE = 0x200000000
# 	other thread: ARCH_SET_GS(0x0) -- sel is 0x0
# [OK]	Index and base were preserved
# [RUN]	GS = 0x2b, GSBASE = 0xffffffffffffffff
# 	other thread: ARCH_SET_GS(0x0) -- sel is 0x0
# [OK]	Index and base were preserved
# [OK]	GS remained 0x7 and GSBASE changed to 0xFF
ok 36 selftests: x86: fsgsbase_64
# selftests: x86: sysret_rip_64
# [RUN]	sigreturn to 0x800000000000
# [OK]	Got SIGSEGV at RIP=0x800000000000
# [RUN]	sigreturn to 0x1000000000000
# [OK]	Got SIGSEGV at RIP=0x1000000000000
# [RUN]	sigreturn to 0x2000000000000
# [OK]	Got SIGSEGV at RIP=0x2000000000000
# [RUN]	sigreturn to 0x4000000000000
# [OK]	Got SIGSEGV at RIP=0x4000000000000
# [RUN]	sigreturn to 0x8000000000000
# [OK]	Got SIGSEGV at RIP=0x8000000000000
# [RUN]	sigreturn to 0x10000000000000
# [OK]	Got SIGSEGV at RIP=0x10000000000000
# [RUN]	sigreturn to 0x20000000000000
# [OK]	Got SIGSEGV at RIP=0x20000000000000
# [RUN]	sigreturn to 0x40000000000000
# [OK]	Got SIGSEGV at RIP=0x40000000000000
# [RUN]	sigreturn to 0x80000000000000
# [OK]	Got SIGSEGV at RIP=0x80000000000000
# [RUN]	sigreturn to 0x100000000000000
# [OK]	Got SIGSEGV at RIP=0x100000000000000
# [RUN]	sigreturn to 0x200000000000000
# [OK]	Got SIGSEGV at RIP=0x200000000000000
# [RUN]	sigreturn to 0x400000000000000
# [OK]	Got SIGSEGV at RIP=0x400000000000000
# [RUN]	sigreturn to 0x800000000000000
# [OK]	Got SIGSEGV at RIP=0x800000000000000
# [RUN]	sigreturn to 0x1000000000000000
# [OK]	Got SIGSEGV at RIP=0x1000000000000000
# [RUN]	sigreturn to 0x2000000000000000
# [OK]	Got SIGSEGV at RIP=0x2000000000000000
# [RUN]	sigreturn to 0x4000000000000000
# [OK]	Got SIGSEGV at RIP=0x4000000000000000
# [RUN]	sigreturn to 0x8000000000000000
# [OK]	Got SIGSEGV at RIP=0x8000000000000000
# [RUN]	Trying a SYSCALL that falls through to 0x7fffffffe000
# [OK]	We survived
# [RUN]	Trying a SYSCALL that falls through to 0x7ffffffff000
# [OK]	We survived
# [RUN]	Trying a SYSCALL that falls through to 0x800000000000
# [OK]	mremap to 0x7ffffffff000 failed
# [RUN]	Trying a SYSCALL that falls through to 0xfffffffff000
# [OK]	mremap to 0xffffffffe000 failed
# [RUN]	Trying a SYSCALL that falls through to 0x1000000000000
# [OK]	mremap to 0xfffffffff000 failed
# [RUN]	Trying a SYSCALL that falls through to 0x1fffffffff000
# [OK]	mremap to 0x1ffffffffe000 failed
# [RUN]	Trying a SYSCALL that falls through to 0x2000000000000
# [OK]	mremap to 0x1fffffffff000 failed
# [RUN]	Trying a SYSCALL that falls through to 0x3fffffffff000
# [OK]	mremap to 0x3ffffffffe000 failed
# [RUN]	Trying a SYSCALL that falls through to 0x4000000000000
# [OK]	mremap to 0x3fffffffff000 failed
# [RUN]	Trying a SYSCALL that falls through to 0x7fffffffff000
# [OK]	mremap to 0x7ffffffffe000 failed
# [RUN]	Trying a SYSCALL that falls through to 0x8000000000000
# [OK]	mremap to 0x7fffffffff000 failed
# [RUN]	Trying a SYSCALL that falls through to 0xffffffffff000
# [OK]	mremap to 0xfffffffffe000 failed
# [RUN]	Trying a SYSCALL that falls through to 0x10000000000000
# [OK]	mremap to 0xffffffffff000 failed
# [RUN]	Trying a SYSCALL that falls through to 0x1ffffffffff000
# [OK]	mremap to 0x1fffffffffe000 failed
# [RUN]	Trying a SYSCALL that falls through to 0x20000000000000
# [OK]	mremap to 0x1ffffffffff000 failed
# [RUN]	Trying a SYSCALL that falls through to 0x3ffffffffff000
# [OK]	mremap to 0x3fffffffffe000 failed
# [RUN]	Trying a SYSCALL that falls through to 0x40000000000000
# [OK]	mremap to 0x3ffffffffff000 failed
# [RUN]	Trying a SYSCALL that falls through to 0x7ffffffffff000
# [OK]	mremap to 0x7fffffffffe000 failed
# [RUN]	Trying a SYSCALL that falls through to 0x80000000000000
# [OK]	mremap to 0x7ffffffffff000 failed
# [RUN]	Trying a SYSCALL that falls through to 0xfffffffffff000
# [OK]	mremap to 0xffffffffffe000 failed
# [RUN]	Trying a SYSCALL that falls through to 0x100000000000000
# [OK]	mremap to 0xfffffffffff000 failed
# [RUN]	Trying a SYSCALL that falls through to 0x1fffffffffff000
# [OK]	mremap to 0x1ffffffffffe000 failed
# [RUN]	Trying a SYSCALL that falls through to 0x200000000000000
# [OK]	mremap to 0x1fffffffffff000 failed
# [RUN]	Trying a SYSCALL that falls through to 0x3fffffffffff000
# [OK]	mremap to 0x3ffffffffffe000 failed
# [RUN]	Trying a SYSCALL that falls through to 0x400000000000000
# [OK]	mremap to 0x3fffffffffff000 failed
# [RUN]	Trying a SYSCALL that falls through to 0x7fffffffffff000
# [OK]	mremap to 0x7ffffffffffe000 failed
# [RUN]	Trying a SYSCALL that falls through to 0x800000000000000
# [OK]	mremap to 0x7fffffffffff000 failed
# [RUN]	Trying a SYSCALL that falls through to 0xffffffffffff000
# [OK]	mremap to 0xfffffffffffe000 failed
# [RUN]	Trying a SYSCALL that falls through to 0x1000000000000000
# [OK]	mremap to 0xffffffffffff000 failed
# [RUN]	Trying a SYSCALL that falls through to 0x1ffffffffffff000
# [OK]	mremap to 0x1fffffffffffe000 failed
# [RUN]	Trying a SYSCALL that falls through to 0x2000000000000000
# [OK]	mremap to 0x1ffffffffffff000 failed
# [RUN]	Trying a SYSCALL that falls through to 0x3ffffffffffff000
# [OK]	mremap to 0x3fffffffffffe000 failed
# [RUN]	Trying a SYSCALL that falls through to 0x4000000000000000
# [OK]	mremap to 0x3ffffffffffff000 failed
# [RUN]	Trying a SYSCALL that falls through to 0x7ffffffffffff000
# [OK]	mremap to 0x7fffffffffffe000 failed
# [RUN]	Trying a SYSCALL that falls through to 0x8000000000000000
# [OK]	mremap to 0x7ffffffffffff000 failed
ok 37 selftests: x86: sysret_rip_64
# selftests: x86: syscall_numbering_64
# [RUN]   Checking for x32 by calling x32 getpid()
# [INFO]      x32 is not supported
# [RUN]   Running tests without ptrace...
# [RUN]       Checking system calls with msb = 0 (0x0)
# [RUN]           Checking some common syscalls as 64 bit
# [OK]                x64 syscall 0:0 returned 0 as expected
# [OK]                x64 syscall 0:1 returned 0 as expected
# [RUN]           Checking some 64-bit only syscalls as 64 bit
# [OK]                x64 syscall 0:19 returned 0 as expected
# [OK]                x64 syscall 0:20 returned 0 as expected
# [RUN]           Checking out of range system calls
# [OK]                x32 syscalls 0:-64..-2 returned -ENOSYS as expected
# [OK]                x32 syscall 0:-1 returned -ENOSYS as expected
# [OK]                x64 syscalls 0:1073741760..1073741823 returned -ENOSYS as expected
# [OK]                x64 syscalls 0:-64..-1 returned -ENOSYS as expected
# [OK]                x32 syscalls 0:1073741759..1073741822 returned -ENOSYS as expected
# [RUN]           Checking for absence of x32 system calls
# [OK]                x32 syscalls 0:0..999 returned -ENOSYS as expected
# [RUN]       Checking system calls with msb = 1 (0x1)
# [RUN]           Checking some common syscalls as 64 bit
# [OK]                x64 syscall 1:0 returned 0 as expected
# [OK]                x64 syscall 1:1 returned 0 as expected
# [RUN]           Checking some 64-bit only syscalls as 64 bit
# [OK]                x64 syscall 1:19 returned 0 as expected
# [OK]                x64 syscall 1:20 returned 0 as expected
# [RUN]           Checking out of range system calls
# [OK]                x32 syscalls 1:-64..-2 returned -ENOSYS as expected
# [OK]                x32 syscall 1:-1 returned -ENOSYS as expected
# [OK]                x64 syscalls 1:1073741760..1073741823 returned -ENOSYS as expected
# [OK]                x64 syscalls 1:-64..-1 returned -ENOSYS as expected
# [OK]                x32 syscalls 1:1073741759..1073741822 returned -ENOSYS as expected
# [RUN]           Checking for absence of x32 system calls
# [OK]                x32 syscalls 1:0..999 returned -ENOSYS as expected
# [RUN]       Checking system calls with msb = -1 (0xffffffff)
# [RUN]           Checking some common syscalls as 64 bit
# [OK]                x64 syscall -1:0 returned 0 as expected
# [OK]                x64 syscall -1:1 returned 0 as expected
# [RUN]           Checking some 64-bit only syscalls as 64 bit
# [OK]                x64 syscall -1:19 returned 0 as expected
# [OK]                x64 syscall -1:20 returned 0 as expected
# [RUN]           Checking out of range system calls
# [OK]                x32 syscalls -1:-64..-2 returned -ENOSYS as expected
# [OK]                x32 syscall -1:-1 returned -ENOSYS as expected
# [OK]                x64 syscalls -1:1073741760..1073741823 returned -ENOSYS as expected
# [OK]                x64 syscalls -1:-64..-1 returned -ENOSYS as expected
# [OK]                x32 syscalls -1:1073741759..1073741822 returned -ENOSYS as expected
# [RUN]           Checking for absence of x32 system calls
# [OK]                x32 syscalls -1:0..999 returned -ENOSYS as expected
# [RUN]       Checking system calls with msb = 1073741823 (0x3fffffff)
# [RUN]           Checking some common syscalls as 64 bit
# [OK]                x64 syscall 1073741823:0 returned 0 as expected
# [OK]                x64 syscall 1073741823:1 returned 0 as expected
# [RUN]           Checking some 64-bit only syscalls as 64 bit
# [OK]                x64 syscall 1073741823:19 returned 0 as expected
# [OK]                x64 syscall 1073741823:20 returned 0 as expected
# [RUN]           Checking out of range system calls
# [OK]                x32 syscalls 1073741823:-64..-2 returned -ENOSYS as expected
# [OK]                x32 syscall 1073741823:-1 returned -ENOSYS as expected
# [OK]                x64 syscalls 1073741823:1073741760..1073741823 returned -ENOSYS as expected
# [OK]                x64 syscalls 1073741823:-64..-1 returned -ENOSYS as expected
# [OK]                x32 syscalls 1073741823:1073741759..1073741822 returned -ENOSYS as expected
# [RUN]           Checking for absence of x32 system calls
# [OK]                x32 syscalls 1073741823:0..999 returned -ENOSYS as expected
# [RUN]       Checking system calls with msb = 1073741824 (0x40000000)
# [RUN]           Checking some common syscalls as 64 bit
# [OK]                x64 syscall 1073741824:0 returned 0 as expected
# [OK]                x64 syscall 1073741824:1 returned 0 as expected
# [RUN]           Checking some 64-bit only syscalls as 64 bit
# [OK]                x64 syscall 1073741824:19 returned 0 as expected
# [OK]                x64 syscall 1073741824:20 returned 0 as expected
# [RUN]           Checking out of range system calls
# [OK]                x32 syscalls 1073741824:-64..-2 returned -ENOSYS as expected
# [OK]                x32 syscall 1073741824:-1 returned -ENOSYS as expected
# [OK]                x64 syscalls 1073741824:1073741760..1073741823 returned -ENOSYS as expected
# [OK]                x64 syscalls 1073741824:-64..-1 returned -ENOSYS as expected
# [OK]                x32 syscalls 1073741824:1073741759..1073741822 returned -ENOSYS as expected
# [RUN]           Checking for absence of x32 system calls
# [OK]                x32 syscalls 1073741824:0..999 returned -ENOSYS as expected
# [RUN]       Checking system calls with msb = 1073741823 (0x3fffffff)
# [RUN]           Checking some common syscalls as 64 bit
# [OK]                x64 syscall 1073741823:0 returned 0 as expected
# [OK]                x64 syscall 1073741823:1 returned 0 as expected
# [RUN]           Checking some 64-bit only syscalls as 64 bit
# [OK]                x64 syscall 1073741823:19 returned 0 as expected
# [OK]                x64 syscall 1073741823:20 returned 0 as expected
# [RUN]           Checking out of range system calls
# [OK]                x32 syscalls 1073741823:-64..-2 returned -ENOSYS as expected
# [OK]                x32 syscall 1073741823:-1 returned -ENOSYS as expected
# [OK]                x64 syscalls 1073741823:1073741760..1073741823 returned -ENOSYS as expected
# [OK]                x64 syscalls 1073741823:-64..-1 returned -ENOSYS as expected
# [OK]                x32 syscalls 1073741823:1073741759..1073741822 returned -ENOSYS as expected
# [RUN]           Checking for absence of x32 system calls
# [OK]                x32 syscalls 1073741823:0..999 returned -ENOSYS as expected
# [RUN]       Checking system calls with msb = -1073741824 (0xc0000000)
# [RUN]           Checking some common syscalls as 64 bit
# [OK]                x64 syscall -1073741824:0 returned 0 as expected
# [OK]                x64 syscall -1073741824:1 returned 0 as expected
# [RUN]           Checking some 64-bit only syscalls as 64 bit
# [OK]                x64 syscall -1073741824:19 returned 0 as expected
# [OK]                x64 syscall -1073741824:20 returned 0 as expected
# [RUN]           Checking out of range system calls
# [OK]                x32 syscalls -1073741824:-64..-2 returned -ENOSYS as expected
# [OK]                x32 syscall -1073741824:-1 returned -ENOSYS as expected
# [OK]                x64 syscalls -1073741824:1073741760..1073741823 returned -ENOSYS as expected
# [OK]                x64 syscalls -1073741824:-64..-1 returned -ENOSYS as expected
# [OK]                x32 syscalls -1073741824:1073741759..1073741822 returned -ENOSYS as expected
# [RUN]           Checking for absence of x32 system calls
# [OK]                x32 syscalls -1073741824:0..999 returned -ENOSYS as expected
# [RUN]       Checking system calls with msb = 2147483647 (0x7fffffff)
# [RUN]           Checking some common syscalls as 64 bit
# [OK]                x64 syscall 2147483647:0 returned 0 as expected
# [OK]                x64 syscall 2147483647:1 returned 0 as expected
# [RUN]           Checking some 64-bit only syscalls as 64 bit
# [OK]                x64 syscall 2147483647:19 returned 0 as expected
# [OK]                x64 syscall 2147483647:20 returned 0 as expected
# [RUN]           Checking out of range system calls
# [OK]                x32 syscalls 2147483647:-64..-2 returned -ENOSYS as expected
# [OK]                x32 syscall 2147483647:-1 returned -ENOSYS as expected
# [OK]                x64 syscalls 2147483647:1073741760..1073741823 returned -ENOSYS as expected
# [OK]                x64 syscalls 2147483647:-64..-1 returned -ENOSYS as expected
# [OK]                x32 syscalls 2147483647:1073741759..1073741822 returned -ENOSYS as expected
# [RUN]           Checking for absence of x32 system calls
# [OK]                x32 syscalls 2147483647:0..999 returned -ENOSYS as expected
# [RUN]       Checking system calls with msb = -2147483648 (0x80000000)
# [RUN]           Checking some common syscalls as 64 bit
# [OK]                x64 syscall -2147483648:0 returned 0 as expected
# [OK]                x64 syscall -2147483648:1 returned 0 as expected
# [RUN]           Checking some 64-bit only syscalls as 64 bit
# [OK]                x64 syscall -2147483648:19 returned 0 as expected
# [OK]                x64 syscall -2147483648:20 returned 0 as expected
# [RUN]           Checking out of range system calls
# [OK]                x32 syscalls -2147483648:-64..-2 returned -ENOSYS as expected
# [OK]                x32 syscall -2147483648:-1 returned -ENOSYS as expected
# [OK]                x64 syscalls -2147483648:1073741760..1073741823 returned -ENOSYS as expected
# [OK]                x64 syscalls -2147483648:-64..-1 returned -ENOSYS as expected
# [OK]                x32 syscalls -2147483648:1073741759..1073741822 returned -ENOSYS as expected
# [RUN]           Checking for absence of x32 system calls
# [OK]                x32 syscalls -2147483648:0..999 returned -ENOSYS as expected
# [RUN]       Checking system calls with msb = -2147483647 (0x80000001)
# [RUN]           Checking some common syscalls as 64 bit
# [OK]                x64 syscall -2147483647:0 returned 0 as expected
# [OK]                x64 syscall -2147483647:1 returned 0 as expected
# [RUN]           Checking some 64-bit only syscalls as 64 bit
# [OK]                x64 syscall -2147483647:19 returned 0 as expected
# [OK]                x64 syscall -2147483647:20 returned 0 as expected
# [RUN]           Checking out of range system calls
# [OK]                x32 syscalls -2147483647:-64..-2 returned -ENOSYS as expected
# [OK]                x32 syscall -2147483647:-1 returned -ENOSYS as expected
# [OK]                x64 syscalls -2147483647:1073741760..1073741823 returned -ENOSYS as expected
# [OK]                x64 syscalls -2147483647:-64..-1 returned -ENOSYS as expected
# [OK]                x32 syscalls -2147483647:1073741759..1073741822 returned -ENOSYS as expected
# [RUN]           Checking for absence of x32 system calls
# [OK]                x32 syscalls -2147483647:0..999 returned -ENOSYS as expected
# [RUN]   Running tests under ptrace: just stop, no data read
# [RUN]       Checking system calls with msb = 0 (0x0)
# [RUN]           Checking some common syscalls as 64 bit
# [OK]                x64 syscall 0:0 returned 0 as expected
# [OK]                x64 syscall 0:1 returned 0 as expected
# [RUN]           Checking some 64-bit only syscalls as 64 bit
# [OK]                x64 syscall 0:19 returned 0 as expected
# [OK]                x64 syscall 0:20 returned 0 as expected
# [RUN]           Checking out of range system calls
# [OK]                x32 syscalls 0:-64..-2 returned -ENOSYS as expected
# [OK]                x32 syscall 0:-1 returned -ENOSYS as expected
# [OK]                x64 syscalls 0:1073741760..1073741823 returned -ENOSYS as expected
# [OK]                x64 syscalls 0:-64..-1 returned -ENOSYS as expected
# [OK]                x32 syscalls 0:1073741759..1073741822 returned -ENOSYS as expected
# [RUN]           Checking for absence of x32 system calls
# [OK]                x32 syscalls 0:0..999 returned -ENOSYS as expected
# [RUN]       Checking system calls with msb = 1 (0x1)
# [RUN]           Checking some common syscalls as 64 bit
# [OK]                x64 syscall 1:0 returned 0 as expected
# [OK]                x64 syscall 1:1 returned 0 as expected
# [RUN]           Checking some 64-bit only syscalls as 64 bit
# [OK]                x64 syscall 1:19 returned 0 as expected
# [OK]                x64 syscall 1:20 returned 0 as expected
# [RUN]           Checking out of range system calls
# [OK]                x32 syscalls 1:-64..-2 returned -ENOSYS as expected
# [OK]                x32 syscall 1:-1 returned -ENOSYS as expected
# [OK]                x64 syscalls 1:1073741760..1073741823 returned -ENOSYS as expected
# [OK]                x64 syscalls 1:-64..-1 returned -ENOSYS as expected
# [OK]                x32 syscalls 1:1073741759..1073741822 returned -ENOSYS as expected
# [RUN]           Checking for absence of x32 system calls
# [OK]                x32 syscalls 1:0..999 returned -ENOSYS as expected
# [RUN]       Checking system calls with msb = -1 (0xffffffff)
# [RUN]           Checking some common syscalls as 64 bit
# [OK]                x64 syscall -1:0 returned 0 as expected
# [OK]                x64 syscall -1:1 returned 0 as expected
# [RUN]           Checking some 64-bit only syscalls as 64 bit
# [OK]                x64 syscall -1:19 returned 0 as expected
# [OK]                x64 syscall -1:20 returned 0 as expected
# [RUN]           Checking out of range system calls
# [OK]                x32 syscalls -1:-64..-2 returned -ENOSYS as expected
# [OK]                x32 syscall -1:-1 returned -ENOSYS as expected
# [OK]                x64 syscalls -1:1073741760..1073741823 returned -ENOSYS as expected
# [OK]                x64 syscalls -1:-64..-1 returned -ENOSYS as expected
# [OK]                x32 syscalls -1:1073741759..1073741822 returned -ENOSYS as expected
# [RUN]           Checking for absence of x32 system calls
# [OK]                x32 syscalls -1:0..999 returned -ENOSYS as expected
# [RUN]       Checking system calls with msb = 1073741823 (0x3fffffff)
# [RUN]           Checking some common syscalls as 64 bit
# [OK]                x64 syscall 1073741823:0 returned 0 as expected
# [OK]                x64 syscall 1073741823:1 returned 0 as expected
# [RUN]           Checking some 64-bit only syscalls as 64 bit
# [OK]                x64 syscall 1073741823:19 returned 0 as expected
# [OK]                x64 syscall 1073741823:20 returned 0 as expected
# [RUN]           Checking out of range system calls
# [OK]                x32 syscalls 1073741823:-64..-2 returned -ENOSYS as expected
# [OK]                x32 syscall 1073741823:-1 returned -ENOSYS as expected
# [OK]                x64 syscalls 1073741823:1073741760..1073741823 returned -ENOSYS as expected
# [OK]                x64 syscalls 1073741823:-64..-1 returned -ENOSYS as expected
# [OK]                x32 syscalls 1073741823:1073741759..1073741822 returned -ENOSYS as expected
# [RUN]           Checking for absence of x32 system calls
# [OK]                x32 syscalls 1073741823:0..999 returned -ENOSYS as expected
# [RUN]       Checking system calls with msb = 1073741824 (0x40000000)
# [RUN]           Checking some common syscalls as 64 bit
# [OK]                x64 syscall 1073741824:0 returned 0 as expected
# [OK]                x64 syscall 1073741824:1 returned 0 as expected
# [RUN]           Checking some 64-bit only syscalls as 64 bit
# [OK]                x64 syscall 1073741824:19 returned 0 as expected
# [OK]                x64 syscall 1073741824:20 returned 0 as expected
# [RUN]           Checking out of range system calls
# [OK]                x32 syscalls 1073741824:-64..-2 returned -ENOSYS as expected
# [OK]                x32 syscall 1073741824:-1 returned -ENOSYS as expected
# [OK]                x64 syscalls 1073741824:1073741760..1073741823 returned -ENOSYS as expected
# [OK]                x64 syscalls 1073741824:-64..-1 returned -ENOSYS as expected
# [OK]                x32 syscalls 1073741824:1073741759..1073741822 returned -ENOSYS as expected
# [RUN]           Checking for absence of x32 system calls
# [OK]                x32 syscalls 1073741824:0..999 returned -ENOSYS as expected
# [RUN]       Checking system calls with msb = 1073741823 (0x3fffffff)
# [RUN]           Checking some common syscalls as 64 bit
# [OK]                x64 syscall 1073741823:0 returned 0 as expected
# [OK]                x64 syscall 1073741823:1 returned 0 as expected
# [RUN]           Checking some 64-bit only syscalls as 64 bit
# [OK]                x64 syscall 1073741823:19 returned 0 as expected
# [OK]                x64 syscall 1073741823:20 returned 0 as expected
# [RUN]           Checking out of range system calls
# [OK]                x32 syscalls 1073741823:-64..-2 returned -ENOSYS as expected
# [OK]                x32 syscall 1073741823:-1 returned -ENOSYS as expected
# [OK]                x64 syscalls 1073741823:1073741760..1073741823 returned -ENOSYS as expected
# [OK]                x64 syscalls 1073741823:-64..-1 returned -ENOSYS as expected
# [OK]                x32 syscalls 1073741823:1073741759..1073741822 returned -ENOSYS as expected
# [RUN]           Checking for absence of x32 system calls
# [OK]                x32 syscalls 1073741823:0..999 returned -ENOSYS as expected
# [RUN]       Checking system calls with msb = -1073741824 (0xc0000000)
# [RUN]           Checking some common syscalls as 64 bit
# [OK]                x64 syscall -1073741824:0 returned 0 as expected
# [OK]                x64 syscall -1073741824:1 returned 0 as expected
# [RUN]           Checking some 64-bit only syscalls as 64 bit
# [OK]                x64 syscall -1073741824:19 returned 0 as expected
# [OK]                x64 syscall -1073741824:20 returned 0 as expected
# [RUN]           Checking out of range system calls
# [OK]                x32 syscalls -1073741824:-64..-2 returned -ENOSYS as expected
# [OK]                x32 syscall -1073741824:-1 returned -ENOSYS as expected
# [OK]                x64 syscalls -1073741824:1073741760..1073741823 returned -ENOSYS as expected
# [OK]                x64 syscalls -1073741824:-64..-1 returned -ENOSYS as expected
# [OK]                x32 syscalls -1073741824:1073741759..1073741822 returned -ENOSYS as expected
# [RUN]           Checking for absence of x32 system calls
# [OK]                x32 syscalls -1073741824:0..999 returned -ENOSYS as expected
# [RUN]       Checking system calls with msb = 2147483647 (0x7fffffff)
# [RUN]           Checking some common syscalls as 64 bit
# [OK]                x64 syscall 2147483647:0 returned 0 as expected
# [OK]                x64 syscall 2147483647:1 returned 0 as expected
# [RUN]           Checking some 64-bit only syscalls as 64 bit
# [OK]                x64 syscall 2147483647:19 returned 0 as expected
# [OK]                x64 syscall 2147483647:20 returned 0 as expected
# [RUN]           Checking out of range system calls
# [OK]                x32 syscalls 2147483647:-64..-2 returned -ENOSYS as expected
# [OK]                x32 syscall 2147483647:-1 returned -ENOSYS as expected
# [OK]                x64 syscalls 2147483647:1073741760..1073741823 returned -ENOSYS as expected
# [OK]                x64 syscalls 2147483647:-64..-1 returned -ENOSYS as expected
# [OK]                x32 syscalls 2147483647:1073741759..1073741822 returned -ENOSYS as expected
# [RUN]           Checking for absence of x32 system calls
# [OK]                x32 syscalls 2147483647:0..999 returned -ENOSYS as expected
# [RUN]       Checking system calls with msb = -2147483648 (0x80000000)
# [RUN]           Checking some common syscalls as 64 bit
# [OK]                x64 syscall -2147483648:0 returned 0 as expected
# [OK]                x64 syscall -2147483648:1 returned 0 as expected
# [RUN]           Checking some 64-bit only syscalls as 64 bit
# [OK]                x64 syscall -2147483648:19 returned 0 as expected
# [OK]                x64 syscall -2147483648:20 returned 0 as expected
# [RUN]           Checking out of range system calls
# [OK]                x32 syscalls -2147483648:-64..-2 returned -ENOSYS as expected
# [OK]                x32 syscall -2147483648:-1 returned -ENOSYS as expected
# [OK]                x64 syscalls -2147483648:1073741760..1073741823 returned -ENOSYS as expected
# [OK]                x64 syscalls -2147483648:-64..-1 returned -ENOSYS as expected
# [OK]                x32 syscalls -2147483648:1073741759..1073741822 returned -ENOSYS as expected
# [RUN]           Checking for absence of x32 system calls
# [OK]                x32 syscalls -2147483648:0..999 returned -ENOSYS as expected
# [RUN]       Checking system calls with msb = -2147483647 (0x80000001)
# [RUN]           Checking some common syscalls as 64 bit
# [OK]                x64 syscall -2147483647:0 returned 0 as expected
# [OK]                x64 syscall -2147483647:1 returned 0 as expected
# [RUN]           Checking some 64-bit only syscalls as 64 bit
# [OK]                x64 syscall -2147483647:19 returned 0 as expected
# [OK]                x64 syscall -2147483647:20 returned 0 as expected
# [RUN]           Checking out of range system calls
# [OK]                x32 syscalls -2147483647:-64..-2 returned -ENOSYS as expected
# [OK]                x32 syscall -2147483647:-1 returned -ENOSYS as expected
# [OK]                x64 syscalls -2147483647:1073741760..1073741823 returned -ENOSYS as expected
# [OK]                x64 syscalls -2147483647:-64..-1 returned -ENOSYS as expected
# [OK]                x32 syscalls -2147483647:1073741759..1073741822 returned -ENOSYS as expected
# [RUN]           Checking for absence of x32 system calls
# [OK]                x32 syscalls -2147483647:0..999 returned -ENOSYS as expected
# [RUN]   Running tests under ptrace: only getregs
# [RUN]       Checking system calls with msb = 0 (0x0)
# [RUN]           Checking some common syscalls as 64 bit
# [OK]                x64 syscall 0:0 returned 0 as expected
# [OK]                x64 syscall 0:1 returned 0 as expected
# [RUN]           Checking some 64-bit only syscalls as 64 bit
# [OK]                x64 syscall 0:19 returned 0 as expected
# [OK]                x64 syscall 0:20 returned 0 as expected
# [RUN]           Checking out of range system calls
# [OK]                x32 syscalls 0:-64..-2 returned -ENOSYS as expected
# [OK]                x32 syscall 0:-1 returned -ENOSYS as expected
# [OK]                x64 syscalls 0:1073741760..1073741823 returned -ENOSYS as expected
# [OK]                x64 syscalls 0:-64..-1 returned -ENOSYS as expected
# [OK]                x32 syscalls 0:1073741759..1073741822 returned -ENOSYS as expected
# [RUN]           Checking for absence of x32 system calls
# [OK]                x32 syscalls 0:0..999 returned -ENOSYS as expected
# [RUN]       Checking system calls with msb = 1 (0x1)
# [RUN]           Checking some common syscalls as 64 bit
# [OK]                x64 syscall 1:0 returned 0 as expected
# [OK]                x64 syscall 1:1 returned 0 as expected
# [RUN]           Checking some 64-bit only syscalls as 64 bit
# [OK]                x64 syscall 1:19 returned 0 as expected
# [OK]                x64 syscall 1:20 returned 0 as expected
# [RUN]           Checking out of range system calls
# [OK]                x32 syscalls 1:-64..-2 returned -ENOSYS as expected
# [OK]                x32 syscall 1:-1 returned -ENOSYS as expected
# [OK]                x64 syscalls 1:1073741760..1073741823 returned -ENOSYS as expected
# [OK]                x64 syscalls 1:-64..-1 returned -ENOSYS as expected
# [OK]                x32 syscalls 1:1073741759..1073741822 returned -ENOSYS as expected
# [RUN]           Checking for absence of x32 system calls
# [OK]                x32 syscalls 1:0..999 returned -ENOSYS as expected
# [RUN]       Checking system calls with msb = -1 (0xffffffff)
# [RUN]           Checking some common syscalls as 64 bit
# [OK]                x64 syscall -1:0 returned 0 as expected
# [OK]                x64 syscall -1:1 returned 0 as expected
# [RUN]           Checking some 64-bit only syscalls as 64 bit
# [OK]                x64 syscall -1:19 returned 0 as expected
# [OK]                x64 syscall -1:20 returned 0 as expected
# [RUN]           Checking out of range system calls
# [OK]                x32 syscalls -1:-64..-2 returned -ENOSYS as expected
# [OK]                x32 syscall -1:-1 returned -ENOSYS as expected
# [OK]                x64 syscalls -1:1073741760..1073741823 returned -ENOSYS as expected
# [OK]                x64 syscalls -1:-64..-1 returned -ENOSYS as expected
# [OK]                x32 syscalls -1:1073741759..1073741822 returned -ENOSYS as expected
# [RUN]           Checking for absence of x32 system calls
# [OK]                x32 syscalls -1:0..999 returned -ENOSYS as expected
# [RUN]       Checking system calls with msb = 1073741823 (0x3fffffff)
# [RUN]           Checking some common syscalls as 64 bit
# [OK]                x64 syscall 1073741823:0 returned 0 as expected
# [OK]                x64 syscall 1073741823:1 returned 0 as expected
# [RUN]           Checking some 64-bit only syscalls as 64 bit
# [OK]                x64 syscall 1073741823:19 returned 0 as expected
# [OK]                x64 syscall 1073741823:20 returned 0 as expected
# [RUN]           Checking out of range system calls
# [OK]                x32 syscalls 1073741823:-64..-2 returned -ENOSYS as expected
# [OK]                x32 syscall 1073741823:-1 returned -ENOSYS as expected
# [OK]                x64 syscalls 1073741823:1073741760..1073741823 returned -ENOSYS as expected
# [OK]                x64 syscalls 1073741823:-64..-1 returned -ENOSYS as expected
# [OK]                x32 syscalls 1073741823:1073741759..1073741822 returned -ENOSYS as expected
# [RUN]           Checking for absence of x32 system calls
# [OK]                x32 syscalls 1073741823:0..999 returned -ENOSYS as expected
# [RUN]       Checking system calls with msb = 1073741824 (0x40000000)
# [RUN]           Checking some common syscalls as 64 bit
# [OK]                x64 syscall 1073741824:0 returned 0 as expected
# [OK]                x64 syscall 1073741824:1 returned 0 as expected
# [RUN]           Checking some 64-bit only syscalls as 64 bit
# [OK]                x64 syscall 1073741824:19 returned 0 as expected
# [OK]                x64 syscall 1073741824:20 returned 0 as expected
# [RUN]           Checking out of range system calls
# [OK]                x32 syscalls 1073741824:-64..-2 returned -ENOSYS as expected
# [OK]                x32 syscall 1073741824:-1 returned -ENOSYS as expected
# [OK]                x64 syscalls 1073741824:1073741760..1073741823 returned -ENOSYS as expected
# [OK]                x64 syscalls 1073741824:-64..-1 returned -ENOSYS as expected
# [OK]                x32 syscalls 1073741824:1073741759..1073741822 returned -ENOSYS as expected
# [RUN]           Checking for absence of x32 system calls
# [OK]                x32 syscalls 1073741824:0..999 returned -ENOSYS as expected
# [RUN]       Checking system calls with msb = 1073741823 (0x3fffffff)
# [RUN]           Checking some common syscalls as 64 bit
# [OK]                x64 syscall 1073741823:0 returned 0 as expected
# [OK]                x64 syscall 1073741823:1 returned 0 as expected
# [RUN]           Checking some 64-bit only syscalls as 64 bit
# [OK]                x64 syscall 1073741823:19 returned 0 as expected
# [OK]                x64 syscall 1073741823:20 returned 0 as expected
# [RUN]           Checking out of range system calls
# [OK]                x32 syscalls 1073741823:-64..-2 returned -ENOSYS as expected
# [OK]                x32 syscall 1073741823:-1 returned -ENOSYS as expected
# [OK]                x64 syscalls 1073741823:1073741760..1073741823 returned -ENOSYS as expected
# [OK]                x64 syscalls 1073741823:-64..-1 returned -ENOSYS as expected
# [OK]                x32 syscalls 1073741823:1073741759..1073741822 returned -ENOSYS as expected
# [RUN]           Checking for absence of x32 system calls
# [OK]                x32 syscalls 1073741823:0..999 returned -ENOSYS as expected
# [RUN]       Checking system calls with msb = -1073741824 (0xc0000000)
# [RUN]           Checking some common syscalls as 64 bit
# [OK]                x64 syscall -1073741824:0 returned 0 as expected
# [OK]                x64 syscall -1073741824:1 returned 0 as expected
# [RUN]           Checking some 64-bit only syscalls as 64 bit
# [OK]                x64 syscall -1073741824:19 returned 0 as expected
# [OK]                x64 syscall -1073741824:20 returned 0 as expected
# [RUN]           Checking out of range system calls
# [OK]                x32 syscalls -1073741824:-64..-2 returned -ENOSYS as expected
# [OK]                x32 syscall -1073741824:-1 returned -ENOSYS as expected
# [OK]                x64 syscalls -1073741824:1073741760..1073741823 returned -ENOSYS as expected
# [OK]                x64 syscalls -1073741824:-64..-1 returned -ENOSYS as expected
# [OK]                x32 syscalls -1073741824:1073741759..1073741822 returned -ENOSYS as expected
# [RUN]           Checking for absence of x32 system calls
# [OK]                x32 syscalls -1073741824:0..999 returned -ENOSYS as expected
# [RUN]       Checking system calls with msb = 2147483647 (0x7fffffff)
# [RUN]           Checking some common syscalls as 64 bit
# [OK]                x64 syscall 2147483647:0 returned 0 as expected
# [OK]                x64 syscall 2147483647:1 returned 0 as expected
# [RUN]           Checking some 64-bit only syscalls as 64 bit
# [OK]                x64 syscall 2147483647:19 returned 0 as expected
# [OK]                x64 syscall 2147483647:20 returned 0 as expected
# [RUN]           Checking out of range system calls
# [OK]                x32 syscalls 2147483647:-64..-2 returned -ENOSYS as expected
# [OK]                x32 syscall 2147483647:-1 returned -ENOSYS as expected
# [OK]                x64 syscalls 2147483647:1073741760..1073741823 returned -ENOSYS as expected
# [OK]                x64 syscalls 2147483647:-64..-1 returned -ENOSYS as expected
# [OK]                x32 syscalls 2147483647:1073741759..1073741822 returned -ENOSYS as expected
# [RUN]           Checking for absence of x32 system calls
# [OK]                x32 syscalls 2147483647:0..999 returned -ENOSYS as expected
# [RUN]       Checking system calls with msb = -2147483648 (0x80000000)
# [RUN]           Checking some common syscalls as 64 bit
# [OK]                x64 syscall -2147483648:0 returned 0 as expected
# [OK]                x64 syscall -2147483648:1 returned 0 as expected
# [RUN]           Checking some 64-bit only syscalls as 64 bit
# [OK]                x64 syscall -2147483648:19 returned 0 as expected
# [OK]                x64 syscall -2147483648:20 returned 0 as expected
# [RUN]           Checking out of range system calls
# [OK]                x32 syscalls -2147483648:-64..-2 returned -ENOSYS as expected
# [OK]                x32 syscall -2147483648:-1 returned -ENOSYS as expected
# [OK]                x64 syscalls -2147483648:1073741760..1073741823 returned -ENOSYS as expected
# [OK]                x64 syscalls -2147483648:-64..-1 returned -ENOSYS as expected
# [OK]                x32 syscalls -2147483648:1073741759..1073741822 returned -ENOSYS as expected
# [RUN]           Checking for absence of x32 system calls
# [OK]                x32 syscalls -2147483648:0..999 returned -ENOSYS as expected
# [RUN]       Checking system calls with msb = -2147483647 (0x80000001)
# [RUN]           Checking some common syscalls as 64 bit
# [OK]                x64 syscall -2147483647:0 returned 0 as expected
# [OK]                x64 syscall -2147483647:1 returned 0 as expected
# [RUN]           Checking some 64-bit only syscalls as 64 bit
# [OK]                x64 syscall -2147483647:19 returned 0 as expected
# [OK]                x64 syscall -2147483647:20 returned 0 as expected
# [RUN]           Checking out of range system calls
# [OK]                x32 syscalls -2147483647:-64..-2 returned -ENOSYS as expected
# [OK]                x32 syscall -2147483647:-1 returned -ENOSYS as expected
# [OK]                x64 syscalls -2147483647:1073741760..1073741823 returned -ENOSYS as expected
# [OK]                x64 syscalls -2147483647:-64..-1 returned -ENOSYS as expected
# [OK]                x32 syscalls -2147483647:1073741759..1073741822 returned -ENOSYS as expected
# [RUN]           Checking for absence of x32 system calls
# [OK]                x32 syscalls -2147483647:0..999 returned -ENOSYS as expected
# [RUN]   Running tests under ptrace: getregs, unmodified setregs
# [RUN]       Checking system calls with msb = 0 (0x0)
# [RUN]           Checking some common syscalls as 64 bit
# [OK]                x64 syscall 0:0 returned 0 as expected
# [OK]                x64 syscall 0:1 returned 0 as expected
# [RUN]           Checking some 64-bit only syscalls as 64 bit
# [OK]                x64 syscall 0:19 returned 0 as expected
# [OK]                x64 syscall 0:20 returned 0 as expected
# [RUN]           Checking out of range system calls
# [OK]                x32 syscalls 0:-64..-2 returned -ENOSYS as expected
# [OK]                x32 syscall 0:-1 returned -ENOSYS as expected
# [OK]                x64 syscalls 0:1073741760..1073741823 returned -ENOSYS as expected
# [OK]                x64 syscalls 0:-64..-1 returned -ENOSYS as expected
# [OK]                x32 syscalls 0:1073741759..1073741822 returned -ENOSYS as expected
# [RUN]           Checking for absence of x32 system calls
# [OK]                x32 syscalls 0:0..999 returned -ENOSYS as expected
# [RUN]       Checking system calls with msb = 1 (0x1)
# [RUN]           Checking some common syscalls as 64 bit
# [OK]                x64 syscall 1:0 returned 0 as expected
# [OK]                x64 syscall 1:1 returned 0 as expected
# [RUN]           Checking some 64-bit only syscalls as 64 bit
# [OK]                x64 syscall 1:19 returned 0 as expected
# [OK]                x64 syscall 1:20 returned 0 as expected
# [RUN]           Checking out of range system calls
# [OK]                x32 syscalls 1:-64..-2 returned -ENOSYS as expected
# [OK]                x32 syscall 1:-1 returned -ENOSYS as expected
# [OK]                x64 syscalls 1:1073741760..1073741823 returned -ENOSYS as expected
# [OK]                x64 syscalls 1:-64..-1 returned -ENOSYS as expected
# [OK]                x32 syscalls 1:1073741759..1073741822 returned -ENOSYS as expected
# [RUN]           Checking for absence of x32 system calls
# [OK]                x32 syscalls 1:0..999 returned -ENOSYS as expected
# [RUN]       Checking system calls with msb = -1 (0xffffffff)
# [RUN]           Checking some common syscalls as 64 bit
# [OK]                x64 syscall -1:0 returned 0 as expected
# [OK]                x64 syscall -1:1 returned 0 as expected
# [RUN]           Checking some 64-bit only syscalls as 64 bit
# [OK]                x64 syscall -1:19 returned 0 as expected
# [OK]                x64 syscall -1:20 returned 0 as expected
# [RUN]           Checking out of range system calls
# [OK]                x32 syscalls -1:-64..-2 returned -ENOSYS as expected
# [OK]                x32 syscall -1:-1 returned -ENOSYS as expected
# [OK]                x64 syscalls -1:1073741760..1073741823 returned -ENOSYS as expected
# [OK]                x64 syscalls -1:-64..-1 returned -ENOSYS as expected
# [OK]                x32 syscalls -1:1073741759..1073741822 returned -ENOSYS as expected
# [RUN]           Checking for absence of x32 system calls
# [OK]                x32 syscalls -1:0..999 returned -ENOSYS as expected
# [RUN]       Checking system calls with msb = 1073741823 (0x3fffffff)
# [RUN]           Checking some common syscalls as 64 bit
# [OK]                x64 syscall 1073741823:0 returned 0 as expected
# [OK]                x64 syscall 1073741823:1 returned 0 as expected
# [RUN]           Checking some 64-bit only syscalls as 64 bit
# [OK]                x64 syscall 1073741823:19 returned 0 as expected
# [OK]                x64 syscall 1073741823:20 returned 0 as expected
# [RUN]           Checking out of range system calls
# [OK]                x32 syscalls 1073741823:-64..-2 returned -ENOSYS as expected
# [OK]                x32 syscall 1073741823:-1 returned -ENOSYS as expected
# [OK]                x64 syscalls 1073741823:1073741760..1073741823 returned -ENOSYS as expected
# [OK]                x64 syscalls 1073741823:-64..-1 returned -ENOSYS as expected
# [OK]                x32 syscalls 1073741823:1073741759..1073741822 returned -ENOSYS as expected
# [RUN]           Checking for absence of x32 system calls
# [OK]                x32 syscalls 1073741823:0..999 returned -ENOSYS as expected
# [RUN]       Checking system calls with msb = 1073741824 (0x40000000)
# [RUN]           Checking some common syscalls as 64 bit
# [OK]                x64 syscall 1073741824:0 returned 0 as expected
# [OK]                x64 syscall 1073741824:1 returned 0 as expected
# [RUN]           Checking some 64-bit only syscalls as 64 bit
# [OK]                x64 syscall 1073741824:19 returned 0 as expected
# [OK]                x64 syscall 1073741824:20 returned 0 as expected
# [RUN]           Checking out of range system calls
# [OK]                x32 syscalls 1073741824:-64..-2 returned -ENOSYS as expected
# [OK]                x32 syscall 1073741824:-1 returned -ENOSYS as expected
# [OK]                x64 syscalls 1073741824:1073741760..1073741823 returned -ENOSYS as expected
# [OK]                x64 syscalls 1073741824:-64..-1 returned -ENOSYS as expected
# [OK]                x32 syscalls 1073741824:1073741759..1073741822 returned -ENOSYS as expected
# [RUN]           Checking for absence of x32 system calls
# [OK]                x32 syscalls 1073741824:0..999 returned -ENOSYS as expected
# [RUN]       Checking system calls with msb = 1073741823 (0x3fffffff)
# [RUN]           Checking some common syscalls as 64 bit
# [OK]                x64 syscall 1073741823:0 returned 0 as expected
# [OK]                x64 syscall 1073741823:1 returned 0 as expected
# [RUN]           Checking some 64-bit only syscalls as 64 bit
# [OK]                x64 syscall 1073741823:19 returned 0 as expected
# [OK]                x64 syscall 1073741823:20 returned 0 as expected
# [RUN]           Checking out of range system calls
# [OK]                x32 syscalls 1073741823:-64..-2 returned -ENOSYS as expected
# [OK]                x32 syscall 1073741823:-1 returned -ENOSYS as expected
# [OK]                x64 syscalls 1073741823:1073741760..1073741823 returned -ENOSYS as expected
# [OK]                x64 syscalls 1073741823:-64..-1 returned -ENOSYS as expected
# [OK]                x32 syscalls 1073741823:1073741759..1073741822 returned -ENOSYS as expected
# [RUN]           Checking for absence of x32 system calls
# [OK]                x32 syscalls 1073741823:0..999 returned -ENOSYS as expected
# [RUN]       Checking system calls with msb = -1073741824 (0xc0000000)
# [RUN]           Checking some common syscalls as 64 bit
# [OK]                x64 syscall -1073741824:0 returned 0 as expected
# [OK]                x64 syscall -1073741824:1 returned 0 as expected
# [RUN]           Checking some 64-bit only syscalls as 64 bit
# [OK]                x64 syscall -1073741824:19 returned 0 as expected
# [OK]                x64 syscall -1073741824:20 returned 0 as expected
# [RUN]           Checking out of range system calls
# [OK]                x32 syscalls -1073741824:-64..-2 returned -ENOSYS as expected
# [OK]                x32 syscall -1073741824:-1 returned -ENOSYS as expected
# [OK]                x64 syscalls -1073741824:1073741760..1073741823 returned -ENOSYS as expected
# [OK]                x64 syscalls -1073741824:-64..-1 returned -ENOSYS as expected
# [OK]                x32 syscalls -1073741824:1073741759..1073741822 returned -ENOSYS as expected
# [RUN]           Checking for absence of x32 system calls
# [OK]                x32 syscalls -1073741824:0..999 returned -ENOSYS as expected
# [RUN]       Checking system calls with msb = 2147483647 (0x7fffffff)
# [RUN]           Checking some common syscalls as 64 bit
# [OK]                x64 syscall 2147483647:0 returned 0 as expected
# [OK]                x64 syscall 2147483647:1 returned 0 as expected
# [RUN]           Checking some 64-bit only syscalls as 64 bit
# [OK]                x64 syscall 2147483647:19 returned 0 as expected
# [OK]                x64 syscall 2147483647:20 returned 0 as expected
# [RUN]           Checking out of range system calls
# [OK]                x32 syscalls 2147483647:-64..-2 returned -ENOSYS as expected
# [OK]                x32 syscall 2147483647:-1 returned -ENOSYS as expected
# [OK]                x64 syscalls 2147483647:1073741760..1073741823 returned -ENOSYS as expected
# [OK]                x64 syscalls 2147483647:-64..-1 returned -ENOSYS as expected
# [OK]                x32 syscalls 2147483647:1073741759..1073741822 returned -ENOSYS as expected
# [RUN]           Checking for absence of x32 system calls
# [OK]                x32 syscalls 2147483647:0..999 returned -ENOSYS as expected
# [RUN]       Checking system calls with msb = -2147483648 (0x80000000)
# [RUN]           Checking some common syscalls as 64 bit
# [OK]                x64 syscall -2147483648:0 returned 0 as expected
# [OK]                x64 syscall -2147483648:1 returned 0 as expected
# [RUN]           Checking some 64-bit only syscalls as 64 bit
# [OK]                x64 syscall -2147483648:19 returned 0 as expected
# [OK]                x64 syscall -2147483648:20 returned 0 as expected
# [RUN]           Checking out of range system calls
# [OK]                x32 syscalls -2147483648:-64..-2 returned -ENOSYS as expected
# [OK]                x32 syscall -2147483648:-1 returned -ENOSYS as expected
# [OK]                x64 syscalls -2147483648:1073741760..1073741823 returned -ENOSYS as expected
# [OK]                x64 syscalls -2147483648:-64..-1 returned -ENOSYS as expected
# [OK]                x32 syscalls -2147483648:1073741759..1073741822 returned -ENOSYS as expected
# [RUN]           Checking for absence of x32 system calls
# [OK]                x32 syscalls -2147483648:0..999 returned -ENOSYS as expected
# [RUN]       Checking system calls with msb = -2147483647 (0x80000001)
# [RUN]           Checking some common syscalls as 64 bit
# [OK]                x64 syscall -2147483647:0 returned 0 as expected
# [OK]                x64 syscall -2147483647:1 returned 0 as expected
# [RUN]           Checking some 64-bit only syscalls as 64 bit
# [OK]                x64 syscall -2147483647:19 returned 0 as expected
# [OK]                x64 syscall -2147483647:20 returned 0 as expected
# [RUN]           Checking out of range system calls
# [OK]                x32 syscalls -2147483647:-64..-2 returned -ENOSYS as expected
# [OK]                x32 syscall -2147483647:-1 returned -ENOSYS as expected
# [OK]                x64 syscalls -2147483647:1073741760..1073741823 returned -ENOSYS as expected
# [OK]                x64 syscalls -2147483647:-64..-1 returned -ENOSYS as expected
# [OK]                x32 syscalls -2147483647:1073741759..1073741822 returned -ENOSYS as expected
# [RUN]           Checking for absence of x32 system calls
# [OK]                x32 syscalls -2147483647:0..999 returned -ENOSYS as expected
# [RUN]   Running tests under ptrace: modifying the default return
# [RUN]       Checking system calls with msb = 0 (0x0)
# [RUN]           Checking some common syscalls as 64 bit
# [OK]                x64 syscall 0:0 returned 0 as expected
# [OK]                x64 syscall 0:1 returned 0 as expected
# [RUN]           Checking some 64-bit only syscalls as 64 bit
# [OK]                x64 syscall 0:19 returned 0 as expected
# [OK]                x64 syscall 0:20 returned 0 as expected
# [RUN]           Checking out of range system calls
# [OK]                x32 syscalls 0:-64..-2 returned -ENOSYS as expected
# [OK]                x32 syscall 0:-1 returned MODIFIED_BY_PTRACE as expected
# [OK]                x64 syscalls 0:1073741760..1073741823 returned -ENOSYS as expected
# [OK]                x64 syscalls 0:-64..-1 returned -ENOSYS as expected
# [OK]                x32 syscalls 0:1073741759..1073741822 returned -ENOSYS as expected
# [RUN]           Checking for absence of x32 system calls
# [OK]                x32 syscalls 0:0..999 returned -ENOSYS as expected
# [RUN]       Checking system calls with msb = 1 (0x1)
# [RUN]           Checking some common syscalls as 64 bit
# [OK]                x64 syscall 1:0 returned 0 as expected
# [OK]                x64 syscall 1:1 returned 0 as expected
# [RUN]           Checking some 64-bit only syscalls as 64 bit
# [OK]                x64 syscall 1:19 returned 0 as expected
# [OK]                x64 syscall 1:20 returned 0 as expected
# [RUN]           Checking out of range system calls
# [OK]                x32 syscalls 1:-64..-2 returned -ENOSYS as expected
# [OK]                x32 syscall 1:-1 returned MODIFIED_BY_PTRACE as expected
# [OK]                x64 syscalls 1:1073741760..1073741823 returned -ENOSYS as expected
# [OK]                x64 syscalls 1:-64..-1 returned -ENOSYS as expected
# [OK]                x32 syscalls 1:1073741759..1073741822 returned -ENOSYS as expected
# [RUN]           Checking for absence of x32 system calls
# [OK]                x32 syscalls 1:0..999 returned -ENOSYS as expected
# [RUN]       Checking system calls with msb = -1 (0xffffffff)
# [RUN]           Checking some common syscalls as 64 bit
# [OK]                x64 syscall -1:0 returned 0 as expected
# [OK]                x64 syscall -1:1 returned 0 as expected
# [RUN]           Checking some 64-bit only syscalls as 64 bit
# [OK]                x64 syscall -1:19 returned 0 as expected
# [OK]                x64 syscall -1:20 returned 0 as expected
# [RUN]           Checking out of range system calls
# [OK]                x32 syscalls -1:-64..-2 returned -ENOSYS as expected
# [OK]                x32 syscall -1:-1 returned MODIFIED_BY_PTRACE as expected
# [OK]                x64 syscalls -1:1073741760..1073741823 returned -ENOSYS as expected
# [OK]                x64 syscalls -1:-64..-1 returned -ENOSYS as expected
# [OK]                x32 syscalls -1:1073741759..1073741822 returned -ENOSYS as expected
# [RUN]           Checking for absence of x32 system calls
# [OK]                x32 syscalls -1:0..999 returned -ENOSYS as expected
# [RUN]       Checking system calls with msb = 1073741823 (0x3fffffff)
# [RUN]           Checking some common syscalls as 64 bit
# [OK]                x64 syscall 1073741823:0 returned 0 as expected
# [OK]                x64 syscall 1073741823:1 returned 0 as expected
# [RUN]           Checking some 64-bit only syscalls as 64 bit
# [OK]                x64 syscall 1073741823:19 returned 0 as expected
# [OK]                x64 syscall 1073741823:20 returned 0 as expected
# [RUN]           Checking out of range system calls
# [OK]                x32 syscalls 1073741823:-64..-2 returned -ENOSYS as expected
# [OK]                x32 syscall 1073741823:-1 returned MODIFIED_BY_PTRACE as expected
# [OK]                x64 syscalls 1073741823:1073741760..1073741823 returned -ENOSYS as expected
# [OK]                x64 syscalls 1073741823:-64..-1 returned -ENOSYS as expected
# [OK]                x32 syscalls 1073741823:1073741759..1073741822 returned -ENOSYS as expected
# [RUN]           Checking for absence of x32 system calls
# [OK]                x32 syscalls 1073741823:0..999 returned -ENOSYS as expected
# [RUN]       Checking system calls with msb = 1073741824 (0x40000000)
# [RUN]           Checking some common syscalls as 64 bit
# [OK]                x64 syscall 1073741824:0 returned 0 as expected
# [OK]                x64 syscall 1073741824:1 returned 0 as expected
# [RUN]           Checking some 64-bit only syscalls as 64 bit
# [OK]                x64 syscall 1073741824:19 returned 0 as expected
# [OK]                x64 syscall 1073741824:20 returned 0 as expected
# [RUN]           Checking out of range system calls
# [OK]                x32 syscalls 1073741824:-64..-2 returned -ENOSYS as expected
# [OK]                x32 syscall 1073741824:-1 returned MODIFIED_BY_PTRACE as expected
# [OK]                x64 syscalls 1073741824:1073741760..1073741823 returned -ENOSYS as expected
# [OK]                x64 syscalls 1073741824:-64..-1 returned -ENOSYS as expected
# [OK]                x32 syscalls 1073741824:1073741759..1073741822 returned -ENOSYS as expected
# [RUN]           Checking for absence of x32 system calls
# [OK]                x32 syscalls 1073741824:0..999 returned -ENOSYS as expected
# [RUN]       Checking system calls with msb = 1073741823 (0x3fffffff)
# [RUN]           Checking some common syscalls as 64 bit
# [OK]                x64 syscall 1073741823:0 returned 0 as expected
# [OK]                x64 syscall 1073741823:1 returned 0 as expected
# [RUN]           Checking some 64-bit only syscalls as 64 bit
# [OK]                x64 syscall 1073741823:19 returned 0 as expected
# [OK]                x64 syscall 1073741823:20 returned 0 as expected
# [RUN]           Checking out of range system calls
# [OK]                x32 syscalls 1073741823:-64..-2 returned -ENOSYS as expected
# [OK]                x32 syscall 1073741823:-1 returned MODIFIED_BY_PTRACE as expected
# [OK]                x64 syscalls 1073741823:1073741760..1073741823 returned -ENOSYS as expected
# [OK]                x64 syscalls 1073741823:-64..-1 returned -ENOSYS as expected
# [OK]                x32 syscalls 1073741823:1073741759..1073741822 returned -ENOSYS as expected
# [RUN]           Checking for absence of x32 system calls
# [OK]                x32 syscalls 1073741823:0..999 returned -ENOSYS as expected
# [RUN]       Checking system calls with msb = -1073741824 (0xc0000000)
# [RUN]           Checking some common syscalls as 64 bit
# [OK]                x64 syscall -1073741824:0 returned 0 as expected
# [OK]                x64 syscall -1073741824:1 returned 0 as expected
# [RUN]           Checking some 64-bit only syscalls as 64 bit
# [OK]                x64 syscall -1073741824:19 returned 0 as expected
# [OK]                x64 syscall -1073741824:20 returned 0 as expected
# [RUN]           Checking out of range system calls
# [OK]                x32 syscalls -1073741824:-64..-2 returned -ENOSYS as expected
# [OK]                x32 syscall -1073741824:-1 returned MODIFIED_BY_PTRACE as expected
# [OK]                x64 syscalls -1073741824:1073741760..1073741823 returned -ENOSYS as expected
# [OK]                x64 syscalls -1073741824:-64..-1 returned -ENOSYS as expected
# [OK]                x32 syscalls -1073741824:1073741759..1073741822 returned -ENOSYS as expected
# [RUN]           Checking for absence of x32 system calls
# [OK]                x32 syscalls -1073741824:0..999 returned -ENOSYS as expected
# [RUN]       Checking system calls with msb = 2147483647 (0x7fffffff)
# [RUN]           Checking some common syscalls as 64 bit
# [OK]                x64 syscall 2147483647:0 returned 0 as expected
# [OK]                x64 syscall 2147483647:1 returned 0 as expected
# [RUN]           Checking some 64-bit only syscalls as 64 bit
# [OK]                x64 syscall 2147483647:19 returned 0 as expected
# [OK]                x64 syscall 2147483647:20 returned 0 as expected
# [RUN]           Checking out of range system calls
# [OK]                x32 syscalls 2147483647:-64..-2 returned -ENOSYS as expected
# [OK]                x32 syscall 2147483647:-1 returned MODIFIED_BY_PTRACE as expected
# [OK]                x64 syscalls 2147483647:1073741760..1073741823 returned -ENOSYS as expected
# [OK]                x64 syscalls 2147483647:-64..-1 returned -ENOSYS as expected
# [OK]                x32 syscalls 2147483647:1073741759..1073741822 returned -ENOSYS as expected
# [RUN]           Checking for absence of x32 system calls
# [OK]                x32 syscalls 2147483647:0..999 returned -ENOSYS as expected
# [RUN]       Checking system calls with msb = -2147483648 (0x80000000)
# [RUN]           Checking some common syscalls as 64 bit
# [OK]                x64 syscall -2147483648:0 returned 0 as expected
# [OK]                x64 syscall -2147483648:1 returned 0 as expected
# [RUN]           Checking some 64-bit only syscalls as 64 bit
# [OK]                x64 syscall -2147483648:19 returned 0 as expected
# [OK]                x64 syscall -2147483648:20 returned 0 as expected
# [RUN]           Checking out of range system calls
# [OK]                x32 syscalls -2147483648:-64..-2 returned -ENOSYS as expected
# [OK]                x32 syscall -2147483648:-1 returned MODIFIED_BY_PTRACE as expected
# [OK]                x64 syscalls -2147483648:1073741760..1073741823 returned -ENOSYS as expected
# [OK]                x64 syscalls -2147483648:-64..-1 returned -ENOSYS as expected
# [OK]                x32 syscalls -2147483648:1073741759..1073741822 returned -ENOSYS as expected
# [RUN]           Checking for absence of x32 system calls
# [OK]                x32 syscalls -2147483648:0..999 returned -ENOSYS as expected
# [RUN]       Checking system calls with msb = -2147483647 (0x80000001)
# [RUN]           Checking some common syscalls as 64 bit
# [OK]                x64 syscall -2147483647:0 returned 0 as expected
# [OK]                x64 syscall -2147483647:1 returned 0 as expected
# [RUN]           Checking some 64-bit only syscalls as 64 bit
# [OK]                x64 syscall -2147483647:19 returned 0 as expected
# [OK]                x64 syscall -2147483647:20 returned 0 as expected
# [RUN]           Checking out of range system calls
# [OK]                x32 syscalls -2147483647:-64..-2 returned -ENOSYS as expected
# [OK]                x32 syscall -2147483647:-1 returned MODIFIED_BY_PTRACE as expected
# [OK]                x64 syscalls -2147483647:1073741760..1073741823 returned -ENOSYS as expected
# [OK]                x64 syscalls -2147483647:-64..-1 returned -ENOSYS as expected
# [OK]                x32 syscalls -2147483647:1073741759..1073741822 returned -ENOSYS as expected
# [RUN]           Checking for absence of x32 system calls
# [OK]                x32 syscalls -2147483647:0..999 returned -ENOSYS as expected
# [RUN]   Running tests under ptrace: clobbering the top 32 bits
# [RUN]       Checking system calls with msb = 0 (0x0)
# [RUN]           Checking some common syscalls as 64 bit
# [OK]                x64 syscall 0:0 returned 0 as expected
# [OK]                x64 syscall 0:1 returned 0 as expected
# [RUN]           Checking some 64-bit only syscalls as 64 bit
# [OK]                x64 syscall 0:19 returned 0 as expected
# [OK]                x64 syscall 0:20 returned 0 as expected
# [RUN]           Checking out of range system calls
# [OK]                x32 syscalls 0:-64..-2 returned -ENOSYS as expected
# [OK]                x32 syscall 0:-1 returned MODIFIED_BY_PTRACE as expected
# [OK]                x64 syscalls 0:1073741760..1073741823 returned -ENOSYS as expected
# [OK]                x64 syscalls 0:-64..-1 returned -ENOSYS as expected
# [OK]                x32 syscalls 0:1073741759..1073741822 returned -ENOSYS as expected
# [RUN]           Checking for absence of x32 system calls
# [OK]                x32 syscalls 0:0..999 returned -ENOSYS as expected
# [RUN]       Checking system calls with msb = 1 (0x1)
# [RUN]           Checking some common syscalls as 64 bit
# [OK]                x64 syscall 1:0 returned 0 as expected
# [OK]                x64 syscall 1:1 returned 0 as expected
# [RUN]           Checking some 64-bit only syscalls as 64 bit
# [OK]                x64 syscall 1:19 returned 0 as expected
# [OK]                x64 syscall 1:20 returned 0 as expected
# [RUN]           Checking out of range system calls
# [OK]                x32 syscalls 1:-64..-2 returned -ENOSYS as expected
# [OK]                x32 syscall 1:-1 returned MODIFIED_BY_PTRACE as expected
# [OK]                x64 syscalls 1:1073741760..1073741823 returned -ENOSYS as expected
# [OK]                x64 syscalls 1:-64..-1 returned -ENOSYS as expected
# [OK]                x32 syscalls 1:1073741759..1073741822 returned -ENOSYS as expected
# [RUN]           Checking for absence of x32 system calls
# [OK]                x32 syscalls 1:0..999 returned -ENOSYS as expected
# [RUN]       Checking system calls with msb = -1 (0xffffffff)
# [RUN]           Checking some common syscalls as 64 bit
# [OK]                x64 syscall -1:0 returned 0 as expected
# [OK]                x64 syscall -1:1 returned 0 as expected
# [RUN]           Checking some 64-bit only syscalls as 64 bit
# [OK]                x64 syscall -1:19 returned 0 as expected
# [OK]                x64 syscall -1:20 returned 0 as expected
# [RUN]           Checking out of range system calls
# [OK]                x32 syscalls -1:-64..-2 returned -ENOSYS as expected
# [OK]                x32 syscall -1:-1 returned MODIFIED_BY_PTRACE as expected
# [OK]                x64 syscalls -1:1073741760..1073741823 returned -ENOSYS as expected
# [OK]                x64 syscalls -1:-64..-1 returned -ENOSYS as expected
# [OK]                x32 syscalls -1:1073741759..1073741822 returned -ENOSYS as expected
# [RUN]           Checking for absence of x32 system calls
# [OK]                x32 syscalls -1:0..999 returned -ENOSYS as expected
# [RUN]       Checking system calls with msb = 1073741823 (0x3fffffff)
# [RUN]           Checking some common syscalls as 64 bit
# [OK]                x64 syscall 1073741823:0 returned 0 as expected
# [OK]                x64 syscall 1073741823:1 returned 0 as expected
# [RUN]           Checking some 64-bit only syscalls as 64 bit
# [OK]                x64 syscall 1073741823:19 returned 0 as expected
# [OK]                x64 syscall 1073741823:20 returned 0 as expected
# [RUN]           Checking out of range system calls
# [OK]                x32 syscalls 1073741823:-64..-2 returned -ENOSYS as expected
# [OK]                x32 syscall 1073741823:-1 returned MODIFIED_BY_PTRACE as expected
# [OK]                x64 syscalls 1073741823:1073741760..1073741823 returned -ENOSYS as expected
# [OK]                x64 syscalls 1073741823:-64..-1 returned -ENOSYS as expected
# [OK]                x32 syscalls 1073741823:1073741759..1073741822 returned -ENOSYS as expected
# [RUN]           Checking for absence of x32 system calls
# [OK]                x32 syscalls 1073741823:0..999 returned -ENOSYS as expected
# [RUN]       Checking system calls with msb = 1073741824 (0x40000000)
# [RUN]           Checking some common syscalls as 64 bit
# [OK]                x64 syscall 1073741824:0 returned 0 as expected
# [OK]                x64 syscall 1073741824:1 returned 0 as expected
# [RUN]           Checking some 64-bit only syscalls as 64 bit
# [OK]                x64 syscall 1073741824:19 returned 0 as expected
# [OK]                x64 syscall 1073741824:20 returned 0 as expected
# [RUN]           Checking out of range system calls
# [OK]                x32 syscalls 1073741824:-64..-2 returned -ENOSYS as expected
# [OK]                x32 syscall 1073741824:-1 returned MODIFIED_BY_PTRACE as expected
# [OK]                x64 syscalls 1073741824:1073741760..1073741823 returned -ENOSYS as expected
# [OK]                x64 syscalls 1073741824:-64..-1 returned -ENOSYS as expected
# [OK]                x32 syscalls 1073741824:1073741759..1073741822 returned -ENOSYS as expected
# [RUN]           Checking for absence of x32 system calls
# [OK]                x32 syscalls 1073741824:0..999 returned -ENOSYS as expected
# [RUN]       Checking system calls with msb = 1073741823 (0x3fffffff)
# [RUN]           Checking some common syscalls as 64 bit
# [OK]                x64 syscall 1073741823:0 returned 0 as expected
# [OK]                x64 syscall 1073741823:1 returned 0 as expected
# [RUN]           Checking some 64-bit only syscalls as 64 bit
# [OK]                x64 syscall 1073741823:19 returned 0 as expected
# [OK]                x64 syscall 1073741823:20 returned 0 as expected
# [RUN]           Checking out of range system calls
# [OK]                x32 syscalls 1073741823:-64..-2 returned -ENOSYS as expected
# [OK]                x32 syscall 1073741823:-1 returned MODIFIED_BY_PTRACE as expected
# [OK]                x64 syscalls 1073741823:1073741760..1073741823 returned -ENOSYS as expected
# [OK]                x64 syscalls 1073741823:-64..-1 returned -ENOSYS as expected
# [OK]                x32 syscalls 1073741823:1073741759..1073741822 returned -ENOSYS as expected
# [RUN]           Checking for absence of x32 system calls
# [OK]                x32 syscalls 1073741823:0..999 returned -ENOSYS as expected
# [RUN]       Checking system calls with msb = -1073741824 (0xc0000000)
# [RUN]           Checking some common syscalls as 64 bit
# [OK]                x64 syscall -1073741824:0 returned 0 as expected
# [OK]                x64 syscall -1073741824:1 returned 0 as expected
# [RUN]           Checking some 64-bit only syscalls as 64 bit
# [OK]                x64 syscall -1073741824:19 returned 0 as expected
# [OK]                x64 syscall -1073741824:20 returned 0 as expected
# [RUN]           Checking out of range system calls
# [OK]                x32 syscalls -1073741824:-64..-2 returned -ENOSYS as expected
# [OK]                x32 syscall -1073741824:-1 returned MODIFIED_BY_PTRACE as expected
# [OK]                x64 syscalls -1073741824:1073741760..1073741823 returned -ENOSYS as expected
# [OK]                x64 syscalls -1073741824:-64..-1 returned -ENOSYS as expected
# [OK]                x32 syscalls -1073741824:1073741759..1073741822 returned -ENOSYS as expected
# [RUN]           Checking for absence of x32 system calls
# [OK]                x32 syscalls -1073741824:0..999 returned -ENOSYS as expected
# [RUN]       Checking system calls with msb = 2147483647 (0x7fffffff)
# [RUN]           Checking some common syscalls as 64 bit
# [OK]                x64 syscall 2147483647:0 returned 0 as expected
# [OK]                x64 syscall 2147483647:1 returned 0 as expected
# [RUN]           Checking some 64-bit only syscalls as 64 bit
# [OK]                x64 syscall 2147483647:19 returned 0 as expected
# [OK]                x64 syscall 2147483647:20 returned 0 as expected
# [RUN]           Checking out of range system calls
# [OK]                x32 syscalls 2147483647:-64..-2 returned -ENOSYS as expected
# [OK]                x32 syscall 2147483647:-1 returned MODIFIED_BY_PTRACE as expected
# [OK]                x64 syscalls 2147483647:1073741760..1073741823 returned -ENOSYS as expected
# [OK]                x64 syscalls 2147483647:-64..-1 returned -ENOSYS as expected
# [OK]                x32 syscalls 2147483647:1073741759..1073741822 returned -ENOSYS as expected
# [RUN]           Checking for absence of x32 system calls
# [OK]                x32 syscalls 2147483647:0..999 returned -ENOSYS as expected
# [RUN]       Checking system calls with msb = -2147483648 (0x80000000)
# [RUN]           Checking some common syscalls as 64 bit
# [OK]                x64 syscall -2147483648:0 returned 0 as expected
# [OK]                x64 syscall -2147483648:1 returned 0 as expected
# [RUN]           Checking some 64-bit only syscalls as 64 bit
# [OK]                x64 syscall -2147483648:19 returned 0 as expected
# [OK]                x64 syscall -2147483648:20 returned 0 as expected
# [RUN]           Checking out of range system calls
# [OK]                x32 syscalls -2147483648:-64..-2 returned -ENOSYS as expected
# [OK]                x32 syscall -2147483648:-1 returned MODIFIED_BY_PTRACE as expected
# [OK]                x64 syscalls -2147483648:1073741760..1073741823 returned -ENOSYS as expected
# [OK]                x64 syscalls -2147483648:-64..-1 returned -ENOSYS as expected
# [OK]                x32 syscalls -2147483648:1073741759..1073741822 returned -ENOSYS as expected
# [RUN]           Checking for absence of x32 system calls
# [OK]                x32 syscalls -2147483648:0..999 returned -ENOSYS as expected
# [RUN]       Checking system calls with msb = -2147483647 (0x80000001)
# [RUN]           Checking some common syscalls as 64 bit
# [OK]                x64 syscall -2147483647:0 returned 0 as expected
# [OK]                x64 syscall -2147483647:1 returned 0 as expected
# [RUN]           Checking some 64-bit only syscalls as 64 bit
# [OK]                x64 syscall -2147483647:19 returned 0 as expected
# [OK]                x64 syscall -2147483647:20 returned 0 as expected
# [RUN]           Checking out of range system calls
# [OK]                x32 syscalls -2147483647:-64..-2 returned -ENOSYS as expected
# [OK]                x32 syscall -2147483647:-1 returned MODIFIED_BY_PTRACE as expected
# [OK]                x64 syscalls -2147483647:1073741760..1073741823 returned -ENOSYS as expected
# [OK]                x64 syscalls -2147483647:-64..-1 returned -ENOSYS as expected
# [OK]                x32 syscalls -2147483647:1073741759..1073741822 returned -ENOSYS as expected
# [RUN]           Checking for absence of x32 system calls
# [OK]                x32 syscalls -2147483647:0..999 returned -ENOSYS as expected
# [RUN]   Running tests under ptrace: sign-extending the syscall number
# [RUN]       Checking system calls with msb = 0 (0x0)
# [RUN]           Checking some common syscalls as 64 bit
# [OK]                x64 syscall 0:0 returned 0 as expected
# [OK]                x64 syscall 0:1 returned 0 as expected
# [RUN]           Checking some 64-bit only syscalls as 64 bit
# [OK]                x64 syscall 0:19 returned 0 as expected
# [OK]                x64 syscall 0:20 returned 0 as expected
# [RUN]           Checking out of range system calls
# [OK]                x32 syscalls 0:-64..-2 returned -ENOSYS as expected
# [OK]                x32 syscall 0:-1 returned MODIFIED_BY_PTRACE as expected
# [OK]                x64 syscalls 0:1073741760..1073741823 returned -ENOSYS as expected
# [OK]                x64 syscalls 0:-64..-1 returned -ENOSYS as expected
# [OK]                x32 syscalls 0:1073741759..1073741822 returned -ENOSYS as expected
# [RUN]           Checking for absence of x32 system calls
# [OK]                x32 syscalls 0:0..999 returned -ENOSYS as expected
# [RUN]       Checking system calls with msb = 1 (0x1)
# [RUN]           Checking some common syscalls as 64 bit
# [OK]                x64 syscall 1:0 returned 0 as expected
# [OK]                x64 syscall 1:1 returned 0 as expected
# [RUN]           Checking some 64-bit only syscalls as 64 bit
# [OK]                x64 syscall 1:19 returned 0 as expected
# [OK]                x64 syscall 1:20 returned 0 as expected
# [RUN]           Checking out of range system calls
# [OK]                x32 syscalls 1:-64..-2 returned -ENOSYS as expected
# [OK]                x32 syscall 1:-1 returned MODIFIED_BY_PTRACE as expected
# [OK]                x64 syscalls 1:1073741760..1073741823 returned -ENOSYS as expected
# [OK]                x64 syscalls 1:-64..-1 returned -ENOSYS as expected
# [OK]                x32 syscalls 1:1073741759..1073741822 returned -ENOSYS as expected
# [RUN]           Checking for absence of x32 system calls
# [OK]                x32 syscalls 1:0..999 returned -ENOSYS as expected
# [RUN]       Checking system calls with msb = -1 (0xffffffff)
# [RUN]           Checking some common syscalls as 64 bit
# [OK]                x64 syscall -1:0 returned 0 as expected
# [OK]                x64 syscall -1:1 returned 0 as expected
# [RUN]           Checking some 64-bit only syscalls as 64 bit
# [OK]                x64 syscall -1:19 returned 0 as expected
# [OK]                x64 syscall -1:20 returned 0 as expected
# [RUN]           Checking out of range system calls
# [OK]                x32 syscalls -1:-64..-2 returned -ENOSYS as expected
# [OK]                x32 syscall -1:-1 returned MODIFIED_BY_PTRACE as expected
# [OK]                x64 syscalls -1:1073741760..1073741823 returned -ENOSYS as expected
# [OK]                x64 syscalls -1:-64..-1 returned -ENOSYS as expected
# [OK]                x32 syscalls -1:1073741759..1073741822 returned -ENOSYS as expected
# [RUN]           Checking for absence of x32 system calls
# [OK]                x32 syscalls -1:0..999 returned -ENOSYS as expected
# [RUN]       Checking system calls with msb = 1073741823 (0x3fffffff)
# [RUN]           Checking some common syscalls as 64 bit
# [OK]                x64 syscall 1073741823:0 returned 0 as expected
# [OK]                x64 syscall 1073741823:1 returned 0 as expected
# [RUN]           Checking some 64-bit only syscalls as 64 bit
# [OK]                x64 syscall 1073741823:19 returned 0 as expected
# [OK]                x64 syscall 1073741823:20 returned 0 as expected
# [RUN]           Checking out of range system calls
# [OK]                x32 syscalls 1073741823:-64..-2 returned -ENOSYS as expected
# [OK]                x32 syscall 1073741823:-1 returned MODIFIED_BY_PTRACE as expected
# [OK]                x64 syscalls 1073741823:1073741760..1073741823 returned -ENOSYS as expected
# [OK]                x64 syscalls 1073741823:-64..-1 returned -ENOSYS as expected
# [OK]                x32 syscalls 1073741823:1073741759..1073741822 returned -ENOSYS as expected
# [RUN]           Checking for absence of x32 system calls
# [OK]                x32 syscalls 1073741823:0..999 returned -ENOSYS as expected
# [RUN]       Checking system calls with msb = 1073741824 (0x40000000)
# [RUN]           Checking some common syscalls as 64 bit
# [OK]                x64 syscall 1073741824:0 returned 0 as expected
# [OK]                x64 syscall 1073741824:1 returned 0 as expected
# [RUN]           Checking some 64-bit only syscalls as 64 bit
# [OK]                x64 syscall 1073741824:19 returned 0 as expected
# [OK]                x64 syscall 1073741824:20 returned 0 as expected
# [RUN]           Checking out of range system calls
# [OK]                x32 syscalls 1073741824:-64..-2 returned -ENOSYS as expected
# [OK]                x32 syscall 1073741824:-1 returned MODIFIED_BY_PTRACE as expected
# [OK]                x64 syscalls 1073741824:1073741760..1073741823 returned -ENOSYS as expected
# [OK]                x64 syscalls 1073741824:-64..-1 returned -ENOSYS as expected
# [OK]                x32 syscalls 1073741824:1073741759..1073741822 returned -ENOSYS as expected
# [RUN]           Checking for absence of x32 system calls
# [OK]                x32 syscalls 1073741824:0..999 returned -ENOSYS as expected
# [RUN]       Checking system calls with msb = 1073741823 (0x3fffffff)
# [RUN]           Checking some common syscalls as 64 bit
# [OK]                x64 syscall 1073741823:0 returned 0 as expected
# [OK]                x64 syscall 1073741823:1 returned 0 as expected
# [RUN]           Checking some 64-bit only syscalls as 64 bit
# [OK]                x64 syscall 1073741823:19 returned 0 as expected
# [OK]                x64 syscall 1073741823:20 returned 0 as expected
# [RUN]           Checking out of range system calls
# [OK]                x32 syscalls 1073741823:-64..-2 returned -ENOSYS as expected
# [OK]                x32 syscall 1073741823:-1 returned MODIFIED_BY_PTRACE as expected
# [OK]                x64 syscalls 1073741823:1073741760..1073741823 returned -ENOSYS as expected
# [OK]                x64 syscalls 1073741823:-64..-1 returned -ENOSYS as expected
# [OK]                x32 syscalls 1073741823:1073741759..1073741822 returned -ENOSYS as expected
# [RUN]           Checking for absence of x32 system calls
# [OK]                x32 syscalls 1073741823:0..999 returned -ENOSYS as expected
# [RUN]       Checking system calls with msb = -1073741824 (0xc0000000)
# [RUN]           Checking some common syscalls as 64 bit
# [OK]                x64 syscall -1073741824:0 returned 0 as expected
# [OK]                x64 syscall -1073741824:1 returned 0 as expected
# [RUN]           Checking some 64-bit only syscalls as 64 bit
# [OK]                x64 syscall -1073741824:19 returned 0 as expected
# [OK]                x64 syscall -1073741824:20 returned 0 as expected
# [RUN]           Checking out of range system calls
# [OK]                x32 syscalls -1073741824:-64..-2 returned -ENOSYS as expected
# [OK]                x32 syscall -1073741824:-1 returned MODIFIED_BY_PTRACE as expected
# [OK]                x64 syscalls -1073741824:1073741760..1073741823 returned -ENOSYS as expected
# [OK]                x64 syscalls -1073741824:-64..-1 returned -ENOSYS as expected
# [OK]                x32 syscalls -1073741824:1073741759..1073741822 returned -ENOSYS as expected
# [RUN]           Checking for absence of x32 system calls
# [OK]                x32 syscalls -1073741824:0..999 returned -ENOSYS as expected
# [RUN]       Checking system calls with msb = 2147483647 (0x7fffffff)
# [RUN]           Checking some common syscalls as 64 bit
# [OK]                x64 syscall 2147483647:0 returned 0 as expected
# [OK]                x64 syscall 2147483647:1 returned 0 as expected
# [RUN]           Checking some 64-bit only syscalls as 64 bit
# [OK]                x64 syscall 2147483647:19 returned 0 as expected
# [OK]                x64 syscall 2147483647:20 returned 0 as expected
# [RUN]           Checking out of range system calls
# [OK]                x32 syscalls 2147483647:-64..-2 returned -ENOSYS as expected
# [OK]                x32 syscall 2147483647:-1 returned MODIFIED_BY_PTRACE as expected
# [OK]                x64 syscalls 2147483647:1073741760..1073741823 returned -ENOSYS as expected
# [OK]                x64 syscalls 2147483647:-64..-1 returned -ENOSYS as expected
# [OK]                x32 syscalls 2147483647:1073741759..1073741822 returned -ENOSYS as expected
# [RUN]           Checking for absence of x32 system calls
# [OK]                x32 syscalls 2147483647:0..999 returned -ENOSYS as expected
# [RUN]       Checking system calls with msb = -2147483648 (0x80000000)
# [RUN]           Checking some common syscalls as 64 bit
# [OK]                x64 syscall -2147483648:0 returned 0 as expected
# [OK]                x64 syscall -2147483648:1 returned 0 as expected
# [RUN]           Checking some 64-bit only syscalls as 64 bit
# [OK]                x64 syscall -2147483648:19 returned 0 as expected
# [OK]                x64 syscall -2147483648:20 returned 0 as expected
# [RUN]           Checking out of range system calls
# [OK]                x32 syscalls -2147483648:-64..-2 returned -ENOSYS as expected
# [OK]                x32 syscall -2147483648:-1 returned MODIFIED_BY_PTRACE as expected
# [OK]                x64 syscalls -2147483648:1073741760..1073741823 returned -ENOSYS as expected
# [OK]                x64 syscalls -2147483648:-64..-1 returned -ENOSYS as expected
# [OK]                x32 syscalls -2147483648:1073741759..1073741822 returned -ENOSYS as expected
# [RUN]           Checking for absence of x32 system calls
# [OK]                x32 syscalls -2147483648:0..999 returned -ENOSYS as expected
# [RUN]       Checking system calls with msb = -2147483647 (0x80000001)
# [RUN]           Checking some common syscalls as 64 bit
# [OK]                x64 syscall -2147483647:0 returned 0 as expected
# [OK]                x64 syscall -2147483647:1 returned 0 as expected
# [RUN]           Checking some 64-bit only syscalls as 64 bit
# [OK]                x64 syscall -2147483647:19 returned 0 as expected
# [OK]                x64 syscall -2147483647:20 returned 0 as expected
# [RUN]           Checking out of range system calls
# [OK]                x32 syscalls -2147483647:-64..-2 returned -ENOSYS as expected
# [OK]                x32 syscall -2147483647:-1 returned MODIFIED_BY_PTRACE as expected
# [OK]                x64 syscalls -2147483647:1073741760..1073741823 returned -ENOSYS as expected
# [OK]                x64 syscalls -2147483647:-64..-1 returned -ENOSYS as expected
# [OK]                x32 syscalls -2147483647:1073741759..1073741822 returned -ENOSYS as expected
# [RUN]           Checking for absence of x32 system calls
# [OK]                x32 syscalls -2147483647:0..999 returned -ENOSYS as expected
# [OK]    All system calls succeeded or failed as expected
ok 38 selftests: x86: syscall_numbering_64
# selftests: x86: corrupt_xstate_header_64
# [RUN]	Send ourselves a signal
# 	Wreck XSTATE header
# 	Got SIGSEGV
# [OK]	Back from the signal.  Now schedule.
# [RUN]	Send ourselves a signal
# 	Wreck XSTATE header
# 	Got SIGSEGV
# [OK]	Back from the signal.  Now schedule.
# [OK]	Back in the main thread.
ok 39 selftests: x86: corrupt_xstate_header_64
# selftests: x86: ldt_gdt_64
# [NOTE]	set_thread_area is available; will use GDT index 12
# [OK]	LDT entry 0 has AR 0x0040FB00 and limit 0x0000000A
# [OK]	LDT entry 0 has AR 0x00C0FB00 and limit 0x0000AFFF
# [OK]	LDT entry 1 is invalid
# [OK]	LDT entry 2 has AR 0x00C0FB00 and limit 0x0000AFFF
# [OK]	LDT entry 1 is invalid
# [OK]	LDT entry 2 has AR 0x00C0FB00 and limit 0x0000AFFF
# [OK]	LDT entry 2 has AR 0x00D0FB00 and limit 0x0000AFFF
# [OK]	LDT entry 2 has AR 0x00D07B00 and limit 0x0000AFFF
# [OK]	LDT entry 2 has AR 0x00907B00 and limit 0x0000AFFF
# [OK]	LDT entry 2 has AR 0x00D07300 and limit 0x0000AFFF
# [OK]	LDT entry 2 has AR 0x00D07100 and limit 0x0000AFFF
# [OK]	LDT entry 2 has AR 0x00D07500 and limit 0x0000AFFF
# [OK]	LDT entry 2 has AR 0x00507700 and limit 0x0000000A
# [OK]	LDT entry 2 has AR 0x00507F00 and limit 0x0000000A
# [OK]	LDT entry 2 has AR 0x00507D00 and limit 0x0000000A
# [OK]	LDT entry 2 has AR 0x00507B00 and limit 0x0000000A
# [OK]	LDT entry 2 has AR 0x00507900 and limit 0x0000000A
# [OK]	LDT entry 2 has AR 0x00507900 and limit 0x0000000A
# [RUN]	Test fork
# [OK]	LDT entry 2 has AR 0x00507900 and limit 0x0000000A
# [OK]	LDT entry 1 is invalid
# [OK]	LDT entry 0 is invalid
# [NOTE]	set_thread_area is available; will use GDT index 12
# [OK]	LDT entry 0 has AR 0x0040FB00 and limit 0x0000000A
# [OK]	LDT entry 0 has AR 0x00C0FB00 and limit 0x0000AFFF
# [OK]	LDT entry 1 is invalid
# [OK]	LDT entry 2 has AR 0x00C0FB00 and limit 0x0000AFFF
# [OK]	LDT entry 1 is invalid
# [OK]	LDT entry 2 has AR 0x00C0FB00 and limit 0x0000AFFF
# [OK]	LDT entry 2 has AR 0x00D0FB00 and limit 0x0000AFFF
# [OK]	LDT entry 2 has AR 0x00D07B00 and limit 0x0000AFFF
# [OK]	LDT entry 2 has AR 0x00907B00 and limit 0x0000AFFF
# [OK]	LDT entry 2 has AR 0x00D07300 and limit 0x0000AFFF
# [OK]	LDT entry 2 has AR 0x00D07100 and limit 0x0000AFFF
# [OK]	LDT entry 2 has AR 0x00D07500 and limit 0x0000AFFF
# [OK]	LDT entry 2 has AR 0x00507700 and limit 0x0000000A
# [OK]	LDT entry 2 has AR 0x00507F00 and limit 0x0000000A
# [OK]	LDT entry 2 has AR 0x00507D00 and limit 0x0000000A
# [OK]	LDT entry 2 has AR 0x00507B00 and limit 0x0000000A
# [OK]	LDT entry 2 has AR 0x00507900 and limit 0x0000000A
# [OK]	LDT entry 2 has AR 0x00507900 and limit 0x0000000A
# [RUN]	Test fork
# [OK]	Child succeeded
# [RUN]	Test size
# [DONE]	Size test
# [OK]	modify_ldt failure 22
# [OK]	LDT entry 0 has AR 0x0000F300 and limit 0x00000000
# [OK]	LDT entry 0 has AR 0x00007300 and limit 0x00000000
# [OK]	LDT entry 0 has AR 0x0000F100 and limit 0x00000000
# [OK]	LDT entry 0 has AR 0x00007300 and limit 0x00000000
# [OK]	LDT entry 0 has AR 0x00007100 and limit 0x00000001
# [OK]	LDT entry 0 has AR 0x00007100 and limit 0x00000000
# [OK]	LDT entry 0 is invalid
# [OK]	LDT entry 0 has AR 0x0040F300 and limit 0x000FFFFF
# [OK]	LDT entry 0 has AR 0x00C0F300 and limit 0xFFFFFFFF
# [OK]	LDT entry 0 has AR 0x00C0F100 and limit 0xFFFFFFFF
# [OK]	LDT entry 0 has AR 0x00C0F700 and limit 0xFFFFFFFF
# [OK]	LDT entry 0 has AR 0x00C0F500 and limit 0xFFFFFFFF
# [OK]	LDT entry 0 is invalid
# [RUN]	Cross-CPU LDT invalidation
# [OK]	All 5 iterations succeeded
# [RUN]	Test exec
# [OK]	LDT entry 0 has AR 0x0040FB00 and limit 0x0000002A
# [OK]	Child succeeded
# [OK]	Invalidate DS with set_thread_area: new DS = 0x0
# [OK]	Invalidate ES with set_thread_area: new ES = 0x0
# [OK]	Invalidate FS with set_thread_area: new FS = 0x0
# [OK]	New FSBASE was zero
# [OK]	Invalidate GS with set_thread_area: new GS = 0x0
# [OK]	New GSBASE was zero
ok 40 selftests: x86: ldt_gdt_64
# selftests: x86: ptrace_syscall_64
# [RUN]	Check int80 return regs
# [OK]	getpid() preserves regs
# [OK]	kill(getpid(), SIGUSR1) preserves regs
# [RUN]	ptrace-induced syscall restart
# [RUN]	SYSEMU
# [OK]	Initial nr and args are correct
# [RUN]	Restart the syscall (ip = 0x7f06c500df59)
# [OK]	Restarted nr and args are correct
# [RUN]	Change nr and args and restart the syscall (ip = 0x7f06c500df59)
# [OK]	Replacement nr and args are correct
# [OK]	Child exited cleanly
# [RUN]	kernel syscall restart under ptrace
# [RUN]	SYSCALL
# [OK]	Initial nr and args are correct
# [RUN]	SYSCALL
# [OK]	Args after SIGUSR1 are correct (ax = -514)
# [OK]	Child got SIGUSR1
# [RUN]	Step again
# [OK]	pause(2) restarted correctly
ok 41 selftests: x86: ptrace_syscall_64
make: Leaving directory '/usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-95e381b6095d0808a64ecbe36515cca2ea2df477/tools/testing/selftests/x86'

--jho1yZJdad60DJr+
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="job.yaml"

---
:#! jobs/kernel-selftests-x86.yaml:
suite: kernel-selftests
testcase: kernel-selftests
category: functional
kconfig: x86_64-rhel-8.3-kselftests
need_memory: 2G
need_cpu: 2
kernel-selftests:
  group: x86
kernel_cmdline: erst_disable
job_origin: kernel-selftests-x86.yaml
:#! queue options:
queue_cmdline_keys:
- branch
- commit
queue: bisect
testbox: lkp-kbl-nuc1
tbox_group: lkp-kbl-nuc1
submit_id: 618a2482e6a3eacb38ee3be6
job_file: "/lkp/jobs/scheduled/lkp-kbl-nuc1/kernel-selftests-x86-ucode=0xde-debian-10.4-x86_64-20200603.cgz-95e381b6095d0808a64ecbe36515cca2ea2df477-20211109-52024-1t7k0ws-0.yaml"
id: 9ab4b7722f896c902587eaec4d9aa047365603a9
queuer_version: "/lkp-src"
:#! hosts/lkp-kbl-nuc1:
model: Kaby Lake
nr_node: 1
nr_cpu: 4
memory: 32G
nr_sdd_partitions: 1
ssd_partitions: "/dev/disk/by-id/ata-INTEL_SSDSC2BB800G4_PHWL4171000W800RGN-part2"
swap_partitions:
rootfs_partition: "/dev/disk/by-id/ata-INTEL_SSDSC2BB800G4_PHWL4171000W800RGN-part1"
brand: Intel(R) Core(TM) i7-7567U CPU @ 3.50GHz
:#! include/category/functional:
kmsg:
heartbeat:
meminfo:
:#! include/queue/cyclic:
commit: 95e381b6095d0808a64ecbe36515cca2ea2df477
:#! include/testbox/lkp-kbl-nuc1:
netconsole_port: 6674
ucode: '0xde'
need_kconfig_hw:
- E1000E: y
- SATA_AHCI
- DRM_I915
:#! include/kernel-selftests:
need_kconfig:
- POSIX_TIMERS: y, v4.10-rc1
initrds:
- linux_headers
- linux_selftests
enqueue_time: 2021-11-09 15:34:26.689582641 +08:00
_id: 618a2482e6a3eacb38ee3be6
_rt: "/result/kernel-selftests/x86-ucode=0xde/lkp-kbl-nuc1/debian-10.4-x86_64-20200603.cgz/x86_64-rhel-8.3-kselftests/gcc-9/95e381b6095d0808a64ecbe36515cca2ea2df477"
:#! schedule options:
user: lkp
compiler: gcc-9
LKP_SERVER: internal-lkp-server
head_commit: e0d453ef5cd3bed98369fb0fc7d2c78bcb3d0e93
base_commit: 8bb7eca972ad531c9b149c0a51ab43a417385813
branch: linux-devel/devel-hourly-20211107-060923
rootfs: debian-10.4-x86_64-20200603.cgz
result_root: "/result/kernel-selftests/x86-ucode=0xde/lkp-kbl-nuc1/debian-10.4-x86_64-20200603.cgz/x86_64-rhel-8.3-kselftests/gcc-9/95e381b6095d0808a64ecbe36515cca2ea2df477/0"
scheduler_version: "/lkp/lkp/.src-20211109-153149"
arch: x86_64
max_uptime: 2100
initrd: "/osimage/debian/debian-10.4-x86_64-20200603.cgz"
bootloader_append:
- root=/dev/ram0
- user=lkp
- job=/lkp/jobs/scheduled/lkp-kbl-nuc1/kernel-selftests-x86-ucode=0xde-debian-10.4-x86_64-20200603.cgz-95e381b6095d0808a64ecbe36515cca2ea2df477-20211109-52024-1t7k0ws-0.yaml
- ARCH=x86_64
- kconfig=x86_64-rhel-8.3-kselftests
- branch=linux-devel/devel-hourly-20211107-060923
- commit=95e381b6095d0808a64ecbe36515cca2ea2df477
- BOOT_IMAGE=/pkg/linux/x86_64-rhel-8.3-kselftests/gcc-9/95e381b6095d0808a64ecbe36515cca2ea2df477/vmlinuz-5.15.0-rc7-02477-g95e381b6095d
- erst_disable
- max_uptime=2100
- RESULT_ROOT=/result/kernel-selftests/x86-ucode=0xde/lkp-kbl-nuc1/debian-10.4-x86_64-20200603.cgz/x86_64-rhel-8.3-kselftests/gcc-9/95e381b6095d0808a64ecbe36515cca2ea2df477/0
- LKP_SERVER=internal-lkp-server
- nokaslr
- selinux=0
- debug
- apic=debug
- sysrq_always_enabled
- rcupdate.rcu_cpu_stall_timeout=100
- net.ifnames=0
- printk.devkmsg=on
- panic=-1
- softlockup_panic=1
- nmi_watchdog=panic
- oops=panic
- load_ramdisk=2
- prompt_ramdisk=0
- drbd.minor_count=8
- systemd.log_level=err
- ignore_loglevel
- console=tty0
- earlyprintk=ttyS0,115200
- console=ttyS0,115200
- vga=normal
- rw
modules_initrd: "/pkg/linux/x86_64-rhel-8.3-kselftests/gcc-9/95e381b6095d0808a64ecbe36515cca2ea2df477/modules.cgz"
linux_headers_initrd: "/pkg/linux/x86_64-rhel-8.3-kselftests/gcc-9/95e381b6095d0808a64ecbe36515cca2ea2df477/linux-headers.cgz"
linux_selftests_initrd: "/pkg/linux/x86_64-rhel-8.3-kselftests/gcc-9/95e381b6095d0808a64ecbe36515cca2ea2df477/linux-selftests.cgz"
bm_initrd: "/osimage/deps/debian-10.4-x86_64-20200603.cgz/run-ipconfig_20200608.cgz,/osimage/deps/debian-10.4-x86_64-20200603.cgz/lkp_20210707.cgz,/osimage/deps/debian-10.4-x86_64-20200603.cgz/rsync-rootfs_20200608.cgz,/osimage/deps/debian-10.4-x86_64-20200603.cgz/kernel-selftests_20210920.cgz,/osimage/pkg/debian-10.4-x86_64-20200603.cgz/kernel-selftests-x86_64-c8c9111a-1_20210929.cgz,/osimage/deps/debian-10.4-x86_64-20200603.cgz/hw_20200715.cgz"
ucode_initrd: "/osimage/ucode/intel-ucode-20210222.cgz"
lkp_initrd: "/osimage/user/lkp/lkp-x86_64.cgz"
site: inn
:#! /lkp/lkp/.src-20211108-140416/include/site/inn:
LKP_CGI_PORT: 80
LKP_CIFS_PORT: 139
oom-killer:
watchdog:
:#! runtime status:
last_kernel: 4.20.0
schedule_notify_address:
:#! user overrides:
kernel: "/pkg/linux/x86_64-rhel-8.3-kselftests/gcc-9/95e381b6095d0808a64ecbe36515cca2ea2df477/vmlinuz-5.15.0-rc7-02477-g95e381b6095d"
dequeue_time: 2021-11-09 17:05:09.553310841 +08:00
:#! /lkp/lkp/.src-20211109-153149/include/site/inn:
job_state: finished
loadavg: 1.10 0.37 0.13 2/139 2071
start_time: '1636448792'
end_time: '1636448806'
version: "/lkp/lkp/.src-20211109-153227:2c15dde8:b40354345"

--jho1yZJdad60DJr+
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=reproduce

ln -sf /usr/bin/clang
ln -sf /usr/bin/llc
sed -i s/default_timeout=45/default_timeout=1200/ kselftest/runner.sh
make -C x86
make run_tests -C x86

--jho1yZJdad60DJr+--
