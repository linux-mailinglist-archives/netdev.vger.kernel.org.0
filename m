Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 30FC0E6A97
	for <lists+netdev@lfdr.de>; Mon, 28 Oct 2019 02:57:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729654AbfJ1B5y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 27 Oct 2019 21:57:54 -0400
Received: from mga11.intel.com ([192.55.52.93]:16201 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727598AbfJ1B5x (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 27 Oct 2019 21:57:53 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga102.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 27 Oct 2019 18:57:53 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.68,238,1569308400"; 
   d="scan'208";a="229541691"
Received: from dpdk-virtio-tbie-2.sh.intel.com (HELO ___) ([10.67.104.74])
  by fmsmga002.fm.intel.com with ESMTP; 27 Oct 2019 18:57:51 -0700
Date:   Mon, 28 Oct 2019 09:58:42 +0800
From:   Tiwei Bie <tiwei.bie@intel.com>
To:     Jason Wang <jasowang@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>
Cc:     alex.williamson@redhat.com, maxime.coquelin@redhat.com,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        dan.daly@intel.com, cunming.liang@intel.com,
        zhihong.wang@intel.com, lingshan.zhu@intel.com
Subject: Re: [PATCH v2] vhost: introduce mdev based hardware backend
Message-ID: <20191028015842.GA9005@___>
References: <106834b5-dae5-82b2-0f97-16951709d075@redhat.com>
 <20191023101135.GA6367@___>
 <5a7bc5da-d501-2750-90bf-545dd55f85fa@redhat.com>
 <20191024042155.GA21090@___>
 <d37529e1-5147-bbe5-cb9d-299bd6d4aa1a@redhat.com>
 <d4cc4f4e-2635-4041-2f68-cd043a97f25a@redhat.com>
 <20191024091839.GA17463@___>
 <fefc82a3-a137-bc03-e1c3-8de79b238080@redhat.com>
 <e7e239ba-2461-4f8d-7dd7-0f557ac7f4bf@redhat.com>
 <20191025080143-mutt-send-email-mst@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20191025080143-mutt-send-email-mst@kernel.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 25, 2019 at 08:16:26AM -0400, Michael S. Tsirkin wrote:
> On Fri, Oct 25, 2019 at 05:54:55PM +0800, Jason Wang wrote:
> > On 2019/10/24 下午6:42, Jason Wang wrote:
> > > 
> > > Yes.
> > > 
> > > 
> > > >   And we should try to avoid
> > > > putting ctrl vq and Rx/Tx vqs in the same DMA space to prevent
> > > > guests having the chance to bypass the host (e.g. QEMU) to
> > > > setup the backend accelerator directly.
> > > 
> > > 
> > > That's really good point.  So when "vhost" type is created, parent
> > > should assume addr of ctrl_vq is hva.
> > > 
> > > Thanks
> > 
> > 
> > This works for vhost but not virtio since there's no way for virtio kernel
> > driver to differ ctrl_vq with the rest when doing DMA map. One possible
> > solution is to provide DMA domain isolation between virtqueues. Then ctrl vq
> > can use its dedicated DMA domain for the work.

It might not be a bad idea to let the parent drivers distinguish
between virtio-mdev mdevs and vhost-mdev mdevs in ctrl-vq handling
by mdev's class id.

> > 
> > Anyway, this could be done in the future. We can have a version first that
> > doesn't support ctrl_vq.

+1, thanks

> > 
> > Thanks
> 
> Well no ctrl_vq implies either no offloads, or no XDP (since XDP needs
> to disable offloads dynamically).
> 
>         if (!virtio_has_feature(vi->vdev, VIRTIO_NET_F_CTRL_GUEST_OFFLOADS)
>             && (virtio_has_feature(vi->vdev, VIRTIO_NET_F_GUEST_TSO4) ||
>                 virtio_has_feature(vi->vdev, VIRTIO_NET_F_GUEST_TSO6) ||
>                 virtio_has_feature(vi->vdev, VIRTIO_NET_F_GUEST_ECN) ||
>                 virtio_has_feature(vi->vdev, VIRTIO_NET_F_GUEST_UFO) ||
>                 virtio_has_feature(vi->vdev, VIRTIO_NET_F_GUEST_CSUM))) {
>                 NL_SET_ERR_MSG_MOD(extack, "Can't set XDP while host is implementing LRO/CSUM, disable LRO/CSUM first");
>                 return -EOPNOTSUPP;
>         }
> 
> neither is very attractive.
> 
> So yes ok just for development but we do need to figure out how it will
> work down the road in production.

Totally agree.

> 
> So really this specific virtio net device does not support control vq,
> instead it supports a different transport specific way to send commands
> to device.
> 
> Some kind of extension to the transport? Ideas?
> 
> 
> -- 
> MST
