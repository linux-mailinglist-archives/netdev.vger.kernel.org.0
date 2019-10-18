Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 89024DC619
	for <lists+netdev@lfdr.de>; Fri, 18 Oct 2019 15:31:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2408476AbfJRNbO convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 18 Oct 2019 09:31:14 -0400
Received: from mx1.redhat.com ([209.132.183.28]:45750 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729783AbfJRNbN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 18 Oct 2019 09:31:13 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id CE75D307D986;
        Fri, 18 Oct 2019 13:31:12 +0000 (UTC)
Received: from gondolin (dhcp-192-202.str.redhat.com [10.33.192.202])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 406EB60619;
        Fri, 18 Oct 2019 13:30:45 +0000 (UTC)
Date:   Fri, 18 Oct 2019 15:30:42 +0200
From:   Cornelia Huck <cohuck@redhat.com>
To:     Jason Wang <jasowang@redhat.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        intel-gfx@lists.freedesktop.org,
        intel-gvt-dev@lists.freedesktop.org, kwankhede@nvidia.com,
        alex.williamson@redhat.com, mst@redhat.com, tiwei.bie@intel.com,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        maxime.coquelin@redhat.com, cunming.liang@intel.com,
        zhihong.wang@intel.com, rob.miller@broadcom.com,
        xiao.w.wang@intel.com, haotian.wang@sifive.com,
        zhenyuw@linux.intel.com, zhi.a.wang@intel.com,
        jani.nikula@linux.intel.com, joonas.lahtinen@linux.intel.com,
        rodrigo.vivi@intel.com, airlied@linux.ie, daniel@ffwll.ch,
        farman@linux.ibm.com, pasic@linux.ibm.com, sebott@linux.ibm.com,
        oberpar@linux.ibm.com, heiko.carstens@de.ibm.com,
        gor@linux.ibm.com, borntraeger@de.ibm.com, akrowiak@linux.ibm.com,
        freude@linux.ibm.com, lingshan.zhu@intel.com, idos@mellanox.com,
        eperezma@redhat.com, lulu@redhat.com, parav@mellanox.com,
        christophe.de.dinechin@gmail.com, kevin.tian@intel.com,
        stefanha@redhat.com
Subject: Re: [PATCH V4 4/6] mdev: introduce virtio device and its device ops
Message-ID: <20191018153042.3516cde1.cohuck@redhat.com>
In-Reply-To: <733c0cfe-064f-c8ba-6bf8-165db88d7e07@redhat.com>
References: <20191017104836.32464-1-jasowang@redhat.com>
        <20191017104836.32464-5-jasowang@redhat.com>
        <20191018114614.6f1e79dc.cohuck@redhat.com>
        <733c0cfe-064f-c8ba-6bf8-165db88d7e07@redhat.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.48]); Fri, 18 Oct 2019 13:31:13 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 18 Oct 2019 18:55:02 +0800
Jason Wang <jasowang@redhat.com> wrote:

> On 2019/10/18 下午5:46, Cornelia Huck wrote:
> > On Thu, 17 Oct 2019 18:48:34 +0800
> > Jason Wang <jasowang@redhat.com> wrote:

> >> + * @get_vendor_id:		Get virtio vendor id
> >> + *				@mdev: mediated device
> >> + *				Returns u32: virtio vendor id  
> > How is the vendor id defined? As for normal virtio-pci devices?  
> 
> 
> The vendor that provides this device. So something like this
> 
> I notice that MMIO also had this so it looks to me it's not pci specific.

Ok. Would be good to specify this more explicitly.

> 
> 
> >  
> >> + * @get_status: 		Get the device status
> >> + *				@mdev: mediated device
> >> + *				Returns u8: virtio device status
> >> + * @set_status: 		Set the device status
> >> + *				@mdev: mediated device
> >> + *				@status: virtio device status
> >> + * @get_config: 		Read from device specific configuration space
> >> + *				@mdev: mediated device
> >> + *				@offset: offset from the beginning of
> >> + *				configuration space
> >> + *				@buf: buffer used to read to
> >> + *				@len: the length to read from
> >> + *				configration space
> >> + * @set_config: 		Write to device specific configuration space
> >> + *				@mdev: mediated device
> >> + *				@offset: offset from the beginning of
> >> + *				configuration space
> >> + *				@buf: buffer used to write from
> >> + *				@len: the length to write to
> >> + *				configration space
> >> + * @get_mdev_features:		Get the feature of virtio mdev device
> >> + *				@mdev: mediated device
> >> + *				Returns the mdev features (API) support by
> >> + *				the device.  
> > What kind of 'features' are supposed to go in there? Are these bits,
> > like you defined for VIRTIO_MDEV_F_VERSION_1 above?  
> 
> 
> It's the API or mdev features other than virtio features. It could be 
> used by driver to determine the capability of the mdev device. Besides 
> _F_VERSION_1, we may add dirty page tracking etc which means we need new 
> device ops.

Ok, so that's supposed to be distinct bits that can be or'ed together?
Makes sense, but probably needs some more documentation somewhere.

> 
> 
> >  
> >> + * @get_generation:		Get device generaton
> >> + *				@mdev: mediated device
> >> + *				Returns u32: device generation  
> > Is that callback mandatory?  
> 
> 
> I think so, it's hard to emulate that completely in virtio-mdev transport.

IIRC, the generation stuff is not mandatory in the current version of
virtio, as not all transports have that concept.

Generally, are any of the callbacks optional, or are all of them
mandatory? From what I understand, you plan to add new things that
depend on features... would that mean non-mandatory callbacks?
