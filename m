Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 805423A7498
	for <lists+netdev@lfdr.de>; Tue, 15 Jun 2021 05:03:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229918AbhFODFo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Jun 2021 23:05:44 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:4776 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229609AbhFODFk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Jun 2021 23:05:40 -0400
Received: from dggeme758-chm.china.huawei.com (unknown [172.30.72.53])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4G3tLM0sRMzXfRw;
        Tue, 15 Jun 2021 10:58:35 +0800 (CST)
Received: from [10.67.103.235] (10.67.103.235) by
 dggeme758-chm.china.huawei.com (10.3.19.104) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Tue, 15 Jun 2021 11:03:34 +0800
Subject: Re: [RESEND PATCH V3 1/6] PCI: Use cached Device Capabilities
 Register
To:     Christoph Hellwig <hch@infradead.org>
References: <1623576555-40338-1-git-send-email-liudongdong3@huawei.com>
 <1623576555-40338-2-git-send-email-liudongdong3@huawei.com>
 <YMbsSfQR65TLkbiX@infradead.org>
CC:     <helgaas@kernel.org>, <kw@linux.com>, <linux-pci@vger.kernel.org>,
        <rajur@chelsio.com>, <hverkuil-cisco@xs4all.nl>,
        <linux-media@vger.kernel.org>, <netdev@vger.kernel.org>
From:   Dongdong Liu <liudongdong3@huawei.com>
Message-ID: <93187571-48bf-53d4-05b8-d29075efb792@huawei.com>
Date:   Tue, 15 Jun 2021 11:03:34 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.7.1
MIME-Version: 1.0
In-Reply-To: <YMbsSfQR65TLkbiX@infradead.org>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.67.103.235]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 dggeme758-chm.china.huawei.com (10.3.19.104)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2021/6/14 13:42, Christoph Hellwig wrote:
> On Sun, Jun 13, 2021 at 05:29:10PM +0800, Dongdong Liu wrote:
>> It will make sense to store the pcie_devcap value in the pci_dev
>> structure instead of reading Device Capabilities Register multiple
>> times. The fisrt place to use pcie_devcap is in set_pcie_port_type(),
>> get the pcie_devcap value here, then use cached pcie_devcap in the
>> needed place.
>>
>> Acked-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
>> Signed-off-by: Dongdong Liu <liudongdong3@huawei.com>
>> ---
>>  drivers/media/pci/cobalt/cobalt-driver.c |  4 ++--
>>  drivers/pci/pci.c                        |  5 +----
>>  drivers/pci/pcie/aspm.c                  | 11 ++++-------
>>  drivers/pci/probe.c                      | 11 +++--------
>>  drivers/pci/quirks.c                     |  3 +--
>>  include/linux/pci.h                      |  1 +
>>  6 files changed, 12 insertions(+), 23 deletions(-)
>>
>> diff --git a/drivers/media/pci/cobalt/cobalt-driver.c b/drivers/media/pci/cobalt/cobalt-driver.c
>> index 839503e..04e735f 100644
>> --- a/drivers/media/pci/cobalt/cobalt-driver.c
>> +++ b/drivers/media/pci/cobalt/cobalt-driver.c
>> @@ -193,11 +193,11 @@ void cobalt_pcie_status_show(struct cobalt *cobalt)
>>  		return;
>>
>>  	/* Device */
>> -	pcie_capability_read_dword(pci_dev, PCI_EXP_DEVCAP, &capa);
>>  	pcie_capability_read_word(pci_dev, PCI_EXP_DEVCTL, &ctrl);
>>  	pcie_capability_read_word(pci_dev, PCI_EXP_DEVSTA, &stat);
>>  	cobalt_info("PCIe device capability 0x%08x: Max payload %d\n",
>> -		    capa, get_payload_size(capa & PCI_EXP_DEVCAP_PAYLOAD));
>> +		    capa,
>> +		    get_payload_size(pci_dev->pcie_devcap & PCI_EXP_DEVCAP_PAYLOAD));
>
> Overly long line.
Will fix
>
>> +		if (!(child->pcie_devcap & PCI_EXP_DEVCAP_RBER) && !aspm_force) {
>
> Another one.
Will fix.

Thanks,
Dongdong
>
> Otherwise looks good:
>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> .
>
