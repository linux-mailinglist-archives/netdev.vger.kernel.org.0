Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 46D5F6BAE9
	for <lists+netdev@lfdr.de>; Wed, 17 Jul 2019 13:03:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726744AbfGQLC6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Jul 2019 07:02:58 -0400
Received: from mx1.redhat.com ([209.132.183.28]:27903 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725799AbfGQLC5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 17 Jul 2019 07:02:57 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 4FDDF59440;
        Wed, 17 Jul 2019 11:02:57 +0000 (UTC)
Received: from redhat.com (ovpn-120-247.rdu2.redhat.com [10.10.120.247])
        by smtp.corp.redhat.com (Postfix) with SMTP id B791E614C1;
        Wed, 17 Jul 2019 11:02:49 +0000 (UTC)
Date:   Wed, 17 Jul 2019 07:02:48 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Jason Wang <jasowang@redhat.com>
Cc:     kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        jfreimann@redhat.com, tiwei.bie@intel.com,
        maxime.coquelin@redhat.com
Subject: Re: [PATCH V3 00/15] Packed virtqueue support for vhost
Message-ID: <20190717070100-mutt-send-email-mst@kernel.org>
References: <20190717105255.63488-1-jasowang@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190717105255.63488-1-jasowang@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.39]); Wed, 17 Jul 2019 11:02:57 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 17, 2019 at 06:52:40AM -0400, Jason Wang wrote:
> Hi all:
> 
> This series implements packed virtqueues which were described
> at [1]. In this version we try to address the performance regression
> saw by V2. The root cause is packed virtqueue need more times of
> userspace memory accesssing which turns out to be very
> expensive. Thanks to the help of 7f466032dc9e ("vhost: access vq
> metadata through kernel virtual address"), such overhead cold be
> eliminated. So in this version, we can see about 2% improvement for
> packed virtqueue on PPS.


Great job, thanks!
Pls allow a bit more review time than usual as this is a big patchset.
Should be done by Tuesday.
-next material anyway.

> More optimizations (e.g IN_ORDER) is on the road.
> 
> Please review.
> 
> [1] https://docs.oasis-open.org/virtio/virtio/v1.1/csprd01/virtio-v1.1-csprd01.html#x1-610007
> 
> This version were tested with:
> - zercopy/datacopy
> - mergeable buffer on/off
> - TCP stream & virtio-user
> 
> Changes from V2:
> - rebase on top of vhost metadata accelreation series
> - introduce shadow used ring API
> - new SET_VRING_BASE/GET_VRING_BASE that takes care about warp counter
>   and index for both avail and used
> - various twaeaks
> 
> Changes from V1:
> - drop uapi patch and use Tiwei's
> - split the enablement of packed virtqueue into a separate patch
> 
> Changes from RFC V5:
> - save unnecessary barriers during vhost_add_used_packed_n()
> - more compact math for event idx
> - fix failure of SET_VRING_BASE when avail_wrap_counter is true
> - fix not copy avail_wrap_counter during GET_VRING_BASE
> - introduce SET_VRING_USED_BASE/GET_VRING_USED_BASE for syncing
> - last_used_idx
> - rename used_wrap_counter to last_used_wrap_counter
> - rebase to net-next
> 
> Changes from RFC V4:
> - fix signalled_used index recording
> - track avail index correctly
> - various minor fixes
> 
> Changes from RFC V3:
> - Fix math on event idx checking
> - Sync last avail wrap counter through GET/SET_VRING_BASE
> - remove desc_event prefix in the driver/device structure
> 
> Changes from RFC V2:
> - do not use & in checking desc_event_flags
> - off should be most significant bit
> - remove the workaround of mergeable buffer for dpdk prototype
> - id should be in the last descriptor in the chain
> - keep _F_WRITE for write descriptor when adding used
> - device flags updating should use ADDR_USED type
> - return error on unexpected unavail descriptor in a chain
> - return false in vhost_ve_avail_empty is descriptor is available
> - track last seen avail_wrap_counter
> - correctly examine available descriptor in get_indirect_packed()
> - vhost_idx_diff should return u16 instead of bool
> 
> Changes from RFC V1:
> - Refactor vhost used elem code to avoid open coding on used elem
> - Event suppression support (compile test only).
> - Indirect descriptor support (compile test only).
> - Zerocopy support.
> - vIOMMU support.
> - SCSI/VSOCK support (compile test only).
> - Fix several bugs
> 
> Jason Wang (15):
>   vhost: simplify meta data pointer accessing
>   vhost: remove the unnecessary parameter of vhost_vq_avail_empty()
>   vhost: remove unnecessary parameter of
>     vhost_enable_notify()/vhost_disable_notify
>   vhost-net: don't use vhost_add_used_n() for zerocopy
>   vhost: introduce helpers to manipulate shadow used ring
>   vhost_net: switch TX to use shadow used ring API
>   vhost_net: calculate last used length once for mergeable buffer
>   vhost_net: switch to use shadow used ring API for RX
>   vhost: do not export vhost_add_used_n() and
>     vhost_add_used_and_signal_n()
>   vhost: hide used ring layout from device
>   vhost: do not use vring_used_elem
>   vhost: vhost_put_user() can accept metadata type
>   vhost: packed ring support
>   vhost: event suppression for packed ring
>   vhost: enable packed virtqueues
> 
>  drivers/vhost/net.c   |  200 +++---
>  drivers/vhost/scsi.c  |   72 +-
>  drivers/vhost/test.c  |    6 +-
>  drivers/vhost/vhost.c | 1508 +++++++++++++++++++++++++++++++++++------
>  drivers/vhost/vhost.h |   78 ++-
>  drivers/vhost/vsock.c |   57 +-
>  6 files changed, 1513 insertions(+), 408 deletions(-)
> 
> -- 
> 2.18.1
