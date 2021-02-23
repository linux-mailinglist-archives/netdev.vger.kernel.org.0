Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA6623227A8
	for <lists+netdev@lfdr.de>; Tue, 23 Feb 2021 10:20:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232016AbhBWJSU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Feb 2021 04:18:20 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:49566 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231414AbhBWJSQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Feb 2021 04:18:16 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1614071807;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=OsJLiDRGiG9P2aNoCz5qcdbP/LSSjGoISGaEFpWYN4w=;
        b=WlCOApsgnq8KeyV/9RLbrwCp5llV/mz1OBVrfGBfCPm21X+o0Mfrd6fXIY5fHjgEZOqagd
        L3NArgDviBkXNy8ZnyfpLqsyZ7n7DogfF4a9pSkte+35uXE90k0SerT3dFfpnmJ7xn/emO
        w6WfqEcHjpF07LcUsuBVXAYMV4ARt5c=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-20-4iObohe_Nx2n4gGEPPd7mA-1; Tue, 23 Feb 2021 04:16:26 -0500
X-MC-Unique: 4iObohe_Nx2n4gGEPPd7mA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2B7BE80402E;
        Tue, 23 Feb 2021 09:16:24 +0000 (UTC)
Received: from carbon (unknown [10.36.110.50])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 438AA1002388;
        Tue, 23 Feb 2021 09:16:18 +0000 (UTC)
Date:   Tue, 23 Feb 2021 10:16:16 +0100
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Tariq Toukan <ttoukan.linux@gmail.com>
Cc:     netdev@vger.kernel.org, Saeed Mahameed <saeedm@mellanox.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, saeedm@nvidia.com,
        Tariq Toukan <tariqt@mellanox.com>, eranbe@nvidia.com,
        maximmi@mellanox.com, Tariq Toukan <tariqt@nvidia.com>,
        brouer@redhat.com
Subject: Re: [PATCH RFC net-next] mlx5: fix for crash on net-next
Message-ID: <20210223101616.6a05ca59@carbon>
In-Reply-To: <b0967766-623a-90fa-3875-db9e1ad6a57f@gmail.com>
References: <161402344429.1980160.4798557236979159924.stgit@firesoul>
        <b0967766-623a-90fa-3875-db9e1ad6a57f@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 23 Feb 2021 10:28:35 +0200
Tariq Toukan <ttoukan.linux@gmail.com> wrote:

> On 2/22/2021 9:50 PM, Jesper Dangaard Brouer wrote:
> > Net-next at commit d310ec03a34e ("Merge tag 'perf-core-2021-02-17')
> > 
> > There is a divide error in drivers/net/ethernet/mellanox/mlx5/core/en_tx.c
> > where it seems that num_tc_x_num_ch can become zero in a modulo operation:
> > 
> > 	if (unlikely(txq_ix >= num_tc_x_num_ch))
> > 		txq_ix %= num_tc_x_num_ch;
> > 
> > I think error were introduced in:
> >   - 214baf22870c ("net/mlx5e: Support HTB offload")
> > 
> > The modulo operation was introduced in:
> >   - 145e5637d941 ("net/mlx5e: Add TX PTP port object support")
> > 
> > The crash looks like this:
> > 
> > [   12.112849] divide error: 0000 [#1] PREEMPT SMP PTI
> > [   12.117727] CPU: 4 PID: 0 Comm: swapper/4 Not tainted 5.11.0-net-next+ #575
> > [   12.124677] Hardware name: Supermicro Super Server/X10SRi-F, BIOS 2.0a 08/01/2016
> > [   12.132149] RIP: 0010:mlx5e_select_queue+0xd5/0x1e0 [mlx5_core]
> > [   12.138110] Code: 85 c0 75 2e 48 83 bb 08 57 00 00 00 75 5b 31 d2 48 89 ee 48 89 df e8 ba 3e 54 e1 0f b7 d0 41 39 d4 0f 8f 6b ff ff ff 89 d0 99 <41> f7 fc e9 60 ff ff ff 8b 96 8c 00 00 00 89 d1 c1 e9 10 39 c1 0f
> > [   12.156849] RSP: 0018:ffffc900001c0c10 EFLAGS: 00010297
> > [   12.162065] RAX: 0000000000000004 RBX: ffff88810ff00000 RCX: 0000000000000007
> > [   12.169188] RDX: 0000000000000000 RSI: ffff888107016400 RDI: ffff8881008dc740
> > [   12.176313] RBP: ffff888107016400 R08: 0000000000000000 R09: 000000ncing: Fatal exception in interrupt ]---
> > 
> > This is an RFC, because I don't think this is a proper fix, but
> > at least it allows me to boot with mlx5 driver enabled.
> > 
> > Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
> > ---  
> 
> Hi Jesper,
> 
> Thanks for your report and patch.
> 
> We'll check it and post the proper fix.
> I wonder what's special in your configuration / use case, as I'm not 
> aware of such failure.
> Can you please share more info about the reproduction?

The machine simply crash under boot, that is how I reproduced.

You should look at why: num_tc_x_num_ch can be zero in:

 u16 mlx5e_select_queue(struct net_device *dev, struct sk_buff *skb,
		       struct net_device *sb_dev)
 {
   [...]
   num_tc_x_num_ch = READ_ONCE(priv->num_tc_x_num_ch);


Here are some info on the mlx5 NIC I'm using:

$ ethtool -i mlx5p1
driver: mlx5_core
version: 5.11.0-net-next-alloc_pages_bul
firmware-version: 16.23.1020 (MT_0000000009)
expansion-rom-version: 
bus-info: 0000:03:00.0
supports-statistics: yes
supports-test: yes
supports-eeprom-access: no
supports-register-dump: no
supports-priv-flags: yes

03:00.0 Ethernet controller: Mellanox Technologies MT28800 Family [ConnectX-5 Ex]
        Subsystem: Mellanox Technologies Device 0002
        Physical Slot: 0
        Flags: bus master, fast devsel, latency 0, IRQ 26
        Memory at f0000000 (64-bit, prefetchable) [size=32M]
        Expansion ROM at fba00000 [disabled] [size=1M]
        Capabilities: [60] Express Endpoint, MSI 00
        Capabilities: [48] Vital Product Data
        Capabilities: [9c] MSI-X: Enable+ Count=64 Masked-
        Capabilities: [c0] Vendor Specific Information: Len=18 <?>
        Capabilities: [40] Power Management version 3
        Capabilities: [100] Advanced Error Reporting
        Capabilities: [150] Alternative Routing-ID Interpretation (ARI)
        Capabilities: [1c0] Secondary PCI Express
        Capabilities: [230] Access Control Services
        Capabilities: [320] Lane Margining at the Receiver <?>
        Capabilities: [370] Physical Layer 16.0 GT/s <?>
        Capabilities: [420] Data Link Feature <?>
        Kernel driver in use: mlx5_core
        Kernel modules: mlx5_core

03:00.1 Ethernet controller: Mellanox Technologies MT28800 Family [ConnectX-5 Ex]
        Subsystem: Mellanox Technologies Device 0002
        Physical Slot: 0
        Flags: bus master, fast devsel, latency 0, IRQ 86
        Memory at ee000000 (64-bit, prefetchable) [size=32M]
        Expansion ROM at fb900000 [disabled] [size=1M]
        Capabilities: [60] Express Endpoint, MSI 00
        Capabilities: [48] Vital Product Data
        Capabilities: [9c] MSI-X: Enable+ Count=64 Masked-
        Capabilities: [c0] Vendor Specific Information: Len=18 <?>
        Capabilities: [40] Power Management version 3
        Capabilities: [100] Advanced Error Reporting
        Capabilities: [150] Alternative Routing-ID Interpretation (ARI)
        Capabilities: [230] Access Control Services
        Capabilities: [420] Data Link Feature <?>
        Kernel driver in use: mlx5_core
        Kernel modules: mlx5_core

-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

