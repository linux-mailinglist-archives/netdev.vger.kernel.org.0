Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3494620712B
	for <lists+netdev@lfdr.de>; Wed, 24 Jun 2020 12:31:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388719AbgFXKbC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jun 2020 06:31:02 -0400
Received: from correo.us.es ([193.147.175.20]:55778 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387962AbgFXKbC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 24 Jun 2020 06:31:02 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 9518FD2DA0B
        for <netdev@vger.kernel.org>; Wed, 24 Jun 2020 12:31:00 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 83B6EDA840
        for <netdev@vger.kernel.org>; Wed, 24 Jun 2020 12:31:00 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 77D02DA78D; Wed, 24 Jun 2020 12:31:00 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 45880DA78C;
        Wed, 24 Jun 2020 12:30:58 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Wed, 24 Jun 2020 12:30:58 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 2324642EF42C;
        Wed, 24 Jun 2020 12:30:58 +0200 (CEST)
Date:   Wed, 24 Jun 2020 12:30:57 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Vlad Buslov <vladbu@mellanox.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jiri Pirko <jiri@resnulli.us>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Roi Dayan <roid@mellanox.com>,
        Majd Dibbiny <majd@mellanox.com>,
        Maor Dickman <maord@mellanox.com>
Subject: Re: Crash in indirect block infra after unloading driver module
Message-ID: <20200624103057.GA30577@salvia>
References: <vbfbll8yd96.fsf@mellanox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <vbfbll8yd96.fsf@mellanox.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 24, 2020 at 01:22:29PM +0300, Vlad Buslov wrote:
> Hi Pablo,
> 
> I've encountered a new issue with indirect offloads infrastructure. The
> issue is that on driver offload its indirect callbacks are not removed
> from blocks and any following offloads operations on block that has such
> callback in its offloads cb list causes call to unmapped address.
> 
> Steps to reproduce:
> 
> echo 1 >/sys/class/net/ens1f0/device/sriov_numvfs
> echo 0000:81:00.2 > /sys/bus/pci/drivers/mlx5_core/unbind
> devlink dev eswitch set pci/0000:81:00.0 mode switchdev
> 
> ip link add vxlan1 type vxlan dstport 4789 external
> ip addr add 192.168.1.1 dev ens1f0
> link set up dev ens1f0
> ip link set up dev ens1f0
> tc qdisc add dev vxlan1 ingress
> tc filter add dev vxlan1 protocol ip ingress flower enc_src_ip 192.168.1.2 enc_dst_ip 192.168.1.1 enc_key_id 42 enc_dst_port 4789 action tunnel_key unset action mirred egress redirect dev ens1f0_0
> tc -s filter show dev vxlan1 ingress
> 
> rmmod mlx5_ib
> rmmod mlx5_core
> tc -s filter show dev vxlan1 ingress

On module removal, the representors are gone and the ->cleanup
callback should be exercised, this callback removes the flow_block and
removes the rules in the driver.

Can you check if the ->cleanup callback is exercised?

> Resulting dmesg:
> 
> [  153.747853] BUG: unable to handle page fault for address: ffffffffc114cee0
> [  153.747975] #PF: supervisor instruction fetch in kernel mode
> [  153.748071] #PF: error_code(0x0010) - not-present page
> [  153.748189] PGD 5b6c12067 P4D 5b6c12067 PUD 5b6c14067 PMD 35b76b067 PTE 0
> [  153.748328] Oops: 0010 [#1] SMP KASAN PTI
> [  153.748403] CPU: 1 PID: 1909 Comm: tc Not tainted 5.8.0-rc1+ #1170
> [  153.748507] Hardware name: Supermicro SYS-2028TP-DECR/X10DRT-P, BIOS 2.0b 03/30/2017
> [  153.748638] RIP: 0010:0xffffffffc114cee0
> [  153.748709] Code: Bad RIP value.
> [  153.748767] RSP: 0018:ffff88834895ef00 EFLAGS: 00010246
> [  153.748858] RAX: 0000000000000000 RBX: ffff888330a30078 RCX: ffffffffb2da70ba
> [  153.748975] RDX: ffff888333635d80 RSI: ffff88834895efa0 RDI: 0000000000000002
> [  153.752948] RBP: 0000000000000002 R08: 0000000000000001 R09: ffffed106614600c
> [  153.759173] R10: ffff888330a3005f R11: ffffed106614600b R12: ffff88834895efa0
> [  153.765419] R13: 0000000000000000 R14: ffffffffc114cee0 R15: ffff8883470efe00
> [  153.771689] FS:  00007f6f6ac12480(0000) GS:ffff888362e40000(0000) knlGS:0000000000000000
> [  153.777983] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [  153.784187] CR2: ffffffffc114ceb6 CR3: 000000035eb9e005 CR4: 00000000001606e0
> [  153.790567] Call Trace:
> [  153.796844]  ? tc_setup_cb_call+0xd8/0x170
> [  153.803164]  ? fl_hw_update_stats+0x117/0x280 [cls_flower]
> [  153.809516]  ? 0xffffffffc1328000
> [  153.815766]  ? _find_next_bit.constprop.0+0x3e/0xf0
> [  153.822079]  ? __nla_reserve+0x4c/0x60
[...]
> 
> I can come up with something to fix mlx5 but it looks like all other
> drivers that support indirect devices are also susceptible to similar
> issue.

How does the fix you have in mind look like?

Thanks.
