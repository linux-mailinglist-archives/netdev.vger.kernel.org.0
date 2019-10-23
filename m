Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D1770E1818
	for <lists+netdev@lfdr.de>; Wed, 23 Oct 2019 12:36:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404516AbfJWKgn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Oct 2019 06:36:43 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:39469 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2391076AbfJWKgn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Oct 2019 06:36:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1571827001;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=c+ZJZ8Qp2Al2NCTrYo8r6xsLIqLGBhiVQkAHuY0n6VM=;
        b=Nm9AVlgbEcmIT3jgILXfOG6VZ4eryS4KBt6w8wvz265wEm/RnA/DmCm+c11jD5MKro/2Wx
        VVPTz/USMEx1gJBwZUF8oixHJK9/BYDhA8R0YlWZ8z3lEkuPdoQjyzZTICaNf8S8F2eKnf
        FDoeOlXFej+920PH7M2hC4UYmxnio5c=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-330-ijQT5u_SMP-UphaCbNmtAA-1; Wed, 23 Oct 2019 06:36:37 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 63DF21800D6B;
        Wed, 23 Oct 2019 10:36:35 +0000 (UTC)
Received: from [10.72.12.79] (ovpn-12-79.pek2.redhat.com [10.72.12.79])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3ECF05D6C8;
        Wed, 23 Oct 2019 10:36:24 +0000 (UTC)
Subject: Re: [RFC 1/2] vhost: IFC VF hardware operation layer
To:     Simon Horman <simon.horman@netronome.com>
Cc:     "Zhu, Lingshan" <lingshan.zhu@intel.com>, mst@redhat.com,
        alex.williamson@redhat.com, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        netdev@vger.kernel.org, dan.daly@intel.com,
        cunming.liang@intel.com, tiwei.bie@intel.com, jason.zeng@intel.com,
        zhiyuan.lv@intel.com
References: <20191016011041.3441-1-lingshan.zhu@intel.com>
 <20191016011041.3441-2-lingshan.zhu@intel.com>
 <20191016095347.5sb43knc7eq44ivo@netronome.com>
 <075be045-3a02-e7d8-672f-4a207c410ee8@intel.com>
 <20191021163139.GC4486@netronome.com>
 <15d94e61-9b3d-7854-b65e-6fea6db75450@redhat.com>
 <20191023101329.GE8732@netronome.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <83356b5f-e2f4-ab79-79d7-20d4850c26a9@redhat.com>
Date:   Wed, 23 Oct 2019 18:36:13 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20191023101329.GE8732@netronome.com>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-MC-Unique: ijQT5u_SMP-UphaCbNmtAA-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2019/10/23 =E4=B8=8B=E5=8D=886:13, Simon Horman wrote:
> On Tue, Oct 22, 2019 at 09:32:36AM +0800, Jason Wang wrote:
>> On 2019/10/22 =E4=B8=8A=E5=8D=8812:31, Simon Horman wrote:
>>> On Mon, Oct 21, 2019 at 05:55:33PM +0800, Zhu, Lingshan wrote:
>>>> On 10/16/2019 5:53 PM, Simon Horman wrote:
>>>>> Hi Zhu,
>>>>>
>>>>> thanks for your patch.
>>>>>
>>>>> On Wed, Oct 16, 2019 at 09:10:40AM +0800, Zhu Lingshan wrote:
>>> ...
>>>
>>>>>> +static void ifcvf_read_dev_config(struct ifcvf_hw *hw, u64 offset,
>>>>>> +=09=09       void *dst, int length)
>>>>>> +{
>>>>>> +=09int i;
>>>>>> +=09u8 *p;
>>>>>> +=09u8 old_gen, new_gen;
>>>>>> +
>>>>>> +=09do {
>>>>>> +=09=09old_gen =3D ioread8(&hw->common_cfg->config_generation);
>>>>>> +
>>>>>> +=09=09p =3D dst;
>>>>>> +=09=09for (i =3D 0; i < length; i++)
>>>>>> +=09=09=09*p++ =3D ioread8((u8 *)hw->dev_cfg + offset + i);
>>>>>> +
>>>>>> +=09=09new_gen =3D ioread8(&hw->common_cfg->config_generation);
>>>>>> +=09} while (old_gen !=3D new_gen);
>>>>> Would it be wise to limit the number of iterations of the loop above?
>>>> Thanks but I don't quite get it. This is used to make sure the functio=
n
>>>> would get the latest config.
>>> I am worried about the possibility that it will loop forever.
>>> Could that happen?
>>>
>>> ...
>> My understanding is that the function here is similar to virtio config
>> generation [1]. So this can only happen for a buggy hardware.
> Ok, so this circles back to my original question.
> Should we put a bound on the number of times the loop runs
> or should we accept that the kernel locks up if the HW is buggy?
>

I'm not sure, and similar logic has been used by virtio-pci drivers for=20
years. Consider this logic is pretty simple and it should not be the=20
only place that virito hardware can lock kernel, we can keep it as is.

Actually, there's no need for hardware to implement generation logic, it=20
could be emulated by software or even ignored. In new version of=20
virtio-mdev, get_generation() is optional, when it was not implemented,=20
0 is simply returned by virtio-mdev transport.

Thanks

