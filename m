Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 51ACF36EA2E
	for <lists+netdev@lfdr.de>; Thu, 29 Apr 2021 14:15:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235958AbhD2MQg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Apr 2021 08:16:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231490AbhD2MQf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Apr 2021 08:16:35 -0400
Received: from mail-oi1-x232.google.com (mail-oi1-x232.google.com [IPv6:2607:f8b0:4864:20::232])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4ECF7C06138B;
        Thu, 29 Apr 2021 05:15:48 -0700 (PDT)
Received: by mail-oi1-x232.google.com with SMTP id i81so66270690oif.6;
        Thu, 29 Apr 2021 05:15:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=7JOIpT+gpkrmnjjclA5CWTgL1Tfw2rNWt1HrwDtAo0o=;
        b=jsP2RMexicFTW5DTFSLZ1KPpxJ34rjzBbFmTBW2sUIo1YgMHrEPMftm8gsBzUmwzbQ
         i7tqCNONGzqSYP9bUP5yMh8+awNqVvli7+uEGMCkKE6g3Vfu2V652cyE1u5XiG4su8Ip
         zJFvb0GzsCgN1bXIu9VNb/1daa7PDfqQvh+nzq0kUZiSUcQgrCgobjlnwYEIOglIKmXt
         A+YN9B4SefPb0If0GF62yfbzFFfJi/p0nsGHJlfBVMF6z8MnYnGoF0sQOv15DvjmhodH
         pLulFOMLFhNHPlUgDczQzpu2TZ5MGAVr5eCHGosKZsw8k/0Bbp7ZuuLJ0Fq1o9gADhvp
         C9BA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=7JOIpT+gpkrmnjjclA5CWTgL1Tfw2rNWt1HrwDtAo0o=;
        b=l0JNuGartNdba9dUBR6Kn973kNIFZnCPL1CVs1Mb9R16q4UUeYWrYd0Uq/+QoJmK+B
         2gayMRVxFsQunE7HvfGAR5PZ6mTWfMeofrjUlO/Vbz8Kv4PXbsoeQOSAwbUYExnfq8Qg
         OxhKMOnyXa3Dvqtz9lCdhI2QRhL52AhrLFb7BloM1hNGFBofpIUMsz99QuJEddQI5TNu
         cSTVeJjJe6YusIjCeM9GOJLsbP26VqZuiJHbsWX7X0+nSVW6WTAelYyEIBtpzesV6+rX
         eaZMl6Fv7oTWg1vbKWIpVq6gDuKFNWx/orvMyYaK7n6e2Aix1t7hbRU8yaGvpnpm1Zwr
         gpIw==
X-Gm-Message-State: AOAM533k7A59AdMYwCUF1G3rC1T7ZPLN6KMunVL6qwXIkL4auTAeZnlc
        /AJPLp6ovnpxFrlC78smqmd8JieNs8zrDPWD2Ns=
X-Google-Smtp-Source: ABdhPJz+Ux2N/YD6IWPcdk9lo0W8iarZD34+mYqN52kQxdAaACM7v/FrBKVgReBD18iwlf7NvuEqsbMMSSQ/CutNLQY=
X-Received: by 2002:aca:cf09:: with SMTP id f9mr6624326oig.95.1619698547741;
 Thu, 29 Apr 2021 05:15:47 -0700 (PDT)
MIME-Version: 1.0
From:   Jason Xing <kerneljasonxing@gmail.com>
Date:   Thu, 29 Apr 2021 20:15:12 +0800
Message-ID: <CAL+tcoDuY6D6j6zO9XSzkUCom9jdD4ydidUL5S8Pt-dqd69EGw@mail.gmail.com>
Subject: soft lockup in __inet_lookup_established() function
To:     David Miller <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        dsahern@kernel.org, kuba@kernel.org
Cc:     netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        liweishi <liweishi@kuaishou.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

I've encountered one big issue which causes infinite loop in
__inet_lookup_established() function until I reboot manually. it's
happening randomly among thousands of machines with the 4.19 kernel
running. Once the soft lockup issue is triggered, whatever I try I
still cannot ping or ssh to the machine anymore until reboot.

Does anyone have any clue on how to dig into this part of code?  I
highly suspect that it has something to do with the corruption of
nulls_list, so the lookup of sk could never break the infinite loop of
hashinfo.

These call traces are totally identical attached below:
[1048271.465028] watchdog: BUG: soft lockup - CPU#20 stuck for 22s!
[swapper/20:0]
[1048271.473669] Modules linked in: vxlan ip6_udp_tunnel udp_tunnel
udp_diag tcp_diag inet_diag nf_conntrack_netlink nfnetlink
br_netfilter bridge stp llc xt_statistic xt_nat ipt_MASQUERADE
ipt_REJECT nf_reject_ipv4 xt_mark xt_addrtype xt_comment xt_conntrack
...
[1048271.553597] RIP: 0010:__inet_lookup_established+0x5a/0x190
...
[1048271.660309] Call Trace:
[1048271.663135]  <IRQ>
[1048271.665432]  tcp_v4_early_demux+0xaa/0x150
[1048271.669812]  ip_rcv_finish+0x171/0x410
[1048271.673941]  ip_rcv+0x273/0x362
[1048271.677360]  ? inet_add_protocol.cold.1+0x1e/0x1e
[1048271.682354]  __netif_receive_skb_core+0xac2/0xbb0
[1048271.687351]  ? inet_gro_receive+0x22a/0x2d0
[1048271.692001]  ? ktime_get_with_offset+0x4d/0xc0
[1048271.696725]  netif_receive_skb_internal+0x42/0xf0
[1048271.701717]  napi_gro_receive+0xba/0xe0
[1048271.705839]  receive_buf+0x165/0xa50 [virtio_net]
[1048271.710839]  ? receive_buf+0x165/0xa50 [virtio_net]
[1048271.716053]  ? vring_unmap_one+0x16/0x80
[1048271.720308]  ? detach_buf+0x69/0x110
[1048271.724218]  virtnet_poll+0xc0/0x2ea [virtio_net]
[1048271.729202]  net_rx_action+0x149/0x3b0
[1048271.733234]  __do_softirq+0xe3/0x30a
[1048271.737095]  irq_exit+0x100/0x110
[1048271.740882]  do_IRQ+0x85/0xd0
[1048271.744143]  common_interrupt+0xf/0xf
[1048271.748104]  </IRQ>


thanks,
jason
