Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A5DCE3D3D76
	for <lists+netdev@lfdr.de>; Fri, 23 Jul 2021 18:21:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230386AbhGWPkp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Jul 2021 11:40:45 -0400
Received: from ale.deltatee.com ([204.191.154.188]:48466 "EHLO
        ale.deltatee.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229713AbhGWPkk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Jul 2021 11:40:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=deltatee.com; s=20200525; h=Subject:In-Reply-To:MIME-Version:Date:
        Message-ID:From:References:Cc:To:content-disposition;
        bh=OgprVPk5lMS0Mw79sOWz8oZveiMEU6wSS+0J13cswS4=; b=aD3oBSzlPoe4EnYJLveM3vV7Gt
        cm1RYGT7I7RBjg/JpL2OB/CzxrokLccG2No1YchjELXaK/8gCZNM7Hdo9gjbAbmBvZyb9Ox14EnN1
        6ZLW+JBkYtEsKDzXzLAUDMGtK/hf5R8zIIQjuha9kL3sGZ6WQdvoCmqaHorfrP25yUkry8hdl1dxG
        qAfx6VBSYml+DuZ72ObRVUKxspjej5eqsTbX8IQ7Z3uHA7xzoU+xFf7EbTs/tz8fHPGD7dKnaJ6kU
        NkbGTo0smbttqdy4bGzK4vJ3HCJSytDmYlZyRwPOoZEIeZTPcHPk2T+YliSSvNYL6lyhH/KibdOlX
        vu40kgOw==;
Received: from s0106a84e3fe8c3f3.cg.shawcable.net ([24.64.144.200] helo=[192.168.0.10])
        by ale.deltatee.com with esmtpsa (TLS1.3:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.92)
        (envelope-from <logang@deltatee.com>)
        id 1m6xuz-00047N-He; Fri, 23 Jul 2021 10:20:58 -0600
To:     Leon Romanovsky <leon@kernel.org>,
        Dongdong Liu <liudongdong3@huawei.com>
Cc:     helgaas@kernel.org, hch@infradead.org, kw@linux.com,
        linux-pci@vger.kernel.org, rajur@chelsio.com,
        hverkuil-cisco@xs4all.nl, linux-media@vger.kernel.org,
        netdev@vger.kernel.org
References: <1627038402-114183-1-git-send-email-liudongdong3@huawei.com>
 <1627038402-114183-8-git-send-email-liudongdong3@huawei.com>
 <YPqo6M0AKWLupvNU@unreal>
From:   Logan Gunthorpe <logang@deltatee.com>
Message-ID: <a8a8ffee-67e8-c899-3d04-1e28fb72560a@deltatee.com>
Date:   Fri, 23 Jul 2021 10:20:50 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <YPqo6M0AKWLupvNU@unreal>
Content-Type: text/plain; charset=utf-8
Content-Language: en-CA
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 24.64.144.200
X-SA-Exim-Rcpt-To: netdev@vger.kernel.org, linux-media@vger.kernel.org, hverkuil-cisco@xs4all.nl, rajur@chelsio.com, linux-pci@vger.kernel.org, kw@linux.com, hch@infradead.org, helgaas@kernel.org, liudongdong3@huawei.com, leon@kernel.org
X-SA-Exim-Mail-From: logang@deltatee.com
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on ale.deltatee.com
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=5.0 tests=ALL_TRUSTED,BAYES_00,
        NICE_REPLY_A autolearn=ham autolearn_force=no version=3.4.2
Subject: Re: [PATCH V6 7/8] PCI: Add "pci=disable_10bit_tag=" parameter for
 peer-to-peer support
X-SA-Exim-Version: 4.2.1 (built Wed, 08 May 2019 21:11:16 +0000)
X-SA-Exim-Scanned: Yes (on ale.deltatee.com)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org




On 2021-07-23 5:32 a.m., Leon Romanovsky wrote:
> On Fri, Jul 23, 2021 at 07:06:41PM +0800, Dongdong Liu wrote:
>> PCIe spec 5.0 r1.0 section 2.2.6.2 says that if an Endpoint supports
>> sending Requests to other Endpoints (as opposed to host memory), the
>> Endpoint must not send 10-Bit Tag Requests to another given Endpoint
>> unless an implementation-specific mechanism determines that the Endpoint
>> supports 10-Bit Tag Completer capability. Add "pci=disable_10bit_tag="
>> parameter to disable 10-Bit Tag Requester if the peer device does not
>> support the 10-Bit Tag Completer. This will make P2P traffic safe.
>>
>> Signed-off-by: Dongdong Liu <liudongdong3@huawei.com>
>> ---
>>  Documentation/admin-guide/kernel-parameters.txt |  7 ++++
>>  drivers/pci/pci.c                               | 56 +++++++++++++++++++++++++
>>  drivers/pci/pci.h                               |  1 +
>>  drivers/pci/pcie/portdrv_pci.c                  | 13 +++---
>>  drivers/pci/probe.c                             |  9 ++--
>>  5 files changed, 78 insertions(+), 8 deletions(-)
>>
>> diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
>> index bdb2200..c2c4585 100644
>> --- a/Documentation/admin-guide/kernel-parameters.txt
>> +++ b/Documentation/admin-guide/kernel-parameters.txt
>> @@ -4019,6 +4019,13 @@
>>  				bridges without forcing it upstream. Note:
>>  				this removes isolation between devices and
>>  				may put more devices in an IOMMU group.
>> +		disable_10bit_tag=<pci_dev>[; ...]
>> +				  Specify one or more PCI devices (in the format
>> +				  specified above) separated by semicolons.
>> +				  Disable 10-Bit Tag Requester if the peer
>> +				  device does not support the 10-Bit Tag
>> +				  Completer.This will make P2P traffic safe.
> 
> I can't imagine more awkward user experience than such kernel parameter.
> 
> As a user, I will need to boot the system, hope for the best that system
> works, write down all PCI device numbers, guess which one doesn't work
> properly, update grub with new command line argument and reboot the
> system. Any HW change and this dance should be repeated.

There are already two such PCI parameters with this pattern and they are
not that awkward. pci_dev may be specified with either vendor/device IDS
or with a path of BDFs (which protects against renumbering).

This flag is only useful in P2PDMA traffic, and if the user attempts
such a transfer, it prints a warning (see the next patch) with the exact
parameter that needs to be added to the command line.

This has worked well for disable_acs_redir and was used for
resource_alignment before that for quite some time. So save a better
suggestion I think this is more than acceptable.

Logan
