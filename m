Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C775B178BA9
	for <lists+netdev@lfdr.de>; Wed,  4 Mar 2020 08:46:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728591AbgCDHqE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Mar 2020 02:46:04 -0500
Received: from mail-vk1-f172.google.com ([209.85.221.172]:35067 "EHLO
        mail-vk1-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725797AbgCDHqD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Mar 2020 02:46:03 -0500
Received: by mail-vk1-f172.google.com with SMTP id r5so294641vkf.2
        for <netdev@vger.kernel.org>; Tue, 03 Mar 2020 23:46:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to;
        bh=OvhmvirsmOHPh/4seAHFB8qK9CTZbOWl+498fVpyRoQ=;
        b=jYJKokyD0SibxhhCYWKknYEn+slQSzk/nFvQJUg26FbFnj+nW9AOXfMSFuCNANKXjA
         HobC7AyQNMOtOtmljcgI9h9NRxV+uQGKfx1ZwEoEJLmHVhdImeYCfeqJRRGfTyyCUE0k
         pJFd9R1aqKK+vYVBYHFgG+DW827y+G2E2mlNCBpq0KBgCFPcEzHJDjE65t37q7tLjn1y
         ukwB8DtV/XyFLdcwzK/zPuq/bfMC9+SeLnZJoxmb4MrSe0+BrQ8Xj8OH28LtI7NSonLm
         Pu1Ti1MhJQlkvxVMQ9s22ac6prG+gX2ghf4294AZDAsAuzNo0n+kxhtppQrva1lFD9mC
         5bEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to;
        bh=OvhmvirsmOHPh/4seAHFB8qK9CTZbOWl+498fVpyRoQ=;
        b=QSwr/VDRxNT142jzkflLg4LOeLtc+XtQea5i+AxogpSgIlfEdVj+MLFcM30d4vwbKu
         bF7Ofm8OhyX6+mZGGwANZTlD+p4bUyPnJyAs69ayeo4fF7fHhm/8EkzDbZqMtzl4QbFT
         zk+udCwIVNFvUk2YGPmV4lJtnwcy+VDza7QEeggCCwhkjI94Pj6Woj7bWE68BQ/XVnD4
         mA7oI9GviTTjJpquPXW2IWKneG/d/abjPcl+Qx/GFB3YJN7P5Zhghn1B21Tnbb6fVD6I
         eejhnbwL7BlAFNKSadmrptRqha6CKVF+y2CclVdU59AzMyJAP8sG+zCfa3WeJy/wAKga
         Q7Mw==
X-Gm-Message-State: ANhLgQ2Z4UBN20c8w0YTG4pZwSA1BEEmTxo1GQXV2Mzpvz4yqYrmdYAq
        6eprXSZESsKgblb/GHWeF+JWuy1XlehZ2XbFyDEi2w==
X-Google-Smtp-Source: ADFU+vtJSm8DTEofCvPtP5G9pWJ4CujNgtMQWa2wfUI7U9nJYYbY37HrzKZ/nwULUL568NzNk1O50YZ7CSAXtHPmHnI=
X-Received: by 2002:a1f:a04f:: with SMTP id j76mr660803vke.75.1583307960286;
 Tue, 03 Mar 2020 23:46:00 -0800 (PST)
MIME-Version: 1.0
References: <CAHfmSg1nnOvBD_JC0S=0_s_0VADZNJb8EyQTNq2m1kMEe9CLyw@mail.gmail.com>
In-Reply-To: <CAHfmSg1nnOvBD_JC0S=0_s_0VADZNJb8EyQTNq2m1kMEe9CLyw@mail.gmail.com>
From:   Jiulun Du <dujiulun@gmail.com>
Date:   Wed, 4 Mar 2020 15:45:48 +0800
Message-ID: <CAHfmSg3-oR85G9XDZ3wVA5Ly7RunrAdAnRZEdxPzR9CeabZ0AA@mail.gmail.com>
Subject: PROBLEM: UDP packet sent over IPVS & VXLAN with tx-checksum offload
 gets bad checksum
To:     netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

[1.] One line summary of the problem:
UDP packet sent over IPVS & Vxlan with tx-checksum offload gets bad checksum

[2.] Full description of the problem/report:
I have this personal Kubernetes setup, with IPVS-powered kube-proxy
for service IP load-balancing, and vxlan-backed flannel as overlay
network between nodes. It's made of multiple KVM nodes from different
providers.

Recently I found some DNS queries would time out. When I try to query
the DNS service IP from the host, the query is dropped. (Some queries
from inside the containers time out too, probably for the same
reason.)

You can find some details in section 7. Basically when I query the
service IP (172.19.128.3) with `dig`, it's sent to `kube-ipvs` (dummy
interface), and IPVS changes the dst address to one of the remote pod
IPs (172.19.195.166 in this case).
Then the packet is locally forwarded to `flannel.1` (vxlan interface),
which wraps it into another UDP packet and send to remote node
(147.135.114.20 port 8472) where DNS server is run.

Running tcpdump on both ends shows that the original UDP query packet
is fine, but the outer packet gets a wrong UDP checksum. It can reach
the other node but gets dropped there.
Packet dump from the sender's ethernet card (ens3):
---
06:22:23.699846 IP (tos 0x0, ttl 64, id 7598, offset 0, flags [none],
proto UDP (17), length 133)
    192.3.59.220.25362 > 147.135.114.20.8472: [bad udp cksum 0xd2ae ->
0x245b!] OTV, flags [I] (0x08), overlay 0, instance 1
IP (tos 0x0, ttl 63, id 33703, offset 0, flags [none], proto UDP (17),
length 83)
    172.19.192.0.13169 > 172.19.195.166.53: [udp sum ok] 41922+ [1au]
A? www.google.com. ar: . OPT UDPsize=4096 (55)
---
Original dump file is available at:
https://cdn.du9l.com/files/udp/ipvs-vxlan-offload.bin (Not sure where
to find a pastebin that supports binary files...)

Further tests show that if I query the DNS pod IP (not having IPVS
doing load-balancing), or if I turn off tx-checksum offload with
`ethtool -K flannel.1 tx off`, everything works. The following are
those packet dumps:
* Query pod IP: https://cdn.du9l.com/files/udp/vxlan-offload-direct.bin
---
06:23:27.755447 IP (tos 0x0, ttl 64, id 15735, offset 0, flags [none],
proto UDP (17), length 133)
    192.3.59.220.56026 > 147.135.114.20.8472: [udp sum ok] OTV, flags
[I] (0x08), overlay 0, instance 1
IP (tos 0x0, ttl 64, id 36748, offset 0, flags [none], proto UDP (17),
length 83)
    172.19.192.0.54406 > 172.19.195.166.53: [udp sum ok] 6417+ [1au]
A? www.google.com. ar: . OPT UDPsize=4096 (55)
06:23:27.840375 IP (tos 0x0, ttl 44, id 64875, offset 0, flags [none],
proto UDP (17), length 151)
    147.135.114.20.35703 > 192.3.59.220.8472: [udp sum ok] OTV, flags
[I] (0x08), overlay 0, instance 1
IP (tos 0x0, ttl 63, id 39107, offset 0, flags [DF], proto UDP (17), length 101)
    172.19.195.166.53 > 172.19.192.0.54406: [udp sum ok] 6417 q: A?
www.google.com. 1/0/1 www.google.com. A 172.217.7.164 ar: . OPT
UDPsize=4096 (73)
---
* Turning off tx offloading:
https://cdn.du9l.com/files/udp/ipvs-vxlan-no-offload.bin
---
06:24:58.750734 IP (tos 0x0, ttl 64, id 33022, offset 0, flags [none],
proto UDP (17), length 133)
    192.3.59.220.15096 > 155.94.231.125.8472: [bad udp cksum 0x7f3e ->
0x5155!] OTV, flags [I] (0x08), overlay 0, instance 1
IP (tos 0x0, ttl 63, id 65518, offset 0, flags [none], proto UDP (17),
length 83)
    172.19.192.0.47729 > 172.19.193.212.53: [udp sum ok] 33434+ [1au]
A? www.google.com. ar: . OPT UDPsize=4096 (55)
06:24:58.768555 IP (tos 0x0, ttl 53, id 2088, offset 0, flags [none],
proto UDP (17), length 151)
    155.94.231.125.60125 > 192.3.59.220.8472: [udp sum ok] OTV, flags
[I] (0x08), overlay 0, instance 1
IP (tos 0x0, ttl 63, id 55547, offset 0, flags [DF], proto UDP (17), length 101)
    172.19.193.212.53 > 172.19.192.0.47729: [udp sum ok] 33434 q: A?
www.google.com. 1/0/1 www.google.com. A 172.217.11.164 ar: . OPT
UDPsize=4096 (73)
---

My guess is that IPVS already calculated a UDP checksum before sending
it to the vxlan interface, and the vxlan (with checksum offload) skips
or wrongly calculates the outer checksum in this case.
I searched in the source code for a while, but it turns out to be too
difficult me to find out the actual cause.

[3.] Keywords (i.e., modules, networking, kernel):
networking, ipvs, vxlan, udp, kubernetes

[4.] Kernel information
[4.1.] Kernel version (from /proc/version):
---
Linux version 5.4.23-050423-generic (kernel@gloin) (gcc version 9.2.1
20200220 (Ubuntu 9.2.1-29ubuntu1)) #202002281329 SMP Fri Feb 28
18:33:31 UTC 2020
---
(This is Ubuntu's "mainline builds" kernel)

[4.2.] Kernel .config file:
Too long, please check
https://cdn.du9l.com/files/udp/config-5.4.23-050423-generic

[5.] Most recent kernel version which did not have the bug:
None. Neither Ubuntu stock version (4.15) nor mainline version (5.4) work.

[6.] Output of Oops.. message (if applicable) with symbolic information
     resolved (see Documentation/admin-guide/oops-tracing.rst)
None.
During my test, kernel only printed "device ens3 entered / left
promiscuous mode" since I'm running tcpdump.

[7.] A small shell script or example program which triggers the
     problem (if possible)
None. I think one can create a test environment by manually creating
IPVS and vxlan endpoints, but I didn't try it.
* ip -d link: https://cdn.du9l.com/files/udp/ip-d-link
* ipvsadm -Ln: https://cdn.du9l.com/files/udp/ipvsadm-Ln
* ip -d addr: https://cdn.du9l.com/files/udp/ip-d-addr
* ip -d route: https://cdn.du9l.com/files/udp/ip-d-route

[8.] Environment
[8.1.] Software (add the output of the ver_linux script here)
Kubernetes v1.17.3
Flannel v0.11.0

ver_linux:
---
If some fields are empty or look unusual you may have an old version.
Compare to the current minimal requirements in Documentation/Changes.

Linux vi-sj 5.4.23-050423-generic #202002281329 SMP Fri Feb 28
18:33:31 UTC 2020 x86_64 x86_64 x86_64 GNU/Linux

Util-linux           2.31.1
Mount               2.31.1
Module-init-tools   24
E2fsprogs           1.44.1
Xfsprogs             4.9.0
Nfs-utils           1.3.3
Linux C Library     2.27
Dynamic linker (ldd) 2.27
Linux C++ Library   6.0.25
Procps               3.3.12
Net-tools           2.10
Kbd                 2.0.4
Console-tools       2.0.4
Sh-utils             8.28
Udev                 237
Modules Loaded       aesni_intel async_memcpy async_pq
async_raid6_recov async_tx async_xor autofs4 bpfilter bridge
br_netfilter btrfs cirrus crc32_pclmul crct10dif_pclmul cryptd
crypto_simd drm drm_kms_helper dummy failover fb_sys_fops floppy
ghash_clmulni_intel glue_helper hid hid_generic i2c_piix4 ib_cm
ib_core ib_iser input_leds intel_rapl_common intel_rapl_msr
ip6table_filter ip6_tables ip6t_REJECT ip6t_rt ip6_udp_tunnel ip_set
ip_set_bitmap_port ip_set_hash_ipport ip_set_hash_ipportip
ip_set_hash_ipportnet iptable_filter iptable_nat ip_tables ipt_REJECT
ip_vs ip_vs_rr ip_vs_sh ip_vs_wrr iscsi_tcp iw_cm joydev libcrc32c
libiscsi libiscsi_tcp linear llc mac_hid multipath net_failover
nf_conntrack nf_conntrack_broadcast nf_conntrack_ftp
nf_conntrack_netbios_ns nf_conntrack_netlink nf_defrag_ipv4
nf_defrag_ipv6 nf_log_common nf_log_ipv4 nf_log_ipv6 nf_nat nf_nat_ftp
nfnetlink nf_reject_ipv4 nf_reject_ipv6 overlay pata_acpi psmouse
raid0 raid10 raid1 raid456 raid6_pq rdma_cm sb_edac sch_fq
scsi_transport_iscsi serio_raw stp sunrpc syscopyarea sysfillrect
sysimgblt tcp_bbr udp_tunnel usbhid virtio_blk virtio_net vxlan
xfrm_algo xfrm_user xor x_tables xt_addrtype xt_comment xt_conntrack
xt_hl xt_limit xt_LOG xt_mark xt_MASQUERADE xt_multiport xt_set
xt_tcpudp zstd_compress
---

[8.2.] Processor information (from /proc/cpuinfo):
---
processor       : 0
vendor_id       : GenuineIntel
cpu family      : 6
model           : 62
model name      : Intel(R) Xeon(R) CPU E5-2670 v2 @ 2.50GHz
stepping        : 4
microcode       : 0x1
cpu MHz         : 2499.998
cache size      : 4096 KB
physical id     : 0
siblings        : 1
core id         : 0
cpu cores       : 1
apicid          : 0
initial apicid  : 0
fpu             : yes
fpu_exception   : yes
cpuid level     : 13
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge
mca cmov pat pse36 clflush mmx fxsr sse sse2 ss syscall nx pdpe1gb lm
constant_tsc arch_perfmon nopl cpuid tsc_known_freq pni pclmulqdq
ssse3 cx16 pcid sse4_1 sse4_2 x2apic popcnt tsc_deadline_timer aes
xsave avx f16c rdrand hypervisor lahf_lm pti ssbd ibrs ibpb stibp
fsgsbase smep xsaveopt
bugs            : cpu_meltdown spectre_v1 spectre_v2 spec_store_bypass
l1tf mds swapgs itlb_multihit
bogomips        : 4999.99
clflush size    : 64
cache_alignment : 64
address sizes   : 46 bits physical, 48 bits virtual
power management:

processor       : 1
vendor_id       : GenuineIntel
cpu family      : 6
model           : 62
model name      : Intel(R) Xeon(R) CPU E5-2670 v2 @ 2.50GHz
stepping        : 4
microcode       : 0x1
cpu MHz         : 2499.998
cache size      : 4096 KB
physical id     : 1
siblings        : 1
core id         : 0
cpu cores       : 1
apicid          : 1
initial apicid  : 1
fpu             : yes
fpu_exception   : yes
cpuid level     : 13
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge
mca cmov pat pse36 clflush mmx fxsr sse sse2 ss syscall nx pdpe1gb lm
constant_tsc arch_perfmon nopl cpuid tsc_known_freq pni pclmulqdq
ssse3 cx16 pcid sse4_1 sse4_2 x2apic popcnt tsc_deadline_timer aes
xsave avx f16c rdrand hypervisor lahf_lm pti ssbd ibrs ibpb stibp
fsgsbase smep xsaveopt
bugs            : cpu_meltdown spectre_v1 spectre_v2 spec_store_bypass
l1tf mds swapgs itlb_multihit
bogomips        : 4999.99
clflush size    : 64
cache_alignment : 64
address sizes   : 46 bits physical, 48 bits virtual
power management:
---

[8.3.] Module information (from /proc/modules):
---
vxlan 61440 0 - Live 0x0000000000000000
ip6_udp_tunnel 16384 1 vxlan, Live 0x0000000000000000
udp_tunnel 16384 1 vxlan, Live 0x0000000000000000
xt_set 16384 2 - Live 0x0000000000000000
ip_set_hash_ipportip 36864 2 - Live 0x0000000000000000
ip_set_hash_ipport 36864 7 - Live 0x0000000000000000
ip_set_bitmap_port 20480 4 - Live 0x0000000000000000
ip_set_hash_ipportnet 45056 1 - Live 0x0000000000000000
ip_set 53248 5 xt_set,ip_set_hash_ipportip,ip_set_hash_ipport,ip_set_bitmap_port,ip_set_hash_ipportnet,
Live 0x0000000000000000
dummy 16384 0 - Live 0x0000000000000000
xt_MASQUERADE 20480 3 - Live 0x0000000000000000
xt_comment 16384 10 - Live 0x0000000000000000
xt_mark 16384 4 - Live 0x0000000000000000
iptable_nat 16384 1 - Live 0x0000000000000000
nf_conntrack_netlink 45056 0 - Live 0x0000000000000000
nfnetlink 16384 3 ip_set,nf_conntrack_netlink, Live 0x0000000000000000
xfrm_user 36864 1 - Live 0x0000000000000000
xfrm_algo 16384 1 xfrm_user, Live 0x0000000000000000
overlay 114688 9 - Live 0x0000000000000000
intel_rapl_msr 20480 0 - Live 0x0000000000000000
intel_rapl_common 24576 1 intel_rapl_msr, Live 0x0000000000000000
sb_edac 32768 0 - Live 0x0000000000000000
joydev 24576 0 - Live 0x0000000000000000
input_leds 16384 0 - Live 0x0000000000000000
serio_raw 20480 0 - Live 0x0000000000000000
mac_hid 16384 0 - Live 0x0000000000000000
ip6t_REJECT 16384 1 - Live 0x0000000000000000
nf_reject_ipv6 20480 1 ip6t_REJECT, Live 0x0000000000000000
nf_log_ipv6 16384 4 - Live 0x0000000000000000
xt_hl 16384 22 - Live 0x0000000000000000
ip6t_rt 20480 3 - Live 0x0000000000000000
ipt_REJECT 16384 1 - Live 0x0000000000000000
nf_reject_ipv4 16384 1 ipt_REJECT, Live 0x0000000000000000
nf_log_ipv4 16384 4 - Live 0x0000000000000000
nf_log_common 16384 2 nf_log_ipv6,nf_log_ipv4, Live 0x0000000000000000
xt_LOG 20480 8 - Live 0x0000000000000000
xt_multiport 20480 4 - Live 0x0000000000000000
xt_limit 16384 11 - Live 0x0000000000000000
xt_tcpudp 20480 44 - Live 0x0000000000000000
xt_addrtype 16384 5 - Live 0x0000000000000000
tcp_bbr 20480 41 - Live 0x0000000000000000
sch_fq 20480 2 - Live 0x0000000000000000
xt_conntrack 16384 22 - Live 0x0000000000000000
ib_iser 53248 0 - Live 0x0000000000000000
rdma_cm 61440 1 ib_iser, Live 0x0000000000000000
iw_cm 49152 1 rdma_cm, Live 0x0000000000000000
ib_cm 57344 1 rdma_cm, Live 0x0000000000000000
ip6table_filter 16384 1 - Live 0x0000000000000000
ib_core 303104 4 ib_iser,rdma_cm,iw_cm,ib_cm, Live 0x0000000000000000
ip6_tables 32768 53 ip6table_filter, Live 0x0000000000000000
iscsi_tcp 24576 0 - Live 0x0000000000000000
libiscsi_tcp 32768 1 iscsi_tcp, Live 0x0000000000000000
libiscsi 57344 3 ib_iser,iscsi_tcp,libiscsi_tcp, Live 0x0000000000000000
scsi_transport_iscsi 110592 4 ib_iser,iscsi_tcp,libiscsi_tcp,libiscsi,
Live 0x0000000000000000
nf_conntrack_netbios_ns 16384 0 - Live 0x0000000000000000
br_netfilter 28672 0 - Live 0x0000000000000000
nf_conntrack_broadcast 16384 1 nf_conntrack_netbios_ns, Live 0x0000000000000000
bridge 176128 1 br_netfilter, Live 0x0000000000000000
stp 16384 1 bridge, Live 0x0000000000000000
nf_nat_ftp 20480 0 - Live 0x0000000000000000
llc 16384 2 bridge,stp, Live 0x0000000000000000
ip_vs_sh 16384 0 - Live 0x0000000000000000
ip_vs_wrr 16384 0 - Live 0x0000000000000000
nf_nat 40960 3 xt_MASQUERADE,iptable_nat,nf_nat_ftp, Live 0x0000000000000000
ip_vs_rr 16384 25 - Live 0x0000000000000000
ip_vs 155648 31 ip_vs_sh,ip_vs_wrr,ip_vs_rr, Live 0x0000000000000000
sunrpc 389120 1 - Live 0x0000000000000000
nf_conntrack_ftp 24576 1 nf_nat_ftp, Live 0x0000000000000000
nf_conntrack 139264 9
xt_MASQUERADE,nf_conntrack_netlink,xt_conntrack,nf_conntrack_netbios_ns,nf_conntrack_broadcast,nf_nat_ftp,nf_nat,ip_vs,nf_conntrack_ftp,
Live 0x0000000000000000
nf_defrag_ipv6 24576 2 ip_vs,nf_conntrack, Live 0x0000000000000000
nf_defrag_ipv4 16384 1 nf_conntrack, Live 0x0000000000000000
iptable_filter 16384 1 - Live 0x0000000000000000
bpfilter 32768 0 - Live 0x0000000000000000
ip_tables 32768 10 iptable_nat,iptable_filter, Live 0x0000000000000000
x_tables 40960 18
xt_set,xt_MASQUERADE,xt_comment,xt_mark,ip6t_REJECT,xt_hl,ip6t_rt,ipt_REJECT,xt_LOG,xt_multiport,xt_limit,xt_tcpudp,xt_addrtype,xt_conntrack,ip6table_filter,ip6_tables,iptable_filter,ip_tables,
Live 0x0000000000000000
autofs4 45056 2 - Live 0x0000000000000000
btrfs 1245184 0 - Live 0x0000000000000000
zstd_compress 167936 1 btrfs, Live 0x0000000000000000
raid10 57344 0 - Live 0x0000000000000000
raid456 155648 0 - Live 0x0000000000000000
async_raid6_recov 24576 1 raid456, Live 0x0000000000000000
async_memcpy 20480 2 raid456,async_raid6_recov, Live 0x0000000000000000
async_pq 24576 2 raid456,async_raid6_recov, Live 0x0000000000000000
async_xor 20480 3 raid456,async_raid6_recov,async_pq, Live 0x0000000000000000
async_tx 20480 5
raid456,async_raid6_recov,async_memcpy,async_pq,async_xor, Live
0x0000000000000000
xor 24576 2 btrfs,async_xor, Live 0x0000000000000000
raid6_pq 114688 4 btrfs,raid456,async_raid6_recov,async_pq, Live
0x0000000000000000
libcrc32c 16384 5 nf_nat,ip_vs,nf_conntrack,btrfs,raid456, Live
0x0000000000000000
raid1 45056 0 - Live 0x0000000000000000
raid0 24576 0 - Live 0x0000000000000000
multipath 20480 0 - Live 0x0000000000000000
linear 20480 0 - Live 0x0000000000000000
crct10dif_pclmul 16384 1 - Live 0x0000000000000000
crc32_pclmul 16384 0 - Live 0x0000000000000000
ghash_clmulni_intel 16384 0 - Live 0x0000000000000000
hid_generic 16384 0 - Live 0x0000000000000000
usbhid 57344 0 - Live 0x0000000000000000
cirrus 16384 0 - Live 0x0000000000000000
aesni_intel 372736 0 - Live 0x0000000000000000
drm_kms_helper 184320 3 cirrus, Live 0x0000000000000000
syscopyarea 16384 1 drm_kms_helper, Live 0x0000000000000000
hid 131072 2 hid_generic,usbhid, Live 0x0000000000000000
crypto_simd 16384 1 aesni_intel, Live 0x0000000000000000
sysfillrect 16384 1 drm_kms_helper, Live 0x0000000000000000
sysimgblt 16384 1 drm_kms_helper, Live 0x0000000000000000
fb_sys_fops 16384 1 drm_kms_helper, Live 0x0000000000000000
virtio_net 53248 0 - Live 0x0000000000000000
cryptd 24576 2 ghash_clmulni_intel,crypto_simd, Live 0x0000000000000000
net_failover 20480 1 virtio_net, Live 0x0000000000000000
glue_helper 16384 1 aesni_intel, Live 0x0000000000000000
drm 487424 3 cirrus,drm_kms_helper, Live 0x0000000000000000
psmouse 155648 0 - Live 0x0000000000000000
failover 16384 1 net_failover, Live 0x0000000000000000
virtio_blk 20480 2 - Live 0x0000000000000000
i2c_piix4 28672 0 - Live 0x0000000000000000
pata_acpi 16384 0 - Live 0x0000000000000000
floppy 81920 0 - Live 0x0000000000000000
---

[8.4.] Loaded driver and hardware information (/proc/ioports, /proc/iomem)
---
0000-0000 : PCI Bus 0000:00
  0000-0000 : dma1
  0000-0000 : pic1
  0000-0000 : timer0
  0000-0000 : timer1
  0000-0000 : keyboard
  0000-0000 : keyboard
  0000-0000 : rtc0
  0000-0000 : dma page reg
  0000-0000 : pic2
  0000-0000 : dma2
  0000-0000 : fpu
  0000-0000 : 0000:00:01.1
    0000-0000 : ata_piix
  0000-0000 : 0000:00:01.1
    0000-0000 : ata_piix
  0000-0000 : 0000:00:01.1
    0000-0000 : ata_piix
  0000-0000 : vga+
  0000-0000 : floppy
  0000-0000 : floppy
  0000-0000 : 0000:00:01.1
    0000-0000 : ata_piix
  0000-0000 : floppy
0000-0000 : PCI conf1
0000-0000 : PCI Bus 0000:00
  0000-0000 : ACPI GPE0_BLK
  0000-0000 : 0000:00:01.3
    0000-0000 : ACPI PM1a_EVT_BLK
    0000-0000 : ACPI PM1a_CNT_BLK
    0000-0000 : ACPI PM_TMR
  0000-0000 : 0000:00:01.3
    0000-0000 : piix4_smbus
  0000-0000 : 0000:00:01.1
    0000-0000 : ata_piix
  0000-0000 : 0000:00:01.2
    0000-0000 : uhci_hcd
  0000-0000 : 0000:00:03.0
    0000-0000 : virtio-pci-legacy
  0000-0000 : 0000:00:04.0
    0000-0000 : virtio-pci-legacy
  0000-0000 : 0000:00:05.0
    0000-0000 : virtio-pci-legacy
---
00000000-00000000 : Reserved
00000000-00000000 : System RAM
00000000-00000000 : Reserved
00000000-00000000 : PCI Bus 0000:00
00000000-00000000 : Video ROM
00000000-00000000 : Adapter ROM
00000000-00000000 : Adapter ROM
00000000-00000000 : Reserved
  00000000-00000000 : System ROM
00000000-00000000 : System RAM
  00000000-00000000 : Kernel code
  00000000-00000000 : Kernel data
  00000000-00000000 : Kernel bss
00000000-00000000 : Reserved
00000000-00000000 : PCI Bus 0000:00
  00000000-00000000 : 0000:00:02.0
    00000000-00000000 : cirrus
  00000000-00000000 : 0000:00:02.0
    00000000-00000000 : cirrus
  00000000-00000000 : 0000:00:03.0
  00000000-00000000 : 0000:00:03.0
  00000000-00000000 : 0000:00:04.0
00000000-00000000 : IOAPIC 0
00000000-00000000 : Local APIC
00000000-00000000 : Reserved
---

[8.5.] PCI information ('lspci -vvv' as root)
---
00:00.0 Host bridge: Intel Corporation 440FX - 82441FX PMC [Natoma] (rev 02)
Subsystem: Red Hat, Inc. Qemu virtual machine
Control: I/O+ Mem+ BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-

00:01.0 ISA bridge: Intel Corporation 82371SB PIIX3 ISA [Natoma/Triton II]
Subsystem: Red Hat, Inc. Qemu virtual machine
Physical Slot: 1
Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
Latency: 0

00:01.1 IDE interface: Intel Corporation 82371SB PIIX3 IDE
[Natoma/Triton II] (prog-if 80 [ISA Compatibility mode-only
controller, supports bus mastering])
Subsystem: Red Hat, Inc. Qemu virtual machine
Physical Slot: 1
Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
Latency: 0
Region 0: [virtual] Memory at 000001f0 (32-bit, non-prefetchable) [size=8]
Region 1: [virtual] Memory at 000003f0 (type 3, non-prefetchable)
Region 2: [virtual] Memory at 00000170 (32-bit, non-prefetchable) [size=8]
Region 3: [virtual] Memory at 00000370 (type 3, non-prefetchable)
Region 4: I/O ports at c000 [size=16]
Kernel driver in use: ata_piix
Kernel modules: pata_acpi

00:01.2 USB controller: Intel Corporation 82371SB PIIX3 USB
[Natoma/Triton II] (rev 01) (prog-if 00 [UHCI])
Subsystem: Red Hat, Inc. QEMU Virtual Machine
Physical Slot: 1
Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
Latency: 0
Interrupt: pin D routed to IRQ 11
Region 4: I/O ports at c020 [size=32]
Kernel driver in use: uhci_hcd

00:01.3 Bridge: Intel Corporation 82371AB/EB/MB PIIX4 ACPI (rev 03)
Subsystem: Red Hat, Inc. Qemu virtual machine
Physical Slot: 1
Control: I/O+ Mem+ BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
Interrupt: pin A routed to IRQ 9
Kernel driver in use: piix4_smbus
Kernel modules: i2c_piix4

00:02.0 VGA compatible controller: Cirrus Logic GD 5446 (prog-if 00
[VGA controller])
Subsystem: Red Hat, Inc. QEMU Virtual Machine
Physical Slot: 2
Control: I/O+ Mem+ BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
Region 0: Memory at f0000000 (32-bit, prefetchable) [size=32M]
Region 1: Memory at f2000000 (32-bit, non-prefetchable) [size=4K]
Expansion ROM at 000c0000 [disabled] [size=128K]
Kernel driver in use: cirrus
Kernel modules: cirrusfb, cirrus

00:03.0 Ethernet controller: Red Hat, Inc. Virtio network device
Subsystem: Red Hat, Inc. Virtio network device
Physical Slot: 3
Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
Latency: 0
Interrupt: pin A routed to IRQ 10
Region 0: I/O ports at c040 [size=32]
Region 1: Memory at f2020000 (32-bit, non-prefetchable) [size=4K]
Expansion ROM at f2030000 [disabled] [size=64K]
Capabilities: [40] MSI-X: Enable+ Count=3 Masked-
Vector table: BAR=1 offset=00000000
PBA: BAR=1 offset=00000800
Kernel driver in use: virtio-pci

00:04.0 SCSI storage controller: Red Hat, Inc. Virtio block device
Subsystem: Red Hat, Inc. Virtio block device
Physical Slot: 4
Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
Latency: 0
Interrupt: pin A routed to IRQ 11
Region 0: I/O ports at c080 [size=64]
Region 1: Memory at f2040000 (32-bit, non-prefetchable) [size=4K]
Capabilities: [40] MSI-X: Enable+ Count=2 Masked-
Vector table: BAR=1 offset=00000000
PBA: BAR=1 offset=00000800
Kernel driver in use: virtio-pci

00:05.0 RAM memory: Red Hat, Inc. Virtio memory balloon
Subsystem: Red Hat, Inc. Virtio memory balloon
Physical Slot: 5
Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
Latency: 0
Interrupt: pin A routed to IRQ 10
Region 0: I/O ports at c0c0 [size=32]
Kernel driver in use: virtio-pci
---

[8.6.] SCSI information (from /proc/scsi/scsi)
---
Attached devices:
Host: scsi1 Channel: 00 Id: 00 Lun: 00
  Vendor: QEMU     Model: QEMU DVD-ROM     Rev: 0.12
  Type:   CD-ROM                           ANSI  SCSI revision: 05
---

[8.7.] Other information that might be relevant to the problem
       (please look in /proc and include all information that you
       think to be relevant):
Please refer to section 7 for some command outputs.

[X.] Other notes, patches, fixes, workarounds:
For workaround I turned off all tx offload for flannel.1 on all nodes,
and it's working.

Thank you.

Jiulun Du
http://Du9L.com
