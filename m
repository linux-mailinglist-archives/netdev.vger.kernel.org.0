Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 42A3B2E7218
	for <lists+netdev@lfdr.de>; Tue, 29 Dec 2020 17:06:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726308AbgL2QGG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Dec 2020 11:06:06 -0500
Received: from m43-15.mailgun.net ([69.72.43.15]:23456 "EHLO
        m43-15.mailgun.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726284AbgL2QGF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Dec 2020 11:06:05 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1609257945; h=Content-Type: MIME-Version: Message-ID:
 Subject: Cc: To: From: Date: Sender;
 bh=MrLEyDoy4U+qDhjVOhW1FGaywHn8k0fvC5AU7BWFeQs=; b=rK2I2lpfgYfWeneVJWYxOpqoRyv+6lIfwt8jyyimsGMKyNpOixk0lxSwXk+BzMnXo1TGmf07
 SfND98FhtktQ0DAyKYGIgavwnbBDSzbyG5DlTdlId0P14De8m3Ag6QwW5cgoaQtZZb9iPv5b
 Kqjr8rGKLp52jhFnWJvY1ABc/0A=
X-Mailgun-Sending-Ip: 69.72.43.15
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n02.prod.us-west-2.postgun.com with SMTP id
 5feb53bc6d2f42c66663daf4 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Tue, 29 Dec 2020 16:05:16
 GMT
Sender: chinagar=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id BB560C433CA; Tue, 29 Dec 2020 16:05:15 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=2.0 tests=ALL_TRUSTED,BAYES_00,SPF_FAIL
        autolearn=no autolearn_force=no version=3.4.0
Received: from chinagar-linux.qualcomm.com (unknown [202.46.22.19])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: chinagar)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 32975C433C6;
        Tue, 29 Dec 2020 16:05:13 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 32975C433C6
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=chinagar@codeaurora.org
Date:   Tue, 29 Dec 2020 21:34:53 +0530
From:   Chinmay Agarwal <chinagar@codeaurora.org>
To:     netdev@vger.kernel.org
Cc:     sharathv@codeaurora.org
Subject: Race Condition Observed in ARP Processing.
Message-ID: <20201229160447.GA3156@chinagar-linux.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.24 (2015-08-30)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi All,

We found a crash while performing some automated stress tests on a 5.4 kernel based device.

We found out that it there is a freed neighbour address which was still part of the gc_list and was leading to crash.
Upon adding some debugs and checking neigh_put/neigh_hold/neigh_destroy calls stacks, looks like there is a possibility of a Race condition happening in the code.
The issue could be reproduced with some effort.

[35156.263929]  Call trace:
[35156.263948]  dump_backtrace+0x0/0x1d0
[35156.263963]  show_stack+0x18/0x24 
[35156.263982]  dump_stack+0xcc/0x11c 
[35156.264003]  print_address_description+0x88/0x578
[35156.264021]  __kasan_report+0x1b4/0x1d0
[35156.264037]   kasan_report+0x14/0x20
[35156.264054]   __asan_load8+0x98/0x9c
[35156.264070]  __list_add_valid+0x3c/0xbc 
[35156.264091]  ___neigh_create+0xbbc/0xcd4
[35156.264108]   __neigh_create+0x18/0x24
[35156.264130]  ip_finish_output2+0x3c4/0x8d0 
[35156.264147]  __ip_finish_output+0x290/0x2bc
[35156.264164]   ip_finish_output+0x48/0x10c
[35156.264180]   ip_output+0x22c/0x27c
[35156.264196]  ip_send_skb+0x70/0x138
[35156.264215]  udp_send_skb+0x3a8/0x6a8 
[35156.264231]  udp_sendmsg+0xd70/0xe4c
[35156.264246]   inet_sendmsg+0x60/0x7c
[35156.264264]  __sys_sendto+0x240/0x2d4 
[35156.264280]  __arm64_sys_sendto+0x7c/0x98 
[35156.264300]  invoke_syscall+0x184/0x328 
[35156.264317]  el0_svc_common+0xc8/0x184 [
35156.264336]  el0_svc_handler+0x94/0xa4 [
35156.264352]  el0_svc+0x8/0xc

[35156.264379]  Allocated by task 1269:
[35156.264404]   __kasan_kmalloc+0x100/0x1c0
[35156.264421]   kasan_slab_alloc+0x18/0x24
[35156.264438]   __kmalloc_track_caller+0x2cc/0x374
[35156.264455]   __alloc_skb+0xa4/0x24c
[35156.264473]   alloc_skb_with_frags+0x80/0x260
[35156.264491]   sock_alloc_send_pskb+0x324/0x498
[35156.264512]   unix_dgram_sendmsg+0x308/0xd34
[35156.264530]   unix_seqpacket_sendmsg+0x88/0xd8
[35156.264548]  __sys_sendto+0x240/0x2d4
[35156.264564]   __arm64_sys_sendto+0x7c/0x98
[35156.264582]   invoke_syscall+0x184/0x328
[35156.264600]   el0_svc_common+0xc8/0x184
[35156.264617]  el0_svc_handler+0x94/0xa4
[35156.264632]   el0_svc+0x8/0xc

[35156.264655]  Freed by task 27859:
[35156.264678]  __kasan_slab_free+0x164/0x234 
[35156.264696]  kasan_slab_free+0x14/0x24 
[35156.264712]  slab_free_freelist_hook+0xe0/0x164
[35156.264726]  kfree+0x134/0x720
[35156.264743]  skb_release_data+0x298/0x2c8 
[35156.264759]  __kfree_skb+0x30/0xb0 
[35156.264774]  consume_skb+0x148/0x17c 
[35156.264792]  skb_free_datagram+0x1c/0x68 
[35156.264809]  unix_dgram_recvmsg+0x46c/0x4d4 
[35156.264827]  unix_seqpacket_recvmsg+0x5c/0x7c 
[35156.264843]  __sys_recvfrom+0x1d0/0x268 
[35156.264864]  __arm64_compat_sys_recvfrom+0x7c/0x98
[35156.264882]   invoke_syscall+0x184/0x328
[35156.264899]   el0_svc_common+0xb4/0x184
[35156.264918]   el0_svc_compat_handler+0x30/0x40
[35156.264933]  el0_svc_compat+0x8/0x24

Possible Race Condition:

CPU 1: 
(thread executing flow: arp_ifdown -> neigh_ifdown -> __neigh_ifdown -> neigh_flush_dev)

static void neigh_flush_dev(struct neigh_table *tbl, struct net_device *dev,
							bool skip_perm)
{
	int i;
	struct neigh_hash_table *nht;
	.....
	
        neigh_del_timer(n);
        neigh_mark_dead(n); --------> //ts1: neighbour entry gets marked as dead
		
	if (refcount_read(&n->refcnt) != 1) {
                /* The most unpleasant situation.
                   We must destroy neighbour entry,
                   but someone still uses it.

                   The destroy will be delayed until
                   the last user releases us, but
                   we must kill timers etc. and move
                   it to safe state.
                */
                   __skb_queue_purge(&n->arp_queue);
                   n->arp_queue_len_bytes = 0;
                   n->output = neigh_blackhole;
                   if (n->nud_state & NUD_VALID)
                        n->nud_state = NUD_NOARP;
                   else
                        n->nud_state = NUD_NONE;
                   neigh_dbg(2, "neigh %p is stray\n", n);
        }
        write_unlock(&n->lock);
        neigh_cleanup_and_release(n);  ---->  //ts3: reference decremented 
					      //but destroy couldn't be done
					      // as reference increased in ts2
   	....
		
		

CPU 2:
(thread executing flow: __netif_receive_skb -> __netif_receive_skb_core -> arp_rcv -> arp_process)

static int arp_process(struct net *net, struct sock *sk, struct sk_buff *skb)
{
.....
		
	/* Update our ARP tables */

	n = __neigh_lookup(&arp_tbl, &sip, dev, 0); ---->//ts2: reference
							// taken on neighbour
				
		...
		if (n) {
			int state = NUD_REACHABLE;
			int override;
			/* If several different ARP replies follows back-to-back,
			   use the FIRST one. It is possible, if several proxy
			   agents are active. Taking the first reply prevents
			   arp trashing and chooses the fastest router.
			*/
			override = time_after(jiffies,
					   n->updated +
					   NEIGH_VAR(n->parms, LOCKTIME)) ||
					   is_garp;

			/* Broadcast replies and request packets
			do not assert neighbour reachability.
	                    */
			if (arp->ar_op != htons(ARPOP_REPLY) ||
				skb->pkt_type != PACKET_HOST)
               		state = NUD_STALE;
			neigh_update(n, sha, state,
				override ? NEIGH_UPDATE_F_OVERRIDE : 0, 0);
	-------->      	//ts4: neigh_update -> __neigh_update -> neigh_update_gc_list
			neigh_release(n);---->	//ts5: release the neighbour 
						//entry and call destroy as refcount is 1.
			}

	}

static int __neigh_update(struct neighbour *neigh, const u8 *lladdr,
                u8 new, u32 flags, u32 nlmsg_pid,
                struct netlink_ext_ack *extack)
{
...
		
		if (neigh->dead) {
				NL_SET_ERR_MSG(extack, "Neighbor entry is now dead");
				goto out;
		}
		.....
			
				
		out:
			if (update_isrouter)
					neigh_update_is_router(neigh, flags, &notify);
			write_unlock_bh(&neigh->lock);

			if (((new ^ old) & NUD_PERMANENT) || ext_learn_change) 
					neigh_update_gc_list(neigh);
 //The test could have an old state set as permanent and new state changed to some other, which hits here?
}

		
		
The crash may have been due to out of order ARP replies.
As neighbour is marked dead should we go ahead with updating our ARP Tables?


