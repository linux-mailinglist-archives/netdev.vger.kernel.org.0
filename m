Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 247A254D0D9
	for <lists+netdev@lfdr.de>; Wed, 15 Jun 2022 20:24:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356371AbiFOSYY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jun 2022 14:24:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245078AbiFOSYX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jun 2022 14:24:23 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 3CF5A252AC;
        Wed, 15 Jun 2022 11:24:22 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id B2EF0153B;
        Wed, 15 Jun 2022 11:24:21 -0700 (PDT)
Received: from e120937-lin (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id B39013F73B;
        Wed, 15 Jun 2022 11:24:18 -0700 (PDT)
Date:   Wed, 15 Jun 2022 19:24:08 +0100
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
Message-ID: <YqojyHuocSoZ0v/Y@e120937-lin>
References: <CACGkMEs05ZisiPW+7H6Omp80MzmZWZCpc1mf5Vd99C3H-KUtgA@mail.gmail.com>
 <20220613041416-mutt-send-email-mst@kernel.org>
 <CACGkMEsT_fWdPxN1cTWOX=vu-ntp3Xo4j46-ZKALeSXr7DmJFQ@mail.gmail.com>
 <20220613045606-mutt-send-email-mst@kernel.org>
 <CACGkMEtAQck7Nr6SP_pD0MGT3njnwZSyT=xPyYzUU3c5GNNM_w@mail.gmail.com>
 <CACGkMEvUFJkC=mnvL2PSH6-3RMcJUk84f-9X46JVcj2vTAr4SQ@mail.gmail.com>
 <20220613052644-mutt-send-email-mst@kernel.org>
 <CACGkMEstGvhETXThuwO+tLVBuRgQb8uC_6DdAM8ZxOi5UKBRbg@mail.gmail.com>
 <Yqi7UhasBDPKCpuV@e120937-lin>
 <CACGkMEv2A7ZHQTrdg9H=xZScAf2DE=Dguaz60ykd4KQGNLrn2Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACGkMEv2A7ZHQTrdg9H=xZScAf2DE=Dguaz60ykd4KQGNLrn2Q@mail.gmail.com>
X-Spam-Status: No, score=-6.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 15, 2022 at 09:41:18AM +0800, Jason Wang wrote:
> On Wed, Jun 15, 2022 at 12:46 AM Cristian Marussi
> <cristian.marussi@arm.com> wrote:

Hi Jason,

> >
> > On Tue, Jun 14, 2022 at 03:40:21PM +0800, Jason Wang wrote:
> > > On Mon, Jun 13, 2022 at 5:28 PM Michael S. Tsirkin <mst@redhat.com> wrote:
> > > >
> >

[snip]

> > >
> > > >  arm_scmi
> > >
> > > It looks to me the singleton device could be used by SCMI immediately after
> > >
> > >         /* Ensure initialized scmi_vdev is visible */
> > >         smp_store_mb(scmi_vdev, vdev);
> > >
> > > So we probably need to do virtio_device_ready() before that. It has an
> > > optional rx queue but the filling is done after the above assignment,
> > > so it's safe. And the callback looks safe is a callback is triggered
> > > after virtio_device_ready() buy before the above assignment.
> > >
> >
> > I wanted to give it a go at this series testing it on the context of
> > SCMI but it does not apply
> >
> > - not on a v5.18:
> >
> > 17:33 $ git rebase -i v5.18
> > 17:33 $ git am ./v6_20220527_jasowang_rework_on_the_irq_hardening_of_virtio.mbx
> > Applying: virtio: use virtio_device_ready() in virtio_device_restore()
> > Applying: virtio: use virtio_reset_device() when possible
> > Applying: virtio: introduce config op to synchronize vring callbacks
> > Applying: virtio-pci: implement synchronize_cbs()
> > Applying: virtio-mmio: implement synchronize_cbs()
> > error: patch failed: drivers/virtio/virtio_mmio.c:345
> > error: drivers/virtio/virtio_mmio.c: patch does not apply
> > Patch failed at 0005 virtio-mmio: implement synchronize_cbs()
> >
> > - neither on a v5.19-rc2:
> >
> > 17:33 $ git rebase -i v5.19-rc2
> > 17:35 $ git am ./v6_20220527_jasowang_rework_on_the_irq_hardening_of_virtio.mbx
> > Applying: virtio: use virtio_device_ready() in virtio_device_restore()
> > error: patch failed: drivers/virtio/virtio.c:526
> > error: drivers/virtio/virtio.c: patch does not apply
> > Patch failed at 0001 virtio: use virtio_device_ready() in
> > virtio_device_restore()
> > hint: Use 'git am --show-current-patch=diff' to see the failed patch
> > When you have resolved this problem, run "git am --continue".
> >
> > ... what I should take as base ?
> 
> It should have already been included in rc2, so there's no need to
> apply patch manually.
> 

I tested this series as included in v5.19-rc2 (WITHOUT adding a virtio_device_ready
in SCMI virtio as you mentioned above ... if I got it right) and I have NOT seen any
issue around SCMI virtio using my usual test setup (using both SCMI vqueues).

No anomalies even when using SCMI virtio in atomic/polling mode.

Adding a virtio_device_ready() at the end of the SCMI virtio probe()
works fine either, it does not make any difference in my setup.
(both using QEMU and kvmtool with this latter NOT supporting
 virtio_V1...not sure if it makes a difference but I thought was worth
 mentioning)

Thanks,
Cristian

