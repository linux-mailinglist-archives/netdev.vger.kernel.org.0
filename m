Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3A9A8E84F0
	for <lists+netdev@lfdr.de>; Tue, 29 Oct 2019 10:57:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727514AbfJ2J4v (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Oct 2019 05:56:51 -0400
Received: from mga17.intel.com ([192.55.52.151]:31715 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726342AbfJ2J4u (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 29 Oct 2019 05:56:50 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga107.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 29 Oct 2019 02:56:50 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.68,243,1569308400"; 
   d="scan'208";a="374497156"
Received: from dpdk-virtio-tbie-2.sh.intel.com (HELO ___) ([10.67.104.74])
  by orsmga005.jf.intel.com with ESMTP; 29 Oct 2019 02:56:47 -0700
Date:   Tue, 29 Oct 2019 17:57:38 +0800
From:   Tiwei Bie <tiwei.bie@intel.com>
To:     Jason Wang <jasowang@redhat.com>
Cc:     "Michael S. Tsirkin" <mst@redhat.com>, alex.williamson@redhat.com,
        maxime.coquelin@redhat.com, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, dan.daly@intel.com,
        cunming.liang@intel.com, zhihong.wang@intel.com,
        lingshan.zhu@intel.com
Subject: Re: [PATCH v2] vhost: introduce mdev based hardware backend
Message-ID: <20191029095738.GA7228@___>
References: <5a7bc5da-d501-2750-90bf-545dd55f85fa@redhat.com>
 <20191024042155.GA21090@___>
 <d37529e1-5147-bbe5-cb9d-299bd6d4aa1a@redhat.com>
 <d4cc4f4e-2635-4041-2f68-cd043a97f25a@redhat.com>
 <20191024091839.GA17463@___>
 <fefc82a3-a137-bc03-e1c3-8de79b238080@redhat.com>
 <e7e239ba-2461-4f8d-7dd7-0f557ac7f4bf@redhat.com>
 <20191025080143-mutt-send-email-mst@kernel.org>
 <20191028015842.GA9005@___>
 <5e8a623d-9d91-607a-1f9e-7a7086ba9a68@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <5e8a623d-9d91-607a-1f9e-7a7086ba9a68@redhat.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 28, 2019 at 11:50:49AM +0800, Jason Wang wrote:
> On 2019/10/28 上午9:58, Tiwei Bie wrote:
> > On Fri, Oct 25, 2019 at 08:16:26AM -0400, Michael S. Tsirkin wrote:
> > > On Fri, Oct 25, 2019 at 05:54:55PM +0800, Jason Wang wrote:
> > > > On 2019/10/24 下午6:42, Jason Wang wrote:
> > > > > Yes.
> > > > > 
> > > > > 
> > > > > >    And we should try to avoid
> > > > > > putting ctrl vq and Rx/Tx vqs in the same DMA space to prevent
> > > > > > guests having the chance to bypass the host (e.g. QEMU) to
> > > > > > setup the backend accelerator directly.
> > > > > 
> > > > > That's really good point.  So when "vhost" type is created, parent
> > > > > should assume addr of ctrl_vq is hva.
> > > > > 
> > > > > Thanks
> > > > 
> > > > This works for vhost but not virtio since there's no way for virtio kernel
> > > > driver to differ ctrl_vq with the rest when doing DMA map. One possible
> > > > solution is to provide DMA domain isolation between virtqueues. Then ctrl vq
> > > > can use its dedicated DMA domain for the work.
> > It might not be a bad idea to let the parent drivers distinguish
> > between virtio-mdev mdevs and vhost-mdev mdevs in ctrl-vq handling
> > by mdev's class id.
> 
> 
> Yes, that should work, I have something probable better, see below.
> 
> 
> > 
> > > > Anyway, this could be done in the future. We can have a version first that
> > > > doesn't support ctrl_vq.
> > +1, thanks
> > 
> > > > Thanks
> > > Well no ctrl_vq implies either no offloads, or no XDP (since XDP needs
> > > to disable offloads dynamically).
> > > 
> > >          if (!virtio_has_feature(vi->vdev, VIRTIO_NET_F_CTRL_GUEST_OFFLOADS)
> > >              && (virtio_has_feature(vi->vdev, VIRTIO_NET_F_GUEST_TSO4) ||
> > >                  virtio_has_feature(vi->vdev, VIRTIO_NET_F_GUEST_TSO6) ||
> > >                  virtio_has_feature(vi->vdev, VIRTIO_NET_F_GUEST_ECN) ||
> > >                  virtio_has_feature(vi->vdev, VIRTIO_NET_F_GUEST_UFO) ||
> > >                  virtio_has_feature(vi->vdev, VIRTIO_NET_F_GUEST_CSUM))) {
> > >                  NL_SET_ERR_MSG_MOD(extack, "Can't set XDP while host is implementing LRO/CSUM, disable LRO/CSUM first");
> > >                  return -EOPNOTSUPP;
> > >          }
> > > 
> > > neither is very attractive.
> > > 
> > > So yes ok just for development but we do need to figure out how it will
> > > work down the road in production.
> > Totally agree.
> > 
> > > So really this specific virtio net device does not support control vq,
> > > instead it supports a different transport specific way to send commands
> > > to device.
> > > 
> > > Some kind of extension to the transport? Ideas?
> 
> 
> So it's basically an issue of isolating DMA domains. Maybe we can start with
> transport API for querying per vq DMA domain/ASID?
> 
> - for vhost-mdev, userspace can query the DMA domain for each specific
> virtqueue. For control vq, mdev can return id for software domain, for the
> rest mdev will return id of VFIO domain. Then userspace know that it should
> use different API for preparing the virtqueue, e.g for vq other than control
> vq, it should use VFIO DMA API. The control vq it should use hva instead.
> 
> - for virito-mdev, we can introduce per-vq DMA device, and route DMA mapping
> request for control vq back to mdev instead of the hardware. (We can wrap
> them into library or helpers to ease the development of vendor physical
> drivers).

Thanks for this proposal! I'm thinking about it these days.
I think it might be too complicated. I'm wondering whether we
can have something simpler. I will post a RFC patch to show
my idea today.

Thanks,
Tiwei

> 
> Thanks
> 
> 
> > > 
> > > 
> > > -- 
> > > MST
> 
