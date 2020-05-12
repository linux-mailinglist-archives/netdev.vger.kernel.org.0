Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ABB501CEC8B
	for <lists+netdev@lfdr.de>; Tue, 12 May 2020 07:51:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726287AbgELFvj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 May 2020 01:51:39 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:24835 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725536AbgELFvi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 May 2020 01:51:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1589262696;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=x/cVjxQ0JMstZElAHAVEHp9fs0uKy63dNO0knF8a+TY=;
        b=c0e0gszTmEAGy9E/JO03kcAqQNvZ6w+JfvAfp7ganW9HFo304AMijRcVLjT5zec41M61kf
        W2rLV4otmtCCzUCP5abhWe7BFfC33jYydUVU+gzqbpGilcQ5+NE0LPdpBRHXRo4XNFKLo4
        ZFX/vuPTWKqs358vDhCQBER8Ak6IrwU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-34-zRaLtNK4OEuDBvfkmqU5wg-1; Tue, 12 May 2020 01:51:34 -0400
X-MC-Unique: zRaLtNK4OEuDBvfkmqU5wg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 62D808005B7;
        Tue, 12 May 2020 05:51:33 +0000 (UTC)
Received: from [10.72.13.96] (ovpn-13-96.pek2.redhat.com [10.72.13.96])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2838738F;
        Tue, 12 May 2020 05:51:26 +0000 (UTC)
Subject: Re: [PATCH] ifcvf: move IRQ request/free to status change handlers
From:   Jason Wang <jasowang@redhat.com>
To:     "Zhu, Lingshan" <lingshan.zhu@intel.com>, mst@redhat.com,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Cc:     lulu@redhat.com, dan.daly@intel.com, cunming.liang@intel.com
References: <1589181563-38400-1-git-send-email-lingshan.zhu@intel.com>
 <22d9dcdb-e790-0a68-ba41-b9530b2bf9fd@redhat.com>
 <0f822630-14ad-e0cd-4171-6213c30f0799@intel.com>
 <24d5875e-6f44-ce43-74f0-e641e02f8f42@redhat.com>
Message-ID: <47713210-e9d9-d185-6e2e-433e2c436de9@redhat.com>
Date:   Tue, 12 May 2020 13:51:25 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <24d5875e-6f44-ce43-74f0-e641e02f8f42@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2020/5/12 上午11:38, Jason Wang wrote:
>>>>
>>>>   static int ifcvf_start_datapath(void *private)
>>>>   {
>>>>       struct ifcvf_hw *vf = ifcvf_private_to_vf(private);
>>>> @@ -118,9 +172,12 @@ static void ifcvf_vdpa_set_status(struct 
>>>> vdpa_device *vdpa_dev, u8 status)
>>>>   {
>>>>       struct ifcvf_adapter *adapter;
>>>>       struct ifcvf_hw *vf;
>>>> +    u8 status_old;
>>>> +    int ret;
>>>>         vf  = vdpa_to_vf(vdpa_dev);
>>>>       adapter = dev_get_drvdata(vdpa_dev->dev.parent);
>>>> +    status_old = ifcvf_get_status(vf);
>>>>         if (status == 0) {
>>>>           ifcvf_stop_datapath(adapter);
>>>> @@ -128,7 +185,22 @@ static void ifcvf_vdpa_set_status(struct 
>>>> vdpa_device *vdpa_dev, u8 status)
>>>>           return;
>>>>       }
>>>>   -    if (status & VIRTIO_CONFIG_S_DRIVER_OK) {
>>>> +    if ((status_old & VIRTIO_CONFIG_S_DRIVER_OK) &&
>>>> +        !(status & VIRTIO_CONFIG_S_DRIVER_OK)) {
>>>> +        ifcvf_stop_datapath(adapter);
>>>> +        ifcvf_free_irq(adapter, IFCVF_MAX_QUEUE_PAIRS * 2);
>>>> +    }
>>>> +
>>>> +    if ((status & VIRTIO_CONFIG_S_DRIVER_OK) &&
>>>> +        !(status_old & VIRTIO_CONFIG_S_DRIVER_OK)) {
>>>> +        ret = ifcvf_request_irq(adapter);
>>>> +        if (ret) {
>>>> +            status = ifcvf_get_status(vf);
>>>> +            status |= VIRTIO_CONFIG_S_FAILED;
>>>> +            ifcvf_set_status(vf, status);
>>>> +            return;
>>>> +        }
>>>> +
>>>
>>>
>>> Have a hard though on the logic here.
>>>
>>> This depends on the status setting from guest or userspace. Which 
>>> means it can not deal with e.g when qemu or userspace is crashed? Do 
>>> we need to care this or it's a over engineering?
>>>
>>> Thanks
>> If qemu crash, I guess users may re-run qmeu / re-initialize the 
>> device, according to the spec, there should be a reset routine.
>> This code piece handles status change on DRIVER_OK flipping. I am not 
>> sure I get your point, mind to give more hints?
>
>
> The problem is if we don't launch new qemu instance, the interrupt 
> will be still there?


Ok, we reset on vhost_vdpa_release() so the following is suspicious:

With the patch, we do:

static void ifcvf_vdpa_set_status(struct vdpa_device *vdpa_dev, u8 status)
{
         struct ifcvf_adapter *adapter;
         struct ifcvf_hw *vf;
         u8 status_old;
         int ret;

         vf  = vdpa_to_vf(vdpa_dev);
         adapter = dev_get_drvdata(vdpa_dev->dev.parent);
         status_old = ifcvf_get_status(vf);

         if (status == 0) {
                 ifcvf_stop_datapath(adapter);
                 ifcvf_reset_vring(adapter);
                 return;
         }

         if ((status_old & VIRTIO_CONFIG_S_DRIVER_OK) &&
             !(status & VIRTIO_CONFIG_S_DRIVER_OK)) {
                 ifcvf_stop_datapath(adapter);
                 ifcvf_free_irq(adapter, IFCVF_MAX_QUEUE_PAIRS * 2);
         }

...

So the handling of status == 0 looks wrong.

The OK -> !OK check should already cover the datapath stopping and irq 
stuffs.

We only need to deal with vring reset and only need to do it after we 
stop the datapath/irq stuffs.

Thanks



>
> Thanks 

