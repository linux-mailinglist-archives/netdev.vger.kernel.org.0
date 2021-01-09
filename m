Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 407982EFD3B
	for <lists+netdev@lfdr.de>; Sat,  9 Jan 2021 03:57:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726522AbhAIC4Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Jan 2021 21:56:24 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:24792 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726432AbhAIC4Y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Jan 2021 21:56:24 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1610160897;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=CPOhMKQ/He5lGnpNvXkvui5YIqdQrwnH9IuZfD2JHsc=;
        b=Krl5I7anRBDlOYKcRf2ppSlPz/OG1BuV+4ageoYYr0PuRG7rAsPjH2f04Xm37NP08fwrC6
        wW9UA0P78d2YYooohC91IMnp4dCZF1UPzUa9AcUgUHwCbISPZ980WGTF6ujiwjX9midldD
        O71hMUPvqeLTTj4MY5VXLDa1XTrs8Tc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-98-GaToKbmmOQSIFyFs2rRjkw-1; Fri, 08 Jan 2021 21:54:53 -0500
X-MC-Unique: GaToKbmmOQSIFyFs2rRjkw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1F1A6180A08A;
        Sat,  9 Jan 2021 02:54:52 +0000 (UTC)
Received: from [10.3.112.139] (ovpn-112-139.phx2.redhat.com [10.3.112.139])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 187B160BF3;
        Sat,  9 Jan 2021 02:54:48 +0000 (UTC)
Subject: Re: [PATCH mlx5-next 1/4] PCI: Configure number of MSI-X vectors for
 SR-IOV VFs
To:     Bjorn Helgaas <helgaas@kernel.org>
Cc:     Leon Romanovsky <leon@kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Jakub Kicinski <kuba@kernel.org>, linux-pci@vger.kernel.org,
        linux-rdma@vger.kernel.org, netdev@vger.kernel.org,
        Alex Williamson <alex.williamson@redhat.com>
References: <20210108210913.GA1471923@bjorn-Precision-5520>
From:   Don Dutile <ddutile@redhat.com>
Message-ID: <96209762-64a8-c710-1b1e-c0cc5207df03@redhat.com>
Date:   Fri, 8 Jan 2021 21:54:47 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20210108210913.GA1471923@bjorn-Precision-5520>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/8/21 4:09 PM, Bjorn Helgaas wrote:
> On Thu, Jan 07, 2021 at 10:54:38PM -0500, Don Dutile wrote:
>> On 1/7/21 7:57 PM, Bjorn Helgaas wrote:
>>> On Sun, Jan 03, 2021 at 10:24:37AM +0200, Leon Romanovsky wrote:
>>>> + **/
>>>> +int pci_set_msix_vec_count(struct pci_dev *dev, int numb)
>>>> +{
>>>> +	struct pci_dev *pdev = pci_physfn(dev);
>>>> +
>>>> +	if (!dev->msix_cap || !pdev->msix_cap)
>>>> +		return -EINVAL;
>>>> +
>>>> +	if (dev->driver || !pdev->driver ||
>>>> +	    !pdev->driver->sriov_set_msix_vec_count)
>>>> +		return -EOPNOTSUPP;
>>>> +
>>>> +	if (numb < 0)
>>>> +		/*
>>>> +		 * We don't support negative numbers for now,
>>>> +		 * but maybe in the future it will make sense.
>>>> +		 */
>>>> +		return -EINVAL;
>>>> +
>>>> +	return pdev->driver->sriov_set_msix_vec_count(dev, numb);
>>> So we write to a VF sysfs file, get here and look up the PF, call a PF
>>> driver callback with the VF as an argument, the callback (at least for
>>> mlx5) looks up the PF from the VF, then does some mlx5-specific magic
>>> to the PF that influences the VF somehow?
>> There's no PF lookup above.... it's just checking if a pdev has a
>> driver with the desired msix-cap setting(reduction) feature.
> We started with the VF (the sysfs file is attached to the VF).  "pdev"
> is the corresponding PF; that's what I meant by "looking up the PF".
> Then we call the PF driver sriov_set_msix_vec_count() method.
ah, got how your statement relates to the files &/or pdev.

> I asked because this raises questions of whether we need mutual
> exclusion or some other coordination between setting this for multiple
> VFs.
>
> Obviously it's great to answer all these in email, but at the end of
> the day, the rationale needs to be in the commit, either in code
> comments or the commit log.
>
I'm still not getting why this is not per-(vf)pdev -- just b/c a device has N-number of MSIX capability doesn't mean it has to all be used/configured,
Setting max-MSIX for VFs in the PF's pdev means it is the same number for all VFs ... and I'm not sure that's the right solution either.
It should still be (v)pdev-based, IMO.
--dd

