Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1980F40874A
	for <lists+netdev@lfdr.de>; Mon, 13 Sep 2021 10:44:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238208AbhIMIpT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Sep 2021 04:45:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:35594 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238084AbhIMIpO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 13 Sep 2021 04:45:14 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A051E60F58;
        Mon, 13 Sep 2021 08:43:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631522637;
        bh=q+ZH/C5x0FNGmn9ETKdlbFz6peLOM+PMwE/+FHWOQZI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=O3nB85auqOX6v/Mq4b9/rR/d0c+JISgiOy8kLpPT3l3KmNB2EEtpC0dYT6f/WYSzF
         o72OHsKk4bWrs1/4b+HauAp5nlC4asFg9IF6UiAdxIP1apZtHAvwuuULqrr1cZsj1T
         5Qrp7E1c/uiDg8boZLxxWztvedusqaNGJafl9Hw8=
Date:   Mon, 13 Sep 2021 10:36:49 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     =?iso-8859-1?Q?H=E5kon?= Bugge <haakon.bugge@oracle.com>
Cc:     sashal@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        stable@vger.kernel.org, dledford@redhat.com, jgg@nvidia.com,
        linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org,
        gnault@redhat.com
Subject: Re: [PATCH 5.4] netns: protect netns ID lookups with RCU
Message-ID: <YT8Noe9uawxlrPS9@kroah.com>
References: <1631368706-22561-1-git-send-email-haakon.bugge@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1631368706-22561-1-git-send-email-haakon.bugge@oracle.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Sep 11, 2021 at 03:58:26PM +0200, Håkon Bugge wrote:
> From: Guillaume Nault <gnault@redhat.com>
> 
> __peernet2id() can be protected by RCU as it only calls idr_for_each(),
> which is RCU-safe, and never modifies the nsid table.
> 
> rtnl_net_dumpid() can also do lockless lookups. It does two nested
> idr_for_each() calls on nsid tables (one direct call and one indirect
> call because of rtnl_net_dumpid_one() calling __peernet2id()). The
> netnsid tables are never updated. Therefore it is safe to not take the
> nsid_lock and run within an RCU-critical section instead.
> 
> Signed-off-by: Guillaume Nault <gnault@redhat.com>
> Signed-off-by: David S. Miller <davem@davemloft.net>
> 
> A nice side-effect of replacing spin_{lock,unlock}_bh() with
> rcu_spin_{lock,unlock}() in peernet2id() is that it avoids the
> situation where SoftIRQs get enabled whilst IRQs are turned off.
> 
> >From bugzilla.redhat.com/show_bug.cgi?id=1384179 (an ancient
> 4.9.0-0.rc0 kernel):
> 
> dump_stack+0x86/0xc3
> __warn+0xcb/0xf0
> warn_slowpath_null+0x1d/0x20
> __local_bh_enable_ip+0x9d/0xc0
> _raw_spin_unlock_bh+0x35/0x40
> peernet2id+0x54/0x80
> netlink_broadcast_filtered+0x220/0x3c0
> netlink_broadcast+0x1d/0x20
> audit_log+0x6a/0x90
> security_set_bools+0xee/0x200
> []
> 
> Note, security_set_bools() calls write_lock_irq(). peernet2id() calls
> spin_unlock_bh().
> 
> >From an internal (UEK) stack trace based on the v4.14.35 kernel (LTS
> 4.14.231):
> 
> queued_spin_lock_slowpath+0xb/0xf
> _raw_spin_lock_irqsave+0x46/0x48
> send_mad+0x3d2/0x590 [ib_core]
> ib_sa_path_rec_get+0x223/0x4d0 [ib_core]
> path_rec_start+0xa3/0x140 [ib_ipoib]
> ipoib_start_xmit+0x2b0/0x6a0 [ib_ipoib]
> dev_hard_start_xmit+0xb2/0x237
> sch_direct_xmit+0x114/0x1bf
> __dev_queue_xmit+0x592/0x818
> dev_queue_xmit+0x10/0x12
> arp_xmit+0x38/0xa6
> arp_send_dst.part.16+0x61/0x84
> arp_process+0x825/0x889
> arp_rcv+0x140/0x1c9
> __netif_receive_skb_core+0x401/0xb39
> __netif_receive_skb+0x18/0x59
> netif_receive_skb_internal+0x45/0x119
> napi_gro_receive+0xd8/0xf6
> ipoib_ib_handle_rx_wc+0x1ca/0x520 [ib_ipoib]
> ipoib_poll+0xcd/0x150 [ib_ipoib]
> net_rx_action+0x289/0x3f4
> __do_softirq+0xe1/0x2b5
> do_softirq_own_stack+0x2a/0x35
> </IRQ>
> do_softirq+0x4d/0x6a
> __local_bh_enable_ip+0x57/0x59
> _raw_spin_unlock_bh+0x23/0x25
> peernet2id+0x51/0x73
> netlink_broadcast_filtered+0x223/0x41b
> netlink_broadcast+0x1d/0x1f
> rdma_nl_multicast+0x22/0x30 [ib_core]
> send_mad+0x3e5/0x590 [ib_core]
> ib_sa_path_rec_get+0x223/0x4d0 [ib_core]
> rdma_resolve_route+0x287/0x810 [rdma_cm]
> rds_rdma_cm_event_handler_cmn+0x311/0x7d0 [rds_rdma]
> rds_rdma_cm_event_handler_worker+0x22/0x30 [rds_rdma]
> process_one_work+0x169/0x3a6
> worker_thread+0x4d/0x3e5
> kthread+0x105/0x138
> ret_from_fork+0x24/0x49

Please keep the original git changelog intact, otherwise it will mess
with people who track these things.

> 
> Here, pay attention to ib_nl_make_request() which calls
> spin_lock_irqsave() on a global lock just before calling
> rdma_nl_multicast(). Thereafter, peernet2id() enables SoftIRQs, and
> ipoib starts and calls the same path and ends up trying to acquire the
> same global lock again.
> 
> (cherry picked from commit 2dce224f469f060b9998a5a869151ef83c08ce77)
> 
> Fixes: fba143c66abb ("netns: avoid disabling irq for netns id")
> Signed-off-by: Håkon Bugge <haakon.bugge@oracle.com>
> 
> Conflicts:
> 	net/core/net_namespace.c
> 
> 		* Due to context differences because v5.4 lacks commit
>                   4905294162bd ("netns: Remove __peernet2id_alloc()").
> 		  Only comments affected.

No need for git conflicts messages here either :(

I'll go fix this up by hand...

thanks,

greg k-h
