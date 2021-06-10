Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E7223A2124
	for <lists+netdev@lfdr.de>; Thu, 10 Jun 2021 02:04:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230017AbhFJAGa convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 9 Jun 2021 20:06:30 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:58428 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229911AbhFJAGa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Jun 2021 20:06:30 -0400
Received: from 1.general.jvosburgh.us.vpn ([10.172.68.206] helo=famine.localdomain)
        by youngberry.canonical.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.93)
        (envelope-from <jay.vosburgh@canonical.com>)
        id 1lr8BT-0006de-7c; Thu, 10 Jun 2021 00:04:31 +0000
Received: by famine.localdomain (Postfix, from userid 1000)
        id 686A85FDD5; Wed,  9 Jun 2021 17:04:29 -0700 (PDT)
Received: from famine (localhost [127.0.0.1])
        by famine.localdomain (Postfix) with ESMTP id 60D9EA040B;
        Wed,  9 Jun 2021 17:04:29 -0700 (PDT)
From:   Jay Vosburgh <jay.vosburgh@canonical.com>
To:     Jussi Maki <joamaki@gmail.com>
cc:     bpf@vger.kernel.org, netdev@vger.kernel.org, daniel@iogearbox.net,
        andy@greyhouse.net, vfalico@gmail.com, andrii@kernel.org
Subject: Re: [PATCH bpf-next 2/3] net: bonding: Use per-cpu rr_tx_counter
In-reply-to: <20210609135537.1460244-3-joamaki@gmail.com>
References: <20210609135537.1460244-1-joamaki@gmail.com> <20210609135537.1460244-3-joamaki@gmail.com>
Comments: In-reply-to Jussi Maki <joamaki@gmail.com>
   message dated "Wed, 09 Jun 2021 13:55:36 -0000."
X-Mailer: MH-E 8.6+git; nmh 1.6; GNU Emacs 27.0.50
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <22629.1623283469.1@famine>
Content-Transfer-Encoding: 8BIT
Date:   Wed, 09 Jun 2021 17:04:29 -0700
Message-ID: <22630.1623283469@famine>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jussi Maki <joamaki@gmail.com> wrote:

>The round-robin rr_tx_counter was shared across CPUs leading
>to significant cache trashing at high packet rates. This patch

	"trashing" -> "thrashing" ?

>switches the round-robin mechanism to use a per-cpu counter to
>decide the destination device.
>
>On a 100Gbit 64 byte packet test this reduces the CPU load from
>50% to 10% on the test system.
>
>Signed-off-by: Jussi Maki <joamaki@gmail.com>
>---
> drivers/net/bonding/bond_main.c | 18 +++++++++++++++---
> include/net/bonding.h           |  2 +-
> 2 files changed, 16 insertions(+), 4 deletions(-)
>
>diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
>index 38eea7e096f3..917dd2cdcbf4 100644
>--- a/drivers/net/bonding/bond_main.c
>+++ b/drivers/net/bonding/bond_main.c
>@@ -4314,16 +4314,16 @@ static u32 bond_rr_gen_slave_id(struct bonding *bond)
> 		slave_id = prandom_u32();
> 		break;
> 	case 1:
>-		slave_id = bond->rr_tx_counter;
>+		slave_id = this_cpu_inc_return(*bond->rr_tx_counter);
> 		break;
> 	default:
> 		reciprocal_packets_per_slave =
> 			bond->params.reciprocal_packets_per_slave;
>-		slave_id = reciprocal_divide(bond->rr_tx_counter,
>+		slave_id = this_cpu_inc_return(*bond->rr_tx_counter);
>+		slave_id = reciprocal_divide(slave_id,
> 					     reciprocal_packets_per_slave);

	With the rr_tx_counter is per-cpu, each CPU is essentially doing
its own round-robin logic, independently of other CPUs, so the resulting
spread of transmitted packets may not be as evenly distributed (as
multiple CPUs could select the same interface to transmit on
approximately in lock-step).  I'm not sure if this could cause actual
problems in practice, though, as particular flows shouldn't skip between
CPUs (and thus rr_tx_counters) very often, and round-robin already
shouldn't be the first choice if no packet reordering is a hard
requirement.

	I think this patch could be submitted against net-next
independently of the rest of the series.

Acked-by: Jay Vosburgh <jay.vosburgh@canonical.com>

	-J

> 		break;
> 	}
>-	bond->rr_tx_counter++;
> 
> 	return slave_id;
> }
>@@ -5278,6 +5278,9 @@ static void bond_uninit(struct net_device *bond_dev)
> 
> 	list_del(&bond->bond_list);
> 
>+	if (BOND_MODE(bond) == BOND_MODE_ROUNDROBIN)
>+		free_percpu(bond->rr_tx_counter);
>+
> 	bond_debug_unregister(bond);
> }
> 
>@@ -5681,6 +5684,15 @@ static int bond_init(struct net_device *bond_dev)
> 	if (!bond->wq)
> 		return -ENOMEM;
> 
>+	if (BOND_MODE(bond) == BOND_MODE_ROUNDROBIN) {
>+		bond->rr_tx_counter = alloc_percpu(u32);
>+		if (!bond->rr_tx_counter) {
>+			destroy_workqueue(bond->wq);
>+			bond->wq = NULL;
>+			return -ENOMEM;
>+		}
>+	}
>+
> 	spin_lock_init(&bond->stats_lock);
> 	netdev_lockdep_set_classes(bond_dev);
> 
>diff --git a/include/net/bonding.h b/include/net/bonding.h
>index 34acb81b4234..8de8180f1be8 100644
>--- a/include/net/bonding.h
>+++ b/include/net/bonding.h
>@@ -232,7 +232,7 @@ struct bonding {
> 	char     proc_file_name[IFNAMSIZ];
> #endif /* CONFIG_PROC_FS */
> 	struct   list_head bond_list;
>-	u32      rr_tx_counter;
>+	u32 __percpu *rr_tx_counter;
> 	struct   ad_bond_info ad_info;
> 	struct   alb_bond_info alb_info;
> 	struct   bond_params params;
>-- 
>2.30.2
>
