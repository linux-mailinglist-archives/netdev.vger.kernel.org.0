Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 01591E2D02
	for <lists+netdev@lfdr.de>; Thu, 24 Oct 2019 11:17:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393033AbfJXJRt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Oct 2019 05:17:49 -0400
Received: from mga01.intel.com ([192.55.52.88]:7055 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726506AbfJXJRt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 24 Oct 2019 05:17:49 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga101.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 24 Oct 2019 02:17:49 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.68,224,1569308400"; 
   d="scan'208";a="197678491"
Received: from dpdk-virtio-tbie-2.sh.intel.com (HELO ___) ([10.67.104.74])
  by fmsmga007.fm.intel.com with ESMTP; 24 Oct 2019 02:17:47 -0700
Date:   Thu, 24 Oct 2019 17:18:39 +0800
From:   Tiwei Bie <tiwei.bie@intel.com>
To:     Jason Wang <jasowang@redhat.com>
Cc:     mst@redhat.com, alex.williamson@redhat.com,
        maxime.coquelin@redhat.com, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, dan.daly@intel.com,
        cunming.liang@intel.com, zhihong.wang@intel.com,
        lingshan.zhu@intel.com
Subject: Re: [PATCH v2] vhost: introduce mdev based hardware backend
Message-ID: <20191024091839.GA17463@___>
References: <47a572fd-5597-1972-e177-8ee25ca51247@redhat.com>
 <20191023030253.GA15401@___>
 <ac36f1e3-b972-71ac-fe0c-3db03e016dcf@redhat.com>
 <20191023070747.GA30533@___>
 <106834b5-dae5-82b2-0f97-16951709d075@redhat.com>
 <20191023101135.GA6367@___>
 <5a7bc5da-d501-2750-90bf-545dd55f85fa@redhat.com>
 <20191024042155.GA21090@___>
 <d37529e1-5147-bbe5-cb9d-299bd6d4aa1a@redhat.com>
 <d4cc4f4e-2635-4041-2f68-cd043a97f25a@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <d4cc4f4e-2635-4041-2f68-cd043a97f25a@redhat.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 24, 2019 at 04:32:42PM +0800, Jason Wang wrote:
> On 2019/10/24 下午4:03, Jason Wang wrote:
> > On 2019/10/24 下午12:21, Tiwei Bie wrote:
> > > On Wed, Oct 23, 2019 at 06:29:21PM +0800, Jason Wang wrote:
> > > > On 2019/10/23 下午6:11, Tiwei Bie wrote:
> > > > > On Wed, Oct 23, 2019 at 03:25:00PM +0800, Jason Wang wrote:
> > > > > > On 2019/10/23 下午3:07, Tiwei Bie wrote:
> > > > > > > On Wed, Oct 23, 2019 at 01:46:23PM +0800, Jason Wang wrote:
> > > > > > > > On 2019/10/23 上午11:02, Tiwei Bie wrote:
> > > > > > > > > On Tue, Oct 22, 2019 at 09:30:16PM +0800, Jason Wang wrote:
> > > > > > > > > > On 2019/10/22 下午5:52, Tiwei Bie wrote:
> > > > > > > > > > > This patch introduces a mdev based hardware vhost backend.
> > > > > > > > > > > This backend is built on top of the same abstraction used
> > > > > > > > > > > in virtio-mdev and provides a generic vhost interface for
> > > > > > > > > > > userspace to accelerate the virtio devices in guest.
> > > > > > > > > > > 
> > > > > > > > > > > This backend is implemented as a mdev device driver on top
> > > > > > > > > > > of the same mdev device ops used in virtio-mdev but using
> > > > > > > > > > > a different mdev class id, and it will register the device
> > > > > > > > > > > as a VFIO device for userspace to use. Userspace can setup
> > > > > > > > > > > the IOMMU with the existing VFIO container/group APIs and
> > > > > > > > > > > then get the device fd with the device name. After getting
> > > > > > > > > > > the device fd of this device, userspace can use vhost ioctls
> > > > > > > > > > > to setup the backend.
> > > > > > > > > > > 
> > > > > > > > > > > Signed-off-by: Tiwei Bie <tiwei.bie@intel.com>
> > > > > > > > > > > ---
> > > > > > > > > > > This patch depends on below series:
> > > > > > > > > > > https://lkml.org/lkml/2019/10/17/286
> > > > > > > > > > > 
> > > > > > > > > > > v1 -> v2:
> > > > > > > > > > > - Replace _SET_STATE with _SET_STATUS (MST);
> > > > > > > > > > > - Check status bits at each step (MST);
> > > > > > > > > > > - Report the max ring size and max number of queues (MST);
> > > > > > > > > > > - Add missing MODULE_DEVICE_TABLE (Jason);
> > > > > > > > > > > - Only support the network backend w/o multiqueue for now;
> > > > > > > > > > Any idea on how to extend it to support
> > > > > > > > > > devices other than net? I think we
> > > > > > > > > > want a generic API or an API that could
> > > > > > > > > > be made generic in the future.
> > > > > > > > > > 
> > > > > > > > > > Do we want to e.g having a generic vhost
> > > > > > > > > > mdev for all kinds of devices or
> > > > > > > > > > introducing e.g vhost-net-mdev and vhost-scsi-mdev?
> > > > > > > > > One possible way is to do what vhost-user does. I.e. Apart from
> > > > > > > > > the generic ring, features, ... related ioctls, we also introduce
> > > > > > > > > device specific ioctls when we need them. As vhost-mdev just needs
> > > > > > > > > to forward configs between parent and userspace and even won't
> > > > > > > > > cache any info when possible,
> > > > > > > > So it looks to me this is only possible if we
> > > > > > > > expose e.g set_config and
> > > > > > > > get_config to userspace.
> > > > > > > The set_config and get_config interface isn't really everything
> > > > > > > of device specific settings. We also have ctrlq in virtio-net.
> > > > > > Yes, but it could be processed by the exist API. Isn't
> > > > > > it? Just set ctrl vq
> > > > > > address and let parent to deal with that.
> > > > > I mean how to expose ctrlq related settings to userspace?
> > > > 
> > > > I think it works like:
> > > > 
> > > > 1) userspace find ctrl_vq is supported
> > > > 
> > > > 2) then it can allocate memory for ctrl vq and set its address through
> > > > vhost-mdev
> > > > 
> > > > 3) userspace can populate ctrl vq itself
> > > I see. That is to say, userspace e.g. QEMU will program the
> > > ctrl vq with the existing VHOST_*_VRING_* ioctls, and parent
> > > drivers should know that the addresses used in ctrl vq are
> > > host virtual addresses in vhost-mdev's case.
> > 
> > 
> > That's really good point. And that means parent needs to differ vhost
> > from virtio. It should work.
> 
> 
> HVA may only work when we have something similar to VHOST_SET_OWNER which
> can reuse MM of its owner.

We already have VHOST_SET_OWNER in vhost now, parent can handle
the commands in its .kick_vq() which is called by vq's .handle_kick
callback. Virtio-user did something similar:

https://github.com/DPDK/dpdk/blob/0da7f445df445630c794897347ee360d6fe6348b/drivers/net/virtio/virtio_user_ethdev.c#L313-L322

> 
> 
> > But is there any chance to use DMA address? I'm asking since the API
> > then tends to be device specific.
> 
> 
> I wonder whether we can introduce MAP IOMMU notifier and get DMA mappings
> from that.

I think this will complicate things unnecessarily and may
bring pains. Because, in vhost-mdev, mdev's ctrl vq is
supposed to be managed by host. And we should try to avoid
putting ctrl vq and Rx/Tx vqs in the same DMA space to prevent
guests having the chance to bypass the host (e.g. QEMU) to
setup the backend accelerator directly.

> 
> Thanks
> 
