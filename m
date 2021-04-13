Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BDE7635E7DF
	for <lists+netdev@lfdr.de>; Tue, 13 Apr 2021 22:58:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232106AbhDMU63 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Apr 2021 16:58:29 -0400
Received: from mga09.intel.com ([134.134.136.24]:24077 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229733AbhDMU61 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 13 Apr 2021 16:58:27 -0400
IronPort-SDR: X0Cwj9qJE1+cc8AzsXDLGjnvd3KJAulRC4VDhMdVD8QPfXnPIQr+NMlAtuG1NMj6vdx2N0sZqg
 AZVxuCf+BVpQ==
X-IronPort-AV: E=McAfee;i="6200,9189,9953"; a="194609592"
X-IronPort-AV: E=Sophos;i="5.82,220,1613462400"; 
   d="txt'?scan'208";a="194609592"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Apr 2021 13:58:01 -0700
IronPort-SDR: f6an/vNNJZe4/5YxIuGmlRFfIB495sM2VEMiBWSLp4Kl01BPoe/zccnCC+z8D0e0mLUoLcPg32
 6lgVZAV4r7+A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.82,220,1613462400"; 
   d="txt'?scan'208";a="389159960"
Received: from irsmsx605.ger.corp.intel.com ([163.33.146.138])
  by fmsmga007.fm.intel.com with ESMTP; 13 Apr 2021 13:57:59 -0700
Received: from tjmaciei-mobl1.localnet (10.212.171.177) by
 IRSMSX605.ger.corp.intel.com (163.33.146.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Tue, 13 Apr 2021 21:57:57 +0100
From:   Thiago Macieira <thiago.macieira@intel.com>
To:     <netdev@vger.kernel.org>, Hayes Wang <hayeswang@realtek.com>
CC:     <linux-usb@vger.kernel.org>
Subject: rtl8152 / power management kernel hang
Date:   Tue, 13 Apr 2021 13:57:54 -0700
Message-ID: <7261663.lHksN3My1W@tjmaciei-mobl1>
Organization: Intel Corporation
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="nextPart5077689.KZWXoKE4AB"
Content-Transfer-Encoding: 7Bit
X-Originating-IP: [10.212.171.177]
X-ClientProxiedBy: orsmsx603.amr.corp.intel.com (10.22.229.16) To
 IRSMSX605.ger.corp.intel.com (163.33.146.138)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--nextPart5077689.KZWXoKE4AB
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"

This has been happening for at least a year but I've only now decided to 
report it.

Kernel 5.11.11
Symptom: 
- partial kernel freeze
- some kernel tasks end up in state D and never leave it
    (notably ipv6_addrconf)
- problem propagates as other userspace processes try to use
  networking, such as /sbin/ip trying to set the device down
- normal reboot impossible, Alt+SysRq,B is necessary

Steps to reproduce: use device for a few hours. I'm using it in a bonded 
connection, but I don't think that's a required condition.

Workaround: disable power management on the device via PowerTop before the 
problem occurs.

The one I had never noticed until now was this, showing up in dmesg right 
around the moment where the freeze happened:

usb 4-1.2: reset SuperSpeed Gen 1 USB device number 3 using xhci_hcd
r8152 4-1.2:1.0 eth0: Using pass-thru MAC addr <redacted>

This did not happen on yesterday's freeze (or at least didn't get logged 
before I had to force-reboot the system).

Alt+SysRq,w log:

sysrq: Show Blocked State
task:bash            state:D stack:    0 pid: 3202 ppid:  2624 flags:
0x00000004
Call Trace:
 __schedule+0x2cf/0x940
 schedule+0x46/0xb0
 rpm_resume+0x19c/0x7b0
 ? wait_woken+0x80/0x80
 pm_runtime_forbid+0x3f/0x60
 control_store+0x78/0x80
 kernfs_fop_write_iter+0x124/0x1b0
 new_sync_write+0x11c/0x1b0
 vfs_write+0x1bc/0x270
 ksys_write+0x5f/0xe0
 do_syscall_64+0x33/0x80
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
RIP: 0033:0x7ff4ddd74347
RSP: 002b:00007ffc2976efd8 EFLAGS: 00000246 ORIG_RAX: 0000000000000001
RAX: ffffffffffffffda RBX: 0000000000000003 RCX: 00007ff4ddd74347
RDX: 0000000000000003 RSI: 0000560e7ef48eb0 RDI: 0000000000000001
RBP: 0000560e7ef48eb0 R08: 000000000000000a R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000003
R13: 00007ff4dde47520 R14: 0000000000000003 R15: 00007ff4dde47700
task:kworker/2:1     state:D stack:    0 pid:394240 ppid:     2 flags:
0x00004000
Workqueue: events rtl_work_func_t [r8152]
Call Trace:
 __schedule+0x2cf/0x940
 schedule+0x46/0xb0
 rpm_resume+0x19c/0x7b0
 ? wait_woken+0x80/0x80
 rpm_resume+0x2e7/0x7b0
 ? netdev_info+0x6c/0x83
 __pm_runtime_resume+0x4a/0x80
 usb_autopm_get_interface+0x18/0x50 [usbcore]
 rtl8152_set_mac_address+0x50/0x1b0 [r8152]
 set_ethernet_addr.isra.0+0x72/0x80 [r8152]
 rtl8152_reset_resume+0x48/0x60 [r8152]
 usb_resume_interface.part.0.isra.0+0x3a/0xb0 [usbcore]
 usb_resume_both+0x103/0x180 [usbcore]
 ? usb_runtime_suspend+0x70/0x70 [usbcore]
 __rpm_callback+0x81/0x140
 rpm_callback+0x4f/0x70
 ? usb_runtime_suspend+0x70/0x70 [usbcore]
 rpm_resume+0x509/0x7b0
 ? _cond_resched+0x16/0x40
 rpm_resume+0x2e7/0x7b0
 ? dequeue_entity+0xc6/0x460
 ? newidle_balance+0x285/0x3d0
 __pm_runtime_resume+0x4a/0x80
 usb_autopm_get_interface+0x18/0x50 [usbcore]
 rtl_work_func_t+0x69/0x2d0 [r8152]
 process_one_work+0x1df/0x370
 worker_thread+0x50/0x400
 ? process_one_work+0x370/0x370
 kthread+0x11b/0x140
 ? __kthread_bind_mask+0x60/0x60
 ret_from_fork+0x22/0x30
task:kworker/2:3     state:D stack:    0 pid:400573 ppid:     2 flags:
0x00004000
Workqueue: events_long rtl_hw_phy_work_func_t [r8152]
Call Trace:
 __schedule+0x2cf/0x940
 schedule+0x46/0xb0
 rpm_resume+0x19c/0x7b0
 ? wait_woken+0x80/0x80
 rpm_resume+0x2e7/0x7b0
 __pm_runtime_resume+0x4a/0x80
 usb_autopm_get_interface+0x18/0x50 [usbcore]
 rtl_hw_phy_work_func_t+0x5e/0x590 [r8152]
 ? __switch_to_asm+0x42/0x70
 ? __switch_to+0x114/0x450
 ? __schedule+0x2d7/0x940
 process_one_work+0x1df/0x370
 worker_thread+0x50/0x400
 ? process_one_work+0x370/0x370
 kthread+0x11b/0x140
 ? __kthread_bind_mask+0x60/0x60
 ret_from_fork+0x22/0x30

See more logs attached, in case they contain more info

$ lsusb | grep Realtek
Bus 004 Device 003: ID 0bda:8153 Realtek Semiconductor Corp. RTL8153 Gigabit 
Ethernet Adapter
Bus 003 Device 003: ID 0bda:4014 Realtek Semiconductor Corp. USB Audio
Bus 001 Device 004: ID 0bda:5682 Realtek Semiconductor Corp. 
Integrated_Webcam_HD

-- 
Thiago Macieira - thiago.macieira (AT) intel.com
  Software Architect - Intel DPG Cloud Engineering

--nextPart5077689.KZWXoKE4AB
Content-Disposition: attachment; filename="lsusb-v.txt"
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"; name="lsusb-v.txt"

Bus 004 Device 003: ID 0bda:8153 Realtek Semiconductor Corp. RTL8153 Gigabit Ethernet Adapter
Couldn't open device, some information will be missing
Device Descriptor:
  bLength                18
  bDescriptorType         1
  bcdUSB               3.00
  bDeviceClass            0 
  bDeviceSubClass         0 
  bDeviceProtocol         0 
  bMaxPacketSize0         9
  idVendor           0x0bda Realtek Semiconductor Corp.
  idProduct          0x8153 RTL8153 Gigabit Ethernet Adapter
  bcdDevice           30.01
  iManufacturer           1 Realtek
  iProduct                2 USB 10/100/1000 LAN
  iSerial                 6 000001000000
  bNumConfigurations      2
  Configuration Descriptor:
    bLength                 9
    bDescriptorType         2
    wTotalLength       0x0039
    bNumInterfaces          1
    bConfigurationValue     1
    iConfiguration          0 
    bmAttributes         0xa0
      (Bus Powered)
      Remote Wakeup
    MaxPower              256mA
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        0
      bAlternateSetting       0
      bNumEndpoints           3
      bInterfaceClass       255 Vendor Specific Class
      bInterfaceSubClass    255 Vendor Specific Subclass
      bInterfaceProtocol      0 
      iInterface              0 
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x81  EP 1 IN
        bmAttributes            2
          Transfer Type            Bulk
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0400  1x 1024 bytes
        bInterval               0
        bMaxBurst               3
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x02  EP 2 OUT
        bmAttributes            2
          Transfer Type            Bulk
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0400  1x 1024 bytes
        bInterval               0
        bMaxBurst               3
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x83  EP 3 IN
        bmAttributes            3
          Transfer Type            Interrupt
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0002  1x 2 bytes
        bInterval               8
        bMaxBurst               0
  Configuration Descriptor:
    bLength                 9
    bDescriptorType         2
    wTotalLength       0x0062
    bNumInterfaces          2
    bConfigurationValue     2
    iConfiguration          0 
    bmAttributes         0xa0
      (Bus Powered)
      Remote Wakeup
    MaxPower              256mA
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        0
      bAlternateSetting       0
      bNumEndpoints           1
      bInterfaceClass         2 Communications
      bInterfaceSubClass      6 Ethernet Networking
      bInterfaceProtocol      0 
      iInterface              5 
      CDC Header:
        bcdCDC               1.10
      CDC Union:
        bMasterInterface        0
        bSlaveInterface         1 
      CDC Ethernet:
        iMacAddress                      3 (??)
        bmEthernetStatistics    0x00000000
        wMaxSegmentSize               1514
        wNumberMCFilters            0x0000
        bNumberPowerFilters              0
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x83  EP 3 IN
        bmAttributes            3
          Transfer Type            Interrupt
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0010  1x 16 bytes
        bInterval               8
        bMaxBurst               0
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        1
      bAlternateSetting       0
      bNumEndpoints           0
      bInterfaceClass        10 CDC Data
      bInterfaceSubClass      0 
      bInterfaceProtocol      0 
      iInterface              0 
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        1
      bAlternateSetting       1
      bNumEndpoints           2
      bInterfaceClass        10 CDC Data
      bInterfaceSubClass      0 
      bInterfaceProtocol      0 
      iInterface              4 
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x81  EP 1 IN
        bmAttributes            2
          Transfer Type            Bulk
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0400  1x 1024 bytes
        bInterval               0
        bMaxBurst               3
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x02  EP 2 OUT
        bmAttributes            2
          Transfer Type            Bulk
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0400  1x 1024 bytes
        bInterval               0
        bMaxBurst               3

--nextPart5077689.KZWXoKE4AB
Content-Disposition: attachment; filename="blockedstate-20210126.txt"
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="UTF-8"; name="blockedstate-20210126.txt"

sysrq: Show Blocked State
task:NetworkManager  state:D stack:    0 pid: 1427 ppid:     1 flags:0x00000000
Call Trace:
 __schedule+0x282/0x870
 schedule+0x46/0xb0
 rpm_resume+0x171/0x7c0
 ? wait_woken+0x80/0x80
 rpm_resume+0x30f/0x7c0
 __pm_runtime_resume+0x4a/0x80
 usb_autopm_get_interface+0x18/0x50 [usbcore]
 rtl8152_get_wol+0x1d/0x90 [r8152]
 dev_ethtool+0xac7/0x2860
 ? __mod_memcg_lruvec_state+0x21/0xe0
 ? kmem_cache_free+0x22a/0x410
 dev_ioctl+0x328/0x560
 sock_do_ioctl+0x9b/0x130
 ? mem_cgroup_css_from_page+0x1/0x20
 sock_ioctl+0x240/0x3b0
 __x64_sys_ioctl+0x83/0xb0
 do_syscall_64+0x33/0x80
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
RIP: 0033:0x7f69dfb553cb
RSP: 002b:00007fff5156ec58 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
RAX: ffffffffffffffda RBX: 00007fff5156ecd0 RCX: 00007f69dfb553cb
RDX: 00007fff5156ecf0 RSI: 0000000000008946 RDI: 0000000000000017
RBP: 00007fff5156ee40 R08: 0000000000000000 R09: 0032346162613638
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000007
R13: 0000000000000000 R14: 00007fff5156ecf0 R15: 00007fff5156ecd0
task:ntpd            state:D stack:    0 pid: 1473 ppid:     1 flags:0x00000004
Call Trace:
 __schedule+0x282/0x870
 schedule+0x46/0xb0
 schedule_preempt_disabled+0xa/0x10
 __mutex_lock.constprop.0+0x154/0x4b0
 ? rht_deferred_worker+0x420/0x420
 ? rtnl_fill_ifinfo+0x1290/0x1290
 __netlink_dump_start+0xbf/0x2c0
 rtnetlink_rcv_msg+0x281/0x380
 ? rtnl_fill_ifinfo+0x1290/0x1290
 ? rtnl_calcit.isra.0+0x120/0x120
 netlink_rcv_skb+0x50/0xf0
 netlink_unicast+0x201/0x2c0
 netlink_sendmsg+0x243/0x480
 sock_sendmsg+0x5e/0x60
 __sys_sendto+0xee/0x150
 ? __sys_socket+0x98/0xf0
 __x64_sys_sendto+0x25/0x30
 do_syscall_64+0x33/0x80
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
RIP: 0033:0x7fb98535efba
RSP: 002b:00007ffd312bdad8 EFLAGS: 00000246 ORIG_RAX: 000000000000002c
RAX: ffffffffffffffda RBX: 00007ffd312bec30 RCX: 00007fb98535efba
RDX: 0000000000000014 RSI: 00007ffd312beb70 RDI: 0000000000000005
RBP: 00007ffd312bebc0 R08: 00007ffd312beb30 R09: 000000000000000c
R10: 0000000000000000 R11: 0000000000000246 R12: 00007ffd312beb30
R13: 00007ffd312beb70 R14: 0000556700d5fb30 R15: 00000000000003f4
task:Qt bearer threa state:D stack:    0 pid: 1955 ppid:     1 flags:0x00000000
Call Trace:
 __schedule+0x282/0x870
 schedule+0x46/0xb0
 schedule_preempt_disabled+0xa/0x10
 __mutex_lock.constprop.0+0x154/0x4b0
 ? rht_deferred_worker+0x420/0x420
 ? rtnl_fill_ifinfo+0x1290/0x1290
 __netlink_dump_start+0xbf/0x2c0
 rtnetlink_rcv_msg+0x281/0x380
 ? inet6_dump_addr+0x166/0x290
 ? rtnl_fill_ifinfo+0x1290/0x1290
 ? rtnl_calcit.isra.0+0x120/0x120
 netlink_rcv_skb+0x50/0xf0
 netlink_unicast+0x201/0x2c0
 netlink_sendmsg+0x243/0x480
 sock_sendmsg+0x5e/0x60
 __sys_sendto+0xee/0x150
 ? sock_setsockopt+0xfa/0xf40
 ? __sys_setsockopt+0x11c/0x1e0
 __x64_sys_sendto+0x25/0x30
 do_syscall_64+0x33/0x80
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
RIP: 0033:0x7f5d95f7eeac
RSP: 002b:00007f5d79ff9d10 EFLAGS: 00000246 ORIG_RAX: 000000000000002c
RAX: ffffffffffffffda RBX: 000000000000001e RCX: 00007f5d95f7eeac
RDX: 0000000000000020 RSI: 00007f5d79ff9db0 RDI: 000000000000001e
RBP: 0000000000000000 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 00007f5d79ff9e78
R13: 000000000000000a R14: 00007f5d640d5ce8 R15: 00007f5d88799660
task:Qt bearer threa state:D stack:    0 pid: 1939 ppid:     1 flags:0x00000000
Call Trace:
 __schedule+0x282/0x870
 schedule+0x46/0xb0
 schedule_preempt_disabled+0xa/0x10
 __mutex_lock.constprop.0+0x154/0x4b0
 ? rht_deferred_worker+0x420/0x420
 ? rtnl_fill_ifinfo+0x1290/0x1290
 __netlink_dump_start+0xbf/0x2c0
 rtnetlink_rcv_msg+0x281/0x380
 ? inet6_dump_addr+0x166/0x290
 ? rtnl_fill_ifinfo+0x1290/0x1290
 ? rtnl_calcit.isra.0+0x120/0x120
 netlink_rcv_skb+0x50/0xf0
 netlink_unicast+0x201/0x2c0
 netlink_sendmsg+0x243/0x480
 sock_sendmsg+0x5e/0x60
 __sys_sendto+0xee/0x150
 ? sock_setsockopt+0xfa/0xf40
 ? __sys_setsockopt+0x11c/0x1e0
 __x64_sys_sendto+0x25/0x30
 do_syscall_64+0x33/0x80
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
RIP: 0033:0x7f2525c26eac
RSP: 002b:00007f251adeccd0 EFLAGS: 00000246 ORIG_RAX: 000000000000002c
RAX: ffffffffffffffda RBX: 000000000000000b RCX: 00007f2525c26eac
RDX: 0000000000000020 RSI: 00007f251adecd70 RDI: 000000000000000b
RBP: 0000000000000000 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 00007f251adece38
R13: 000000000000000a R14: 00007f250c0d93d8 R15: 00007f2521c92660
task:Qt bearer threa state:D stack:    0 pid: 2594 ppid:  2026 flags:0x00000000
Call Trace:
 __schedule+0x282/0x870
 schedule+0x46/0xb0
 schedule_preempt_disabled+0xa/0x10
 __mutex_lock.constprop.0+0x154/0x4b0
 ? rht_deferred_worker+0x420/0x420
 ? rtnl_fill_ifinfo+0x1290/0x1290
 __netlink_dump_start+0xbf/0x2c0
 rtnetlink_rcv_msg+0x281/0x380
 ? inet6_dump_addr+0x166/0x290
 ? rtnl_fill_ifinfo+0x1290/0x1290
 ? rtnl_calcit.isra.0+0x120/0x120
 netlink_rcv_skb+0x50/0xf0
 netlink_unicast+0x201/0x2c0
 netlink_sendmsg+0x243/0x480
 sock_sendmsg+0x5e/0x60
 __sys_sendto+0xee/0x150
 ? sock_setsockopt+0xfa/0xf40
 ? __sys_setsockopt+0x11c/0x1e0
 __x64_sys_sendto+0x25/0x30
 do_syscall_64+0x33/0x80
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
RIP: 0033:0x7f45b6bbdeac
RSP: 002b:00007f45aaffbbd0 EFLAGS: 00000246 ORIG_RAX: 000000000000002c
RAX: ffffffffffffffda RBX: 000000000000000e RCX: 00007f45b6bbdeac
RDX: 0000000000000020 RSI: 00007f45aaffbc70 RDI: 000000000000000e
RBP: 0000000000000000 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 00007f45aaffbd38
R13: 000000000000000a R14: 00007f45a00d41c8 R15: 00007f45b23e3660
task:Qt bearer threa state:D stack:    0 pid: 2638 ppid:  2026 flags:0x00000000
Call Trace:
 __schedule+0x282/0x870
 schedule+0x46/0xb0
 schedule_preempt_disabled+0xa/0x10
 __mutex_lock.constprop.0+0x154/0x4b0
 ? rht_deferred_worker+0x420/0x420
 ? rtnl_fill_ifinfo+0x1290/0x1290
 __netlink_dump_start+0xbf/0x2c0
 rtnetlink_rcv_msg+0x281/0x380
 ? rtnl_fill_ifinfo+0x1290/0x1290
 ? rtnl_calcit.isra.0+0x120/0x120
 netlink_rcv_skb+0x50/0xf0
 netlink_unicast+0x201/0x2c0
 netlink_sendmsg+0x243/0x480
 sock_sendmsg+0x5e/0x60
 __sys_sendto+0xee/0x150
 ? sock_setsockopt+0xfa/0xf40
 ? __sys_setsockopt+0x11c/0x1e0
 __x64_sys_sendto+0x25/0x30
 do_syscall_64+0x33/0x80
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
RIP: 0033:0x7f662ad4beac
RSP: 002b:00007f661edecbd0 EFLAGS: 00000246 ORIG_RAX: 000000000000002c
RAX: ffffffffffffffda RBX: 0000000000000010 RCX: 00007f662ad4beac
RDX: 0000000000000020 RSI: 00007f661edecc70 RDI: 0000000000000010
RBP: 0000000000000000 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 00007f661edecd38
R13: 000000000000000a R14: 00007f660c0d42f8 R15: 00007f66264d0660
task:Qt bearer threa state:D stack:    0 pid: 2641 ppid:  2026 flags:0x00000000
Call Trace:
 __schedule+0x282/0x870
 schedule+0x46/0xb0
 schedule_preempt_disabled+0xa/0x10
 __mutex_lock.constprop.0+0x154/0x4b0
 ? rht_deferred_worker+0x420/0x420
 ? rtnl_fill_ifinfo+0x1290/0x1290
 __netlink_dump_start+0xbf/0x2c0
 rtnetlink_rcv_msg+0x281/0x380
 ? inet6_dump_addr+0x166/0x290
 ? rtnl_fill_ifinfo+0x1290/0x1290
 ? rtnl_calcit.isra.0+0x120/0x120
 netlink_rcv_skb+0x50/0xf0
 netlink_unicast+0x201/0x2c0
 netlink_sendmsg+0x243/0x480
 sock_sendmsg+0x5e/0x60
 __sys_sendto+0xee/0x150
 ? sock_setsockopt+0xfa/0xf40
 ? __sys_setsockopt+0x11c/0x1e0
 __x64_sys_sendto+0x25/0x30
 do_syscall_64+0x33/0x80
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
RIP: 0033:0x7fb44e9e8eac
RSP: 002b:00007fb4425ebbd0 EFLAGS: 00000246 ORIG_RAX: 000000000000002c
RAX: ffffffffffffffda RBX: 0000000000000011 RCX: 00007fb44e9e8eac
RDX: 0000000000000020 RSI: 00007fb4425ebc70 RDI: 0000000000000011
RBP: 0000000000000000 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 00007fb4425ebd38
R13: 000000000000000a R14: 00007fb4380d5708 R15: 00007fb44a16d660
task:Qt bearer threa state:D stack:    0 pid: 2655 ppid:  2026 flags:0x00000000
Call Trace:
 __schedule+0x282/0x870
 schedule+0x46/0xb0
 schedule_preempt_disabled+0xa/0x10
 __mutex_lock.constprop.0+0x154/0x4b0
 ? rht_deferred_worker+0x420/0x420
 ? rtnl_fill_ifinfo+0x1290/0x1290
 __netlink_dump_start+0xbf/0x2c0
 rtnetlink_rcv_msg+0x281/0x380
 ? inet6_dump_addr+0x166/0x290
 ? rtnl_fill_ifinfo+0x1290/0x1290
 ? rtnl_calcit.isra.0+0x120/0x120
 netlink_rcv_skb+0x50/0xf0
 netlink_unicast+0x201/0x2c0
 netlink_sendmsg+0x243/0x480
 sock_sendmsg+0x5e/0x60
 __sys_sendto+0xee/0x150
 ? sock_setsockopt+0xfa/0xf40
 ? __sys_setsockopt+0x11c/0x1e0
 __x64_sys_sendto+0x25/0x30
 do_syscall_64+0x33/0x80
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
RIP: 0033:0x7f6f01892eac
RSP: 002b:00007f6ef5ad5bd0 EFLAGS: 00000246 ORIG_RAX: 000000000000002c
RAX: ffffffffffffffda RBX: 000000000000000f RCX: 00007f6f01892eac
RDX: 0000000000000020 RSI: 00007f6ef5ad5c70 RDI: 000000000000000f
RBP: 0000000000000000 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 00007f6ef5ad5d38
R13: 000000000000000a R14: 00007f6eec0d34b8 R15: 00007f6efd017660
task:Qt bearer threa state:D stack:    0 pid: 2687 ppid:  2026 flags:0x00000000
Call Trace:
 __schedule+0x282/0x870
 schedule+0x46/0xb0
 schedule_preempt_disabled+0xa/0x10
 __mutex_lock.constprop.0+0x154/0x4b0
 ? rht_deferred_worker+0x420/0x420
 ? rtnl_fill_ifinfo+0x1290/0x1290
 __netlink_dump_start+0xbf/0x2c0
 rtnetlink_rcv_msg+0x281/0x380
 ? inet6_dump_addr+0x166/0x290
 ? rtnl_fill_ifinfo+0x1290/0x1290
 ? rtnl_calcit.isra.0+0x120/0x120
 netlink_rcv_skb+0x50/0xf0
 netlink_unicast+0x201/0x2c0
 netlink_sendmsg+0x243/0x480
 sock_sendmsg+0x5e/0x60
 __sys_sendto+0xee/0x150
 ? sock_setsockopt+0xfa/0xf40
 ? __sys_setsockopt+0x11c/0x1e0
 __x64_sys_sendto+0x25/0x30
 do_syscall_64+0x33/0x80
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
RIP: 0033:0x7f6d7a992eac
RSP: 002b:00007f6d6e5ebbd0 EFLAGS: 00000246 ORIG_RAX: 000000000000002c
RAX: ffffffffffffffda RBX: 000000000000000d RCX: 00007f6d7a992eac
RDX: 0000000000000020 RSI: 00007f6d6e5ebc70 RDI: 000000000000000d
RBP: 0000000000000000 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 00007f6d6e5ebd38
R13: 000000000000000a R14: 00007f6d640d3738 R15: 00007f6d745a9660
task:Qt bearer threa state:D stack:    0 pid: 2688 ppid:  2026 flags:0x00000000
Call Trace:
 __schedule+0x282/0x870
 schedule+0x46/0xb0
 schedule_preempt_disabled+0xa/0x10
 __mutex_lock.constprop.0+0x154/0x4b0
 ? rht_deferred_worker+0x420/0x420
 ? rtnl_fill_ifinfo+0x1290/0x1290
 __netlink_dump_start+0xbf/0x2c0
 rtnetlink_rcv_msg+0x281/0x380
 ? inet6_dump_addr+0x166/0x290
 ? rtnl_fill_ifinfo+0x1290/0x1290
 ? rtnl_calcit.isra.0+0x120/0x120
 netlink_rcv_skb+0x50/0xf0
 netlink_unicast+0x201/0x2c0
 netlink_sendmsg+0x243/0x480
 sock_sendmsg+0x5e/0x60
 __sys_sendto+0xee/0x150
 ? sock_setsockopt+0xfa/0xf40
 ? __sys_setsockopt+0x11c/0x1e0
 __x64_sys_sendto+0x25/0x30
 do_syscall_64+0x33/0x80
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
RIP: 0033:0x7fa6e6cfbeac
RSP: 002b:00007fa6dadecbd0 EFLAGS: 00000246 ORIG_RAX: 000000000000002c
RAX: ffffffffffffffda RBX: 000000000000000d RCX: 00007fa6e6cfbeac
RDX: 0000000000000020 RSI: 00007fa6dadecc70 RDI: 000000000000000d
RBP: 0000000000000000 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 00007fa6dadecd38
R13: 000000000000000a R14: 00007fa6c80d39a8 R15: 00007fa6e0111660
task:Qt bearer threa state:D stack:    0 pid: 2644 ppid:  2026 flags:0x00000000
Call Trace:
 __schedule+0x282/0x870
 schedule+0x46/0xb0
 schedule_preempt_disabled+0xa/0x10
 __mutex_lock.constprop.0+0x154/0x4b0
 ? rht_deferred_worker+0x420/0x420
 ? rtnl_fill_ifinfo+0x1290/0x1290
 __netlink_dump_start+0xbf/0x2c0
 rtnetlink_rcv_msg+0x281/0x380
 ? rtnl_fill_ifinfo+0x1290/0x1290
 ? rtnl_calcit.isra.0+0x120/0x120
 netlink_rcv_skb+0x50/0xf0
 netlink_unicast+0x201/0x2c0
 netlink_sendmsg+0x243/0x480
 sock_sendmsg+0x5e/0x60
 __sys_sendto+0xee/0x150
 ? sock_setsockopt+0xfa/0xf40
 ? __sys_setsockopt+0x11c/0x1e0
 __x64_sys_sendto+0x25/0x30
 do_syscall_64+0x33/0x80
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
RIP: 0033:0x7f8558a64eac
RSP: 002b:00007f8550e07bd0 EFLAGS: 00000246 ORIG_RAX: 000000000000002c
RAX: ffffffffffffffda RBX: 0000000000000012 RCX: 00007f8558a64eac
RDX: 0000000000000020 RSI: 00007f8550e07c70 RDI: 0000000000000012
RBP: 0000000000000000 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 00007f8550e07d38
R13: 000000000000000a R14: 00007f853c0d4068 R15: 00007f8553a19660
task:Qt bearer threa state:D stack:    0 pid: 2654 ppid:  2026 flags:0x00000000
Call Trace:
 __schedule+0x282/0x870
 schedule+0x46/0xb0
 schedule_preempt_disabled+0xa/0x10
 __mutex_lock.constprop.0+0x154/0x4b0
 ? rht_deferred_worker+0x420/0x420
 ? rtnl_fill_ifinfo+0x1290/0x1290
 __netlink_dump_start+0xbf/0x2c0
 rtnetlink_rcv_msg+0x281/0x380
 ? inet6_dump_addr+0x166/0x290
 ? rtnl_fill_ifinfo+0x1290/0x1290
 ? rtnl_calcit.isra.0+0x120/0x120
 netlink_rcv_skb+0x50/0xf0
 netlink_unicast+0x201/0x2c0
 netlink_sendmsg+0x243/0x480
 sock_sendmsg+0x5e/0x60
 __sys_sendto+0xee/0x150
 ? sock_setsockopt+0xfa/0xf40
 ? __sys_setsockopt+0x11c/0x1e0
 __x64_sys_sendto+0x25/0x30
 do_syscall_64+0x33/0x80
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
RIP: 0033:0x7fd655284eac
RSP: 002b:00007fd64d70abd0 EFLAGS: 00000246 ORIG_RAX: 000000000000002c
RAX: ffffffffffffffda RBX: 0000000000000011 RCX: 00007fd655284eac
RDX: 0000000000000020 RSI: 00007fd64d70ac70 RDI: 0000000000000011
RBP: 0000000000000000 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 00007fd64d70ad38
R13: 000000000000000a R14: 00007fd63c0d3618 R15: 00007fd650954660
task:Qt bearer threa state:D stack:    0 pid: 2651 ppid:  2026 flags:0x00000000
Call Trace:
 __schedule+0x282/0x870
 schedule+0x46/0xb0
 schedule_preempt_disabled+0xa/0x10
 __mutex_lock.constprop.0+0x154/0x4b0
 ? rht_deferred_worker+0x420/0x420
 ? rtnl_fill_ifinfo+0x1290/0x1290
 __netlink_dump_start+0xbf/0x2c0
 rtnetlink_rcv_msg+0x281/0x380
 ? inet6_dump_addr+0x166/0x290
 ? rtnl_fill_ifinfo+0x1290/0x1290
 ? rtnl_calcit.isra.0+0x120/0x120
 netlink_rcv_skb+0x50/0xf0
 netlink_unicast+0x201/0x2c0
 netlink_sendmsg+0x243/0x480
 sock_sendmsg+0x5e/0x60
 __sys_sendto+0xee/0x150
 ? sock_setsockopt+0xfa/0xf40
 ? __sys_setsockopt+0x11c/0x1e0
 __x64_sys_sendto+0x25/0x30
 do_syscall_64+0x33/0x80
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
RIP: 0033:0x7f26760f4eac
RSP: 002b:00007f266a72fbd0 EFLAGS: 00000246 ORIG_RAX: 000000000000002c
RAX: ffffffffffffffda RBX: 000000000000000e RCX: 00007f26760f4eac
RDX: 0000000000000020 RSI: 00007f266a72fc70 RDI: 000000000000000e
RBP: 0000000000000000 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 00007f266a72fd38
R13: 000000000000000a R14: 00007f26600d4e08 R15: 00007f267136e660
task:Qt bearer threa state:D stack:    0 pid: 2691 ppid:  2026 flags:0x00000000
Call Trace:
 __schedule+0x282/0x870
 schedule+0x46/0xb0
 schedule_preempt_disabled+0xa/0x10
 __mutex_lock.constprop.0+0x154/0x4b0
 ? rht_deferred_worker+0x420/0x420
 ? rtnl_fill_ifinfo+0x1290/0x1290
 __netlink_dump_start+0xbf/0x2c0
 rtnetlink_rcv_msg+0x281/0x380
 ? inet6_dump_addr+0x166/0x290
 ? rtnl_fill_ifinfo+0x1290/0x1290
 ? rtnl_calcit.isra.0+0x120/0x120
 netlink_rcv_skb+0x50/0xf0
 netlink_unicast+0x201/0x2c0
 netlink_sendmsg+0x243/0x480
 sock_sendmsg+0x5e/0x60
 __sys_sendto+0xee/0x150
 ? sock_setsockopt+0xfa/0xf40
 ? __sys_setsockopt+0x11c/0x1e0
 __x64_sys_sendto+0x25/0x30
 do_syscall_64+0x33/0x80
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
RIP: 0033:0x7fc3c1223eac
RSP: 002b:00007fc396ffb4d0 EFLAGS: 00000246 ORIG_RAX: 000000000000002c
RAX: ffffffffffffffda RBX: 0000000000000010 RCX: 00007fc3c1223eac
RDX: 0000000000000020 RSI: 00007fc396ffb570 RDI: 0000000000000010
RBP: 0000000000000000 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 00007fc396ffb638
R13: 000000000000000a R14: 00007fc3880d4838 R15: 00007fc3ac0fe660
task:DNS Res~ver #17 state:D stack:    0 pid:711461 ppid:  1807 flags:0x00000004
Call Trace:
 __schedule+0x282/0x870
 schedule+0x46/0xb0
 schedule_preempt_disabled+0xa/0x10
 __mutex_lock.constprop.0+0x154/0x4b0
 ? __switch_to+0x114/0x450
 ? rht_deferred_worker+0x420/0x420
 ? validate_linkmsg+0x130/0x130
 __netlink_dump_start+0xbf/0x2c0
 rtnetlink_rcv_msg+0x281/0x380
 ? validate_linkmsg+0x130/0x130
 ? rtnl_calcit.isra.0+0x120/0x120
 netlink_rcv_skb+0x50/0xf0
 netlink_unicast+0x201/0x2c0
 netlink_sendmsg+0x243/0x480
 sock_sendmsg+0x5e/0x60
 __sys_sendto+0xee/0x150
 ? __sys_socket+0x98/0xf0
 __x64_sys_sendto+0x25/0x30
 do_syscall_64+0x33/0x80
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
RIP: 0033:0x7f6ebab2b014
RSP: 002b:00007f6e9692feb0 EFLAGS: 00000293 ORIG_RAX: 000000000000002c
RAX: ffffffffffffffda RBX: 00007f6e96930fe0 RCX: 00007f6ebab2b014
RDX: 0000000000000014 RSI: 00007f6e96930fe0 RDI: 0000000000000050
RBP: 0000000000000000 R08: 00007f6e96930f84 R09: 000000000000000c
R10: 0000000000000000 R11: 0000000000000293 R12: 00007f6e96930f84
R13: 00000000862f8d6c R14: 0000000000000050 R15: 00007f6e2d3f2990
task:Qt bearer threa state:D stack:    0 pid: 3183 ppid:  2745 flags:0x00000004
Call Trace:
 __schedule+0x282/0x870
 schedule+0x46/0xb0
 schedule_preempt_disabled+0xa/0x10
 __mutex_lock.constprop.0+0x154/0x4b0
 ? rht_deferred_worker+0x420/0x420
 ? rtnl_fill_ifinfo+0x1290/0x1290
 __netlink_dump_start+0xbf/0x2c0
 rtnetlink_rcv_msg+0x281/0x380
 ? inet6_dump_addr+0x166/0x290
 ? rtnl_fill_ifinfo+0x1290/0x1290
 ? rtnl_calcit.isra.0+0x120/0x120
 netlink_rcv_skb+0x50/0xf0
 netlink_unicast+0x201/0x2c0
 netlink_sendmsg+0x243/0x480
 sock_sendmsg+0x5e/0x60
 __sys_sendto+0xee/0x150
 ? sock_setsockopt+0xfa/0xf40
 ? __sys_setsockopt+0x11c/0x1e0
 __x64_sys_sendto+0x25/0x30
 do_syscall_64+0x33/0x80
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
RIP: 0033:0x7fedd8974eac
RSP: 002b:00007fedc11ef4d0 EFLAGS: 00000246 ORIG_RAX: 000000000000002c
RAX: ffffffffffffffda RBX: 0000000000000063 RCX: 00007fedd8974eac
RDX: 0000000000000020 RSI: 00007fedc11ef570 RDI: 0000000000000063
RBP: 0000000000000000 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 00007fedc11ef638
R13: 000000000000000a R14: 00007feda40d56c8 R15: 00007fedc81b4660
task:ThreadPoolSingl state:D stack:    0 pid:732179 ppid:  2745 flags:0x00004002
Call Trace:
 __schedule+0x282/0x870
 ? __wake_up_common+0x7a/0x140
 schedule+0x46/0xb0
 schedule_preempt_disabled+0xa/0x10
 __mutex_lock.constprop.0+0x154/0x4b0
 ip_mc_drop_socket+0x2f/0xb0
 inet_release+0x29/0x80
 __sock_release+0x3d/0xa0
 sock_close+0x11/0x20
 __fput+0x9d/0x240
 task_work_run+0x65/0xa0
 do_exit+0x338/0x9f0
 ? finish_task_switch+0x206/0x270
 do_group_exit+0x33/0xa0
 get_signal+0x161/0x8a0
 arch_do_signal+0x30/0x830
 ? hrtimer_nanosleep+0x9b/0x120
 ? __hrtimer_init+0xd0/0xd0
 exit_to_user_mode_prepare+0xd5/0x140
 syscall_exit_to_user_mode+0x2d/0x190
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
RIP: 0033:0x7f5a58672901
RSP: 002b:00007f5a4e2526e0 EFLAGS: 00000293 ORIG_RAX: 00000000000000e6
RAX: fffffffffffffdfc RBX: 0000000000000000 RCX: 00007f5a58672901
RDX: 00007f5a4e252720 RSI: 0000000000000000 RDI: 0000000000000000
RBP: 00007f5a4e2527a0 R08: 0000000000000000 R09: 0ccccccccccccccc
R10: 0000000000000000 R11: 0000000000000293 R12: 0000000000000ce0
R13: 0000001afc700614 R14: 0000000000000010 R15: 0000000000004000
task:Chrome_ChildIOT state:D stack:    0 pid: 3304 ppid:732179 flags:0x00000004
Call Trace:
 __schedule+0x282/0x870
 schedule+0x46/0xb0
 schedule_preempt_disabled+0xa/0x10
 __mutex_lock.constprop.0+0x154/0x4b0
 ip_mc_drop_socket+0x2f/0xb0
 inet_release+0x29/0x80
 __sock_release+0x3d/0xa0
 sock_close+0x11/0x20
 __fput+0x9d/0x240
 task_work_run+0x65/0xa0
 exit_to_user_mode_prepare+0x120/0x140
 syscall_exit_to_user_mode+0x2d/0x190
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
RIP: 0033:0x7f3f0876017b
RSP: 002b:00007f3f03262860 EFLAGS: 00000293 ORIG_RAX: 0000000000000003
RAX: 0000000000000000 RBX: 0000383f91231a88 RCX: 00007f3f0876017b
RDX: 0000000000000002 RSI: 0000383f91012900 RDI: 0000000000000077
RBP: 00007f3f032628a0 R08: 0000000000000000 R09: 0000383f919b9000
R10: 00007f3f03262830 R11: 0000000000000293 R12: 0000383f908a4c00
R13: 0000000000000002 R14: 0000000000000000 R15: 0000383f90a2aed8
task:ThreadPoolForeg state:D stack:    0 pid:724220 ppid:732179 flags:0x00000004
Call Trace:
 __schedule+0x282/0x870
 schedule+0x46/0xb0
 schedule_preempt_disabled+0xa/0x10
 __mutex_lock.constprop.0+0x154/0x4b0
 ? __switch_to+0x114/0x450
 ? rht_deferred_worker+0x420/0x420
 ? validate_linkmsg+0x130/0x130
 __netlink_dump_start+0xbf/0x2c0
 rtnetlink_rcv_msg+0x281/0x380
 ? validate_linkmsg+0x130/0x130
 ? rtnl_calcit.isra.0+0x120/0x120
 netlink_rcv_skb+0x50/0xf0
 netlink_unicast+0x201/0x2c0
 netlink_sendmsg+0x243/0x480
 sock_sendmsg+0x5e/0x60
 __sys_sendto+0xee/0x150
 ? __sys_socket+0x98/0xf0
 __x64_sys_sendto+0x25/0x30
 do_syscall_64+0x33/0x80
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
RIP: 0033:0x7f3f070a5014
RSP: 002b:00007f3f00fc07b0 EFLAGS: 00000293 ORIG_RAX: 000000000000002c
RAX: ffffffffffffffda RBX: 00007f3f00fc18e0 RCX: 00007f3f070a5014
RDX: 0000000000000014 RSI: 00007f3f00fc18e0 RDI: 000000000000001b
RBP: 0000000000000000 R08: 00007f3f00fc1884 R09: 000000000000000c
R10: 0000000000000000 R11: 0000000000000293 R12: 00007f3f00fc1884
R13: 000000009d449eb6 R14: 000000000000001b R15: 00007f3f00fc1fb0
task:ThreadPoolForeg state:D stack:    0 pid:728256 ppid:732179 flags:0x00000004
Call Trace:
 __schedule+0x282/0x870
 schedule+0x46/0xb0
 schedule_preempt_disabled+0xa/0x10
 __mutex_lock.constprop.0+0x154/0x4b0
 ? __switch_to+0x114/0x450
 ? rht_deferred_worker+0x420/0x420
 ? validate_linkmsg+0x130/0x130
 __netlink_dump_start+0xbf/0x2c0
 rtnetlink_rcv_msg+0x281/0x380
 ? validate_linkmsg+0x130/0x130
 ? rtnl_calcit.isra.0+0x120/0x120
 netlink_rcv_skb+0x50/0xf0
 netlink_unicast+0x201/0x2c0
 netlink_sendmsg+0x243/0x480
 sock_sendmsg+0x5e/0x60
 __sys_sendto+0xee/0x150
 ? alloc_file_pseudo+0xa3/0x110
 ? __sys_socket+0x98/0xf0
 __x64_sys_sendto+0x25/0x30
 do_syscall_64+0x33/0x80
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
RIP: 0033:0x7f3f087605c4
RSP: 002b:00007f3efee09ce0 EFLAGS: 00000293 ORIG_RAX: 000000000000002c
RAX: ffffffffffffffda RBX: 00007f3efee09d30 RCX: 00007f3f087605c4
RDX: 0000000000000011 RSI: 00007f3efee09d30 RDI: 0000000000000022
RBP: 0000000000000000 R08: 00007f3efee09d20 R09: 000000000000000c
R10: 0000000000000000 R11: 0000000000000293 R12: 00007f3efee0a180
R13: aaaaaaaaaaaaaaaa R14: 00007f3efee09d20 R15: 00007f3efee09f18
task:kworker/2:0     state:D stack:    0 pid:567581 ppid:     2 flags:0x00004000
Workqueue: pm pm_runtime_work
Call Trace:
 __schedule+0x282/0x870
 schedule+0x46/0xb0
 schedule_timeout+0x8b/0x140
 ? __next_timer_interrupt+0x100/0x100
 msleep+0x2a/0x40
 napi_disable+0x2b/0x70
 rtl8152_suspend+0x28f/0x330 [r8152]
 usb_suspend_both+0x9d/0x230 [usbcore]
 usb_runtime_suspend+0x2b/0x70 [usbcore]
 ? usb_autoresume_device+0x50/0x50 [usbcore]
 __rpm_callback+0xce/0x180
 rpm_callback+0x4f/0x70
 ? usb_autoresume_device+0x50/0x50 [usbcore]
 rpm_suspend+0x147/0x660
 ? __switch_to+0x114/0x450
 pm_runtime_work+0x8e/0x90
 process_one_work+0x1df/0x370
 worker_thread+0x50/0x400
 ? process_one_work+0x370/0x370
 kthread+0x11b/0x140
 ? __kthread_bind_mask+0x60/0x60
 ret_from_fork+0x22/0x30
task:kworker/u8:8    state:D stack:    0 pid:669401 ppid:     2 flags:0x00004000
Workqueue: kacpi_hotplug acpi_hotplug_work_fn
Call Trace:
 __schedule+0x282/0x870
 schedule+0x46/0xb0
 __pm_runtime_barrier+0xaa/0x170
 ? wait_woken+0x80/0x80
 pm_runtime_barrier+0x48/0x90
 usb_disconnect+0x6b/0x90 [usbcore]
 usb_disconnect.cold+0x28/0x20a [usbcore]
 usb_disconnect.cold+0x28/0x20a [usbcore]
 ? __mutex_lock.constprop.0+0x411/0x4b0
 usb_remove_hcd+0xdf/0x1d9 [usbcore]
 xhci_pci_remove+0x51/0xc0 [xhci_pci]
 pci_device_remove+0x3b/0xa0
 __device_release_driver+0x17a/0x230
 device_release_driver+0x24/0x30
 pci_stop_bus_device+0x68/0x90
 pci_stop_bus_device+0x2c/0x90
 pci_stop_bus_device+0x2c/0x90
 pci_stop_and_remove_bus_device+0xe/0x20
 disable_slot+0x49/0x90
 acpiphp_check_bridge.part.0+0xba/0x140
 acpiphp_hotplug_notify+0x170/0x280
 ? acpiphp_post_dock_fixup+0xe0/0xe0
 acpi_device_hotplug+0x9e/0x400
 acpi_hotplug_work_fn+0x3d/0x50
 process_one_work+0x1df/0x370
 worker_thread+0x50/0x400
 ? process_one_work+0x370/0x370
 kthread+0x11b/0x140
 ? __kthread_bind_mask+0x60/0x60
 ret_from_fork+0x22/0x30
task:tlp             state:D stack:    0 pid:679042 ppid:     1 flags:0x00000324
Call Trace:
 __schedule+0x282/0x870
 schedule+0x46/0xb0
 schedule_preempt_disabled+0xa/0x10
 __mutex_lock.constprop.0+0x154/0x4b0
 ? kernfs_fop_write+0x131/0x1b0
 control_store+0x23/0x80
 kernfs_fop_write+0xce/0x1b0
 vfs_write+0xc3/0x270
 ksys_write+0x5f/0xe0
 do_syscall_64+0x33/0x80
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
RIP: 0033:0x7f6d318ca357
RSP: 002b:00007ffe81914838 EFLAGS: 00000246 ORIG_RAX: 0000000000000001
RAX: ffffffffffffffda RBX: 0000000000000005 RCX: 00007f6d318ca357
RDX: 0000000000000005 RSI: 00005646488d42a0 RDI: 0000000000000001
RBP: 00005646488d42a0 R08: 000000000000000a R09: 000000000000005c
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000005
R13: 00007f6d3199d520 R14: 0000000000000005 R15: 00007f6d3199d720
task:kworker/0:1     state:D stack:    0 pid:728749 ppid:     2 flags:0x00004000
Workqueue: ipv6_addrconf addrconf_verify_work
Call Trace:
 __schedule+0x282/0x870
 ? sched_clock+0x5/0x10
 schedule+0x46/0xb0
 schedule_preempt_disabled+0xa/0x10
 __mutex_lock.constprop.0+0x154/0x4b0
 addrconf_verify_work+0xa/0x20
 process_one_work+0x1df/0x370
 worker_thread+0x50/0x400
 ? process_one_work+0x370/0x370
 kthread+0x11b/0x140
 ? __kthread_bind_mask+0x60/0x60
 ret_from_fork+0x22/0x30
task:systemd-sleep   state:D stack:    0 pid:731268 ppid:     1 flags:0x00004000
Call Trace:
 __schedule+0x282/0x870
 schedule+0x46/0xb0
 rpm_resume+0x171/0x7c0
 ? wait_woken+0x80/0x80
 rpm_resume+0x30f/0x7c0
 ? mgmt_send_event+0xc5/0x100 [bluetooth]
 __pm_runtime_resume+0x4a/0x80
 usb_autopm_get_interface+0x18/0x50 [usbcore]
 rtl_notifier+0x3d/0x40 [r8152]
 blocking_notifier_call_chain_robust+0x64/0xd0
 pm_notifier_call_chain_robust+0x19/0x40
 pm_suspend.cold+0x15c/0x374
 state_store+0x42/0x90
 kernfs_fop_write+0xce/0x1b0
 vfs_write+0xc3/0x270
 ksys_write+0x5f/0xe0
 do_syscall_64+0x33/0x80
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
RIP: 0033:0x7f6e61874357
RSP: 002b:00007ffc6233ce28 EFLAGS: 00000246 ORIG_RAX: 0000000000000001
RAX: ffffffffffffffda RBX: 0000000000000004 RCX: 00007f6e61874357
RDX: 0000000000000004 RSI: 00007ffc6233cf10 RDI: 0000000000000004
RBP: 00007ffc6233cf10 R08: 000055df5a254560 R09: 00007f6e6190b0c0
R10: 00007f6e6190afc0 R11: 0000000000000246 R12: 0000000000000004
R13: 000055df5a235410 R14: 0000000000000004 R15: 00007f6e61947720
task:pingsender      state:D stack:    0 pid:732175 ppid:711461 flags:0x00000000
Call Trace:
 __schedule+0x282/0x870
 ? page_add_new_anon_rmap+0xa3/0x1f0
 schedule+0x46/0xb0
 schedule_preempt_disabled+0xa/0x10
 __mutex_lock.constprop.0+0x154/0x4b0
 ? rht_deferred_worker+0x420/0x420
 ? validate_linkmsg+0x130/0x130
 __netlink_dump_start+0xbf/0x2c0
 rtnetlink_rcv_msg+0x281/0x380
 ? validate_linkmsg+0x130/0x130
 ? rtnl_calcit.isra.0+0x120/0x120
 netlink_rcv_skb+0x50/0xf0
 netlink_unicast+0x201/0x2c0
 netlink_sendmsg+0x243/0x480
 sock_sendmsg+0x5e/0x60
 __sys_sendto+0xee/0x150
 ? __sys_socket+0x98/0xf0
 __x64_sys_sendto+0x25/0x30
 do_syscall_64+0x33/0x80
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
RIP: 0033:0x7f080918d014
RSP: 002b:00007f0808311460 EFLAGS: 00000293 ORIG_RAX: 000000000000002c
RAX: ffffffffffffffda RBX: 00007f0808312590 RCX: 00007f080918d014
RDX: 0000000000000014 RSI: 00007f0808312590 RDI: 0000000000000007
RBP: 0000000000000000 R08: 00007f0808312534 R09: 000000000000000c
R10: 0000000000000000 R11: 0000000000000293 R12: 00007f0808312534
R13: 00000000000b2c0d R14: 0000000000000007 R15: 00007f0808312940
irssi[2126]: segfault at f8 ip 00007f8c7ed36d80 sp 00007fff60575550 error 4 in libc-2.32.so[7f8c7ecd0000+14f000]
Code: 66 2e 0f 1f 84 00 00 00 00 00 f3 0f 1e fa 48 83 ec 18 48 8b 05 71 71 13 00 48 8b 00 48 85 c0 0f 85 7d 00 00 00 48 85 ff 74 70 <48> 8b 47 f8 48 8d 77 f0 a8 02 75 34 48 8b 15 bd 6f 13 00 64 48 83
irssi[2108]: segfault at f8 ip 00007faa135f4d80 sp 00007fff8cf8f980 error 4 in libc-2.32.so[7faa1358e000+14f000]
Code: 66 2e 0f 1f 84 00 00 00 00 00 f3 0f 1e fa 48 83 ec 18 48 8b 05 71 71 13 00 48 8b 00 48 85 c0 0f 85 7d 00 00 00 48 85 ff 74 70 <48> 8b 47 f8 48 8d 77 f0 a8 02 75 34 48 8b 15 bd 6f 13 00 64 48 83
sysrq: Emergency Sync
Emergency Sync complete
sysrq: Emergency Remount R/O
EXT4-fs (nvme0n1p3): re-mounted. Opts: (null)
EXT4-fs (dm-8): re-mounted. Opts: (null)
EXT4-fs (dm-3): re-mounted. Opts: (null)
Emergency Remount complete
sysrq: Power Off
kvm: exiting hardware virtualization
sysrq: Emergency Sync

--nextPart5077689.KZWXoKE4AB
Content-Disposition: attachment; filename="timeout-20210323.txt"
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"; name="timeout-20210323.txt"

NETDEV WATCHDOG: eth0 (r8152): transmit queue 0 timed out
WARNING: CPU: 3 PID: 0 at net/sched/sch_generic.c:442 dev_watchdog+0x24d/0x260
Modules linked in: sha3_generic ses enclosure scsi_transport_sas uas usb_storage uinput hid_logitech_hi>
 dmi_sysfs nls_iso8859_1 nls_cp437 vfat snd_hda_codec_hdmi fat iwlmvm snd_hda_codec_realtek snd_hda_cod>
 intel_lpss idma64 intel_soc_dts_iosf intel_pch_thermal fan thermal tiny_power_button ac acpi_pad int34>
CPU: 3 PID: 0 Comm: swapper/3 Tainted: G        W IO      5.11.6-1-default #1 openSUSE Tumbleweed
Hardware name: Dell Inc. XPS 13 9350/09JHRY, BIOS 1.7.0 01/16/2018
RIP: 0010:dev_watchdog+0x24d/0x260
Code: 49 a5 fd ff eb a9 4c 89 f7 c6 05 93 a7 39 01 01 e8 c8 73 fa ff 44 89 e9 4c 89 f6 48 c7 c7 98 0e 3>
RSP: 0018:ffffb38a8018ceb8 EFLAGS: 00010286
RAX: 0000000000000000 RBX: ffff8c5e83579800 RCX: 0000000000000000
RDX: ffff8c61eedaace0 RSI: ffff8c61eed9ac00 RDI: 0000000000000300
RBP: ffff8c6027be23dc R08: ffffffffaeb4b698 R09: 0000000000009a79
R10: ffffffffaea6d120 R11: 3fffffffffffffff R12: ffff8c6027be2480
R13: 0000000000000000 R14: ffff8c6027be2000 R15: ffff8c5e83579880
FS:  0000000000000000(0000) GS:ffff8c61eed80000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 000039647ec95400 CR3: 0000000393410003 CR4: 00000000003706e0
Call Trace:
 <IRQ>
 ? pfifo_fast_enqueue+0x150/0x150
 call_timer_fn+0x29/0xf0
 __run_timers.part.0+0x1d7/0x240
 ? __hrtimer_run_queues+0x139/0x270
 ? recalibrate_cpu_khz+0x10/0x10
 ? ktime_get+0x38/0xa0
 ? lapic_next_deadline+0x28/0x30
 run_timer_softirq+0x26/0x50
 __do_softirq+0xc5/0x275
 asm_call_irq_on_stack+0x12/0x20
 </IRQ>
 do_softirq_own_stack+0x37/0x40
 irq_exit_rcu+0x8e/0xc0
 sysvec_apic_timer_interrupt+0x36/0x80
 asm_sysvec_apic_timer_interrupt+0x12/0x20
RIP: 0010:cpuidle_enter_state+0xc7/0x350
Code: 8b 3d ad 50 81 52 e8 18 5f 8d ff 49 89 c5 0f 1f 44 00 00 31 ff e8 09 75 8d ff 45 84 ff 0f 85 fa 0>
RSP: 0018:ffffb38a800e7ea8 EFLAGS: 00000246
RAX: ffff8c61eedae400 RBX: 0000000000000008 RCX: 000000000000001f
RDX: 0000000000000000 RSI: 0000000039f89620 RDI: 0000000000000000
RBP: ffff8c61eedb9700 R08: 00004bfbe4bb7a2e R09: 00004bfc0b322f5f
R10: 0000000000003dd1 R11: 0000000000001642 R12: ffffffffaebdd700
R13: 00004bfbe4bb7a2e R14: 0000000000000008 R15: 0000000000000000
 ? cpuidle_enter_state+0xb7/0x350
 cpuidle_enter+0x29/0x40
 do_idle+0x1ef/0x2b0
 cpu_startup_entry+0x19/0x20
 secondary_startup_64_no_verify+0xc2/0xcb
---[ end trace 1d61b6006c9f1f83 ]---
r8152 4-1.2:1.0 eth0: Tx timeout
r8152 4-1.2:1.0 eth0: Tx timeout

--nextPart5077689.KZWXoKE4AB--
