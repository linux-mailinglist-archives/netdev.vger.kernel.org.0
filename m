Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0B3F567A882
	for <lists+netdev@lfdr.de>; Wed, 25 Jan 2023 02:55:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230432AbjAYBzE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Jan 2023 20:55:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230251AbjAYBzC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Jan 2023 20:55:02 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1D464345E;
        Tue, 24 Jan 2023 17:54:56 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6A5F861419;
        Wed, 25 Jan 2023 01:54:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A362DC433D2;
        Wed, 25 Jan 2023 01:54:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674611695;
        bh=f0GEiE95h/iDPTcC7XI4mLH9V+y2m5U6NWTNfMUfN9k=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=UsMMZv6Wsalg7NZQbcamtvk6vJBydjWpN5OkLS2O8j2uWORSb1XXfFZKuMlsAudyM
         B8pY8mPn3nlmO+LU7UBbLVEqQ2UMaOeJRQY1joAvoyZQWy5qrq5J5zB7Fa4cq2FQSb
         jsIcuKvHuLrtVuPupr56TV+UdLf1ax56DuiivKTYQVfitE3rG/EfmyyFjWFOMZFF3f
         ASI8AVzKaKJM/w1gM23EtRhsKNOfHEAANXuBZnHU2N/dx5Ilm6EBmsdWED9Y2kpX2V
         IiE2r8aemRtIWanvQxuqLXel2GELw8KYY7KGXLNrJqMKhJooRTgK3HQEk4Rrk1ATEv
         PRrRF1n6sZmaQ==
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 7C798942C40; Wed, 25 Jan 2023 02:54:52 +0100 (CET)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@kernel.org>
To:     Shawn Bohrer <sbohrer@cloudflare.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Cc:     makita.toshiaki@lab.ntt.co.jp
Subject: Re: KASAN veth use after free in XDP_REDIRECT
In-Reply-To: <Y9BfknDG0LXmruDu@JNXK7M3>
References: <Y9BfknDG0LXmruDu@JNXK7M3>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Wed, 25 Jan 2023 02:54:52 +0100
Message-ID: <87357znztf.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Shawn Bohrer <sbohrer@cloudflare.com> writes:

> Hello,
>
> We've seen the following KASAN report on our systems. When using
> AF_XDP on a veth.
>
> KASAN report:
>
> BUG: KASAN: use-after-free in __xsk_rcv+0x18d/0x2c0
> Read of size 78 at addr ffff888976250154 by task napi/iconduit-g/148640
>
> CPU: 5 PID: 148640 Comm: napi/iconduit-g Kdump: loaded Tainted: G        =
   O       6.1.4-cloudflare-kasan-2023.1.2 #1
> Hardware name: Quanta Computer Inc. QuantaPlex T41S-2U/S2S-MB, BIOS S2S_3=
B10.03 06/21/2018
> Call Trace:
>  <TASK>
>  dump_stack_lvl+0x34/0x48
>  print_report+0x170/0x473
>  ? __xsk_rcv+0x18d/0x2c0
>  kasan_report+0xad/0x130
>  ? __xsk_rcv+0x18d/0x2c0
>  kasan_check_range+0x149/0x1a0
>  memcpy+0x20/0x60
>  __xsk_rcv+0x18d/0x2c0
>  __xsk_map_redirect+0x1f3/0x490
>  ? veth_xdp_rcv_skb+0x89c/0x1ba0 [veth]
>  xdp_do_redirect+0x5ca/0xd60
>  veth_xdp_rcv_skb+0x935/0x1ba0 [veth]
>  ? __netif_receive_skb_list_core+0x671/0x920
>  ? veth_xdp+0x670/0x670 [veth]
>  veth_xdp_rcv+0x304/0xa20 [veth]
>  ? do_xdp_generic+0x150/0x150
>  ? veth_xdp_rcv_one+0xde0/0xde0 [veth]
>  ? _raw_spin_lock_bh+0xe0/0xe0
>  ? newidle_balance+0x887/0xe30
>  ? __perf_event_task_sched_in+0xdb/0x800
>  veth_poll+0x139/0x571 [veth]
>  ? veth_xdp_rcv+0xa20/0xa20 [veth]
>  ? _raw_spin_unlock+0x39/0x70
>  ? finish_task_switch.isra.0+0x17e/0x7d0
>  ? __switch_to+0x5cf/0x1070
>  ? __schedule+0x95b/0x2640
>  ? io_schedule_timeout+0x160/0x160
>  __napi_poll+0xa1/0x440
>  napi_threaded_poll+0x3d1/0x460
>  ? __napi_poll+0x440/0x440
>  ? __kthread_parkme+0xc6/0x1f0
>  ? __napi_poll+0x440/0x440
>  kthread+0x2a2/0x340
>  ? kthread_complete_and_exit+0x20/0x20
>  ret_from_fork+0x22/0x30
>  </TASK>
>
> Freed by task 148640:
>  kasan_save_stack+0x23/0x50
>  kasan_set_track+0x21/0x30
>  kasan_save_free_info+0x2a/0x40
>  ____kasan_slab_free+0x169/0x1d0
>  slab_free_freelist_hook+0xd2/0x190
>  __kmem_cache_free+0x1a1/0x2f0
>  skb_release_data+0x449/0x600
>  consume_skb+0x9f/0x1c0
>  veth_xdp_rcv_skb+0x89c/0x1ba0 [veth]
>  veth_xdp_rcv+0x304/0xa20 [veth]
>  veth_poll+0x139/0x571 [veth]
>  __napi_poll+0xa1/0x440
>  napi_threaded_poll+0x3d1/0x460
>  kthread+0x2a2/0x340
>  ret_from_fork+0x22/0x30
>
>
> The buggy address belongs to the object at ffff888976250000
>  which belongs to the cache kmalloc-2k of size 2048
> The buggy address is located 340 bytes inside of
>  2048-byte region [ffff888976250000, ffff888976250800)
>
> The buggy address belongs to the physical page:
> page:00000000ae18262a refcount:2 mapcount:0 mapping:0000000000000000 inde=
x:0x0 pfn:0x976250
> head:00000000ae18262a order:3 compound_mapcount:0 compound_pincount:0
> flags: 0x2ffff800010200(slab|head|node=3D0|zone=3D2|lastcpupid=3D0x1ffff)
> raw: 002ffff800010200 0000000000000000 dead000000000122 ffff88810004cf00
> raw: 0000000000000000 0000000080080008 00000002ffffffff 0000000000000000
> page dumped because: kasan: bad access detected
>
> Memory state around the buggy address:
>  ffff888976250000: fa fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>  ffff888976250080: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>>ffff888976250100: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>  =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 ^
>  ffff888976250180: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>  ffff888976250200: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>
>
> If I understand the code correctly it looks like a xdp_buf is
> constructed pointing to the memory backed by a skb but consume_skb()
> is called while the xdp_buf() is still in use.
>
> ```
> 	case XDP_REDIRECT:
> 		veth_xdp_get(&xdp);
> 		consume_skb(skb);
> 		xdp.rxq->mem =3D rq->xdp_mem;
> 		if (xdp_do_redirect(rq->dev, &xdp, xdp_prog)) {
> 			stats->rx_drops++;
> 			goto err_xdp;
> 		}
> 		stats->xdp_redirect++;
> 		rcu_read_unlock();
> 		goto xdp_xmit;
> ```
>
> It is worth noting that I think XDP_TX has the exact same problem.
>
> Again assuming I understand the problem one naive solution might be to
> move the consum_skb() call after xdp_do_redirect().  I think this
> might work for BPF_MAP_TYPE_XSKMAP, BPF_MAP_TYPE_DEVMAP, and
> BPF_MAP_TYPE_DEVMAP_HASH since those all seem to copy the xdb_buf to
> new memory.  The copy happens for XSKMAP in __xsk_rcv() and for the
> DEVMAP cases happens in dev_map_enqueue_clone().
>
> However, it would appear that for BPF_MAP_TYPE_CPUMAP that memory can
> live much longer, possibly even after xdp_do_flush().  If I'm correct,
> I'm not really sure where it would be safe to call consume_skb().

So the idea is that veth_xdp_get() does a
get_page(virt_to_page(xdp->data)), where xdp->data in this case points
to skb->head. This should keep the data page alive even if the skb
surrounding it is freed by the call to consume_skb().

However, because the skb->head in this case was allocated from a slab
allocator, taking a page refcount is not enough to prevent it from being
freed.

I'm not sure how best to fix this. I guess we could try to detect this
case in the veth driver and copy the data, like we do for skb_share()
etc. However, I'm not sure how to actually detect this case...

Where are the skbs being processed coming from? I.e., what path
allocated them?

-Toke
