Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3E76556126D
	for <lists+netdev@lfdr.de>; Thu, 30 Jun 2022 08:26:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232505AbiF3G0a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jun 2022 02:26:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229891AbiF3G03 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Jun 2022 02:26:29 -0400
Received: from out30-132.freemail.mail.aliyun.com (out30-132.freemail.mail.aliyun.com [115.124.30.132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9208112AE2;
        Wed, 29 Jun 2022 23:26:27 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R161e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018046059;MF=xuanzhuo@linux.alibaba.com;NM=1;PH=DS;RN=7;SR=0;TI=SMTPD_---0VHqisr8_1656570382;
Received: from localhost(mailfrom:xuanzhuo@linux.alibaba.com fp:SMTPD_---0VHqisr8_1656570382)
          by smtp.aliyun-inc.com;
          Thu, 30 Jun 2022 14:26:23 +0800
Message-ID: <1656569481.3897407-1-xuanzhuo@linux.alibaba.com>
Subject: Re: [PATCH V2] virtio-net: fix the race between refill work and close
Date:   Thu, 30 Jun 2022 14:11:21 +0800
From:   Xuan Zhuo <xuanzhuo@linux.alibaba.com>
To:     Jason Wang <jasowang@redhat.com>
Cc:     mst <mst@redhat.com>, davem <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        virtualization <virtualization@lists.linux-foundation.org>,
        netdev <netdev@vger.kernel.org>,
        "linux-kernel" <linux-kernel@vger.kernel.org>
References: <20220630020805.74658-1-jasowang@redhat.com>
 <1656555045.7370687-2-xuanzhuo@linux.alibaba.com>
 <CACGkMEvMrxWRNY_NbujLsWff4zMVELr7C9CJ77k_m5OTFEe0dA@mail.gmail.com>
In-Reply-To: <CACGkMEvMrxWRNY_NbujLsWff4zMVELr7C9CJ77k_m5OTFEe0dA@mail.gmail.com>
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 30 Jun 2022 14:07:52 +0800, Jason Wang <jasowang@redhat.com> wrote:
> On Thu, Jun 30, 2022 at 10:22 AM Xuan Zhuo <xuanzhuo@linux.alibaba.com> wrote:
> >
> > On Thu, 30 Jun 2022 10:08:04 +0800, Jason Wang <jasowang@redhat.com> wrote:
> > > We try using cancel_delayed_work_sync() to prevent the work from
> > > enabling NAPI. This is insufficient since we don't disable the source
> > > of the refill work scheduling. This means an NAPI poll callback after
> > > cancel_delayed_work_sync() can schedule the refill work then can
> > > re-enable the NAPI that leads to use-after-free [1].
> >
> >
> > Can you explain in more detail how this happened?
> >
> > napi_disable() is normally called after cancel_delayed_work_sync(). This ensures
> > that all napi callbacks will end, and the new napi_disable() will wait.
> > There will be no re-enable napi.
>
> An rx interrupt that may come between after the cancel_delayed_work()
> but before the napi_disable(). It schedules a refill_work that may run
> after the napi_disable() in virtnet_close().

Yes


>
> >
> > So I guess the use-after-free is caused by refill_work being called after
> > dev/vi/napi is released. In this way, we can just call
> > cancel_delayed_work_sync() after napi_disalbe().
>
> So the refill_work can re-enable the NAPI when it is run after
> napi_disable() in this case.


Since napi_disable() has been called in virtnet_close(), it will get stuck when
napi_disable() in refill_work(). I think use-after-free is because vi/napi etc.
have been released, refill_work() going to access again causes an exception.

napi will not be re-enable.

I would like to call cancel_delayed_work_sync() after napi_disable()
to solve this problem. But this also has a problem, refill_work() can get stuck
on napi_disable() and cannot exit. In this way, we want napi_disable() to check
that the current state is disabled and exit directly.

Thanks.


>
> Thanks
>
>
> >
> > Thanks.
> >
> > >
> > > Since the work can enable NAPI, we can't simply disable NAPI before
> > > calling cancel_delayed_work_sync(). So fix this by introducing a
> > > dedicated boolean to control whether or not the work could be
> > > scheduled from NAPI.
> > >
> > > [1]
> > > ==================================================================
> > > BUG: KASAN: use-after-free in refill_work+0x43/0xd4
> > > Read of size 2 at addr ffff88810562c92e by task kworker/2:1/42
> > >
> > > CPU: 2 PID: 42 Comm: kworker/2:1 Not tainted 5.19.0-rc1+ #480
> > > Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS rel-1.16.0-0-gd239552ce722-prebuilt.qemu.org 04/01/2014
> > > Workqueue: events refill_work
> > > Call Trace:
> > >  <TASK>
> > >  dump_stack_lvl+0x34/0x44
> > >  print_report.cold+0xbb/0x6ac
> > >  ? _printk+0xad/0xde
> > >  ? refill_work+0x43/0xd4
> > >  kasan_report+0xa8/0x130
> > >  ? refill_work+0x43/0xd4
> > >  refill_work+0x43/0xd4
> > >  process_one_work+0x43d/0x780
> > >  worker_thread+0x2a0/0x6f0
> > >  ? process_one_work+0x780/0x780
> > >  kthread+0x167/0x1a0
> > >  ? kthread_exit+0x50/0x50
> > >  ret_from_fork+0x22/0x30
> > >  </TASK>
> > > ...
> > >
> > > Fixes: b2baed69e605c ("virtio_net: set/cancel work on ndo_open/ndo_stop")
> > > Signed-off-by: Jason Wang <jasowang@redhat.com>
> > > ---
> > >  drivers/net/virtio_net.c | 38 ++++++++++++++++++++++++++++++++++++--
> > >  1 file changed, 36 insertions(+), 2 deletions(-)
> > >
> > > diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> > > index db05b5e930be..21bf1e5c81ef 100644
> > > --- a/drivers/net/virtio_net.c
> > > +++ b/drivers/net/virtio_net.c
> > > @@ -251,6 +251,12 @@ struct virtnet_info {
> > >       /* Does the affinity hint is set for virtqueues? */
> > >       bool affinity_hint_set;
> > >
> > > +     /* Is refill work enabled? */
> > > +     bool refill_work_enabled;
> > > +
> > > +     /* The lock to synchronize the access to refill_work_enabled */
> > > +     spinlock_t refill_lock;
> > > +
> > >       /* CPU hotplug instances for online & dead */
> > >       struct hlist_node node;
> > >       struct hlist_node node_dead;
> > > @@ -348,6 +354,20 @@ static struct page *get_a_page(struct receive_queue *rq, gfp_t gfp_mask)
> > >       return p;
> > >  }
> > >
> > > +static void enable_refill_work(struct virtnet_info *vi)
> > > +{
> > > +     spin_lock(&vi->refill_lock);
> > > +     vi->refill_work_enabled = true;
> > > +     spin_unlock(&vi->refill_lock);
> > > +}
> > > +
> > > +static void disable_refill_work(struct virtnet_info *vi)
> > > +{
> > > +     spin_lock(&vi->refill_lock);
> > > +     vi->refill_work_enabled = false;
> > > +     spin_unlock(&vi->refill_lock);
> > > +}
> > > +
> > >  static void virtqueue_napi_schedule(struct napi_struct *napi,
> > >                                   struct virtqueue *vq)
> > >  {
> > > @@ -1527,8 +1547,12 @@ static int virtnet_receive(struct receive_queue *rq, int budget,
> > >       }
> > >
> > >       if (rq->vq->num_free > min((unsigned int)budget, virtqueue_get_vring_size(rq->vq)) / 2) {
> > > -             if (!try_fill_recv(vi, rq, GFP_ATOMIC))
> > > -                     schedule_delayed_work(&vi->refill, 0);
> > > +             if (!try_fill_recv(vi, rq, GFP_ATOMIC)) {
> > > +                     spin_lock(&vi->refill_lock);
> > > +                     if (vi->refill_work_enabled)
> > > +                             schedule_delayed_work(&vi->refill, 0);
> > > +                     spin_unlock(&vi->refill_lock);
> > > +             }
> > >       }
> > >
> > >       u64_stats_update_begin(&rq->stats.syncp);
> > > @@ -1651,6 +1675,8 @@ static int virtnet_open(struct net_device *dev)
> > >       struct virtnet_info *vi = netdev_priv(dev);
> > >       int i, err;
> > >
> > > +     enable_refill_work(vi);
> > > +
> > >       for (i = 0; i < vi->max_queue_pairs; i++) {
> > >               if (i < vi->curr_queue_pairs)
> > >                       /* Make sure we have some buffers: if oom use wq. */
> > > @@ -2033,6 +2059,8 @@ static int virtnet_close(struct net_device *dev)
> > >       struct virtnet_info *vi = netdev_priv(dev);
> > >       int i;
> > >
> > > +     /* Make sure NAPI doesn't schedule refill work */
> > > +     disable_refill_work(vi);
> > >       /* Make sure refill_work doesn't re-enable napi! */
> > >       cancel_delayed_work_sync(&vi->refill);
> > >
> > > @@ -2776,6 +2804,9 @@ static void virtnet_freeze_down(struct virtio_device *vdev)
> > >       netif_tx_lock_bh(vi->dev);
> > >       netif_device_detach(vi->dev);
> > >       netif_tx_unlock_bh(vi->dev);
> > > +     /* Make sure NAPI doesn't schedule refill work */
> > > +     disable_refill_work(vi);
> > > +     /* Make sure refill_work doesn't re-enable napi! */
> > >       cancel_delayed_work_sync(&vi->refill);
> > >
> > >       if (netif_running(vi->dev)) {
> > > @@ -2799,6 +2830,8 @@ static int virtnet_restore_up(struct virtio_device *vdev)
> > >
> > >       virtio_device_ready(vdev);
> > >
> > > +     enable_refill_work(vi);
> > > +
> > >       if (netif_running(vi->dev)) {
> > >               for (i = 0; i < vi->curr_queue_pairs; i++)
> > >                       if (!try_fill_recv(vi, &vi->rq[i], GFP_KERNEL))
> > > @@ -3548,6 +3581,7 @@ static int virtnet_probe(struct virtio_device *vdev)
> > >       vdev->priv = vi;
> > >
> > >       INIT_WORK(&vi->config_work, virtnet_config_changed_work);
> > > +     spin_lock_init(&vi->refill_lock);
> > >
> > >       /* If we can receive ANY GSO packets, we must allocate large ones. */
> > >       if (virtio_has_feature(vdev, VIRTIO_NET_F_GUEST_TSO4) ||
> > > --
> > > 2.25.1
> > >
> >
>
