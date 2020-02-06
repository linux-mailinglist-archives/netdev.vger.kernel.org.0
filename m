Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 65CD2153D8F
	for <lists+netdev@lfdr.de>; Thu,  6 Feb 2020 04:21:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727804AbgBFDVg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Feb 2020 22:21:36 -0500
Received: from mga09.intel.com ([134.134.136.24]:30365 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727474AbgBFDVg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 5 Feb 2020 22:21:36 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga102.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 05 Feb 2020 19:21:35 -0800
X-IronPort-AV: E=Sophos;i="5.70,408,1574150400"; 
   d="scan'208";a="224871203"
Received: from lingshan-mobl5.ccr.corp.intel.com (HELO [10.249.175.127]) ([10.249.175.127])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-SHA; 05 Feb 2020 19:21:30 -0800
Subject: Re: [PATCH] vhost: introduce vDPA based backend
To:     Jason Wang <jasowang@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Gunthorpe <jgg@mellanox.com>
Cc:     Shahaf Shuler <shahafs@mellanox.com>,
        Tiwei Bie <tiwei.bie@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "rob.miller@broadcom.com" <rob.miller@broadcom.com>,
        "haotian.wang@sifive.com" <haotian.wang@sifive.com>,
        "eperezma@redhat.com" <eperezma@redhat.com>,
        "lulu@redhat.com" <lulu@redhat.com>,
        Parav Pandit <parav@mellanox.com>,
        "rdunlap@infradead.org" <rdunlap@infradead.org>,
        "hch@infradead.org" <hch@infradead.org>,
        Jiri Pirko <jiri@mellanox.com>,
        "hanand@xilinx.com" <hanand@xilinx.com>,
        "mhabets@solarflare.com" <mhabets@solarflare.com>,
        "maxime.coquelin@redhat.com" <maxime.coquelin@redhat.com>,
        "lingshan.zhu@intel.com" <lingshan.zhu@intel.com>,
        "dan.daly@intel.com" <dan.daly@intel.com>,
        "cunming.liang@intel.com" <cunming.liang@intel.com>,
        "zhihong.wang@intel.com" <zhihong.wang@intel.com>
References: <20200131033651.103534-1-tiwei.bie@intel.com>
 <7aab2892-bb19-a06a-a6d3-9c28bc4c3400@redhat.com>
 <20200205020247.GA368700@___>
 <AM0PR0502MB37952015716C1D5E07E390B6C3020@AM0PR0502MB3795.eurprd05.prod.outlook.com>
 <112858a4-1a01-f4d7-e41a-1afaaa1cad45@redhat.com>
 <20200205125648.GV23346@mellanox.com>
 <20200205081210-mutt-send-email-mst@kernel.org>
 <55b050d6-b31d-f8a2-2a15-0fc68896d47f@redhat.com>
From:   Zhu Lingshan <lingshan.zhu@linux.intel.com>
Message-ID: <4b1753eb-b281-17e0-6636-849ac20cbe50@linux.intel.com>
Date:   Thu, 6 Feb 2020 11:21:27 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.2
MIME-Version: 1.0
In-Reply-To: <55b050d6-b31d-f8a2-2a15-0fc68896d47f@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2/6/2020 11:11 AM, Jason Wang wrote:
>
> On 2020/2/5 下午9:14, Michael S. Tsirkin wrote:
>> On Wed, Feb 05, 2020 at 08:56:48AM -0400, Jason Gunthorpe wrote:
>>> On Wed, Feb 05, 2020 at 03:50:14PM +0800, Jason Wang wrote:
>>>>> Would it be better for the map/umnap logic to happen inside each 
>>>>> device ?
>>>>> Devices that needs the IOMMU will call iommu APIs from inside the 
>>>>> driver callback.
>>>> Technically, this can work. But if it can be done by vhost-vpda it 
>>>> will make
>>>> the vDPA driver more compact and easier to be implemented.
>>> Generally speaking, in the kernel, it is normal to not hoist code of
>>> out drivers into subsystems until 2-3 drivers are duplicating that
>>> code. It helps ensure the right design is used
>>>
>>> Jason
>> That's up to the sybsystem maintainer really, as there's also some
>> intuition involved in guessing a specific API is widely useful.
>> In-kernel APIs are flexible, if we find something isn't needed we just
>> drop it.
>>
>
> If I understand correctly. At least Intel (Ling Shan) and Brodcom 
> (Rob) doesn't want to deal with DMA stuffs in their driver.
>
> Anyway since the DMA bus operations is optional, driver may still 
> choose to do DMA by itself if they want even if it requires platform 
> IOMMU to work.
>
> Thanks
>
Many Thanks if this could be done. The parent device has DMA 
capabilities and dma ops implemented, we hope can make use of it, as 
discussed in the vdpa thread.
