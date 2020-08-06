Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9771923E379
	for <lists+netdev@lfdr.de>; Thu,  6 Aug 2020 23:20:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726350AbgHFVUo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Aug 2020 17:20:44 -0400
Received: from agw4.byu.edu ([128.187.16.188]:45220 "EHLO agw4.byu.edu"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725783AbgHFVUo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 6 Aug 2020 17:20:44 -0400
X-Greylist: delayed 574 seconds by postgrey-1.27 at vger.kernel.org; Thu, 06 Aug 2020 17:20:43 EDT
Received: from cangw3.byu.edu (cangw3.byu.edu [10.18.21.143])
        by agw4.byu.edu (Postfix) with ESMTPS id 31CDE1A374;
        Thu,  6 Aug 2020 15:11:09 -0600 (MDT)
Received: from mail2.fsl.byu.edu (mail2.rc.byu.edu [128.187.49.32])
        by cangw3.byu.edu (8.15.2/8.15.2/Debian-8) with ESMTPS id 076LB4BE023942
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 6 Aug 2020 15:11:06 -0600
Received: from [192.168.124.133] (v-pool-133.rc.byu.edu [192.168.124.133])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail2.fsl.byu.edu (Postfix) with ESMTPSA id CC5353F2D9;
        Thu,  6 Aug 2020 15:11:04 -0600 (MDT)
From:   Ryan Cox <ryan_cox@byu.edu>
Subject: Severe performance regression in "net: macsec: preserve ingress frame
 ordering"
To:     netdev@vger.kernel.org, davem@davemloft.net, sd@queasysnail.net,
        scott@scottdial.com
Cc:     Antoine Tenart <antoine.tenart@bootlin.com>
Message-ID: <1b0cec71-d084-8153-2ba4-72ce71abeb65@byu.edu>
Date:   Thu, 6 Aug 2020 15:11:04 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.1.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Bayes-Prob: 0.0001 (Score -1, tokens from: Outbound, byu-edu:default, base:default, @@RPTN)
X-Spam-Score: -1.00 () [Hold at 5.00] Bayes(0.0001:-1.0)
X-CanIt-Geo: ip=128.187.49.32; country=US; region=Utah; city=Provo; latitude=40.2329; longitude=-111.6688; http://maps.google.com/maps?q=40.2329,-111.6688&z=6
X-CanItPRO-Stream: byu-edu:Outbound (inherits from byu-edu:default,base:default)
X-Canit-Stats-ID: 0a3clb5U4 - e81743dca71f - 20200806
X-Scanned-By: CanIt (www . roaringpenguin . com)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

I have found two performance issues with MACsec on 10 Gb/s links (tested 
on Intel and Broadcom NICs):
1)  MACsec with encryption is much faster than MACsec without encryption 
(9.8 vs 7.4 Gb/s) until 5.7, where both have poor performance
2)  5.7 introduced a severe performance impact for MACsec with and 
without encryption at commit ab046a5d4be4c90a3952a0eae75617b49c0cb01b

I haven't been able to look at issue #1 yet (and I don't know where to 
start) since I got sidetracked looking at issue #2.

This email is about issue #2, which results in the following in my test 
setup:
* MACsec with encryption drops from 9.81 Gb/s to 1.00 Gb/s or sometimes 
worse
* MACsec without encryption drops from 7.40 Gb/s to 1.80 Gb/s

I have tested a number of configurations.  These tests were performed on 
the following hardware:
* dual Intel Xeon E5-2680 v4 @ 2.40GHz, 14 cores each
* Intel 82599ES 10 GbE NIC
* ixgbe driver, version 5.1.0-k

I also tested on the following hardware in a more limited fashion, but 
the results were consistent:
* dual Intel Xeon E5-2670 v3 @ 2.30GHz, 12 cores each
* Broadcom BCM57810 10 GbE NIC
* bnx2x driver, 1.713.36-0

Only one 10 Gb/s link was populated (i.e. no port-channel).  The MTU for 
the network is 9000, with a resulting MACsec MTU of 8968.  All tests 
were performed with only one switch in between the servers.

I tested three scenarios.  The tests were run on servers that are booted 
with NFS root from an identical image.  The only difference was the 
kernel.  A script was run to create the three scenarios and run the 
benchmarks, so the setups are identical across tests.

The scenarios all involved iperf3 tests of these conditions:
1) no MACsec
2) MACsec without encryption
3) MACsec with encryption

The MACsec setup was done as follows:
ip link add link em1 ms1 type macsec sci 1234 encrypt on  #or omitting 
the "encrypt on" for specific tests
ip macsec add ms1 tx sa 0 pn 1234 on key 01 $(printf %032d 1234)
ip macsec add ms1 rx sci 1234
ip macsec add ms1 rx sci 1234 sa 0 pn 1234 on key 01 $(printf %032d 1234)

That results in `ip macsec show` like this:
6: ms1: protect on validate strict sc off sa off encrypt on send_sci on 
end_station off scb off replay off
     cipher suite: GCM-AES-128, using ICV length 16
     TXSC: 0000000000001234 on SA 0
         0: PN 599345, state on, key 01000000000000000000000000000000
     RXSC: 0000000000001234, state on
         0: PN 5076769, state on, key 01000000000000000000000000000000

I tested a number of kernels (all 64 bit) including:
* 4.18.0-193.13.2.el8_2 (RHEL 8)
* 5.6.7-1.el8.elrepo (ELRepo)
* 5.7.11-1.el8.elrepo (ELRepo)
* 5.7 at tag v5.7.11 (I compiled)
* 5.7 at tag v5.7.11 with ab046a5d4be4c90a3952a0eae75617b49c0cb01b 
reverted (I compiled)

I did test 4.18 <-> 5.7 (bi-directional) and both directions resulted in 
poor performance.  Other than that, each test was between two servers of 
the same kernel version.

CONFIG_CRYPTO_AES_NI_INTEL=y is set in all kernels.

4.18 and 5.6 kernels both have very similar performance characteristics:
* 9.89 Gb/s with no macsec at all
* 7.40 Gb/s with macsec WITHOUT encryption  <--- not sure why, but 
turning OFF encryption slowed things down
* 9.81 Gb/s with macsec WITH encryption

With 5.7 I get:
* 9.90 Gb/s with no macsec at all
* 1.80 Gb/s with macsec WITHOUT encryption
* 1.00 Gb/s (sometimes, but often less) with macsec WITH encryption

With 5.7 but with ab046a5d4be4c90a3952a0eae75617b49c0cb01b reverted, I get:
* 9.90 Gb/s with no macsec at all
* 7.33 Gb/s with macsec WITHOUT encryption
* 9.83 Gb/s with macsec WITH encryption

On tests where performance is bad (including macsec without encryption), 
iperf3 is at 100% CPU usage.  I was able to run it under `perf record`on 
iperf3 in a number of the tests but, unfortunately, I have had trouble 
compiling perf for my own 5.7 compilations (definitely PEBKAC).  If it 
would be useful I can work on fixing the perf compilation issues.

For 5.7.11-1.el8.elrepo (which has the issue) I get the following top 10 
items in `perf report`:
* MACsec without encryption - iperf3 instance running as server 
(receives data)
     29.92%  iperf3   [kernel.kallsyms]  [k] copy_user_enhanced_fast_string
      6.48%  iperf3   [kernel.kallsyms]  [k] do_syscall_64
      2.92%  iperf3   [kernel.kallsyms]  [k] syscall_return_via_sysret
      2.37%  iperf3   [kernel.kallsyms]  [k] entry_SYSCALL_64
      2.32%  iperf3   [kernel.kallsyms]  [k] __skb_datagram_iter
      2.26%  iperf3   [kernel.kallsyms]  [k] __free_pages_ok
      2.09%  iperf3   [kernel.kallsyms]  [k] tcp_poll
      1.75%  iperf3   [kernel.kallsyms]  [k] do_select
      1.48%  iperf3   [kernel.kallsyms]  [k] free_one_page
      1.44%  iperf3   [kernel.kallsyms]  [k] kmem_cache_free

* MACsec without encryption - iperf3 instance running as client (sends data)
     83.63%  iperf3   [kernel.kallsyms]  [k] gf128mul_4k_lle
      3.46%  iperf3   [kernel.kallsyms]  [k] ghash_update
      1.48%  iperf3   [kernel.kallsyms]  [k] copy_user_enhanced_fast_string
      1.18%  iperf3   [kernel.kallsyms]  [k] memcpy_erms
      1.17%  iperf3   [kernel.kallsyms]  [k] do_csum
      0.50%  iperf3   [kernel.kallsyms]  [k] _raw_spin_lock
      0.44%  iperf3   [kernel.kallsyms]  [k] __copy_skb_header
      0.36%  iperf3   [kernel.kallsyms]  [k] get_page_from_freelist
      0.23%  iperf3   [kernel.kallsyms]  [k] ixgbe_xmit_frame_ring
      0.22%  iperf3   [kernel.kallsyms]  [k] skb_segment

* MACsec with encryption - iperf3 instance running as server (receives data)
     15.66%  iperf3   [kernel.kallsyms]  [k] copy_user_enhanced_fast_string
      9.52%  iperf3   [kernel.kallsyms]  [k] do_syscall_64
      3.76%  iperf3   [kernel.kallsyms]  [k] syscall_return_via_sysret
      3.28%  iperf3   [kernel.kallsyms]  [k] entry_SYSCALL_64
      3.22%  iperf3   [kernel.kallsyms]  [k] do_select
      2.71%  iperf3   [kernel.kallsyms]  [k] tcp_poll
      1.84%  iperf3   [kernel.kallsyms]  [k] tcp_recvmsg
      1.59%  iperf3   [kernel.kallsyms]  [k] sock_poll
      1.38%  iperf3   [kernel.kallsyms]  [k] __skb_datagram_iter
      1.37%  iperf3   [kernel.kallsyms]  [k] __free_pages_ok

* MACsec with encryption - iperf3 instance running as client (sends data)
     43.95%  iperf3   [kernel.kallsyms]  [k] gf128mul_4k_lle
     17.48%  iperf3   [kernel.kallsyms]  [k] _aesni_enc1
      9.42%  iperf3   [kernel.kallsyms]  [k] kernel_fpu_begin
      7.75%  iperf3   [kernel.kallsyms]  [k] __crypto_xor
      3.18%  iperf3   [kernel.kallsyms]  [k] crypto_ctr_crypt
      2.67%  iperf3   [kernel.kallsyms]  [k] crypto_inc
      2.30%  iperf3   [kernel.kallsyms]  [k] aesni_encrypt
      2.05%  iperf3   [kernel.kallsyms]  [k] aesni_enc
      1.87%  iperf3   [kernel.kallsyms]  [k] ghash_update
      1.03%  iperf3   [kernel.kallsyms]  [k] kernel_fpu_end

Here is `ethtool -k em1` in case that is helpful:
Features for em1:
rx-checksumming: on
tx-checksumming: on
         tx-checksum-ipv4: off [fixed]
         tx-checksum-ip-generic: on
         tx-checksum-ipv6: off [fixed]
         tx-checksum-fcoe-crc: on [fixed]
         tx-checksum-sctp: on
scatter-gather: on
         tx-scatter-gather: on
         tx-scatter-gather-fraglist: off [fixed]
tcp-segmentation-offload: on
         tx-tcp-segmentation: on
         tx-tcp-ecn-segmentation: off [fixed]
         tx-tcp-mangleid-segmentation: off
         tx-tcp6-segmentation: on
generic-segmentation-offload: on
generic-receive-offload: on
large-receive-offload: off
rx-vlan-offload: on
tx-vlan-offload: on
ntuple-filters: off
receive-hashing: on
highdma: on [fixed]
rx-vlan-filter: on
vlan-challenged: off [fixed]
tx-lockless: off [fixed]
netns-local: off [fixed]
tx-gso-robust: off [fixed]
tx-fcoe-segmentation: on [fixed]
tx-gre-segmentation: on
tx-gre-csum-segmentation: on
tx-ipxip4-segmentation: on
tx-ipxip6-segmentation: on
tx-udp_tnl-segmentation: on
tx-udp_tnl-csum-segmentation: on
tx-gso-partial: on
tx-tunnel-remcsum-segmentation: off [fixed]
tx-sctp-segmentation: off [fixed]
tx-esp-segmentation: on
tx-udp-segmentation: on
tx-gso-list: off [fixed]
fcoe-mtu: off [fixed]
tx-nocache-copy: off
loopback: off [fixed]
rx-fcs: off [fixed]
rx-all: off
tx-vlan-stag-hw-insert: off [fixed]
rx-vlan-stag-hw-parse: off [fixed]
rx-vlan-stag-filter: off [fixed]
l2-fwd-offload: off
hw-tc-offload: off
esp-hw-offload: on
esp-tx-csum-hw-offload: on
rx-udp_tunnel-port-offload: on
tls-hw-tx-offload: off [fixed]
tls-hw-rx-offload: off [fixed]
rx-gro-hw: off [fixed]
tls-hw-record: off [fixed]
rx-gro-list: off
macsec-hw-offload: off [fixed]

I have lots of logs that I can provide if needed.

I thank Antoine Tenart for suggesting tests for this issue and for 
narrowing down which commits to check.

Thanks,
Ryan
