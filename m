Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 078753245DE
	for <lists+netdev@lfdr.de>; Wed, 24 Feb 2021 22:39:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235969AbhBXVj2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Feb 2021 16:39:28 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:43975 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235962AbhBXVjS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Feb 2021 16:39:18 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1614202672;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=r0VVhQgbHXdIHWVEalPSwejZCgGaETPw/01RIXLdloc=;
        b=VrrQEkaHsPUArR/ieyUsr0jJfFpyGlGdaA9aCQNL6A7j7QtI756rf6usmh64P8VRVO7wVj
        9Gg6OdJjAG8QhRw4VMtG8Kp8ar+j5ysC8WwzJb9OogpP2X0L6vNsmVJFEbxWyNmlbjdVEu
        QRlWFY3CKuzuEKalwiBlyJ7qVrzT+Tk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-363-kyVKejzEPj2INF83MbZV4A-1; Wed, 24 Feb 2021 16:37:47 -0500
X-MC-Unique: kyVKejzEPj2INF83MbZV4A-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 56519AFA80;
        Wed, 24 Feb 2021 21:37:45 +0000 (UTC)
Received: from [10.3.112.31] (ovpn-112-31.phx2.redhat.com [10.3.112.31])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0C9D55D9D3;
        Wed, 24 Feb 2021 21:37:40 +0000 (UTC)
Subject: Re: [PATCH mlx5-next v6 1/4] PCI: Add sysfs callback to allow MSI-X
 table size change of SR-IOV VFs
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Bjorn Helgaas <helgaas@kernel.org>
Cc:     Leon Romanovsky <leon@kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>, linux-pci@vger.kernel.org,
        linux-rdma@vger.kernel.org, netdev@vger.kernel.org,
        Alex Williamson <alex.williamson@redhat.com>,
        "David S . Miller" <davem@davemloft.net>,
        =?UTF-8?Q?Krzysztof_Wilczy=c5=84s?= =?UTF-8?Q?ki?= <kw@linux.com>
References: <YDIExpismOnU3c4k@unreal>
 <20210223210743.GA1475710@bjorn-Precision-5520> <YDYJpTaxXL4ESwZS@kroah.com>
From:   Don Dutile <ddutile@redhat.com>
Message-ID: <f88031ee-699f-458f-c8f5-952f2a24e723@redhat.com>
Date:   Wed, 24 Feb 2021 16:37:40 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <YDYJpTaxXL4ESwZS@kroah.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/24/21 3:09 AM, Greg Kroah-Hartman wrote:
> On Tue, Feb 23, 2021 at 03:07:43PM -0600, Bjorn Helgaas wrote:
>> On Sun, Feb 21, 2021 at 08:59:18AM +0200, Leon Romanovsky wrote:
>>> On Sat, Feb 20, 2021 at 01:06:00PM -0600, Bjorn Helgaas wrote:
>>>> On Fri, Feb 19, 2021 at 09:20:18AM +0100, Greg Kroah-Hartman wrote:
>>>>
>>>>> Ok, can you step back and try to explain what problem you are trying to
>>>>> solve first, before getting bogged down in odd details?  I find it
>>>>> highly unlikely that this is something "unique", but I could be wrong as
>>>>> I do not understand what you are wanting to do here at all.
>>>> We want to add two new sysfs files:
>>>>
>>>>    sriov_vf_total_msix, for PF devices
>>>>    sriov_vf_msix_count, for VF devices associated with the PF
>>>>
>>>> AFAICT it is *acceptable* if they are both present always.  But it
>>>> would be *ideal* if they were only present when a driver that
>>>> implements the ->sriov_get_vf_total_msix() callback is bound to the
>>>> PF.
>>> BTW, we already have all possible combinations: static, static with
>>> folder, with and without "sriov_" prefix, dynamic with and without
>>> folders on VFs.
>>>
>>> I need to know on which version I'll get Acked-by and that version I
>>> will resubmit.
>> I propose that you make static attributes for both files, so
>> "sriov_vf_total_msix" is visible for *every* PF in the system and
>> "sriov_vf_msix_count" is visible for *every* VF in the system.
>>
>> The PF "sriov_vf_total_msix" show function can return zero if there's
>> no PF driver or it doesn't support ->sriov_get_vf_total_msix().
>> (Incidentally, I think the documentation should mention that when it
>> *is* supported, the contents of this file are *constant*, i.e., it
>> does not decrease as vectors are assigned to VFs.)
>>
>> The "sriov_vf_msix_count" set function can ignore writes if there's no
>> PF driver or it doesn't support ->sriov_get_vf_total_msix(), or if a
>> VF driver is bound.
>>
>> Any userspace software must be able to deal with those scenarios
>> anyway, so I don't think the mere presence or absence of the files is
>> a meaningful signal to that software.
> Hopefully, good luck with that!
Management sw is use to dealing with optional sysfs files.
libvirt does that now with the VF files for a PF -- all PF's don't have VFs.
The VF files are only created if a VF ext-cfg-hdr exists.

So, as Bjorn said, mgmt sw related to optionally tuning PCIe devices are designed to check for file existence.

>> If we figure out a way to make the files visible only when the
>> appropriate driver is bound, that might be nice and could always be
>> done later.  But I don't think it's essential.
> That seems reasonable, feel free to cc: me on the next patch series and
> I'll try to review it, which should make more sense to me than this
> email thread :)
>
> thanks,
>
> greg k-h
>

