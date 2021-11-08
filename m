Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1570B447853
	for <lists+netdev@lfdr.de>; Mon,  8 Nov 2021 02:32:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235879AbhKHBfC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 7 Nov 2021 20:35:02 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:50786 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235852AbhKHBfB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 7 Nov 2021 20:35:01 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1636335137;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=0xS+TVeEKlAS3P3GylclX4L55dwuY5w3m8EU10OF6ww=;
        b=iBtK7bFOzbIE/tXSUOY0k+tm3/1YUkdqYLy2KzhTrY6NpbU3eOh8tNIItvago+4Cekz/CJ
        Kh8gWWAb2fivV0qhaRzXkufy/Ulq7m0hBdQYcAheI/mKYu0ZUGAxUxUMB5JAsq9WiHONX5
        uVc25pLABc0oDjUTY8Q00PaKGO96id8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-57-cpjwtip0Mz2f1jSmI7eG1A-1; Sun, 07 Nov 2021 20:32:12 -0500
X-MC-Unique: cpjwtip0Mz2f1jSmI7eG1A-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4BEDE875109;
        Mon,  8 Nov 2021 01:32:10 +0000 (UTC)
Received: from T590 (ovpn-8-17.pek2.redhat.com [10.72.8.17])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id E34B61048102;
        Mon,  8 Nov 2021 01:31:58 +0000 (UTC)
Date:   Mon, 8 Nov 2021 09:31:54 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     Yu Kuai <yukuai3@huawei.com>
Cc:     axboe@kernel.dk, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org, kbusch@kernel.org, linux-block@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, yi.zhang@huawei.com, yebin10@huawei.com,
        ming.lei@redhat.com
Subject: Re: [PATCH] blk-mq: don't free tags if the tag_set is used by other
 device in queue initialztion
Message-ID: <YYh+CrMZb4RPLFKs@T590>
References: <20211106092331.3162749-1-yukuai3@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211106092331.3162749-1-yukuai3@huawei.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Nov 06, 2021 at 05:23:31PM +0800, Yu Kuai wrote:
> Our test report a UAF on v5.10:
> 
> [ 1446.674930] ==================================================================
> [ 1446.675970] BUG: KASAN: use-after-free in blk_mq_get_driver_tag+0x9a4/0xa90
> [ 1446.676902] Read of size 8 at addr ffff8880185afd10 by task kworker/1:2/12348
> [ 1446.677851]
> [ 1446.678073] CPU: 1 PID: 12348 Comm: kworker/1:2 Not tainted 5.10.0-10177-gc9c81b1e346a #2
> [ 1446.679168] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.14.0-0-g155821a1990b-prebuilt.qemu.org 04/01/2014
> [ 1446.680692] Workqueue: kthrotld blk_throtl_dispatch_work_fn
> [ 1446.681448] Call Trace:
> [ 1446.681800]  dump_stack+0x9b/0xce
> [ 1446.682259]  ? blk_mq_get_driver_tag+0x9a4/0xa90
> [ 1446.682916]  print_address_description.constprop.6+0x3e/0x60
> [ 1446.683688]  ? __cpuidle_text_end+0x5/0x5
> [ 1446.684239]  ? vprintk_func+0x6b/0x120
> [ 1446.684748]  ? blk_mq_get_driver_tag+0x9a4/0xa90
> [ 1446.685373]  ? blk_mq_get_driver_tag+0x9a4/0xa90
> [ 1446.685999]  kasan_report.cold.9+0x22/0x3a
> [ 1446.686559]  ? blk_mq_get_driver_tag+0x9a4/0xa90
> [ 1446.687186]  blk_mq_get_driver_tag+0x9a4/0xa90
> [ 1446.687785]  blk_mq_dispatch_rq_list+0x21a/0x1d40
> [ 1446.688427]  ? __sbitmap_get_word+0xc3/0xe0
> [ 1446.688992]  ? blk_mq_dequeue_from_ctx+0x960/0x960
> [ 1446.689641]  ? _raw_spin_lock+0x7a/0xd0
> [ 1446.690164]  ? _raw_spin_lock_irq+0xd0/0xd0
> [ 1446.690727]  ? sbitmap_get_shallow+0x3c9/0x4e0
> [ 1446.691329]  ? sbitmap_any_bit_set+0x128/0x190
> [ 1446.691928]  ? kyber_completed_request+0x290/0x290
> [ 1446.692576]  __blk_mq_do_dispatch_sched+0x394/0x830
> [ 1446.693237]  ? blk_mq_sched_request_inserted+0x100/0x100
> [ 1446.693948]  ? __blk_queue_split+0x31d/0x1380
> [ 1446.694540]  ? blk_integrity_merge_bio+0xc1/0x370
> [ 1446.695182]  ? ll_back_merge_fn+0x694/0x1490
> [ 1446.695758]  __blk_mq_sched_dispatch_requests+0x398/0x4f0
> [ 1446.696484]  ? bio_attempt_back_merge+0x1cc/0x340
> [ 1446.697121]  ? blk_mq_do_dispatch_ctx+0x570/0x570
> [ 1446.697756]  ? _raw_spin_lock+0x7a/0xd0
> [ 1446.698279]  blk_mq_sched_dispatch_requests+0xdf/0x140
> [ 1446.698967]  __blk_mq_run_hw_queue+0xc0/0x270
> [ 1446.699561]  __blk_mq_delay_run_hw_queue+0x4cc/0x550
> [ 1446.700231]  ? kyber_has_work+0x9a/0x140
> [ 1446.700760]  ? kyber_completed_request+0x290/0x290
> [ 1446.701407]  blk_mq_run_hw_queue+0x13b/0x2b0
> [ 1446.701982]  ? kyber_has_work+0x140/0x140
> [ 1446.702593]  blk_mq_sched_insert_requests+0x1de/0x390
> [ 1446.703309]  blk_mq_flush_plug_list+0x4b4/0x760
> [ 1446.703946]  ? blk_mq_insert_requests+0x4b0/0x4b0
> [ 1446.704644]  ? __bpf_trace_block_bio_complete+0x30/0x30
> [ 1446.705408]  blk_flush_plug_list+0x2c5/0x480
> [ 1446.706026]  ? blk_insert_cloned_request+0x460/0x460
> [ 1446.706717]  ? _raw_spin_lock_irq+0x7b/0xd0
> [ 1446.707292]  ? _raw_spin_lock_irqsave+0xe0/0xe0
> [ 1446.707901]  ? set_next_entity+0x235/0x2210
> [ 1446.708471]  blk_finish_plug+0x55/0xa0
> [ 1446.708980]  blk_throtl_dispatch_work_fn+0x23b/0x2e0
> [ 1446.709653]  ? tg_prfill_limit+0x8a0/0x8a0
> [ 1446.710216]  ? read_word_at_a_time+0xe/0x20
> [ 1446.710780]  ? strscpy+0x9a/0x320
> [ 1446.711236]  process_one_work+0x6d4/0xfe0
> [ 1446.711778]  worker_thread+0x91/0xc80
> [ 1446.712281]  ? __kthread_parkme+0xb0/0x110
> [ 1446.712834]  ? process_one_work+0xfe0/0xfe0
> [ 1446.713400]  kthread+0x32d/0x3f0
> [ 1446.713840]  ? kthread_park+0x170/0x170
> [ 1446.714362]  ret_from_fork+0x1f/0x30
> [ 1446.714846]
> [ 1446.715062] Allocated by task 1:
> [ 1446.715509]  kasan_save_stack+0x19/0x40
> [ 1446.716026]  __kasan_kmalloc.constprop.1+0xc1/0xd0
> [ 1446.716673]  blk_mq_init_tags+0x6d/0x330
> [ 1446.717207]  blk_mq_alloc_rq_map+0x50/0x1c0
> [ 1446.717769]  __blk_mq_alloc_map_and_request+0xe5/0x320
> [ 1446.718459]  blk_mq_alloc_tag_set+0x679/0xdc0
> [ 1446.719050]  scsi_add_host_with_dma.cold.3+0xa0/0x5db
> [ 1446.719736]  virtscsi_probe+0x7bf/0xbd0
> [ 1446.720265]  virtio_dev_probe+0x402/0x6c0
> [ 1446.720808]  really_probe+0x276/0xde0
> [ 1446.721320]  driver_probe_device+0x267/0x3d0
> [ 1446.721892]  device_driver_attach+0xfe/0x140
> [ 1446.722491]  __driver_attach+0x13a/0x2c0
> [ 1446.723037]  bus_for_each_dev+0x146/0x1c0
> [ 1446.723603]  bus_add_driver+0x3fc/0x680
> [ 1446.724145]  driver_register+0x1c0/0x400
> [ 1446.724693]  init+0xa2/0xe8
> [ 1446.725091]  do_one_initcall+0x9e/0x310
> [ 1446.725626]  kernel_init_freeable+0xc56/0xcb9
> [ 1446.726231]  kernel_init+0x11/0x198
> [ 1446.726714]  ret_from_fork+0x1f/0x30
> [ 1446.727212]
> [ 1446.727433] Freed by task 26992:
> [ 1446.727882]  kasan_save_stack+0x19/0x40
> [ 1446.728420]  kasan_set_track+0x1c/0x30
> [ 1446.728943]  kasan_set_free_info+0x1b/0x30
> [ 1446.729517]  __kasan_slab_free+0x111/0x160
> [ 1446.730084]  kfree+0xb8/0x520
> [ 1446.730507]  blk_mq_free_map_and_requests+0x10b/0x1b0
> [ 1446.731206]  blk_mq_realloc_hw_ctxs+0x8cb/0x15b0
> [ 1446.731844]  blk_mq_init_allocated_queue+0x374/0x1380
> [ 1446.732540]  blk_mq_init_queue_data+0x7f/0xd0
> [ 1446.733155]  scsi_mq_alloc_queue+0x45/0x170
> [ 1446.733730]  scsi_alloc_sdev+0x73c/0xb20
> [ 1446.734281]  scsi_probe_and_add_lun+0x9a6/0x2d90
> [ 1446.734916]  __scsi_scan_target+0x208/0xc50
> [ 1446.735500]  scsi_scan_channel.part.3+0x113/0x170
> [ 1446.736149]  scsi_scan_host_selected+0x25a/0x360
> [ 1446.736783]  store_scan+0x290/0x2d0
> [ 1446.737275]  dev_attr_store+0x55/0x80
> [ 1446.737782]  sysfs_kf_write+0x132/0x190
> [ 1446.738313]  kernfs_fop_write_iter+0x319/0x4b0
> [ 1446.738921]  new_sync_write+0x40e/0x5c0
> [ 1446.739429]  vfs_write+0x519/0x720
> [ 1446.739877]  ksys_write+0xf8/0x1f0
> [ 1446.740332]  do_syscall_64+0x2d/0x40
> [ 1446.740802]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
> [ 1446.741462]
> [ 1446.741670] The buggy address belongs to the object at ffff8880185afd00
> [ 1446.741670]  which belongs to the cache kmalloc-256 of size 256
> [ 1446.743276] The buggy address is located 16 bytes inside of
> [ 1446.743276]  256-byte region [ffff8880185afd00, ffff8880185afe00)
> [ 1446.744765] The buggy address belongs to the page:
> [ 1446.745416] page:ffffea0000616b00 refcount:1 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x185ac
> [ 1446.746694] head:ffffea0000616b00 order:2 compound_mapcount:0 compound_pincount:0
> [ 1446.747719] flags: 0x1fffff80010200(slab|head)
> [ 1446.748337] raw: 001fffff80010200 ffffea00006a3208 ffffea000061bf08 ffff88801004f240
> [ 1446.749404] raw: 0000000000000000 0000000000100010 00000001ffffffff 0000000000000000
> [ 1446.750455] page dumped because: kasan: bad access detected
> [ 1446.751227]
> [ 1446.751445] Memory state around the buggy address:
> [ 1446.752102]  ffff8880185afc00: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
> [ 1446.753090]  ffff8880185afc80: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
> [ 1446.754079] >ffff8880185afd00: fa fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
> [ 1446.755065]                          ^
> [ 1446.755589]  ffff8880185afd80: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
> [ 1446.756574]  ffff8880185afe00: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
> [ 1446.757566] ==================================================================
> 
> Flag 'BLK_MQ_F_TAG_QUEUE_SHARED' will be set if the second device on the
> same host initializes it's queue successfully. However, if the second
> device failed to allocate memory in blk_mq_alloc_and_init_hctx() from
> blk_mq_realloc_hw_ctxs() from blk_mq_init_allocated_queue(),
> __blk_mq_free_map_and_rqs() will be called on error path, and if
> 'BLK_MQ_TAG_HCTX_SHARED' is not set, 'tag_set->tags' will be freed
> while it's still used by the first device.
> 
> Fix the problem by checking if 'tag_set->tag_list' is emptly before
> freeing 'tag_set->tag' during queue initialization.
> 
> Fixes: 868f2f0b7206 ("blk-mq: dynamic h/w context count")
> Signed-off-by: Yu Kuai <yukuai3@huawei.com>
> ---
>  block/blk-mq.c | 12 ++++++++++--
>  1 file changed, 10 insertions(+), 2 deletions(-)
> 
> diff --git a/block/blk-mq.c b/block/blk-mq.c
> index 3527ee251a85..529ad8c47377 100644
> --- a/block/blk-mq.c
> +++ b/block/blk-mq.c
> @@ -3571,7 +3571,7 @@ static struct blk_mq_hw_ctx *blk_mq_alloc_and_init_hctx(
>  }
>  
>  static void blk_mq_realloc_hw_ctxs(struct blk_mq_tag_set *set,
> -						struct request_queue *q)
> +				   struct request_queue *q)
>  {
>  	int i, j, end;
>  	struct blk_mq_hw_ctx **hctxs = q->queue_hw_ctx;
> @@ -3636,9 +3636,17 @@ static void blk_mq_realloc_hw_ctxs(struct blk_mq_tag_set *set,
>  
>  	for (; j < end; j++) {
>  		struct blk_mq_hw_ctx *hctx = hctxs[j];
> +		bool free_tags = !blk_mq_is_shared_tags(set->flags) &&
> +			!q->nr_hw_queues && list_empty(&set->tag_list);
>  
>  		if (hctx) {
> -			__blk_mq_free_map_and_rqs(set, j);
> +			/*
> +			 * tags should not be freed if other device is using the
> +			 * tagset. q->nr_hw_queues is zero means current
> +			 * function is called from queue initialization.
> +			 */
> +			if (free_tags)
> +				__blk_mq_free_map_and_rqs(set, j);
>  			blk_mq_exit_hctx(q, set, hctx, j);
>  			hctxs[j] = NULL;

__blk_mq_free_map_and_rqs() isn't supposed to call in
blk_mq_realloc_hw_ctxs(), so why can't we simply remove it here?


Thanks,
Ming

