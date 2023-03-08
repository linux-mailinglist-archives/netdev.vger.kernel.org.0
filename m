Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D47426B1527
	for <lists+netdev@lfdr.de>; Wed,  8 Mar 2023 23:34:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230030AbjCHWeN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Mar 2023 17:34:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229654AbjCHWeM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Mar 2023 17:34:12 -0500
Received: from mail-oa1-x2d.google.com (mail-oa1-x2d.google.com [IPv6:2001:4860:4864:20::2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 958BACB06C
        for <netdev@vger.kernel.org>; Wed,  8 Mar 2023 14:34:10 -0800 (PST)
Received: by mail-oa1-x2d.google.com with SMTP id 586e51a60fabf-1763e201bb4so425351fac.1
        for <netdev@vger.kernel.org>; Wed, 08 Mar 2023 14:34:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google; t=1678314850;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=Tc8h0McGS7VzRIynGsVwgWeamj/Lqm5MgT+K8mE2w7k=;
        b=HsFTwqgwUXZTGYxX3NB7o+vZTvuQBUtig+lZUvrZtRxnRZSfZ82NG6Gw8vmF8n1lS4
         SKo7C3qKTo+vDO7PUo2T4B2KJfpflD0+DyR1vjZzMECowtmGUXOI1hK8TEpcnVZNgG5n
         hD7kluTubzKZWCCUSDzxLq/E5koULgIb1PwT8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678314850;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Tc8h0McGS7VzRIynGsVwgWeamj/Lqm5MgT+K8mE2w7k=;
        b=2f0t9Vgjd9q+Wo/ZquHGVd6spVMxjXkMRF+pgSEI46nysrvoE5MIYbviWAxx/waYVS
         v5O8MW5xHd5lT57TQ/2Sg18Md5G8BVwRNOuk2/jhfcObOrcs3ngoxI71bq31g+WWpdE7
         ZBM9BNCMGw49si+NDYAK0+wmwXZ3fWf9X1W1Fo6I8l7P3tcCBHL+zfsSTAYH4djRjCAO
         EXfR9v70Cfq09QpnYOPOTauI+gMA/IgW+z7lwwZ9P/t8vpJLYfPMx4VyMufHVLSnG0BA
         u+Rh+HjMfo+jXD8eu2UtmY73hBMTf5LLgEUo90GTkVZWvkn+nqIaapofPA1Bp3BVKkuu
         mWIQ==
X-Gm-Message-State: AO0yUKWboEW1jraPTWmrsTFrsHME6jDeB2309OzWot9s1h9Z2pU2Fd+5
        tMNpkMQfJ+AYGK+mwGDUUu4QQQ==
X-Google-Smtp-Source: AK7set+bkpm/SgW2QUYemIw+fTpEVBzvyORLs6lDduEgP/GWLHsiOVSDjznD+AY6NaumRIDFWIuk7w==
X-Received: by 2002:a05:6870:8202:b0:16d:e7d4:4180 with SMTP id n2-20020a056870820200b0016de7d44180mr11332650oae.29.1678314849731;
        Wed, 08 Mar 2023 14:34:09 -0800 (PST)
Received: from JNXK7M3 ([2a09:bac5:bf22:96::f:357])
        by smtp.gmail.com with ESMTPSA id z18-20020a9d71d2000000b0068bd9a6d644sm7091901otj.23.2023.03.08.14.34.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Mar 2023 14:34:08 -0800 (PST)
Date:   Wed, 8 Mar 2023 16:33:58 -0600
From:   Shawn Bohrer <sbohrer@cloudflare.com>
To:     Toshiaki Makita <toshiaki.makita1@gmail.com>
Cc:     Toke =?iso-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@kernel.org>,
        makita.toshiaki@lab.ntt.co.jp, netdev@vger.kernel.org,
        bpf@vger.kernel.org, lorenzo@kernel.org, kernel-team@cloudflare.com
Subject: Re: KASAN veth use after free in XDP_REDIRECT
Message-ID: <ZAkNABggOdKw6PwA@JNXK7M3>
References: <Y9BfknDG0LXmruDu@JNXK7M3>
 <87357znztf.fsf@toke.dk>
 <19b18a7c-ed1c-1f9d-84d4-7046bffe46b9@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <19b18a7c-ed1c-1f9d-84d4-7046bffe46b9@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 25, 2023 at 11:07:32AM +0900, Toshiaki Makita wrote:
> On 2023/01/25 10:54, Toke Høiland-Jørgensen wrote:
> > Shawn Bohrer <sbohrer@cloudflare.com> writes:
> > 
> > > Hello,
> > > 
> > > We've seen the following KASAN report on our systems. When using
> > > AF_XDP on a veth.
> > > 
> > > KASAN report:
> > > 
> > > BUG: KASAN: use-after-free in __xsk_rcv+0x18d/0x2c0
> > > Read of size 78 at addr ffff888976250154 by task napi/iconduit-g/148640
> > > 
> > > CPU: 5 PID: 148640 Comm: napi/iconduit-g Kdump: loaded Tainted: G           O       6.1.4-cloudflare-kasan-2023.1.2 #1
> > > Hardware name: Quanta Computer Inc. QuantaPlex T41S-2U/S2S-MB, BIOS S2S_3B10.03 06/21/2018
> > > Call Trace:
> > >   <TASK>
> > >   dump_stack_lvl+0x34/0x48
> > >   print_report+0x170/0x473
> > >   ? __xsk_rcv+0x18d/0x2c0
> > >   kasan_report+0xad/0x130
> > >   ? __xsk_rcv+0x18d/0x2c0
> > >   kasan_check_range+0x149/0x1a0
> > >   memcpy+0x20/0x60
> > >   __xsk_rcv+0x18d/0x2c0
> > >   __xsk_map_redirect+0x1f3/0x490
> > >   ? veth_xdp_rcv_skb+0x89c/0x1ba0 [veth]
> > >   xdp_do_redirect+0x5ca/0xd60
> > >   veth_xdp_rcv_skb+0x935/0x1ba0 [veth]
> > >   ? __netif_receive_skb_list_core+0x671/0x920
> > >   ? veth_xdp+0x670/0x670 [veth]
> > >   veth_xdp_rcv+0x304/0xa20 [veth]
> > >   ? do_xdp_generic+0x150/0x150
> > >   ? veth_xdp_rcv_one+0xde0/0xde0 [veth]
> > >   ? _raw_spin_lock_bh+0xe0/0xe0
> > >   ? newidle_balance+0x887/0xe30
> > >   ? __perf_event_task_sched_in+0xdb/0x800
> > >   veth_poll+0x139/0x571 [veth]
> > >   ? veth_xdp_rcv+0xa20/0xa20 [veth]
> > >   ? _raw_spin_unlock+0x39/0x70
> > >   ? finish_task_switch.isra.0+0x17e/0x7d0
> > >   ? __switch_to+0x5cf/0x1070
> > >   ? __schedule+0x95b/0x2640
> > >   ? io_schedule_timeout+0x160/0x160
> > >   __napi_poll+0xa1/0x440
> > >   napi_threaded_poll+0x3d1/0x460
> > >   ? __napi_poll+0x440/0x440
> > >   ? __kthread_parkme+0xc6/0x1f0
> > >   ? __napi_poll+0x440/0x440
> > >   kthread+0x2a2/0x340
> > >   ? kthread_complete_and_exit+0x20/0x20
> > >   ret_from_fork+0x22/0x30
> > >   </TASK>
> > > 
> > > Freed by task 148640:
> > >   kasan_save_stack+0x23/0x50
> > >   kasan_set_track+0x21/0x30
> > >   kasan_save_free_info+0x2a/0x40
> > >   ____kasan_slab_free+0x169/0x1d0
> > >   slab_free_freelist_hook+0xd2/0x190
> > >   __kmem_cache_free+0x1a1/0x2f0
> > >   skb_release_data+0x449/0x600
> > >   consume_skb+0x9f/0x1c0
> > >   veth_xdp_rcv_skb+0x89c/0x1ba0 [veth]
> > >   veth_xdp_rcv+0x304/0xa20 [veth]
> > >   veth_poll+0x139/0x571 [veth]
> > >   __napi_poll+0xa1/0x440
> > >   napi_threaded_poll+0x3d1/0x460
> > >   kthread+0x2a2/0x340
> > >   ret_from_fork+0x22/0x30
> > > 
> > > 
> > > The buggy address belongs to the object at ffff888976250000
> > >   which belongs to the cache kmalloc-2k of size 2048
> > > The buggy address is located 340 bytes inside of
> > >   2048-byte region [ffff888976250000, ffff888976250800)
> > > 
> > > The buggy address belongs to the physical page:
> > > page:00000000ae18262a refcount:2 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x976250
> > > head:00000000ae18262a order:3 compound_mapcount:0 compound_pincount:0
> > > flags: 0x2ffff800010200(slab|head|node=0|zone=2|lastcpupid=0x1ffff)
> > > raw: 002ffff800010200 0000000000000000 dead000000000122 ffff88810004cf00
> > > raw: 0000000000000000 0000000080080008 00000002ffffffff 0000000000000000
> > > page dumped because: kasan: bad access detected
> > > 
> > > Memory state around the buggy address:
> > >   ffff888976250000: fa fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
> > >   ffff888976250080: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
> > > > ffff888976250100: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
> > >                                                   ^
> > >   ffff888976250180: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
> > >   ffff888976250200: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
> > > 
> > > 
> > > If I understand the code correctly it looks like a xdp_buf is
> > > constructed pointing to the memory backed by a skb but consume_skb()
> > > is called while the xdp_buf() is still in use.
> > > 
> > > ```
> > > 	case XDP_REDIRECT:
> > > 		veth_xdp_get(&xdp);
> > > 		consume_skb(skb);
> > > 		xdp.rxq->mem = rq->xdp_mem;
> > > 		if (xdp_do_redirect(rq->dev, &xdp, xdp_prog)) {
> > > 			stats->rx_drops++;
> > > 			goto err_xdp;
> > > 		}
> > > 		stats->xdp_redirect++;
> > > 		rcu_read_unlock();
> > > 		goto xdp_xmit;
> > > ```
> > > 
> > > It is worth noting that I think XDP_TX has the exact same problem.
> > > 
> > > Again assuming I understand the problem one naive solution might be to
> > > move the consum_skb() call after xdp_do_redirect().  I think this
> > > might work for BPF_MAP_TYPE_XSKMAP, BPF_MAP_TYPE_DEVMAP, and
> > > BPF_MAP_TYPE_DEVMAP_HASH since those all seem to copy the xdb_buf to
> > > new memory.  The copy happens for XSKMAP in __xsk_rcv() and for the
> > > DEVMAP cases happens in dev_map_enqueue_clone().
> > > 
> > > However, it would appear that for BPF_MAP_TYPE_CPUMAP that memory can
> > > live much longer, possibly even after xdp_do_flush().  If I'm correct,
> > > I'm not really sure where it would be safe to call consume_skb().
> > 
> > So the idea is that veth_xdp_get() does a
> > get_page(virt_to_page(xdp->data)), where xdp->data in this case points
> > to skb->head. This should keep the data page alive even if the skb
> > surrounding it is freed by the call to consume_skb().
> > 
> > However, because the skb->head in this case was allocated from a slab
> > allocator, taking a page refcount is not enough to prevent it from being
> > freed.
> 
> Not sure why skb->head is kmallocked here.
> skb_head_is_locked() check in veth_convert_skb_to_xdp_buff() should ensure that
> skb head is a page fragment.

I have a few more details here.  We have some machines running 5.15
kernels and some are running 6.1 kernels.  So far it appears this only
happens on 6.1.  We also have a couple of different network cards but
it appears that only the machines with Solarflare cards using the sfc
driver hit the KASAN BUG.

718a18a0c8a67f97781e40bdef7cdd055c430996 "veth: Rework
veth_xdp_rcv_skb in order to accept non-linear skb" reworked and added
the veth_convert_skb_to_xdp_buff() call you mentioned.  Importantly it
also added a call to pskb_expand_head() which will kmalloc() the
skb->head.  This looks like a path that could be causing the KASAN
BUG, but I have not yet confirmed that is the path we are hitting.
This change was also added in 5.18 so might explain why we don't see
it on 5.15.

--
Shawn

