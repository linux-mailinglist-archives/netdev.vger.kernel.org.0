Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A4D6CE9B29
	for <lists+netdev@lfdr.de>; Wed, 30 Oct 2019 12:53:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726302AbfJ3Lxq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Oct 2019 07:53:46 -0400
Received: from mga06.intel.com ([134.134.136.31]:43399 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726065AbfJ3Lxq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 30 Oct 2019 07:53:46 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga104.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 30 Oct 2019 04:53:45 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.68,247,1569308400"; 
   d="scan'208";a="401479933"
Received: from dpdk-virtio-tbie-2.sh.intel.com (HELO ___) ([10.67.104.74])
  by fmsmga006.fm.intel.com with ESMTP; 30 Oct 2019 04:53:43 -0700
Date:   Wed, 30 Oct 2019 19:54:33 +0800
From:   Tiwei Bie <tiwei.bie@intel.com>
To:     Jason Wang <jasowang@redhat.com>
Cc:     mst@redhat.com, linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        dan.daly@intel.com, cunming.liang@intel.com,
        zhihong.wang@intel.com, lingshan.zhu@intel.com
Subject: Re: [RFC] vhost_mdev: add network control vq support
Message-ID: <20191030115433.GA27220@___>
References: <20191029101726.12699-1-tiwei.bie@intel.com>
 <59474431-9e77-567c-9a46-a3965f587f65@redhat.com>
 <20191030061711.GA11968@___>
 <39aa9f66-8e58-ea63-5795-7df8861ff3a0@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <39aa9f66-8e58-ea63-5795-7df8861ff3a0@redhat.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 30, 2019 at 03:04:37PM +0800, Jason Wang wrote:
> On 2019/10/30 下午2:17, Tiwei Bie wrote:
> > On Tue, Oct 29, 2019 at 06:51:32PM +0800, Jason Wang wrote:
> >> On 2019/10/29 下午6:17, Tiwei Bie wrote:
> >>> This patch adds the network control vq support in vhost-mdev.
> >>> A vhost-mdev specific op is introduced to allow parent drivers
> >>> to handle the network control commands come from userspace.
> >> Probably work for userspace driver but not kernel driver.
> > Exactly. This is only for userspace.
> >
> > I got your point now. In virtio-mdev kernel driver case,
> > the ctrl-vq can be special as well.
> >
> 
> Then maybe it's better to introduce vhost-mdev-net on top?
> 
> Looking at the other type of virtio device:
> 
> - console have two control virtqueues when multiqueue port is enabled
> 
> - SCSI has controlq + eventq
> 
> - GPU has controlq
> 
> - Crypto device has one controlq
> 
> - Socket has eventq
> 
> ...

Thanks for the list! It looks dirty to define specific
commands and types in vhost UAPI for each of them in the
future. It's definitely much better to find an approach
to solve it once for all if possible..

Just a quick thought, considering all vhost-mdev does
is just to forward settings between parent and userspace,
I'm wondering whether it's possible to make the argp
opaque in vhost-mdev UAPI and just introduce one generic
ioctl command to deliver these device specific commands
(which are opaque in vhost-mdev as vhost-mdev just pass
the pointer -- argp) defined by spec.

I'm also fine with exposing ctrlq to userspace directly.
PS. It's interesting that some devices have more than
one ctrlq. I need to take a close look first..


> 
> Thanks
> 
