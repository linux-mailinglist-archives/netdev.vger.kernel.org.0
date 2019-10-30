Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D1245EA4F7
	for <lists+netdev@lfdr.de>; Wed, 30 Oct 2019 21:47:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726945AbfJ3Ury (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Oct 2019 16:47:54 -0400
Received: from mail-vs1-f54.google.com ([209.85.217.54]:44398 "EHLO
        mail-vs1-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726853AbfJ3Urx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Oct 2019 16:47:53 -0400
Received: by mail-vs1-f54.google.com with SMTP id j85so2583332vsd.11
        for <netdev@vger.kernel.org>; Wed, 30 Oct 2019 13:47:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=B+CI5ROaJZrTlPP/bvTxKR8sUWlwRxBXLcfE48Oj8lY=;
        b=ns3gPEEFn/v/pPrmWpY20tryRJtBgfIKtinpT6rZhPkMGt97f9AUrwPdbFyksTVHww
         hAV7CDogbbMkC3h+32ym+sNzSCZWUy2FachTyR07qs19j+WTFcvk/LjqYgSkii7UJjki
         mXGwD00x1hAP+WekyoIoUL7KiFJPqRxK5Aua/Fp4M8kDX+0xitUlQ2HOxdy8lLdqrtcy
         ckq2diHts8Ua46LWBHcc+TQU8PGGABHLlb4QALF7K8O4og21RgSyTCYzS2yk4N7AubDP
         PVotem/0UvZKROCQueR14/ATx+Auuc+sgo8DBYurgs3SVGf8rQvYhuRvkrXFDss4XwAR
         X1cQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=B+CI5ROaJZrTlPP/bvTxKR8sUWlwRxBXLcfE48Oj8lY=;
        b=UpyGqKOxjK4PEmtMeETzcyoBWoAuMamGmZUtht3GLlU0jpdCxLIEaKa1EpRzR9DltG
         MsoJKjdcvlNSNwg+djNfRLid2wNQ15BNZNXjfcnO0pC2ThjJESHR555G1XbRUwLQpP5O
         fwOReqzIXFy+o6zP1zYkU0i5+VNZWX5wRI67p9sMcqWDEuQswhUBQ7iawV4ebY/nQ2+v
         aOI3obuafKUYapm0adnf3gq9Jbd15HiCuVr/q/S4JfKyplHWw22QQs5+Cb4c6zQKpaM4
         gfWSqpKXxAB+XOfZIBCXdM2nZKi2e7+uYDh1ihwa+rADa6naz322q22K0Zh1ONfPXogC
         xpPw==
X-Gm-Message-State: APjAAAVjHkRUWT8vYs6blX5ysBKZYQXCjDj05TF6Gxyi87oeOnimkWJr
        WuNOIExAoIexVdwm4CICqBKLuQC+6HJX13BQdKLSRnthaoA=
X-Google-Smtp-Source: APXvYqxJc9rY42cc4Dv0uaExvvlaAuwQqi7kD7xpGZ7OvYTgIWZxznNoc8qniJG3lb0Nq71r32mbeXbPZGBTd3/uAmU=
X-Received: by 2002:a67:d20e:: with SMTP id y14mr946133vsi.16.1572468471200;
 Wed, 30 Oct 2019 13:47:51 -0700 (PDT)
MIME-Version: 1.0
From:   JD <jdtxs00@gmail.com>
Date:   Wed, 30 Oct 2019 15:47:40 -0500
Message-ID: <CAMnf+PjGq2qsZzg=+H5Z5kO+PSQbo=R0MHW5rv1CWrqoS=biqw@mail.gmail.com>
Subject: Followup: Kernel memory leak on 4.11+ & 5.3.x with IPsec
To:     netdev@vger.kernel.org
Cc:     steffen.klassert@secunet.com, herbert@gondor.apana.org.au
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello, this is a followup to my previous email I sent regarding a
kernel memory leak with IPsec.

After a lot of testing and narrowing down, I've figured out the leak
begins as of the kernel 4.11 release. It is still occurring in the
latest mainline kernel too.

For brief context, there's a kernel memory leak in IPsec where passing
traffic through the tunnel eats away at available memory and OOMkiller
kicks in.

This memory usage doesn't appear in slab or userspace. Nor is it
reclaimed by bringing down the tunnels, or unloading the respective
kernel modules.
The only way to get the memory back is by rebooting.

To keep things simple, here are some facts around the issue:
- It is definitely related to IPsec/xfrm in some way. The boxes I have
tested on are fresh installs, no other software or customization
whatsoever. Only used for IPsec tunnels.
- Memory can leak at a rate of ~150MB per day.
- The issue begins as of kernel 4.11.  Kernel 4.10 does not have this leak.
- You can only reproduce the problem by passing traffic through
multiple IPsec tunnels. Keeping the tunnels idle does not eat away at
memory.
- The issue affects the current mainline kernel.
- Ubuntu 19.10/CentOS 7 & RHEL 8 have been tested, all exhibit the behavior.
- The issue happens on both bare metal and virtual machines.
- kmemleak does not produce any results, however, memleak-bpfcc does.

I have attached the output of meminfo, slabinfo and the results from
"memleak-bpfcc 3 -o 600000" to the bottom of this email.  These are
from a system running the 5.3.0-18 kernel on Ubuntu 19.10.

Also attached smem with dates which shows kernel memory growing by 2x.

Here are some clear steps to reproduce:
- On your preferred OS, install an IPsec daemon/software
(strongswan/openswan/whatever)
- Setup a IKEv2 conn in tunnel mode. Use a RFC1918 private range for
your client IP pool. e.g: 10.2.0.0/16
- Enable IP forwarding (net.ipv4.ip_forward = 1)
- MASQUERADE the 10.2.0.0/16 range using iptables, e.g: "-A
POSTROUTING -s 10.2.0.0/16 -o eth0 -j MASQUERADE"
- Connect some IKEv2 clients (any device, any platform, doesn't
matter) and pass traffic through the tunnel.
^^ It speeds up the leak if you have multiple tunnels passing traffic
at the same time.

- Observe memory is lost over time and never recovered. Doesn't matter
if you restart the daemon, bring down the tunnels, or even unload
xfrm/ipsec modules. The memory goes into the void. Only way to reclaim
is by restarting completely.

Please let me know if anything further is needed to diagnose/debug
this problem. We're stuck with the 4.9 kernel because all newer
kernels leak memory. Any help or advice is appreciated.

Thank you.


Here's the slabinfo/meminfo/slab/memleak-bpfcc output.

==== meminfo ===
MemTotal:        8152876 kB
MemFree:         4851964 kB
MemAvailable:    7357172 kB
Buffers:           76244 kB
Cached:          2530008 kB
SwapCached:            0 kB
Active:          1474888 kB
Inactive:        1255692 kB
Active(anon):     133180 kB
Inactive(anon):      180 kB
Active(file):    1341708 kB
Inactive(file):  1255512 kB
Unevictable:       18288 kB
Mlocked:           18288 kB
SwapTotal:             0 kB
SwapFree:              0 kB
Dirty:                 0 kB
Writeback:             0 kB
AnonPages:        142624 kB
Mapped:           281916 kB
Shmem:               936 kB
KReclaimable:     211744 kB
Slab:             281588 kB
SReclaimable:     211744 kB
SUnreclaim:        69844 kB
KernelStack:        2768 kB
PageTables:         3112 kB
NFS_Unstable:          0 kB
Bounce:                0 kB
WritebackTmp:          0 kB
CommitLimit:     4076436 kB
Committed_AS:     561124 kB
VmallocTotal:   34359738367 kB
VmallocUsed:      142540 kB
VmallocChunk:          0 kB
Percpu:             3056 kB
HardwareCorrupted:     0 kB
AnonHugePages:         0 kB
ShmemHugePages:        0 kB
ShmemPmdMapped:        0 kB
CmaTotal:              0 kB
CmaFree:               0 kB
HugePages_Total:       0
HugePages_Free:        0
HugePages_Rsvd:        0
HugePages_Surp:        0
Hugepagesize:       2048 kB
Hugetlb:               0 kB
DirectMap4k:      204780 kB
DirectMap2M:     6086656 kB
DirectMap1G:     2097152 kB


==== smem ====
root@ubuntu:~# date; smem -tkw
Wed Oct 30 00:39:52 UTC 2019
kernel dynamic memory        753.4M     657.0M      96.3M

after running ipsec tunnels with traffic for 17h:

root@ubuntu:~# date; smem -tkw
Wed Oct 30 17:58:55 UTC 2019
kernel dynamic memory          2.5G       2.3G     187.5M

root@ubuntu:~# uname -r
5.3.0-18-generic

root@ubuntu:~# tail -n1 /etc/lsb-release
DISTRIB_DESCRIPTION="Ubuntu 19.10"

==== slabinfo ====
slabinfo - version: 2.1
# name            <active_objs> <num_objs> <objsize> <objperslab>
<pagesperslab> : tunables <limit> <batchcount> <sharedfactor> :
slabdata <active_slabs> <num_slabs> <sharedavail>
ufs_inode_cache        0      0    792   20    4 : tunables    0    0
  0 : slabdata      0      0      0
xfs_dqtrx              0      0    528   31    4 : tunables    0    0
  0 : slabdata      0      0      0
xfs_dquot              0      0    496   16    2 : tunables    0    0
  0 : slabdata      0      0      0
xfs_buf                0      0    384   21    2 : tunables    0    0
  0 : slabdata      0      0      0
xfs_rui_item           0      0    696   23    4 : tunables    0    0
  0 : slabdata      0      0      0
xfs_rud_item           0      0    176   23    1 : tunables    0    0
  0 : slabdata      0      0      0
xfs_inode              0      0   1024   16    4 : tunables    0    0
  0 : slabdata      0      0      0
xfs_efd_item           0      0    440   18    2 : tunables    0    0
  0 : slabdata      0      0      0
xfs_buf_item           0      0    272   30    2 : tunables    0    0
  0 : slabdata      0      0      0
xfs_trans              0      0    232   17    1 : tunables    0    0
  0 : slabdata      0      0      0
xfs_da_state           0      0    480   17    2 : tunables    0    0
  0 : slabdata      0      0      0
xfs_btree_cur          0      0    224   18    1 : tunables    0    0
  0 : slabdata      0      0      0
nf_conntrack         725    725    320   25    2 : tunables    0    0
  0 : slabdata     29     29      0
kvm_async_pf           0      0    136   30    1 : tunables    0    0
  0 : slabdata      0      0      0
kvm_vcpu               0      0  17216    1    8 : tunables    0    0
  0 : slabdata      0      0      0
kvm_mmu_page_header      0      0    160   25    1 : tunables    0
0    0 : slabdata      0      0      0
x86_fpu                0      0   4160    7    8 : tunables    0    0
  0 : slabdata      0      0      0
ext4_groupinfo_4k   1288   1288    144   28    1 : tunables    0    0
  0 : slabdata     46     46      0
btrfs_delayed_node      0      0    312   26    2 : tunables    0    0
   0 : slabdata      0      0      0
btrfs_ordered_extent      0      0    416   19    2 : tunables    0
0    0 : slabdata      0      0      0
btrfs_extent_map       0      0    144   28    1 : tunables    0    0
  0 : slabdata      0      0      0
btrfs_path             0      0    112   36    1 : tunables    0    0
  0 : slabdata      0      0      0
btrfs_inode            0      0   1152   28    8 : tunables    0    0
  0 : slabdata      0      0      0
ip6-frags              0      0    184   22    1 : tunables    0    0
  0 : slabdata      0      0      0
PINGv6                 0      0   1216   26    8 : tunables    0    0
  0 : slabdata      0      0      0
RAWv6                182    182   1216   26    8 : tunables    0    0
  0 : slabdata      7      7      0
UDPv6                275    275   1280   25    8 : tunables    0    0
  0 : slabdata     11     11      0
tw_sock_TCPv6          0      0    240   17    1 : tunables    0    0
  0 : slabdata      0      0      0
request_sock_TCPv6      0      0    304   26    2 : tunables    0    0
   0 : slabdata      0      0      0
TCPv6                 52     52   2368   13    8 : tunables    0    0
  0 : slabdata      4      4      0
kcopyd_job             0      0   3312    9    8 : tunables    0    0
  0 : slabdata      0      0      0
dm_uevent              0      0   2632   12    8 : tunables    0    0
  0 : slabdata      0      0      0
scsi_sense_cache     448    448    128   32    1 : tunables    0    0
  0 : slabdata     14     14      0
mqueue_inode_cache     17     17    960   17    4 : tunables    0    0
   0 : slabdata      1      1      0
fuse_request           0      0    392   20    2 : tunables    0    0
  0 : slabdata      0      0      0
fuse_inode             0      0    832   19    4 : tunables    0    0
  0 : slabdata      0      0      0
ecryptfs_key_record_cache      0      0    576   28    4 : tunables
0    0    0 : slabdata      0      0      0
ecryptfs_inode_cache      0      0    960   17    4 : tunables    0
0    0 : slabdata      0      0      0
ecryptfs_file_cache      0      0     16  256    1 : tunables    0
0    0 : slabdata      0      0      0
ecryptfs_auth_tok_list_item      0      0    832   19    4 : tunables
  0    0    0 : slabdata      0      0      0
fat_inode_cache       47     66    728   22    4 : tunables    0    0
  0 : slabdata      3      3      0
fat_cache              0      0     40  102    1 : tunables    0    0
  0 : slabdata      0      0      0
squashfs_inode_cache   1774   1886    704   23    4 : tunables    0
0    0 : slabdata     82     82      0
jbd2_journal_head   1632   1700    120   34    1 : tunables    0    0
  0 : slabdata     50     50      0
jbd2_revoke_table_s    256    256     16  256    1 : tunables    0
0    0 : slabdata      1      1      0
ext4_inode_cache   57351  59460   1080   30    8 : tunables    0    0
  0 : slabdata   1982   1982      0
ext4_allocation_context    128    128    128   32    1 : tunables    0
   0    0 : slabdata      4      4      0
ext4_pending_reservation    640    640     32  128    1 : tunables
0    0    0 : slabdata      5      5      0
ext4_extent_status  74358  74358     40  102    1 : tunables    0    0
   0 : slabdata    729    729      0
mbcache              365    365     56   73    1 : tunables    0    0
  0 : slabdata      5      5      0
fscrypt_info         512    512     64   64    1 : tunables    0    0
  0 : slabdata      8      8      0
fscrypt_ctx          340    340     48   85    1 : tunables    0    0
  0 : slabdata      4      4      0
userfaultfd_ctx_cache      0      0    192   21    1 : tunables    0
 0    0 : slabdata      0      0      0
dnotify_struct         0      0     32  128    1 : tunables    0    0
  0 : slabdata      0      0      0
pid_namespace          0      0    208   19    1 : tunables    0    0
  0 : slabdata      0      0      0
posix_timers_cache     34     34    240   17    1 : tunables    0    0
   0 : slabdata      2      2      0
UNIX                1600   1600   1024   16    4 : tunables    0    0
  0 : slabdata    100    100      0
ip4-frags              0      0    200   20    1 : tunables    0    0
  0 : slabdata      0      0      0
xfrm_state           552    552    704   23    4 : tunables    0    0
  0 : slabdata     24     24      0
PING                   0      0    960   17    4 : tunables    0    0
  0 : slabdata      0      0      0
RAW                  192    192   1024   16    4 : tunables    0    0
  0 : slabdata     12     12      0
tw_sock_TCP           17     17    240   17    1 : tunables    0    0
  0 : slabdata      1      1      0
request_sock_TCP     182    182    304   26    2 : tunables    0    0
  0 : slabdata      7      7      0
TCP                  140    140   2240   14    8 : tunables    0    0
  0 : slabdata     10     10      0
hugetlbfs_inode_cache     52     52    616   26    4 : tunables    0
 0    0 : slabdata      2      2      0
dquot                400    400    256   16    1 : tunables    0    0
  0 : slabdata     25     25      0
eventpoll_pwq       2632   2632     72   56    1 : tunables    0    0
  0 : slabdata     47     47      0
dax_cache             21     21    768   21    4 : tunables    0    0
  0 : slabdata      1      1      0
request_queue         90    150   2088   15    8 : tunables    0    0
  0 : slabdata     10     10      0
biovec-max           204    208   4096    8    8 : tunables    0    0
  0 : slabdata     26     26      0
biovec-128            16     16   2048   16    8 : tunables    0    0
  0 : slabdata      1      1      0
biovec-64             64     64   1024   16    4 : tunables    0    0
  0 : slabdata      4      4      0
user_namespace         0      0    536   30    4 : tunables    0    0
  0 : slabdata      0      0      0
dmaengine-unmap-256     15     15   2112   15    8 : tunables    0
0    0 : slabdata      1      1      0
dmaengine-unmap-128     30     30   1088   30    8 : tunables    0
0    0 : slabdata      1      1      0
dmaengine-unmap-16    884    945    192   21    1 : tunables    0    0
   0 : slabdata     45     45      0
dmaengine-unmap-2  30208  30208     64   64    1 : tunables    0    0
  0 : slabdata    472    472      0
sock_inode_cache    2338   2356    832   19    4 : tunables    0    0
  0 : slabdata    124    124      0
skbuff_ext_cache    2048   2048    128   32    1 : tunables    0    0
  0 : slabdata     64     64      0
skbuff_fclone_cache    240    240    512   16    2 : tunables    0
0    0 : slabdata     15     15      0
skbuff_head_cache   2992   3072    256   16    1 : tunables    0    0
  0 : slabdata    192    192      0
configfs_dir_cache     84     84     96   42    1 : tunables    0    0
   0 : slabdata      2      2      0
file_lock_cache       72     72    216   18    1 : tunables    0    0
  0 : slabdata      4      4      0
fsnotify_mark_connector    512    512     32  128    1 : tunables    0
   0    0 : slabdata      4      4      0
net_namespace          6      6   4928    6    8 : tunables    0    0
  0 : slabdata      1      1      0
task_delay_info     4437   4437     80   51    1 : tunables    0    0
  0 : slabdata     87     87      0
taskstats             92     92    344   23    2 : tunables    0    0
  0 : slabdata      4      4      0
proc_dir_entry       483    483    192   21    1 : tunables    0    0
  0 : slabdata     23     23      0
pde_opener          7140   7140     40  102    1 : tunables    0    0
  0 : slabdata     70     70      0
proc_inode_cache   29275  29808    664   24    4 : tunables    0    0
  0 : slabdata   1242   1242      0
bdev_cache            76     76    832   19    4 : tunables    0    0
  0 : slabdata      4      4      0
shmem_inode_cache   1819   2254    704   23    4 : tunables    0    0
  0 : slabdata     98     98      0
kernfs_node_cache  69270  69270    136   30    1 : tunables    0    0
  0 : slabdata   2309   2309      0
mnt_cache           1058   1100    320   25    2 : tunables    0    0
  0 : slabdata     44     44      0
filp               12429  13328    256   16    1 : tunables    0    0
  0 : slabdata    833    833      0
inode_cache        26833  27378    592   27    4 : tunables    0    0
  0 : slabdata   1014   1014      0
dentry            156821 163443    192   21    1 : tunables    0    0
  0 : slabdata   7783   7783      0
names_cache           56     56   4096    8    8 : tunables    0    0
  0 : slabdata      7      7      0
iint_cache             0      0    120   34    1 : tunables    0    0
  0 : slabdata      0      0      0
lsm_file_cache      3230   3230     24  170    1 : tunables    0    0
  0 : slabdata     19     19      0
buffer_head       573955 582075    104   39    1 : tunables    0    0
  0 : slabdata  14925  14925      0
uts_namespace         36     36    440   18    2 : tunables    0    0
  0 : slabdata      2      2      0
nsproxy              511    511     56   73    1 : tunables    0    0
  0 : slabdata      7      7      0
vm_area_struct     21462  22116    208   19    1 : tunables    0    0
  0 : slabdata   1164   1164      0
mm_struct           2100   2100   1088   30    8 : tunables    0    0
  0 : slabdata     70     70      0
files_cache         1472   1472    704   23    4 : tunables    0    0
  0 : slabdata     64     64      0
signal_cache        2280   2280   1088   30    8 : tunables    0    0
  0 : slabdata     76     76      0
sighand_cache       1275   1275   2112   15    8 : tunables    0    0
  0 : slabdata     85     85      0
task_struct          845    890   5888    5    8 : tunables    0    0
  0 : slabdata    178    178      0
cred_jar            3528   3528    192   21    1 : tunables    0    0
  0 : slabdata    168    168      0
anon_vma_chain     39618  40000     64   64    1 : tunables    0    0
  0 : slabdata    625    625      0
anon_vma           22217  22402     88   46    1 : tunables    0    0
  0 : slabdata    487    487      0
pid                 4193   4224    128   32    1 : tunables    0    0
  0 : slabdata    132    132      0
Acpi-Operand        1120   1120     72   56    1 : tunables    0    0
  0 : slabdata     20     20      0
Acpi-ParseExt        156    156    104   39    1 : tunables    0    0
  0 : slabdata      4      4      0
Acpi-State           357    357     80   51    1 : tunables    0    0
  0 : slabdata      7      7      0
Acpi-Namespace       510    510     40  102    1 : tunables    0    0
  0 : slabdata      5      5      0
numa_policy           31     31    264   31    2 : tunables    0    0
  0 : slabdata      1      1      0
ftrace_event_field   5015   5015     48   85    1 : tunables    0    0
   0 : slabdata     59     59      0
pool_workqueue       176    176    256   16    1 : tunables    0    0
  0 : slabdata     11     11      0
radix_tree_node    22018  24080    584   28    4 : tunables    0    0
  0 : slabdata    860    860      0
task_group           100    100    640   25    4 : tunables    0    0
  0 : slabdata      4      4      0
vmap_area           3489   4876     88   46    1 : tunables    0    0
  0 : slabdata    106    106      0
dma-kmalloc-8k         0      0   8192    4    8 : tunables    0    0
  0 : slabdata      0      0      0
dma-kmalloc-4k         0      0   4096    8    8 : tunables    0    0
  0 : slabdata      0      0      0
dma-kmalloc-2k         0      0   2048   16    8 : tunables    0    0
  0 : slabdata      0      0      0
dma-kmalloc-1k         0      0   1024   16    4 : tunables    0    0
  0 : slabdata      0      0      0
dma-kmalloc-512        0      0    512   16    2 : tunables    0    0
  0 : slabdata      0      0      0
dma-kmalloc-256        0      0    256   16    1 : tunables    0    0
  0 : slabdata      0      0      0
dma-kmalloc-128        0      0    128   32    1 : tunables    0    0
  0 : slabdata      0      0      0
dma-kmalloc-64         0      0     64   64    1 : tunables    0    0
  0 : slabdata      0      0      0
dma-kmalloc-32         0      0     32  128    1 : tunables    0    0
  0 : slabdata      0      0      0
dma-kmalloc-16         0      0     16  256    1 : tunables    0    0
  0 : slabdata      0      0      0
dma-kmalloc-8          0      0      8  512    1 : tunables    0    0
  0 : slabdata      0      0      0
dma-kmalloc-192        0      0    192   21    1 : tunables    0    0
  0 : slabdata      0      0      0
dma-kmalloc-96         0      0     96   42    1 : tunables    0    0
  0 : slabdata      0      0      0
kmalloc-rcl-8k         0      0   8192    4    8 : tunables    0    0
  0 : slabdata      0      0      0
kmalloc-rcl-4k         0      0   4096    8    8 : tunables    0    0
  0 : slabdata      0      0      0
kmalloc-rcl-2k         0      0   2048   16    8 : tunables    0    0
  0 : slabdata      0      0      0
kmalloc-rcl-1k         0      0   1024   16    4 : tunables    0    0
  0 : slabdata      0      0      0
kmalloc-rcl-512        0      0    512   16    2 : tunables    0    0
  0 : slabdata      0      0      0
kmalloc-rcl-256        0      0    256   16    1 : tunables    0    0
  0 : slabdata      0      0      0
kmalloc-rcl-192        0      0    192   21    1 : tunables    0    0
  0 : slabdata      0      0      0
kmalloc-rcl-128      634    704    128   32    1 : tunables    0    0
  0 : slabdata     22     22      0
kmalloc-rcl-96      1719   2310     96   42    1 : tunables    0    0
  0 : slabdata     55     55      0
kmalloc-rcl-64      5248   6272     64   64    1 : tunables    0    0
  0 : slabdata     98     98      0
kmalloc-rcl-32         0      0     32  128    1 : tunables    0    0
  0 : slabdata      0      0      0
kmalloc-rcl-16         0      0     16  256    1 : tunables    0    0
  0 : slabdata      0      0      0
kmalloc-rcl-8          0      0      8  512    1 : tunables    0    0
  0 : slabdata      0      0      0
kmalloc-8k           126    140   8192    4    8 : tunables    0    0
  0 : slabdata     35     35      0
kmalloc-4k          1704   1704   4096    8    8 : tunables    0    0
  0 : slabdata    213    213      0
kmalloc-2k          1344   1344   2048   16    8 : tunables    0    0
  0 : slabdata     84     84      0
kmalloc-1k          3084   3408   1024   16    4 : tunables    0    0
  0 : slabdata    213    213      0
kmalloc-512         3559   3696    512   16    2 : tunables    0    0
  0 : slabdata    231    231      0
kmalloc-256          992    992    256   16    1 : tunables    0    0
  0 : slabdata     62     62      0
kmalloc-192         3087   3087    192   21    1 : tunables    0    0
  0 : slabdata    147    147      0
kmalloc-128         1530   2080    128   32    1 : tunables    0    0
  0 : slabdata     65     65      0
kmalloc-96          4435   4536     96   42    1 : tunables    0    0
  0 : slabdata    108    108      0
kmalloc-64         15360  15360     64   64    1 : tunables    0    0
  0 : slabdata    240    240      0
kmalloc-32         40960  40960     32  128    1 : tunables    0    0
  0 : slabdata    320    320      0
kmalloc-16          9984   9984     16  256    1 : tunables    0    0
  0 : slabdata     39     39      0
kmalloc-8           8192   8192      8  512    1 : tunables    0    0
  0 : slabdata     16     16      0
kmem_cache_node     1600   1600     64   64    1 : tunables    0    0
  0 : slabdata     25     25      0
kmem_cache          1478   1494    448   18    2 : tunables    0    0
  0 : slabdata     83     83      0

==== truncated memleak-bpfcc entries ====
Attaching to kernel allocators, Ctrl+C to quit.

    2654208 bytes in 81 allocations from stack
        __alloc_pages_nodemask+0x239 [kernel]
        __alloc_pages_nodemask+0x239 [kernel]
        alloc_pages_current+0x87 [kernel]
        skb_page_frag_refill+0x80 [kernel]
        esp_output_tail+0x3a5 [kernel]
        esp_output+0x11f [kernel]
        xfrm_output_resume+0x480 [kernel]
        xfrm_output+0x81 [kernel]
        xfrm4_output_finish+0x2b [kernel]
        __xfrm4_output+0x44 [kernel]
        xfrm4_output+0x3f [kernel]
        ip_forward_finish+0x58 [kernel]
        ip_forward+0x3f9 [kernel]
        ip_rcv_finish+0x85 [kernel]
        ip_rcv+0xbc [kernel]
        __netif_receive_skb_one_core+0x87 [kernel]
        __netif_receive_skb+0x18 [kernel]
        netif_receive_skb_internal+0x45 [kernel]
        napi_gro_receive+0xff [kernel]
        receive_buf+0x175 [kernel]
        virtnet_poll+0x158 [kernel]
        net_rx_action+0x13a [kernel]
        __softirqentry_text_start+0xe1 [kernel]
        run_ksoftirqd+0x2b [kernel]
        smpboot_thread_fn+0xd0 [kernel]
        kthread+0x104 [kernel]
        ret_from_fork+0x35 [kernel]
    6500352 bytes in 1587 allocations from stack
        __alloc_pages_nodemask+0x239 [kernel]
        __alloc_pages_nodemask+0x239 [kernel]
        alloc_pages_vma+0xda [kernel]
        do_anonymous_page+0x115 [kernel]
        __handle_mm_fault+0x760 [kernel]
        handle_mm_fault+0xca [kernel]
        do_user_addr_fault+0x1f9 [kernel]
        __do_page_fault+0x58 [kernel]
        do_page_fault+0x2c [kernel]
        do_async_page_fault+0x39 [kernel]
        async_page_fault+0x34 [kernel]
    11038720 bytes in 2695 allocations from stack
        __kmalloc_track_caller+0x162 [kernel]
        __kmalloc_track_caller+0x162 [kernel]
        kmemdup+0x1c [kernel]
        bpf_prepare_filter+0x3d5 [kernel]
        bpf_prog_create_from_user+0xc7 [kernel]
        seccomp_set_mode_filter+0x11a [kernel]
        do_seccomp+0x39 [kernel]
        prctl_set_seccomp+0x2c [kernel]
        __x64_sys_prctl+0x52c [kernel]
        do_syscall_64+0x5a [kernel]
        entry_SYSCALL_64_after_hwframe+0x44 [kernel]
    11063296 bytes in 2701 allocations from stack
        __alloc_pages_nodemask+0x239 [kernel]
        __alloc_pages_nodemask+0x239 [kernel]
        alloc_pages_vma+0xda [kernel]
        wp_page_copy+0x8a [kernel]
        do_wp_page+0x94 [kernel]
        __handle_mm_fault+0x771 [kernel]
        handle_mm_fault+0xca [kernel]
        do_user_addr_fault+0x1f9 [kernel]
        __do_page_fault+0x58 [kernel]
        do_page_fault+0x2c [kernel]
        do_async_page_fault+0x39 [kernel]
        async_page_fault+0x34 [kernel]
[18:57:37] Top 10 stacks with outstanding allocations:
    421888 bytes in 103 allocations from stack
        __alloc_pages_nodemask+0x239 [kernel]
        __alloc_pages_nodemask+0x239 [kernel]
        alloc_pages_current+0x87 [kernel]
        alloc_slab_page+0x17b [kernel]
        allocate_slab+0x7d [kernel]
        new_slab+0x4a [kernel]
        ___slab_alloc+0x338 [kernel]
        __slab_alloc+0x20 [kernel]
        kmem_cache_alloc+0x204 [kernel]
        __alloc_file+0x28 [kernel]
        alloc_empty_file+0x46 [kernel]
        path_openat+0x47 [kernel]
        do_filp_open+0x91 [kernel]
        do_sys_open+0x17e [kernel]
        __x64_sys_openat+0x20 [kernel]
        do_syscall_64+0x5a [kernel]
        entry_SYSCALL_64_after_hwframe+0x44 [kernel]
    425984 bytes in 13 allocations from stack
        __alloc_pages_nodemask+0x239 [kernel]
        __alloc_pages_nodemask+0x239 [kernel]
        alloc_pages_current+0x87 [kernel]
        skb_page_frag_refill+0x80 [kernel]
        esp_output_tail+0x3a5 [kernel]
        esp_output+0x11f [kernel]
        xfrm_output_resume+0x480 [kernel]
        xfrm_output+0x81 [kernel]
        xfrm4_output_finish+0x2b [kernel]
        __xfrm4_output+0x44 [kernel]
        xfrm4_output+0x3f [kernel]
        ip_forward_finish+0x58 [kernel]
        ip_forward+0x3f9 [kernel]
        ip_rcv_finish+0x85 [kernel]
        ip_rcv+0xbc [kernel]
        __netif_receive_skb_one_core+0x87 [kernel]
        __netif_receive_skb+0x18 [kernel]
        netif_receive_skb_internal+0x45 [kernel]
        napi_gro_receive+0xff [kernel]
        receive_buf+0x175 [kernel]
        virtnet_poll+0x158 [kernel]
        net_rx_action+0x13a [kernel]
        __softirqentry_text_start+0xe1 [kernel]
        irq_exit+0xae [kernel]
        do_IRQ+0x86 [kernel]
        ret_from_intr+0x0 [kernel]
        native_safe_halt+0xe [kernel]
        arch_cpu_idle+0x15 [kernel]
        default_idle_call+0x23 [kernel]
        do_idle+0x209 [kernel]
        cpu_startup_entry+0x20 [kernel]
        start_secondary+0x168 [kernel]
        secondary_startup_64+0xa4 [kernel]
