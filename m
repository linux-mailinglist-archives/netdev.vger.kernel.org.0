Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 35B6354B6A2
	for <lists+netdev@lfdr.de>; Tue, 14 Jun 2022 18:48:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244066AbiFNQqZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jun 2022 12:46:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244321AbiFNQqU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jun 2022 12:46:20 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 544F228981;
        Tue, 14 Jun 2022 09:46:19 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 2783016F3;
        Tue, 14 Jun 2022 09:46:19 -0700 (PDT)
Received: from e120937-lin (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 256253F66F;
        Tue, 14 Jun 2022 09:46:16 -0700 (PDT)
Date:   Tue, 14 Jun 2022 17:46:10 +0100
From:   Cristian Marussi <cristian.marussi@arm.com>
To:     Jason Wang <jasowang@redhat.com>
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
        virtualization <virtualization@lists.linux-foundation.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        "Paul E. McKenney" <paulmck@kernel.org>,
        Marc Zyngier <maz@kernel.org>,
        Halil Pasic <pasic@linux.ibm.com>,
        Cornelia Huck <cohuck@redhat.com>,
        eperezma <eperezma@redhat.com>, Cindy Lu <lulu@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
        Vineeth Vijayan <vneethv@linux.ibm.com>,
        Peter Oberparleiter <oberpar@linux.ibm.com>,
        linux-s390@vger.kernel.org, conghui.chen@intel.com,
        Viresh Kumar <viresh.kumar@linaro.org>,
        netdev <netdev@vger.kernel.org>, pankaj.gupta.linux@gmail.com,
        sudeep.holla@arm.com, Bjorn Andersson <bjorn.andersson@linaro.org>,
        Mathieu Poirier <mathieu.poirier@linaro.org>
Subject: Re: [PATCH V6 8/9] virtio: harden vring IRQ
Message-ID: <Yqi7UhasBDPKCpuV@e120937-lin>
References: <CACGkMEtRP+0Xy63g0SF_y1avv=3rFv6P9+Z7kp9XBS5d+_py8w@mail.gmail.com>
 <20220613023337-mutt-send-email-mst@kernel.org>
 <CACGkMEs05ZisiPW+7H6Omp80MzmZWZCpc1mf5Vd99C3H-KUtgA@mail.gmail.com>
 <20220613041416-mutt-send-email-mst@kernel.org>
 <CACGkMEsT_fWdPxN1cTWOX=vu-ntp3Xo4j46-ZKALeSXr7DmJFQ@mail.gmail.com>
 <20220613045606-mutt-send-email-mst@kernel.org>
 <CACGkMEtAQck7Nr6SP_pD0MGT3njnwZSyT=xPyYzUU3c5GNNM_w@mail.gmail.com>
 <CACGkMEvUFJkC=mnvL2PSH6-3RMcJUk84f-9X46JVcj2vTAr4SQ@mail.gmail.com>
 <20220613052644-mutt-send-email-mst@kernel.org>
 <CACGkMEstGvhETXThuwO+tLVBuRgQb8uC_6DdAM8ZxOi5UKBRbg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACGkMEstGvhETXThuwO+tLVBuRgQb8uC_6DdAM8ZxOi5UKBRbg@mail.gmail.com>
X-Spam-Status: No, score=-6.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 14, 2022 at 03:40:21PM +0800, Jason Wang wrote:
> On Mon, Jun 13, 2022 at 5:28 PM Michael S. Tsirkin <mst@redhat.com> wrote:
> >

Hi Jason,

> > On Mon, Jun 13, 2022 at 05:14:59PM +0800, Jason Wang wrote:
> > > On Mon, Jun 13, 2022 at 5:08 PM Jason Wang <jasowang@redhat.com> wrote:
> > > >
> > > > On Mon, Jun 13, 2022 at 4:59 PM Michael S. Tsirkin <mst@redhat.com> wrote:
> > > > >
> > > > > On Mon, Jun 13, 2022 at 04:51:08PM +0800, Jason Wang wrote:
> > > > > > On Mon, Jun 13, 2022 at 4:19 PM Michael S. Tsirkin <mst@redhat.com> wrote:
> > > > > > >
> > > > > > > On Mon, Jun 13, 2022 at 04:07:09PM +0800, Jason Wang wrote:
> > > > > > > > On Mon, Jun 13, 2022 at 3:23 PM Michael S. Tsirkin <mst@redhat.com> wrote:
> > > > > > > > >
> > > > > > > > > On Mon, Jun 13, 2022 at 01:26:59PM +0800, Jason Wang wrote:
> > > > > > > > > > On Sat, Jun 11, 2022 at 1:12 PM Michael S. Tsirkin <mst@redhat.com> wrote:
> > > > > > > > > > >
> > > > > > > > > > > On Fri, May 27, 2022 at 02:01:19PM +0800, Jason Wang wrote:
> > > > > > > > > > > > This is a rework on the previous IRQ hardening that is done for
> > > > > > > > > > > > virtio-pci where several drawbacks were found and were reverted:
> > > > > > > > > > > >
> > > > > > > > > > > > 1) try to use IRQF_NO_AUTOEN which is not friendly to affinity managed IRQ
> > > > > > > > > > > >    that is used by some device such as virtio-blk
> > > > > > > > > > > > 2) done only for PCI transport
> > > > > > > > > > > >
> > > > > > > > > > > > The vq->broken is re-used in this patch for implementing the IRQ
> > > > > > > > > > > > hardening. The vq->broken is set to true during both initialization
> > > > > > > > > > > > and reset. And the vq->broken is set to false in
> > > > > > > > > > > > virtio_device_ready(). Then vring_interrupt() can check and return
> > > > > > > > > > > > when vq->broken is true. And in this case, switch to return IRQ_NONE
> > > > > > > > > > > > to let the interrupt core aware of such invalid interrupt to prevent
> > > > > > > > > > > > IRQ storm.
> > > > > > > > > > > >
> > > > > > > > > > > > The reason of using a per queue variable instead of a per device one
> > > > > > > > > > > > is that we may need it for per queue reset hardening in the future.
> > > > > > > > > > > >
> > > > > > > > > > > > Note that the hardening is only done for vring interrupt since the
> > > > > > > > > > > > config interrupt hardening is already done in commit 22b7050a024d7
> > > > > > > > > > > > ("virtio: defer config changed notifications"). But the method that is
> > > > > > > > > > > > used by config interrupt can't be reused by the vring interrupt
> > > > > > > > > > > > handler because it uses spinlock to do the synchronization which is
> > > > > > > > > > > > expensive.
> > > > > > > > > > > >
> > > > > > > > > > > > Cc: Thomas Gleixner <tglx@linutronix.de>
> > > > > > > > > > > > Cc: Peter Zijlstra <peterz@infradead.org>
> > > > > > > > > > > > Cc: "Paul E. McKenney" <paulmck@kernel.org>
> > > > > > > > > > > > Cc: Marc Zyngier <maz@kernel.org>
> > > > > > > > > > > > Cc: Halil Pasic <pasic@linux.ibm.com>
> > > > > > > > > > > > Cc: Cornelia Huck <cohuck@redhat.com>
> > > > > > > > > > > > Cc: Vineeth Vijayan <vneethv@linux.ibm.com>
> > > > > > > > > > > > Cc: Peter Oberparleiter <oberpar@linux.ibm.com>
> > > > > > > > > > > > Cc: linux-s390@vger.kernel.org
> > > > > > > > > > > > Signed-off-by: Jason Wang <jasowang@redhat.com>
> > > > > > > > > > >
> > > > > > > > > > >
> > > > > > > > > > > Jason, I am really concerned by all the fallout.
> > > > > > > > > > > I propose adding a flag to suppress the hardening -
> > > > > > > > > > > this will be a debugging aid and a work around for
> > > > > > > > > > > users if we find more buggy drivers.
> > > > > > > > > > >
> > > > > > > > > > > suppress_interrupt_hardening ?
> > > > > > > > > >
> > > > > > > > > > I can post a patch but I'm afraid if we disable it by default, it
> > > > > > > > > > won't be used by the users so there's no way for us to receive the bug
> > > > > > > > > > report. Or we need a plan to enable it by default.
> > > > > > > > > >
> > > > > > > > > > It's rc2, how about waiting for 1 and 2 rc? Or it looks better if we
> > > > > > > > > > simply warn instead of disable it by default.
> > > > > > > > > >
> > > > > > > > > > Thanks
> > > > > > > > >
> > > > > > > > > I meant more like a flag in struct virtio_driver.
> > > > > > > > > For now, could you audit all drivers which don't call _ready?
> > > > > > > > > I found 5 of these:
> > > > > > > > >
> > > > > > > > > drivers/bluetooth/virtio_bt.c
> > > > > > > >
> > > > > > > > This driver seems to be fine, it doesn't use the device/vq in its probe().
> > > > > > >
> > > > > > >
> > > > > > > But it calls hci_register_dev and that in turn queues all kind of
> > > > > > > work. Also, can linux start using the device immediately after
> > > > > > > it's registered?
> > > > > >
> > > > > > So I think the driver is allowed to queue before DRIVER_OK.
> > > > >
> > > > > it's not allowed to kick
> > > >
> > > > Yes.
> > > >
> > > > >
> > > > > > If yes,
> > > > > > the only side effect is the delay of the tx interrupt after DRIVER_OK
> > > > > > for a well behaved device.
> > > > >
> > > > > your patches drop the interrupt though, it won't be just delayed.
> > > >
> > > > For a well behaved device, it can only trigger the interrupt after DRIVER_OK.
> > > >
> > > > So for virtio bt, it works like:
> > > >
> > > > 1) driver queue buffer and kick
> > > > 2) driver set DRIVER_OK
> > > > 3) device start to process the buffer
> > > > 4) device send an notification
> > > >
> > > > The only risk is that the virtqueue could be filled before DRIVER_OK,
> > > > or anything I missed?
> > >
> > > btw, hci has an open and close method and we do rx refill in
> > > hdev->open, so we're probably fine here.
> > >
> > > Thanks
> >
> >
> > Sounds good. Now to audit the rest of them from this POV ;)
> 
> Adding maintainers.
> 
> >
> >  drivers/i2c/busses/i2c-virtio.c
> 
> It looks to me the device could be used immediately after
> i2c_add_adapter() return. So we probably need to add
> virtio_device_ready() before that. Fortunately, there's no rx vq in
> i2c and the callback looks safe if the callback is called before the
> i2c registration and after virtio_device_ready().
> 
> >  drivers/net/caif/caif_virtio.c
> 
> A networking device, RX is backed by vringh so we don't need to
> refill. TX is backed by virtio and is available until ndo_open. So
> it's fine to let the core to set DRIVER_OK after probe().
> 
> >  drivers/nvdimm/virtio_pmem.c
> 
> It doesn't use interrupt so far, so it has nothing to do with the IRQ hardening.
> 
> But the device could be used by the subsystem immediately after
> nvdimm_pmem_region_create(), this means the flush could be issued
> before DRIVER_OK. We need virtio_device_ready() before. We don't have
> a RX virtqueue and the callback looks safe if the callback is called
> after virtio_device_ready() but before the nvdimm region creating.
> 
> And it looks to me there's a race between the assignment of
> provider_data and virtio_pmem_flush(). If the flush was issued before
> the assignment we will end up with a NULL pointer dereference. This is
> something we need to fix.
> 
> >  arm_scmi
> 
> It looks to me the singleton device could be used by SCMI immediately after
> 
>         /* Ensure initialized scmi_vdev is visible */
>         smp_store_mb(scmi_vdev, vdev);
> 
> So we probably need to do virtio_device_ready() before that. It has an
> optional rx queue but the filling is done after the above assignment,
> so it's safe. And the callback looks safe is a callback is triggered
> after virtio_device_ready() buy before the above assignment.
> 

I wanted to give it a go at this series testing it on the context of
SCMI but it does not apply

- not on a v5.18:

17:33 $ git rebase -i v5.18
17:33 $ git am ./v6_20220527_jasowang_rework_on_the_irq_hardening_of_virtio.mbx
Applying: virtio: use virtio_device_ready() in virtio_device_restore()
Applying: virtio: use virtio_reset_device() when possible
Applying: virtio: introduce config op to synchronize vring callbacks
Applying: virtio-pci: implement synchronize_cbs()
Applying: virtio-mmio: implement synchronize_cbs()
error: patch failed: drivers/virtio/virtio_mmio.c:345
error: drivers/virtio/virtio_mmio.c: patch does not apply
Patch failed at 0005 virtio-mmio: implement synchronize_cbs()

- neither on a v5.19-rc2:

17:33 $ git rebase -i v5.19-rc2 
17:35 $ git am ./v6_20220527_jasowang_rework_on_the_irq_hardening_of_virtio.mbx
Applying: virtio: use virtio_device_ready() in virtio_device_restore()
error: patch failed: drivers/virtio/virtio.c:526
error: drivers/virtio/virtio.c: patch does not apply
Patch failed at 0001 virtio: use virtio_device_ready() in
virtio_device_restore()
hint: Use 'git am --show-current-patch=diff' to see the failed patch
When you have resolved this problem, run "git am --continue".

... what I should take as base ?

Thanks,
Cristian

