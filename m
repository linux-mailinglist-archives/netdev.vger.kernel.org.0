Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 705E736BD71
	for <lists+netdev@lfdr.de>; Tue, 27 Apr 2021 04:44:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232295AbhD0CpB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Apr 2021 22:45:01 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:21543 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231685AbhD0Co6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Apr 2021 22:44:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1619491455;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=9t6HPD50NoeAQXyHmZQufw+PUx5Y2vTcwzjnMztmhfk=;
        b=h16nnAEmPMKIGY/vSyF14ZepZ/rHBzvuihVMFHLPUzKm+Poc87/hSPVi0SQept6v3J3pui
        wkZezpJqpWZzSxaAnu4XfzvFGNZizAHjDz21kdQLVspaasVHM1mHMRXvkVstGRelF1ukGs
        i5wOHLctLaDVBl4rjLlXpkRcbI1H3y4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-490-2UCijym4OnKKmfQixEZelQ-1; Mon, 26 Apr 2021 22:44:11 -0400
X-MC-Unique: 2UCijym4OnKKmfQixEZelQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 112AE1006C83;
        Tue, 27 Apr 2021 02:44:10 +0000 (UTC)
Received: from wangxiaodeMacBook-Air.local (ovpn-13-221.pek2.redhat.com [10.72.13.221])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E412B19D7D;
        Tue, 27 Apr 2021 02:44:01 +0000 (UTC)
Subject: Re: [PATCH] virtio-net: enable SRIOV
To:     Arkadiusz Kudan <arkadiusz.kudan@codilime.com>,
        virtualization@lists.linux-foundation.org
Cc:     mst@redhat.com, netdev@vger.kernel.org,
        Miroslaw Walukiewicz <Miroslaw.Walukiewicz@intel.com>
References: <20210426102135.227802-1-arkadiusz.kudan@codilime.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <625a6618-bb59-8ccc-bf1c-e29ac556b590@redhat.com>
Date:   Tue, 27 Apr 2021 10:43:59 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.10.0
MIME-Version: 1.0
In-Reply-To: <20210426102135.227802-1-arkadiusz.kudan@codilime.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


在 2021/4/26 下午6:21, Arkadiusz Kudan 写道:
> With increasing interest for virtio, NIC have appeared that provide
> SRIOV with PF appearing in the host as a virtio network device
> and probably more similiar NICs will emerge.
> igb_uio of DPDK or pci-pf-stub can be used to provide SRIOV,
> however there are hypervisors/VMMs that require VFs, which are
> to be PCI passthrued to a VM, to have its PF with network
> representation in the kernel. For virtio-net based PFs,
> virtio-net could do that by providing both SRIOV interface and
> netdev representation.
>
> Enable SRIOV via VIRTIO_F_SR_IOV feature bit if the device
> supports it.
>
> Signed-off-by: Arkadiusz Kudan <arkadiusz.kudan@codilime.com>
> Signed-off-by: Miroslaw Walukiewicz <Miroslaw.Walukiewicz@intel.com>
> ---
>   drivers/net/virtio_net.c | 1 +
>   1 file changed, 1 insertion(+)
>
> diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> index 0824e6999e49..a03aa7e99689 100644
> --- a/drivers/net/virtio_net.c
> +++ b/drivers/net/virtio_net.c
> @@ -3249,6 +3249,7 @@ static struct virtio_device_id id_table[] = {
>   
>   static unsigned int features[] = {
>   	VIRTNET_FEATURES,
> +	VIRTIO_F_SR_IOV,
>   };


So I'm suprised that it needs to be enabled per device. We had:

static void vp_transport_features(struct virtio_device *vdev, u64 features)
{
         struct virtio_pci_device *vp_dev = to_vp_device(vdev);
         struct pci_dev *pci_dev = vp_dev->pci_dev;

         if ((features & BIT_ULL(VIRTIO_F_SR_IOV)) &&
                         pci_find_ext_capability(pci_dev, 
PCI_EXT_CAP_ID_SRIOV))
                 __virtio_set_bit(vdev, VIRTIO_F_SR_IOV);
}

And I had used this driver for SRIOV virtio-pci hardware for more than 
one year.

Thanks


>   
>   static unsigned int features_legacy[] = {

