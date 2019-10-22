Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AC40BDFA29
	for <lists+netdev@lfdr.de>; Tue, 22 Oct 2019 03:35:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730711AbfJVBcz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Oct 2019 21:32:55 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:29075 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1730699AbfJVBcy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Oct 2019 21:32:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1571707973;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=o0Lp/gVS/UVZJ6HpPOA1ELyW3Kw/drS4YFNnrvpMCr8=;
        b=DHMNIRp6vkHA+41uF4BENOl/UOXKohHEZ+5k4CBMaVwi56iBZLkz9KrmNPIOoASrVw3rfS
        WE5SYbdJgCKq+z5LJ+vzT8VApE7guNArTrjnH9Te18GiRk4P8/HjTf560wrFi9HyHnaAYW
        IGasUM8MjB6x5OiEdONTuTlYTM5zmhM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-384-k9QbnoCZP_WXlFbJr2Vfxw-1; Mon, 21 Oct 2019 21:32:50 -0400
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id CF9221800DC7;
        Tue, 22 Oct 2019 01:32:48 +0000 (UTC)
Received: from [10.72.12.133] (ovpn-12-133.pek2.redhat.com [10.72.12.133])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 936AD10027A1;
        Tue, 22 Oct 2019 01:32:39 +0000 (UTC)
Subject: Re: [RFC 1/2] vhost: IFC VF hardware operation layer
To:     Simon Horman <simon.horman@netronome.com>,
        "Zhu, Lingshan" <lingshan.zhu@intel.com>
Cc:     mst@redhat.com, alex.williamson@redhat.com,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        netdev@vger.kernel.org, dan.daly@intel.com,
        cunming.liang@intel.com, tiwei.bie@intel.com, jason.zeng@intel.com,
        zhiyuan.lv@intel.com
References: <20191016011041.3441-1-lingshan.zhu@intel.com>
 <20191016011041.3441-2-lingshan.zhu@intel.com>
 <20191016095347.5sb43knc7eq44ivo@netronome.com>
 <075be045-3a02-e7d8-672f-4a207c410ee8@intel.com>
 <20191021163139.GC4486@netronome.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <15d94e61-9b3d-7854-b65e-6fea6db75450@redhat.com>
Date:   Tue, 22 Oct 2019 09:32:36 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20191021163139.GC4486@netronome.com>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-MC-Unique: k9QbnoCZP_WXlFbJr2Vfxw-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2019/10/22 =E4=B8=8A=E5=8D=8812:31, Simon Horman wrote:
> On Mon, Oct 21, 2019 at 05:55:33PM +0800, Zhu, Lingshan wrote:
>> On 10/16/2019 5:53 PM, Simon Horman wrote:
>>> Hi Zhu,
>>>
>>> thanks for your patch.
>>>
>>> On Wed, Oct 16, 2019 at 09:10:40AM +0800, Zhu Lingshan wrote:
> ...
>
>>>> +static void ifcvf_read_dev_config(struct ifcvf_hw *hw, u64 offset,
>>>> +=09=09       void *dst, int length)
>>>> +{
>>>> +=09int i;
>>>> +=09u8 *p;
>>>> +=09u8 old_gen, new_gen;
>>>> +
>>>> +=09do {
>>>> +=09=09old_gen =3D ioread8(&hw->common_cfg->config_generation);
>>>> +
>>>> +=09=09p =3D dst;
>>>> +=09=09for (i =3D 0; i < length; i++)
>>>> +=09=09=09*p++ =3D ioread8((u8 *)hw->dev_cfg + offset + i);
>>>> +
>>>> +=09=09new_gen =3D ioread8(&hw->common_cfg->config_generation);
>>>> +=09} while (old_gen !=3D new_gen);
>>> Would it be wise to limit the number of iterations of the loop above?
>> Thanks but I don't quite get it. This is used to make sure the function
>> would get the latest config.
> I am worried about the possibility that it will loop forever.
> Could that happen?
>
> ...


My understanding is that the function here is similar to virtio config=20
generation [1]. So this can only happen for a buggy hardware.

Thanks

[1]=20
https://docs.oasis-open.org/virtio/virtio/v1.1/csprd01/virtio-v1.1-csprd01.=
html=20
Section 2.4.1


>
>>>> +static void io_write64_twopart(u64 val, u32 *lo, u32 *hi)
>>>> +{
>>>> +=09iowrite32(val & ((1ULL << 32) - 1), lo);
>>>> +=09iowrite32(val >> 32, hi);
>>>> +}
>>> I see this macro is also in virtio_pci_modern.c
>>>
>>> Assuming lo and hi aren't guaranteed to be sequential
>>> and thus iowrite64_hi_lo() cannot be used perhaps
>>> it would be good to add a common helper somewhere.
>> Thanks, I will try after this IFC patchwork, I will cc you.
> Thanks.
>
> ...

