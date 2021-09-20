Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7BEF6411609
	for <lists+netdev@lfdr.de>; Mon, 20 Sep 2021 15:44:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239618AbhITNqR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Sep 2021 09:46:17 -0400
Received: from sender11-of-o53.zoho.eu ([31.186.226.239]:21829 "EHLO
        sender11-of-o53.zoho.eu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236385AbhITNqR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Sep 2021 09:46:17 -0400
X-Greylist: delayed 904 seconds by postgrey-1.27 at vger.kernel.org; Mon, 20 Sep 2021 09:46:16 EDT
ARC-Seal: i=1; a=rsa-sha256; t=1632144584; cv=none; 
        d=zohomail.eu; s=zohoarc; 
        b=afLQNKiajY4FEd5q/QKtZbXRZBUfhrokPf57jtc9EyAV20Z/pECmRWqGjTXGJieMxZPXvqRJ7sef6Juw/AwEaOHgBaMnhAPDiNuqZzIT0Ez+brh9XLiZhX/HRAKhG+V4hNgy6OF2KJh61iIMdzZWWggzhaSXSojrIJNztyWSLJM=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.eu; s=zohoarc; 
        t=1632144584; h=Content-Type:Content-Transfer-Encoding:Date:From:MIME-Version:Message-ID:Subject:To; 
        bh=HsRYjw0G15xnBFBys7SWjXT5SnHkIbqIR2bB/qrELUU=; 
        b=PFAMPoaAXaIatToxFl2+XPAqrMtCfrmHAK2hjUs+AO/UK6CJcgx2SIYaxoEb2twubfpBcQvVwHbbP2z1z/DSRmAYUo2hhl0nvhok1tAGa7oHUHSnJQcjryqsq6jA+jLFhShMq6DhSzL8KK+TmYA2s9Uj/FMzpZv/dC4nzc7dhQY=
ARC-Authentication-Results: i=1; mx.zohomail.eu;
        dkim=pass  header.i=bursov.com;
        spf=pass  smtp.mailfrom=vitaly@bursov.com;
        dmarc=pass header.from=<vitaly@bursov.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1632144584;
        s=zoho; d=bursov.com; i=vitaly@bursov.com;
        h=To:From:Subject:Message-ID:Date:MIME-Version:Content-Type:Content-Transfer-Encoding;
        bh=HsRYjw0G15xnBFBys7SWjXT5SnHkIbqIR2bB/qrELUU=;
        b=Pkkb2t+x4i+1dkib/GpUgseVzBhpZJYbxuLgJtH5lM/PFlUX34OmUdOlQcaTxi5g
        lmS3x5Xx8nm38PpxZVdEkW6w5KBTUkq09AzaOwwrJleIeLd6EPPyhRyofQjfem2FJyZ
        F6NGdfrJ3LUbkyGtLBx0CTVfg1bwih34cVkIiD3Y=
Received: from [192.168.11.99] (31.133.98.254 [31.133.98.254]) by mx.zoho.eu
        with SMTPS id 1632144582600975.4708918501769; Mon, 20 Sep 2021 15:29:42 +0200 (CEST)
To:     Siva Reddy Kallam <siva.kallam@broadcom.com>,
        Prashant Sreedharan <prashant@broadcom.com>,
        Michael Chan <mchan@broadcom.com>, netdev@vger.kernel.org
From:   Vitaly Bursov <vitaly@bursov.com>
Subject: tg3 RX packet re-order in queue 0 with RSS
Message-ID: <0a1d6421-b618-9fea-9787-330a18311ec0@bursov.com>
Date:   Mon, 20 Sep 2021 16:29:42 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: ru-RU
Content-Transfer-Encoding: 7bit
X-ZohoMailClient: External
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

We found a occassional and random (sometimes happens, sometimes not)
packet re-order when NIC is involved in UDP multicast reception, which
is sensitive to a packet re-order. Network capture with tcpdump
sometimes shows the packet re-order, sometimes not (e.g. no re-order on
a host, re-order in a container at the same time). In a pcap file
re-ordered packets have a correct timestamp - delayed packet had a more
earlier timestamp compared to a previous packet:
     1.00s packet1
     1.20s packet3
     1.10s packet2
     1.30s packet4

There's about 300Mbps of traffic on this NIC, and server is busy
(hyper-threading enabled, about 50% overall idle) with its
computational application work.

NIC is HPE's 4-port 331i adapter - BCM5719, in a default ring and
coalescing configuration, 1 TX queue, 4 RX queues.

After further investigation, I believe that there are two separate
issues in tg3.c driver. Issues can be reproduced with iperf3, and
unicast UDP.

Here are the details of how I understand this behavior.

1. Packet re-order.

Driver calls napi_schedule(&tnapi->napi) when handling the interrupt,
however, sometimes it calls napi_schedule(&tp->napi[1].napi), which
handles RX queue 0 too:

     https://github.com/torvalds/linux/blob/master/drivers/net/ethernet/broadcom/tg3.c#L6802-L7007

     static int tg3_rx(struct tg3_napi *tnapi, int budget)
     {
             struct tg3 *tp = tnapi->tp;

             ...

             /* Refill RX ring(s). */
             if (!tg3_flag(tp, ENABLE_RSS)) {
                     ....
             } else if (work_mask) {
                     ...

                     if (tnapi != &tp->napi[1]) {
                             tp->rx_refill = true;
                             napi_schedule(&tp->napi[1].napi);
                     }
             }
             ...
     }

 From napi_schedule() code, it should schedure RX 0 traffic handling on
a current CPU, which handles queues RX1-3 right now.

At least two traffic flows are required - one on RX queue 0, and the
other on any other queue (1-3). Re-ordering may happend only on flow
from queue 0, the second flow will work fine.

No idea how to fix this.

There are two ways to mitigate this:

   1. Enable RPS by writting any non-zero mask to
      /sys/class/net/enp2s0f0/queues/rx-0/rps_cpus This encorces CPU
      when processing traffic, and overrides whatever "current" CPU for
      RX queue 0 is in this moment.

   2. Configure RX hash flow redirection with: ethtool -X enp2s0f0
      weight 0 1 1 1 to exclude RX queue 0 from handling the traffic.


2. RPS configuration

Before napi_gro_receive() call, there's no call to skb_record_rx_queue():

     static int tg3_rx(struct tg3_napi *tnapi, int budget)
     {
             struct tg3 *tp = tnapi->tp;
             u32 work_mask, rx_std_posted = 0;
             u32 std_prod_idx, jmb_prod_idx;
             u32 sw_idx = tnapi->rx_rcb_ptr;
             u16 hw_idx;
             int received;
             struct tg3_rx_prodring_set *tpr = &tnapi->prodring;

             ...

                     napi_gro_receive(&tnapi->napi, skb);


                     received++;
                     budget--;
             ...


As a result, queue_mapping is always 0/not set, and RPS handles all
traffic as originating from queue 0.

           <idle>-0     [013] ..s. 14030782.234664: napi_gro_receive_entry: dev=enp2s0f0 napi_id=0x0 queue_mapping=0 ...

RPS configuration for rx-1 to to rx-3 has no effect.


NIC:
02:00.0 Ethernet controller: Broadcom Inc. and subsidiaries NetXtreme BCM5719 Gigabit Ethernet PCIe (rev 01)
     Subsystem: Hewlett-Packard Company Ethernet 1Gb 4-port 331i Adapter
     Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr+ Stepping- SERR+ FastB2B- DisINTx+
     Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
     Latency: 0, Cache Line Size: 64 bytes
     Interrupt: pin A routed to IRQ 16
     NUMA node: 0
     Region 0: Memory at d9d90000 (64-bit, prefetchable) [size=64K]
     Region 2: Memory at d9da0000 (64-bit, prefetchable) [size=64K]
     Region 4: Memory at d9db0000 (64-bit, prefetchable) [size=64K]
     [virtual] Expansion ROM at d9c00000 [disabled] [size=256K]
     Capabilities: <access denied>
     Kernel driver in use: tg3
     Kernel modules: tg3

Linux kernel:
     CentOS 7 - 3.10.0-1160.15.2
     Ubuntu - 5.4.0-80.90

Network configuration:
     iperf3 (sender) - [LAN] - NIC (enp2s0f0) - Bridge (br0) - veth (v1) - namespace veth (v2) - iperf3 (receiver 1)

     brctl addbr br0
     ip l set up dev br0
     ip a a 10.10.10.10/24 dev br0
     ip r a default via 10.10.10.1 dev br0
     ip l set dev enp2s0f0 master br0
     ip l set up dev enp2s0f0

     ip netns add n1
     ip link add v1 type veth peer name v2
     ip l set up dev v1
     ip l set dev v1 master br0
     ip l set dev v2 netns n1

     ip netns exec n1 bash
     ip l set up dev lo
     ip l set up dev v2
     ip a a 10.10.10.11/24 dev v2

     "receiver 2" has the same configuration but different IP and different namespace.

Iperf3:

     Sender runs iperfs: iperf3 -s -p 5201 & iperf3 -s -p 5202 &
     Receiver's iperf3 -c 10.10.10.1 -R -p 5201 -u -l 163 -b 200M -t 300

-- 
Thanks
Vitalii

