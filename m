Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2576136E343
	for <lists+netdev@lfdr.de>; Thu, 29 Apr 2021 04:31:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231161AbhD2Ccc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Apr 2021 22:32:32 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:52893 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229624AbhD2Ccb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Apr 2021 22:32:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1619663505;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=7NI8qnFXevb88JEF9R2uPeuDpBw7GI5NdpL3yynjyKc=;
        b=esCvNNVGKQmJcNqZ+OObQSl1qFGQKvOHR2aYQK9NhsPA+uCjx6WpL1tvxFcMsmMzQQGYgb
        dQIQWG6Wbw3yIfmLtC31bfosPO8mbx29xVwwi2rHNQu3yVIbT40HPKJhaHrS4poVaNZ6yG
        qQ957jCwQqvbNRmEK3RBusZn7QGML20=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-569-5apZaFv3PbGppGJeBa69Fw-1; Wed, 28 Apr 2021 22:31:39 -0400
X-MC-Unique: 5apZaFv3PbGppGJeBa69Fw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 72E6C64157;
        Thu, 29 Apr 2021 02:31:38 +0000 (UTC)
Received: from wangxiaodeMacBook-Air.local (ovpn-13-162.pek2.redhat.com [10.72.13.162])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 69D7161008;
        Thu, 29 Apr 2021 02:31:34 +0000 (UTC)
Subject: Re: [PATCH] virtio-net: enable SRIOV
To:     Arkadiusz Kudan <arkadiusz.kudan@codilime.com>,
        "Walukiewicz, Miroslaw" <Miroslaw.Walukiewicz@intel.com>
Cc:     "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "mst@redhat.com" <mst@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Jayagopi, Geetha" <geetha.jayagopi@intel.com>
References: <20210426102135.227802-1-arkadiusz.kudan@codilime.com>
 <625a6618-bb59-8ccc-bf1c-e29ac556b590@redhat.com>
 <MWHPR1101MB209476B1939ADB73C57E71AC9E409@MWHPR1101MB2094.namprd11.prod.outlook.com>
 <CAFSqgu1sX+t2hfQpbtDxOanRNd2y58GuR7=omSt0=DviwRGc6g@mail.gmail.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <eeccdebc-42a3-479b-69ee-20ef933e1a67@redhat.com>
Date:   Thu, 29 Apr 2021 10:31:32 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.10.0
MIME-Version: 1.0
In-Reply-To: <CAFSqgu1sX+t2hfQpbtDxOanRNd2y58GuR7=omSt0=DviwRGc6g@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


在 2021/4/28 下午9:57, Arkadiusz Kudan 写道:
> Hi Jason,
>
> Also i would like to add another issue, that is location of 'net' 
> sysfs inside PCI devices sysfs. Libvirt also expects to find folder 
> '/sys/bus/pci/devices/<PF addr>/net' to get corresponding network 
> interface.
> However, for virtio-net managed devices, the 'net' folder is located 
> in virtioX folder, i.e. '/sys/bus/pci/devices/<PF addr>/virtioX/net'.
>
> AFAIK it is due to how sysfs works and usage of virtual bus in virtio 
> driver implementation, or am i wrong?


It works for normal PF driver since the the pci driver register the pci 
parent to networking subsystem which is not the case of virtio. 
Virtio-pci driver register the parent PCI device into virtio bus. And 
virtio-net is a driver for virtio bus which is unaware of pci bus.

Virtio-net can drive devices other than PCI, it could be MMIO/ccw/vdpa bus.


> Is there any way to create somehow some symlink e.g. for this case, so 
> libvirt finds it?


So libvirt should not assume the networking drivers are PCI drivers, the 
driver core support hierarchy which is what libvirt should follow:

E.g, it needs to follow /sys/bus/pci/devices/<PF addr>/virtioX/net

Note that virtio is the first but not the only bus that need to be dealt 
with. Libvirt may suffer from similar issue when you want to manage 
subfunction, vDPA or SIOV devices.


>
> Regarding the ndo_* SRIOV callbacks, a proper implementation would 
> actually need to tell the PF the VF config somehow. How would 
> virtio-net do that?
> Wouldn't that need extending virtio specification? Or is it worked on 
> for virtio 1.2? (AFAIK it isn't released yet)


It's under development[1], it would be a dedicated feature (not 
necessarily 1.2).

If the vendor want to go with vDPA, they are free the implement the 
vendor specific management method via the vDPA netlink protocol[2].

Thanks

[1] 
https://lists.oasis-open.org/archives/virtio-comment/202101/msg00047.html

[2] 
https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git/commit/drivers/vdpa/vdpa.c?id=903f7bcaedb84ca47998e609015a34ddde93742e


>
> Thanks and regards,
> AK
>
>
> On Wed, Apr 28, 2021 at 3:33 PM Walukiewicz, Miroslaw 
> <Miroslaw.Walukiewicz@intel.com 
> <mailto:Miroslaw.Walukiewicz@intel.com>> wrote:
>
>     HI Jason,
>
>     You are right here. We did not catch your change in driver and the
>     SRIOV flag is set correctly as you stated.
>
>     We want to orchestrate the HW implementation of VFs and PFs for
>     virtio-net using libvirt.
>
>     The issue that we want to resolve is that there is no
>     .ndo_get_vf_config Callback implemented in virtio-net driver as
>     other NIC's drivers have, called by libvirt.
>     See
>     https://github.com/torvalds/linux/blob/master/drivers/net/ethernet/intel/igb/igb_main.c#L2996
>     <https://github.com/torvalds/linux/blob/master/drivers/net/ethernet/intel/igb/igb_main.c#L2996>,
>     for example
>     This callback really should create a minimal configuration inside
>     of driver, but we cannot avoid it.
>
>     Another issue is lack of sysfs fro virtual functions
>     /sys/class/net/ens801f0/device/virtfnX (where X is VF number and
>     ens801fo is its PF netdev),
>
>     Could you advise us, how we can solve our issue and drive us to
>     proper solution?
>
>     Regards,
>
>     Mirek
>     -----Original Message-----
>     From: Jason Wang <jasowang@redhat.com <mailto:jasowang@redhat.com>>
>     Sent: wtorek, 27 kwietnia 2021 04:44
>     To: Arkadiusz Kudan <arkadiusz.kudan@codilime.com
>     <mailto:arkadiusz.kudan@codilime.com>>;
>     virtualization@lists.linux-foundation.org
>     <mailto:virtualization@lists.linux-foundation.org>
>     Cc: mst@redhat.com <mailto:mst@redhat.com>; netdev@vger.kernel.org
>     <mailto:netdev@vger.kernel.org>; Walukiewicz, Miroslaw
>     <Miroslaw.Walukiewicz@intel.com
>     <mailto:Miroslaw.Walukiewicz@intel.com>>
>     Subject: Re: [PATCH] virtio-net: enable SRIOV
>
>
>     在 2021/4/26 下午6:21, Arkadiusz Kudan 写道:
>     > With increasing interest for virtio, NIC have appeared that provide
>     > SRIOV with PF appearing in the host as a virtio network device and
>     > probably more similiar NICs will emerge.
>     > igb_uio of DPDK or pci-pf-stub can be used to provide SRIOV,
>     however
>     > there are hypervisors/VMMs that require VFs, which are to be PCI
>     > passthrued to a VM, to have its PF with network representation
>     in the
>     > kernel. For virtio-net based PFs, virtio-net could do that by
>     > providing both SRIOV interface and netdev representation.
>     >
>     > Enable SRIOV via VIRTIO_F_SR_IOV feature bit if the device supports
>     > it.
>     >
>     > Signed-off-by: Arkadiusz Kudan <arkadiusz.kudan@codilime.com
>     <mailto:arkadiusz.kudan@codilime.com>>
>     > Signed-off-by: Miroslaw Walukiewicz
>     <Miroslaw.Walukiewicz@intel.com
>     <mailto:Miroslaw.Walukiewicz@intel.com>>
>     > ---
>     >   drivers/net/virtio_net.c | 1 +
>     >   1 file changed, 1 insertion(+)
>     >
>     > diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
>     index
>     > 0824e6999e49..a03aa7e99689 100644
>     > --- a/drivers/net/virtio_net.c
>     > +++ b/drivers/net/virtio_net.c
>     > @@ -3249,6 +3249,7 @@ static struct virtio_device_id id_table[] = {
>     >
>     >   static unsigned int features[] = {
>     >       VIRTNET_FEATURES,
>     > +     VIRTIO_F_SR_IOV,
>     >   };
>
>
>     So I'm suprised that it needs to be enabled per device. We had:
>
>     static void vp_transport_features(struct virtio_device *vdev, u64
>     features) {
>              struct virtio_pci_device *vp_dev = to_vp_device(vdev);
>              struct pci_dev *pci_dev = vp_dev->pci_dev;
>
>              if ((features & BIT_ULL(VIRTIO_F_SR_IOV)) &&
>                              pci_find_ext_capability(pci_dev,
>     PCI_EXT_CAP_ID_SRIOV))
>                      __virtio_set_bit(vdev, VIRTIO_F_SR_IOV); }
>
>     And I had used this driver for SRIOV virtio-pci hardware for more
>     than one year.
>
>     Thanks
>
>
>     >
>     >   static unsigned int features_legacy[] = {
>
>
>
> -- 
>
> Arkadiusz Kudan
>
> Software Engineer
>
>
> spiritualrage@gmail.com <mailto:spiritualrage@gmail.com>
>
> Logo Codilime 
> <http://www.codilime.com/?utm_source=Stopka&utm_medium=Email&utm_campaign=Stopka> 
>
>
> Logo Facebook <https://www.facebook.com/codilime/> Logo Linkedin 
> <https://www.linkedin.com/company/codilime> Logo Twitter 
> <https://twitter.com/codilime>
>
> CodiLime Sp. z o.o. - Ltd. company with its registered office 
> in Poland, 02-493 Warsaw, ul. Krancowa 5.
> Registered by The District Court for the Capital City of Warsaw, 
> XII Commercial Department of the National Court Register.
> Entered into National Court Register under No. KRS 0000388871. 
> Tax identification number (NIP) 5272657478. Statistical number (REGON) 
> 142974628.
>
>
> -------------------------------
> This document contains material that is confidential in CodiLime Sp. z 
> o.o. DO NOT PRINT. DO NOT COPY. DO NOT DISTRIBUTE. If you are not the 
> intended recipient of this document, be aware that any use, review, 
> retransmission, distribution, reproduction or any action taken in 
> reliance upon this message is strictly prohibited. If you received 
> this in error, please contact the sender and help@codilime.com 
> <mailto:help@codilime.com>. Return the paper copy, delete the material 
> from all computers and storage media.

