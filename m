Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 99435EA8ED
	for <lists+netdev@lfdr.de>; Thu, 31 Oct 2019 02:46:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726554AbfJaBoY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Oct 2019 21:44:24 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:30592 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725926AbfJaBoY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Oct 2019 21:44:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1572486262;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=4tc+kGwmBYkHh3r+P2hKVHCMVc/QGj3NROan5F4N/4I=;
        b=OrEB0O0cTPVrKKFY3kRbDS1m+afKuwRyVp2KxiK1anbj0UZt9WKQl6ohyHTnWPMqa+PkAg
        ZPBG3yTp6IBI5YI6CCzY97snHMznV5F2eFsEzg/KqkMT818roJXmLOUpPnJJNa+J6XgtU/
        yC9J18HdWCbzqku8b4w5xlZvtRRE++Q=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-374-EZPixSApMXCjMTJG_WhWEw-1; Wed, 30 Oct 2019 21:44:19 -0400
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0A8A11005500;
        Thu, 31 Oct 2019 01:44:18 +0000 (UTC)
Received: from [10.72.12.100] (ovpn-12-100.pek2.redhat.com [10.72.12.100])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7771160132;
        Thu, 31 Oct 2019 01:44:12 +0000 (UTC)
Subject: Re: [RFC] vhost_mdev: add network control vq support
To:     Tiwei Bie <tiwei.bie@intel.com>
Cc:     mst@redhat.com, linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        dan.daly@intel.com, cunming.liang@intel.com,
        zhihong.wang@intel.com, lingshan.zhu@intel.com
References: <20191029101726.12699-1-tiwei.bie@intel.com>
 <59474431-9e77-567c-9a46-a3965f587f65@redhat.com>
 <20191030061711.GA11968@___>
 <39aa9f66-8e58-ea63-5795-7df8861ff3a0@redhat.com>
 <20191030115433.GA27220@___>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <b1ab03ec-edb0-f955-2719-beb0653feed1@redhat.com>
Date:   Thu, 31 Oct 2019 09:44:11 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20191030115433.GA27220@___>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-MC-Unique: EZPixSApMXCjMTJG_WhWEw-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2019/10/30 =E4=B8=8B=E5=8D=887:54, Tiwei Bie wrote:
> On Wed, Oct 30, 2019 at 03:04:37PM +0800, Jason Wang wrote:
>> On 2019/10/30 =E4=B8=8B=E5=8D=882:17, Tiwei Bie wrote:
>>> On Tue, Oct 29, 2019 at 06:51:32PM +0800, Jason Wang wrote:
>>>> On 2019/10/29 =E4=B8=8B=E5=8D=886:17, Tiwei Bie wrote:
>>>>> This patch adds the network control vq support in vhost-mdev.
>>>>> A vhost-mdev specific op is introduced to allow parent drivers
>>>>> to handle the network control commands come from userspace.
>>>> Probably work for userspace driver but not kernel driver.
>>> Exactly. This is only for userspace.
>>>
>>> I got your point now. In virtio-mdev kernel driver case,
>>> the ctrl-vq can be special as well.
>>>
>> Then maybe it's better to introduce vhost-mdev-net on top?
>>
>> Looking at the other type of virtio device:
>>
>> - console have two control virtqueues when multiqueue port is enabled
>>
>> - SCSI has controlq + eventq
>>
>> - GPU has controlq
>>
>> - Crypto device has one controlq
>>
>> - Socket has eventq
>>
>> ...
> Thanks for the list! It looks dirty to define specific
> commands and types in vhost UAPI for each of them in the
> future. It's definitely much better to find an approach
> to solve it once for all if possible..
>
> Just a quick thought, considering all vhost-mdev does
> is just to forward settings between parent and userspace,
> I'm wondering whether it's possible to make the argp
> opaque in vhost-mdev UAPI and just introduce one generic
> ioctl command to deliver these device specific commands
> (which are opaque in vhost-mdev as vhost-mdev just pass
> the pointer -- argp) defined by spec.


It looks that using opaque pointer is probably not good for UAPI. And we=20
need also invent API for eventq.


>
> I'm also fine with exposing ctrlq to userspace directly.
> PS. It's interesting that some devices have more than
> one ctrlq. I need to take a close look first..


Thanks.


>
>
>> Thanks
>>

